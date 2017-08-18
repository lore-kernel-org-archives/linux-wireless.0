Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:44602 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751861AbdHRPw3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Aug 2017 11:52:29 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Tzipi Peres <tzipi.peres@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 18 Aug 2017 18:49:14 +0300
Message-Id: <20170818154922.2904-17-luca@coelho.fi> (sfid-20170818_175232_235678_A17F8838)
In-Reply-To: <20170818154922.2904-1-luca@coelho.fi>
References: <20170818154922.2904-1-luca@coelho.fi>
Subject: [PATCH 16/24] iwlwifi: distinguish different RF modules in A000 devices
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tzipi Peres <tzipi.peres@intel.com>

Newer versions of A000 devices come with two diffenent RF modules.
The PCI_ID, the subsystem ID and the RF ID are identical in these two cases,
so we need to differentiate them by using the CSR_HW_RF_ID register-
in order to load the appropriate firmware.

Signed-off-by: Tzipi Peres <tzipi.peres@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/cfg/a000.c   | 34 ++++++++++++++++++++++---
 drivers/net/wireless/intel/iwlwifi/iwl-config.h |  4 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h    |  7 ++++-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c   | 23 ++++++++++++-----
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c |  2 +-
 5 files changed, 58 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/a000.c b/drivers/net/wireless/intel/iwlwifi/cfg/a000.c
index 40d67a5a2635..dcd35b5c9d24 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/a000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/a000.c
@@ -76,13 +76,19 @@
 #define IWL_A000_HR_FW_PRE	"iwlwifi-Qu-a0-hr-a0-"
 #define IWL_A000_HR_CDB_FW_PRE	"iwlwifi-QuIcp-z0-hrcdb-a0-"
 #define IWL_A000_HR_F0_FW_PRE	"iwlwifi-QuQnj-f0-hr-a0-"
+#define IWL_A000_JF_B0_FW_PRE	"iwlwifi-QuQnj-a0-jf-b0-"
+#define IWL_A000_HR_A0_FW_PRE	"iwlwifi-QuQnj-a0-hr-a0-"
 
 #define IWL_A000_HR_MODULE_FIRMWARE(api) \
 	IWL_A000_HR_FW_PRE "-" __stringify(api) ".ucode"
 #define IWL_A000_JF_MODULE_FIRMWARE(api) \
 	IWL_A000_JF_FW_PRE "-" __stringify(api) ".ucode"
-#define IWL_A000_HR_QNJ_MODULE_FIRMWARE(api) \
+#define IWL_A000_HR_F0_QNJ_MODULE_FIRMWARE(api) \
 	IWL_A000_HR_F0_FW_PRE "-" __stringify(api) ".ucode"
+#define IWL_A000_JF_B0_QNJ_MODULE_FIRMWARE(api) \
+	IWL_A000_JF_B0_FW_PRE "-" __stringify(api) ".ucode"
+#define IWL_A000_HR_A0_QNJ_MODULE_FIRMWARE(api) \
+	IWL_A000_HR_A0_FW_PRE "-" __stringify(api) ".ucode"
 
 #define NVM_HW_SECTION_NUM_FAMILY_A000		10
 
@@ -171,7 +177,7 @@ const struct iwl_cfg iwla000_2ax_cfg_hr = {
 		.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
 };
 
