Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41188 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1758275AbcH3Ljf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Aug 2016 07:39:35 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Oren Givon <oren.givon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 30 Aug 2016 14:38:55 +0300
Message-Id: <1472557142-14782-9-git-send-email-luca@coelho.fi> (sfid-20160830_133949_745833_AFE4675D)
In-Reply-To: <1472557142-14782-1-git-send-email-luca@coelho.fi>
References: <1472556999.27868.86.camel@coelho.fi>
 <1472557142-14782-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 09/16] iwlwifi: rename and reorder 9000 series configuration structs
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Oren Givon <oren.givon@intel.com>

Rename and reorder the 9000 series configuration structs:
- struct containing configuration of 5165 was renamed to 9000.

Signed-off-by: Oren Givon <oren.givon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-9000.c   | 63 +++++++++++++------------
 drivers/net/wireless/intel/iwlwifi/iwl-config.h |  4 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c   | 34 +++++++------
 3 files changed, 50 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
index fbaf705..b8356a8 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
@@ -72,15 +72,15 @@
 #define IWL9000_SMEM_OFFSET		0x400000
 #define IWL9000_SMEM_LEN		0x68000
 
-#define  IWL9000_FW_PRE "iwlwifi-9000-pu-a0-lc-a0-"
+#define  IWL9000_FW_PRE "iwlwifi-9000-pu-a0-jf-a0-"
 #define  IWL9260_FW_PRE "iwlwifi-9260-th-a0-jf-a0-"
-#define  IWL9260LC_FW_PRE "iwlwifi-9260-th-a0-lc-a0-"
+#define  IWL9000LC_FW_PRE "iwlwifi-9000-pu-a0-lc-a0-"
 #define IWL9000_MODULE_FIRMWARE(api) \
 	IWL9000_FW_PRE "-" __stringify(api) ".ucode"
 #define IWL9260_MODULE_FIRMWARE(api) \
 	IWL9260_FW_PRE "-" __stringify(api) ".ucode"
-#define IWL9260LC_MODULE_FIRMWARE(api) \
-	IWL9260LC_FW_PRE "-" __stringify(api) ".ucode"
+#define IWL9000LC_MODULE_FIRMWARE(api) \
+	IWL9000LC_FW_PRE "-" __stringify(api) ".ucode"
 
 #define NVM_HW_SECTION_NUM_FAMILY_9000		10
 
