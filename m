Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:52082 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751234AbeF3NXj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 30 Jun 2018 09:23:39 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>,
        Golan Ben Ami <golan.ben.ami@intel.com>
Date: Sat, 30 Jun 2018 16:23:17 +0300
Message-Id: <20180630132330.14928-3-luca@coelho.fi> (sfid-20180630_152345_541691_DEA981D7)
In-Reply-To: <20180630132330.14928-1-luca@coelho.fi>
References: <20180630132330.14928-1-luca@coelho.fi>
Subject: [PATCH 02/15] iwlwifi: add support for 22560 devices
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Add support for the new 22560 family of devices and, while at it,
reorganize the 22000 family so it fits better with the new one.

Signed-off-by: Golan Ben Ami <golan.ben.ami@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/cfg/22000.c    | 63 ++++++++++++-------
 .../net/wireless/intel/iwlwifi/iwl-config.h   |  4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h  |  3 +
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c |  2 -
 .../net/wireless/intel/iwlwifi/pcie/trans.c   | 20 ++++--
 5 files changed, 62 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index 6eb0894bd910..aafd8cab86b0 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -73,23 +73,29 @@
 #define IWL_22000_SMEM_OFFSET		0x400000
 #define IWL_22000_SMEM_LEN		0xD0000
 
-#define IWL_22000_JF_FW_PRE	"iwlwifi-Qu-a0-jf-b0-"
-#define IWL_22000_HR_FW_PRE	"iwlwifi-Qu-a0-hr-a0-"
-#define IWL_22000_HR_CDB_FW_PRE	"iwlwifi-QuIcp-z0-hrcdb-a0-"
-#define IWL_22000_HR_F0_FW_PRE	"iwlwifi-QuQnj-f0-hr-a0-"
-#define IWL_22000_JF_B0_FW_PRE	"iwlwifi-QuQnj-a0-jf-b0-"
-#define IWL_22000_HR_A0_FW_PRE	"iwlwifi-QuQnj-a0-hr-a0-"
+#define IWL_22000_JF_FW_PRE		"iwlwifi-Qu-a0-jf-b0-"
+#define IWL_22000_HR_FW_PRE		"iwlwifi-Qu-a0-hr-a0-"
+#define IWL_22000_HR_CDB_FW_PRE		"iwlwifi-QuIcp-z0-hrcdb-a0-"
+#define IWL_22000_HR_A_F0_FW_PRE	"iwlwifi-QuQnj-f0-hr-a0-"
+#define IWL_22000_HR_B_FW_PRE		"iwlwifi-Qu-b0-hr-b0-"
+#define IWL_22000_JF_B0_FW_PRE		"iwlwifi-QuQnj-a0-jf-b0-"
+#define IWL_22000_HR_A0_FW_PRE		"iwlwifi-QuQnj-a0-hr-a0-"
+#define IWL_22000_SU_Z0_FW_PRE		"iwlwifi-su-z0-"
 
 #define IWL_22000_HR_MODULE_FIRMWARE(api) \
 	IWL_22000_HR_FW_PRE __stringify(api) ".ucode"
 #define IWL_22000_JF_MODULE_FIRMWARE(api) \
 	IWL_22000_JF_FW_PRE __stringify(api) ".ucode"
-#define IWL_22000_HR_F0_QNJ_MODULE_FIRMWARE(api) \
-	IWL_22000_HR_F0_FW_PRE __stringify(api) ".ucode"
+#define IWL_22000_HR_A_F0_QNJ_MODULE_FIRMWARE(api) \
+	IWL_22000_HR_A_F0_FW_PRE __stringify(api) ".ucode"
+#define IWL_22000_HR_B_QNJ_MODULE_FIRMWARE(api) \
+	IWL_22000_HR_B_FW_PRE __stringify(api) ".ucode"
 #define IWL_22000_JF_B0_QNJ_MODULE_FIRMWARE(api) \
 	IWL_22000_JF_B0_FW_PRE __stringify(api) ".ucode"
 #define IWL_22000_HR_A0_QNJ_MODULE_FIRMWARE(api) \
 	IWL_22000_HR_A0_FW_PRE __stringify(api) ".ucode"
