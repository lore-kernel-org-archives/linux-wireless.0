Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:43614 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758827Ab3LBU77 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Dec 2013 15:59:59 -0500
Received: by mail-wi0-f171.google.com with SMTP id ca18so5517548wib.10
        for <linux-wireless@vger.kernel.org>; Mon, 02 Dec 2013 12:59:58 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 12/13] iwlwifi: mvm: rs: overhaul search cycle state machine
Date: Mon,  2 Dec 2013 22:59:24 +0200
Message-Id: <1386017965-13641-12-git-send-email-egrumbach@gmail.com> (sfid-20131202_222459_626525_B988C8C8)
In-Reply-To: <529CF2D6.1080008@gmail.com>
References: <529CF2D6.1080008@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Rewrite the search cycle state machine to use a more data
oriented approach where the different Tx columns (configs)
limitations and next columns to search are reprsented in
tables which are easy to change. This overhaul also includes
several major fixes:

1. Prevent going back to a specific Tx column in a search
cycle if it was already explored.

2. Avoid switching to a Tx column that doesn't have any chance
if it performs perfectly to beat the current throughput we're
getting.

These issues were degrading throughput as they were causing
switching to "bad" Tx columns.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c |  921 +++++++++++++++------------------
 drivers/net/wireless/iwlwifi/mvm/rs.h |   64 +--
 2 files changed, 458 insertions(+), 527 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 1bfdde5..1bb6581 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -123,6 +123,190 @@ static const struct iwl_rs_rate_info iwl_rates[IWL_RATE_COUNT] = {
 	IWL_DECLARE_MCS_RATE(9),                 /* MCS 9 */
 };
 
