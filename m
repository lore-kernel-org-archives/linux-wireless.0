Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:9419 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420Ab0I2A4y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 20:56:54 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Jay Sternberg <jay.e.sternberg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/5] iwlwifi: define 100 devices
Date: Tue, 28 Sep 2010 17:56:54 -0700
Message-Id: <1285721818-10281-2-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1285721818-10281-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1285721818-10281-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jay Sternberg <jay.e.sternberg@intel.com>

add new structures and defines need to identify 100 devices.

Signed-off-by: Jay Sternberg <jay.e.sternberg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |   73 +++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    6 +++
 drivers/net/wireless/iwlwifi/iwl-agn.h  |    2 +
 3 files changed, 81 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 56ef4ed..19dbef0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -50,14 +50,20 @@
 
 /* Highest firmware API version supported */
 #define IWL1000_UCODE_API_MAX 3
+#define IWL100_UCODE_API_MAX 5
 
 /* Lowest firmware API version supported */
 #define IWL1000_UCODE_API_MIN 1
+#define IWL100_UCODE_API_MIN 5
 
 #define IWL1000_FW_PRE "iwlwifi-1000-"
 #define _IWL1000_MODULE_FIRMWARE(api) IWL1000_FW_PRE #api ".ucode"
 #define IWL1000_MODULE_FIRMWARE(api) _IWL1000_MODULE_FIRMWARE(api)
 
+#define IWL100_FW_PRE "iwlwifi-100-"
+#define _IWL100_MODULE_FIRMWARE(api) IWL100_FW_PRE #api ".ucode"
+#define IWL100_MODULE_FIRMWARE(api) _IWL100_MODULE_FIRMWARE(api)
+
 
 /*
  * For 1000, use advance thermal throttling critical temperature threshold,
@@ -310,4 +316,71 @@ struct iwl_cfg iwl1000_bg_cfg = {
 	.chain_noise_calib_by_driver = true,
 };
 
+struct iwl_cfg iwl100_bgn_cfg = {
+	.name = "Intel(R) 100 Series 1x1 BGN",
+	.fw_name_pre = IWL100_FW_PRE,
+	.ucode_api_max = IWL100_UCODE_API_MAX,
+	.ucode_api_min = IWL100_UCODE_API_MIN,
+	.sku = IWL_SKU_G|IWL_SKU_N,
+	.ops = &iwl1000_ops,
+	.eeprom_size = OTP_LOW_IMAGE_SIZE,
+	.eeprom_ver = EEPROM_1000_EEPROM_VERSION,
+	.eeprom_calib_ver = EEPROM_1000_TX_POWER_VERSION,
+	.num_of_queues = IWLAGN_NUM_QUEUES,
+	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
+	.mod_params = &iwlagn_mod_params,
+	.valid_tx_ant = ANT_A,
+	.valid_rx_ant = ANT_A,
+	.pll_cfg_val = CSR50_ANA_PLL_CFG_VAL,
+	.set_l0s = true,
+	.use_bsm = false,
+	.max_ll_items = OTP_MAX_LL_ITEMS_1000,
+	.shadow_ram_support = false,
+	.ht_greenfield_support = true,
+	.led_compensation = 51,
+	.use_rts_for_aggregation = true, /* use rts/cts protection */
+	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
+	.support_ct_kill_exit = true,
+	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_EXT_LONG_THRESHOLD_DEF,
+	.chain_noise_scale = 1000,
+	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
+	.max_event_log_size = 128,
+	.ucode_tracing = true,
+	.sensitivity_calib_by_driver = true,
+	.chain_noise_calib_by_driver = true,
+};
+
+struct iwl_cfg iwl100_bg_cfg = {
+	.name = "Intel(R) 100 Series 1x1 BG",
+	.fw_name_pre = IWL100_FW_PRE,
+	.ucode_api_max = IWL100_UCODE_API_MAX,
+	.ucode_api_min = IWL100_UCODE_API_MIN,
+	.sku = IWL_SKU_G,
+	.ops = &iwl1000_ops,
+	.eeprom_size = OTP_LOW_IMAGE_SIZE,
+	.eeprom_ver = EEPROM_1000_EEPROM_VERSION,
+	.eeprom_calib_ver = EEPROM_1000_TX_POWER_VERSION,
+	.num_of_queues = IWLAGN_NUM_QUEUES,
+	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
+	.mod_params = &iwlagn_mod_params,
+	.valid_tx_ant = ANT_A,
+	.valid_rx_ant = ANT_A,
+	.pll_cfg_val = CSR50_ANA_PLL_CFG_VAL,
+	.set_l0s = true,
+	.use_bsm = false,
+	.max_ll_items = OTP_MAX_LL_ITEMS_1000,
+	.shadow_ram_support = false,
+	.led_compensation = 51,
+	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
+	.support_ct_kill_exit = true,
+	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_EXT_LONG_THRESHOLD_DEF,
+	.chain_noise_scale = 1000,
+	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
+	.max_event_log_size = 128,
+	.ucode_tracing = true,
+	.sensitivity_calib_by_driver = true,
+	.chain_noise_calib_by_driver = true,
+};
+
 MODULE_FIRMWARE(IWL1000_MODULE_FIRMWARE(IWL1000_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL100_MODULE_FIRMWARE(IWL100_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 646864a..005b07b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -4788,6 +4788,12 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x0083, 0x1326, iwl1000_bg_cfg)},
 	{IWL_PCI_DEVICE(0x0084, 0x1216, iwl1000_bg_cfg)},
 	{IWL_PCI_DEVICE(0x0084, 0x1316, iwl1000_bg_cfg)},
+
+	{IWL_PCI_DEVICE(0x08AE, 0x1005, iwl100_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x08AF, 0x1015, iwl100_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x08AE, 0x1025, iwl100_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x08AE, 0x1007, iwl100_bg_cfg)},
+	{IWL_PCI_DEVICE(0x08AE, 0x1017, iwl100_bg_cfg)},
 #endif /* CONFIG_IWL5000 */
 
 	{0}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index a372184..d5dc824 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -92,6 +92,8 @@ extern struct iwl_cfg iwl6050_2abg_cfg;
 extern struct iwl_cfg iwl6050g2_bgn_cfg;
 extern struct iwl_cfg iwl1000_bgn_cfg;
 extern struct iwl_cfg iwl1000_bg_cfg;
+extern struct iwl_cfg iwl100_bgn_cfg;
+extern struct iwl_cfg iwl100_bg_cfg;
 
 extern struct iwl_mod_params iwlagn_mod_params;
 extern struct iwl_hcmd_ops iwlagn_hcmd;
-- 
1.7.0.4