-const struct iwl_cfg iwla000_2ax_cfg_qnj_hr = {
+const struct iwl_cfg iwla000_2ax_cfg_qnj_hr_f0 = {
 		.name = "Intel(R) Dual Band Wireless AX a000",
 		.fw_name_pre = IWL_A000_HR_F0_FW_PRE,
 		IWL_DEVICE_A000,
@@ -181,6 +187,28 @@ const struct iwl_cfg iwla000_2ax_cfg_qnj_hr = {
 		.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
 };
 
+const struct iwl_cfg iwla000_2ax_cfg_qnj_jf_b0 = {
+		.name = "Intel(R) Dual Band Wireless AX a000",
+		.fw_name_pre = IWL_A000_JF_B0_FW_PRE,
+		IWL_DEVICE_A000,
+		.ht_params = &iwl_a000_ht_params,
+		.nvm_ver = IWL_A000_NVM_VERSION,
+		.nvm_calib_ver = IWL_A000_TX_POWER_VERSION,
+		.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
+};
+
+const struct iwl_cfg iwla000_2ax_cfg_qnj_hr_a0 = {
+		.name = "Intel(R) Dual Band Wireless AX a000",
+		.fw_name_pre = IWL_A000_HR_A0_FW_PRE,
+		IWL_DEVICE_A000,
+		.ht_params = &iwl_a000_ht_params,
+		.nvm_ver = IWL_A000_NVM_VERSION,
+		.nvm_calib_ver = IWL_A000_TX_POWER_VERSION,
+		.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
+};
+
 MODULE_FIRMWARE(IWL_A000_HR_MODULE_FIRMWARE(IWL_A000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_A000_JF_MODULE_FIRMWARE(IWL_A000_UCODE_API_MAX));
-MODULE_FIRMWARE(IWL_A000_HR_QNJ_MODULE_FIRMWARE(IWL_A000_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL_A000_HR_F0_QNJ_MODULE_FIRMWARE(IWL_A000_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL_A000_JF_B0_QNJ_MODULE_FIRMWARE(IWL_A000_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL_A000_HR_A0_QNJ_MODULE_FIRMWARE(IWL_A000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 573dbeed3fbf..b82a3d0f64b0 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -463,7 +463,9 @@ extern const struct iwl_cfg iwla000_2ac_cfg_hr;
 extern const struct iwl_cfg iwla000_2ac_cfg_hr_cdb;
 extern const struct iwl_cfg iwla000_2ac_cfg_jf;
 extern const struct iwl_cfg iwla000_2ax_cfg_hr;
-extern const struct iwl_cfg iwla000_2ax_cfg_qnj_hr;
+extern const struct iwl_cfg iwla000_2ax_cfg_qnj_hr_f0;
+extern const struct iwl_cfg iwla000_2ax_cfg_qnj_jf_b0;
+extern const struct iwl_cfg iwla000_2ax_cfg_qnj_hr_a0;
 #endif /* CONFIG_IWLMVM */
 
 #endif /* __IWL_CONFIG_H__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
index 7d468ad7cb6a..b03e0f975b5a 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
@@ -354,11 +354,16 @@ enum {
 #define CSR_HW_REV_TYPE_135		(0x0000120)
 #define CSR_HW_REV_TYPE_7265D		(0x0000210)
 #define CSR_HW_REV_TYPE_NONE		(0x00001F0)
+#define CSR_HW_REV_TYPE_QNJ		(0x0000360)
+#define CSR_HW_REV_TYPE_HR_CDB		(0x0000340)
 
 /* RF_ID value */
 #define CSR_HW_RF_ID_TYPE_JF		(0x00105100)
 #define CSR_HW_RF_ID_TYPE_HR		(0x0010A000)
-#define CSR_HW_RF_ID_TYPE_HRCDB		(0x00109000)
+#define CSR_HW_RF_ID_TYPE_HRCDB		(0x00109F00)
+
+/* HW_RF CHIP ID  */
+#define CSR_HW_RF_ID_TYPE_CHIP_ID(_val) (((_val) >> 12) & 0xFFF)
 
 /* EEPROM REG */
 #define CSR_EEPROM_REG_READ_VALID_MSK	(0x00000001)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 87712aeac31f..27d1eec1c899 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -690,12 +690,23 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		iwl_trans->cfg = cfg_7265d;
 	}
 
-	if (iwl_trans->cfg->rf_id && cfg == &iwla000_2ac_cfg_hr_cdb) {
-		if (iwl_trans->hw_rf_id == CSR_HW_RF_ID_TYPE_JF)
-			cfg = &iwla000_2ac_cfg_jf;
-		else if (iwl_trans->hw_rf_id == CSR_HW_RF_ID_TYPE_HR)
-			cfg = &iwla000_2ac_cfg_hr;
-
+	if (iwl_trans->cfg->rf_id && cfg == &iwla000_2ac_cfg_hr_cdb &&
+	    iwl_trans->hw_rev != CSR_HW_REV_TYPE_HR_CDB) {
+		u32 rf_id_chp = CSR_HW_RF_ID_TYPE_CHIP_ID(iwl_trans->hw_rf_id);
+		u32 jf_chp_id = CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_JF);
+		u32 hr_chp_id = CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_HR);
+
+		if (rf_id_chp == jf_chp_id) {
+			if (iwl_trans->hw_rev == CSR_HW_REV_TYPE_QNJ)
+				cfg = &iwla000_2ax_cfg_qnj_jf_b0;
+			else
+				cfg = &iwla000_2ac_cfg_jf;
+		} else if (rf_id_chp == hr_chp_id) {
+			if (iwl_trans->hw_rev == CSR_HW_REV_TYPE_QNJ)
+				cfg = &iwla000_2ax_cfg_qnj_hr_a0;
+			else
+				cfg = &iwla000_2ac_cfg_hr;
+		}
 		iwl_trans->cfg = cfg;
 	}
 #endif
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 3ecafa2ad922..58873cc27396 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3145,7 +3145,7 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 
 		hw_status = iwl_read_prph(trans, UMAG_GEN_HW_STATUS);
 		if (hw_status & UMAG_GEN_HW_IS_FPGA)
-			trans->cfg = &iwla000_2ax_cfg_qnj_hr;
+			trans->cfg = &iwla000_2ax_cfg_qnj_hr_f0;
 		else
 			trans->cfg = &iwla000_2ac_cfg_hr;
 	}
-- 
2.14.1
