Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:15336 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759858Ab1LPQhr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 11:37:47 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 01/24] iwlwifi: move iwl_cfg from iwl_priv to iwl_shared
Date: Fri, 16 Dec 2011 07:37:06 -0800
Message-Id: <1324049849-831-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111216_173813_074076_1EA959C3)
In-Reply-To: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

Move the configuration pointer from the upper level iwl_priv to the
lower level iwl_shared structure, with associated code fixes.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c          |   14 ++--
 drivers/net/wireless/iwlwifi/iwl-2000.c          |   16 ++--
 drivers/net/wireless/iwlwifi/iwl-5000.c          |   24 +++---
 drivers/net/wireless/iwlwifi/iwl-6000.c          |   20 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c     |   12 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c       |   22 +++---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c        |    8 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c        |   10 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c      |    8 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c        |   12 ++--
 drivers/net/wireless/iwlwifi/iwl-agn.c           |   60 +++++++-------
 drivers/net/wireless/iwlwifi/iwl-core.c          |   33 ++++----
 drivers/net/wireless/iwlwifi/iwl-core.h          |   75 +----------------
 drivers/net/wireless/iwlwifi/iwl-debugfs.c       |   26 +++---
 drivers/net/wireless/iwlwifi/iwl-dev.h           |   11 ---
 drivers/net/wireless/iwlwifi/iwl-eeprom.c        |   58 ++++++------
 drivers/net/wireless/iwlwifi/iwl-led.c           |    8 +-
 drivers/net/wireless/iwlwifi/iwl-led.h           |   14 ---
 drivers/net/wireless/iwlwifi/iwl-mac80211.c      |   22 +++---
 drivers/net/wireless/iwlwifi/iwl-power.c         |    8 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c          |   16 ++--
 drivers/net/wireless/iwlwifi/iwl-shared.h        |  100 +++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-testmode.c      |    8 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-ucode.c         |   12 ++--
 26 files changed, 301 insertions(+), 300 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 8d3bad7..1ef7bfc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -124,10 +124,10 @@ static int iwl1000_hw_set_hw_params(struct iwl_priv *priv)
 {
 	if (iwlagn_mod_params.num_of_queues >= IWL_MIN_NUM_QUEUES &&
 	    iwlagn_mod_params.num_of_queues <= IWLAGN_NUM_QUEUES)
-		priv->cfg->base_params->num_of_queues =
+		cfg(priv)->base_params->num_of_queues =
 			iwlagn_mod_params.num_of_queues;
 
-	hw_params(priv).max_txq_num = priv->cfg->base_params->num_of_queues;
+	hw_params(priv).max_txq_num = cfg(priv)->base_params->num_of_queues;
 	priv->contexts[IWL_RXON_CTX_BSS].bcast_sta_id = IWLAGN_BROADCAST_ID;
 
 	hw_params(priv).max_data_size = IWLAGN_RTC_DATA_SIZE;
@@ -135,14 +135,14 @@ static int iwl1000_hw_set_hw_params(struct iwl_priv *priv)
 
 	hw_params(priv).ht40_channel =  BIT(IEEE80211_BAND_2GHZ);
 
-	hw_params(priv).tx_chains_num = num_of_ant(priv->cfg->valid_tx_ant);
-	if (priv->cfg->rx_with_siso_diversity)
+	hw_params(priv).tx_chains_num = num_of_ant(cfg(priv)->valid_tx_ant);
+	if (cfg(priv)->rx_with_siso_diversity)
 		hw_params(priv).rx_chains_num = 1;
 	else
 		hw_params(priv).rx_chains_num =
-			num_of_ant(priv->cfg->valid_rx_ant);
-	hw_params(priv).valid_tx_ant = priv->cfg->valid_tx_ant;
-	hw_params(priv).valid_rx_ant = priv->cfg->valid_rx_ant;
+			num_of_ant(cfg(priv)->valid_rx_ant);
+	hw_params(priv).valid_tx_ant = cfg(priv)->valid_tx_ant;
+	hw_params(priv).valid_rx_ant = cfg(priv)->valid_rx_ant;
 
 	iwl1000_set_ct_threshold(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 0c4688d..1d2cb4c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -86,7 +86,7 @@ static void iwl2000_nic_config(struct iwl_priv *priv)
 {
 	iwl_rf_config(priv);
 
-	if (priv->cfg->iq_invert)
+	if (cfg(priv)->iq_invert)
 		iwl_set_bit(bus(priv), CSR_GP_DRIVER_REG,
 			    CSR_GP_DRIVER_REG_BIT_RADIO_IQ_INVER);
 }
@@ -120,10 +120,10 @@ static int iwl2000_hw_set_hw_params(struct iwl_priv *priv)
 {
 	if (iwlagn_mod_params.num_of_queues >= IWL_MIN_NUM_QUEUES &&
 	    iwlagn_mod_params.num_of_queues <= IWLAGN_NUM_QUEUES)
-		priv->cfg->base_params->num_of_queues =
+		cfg(priv)->base_params->num_of_queues =
 			iwlagn_mod_params.num_of_queues;
 
-	hw_params(priv).max_txq_num = priv->cfg->base_params->num_of_queues;
+	hw_params(priv).max_txq_num = cfg(priv)->base_params->num_of_queues;
 	priv->contexts[IWL_RXON_CTX_BSS].bcast_sta_id = IWLAGN_BROADCAST_ID;
 
 	hw_params(priv).max_data_size = IWL60_RTC_DATA_SIZE;
@@ -131,14 +131,14 @@ static int iwl2000_hw_set_hw_params(struct iwl_priv *priv)
 
 	hw_params(priv).ht40_channel =  BIT(IEEE80211_BAND_2GHZ);
 
-	hw_params(priv).tx_chains_num = num_of_ant(priv->cfg->valid_tx_ant);
-	if (priv->cfg->rx_with_siso_diversity)
+	hw_params(priv).tx_chains_num = num_of_ant(cfg(priv)->valid_tx_ant);
+	if (cfg(priv)->rx_with_siso_diversity)
 		hw_params(priv).rx_chains_num = 1;
 	else
 		hw_params(priv).rx_chains_num =
-			num_of_ant(priv->cfg->valid_rx_ant);
-	hw_params(priv).valid_tx_ant = priv->cfg->valid_tx_ant;
-	hw_params(priv).valid_rx_ant = priv->cfg->valid_rx_ant;
+			num_of_ant(cfg(priv)->valid_rx_ant);
+	hw_params(priv).valid_tx_ant = cfg(priv)->valid_tx_ant;
+	hw_params(priv).valid_rx_ant = cfg(priv)->valid_rx_ant;
 
 	iwl2000_set_ct_threshold(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 6706d7c..b3a365f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -166,10 +166,10 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 {
 	if (iwlagn_mod_params.num_of_queues >= IWL_MIN_NUM_QUEUES &&
 	    iwlagn_mod_params.num_of_queues <= IWLAGN_NUM_QUEUES)
-		priv->cfg->base_params->num_of_queues =
+		cfg(priv)->base_params->num_of_queues =
 			iwlagn_mod_params.num_of_queues;
 
-	hw_params(priv).max_txq_num = priv->cfg->base_params->num_of_queues;
+	hw_params(priv).max_txq_num = cfg(priv)->base_params->num_of_queues;
 	priv->contexts[IWL_RXON_CTX_BSS].bcast_sta_id = IWLAGN_BROADCAST_ID;
 
 	hw_params(priv).max_data_size = IWLAGN_RTC_DATA_SIZE;
@@ -178,10 +178,10 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 	hw_params(priv).ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
 					BIT(IEEE80211_BAND_5GHZ);
 
-	hw_params(priv).tx_chains_num = num_of_ant(priv->cfg->valid_tx_ant);
-	hw_params(priv).rx_chains_num = num_of_ant(priv->cfg->valid_rx_ant);
-	hw_params(priv).valid_tx_ant = priv->cfg->valid_tx_ant;
-	hw_params(priv).valid_rx_ant = priv->cfg->valid_rx_ant;
+	hw_params(priv).tx_chains_num = num_of_ant(cfg(priv)->valid_tx_ant);
+	hw_params(priv).rx_chains_num = num_of_ant(cfg(priv)->valid_rx_ant);
+	hw_params(priv).valid_tx_ant = cfg(priv)->valid_tx_ant;
+	hw_params(priv).valid_rx_ant = cfg(priv)->valid_rx_ant;
 
 	iwl5000_set_ct_threshold(priv);
 
@@ -195,10 +195,10 @@ static int iwl5150_hw_set_hw_params(struct iwl_priv *priv)
 {
 	if (iwlagn_mod_params.num_of_queues >= IWL_MIN_NUM_QUEUES &&
 	    iwlagn_mod_params.num_of_queues <= IWLAGN_NUM_QUEUES)
-		priv->cfg->base_params->num_of_queues =
+		cfg(priv)->base_params->num_of_queues =
 			iwlagn_mod_params.num_of_queues;
 
-	hw_params(priv).max_txq_num = priv->cfg->base_params->num_of_queues;
+	hw_params(priv).max_txq_num = cfg(priv)->base_params->num_of_queues;
 	priv->contexts[IWL_RXON_CTX_BSS].bcast_sta_id = IWLAGN_BROADCAST_ID;
 
 	hw_params(priv).max_data_size = IWLAGN_RTC_DATA_SIZE;
@@ -207,10 +207,10 @@ static int iwl5150_hw_set_hw_params(struct iwl_priv *priv)
 	hw_params(priv).ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
 					BIT(IEEE80211_BAND_5GHZ);
 
-	hw_params(priv).tx_chains_num = num_of_ant(priv->cfg->valid_tx_ant);
-	hw_params(priv).rx_chains_num = num_of_ant(priv->cfg->valid_rx_ant);
-	hw_params(priv).valid_tx_ant = priv->cfg->valid_tx_ant;
-	hw_params(priv).valid_rx_ant = priv->cfg->valid_rx_ant;
+	hw_params(priv).tx_chains_num = num_of_ant(cfg(priv)->valid_tx_ant);
+	hw_params(priv).rx_chains_num = num_of_ant(cfg(priv)->valid_rx_ant);
+	hw_params(priv).valid_tx_ant = cfg(priv)->valid_tx_ant;
+	hw_params(priv).valid_rx_ant = cfg(priv)->valid_rx_ant;
 
 	iwl5150_set_ct_threshold(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 3e277b6..a3be117 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -102,14 +102,14 @@ static void iwl6000_nic_config(struct iwl_priv *priv)
 	iwl_rf_config(priv);
 
 	/* no locking required for register write */
-	if (priv->cfg->pa_type == IWL_PA_INTERNAL) {
+	if (cfg(priv)->pa_type == IWL_PA_INTERNAL) {
 		/* 2x2 IPA phy type */
 		iwl_write32(bus(priv), CSR_GP_DRIVER_REG,
 			     CSR_GP_DRIVER_REG_BIT_RADIO_SKU_2x2_IPA);
 	}
 	/* do additional nic configuration if needed */
-	if (priv->cfg->additional_nic_config)
-			priv->cfg->additional_nic_config(priv);
+	if (cfg(priv)->additional_nic_config)
+			cfg(priv)->additional_nic_config(priv);
 }
 
 static struct iwl_sensitivity_ranges iwl6000_sensitivity = {
@@ -141,10 +141,10 @@ static int iwl6000_hw_set_hw_params(struct iwl_priv *priv)
 {
 	if (iwlagn_mod_params.num_of_queues >= IWL_MIN_NUM_QUEUES &&
 	    iwlagn_mod_params.num_of_queues <= IWLAGN_NUM_QUEUES)
-		priv->cfg->base_params->num_of_queues =
+		cfg(priv)->base_params->num_of_queues =
 			iwlagn_mod_params.num_of_queues;
 
-	hw_params(priv).max_txq_num = priv->cfg->base_params->num_of_queues;
+	hw_params(priv).max_txq_num = cfg(priv)->base_params->num_of_queues;
 	priv->contexts[IWL_RXON_CTX_BSS].bcast_sta_id = IWLAGN_BROADCAST_ID;
 
 	hw_params(priv).max_data_size = IWL60_RTC_DATA_SIZE;
@@ -153,14 +153,14 @@ static int iwl6000_hw_set_hw_params(struct iwl_priv *priv)
 	hw_params(priv).ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
 					BIT(IEEE80211_BAND_5GHZ);
 
-	hw_params(priv).tx_chains_num = num_of_ant(priv->cfg->valid_tx_ant);
-	if (priv->cfg->rx_with_siso_diversity)
+	hw_params(priv).tx_chains_num = num_of_ant(cfg(priv)->valid_tx_ant);
+	if (cfg(priv)->rx_with_siso_diversity)
 		hw_params(priv).rx_chains_num = 1;
 	else
 		hw_params(priv).rx_chains_num =
-			num_of_ant(priv->cfg->valid_rx_ant);
-	hw_params(priv).valid_tx_ant = priv->cfg->valid_tx_ant;
-	hw_params(priv).valid_rx_ant = priv->cfg->valid_rx_ant;
+			num_of_ant(cfg(priv)->valid_rx_ant);
+	hw_params(priv).valid_tx_ant = cfg(priv)->valid_tx_ant;
+	hw_params(priv).valid_rx_ant = cfg(priv)->valid_rx_ant;
 
 	iwl6000_set_ct_threshold(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
index 16971a0..50ff849 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
@@ -513,7 +513,7 @@ static int iwl_enhance_sensitivity_write(struct iwl_priv *priv)
 
 	iwl_prepare_legacy_sensitivity_tbl(priv, data, &cmd.enhance_table[0]);
 
-	if (priv->cfg->base_params->hd_v2) {
+	if (cfg(priv)->base_params->hd_v2) {
 		cmd.enhance_table[HD_INA_NON_SQUARE_DET_OFDM_INDEX] =
 			HD_INA_NON_SQUARE_DET_OFDM_DATA_V2;
 		cmd.enhance_table[HD_INA_NON_SQUARE_DET_CCK_INDEX] =
@@ -847,7 +847,7 @@ static void iwl_find_disconn_antenna(struct iwl_priv *priv, u32* average_sig,
 			 * connect the first valid tx chain
 			 */
 			first_chain =
-				find_first_chain(priv->cfg->valid_tx_ant);
+				find_first_chain(cfg(priv)->valid_tx_ant);
 			data->disconn_array[first_chain] = 0;
 			active_chains |= BIT(first_chain);
 			IWL_DEBUG_CALIB(priv,
@@ -890,7 +890,7 @@ static void iwlagn_gain_computation(struct iwl_priv *priv,
 			continue;
 		}
 
-		delta_g = (priv->cfg->base_params->chain_noise_scale *
+		delta_g = (cfg(priv)->base_params->chain_noise_scale *
 			((s32)average_noise[default_chain] -
 			(s32)average_noise[i])) / 1500;
 
@@ -1047,8 +1047,8 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv)
 		return;
 
 	/* Analyze signal for disconnected antenna */
-	if (priv->cfg->bt_params &&
-	    priv->cfg->bt_params->advanced_bt_coexist) {
+	if (cfg(priv)->bt_params &&
+	    cfg(priv)->bt_params->advanced_bt_coexist) {
 		/* Disable disconnected antenna algorithm for advanced
 		   bt coex, assuming valid antennas are connected */
 		data->active_chains = hw_params(priv).valid_rx_ant;
@@ -1082,7 +1082,7 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv)
 
 	iwlagn_gain_computation(priv, average_noise,
 				min_average_noise_antenna_i, min_average_noise,
-				find_first_chain(priv->cfg->valid_rx_ant));
+				find_first_chain(cfg(priv)->valid_rx_ant));
 
 	/* Some power changes may have been made during the calibration.
 	 * Update and commit the RXON
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 057f952..1c945fb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -150,7 +150,7 @@ static u32 eeprom_indirect_address(const struct iwl_shared *shrd, u32 address)
 const u8 *iwl_eeprom_query_addr(const struct iwl_shared *shrd, size_t offset)
 {
 	u32 address = eeprom_indirect_address(shrd, offset);
-	BUG_ON(address >= shrd->priv->cfg->base_params->eeprom_size);
+	BUG_ON(address >= shrd->cfg->base_params->eeprom_size);
 	return &shrd->eeprom[address];
 }
 
@@ -232,7 +232,7 @@ int iwlagn_txfifo_flush(struct iwl_priv *priv, u16 flush_control)
 				IWL_PAN_SCD_BK_MSK | IWL_PAN_SCD_MGMT_MSK |
 				IWL_PAN_SCD_MULTICAST_MSK;
 
-	if (priv->cfg->sku & EEPROM_SKU_CAP_11N_ENABLE)
+	if (cfg(priv)->sku & EEPROM_SKU_CAP_11N_ENABLE)
 		flush_cmd.fifo_control |= IWL_AGG_TX_QUEUE_MSK;
 
 	IWL_DEBUG_INFO(priv, "fifo queue control: 0X%x\n",
@@ -374,15 +374,15 @@ void iwlagn_send_advance_bt_config(struct iwl_priv *priv)
 	BUILD_BUG_ON(sizeof(iwlagn_def_3w_lookup) !=
 			sizeof(basic.bt3_lookup_table));
 
-	if (priv->cfg->bt_params) {
-		if (priv->cfg->bt_params->bt_session_2) {
+	if (cfg(priv)->bt_params) {
+		if (cfg(priv)->bt_params->bt_session_2) {
 			bt_cmd_2000.prio_boost = cpu_to_le32(
-				priv->cfg->bt_params->bt_prio_boost);
+				cfg(priv)->bt_params->bt_prio_boost);
 			bt_cmd_2000.tx_prio_boost = 0;
 			bt_cmd_2000.rx_prio_boost = 0;
 		} else {
 			bt_cmd_6000.prio_boost =
-				priv->cfg->bt_params->bt_prio_boost;
+				cfg(priv)->bt_params->bt_prio_boost;
 			bt_cmd_6000.tx_prio_boost = 0;
 			bt_cmd_6000.rx_prio_boost = 0;
 		}
@@ -430,7 +430,7 @@ void iwlagn_send_advance_bt_config(struct iwl_priv *priv)
 		       priv->bt_full_concurrent ?
 		       "full concurrency" : "3-wire");
 
-	if (priv->cfg->bt_params->bt_session_2) {
+	if (cfg(priv)->bt_params->bt_session_2) {
 		memcpy(&bt_cmd_2000.basic, &basic,
 			sizeof(basic));
 		ret = iwl_trans_send_cmd_pdu(trans(priv), REPLY_BT_CONFIG,
@@ -799,8 +799,8 @@ static bool is_single_rx_stream(struct iwl_priv *priv)
  */
 static int iwl_get_active_rx_chain_count(struct iwl_priv *priv)
 {
-	if (priv->cfg->bt_params &&
-	    priv->cfg->bt_params->advanced_bt_coexist &&
+	if (cfg(priv)->bt_params &&
+	    cfg(priv)->bt_params->advanced_bt_coexist &&
 	    (priv->bt_full_concurrent ||
 	     priv->bt_traffic_load >= IWL_BT_COEX_TRAFFIC_LOAD_HIGH)) {
 		/*
@@ -871,8 +871,8 @@ void iwlagn_set_rxon_chain(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	else
 		active_chains = hw_params(priv).valid_rx_ant;
 
-	if (priv->cfg->bt_params &&
-	    priv->cfg->bt_params->advanced_bt_coexist &&
+	if (cfg(priv)->bt_params &&
+	    cfg(priv)->bt_params->advanced_bt_coexist &&
 	    (priv->bt_full_concurrent ||
 	     priv->bt_traffic_load >= IWL_BT_COEX_TRAFFIC_LOAD_HIGH)) {
 		/*
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index a23835a..bc0c924 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -1086,7 +1086,7 @@ done:
 	    (priv->tm_fixed_rate != lq_sta->dbg_fixed_rate))
 		rs_program_fix_rate(priv, lq_sta);
 #endif
-	if (priv->cfg->bt_params && priv->cfg->bt_params->advanced_bt_coexist)
+	if (cfg(priv)->bt_params && cfg(priv)->bt_params->advanced_bt_coexist)
 		rs_bt_update_lq(priv, ctx, lq_sta);
 }
 
@@ -3055,11 +3055,11 @@ static void rs_fill_link_cmd(struct iwl_priv *priv,
 	 * overwrite if needed, pass aggregation time limit
 	 * to uCode in uSec
 	 */
-	if (priv && priv->cfg->bt_params &&
-	    priv->cfg->bt_params->agg_time_limit &&
+	if (priv && cfg(priv)->bt_params &&
+	    cfg(priv)->bt_params->agg_time_limit &&
 	    priv->bt_traffic_load >= IWL_BT_COEX_TRAFFIC_LOAD_HIGH)
 		lq_cmd->agg_params.agg_time_limit =
-			cpu_to_le16(priv->cfg->bt_params->agg_time_limit);
+			cpu_to_le16(cfg(priv)->bt_params->agg_time_limit);
 }
 
 static void *rs_alloc(struct ieee80211_hw *hw, struct dentry *debugfsdir)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index 9001c23..b22b297 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -318,7 +318,7 @@ static bool iwlagn_good_plcp_health(struct iwl_priv *priv,
 				 unsigned int msecs)
 {
 	int delta;
-	int threshold = priv->cfg->base_params->plcp_delta_threshold;
+	int threshold = cfg(priv)->base_params->plcp_delta_threshold;
 
 	if (threshold == IWL_MAX_PLCP_ERR_THRESHOLD_DISABLE) {
 		IWL_DEBUG_RADIO(priv, "plcp_err check disabled\n");
@@ -583,8 +583,8 @@ static int iwlagn_rx_statistics(struct iwl_priv *priv,
 		iwlagn_rx_calc_noise(priv);
 		queue_work(priv->shrd->workqueue, &priv->run_time_calib_work);
 	}
-	if (priv->cfg->lib->temperature && change)
-		priv->cfg->lib->temperature(priv);
+	if (cfg(priv)->lib->temperature && change)
+		cfg(priv)->lib->temperature(priv);
 	return 0;
 }
 
@@ -1136,8 +1136,8 @@ void iwl_setup_rx_handlers(struct iwl_priv *priv)
 	init_waitqueue_head(&priv->shrd->notif_waitq);
 
 	/* Set up BT Rx handlers */
-	if (priv->cfg->lib->bt_rx_handler_setup)
-		priv->cfg->lib->bt_rx_handler_setup(priv);
+	if (cfg(priv)->lib->bt_rx_handler_setup)
+		cfg(priv)->lib->bt_rx_handler_setup(priv);
 
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index d21f535..1c66594 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -296,9 +296,9 @@ static int iwlagn_rxon_connect(struct iwl_priv *priv,
 	}
 
 	if (ctx->vif && ctx->vif->type == NL80211_IFTYPE_STATION &&
-	    priv->cfg->ht_params && priv->cfg->ht_params->smps_mode)
+	    cfg(priv)->ht_params && cfg(priv)->ht_params->smps_mode)
 		ieee80211_request_smps(ctx->vif,
-				       priv->cfg->ht_params->smps_mode);
+				       cfg(priv)->ht_params->smps_mode);
 
 	return 0;
 }
@@ -445,8 +445,8 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	 * force CTS-to-self frames protection if RTS-CTS is not preferred
 	 * one aggregation protection method
 	 */
-	if (!(priv->cfg->ht_params &&
-	      priv->cfg->ht_params->use_rts_for_aggregation))
+	if (!(cfg(priv)->ht_params &&
+	      cfg(priv)->ht_params->use_rts_for_aggregation))
 		ctx->staging.flags |= RXON_FLG_SELF_CTS_EN;
 
 	if ((ctx->vif && ctx->vif->bss_conf.use_short_slot) ||
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
index c27180a..b0dff7a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
@@ -633,7 +633,7 @@ void iwl_tt_initialize(struct iwl_priv *priv)
 	INIT_WORK(&priv->ct_enter, iwl_bg_ct_enter);
 	INIT_WORK(&priv->ct_exit, iwl_bg_ct_exit);
 
-	if (priv->cfg->base_params->adv_thermal_throttle) {
+	if (cfg(priv)->base_params->adv_thermal_throttle) {
 		IWL_DEBUG_TEMP(priv, "Advanced Thermal Throttling\n");
 		tt->restriction = kcalloc(IWL_TI_STATE_MAX,
 					  sizeof(struct iwl_tt_restriction),
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 81754cd..b484578 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -74,8 +74,8 @@ static void iwlagn_tx_cmd_build_basic(struct iwl_priv *priv,
 	else if (ieee80211_is_back_req(fc))
 		tx_flags |= TX_CMD_FLG_ACK_MSK | TX_CMD_FLG_IMM_BA_RSP_MASK;
 	else if (info->band == IEEE80211_BAND_2GHZ &&
-		 priv->cfg->bt_params &&
-		 priv->cfg->bt_params->advanced_bt_coexist &&
+		 cfg(priv)->bt_params &&
+		 cfg(priv)->bt_params->advanced_bt_coexist &&
 		 (ieee80211_is_auth(fc) || ieee80211_is_assoc_req(fc) ||
 		 ieee80211_is_reassoc_req(fc) ||
 		 skb->protocol == cpu_to_be16(ETH_P_PAE)))
@@ -191,8 +191,8 @@ static void iwlagn_tx_cmd_build_rate(struct iwl_priv *priv,
 		rate_flags |= RATE_MCS_CCK_MSK;
 
 	/* Set up antennas */
-	 if (priv->cfg->bt_params &&
-	     priv->cfg->bt_params->advanced_bt_coexist &&
+	 if (cfg(priv)->bt_params &&
+	     cfg(priv)->bt_params->advanced_bt_coexist &&
 	     priv->bt_full_concurrent) {
 		/* operated as 1x1 in full concurrency mode */
 		priv->mgmt_tx_ant = iwl_toggle_tx_ant(priv, priv->mgmt_tx_ant,
@@ -598,8 +598,8 @@ static void iwl_rx_reply_tx_agg(struct iwl_priv *priv,
 	 * notification again.
 	 */
 	if (tx_resp->bt_kill_count && tx_resp->frame_count == 1 &&
-	    priv->cfg->bt_params &&
-	    priv->cfg->bt_params->advanced_bt_coexist) {
+	    cfg(priv)->bt_params &&
+	    cfg(priv)->bt_params->advanced_bt_coexist) {
 		IWL_DEBUG_COEX(priv, "receive reply tx w/ bt_kill\n");
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index f5fe42d..5a9370d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -515,7 +515,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context);
 
 static int __must_check iwl_request_firmware(struct iwl_priv *priv, bool first)
 {
-	const char *name_pre = priv->cfg->fw_name_pre;
+	const char *name_pre = cfg(priv)->fw_name_pre;
 	char tag[8];
 
 	if (first) {
@@ -524,14 +524,14 @@ static int __must_check iwl_request_firmware(struct iwl_priv *priv, bool first)
 		strcpy(tag, UCODE_EXPERIMENTAL_TAG);
 	} else if (priv->fw_index == UCODE_EXPERIMENTAL_INDEX) {
 #endif
-		priv->fw_index = priv->cfg->ucode_api_max;
+		priv->fw_index = cfg(priv)->ucode_api_max;
 		sprintf(tag, "%d", priv->fw_index);
 	} else {
 		priv->fw_index--;
 		sprintf(tag, "%d", priv->fw_index);
 	}
 
-	if (priv->fw_index < priv->cfg->ucode_api_min) {
+	if (priv->fw_index < cfg(priv)->ucode_api_min) {
 		IWL_ERR(priv, "no suitable firmware found!\n");
 		return -ENOENT;
 	}
@@ -836,9 +836,9 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	struct iwl_ucode_header *ucode;
 	int err;
 	struct iwlagn_firmware_pieces pieces;
-	const unsigned int api_max = priv->cfg->ucode_api_max;
-	unsigned int api_ok = priv->cfg->ucode_api_ok;
-	const unsigned int api_min = priv->cfg->ucode_api_min;
+	const unsigned int api_max = cfg(priv)->ucode_api_max;
+	unsigned int api_ok = cfg(priv)->ucode_api_ok;
+	const unsigned int api_min = cfg(priv)->ucode_api_min;
 	u32 api_ver;
 	char buildstr[25];
 	u32 build;
@@ -1027,14 +1027,14 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 		priv->init_evtlog_size = (pieces.init_evtlog_size - 16)/12;
 	else
 		priv->init_evtlog_size =
-			priv->cfg->base_params->max_event_log_size;
+			cfg(priv)->base_params->max_event_log_size;
 	priv->init_errlog_ptr = pieces.init_errlog_ptr;
 	priv->inst_evtlog_ptr = pieces.inst_evtlog_ptr;
 	if (pieces.inst_evtlog_size)
 		priv->inst_evtlog_size = (pieces.inst_evtlog_size - 16)/12;
 	else
 		priv->inst_evtlog_size =
-			priv->cfg->base_params->max_event_log_size;
+			cfg(priv)->base_params->max_event_log_size;
 	priv->inst_errlog_ptr = pieces.inst_errlog_ptr;
 #ifndef CONFIG_IWLWIFI_P2P
 	ucode_capa.flags &= ~IWL_UCODE_TLV_FLAGS_PAN;
@@ -1043,7 +1043,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	priv->new_scan_threshold_behaviour =
 		!!(ucode_capa.flags & IWL_UCODE_TLV_FLAGS_NEWSCAN);
 
-	if (!(priv->cfg->sku & EEPROM_SKU_CAP_IPAN_ENABLE))
+	if (!(cfg(priv)->sku & EEPROM_SKU_CAP_IPAN_ENABLE))
 		ucode_capa.flags &= ~IWL_UCODE_TLV_FLAGS_PAN;
 
 	/*
@@ -1124,7 +1124,7 @@ static void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 	priv->thermal_throttle.ct_kill_toggle = false;
 
-	if (priv->cfg->base_params->support_ct_kill_exit) {
+	if (cfg(priv)->base_params->support_ct_kill_exit) {
 		adv_cmd.critical_temperature_enter =
 			cpu_to_le32(hw_params(priv).ct_kill_threshold);
 		adv_cmd.critical_temperature_exit =
@@ -1219,10 +1219,10 @@ int iwl_alive_start(struct iwl_priv *priv)
 		return -ERFKILL;
 
 	/* download priority table before any calibration request */
-	if (priv->cfg->bt_params &&
-	    priv->cfg->bt_params->advanced_bt_coexist) {
+	if (cfg(priv)->bt_params &&
+	    cfg(priv)->bt_params->advanced_bt_coexist) {
 		/* Configure Bluetooth device coexistence support */
-		if (priv->cfg->bt_params->bt_sco_disable)
+		if (cfg(priv)->bt_params->bt_sco_disable)
 			priv->bt_enable_pspoll = false;
 		else
 			priv->bt_enable_pspoll = true;
@@ -1261,7 +1261,7 @@ int iwl_alive_start(struct iwl_priv *priv)
 	priv->active_rate = IWL_RATES_MASK;
 
 	/* Configure Tx antenna selection based on H/W config */
-	iwlagn_send_tx_ant_config(priv, priv->cfg->valid_tx_ant);
+	iwlagn_send_tx_ant_config(priv, cfg(priv)->valid_tx_ant);
 
 	if (iwl_is_associated_ctx(ctx) && !priv->shrd->wowlan) {
 		struct iwl_rxon_cmd *active_rxon =
@@ -1330,9 +1330,9 @@ void __iwl_down(struct iwl_priv *priv)
 	priv->bt_status = 0;
 	priv->cur_rssi_ctx = NULL;
 	priv->bt_is_sco = 0;
-	if (priv->cfg->bt_params)
+	if (cfg(priv)->bt_params)
 		priv->bt_traffic_load =
-			 priv->cfg->bt_params->bt_init_traffic_load;
+			 cfg(priv)->bt_params->bt_init_traffic_load;
 	else
 		priv->bt_traffic_load = 0;
 	priv->bt_full_concurrent = false;
@@ -1514,8 +1514,8 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 
 	iwl_setup_scan_deferred_work(priv);
 
-	if (priv->cfg->lib->bt_setup_deferred_work)
-		priv->cfg->lib->bt_setup_deferred_work(priv);
+	if (cfg(priv)->lib->bt_setup_deferred_work)
+		cfg(priv)->lib->bt_setup_deferred_work(priv);
 
 	init_timer(&priv->statistics_periodic);
 	priv->statistics_periodic.data = (unsigned long)priv;
@@ -1532,8 +1532,8 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 
 static void iwl_cancel_deferred_work(struct iwl_priv *priv)
 {
-	if (priv->cfg->lib->cancel_deferred_work)
-		priv->cfg->lib->cancel_deferred_work(priv);
+	if (cfg(priv)->lib->cancel_deferred_work)
+		cfg(priv)->lib->cancel_deferred_work(priv);
 
 	cancel_work_sync(&priv->run_time_calib_work);
 	cancel_work_sync(&priv->beacon_update);
@@ -1602,8 +1602,8 @@ static int iwl_init_drv(struct iwl_priv *priv)
 	iwl_init_scan_params(priv);
 
 	/* init bt coex */
-	if (priv->cfg->bt_params &&
-	    priv->cfg->bt_params->advanced_bt_coexist) {
+	if (cfg(priv)->bt_params &&
+	    cfg(priv)->bt_params->advanced_bt_coexist) {
 		priv->kill_ack_mask = IWLAGN_BT_KILL_ACK_MASK_DEFAULT;
 		priv->kill_cts_mask = IWLAGN_BT_KILL_CTS_MASK_DEFAULT;
 		priv->bt_valid = IWLAGN_BT_ALL_VALID_MSK;
@@ -1668,17 +1668,17 @@ static int iwl_set_hw_params(struct iwl_priv *priv)
 			get_order(IWL_RX_BUF_SIZE_4K);
 
 	if (iwlagn_mod_params.disable_11n)
-		priv->cfg->sku &= ~EEPROM_SKU_CAP_11N_ENABLE;
+		cfg(priv)->sku &= ~EEPROM_SKU_CAP_11N_ENABLE;
 
 	hw_params(priv).num_ampdu_queues =
-		priv->cfg->base_params->num_of_ampdu_queues;
+		cfg(priv)->base_params->num_of_ampdu_queues;
 	hw_params(priv).shadow_reg_enable =
-		priv->cfg->base_params->shadow_reg_enable;
-	hw_params(priv).sku = priv->cfg->sku;
-	hw_params(priv).wd_timeout = priv->cfg->base_params->wd_timeout;
+		cfg(priv)->base_params->shadow_reg_enable;
+	hw_params(priv).sku = cfg(priv)->sku;
+	hw_params(priv).wd_timeout = cfg(priv)->base_params->wd_timeout;
 
 	/* Device-specific setup */
-	return priv->cfg->lib->set_hw_params(priv);
+	return cfg(priv)->lib->set_hw_params(priv);
 }
 
 
@@ -1757,7 +1757,7 @@ int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
 	iwl_debug_config(priv);
 
 	IWL_DEBUG_INFO(priv, "*** LOAD DRIVER ***\n");
-	priv->cfg = cfg;
+	cfg(priv) = cfg;
 
 	/* is antenna coupling more than 35dB ? */
 	priv->bt_ant_couple_ok =
@@ -1791,7 +1791,7 @@ int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
 	 ***********************/
 	hw_rev = iwl_hw_detect(priv);
 	IWL_INFO(priv, "Detected %s, REV=0x%X\n",
-		priv->cfg->name, hw_rev);
+		cfg(priv)->name, hw_rev);
 
 	err = iwl_trans_request_irq(trans(priv));
 	if (err)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 3b6f48b..d037f69 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -60,8 +60,8 @@ static void iwl_init_ht_hw_capab(const struct iwl_priv *priv,
 
 	ht_info->ht_supported = true;
 
-	if (priv->cfg->ht_params &&
-	    priv->cfg->ht_params->ht_greenfield_support)
+	if (cfg(priv)->ht_params &&
+	    cfg(priv)->ht_params->ht_greenfield_support)
 		ht_info->cap |= IEEE80211_HT_CAP_GRN_FLD;
 	ht_info->cap |= IEEE80211_HT_CAP_SGI_20;
 	max_bit_rate = MAX_BIT_RATE_20_MHZ;
@@ -76,11 +76,11 @@ static void iwl_init_ht_hw_capab(const struct iwl_priv *priv,
 		ht_info->cap |= IEEE80211_HT_CAP_MAX_AMSDU;
 
 	ht_info->ampdu_factor = CFG_HT_RX_AMPDU_FACTOR_DEF;
-	if (priv->cfg->bt_params && priv->cfg->bt_params->ampdu_factor)
-		ht_info->ampdu_factor = priv->cfg->bt_params->ampdu_factor;
+	if (cfg(priv)->bt_params && cfg(priv)->bt_params->ampdu_factor)
+		ht_info->ampdu_factor = cfg(priv)->bt_params->ampdu_factor;
 	ht_info->ampdu_density = CFG_HT_MPDU_DENSITY_DEF;
-	if (priv->cfg->bt_params && priv->cfg->bt_params->ampdu_density)
-		ht_info->ampdu_density = priv->cfg->bt_params->ampdu_density;
+	if (cfg(priv)->bt_params && cfg(priv)->bt_params->ampdu_density)
+		ht_info->ampdu_density = cfg(priv)->bt_params->ampdu_density;
 
 	ht_info->mcs.rx_mask[0] = 0xFF;
 	if (rx_chains_num >= 2)
@@ -141,7 +141,7 @@ int iwl_init_geos(struct iwl_priv *priv)
 	sband->bitrates = &rates[IWL_FIRST_OFDM_RATE];
 	sband->n_bitrates = IWL_RATE_COUNT_LEGACY - IWL_FIRST_OFDM_RATE;
 
-	if (priv->cfg->sku & EEPROM_SKU_CAP_11N_ENABLE)
+	if (cfg(priv)->sku & EEPROM_SKU_CAP_11N_ENABLE)
 		iwl_init_ht_hw_capab(priv, &sband->ht_cap,
 					 IEEE80211_BAND_5GHZ);
 
@@ -151,7 +151,7 @@ int iwl_init_geos(struct iwl_priv *priv)
 	sband->bitrates = rates;
 	sband->n_bitrates = IWL_RATE_COUNT_LEGACY;
 
-	if (priv->cfg->sku & EEPROM_SKU_CAP_11N_ENABLE)
+	if (cfg(priv)->sku & EEPROM_SKU_CAP_11N_ENABLE)
 		iwl_init_ht_hw_capab(priv, &sband->ht_cap,
 					 IEEE80211_BAND_2GHZ);
 
@@ -206,12 +206,12 @@ int iwl_init_geos(struct iwl_priv *priv)
 	priv->tx_power_next = max_tx_power;
 
 	if ((priv->bands[IEEE80211_BAND_5GHZ].n_channels == 0) &&
-	     priv->cfg->sku & EEPROM_SKU_CAP_BAND_52GHZ) {
+	     cfg(priv)->sku & EEPROM_SKU_CAP_BAND_52GHZ) {
 		char buf[32];
 		bus_get_hw_id(bus(priv), buf, sizeof(buf));
 		IWL_INFO(priv, "Incorrectly detected BG card as ABG. "
 			"Please send your %s to maintainer.\n", buf);
-		priv->cfg->sku &= ~EEPROM_SKU_CAP_BAND_52GHZ;
+		cfg(priv)->sku &= ~EEPROM_SKU_CAP_BAND_52GHZ;
 	}
 
 	IWL_INFO(priv, "Tunable channels: %d 802.11bg, %d 802.11a channels\n",
@@ -966,9 +966,9 @@ int iwl_apm_init(struct iwl_priv *priv)
 	bus_apm_config(bus(priv));
 
 	/* Configure analog phase-lock-loop before activating to D0A */
-	if (priv->cfg->base_params->pll_cfg_val)
+	if (cfg(priv)->base_params->pll_cfg_val)
 		iwl_set_bit(bus(priv), CSR_ANA_PLL_CFG,
-			    priv->cfg->base_params->pll_cfg_val);
+			    cfg(priv)->base_params->pll_cfg_val);
 
 	/*
 	 * Set "initialization complete" bit to move adapter from
@@ -1465,7 +1465,7 @@ void iwl_bg_watchdog(unsigned long data)
 	if (iwl_is_rfkill(priv->shrd))
 		return;
 
-	timeout = priv->cfg->base_params->wd_timeout;
+	timeout = cfg(priv)->base_params->wd_timeout;
 	if (timeout == 0)
 		return;
 
@@ -1490,11 +1490,11 @@ void iwl_bg_watchdog(unsigned long data)
 
 void iwl_setup_watchdog(struct iwl_priv *priv)
 {
-	unsigned int timeout = priv->cfg->base_params->wd_timeout;
+	unsigned int timeout = cfg(priv)->base_params->wd_timeout;
 
 	if (!iwlagn_mod_params.wd_disable) {
 		/* use system default */
-		if (timeout && !priv->cfg->base_params->wd_disable)
+		if (timeout && !cfg(priv)->base_params->wd_disable)
 			mod_timer(&priv->watchdog,
 				jiffies +
 				msecs_to_jiffies(IWL_WD_TICK(timeout)));
@@ -1619,8 +1619,7 @@ void iwl_set_hw_rfkill_state(struct iwl_priv *priv, bool state)
 
 void iwl_nic_config(struct iwl_priv *priv)
 {
-	priv->cfg->lib->nic_config(priv);
-
+	cfg(priv)->lib->nic_config(priv);
 }
 
 void iwl_free_skb(struct iwl_priv *priv, struct sk_buff *skb)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 6da53a3..792e802 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -165,77 +165,6 @@ struct iwl_ht_params {
 	enum ieee80211_smps_mode smps_mode;
 };
 
-/**
- * struct iwl_cfg
- * @name: Offical name of the device
- * @fw_name_pre: Firmware filename prefix. The api version and extension
- *	(.ucode) will be added to filename before loading from disk. The
- *	filename is constructed as fw_name_pre<api>.ucode.
- * @ucode_api_max: Highest version of uCode API supported by driver.
- * @ucode_api_ok: oldest version of the uCode API that is OK to load
- *	without a warning, for use in transitions
- * @ucode_api_min: Lowest version of uCode API supported by driver.
- * @valid_tx_ant: valid transmit antenna
- * @valid_rx_ant: valid receive antenna
- * @sku: sku information from EEPROM
- * @eeprom_ver: EEPROM version
- * @eeprom_calib_ver: EEPROM calibration version
- * @lib: pointer to the lib ops
- * @additional_nic_config: additional nic configuration
- * @base_params: pointer to basic parameters
- * @ht_params: point to ht patameters
- * @bt_params: pointer to bt parameters
- * @pa_type: used by 6000 series only to identify the type of Power Amplifier
- * @need_temp_offset_calib: need to perform temperature offset calibration
- * @no_xtal_calib: some devices do not need crystal calibration data,
- *	don't send it to those
- * @scan_antennas: available antenna for scan operation
- * @led_mode: 0=blinking, 1=On(RF On)/Off(RF Off)
- * @adv_pm: advance power management
- * @rx_with_siso_diversity: 1x1 device with rx antenna diversity
- * @internal_wimax_coex: internal wifi/wimax combo device
- * @iq_invert: I/Q inversion
- * @temp_offset_v2: support v2 of temperature offset calibration
- *
- * We enable the driver to be backward compatible wrt API version. The
- * driver specifies which APIs it supports (with @ucode_api_max being the
- * highest and @ucode_api_min the lowest). Firmware will only be loaded if
- * it has a supported API version.
- *
- * The ideal usage of this infrastructure is to treat a new ucode API
- * release as a new hardware revision.
- */
-struct iwl_cfg {
-	/* params specific to an individual device within a device family */
-	const char *name;
-	const char *fw_name_pre;
-	const unsigned int ucode_api_max;
-	const unsigned int ucode_api_ok;
-	const unsigned int ucode_api_min;
-	u8   valid_tx_ant;
-	u8   valid_rx_ant;
-	u16  sku;
-	u16  eeprom_ver;
-	u16  eeprom_calib_ver;
-	const struct iwl_lib_ops *lib;
-	void (*additional_nic_config)(struct iwl_priv *priv);
-	/* params not likely to change within a device family */
-	struct iwl_base_params *base_params;
-	/* params likely to change within a device family */
-	struct iwl_ht_params *ht_params;
-	struct iwl_bt_params *bt_params;
-	enum iwl_pa_type pa_type;	  /* if used set to IWL_PA_SYSTEM */
-	const bool need_temp_offset_calib; /* if used set to true */
-	const bool no_xtal_calib;
-	u8 scan_rx_antennas[IEEE80211_NUM_BANDS];
-	enum iwl_led_mode led_mode;
-	const bool adv_pm;
-	const bool rx_with_siso_diversity;
-	const bool internal_wimax_coex;
-	const bool iq_invert;
-	const bool temp_offset_v2;
-};
-
 /***************************
  *   L i b                 *
  ***************************/
@@ -368,8 +297,8 @@ static inline const struct ieee80211_supported_band *iwl_get_hw_mode(
 
 static inline bool iwl_advanced_bt_coexist(struct iwl_priv *priv)
 {
-	return priv->cfg->bt_params &&
-	       priv->cfg->bt_params->advanced_bt_coexist;
+	return cfg(priv)->bt_params &&
+	       cfg(priv)->bt_params->advanced_bt_coexist;
 }
 
 static inline void iwl_enable_rfkill_int(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 6bf6845..074068e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -408,7 +408,7 @@ static ssize_t iwl_dbgfs_nvm_read(struct file *file,
 	const u8 *ptr;
 	char *buf;
 	u16 eeprom_ver;
-	size_t eeprom_len = priv->cfg->base_params->eeprom_size;
+	size_t eeprom_len = cfg(priv)->base_params->eeprom_size;
 	buf_size = 4 * eeprom_len + 256;
 
 	if (eeprom_len % 16) {
@@ -1542,15 +1542,15 @@ static ssize_t iwl_dbgfs_ucode_tx_stats_read(struct file *file,
 	if (tx->tx_power.ant_a || tx->tx_power.ant_b || tx->tx_power.ant_c) {
 		pos += scnprintf(buf + pos, bufsz - pos,
 			"tx power: (1/2 dB step)\n");
-		if ((priv->cfg->valid_tx_ant & ANT_A) && tx->tx_power.ant_a)
+		if ((cfg(priv)->valid_tx_ant & ANT_A) && tx->tx_power.ant_a)
 			pos += scnprintf(buf + pos, bufsz - pos,
 					fmt_hex, "antenna A:",
 					tx->tx_power.ant_a);
-		if ((priv->cfg->valid_tx_ant & ANT_B) && tx->tx_power.ant_b)
+		if ((cfg(priv)->valid_tx_ant & ANT_B) && tx->tx_power.ant_b)
 			pos += scnprintf(buf + pos, bufsz - pos,
 					fmt_hex, "antenna B:",
 					tx->tx_power.ant_b);
-		if ((priv->cfg->valid_tx_ant & ANT_C) && tx->tx_power.ant_c)
+		if ((cfg(priv)->valid_tx_ant & ANT_C) && tx->tx_power.ant_c)
 			pos += scnprintf(buf + pos, bufsz - pos,
 					fmt_hex, "antenna C:",
 					tx->tx_power.ant_c);
@@ -2221,7 +2221,7 @@ static ssize_t iwl_dbgfs_plcp_delta_read(struct file *file,
 	const size_t bufsz = sizeof(buf);
 
 	pos += scnprintf(buf + pos, bufsz - pos, "%u\n",
-			priv->cfg->base_params->plcp_delta_threshold);
+			cfg(priv)->base_params->plcp_delta_threshold);
 
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
@@ -2243,10 +2243,10 @@ static ssize_t iwl_dbgfs_plcp_delta_write(struct file *file,
 		return -EINVAL;
 	if ((plcp < IWL_MAX_PLCP_ERR_THRESHOLD_MIN) ||
 		(plcp > IWL_MAX_PLCP_ERR_THRESHOLD_MAX))
-		priv->cfg->base_params->plcp_delta_threshold =
+		cfg(priv)->base_params->plcp_delta_threshold =
 			IWL_MAX_PLCP_ERR_THRESHOLD_DISABLE;
 	else
-		priv->cfg->base_params->plcp_delta_threshold = plcp;
+		cfg(priv)->base_params->plcp_delta_threshold = plcp;
 	return count;
 }
 
@@ -2348,7 +2348,7 @@ static ssize_t iwl_dbgfs_wd_timeout_write(struct file *file,
 	if (timeout < 0 || timeout > IWL_MAX_WD_TIMEOUT)
 		timeout = IWL_DEF_WD_TIMEOUT;
 
-	priv->cfg->base_params->wd_timeout = timeout;
+	cfg(priv)->base_params->wd_timeout = timeout;
 	iwl_setup_watchdog(priv);
 	return count;
 }
@@ -2408,10 +2408,10 @@ static ssize_t iwl_dbgfs_protection_mode_read(struct file *file,
 	char buf[40];
 	const size_t bufsz = sizeof(buf);
 
-	if (priv->cfg->ht_params)
+	if (cfg(priv)->ht_params)
 		pos += scnprintf(buf + pos, bufsz - pos,
 			 "use %s for aggregation\n",
-			 (priv->cfg->ht_params->use_rts_for_aggregation) ?
+			 (cfg(priv)->ht_params->use_rts_for_aggregation) ?
 				"rts/cts" : "cts-to-self");
 	else
 		pos += scnprintf(buf + pos, bufsz - pos, "N/A");
@@ -2428,7 +2428,7 @@ static ssize_t iwl_dbgfs_protection_mode_write(struct file *file,
 	int buf_size;
 	int rts;
 
-	if (!priv->cfg->ht_params)
+	if (!cfg(priv)->ht_params)
 		return -EINVAL;
 
 	memset(buf, 0, sizeof(buf));
@@ -2438,9 +2438,9 @@ static ssize_t iwl_dbgfs_protection_mode_write(struct file *file,
 	if (sscanf(buf, "%d", &rts) != 1)
 		return -EINVAL;
 	if (rts)
-		priv->cfg->ht_params->use_rts_for_aggregation = true;
+		cfg(priv)->ht_params->use_rts_for_aggregation = true;
 	else
-		priv->cfg->ht_params->use_rts_for_aggregation = false;
+		cfg(priv)->ht_params->use_rts_for_aggregation = false;
 	return count;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 69ecf6e..f1317a6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -512,16 +512,6 @@ enum iwl_access_mode {
 	IWL_OTP_ACCESS_RELATIVE,
 };
 
-/**
- * enum iwl_pa_type - Power Amplifier type
- * @IWL_PA_SYSTEM:  based on uCode configuration
- * @IWL_PA_INTERNAL: use Internal only
- */
-enum iwl_pa_type {
-	IWL_PA_SYSTEM = 0,
-	IWL_PA_INTERNAL = 1,
-};
-
 /* reply_tx_statistics (for _agn devices) */
 struct reply_tx_error_statistics {
 	u32 pp_delay;
@@ -776,7 +766,6 @@ struct iwl_priv {
 	struct ieee80211_channel *ieee_channels;
 	struct ieee80211_rate *ieee_rates;
 	struct kmem_cache *tx_cmd_pool;
-	struct iwl_cfg *cfg;
 
 	enum ieee80211_band band;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 6fcc7d5..c1eda97 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -230,8 +230,8 @@ int iwl_eeprom_check_version(struct iwl_priv *priv)
 	eeprom_ver = iwl_eeprom_query16(priv->shrd, EEPROM_VERSION);
 	calib_ver = iwl_eeprom_calib_version(priv->shrd);
 
-	if (eeprom_ver < priv->cfg->eeprom_ver ||
-	    calib_ver < priv->cfg->eeprom_calib_ver)
+	if (eeprom_ver < cfg(priv)->eeprom_ver ||
+	    calib_ver < cfg(priv)->eeprom_calib_ver)
 		goto err;
 
 	IWL_INFO(priv, "device EEPROM VER=0x%x, CALIB=0x%x\n",
@@ -241,8 +241,8 @@ int iwl_eeprom_check_version(struct iwl_priv *priv)
 err:
 	IWL_ERR(priv, "Unsupported (too old) EEPROM VER=0x%x < 0x%x "
 		  "CALIB=0x%x < 0x%x\n",
-		  eeprom_ver, priv->cfg->eeprom_ver,
-		  calib_ver,  priv->cfg->eeprom_calib_ver);
+		  eeprom_ver, cfg(priv)->eeprom_ver,
+		  calib_ver,  cfg(priv)->eeprom_calib_ver);
 	return -EINVAL;
 
 }
@@ -252,35 +252,35 @@ int iwl_eeprom_check_sku(struct iwl_priv *priv)
 	struct iwl_shared *shrd = priv->shrd;
 	u16 radio_cfg;
 
-	if (!priv->cfg->sku) {
+	if (!cfg(priv)->sku) {
 		/* not using sku overwrite */
-		priv->cfg->sku = iwl_eeprom_query16(shrd, EEPROM_SKU_CAP);
-		if (priv->cfg->sku & EEPROM_SKU_CAP_11N_ENABLE &&
-		    !priv->cfg->ht_params) {
+		cfg(priv)->sku = iwl_eeprom_query16(shrd, EEPROM_SKU_CAP);
+		if (cfg(priv)->sku & EEPROM_SKU_CAP_11N_ENABLE &&
+		    !cfg(priv)->ht_params) {
 			IWL_ERR(priv, "Invalid 11n configuration\n");
 			return -EINVAL;
 		}
 	}
-	if (!priv->cfg->sku) {
+	if (!cfg(priv)->sku) {
 		IWL_ERR(priv, "Invalid device sku\n");
 		return -EINVAL;
 	}
 
-	IWL_INFO(priv, "Device SKU: 0X%x\n", priv->cfg->sku);
+	IWL_INFO(priv, "Device SKU: 0x%X\n", cfg(priv)->sku);
 
-	if (!priv->cfg->valid_tx_ant && !priv->cfg->valid_rx_ant) {
+	if (!cfg(priv)->valid_tx_ant && !cfg(priv)->valid_rx_ant) {
 		/* not using .cfg overwrite */
 		radio_cfg = iwl_eeprom_query16(shrd, EEPROM_RADIO_CONFIG);
-		priv->cfg->valid_tx_ant = EEPROM_RF_CFG_TX_ANT_MSK(radio_cfg);
-		priv->cfg->valid_rx_ant = EEPROM_RF_CFG_RX_ANT_MSK(radio_cfg);
-		if (!priv->cfg->valid_tx_ant || !priv->cfg->valid_rx_ant) {
-			IWL_ERR(priv, "Invalid chain (0X%x, 0X%x)\n",
-				priv->cfg->valid_tx_ant,
-				priv->cfg->valid_rx_ant);
+		cfg(priv)->valid_tx_ant = EEPROM_RF_CFG_TX_ANT_MSK(radio_cfg);
+		cfg(priv)->valid_rx_ant = EEPROM_RF_CFG_RX_ANT_MSK(radio_cfg);
+		if (!cfg(priv)->valid_tx_ant || !cfg(priv)->valid_rx_ant) {
+			IWL_ERR(priv, "Invalid chain (0x%X, 0x%X)\n",
+				cfg(priv)->valid_tx_ant,
+				cfg(priv)->valid_rx_ant);
 			return -EINVAL;
 		}
-		IWL_INFO(priv, "Valid Tx ant: 0X%x, Valid Rx ant: 0X%x\n",
-			 priv->cfg->valid_tx_ant, priv->cfg->valid_rx_ant);
+		IWL_INFO(priv, "Valid Tx ant: 0x%X, Valid Rx ant: 0x%X\n",
+			 cfg(priv)->valid_tx_ant, cfg(priv)->valid_rx_ant);
 	}
 	/*
 	 * for some special cases,
@@ -369,7 +369,7 @@ static int iwl_init_otp_access(struct iwl_bus *bus)
 		 * CSR auto clock gate disable bit -
 		 * this is only applicable for HW with OTP shadow RAM
 		 */
-		if (priv(bus)->cfg->base_params->shadow_ram_support)
+		if (cfg(bus)->base_params->shadow_ram_support)
 			iwl_set_bit(bus, CSR_DBG_LINK_PWR_MGMT_REG,
 				CSR_RESET_LINK_PWR_MGMT_DISABLED);
 	}
@@ -489,7 +489,7 @@ static int iwl_find_otp_image(struct iwl_bus *bus,
 		}
 		/* more in the link list, continue */
 		usedblocks++;
-	} while (usedblocks <= priv(bus)->cfg->base_params->max_ll_items);
+	} while (usedblocks <= cfg(bus)->base_params->max_ll_items);
 
 	/* OTP has no valid blocks */
 	IWL_DEBUG_EEPROM(bus, "OTP has no valid blocks\n");
@@ -629,7 +629,7 @@ void iwl_eeprom_enhanced_txpower(struct iwl_priv *priv)
 				 ((txp->delta_20_in_40 & 0xf0) >> 4),
 				 (txp->delta_20_in_40 & 0x0f));
 
-		max_txp_avg = iwl_get_max_txpower_avg(priv->cfg, txp_array, idx,
+		max_txp_avg = iwl_get_max_txpower_avg(cfg(priv), txp_array, idx,
 						      &max_txp_avg_halfdbm);
 
 		/*
@@ -667,7 +667,7 @@ int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
 	if (trans(priv)->nvm_device_type == -ENOENT)
 		return -ENOENT;
 	/* allocate eeprom */
-	sz = priv->cfg->base_params->eeprom_size;
+	sz = cfg(priv)->base_params->eeprom_size;
 	IWL_DEBUG_EEPROM(priv, "NVM size = %d\n", sz);
 	shrd->eeprom = kzalloc(sz, GFP_KERNEL);
 	if (!shrd->eeprom) {
@@ -709,7 +709,7 @@ int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
 			     CSR_OTP_GP_REG_ECC_CORR_STATUS_MSK |
 			     CSR_OTP_GP_REG_ECC_UNCORR_STATUS_MSK);
 		/* traversing the linked list if no shadow ram supported */
-		if (!priv->cfg->base_params->shadow_ram_support) {
+		if (!cfg(priv)->base_params->shadow_ram_support) {
 			if (iwl_find_otp_image(bus(priv), &validblockaddr)) {
 				ret = -ENOENT;
 				goto done;
@@ -776,7 +776,7 @@ static void iwl_init_band_reference(const struct iwl_priv *priv,
 			const u8 **eeprom_ch_index)
 {
 	struct iwl_shared *shrd = priv->shrd;
-	u32 offset = priv->cfg->lib->
+	u32 offset = cfg(priv)->lib->
 			eeprom_ops.regulatory_bands[eep_band - 1];
 	switch (eep_band) {
 	case 1:		/* 2.4GHz band */
@@ -983,9 +983,9 @@ int iwl_init_channel_map(struct iwl_priv *priv)
 	}
 
 	/* Check if we do have HT40 channels */
-	if (priv->cfg->lib->eeprom_ops.regulatory_bands[5] ==
+	if (cfg(priv)->lib->eeprom_ops.regulatory_bands[5] ==
 	    EEPROM_REGULATORY_BAND_NO_HT40 &&
-	    priv->cfg->lib->eeprom_ops.regulatory_bands[6] ==
+	    cfg(priv)->lib->eeprom_ops.regulatory_bands[6] ==
 	    EEPROM_REGULATORY_BAND_NO_HT40)
 		return 0;
 
@@ -1021,8 +1021,8 @@ int iwl_init_channel_map(struct iwl_priv *priv)
 	 * driver need to process addition information
 	 * to determine the max channel tx power limits
 	 */
-	if (priv->cfg->lib->eeprom_ops.update_enhanced_txpower)
-		priv->cfg->lib->eeprom_ops.update_enhanced_txpower(priv);
+	if (cfg(priv)->lib->eeprom_ops.update_enhanced_txpower)
+		cfg(priv)->lib->eeprom_ops.update_enhanced_txpower(priv);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index eb54173..14dcbfc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -137,11 +137,11 @@ static int iwl_led_cmd(struct iwl_priv *priv,
 	}
 
 	IWL_DEBUG_LED(priv, "Led blink time compensation=%u\n",
-			priv->cfg->base_params->led_compensation);
+			cfg(priv)->base_params->led_compensation);
 	led_cmd.on = iwl_blink_compensation(priv, on,
-				priv->cfg->base_params->led_compensation);
+				cfg(priv)->base_params->led_compensation);
 	led_cmd.off = iwl_blink_compensation(priv, off,
-				priv->cfg->base_params->led_compensation);
+				cfg(priv)->base_params->led_compensation);
 
 	ret = iwl_send_led_cmd(priv, &led_cmd);
 	if (!ret) {
@@ -178,7 +178,7 @@ void iwl_leds_init(struct iwl_priv *priv)
 	int ret;
 
 	if (mode == IWL_LED_DEFAULT)
-		mode = priv->cfg->led_mode;
+		mode = cfg(priv)->led_mode;
 
 	priv->led.name = kasprintf(GFP_KERNEL, "%s-led",
 				   wiphy_name(priv->hw->wiphy));
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.h b/drivers/net/wireless/iwlwifi/iwl-led.h
index 1c93dfe..2550b3c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.h
+++ b/drivers/net/wireless/iwlwifi/iwl-led.h
@@ -36,20 +36,6 @@ struct iwl_priv;
 #define IWL_LED_ACTIVITY       (0<<1)
 #define IWL_LED_LINK           (1<<1)
 
-/*
- * LED mode
- *    IWL_LED_DEFAULT:  use device default
- *    IWL_LED_RF_STATE: turn LED on/off based on RF state
- *			LED ON  = RF ON
- *			LED OFF = RF OFF
- *    IWL_LED_BLINK:    adjust led blink rate based on blink table
- */
-enum iwl_led_mode {
-	IWL_LED_DEFAULT,
-	IWL_LED_RF_STATE,
-	IWL_LED_BLINK,
-};
-
 void iwlagn_led_enable(struct iwl_priv *priv);
 void iwl_leds_init(struct iwl_priv *priv);
 void iwl_leds_exit(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index e3944f4..4aedd72 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -160,7 +160,7 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 	hw->flags |= IEEE80211_HW_SUPPORTS_PS |
 		     IEEE80211_HW_SUPPORTS_DYNAMIC_PS;
 
-	if (priv->cfg->sku & EEPROM_SKU_CAP_11N_ENABLE)
+	if (cfg(priv)->sku & EEPROM_SKU_CAP_11N_ENABLE)
 		hw->flags |= IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS |
 			     IEEE80211_HW_SUPPORTS_STATIC_SMPS;
 
@@ -616,7 +616,7 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 	IWL_DEBUG_HT(priv, "A-MPDU action on addr %pM tid %d\n",
 		     sta->addr, tid);
 
-	if (!(priv->cfg->sku & EEPROM_SKU_CAP_11N_ENABLE))
+	if (!(cfg(priv)->sku & EEPROM_SKU_CAP_11N_ENABLE))
 		return -EACCES;
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
@@ -647,8 +647,8 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 		}
 		if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
 			ret = 0;
-		if (!priv->agg_tids_count && priv->cfg->ht_params &&
-		    priv->cfg->ht_params->use_rts_for_aggregation) {
+		if (!priv->agg_tids_count && cfg(priv)->ht_params &&
+		    cfg(priv)->ht_params->use_rts_for_aggregation) {
 			/*
 			 * switch off RTS/CTS if it was previously enabled
 			 */
@@ -684,8 +684,8 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 		sta_priv->max_agg_bufsize =
 			min(sta_priv->max_agg_bufsize, buf_size);
 
-		if (priv->cfg->ht_params &&
-		    priv->cfg->ht_params->use_rts_for_aggregation) {
+		if (cfg(priv)->ht_params &&
+		    cfg(priv)->ht_params->use_rts_for_aggregation) {
 			/*
 			 * switch to RTS/CTS if it is the prefer protection
 			 * method for HT traffic
@@ -792,7 +792,7 @@ static void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
 	if (!iwl_is_associated_ctx(ctx))
 		goto out;
 
-	if (!priv->cfg->lib->set_channel_switch)
+	if (!cfg(priv)->lib->set_channel_switch)
 		goto out;
 
 	ch = channel->hw_value;
@@ -832,7 +832,7 @@ static void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
 	 */
 	set_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->shrd->status);
 	priv->switch_channel = cpu_to_le16(ch);
-	if (priv->cfg->lib->set_channel_switch(priv, ch_switch)) {
+	if (cfg(priv)->lib->set_channel_switch(priv, ch_switch)) {
 		clear_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->shrd->status);
 		priv->switch_channel = 0;
 		ieee80211_chswitch_done(ctx->vif, false);
@@ -1125,8 +1125,8 @@ static void iwlagn_mac_rssi_callback(struct ieee80211_hw *hw,
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 	mutex_lock(&priv->shrd->mutex);
 
-	if (priv->cfg->bt_params &&
-			priv->cfg->bt_params->advanced_bt_coexist) {
+	if (cfg(priv)->bt_params &&
+			cfg(priv)->bt_params->advanced_bt_coexist) {
 		if (rssi_event == RSSI_EVENT_LOW)
 			priv->bt_enable_pspoll = true;
 		else if (rssi_event == RSSI_EVENT_HIGH)
@@ -1237,7 +1237,7 @@ static int iwl_setup_interface(struct iwl_priv *priv,
 		return err;
 	}
 
-	if (priv->cfg->bt_params && priv->cfg->bt_params->advanced_bt_coexist &&
+	if (cfg(priv)->bt_params && cfg(priv)->bt_params->advanced_bt_coexist &&
 	    vif->type == NL80211_IFTYPE_ADHOC) {
 		/*
 		 * pretend to have high BT traffic as long as we
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 4eaab20..2b188a6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -167,7 +167,7 @@ static void iwl_static_sleep_cmd(struct iwl_priv *priv,
 	u8 skip;
 	u32 slp_itrvl;
 
-	if (priv->cfg->adv_pm) {
+	if (cfg(priv)->adv_pm) {
 		table = apm_range_2;
 		if (period <= IWL_DTIM_RANGE_1_MAX)
 			table = apm_range_1;
@@ -221,7 +221,7 @@ static void iwl_static_sleep_cmd(struct iwl_priv *priv,
 		cmd->flags &= ~IWL_POWER_SHADOW_REG_ENA;
 
 	if (iwl_advanced_bt_coexist(priv)) {
-		if (!priv->cfg->bt_params->bt_sco_disable)
+		if (!cfg(priv)->bt_params->bt_sco_disable)
 			cmd->flags |= IWL_POWER_BT_SCO_ENA;
 		else
 			cmd->flags &= ~IWL_POWER_BT_SCO_ENA;
@@ -307,7 +307,7 @@ static void iwl_power_fill_sleep_cmd(struct iwl_priv *priv,
 		cmd->flags &= ~IWL_POWER_SHADOW_REG_ENA;
 
 	if (iwl_advanced_bt_coexist(priv)) {
-		if (!priv->cfg->bt_params->bt_sco_disable)
+		if (!cfg(priv)->bt_params->bt_sco_disable)
 			cmd->flags |= IWL_POWER_BT_SCO_ENA;
 		else
 			cmd->flags &= ~IWL_POWER_BT_SCO_ENA;
@@ -350,7 +350,7 @@ static void iwl_power_build_cmd(struct iwl_priv *priv,
 
 	if (priv->shrd->wowlan)
 		iwl_static_sleep_cmd(priv, cmd, IWL_POWER_INDEX_5, dtimper);
-	else if (!priv->cfg->base_params->no_idle_support &&
+	else if (!cfg(priv)->base_params->no_idle_support &&
 		 priv->hw->conf.flags & IEEE80211_CONF_IDLE)
 		iwl_static_sleep_cmd(priv, cmd, IWL_POWER_INDEX_5, 20);
 	else if (iwl_tt_is_low_power_state(priv)) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 359d218..084aa2c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -691,8 +691,8 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		 * Internal scans are passive, so we can indiscriminately set
 		 * the BT ignore flag on 2.4 GHz since it applies to TX only.
 		 */
-		if (priv->cfg->bt_params &&
-		    priv->cfg->bt_params->advanced_bt_coexist)
+		if (cfg(priv)->bt_params &&
+		    cfg(priv)->bt_params->advanced_bt_coexist)
 			scan->tx_cmd.tx_flags |= TX_CMD_FLG_IGNORE_BT;
 		break;
 	case IEEE80211_BAND_5GHZ:
@@ -733,12 +733,12 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 
 	band = priv->scan_band;
 
-	if (priv->cfg->scan_rx_antennas[band])
-		rx_ant = priv->cfg->scan_rx_antennas[band];
+	if (cfg(priv)->scan_rx_antennas[band])
+		rx_ant = cfg(priv)->scan_rx_antennas[band];
 
 	if (band == IEEE80211_BAND_2GHZ &&
-	    priv->cfg->bt_params &&
-	    priv->cfg->bt_params->advanced_bt_coexist) {
+	    cfg(priv)->bt_params &&
+	    cfg(priv)->bt_params->advanced_bt_coexist) {
 		/* transmit 2.4 GHz probes only on first antenna */
 		scan_tx_antennas = first_antenna(scan_tx_antennas);
 	}
@@ -762,8 +762,8 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 
 		rx_ant = first_antenna(active_chains);
 	}
-	if (priv->cfg->bt_params &&
-	    priv->cfg->bt_params->advanced_bt_coexist &&
+	if (cfg(priv)->bt_params &&
+	    cfg(priv)->bt_params->advanced_bt_coexist &&
 	    priv->bt_full_concurrent) {
 		/* operated as 1x1 in full concurrency mode */
 		rx_ant = first_antenna(rx_ant);
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 29a7284..df6d212 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -94,7 +94,6 @@
  * This implementation is iwl-pci.c
  */
 
-struct iwl_cfg;
 struct iwl_bus;
 struct iwl_priv;
 struct iwl_trans;
@@ -304,6 +303,101 @@ struct iwl_notification_wait {
 };
 
 /**
+ * enum iwl_pa_type - Power Amplifier type
+ * @IWL_PA_SYSTEM:  based on uCode configuration
+ * @IWL_PA_INTERNAL: use Internal only
+ */
+enum iwl_pa_type {
+	IWL_PA_SYSTEM = 0,
+	IWL_PA_INTERNAL = 1,
+};
+
+/*
+ * LED mode
+ *    IWL_LED_DEFAULT:  use device default
+ *    IWL_LED_RF_STATE: turn LED on/off based on RF state
+ *			LED ON  = RF ON
+ *			LED OFF = RF OFF
+ *    IWL_LED_BLINK:    adjust led blink rate based on blink table
+ */
+enum iwl_led_mode {
+	IWL_LED_DEFAULT,
+	IWL_LED_RF_STATE,
+	IWL_LED_BLINK,
+};
+
+/**
+ * struct iwl_cfg
+ * @name: Offical name of the device
+ * @fw_name_pre: Firmware filename prefix. The api version and extension
+ *	(.ucode) will be added to filename before loading from disk. The
+ *	filename is constructed as fw_name_pre<api>.ucode.
+ * @ucode_api_max: Highest version of uCode API supported by driver.
+ * @ucode_api_ok: oldest version of the uCode API that is OK to load
+ *	without a warning, for use in transitions
+ * @ucode_api_min: Lowest version of uCode API supported by driver.
+ * @valid_tx_ant: valid transmit antenna
+ * @valid_rx_ant: valid receive antenna
+ * @sku: sku information from EEPROM
+ * @eeprom_ver: EEPROM version
+ * @eeprom_calib_ver: EEPROM calibration version
+ * @lib: pointer to the lib ops
+ * @additional_nic_config: additional nic configuration
+ * @base_params: pointer to basic parameters
+ * @ht_params: point to ht patameters
+ * @bt_params: pointer to bt parameters
+ * @pa_type: used by 6000 series only to identify the type of Power Amplifier
+ * @need_temp_offset_calib: need to perform temperature offset calibration
+ * @no_xtal_calib: some devices do not need crystal calibration data,
+ *	don't send it to those
+ * @scan_rx_antennas: available antenna for scan operation
+ * @led_mode: 0=blinking, 1=On(RF On)/Off(RF Off)
+ * @adv_pm: advance power management
+ * @rx_with_siso_diversity: 1x1 device with rx antenna diversity
+ * @internal_wimax_coex: internal wifi/wimax combo device
+ * @iq_invert: I/Q inversion
+ * @temp_offset_v2: support v2 of temperature offset calibration
+ *
+ * We enable the driver to be backward compatible wrt API version. The
+ * driver specifies which APIs it supports (with @ucode_api_max being the
+ * highest and @ucode_api_min the lowest). Firmware will only be loaded if
+ * it has a supported API version.
+ *
+ * The ideal usage of this infrastructure is to treat a new ucode API
+ * release as a new hardware revision.
+ */
+struct iwl_cfg {
+	/* params specific to an individual device within a device family */
+	const char *name;
+	const char *fw_name_pre;
+	const unsigned int ucode_api_max;
+	const unsigned int ucode_api_ok;
+	const unsigned int ucode_api_min;
+	u8   valid_tx_ant;
+	u8   valid_rx_ant;
+	u16  sku;
+	u16  eeprom_ver;
+	u16  eeprom_calib_ver;
+	const struct iwl_lib_ops *lib;
+	void (*additional_nic_config)(struct iwl_priv *priv);
+	/* params not likely to change within a device family */
+	struct iwl_base_params *base_params;
+	/* params likely to change within a device family */
+	struct iwl_ht_params *ht_params;
+	struct iwl_bt_params *bt_params;
+	enum iwl_pa_type pa_type;	  /* if used set to IWL_PA_SYSTEM */
+	const bool need_temp_offset_calib; /* if used set to true */
+	const bool no_xtal_calib;
+	u8 scan_rx_antennas[IEEE80211_NUM_BANDS];
+	enum iwl_led_mode led_mode;
+	const bool adv_pm;
+	const bool rx_with_siso_diversity;
+	const bool internal_wimax_coex;
+	const bool iq_invert;
+	const bool temp_offset_v2;
+};
+
+/**
  * struct iwl_shared - shared fields for all the layers of the driver
  *
  * @dbg_level_dev: dbg level set per device. Prevails on
@@ -313,6 +407,7 @@ struct iwl_notification_wait {
  * @status: STATUS_*
  * @valid_contexts: microcode/device supports multiple contexts
  * @bus: pointer to the bus layer data
+ * @cfg: see struct iwl_cfg
  * @priv: pointer to the upper layer data
  * @hw_params: see struct iwl_hw_params
  * @workqueue: the workqueue used by all the layers of the driver
@@ -320,6 +415,7 @@ struct iwl_notification_wait {
  * @sta_lock: protects the station table.
  *	If lock and sta_lock are needed, lock must be acquired first.
  * @mutex:
+ * @eeprom: pointer to the eeprom/OTP image
  * @ucode_type: indicator of loaded ucode image
  * @notif_waits: things waiting for notification
  * @notif_wait_lock: lock protecting notification
@@ -340,6 +436,7 @@ struct iwl_shared {
 	u8 valid_contexts;
 
 	struct iwl_bus *bus;
+	struct iwl_cfg *cfg;
 	struct iwl_priv *priv;
 	struct iwl_trans *trans;
 	struct iwl_hw_params hw_params;
@@ -373,6 +470,7 @@ struct iwl_shared {
 
 /*Whatever _m is (iwl_trans, iwl_priv, iwl_bus, these macros will work */
 #define priv(_m)	((_m)->shrd->priv)
+#define cfg(_m)		((_m)->shrd->cfg)
 #define bus(_m)		((_m)->shrd->bus)
 #define trans(_m)	((_m)->shrd->trans)
 #define hw_params(_m)	((_m)->shrd->hw_params)
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index a874eb7..0fb962e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -425,8 +425,8 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 
 	switch (nla_get_u32(tb[IWL_TM_ATTR_COMMAND])) {
 	case IWL_TM_CMD_APP2DEV_GET_DEVICENAME:
-		rsp_data_ptr = (unsigned char *)priv->cfg->name;
-		rsp_data_len = strlen(priv->cfg->name);
+		rsp_data_ptr = (unsigned char *)cfg(priv)->name;
+		rsp_data_len = strlen(cfg(priv)->name);
 		skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy,
 							rsp_data_len + 20);
 		if (!skb) {
@@ -487,7 +487,7 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 	case IWL_TM_CMD_APP2DEV_GET_EEPROM:
 		if (priv->shrd->eeprom) {
 			skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy,
-				priv->cfg->base_params->eeprom_size + 20);
+				cfg(priv)->base_params->eeprom_size + 20);
 			if (!skb) {
 				IWL_DEBUG_INFO(priv,
 				       "Error allocating memory\n");
@@ -496,7 +496,7 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 			NLA_PUT_U32(skb, IWL_TM_ATTR_COMMAND,
 				IWL_TM_CMD_DEV2APP_EEPROM_RSP);
 			NLA_PUT(skb, IWL_TM_ATTR_EEPROM,
-				priv->cfg->base_params->eeprom_size,
+				cfg(priv)->base_params->eeprom_size,
 				priv->shrd->eeprom);
 			status = cfg80211_testmode_reply(skb);
 			if (status < 0)
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index 2ee00e0..791005d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -672,7 +672,7 @@ static void iwl_irq_handle_error(struct iwl_trans *trans)
 {
 	struct iwl_priv *priv = priv(trans);
 	/* W/A for WiFi/WiMAX coex and WiMAX own the RF */
-	if (priv->cfg->internal_wimax_coex &&
+	if (cfg(priv)->internal_wimax_coex &&
 	    (!(iwl_read_prph(bus(trans), APMG_CLK_CTRL_REG) &
 			APMS_CLK_VAL_MRB_FUNC_MODE) ||
 	     (iwl_read_prph(bus(trans), APMG_PS_CTRL_REG) &
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index 0577212..5ed8217 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -320,8 +320,8 @@ int iwlagn_init_alive_start(struct iwl_priv *priv)
 {
 	int ret;
 
-	if (priv->cfg->bt_params &&
-	    priv->cfg->bt_params->advanced_bt_coexist) {
+	if (cfg(priv)->bt_params &&
+	    cfg(priv)->bt_params->advanced_bt_coexist) {
 		/*
 		 * Tell uCode we are ready to perform calibration
 		 * need to perform this before any calibration
@@ -343,8 +343,8 @@ int iwlagn_init_alive_start(struct iwl_priv *priv)
 	 * temperature offset calibration is only needed for runtime ucode,
 	 * so prepare the value now.
 	 */
-	if (priv->cfg->need_temp_offset_calib) {
-		if (priv->cfg->temp_offset_v2)
+	if (cfg(priv)->need_temp_offset_calib) {
+		if (cfg(priv)->temp_offset_v2)
 			return iwl_set_temperature_offset_calib_v2(priv);
 		else
 			return iwl_set_temperature_offset_calib(priv);
@@ -357,7 +357,7 @@ static int iwl_send_wimax_coex(struct iwl_priv *priv)
 {
 	struct iwl_wimax_coex_cmd coex_cmd;
 
-	if (priv->cfg->base_params->support_wimax_coexist) {
+	if (cfg(priv)->base_params->support_wimax_coexist) {
 		/* UnMask wake up src at associated sleep */
 		coex_cmd.flags = COEX_FLAGS_ASSOC_WA_UNMASK_MSK;
 
@@ -453,7 +453,7 @@ static int iwl_alive_notify(struct iwl_priv *priv)
 	if (ret)
 		return ret;
 
-	if (!priv->cfg->no_xtal_calib) {
+	if (!cfg(priv)->no_xtal_calib) {
 		ret = iwl_set_Xtal_calib(priv);
 		if (ret)
 			return ret;
-- 
1.7.0.4

