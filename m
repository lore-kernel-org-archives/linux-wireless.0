Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38078 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754964Ab2CDUm7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:42:59 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 014/101] iwlwifi: use valid TX/RX antenna from hw_params
Date: Sun,  4 Mar 2012 11:28:28 -0800
Message-Id: <1330889395-533-15-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214339_242365_99500D14)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

It's not really a good idea to write to the
global static configuration. Use the valid
TX/RX antenna information only from the HW
params struct except in the case where the
values from the config are used to override
the values from the EEPROM.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c      |    7 ++---
 drivers/net/wireless/iwlwifi/iwl-2000.c      |    7 ++---
 drivers/net/wireless/iwlwifi/iwl-5000.c      |   16 +++++-----
 drivers/net/wireless/iwlwifi/iwl-6000.c      |    7 ++---
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c   |    9 ++++--
 drivers/net/wireless/iwlwifi/iwl-eeprom.c    |   38 +++++++++++++------------
 8 files changed, 46 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 605ee3d..22eb062 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -131,14 +131,13 @@ static void iwl1000_hw_set_hw_params(struct iwl_priv *priv)
 
 	hw_params(priv).ht40_channel =  BIT(IEEE80211_BAND_2GHZ);
 
-	hw_params(priv).tx_chains_num = num_of_ant(cfg(priv)->valid_tx_ant);
+	hw_params(priv).tx_chains_num =
+		num_of_ant(hw_params(priv).valid_tx_ant);
 	if (cfg(priv)->rx_with_siso_diversity)
 		hw_params(priv).rx_chains_num = 1;
 	else
 		hw_params(priv).rx_chains_num =
