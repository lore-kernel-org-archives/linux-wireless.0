Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:15248 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755009Ab0KJSBH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 13:01:07 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Shanyu Zhao <shanyu.zhao@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 14/16] iwlwifi: seperate disconnected antenna function
Date: Wed, 10 Nov 2010 09:56:48 -0800
Message-Id: <1289411810-23093-15-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1289411810-23093-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1289411810-23093-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shanyu Zhao <shanyu.zhao@intel.com>

Disconnected antenna algorithm is seperated into its own function from chain noise
calibration routine for better code management.

Signed-off-by: Shanyu Zhao <shanyu.zhao@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c |  231 ++++++++++++++------------
 1 files changed, 123 insertions(+), 108 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
index e2019e7..b4cfc3c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
@@ -732,8 +732,128 @@ static inline u8 find_first_chain(u8 mask)
 	return CHAIN_C;
 }
 
+/**
+ * Run disconnected antenna algorithm to find out which antennas are
+ * disconnected.
+ */
+static void iwl_find_disconn_antenna(struct iwl_priv *priv, u32* average_sig,
+				     struct iwl_chain_noise_data *data)
+{
+	u32 active_chains = 0;
+	u32 max_average_sig;
+	u16 max_average_sig_antenna_i;
+	u8 num_tx_chains;
+	u8 first_chain;
+	u16 i = 0;
+
+	average_sig[0] = data->chain_signal_a /
+			 priv->cfg->base_params->chain_noise_num_beacons;
+	average_sig[1] = data->chain_signal_b /
+			 priv->cfg->base_params->chain_noise_num_beacons;
+	average_sig[2] = data->chain_signal_c /
+			 priv->cfg->base_params->chain_noise_num_beacons;
+
+	if (average_sig[0] >= average_sig[1]) {
+		max_average_sig = average_sig[0];
+		max_average_sig_antenna_i = 0;
+		active_chains = (1 << max_average_sig_antenna_i);
+	} else {
+		max_average_sig = average_sig[1];
+		max_average_sig_antenna_i = 1;
+		active_chains = (1 << max_average_sig_antenna_i);
+	}
+
+	if (average_sig[2] >= max_average_sig) {
+		max_average_sig = average_sig[2];
+		max_average_sig_antenna_i = 2;
+		active_chains = (1 << max_average_sig_antenna_i);
+	}
+
+	IWL_DEBUG_CALIB(priv, "average_sig: a %d b %d c %d\n",
+		     average_sig[0], average_sig[1], average_sig[2]);
+	IWL_DEBUG_CALIB(priv, "max_average_sig = %d, antenna %d\n",
+		     max_average_sig, max_average_sig_antenna_i);
+
+	/* Compare signal strengths for all 3 receivers. */
+	for (i = 0; i < NUM_RX_CHAINS; i++) {
+		if (i != max_average_sig_antenna_i) {
+			s32 rssi_delta = (max_average_sig - average_sig[i]);
+
+			/* If signal is very weak, compared with
+			 * strongest, mark it as disconnected. */
+			if (rssi_delta > MAXIMUM_ALLOWED_PATHLOSS)
+				data->disconn_array[i] = 1;
+			else
+				active_chains |= (1 << i);
+			IWL_DEBUG_CALIB(priv, "i = %d  rssiDelta = %d  "
+			     "disconn_array[i] = %d\n",
+			     i, rssi_delta, data->disconn_array[i]);
+		}
+	}
+
+	/*
+	 * The above algorithm sometimes fails when the ucode
+	 * reports 0 for all chains. It's not clear why that
+	 * happens to start with, but it is then causing trouble
+	 * because this can make us enable more chains than the
+	 * hardware really has.
+	 *
+	 * To be safe, simply mask out any chains that we know
+	 * are not on the device.
+	 */
+	if (priv->cfg->bt_params &&
+	    priv->cfg->bt_params->advanced_bt_coexist &&
+	    priv->bt_full_concurrent) {
+		/* operated as 1x1 in full concurrency mode */
+		active_chains &= first_antenna(priv->hw_params.valid_rx_ant);
+	} else
+		active_chains &= priv->hw_params.valid_rx_ant;
+
+	num_tx_chains = 0;
+	for (i = 0; i < NUM_RX_CHAINS; i++) {
+		/* loops on all the bits of
+		 * priv->hw_setting.valid_tx_ant */
+		u8 ant_msk = (1 << i);
+		if (!(priv->hw_params.valid_tx_ant & ant_msk))
+			continue;
+
+		num_tx_chains++;
+		if (data->disconn_array[i] == 0)
+			/* there is a Tx antenna connected */
+			break;
+		if (num_tx_chains == priv->hw_params.tx_chains_num &&
+		    data->disconn_array[i]) {
+			/*
+			 * If all chains are disconnected
+			 * connect the first valid tx chain
+			 */
+			first_chain =
+				find_first_chain(priv->cfg->valid_tx_ant);
+			data->disconn_array[first_chain] = 0;
+			active_chains |= BIT(first_chain);
+			IWL_DEBUG_CALIB(priv, "All Tx chains are disconnected \
+					W/A - declare %d as connected\n",
+					first_chain);
+			break;
+		}
+	}
+
+	if (active_chains != priv->hw_params.valid_rx_ant &&
+	    active_chains != priv->chain_noise_data.active_chains)
+		IWL_DEBUG_CALIB(priv,
+				"Detected that not all antennas are connected! "
+				"Connected: %#x, valid: %#x.\n",
+				active_chains, priv->hw_params.valid_rx_ant);
+
+	/* Save for use within RXON, TX, SCAN commands, etc. */
+	data->active_chains = active_chains;
+	IWL_DEBUG_CALIB(priv, "active_chains (bitwise) = 0x%x\n",
+			active_chains);
+}
+
+
 /*
- * Accumulate 20 beacons of signal and noise statistics for each of
+ * Accumulate 16 beacons of signal and noise statistics for each of
  *   3 receivers/antennas/rx-chains, then figure out:
  * 1)  Which antennas are connected.
  * 2)  Differential rx gain settings to balance the 3 receivers.
@@ -750,8 +870,6 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv, void *stat_resp)
 	u32 chain_sig_c;
 	u32 average_sig[NUM_RX_CHAINS] = {INITIALIZATION_VALUE};
 	u32 average_noise[NUM_RX_CHAINS] = {INITIALIZATION_VALUE};
-	u32 max_average_sig;
-	u16 max_average_sig_antenna_i;
 	u32 min_average_noise = MIN_AVERAGE_NOISE_MAX_VALUE;
 	u16 min_average_noise_antenna_i = INITIALIZATION_VALUE;
 	u16 i = 0;
@@ -759,11 +877,9 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv, void *stat_resp)
 	u16 stat_chnum = INITIALIZATION_VALUE;
 	u8 rxon_band24;
 	u8 stat_band24;
-	u32 active_chains = 0;
-	u8 num_tx_chains;
 	unsigned long flags;
 	struct statistics_rx_non_phy *rx_info;
-	u8 first_chain;
+
 	/*
 	 * MULTI-FIXME:
 	 * When we support multiple interfaces on different channels,
@@ -869,108 +985,7 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv, void *stat_resp)
 		return;
 
 	/* Analyze signal for disconnected antenna */