+#define IWL_22000_SU_Z0_MODULE_FIRMWARE(api) \
+	IWL_22000_SU_Z0_FW_PRE __stringify(api) ".ucode"
 
 #define NVM_HW_SECTION_NUM_FAMILY_22000		10
 
@@ -179,6 +185,16 @@ const struct iwl_cfg iwl22000_2ax_cfg_hr = {
 	.nvm_ver = IWL_22000_NVM_VERSION,
 	.nvm_calib_ver = IWL_22000_TX_POWER_VERSION,
 	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
+};
+
+const struct iwl_cfg iwl22000_2ax_cfg_qnj_hr_a0_f0 = {
+	.name = "Intel(R) Dual Band Wireless AX 22000",
+	.fw_name_pre = IWL_22000_HR_A_F0_FW_PRE,
+	IWL_DEVICE_22000,
+	.ht_params = &iwl_22000_ht_params,
+	.nvm_ver = IWL_22000_NVM_VERSION,
+	.nvm_calib_ver = IWL_22000_TX_POWER_VERSION,
+	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
 	/*
 	 * This device doesn't support receiving BlockAck with a large bitmap
 	 * so we need to restrict the size of transmitted aggregation to the
@@ -187,21 +203,15 @@ const struct iwl_cfg iwl22000_2ax_cfg_hr = {
 	.max_tx_agg_size = IEEE80211_MAX_AMPDU_BUF_HT,
 };
 
-const struct iwl_cfg iwl22000_2ax_cfg_qnj_hr_f0 = {
+const struct iwl_cfg iwl22000_2ax_cfg_qnj_hr_b0 = {
 	.name = "Intel(R) Dual Band Wireless AX 22000",
-	.fw_name_pre = IWL_22000_HR_F0_FW_PRE,
+	.fw_name_pre = IWL_22000_HR_B_FW_PRE,
 	IWL_DEVICE_22000,
 	.csr = &iwl_csr_v1,
 	.ht_params = &iwl_22000_ht_params,
 	.nvm_ver = IWL_22000_NVM_VERSION,
 	.nvm_calib_ver = IWL_22000_TX_POWER_VERSION,
 	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
-	/*
-	 * This device doesn't support receiving BlockAck with a large bitmap
-	 * so we need to restrict the size of transmitted aggregation to the
-	 * HT size; mac80211 would otherwise pick the HE max (256) by default.
-	 */
-	.max_tx_agg_size = IEEE80211_MAX_AMPDU_BUF_HT,
 };
 
 const struct iwl_cfg iwl22000_2ax_cfg_qnj_jf_b0 = {
@@ -213,12 +223,6 @@ const struct iwl_cfg iwl22000_2ax_cfg_qnj_jf_b0 = {
 	.nvm_ver = IWL_22000_NVM_VERSION,
 	.nvm_calib_ver = IWL_22000_TX_POWER_VERSION,
 	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
-	/*
-	 * This device doesn't support receiving BlockAck with a large bitmap
-	 * so we need to restrict the size of transmitted aggregation to the
-	 * HT size; mac80211 would otherwise pick the HE max (256) by default.
-	 */
-	.max_tx_agg_size = IEEE80211_MAX_AMPDU_BUF_HT,
 };
 
 const struct iwl_cfg iwl22000_2ax_cfg_qnj_hr_a0 = {
@@ -230,6 +234,17 @@ const struct iwl_cfg iwl22000_2ax_cfg_qnj_hr_a0 = {
 	.nvm_ver = IWL_22000_NVM_VERSION,
 	.nvm_calib_ver = IWL_22000_TX_POWER_VERSION,
 	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
+};
+
+const struct iwl_cfg iwl22000_2ax_cfg_hr_cdb = {
+	.name = "Intel(R) Dual Band Wireless AX 22560",
+	.fw_name_pre = IWL_22000_SU_Z0_FW_PRE,
+	IWL_DEVICE_22000,
+	.ht_params = &iwl_22000_ht_params,
+	.nvm_ver = IWL_22000_NVM_VERSION,
+	.nvm_calib_ver = IWL_22000_TX_POWER_VERSION,
+	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
+	.cdb = true,
 	/*
 	 * This device doesn't support receiving BlockAck with a large bitmap
 	 * so we need to restrict the size of transmitted aggregation to the
@@ -240,6 +255,8 @@ const struct iwl_cfg iwl22000_2ax_cfg_qnj_hr_a0 = {
 
 MODULE_FIRMWARE(IWL_22000_HR_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_22000_JF_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
-MODULE_FIRMWARE(IWL_22000_HR_F0_QNJ_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL_22000_HR_A_F0_QNJ_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL_22000_HR_B_QNJ_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_22000_JF_B0_QNJ_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_22000_HR_A0_QNJ_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL_22000_SU_Z0_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index c503b26793f6..ede491be7aac 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -566,9 +566,11 @@ extern const struct iwl_cfg iwl22000_2ac_cfg_hr;
 extern const struct iwl_cfg iwl22000_2ac_cfg_hr_cdb;
 extern const struct iwl_cfg iwl22000_2ac_cfg_jf;
 extern const struct iwl_cfg iwl22000_2ax_cfg_hr;
-extern const struct iwl_cfg iwl22000_2ax_cfg_qnj_hr_f0;
+extern const struct iwl_cfg iwl22000_2ax_cfg_qnj_hr_a0_f0;
+extern const struct iwl_cfg iwl22000_2ax_cfg_qnj_hr_b0;
 extern const struct iwl_cfg iwl22000_2ax_cfg_qnj_jf_b0;
 extern const struct iwl_cfg iwl22000_2ax_cfg_qnj_hr_a0;
+extern const struct iwl_cfg iwl22000_2ax_cfg_hr_cdb;
 #endif /* CONFIG_IWLMVM */
 
 #endif /* __IWL_CONFIG_H__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
index ba971d3946e2..3ef71c22bcaa 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
@@ -339,6 +339,9 @@ enum {
 /* HW_RF CHIP ID  */
 #define CSR_HW_RF_ID_TYPE_CHIP_ID(_val) (((_val) >> 12) & 0xFFF)
 
+/* HW_RF CHIP STEP  */
+#define CSR_HW_RF_STEP(_val) (((_val) >> 8) & 0xF)
+
 /* EEPROM REG */
 #define CSR_EEPROM_REG_READ_VALID_MSK	(0x00000001)
 #define CSR_EEPROM_REG_BIT_CMD		(0x00000002)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 38234bda9017..0358b406be81 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -816,8 +816,6 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x2720, 0x1080, iwl22000_2ax_cfg_hr)},
 	{IWL_PCI_DEVICE(0x2720, 0x0090, iwl22000_2ac_cfg_hr_cdb)},
 	{IWL_PCI_DEVICE(0x2720, 0x0310, iwl22000_2ac_cfg_hr_cdb)},
-	{IWL_PCI_DEVICE(0x40C0, 0x0000, iwl22000_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0x40C0, 0x0A10, iwl22000_2ax_cfg_hr)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x0000, iwl22000_2ax_cfg_hr)},
 
 #endif /* CONFIG_IWLMVM */
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 57f5d8f3bdf6..e0398ef07388 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3349,14 +3349,26 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 
 #if IS_ENABLED(CONFIG_IWLMVM)
 	trans->hw_rf_id = iwl_read32(trans, CSR_HW_RF_ID);
-	if (trans->hw_rf_id == CSR_HW_RF_ID_TYPE_HR) {
+
+	if (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
+	    CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_HR)) {
 		u32 hw_status;
 
 		hw_status = iwl_read_prph(trans, UMAG_GEN_HW_STATUS);
-		if (hw_status & UMAG_GEN_HW_IS_FPGA)
-			trans->cfg = &iwl22000_2ax_cfg_qnj_hr_f0;
-		else
+		if (CSR_HW_RF_STEP(trans->hw_rf_id) == SILICON_B_STEP)
+			/*
+			* b step fw is the same for physical card and fpga
+			*/
+			trans->cfg = &iwl22000_2ax_cfg_qnj_hr_b0;
+		else if ((hw_status & UMAG_GEN_HW_IS_FPGA) &&
+			 CSR_HW_RF_STEP(trans->hw_rf_id) == SILICON_A_STEP) {
+			trans->cfg = &iwl22000_2ax_cfg_qnj_hr_a0_f0;
+		} else {
+			/*
+			* a step no FPGA
+			*/
 			trans->cfg = &iwl22000_2ac_cfg_hr;
+		}
 	}
 #endif
 
-- 
2.18.0