@@ -147,40 +147,41 @@ static const struct iwl_tt_params iwl9000_tt_params = {
 	.rf_id = true
 
 const struct iwl_cfg iwl9260_2ac_cfg = {
-		.name = "Intel(R) Dual Band Wireless AC 9260",
-		.fw_name_pre = IWL9260_FW_PRE,
-		IWL_DEVICE_9000,
-		.ht_params = &iwl9000_ht_params,
-		.nvm_ver = IWL9000_NVM_VERSION,
-		.nvm_calib_ver = IWL9000_TX_POWER_VERSION,
-		.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
+	.name = "Intel(R) Dual Band Wireless AC 9260",
+	.fw_name_pre = IWL9260_FW_PRE,
+	IWL_DEVICE_9000,
+	.ht_params = &iwl9000_ht_params,
+	.nvm_ver = IWL9000_NVM_VERSION,
+	.nvm_calib_ver = IWL9000_TX_POWER_VERSION,
+	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
+};
+
+const struct iwl_cfg iwl9000_2ac_cfg = {
+	.name = "Intel(R) Dual Band Wireless AC 9000",
+	.fw_name_pre = IWL9000_FW_PRE,
+	IWL_DEVICE_9000,
+	.ht_params = &iwl9000_ht_params,
+	.nvm_ver = IWL9000_NVM_VERSION,
+	.nvm_calib_ver = IWL9000_TX_POWER_VERSION,
+	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
+	.integrated = true,
 };
 
 /*
  * TODO the struct below is for internal testing only this should be
  * removed by EO 2016~
  */
-const struct iwl_cfg iwl9260lc_2ac_cfg = {
-		.name = "Intel(R) Dual Band Wireless AC 9260",
-		.fw_name_pre = IWL9260LC_FW_PRE,
-		IWL_DEVICE_9000,
-		.ht_params = &iwl9000_ht_params,
-		.nvm_ver = IWL9000_NVM_VERSION,
-		.nvm_calib_ver = IWL9000_TX_POWER_VERSION,
-		.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
-};
-
-const struct iwl_cfg iwl5165_2ac_cfg = {
-		.name = "Intel(R) Dual Band Wireless AC 5165",
-		.fw_name_pre = IWL9000_FW_PRE,
-		IWL_DEVICE_9000,
-		.ht_params = &iwl9000_ht_params,
-		.nvm_ver = IWL9000_NVM_VERSION,
-		.nvm_calib_ver = IWL9000_TX_POWER_VERSION,
-		.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
-		.integrated = true,
+const struct iwl_cfg iwl9000lc_2ac_cfg = {
+	.name = "Intel(R) Dual Band Wireless AC 9000",
+	.fw_name_pre = IWL9000LC_FW_PRE,
+	IWL_DEVICE_9000,
+	.ht_params = &iwl9000_ht_params,
+	.nvm_ver = IWL9000_NVM_VERSION,
+	.nvm_calib_ver = IWL9000_TX_POWER_VERSION,
+	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
+	.integrated = true,
 };
 
 MODULE_FIRMWARE(IWL9000_MODULE_FIRMWARE(IWL9000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL9260_MODULE_FIRMWARE(IWL9000_UCODE_API_MAX));
-MODULE_FIRMWARE(IWL9260LC_MODULE_FIRMWARE(IWL9000_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL9000LC_MODULE_FIRMWARE(IWL9000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 423b233..04260fc 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -449,9 +449,9 @@ extern const struct iwl_cfg iwl4165_2ac_cfg;
 extern const struct iwl_cfg iwl8260_2ac_sdio_cfg;
 extern const struct iwl_cfg iwl8265_2ac_sdio_cfg;
 extern const struct iwl_cfg iwl4165_2ac_sdio_cfg;
+extern const struct iwl_cfg iwl9000_2ac_cfg;
+extern const struct iwl_cfg iwl9000lc_2ac_cfg;
 extern const struct iwl_cfg iwl9260_2ac_cfg;
-extern const struct iwl_cfg iwl9260lc_2ac_cfg;
-extern const struct iwl_cfg iwl5165_2ac_cfg;
 extern const struct iwl_cfg iwla000_2ac_cfg;
 #endif /* CONFIG_IWLMVM */
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 78cf9a7..bf523f5 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -504,18 +504,18 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 /* 9000 Series */
 	{IWL_PCI_DEVICE(0x2526, 0x0000, iwl9260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x0010, iwl9260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0A10, iwl9260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0010, iwl9260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0210, iwl9260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0410, iwl9260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0610, iwl9260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0310, iwl5165_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0000, iwl5165_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0510, iwl5165_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x2010, iwl5165_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2526, 0x1420, iwl5165_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0710, iwl5165_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x2A10, iwl5165_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0A10, iwl9000_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0010, iwl9000_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0210, iwl9000_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0410, iwl9000_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0610, iwl9000_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0310, iwl9000_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0000, iwl9000_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0510, iwl9000_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x2010, iwl9000_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x1420, iwl9000_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0710, iwl9000_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x2A10, iwl9000_2ac_cfg)},
 
 /* a000 Series */
 	{IWL_PCI_DEVICE(0x2720, 0x0A10, iwla000_2ac_cfg)},
@@ -608,7 +608,6 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	const struct iwl_cfg *cfg = (struct iwl_cfg *)(ent->driver_data);
 	const struct iwl_cfg *cfg_7265d __maybe_unused = NULL;
-	const struct iwl_cfg *cfg_9260lc __maybe_unused = NULL;
 	struct iwl_trans *iwl_trans;
 	int ret;
 
@@ -637,11 +636,10 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	if (iwl_trans->cfg->rf_id) {
-		if (cfg == &iwl9260_2ac_cfg)
-			cfg_9260lc = &iwl9260lc_2ac_cfg;
-		if (cfg_9260lc && iwl_trans->hw_rf_id == CSR_HW_RF_ID_TYPE_LC) {
-			cfg = cfg_9260lc;
-			iwl_trans->cfg = cfg_9260lc;
+		if (cfg == &iwl9000_2ac_cfg &&
+		    iwl_trans->hw_rf_id == CSR_HW_RF_ID_TYPE_LC) {
+			cfg = &iwl9000lc_2ac_cfg;
+			iwl_trans->cfg = cfg;
 		}
 	}
 #endif
-- 
2.8.1
