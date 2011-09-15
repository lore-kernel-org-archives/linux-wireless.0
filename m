Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:19373 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934481Ab1IOTcG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 15:32:06 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Fry, Donald H" <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 11/27] iwlagn: simplify chain_noise_num_beacons indirection
Date: Thu, 15 Sep 2011 11:46:38 -0700
Message-Id: <1316112414-6341-12-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110915_213229_701134_2E1CFEB2)
In-Reply-To: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Fry, Donald H <donald.h.fry@intel.com>

chain_noise_num_beacons is set and never changes.  Use the #define
rather than 3 levels of indirection.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c      |    1 -
 drivers/net/wireless/iwlwifi/iwl-2000.c      |    2 --
 drivers/net/wireless/iwlwifi/iwl-5000.c      |    1 -
 drivers/net/wireless/iwlwifi/iwl-6000.c      |    3 ---
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c |   21 +++++++--------------
 drivers/net/wireless/iwlwifi/iwl-core.h      |    1 -
 6 files changed, 7 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 4766c3a..5eba5d9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -191,7 +191,6 @@ static struct iwl_base_params iwl1000_base_params = {
 	.max_ll_items = OTP_MAX_LL_ITEMS_1000,
 	.shadow_ram_support = false,
 	.led_compensation = 51,
-	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_EXT_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 0579398..ba138a5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -211,7 +211,6 @@ static struct iwl_base_params iwl2000_base_params = {
 	.max_ll_items = OTP_MAX_LL_ITEMS_2x00,
 	.shadow_ram_support = true,
 	.led_compensation = 51,
-	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.adv_thermal_throttle = true,
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
@@ -231,7 +230,6 @@ static struct iwl_base_params iwl2030_base_params = {
 	.max_ll_items = OTP_MAX_LL_ITEMS_2x00,
 	.shadow_ram_support = true,
 	.led_compensation = 57,
-	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.adv_thermal_throttle = true,
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 7cb4d69..327ebf6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -353,7 +353,6 @@ static struct iwl_base_params iwl5000_base_params = {
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.pll_cfg_val = CSR50_ANA_PLL_CFG_VAL,
 	.led_compensation = 51,
-	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
 	.wd_timeout = IWL_LONG_WD_TIMEOUT,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 2a98e65..d443785 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -305,7 +305,6 @@ static struct iwl_base_params iwl6000_base_params = {
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
 	.shadow_ram_support = true,
 	.led_compensation = 51,
-	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.adv_thermal_throttle = true,
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
@@ -323,7 +322,6 @@ static struct iwl_base_params iwl6050_base_params = {
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x50,
 	.shadow_ram_support = true,
 	.led_compensation = 51,
-	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.adv_thermal_throttle = true,
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
@@ -340,7 +338,6 @@ static struct iwl_base_params iwl6000_g2_base_params = {
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
 	.shadow_ram_support = true,
 	.led_compensation = 57,
-	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.adv_thermal_throttle = true,
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
index b725f69..03bac48 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
@@ -766,12 +766,9 @@ static void iwl_find_disconn_antenna(struct iwl_priv *priv, u32* average_sig,
 	u8 first_chain;
 	u16 i = 0;
 
-	average_sig[0] = data->chain_signal_a /
-			 priv->cfg->base_params->chain_noise_num_beacons;
-	average_sig[1] = data->chain_signal_b /
-			 priv->cfg->base_params->chain_noise_num_beacons;
-	average_sig[2] = data->chain_signal_c /
-			 priv->cfg->base_params->chain_noise_num_beacons;
+	average_sig[0] = data->chain_signal_a / IWL_CAL_NUM_BEACONS;
+	average_sig[1] = data->chain_signal_b / IWL_CAL_NUM_BEACONS;
+	average_sig[2] = data->chain_signal_c / IWL_CAL_NUM_BEACONS;
 
 	if (average_sig[0] >= average_sig[1]) {
 		max_average_sig = average_sig[0];
@@ -1038,8 +1035,7 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv)
 	/* If this is the "chain_noise_num_beacons", determine:
 	 * 1)  Disconnected antennas (using signal strengths)
 	 * 2)  Differential gain (using silence noise) to balance receivers */
-	if (data->beacon_count !=
-		priv->cfg->base_params->chain_noise_num_beacons)
+	if (data->beacon_count != IWL_CAL_NUM_BEACONS)
 		return;
 
 	/* Analyze signal for disconnected antenna */
@@ -1055,12 +1051,9 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv)
 		iwl_find_disconn_antenna(priv, average_sig, data);
 
 	/* Analyze noise for rx balance */
-	average_noise[0] = data->chain_noise_a /
-			   priv->cfg->base_params->chain_noise_num_beacons;
-	average_noise[1] = data->chain_noise_b /
-			   priv->cfg->base_params->chain_noise_num_beacons;
-	average_noise[2] = data->chain_noise_c /
-			   priv->cfg->base_params->chain_noise_num_beacons;
+	average_noise[0] = data->chain_noise_a / IWL_CAL_NUM_BEACONS;
+	average_noise[1] = data->chain_noise_b / IWL_CAL_NUM_BEACONS;
+	average_noise[2] = data->chain_noise_c / IWL_CAL_NUM_BEACONS;
 
 	for (i = 0; i < NUM_RX_CHAINS; i++) {
 		if (!(data->disconn_array[i]) &&
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 56b554c..549dc46 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -124,7 +124,6 @@ struct iwl_base_params {
 	const u16 max_ll_items;
 	const bool shadow_ram_support;
 	u16 led_compensation;
-	int chain_noise_num_beacons;
 	bool adv_thermal_throttle;
 	bool support_ct_kill_exit;
 	const bool support_wimax_coexist;
-- 
1.7.0.4

