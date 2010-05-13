Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:49315 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932714Ab0EMVuW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 17:50:22 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Shanyu Zhao <shanyu.zhao@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 17/17] iwlwifi: add new PCI IDs for 6000g2 devices
Date: Thu, 13 May 2010 14:49:59 -0700
Message-Id: <1273787399-9280-18-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273787399-9280-1-git-send-email-reinette.chatre@intel.com>
References: <1273787399-9280-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shanyu Zhao <shanyu.zhao@intel.com>

Add new PCI IDs for 6000 Series Gen2 devices
and also defines a new sku of device: 6000g2b 2x2 bgn.

Signed-off-by: Shanyu Zhao <shanyu.zhao@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |   34 +++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c  |   24 +++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.h  |    1 +
 3 files changed, 59 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 9247594..73713f6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -598,6 +598,40 @@ struct iwl_cfg iwl6000g2b_2abg_cfg = {
 	.max_event_log_size = 512,
 };
 
+struct iwl_cfg iwl6000g2b_2bgn_cfg = {
+	.name = "6000 Series 2x2 BGN Gen2b",
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
 struct iwl_cfg iwl6000g2b_2bg_cfg = {
 	.name = "6000 Series 2x2 BG Gen2b",
 	.fw_name_pre = IWL6000G2B_FW_PRE,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index eb74f28..84c1675 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -4058,6 +4058,13 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x0085, 0x1216, iwl6000g2a_2abg_cfg)},
 	{IWL_PCI_DEVICE(0x0082, 0x1226, iwl6000g2a_2abg_cfg)},
 	{IWL_PCI_DEVICE(0x0082, 0x1207, iwl6000g2a_2bg_cfg)},
+	{IWL_PCI_DEVICE(0x0082, 0x1301, iwl6000g2a_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x0082, 0x1306, iwl6000g2a_2abg_cfg)},
+	{IWL_PCI_DEVICE(0x0082, 0x1307, iwl6000g2a_2bg_cfg)},
+	{IWL_PCI_DEVICE(0x0082, 0x1321, iwl6000g2a_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x0082, 0x1326, iwl6000g2a_2abg_cfg)},
+	{IWL_PCI_DEVICE(0x0085, 0x1311, iwl6000g2a_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x0085, 0x1316, iwl6000g2a_2abg_cfg)},
 
 /* 6x00 Series Gen2b */
 	{IWL_PCI_DEVICE(0x008F, 0x5105, iwl6000g2b_bgn_cfg)},
@@ -4071,6 +4078,23 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x0090, 0x5216, iwl6000g2b_2abg_cfg)},
 	{IWL_PCI_DEVICE(0x008F, 0x5226, iwl6000g2b_2abg_cfg)},
 	{IWL_PCI_DEVICE(0x008F, 0x5207, iwl6000g2b_2bg_cfg)},
+	{IWL_PCI_DEVICE(0x008A, 0x5301, iwl6000g2b_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x008A, 0x5305, iwl6000g2b_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x008A, 0x5307, iwl6000g2b_bg_cfg)},
+	{IWL_PCI_DEVICE(0x008A, 0x5321, iwl6000g2b_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x008A, 0x5325, iwl6000g2b_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x008B, 0x5311, iwl6000g2b_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x008B, 0x5315, iwl6000g2b_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0090, 0x5211, iwl6000g2b_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x0090, 0x5215, iwl6000g2b_2bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0090, 0x5216, iwl6000g2b_2abg_cfg)},
+	{IWL_PCI_DEVICE(0x0091, 0x5201, iwl6000g2b_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x0091, 0x5205, iwl6000g2b_2bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0091, 0x5206, iwl6000g2b_2abg_cfg)},
+	{IWL_PCI_DEVICE(0x0091, 0x5207, iwl6000g2b_2bg_cfg)},
+	{IWL_PCI_DEVICE(0x0091, 0x5221, iwl6000g2b_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x0091, 0x5225, iwl6000g2b_2bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0091, 0x5226, iwl6000g2b_2abg_cfg)},
 
 /* 6x50 WiFi/WiMax Series */
 	{IWL_PCI_DEVICE(0x0087, 0x1301, iwl6050_2agn_cfg)},
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index f7ef893..5c32777 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -81,6 +81,7 @@ extern struct iwl_cfg iwl6000g2b_bgn_cfg;
 extern struct iwl_cfg iwl6000g2b_bg_cfg;
 extern struct iwl_cfg iwl6000g2b_2agn_cfg;
 extern struct iwl_cfg iwl6000g2b_2abg_cfg;
+extern struct iwl_cfg iwl6000g2b_2bgn_cfg;
 extern struct iwl_cfg iwl6000g2b_2bg_cfg;
 extern struct iwl_cfg iwl6000i_2agn_cfg;
 extern struct iwl_cfg iwl6000i_2abg_cfg;
-- 
1.6.3.3

