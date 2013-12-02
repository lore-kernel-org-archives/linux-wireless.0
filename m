Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:65525 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814Ab3LBU7k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Dec 2013 15:59:40 -0500
Received: by mail-wg0-f51.google.com with SMTP id b13so9551782wgh.6
        for <linux-wireless@vger.kernel.org>; Mon, 02 Dec 2013 12:59:39 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/13] iwlwifi: mvm: rs: improve debug prints
Date: Mon,  2 Dec 2013 22:59:13 +0200
Message-Id: <1386017965-13641-1-git-send-email-egrumbach@gmail.com> (sfid-20131202_215949_869533_C4249C4D)
In-Reply-To: <529CF2D6.1080008@gmail.com>
References: <529CF2D6.1080008@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Enable better tracking of different decisions made
by the rate scale algorithm.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c |  116 +++++++++++++++++++++++----------
 1 file changed, 83 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index a7efeb3..0655209 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -174,7 +174,7 @@ static void rs_fill_link_cmd(struct iwl_mvm *mvm,
 			     struct ieee80211_sta *sta,
 			     struct iwl_lq_sta *lq_sta, u32 rate_n_flags);
 static void rs_stay_in_table(struct iwl_lq_sta *lq_sta, bool force_search);
-
+static const char *rs_pretty_lq_type(enum iwl_table_type type);
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 static void rs_dbgfs_set_mcs(struct iwl_lq_sta *lq_sta,
@@ -778,9 +778,6 @@ static void rs_tx_status(void *mvm_r, struct ieee80211_supported_band *sband,
 	struct iwl_scale_tbl_info tbl_type;
 	struct iwl_scale_tbl_info *curr_tbl, *other_tbl, *tmp_tbl;
 
-	IWL_DEBUG_RATE_LIMIT(mvm,
-			     "get frame ack response, update rate scale window\n");
-
 	/* Treat uninitialized rate scaling data same as non-existing. */
 	if (!lq_sta) {
 		IWL_DEBUG_RATE(mvm, "Station rate scaling not created yet.\n");
@@ -1499,8 +1496,10 @@ static int rs_move_mimo2_to_other(struct iwl_mvm *mvm,
 	u8 update_search_tbl_counter = 0;
 	int ret;
 
-	if (!iwl_mvm_bt_coex_is_mimo_allowed(mvm, sta))
+	if (!iwl_mvm_bt_coex_is_mimo_allowed(mvm, sta)) {
+		IWL_DEBUG_RATE(mvm, "BT COEX force switch to SISO A\n");
 		tbl->action = IWL_MIMO2_SWITCH_SISO_A;
+	}
 
 	start_action = tbl->action;
 	while (1) {
@@ -1721,8 +1720,6 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 	struct iwl_mvm_sta *sta_priv = (void *)sta->drv_priv;
 	struct iwl_mvm_tid_data *tid_data;
 
-	IWL_DEBUG_RATE(mvm, "rate scale calculate new rate for skb\n");
-
 	/* Send management frames and NO_ACK data using lowest rate. */
 	/* TODO: this could probably be improved.. */
 	if (!ieee80211_is_data(hdr->frame_control) ||
@@ -1758,14 +1755,9 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 	/* current tx rate */
 	index = lq_sta->last_txrate_idx;
 
-	IWL_DEBUG_RATE(mvm, "Rate scale index %d for type %d\n", index,
-		       tbl->lq_type);
-
 	/* rates available for this association, and for modulation mode */
 	rate_mask = rs_get_supported_rates(lq_sta, hdr, tbl->lq_type);
 
-	IWL_DEBUG_RATE(mvm, "mask 0x%04X\n", rate_mask);
-
 	/* mask with station rate restriction */
 	if (is_legacy(tbl->lq_type)) {
 		if (lq_sta->band == IEEE80211_BAND_5GHZ)
@@ -1809,6 +1801,9 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 		index = lq_sta->max_rate_idx;
 		update_lq = 1;
 		window = &(tbl->win[index]);
+		IWL_DEBUG_RATE(mvm,
+			       "Forcing user max rate %d\n",
+			       index);
 		goto lq_update;
 	}
 
@@ -1825,8 +1820,9 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 	if ((fail_count < IWL_RATE_MIN_FAILURE_TH) &&
 	    (window->success_counter < IWL_RATE_MIN_SUCCESS_TH)) {
 		IWL_DEBUG_RATE(mvm,
-			       "LQ: still below TH. succ=%d total=%d for index %d\n",
-			       window->success_counter, window->counter, index);
+			       "(%s: %d): Test Window: succ %d total %d\n",
+			       rs_pretty_lq_type(tbl->lq_type),
+			       index, window->success_counter, window->counter);
 
 		/* Can't calculate this yet; not enough history */
 		window->average_tpt = IWL_INVALID_VALUE;
@@ -1854,7 +1850,8 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 		 * continuing to use the setup that we've been trying. */
 		if (window->average_tpt > lq_sta->last_tpt) {
 			IWL_DEBUG_RATE(mvm,
-				       "LQ: SWITCHING TO NEW TABLE suc=%d cur-tpt=%d old-tpt=%d\n",
+				       "SWITCHING TO NEW TABLE SR: %d "
+				       "cur-tpt %d old-tpt %d\n",
 				       window->success_ratio,
 				       window->average_tpt,
 				       lq_sta->last_tpt);
@@ -1868,7 +1865,8 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 		/* Else poor success; go back to mode in "active" table */
 		} else {
 			IWL_DEBUG_RATE(mvm,
-				       "LQ: GOING BACK TO THE OLD TABLE suc=%d cur-tpt=%d old-tpt=%d\n",
+				       "GOING BACK TO THE OLD TABLE: SR %d "
+				       "cur-tpt %d old-tpt %d\n",
 				       window->success_ratio,
 				       window->average_tpt,
 				       lq_sta->last_tpt);
@@ -1916,20 +1914,31 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 	if (high != IWL_RATE_INVALID)
 		high_tpt = tbl->win[high].average_tpt;
 
+	IWL_DEBUG_RATE(mvm,
+		       "(%s: %d): cur_tpt %d SR %d low %d high %d low_tpt %d high_tpt %d\n",
+		       rs_pretty_lq_type(tbl->lq_type), index, current_tpt,
+		       sr, low, high, low_tpt, high_tpt);
+
 	scale_action = 0;
 
 	/* Too many failures, decrease rate */
 	if ((sr <= IWL_RATE_DECREASE_TH) || (current_tpt == 0)) {
 		IWL_DEBUG_RATE(mvm,
-			       "decrease rate because of low success_ratio\n");
+			       "decrease rate because of low SR\n");
 		scale_action = -1;
 	/* No throughput measured yet for adjacent rates; try increase. */
 	} else if ((low_tpt == IWL_INVALID_VALUE) &&
 		   (high_tpt == IWL_INVALID_VALUE)) {
-		if (high != IWL_RATE_INVALID && sr >= IWL_RATE_INCREASE_TH)
+		if (high != IWL_RATE_INVALID && sr >= IWL_RATE_INCREASE_TH) {
+			IWL_DEBUG_RATE(mvm,
+				       "Good SR and no high rate measurement. "
+				       "Increase rate\n");
 			scale_action = 1;
-		else if (low != IWL_RATE_INVALID)
+		} else if (low != IWL_RATE_INVALID) {
+			IWL_DEBUG_RATE(mvm,
+				       "Remain in current rate\n");
 			scale_action = 0;
+		}
 	}
 
 	/* Both adjacent throughputs are measured, but neither one has better
@@ -1937,8 +1946,12 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 	else if ((low_tpt != IWL_INVALID_VALUE) &&
 		 (high_tpt != IWL_INVALID_VALUE) &&
 		 (low_tpt < current_tpt) &&
-		 (high_tpt < current_tpt))
+		 (high_tpt < current_tpt)) {
+		IWL_DEBUG_RATE(mvm,
+			       "Both high and low are worse. "
+			       "Maintain rate\n");
 		scale_action = 0;
+	}
 
 	/* At least one adjacent rate's throughput is measured,
 	 * and may have better performance. */
@@ -1948,8 +1961,14 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 			/* Higher rate has better throughput */
 			if (high_tpt > current_tpt &&
 			    sr >= IWL_RATE_INCREASE_TH) {
+				IWL_DEBUG_RATE(mvm,
+					       "Higher rate is better and good "
+					       "SR. Increate rate\n");
 				scale_action = 1;
 			} else {
+				IWL_DEBUG_RATE(mvm,
+					       "Higher rate isn't better OR "
+					       "no good SR. Maintain rate\n");
 				scale_action = 0;
 			}
 
@@ -1958,9 +1977,13 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 			/* Lower rate has better throughput */
 			if (low_tpt > current_tpt) {
 				IWL_DEBUG_RATE(mvm,
-					       "decrease rate because of low tpt\n");
+					       "Lower rate is better. "
+					       "Decrease rate\n");
 				scale_action = -1;
 			} else if (sr >= IWL_RATE_INCREASE_TH) {
+				IWL_DEBUG_RATE(mvm,
+					       "Lower rate isn't better and "
+					       "good SR. Increase rate\n");
 				scale_action = 1;
 			}
 		}
@@ -1970,12 +1993,17 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 	 * has been good at old rate.  Don't change it. */
 	if ((scale_action == -1) && (low != IWL_RATE_INVALID) &&
 	    ((sr > IWL_RATE_HIGH_TH) ||
-	     (current_tpt > (100 * tbl->expected_tpt[low]))))
+	     (current_tpt > (100 * tbl->expected_tpt[low])))) {
+		IWL_DEBUG_RATE(mvm,
+			       "Sanity check failed. Maintain rate\n");
 		scale_action = 0;
+	}
 
 	/* Force a search in case BT doesn't like us being in MIMO */
 	if (is_mimo(tbl->lq_type) &&
 	    !iwl_mvm_bt_coex_is_mimo_allowed(mvm, sta)) {
+		IWL_DEBUG_RATE(mvm,
+			       "BT Coex forbids MIMO. Search for new config\n");
 		rs_stay_in_table(lq_sta, true);
 		goto lq_update;
 	}
@@ -1986,6 +2014,9 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 		if (low != IWL_RATE_INVALID) {
 			update_lq = 1;
 			index = low;
+		} else {
+			IWL_DEBUG_RATE(mvm,
+				       "At the bottom rate. Can't decrease\n");
 		}
 
 		break;
@@ -1994,6 +2025,9 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 		if (high != IWL_RATE_INVALID) {
 			update_lq = 1;
 			index = high;
+		} else {
+			IWL_DEBUG_RATE(mvm,
+				       "At the top rate. Can't increase\n");
 		}
 
 		break;
@@ -2003,10 +2037,6 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 		break;
 	}
 
-	IWL_DEBUG_RATE(mvm,
-		       "choose rate scale index %d action %d low %d high %d type %d\n",
-		       index, scale_action, low, high, tbl->lq_type);
-
 lq_update:
 	/* Replace uCode's rate table for the destination station. */
 	if (update_lq)
@@ -2025,6 +2055,10 @@ lq_update:
 		/* Save current throughput to compare with "search" throughput*/
 		lq_sta->last_tpt = current_tpt;
 
+		IWL_DEBUG_RATE(mvm,
+			       "Start Search: update_lq %d done_search %d stay_in_tbl %d win->counter %d\n",
+			       update_lq, done_search, lq_sta->stay_in_tbl,
+			       window->counter);
 		/* Select a new "search" modulation mode to try.
 		 * If one is found, set up the new "search" table. */
 		if (is_legacy(tbl->lq_type))
@@ -2047,8 +2081,11 @@ lq_update:
 			index = iwl_hwrate_to_plcp_idx(tbl->current_rate);
 
 			IWL_DEBUG_RATE(mvm,
-				       "Switch current  mcs: %X index: %d\n",
-				       tbl->current_rate, index);
+				       "Switch to SEARCH TABLE: "
+				       "mcs %X (%s: %d)\n",
+				       tbl->current_rate,
+				       rs_pretty_lq_type(tbl->lq_type),
+				       index);
 			rs_fill_link_cmd(mvm, sta, lq_sta, tbl->current_rate);
 			iwl_mvm_send_lq_cmd(mvm, &lq_sta->lq, false);
 		} else {
@@ -2169,8 +2206,6 @@ static void rs_get_rate(void *mvm_r, struct ieee80211_sta *sta, void *mvm_sta,
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct iwl_lq_sta *lq_sta = mvm_sta;
 
-	IWL_DEBUG_RATE_LIMIT(mvm, "rate scale calculate new rate for skb\n");
-
 	/* Get max rate if user set max rate */
 	if (lq_sta) {
 		lq_sta->max_rate_idx = txrc->max_rate_idx;
@@ -2554,7 +2589,6 @@ static void rs_dbgfs_set_mcs(struct iwl_lq_sta *lq_sta,
 		  >> RATE_MCS_ANT_POS);
 		if ((valid_tx_ant & ant_sel_tx) == ant_sel_tx) {
 			*rate_n_flags = lq_sta->dbg_fixed_rate;
-			IWL_DEBUG_RATE(mvm, "Fixed rate ON\n");
 		} else {
 			lq_sta->dbg_fixed_rate = 0;
 			IWL_ERR(mvm,
@@ -2562,8 +2596,6 @@ static void rs_dbgfs_set_mcs(struct iwl_lq_sta *lq_sta,
 				ant_sel_tx, valid_tx_ant);
 			IWL_DEBUG_RATE(mvm, "Fixed rate OFF\n");
 		}
-	} else {
-		IWL_DEBUG_RATE(mvm, "Fixed rate OFF\n");
 	}
 }
 
@@ -2593,6 +2625,24 @@ static ssize_t rs_sta_dbgfs_scale_table_write(struct file *file,
 	return count;
 }
 
+static const char *rs_pretty_lq_type(enum iwl_table_type type)
+{
+	static const char * const lq_type[] = {
+		[LQ_NONE] = "NONE",
+		[LQ_LEGACY_A] = "LEGACY_A",
+		[LQ_LEGACY_G] = "LEGACY_G",
+		[LQ_HT_SISO] = "HT SISO",
+		[LQ_HT_MIMO2] = "HT MIMO",
+		[LQ_VHT_SISO] = "VHT SISO",
+		[LQ_VHT_MIMO2] = "VHT MIMO",
+	};
+
+	if (type < LQ_NONE || type >= LQ_MAX)
+		return "UNKNOWN";
+
+	return lq_type[type];
+}
+
 static int rs_pretty_print_rate(char *buf, const u32 rate)
 {
 	static const char * const ant_name[] = {
-- 
1.7.9.5

