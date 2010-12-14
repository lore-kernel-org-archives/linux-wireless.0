Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:3691 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758028Ab0LNARH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 19:17:07 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 01/14] iwlagn: change led compensation for 6005 and 6030 devices
Date: Mon, 13 Dec 2010 16:09:19 -0800
Message-Id: <1292285372-11373-2-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1292285372-11373-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1292285372-11373-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

For both 6005 and 6030 devices, change the led compensation to 57

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 808942c..10a5369 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -511,7 +511,7 @@ static struct iwl_base_params iwl6050_base_params = {
 	.chain_noise_calib_by_driver = true,
 	.shadow_reg_enable = true,
 };
-static struct iwl_base_params iwl6000_coex_base_params = {
+static struct iwl_base_params iwl6000_g2_base_params = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
@@ -520,7 +520,7 @@ static struct iwl_base_params iwl6000_coex_base_params = {
 	.use_bsm = false,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
 	.shadow_ram_support = true,
-	.led_compensation = 51,
+	.led_compensation = 57,
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.supports_idle = true,
 	.adv_thermal_throttle = true,
@@ -559,7 +559,7 @@ struct iwl_cfg iwl6005_2agn_cfg = {
 	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
 	.ops = &iwl6000_ops,
 	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl6000_base_params,
+	.base_params = &iwl6000_g2_base_params,
 	.ht_params = &iwl6000_ht_params,
 	.need_dc_calib = true,
 	.need_temp_offset_calib = true,
@@ -575,7 +575,7 @@ struct iwl_cfg iwl6005_2abg_cfg = {
 	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
 	.ops = &iwl6000_ops,
 	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl6000_base_params,
+	.base_params = &iwl6000_g2_base_params,
 	.need_dc_calib = true,
 	.need_temp_offset_calib = true,
 	.led_mode = IWL_LED_RF_STATE,
@@ -590,7 +590,7 @@ struct iwl_cfg iwl6005_2bg_cfg = {
 	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
 	.ops = &iwl6000_ops,
 	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl6000_base_params,
+	.base_params = &iwl6000_g2_base_params,
 	.need_dc_calib = true,
 	.need_temp_offset_calib = true,
 	.led_mode = IWL_LED_RF_STATE,
@@ -605,7 +605,7 @@ struct iwl_cfg iwl6030_2agn_cfg = {
 	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
 	.ops = &iwl6000g2b_ops,
 	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl6000_coex_base_params,
+	.base_params = &iwl6000_g2_base_params,
 	.bt_params = &iwl6000_bt_params,
 	.ht_params = &iwl6000_ht_params,
 	.need_dc_calib = true,
@@ -625,7 +625,7 @@ struct iwl_cfg iwl6030_2abg_cfg = {
 	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
 	.ops = &iwl6000g2b_ops,
 	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl6000_coex_base_params,
+	.base_params = &iwl6000_g2_base_params,
 	.bt_params = &iwl6000_bt_params,
 	.need_dc_calib = true,
 	.need_temp_offset_calib = true,
@@ -644,7 +644,7 @@ struct iwl_cfg iwl6030_2bgn_cfg = {
 	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
 	.ops = &iwl6000g2b_ops,
 	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl6000_coex_base_params,
+	.base_params = &iwl6000_g2_base_params,
 	.bt_params = &iwl6000_bt_params,
 	.ht_params = &iwl6000_ht_params,
 	.need_dc_calib = true,
@@ -664,7 +664,7 @@ struct iwl_cfg iwl6030_2bg_cfg = {
 	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
 	.ops = &iwl6000g2b_ops,
 	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl6000_coex_base_params,
+	.base_params = &iwl6000_g2_base_params,
 	.bt_params = &iwl6000_bt_params,
 	.need_dc_calib = true,
 	.need_temp_offset_calib = true,
@@ -683,7 +683,7 @@ struct iwl_cfg iwl1030_bgn_cfg = {
 	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
 	.ops = &iwl6000g2b_ops,
 	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl6000_coex_base_params,
+	.base_params = &iwl6000_g2_base_params,
 	.bt_params = &iwl6000_bt_params,
 	.ht_params = &iwl6000_ht_params,
 	.need_dc_calib = true,
@@ -703,7 +703,7 @@ struct iwl_cfg iwl1030_bg_cfg = {
 	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
 	.ops = &iwl6000g2b_ops,
 	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl6000_coex_base_params,
+	.base_params = &iwl6000_g2_base_params,
 	.bt_params = &iwl6000_bt_params,
 	.need_dc_calib = true,
 	.need_temp_offset_calib = true,
@@ -833,7 +833,7 @@ struct iwl_cfg iwl130_bgn_cfg = {
 	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
 	.ops = &iwl6000g2b_ops,
 	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl6000_coex_base_params,
+	.base_params = &iwl6000_g2_base_params,
 	.bt_params = &iwl6000_bt_params,
 	.ht_params = &iwl6000_ht_params,
 	.need_dc_calib = true,
@@ -852,7 +852,7 @@ struct iwl_cfg iwl130_bg_cfg = {
 	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
 	.ops = &iwl6000g2b_ops,
 	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl6000_coex_base_params,
+	.base_params = &iwl6000_g2_base_params,
 	.bt_params = &iwl6000_bt_params,
 	.need_dc_calib = true,
 	.led_mode = IWL_LED_RF_STATE,
-- 
1.7.0.4

