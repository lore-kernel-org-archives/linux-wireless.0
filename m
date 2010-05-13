Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:60714 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932560Ab0EMVuW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 17:50:22 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Shanyu Zhao <shanyu.zhao@intel.com>,
	Jay Sternberg <jay.e.sternberg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 11/17] iwlwifi: enable remaining 6000 Gen2 devices
Date: Thu, 13 May 2010 14:49:53 -0700
Message-Id: <1273787399-9280-12-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273787399-9280-1-git-send-email-reinette.chatre@intel.com>
References: <1273787399-9280-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shanyu Zhao <shanyu.zhao@intel.com>

This patch enables all remaining 6000 series Gen2 devices.
To work-around a firmware crash problem, we disable sending
bt coex command for 6000g2b series devices.

Signed-off-by: Jay Sternberg <jay.e.sternberg@intel.com>
Signed-off-by: Shanyu Zhao <shanyu.zhao@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c     |  252 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   17 ++
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    4 +
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    7 +
 5 files changed, 282 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 9fbf54c..9247594 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -71,6 +71,10 @@
 #define _IWL6000G2A_MODULE_FIRMWARE(api) IWL6000G2A_FW_PRE #api ".ucode"
 #define IWL6000G2A_MODULE_FIRMWARE(api) _IWL6000G2A_MODULE_FIRMWARE(api)
 