+enum rs_column_mode {
+	RS_INVALID = 0,
+	RS_LEGACY,
+	RS_SISO,
+	RS_MIMO2,
+};
+
+#define MAX_NEXT_COLUMNS 5
+#define MAX_COLUMN_CHECKS 3
+
+typedef bool (*allow_column_func_t) (struct iwl_mvm *mvm,
+				     struct ieee80211_sta *sta,
+				     struct iwl_scale_tbl_info *tbl);
+
+struct rs_tx_column {
+	enum rs_column_mode mode;
+	u8 ant;
+	bool sgi;
+	enum rs_column next_columns[MAX_NEXT_COLUMNS];
+	allow_column_func_t checks[MAX_COLUMN_CHECKS];
+};
+
+static bool rs_mimo_allow(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
+			  struct iwl_scale_tbl_info *tbl)
+{
+	if (!sta->ht_cap.ht_supported)
+		return false;
+
+	if (sta->smps_mode == IEEE80211_SMPS_STATIC)
+		return false;
+
+	if (num_of_ant(iwl_fw_valid_tx_ant(mvm->fw)) < 2)
+		return false;
+
+	if (!iwl_mvm_bt_coex_is_mimo_allowed(mvm, sta))
+		return false;
+
+	return true;
+}
+
+static bool rs_siso_allow(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
+			  struct iwl_scale_tbl_info *tbl)
+{
+	if (!sta->ht_cap.ht_supported)
+		return false;
+
+	return true;
+}
+
+static bool rs_sgi_allow(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
+			 struct iwl_scale_tbl_info *tbl)
+{
+	struct rs_rate *rate = &tbl->rate;
+	struct ieee80211_sta_ht_cap *ht_cap = &sta->ht_cap;
+	struct ieee80211_sta_vht_cap *vht_cap = &sta->vht_cap;
+
+	if (is_ht20(rate) && (ht_cap->cap &
+			     IEEE80211_HT_CAP_SGI_20))
+		return true;
+	if (is_ht40(rate) && (ht_cap->cap &
+			     IEEE80211_HT_CAP_SGI_40))
+		return true;
+	if (is_ht80(rate) && (vht_cap->cap &
+			     IEEE80211_VHT_CAP_SHORT_GI_80))
+		return true;
+
+	return false;
+}
+
+static const struct rs_tx_column rs_tx_columns[] = {
+	[RS_COLUMN_LEGACY_ANT_A] = {
+		.mode = RS_LEGACY,
+		.ant = ANT_A,
+		.next_columns = {
+			RS_COLUMN_LEGACY_ANT_B,
+			RS_COLUMN_SISO_ANT_A,
+			RS_COLUMN_MIMO2,
+			RS_COLUMN_INVALID,
+			RS_COLUMN_INVALID,
+		},
+	},
+	[RS_COLUMN_LEGACY_ANT_B] = {
+		.mode = RS_LEGACY,
+		.ant = ANT_B,
+		.next_columns = {
+			RS_COLUMN_LEGACY_ANT_A,
+			RS_COLUMN_SISO_ANT_B,
+			RS_COLUMN_MIMO2,
+			RS_COLUMN_INVALID,
+			RS_COLUMN_INVALID,
+		},
+	},
+	[RS_COLUMN_SISO_ANT_A] = {
+		.mode = RS_SISO,
+		.ant = ANT_A,
+		.next_columns = {
+			RS_COLUMN_SISO_ANT_B,
+			RS_COLUMN_MIMO2,
+			RS_COLUMN_SISO_ANT_A_SGI,
+			RS_COLUMN_INVALID,
+			RS_COLUMN_INVALID,
+		},
+		.checks = {
+			rs_siso_allow,
+		},
+	},
+	[RS_COLUMN_SISO_ANT_B] = {
+		.mode = RS_SISO,
+		.ant = ANT_B,
+		.next_columns = {
+			RS_COLUMN_SISO_ANT_A,
+			RS_COLUMN_MIMO2,
+			RS_COLUMN_SISO_ANT_B_SGI,
+			RS_COLUMN_INVALID,
+			RS_COLUMN_INVALID,
+		},
+		.checks = {
+			rs_siso_allow,
+		},
+	},
+	[RS_COLUMN_SISO_ANT_A_SGI] = {
+		.mode = RS_SISO,
+		.ant = ANT_A,
+		.sgi = true,
+		.next_columns = {
+			RS_COLUMN_SISO_ANT_B_SGI,
+			RS_COLUMN_MIMO2_SGI,
+			RS_COLUMN_SISO_ANT_A,
+			RS_COLUMN_INVALID,
+			RS_COLUMN_INVALID,
+		},
+		.checks = {
+			rs_siso_allow,
+			rs_sgi_allow,
+		},
+	},
+	[RS_COLUMN_SISO_ANT_B_SGI] = {
+		.mode = RS_SISO,
+		.ant = ANT_B,
+		.sgi = true,
+		.next_columns = {
+			RS_COLUMN_SISO_ANT_A_SGI,
+			RS_COLUMN_MIMO2_SGI,
+			RS_COLUMN_SISO_ANT_B,
+			RS_COLUMN_INVALID,
+			RS_COLUMN_INVALID,
+		},
+		.checks = {
+			rs_siso_allow,
+			rs_sgi_allow,
+		},
+	},
+	[RS_COLUMN_MIMO2] = {
+		.mode = RS_MIMO2,
+		.ant = ANT_AB,
+		.next_columns = {
+			RS_COLUMN_SISO_ANT_A,
+			RS_COLUMN_MIMO2_SGI,
+			RS_COLUMN_INVALID,
+			RS_COLUMN_INVALID,
+			RS_COLUMN_INVALID,
+		},
+		.checks = {
+			rs_mimo_allow,
+		},
+	},
+	[RS_COLUMN_MIMO2_SGI] = {
+		.mode = RS_MIMO2,
+		.ant = ANT_AB,
+		.sgi = true,
+		.next_columns = {
+			RS_COLUMN_SISO_ANT_A_SGI,
+			RS_COLUMN_MIMO2,
+			RS_COLUMN_INVALID,
+			RS_COLUMN_INVALID,
+			RS_COLUMN_INVALID,
+		},
+		.checks = {
+			rs_mimo_allow,
+			rs_sgi_allow,
+		},
+	},
+};
+
 static inline u8 rs_extract_rate(u32 rate_n_flags)
 {
 	/* also works for HT because bits 7:6 are zero there */
@@ -839,6 +1023,9 @@ static void rs_tx_status(void *mvm_r, struct ieee80211_supported_band *sband,
 		lq_sta->missed_rate_counter++;
 		if (lq_sta->missed_rate_counter > IWL_MISSED_RATE_MAX) {
 			lq_sta->missed_rate_counter = 0;
+			IWL_DEBUG_RATE(mvm,
+				       "Too many rates mismatch. Send sync LQ. rs_state %d\n",
+				       lq_sta->rs_state);
 			iwl_mvm_send_lq_cmd(mvm, &lq_sta->lq, false);
 		}
 		/* Regardless, ignore this status info for outdated rate */
@@ -888,7 +1075,7 @@ static void rs_tx_status(void *mvm_r, struct ieee80211_supported_band *sband,
 				   info->status.ampdu_ack_len);
 
 		/* Update success/fail counts if not searching for new mode */
-		if (lq_sta->stay_in_tbl) {
+		if (lq_sta->rs_state == RS_STATE_STAY_IN_COLUMN) {
 			lq_sta->total_success += info->status.ampdu_ack_len;
 			lq_sta->total_failed += (info->status.ampdu_len -
 					info->status.ampdu_ack_len);
@@ -915,14 +1102,20 @@ static void rs_tx_status(void *mvm_r, struct ieee80211_supported_band *sband,
 				tmp_tbl = curr_tbl;
 			else if (rs_rate_match(&rate, &other_tbl->rate))
 				tmp_tbl = other_tbl;
-			else
+			else {
+				IWL_DEBUG_RATE(mvm,
+					       "Tx packet rate doesn't match ACTIVE or SEARCH tables\n");
+				rs_dump_rate(mvm, &rate, "Tx PACKET:");
+				rs_dump_rate(mvm, &curr_tbl->rate, "CURRENT:");
+				rs_dump_rate(mvm, &other_tbl->rate, "OTHER:");
 				continue;
+			}
 			rs_collect_tx_data(tmp_tbl, rate.index, 1,
 					   i < retries ? 0 : legacy_success);
 		}
 
 		/* Update success/fail counts if not searching for new mode */
-		if (lq_sta->stay_in_tbl) {
+		if (lq_sta->rs_state == RS_STATE_STAY_IN_COLUMN) {
 			lq_sta->total_success += legacy_success;
 			lq_sta->total_failed += retries + (1 - legacy_success);
 		}
@@ -946,8 +1139,8 @@ done:
 static void rs_set_stay_in_table(struct iwl_mvm *mvm, u8 is_legacy,
 				 struct iwl_lq_sta *lq_sta)
 {
-	IWL_DEBUG_RATE(mvm, "we are staying in the same table\n");
-	lq_sta->stay_in_tbl = 1;	/* only place this gets set */
+	IWL_DEBUG_RATE(mvm, "Moving to RS_STATE_STAY_IN_COLUMN\n");
+	lq_sta->rs_state = RS_STATE_STAY_IN_COLUMN;
 	if (is_legacy) {
 		lq_sta->table_count_limit = IWL_LEGACY_TABLE_COUNT;
 		lq_sta->max_failure_limit = IWL_LEGACY_FAILURE_LIMIT;
@@ -961,38 +1154,31 @@ static void rs_set_stay_in_table(struct iwl_mvm *mvm, u8 is_legacy,
 	lq_sta->total_failed = 0;
 	lq_sta->total_success = 0;
 	lq_sta->flush_timer = jiffies;
-	lq_sta->action_counter = 0;
+	lq_sta->visited_columns = 0;
 }
 
-/*
- * Find correct throughput table for given mode of modulation
- */
-static void rs_set_expected_tpt_table(struct iwl_lq_sta *lq_sta,
-				      struct iwl_scale_tbl_info *tbl)
+static s32 *rs_get_expected_tpt_table(struct iwl_lq_sta *lq_sta,
+				      const struct rs_tx_column *column,
+				      u32 bw)
 {
 	/* Used to choose among HT tables */
 	s32 (*ht_tbl_pointer)[IWL_RATE_COUNT];
-	struct rs_rate *rate = &tbl->rate;
 
-	/* Check for invalid LQ type */
-	if (WARN_ON_ONCE(!is_legacy(rate) && !is_ht(rate) &&
-			 !(is_vht(rate)))) {
-		tbl->expected_tpt = expected_tpt_legacy;
-		return;
-	}
+	if (WARN_ON_ONCE(column->mode != RS_LEGACY &&
+			 column->mode != RS_SISO &&
+			 column->mode != RS_MIMO2))
+		return expected_tpt_legacy;
 
 	/* Legacy rates have only one table */
-	if (is_legacy(rate)) {
-		tbl->expected_tpt = expected_tpt_legacy;
-		return;
-	}
+	if (column->mode == RS_LEGACY)
+		return expected_tpt_legacy;
 
 	ht_tbl_pointer = expected_tpt_mimo2_20MHz;
 	/* Choose among many HT tables depending on number of streams
 	 * (SISO/MIMO2), channel width (20/40/80), SGI, and aggregation
 	 * status */
-	if (is_siso(rate)) {
-		switch (rate->bw) {
+	if (column->mode == RS_SISO) {
+		switch (bw) {
 		case RATE_MCS_CHAN_WIDTH_20:
 			ht_tbl_pointer = expected_tpt_siso_20MHz;
 			break;
@@ -1005,8 +1191,8 @@ static void rs_set_expected_tpt_table(struct iwl_lq_sta *lq_sta,
 		default:
 			WARN_ON_ONCE(1);
 		}
-	} else if (is_mimo2(rate)) {
-		switch (rate->bw) {
+	} else if (column->mode == RS_MIMO2) {
+		switch (bw) {
 		case RATE_MCS_CHAN_WIDTH_20:
 			ht_tbl_pointer = expected_tpt_mimo2_20MHz;
 			break;
@@ -1023,14 +1209,23 @@ static void rs_set_expected_tpt_table(struct iwl_lq_sta *lq_sta,
 		WARN_ON_ONCE(1);
 	}
 
-	if (!rate->sgi && !lq_sta->is_agg)		/* Normal */
-		tbl->expected_tpt = ht_tbl_pointer[0];
-	else if (rate->sgi && !lq_sta->is_agg)	        /* SGI */
-		tbl->expected_tpt = ht_tbl_pointer[1];
-	else if (!rate->sgi && lq_sta->is_agg)	        /* AGG */
-		tbl->expected_tpt = ht_tbl_pointer[2];
+	if (!column->sgi && !lq_sta->is_agg)		/* Normal */
+		return ht_tbl_pointer[0];
+	else if (column->sgi && !lq_sta->is_agg)        /* SGI */
+		return ht_tbl_pointer[1];
+	else if (!column->sgi && lq_sta->is_agg)        /* AGG */
+		return ht_tbl_pointer[2];
 	else						/* AGG+SGI */
-		tbl->expected_tpt = ht_tbl_pointer[3];
+		return ht_tbl_pointer[3];
+}
+
+static void rs_set_expected_tpt_table(struct iwl_lq_sta *lq_sta,
+				      struct iwl_scale_tbl_info *tbl)
+{
+	struct rs_rate *rate = &tbl->rate;
+	const struct rs_tx_column *column = &rs_tx_columns[tbl->column];
+
+	tbl->expected_tpt = rs_get_expected_tpt_table(lq_sta, column, rate->bw);
 }
 
 /*
@@ -1135,19 +1330,6 @@ static s32 rs_get_best_rate(struct iwl_mvm *mvm,
 	return new_rate;
 }
 
-/* Move to the next action and wrap around to the first action in case
- * we're at the last action. Assumes actions start at 0.
- */
-static inline void rs_move_next_action(struct iwl_scale_tbl_info *tbl,
-				       u8 last_action)
-{
-	BUILD_BUG_ON(IWL_LEGACY_FIRST_ACTION != 0);
-	BUILD_BUG_ON(IWL_SISO_FIRST_ACTION != 0);
-	BUILD_BUG_ON(IWL_MIMO2_FIRST_ACTION != 0);
-
-	tbl->action = (tbl->action + 1) % (last_action + 1);
-}
-
 static u32 rs_bw_from_sta_bw(struct ieee80211_sta *sta)
 {
 	if (sta->bandwidth >= IEEE80211_STA_RX_BW_80)
@@ -1158,409 +1340,6 @@ static u32 rs_bw_from_sta_bw(struct ieee80211_sta *sta)
 	return RATE_MCS_CHAN_WIDTH_20;
 }
 
-static bool rs_sgi_allowed(struct rs_rate *rate,
-			   struct ieee80211_sta *sta)
-{
-	struct ieee80211_sta_ht_cap *ht_cap = &sta->ht_cap;
-	struct ieee80211_sta_vht_cap *vht_cap = &sta->vht_cap;
-
-	if (is_ht20(rate) && (ht_cap->cap &
-			     IEEE80211_HT_CAP_SGI_20))
-		return true;
-	if (is_ht40(rate) && (ht_cap->cap &
-			     IEEE80211_HT_CAP_SGI_40))
-		return true;
-	if (is_ht80(rate) && (vht_cap->cap &
-			     IEEE80211_VHT_CAP_SHORT_GI_80))
-		return true;
-
-	return false;
-}
-
-/*
- * Set up search table for MIMO2
- */
-static int rs_switch_to_mimo2(struct iwl_mvm *mvm,
-			     struct iwl_lq_sta *lq_sta,
-			     struct ieee80211_sta *sta,
-			     struct iwl_scale_tbl_info *tbl, int index)
-{
-	u16 rate_mask;
-	s32 rate_idx;
-
-	if (!sta->ht_cap.ht_supported)
-		return -1;
-
-	if (sta->smps_mode == IEEE80211_SMPS_STATIC)
-		return -1;
-
-	/* Need both Tx chains/antennas to support MIMO */
-	if (num_of_ant(iwl_fw_valid_tx_ant(mvm->fw)) < 2)
-		return -1;
-
-	IWL_DEBUG_RATE(mvm, "LQ: try to switch to MIMO2\n");
-
-	tbl->rate.type = lq_sta->is_vht ? LQ_VHT_MIMO2 : LQ_HT_MIMO2;
-	tbl->action = 0;
-	tbl->max_search = IWL_MAX_SEARCH;
-	rate_mask = lq_sta->active_mimo2_rate;
-
-	tbl->rate.bw = rs_bw_from_sta_bw(sta);
-	rs_set_expected_tpt_table(lq_sta, tbl);
-
-	rate_idx = rs_get_best_rate(mvm, lq_sta, tbl, rate_mask, index);
-
-	IWL_DEBUG_RATE(mvm, "LQ: MIMO2 best rate %d mask %X\n",
-		       rate_idx, rate_mask);
-	if ((rate_idx == IWL_RATE_INVALID) || !((1 << rate_idx) & rate_mask)) {
-		IWL_DEBUG_RATE(mvm, "Can't switch with index %d rate mask %x\n",
-			       rate_idx, rate_mask);
-		return -1;
-	}
-
-	tbl->rate.index = rate_idx;
-	tbl->current_rate = ucode_rate_from_rs_rate(mvm, &tbl->rate);
-
-	IWL_DEBUG_RATE(mvm, "LQ: Switch to new mcs %X index\n",
-		       tbl->current_rate);
-	return 0;
-}
-
-/*
- * Set up search table for SISO
- */
-static int rs_switch_to_siso(struct iwl_mvm *mvm,
-			     struct iwl_lq_sta *lq_sta,
-			     struct ieee80211_sta *sta,
-			     struct iwl_scale_tbl_info *tbl, int index)
-{
-	u16 rate_mask;
-	s32 rate_idx;
-
-	if (!sta->ht_cap.ht_supported)
-		return -1;
-
-	IWL_DEBUG_RATE(mvm, "LQ: try to switch to SISO\n");
-
-	tbl->rate.type = lq_sta->is_vht ? LQ_VHT_SISO : LQ_HT_SISO;
-	tbl->action = 0;
-	tbl->max_search = IWL_MAX_SEARCH;
-	rate_mask = lq_sta->active_siso_rate;
-
-	tbl->rate.bw = rs_bw_from_sta_bw(sta);
-	rs_set_expected_tpt_table(lq_sta, tbl);
-	rate_idx = rs_get_best_rate(mvm, lq_sta, tbl, rate_mask, index);
-
-	IWL_DEBUG_RATE(mvm, "LQ: get best rate %d mask %X\n",
-		       rate_idx, rate_mask);
-	if ((rate_idx == IWL_RATE_INVALID) || !((1 << rate_idx) & rate_mask)) {
-		IWL_DEBUG_RATE(mvm,
-			       "can not switch with index %d rate mask %x\n",
-			       rate_idx, rate_mask);
-		return -1;
-	}
-
-	tbl->rate.index = rate_idx;
-	tbl->current_rate = ucode_rate_from_rs_rate(mvm, &tbl->rate);
-
-	IWL_DEBUG_RATE(mvm, "LQ: Switch to new mcs %X index\n",
-		       tbl->current_rate);
-	return 0;
-}
-
-/*
- * Try to switch to new modulation mode from legacy
- */
-static int rs_move_legacy_other(struct iwl_mvm *mvm,
-				struct iwl_lq_sta *lq_sta,
-				struct ieee80211_sta *sta,
-				int index)
-{
-	struct iwl_scale_tbl_info *tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
-	struct iwl_scale_tbl_info *search_tbl =
-				&(lq_sta->lq_info[(1 - lq_sta->active_tbl)]);
-	struct rs_rate *rate = &search_tbl->rate;
-	struct iwl_rate_scale_data *window = &(tbl->win[index]);
-	u32 sz = (sizeof(struct iwl_scale_tbl_info) -
-		  (sizeof(struct iwl_rate_scale_data) * IWL_RATE_COUNT));
-	u8 start_action;
-	u8 valid_tx_ant = iwl_fw_valid_tx_ant(mvm->fw);
-	u8 tx_chains_num = num_of_ant(valid_tx_ant);
-	int ret;
-	u8 update_search_tbl_counter = 0;
-
-	start_action = tbl->action;
-	while (1) {
-		lq_sta->action_counter++;
-		switch (tbl->action) {
-		case IWL_LEGACY_SWITCH_ANTENNA:
-			IWL_DEBUG_RATE(mvm, "LQ: Legacy toggle Antenna\n");
-
-			if (tx_chains_num <= 1)
-				break;
-
-			/* Don't change antenna if success has been great */
-			if (window->success_ratio >= IWL_RS_GOOD_RATIO)
-				break;
-
-			/* Set up search table to try other antenna */
-			memcpy(search_tbl, tbl, sz);
-
-			if (rs_toggle_antenna(valid_tx_ant,
-					      &search_tbl->current_rate,
-					      &search_tbl->rate)) {
-				update_search_tbl_counter = 1;
-				rs_set_expected_tpt_table(lq_sta, search_tbl);
-				goto out;
-			}
-			break;
-		case IWL_LEGACY_SWITCH_SISO:
-			IWL_DEBUG_RATE(mvm, "LQ: Legacy switch to SISO\n");
-
-			/* Set up search table to try SISO */
-			memcpy(search_tbl, tbl, sz);
-			rate->sgi = false;
-			ret = rs_switch_to_siso(mvm, lq_sta, sta,
-						 search_tbl, index);
-			if (!ret) {
-				lq_sta->action_counter = 0;
-				goto out;
-			}
-
-			break;
-		case IWL_LEGACY_SWITCH_MIMO2:
-			IWL_DEBUG_RATE(mvm, "LQ: Legacy switch to MIMO2\n");
-
-			/* Set up search table to try MIMO */
-			memcpy(search_tbl, tbl, sz);
-			rate->sgi = false;
-			rate->ant = ANT_AB;
-
-			if (!rs_is_valid_ant(valid_tx_ant,
-					     rate->ant))
-				break;
-
-			ret = rs_switch_to_mimo2(mvm, lq_sta, sta,
-						 search_tbl, index);
-			if (!ret) {
-				lq_sta->action_counter = 0;
-				goto out;
-			}
-			break;
-		default:
-			WARN_ON_ONCE(1);
-		}
-		rs_move_next_action(tbl, IWL_LEGACY_LAST_ACTION);
-
-		if (tbl->action == start_action)
-			break;
-	}
-	rate->type = LQ_NONE;
-	return 0;
-
-out:
-	lq_sta->search_better_tbl = 1;
-	rs_move_next_action(tbl, IWL_LEGACY_LAST_ACTION);
-	if (update_search_tbl_counter)
-		search_tbl->action = tbl->action;
-	return 0;
-}
-
-/*
- * Try to switch to new modulation mode from SISO
- */
-static int rs_move_siso_to_other(struct iwl_mvm *mvm,
-				 struct iwl_lq_sta *lq_sta,
-				 struct ieee80211_sta *sta, int index)
-{
-	struct iwl_scale_tbl_info *tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
-	struct iwl_scale_tbl_info *search_tbl =
-				&(lq_sta->lq_info[(1 - lq_sta->active_tbl)]);
-	struct rs_rate *rate = &search_tbl->rate;
-	struct iwl_rate_scale_data *window = &(tbl->win[index]);
-	u32 sz = (sizeof(struct iwl_scale_tbl_info) -
-		  (sizeof(struct iwl_rate_scale_data) * IWL_RATE_COUNT));
-	u8 start_action;
-	u8 valid_tx_ant = iwl_fw_valid_tx_ant(mvm->fw);
-	u8 tx_chains_num = num_of_ant(valid_tx_ant);
-	u8 update_search_tbl_counter = 0;
-	int ret;
-
-	if (tbl->action == IWL_SISO_SWITCH_MIMO2 &&
-	    !iwl_mvm_bt_coex_is_mimo_allowed(mvm, sta))
-		tbl->action = IWL_SISO_SWITCH_ANTENNA;
-
-	start_action = tbl->action;
-	while (1) {
-		lq_sta->action_counter++;
-		switch (tbl->action) {
-		case IWL_SISO_SWITCH_ANTENNA:
-			IWL_DEBUG_RATE(mvm, "LQ: SISO toggle Antenna\n");
-			if (tx_chains_num <= 1)
-				break;
-
-			if (window->success_ratio >= IWL_RS_GOOD_RATIO &&
-			    BT_MBOX_MSG(&mvm->last_bt_notif, 3,
-					TRAFFIC_LOAD) == 0)
-				break;
-
-			memcpy(search_tbl, tbl, sz);
-			if (rs_toggle_antenna(valid_tx_ant,
-					      &search_tbl->current_rate,
-					      rate)) {
-				update_search_tbl_counter = 1;
-				goto out;
-			}
-			break;
-		case IWL_SISO_SWITCH_MIMO2:
-			IWL_DEBUG_RATE(mvm, "LQ: SISO switch to MIMO2\n");
-			memcpy(search_tbl, tbl, sz);
-			rate->sgi = false;
-			rate->ant = ANT_AB;
-
-			if (!rs_is_valid_ant(valid_tx_ant,
-					     rate->ant))
-				break;
-
-			ret = rs_switch_to_mimo2(mvm, lq_sta, sta,
-						 search_tbl, index);
-			if (!ret)
-				goto out;
-			break;
-		case IWL_SISO_SWITCH_GI:
-			if (!rs_sgi_allowed(rate, sta))
-				break;
-
-			IWL_DEBUG_RATE(mvm, "LQ: SISO toggle SGI/NGI\n");
-
-			memcpy(search_tbl, tbl, sz);
-			rate->sgi = !tbl->rate.sgi;
-			rs_set_expected_tpt_table(lq_sta, search_tbl);
-			if (tbl->rate.sgi) {
-				s32 tpt = lq_sta->last_tpt / 100;
-				if (tpt >= search_tbl->expected_tpt[index])
-					break;
-			}
-			rate->index = index;
-			search_tbl->current_rate =
-				ucode_rate_from_rs_rate(mvm, rate);
-			update_search_tbl_counter = 1;
-			goto out;
-		default:
-			WARN_ON_ONCE(1);
-		}
-		rs_move_next_action(tbl, IWL_SISO_LAST_ACTION);
-
-		if (tbl->action == start_action)
-			break;
-	}
-	rate->type = LQ_NONE;
-	return 0;
-
- out:
-	lq_sta->search_better_tbl = 1;
-	rs_move_next_action(tbl, IWL_SISO_LAST_ACTION);
-	if (update_search_tbl_counter)
-		search_tbl->action = tbl->action;
-
-	return 0;
-}
-
-/*
- * Try to switch to new modulation mode from MIMO2
- */
-static int rs_move_mimo2_to_other(struct iwl_mvm *mvm,
-				 struct iwl_lq_sta *lq_sta,
-				 struct ieee80211_sta *sta, int index)
-{
-	struct iwl_scale_tbl_info *tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
-	struct iwl_scale_tbl_info *search_tbl =
-				&(lq_sta->lq_info[(1 - lq_sta->active_tbl)]);
-	struct rs_rate *rate = &search_tbl->rate;
-	u32 sz = (sizeof(struct iwl_scale_tbl_info) -
-		  (sizeof(struct iwl_rate_scale_data) * IWL_RATE_COUNT));
-	u8 start_action;
-	u8 valid_tx_ant = iwl_fw_valid_tx_ant(mvm->fw);
-	u8 update_search_tbl_counter = 0;
-	int ret;
-
-	if (!iwl_mvm_bt_coex_is_mimo_allowed(mvm, sta)) {
-		IWL_DEBUG_RATE(mvm, "BT COEX force switch to SISO A\n");
-		tbl->action = IWL_MIMO2_SWITCH_SISO_A;
-	}
-
-	start_action = tbl->action;
-	while (1) {
-		lq_sta->action_counter++;
-		switch (tbl->action) {
-		case IWL_MIMO2_SWITCH_SISO_A:
-		case IWL_MIMO2_SWITCH_SISO_B:
-			IWL_DEBUG_RATE(mvm, "LQ: MIMO2 switch to SISO\n");
-
-			/* Set up new search table for SISO */
-			memcpy(search_tbl, tbl, sz);
-
-			if (tbl->action == IWL_MIMO2_SWITCH_SISO_A)
-				rate->ant = ANT_A;
-			else /* tbl->action == IWL_MIMO2_SWITCH_SISO_B */
-				rate->ant = ANT_B;
-
-			if (!rs_is_valid_ant(valid_tx_ant,
-					     rate->ant))
-				break;
-
-			ret = rs_switch_to_siso(mvm, lq_sta, sta,
-						 search_tbl, index);
-			if (!ret)
-				goto out;
-
-			break;
-
-		case IWL_MIMO2_SWITCH_GI:
-			if (!rs_sgi_allowed(rate, sta))
-				break;
-
-			IWL_DEBUG_RATE(mvm, "LQ: MIMO2 toggle SGI/NGI\n");
-
-			/* Set up new search table for MIMO2 */
-			memcpy(search_tbl, tbl, sz);
-			rate->sgi = !tbl->rate.sgi;
-			rs_set_expected_tpt_table(lq_sta, search_tbl);
-			/*
-			 * If active table already uses the fastest possible
-			 * modulation (dual stream with short guard interval),
-			 * and it's working well, there's no need to look
-			 * for a better type of modulation!
-			 */
-			if (tbl->rate.sgi) {
-				s32 tpt = lq_sta->last_tpt / 100;
-				if (tpt >= search_tbl->expected_tpt[index])
-					break;
-			}
-			rate->index = index;
-			search_tbl->current_rate =
-				ucode_rate_from_rs_rate(mvm, rate);
-			update_search_tbl_counter = 1;
-			goto out;
-		default:
-			WARN_ON_ONCE(1);
-		}
-		rs_move_next_action(tbl, IWL_MIMO2_LAST_ACTION);
-
-		if (tbl->action == start_action)
-			break;
-	}
-	rate->type = LQ_NONE;
-	return 0;
- out:
-	lq_sta->search_better_tbl = 1;
-	rs_move_next_action(tbl, IWL_MIMO2_LAST_ACTION);
-	if (update_search_tbl_counter)
-		search_tbl->action = tbl->action;
-
-	return 0;
-}
-
 /*
  * Check whether we should continue using same modulation mode, or
  * begin search for a new mode, based on:
@@ -1582,7 +1361,7 @@ static void rs_stay_in_table(struct iwl_lq_sta *lq_sta, bool force_search)
 	tbl = &(lq_sta->lq_info[active_tbl]);
 
 	/* If we've been disallowing search, see if we should now allow it */
-	if (lq_sta->stay_in_tbl) {
+	if (lq_sta->rs_state == RS_STATE_STAY_IN_COLUMN) {
 		/* Elapsed time using current modulation mode */
 		if (lq_sta->flush_timer)
 			flush_interval_passed =
@@ -1610,10 +1389,14 @@ static void rs_stay_in_table(struct iwl_lq_sta *lq_sta, bool force_search)
 				     flush_interval_passed);
 
 			/* Allow search for new mode */
-			lq_sta->stay_in_tbl = 0;	/* only place reset */
+			lq_sta->rs_state = RS_STATE_SEARCH_CYCLE_STARTED;
+			IWL_DEBUG_RATE(mvm,
+				       "Moving to RS_STATE_SEARCH_CYCLE_STARTED\n");
 			lq_sta->total_failed = 0;
 			lq_sta->total_success = 0;
 			lq_sta->flush_timer = 0;
+			/* mark the current column as visited */
+			lq_sta->visited_columns = BIT(tbl->column);
 		/*
 		 * Else if we've used this modulation mode enough repetitions
 		 * (regardless of elapsed time or success/failure), reset
@@ -1637,7 +1420,8 @@ static void rs_stay_in_table(struct iwl_lq_sta *lq_sta, bool force_search)
 		/* If transitioning to allow "search", reset all history
 		 * bitmaps and stats in active table (this will become the new
 		 * "search" table). */
-		if (!lq_sta->stay_in_tbl) {
+		if (lq_sta->rs_state == RS_STATE_SEARCH_CYCLE_STARTED) {
+			IWL_DEBUG_RATE(mvm, "Clearing up window stats\n");
 			for (i = 0; i < IWL_RATE_COUNT; i++)
 				rs_rate_scale_clear_window(&(tbl->win[i]));
 		}
@@ -1675,6 +1459,162 @@ static u8 rs_get_tid(struct iwl_lq_sta *lq_data,
 	return tid;
 }
 
+static enum rs_column rs_get_next_column(struct iwl_mvm *mvm,
+					 struct iwl_lq_sta *lq_sta,
+					 struct ieee80211_sta *sta,
+					 struct iwl_scale_tbl_info *tbl)
+{
+	int i, j, n;
+	enum rs_column next_col_id;
+	const struct rs_tx_column *curr_col = &rs_tx_columns[tbl->column];
+	const struct rs_tx_column *next_col;
+	allow_column_func_t allow_func;
+	u8 valid_ants = iwl_fw_valid_tx_ant(mvm->fw);
+	s32 *expected_tpt_tbl;
+	s32 tpt, max_expected_tpt;
+
+	for (i = 0; i < MAX_NEXT_COLUMNS; i++) {
+		next_col_id = curr_col->next_columns[i];
+
+		if (next_col_id == RS_COLUMN_INVALID)
+			continue;
+
+		if (lq_sta->visited_columns & BIT(next_col_id)) {
+			IWL_DEBUG_RATE(mvm, "Skip already visited column %d\n",
+				       next_col_id);
+			continue;
+		}
+
+		next_col = &rs_tx_columns[next_col_id];
+
+		if (!rs_is_valid_ant(valid_ants, next_col->ant)) {
+			IWL_DEBUG_RATE(mvm,
+				       "Skip column %d as ANT config isn't supported by chip. valid_ants 0x%x column ant 0x%x\n",
+				       next_col_id, valid_ants, next_col->ant);
+			continue;
+		}
+
+		for (j = 0; j < MAX_COLUMN_CHECKS; j++) {
+			allow_func = next_col->checks[j];
+			if (allow_func && !allow_func(mvm, sta, tbl))
+				break;
+		}
+
+		if (j != MAX_COLUMN_CHECKS) {
+			IWL_DEBUG_RATE(mvm,
+				       "Skip column %d: not allowed (check %d failed)\n",
+				       next_col_id, j);
+
+			continue;
+		}
+
+		tpt = lq_sta->last_tpt / 100;
+		expected_tpt_tbl = rs_get_expected_tpt_table(lq_sta, next_col,
+							     tbl->rate.bw);
+		if (WARN_ON_ONCE(!expected_tpt_tbl))
+			continue;
+
+		max_expected_tpt = 0;
+		for (n = 0; n < IWL_RATE_COUNT; n++)
+			if (expected_tpt_tbl[n] > max_expected_tpt)
+				max_expected_tpt = expected_tpt_tbl[n];
+
+		if (tpt >= max_expected_tpt) {
+			IWL_DEBUG_RATE(mvm,
+				       "Skip column %d: can't beat current TPT. Max expected %d current %d\n",
+				       next_col_id, max_expected_tpt, tpt);
+			continue;
+		}
+
+		break;
+	}
+
+	if (i == MAX_NEXT_COLUMNS)
+		return RS_COLUMN_INVALID;
+
+	IWL_DEBUG_RATE(mvm, "Found potential column %d\n", next_col_id);
+
+	return next_col_id;
+}
+
+static int rs_switch_to_column(struct iwl_mvm *mvm,
+			       struct iwl_lq_sta *lq_sta,
+			       struct ieee80211_sta *sta,
+			       enum rs_column col_id)
+{
+	struct iwl_scale_tbl_info *tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
+	struct iwl_scale_tbl_info *search_tbl =
+				&(lq_sta->lq_info[(1 - lq_sta->active_tbl)]);
+	struct rs_rate *rate = &search_tbl->rate;
+	const struct rs_tx_column *column = &rs_tx_columns[col_id];
+	const struct rs_tx_column *curr_column = &rs_tx_columns[tbl->column];
+	u32 sz = (sizeof(struct iwl_scale_tbl_info) -
+		  (sizeof(struct iwl_rate_scale_data) * IWL_RATE_COUNT));
+	u16 rate_mask = 0;
+	u32 rate_idx = 0;
+
+	memcpy(search_tbl, tbl, sz);
+
+	rate->sgi = column->sgi;
+	rate->ant = column->ant;
+
+	if (column->mode == RS_LEGACY) {
+		if (lq_sta->band == IEEE80211_BAND_5GHZ)
+			rate->type = LQ_LEGACY_A;
+		else
+			rate->type = LQ_LEGACY_G;
+
+		rate_mask = lq_sta->active_legacy_rate;
+	} else if (column->mode == RS_SISO) {
+		rate->type = lq_sta->is_vht ? LQ_VHT_SISO : LQ_HT_SISO;
+		rate_mask = lq_sta->active_siso_rate;
+	} else if (column->mode == RS_MIMO2) {
+		rate->type = lq_sta->is_vht ? LQ_VHT_MIMO2 : LQ_HT_MIMO2;
+		rate_mask = lq_sta->active_mimo2_rate;
+	} else {
+		WARN_ON_ONCE("Bad column mode");
+	}
+
+	rate->bw = rs_bw_from_sta_bw(sta);
+	search_tbl->column = col_id;
+	rs_set_expected_tpt_table(lq_sta, search_tbl);
+
+	/* Get the best matching rate if we're changing modes. e.g.
+	 * SISO->MIMO, LEGACY->SISO, MIMO->SISO
+	 */
+	if (curr_column->mode != column->mode) {
+		rate_idx = rs_get_best_rate(mvm, lq_sta, search_tbl,
+					    rate_mask, rate->index);
+
+		if ((rate_idx == IWL_RATE_INVALID) ||
+		    !(BIT(rate_idx) & rate_mask)) {
+			IWL_DEBUG_RATE(mvm,
+				       "can not switch with index %d"
+				       " rate mask %x\n",
+				       rate_idx, rate_mask);
+
+			goto err;
+		}
+
+		rate->index = rate_idx;
+	}
+
+	/* TODO: remove current_rate and keep using rs_rate all the way until
+	 * we need to fill in the rs_table in the LQ command
+	 */
+	search_tbl->current_rate = ucode_rate_from_rs_rate(mvm, rate);
+	IWL_DEBUG_RATE(mvm, "Switched to column %d: Index %d\n",
+		       col_id, rate->index);
+
+	lq_sta->visited_columns |= BIT(col_id);
+	return 0;
+
+err:
+	rate->type = LQ_NONE;
+	return -1;
+}
+
+
 /*
  * Do rate scaling and search for new modulation mode.
  */
@@ -1772,7 +1712,7 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 	if (!rate_scale_index_msk)
 		rate_scale_index_msk = rate_mask;
 
-	if (!((1 << index) & rate_scale_index_msk)) {
+	if (!((BIT(index) & rate_scale_index_msk))) {
 		IWL_ERR(mvm, "Current Rate is not valid\n");
 		if (lq_sta->search_better_tbl) {
 			/* revert to active table if search table is not valid*/
@@ -1852,9 +1792,6 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 				       window->average_tpt,
 				       lq_sta->last_tpt);
 
-			if (!is_legacy(rate))
-				lq_sta->enable_counter = 1;
-
 			/* Swap tables; "search" becomes "active" */
 			lq_sta->active_tbl = active_tbl;
 			current_tpt = window->average_tpt;
@@ -2049,24 +1986,29 @@ lq_update:
 	 * 3)  Allowing a new search
 	 */
 	if (!update_lq && !done_search &&
-	    !lq_sta->stay_in_tbl && window->counter) {
+	    lq_sta->rs_state == RS_STATE_SEARCH_CYCLE_STARTED
+	    && window->counter) {
+		enum rs_column next_column;
+
 		/* Save current throughput to compare with "search" throughput*/
 		lq_sta->last_tpt = current_tpt;
 
 		IWL_DEBUG_RATE(mvm,
-			       "Start Search: update_lq %d done_search %d stay_in_tbl %d win->counter %d\n",
-			       update_lq, done_search, lq_sta->stay_in_tbl,
+			       "Start Search: update_lq %d done_search %d rs_state %d win->counter %d\n",
+			       update_lq, done_search, lq_sta->rs_state,
 			       window->counter);
-		/* Select a new "search" modulation mode to try.
-		 * If one is found, set up the new "search" table. */
-		if (is_legacy(&tbl->rate))
-			rs_move_legacy_other(mvm, lq_sta, sta, index);
-		else if (is_siso(&tbl->rate))
-			rs_move_siso_to_other(mvm, lq_sta, sta, index);
-		else if (is_mimo2(&tbl->rate))
-			rs_move_mimo2_to_other(mvm, lq_sta, sta, index);
-		else
-			WARN_ON_ONCE(1);
+
+		next_column = rs_get_next_column(mvm, lq_sta, sta, tbl);
+		if (next_column != RS_COLUMN_INVALID) {
+			int ret = rs_switch_to_column(mvm, lq_sta, sta,
+						      next_column);
+			if (!ret)
+				lq_sta->search_better_tbl = 1;
+		} else {
+			IWL_DEBUG_RATE(mvm,
+				       "No more columns to explore in search cycle. Go to RS_STATE_SEARCH_CYCLE_ENDED\n");
+			lq_sta->rs_state = RS_STATE_SEARCH_CYCLE_ENDED;
+		}
 
 		/* If new "search" mode was selected, set up in uCode table */
 		if (lq_sta->search_better_tbl) {
@@ -2078,12 +2020,8 @@ lq_update:
 			/* Use new "search" start rate */
 			index = iwl_hwrate_to_plcp_idx(tbl->current_rate);
 
-			IWL_DEBUG_RATE(mvm,
-				       "Switch to SEARCH TABLE: "
-				       "mcs %X (%s: %d)\n",
-				       tbl->current_rate,
-				       rs_pretty_lq_type(tbl->rate.type),
-				       index);
+			rs_dump_rate(mvm, &tbl->rate,
+				     "Switch to SEARCH TABLE:");
 			rs_fill_link_cmd(mvm, sta, lq_sta, tbl->current_rate);
 			iwl_mvm_send_lq_cmd(mvm, &lq_sta->lq, false);
 		} else {
@@ -2091,24 +2029,20 @@ lq_update:
 		}
 	}
 
-	if (done_search && !lq_sta->stay_in_tbl) {
+	if (done_search && lq_sta->rs_state == RS_STATE_SEARCH_CYCLE_ENDED) {
 		/* If the "active" (non-search) mode was legacy,
 		 * and we've tried switching antennas,
 		 * but we haven't been able to try HT modes (not available),
 		 * stay with best antenna legacy modulation for a while
 		 * before next round of mode comparisons. */
 		tbl1 = &(lq_sta->lq_info[lq_sta->active_tbl]);
-		if (is_legacy(&tbl1->rate) && !sta->ht_cap.ht_supported &&
-		    lq_sta->action_counter > tbl1->max_search) {
+		if (is_legacy(&tbl1->rate) && !sta->ht_cap.ht_supported) {
 			IWL_DEBUG_RATE(mvm, "LQ: STAY in legacy table\n");
 			rs_set_stay_in_table(mvm, 1, lq_sta);
-		}
-
+		} else {
 		/* If we're in an HT mode, and all 3 mode switch actions
 		 * have been tried and compared, stay in this best modulation
 		 * mode for a while before next round of mode comparisons. */
-		if (lq_sta->enable_counter &&
-		    (lq_sta->action_counter >= tbl1->max_search)) {
 			if ((lq_sta->last_tpt > IWL_AGG_TPT_THREHOLD) &&
 			    (lq_sta->tx_agg_tid_en & (1 << tid)) &&
 			    (tid != IWL_MAX_TID_COUNT)) {
@@ -2176,19 +2110,24 @@ static void rs_initialize_lq(struct iwl_mvm *mvm,
 	if ((i < 0) || (i >= IWL_RATE_COUNT))
 		i = 0;
 
-	ucode_rate = iwl_rates[i].plcp;
+	rate->index = i;
 	rate->ant = first_antenna(valid_tx_ant);
-	ucode_rate |= rate->ant << RATE_MCS_ANT_POS;
-
-	if (i >= IWL_FIRST_CCK_RATE && i <= IWL_LAST_CCK_RATE)
-		ucode_rate |= RATE_MCS_CCK_MSK;
-
-	rs_rate_from_ucode_rate(ucode_rate, band, rate);
-	if (!rs_is_valid_ant(valid_tx_ant, rate->ant))
-		rs_toggle_antenna(valid_tx_ant, &ucode_rate, rate);
+	rate->sgi = false;
+	rate->bw = RATE_MCS_CHAN_WIDTH_20;
+	if (band == IEEE80211_BAND_5GHZ)
+		rate->type = LQ_LEGACY_A;
+	else
+		rate->type = LQ_LEGACY_G;
 
 	ucode_rate = ucode_rate_from_rs_rate(mvm, rate);
 	tbl->current_rate = ucode_rate;
+
+	WARN_ON_ONCE(rate->ant != ANT_A && rate->ant != ANT_B);
+	if (rate->ant == ANT_A)
+		tbl->column = RS_COLUMN_LEGACY_ANT_A;
+	else
+		tbl->column = RS_COLUMN_LEGACY_ANT_B;
+
 	rs_set_expected_tpt_table(lq_sta, tbl);
 	rs_fill_link_cmd(NULL, NULL, lq_sta, ucode_rate);
 	/* TODO restore station should remember the lq cmd */
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.h b/drivers/net/wireless/iwlwifi/mvm/rs.h
index 8fa26af..b329607 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.h
@@ -157,37 +157,6 @@ enum {
 #define IWL_RATE_INCREASE_TH		6400	/*  50% */
 #define RS_SR_FORCE_DECREASE		1920	/*  15% */
 
-/* possible actions when in legacy mode */
-enum {
-	IWL_LEGACY_SWITCH_ANTENNA,
-	IWL_LEGACY_SWITCH_SISO,
-	IWL_LEGACY_SWITCH_MIMO2,
-	IWL_LEGACY_FIRST_ACTION = IWL_LEGACY_SWITCH_ANTENNA,
-	IWL_LEGACY_LAST_ACTION = IWL_LEGACY_SWITCH_MIMO2,
-};
-
-/* possible actions when in siso mode */
-enum {
-	IWL_SISO_SWITCH_ANTENNA,
-	IWL_SISO_SWITCH_MIMO2,
-	IWL_SISO_SWITCH_GI,
-	IWL_SISO_FIRST_ACTION = IWL_SISO_SWITCH_ANTENNA,
-	IWL_SISO_LAST_ACTION = IWL_SISO_SWITCH_GI,
-};
-
-/* possible actions when in mimo mode */
-enum {
-	IWL_MIMO2_SWITCH_SISO_A,
-	IWL_MIMO2_SWITCH_SISO_B,
-	IWL_MIMO2_SWITCH_GI,
-	IWL_MIMO2_FIRST_ACTION = IWL_MIMO2_SWITCH_SISO_A,
-	IWL_MIMO2_LAST_ACTION = IWL_MIMO2_SWITCH_GI,
-};
-
-#define IWL_MAX_SEARCH IWL_MIMO2_LAST_ACTION
-
-#define IWL_ACTION_LIMIT		3	/* # possible actions */
-
 #define LINK_QUAL_AGG_TIME_LIMIT_DEF	(4000) /* 4 milliseconds */
 #define LINK_QUAL_AGG_TIME_LIMIT_MAX	(8000)
 #define LINK_QUAL_AGG_TIME_LIMIT_MIN	(100)
@@ -282,6 +251,23 @@ struct iwl_rate_scale_data {
 	s32 average_tpt;	/* success ratio * expected throughput */
 };
 
+/* Possible Tx columns
+ * Tx Column = a combo of legacy/siso/mimo x antenna x SGI
+ */
+enum rs_column {
+	RS_COLUMN_LEGACY_ANT_A = 0,
+	RS_COLUMN_LEGACY_ANT_B,
+	RS_COLUMN_SISO_ANT_A,
+	RS_COLUMN_SISO_ANT_B,
+	RS_COLUMN_SISO_ANT_A_SGI,
+	RS_COLUMN_SISO_ANT_B_SGI,
+	RS_COLUMN_MIMO2,
+	RS_COLUMN_MIMO2_SGI,
+
+	RS_COLUMN_LAST = RS_COLUMN_MIMO2_SGI,
+	RS_COLUMN_INVALID,
+};
+
 /**
  * struct iwl_scale_tbl_info -- tx params and success history for all rates
  *
@@ -290,13 +276,18 @@ struct iwl_rate_scale_data {
  */
 struct iwl_scale_tbl_info {
 	struct rs_rate rate;
-	u8 action;	/* change modulation; IWL_[LEGACY/SISO/MIMO]_SWITCH_* */
-	u8 max_search;	/* maximun number of tables we can search */
+	enum rs_column column;
 	s32 *expected_tpt;	/* throughput metrics; expected_tpt_G, etc. */
 	u32 current_rate;  /* rate_n_flags, uCode API format */
 	struct iwl_rate_scale_data win[IWL_RATE_COUNT]; /* rate histories */
 };
 
+enum {
+	RS_STATE_SEARCH_CYCLE_STARTED,
+	RS_STATE_SEARCH_CYCLE_ENDED,
+	RS_STATE_STAY_IN_COLUMN,
+};
+
 /**
  * struct iwl_lq_sta -- driver's rate scaling private structure
  *
@@ -304,8 +295,7 @@ struct iwl_scale_tbl_info {
  */
 struct iwl_lq_sta {
 	u8 active_tbl;		/* index of active table, range 0-1 */
-	u8 enable_counter;	/* indicates HT mode */
-	u8 stay_in_tbl;		/* 1: disallow, 0: allow search for new mode */
+	u8 rs_state;            /* RS_STATE_* */
 	u8 search_better_tbl;	/* 1: currently trying alternate mode */
 	s32 last_tpt;
 
@@ -318,7 +308,9 @@ struct iwl_lq_sta {
 	u32 total_success;	/* total successful frames, any/all rates */
 	u64 flush_timer;	/* time staying in mode before new search */
 
-	u8 action_counter;	/* # mode-switch actions tried */
+	u32 visited_columns;    /* Bitmask marking which Tx columns were
+				 * explored during a search cycle
+				 */
 	bool is_vht;
 	enum ieee80211_band band;
 
-- 
1.7.9.5

