Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:5080 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837Ab0GITXc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jul 2010 15:23:32 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Shanyu Zhao <shanyu.zhao@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/4] iwlwifi: enable 6050 series Gen2 devices
Date: Fri,  9 Jul 2010 12:24:37 -0700
Message-Id: <1278703480-13363-2-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1278703480-13363-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1278703480-13363-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shanyu Zhao <shanyu.zhao@intel.com>

To enable 6050 series Gen 2 devices:
1) new PCI_IDs are added;
2) new EEPROM version and calibration version numbers defined;
3) new hardware REV number defined;

Signed-off-by: Shanyu Zhao <shanyu.zhao@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c   |   38 +++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c    |    8 ++++++
 drivers/net/wireless/iwlwifi/iwl-agn.h    |    1 +
 drivers/net/wireless/iwlwifi/iwl-csr.h    |    1 +
 drivers/net/wireless/iwlwifi/iwl-eeprom.h |    4 +++
 5 files changed, 52 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 59681c5..0955219 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -829,6 +829,44 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.need_dc_calib = true,
 };
 
+struct iwl_cfg iwl6050g2_bgn_cfg = {
+	.name = "6050 Series 1x2 BGN Gen2",
+	.fw_name_pre = IWL6050_FW_PRE,
+	.ucode_api_max = IWL6050_UCODE_API_MAX,
+	.ucode_api_min = IWL6050_UCODE_API_MIN,
+	.sku = IWL_SKU_G|IWL_SKU_N,
+	.ops = &iwl6000_ops,
+	.eeprom_size = OTP_LOW_IMAGE_SIZE,
+	.eeprom_ver = EEPROM_6050G2_EEPROM_VERSION,
+	.eeprom_calib_ver = EEPROM_6050G2_TX_POWER_VERSION,
+	.num_of_queues = IWLAGN_NUM_QUEUES,
+	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
+	.mod_params = &iwlagn_mod_params,
+	.valid_tx_ant = ANT_A,
+	.valid_rx_ant = ANT_AB,
+	.pll_cfg_val = 0,
+	.set_l0s = true,
+	.use_bsm = false,
+	.pa_type = IWL_PA_SYSTEM,
+	.max_ll_items = OTP_MAX_LL_ITEMS_6x50,
+	.shadow_ram_support = true,
+	.ht_greenfield_support = true,
+	.led_compensation = 51,
+	.use_rts_for_ht = true, /* use rts/cts protection */
+	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
+	.supports_idle = true,
+	.adv_thermal_throttle = true,
+	.support_ct_kill_exit = true,
+	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
+	.chain_noise_scale = 1500,
+	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.max_event_log_size = 1024,
+	.ucode_tracing = true,
+	.sensitivity_calib_by_driver = true,
+	.chain_noise_calib_by_driver = true,
+	.need_dc_calib = true,
+};
+
 struct iwl_cfg iwl6050_2abg_cfg = {
 	.name = "Intel(R) Centrino(R) Advanced-N + WiMAX 6250 ABG",
 	.fw_name_pre = IWL6050_FW_PRE,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 66c83b2..b5d1939 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -4323,6 +4323,14 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x0089, 0x1311, iwl6050_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x0089, 0x1316, iwl6050_2abg_cfg)},
 
+/* 6x50 WiFi/WiMax Series Gen2 */
+	{IWL_PCI_DEVICE(0x0885, 0x1305, iwl6050g2_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0885, 0x1306, iwl6050g2_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0885, 0x1325, iwl6050g2_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0885, 0x1326, iwl6050g2_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0886, 0x1315, iwl6050g2_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0886, 0x1316, iwl6050g2_bgn_cfg)},
+
 /* 1000 Series WiFi */
 	{IWL_PCI_DEVICE(0x0083, 0x1205, iwl1000_bgn_cfg)},
 	{IWL_PCI_DEVICE(0x0083, 0x1305, iwl1000_bgn_cfg)},
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 5c46b2c..cc6464d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -89,6 +89,7 @@ extern struct iwl_cfg iwl6000i_2bg_cfg;
 extern struct iwl_cfg iwl6000_3agn_cfg;
 extern struct iwl_cfg iwl6050_2agn_cfg;
 extern struct iwl_cfg iwl6050_2abg_cfg;
+extern struct iwl_cfg iwl6050g2_bgn_cfg;
 extern struct iwl_cfg iwl1000_bgn_cfg;
 extern struct iwl_cfg iwl1000_bg_cfg;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index 254c35a..ecf98e7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -298,6 +298,7 @@
 #define CSR_HW_REV_TYPE_1000           (0x0000060)
 #define CSR_HW_REV_TYPE_6x00           (0x0000070)
 #define CSR_HW_REV_TYPE_6x50           (0x0000080)
+#define CSR_HW_REV_TYPE_6x50g2         (0x0000084)
 #define CSR_HW_REV_TYPE_6x00g2         (0x00000B0)
 #define CSR_HW_REV_TYPE_NONE           (0x00000F0)
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 95aa202..f8b707d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -276,6 +276,10 @@ struct iwl_eeprom_enhanced_txpwr {
 #define EEPROM_6050_TX_POWER_VERSION    (4)
 #define EEPROM_6050_EEPROM_VERSION	(0x532)
 
+/* 6x50g2 Specific */
+#define EEPROM_6050G2_TX_POWER_VERSION    (6)
+#define EEPROM_6050G2_EEPROM_VERSION	(0x553)
+
 /* 6x00g2 Specific */
 #define EEPROM_6000G2_TX_POWER_VERSION    (6)
 #define EEPROM_6000G2_EEPROM_VERSION	(0x709)
-- 
1.7.0.4

