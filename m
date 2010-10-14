Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:8111 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753146Ab0JNSET (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 14:04:19 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/9] iwlagn: need longer tx queue stuck timer for coex devices
Date: Thu, 14 Oct 2010 11:02:42 -0700
Message-Id: <1287079370-20587-2-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1287079370-20587-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1287079370-20587-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For BT/WiFi combo devices, need longer tx stuck queue
timer, so those devices won't reload firmware too often.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |   38 ++++++++++++++++++++++++------
 drivers/net/wireless/iwlwifi/iwl-core.c |   11 +++-----
 2 files changed, 34 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 4810258..3eaea6f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -509,6 +509,28 @@ static struct iwl_base_params iwl6050_base_params = {
 	.sensitivity_calib_by_driver = true,
 	.chain_noise_calib_by_driver = true,
 };
+static struct iwl_base_params iwl6000_coex_base_params = {
+	.eeprom_size = OTP_LOW_IMAGE_SIZE,
+	.num_of_queues = IWLAGN_NUM_QUEUES,
+	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
+	.pll_cfg_val = 0,
+	.set_l0s = true,
+	.use_bsm = false,
+	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
+	.shadow_ram_support = true,
+	.led_compensation = 51,
+	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
+	.supports_idle = true,
+	.adv_thermal_throttle = true,
+	.support_ct_kill_exit = true,
+	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
+	.chain_noise_scale = 1000,
+	.monitor_recover_period = IWL_LONG_MONITORING_PERIOD,
+	.max_event_log_size = 512,
+	.ucode_tracing = true,
+	.sensitivity_calib_by_driver = true,
+	.chain_noise_calib_by_driver = true,
+};
 
 static struct iwl_ht_params iwl6000_ht_params = {
 	.ht_greenfield_support = true,
@@ -587,7 +609,7 @@ struct iwl_cfg iwl6000g2b_2agn_cfg = {
 	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
 	.ops = &iwl6000g2b_ops,
 	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl6000_base_params,
+	.base_params = &iwl6000_coex_base_params,
 	.bt_params = &iwl6000_bt_params,
 	.ht_params = &iwl6000_ht_params,
 	.need_dc_calib = true,
@@ -608,7 +630,7 @@ struct iwl_cfg iwl6000g2b_2abg_cfg = {
 	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
 	.ops = &iwl6000g2b_ops,
 	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl6000_base_params,
+	.base_params = &iwl6000_coex_base_params,
 	.bt_params = &iwl6000_bt_params,
 	.need_dc_calib = true,
 	.need_temp_offset_calib = true,
@@ -628,7 +650,7 @@ struct iwl_cfg iwl6000g2b_2bgn_cfg = {
 	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
 	.ops = &iwl6000g2b_ops,
 	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl6000_base_params,
+	.base_params = &iwl6000_coex_base_params,
 	.bt_params = &iwl6000_bt_params,
 	.ht_params = &iwl6000_ht_params,
 	.need_dc_calib = true,
@@ -649,7 +671,7 @@ struct iwl_cfg iwl6000g2b_2bg_cfg = {
 	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
 	.ops = &iwl6000g2b_ops,
 	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl6000_base_params,
+	.base_params = &iwl6000_coex_base_params,
 	.bt_params = &iwl6000_bt_params,
 	.need_dc_calib = true,
 	.need_temp_offset_calib = true,
@@ -669,7 +691,7 @@ struct iwl_cfg iwl6000g2b_bgn_cfg = {
 	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
 	.ops = &iwl6000g2b_ops,
 	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl6000_base_params,
+	.base_params = &iwl6000_coex_base_params,
 	.bt_params = &iwl6000_bt_params,
 	.ht_params = &iwl6000_ht_params,
 	.need_dc_calib = true,
@@ -690,7 +712,7 @@ struct iwl_cfg iwl6000g2b_bg_cfg = {
 	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
 	.ops = &iwl6000g2b_ops,
 	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl6000_base_params,
+	.base_params = &iwl6000_coex_base_params,
 	.bt_params = &iwl6000_bt_params,
 	.need_dc_calib = true,
 	.need_temp_offset_calib = true,
@@ -829,7 +851,7 @@ struct iwl_cfg iwl130_bgn_cfg = {
 	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
 	.ops = &iwl6000g2b_ops,
 	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl6000_base_params,
+	.base_params = &iwl6000_coex_base_params,
 	.bt_params = &iwl6000_bt_params,
 	.ht_params = &iwl6000_ht_params,
 	.need_dc_calib = true,
@@ -849,7 +871,7 @@ struct iwl_cfg iwl130_bg_cfg = {
 	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
 	.ops = &iwl6000g2b_ops,
 	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl6000_base_params,
+	.base_params = &iwl6000_coex_base_params,
 	.bt_params = &iwl6000_bt_params,
 	.need_dc_calib = true,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index b3efbe0..89b1827 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2483,13 +2483,10 @@ static int iwl_check_stuck_queue(struct iwl_priv *priv, int cnt)
 					"queue %d, not read %d time\n",
 					q->id,
 					q->repeat_same_read_ptr);
-			if (priv->cfg->bt_params &&
-			    !priv->cfg->bt_params->advanced_bt_coexist) {
-				mod_timer(&priv->monitor_recover,
-					jiffies + msecs_to_jiffies(
-					IWL_ONE_HUNDRED_MSECS));
-				return 1;
-			}
+			mod_timer(&priv->monitor_recover,
+				jiffies + msecs_to_jiffies(
+				IWL_ONE_HUNDRED_MSECS));
+			return 1;
 		}
 	} else {
 		q->last_read_ptr = q->read_ptr;
-- 
1.7.0.4

