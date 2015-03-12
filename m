Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:14617 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754496AbbCLNFo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:05:44 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 15/49] iwlwifi: mvm: support new PHY_SKU nvm section for family 8000 B0
Date: Thu, 12 Mar 2015 15:04:00 +0200
Message-Id: <1426165474-25586-15-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_140548_098471_67B73CA1)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

Starting from family 8000 B0 step the radio_cfg parameters
and the get_sku parameters moved from SW section to PHY_SKU section.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c | 49 +++++++++++++++++++++-------
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.h |  5 +--
 drivers/net/wireless/iwlwifi/mvm/fw-api.h    |  3 +-
 drivers/net/wireless/iwlwifi/mvm/nvm.c       | 20 ++++++++++--
 4 files changed, 60 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index bca4582..d9423ed 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -103,6 +103,11 @@ enum family_8000_nvm_offsets {
 	SKU_FAMILY_8000 = 4,
 	N_HW_ADDRS_FAMILY_8000 = 5,
 
+	/* NVM PHY-SKU-Section offset (in words) for B0 */
+	RADIO_CFG_FAMILY_8000_B0 = 0,
+	SKU_FAMILY_8000_B0 = 2,
+	N_HW_ADDRS_FAMILY_8000_B0 = 3,
+
 	/* NVM REGULATORY -Section offset (in words) definitions */
 	NVM_CHANNELS_FAMILY_8000 = 0,
 	NVM_LAR_OFFSET_FAMILY_8000 = 0x4C7,
@@ -150,6 +155,7 @@ static const u8 iwl_nvm_channels_family_8000[] = {
 #define LAST_2GHZ_HT_PLUS		9
 #define LAST_5GHZ_HT			165
 #define LAST_5GHZ_HT_FAMILY_8000	181
+#define N_HW_ADDR_MASK			0xF
 
 /* rate data (static) */
 static struct ieee80211_rate iwl_cfg80211_rates[] = {
@@ -440,10 +446,15 @@ static void iwl_init_sbands(struct device *dev, const struct iwl_cfg *cfg,
 }
 
 static int iwl_get_sku(const struct iwl_cfg *cfg,
-		       const __le16 *nvm_sw)
+		       const __le16 *nvm_sw, const __le16 *phy_sku,
+		       bool is_family_8000_a_step)
 {
 	if (cfg->device_family != IWL_DEVICE_FAMILY_8000)
 		return le16_to_cpup(nvm_sw + SKU);
+
+	if (!is_family_8000_a_step)
+		return le32_to_cpup((__le32 *)(phy_sku +
+					       SKU_FAMILY_8000_B0));
 	else
 		return le32_to_cpup((__le32 *)(nvm_sw + SKU_FAMILY_8000));
 }
@@ -459,23 +470,36 @@ static int iwl_get_nvm_version(const struct iwl_cfg *cfg,
 }
 
 static int iwl_get_radio_cfg(const struct iwl_cfg *cfg,
-			     const __le16 *nvm_sw)
+			     const __le16 *nvm_sw, const __le16 *phy_sku,
+			     bool is_family_8000_a_step)
 {
 	if (cfg->device_family != IWL_DEVICE_FAMILY_8000)
 		return le16_to_cpup(nvm_sw + RADIO_CFG);
+
+	if (!is_family_8000_a_step)
+		return le32_to_cpup((__le32 *)(phy_sku +
+					       RADIO_CFG_FAMILY_8000_B0));
 	else
 		return le32_to_cpup((__le32 *)(nvm_sw + RADIO_CFG_FAMILY_8000));
+
 }
 
-#define N_HW_ADDRS_MASK_FAMILY_8000	0xF
 static int iwl_get_n_hw_addrs(const struct iwl_cfg *cfg,
-			      const __le16 *nvm_sw)
+			      const __le16 *nvm_sw, bool is_family_8000_a_step)
 {
+	int n_hw_addr;
+
 	if (cfg->device_family != IWL_DEVICE_FAMILY_8000)
 		return le16_to_cpup(nvm_sw + N_HW_ADDRS);
+
+	if (!is_family_8000_a_step)
+		n_hw_addr = le32_to_cpup((__le32 *)(nvm_sw +
+						    N_HW_ADDRS_FAMILY_8000_B0));
 	else
-		return le32_to_cpup((__le32 *)(nvm_sw + N_HW_ADDRS_FAMILY_8000))
-		       & N_HW_ADDRS_MASK_FAMILY_8000;
+		n_hw_addr = le32_to_cpup((__le32 *)(nvm_sw +
+						    N_HW_ADDRS_FAMILY_8000));
+
+	return n_hw_addr & N_HW_ADDR_MASK;
 }
 
 static void iwl_set_radio_cfg(const struct iwl_cfg *cfg,
@@ -598,8 +622,9 @@ struct iwl_nvm_data *
 iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 		   const __le16 *nvm_hw, const __le16 *nvm_sw,
 		   const __le16 *nvm_calib, const __le16 *regulatory,
-		   const __le16 *mac_override, u8 tx_chains, u8 rx_chains,
-		   bool lar_fw_supported)
+		   const __le16 *mac_override, const __le16 *phy_sku,
+		   u8 tx_chains, u8 rx_chains,
+		   bool lar_fw_supported, bool is_family_8000_a_step)
 {
 	struct iwl_nvm_data *data;
 	u32 sku;
@@ -621,14 +646,15 @@ iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 
 	data->nvm_version = iwl_get_nvm_version(cfg, nvm_sw);
 
-	radio_cfg = iwl_get_radio_cfg(cfg, nvm_sw);
+	radio_cfg =
+		iwl_get_radio_cfg(cfg, nvm_sw, phy_sku, is_family_8000_a_step);
 	iwl_set_radio_cfg(cfg, data, radio_cfg);
 	if (data->valid_tx_ant)
 		tx_chains &= data->valid_tx_ant;
 	if (data->valid_rx_ant)
 		rx_chains &= data->valid_rx_ant;
 
-	sku = iwl_get_sku(cfg, nvm_sw);
+	sku = iwl_get_sku(cfg, nvm_sw, phy_sku, is_family_8000_a_step);
 	data->sku_cap_band_24GHz_enable = sku & NVM_SKU_CAP_BAND_24GHZ;
 	data->sku_cap_band_52GHz_enable = sku & NVM_SKU_CAP_BAND_52GHZ;
 	data->sku_cap_11n_enable = sku & NVM_SKU_CAP_11N_ENABLE;
@@ -637,7 +663,8 @@ iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 	data->sku_cap_11ac_enable = data->sku_cap_11n_enable &&
 				    (sku & NVM_SKU_CAP_11AC_ENABLE);
 
-	data->n_hw_addrs = iwl_get_n_hw_addrs(cfg, nvm_sw);
+	data->n_hw_addrs =
+		iwl_get_n_hw_addrs(cfg, nvm_sw, is_family_8000_a_step);
 
 	if (cfg->device_family != IWL_DEVICE_FAMILY_8000) {
 		/* Checking for required sections */
diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.h b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.h
index c950c14..18c3ff2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.h
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.h
@@ -77,8 +77,9 @@ struct iwl_nvm_data *
 iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 		   const __le16 *nvm_hw, const __le16 *nvm_sw,
 		   const __le16 *nvm_calib, const __le16 *regulatory,
-		   const __le16 *mac_override, u8 tx_chains, u8 rx_chains,
-		   bool lar_fw_supported);
+		   const __le16 *mac_override, const __le16 *phy_sku,
+		   u8 tx_chains, u8 rx_chains,
+		   bool lar_fw_supported, bool is_family_8000_a_step);
 
 /**
  * iwl_parse_mcc_info - parse MCC (mobile country code) info coming from FW
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index c4b59ec..f514fae 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -366,7 +366,8 @@ enum {
 	NVM_SECTION_TYPE_CALIBRATION = 4,
 	NVM_SECTION_TYPE_PRODUCTION = 5,
 	NVM_SECTION_TYPE_MAC_OVERRIDE = 11,
-	NVM_MAX_NUM_SECTIONS = 12,
+	NVM_SECTION_TYPE_PHY_SKU = 12,
+	NVM_MAX_NUM_SECTIONS = 13,
 };
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/mvm/nvm.c b/drivers/net/wireless/iwlwifi/mvm/nvm.c
index 1c699c9..eb40c89 100644
--- a/drivers/net/wireless/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/iwlwifi/mvm/nvm.c
@@ -263,7 +263,8 @@ static struct iwl_nvm_data *
 iwl_parse_nvm_sections(struct iwl_mvm *mvm)
 {
 	struct iwl_nvm_section *sections = mvm->nvm_sections;
-	const __le16 *hw, *sw, *calib, *regulatory, *mac_override;
+	const __le16 *hw, *sw, *calib, *regulatory, *mac_override, *phy_sku;
+	bool is_family_8000_a_step = false;
 
 	/* Checking for required sections */
 	if (mvm->trans->cfg->device_family != IWL_DEVICE_FAMILY_8000) {
@@ -287,6 +288,17 @@ iwl_parse_nvm_sections(struct iwl_mvm *mvm)
 				"Can't parse mac_address, empty sections\n");
 			return NULL;
 		}
