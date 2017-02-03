Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:38056 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753359AbdBCOlM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Feb 2017 09:41:12 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  3 Feb 2017 16:38:10 +0200
Message-Id: <20170203143812.7525-24-luca@coelho.fi> (sfid-20170203_154125_204023_8B38CB50)
In-Reply-To: <20170203143812.7525-1-luca@coelho.fi>
References: <20170203143812.7525-1-luca@coelho.fi>
Subject: [PATCH 23/25] iwlwifi: support two phys for a000 devices
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Support differentiating between two phys for a000 devices
in order to load the correct firmware.
Eventually when moving completely to the new phy we will be
able to remove this.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-a000.c   | 30 +++++++++++++++++++------
 drivers/net/wireless/intel/iwlwifi/iwl-config.h |  3 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h    |  1 +
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c   |  8 ++++++-
 4 files changed, 33 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-a000.c b/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
index 82f18d967c40..15dd7f6137c8 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
@@ -72,9 +72,13 @@
 #define IWL_A000_SMEM_OFFSET		0x400000
 #define IWL_A000_SMEM_LEN		0x68000
 
-#define IWL_A000_FW_PRE "iwlwifi-Qu-a0-jf-b0-"
-#define IWL_A000_MODULE_FIRMWARE(api) \
-	IWL_A000_FW_PRE "-" __stringify(api) ".ucode"
+#define IWL_A000_JF_FW_PRE "iwlwifi-Qu-a0-jf-b0-"
+#define IWL_A000_HR_FW_PRE "iwlwifi-Qu-a0-hr-a0-"
+
+#define IWL_A000_HR_MODULE_FIRMWARE(api) \
+	IWL_A000_HR_FW_PRE "-" __stringify(api) ".ucode"
+#define IWL_A000_JF_MODULE_FIRMWARE(api) \
+	IWL_A000_JF_FW_PRE "-" __stringify(api) ".ucode"
 
 #define NVM_HW_SECTION_NUM_FAMILY_A000		10
 
@@ -116,11 +120,22 @@ static const struct iwl_ht_params iwl_a000_ht_params = {
 	.mq_rx_supported = true,					\
 	.vht_mu_mimo_supported = true,					\
 	.mac_addr_from_csr = true,					\
-	.use_tfh = true
+	.use_tfh = true,						\
+	.rf_id = true
+
+const struct iwl_cfg iwla000_2ac_cfg_hr = {
+		.name = "Intel(R) Dual Band Wireless AC a000",
+		.fw_name_pre = IWL_A000_HR_FW_PRE,
+		IWL_DEVICE_A000,
+		.ht_params = &iwl_a000_ht_params,
+		.nvm_ver = IWL_A000_NVM_VERSION,
+		.nvm_calib_ver = IWL_A000_TX_POWER_VERSION,
+		.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
+};
 
-const struct iwl_cfg iwla000_2ac_cfg = {
+const struct iwl_cfg iwla000_2ac_cfg_jf = {
 		.name = "Intel(R) Dual Band Wireless AC a000",
-		.fw_name_pre = IWL_A000_FW_PRE,
+		.fw_name_pre = IWL_A000_JF_FW_PRE,
 		IWL_DEVICE_A000,
 		.ht_params = &iwl_a000_ht_params,
 		.nvm_ver = IWL_A000_NVM_VERSION,
@@ -128,4 +143,5 @@ const struct iwl_cfg iwla000_2ac_cfg = {
 		.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
 };
 
-MODULE_FIRMWARE(IWL_A000_MODULE_FIRMWARE(IWL_A000_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL_A000_HR_MODULE_FIRMWARE(IWL_A000_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL_A000_JF_MODULE_FIRMWARE(IWL_A000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 2660cc4b9f8c..94f8a51b633e 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -455,7 +455,8 @@ extern const struct iwl_cfg iwl9260_2ac_cfg;
 extern const struct iwl_cfg iwl9270_2ac_cfg;
 extern const struct iwl_cfg iwl9460_2ac_cfg;
 extern const struct iwl_cfg iwl9560_2ac_cfg;
-extern const struct iwl_cfg iwla000_2ac_cfg;
+extern const struct iwl_cfg iwla000_2ac_cfg_hr;
+extern const struct iwl_cfg iwla000_2ac_cfg_jf;
 #endif /* CONFIG_IWLMVM */
 
 #endif /* __IWL_CONFIG_H__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
index d73e9d436027..4ee3b621ec27 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
@@ -349,6 +349,7 @@ enum {
 /* RF_ID value */
 #define CSR_HW_RF_ID_TYPE_JF		(0x00105000)
 #define CSR_HW_RF_ID_TYPE_LC		(0x00101000)
+#define CSR_HW_RF_ID_TYPE_HR		(0x00109000)
 
 /* EEPROM REG */
 #define CSR_EEPROM_REG_READ_VALID_MSK	(0x00000001)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 43c2475346ac..618894ecfd22 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -533,7 +533,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0xA370, 0x1030, iwl9560_2ac_cfg)},
 
 /* a000 Series */
-	{IWL_PCI_DEVICE(0x2720, 0x0A10, iwla000_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2720, 0x0A10, iwla000_2ac_cfg_hr)},
 #endif /* CONFIG_IWLMVM */
 
 	{0}
@@ -673,6 +673,12 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			cfg = &iwl9000lc_2ac_cfg;
 			iwl_trans->cfg = cfg;
 		}
+
+		if (cfg == &iwla000_2ac_cfg_hr &&
+		    iwl_trans->hw_rf_id == CSR_HW_RF_ID_TYPE_JF) {
+			cfg = &iwla000_2ac_cfg_jf;
+			iwl_trans->cfg = cfg;
+		}
 	}
 #endif
 
-- 
2.11.0
