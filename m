Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:14459 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665Ab2DROps (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 10:45:48 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/15] iwlwifi: op_mode holds its pointer to the config
Date: Wed, 18 Apr 2012 07:41:05 -0700
Message-Id: <1334760077-5714-4-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120418_164553_978763_10D90928)
In-Reply-To: <1334760077-5714-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334760077-5714-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Instead of using the shared area that we be killed.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c   |    8 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-devices.c |    8 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c     |   18 +++++-----
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c      |    8 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c    |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c      |   16 +++++-----
 drivers/net/wireless/iwlwifi/iwl-agn.c         |   41 ++++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-agn.h         |    4 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c     |    8 ++--
 drivers/net/wireless/iwlwifi/iwl-dev.h         |    1 +
 drivers/net/wireless/iwlwifi/iwl-drv.c         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c      |   26 +++++++-------
 drivers/net/wireless/iwlwifi/iwl-led.c         |    8 ++--
 drivers/net/wireless/iwlwifi/iwl-mac80211.c    |    6 ++--
 drivers/net/wireless/iwlwifi/iwl-op-mode.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl-power.c       |    8 ++--
 drivers/net/wireless/iwlwifi/iwl-scan.c        |   12 +++---
 drivers/net/wireless/iwlwifi/iwl-testmode.c    |    8 ++--
 drivers/net/wireless/iwlwifi/iwl-ucode.c       |   10 +++---
 21 files changed, 102 insertions(+), 99 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
index 61c243f..b088f9b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
@@ -521,7 +521,7 @@ static int iwl_enhance_sensitivity_write(struct iwl_priv *priv)
 
 	iwl_prepare_legacy_sensitivity_tbl(priv, data, &cmd.enhance_table[0]);
 