-			num_of_ant(cfg(priv)->valid_rx_ant);
-	hw_params(priv).valid_tx_ant = cfg(priv)->valid_tx_ant;
-	hw_params(priv).valid_rx_ant = cfg(priv)->valid_rx_ant;
+			num_of_ant(hw_params(priv).valid_rx_ant);
 
 	iwl1000_set_ct_threshold(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index e6e8c79..43d17a4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -127,14 +127,13 @@ static void iwl2000_hw_set_hw_params(struct iwl_priv *priv)
 
 	hw_params(priv).ht40_channel =  BIT(IEEE80211_BAND_2GHZ);
 
-	hw_params(priv).tx_chains_num = num_of_ant(cfg(priv)->valid_tx_ant);
+	hw_params(priv).tx_chains_num =
+		num_of_ant(hw_params(priv).valid_tx_ant);
 	if (cfg(priv)->rx_with_siso_diversity)
 		hw_params(priv).rx_chains_num = 1;
 	else
 		hw_params(priv).rx_chains_num =
-			num_of_ant(cfg(priv)->valid_rx_ant);
-	hw_params(priv).valid_tx_ant = cfg(priv)->valid_tx_ant;
-	hw_params(priv).valid_rx_ant = cfg(priv)->valid_rx_ant;
+			num_of_ant(hw_params(priv).valid_rx_ant);
 
 	iwl2000_set_ct_threshold(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index ccaeead..8cdc4a3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -167,10 +167,10 @@ static void iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 	hw_params(priv).ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
 					BIT(IEEE80211_BAND_5GHZ);
 
-	hw_params(priv).tx_chains_num = num_of_ant(cfg(priv)->valid_tx_ant);
-	hw_params(priv).rx_chains_num = num_of_ant(cfg(priv)->valid_rx_ant);
-	hw_params(priv).valid_tx_ant = cfg(priv)->valid_tx_ant;
-	hw_params(priv).valid_rx_ant = cfg(priv)->valid_rx_ant;
+	hw_params(priv).tx_chains_num =
+		num_of_ant(hw_params(priv).valid_tx_ant);
+	hw_params(priv).rx_chains_num =
+		num_of_ant(hw_params(priv).valid_rx_ant);
 
 	iwl5000_set_ct_threshold(priv);
 
@@ -190,10 +190,10 @@ static void iwl5150_hw_set_hw_params(struct iwl_priv *priv)
 	hw_params(priv).ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
 					BIT(IEEE80211_BAND_5GHZ);
 
-	hw_params(priv).tx_chains_num = num_of_ant(cfg(priv)->valid_tx_ant);
-	hw_params(priv).rx_chains_num = num_of_ant(cfg(priv)->valid_rx_ant);
-	hw_params(priv).valid_tx_ant = cfg(priv)->valid_tx_ant;
-	hw_params(priv).valid_rx_ant = cfg(priv)->valid_rx_ant;
+	hw_params(priv).tx_chains_num =
+		num_of_ant(hw_params(priv).valid_tx_ant);
+	hw_params(priv).rx_chains_num =
+		num_of_ant(hw_params(priv).valid_rx_ant);
 
 	iwl5150_set_ct_threshold(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 223e60a..720e8e6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -149,14 +149,13 @@ static void iwl6000_hw_set_hw_params(struct iwl_priv *priv)
 	hw_params(priv).ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
 					BIT(IEEE80211_BAND_5GHZ);
 
-	hw_params(priv).tx_chains_num = num_of_ant(cfg(priv)->valid_tx_ant);
+	hw_params(priv).tx_chains_num =
+		num_of_ant(hw_params(priv).valid_tx_ant);
 	if (cfg(priv)->rx_with_siso_diversity)
 		hw_params(priv).rx_chains_num = 1;
 	else
 		hw_params(priv).rx_chains_num =
-			num_of_ant(cfg(priv)->valid_rx_ant);
-	hw_params(priv).valid_tx_ant = cfg(priv)->valid_tx_ant;
-	hw_params(priv).valid_rx_ant = cfg(priv)->valid_rx_ant;
+			num_of_ant(hw_params(priv).valid_rx_ant);
 
 	iwl6000_set_ct_threshold(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
index 12acc81..84fc5ce 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
@@ -848,7 +848,7 @@ static void iwl_find_disconn_antenna(struct iwl_priv *priv, u32* average_sig,
 			 * connect the first valid tx chain
 			 */
 			first_chain =
-				find_first_chain(cfg(priv)->valid_tx_ant);
+				find_first_chain(hw_params(priv).valid_tx_ant);
 			data->disconn_array[first_chain] = 0;
 			active_chains |= BIT(first_chain);
 			IWL_DEBUG_CALIB(priv,
@@ -1082,7 +1082,7 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv)
 
 	iwlagn_gain_computation(priv, average_noise,
 				min_average_noise_antenna_i, min_average_noise,
-				find_first_chain(cfg(priv)->valid_rx_ant));
+				find_first_chain(hw_params(priv).valid_rx_ant));
 
 	/* Some power changes may have been made during the calibration.
 	 * Update and commit the RXON
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index e1bf125..6cec7e6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -699,7 +699,7 @@ int iwl_alive_start(struct iwl_priv *priv)
 	priv->active_rate = IWL_RATES_MASK;
 
 	/* Configure Tx antenna selection based on H/W config */
-	iwlagn_send_tx_ant_config(priv, cfg(priv)->valid_tx_ant);
+	iwlagn_send_tx_ant_config(priv, hw_params(priv).valid_tx_ant);
 
 	if (iwl_is_associated_ctx(ctx) && !priv->shrd->wowlan) {
 		struct iwl_rxon_cmd *active_rxon =
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index dd502e8..b6740c3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -1546,15 +1546,18 @@ static ssize_t iwl_dbgfs_ucode_tx_stats_read(struct file *file,
 	if (tx->tx_power.ant_a || tx->tx_power.ant_b || tx->tx_power.ant_c) {
 		pos += scnprintf(buf + pos, bufsz - pos,
 			"tx power: (1/2 dB step)\n");
-		if ((cfg(priv)->valid_tx_ant & ANT_A) && tx->tx_power.ant_a)
+		if ((hw_params(priv).valid_tx_ant & ANT_A) &&
+		    tx->tx_power.ant_a)
 			pos += scnprintf(buf + pos, bufsz - pos,
 					fmt_hex, "antenna A:",
 					tx->tx_power.ant_a);
-		if ((cfg(priv)->valid_tx_ant & ANT_B) && tx->tx_power.ant_b)
+		if ((hw_params(priv).valid_tx_ant & ANT_B) &&
+		    tx->tx_power.ant_b)
 			pos += scnprintf(buf + pos, bufsz - pos,
 					fmt_hex, "antenna B:",
 					tx->tx_power.ant_b);
-		if ((cfg(priv)->valid_tx_ant & ANT_C) && tx->tx_power.ant_c)
+		if ((hw_params(priv).valid_tx_ant & ANT_C) &&
+		    tx->tx_power.ant_c)
 			pos += scnprintf(buf + pos, bufsz - pos,
 					fmt_hex, "antenna C:",
 					tx->tx_power.ant_c);
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index d8668bc..6915b33 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -271,25 +271,27 @@ int iwl_eeprom_init_hw_params(struct iwl_priv *priv)
 
 	IWL_INFO(priv, "Device SKU: 0x%X\n", hw_params(priv).sku);
 
-	if (!cfg(priv)->valid_tx_ant && !cfg(priv)->valid_rx_ant) {
-		/* not using .cfg overwrite */
-		radio_cfg = iwl_eeprom_query16(shrd, EEPROM_RADIO_CONFIG);
-		cfg(priv)->valid_tx_ant = EEPROM_RF_CFG_TX_ANT_MSK(radio_cfg);
-		cfg(priv)->valid_rx_ant = EEPROM_RF_CFG_RX_ANT_MSK(radio_cfg);
-		if (!cfg(priv)->valid_tx_ant || !cfg(priv)->valid_rx_ant) {
-			IWL_ERR(priv, "Invalid chain (0x%X, 0x%X)\n",
-				cfg(priv)->valid_tx_ant,
-				cfg(priv)->valid_rx_ant);
-			return -EINVAL;
-		}
-		IWL_INFO(priv, "Valid Tx ant: 0x%X, Valid Rx ant: 0x%X\n",
-			 cfg(priv)->valid_tx_ant, cfg(priv)->valid_rx_ant);
+	radio_cfg = iwl_eeprom_query16(shrd, EEPROM_RADIO_CONFIG);
+
+	hw_params(priv).valid_tx_ant = EEPROM_RF_CFG_TX_ANT_MSK(radio_cfg);
+	hw_params(priv).valid_rx_ant = EEPROM_RF_CFG_RX_ANT_MSK(radio_cfg);
+
+	/* check overrides (some devices have wrong EEPROM) */
+	if (cfg(priv)->valid_tx_ant)
+		hw_params(priv).valid_tx_ant = cfg(priv)->valid_tx_ant;
+	if (cfg(priv)->valid_rx_ant)
+		hw_params(priv).valid_rx_ant = cfg(priv)->valid_rx_ant;
+
+	if (!hw_params(priv).valid_tx_ant || !hw_params(priv).valid_rx_ant) {
+		IWL_ERR(priv, "Invalid chain (0x%X, 0x%X)\n",
+			hw_params(priv).valid_tx_ant,
+			hw_params(priv).valid_rx_ant);
+		return -EINVAL;
 	}
-	/*
-	 * for some special cases,
-	 * EEPROM did not reflect the correct antenna setting
-	 * so overwrite the valid tx/rx antenna from .cfg
-	 */
+
+	IWL_INFO(priv, "Valid Tx ant: 0x%X, Valid Rx ant: 0x%X\n",
+		 hw_params(priv).valid_tx_ant, hw_params(priv).valid_rx_ant);
+
 	return 0;
 }
 
-- 
1.7.0.4