+
+		if (CSR_HW_REV_STEP(mvm->trans->hw_rev) == SILICON_A_STEP)
+			is_family_8000_a_step = true;
+
+		/* PHY_SKU section is mandatory in B0 */
+		if (!is_family_8000_a_step &&
+		    !mvm->nvm_sections[NVM_SECTION_TYPE_PHY_SKU].data) {
+			IWL_ERR(mvm,
+				"Can't parse phy_sku in B0, empty sections\n");
+			return NULL;
+		}
 	}
 
 	if (WARN_ON(!mvm->cfg))
@@ -298,13 +310,15 @@ iwl_parse_nvm_sections(struct iwl_mvm *mvm)
 	regulatory = (const __le16 *)sections[NVM_SECTION_TYPE_REGULATORY].data;
 	mac_override =
 		(const __le16 *)sections[NVM_SECTION_TYPE_MAC_OVERRIDE].data;
+	phy_sku = (const __le16 *)sections[NVM_SECTION_TYPE_PHY_SKU].data;
 
 	return iwl_parse_nvm_data(mvm->trans->dev, mvm->cfg, hw, sw, calib,
-				  regulatory, mac_override,
+				  regulatory, mac_override, phy_sku,
 				  mvm->fw->valid_tx_ant,
 				  mvm->fw->valid_rx_ant,
 				  mvm->fw->ucode_capa.capa[0] &
-				  IWL_UCODE_TLV_CAPA_LAR_SUPPORT);
+				  IWL_UCODE_TLV_CAPA_LAR_SUPPORT,
+				  is_family_8000_a_step);
 }
 
 #define MAX_NVM_FILE_LEN	16384
-- 
1.9.1