-	if (cfg(priv)->base_params->hd_v2) {
+	if (priv->cfg->base_params->hd_v2) {
 		cmd.enhance_table[HD_INA_NON_SQUARE_DET_OFDM_INDEX] =
 			HD_INA_NON_SQUARE_DET_OFDM_DATA_V2;
 		cmd.enhance_table[HD_INA_NON_SQUARE_DET_CCK_INDEX] =
@@ -895,7 +895,7 @@ static void iwlagn_gain_computation(struct iwl_priv *priv,
 			continue;
 		}
 
-		delta_g = (cfg(priv)->base_params->chain_noise_scale *
+		delta_g = (priv->cfg->base_params->chain_noise_scale *
 			((s32)average_noise[default_chain] -
 			(s32)average_noise[i])) / 1500;
 
@@ -1051,8 +1051,8 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv)
 		return;
 
 	/* Analyze signal for disconnected antenna */
-	if (cfg(priv)->bt_params &&
-	    cfg(priv)->bt_params->advanced_bt_coexist) {
+	if (priv->cfg->bt_params &&
+	    priv->cfg->bt_params->advanced_bt_coexist) {
 		/* Disable disconnected antenna algorithm for advanced
 		   bt coex, assuming valid antennas are connected */
 		data->active_chains = priv->hw_params.valid_rx_ant;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-devices.c b/drivers/net/wireless/iwlwifi/iwl-agn-devices.c
index ae4a216..d0700e0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-devices.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-devices.c
@@ -175,7 +175,7 @@ static void iwl1000_hw_set_hw_params(struct iwl_priv *priv)
 
 	priv->hw_params.tx_chains_num =
 		num_of_ant(priv->hw_params.valid_tx_ant);
-	if (cfg(priv)->rx_with_siso_diversity)
+	if (priv->cfg->rx_with_siso_diversity)
 		priv->hw_params.rx_chains_num = 1;
 	else
 		priv->hw_params.rx_chains_num =
@@ -256,7 +256,7 @@ static void iwl2000_hw_set_hw_params(struct iwl_priv *priv)
 
 	priv->hw_params.tx_chains_num =
 		num_of_ant(priv->hw_params.valid_tx_ant);
-	if (cfg(priv)->rx_with_siso_diversity)
+	if (priv->cfg->rx_with_siso_diversity)
 		priv->hw_params.rx_chains_num = 1;
 	else
 		priv->hw_params.rx_chains_num =
@@ -573,7 +573,7 @@ static void iwl6000_nic_config(struct iwl_priv *priv)
 {
 	iwl_rf_config(priv);
 
-	switch (cfg(priv)->device_family) {
+	switch (priv->cfg->device_family) {
 	case IWL_DEVICE_FAMILY_6005:
 	case IWL_DEVICE_FAMILY_6030:
 	case IWL_DEVICE_FAMILY_6000:
@@ -633,7 +633,7 @@ static void iwl6000_hw_set_hw_params(struct iwl_priv *priv)
 
 	priv->hw_params.tx_chains_num =
 		num_of_ant(priv->hw_params.valid_tx_ant);
-	if (cfg(priv)->rx_with_siso_diversity)
+	if (priv->cfg->rx_with_siso_diversity)
 		priv->hw_params.rx_chains_num = 1;
 	else
 		priv->hw_params.rx_chains_num =
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index ab36344..86a6733 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -312,21 +312,21 @@ void iwlagn_send_advance_bt_config(struct iwl_priv *priv)
 	BUILD_BUG_ON(sizeof(iwlagn_def_3w_lookup) !=
 			sizeof(basic.bt3_lookup_table));
 
-	if (cfg(priv)->bt_params) {
+	if (priv->cfg->bt_params) {
 		/*
 		 * newer generation of devices (2000 series and newer)
 		 * use the version 2 of the bt command
 		 * we need to make sure sending the host command
 		 * with correct data structure to avoid uCode assert
 		 */
-		if (cfg(priv)->bt_params->bt_session_2) {
+		if (priv->cfg->bt_params->bt_session_2) {
 			bt_cmd_v2.prio_boost = cpu_to_le32(
-				cfg(priv)->bt_params->bt_prio_boost);
+				priv->cfg->bt_params->bt_prio_boost);
 			bt_cmd_v2.tx_prio_boost = 0;
 			bt_cmd_v2.rx_prio_boost = 0;
 		} else {
 			bt_cmd_v1.prio_boost =
-				cfg(priv)->bt_params->bt_prio_boost;
+				priv->cfg->bt_params->bt_prio_boost;
 			bt_cmd_v1.tx_prio_boost = 0;
 			bt_cmd_v1.rx_prio_boost = 0;
 		}
@@ -374,7 +374,7 @@ void iwlagn_send_advance_bt_config(struct iwl_priv *priv)
 		       priv->bt_full_concurrent ?
 		       "full concurrency" : "3-wire");
 
-	if (cfg(priv)->bt_params->bt_session_2) {
+	if (priv->cfg->bt_params->bt_session_2) {
 		memcpy(&bt_cmd_v2.basic, &basic,
 			sizeof(basic));
 		ret = iwl_dvm_send_cmd_pdu(priv, REPLY_BT_CONFIG,
@@ -740,8 +740,8 @@ static bool is_single_rx_stream(struct iwl_priv *priv)
  */
 static int iwl_get_active_rx_chain_count(struct iwl_priv *priv)
 {
-	if (cfg(priv)->bt_params &&
-	    cfg(priv)->bt_params->advanced_bt_coexist &&
+	if (priv->cfg->bt_params &&
+	    priv->cfg->bt_params->advanced_bt_coexist &&
 	    (priv->bt_full_concurrent ||
 	     priv->bt_traffic_load >= IWL_BT_COEX_TRAFFIC_LOAD_HIGH)) {
 		/*
@@ -812,8 +812,8 @@ void iwlagn_set_rxon_chain(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	else
 		active_chains = priv->hw_params.valid_rx_ant;
 
-	if (cfg(priv)->bt_params &&
-	    cfg(priv)->bt_params->advanced_bt_coexist &&
+	if (priv->cfg->bt_params &&
+	    priv->cfg->bt_params->advanced_bt_coexist &&
 	    (priv->bt_full_concurrent ||
 	     priv->bt_traffic_load >= IWL_BT_COEX_TRAFFIC_LOAD_HIGH)) {
 		/*
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 8b13b6c..024a0dd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -1085,7 +1085,7 @@ done:
 	    (priv->tm_fixed_rate != lq_sta->dbg_fixed_rate))
 		rs_program_fix_rate(priv, lq_sta);
 #endif
-	if (cfg(priv)->bt_params && cfg(priv)->bt_params->advanced_bt_coexist)
+	if (priv->cfg->bt_params && priv->cfg->bt_params->advanced_bt_coexist)
 		rs_bt_update_lq(priv, ctx, lq_sta);
 }
 
@@ -3063,11 +3063,11 @@ static void rs_fill_link_cmd(struct iwl_priv *priv,
 	 * overwrite if needed, pass aggregation time limit
 	 * to uCode in uSec
 	 */
-	if (priv && cfg(priv)->bt_params &&
-	    cfg(priv)->bt_params->agg_time_limit &&
+	if (priv && priv->cfg->bt_params &&
+	    priv->cfg->bt_params->agg_time_limit &&
 	    priv->bt_traffic_load >= IWL_BT_COEX_TRAFFIC_LOAD_HIGH)
 		lq_cmd->agg_params.agg_time_limit =
-			cpu_to_le16(cfg(priv)->bt_params->agg_time_limit);
+			cpu_to_le16(priv->cfg->bt_params->agg_time_limit);
 }
 
 static void *rs_alloc(struct ieee80211_hw *hw, struct dentry *debugfsdir)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index e321a29..9f647bd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -1105,7 +1105,7 @@ void iwl_setup_rx_handlers(struct iwl_priv *priv)
 	iwl_notification_wait_init(&priv->notif_wait);
 
 	/* Set up BT Rx handlers */
-	if (cfg(priv)->bt_params)
+	if (priv->cfg->bt_params)
 		iwlagn_bt_rx_handler_setup(priv);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 5c7bddd..00055a0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -531,9 +531,9 @@ static int iwlagn_rxon_connect(struct iwl_priv *priv,
 	}
 
 	if (ctx->vif && ctx->vif->type == NL80211_IFTYPE_STATION &&
-	    cfg(priv)->ht_params && cfg(priv)->ht_params->smps_mode)
+	    priv->cfg->ht_params && priv->cfg->ht_params->smps_mode)
 		ieee80211_request_smps(ctx->vif,
-				       cfg(priv)->ht_params->smps_mode);
+				       priv->cfg->ht_params->smps_mode);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
index 18276db..f6bf874 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
@@ -632,7 +632,7 @@ void iwl_tt_initialize(struct iwl_priv *priv)
 	INIT_WORK(&priv->ct_enter, iwl_bg_ct_enter);
 	INIT_WORK(&priv->ct_exit, iwl_bg_ct_exit);
 
-	if (cfg(priv)->base_params->adv_thermal_throttle) {
+	if (priv->cfg->base_params->adv_thermal_throttle) {
 		IWL_DEBUG_TEMP(priv, "Advanced Thermal Throttling\n");
 		tt->restriction = kcalloc(IWL_TI_STATE_MAX,
 					  sizeof(struct iwl_tt_restriction),
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index f6041ca..76fea8f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -85,8 +85,8 @@ static void iwlagn_tx_cmd_build_basic(struct iwl_priv *priv,
 	else if (ieee80211_is_back_req(fc))
 		tx_flags |= TX_CMD_FLG_ACK_MSK | TX_CMD_FLG_IMM_BA_RSP_MASK;
 	else if (info->band == IEEE80211_BAND_2GHZ &&
-		 cfg(priv)->bt_params &&
-		 cfg(priv)->bt_params->advanced_bt_coexist &&
+		 priv->cfg->bt_params &&
+		 priv->cfg->bt_params->advanced_bt_coexist &&
 		 (ieee80211_is_auth(fc) || ieee80211_is_assoc_req(fc) ||
 		 ieee80211_is_reassoc_req(fc) ||
 		 skb->protocol == cpu_to_be16(ETH_P_PAE)))
@@ -203,8 +203,8 @@ static void iwlagn_tx_cmd_build_rate(struct iwl_priv *priv,
 		rate_flags |= RATE_MCS_CCK_MSK;
 
 	/* Set up antennas */
-	 if (cfg(priv)->bt_params &&
-	     cfg(priv)->bt_params->advanced_bt_coexist &&
+	 if (priv->cfg->bt_params &&
+	     priv->cfg->bt_params->advanced_bt_coexist &&
 	     priv->bt_full_concurrent) {
 		/* operated as 1x1 in full concurrency mode */
 		priv->mgmt_tx_ant = iwl_toggle_tx_ant(priv, priv->mgmt_tx_ant,
@@ -501,7 +501,7 @@ static int iwlagn_alloc_agg_txq(struct iwl_priv *priv, int ac)
 	int q;
 
 	for (q = IWLAGN_FIRST_AMPDU_QUEUE;
-	     q < cfg(priv)->base_params->num_of_queues; q++) {
+	     q < priv->cfg->base_params->num_of_queues; q++) {
 		if (!test_and_set_bit(q, priv->agg_q_alloc)) {
 			priv->queue_to_ac[q] = ac;
 			return q;
@@ -909,8 +909,8 @@ static void iwl_rx_reply_tx_agg(struct iwl_priv *priv,
 	 * notification again.
 	 */
 	if (tx_resp->bt_kill_count && tx_resp->frame_count == 1 &&
-	    cfg(priv)->bt_params &&
-	    cfg(priv)->bt_params->advanced_bt_coexist) {
+	    priv->cfg->bt_params &&
+	    priv->cfg->bt_params->advanced_bt_coexist) {
 		IWL_DEBUG_COEX(priv, "receive reply tx w/ bt_kill\n");
 	}
 
@@ -1249,7 +1249,7 @@ int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 	 * (in Tx queue's circular buffer) of first TFD/frame in window */
 	u16 ba_resp_scd_ssn = le16_to_cpu(ba_resp->scd_ssn);
 
-	if (scd_flow >= cfg(priv)->base_params->num_of_queues) {
+	if (scd_flow >= priv->cfg->base_params->num_of_queues) {
 		IWL_ERR(priv,
 			"BUG_ON scd_flow is bigger than number of queues\n");
 		return 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 81c1cd7..6771b6d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -674,7 +674,7 @@ void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 
 	priv->thermal_throttle.ct_kill_toggle = false;
 
-	if (cfg(priv)->base_params->support_ct_kill_exit) {
+	if (priv->cfg->base_params->support_ct_kill_exit) {
 		adv_cmd.critical_temperature_enter =
 			cpu_to_le32(priv->hw_params.ct_kill_threshold);
 		adv_cmd.critical_temperature_exit =
@@ -791,10 +791,10 @@ int iwl_alive_start(struct iwl_priv *priv)
 	}
 
 	/* download priority table before any calibration request */
-	if (cfg(priv)->bt_params &&
-	    cfg(priv)->bt_params->advanced_bt_coexist) {
+	if (priv->cfg->bt_params &&
+	    priv->cfg->bt_params->advanced_bt_coexist) {
 		/* Configure Bluetooth device coexistence support */
-		if (cfg(priv)->bt_params->bt_sco_disable)
+		if (priv->cfg->bt_params->bt_sco_disable)
 			priv->bt_enable_pspoll = false;
 		else
 			priv->bt_enable_pspoll = true;
@@ -931,9 +931,9 @@ void iwl_down(struct iwl_priv *priv)
 	priv->bt_status = 0;
 	priv->cur_rssi_ctx = NULL;
 	priv->bt_is_sco = 0;
-	if (cfg(priv)->bt_params)
+	if (priv->cfg->bt_params)
 		priv->bt_traffic_load =
-			 cfg(priv)->bt_params->bt_init_traffic_load;
+			 priv->cfg->bt_params->bt_init_traffic_load;
 	else
 		priv->bt_traffic_load = 0;
 	priv->bt_full_concurrent = false;
@@ -1114,7 +1114,7 @@ void iwl_setup_deferred_work(struct iwl_priv *priv)
 
 	iwl_setup_scan_deferred_work(priv);
 
-	if (cfg(priv)->bt_params)
+	if (priv->cfg->bt_params)
 		iwlagn_bt_setup_deferred_work(priv);
 
 	init_timer(&priv->statistics_periodic);
@@ -1128,7 +1128,7 @@ void iwl_setup_deferred_work(struct iwl_priv *priv)
 
 void iwl_cancel_deferred_work(struct iwl_priv *priv)
 {
-	if (cfg(priv)->bt_params)
+	if (priv->cfg->bt_params)
 		iwlagn_bt_cancel_deferred_work(priv);
 
 	cancel_work_sync(&priv->run_time_calib_work);
@@ -1179,8 +1179,8 @@ static void iwl_init_ht_hw_capab(const struct iwl_priv *priv,
 
 	ht_info->ht_supported = true;
 
-	if (cfg(priv)->ht_params &&
-	    cfg(priv)->ht_params->ht_greenfield_support)
+	if (priv->cfg->ht_params &&
+	    priv->cfg->ht_params->ht_greenfield_support)
 		ht_info->cap |= IEEE80211_HT_CAP_GRN_FLD;
 	ht_info->cap |= IEEE80211_HT_CAP_SGI_20;
 	max_bit_rate = MAX_BIT_RATE_20_MHZ;
@@ -1362,7 +1362,7 @@ int iwl_init_drv(struct iwl_priv *priv)
 	priv->band = IEEE80211_BAND_2GHZ;
 
 	priv->plcp_delta_threshold =
-		cfg(priv)->base_params->plcp_delta_threshold;
+		priv->cfg->base_params->plcp_delta_threshold;
 
 	priv->iw_mode = NL80211_IFTYPE_STATION;
 	priv->current_ht_config.smps = IEEE80211_SMPS_STATIC;
@@ -1379,8 +1379,8 @@ int iwl_init_drv(struct iwl_priv *priv)
 	iwl_init_scan_params(priv);
 
 	/* init bt coex */
-	if (cfg(priv)->bt_params &&
-	    cfg(priv)->bt_params->advanced_bt_coexist) {
+	if (priv->cfg->bt_params &&
+	    priv->cfg->bt_params->advanced_bt_coexist) {
 		priv->kill_ack_mask = IWLAGN_BT_KILL_ACK_MASK_DEFAULT;
 		priv->kill_cts_mask = IWLAGN_BT_KILL_CTS_MASK_DEFAULT;
 		priv->bt_valid = IWLAGN_BT_ALL_VALID_MSK;
@@ -1425,9 +1425,9 @@ void iwl_uninit_drv(struct iwl_priv *priv)
 
 void iwl_set_hw_params(struct iwl_priv *priv)
 {
-	if (cfg(priv)->ht_params)
+	if (priv->cfg->ht_params)
 		priv->hw_params.use_rts_for_aggregation =
-			cfg(priv)->ht_params->use_rts_for_aggregation;
+			priv->cfg->ht_params->use_rts_for_aggregation;
 
 	if (iwlagn_mod_params.disable_11n & IWL_DISABLE_HT_ALL)
 		priv->hw_params.sku &= ~EEPROM_SKU_CAP_11N_ENABLE;
@@ -1474,6 +1474,7 @@ void iwl_debug_config(struct iwl_priv *priv)
 }
 
 static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
+						 const struct iwl_cfg *cfg,
 						 const struct iwl_fw *fw)
 {
 	struct iwl_priv *priv;
@@ -1499,8 +1500,7 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	 ************************/
 	hw = iwl_alloc_all();
 	if (!hw) {
-		pr_err("%s: Cannot allocate network device\n",
-				cfg(trans)->name);
+		pr_err("%s: Cannot allocate network device\n", cfg->name);
 		goto out;
 	}
 
@@ -1509,9 +1509,10 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	priv = IWL_OP_MODE_GET_DVM(op_mode);
 	priv->shrd = trans->shrd;
 	priv->trans = trans;
+	priv->cfg = cfg;
 	priv->fw = fw;
 
-	switch (cfg(priv)->device_family) {
+	switch (priv->cfg->device_family) {
 	case IWL_DEVICE_FAMILY_1000:
 	case IWL_DEVICE_FAMILY_100:
 		priv->lib = &iwl1000_lib;
@@ -1557,7 +1558,7 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	trans_cfg.rx_buf_size_8k = iwlagn_mod_params.amsdu_size_8K;
 	if (!iwlagn_mod_params.wd_disable)
 		trans_cfg.queue_watchdog_timeout =
-			cfg(priv)->base_params->wd_timeout;
+			priv->cfg->base_params->wd_timeout;
 	else
 		trans_cfg.queue_watchdog_timeout = IWL_WATCHHDOG_DISABLED;
 	trans_cfg.command_names = iwl_dvm_cmd_strings;
@@ -1622,7 +1623,7 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	 * 2. Read REV register
 	 ***********************/
 	IWL_INFO(priv, "Detected %s, REV=0x%X\n",
-		cfg(priv)->name, priv->trans->hw_rev);
+		priv->cfg->name, priv->trans->hw_rev);
 
 	if (iwl_trans_start_hw(priv->trans))
 		goto out_free_traffic_mem;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index e4c0a94..8a09d0c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -279,8 +279,8 @@ void iwlagn_bt_adjust_rssi_monitor(struct iwl_priv *priv, bool rssi_ena);
 
 static inline bool iwl_advanced_bt_coexist(struct iwl_priv *priv)
 {
-	return cfg(priv)->bt_params &&
-	       cfg(priv)->bt_params->advanced_bt_coexist;
+	return priv->cfg->bt_params &&
+	       priv->cfg->bt_params->advanced_bt_coexist;
 }
 
 #ifdef CONFIG_IWLWIFI_DEBUG
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index a1d155a..70c24f5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -408,7 +408,7 @@ static ssize_t iwl_dbgfs_nvm_read(struct file *file,
 	const u8 *ptr;
 	char *buf;
 	u16 eeprom_ver;
-	size_t eeprom_len = cfg(priv)->base_params->eeprom_size;
+	size_t eeprom_len = priv->cfg->base_params->eeprom_size;
 	buf_size = 4 * eeprom_len + 256;
 
 	if (eeprom_len % 16) {
@@ -829,7 +829,7 @@ static ssize_t iwl_dbgfs_traffic_log_read(struct file *file,
 
 	char *buf;
 	int bufsz = ((IWL_TRAFFIC_ENTRIES * IWL_TRAFFIC_ENTRY_SIZE * 64) * 2) +
-		(cfg(priv)->base_params->num_of_queues * 32 * 8) + 400;
+		(priv->cfg->base_params->num_of_queues * 32 * 8) + 400;
 	const u8 *ptr;
 	ssize_t ret;
 
@@ -2380,7 +2380,7 @@ static ssize_t iwl_dbgfs_protection_mode_read(struct file *file,
 	char buf[40];
 	const size_t bufsz = sizeof(buf);
 
-	if (cfg(priv)->ht_params)
+	if (priv->cfg->ht_params)
 		pos += scnprintf(buf + pos, bufsz - pos,
 			 "use %s for aggregation\n",
 			 (priv->hw_params.use_rts_for_aggregation) ?
@@ -2400,7 +2400,7 @@ static ssize_t iwl_dbgfs_protection_mode_write(struct file *file,
 	int buf_size;
 	int rts;
 
-	if (!cfg(priv)->ht_params)
+	if (!priv->cfg->ht_params)
 		return -EINVAL;
 
 	memset(buf, 0, sizeof(buf));
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index faf54c4..33d5878 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -761,6 +761,7 @@ struct iwl_priv {
 	/*data shared among all the driver's layers */
 	struct iwl_shared *shrd;
 	struct iwl_trans *trans;
+	const struct iwl_cfg *cfg;
 	const struct iwl_fw *fw;
 	const struct iwl_lib_ops *lib;
 	unsigned long status;
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 8e29621..72d0818 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -859,7 +859,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	release_firmware(ucode_raw);
 	complete(&drv->request_firmware_complete);
 
-	drv->op_mode = iwl_dvm_ops.start(drv->trans, &drv->fw);
+	drv->op_mode = iwl_dvm_ops.start(drv->trans, cfg, &drv->fw);
 
 	if (!drv->op_mode)
 		goto out_unbind;
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 622a8f3..593485b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -236,8 +236,8 @@ int iwl_eeprom_check_version(struct iwl_priv *priv)
 	eeprom_ver = iwl_eeprom_query16(priv, EEPROM_VERSION);
 	calib_ver = iwl_eeprom_calib_version(priv);
 
-	if (eeprom_ver < cfg(priv)->eeprom_ver ||
-	    calib_ver < cfg(priv)->eeprom_calib_ver)
+	if (eeprom_ver < priv->cfg->eeprom_ver ||
+	    calib_ver < priv->cfg->eeprom_calib_ver)
 		goto err;
 
 	IWL_INFO(priv, "device EEPROM VER=0x%x, CALIB=0x%x\n",
@@ -247,8 +247,8 @@ int iwl_eeprom_check_version(struct iwl_priv *priv)
 err:
 	IWL_ERR(priv, "Unsupported (too old) EEPROM VER=0x%x < 0x%x "
 		  "CALIB=0x%x < 0x%x\n",
-		  eeprom_ver, cfg(priv)->eeprom_ver,
-		  calib_ver,  cfg(priv)->eeprom_calib_ver);
+		  eeprom_ver, priv->cfg->eeprom_ver,
+		  calib_ver,  priv->cfg->eeprom_calib_ver);
 	return -EINVAL;
 
 }
@@ -259,7 +259,7 @@ int iwl_eeprom_init_hw_params(struct iwl_priv *priv)
 
 	priv->hw_params.sku = iwl_eeprom_query16(priv, EEPROM_SKU_CAP);
 	if (priv->hw_params.sku & EEPROM_SKU_CAP_11N_ENABLE &&
-	    !cfg(priv)->ht_params) {
+	    !priv->cfg->ht_params) {
 		IWL_ERR(priv, "Invalid 11n configuration\n");
 		return -EINVAL;
 	}
@@ -277,10 +277,10 @@ int iwl_eeprom_init_hw_params(struct iwl_priv *priv)
 	priv->hw_params.valid_rx_ant = EEPROM_RF_CFG_RX_ANT_MSK(radio_cfg);
 
 	/* check overrides (some devices have wrong EEPROM) */
-	if (cfg(priv)->valid_tx_ant)
-		priv->hw_params.valid_tx_ant = cfg(priv)->valid_tx_ant;
-	if (cfg(priv)->valid_rx_ant)
-		priv->hw_params.valid_rx_ant = cfg(priv)->valid_rx_ant;
+	if (priv->cfg->valid_tx_ant)
+		priv->hw_params.valid_tx_ant = priv->cfg->valid_tx_ant;
+	if (priv->cfg->valid_rx_ant)
+		priv->hw_params.valid_rx_ant = priv->cfg->valid_rx_ant;
 
 	if (!priv->hw_params.valid_tx_ant || !priv->hw_params.valid_rx_ant) {
 		IWL_ERR(priv, "Invalid chain (0x%X, 0x%X)\n",
@@ -349,7 +349,7 @@ static u32 eeprom_indirect_address(struct iwl_priv *priv, u32 address)
 const u8 *iwl_eeprom_query_addr(struct iwl_priv *priv, size_t offset)
 {
 	u32 address = eeprom_indirect_address(priv, offset);
-	BUG_ON(address >= cfg(priv)->base_params->eeprom_size);
+	BUG_ON(address >= priv->cfg->base_params->eeprom_size);
 	return &priv->eeprom[address];
 }
 
@@ -693,7 +693,7 @@ static void iwl_eeprom_enhanced_txpower(struct iwl_priv *priv)
 				 ((txp->delta_20_in_40 & 0xf0) >> 4),
 				 (txp->delta_20_in_40 & 0x0f));
 
-		max_txp_avg = iwl_get_max_txpower_avg(cfg(priv), txp_array, idx,
+		max_txp_avg = iwl_get_max_txpower_avg(priv->cfg, txp_array, idx,
 						      &max_txp_avg_halfdbm);
 
 		/*
@@ -730,7 +730,7 @@ int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
 	if (priv->nvm_device_type == -ENOENT)
 		return -ENOENT;
 	/* allocate eeprom */
-	sz = cfg(priv)->base_params->eeprom_size;
+	sz = priv->cfg->base_params->eeprom_size;
 	IWL_DEBUG_EEPROM(priv, "NVM size = %d\n", sz);
 	priv->eeprom = kzalloc(sz, GFP_KERNEL);
 	if (!priv->eeprom) {
@@ -770,7 +770,7 @@ int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
 			     CSR_OTP_GP_REG_ECC_CORR_STATUS_MSK |
 			     CSR_OTP_GP_REG_ECC_UNCORR_STATUS_MSK);
 		/* traversing the linked list if no shadow ram supported */
-		if (!cfg(priv)->base_params->shadow_ram_support) {
+		if (!priv->cfg->base_params->shadow_ram_support) {
 			if (iwl_find_otp_image(priv->trans, &validblockaddr)) {
 				ret = -ENOENT;
 				goto done;
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 18e6a36..d57063e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -138,11 +138,11 @@ static int iwl_led_cmd(struct iwl_priv *priv,
 	}
 
 	IWL_DEBUG_LED(priv, "Led blink time compensation=%u\n",
-			cfg(priv)->base_params->led_compensation);
+			priv->cfg->base_params->led_compensation);
 	led_cmd.on = iwl_blink_compensation(priv, on,
-				cfg(priv)->base_params->led_compensation);
+				priv->cfg->base_params->led_compensation);
 	led_cmd.off = iwl_blink_compensation(priv, off,
-				cfg(priv)->base_params->led_compensation);
+				priv->cfg->base_params->led_compensation);
 
 	ret = iwl_send_led_cmd(priv, &led_cmd);
 	if (!ret) {
@@ -183,7 +183,7 @@ void iwl_leds_init(struct iwl_priv *priv)
 		return;
 	}
 	if (mode == IWL_LED_DEFAULT)
-		mode = cfg(priv)->led_mode;
+		mode = priv->cfg->led_mode;
 
 	priv->led.name = kasprintf(GFP_KERNEL, "%s-led",
 				   wiphy_name(priv->hw->wiphy));
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 20388ec..293110b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -1130,8 +1130,8 @@ void iwlagn_mac_rssi_callback(struct ieee80211_hw *hw,
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 	mutex_lock(&priv->mutex);
 
-	if (cfg(priv)->bt_params &&
-			cfg(priv)->bt_params->advanced_bt_coexist) {
+	if (priv->cfg->bt_params &&
+			priv->cfg->bt_params->advanced_bt_coexist) {
 		if (rssi_event == RSSI_EVENT_LOW)
 			priv->bt_enable_pspoll = true;
 		else if (rssi_event == RSSI_EVENT_HIGH)
@@ -1240,7 +1240,7 @@ int iwl_setup_interface(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 		return err;
 	}
 
-	if (cfg(priv)->bt_params && cfg(priv)->bt_params->advanced_bt_coexist &&
+	if (priv->cfg->bt_params && priv->cfg->bt_params->advanced_bt_coexist &&
 	    vif->type == NL80211_IFTYPE_ADHOC) {
 		/*
 		 * pretend to have high BT traffic as long as we
diff --git a/drivers/net/wireless/iwlwifi/iwl-op-mode.h b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
index ca947ae..73e1a0e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-op-mode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
@@ -129,6 +129,7 @@ struct iwl_fw;
  */
 struct iwl_op_mode_ops {
 	struct iwl_op_mode *(*start)(struct iwl_trans *trans,
+				     const struct iwl_cfg *cfg,
 				     const struct iwl_fw *fw);
 	void (*stop)(struct iwl_op_mode *op_mode);
 	int (*rx)(struct iwl_op_mode *op_mode, struct iwl_rx_cmd_buffer *rxb,
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 2c6f3b1..8456331 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -167,7 +167,7 @@ static void iwl_static_sleep_cmd(struct iwl_priv *priv,
 	u8 skip;
 	u32 slp_itrvl;
 
-	if (cfg(priv)->adv_pm) {
+	if (priv->cfg->adv_pm) {
 		table = apm_range_2;
 		if (period <= IWL_DTIM_RANGE_1_MAX)
 			table = apm_range_1;
@@ -215,13 +215,13 @@ static void iwl_static_sleep_cmd(struct iwl_priv *priv,
 	else
 		cmd->flags &= ~IWL_POWER_SLEEP_OVER_DTIM_MSK;
 
-	if (cfg(priv)->base_params->shadow_reg_enable)
+	if (priv->cfg->base_params->shadow_reg_enable)
 		cmd->flags |= IWL_POWER_SHADOW_REG_ENA;
 	else
 		cmd->flags &= ~IWL_POWER_SHADOW_REG_ENA;
 
 	if (iwl_advanced_bt_coexist(priv)) {
-		if (!cfg(priv)->bt_params->bt_sco_disable)
+		if (!priv->cfg->bt_params->bt_sco_disable)
 			cmd->flags |= IWL_POWER_BT_SCO_ENA;
 		else
 			cmd->flags &= ~IWL_POWER_BT_SCO_ENA;
@@ -295,7 +295,7 @@ static void iwl_power_build_cmd(struct iwl_priv *priv,
 
 	if (priv->wowlan)
 		iwl_static_sleep_cmd(priv, cmd, IWL_POWER_INDEX_5, dtimper);
-	else if (!cfg(priv)->base_params->no_idle_support &&
+	else if (!priv->cfg->base_params->no_idle_support &&
 		 priv->hw->conf.flags & IEEE80211_CONF_IDLE)
 		iwl_static_sleep_cmd(priv, cmd, IWL_POWER_INDEX_5, 20);
 	else if (iwl_tt_is_low_power_state(priv)) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 490a60d..9b88b90 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -791,8 +791,8 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		 * Internal scans are passive, so we can indiscriminately set
 		 * the BT ignore flag on 2.4 GHz since it applies to TX only.
 		 */
-		if (cfg(priv)->bt_params &&
-		    cfg(priv)->bt_params->advanced_bt_coexist)
+		if (priv->cfg->bt_params &&
+		    priv->cfg->bt_params->advanced_bt_coexist)
 			scan->tx_cmd.tx_flags |= TX_CMD_FLG_IGNORE_BT;
 		break;
 	case IEEE80211_BAND_5GHZ:
@@ -834,8 +834,8 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	band = priv->scan_band;
 
 	if (band == IEEE80211_BAND_2GHZ &&
-	    cfg(priv)->bt_params &&
-	    cfg(priv)->bt_params->advanced_bt_coexist) {
+	    priv->cfg->bt_params &&
+	    priv->cfg->bt_params->advanced_bt_coexist) {
 		/* transmit 2.4 GHz probes only on first antenna */
 		scan_tx_antennas = first_antenna(scan_tx_antennas);
 	}
@@ -863,8 +863,8 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 
 		rx_ant = first_antenna(active_chains);
 	}
-	if (cfg(priv)->bt_params &&
-	    cfg(priv)->bt_params->advanced_bt_coexist &&
+	if (priv->cfg->bt_params &&
+	    priv->cfg->bt_params->advanced_bt_coexist &&
 	    priv->bt_full_concurrent) {
 		/* operated as 1x1 in full concurrency mode */
 		rx_ant = first_antenna(rx_ant);
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index 0c516d0..a6b16aa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -473,8 +473,8 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 
 	switch (nla_get_u32(tb[IWL_TM_ATTR_COMMAND])) {
 	case IWL_TM_CMD_APP2DEV_GET_DEVICENAME:
-		rsp_data_ptr = (unsigned char *)cfg(priv)->name;
-		rsp_data_len = strlen(cfg(priv)->name);
+		rsp_data_ptr = (unsigned char *)priv->cfg->name;
+		rsp_data_len = strlen(priv->cfg->name);
 		skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy,
 							rsp_data_len + 20);
 		if (!skb) {
@@ -534,7 +534,7 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 	case IWL_TM_CMD_APP2DEV_GET_EEPROM:
 		if (priv->eeprom) {
 			skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy,
-				cfg(priv)->base_params->eeprom_size + 20);
+				priv->cfg->base_params->eeprom_size + 20);
 			if (!skb) {
 				IWL_ERR(priv, "Memory allocation fail\n");
 				return -ENOMEM;
@@ -542,7 +542,7 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 			NLA_PUT_U32(skb, IWL_TM_ATTR_COMMAND,
 				IWL_TM_CMD_DEV2APP_EEPROM_RSP);
 			NLA_PUT(skb, IWL_TM_ATTR_EEPROM,
-				cfg(priv)->base_params->eeprom_size,
+				priv->cfg->base_params->eeprom_size,
 				priv->eeprom);
 			status = cfg80211_testmode_reply(skb);
 			if (status < 0)
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index 4056d1f..1955803 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -145,8 +145,8 @@ int iwl_init_alive_start(struct iwl_priv *priv)
 {
 	int ret;
 
-	if (cfg(priv)->bt_params &&
-	    cfg(priv)->bt_params->advanced_bt_coexist) {
+	if (priv->cfg->bt_params &&
+	    priv->cfg->bt_params->advanced_bt_coexist) {
 		/*
 		 * Tell uCode we are ready to perform calibration
 		 * need to perform this before any calibration
@@ -168,8 +168,8 @@ int iwl_init_alive_start(struct iwl_priv *priv)
 	 * temperature offset calibration is only needed for runtime ucode,
 	 * so prepare the value now.
 	 */
-	if (cfg(priv)->need_temp_offset_calib) {
-		if (cfg(priv)->temp_offset_v2)
+	if (priv->cfg->need_temp_offset_calib) {
+		if (priv->cfg->temp_offset_v2)
 			return iwl_set_temperature_offset_calib_v2(priv);
 		else
 			return iwl_set_temperature_offset_calib(priv);
@@ -253,7 +253,7 @@ static int iwl_alive_notify(struct iwl_priv *priv)
 	if (ret)
 		return ret;
 
-	if (!cfg(priv)->no_xtal_calib) {
+	if (!priv->cfg->no_xtal_calib) {
 		ret = iwl_set_Xtal_calib(priv);
 		if (ret)
 			return ret;
-- 
1.7.0.4

