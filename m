Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:14617 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754475AbbCLNFl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:05:41 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Matti Gottlieb <matti.gottlieb@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 13/49] iwlwifi: iwlmvm: LAR: disable LAR support due to NVM vs TLV conflict
Date: Thu, 12 Mar 2015 15:03:58 +0200
Message-Id: <1426165474-25586-13-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_140543_698465_A16026E2)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Matti Gottlieb <matti.gottlieb@intel.com>

If LAR is supported in TLV, but the NVM does not enable it, then disable
LAR support and ignore the TLV's bit that enabled LAR.

Signed-off-by: Matti Gottlieb <matti.gottlieb@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h |  1 +
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c    | 15 ++++++++++++---
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.h    |  2 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h          | 12 +++++++++++-
 drivers/net/wireless/iwlwifi/mvm/nvm.c          | 17 ++++++++++++++++-
 5 files changed, 41 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h b/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h
index f0548b8..5234a0b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h
@@ -94,6 +94,7 @@ struct iwl_nvm_data {
 	u32 nvm_version;
 	s8 max_tx_pwr_half_dbm;
 
+	bool lar_enabled;
 	struct ieee80211_supported_band bands[IEEE80211_NUM_BANDS];
 	struct ieee80211_channel channels[];
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index 83ba307f..88ee84c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -105,6 +105,8 @@ enum family_8000_nvm_offsets {
 
 	/* NVM REGULATORY -Section offset (in words) definitions */
 	NVM_CHANNELS_FAMILY_8000 = 0,
+	NVM_LAR_OFFSET_FAMILY_8000 = 0x4C7,
+	NVM_LAR_ENABLED_FAMILY_8000 = 0x7,
 
 	/* NVM calibration section offset (in words) definitions */
 	NVM_CALIB_SECTION_FAMILY_8000 = 0x2B8,
@@ -597,11 +599,12 @@ iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 		   const __le16 *nvm_hw, const __le16 *nvm_sw,
 		   const __le16 *nvm_calib, const __le16 *regulatory,
 		   const __le16 *mac_override, u8 tx_chains, u8 rx_chains,
-		   bool lar_supported)
+		   bool lar_fw_supported)
 {
 	struct iwl_nvm_data *data;
 	u32 sku;
 	u32 radio_cfg;
+	u16 lar_config;
 
 	if (cfg->device_family != IWL_DEVICE_FAMILY_8000)
 		data = kzalloc(sizeof(*data) +
@@ -653,15 +656,21 @@ iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 
 		iwl_init_sbands(dev, cfg, data, nvm_sw,
 				sku & NVM_SKU_CAP_11AC_ENABLE, tx_chains,
-				rx_chains, lar_supported);
+				rx_chains, lar_fw_supported);
 	} else {
+		lar_config = le16_to_cpup(regulatory +
+					  NVM_LAR_OFFSET_FAMILY_8000);
+		data->lar_enabled = !!(lar_config &
+				       NVM_LAR_ENABLED_FAMILY_8000);
+
 		/* MAC address in family 8000 */
 		iwl_set_hw_address_family_8000(dev, cfg, data, mac_override,
 					       nvm_hw);
 
 		iwl_init_sbands(dev, cfg, data, regulatory,
 				sku & NVM_SKU_CAP_11AC_ENABLE, tx_chains,
-				rx_chains, lar_supported);
+				rx_chains, lar_fw_supported &&
+				data->lar_enabled);
 	}
 
 	data->calib_version = 255;
diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.h b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.h
index 1b3990d..c950c14 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.h
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.h
@@ -78,7 +78,7 @@ iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 		   const __le16 *nvm_hw, const __le16 *nvm_sw,
 		   const __le16 *nvm_calib, const __le16 *regulatory,
 		   const __le16 *mac_override, u8 tx_chains, u8 rx_chains,
-		   bool lar_supported);
+		   bool lar_fw_supported);
 
 /**
  * iwl_parse_mcc_info - parse MCC (mobile country code) info coming from FW
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index df5a228..a196c78 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -914,7 +914,17 @@ static inline bool iwl_mvm_is_d0i3_supported(struct iwl_mvm *mvm)
 
 static inline bool iwl_mvm_is_lar_supported(struct iwl_mvm *mvm)
 {
-	return mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_LAR_SUPPORT;
+	bool nvm_lar = mvm->nvm_data->lar_enabled;
+	bool tlv_lar = mvm->fw->ucode_capa.capa[0] &
+		IWL_UCODE_TLV_CAPA_LAR_SUPPORT;
+	/*
+	 * Enable LAR only if it is supported by the FW (TLV) &&
+	 * enabled in the NVM
+	 */
+	if (mvm->cfg->device_family == IWL_DEVICE_FAMILY_8000)
+		return nvm_lar && tlv_lar;
+	else
+		return tlv_lar;
 }
 
 static inline bool iwl_mvm_is_scd_cfg_supported(struct iwl_mvm *mvm)
diff --git a/drivers/net/wireless/iwlwifi/mvm/nvm.c b/drivers/net/wireless/iwlwifi/mvm/nvm.c
index b88b4cd..1c699c9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/iwlwifi/mvm/nvm.c
@@ -303,7 +303,8 @@ iwl_parse_nvm_sections(struct iwl_mvm *mvm)
 				  regulatory, mac_override,
 				  mvm->fw->valid_tx_ant,
 				  mvm->fw->valid_rx_ant,
-				  iwl_mvm_is_lar_supported(mvm));
+				  mvm->fw->ucode_capa.capa[0] &
+				  IWL_UCODE_TLV_CAPA_LAR_SUPPORT);
 }
 
 #define MAX_NVM_FILE_LEN	16384
@@ -659,6 +660,20 @@ exit:
 
 int iwl_mvm_init_mcc(struct iwl_mvm *mvm)
 {
+	bool tlv_lar;
+	bool nvm_lar;
+
+	if (mvm->cfg->device_family == IWL_DEVICE_FAMILY_8000) {
+		tlv_lar = mvm->fw->ucode_capa.capa[0] &
+			IWL_UCODE_TLV_CAPA_LAR_SUPPORT;
+		nvm_lar = mvm->nvm_data->lar_enabled;
+		if (tlv_lar != nvm_lar)
+			IWL_INFO(mvm,
+				 "Conflict between TLV & NVM regarding enabling LAR (TLV = %s NVM =%s)\n",
+				 tlv_lar ? "enabled" : "disabled",
+				 nvm_lar ? "enabled" : "disabled");
+	}
+
 	if (!iwl_mvm_is_lar_supported(mvm))
 		return 0;
 
-- 
1.9.1

