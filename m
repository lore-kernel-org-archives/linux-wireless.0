Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:27344 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963Ab0HWOxf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 10:53:35 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 22/26] iwlagn: set traffic load based on multiple factors
Date: Mon, 23 Aug 2010 07:57:13 -0700
Message-Id: <1282575437-23270-23-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Current BT traffic load should based on the following conditions:

1. BT On/Off status
2. Channel announcement enable/disable
3. Curren traffic load report from uCode

Need to modify rate scale to down-grade from MIMO to SISO if detected
high BT traffic load. Also need to make sure not using chain "B" with high
BT traffic or if it is in "full concurrency" mode.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c   |   29 ++++++--
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |  113 ++++++++++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-agn.c    |    4 +
 drivers/net/wireless/iwlwifi/iwl-core.c   |   16 +++-
 drivers/net/wireless/iwlwifi/iwl-dev.h    |    1 +
 5 files changed, 112 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index ebf0c7e..30dc1f3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -428,6 +428,9 @@ static void iwl6000g2b_bt_traffic_change_work(struct work_struct *work)
 		container_of(work, struct iwl_priv, bt_traffic_change_work);
 	int smps_request = -1;
 
+	IWL_DEBUG_INFO(priv, "BT traffic load changes: %d\n",
+		       priv->bt_traffic_load);
+
 	switch (priv->bt_traffic_load) {
 	case IWL_BT_COEX_TRAFFIC_LOAD_NONE:
 		smps_request = IEEE80211_SMPS_AUTOMATIC;
@@ -447,6 +450,9 @@ static void iwl6000g2b_bt_traffic_change_work(struct work_struct *work)
 
 	mutex_lock(&priv->mutex);
 
+	if (priv->cfg->ops->lib->update_chain_flags)
+		priv->cfg->ops->lib->update_chain_flags(priv);
+
 	if (smps_request != -1 &&
 	    priv->vif && priv->vif->type == NL80211_IFTYPE_STATION)
 		ieee80211_request_smps(priv->vif, smps_request);
@@ -549,6 +555,7 @@ static void iwl6000g2b_bt_coex_profile_notif(struct iwl_priv *priv,
 	struct iwl_bt_coex_profile_notif *coex = &pkt->u.bt_coex_profile_notif;
 	struct iwl6000g2b_bt_sco_cmd sco_cmd = { .flags = 0 };
 	struct iwl_bt_uart_msg *uart_msg = &coex->last_bt_uart_msg;
+	u8 last_traffic_load;
 
 	IWL_DEBUG_NOTIF(priv, "BT Coex notification:\n");
 	IWL_DEBUG_NOTIF(priv, "    status: %d\n", coex->bt_status);
@@ -556,16 +563,28 @@ static void iwl6000g2b_bt_coex_profile_notif(struct iwl_priv *priv,
 	IWL_DEBUG_NOTIF(priv, "    CI compliance: %d\n", coex->bt_ci_compliance);
 	iwlagn_print_uartmsg(priv, uart_msg);
 
+	last_traffic_load = priv->notif_bt_traffic_load;
 	priv->notif_bt_traffic_load = coex->bt_traffic_load;
-
 	if (priv->iw_mode != NL80211_IFTYPE_ADHOC) {
-		if (coex->bt_traffic_load != priv->bt_traffic_load) {
-			priv->bt_traffic_load = coex->bt_traffic_load;
-
+		if (priv->bt_status != coex->bt_status ||
+		    last_traffic_load != coex->bt_traffic_load) {
+			if (coex->bt_status) {
+				/* BT on */
+				if (!priv->bt_ch_announce)
+					priv->bt_traffic_load =
+						IWL_BT_COEX_TRAFFIC_LOAD_HIGH;
+				else
+					priv->bt_traffic_load =
+						coex->bt_traffic_load;
+			} else {
+				/* BT off */
+				priv->bt_traffic_load =
+					IWL_BT_COEX_TRAFFIC_LOAD_NONE;
+			}
+			priv->bt_status = coex->bt_status;
 			queue_work(priv->workqueue,
 				   &priv->bt_traffic_change_work);
 		}
-
 		if (priv->bt_sco_active !=
 		    (uart_msg->frame3 & BT_UART_MSG_FRAME3SCOESCO_MSK)) {
 			priv->bt_sco_active = uart_msg->frame3 &
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 687b534..e78f3f0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -82,7 +82,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 				   struct iwl_lq_sta *lq_sta);
 static void rs_fill_link_cmd(struct iwl_priv *priv,
 			     struct iwl_lq_sta *lq_sta, u32 rate_n_flags);
-static void rs_stay_in_table(struct iwl_lq_sta *lq_sta);
+static void rs_stay_in_table(struct iwl_lq_sta *lq_sta, bool force_search);
 
 
 #ifdef CONFIG_MAC80211_DEBUGFS
@@ -900,7 +900,7 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 		 * no matching table found, let's by-pass the data collection
 		 * and continue to perform rate scale to find the rate table
 		 */
-		rs_stay_in_table(lq_sta);
+		rs_stay_in_table(lq_sta, true);
 		goto done;
 	}
 
@@ -1334,15 +1334,17 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 		break;
 	case IWL_BT_COEX_TRAFFIC_LOAD_LOW:
 		/* avoid antenna B unless MIMO */
+		valid_tx_ant = first_antenna(priv->hw_params.valid_tx_ant);
 		if (tbl->action == IWL_LEGACY_SWITCH_ANTENNA2)
 			tbl->action = IWL_LEGACY_SWITCH_ANTENNA1;
 		break;
 	case IWL_BT_COEX_TRAFFIC_LOAD_HIGH:
 	case IWL_BT_COEX_TRAFFIC_LOAD_CONTINUOUS:
 		/* avoid antenna B and MIMO */
+		valid_tx_ant = first_antenna(priv->hw_params.valid_tx_ant);
 		if (tbl->action >= IWL_LEGACY_SWITCH_ANTENNA2 &&
 		    tbl->action != IWL_LEGACY_SWITCH_SISO)
-			tbl->action = IWL_SISO_SWITCH_ANTENNA1;
+			tbl->action = IWL_LEGACY_SWITCH_SISO;
 		break;
 	default:
 		IWL_ERR(priv, "Invalid BT load %d", priv->bt_traffic_load);
@@ -1362,6 +1364,7 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 			tbl->action = IWL_LEGACY_SWITCH_ANTENNA1;
 		else if (tbl->action >= IWL_LEGACY_SWITCH_ANTENNA2)
 			tbl->action = IWL_LEGACY_SWITCH_SISO;
+		valid_tx_ant = first_antenna(priv->hw_params.valid_tx_ant);
 	}
 
 	start_action = tbl->action;
@@ -1379,7 +1382,10 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 				break;
 
 			/* Don't change antenna if success has been great */
-			if (window->success_ratio >= IWL_RS_GOOD_RATIO)
+			if (window->success_ratio >= IWL_RS_GOOD_RATIO &&
+			    !priv->bt_full_concurrent &&
+			    priv->bt_traffic_load ==
+					IWL_BT_COEX_TRAFFIC_LOAD_NONE)
 				break;
 
 			/* Set up search table to try other antenna */
@@ -1503,14 +1509,15 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 		break;
 	case IWL_BT_COEX_TRAFFIC_LOAD_LOW:
 		/* avoid antenna B unless MIMO */
+		valid_tx_ant = first_antenna(priv->hw_params.valid_tx_ant);
 		if (tbl->action == IWL_SISO_SWITCH_ANTENNA2)
 			tbl->action = IWL_SISO_SWITCH_ANTENNA1;
 		break;
 	case IWL_BT_COEX_TRAFFIC_LOAD_HIGH:
 	case IWL_BT_COEX_TRAFFIC_LOAD_CONTINUOUS:
 		/* avoid antenna B and MIMO */
-		if (tbl->action >= IWL_SISO_SWITCH_ANTENNA2 &&
-		    tbl->action != IWL_SISO_SWITCH_GI)
+		valid_tx_ant = first_antenna(priv->hw_params.valid_tx_ant);
+		if (tbl->action != IWL_SISO_SWITCH_ANTENNA1)
 			tbl->action = IWL_SISO_SWITCH_ANTENNA1;
 		break;
 	default:
@@ -1525,9 +1532,11 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 	}
 
 	/* configure as 1x1 if bt full concurrency */
-	if (priv->bt_full_concurrent &&
-	    tbl->action >= IWL_LEGACY_SWITCH_ANTENNA2)
-		tbl->action = IWL_SISO_SWITCH_ANTENNA1;
+	if (priv->bt_full_concurrent) {
+		valid_tx_ant = first_antenna(priv->hw_params.valid_tx_ant);
+		if (tbl->action >= IWL_LEGACY_SWITCH_ANTENNA2)
+			tbl->action = IWL_SISO_SWITCH_ANTENNA1;
+	}
 
 	start_action = tbl->action;
 	for (;;) {
@@ -1536,14 +1545,16 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 		case IWL_SISO_SWITCH_ANTENNA1:
 		case IWL_SISO_SWITCH_ANTENNA2:
 			IWL_DEBUG_RATE(priv, "LQ: SISO toggle Antenna\n");
-
 			if ((tbl->action == IWL_SISO_SWITCH_ANTENNA1 &&
-							tx_chains_num <= 1) ||
+						tx_chains_num <= 1) ||
 			    (tbl->action == IWL_SISO_SWITCH_ANTENNA2 &&
-							tx_chains_num <= 2))
+						tx_chains_num <= 2))
 				break;
 
