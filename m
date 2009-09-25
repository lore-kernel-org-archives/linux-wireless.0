Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:1107 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534AbZIYVYa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 17:24:30 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 6/8] iwlwifi: Chain Noise Calibration for 6000 series
Date: Fri, 25 Sep 2009 14:24:26 -0700
Message-Id: <1253913868-8400-7-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1253913868-8400-1-git-send-email-reinette.chatre@intel.com>
References: <1253913868-8400-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Adding support of Chain Noise Calibration for 6000 series NICs.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c  |    2 +
 drivers/net/wireless/iwlwifi/iwl-4965.c  |    6 ++-
 drivers/net/wireless/iwlwifi/iwl-5000.c  |   15 ++++++-
 drivers/net/wireless/iwlwifi/iwl-6000.c  |   19 +++++----
 drivers/net/wireless/iwlwifi/iwl-calib.c |   64 +++++++++++++++++++++---------
 drivers/net/wireless/iwlwifi/iwl-core.h  |    5 ++-
 drivers/net/wireless/iwlwifi/iwl-dev.h   |    3 +-
 7 files changed, 80 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 3b3e6bc..9dfd4c4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -165,6 +165,7 @@ struct iwl_cfg iwl1000_bgn_cfg = {
 	.shadow_ram_support = false,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
+	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 };
 
 struct iwl_cfg iwl1000_bg_cfg = {
@@ -185,5 +186,6 @@ struct iwl_cfg iwl1000_bg_cfg = {
 	.shadow_ram_support = false,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
+	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 9ad5bca..d8c10ee 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -495,14 +495,15 @@ static void iwl4965_chain_noise_reset(struct iwl_priv *priv)
 static void iwl4965_gain_computation(struct iwl_priv *priv,
 		u32 *average_noise,
 		u16 min_average_noise_antenna_i,
-		u32 min_average_noise)
+		u32 min_average_noise,
+		u8 default_chain)
 {
 	int i, ret;
 	struct iwl_chain_noise_data *data = &priv->chain_noise_data;
 
 	data->delta_gain_code[min_average_noise_antenna_i] = 0;
 
-	for (i = 0; i < NUM_RX_CHAINS; i++) {
+	for (i = default_chain; i < NUM_RX_CHAINS; i++) {
 		s32 delta_g = 0;
 
 		if (!(data->disconn_array[i]) &&
@@ -2350,6 +2351,7 @@ struct iwl_cfg iwl4965_agn_cfg = {
 	.ht_greenfield_support = false,
 	.broken_powersave = true,
 	.led_compensation = 61,
+	.chain_noise_num_beacons = IWL4965_CAL_NUM_BEACONS,
 };
 
 /* Module firmware */
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index e5b0fab..35bf56c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -301,14 +301,17 @@ u16 iwl5000_eeprom_calib_version(struct iwl_priv *priv)
 static void iwl5000_gain_computation(struct iwl_priv *priv,
 		u32 average_noise[NUM_RX_CHAINS],
 		u16 min_average_noise_antenna_i,
-		u32 min_average_noise)
+		u32 min_average_noise,
+		u8 default_chain)
 {
 	int i;
 	s32 delta_g;
 	struct iwl_chain_noise_data *data = &priv->chain_noise_data;
 
-	/* Find Gain Code for the antennas B and C */
-	for (i = 1; i < NUM_RX_CHAINS; i++) {
+	/*
+	 * Find Gain Code for the chains based on "default chain"
+	 */
+	for (i = default_chain + 1; i < NUM_RX_CHAINS; i++) {
 		if ((data->disconn_array[i])) {
 			data->delta_gain_code[i] = 0;
 			continue;
@@ -1670,6 +1673,7 @@ struct iwl_cfg iwl5300_agn_cfg = {
 	.need_pll_cfg = true,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
+	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 };
 
 struct iwl_cfg iwl5100_bg_cfg = {
@@ -1688,6 +1692,7 @@ struct iwl_cfg iwl5100_bg_cfg = {
 	.need_pll_cfg = true,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
+	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 };
 
 struct iwl_cfg iwl5100_abg_cfg = {
@@ -1706,6 +1711,7 @@ struct iwl_cfg iwl5100_abg_cfg = {
 	.need_pll_cfg = true,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
+	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 };
 
 struct iwl_cfg iwl5100_agn_cfg = {
@@ -1724,6 +1730,7 @@ struct iwl_cfg iwl5100_agn_cfg = {
 	.need_pll_cfg = true,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
+	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 };
 
 struct iwl_cfg iwl5350_agn_cfg = {
@@ -1742,6 +1749,7 @@ struct iwl_cfg iwl5350_agn_cfg = {
 	.need_pll_cfg = true,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
+	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 };
 
 struct iwl_cfg iwl5150_agn_cfg = {
@@ -1760,6 +1768,7 @@ struct iwl_cfg iwl5150_agn_cfg = {
 	.need_pll_cfg = true,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
+	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 };
 
 MODULE_FIRMWARE(IWL5000_MODULE_FIRMWARE(IWL5000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 01a1f81..ad5d77c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -222,18 +222,11 @@ static struct iwl_lib_ops iwl6000_lib = {
 	 },
 };
 
-static struct iwl_hcmd_utils_ops iwl6000_hcmd_utils = {
-	.get_hcmd_size = iwl5000_get_hcmd_size,
-	.build_addsta_hcmd = iwl5000_build_addsta_hcmd,
-	.rts_tx_cmd_flag = iwl5000_rts_tx_cmd_flag,
-	.calc_rssi = iwl5000_calc_rssi,
-};
-
 static struct iwl_ops iwl6000_ops = {
 	.ucode = &iwl5000_ucode,
 	.lib = &iwl6000_lib,
 	.hcmd = &iwl5000_hcmd,
-	.utils = &iwl6000_hcmd_utils,
+	.utils = &iwl5000_hcmd_utils,
 };
 
 
@@ -260,6 +253,7 @@ struct iwl_cfg iwl6000h_2agn_cfg = {
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
 	.use_rts_for_ht = true, /* use rts/cts protection */
+	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 };
 
 struct iwl_cfg iwl6000h_2abg_cfg = {
@@ -281,6 +275,7 @@ struct iwl_cfg iwl6000h_2abg_cfg = {
 	.shadow_ram_support = true,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
+	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 };
 
 struct iwl_cfg iwl6000h_2bg_cfg = {
@@ -302,6 +297,7 @@ struct iwl_cfg iwl6000h_2bg_cfg = {
 	.shadow_ram_support = true,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
+	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 };
 
 /*
@@ -327,6 +323,7 @@ struct iwl_cfg iwl6000i_2agn_cfg = {
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
 	.use_rts_for_ht = true, /* use rts/cts protection */
+	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 };
 
 struct iwl_cfg iwl6000i_2abg_cfg = {
@@ -348,6 +345,7 @@ struct iwl_cfg iwl6000i_2abg_cfg = {
 	.shadow_ram_support = true,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
+	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 };
 
 struct iwl_cfg iwl6000i_2bg_cfg = {
@@ -369,6 +367,7 @@ struct iwl_cfg iwl6000i_2bg_cfg = {
 	.shadow_ram_support = true,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
+	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 };
 
 struct iwl_cfg iwl6050_2agn_cfg = {
@@ -391,6 +390,7 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
 	.use_rts_for_ht = true, /* use rts/cts protection */
+	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 };
 
 struct iwl_cfg iwl6050_2abg_cfg = {
@@ -412,6 +412,7 @@ struct iwl_cfg iwl6050_2abg_cfg = {
 	.shadow_ram_support = true,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
+	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 };
 
 struct iwl_cfg iwl6000_3agn_cfg = {
@@ -434,6 +435,7 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
 	.use_rts_for_ht = true, /* use rts/cts protection */
+	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 };
 
 struct iwl_cfg iwl6050_3agn_cfg = {
@@ -456,6 +458,7 @@ struct iwl_cfg iwl6050_3agn_cfg = {
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
 	.use_rts_for_ht = true, /* use rts/cts protection */
+	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 };
 
 MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-calib.c b/drivers/net/wireless/iwlwifi/iwl-calib.c
index 6e73317..69a80d7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-calib.c
@@ -643,6 +643,15 @@ void iwl_sensitivity_calibration(struct iwl_priv *priv,
 }
 EXPORT_SYMBOL(iwl_sensitivity_calibration);
 
+static inline u8 find_first_chain(u8 mask)
+{
+	if (mask & ANT_A)
+		return CHAIN_A;
+	if (mask & ANT_B)
+		return CHAIN_B;
+	return CHAIN_C;
+}
+
 /*
  * Accumulate 20 beacons of signal and noise statistics for each of
  *   3 receivers/antennas/rx-chains, then figure out:
@@ -675,14 +684,17 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv,
 	u8 num_tx_chains;
 	unsigned long flags;
 	struct statistics_rx_non_phy *rx_info = &(stat_resp->rx.general);
+	u8 first_chain;
 
 	if (priv->disable_chain_noise_cal)
 		return;
 
 	data = &(priv->chain_noise_data);
 
-	/* Accumulate just the first 20 beacons after the first association,
-	 *   then we're done forever. */
+	/*
+	 * Accumulate just the first "chain_noise_num_beacons" after
+	 * the first association, then we're done forever.
+	 */
 	if (data->state != IWL_CHAIN_NOISE_ACCUMULATE) {
 		if (data->state == IWL_CHAIN_NOISE_ALIVE)
 			IWL_DEBUG_CALIB(priv, "Wait for noise calib reset\n");
@@ -710,7 +722,10 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv,
 		return;
 	}
 
-	/* Accumulate beacon statistics values across 20 beacons */
+	/*
+	 *  Accumulate beacon statistics values across
+	 * "chain_noise_num_beacons"
+	 */
 	chain_noise_a = le32_to_cpu(rx_info->beacon_silence_rssi_a) &
 				IN_BAND_FILTER;
 	chain_noise_b = le32_to_cpu(rx_info->beacon_silence_rssi_b) &
@@ -741,16 +756,19 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv,
 	IWL_DEBUG_CALIB(priv, "chain_noise: a %d b %d c %d\n",
 			chain_noise_a, chain_noise_b, chain_noise_c);
 
-	/* If this is the 20th beacon, determine:
+	/* If this is the "chain_noise_num_beacons", determine:
 	 * 1)  Disconnected antennas (using signal strengths)
 	 * 2)  Differential gain (using silence noise) to balance receivers */
-	if (data->beacon_count != CAL_NUM_OF_BEACONS)
+	if (data->beacon_count != priv->cfg->chain_noise_num_beacons)
 		return;
 
 	/* Analyze signal for disconnected antenna */
-	average_sig[0] = (data->chain_signal_a) / CAL_NUM_OF_BEACONS;
-	average_sig[1] = (data->chain_signal_b) / CAL_NUM_OF_BEACONS;
-	average_sig[2] = (data->chain_signal_c) / CAL_NUM_OF_BEACONS;
+	average_sig[0] =
+		(data->chain_signal_a) / priv->cfg->chain_noise_num_beacons;
+	average_sig[1] =
+		(data->chain_signal_b) / priv->cfg->chain_noise_num_beacons;
+	average_sig[2] =
+		(data->chain_signal_c) / priv->cfg->chain_noise_num_beacons;
 
 	if (average_sig[0] >= average_sig[1]) {
 		max_average_sig = average_sig[0];
@@ -803,13 +821,17 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv,
 			/* there is a Tx antenna connected */
 			break;
 		if (num_tx_chains == priv->hw_params.tx_chains_num &&
-		data->disconn_array[i]) {
-			/* This is the last TX antenna and is also
-			 * disconnected connect it anyway */
-			data->disconn_array[i] = 0;
-			active_chains |= ant_msk;
-			IWL_DEBUG_CALIB(priv, "All Tx chains are disconnected W/A - "
-				"declare %d as connected\n", i);
+		    data->disconn_array[i]) {
+			/*
+			 * If all chains are disconnected
+			 * connect the first valid tx chain
+			 */
+			first_chain =
+				find_first_chain(priv->cfg->valid_tx_ant);
+			data->disconn_array[first_chain] = 0;
+			active_chains |= BIT(first_chain);
+			IWL_DEBUG_CALIB(priv, "All Tx chains are disconnected W/A - declare %d as connected\n",
+					first_chain);
 			break;
 		}
 	}
@@ -820,9 +842,12 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv,
 			active_chains);
 
 	/* Analyze noise for rx balance */
-	average_noise[0] = ((data->chain_noise_a)/CAL_NUM_OF_BEACONS);
-	average_noise[1] = ((data->chain_noise_b)/CAL_NUM_OF_BEACONS);
-	average_noise[2] = ((data->chain_noise_c)/CAL_NUM_OF_BEACONS);
+	average_noise[0] =
+		((data->chain_noise_a) / priv->cfg->chain_noise_num_beacons);
+	average_noise[1] =
+		((data->chain_noise_b) / priv->cfg->chain_noise_num_beacons);
+	average_noise[2] =
+		((data->chain_noise_c) / priv->cfg->chain_noise_num_beacons);
 
 	for (i = 0; i < NUM_RX_CHAINS; i++) {
 		if (!(data->disconn_array[i]) &&
@@ -843,7 +868,8 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv,
 
 	if (priv->cfg->ops->utils->gain_computation)
 		priv->cfg->ops->utils->gain_computation(priv, average_noise,
-			min_average_noise_antenna_i, min_average_noise);
+				min_average_noise_antenna_i, min_average_noise,
+				find_first_chain(priv->cfg->valid_rx_ant));
 
 	/* Some power changes may have been made during the calibration.
 	 * Update and commit the RXON
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index f094cd9..b66bf7b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -98,7 +98,8 @@ struct iwl_hcmd_utils_ops {
 	void (*gain_computation)(struct iwl_priv *priv,
 			u32 *average_noise,
 			u16 min_average_noise_antennat_i,
-			u32 min_average_noise);
+			u32 min_average_noise,
+			u8 default_chain);
 	void (*chain_noise_reset)(struct iwl_priv *priv);
 	void (*rts_tx_cmd_flag)(struct ieee80211_tx_info *info,
 			__le32 *tx_flags);
@@ -218,6 +219,7 @@ struct iwl_mod_params {
  *	to the deviation to achieve the desired led frequency.
  *	The detail algorithm is described in iwl-led.c
  * @use_rts_for_ht: use rts/cts protection for HT traffic
+ * @chain_noise_num_beacons: number of beacons used to compute chain noise
  *
  * We enable the driver to be backward compatible wrt API version. The
  * driver specifies which APIs it supports (with @ucode_api_max being the
@@ -262,6 +264,7 @@ struct iwl_cfg {
 	u16 led_compensation;
 	const bool broken_powersave;
 	bool use_rts_for_ht;
+	int chain_noise_num_beacons;
 };
 
 /***************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 3ea97be..ad99ce7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -743,7 +743,8 @@ struct iwl_dma_ptr {
 
 /* Sensitivity and chain noise calibration */
 #define INITIALIZATION_VALUE		0xFFFF
-#define CAL_NUM_OF_BEACONS		20
+#define IWL4965_CAL_NUM_BEACONS		20
+#define IWL_CAL_NUM_BEACONS		16
 #define MAXIMUM_ALLOWED_PATHLOSS	15
 
 #define CHAIN_NOISE_MAX_DELTA_GAIN_CODE 3
-- 
1.5.6.3

