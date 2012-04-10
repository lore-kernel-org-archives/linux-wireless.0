Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:46192 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754643Ab2DJAuW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2012 20:50:22 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 05/11] iwlwifi: move hw_params into priv
Date: Mon,  9 Apr 2012 17:46:55 -0700
Message-Id: <1334018821-30416-6-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120410_025043_283557_D7E3243B)
In-Reply-To: <1334018821-30416-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334018821-30416-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The hw_params are mostly values that are
derived from the actual hardware config.
As such, while it is possible that MVM
will require similar ones, it makes more
sense -- at least for now -- to put them
into the DVM struct.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c      |   18 ++++----
 drivers/net/wireless/iwlwifi/iwl-2000.c      |   18 ++++----
 drivers/net/wireless/iwlwifi/iwl-5000.c      |   28 ++++++------
 drivers/net/wireless/iwlwifi/iwl-6000.c      |   18 ++++----
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c |   22 +++++-----
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c   |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c    |   56 +++++++++++++-------------
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c   |   12 +++---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c    |    6 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c       |   36 ++++++++--------
 drivers/net/wireless/iwlwifi/iwl-debugfs.c   |   12 +++---
 drivers/net/wireless/iwlwifi/iwl-dev.h       |   33 +++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-eeprom.c    |   24 ++++++------
 drivers/net/wireless/iwlwifi/iwl-mac80211.c  |    6 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c      |    8 ++--
 drivers/net/wireless/iwlwifi/iwl-shared.h    |   34 ----------------
 17 files changed, 168 insertions(+), 169 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 3787f84..b131f9d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -77,8 +77,8 @@
 static void iwl1000_set_ct_threshold(struct iwl_priv *priv)
 {
 	/* want Celsius */
-	hw_params(priv).ct_kill_threshold = CT_KILL_THRESHOLD_LEGACY;
-	hw_params(priv).ct_kill_exit_threshold = CT_KILL_EXIT_THRESHOLD;
+	priv->hw_params.ct_kill_threshold = CT_KILL_THRESHOLD_LEGACY;
+	priv->hw_params.ct_kill_exit_threshold = CT_KILL_EXIT_THRESHOLD;
 }
 
 /* NIC configuration for 1000 series */
@@ -122,20 +122,20 @@ static const struct iwl_sensitivity_ranges iwl1000_sensitivity = {
 
 static void iwl1000_hw_set_hw_params(struct iwl_priv *priv)
 {
-	hw_params(priv).ht40_channel =  BIT(IEEE80211_BAND_2GHZ);
+	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ);
 
-	hw_params(priv).tx_chains_num =
-		num_of_ant(hw_params(priv).valid_tx_ant);
+	priv->hw_params.tx_chains_num =
+		num_of_ant(priv->hw_params.valid_tx_ant);
 	if (cfg(priv)->rx_with_siso_diversity)
-		hw_params(priv).rx_chains_num = 1;
+		priv->hw_params.rx_chains_num = 1;
 	else
-		hw_params(priv).rx_chains_num =
-			num_of_ant(hw_params(priv).valid_rx_ant);
+		priv->hw_params.rx_chains_num =
+			num_of_ant(priv->hw_params.valid_rx_ant);
 
 	iwl1000_set_ct_threshold(priv);
 
 	/* Set initial sensitivity parameters */
-	hw_params(priv).sens = &iwl1000_sensitivity;
+	priv->hw_params.sens = &iwl1000_sensitivity;
 }
 
 static struct iwl_lib_ops iwl1000_lib = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index e1329a1..d4c495e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -77,8 +77,8 @@
 static void iwl2000_set_ct_threshold(struct iwl_priv *priv)
 {
 	/* want Celsius */
-	hw_params(priv).ct_kill_threshold = CT_KILL_THRESHOLD;
-	hw_params(priv).ct_kill_exit_threshold = CT_KILL_EXIT_THRESHOLD;
+	priv->hw_params.ct_kill_threshold = CT_KILL_THRESHOLD;
+	priv->hw_params.ct_kill_exit_threshold = CT_KILL_EXIT_THRESHOLD;
 }
 
 /* NIC configuration for 2000 series */
@@ -116,20 +116,20 @@ static const struct iwl_sensitivity_ranges iwl2000_sensitivity = {
 
 static void iwl2000_hw_set_hw_params(struct iwl_priv *priv)
 {
-	hw_params(priv).ht40_channel =  BIT(IEEE80211_BAND_2GHZ);
+	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ);
 
-	hw_params(priv).tx_chains_num =
-		num_of_ant(hw_params(priv).valid_tx_ant);
+	priv->hw_params.tx_chains_num =
+		num_of_ant(priv->hw_params.valid_tx_ant);
 	if (cfg(priv)->rx_with_siso_diversity)
-		hw_params(priv).rx_chains_num = 1;
+		priv->hw_params.rx_chains_num = 1;
 	else
-		hw_params(priv).rx_chains_num =
-			num_of_ant(hw_params(priv).valid_rx_ant);
+		priv->hw_params.rx_chains_num =
+			num_of_ant(priv->hw_params.valid_rx_ant);
 
 	iwl2000_set_ct_threshold(priv);
 
 	/* Set initial sensitivity parameters */
-	hw_params(priv).sens = &iwl2000_sensitivity;
+	priv->hw_params.sens = &iwl2000_sensitivity;
 }
 
 static struct iwl_lib_ops iwl2000_lib = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 9f379d3..8870370 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -145,45 +145,45 @@ static void iwl5150_set_ct_threshold(struct iwl_priv *priv)
 	s32 threshold = (s32)CELSIUS_TO_KELVIN(CT_KILL_THRESHOLD_LEGACY) -
 			iwl_temp_calib_to_offset(priv->shrd);
 