+#define IWL6000G2B_FW_PRE "iwlwifi-6000g2b-"
+#define _IWL6000G2B_MODULE_FIRMWARE(api) IWL6000G2B_FW_PRE #api ".ucode"
+#define IWL6000G2B_MODULE_FIRMWARE(api) _IWL6000G2B_MODULE_FIRMWARE(api)
+
 
 static void iwl6000_set_ct_threshold(struct iwl_priv *priv)
 {
@@ -335,6 +339,25 @@ static const struct iwl_ops iwl6000_ops = {
 	.led = &iwlagn_led_ops,
 };
 
+static void do_not_send_bt_config(struct iwl_priv *priv)
+{
+}
+
+static struct iwl_hcmd_ops iwl6000g2b_hcmd = {
+	.rxon_assoc = iwlagn_send_rxon_assoc,
+	.commit_rxon = iwl_commit_rxon,
+	.set_rxon_chain = iwl_set_rxon_chain,
+	.set_tx_ant = iwlagn_send_tx_ant_config,
+	.send_bt_config = do_not_send_bt_config,
+};
+
+static const struct iwl_ops iwl6000g2b_ops = {
+	.lib = &iwl6000_lib,
+	.hcmd = &iwl6000g2b_hcmd,
+	.utils = &iwlagn_hcmd_utils,
+	.led = &iwlagn_led_ops,
+};
+
 static struct iwl_lib_ops iwl6050_lib = {
 	.set_hw_params = iwl6050_hw_set_hw_params,
 	.txq_update_byte_cnt_tbl = iwlagn_txq_update_byte_cnt_tbl,
@@ -445,6 +468,234 @@ struct iwl_cfg iwl6000g2a_2agn_cfg = {
 	.chain_noise_calib_by_driver = true,
 };
 
+struct iwl_cfg iwl6000g2a_2abg_cfg = {
+	.name = "6000 Series 2x2 ABG Gen2a",
+	.fw_name_pre = IWL6000G2A_FW_PRE,
+	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
+	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
+	.sku = IWL_SKU_A|IWL_SKU_G,
+	.ops = &iwl6000_ops,
+	.eeprom_size = OTP_LOW_IMAGE_SIZE,
+	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
+	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
+	.num_of_queues = IWLAGN_NUM_QUEUES,
+	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
+	.mod_params = &iwlagn_mod_params,
+	.valid_tx_ant = ANT_AB,
+	.valid_rx_ant = ANT_AB,
+	.pll_cfg_val = 0,
+	.set_l0s = true,
+	.use_bsm = false,
+	.pa_type = IWL_PA_SYSTEM,
+	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
+	.shadow_ram_support = true,
+	.led_compensation = 51,
+	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
+	.supports_idle = true,
+	.adv_thermal_throttle = true,
+	.support_ct_kill_exit = true,
+	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
+	.chain_noise_scale = 1000,
+	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.max_event_log_size = 512,
+};
+
+struct iwl_cfg iwl6000g2a_2bg_cfg = {
+	.name = "6000 Series 2x2 BG Gen2a",
+	.fw_name_pre = IWL6000G2A_FW_PRE,
+	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
+	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
+	.sku = IWL_SKU_G,
+	.ops = &iwl6000_ops,
+	.eeprom_size = OTP_LOW_IMAGE_SIZE,
+	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
+	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
+	.num_of_queues = IWLAGN_NUM_QUEUES,
+	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
+	.mod_params = &iwlagn_mod_params,
+	.valid_tx_ant = ANT_AB,
+	.valid_rx_ant = ANT_AB,
+	.pll_cfg_val = 0,
+	.set_l0s = true,
+	.use_bsm = false,
+	.pa_type = IWL_PA_SYSTEM,
+	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
+	.shadow_ram_support = true,
+	.led_compensation = 51,
+	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
+	.supports_idle = true,
+	.adv_thermal_throttle = true,
+	.support_ct_kill_exit = true,
+	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
+	.chain_noise_scale = 1000,
+	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.max_event_log_size = 512,
+};
+
+struct iwl_cfg iwl6000g2b_2agn_cfg = {
+	.name = "6000 Series 2x2 AGN Gen2b",
+	.fw_name_pre = IWL6000G2B_FW_PRE,
+	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
+	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
+	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
+	.ops = &iwl6000g2b_ops,
+	.eeprom_size = OTP_LOW_IMAGE_SIZE,
+	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
+	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
+	.num_of_queues = IWLAGN_NUM_QUEUES,
+	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
+	.mod_params = &iwlagn_mod_params,
+	.valid_tx_ant = ANT_AB,
+	.valid_rx_ant = ANT_AB,
+	.pll_cfg_val = 0,
+	.set_l0s = true,
+	.use_bsm = false,
+	.pa_type = IWL_PA_SYSTEM,
+	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
+	.shadow_ram_support = true,
+	.ht_greenfield_support = true,
+	.led_compensation = 51,
+	.use_rts_for_ht = true, /* use rts/cts protection */
+	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
+	.supports_idle = true,
+	.adv_thermal_throttle = true,
+	.support_ct_kill_exit = true,
+	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
+	.chain_noise_scale = 1000,
+	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.max_event_log_size = 512,
+};
+
+struct iwl_cfg iwl6000g2b_2abg_cfg = {
+	.name = "6000 Series 2x2 ABG Gen2b",
+	.fw_name_pre = IWL6000G2B_FW_PRE,
+	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
+	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
+	.sku = IWL_SKU_A|IWL_SKU_G,
+	.ops = &iwl6000g2b_ops,
+	.eeprom_size = OTP_LOW_IMAGE_SIZE,
+	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
+	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
+	.num_of_queues = IWLAGN_NUM_QUEUES,
+	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
+	.mod_params = &iwlagn_mod_params,
+	.valid_tx_ant = ANT_AB,
+	.valid_rx_ant = ANT_AB,
+	.pll_cfg_val = 0,
+	.set_l0s = true,
+	.use_bsm = false,
+	.pa_type = IWL_PA_SYSTEM,
+	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
+	.shadow_ram_support = true,
+	.led_compensation = 51,
+	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
+	.supports_idle = true,
+	.adv_thermal_throttle = true,
+	.support_ct_kill_exit = true,
+	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
+	.chain_noise_scale = 1000,
+	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.max_event_log_size = 512,
+};
+
+struct iwl_cfg iwl6000g2b_2bg_cfg = {
+	.name = "6000 Series 2x2 BG Gen2b",
+	.fw_name_pre = IWL6000G2B_FW_PRE,
+	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
+	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
+	.sku = IWL_SKU_G,
+	.ops = &iwl6000g2b_ops,
+	.eeprom_size = OTP_LOW_IMAGE_SIZE,
+	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
+	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
+	.num_of_queues = IWLAGN_NUM_QUEUES,
+	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
+	.mod_params = &iwlagn_mod_params,
+	.valid_tx_ant = ANT_AB,
+	.valid_rx_ant = ANT_AB,
+	.pll_cfg_val = 0,
+	.set_l0s = true,
+	.use_bsm = false,
+	.pa_type = IWL_PA_SYSTEM,
+	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
+	.shadow_ram_support = true,
+	.led_compensation = 51,
+	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
+	.supports_idle = true,
+	.adv_thermal_throttle = true,
+	.support_ct_kill_exit = true,
+	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
+	.chain_noise_scale = 1000,
+	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.max_event_log_size = 512,
+};
+
+struct iwl_cfg iwl6000g2b_bgn_cfg = {
+	.name = "6000 Series 1x2 BGN Gen2b",
+	.fw_name_pre = IWL6000G2B_FW_PRE,
+	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
+	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
+	.sku = IWL_SKU_G|IWL_SKU_N,
+	.ops = &iwl6000g2b_ops,
+	.eeprom_size = OTP_LOW_IMAGE_SIZE,
+	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
+	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
+	.num_of_queues = IWLAGN_NUM_QUEUES,
+	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
+	.mod_params = &iwlagn_mod_params,
+	.valid_tx_ant = ANT_A,
+	.valid_rx_ant = ANT_AB,
+	.pll_cfg_val = 0,
+	.set_l0s = true,
+	.use_bsm = false,
+	.pa_type = IWL_PA_SYSTEM,
+	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
+	.shadow_ram_support = true,
+	.ht_greenfield_support = true,
+	.led_compensation = 51,
+	.use_rts_for_ht = true, /* use rts/cts protection */
+	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
+	.supports_idle = true,
+	.adv_thermal_throttle = true,
+	.support_ct_kill_exit = true,
+	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
+	.chain_noise_scale = 1000,
+	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.max_event_log_size = 512,
+};
+
+struct iwl_cfg iwl6000g2b_bg_cfg = {
+	.name = "6000 Series 1x2 BG Gen2b",
+	.fw_name_pre = IWL6000G2B_FW_PRE,
+	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
+	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
+	.sku = IWL_SKU_G,
+	.ops = &iwl6000g2b_ops,
+	.eeprom_size = OTP_LOW_IMAGE_SIZE,
+	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
+	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
+	.num_of_queues = IWLAGN_NUM_QUEUES,
+	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
+	.mod_params = &iwlagn_mod_params,
+	.valid_tx_ant = ANT_A,
+	.valid_rx_ant = ANT_AB,
+	.pll_cfg_val = 0,
+	.set_l0s = true,
+	.use_bsm = false,
+	.pa_type = IWL_PA_SYSTEM,
+	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
+	.shadow_ram_support = true,
+	.led_compensation = 51,
+	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
+	.supports_idle = true,
+	.adv_thermal_throttle = true,
+	.support_ct_kill_exit = true,
+	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
+	.chain_noise_scale = 1000,
+	.monitor_recover_period = IWL_MONITORING_PERIOD,
+	.max_event_log_size = 512,
+};
+
 /*
  * "i": Internal configuration, use internal Power Amplifier
  */
@@ -667,3 +918,4 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL6050_MODULE_FIRMWARE(IWL6050_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL6000G2A_MODULE_FIRMWARE(IWL6000G2_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL6000G2B_MODULE_FIRMWARE(IWL6000G2_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
index 44ef5d9..25851ec 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
@@ -37,7 +37,7 @@
 #include "iwl-io.h"
 #include "iwl-agn.h"
 
-static int iwlagn_send_rxon_assoc(struct iwl_priv *priv)
+int iwlagn_send_rxon_assoc(struct iwl_priv *priv)
 {
 	int ret = 0;
 	struct iwl5000_rxon_assoc_cmd rxon_assoc;
@@ -84,7 +84,7 @@ static int iwlagn_send_rxon_assoc(struct iwl_priv *priv)
 	return ret;
 }
 
-static int iwlagn_send_tx_ant_config(struct iwl_priv *priv, u8 valid_tx_ant)
+int iwlagn_send_tx_ant_config(struct iwl_priv *priv, u8 valid_tx_ant)
 {
 	struct iwl_tx_ant_config_cmd tx_ant_cmd = {
 	  .valid = cpu_to_le32(valid_tx_ant),
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 845d0ee..f910246 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -4059,6 +4059,23 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x0082, 0x1201, iwl6000g2a_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x0085, 0x1211, iwl6000g2a_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x0082, 0x1221, iwl6000g2a_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x0082, 0x1206, iwl6000g2a_2abg_cfg)},
+	{IWL_PCI_DEVICE(0x0085, 0x1216, iwl6000g2a_2abg_cfg)},
+	{IWL_PCI_DEVICE(0x0082, 0x1226, iwl6000g2a_2abg_cfg)},
+	{IWL_PCI_DEVICE(0x0082, 0x1207, iwl6000g2a_2bg_cfg)},
+
+/* 6x00 Series Gen2b */
+	{IWL_PCI_DEVICE(0x008F, 0x5105, iwl6000g2b_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0090, 0x5115, iwl6000g2b_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x008F, 0x5125, iwl6000g2b_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x008F, 0x5107, iwl6000g2b_bg_cfg)},
+	{IWL_PCI_DEVICE(0x008F, 0x5201, iwl6000g2b_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x0090, 0x5211, iwl6000g2b_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x008F, 0x5221, iwl6000g2b_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x008F, 0x5206, iwl6000g2b_2abg_cfg)},
+	{IWL_PCI_DEVICE(0x0090, 0x5216, iwl6000g2b_2abg_cfg)},
+	{IWL_PCI_DEVICE(0x008F, 0x5226, iwl6000g2b_2abg_cfg)},
+	{IWL_PCI_DEVICE(0x008F, 0x5207, iwl6000g2b_2bg_cfg)},
 
 /* 6x50 WiFi/WiMax Series */
 	{IWL_PCI_DEVICE(0x0087, 0x1301, iwl6050_2agn_cfg)},
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index fbbefe1..12c198f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -180,4 +180,8 @@ void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif);
 int iwlagn_manage_ibss_station(struct iwl_priv *priv,
 			       struct ieee80211_vif *vif, bool add);
 
+/* hcmd */
+int iwlagn_send_rxon_assoc(struct iwl_priv *priv);
+int iwlagn_send_tx_ant_config(struct iwl_priv *priv, u8 valid_tx_ant);
+
 #endif /* __iwl_agn_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index fdd0430..04296fd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -58,6 +58,13 @@ extern struct iwl_cfg iwl5100_abg_cfg;
 extern struct iwl_cfg iwl5150_agn_cfg;
 extern struct iwl_cfg iwl5150_abg_cfg;
 extern struct iwl_cfg iwl6000g2a_2agn_cfg;
+extern struct iwl_cfg iwl6000g2a_2abg_cfg;
+extern struct iwl_cfg iwl6000g2a_2bg_cfg;
+extern struct iwl_cfg iwl6000g2b_bgn_cfg;
+extern struct iwl_cfg iwl6000g2b_bg_cfg;
+extern struct iwl_cfg iwl6000g2b_2agn_cfg;
+extern struct iwl_cfg iwl6000g2b_2abg_cfg;
+extern struct iwl_cfg iwl6000g2b_2bg_cfg;
 extern struct iwl_cfg iwl6000i_2agn_cfg;
 extern struct iwl_cfg iwl6000i_2abg_cfg;
 extern struct iwl_cfg iwl6000i_2bg_cfg;
-- 
1.6.3.3