-			if (window->success_ratio >= IWL_RS_GOOD_RATIO)
+			if (window->success_ratio >= IWL_RS_GOOD_RATIO &&
+			    !priv->bt_full_concurrent &&
+			    priv->bt_traffic_load ==
+					IWL_BT_COEX_TRAFFIC_LOAD_NONE)
 				break;
 
 			memcpy(search_tbl, tbl, sz);
@@ -1670,13 +1681,13 @@ static int rs_move_mimo2_to_other(struct iwl_priv *priv,
 	case IWL_BT_COEX_TRAFFIC_LOAD_HIGH:
 	case IWL_BT_COEX_TRAFFIC_LOAD_CONTINUOUS:
 		/* avoid antenna B and MIMO */
-		if (tbl->action == IWL_MIMO2_SWITCH_MIMO3_ABC)
-			tbl->action = IWL_SISO_SWITCH_ANTENNA1;
+		if (tbl->action != IWL_MIMO2_SWITCH_SISO_A)
+			tbl->action = IWL_MIMO2_SWITCH_SISO_A;
+		break;
 	case IWL_BT_COEX_TRAFFIC_LOAD_LOW:
 		/* avoid antenna B unless MIMO */
-		if (tbl->action == IWL_MIMO2_SWITCH_ANTENNA2)
-			tbl->action = IWL_MIMO2_SWITCH_ANTENNA1;
-		else if (tbl->action == IWL_MIMO2_SWITCH_SISO_B)
+		if (tbl->action == IWL_MIMO2_SWITCH_SISO_B ||
+		    tbl->action == IWL_MIMO2_SWITCH_SISO_C)
 			tbl->action = IWL_MIMO2_SWITCH_SISO_A;
 		break;
 	default:
@@ -1840,16 +1851,14 @@ static int rs_move_mimo3_to_other(struct iwl_priv *priv,
 	case IWL_BT_COEX_TRAFFIC_LOAD_HIGH:
 	case IWL_BT_COEX_TRAFFIC_LOAD_CONTINUOUS:
 		/* avoid antenna B and MIMO */
-		if (tbl->action == IWL_MIMO3_SWITCH_MIMO2_AB ||
-		    tbl->action == IWL_MIMO3_SWITCH_MIMO2_AC ||
-		    tbl->action == IWL_MIMO3_SWITCH_MIMO2_BC)
+		if (tbl->action != IWL_MIMO3_SWITCH_SISO_A)
 			tbl->action = IWL_MIMO3_SWITCH_SISO_A;
+		break;
 	case IWL_BT_COEX_TRAFFIC_LOAD_LOW:
 		/* avoid antenna B unless MIMO */
-		if (tbl->action == IWL_MIMO3_SWITCH_SISO_B)
+		if (tbl->action == IWL_MIMO3_SWITCH_SISO_B ||
+		    tbl->action == IWL_MIMO3_SWITCH_SISO_C)
 			tbl->action = IWL_MIMO3_SWITCH_SISO_A;
-		else if (tbl->action == IWL_MIMO3_SWITCH_ANTENNA2)
-			tbl->action = IWL_MIMO3_SWITCH_ANTENNA1;
 		break;
 	default:
 		IWL_ERR(priv, "Invalid BT load %d", priv->bt_traffic_load);
@@ -1996,7 +2005,7 @@ static int rs_move_mimo3_to_other(struct iwl_priv *priv,
  * 2) # times calling this function
  * 3) elapsed time in this mode (not used, for now)
  */
-static void rs_stay_in_table(struct iwl_lq_sta *lq_sta)
+static void rs_stay_in_table(struct iwl_lq_sta *lq_sta, bool force_search)
 {
 	struct iwl_scale_tbl_info *tbl;
 	int i;
@@ -2027,7 +2036,8 @@ static void rs_stay_in_table(struct iwl_lq_sta *lq_sta)
 		 * allow a new search.  Also (below) reset all bitmaps and
 		 * stats in active history.
 		 */
-		if ((lq_sta->total_failed > lq_sta->max_failure_limit) ||
+		if (force_search ||
+		    (lq_sta->total_failed > lq_sta->max_failure_limit) ||
 		    (lq_sta->total_success > lq_sta->max_success_limit) ||
 		    ((!lq_sta->search_better_tbl) && (lq_sta->flush_timer)
 		     && (flush_interval_passed))) {
@@ -2243,7 +2253,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 
 		/* Should we stay with this modulation mode,
 		 * or search for a new one? */
-		rs_stay_in_table(lq_sta);
+		rs_stay_in_table(lq_sta, false);
 
 		goto out;
 	}
@@ -2392,16 +2402,25 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 		(is_mimo2(tbl->lq_type) || is_mimo3(tbl->lq_type)))
 		scale_action = -1;
 
-	if (lq_sta->last_bt_traffic > priv->bt_traffic_load) {
-		lq_sta->last_bt_traffic = priv->bt_traffic_load;
-		/*
-		 * don't set scale_action, don't want to scale up if
-		 * the rate scale doesn't otherwise think that is a
-		 * good idea.
-		 */
-	} else if (lq_sta->last_bt_traffic < priv->bt_traffic_load) {
-		lq_sta->last_bt_traffic = priv->bt_traffic_load;
-		scale_action = -1;
+	if ((priv->bt_traffic_load >= IWL_BT_COEX_TRAFFIC_LOAD_HIGH) &&
+	     (is_mimo2(tbl->lq_type) || is_mimo3(tbl->lq_type))) {
+		if (lq_sta->last_bt_traffic > priv->bt_traffic_load) {
+			/*
+			 * don't set scale_action, don't want to scale up if
+			 * the rate scale doesn't otherwise think that is a
+			 * good idea.
+			 */
+		} else if (lq_sta->last_bt_traffic <= priv->bt_traffic_load) {
+			scale_action = -1;
+		}
+	}
+	lq_sta->last_bt_traffic = priv->bt_traffic_load;
+
+	if ((priv->bt_traffic_load >= IWL_BT_COEX_TRAFFIC_LOAD_HIGH) &&
+	     (is_mimo2(tbl->lq_type) || is_mimo3(tbl->lq_type))) {
+		/* search for a new modulation */
+		rs_stay_in_table(lq_sta, true);
+		goto lq_update;
 	}
 
 	switch (scale_action) {
@@ -2440,7 +2459,7 @@ lq_update:
 	if (iwl_tx_ant_restriction(priv) == IWL_ANT_OK_MULTI) {
 		/* Should we stay with this modulation mode,
 		 * or search for a new one? */
-		rs_stay_in_table(lq_sta);
+	  rs_stay_in_table(lq_sta, false);
 	}
 	/*
 	 * Search for new modulation mode if we're:
@@ -2786,6 +2805,12 @@ static void rs_fill_link_cmd(struct iwl_priv *priv,
 	rs_get_tbl_info_from_mcs(new_rate, lq_sta->band,
 				  &tbl_type, &rate_idx);
 
+	if (priv && priv->bt_full_concurrent) {
+		/* 1x1 only */
+		tbl_type.ant_type =
+			first_antenna(priv->hw_params.valid_tx_ant);
+	}
+
 	/* How many times should we repeat the initial rate? */
 	if (is_legacy(tbl_type.lq_type)) {
 		ant_toggle_cnt = 1;
@@ -2800,8 +2825,7 @@ static void rs_fill_link_cmd(struct iwl_priv *priv,
 	/* Fill 1st table entry (index 0) */
 	lq_cmd->rs_table[index].rate_n_flags = cpu_to_le32(new_rate);
 
-	if (num_of_ant(tbl_type.ant_type) == 1 ||
-	    (priv && priv->bt_full_concurrent)) {
+	if (num_of_ant(tbl_type.ant_type) == 1) {
 		lq_cmd->general_params.single_stream_ant_msk =
 						tbl_type.ant_type;
 	} else if (num_of_ant(tbl_type.ant_type) == 2) {
@@ -2811,7 +2835,6 @@ static void rs_fill_link_cmd(struct iwl_priv *priv,
 
 	index++;
 	repeat_rate--;
-
 	if (priv) {
 		if (priv->bt_full_concurrent)
 			valid_tx_ant = ANT_A;
@@ -2832,7 +2855,7 @@ static void rs_fill_link_cmd(struct iwl_priv *priv,
 					 rs_toggle_antenna(valid_tx_ant,
 							&new_rate, &tbl_type))
 					ant_toggle_cnt = 1;
-}
+			}
 
 			/* Override next rate if needed for debug purposes */
 			rs_dbgfs_set_mcs(lq_sta, &new_rate, index);
@@ -2847,6 +2870,12 @@ static void rs_fill_link_cmd(struct iwl_priv *priv,
 		rs_get_tbl_info_from_mcs(new_rate, lq_sta->band, &tbl_type,
 						&rate_idx);
 
+		if (priv && priv->bt_full_concurrent) {
+			/* 1x1 only */
+			tbl_type.ant_type =
+				first_antenna(priv->hw_params.valid_tx_ant);
+		}
+
 		/* Indicate to uCode which entries might be MIMO.
 		 * If initial rate was MIMO, this will finally end up
 		 * as (IWL_HT_NUMBER_TRY * 2), after 2nd pass, otherwise 0. */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index e0592f4..bd006c5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2818,6 +2818,7 @@ static void __iwl_down(struct iwl_priv *priv)
 	iwl_clear_driver_stations(priv);
 
 	/* reset BT coex data */
+	priv->bt_status = 0;
 	priv->bt_traffic_load = priv->cfg->bt_init_traffic_load;
 	priv->bt_sco_active = false;
 	priv->bt_full_concurrent = false;
@@ -3128,6 +3129,7 @@ static void iwl_bg_restart(struct work_struct *data)
 		bool bt_sco, bt_full_concurrent;
 		u8 bt_ci_compliance;
 		u8 bt_load;
+		u8 bt_status;
 
 		mutex_lock(&priv->mutex);
 		priv->vif = NULL;
@@ -3146,6 +3148,7 @@ static void iwl_bg_restart(struct work_struct *data)
 		bt_full_concurrent = priv->bt_full_concurrent;
 		bt_ci_compliance = priv->bt_ci_compliance;
 		bt_load = priv->bt_traffic_load;
+		bt_status = priv->bt_status;
 
 		__iwl_down(priv);
 
@@ -3153,6 +3156,7 @@ static void iwl_bg_restart(struct work_struct *data)
 		priv->bt_full_concurrent = bt_full_concurrent;
 		priv->bt_ci_compliance = bt_ci_compliance;
 		priv->bt_traffic_load = bt_load;
+		priv->bt_status = bt_status;
 
 		mutex_unlock(&priv->mutex);
 		iwl_cancel_deferred_work(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 34cba38..c43124c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -780,8 +780,12 @@ EXPORT_SYMBOL(iwl_set_rxon_ht);
  */
 static int iwl_get_active_rx_chain_count(struct iwl_priv *priv)
 {
-	if (priv->cfg->advanced_bt_coexist && priv->bt_full_concurrent) {
-		/* operated as 1x1 in full concurrency mode */
+	if (priv->cfg->advanced_bt_coexist && (priv->bt_full_concurrent ||
+	    priv->bt_traffic_load >= IWL_BT_COEX_TRAFFIC_LOAD_HIGH)) {
+		/*
+		 * only use chain 'A' in bt high traffic load or
+		 * full concurrency mode
+		 */
 		return IWL_NUM_RX_CHAINS_SINGLE;
 	}
 	/* # of Rx chains to use when expecting MIMO. */
@@ -845,8 +849,12 @@ void iwl_set_rxon_chain(struct iwl_priv *priv)
 	else
 		active_chains = priv->hw_params.valid_rx_ant;
 
-	if (priv->cfg->advanced_bt_coexist && priv->bt_full_concurrent) {
-		/* operated as 1x1 in full concurrency mode */
+	if (priv->cfg->advanced_bt_coexist && (priv->bt_full_concurrent ||
+	    priv->bt_traffic_load >= IWL_BT_COEX_TRAFFIC_LOAD_HIGH)) {
+		/*
+		 * only use chain 'A' in bt high traffic load or
+		 * full concurrency mode
+		 */
 		active_chains = first_antenna(active_chains);
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 1adb68e..8d5201a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1367,6 +1367,7 @@ struct iwl_priv {
 	};
 
 	/* bt coex */
+	u8 bt_status;
 	u8 bt_traffic_load, notif_bt_traffic_load;
 	bool bt_ch_announce;
 	bool bt_sco_active;
-- 
1.7.0.4

