require 'ruby-saml'
module DeviseSamlAuthenticatable
  module SamlConfig
    def saml_config(idp_entity_id: nil)
      return file_based_config if file_based_config
      return adapter_based_config(idp_entity_id) if Devise.idp_settings_adapter

      Devise.saml_config
    end

    private

    def file_based_config
      return @file_based_config if @file_based_config
      idp_config_path = "#{Rails.root}/config/idp.yml"

      if File.exists?(idp_config_path)
        @file_based_config ||= OneLogin::RubySaml::Settings.new(YAML.load(File.read(idp_config_path))[Rails.env])
      end
    end

    def adapter_based_config(idp_entity_id)
      OneLogin::RubySaml::Settings.new(Devise.idp_settings_adapter.settings(idp_entity_id))
    end
  end
end