-	average_sig[0] = data->chain_signal_a /
-			 priv->cfg->base_params->chain_noise_num_beacons;
-	average_sig[1] = data->chain_signal_b /
-			 priv->cfg->base_params->chain_noise_num_beacons;
-	average_sig[2] = data->chain_signal_c /
-			 priv->cfg->base_params->chain_noise_num_beacons;
-
-	if (average_sig[0] >= average_sig[1]) {
-		max_average_sig = average_sig[0];
-		max_average_sig_antenna_i = 0;
-		active_chains = (1 << max_average_sig_antenna_i);
-	} else {
-		max_average_sig = average_sig[1];
-		max_average_sig_antenna_i = 1;
-		active_chains = (1 << max_average_sig_antenna_i);
-	}
-
-	if (average_sig[2] >= max_average_sig) {
-		max_average_sig = average_sig[2];
-		max_average_sig_antenna_i = 2;
-		active_chains = (1 << max_average_sig_antenna_i);
-	}
-
-	IWL_DEBUG_CALIB(priv, "average_sig: a %d b %d c %d\n",
-		     average_sig[0], average_sig[1], average_sig[2]);
-	IWL_DEBUG_CALIB(priv, "max_average_sig = %d, antenna %d\n",
-		     max_average_sig, max_average_sig_antenna_i);
-
-	/* Compare signal strengths for all 3 receivers. */
-	for (i = 0; i < NUM_RX_CHAINS; i++) {
-		if (i != max_average_sig_antenna_i) {
-			s32 rssi_delta = (max_average_sig - average_sig[i]);
-
-			/* If signal is very weak, compared with
-			 * strongest, mark it as disconnected. */
-			if (rssi_delta > MAXIMUM_ALLOWED_PATHLOSS)
-				data->disconn_array[i] = 1;
-			else
-				active_chains |= (1 << i);
-			IWL_DEBUG_CALIB(priv, "i = %d  rssiDelta = %d  "
-			     "disconn_array[i] = %d\n",
-			     i, rssi_delta, data->disconn_array[i]);
-		}
-	}
-
-	/*
-	 * The above algorithm sometimes fails when the ucode
-	 * reports 0 for all chains. It's not clear why that
-	 * happens to start with, but it is then causing trouble
-	 * because this can make us enable more chains than the
-	 * hardware really has.
-	 *
-	 * To be safe, simply mask out any chains that we know
-	 * are not on the device.
-	 */
-	if (priv->cfg->bt_params &&
-	    priv->cfg->bt_params->advanced_bt_coexist &&
-	    priv->bt_full_concurrent) {
-		/* operated as 1x1 in full concurrency mode */
-		active_chains &= first_antenna(priv->hw_params.valid_rx_ant);
-	} else
-		active_chains &= priv->hw_params.valid_rx_ant;
-
-	num_tx_chains = 0;
-	for (i = 0; i < NUM_RX_CHAINS; i++) {
-		/* loops on all the bits of
-		 * priv->hw_setting.valid_tx_ant */
-		u8 ant_msk = (1 << i);
-		if (!(priv->hw_params.valid_tx_ant & ant_msk))
-			continue;
-
-		num_tx_chains++;
-		if (data->disconn_array[i] == 0)
-			/* there is a Tx antenna connected */
-			break;
-		if (num_tx_chains == priv->hw_params.tx_chains_num &&
-		    data->disconn_array[i]) {
-			/*
-			 * If all chains are disconnected
-			 * connect the first valid tx chain
-			 */
-			first_chain =
-				find_first_chain(priv->cfg->valid_tx_ant);
-			data->disconn_array[first_chain] = 0;
-			active_chains |= BIT(first_chain);
-			IWL_DEBUG_CALIB(priv, "All Tx chains are disconnected W/A - declare %d as connected\n",
-					first_chain);
-			break;
-		}
-	}
-
-	if (active_chains != priv->hw_params.valid_rx_ant &&
-	    active_chains != priv->chain_noise_data.active_chains)
-		IWL_DEBUG_CALIB(priv,
-				"Detected that not all antennas are connected! "
-				"Connected: %#x, valid: %#x.\n",
-				active_chains, priv->hw_params.valid_rx_ant);
-
-	/* Save for use within RXON, TX, SCAN commands, etc. */
-	priv->chain_noise_data.active_chains = active_chains;
-	IWL_DEBUG_CALIB(priv, "active_chains (bitwise) = 0x%x\n",
-			active_chains);
+	iwl_find_disconn_antenna(priv, average_sig, data);
 
 	/* Analyze noise for rx balance */
 	average_noise[0] = data->chain_noise_a /
-- 
1.7.0.4

