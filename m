Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:14617 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754508AbbCLNFp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:05:45 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 16/49] iwlwifi: allow disabling LAR via module param
Date: Thu, 12 Mar 2015 15:04:01 +0200
Message-Id: <1426165474-25586-16-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_140550_299254_9327746A)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arikx.nemtsov@intel.com>

This module parameter is useful for debugging NVM and LAR related issues.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c       |  4 ++++
 drivers/net/wireless/iwlwifi/iwl-modparams.h |  2 ++
 drivers/net/wireless/iwlwifi/mvm/mvm.h       |  4 ++++
 drivers/net/wireless/iwlwifi/mvm/nvm.c       | 13 +++++++------
 4 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 141331d..f1d73d5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -1546,6 +1546,10 @@ module_param_named(d0i3_disable, iwlwifi_mod_params.d0i3_disable,
 		   bool, S_IRUGO);
 MODULE_PARM_DESC(d0i3_disable, "disable d0i3 functionality (default: Y)");
 
+module_param_named(lar_disable, iwlwifi_mod_params.lar_disable,
+		   bool, S_IRUGO);
+MODULE_PARM_DESC(lar_disable, "disable LAR functionality (default: N)");
+
 module_param_named(uapsd_disable, iwlwifi_mod_params.uapsd_disable,
 		   bool, S_IRUGO | S_IWUSR);
 #ifdef CONFIG_IWLWIFI_UAPSD
diff --git a/drivers/net/wireless/iwlwifi/iwl-modparams.h b/drivers/net/wireless/iwlwifi/iwl-modparams.h
index e8eabd2..ac2b90d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-modparams.h
+++ b/drivers/net/wireless/iwlwifi/iwl-modparams.h
@@ -103,6 +103,7 @@ enum iwl_disable_11n {
  * @debug_level: levels are IWL_DL_*
  * @ant_coupling: antenna coupling in dB, default = 0
  * @d0i3_disable: disable d0i3, default = 1,
+ * @lar_disable: disable LAR (regulatory), default = 0
  * @fw_monitor: allow to use firmware monitor
  */
 struct iwl_mod_params {
@@ -121,6 +122,7 @@ struct iwl_mod_params {
 	char *nvm_file;
 	bool uapsd_disable;
 	bool d0i3_disable;
+	bool lar_disable;
 	bool fw_monitor;
 };
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index a196c78..207c3a8 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -917,6 +917,10 @@ static inline bool iwl_mvm_is_lar_supported(struct iwl_mvm *mvm)
 	bool nvm_lar = mvm->nvm_data->lar_enabled;
 	bool tlv_lar = mvm->fw->ucode_capa.capa[0] &
 		IWL_UCODE_TLV_CAPA_LAR_SUPPORT;
+
+	if (iwlwifi_mod_params.lar_disable)
+		return false;
+
 	/*
 	 * Enable LAR only if it is supported by the FW (TLV) &&
 	 * enabled in the NVM
diff --git a/drivers/net/wireless/iwlwifi/mvm/nvm.c b/drivers/net/wireless/iwlwifi/mvm/nvm.c
index eb40c89..5a16e0d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/iwlwifi/mvm/nvm.c
@@ -264,7 +264,7 @@ iwl_parse_nvm_sections(struct iwl_mvm *mvm)
 {
 	struct iwl_nvm_section *sections = mvm->nvm_sections;
 	const __le16 *hw, *sw, *calib, *regulatory, *mac_override, *phy_sku;
-	bool is_family_8000_a_step = false;
+	bool is_family_8000_a_step = false, lar_enabled;
 
 	/* Checking for required sections */
 	if (mvm->trans->cfg->device_family != IWL_DEVICE_FAMILY_8000) {
@@ -312,13 +312,14 @@ iwl_parse_nvm_sections(struct iwl_mvm *mvm)
 		(const __le16 *)sections[NVM_SECTION_TYPE_MAC_OVERRIDE].data;
 	phy_sku = (const __le16 *)sections[NVM_SECTION_TYPE_PHY_SKU].data;
 
+	lar_enabled = !iwlwifi_mod_params.lar_disable &&
+		      (mvm->fw->ucode_capa.capa[0] &
+		       IWL_UCODE_TLV_CAPA_LAR_SUPPORT);
+
 	return iwl_parse_nvm_data(mvm->trans->dev, mvm->cfg, hw, sw, calib,
 				  regulatory, mac_override, phy_sku,
-				  mvm->fw->valid_tx_ant,
-				  mvm->fw->valid_rx_ant,
-				  mvm->fw->ucode_capa.capa[0] &
-				  IWL_UCODE_TLV_CAPA_LAR_SUPPORT,
-				  is_family_8000_a_step);
+				  mvm->fw->valid_tx_ant, mvm->fw->valid_rx_ant,
+				  lar_enabled, is_family_8000_a_step);
 }
 
 #define MAX_NVM_FILE_LEN	16384
-- 
1.9.1