-	hw_params(priv).ct_kill_threshold = threshold * volt2temp_coef;
+	priv->hw_params.ct_kill_threshold = threshold * volt2temp_coef;
 }
 
 static void iwl5000_set_ct_threshold(struct iwl_priv *priv)
 {
 	/* want Celsius */
-	hw_params(priv).ct_kill_threshold = CT_KILL_THRESHOLD_LEGACY;
+	priv->hw_params.ct_kill_threshold = CT_KILL_THRESHOLD_LEGACY;
 }
 
 static void iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 {
-	hw_params(priv).ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
+	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
 					BIT(IEEE80211_BAND_5GHZ);
 
-	hw_params(priv).tx_chains_num =
-		num_of_ant(hw_params(priv).valid_tx_ant);
-	hw_params(priv).rx_chains_num =
-		num_of_ant(hw_params(priv).valid_rx_ant);
+	priv->hw_params.tx_chains_num =
+		num_of_ant(priv->hw_params.valid_tx_ant);
+	priv->hw_params.rx_chains_num =
+		num_of_ant(priv->hw_params.valid_rx_ant);
 
 	iwl5000_set_ct_threshold(priv);
 
 	/* Set initial sensitivity parameters */
-	hw_params(priv).sens = &iwl5000_sensitivity;
+	priv->hw_params.sens = &iwl5000_sensitivity;
 }
 
 static void iwl5150_hw_set_hw_params(struct iwl_priv *priv)
 {
-	hw_params(priv).ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
+	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
 					BIT(IEEE80211_BAND_5GHZ);
 
-	hw_params(priv).tx_chains_num =
-		num_of_ant(hw_params(priv).valid_tx_ant);
-	hw_params(priv).rx_chains_num =
-		num_of_ant(hw_params(priv).valid_rx_ant);
+	priv->hw_params.tx_chains_num =
+		num_of_ant(priv->hw_params.valid_tx_ant);
+	priv->hw_params.rx_chains_num =
+		num_of_ant(priv->hw_params.valid_rx_ant);
 
 	iwl5150_set_ct_threshold(priv);
 
 	/* Set initial sensitivity parameters */
-	hw_params(priv).sens = &iwl5150_sensitivity;
+	priv->hw_params.sens = &iwl5150_sensitivity;
 }
 
 static void iwl5150_temperature(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 7075570..dc07560 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -74,8 +74,8 @@
 static void iwl6000_set_ct_threshold(struct iwl_priv *priv)
 {
 	/* want Celsius */
-	hw_params(priv).ct_kill_threshold = CT_KILL_THRESHOLD;
-	hw_params(priv).ct_kill_exit_threshold = CT_KILL_EXIT_THRESHOLD;
+	priv->hw_params.ct_kill_threshold = CT_KILL_THRESHOLD;
+	priv->hw_params.ct_kill_exit_threshold = CT_KILL_EXIT_THRESHOLD;
 }
 
 static void iwl6050_additional_nic_config(struct iwl_priv *priv)
@@ -139,21 +139,21 @@ static const struct iwl_sensitivity_ranges iwl6000_sensitivity = {
 
 static void iwl6000_hw_set_hw_params(struct iwl_priv *priv)
 {
-	hw_params(priv).ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
+	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
 					BIT(IEEE80211_BAND_5GHZ);
 
-	hw_params(priv).tx_chains_num =
-		num_of_ant(hw_params(priv).valid_tx_ant);
+	priv->hw_params.tx_chains_num =
+		num_of_ant(priv->hw_params.valid_tx_ant);
 	if (cfg(priv)->rx_with_siso_diversity)
-		hw_params(priv).rx_chains_num = 1;
+		priv->hw_params.rx_chains_num = 1;
 	else
-		hw_params(priv).rx_chains_num =
-			num_of_ant(hw_params(priv).valid_rx_ant);
+		priv->hw_params.rx_chains_num =
+			num_of_ant(priv->hw_params.valid_rx_ant);
 
 	iwl6000_set_ct_threshold(priv);
 
 	/* Set initial sensitivity parameters */
-	hw_params(priv).sens = &iwl6000_sensitivity;
+	priv->hw_params.sens = &iwl6000_sensitivity;
 
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
index 84cbe7b..2f73109 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
@@ -190,7 +190,7 @@ static int iwl_sens_energy_cck(struct iwl_priv *priv,
 	u32 max_false_alarms = MAX_FA_CCK * rx_enable_time;
 	u32 min_false_alarms = MIN_FA_CCK * rx_enable_time;
 	struct iwl_sensitivity_data *data = NULL;
-	const struct iwl_sensitivity_ranges *ranges = hw_params(priv).sens;
+	const struct iwl_sensitivity_ranges *ranges = priv->hw_params.sens;
 
 	data = &(priv->sensitivity_data);
 
@@ -373,7 +373,7 @@ static int iwl_sens_auto_corr_ofdm(struct iwl_priv *priv,
 	u32 max_false_alarms = MAX_FA_OFDM * rx_enable_time;
 	u32 min_false_alarms = MIN_FA_OFDM * rx_enable_time;
 	struct iwl_sensitivity_data *data = NULL;
-	const struct iwl_sensitivity_ranges *ranges = hw_params(priv).sens;
+	const struct iwl_sensitivity_ranges *ranges = priv->hw_params.sens;
 
 	data = &(priv->sensitivity_data);
 
@@ -597,7 +597,7 @@ void iwl_init_sensitivity(struct iwl_priv *priv)
 	int ret = 0;
 	int i;
 	struct iwl_sensitivity_data *data = NULL;
-	const struct iwl_sensitivity_ranges *ranges = hw_params(priv).sens;
+	const struct iwl_sensitivity_ranges *ranges = priv->hw_params.sens;
 
 	if (priv->disable_sens_cal)
 		return;
@@ -833,28 +833,28 @@ static void iwl_find_disconn_antenna(struct iwl_priv *priv, u32* average_sig,
 	 * To be safe, simply mask out any chains that we know
 	 * are not on the device.
 	 */
-	active_chains &= hw_params(priv).valid_rx_ant;
+	active_chains &= priv->hw_params.valid_rx_ant;
 
 	num_tx_chains = 0;
 	for (i = 0; i < NUM_RX_CHAINS; i++) {
 		/* loops on all the bits of
 		 * priv->hw_setting.valid_tx_ant */
 		u8 ant_msk = (1 << i);
-		if (!(hw_params(priv).valid_tx_ant & ant_msk))
+		if (!(priv->hw_params.valid_tx_ant & ant_msk))
 			continue;
 
 		num_tx_chains++;
 		if (data->disconn_array[i] == 0)
 			/* there is a Tx antenna connected */
 			break;
-		if (num_tx_chains == hw_params(priv).tx_chains_num &&
+		if (num_tx_chains == priv->hw_params.tx_chains_num &&
 		    data->disconn_array[i]) {
 			/*
 			 * If all chains are disconnected
 			 * connect the first valid tx chain
 			 */
 			first_chain =
-				find_first_chain(hw_params(priv).valid_tx_ant);
+				find_first_chain(priv->hw_params.valid_tx_ant);
 			data->disconn_array[first_chain] = 0;
 			active_chains |= BIT(first_chain);
 			IWL_DEBUG_CALIB(priv,
@@ -864,13 +864,13 @@ static void iwl_find_disconn_antenna(struct iwl_priv *priv, u32* average_sig,
 		}
 	}
 
-	if (active_chains != hw_params(priv).valid_rx_ant &&
+	if (active_chains != priv->hw_params.valid_rx_ant &&
 	    active_chains != priv->chain_noise_data.active_chains)
 		IWL_DEBUG_CALIB(priv,
 				"Detected that not all antennas are connected! "
 				"Connected: %#x, valid: %#x.\n",
 				active_chains,
-				hw_params(priv).valid_rx_ant);
+				priv->hw_params.valid_rx_ant);
 
 	/* Save for use within RXON, TX, SCAN commands, etc. */
 	data->active_chains = active_chains;
@@ -1055,7 +1055,7 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv)
 	    cfg(priv)->bt_params->advanced_bt_coexist) {
 		/* Disable disconnected antenna algorithm for advanced
 		   bt coex, assuming valid antennas are connected */
-		data->active_chains = hw_params(priv).valid_rx_ant;
+		data->active_chains = priv->hw_params.valid_rx_ant;
 		for (i = 0; i < NUM_RX_CHAINS; i++)
 			if (!(data->active_chains & (1<<i)))
 				data->disconn_array[i] = 1;
@@ -1085,7 +1085,7 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv)
 			min_average_noise, min_average_noise_antenna_i);
 
 	iwlagn_gain_computation(priv, average_noise,
-				find_first_chain(hw_params(priv).valid_rx_ant));
+				find_first_chain(priv->hw_params.valid_rx_ant));
 
 	/* Some power changes may have been made during the calibration.
 	 * Update and commit the RXON
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index fae15c0..fb6fe7f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -234,7 +234,7 @@ int iwlagn_txfifo_flush(struct iwl_priv *priv, u16 flush_control)
 				IWL_PAN_SCD_BK_MSK | IWL_PAN_SCD_MGMT_MSK |
 				IWL_PAN_SCD_MULTICAST_MSK;
 
-	if (hw_params(priv).sku & EEPROM_SKU_CAP_11N_ENABLE)
+	if (priv->hw_params.sku & EEPROM_SKU_CAP_11N_ENABLE)
 		flush_cmd.fifo_control |= IWL_AGG_TX_QUEUE_MSK;
 
 	IWL_DEBUG_INFO(priv, "fifo queue control: 0X%x\n",
@@ -868,7 +868,7 @@ void iwlagn_set_rxon_chain(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	if (priv->chain_noise_data.active_chains)
 		active_chains = priv->chain_noise_data.active_chains;
 	else
-		active_chains = hw_params(priv).valid_rx_ant;
+		active_chains = priv->hw_params.valid_rx_ant;
 
 	if (cfg(priv)->bt_params &&
 	    cfg(priv)->bt_params->advanced_bt_coexist &&
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 2343412..0dd6d5c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -819,7 +819,7 @@ static u32 rs_get_lower_rate(struct iwl_lq_sta *lq_sta,
 
 		if (num_of_ant(tbl->ant_type) > 1)
 			tbl->ant_type =
-			    first_antenna(hw_params(priv).valid_tx_ant);
+			    first_antenna(priv->hw_params.valid_tx_ant);
 
 		tbl->is_ht40 = 0;
 		tbl->is_SGI = 0;
@@ -1291,7 +1291,7 @@ static int rs_switch_to_mimo2(struct iwl_priv *priv,
 		return -1;
 
 	/* Need both Tx chains/antennas to support MIMO */
-	if (hw_params(priv).tx_chains_num < 2)
+	if (priv->hw_params.tx_chains_num < 2)
 		return -1;
 
 	IWL_DEBUG_RATE(priv, "LQ: try to switch to MIMO2\n");
@@ -1347,7 +1347,7 @@ static int rs_switch_to_mimo3(struct iwl_priv *priv,
 		return -1;
 
 	/* Need both Tx chains/antennas to support MIMO */
-	if (hw_params(priv).tx_chains_num < 3)
+	if (priv->hw_params.tx_chains_num < 3)
 		return -1;
 
 	IWL_DEBUG_RATE(priv, "LQ: try to switch to MIMO3\n");
@@ -1446,8 +1446,8 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 	u32 sz = (sizeof(struct iwl_scale_tbl_info) -
 		  (sizeof(struct iwl_rate_scale_data) * IWL_RATE_COUNT));
 	u8 start_action;
-	u8 valid_tx_ant = hw_params(priv).valid_tx_ant;
-	u8 tx_chains_num = hw_params(priv).tx_chains_num;
+	u8 valid_tx_ant = priv->hw_params.valid_tx_ant;
+	u8 tx_chains_num = priv->hw_params.tx_chains_num;
 	int ret = 0;
 	u8 update_search_tbl_counter = 0;
 
@@ -1464,7 +1464,7 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 	case IWL_BT_COEX_TRAFFIC_LOAD_CONTINUOUS:
 		/* avoid antenna B and MIMO */
 		valid_tx_ant =
-			first_antenna(hw_params(priv).valid_tx_ant);
+			first_antenna(priv->hw_params.valid_tx_ant);
 		if (tbl->action >= IWL_LEGACY_SWITCH_ANTENNA2 &&
 		    tbl->action != IWL_LEGACY_SWITCH_SISO)
 			tbl->action = IWL_LEGACY_SWITCH_SISO;
@@ -1488,7 +1488,7 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 		else if (tbl->action >= IWL_LEGACY_SWITCH_ANTENNA2)
 			tbl->action = IWL_LEGACY_SWITCH_SISO;
 		valid_tx_ant =
-			first_antenna(hw_params(priv).valid_tx_ant);
+			first_antenna(priv->hw_params.valid_tx_ant);
 	}
 
 	start_action = tbl->action;
@@ -1622,8 +1622,8 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 	u32 sz = (sizeof(struct iwl_scale_tbl_info) -
 		  (sizeof(struct iwl_rate_scale_data) * IWL_RATE_COUNT));
 	u8 start_action;
-	u8 valid_tx_ant = hw_params(priv).valid_tx_ant;
-	u8 tx_chains_num = hw_params(priv).tx_chains_num;
+	u8 valid_tx_ant = priv->hw_params.valid_tx_ant;
+	u8 tx_chains_num = priv->hw_params.tx_chains_num;
 	u8 update_search_tbl_counter = 0;
 	int ret;
 
@@ -1640,7 +1640,7 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 	case IWL_BT_COEX_TRAFFIC_LOAD_CONTINUOUS:
 		/* avoid antenna B and MIMO */
 		valid_tx_ant =
-			first_antenna(hw_params(priv).valid_tx_ant);
+			first_antenna(priv->hw_params.valid_tx_ant);
 		if (tbl->action != IWL_SISO_SWITCH_ANTENNA1)
 			tbl->action = IWL_SISO_SWITCH_ANTENNA1;
 		break;
@@ -1658,7 +1658,7 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 	/* configure as 1x1 if bt full concurrency */
 	if (priv->bt_full_concurrent) {
 		valid_tx_ant =
-			first_antenna(hw_params(priv).valid_tx_ant);
+			first_antenna(priv->hw_params.valid_tx_ant);
 		if (tbl->action >= IWL_LEGACY_SWITCH_ANTENNA2)
 			tbl->action = IWL_SISO_SWITCH_ANTENNA1;
 	}
@@ -1794,8 +1794,8 @@ static int rs_move_mimo2_to_other(struct iwl_priv *priv,
 	u32 sz = (sizeof(struct iwl_scale_tbl_info) -
 		  (sizeof(struct iwl_rate_scale_data) * IWL_RATE_COUNT));
 	u8 start_action;
-	u8 valid_tx_ant = hw_params(priv).valid_tx_ant;
-	u8 tx_chains_num = hw_params(priv).tx_chains_num;
+	u8 valid_tx_ant = priv->hw_params.valid_tx_ant;
+	u8 tx_chains_num = priv->hw_params.tx_chains_num;
 	u8 update_search_tbl_counter = 0;
 	int ret;
 
@@ -1964,8 +1964,8 @@ static int rs_move_mimo3_to_other(struct iwl_priv *priv,
 	u32 sz = (sizeof(struct iwl_scale_tbl_info) -
 		  (sizeof(struct iwl_rate_scale_data) * IWL_RATE_COUNT));
 	u8 start_action;
-	u8 valid_tx_ant = hw_params(priv).valid_tx_ant;
-	u8 tx_chains_num = hw_params(priv).tx_chains_num;
+	u8 valid_tx_ant = priv->hw_params.valid_tx_ant;
+	u8 tx_chains_num = priv->hw_params.tx_chains_num;
 	int ret;
 	u8 update_search_tbl_counter = 0;
 
@@ -2698,7 +2698,7 @@ static void rs_initialize_lq(struct iwl_priv *priv,
 
 	i = lq_sta->last_txrate_idx;
 
-	valid_tx_ant = hw_params(priv).valid_tx_ant;
+	valid_tx_ant = priv->hw_params.valid_tx_ant;
 
 	if (!lq_sta->search_better_tbl)
 		active_tbl = lq_sta->active_tbl;
@@ -2884,15 +2884,15 @@ void iwl_rs_rate_init(struct iwl_priv *priv, struct ieee80211_sta *sta, u8 sta_i
 
 	/* These values will be overridden later */
 	lq_sta->lq.general_params.single_stream_ant_msk =
-		first_antenna(hw_params(priv).valid_tx_ant);
+		first_antenna(priv->hw_params.valid_tx_ant);
 	lq_sta->lq.general_params.dual_stream_ant_msk =
-		hw_params(priv).valid_tx_ant &
-		~first_antenna(hw_params(priv).valid_tx_ant);
+		priv->hw_params.valid_tx_ant &
+		~first_antenna(priv->hw_params.valid_tx_ant);
 	if (!lq_sta->lq.general_params.dual_stream_ant_msk) {
 		lq_sta->lq.general_params.dual_stream_ant_msk = ANT_AB;
-	} else if (num_of_ant(hw_params(priv).valid_tx_ant) == 2) {
+	} else if (num_of_ant(priv->hw_params.valid_tx_ant) == 2) {
 		lq_sta->lq.general_params.dual_stream_ant_msk =
-			hw_params(priv).valid_tx_ant;
+			priv->hw_params.valid_tx_ant;
 	}
 
 	/* as default allow aggregation for all tids */
@@ -2938,7 +2938,7 @@ static void rs_fill_link_cmd(struct iwl_priv *priv,
 	if (priv && priv->bt_full_concurrent) {
 		/* 1x1 only */
 		tbl_type.ant_type =
-			first_antenna(hw_params(priv).valid_tx_ant);
+			first_antenna(priv->hw_params.valid_tx_ant);
 	}
 
 	/* How many times should we repeat the initial rate? */
@@ -2970,7 +2970,7 @@ static void rs_fill_link_cmd(struct iwl_priv *priv,
 		if (priv->bt_full_concurrent)
 			valid_tx_ant = ANT_A;
 		else
-			valid_tx_ant = hw_params(priv).valid_tx_ant;
+			valid_tx_ant = priv->hw_params.valid_tx_ant;
 	}
 
 	/* Fill rest of rate table */
@@ -3004,7 +3004,7 @@ static void rs_fill_link_cmd(struct iwl_priv *priv,
 		if (priv && priv->bt_full_concurrent) {
 			/* 1x1 only */
 			tbl_type.ant_type =
-			    first_antenna(hw_params(priv).valid_tx_ant);
+			    first_antenna(priv->hw_params.valid_tx_ant);
 		}
 
 		/* Indicate to uCode which entries might be MIMO.
@@ -3096,7 +3096,7 @@ static void rs_dbgfs_set_mcs(struct iwl_lq_sta *lq_sta,
 	u8 ant_sel_tx;
 
 	priv = lq_sta->drv;
-	valid_tx_ant = hw_params(priv).valid_tx_ant;
+	valid_tx_ant = priv->hw_params.valid_tx_ant;
 	if (lq_sta->dbg_fixed_rate) {
 		ant_sel_tx =
 		  ((lq_sta->dbg_fixed_rate & RATE_MCS_ANT_ABC_MSK)
@@ -3167,9 +3167,9 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 	desc += sprintf(buff+desc, "fixed rate 0x%X\n",
 			lq_sta->dbg_fixed_rate);
 	desc += sprintf(buff+desc, "valid_tx_ant %s%s%s\n",
-	    (hw_params(priv).valid_tx_ant & ANT_A) ? "ANT_A," : "",
-	    (hw_params(priv).valid_tx_ant & ANT_B) ? "ANT_B," : "",
-	    (hw_params(priv).valid_tx_ant & ANT_C) ? "ANT_C" : "");
+	    (priv->hw_params.valid_tx_ant & ANT_A) ? "ANT_A," : "",
+	    (priv->hw_params.valid_tx_ant & ANT_B) ? "ANT_B," : "",
+	    (priv->hw_params.valid_tx_ant & ANT_C) ? "ANT_C" : "");
 	desc += sprintf(buff+desc, "lq type %s\n",
 	   (is_legacy(tbl->lq_type)) ? "legacy" : "HT");
 	if (is_Ht(tbl->lq_type)) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 73d8ab4..094b318 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -692,7 +692,7 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	 * force CTS-to-self frames protection if RTS-CTS is not preferred
 	 * one aggregation protection method
 	 */
-	if (!hw_params(priv).use_rts_for_aggregation)
+	if (!priv->hw_params.use_rts_for_aggregation)
 		ctx->staging.flags |= RXON_FLG_SELF_CTS_EN;
 
 	if ((ctx->vif && ctx->vif->bss_conf.use_short_slot) ||
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index c417560..b74bb68 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -864,23 +864,23 @@ void iwl_sta_fill_lq(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 	if (r >= IWL_FIRST_CCK_RATE && r <= IWL_LAST_CCK_RATE)
 		rate_flags |= RATE_MCS_CCK_MSK;
 
-	rate_flags |= first_antenna(hw_params(priv).valid_tx_ant) <<
+	rate_flags |= first_antenna(priv->hw_params.valid_tx_ant) <<
 				RATE_MCS_ANT_POS;
 	rate_n_flags = iwl_hw_set_rate_n_flags(iwl_rates[r].plcp, rate_flags);
 	for (i = 0; i < LINK_QUAL_MAX_RETRY_NUM; i++)
 		link_cmd->rs_table[i].rate_n_flags = rate_n_flags;
 
 	link_cmd->general_params.single_stream_ant_msk =
-			first_antenna(hw_params(priv).valid_tx_ant);
+			first_antenna(priv->hw_params.valid_tx_ant);
 
 	link_cmd->general_params.dual_stream_ant_msk =
-		hw_params(priv).valid_tx_ant &
-		~first_antenna(hw_params(priv).valid_tx_ant);
+		priv->hw_params.valid_tx_ant &
+		~first_antenna(priv->hw_params.valid_tx_ant);
 	if (!link_cmd->general_params.dual_stream_ant_msk) {
 		link_cmd->general_params.dual_stream_ant_msk = ANT_AB;
-	} else if (num_of_ant(hw_params(priv).valid_tx_ant) == 2) {
+	} else if (num_of_ant(priv->hw_params.valid_tx_ant) == 2) {
 		link_cmd->general_params.dual_stream_ant_msk =
-			hw_params(priv).valid_tx_ant;
+			priv->hw_params.valid_tx_ant;
 	}
 
 	link_cmd->agg_params.agg_dis_start_th =
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 07563a6..975ad74 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -208,10 +208,10 @@ static void iwlagn_tx_cmd_build_rate(struct iwl_priv *priv,
 	     priv->bt_full_concurrent) {
 		/* operated as 1x1 in full concurrency mode */
 		priv->mgmt_tx_ant = iwl_toggle_tx_ant(priv, priv->mgmt_tx_ant,
-				first_antenna(hw_params(priv).valid_tx_ant));
+				first_antenna(priv->hw_params.valid_tx_ant));
 	} else
 		priv->mgmt_tx_ant = iwl_toggle_tx_ant(priv, priv->mgmt_tx_ant,
-						hw_params(priv).valid_tx_ant);
+						priv->hw_params.valid_tx_ant);
 	rate_flags |= iwl_ant_idx_to_flags(priv->mgmt_tx_ant);
 
 	/* Set the rate in the TX cmd */
@@ -689,7 +689,7 @@ int iwlagn_tx_agg_oper(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	sta_priv->max_agg_bufsize =
 		min(sta_priv->max_agg_bufsize, buf_size);
 
-	if (hw_params(priv).use_rts_for_aggregation) {
+	if (priv->hw_params.use_rts_for_aggregation) {
 		/*
 		 * switch to RTS/CTS if it is the prefer protection
 		 * method for HT traffic
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 5971fc6..2818148 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -177,7 +177,7 @@ int iwlagn_send_beacon_cmd(struct iwl_priv *priv)
 		rate = info->control.rates[0].idx;
 
 	priv->mgmt_tx_ant = iwl_toggle_tx_ant(priv, priv->mgmt_tx_ant,
-					      hw_params(priv).valid_tx_ant);
+					      priv->hw_params.valid_tx_ant);
 	rate_flags = iwl_ant_idx_to_flags(priv->mgmt_tx_ant);
 
 	/* In mac80211, rates for 5 GHz start at 0 */
@@ -655,9 +655,9 @@ static void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 
 	if (cfg(priv)->base_params->support_ct_kill_exit) {
 		adv_cmd.critical_temperature_enter =
-			cpu_to_le32(hw_params(priv).ct_kill_threshold);
+			cpu_to_le32(priv->hw_params.ct_kill_threshold);
 		adv_cmd.critical_temperature_exit =
-			cpu_to_le32(hw_params(priv).ct_kill_exit_threshold);
+			cpu_to_le32(priv->hw_params.ct_kill_exit_threshold);
 
 		ret = iwl_dvm_send_cmd_pdu(priv,
 				       REPLY_CT_KILL_CONFIG_CMD,
@@ -668,11 +668,11 @@ static void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 			IWL_DEBUG_INFO(priv, "REPLY_CT_KILL_CONFIG_CMD "
 				"succeeded, critical temperature enter is %d,"
 				"exit is %d\n",
-				hw_params(priv).ct_kill_threshold,
-				hw_params(priv).ct_kill_exit_threshold);
+				priv->hw_params.ct_kill_threshold,
+				priv->hw_params.ct_kill_exit_threshold);
 	} else {
 		cmd.critical_temperature_R =
-			cpu_to_le32(hw_params(priv).ct_kill_threshold);
+			cpu_to_le32(priv->hw_params.ct_kill_threshold);
 
 		ret = iwl_dvm_send_cmd_pdu(priv,
 				       REPLY_CT_KILL_CONFIG_CMD,
@@ -683,7 +683,7 @@ static void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 			IWL_DEBUG_INFO(priv, "REPLY_CT_KILL_CONFIG_CMD "
 				"succeeded, "
 				"critical temperature is %d\n",
-				hw_params(priv).ct_kill_threshold);
+				priv->hw_params.ct_kill_threshold);
 	}
 }
 
@@ -790,7 +790,7 @@ int iwl_alive_start(struct iwl_priv *priv)
 	priv->active_rate = IWL_RATES_MASK;
 
 	/* Configure Tx antenna selection based on H/W config */
-	iwlagn_send_tx_ant_config(priv, hw_params(priv).valid_tx_ant);
+	iwlagn_send_tx_ant_config(priv, priv->hw_params.valid_tx_ant);
 
 	if (iwl_is_associated_ctx(ctx) && !priv->wowlan) {
 		struct iwl_rxon_cmd *active_rxon =
@@ -1129,8 +1129,8 @@ static void iwl_init_ht_hw_capab(const struct iwl_priv *priv,
 			      enum ieee80211_band band)
 {
 	u16 max_bit_rate = 0;
-	u8 rx_chains_num = hw_params(priv).rx_chains_num;
-	u8 tx_chains_num = hw_params(priv).tx_chains_num;
+	u8 rx_chains_num = priv->hw_params.rx_chains_num;
+	u8 tx_chains_num = priv->hw_params.tx_chains_num;
 
 	ht_info->cap = 0;
 	memset(&ht_info->mcs, 0, sizeof(ht_info->mcs));
@@ -1142,7 +1142,7 @@ static void iwl_init_ht_hw_capab(const struct iwl_priv *priv,
 		ht_info->cap |= IEEE80211_HT_CAP_GRN_FLD;
 	ht_info->cap |= IEEE80211_HT_CAP_SGI_20;
 	max_bit_rate = MAX_BIT_RATE_20_MHZ;
-	if (hw_params(priv).ht40_channel & BIT(band)) {
+	if (priv->hw_params.ht40_channel & BIT(band)) {
 		ht_info->cap |= IEEE80211_HT_CAP_SUP_WIDTH_20_40;
 		ht_info->cap |= IEEE80211_HT_CAP_SGI_40;
 		ht_info->mcs.rx_mask[4] = 0x01;
@@ -1214,7 +1214,7 @@ static int iwl_init_geos(struct iwl_priv *priv)
 	sband->bitrates = &rates[IWL_FIRST_OFDM_RATE];
 	sband->n_bitrates = IWL_RATE_COUNT_LEGACY - IWL_FIRST_OFDM_RATE;
 
-	if (hw_params(priv).sku & EEPROM_SKU_CAP_11N_ENABLE)
+	if (priv->hw_params.sku & EEPROM_SKU_CAP_11N_ENABLE)
 		iwl_init_ht_hw_capab(priv, &sband->ht_cap,
 					 IEEE80211_BAND_5GHZ);
 
@@ -1224,7 +1224,7 @@ static int iwl_init_geos(struct iwl_priv *priv)
 	sband->bitrates = rates;
 	sband->n_bitrates = IWL_RATE_COUNT_LEGACY;
 
-	if (hw_params(priv).sku & EEPROM_SKU_CAP_11N_ENABLE)
+	if (priv->hw_params.sku & EEPROM_SKU_CAP_11N_ENABLE)
 		iwl_init_ht_hw_capab(priv, &sband->ht_cap,
 					 IEEE80211_BAND_2GHZ);
 
@@ -1279,11 +1279,11 @@ static int iwl_init_geos(struct iwl_priv *priv)
 	priv->tx_power_next = max_tx_power;
 
 	if ((priv->bands[IEEE80211_BAND_5GHZ].n_channels == 0) &&
-	     hw_params(priv).sku & EEPROM_SKU_CAP_BAND_52GHZ) {
+	     priv->hw_params.sku & EEPROM_SKU_CAP_BAND_52GHZ) {
 		IWL_INFO(priv, "Incorrectly detected BG card as ABG. "
 			"Please send your %s to maintainer.\n",
 			trans(priv)->hw_id_str);
-		hw_params(priv).sku &= ~EEPROM_SKU_CAP_BAND_52GHZ;
+		priv->hw_params.sku &= ~EEPROM_SKU_CAP_BAND_52GHZ;
 	}
 
 	IWL_INFO(priv, "Tunable channels: %d 802.11bg, %d 802.11a channels\n",
@@ -1390,11 +1390,11 @@ static void iwl_uninit_drv(struct iwl_priv *priv)
 static void iwl_set_hw_params(struct iwl_priv *priv)
 {
 	if (cfg(priv)->ht_params)
-		hw_params(priv).use_rts_for_aggregation =
+		priv->hw_params.use_rts_for_aggregation =
 			cfg(priv)->ht_params->use_rts_for_aggregation;
 
 	if (iwlagn_mod_params.disable_11n & IWL_DISABLE_HT_ALL)
-		hw_params(priv).sku &= ~EEPROM_SKU_CAP_11N_ENABLE;
+		priv->hw_params.sku &= ~EEPROM_SKU_CAP_11N_ENABLE;
 
 	/* Device-specific setup */
 	cfg(priv)->lib->set_hw_params(priv);
@@ -1588,7 +1588,7 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	 ************************/
 	iwl_set_hw_params(priv);
 
-	if (!(hw_params(priv).sku & EEPROM_SKU_CAP_IPAN_ENABLE)) {
+	if (!(priv->hw_params.sku & EEPROM_SKU_CAP_IPAN_ENABLE)) {
 		IWL_DEBUG_INFO(priv, "Your EEPROM disabled PAN");
 		ucode_flags &= ~IWL_UCODE_TLV_FLAGS_PAN;
 		/*
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index a7df9de..fceb4e5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -1547,17 +1547,17 @@ static ssize_t iwl_dbgfs_ucode_tx_stats_read(struct file *file,
 	if (tx->tx_power.ant_a || tx->tx_power.ant_b || tx->tx_power.ant_c) {
 		pos += scnprintf(buf + pos, bufsz - pos,
 			"tx power: (1/2 dB step)\n");
-		if ((hw_params(priv).valid_tx_ant & ANT_A) &&
+		if ((priv->hw_params.valid_tx_ant & ANT_A) &&
 		    tx->tx_power.ant_a)
 			pos += scnprintf(buf + pos, bufsz - pos,
 					fmt_hex, "antenna A:",
 					tx->tx_power.ant_a);
-		if ((hw_params(priv).valid_tx_ant & ANT_B) &&
+		if ((priv->hw_params.valid_tx_ant & ANT_B) &&
 		    tx->tx_power.ant_b)
 			pos += scnprintf(buf + pos, bufsz - pos,
 					fmt_hex, "antenna B:",
 					tx->tx_power.ant_b);
-		if ((hw_params(priv).valid_tx_ant & ANT_C) &&
+		if ((priv->hw_params.valid_tx_ant & ANT_C) &&
 		    tx->tx_power.ant_c)
 			pos += scnprintf(buf + pos, bufsz - pos,
 					fmt_hex, "antenna C:",
@@ -2411,7 +2411,7 @@ static ssize_t iwl_dbgfs_protection_mode_read(struct file *file,
 	if (cfg(priv)->ht_params)
 		pos += scnprintf(buf + pos, bufsz - pos,
 			 "use %s for aggregation\n",
-			 (hw_params(priv).use_rts_for_aggregation) ?
+			 (priv->hw_params.use_rts_for_aggregation) ?
 				"rts/cts" : "cts-to-self");
 	else
 		pos += scnprintf(buf + pos, bufsz - pos, "N/A");
@@ -2438,9 +2438,9 @@ static ssize_t iwl_dbgfs_protection_mode_write(struct file *file,
 	if (sscanf(buf, "%d", &rts) != 1)
 		return -EINVAL;
 	if (rts)
-		hw_params(priv).use_rts_for_aggregation = true;
+		priv->hw_params.use_rts_for_aggregation = true;
 	else
-		hw_params(priv).use_rts_for_aggregation = false;
+		priv->hw_params.use_rts_for_aggregation = false;
 	return count;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 780bcf3..caaf14c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -681,6 +681,37 @@ enum iwl_scan_type {
 	IWL_SCAN_ROC,
 };
 
+/**
+ * struct iwl_hw_params
+ *
+ * Holds the module parameters
+ *
+ * @tx_chains_num: Number of TX chains
+ * @rx_chains_num: Number of RX chains
+ * @valid_tx_ant: usable antennas for TX
+ * @valid_rx_ant: usable antennas for RX
+ * @ht40_channel: is 40MHz width possible: BIT(IEEE80211_BAND_XXX)
+ * @sku: sku read from EEPROM
+ * @ct_kill_threshold: temperature threshold - in hw dependent unit
+ * @ct_kill_exit_threshold: when to reeable the device - in hw dependent unit
+ *	relevant for 1000, 6000 and up
+ * @struct iwl_sensitivity_ranges: range of sensitivity values
+ * @use_rts_for_aggregation: use rts/cts protection for HT traffic
+ */
+struct iwl_hw_params {
+	u8  tx_chains_num;
+	u8  rx_chains_num;
+	u8  valid_tx_ant;
+	u8  valid_rx_ant;
+	u8  ht40_channel;
+	bool use_rts_for_aggregation;
+	u16 sku;
+	u32 ct_kill_threshold;
+	u32 ct_kill_exit_threshold;
+
+	const struct iwl_sensitivity_ranges *sens;
+};
+
 #ifdef CONFIG_IWLWIFI_DEVICE_TESTMODE
 struct iwl_testmode_trace {
 	u32 buff_size;
@@ -739,6 +770,8 @@ struct iwl_priv {
 
 	struct workqueue_struct *workqueue;
 
+	struct iwl_hw_params hw_params;
+
 	enum ieee80211_band band;
 	u8 valid_contexts;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 23cea42..12744b0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -258,40 +258,40 @@ int iwl_eeprom_init_hw_params(struct iwl_priv *priv)
 	struct iwl_shared *shrd = priv->shrd;
 	u16 radio_cfg;
 
-	hw_params(priv).sku = iwl_eeprom_query16(shrd, EEPROM_SKU_CAP);
-	if (hw_params(priv).sku & EEPROM_SKU_CAP_11N_ENABLE &&
+	priv->hw_params.sku = iwl_eeprom_query16(shrd, EEPROM_SKU_CAP);
+	if (priv->hw_params.sku & EEPROM_SKU_CAP_11N_ENABLE &&
 	    !cfg(priv)->ht_params) {
 		IWL_ERR(priv, "Invalid 11n configuration\n");
 		return -EINVAL;
 	}
 
-	if (!hw_params(priv).sku) {
+	if (!priv->hw_params.sku) {
 		IWL_ERR(priv, "Invalid device sku\n");
 		return -EINVAL;
 	}
 
-	IWL_INFO(priv, "Device SKU: 0x%X\n", hw_params(priv).sku);
+	IWL_INFO(priv, "Device SKU: 0x%X\n", priv->hw_params.sku);
 
 	radio_cfg = iwl_eeprom_query16(shrd, EEPROM_RADIO_CONFIG);
 
-	hw_params(priv).valid_tx_ant = EEPROM_RF_CFG_TX_ANT_MSK(radio_cfg);
-	hw_params(priv).valid_rx_ant = EEPROM_RF_CFG_RX_ANT_MSK(radio_cfg);
+	priv->hw_params.valid_tx_ant = EEPROM_RF_CFG_TX_ANT_MSK(radio_cfg);
+	priv->hw_params.valid_rx_ant = EEPROM_RF_CFG_RX_ANT_MSK(radio_cfg);
 
 	/* check overrides (some devices have wrong EEPROM) */
 	if (cfg(priv)->valid_tx_ant)
-		hw_params(priv).valid_tx_ant = cfg(priv)->valid_tx_ant;
+		priv->hw_params.valid_tx_ant = cfg(priv)->valid_tx_ant;
 	if (cfg(priv)->valid_rx_ant)
-		hw_params(priv).valid_rx_ant = cfg(priv)->valid_rx_ant;
+		priv->hw_params.valid_rx_ant = cfg(priv)->valid_rx_ant;
 
-	if (!hw_params(priv).valid_tx_ant || !hw_params(priv).valid_rx_ant) {
+	if (!priv->hw_params.valid_tx_ant || !priv->hw_params.valid_rx_ant) {
 		IWL_ERR(priv, "Invalid chain (0x%X, 0x%X)\n",
-			hw_params(priv).valid_tx_ant,
-			hw_params(priv).valid_rx_ant);
+			priv->hw_params.valid_tx_ant,
+			priv->hw_params.valid_rx_ant);
 		return -EINVAL;
 	}
 
 	IWL_INFO(priv, "Valid Tx ant: 0x%X, Valid Rx ant: 0x%X\n",
-		 hw_params(priv).valid_tx_ant, hw_params(priv).valid_rx_ant);
+		 priv->hw_params.valid_tx_ant, priv->hw_params.valid_rx_ant);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 551db9e..e084a4b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -160,7 +160,7 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 		     IEEE80211_HW_SUPPORTS_DYNAMIC_PS |
 		     IEEE80211_HW_SCAN_WHILE_IDLE;
 
-	if (hw_params(priv).sku & EEPROM_SKU_CAP_11N_ENABLE)
+	if (priv->hw_params.sku & EEPROM_SKU_CAP_11N_ENABLE)
 		hw->flags |= IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS |
 			     IEEE80211_HW_SUPPORTS_STATIC_SMPS;
 
@@ -636,7 +636,7 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 	IWL_DEBUG_HT(priv, "A-MPDU action on addr %pM tid %d\n",
 		     sta->addr, tid);
 
-	if (!(hw_params(priv).sku & EEPROM_SKU_CAP_11N_ENABLE))
+	if (!(priv->hw_params.sku & EEPROM_SKU_CAP_11N_ENABLE))
 		return -EACCES;
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
@@ -670,7 +670,7 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 				     priv->agg_tids_count);
 		}
 		if (!priv->agg_tids_count &&
-		    hw_params(priv).use_rts_for_aggregation) {
+		    priv->hw_params.use_rts_for_aggregation) {
 			/*
 			 * switch off RTS/CTS if it was previously enabled
 			 */
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index dcf5b12..490a60d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -673,12 +673,12 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	u16 rx_chain = 0;
 	enum ieee80211_band band;
 	u8 n_probes = 0;
-	u8 rx_ant = hw_params(priv).valid_rx_ant;
+	u8 rx_ant = priv->hw_params.valid_rx_ant;
 	u8 rate;
 	bool is_active = false;
 	int  chan_mod;
 	u8 active_chains;
-	u8 scan_tx_antennas = hw_params(priv).valid_tx_ant;
+	u8 scan_tx_antennas = priv->hw_params.valid_tx_ant;
 	int ret;
 
 	lockdep_assert_held(&priv->mutex);
@@ -872,7 +872,7 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 
 	/* MIMO is not used here, but value is required */
 	rx_chain |=
-		hw_params(priv).valid_rx_ant << RXON_RX_CHAIN_VALID_POS;
+		priv->hw_params.valid_rx_ant << RXON_RX_CHAIN_VALID_POS;
 	rx_chain |= rx_ant << RXON_RX_CHAIN_FORCE_MIMO_SEL_POS;
 	rx_chain |= rx_ant << RXON_RX_CHAIN_FORCE_SEL_POS;
 	rx_chain |= 0x1 << RXON_RX_CHAIN_DRIVER_FORCE_POS;
@@ -985,7 +985,7 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 
 void iwl_init_scan_params(struct iwl_priv *priv)
 {
-	u8 ant_idx = fls(hw_params(priv).valid_tx_ant) - 1;
+	u8 ant_idx = fls(priv->hw_params.valid_tx_ant) - 1;
 	if (!priv->scan_tx_ant[IEEE80211_BAND_5GHZ])
 		priv->scan_tx_ant[IEEE80211_BAND_5GHZ] = ant_idx;
 	if (!priv->scan_tx_ant[IEEE80211_BAND_2GHZ])
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index c6049cf..c6de930 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -155,37 +155,6 @@ struct iwl_mod_params {
 	bool auto_agg;
 };
 
-/**
- * struct iwl_hw_params
- *
- * Holds the module parameters
- *
- * @tx_chains_num: Number of TX chains
- * @rx_chains_num: Number of RX chains
- * @valid_tx_ant: usable antennas for TX
- * @valid_rx_ant: usable antennas for RX
- * @ht40_channel: is 40MHz width possible: BIT(IEEE80211_BAND_XXX)
- * @sku: sku read from EEPROM
- * @ct_kill_threshold: temperature threshold - in hw dependent unit
- * @ct_kill_exit_threshold: when to reeable the device - in hw dependent unit
- *	relevant for 1000, 6000 and up
- * @struct iwl_sensitivity_ranges: range of sensitivity values
- * @use_rts_for_aggregation: use rts/cts protection for HT traffic
- */
-struct iwl_hw_params {
-	u8  tx_chains_num;
-	u8  rx_chains_num;
-	u8  valid_tx_ant;
-	u8  valid_rx_ant;
-	u8  ht40_channel;
-	bool use_rts_for_aggregation;
-	u16 sku;
-	u32 ct_kill_threshold;
-	u32 ct_kill_exit_threshold;
-
-	const struct iwl_sensitivity_ranges *sens;
-};
-
 /*
  * LED mode
  *    IWL_LED_DEFAULT:  use device default
@@ -337,7 +306,6 @@ struct iwl_cfg {
  * @priv: pointer to the upper layer data
  * @trans: pointer to the transport layer data
  * @nic: pointer to the nic data
- * @hw_params: see struct iwl_hw_params
  * @lock: protect general shared data
  * @eeprom: pointer to the eeprom/OTP image
  */
@@ -347,7 +315,6 @@ struct iwl_shared {
 	const struct iwl_cfg *cfg;
 	struct iwl_trans *trans;
 	void *drv;
-	struct iwl_hw_params hw_params;
 
 	/* eeprom -- this is in the card's little endian byte order */
 	u8 *eeprom;
@@ -357,7 +324,6 @@ struct iwl_shared {
 /*Whatever _m is (iwl_trans, iwl_priv, these macros will work */
 #define cfg(_m)		((_m)->shrd->cfg)
 #define trans(_m)	((_m)->shrd->trans)
-#define hw_params(_m)	((_m)->shrd->hw_params)
 
 static inline bool iwl_have_debug_level(u32 level)
 {
-- 
1.7.0.4

