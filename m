Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22727 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753586Ab0CYUo7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 16:44:59 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Jay Sternberg <jay.e.sternberg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 15/22] iwlwifi: enable '6000 Series 2x2 AGN Gen2' adaptors
Date: Thu, 25 Mar 2010 13:44:43 -0700
Message-Id: <1269549890-19195-16-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
References: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jay Sternberg <jay.e.sternberg@intel.com>

Signed-off-by: Jay Sternberg <jay.e.sternberg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |   34 +++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    1 +
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    1 +
 3 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index f89e1c7..7473518 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -57,6 +57,7 @@
 #define IWL6050_UCODE_API_MIN 4
 
 #define IWL6000_FW_PRE "iwlwifi-6000-"
+#define IWL6000_G2_FW_PRE "iwlwifi-6005-"
 #define _IWL6000_MODULE_FIRMWARE(api) IWL6000_FW_PRE #api ".ucode"
 #define IWL6000_MODULE_FIRMWARE(api) _IWL6000_MODULE_FIRMWARE(api)
 
@@ -362,6 +363,39 @@ static const struct iwl_ops iwl6050_ops = {
 /*
  * "i": Internal configuration, use internal Power Amplifier
  */
+struct iwl_cfg iwl6000i_g2_2agn_cfg = {
+	.name = "6000 Series 2x2 AGN Gen2",
+	.fw_name_pre = IWL6000_G2_FW_PRE,
+	.ucode_api_max = IWL6000_UCODE_API_MAX,
+	.ucode_api_min = IWL6000_UCODE_API_MIN,
+	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
+	.ops = &iwl6000_ops,
+	.eeprom_size = OTP_LOW_IMAGE_SIZE,
+	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
+	.eeprom_calib_ver = EEPROM_6000_TX_POWER_VERSION,
+	.num_of_queues = IWLAGN_NUM_QUEUES,
+	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
+	.mod_params = &iwlagn_mod_params,
+	.valid_tx_ant = ANT_AB,
+	.valid_rx_ant = ANT_AB,
+	.pll_cfg_val = 0,
+	.set_l0s = true,
+	.use_bsm = false,
+	.pa_type = IWL_PA_INTERNAL,
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
+};
+
 struct iwl_cfg iwl6000i_2agn_cfg = {
 	.name = "Intel(R) Centrino(R) Advanced-N 6200 AGN",
 	.fw_name_pre = IWL6000_FW_PRE,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index bc08e9b..3f0fd75 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3853,6 +3853,7 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x4238, 0x1111, iwl6000_3agn_cfg)},
 	{IWL_PCI_DEVICE(0x4239, 0x1311, iwl6000i_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x4239, 0x1316, iwl6000i_2abg_cfg)},
+	{IWL_PCI_DEVICE(0x0082, 0x1201, iwl6000i_g2_2agn_cfg)},
 
 /* 6x50 WiFi/WiMax Series */
 	{IWL_PCI_DEVICE(0x0087, 0x1301, iwl6050_2agn_cfg)},
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index e847e61..c2e97cd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -57,6 +57,7 @@ extern struct iwl_cfg iwl5100_abg_cfg;
 extern struct iwl_cfg iwl5150_agn_cfg;
 extern struct iwl_cfg iwl5150_abg_cfg;
 extern struct iwl_cfg iwl6000i_2agn_cfg;
+extern struct iwl_cfg iwl6000i_g2_2agn_cfg;
 extern struct iwl_cfg iwl6000i_2abg_cfg;
 extern struct iwl_cfg iwl6000i_2bg_cfg;
 extern struct iwl_cfg iwl6000_3agn_cfg;
-- 
1.6.3.3

