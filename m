Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50567 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074AbaL3OUi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2014 09:20:38 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 33/33] iwlwifi: mvm: rs: organize and cleanup consts
Date: Tue, 30 Dec 2014 16:19:08 +0200
Message-Id: <1419949148-24046-33-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141230_154348_128631_C197C739)
In-Reply-To: <1419948357.21410.4.camel@egrumbacBox>
References: <1419948357.21410.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Organize and cleanup the consts used by rs.
This is part of making some of these configurable.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/constants.h |  28 +++++++
 drivers/net/wireless/iwlwifi/mvm/rs.c        | 109 +++++++++++++--------------
 drivers/net/wireless/iwlwifi/mvm/rs.h        |  39 ----------
 3 files changed, 79 insertions(+), 97 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/constants.h b/drivers/net/wireless/iwlwifi/mvm/constants.h
index 3bd9347..7cd1de8 100644
--- a/drivers/net/wireless/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/iwlwifi/mvm/constants.h
@@ -102,5 +102,33 @@
 #define IWL_MVM_QUOTA_THRESHOLD			8
 #define IWL_MVM_RS_RSSI_BASED_INIT_RATE         0
 #define IWL_MVM_RS_DISABLE_MIMO			0
+#define IWL_MVM_RS_NUM_TRY_BEFORE_ANT_TOGGLE    1
+#define IWL_MVM_RS_LEGACY_RETRIES_PER_RATE      1
+#define IWL_MVM_RS_HT_VHT_RETRIES_PER_RATE      2
+#define IWL_MVM_RS_HT_VHT_RETRIES_PER_RATE_TW   1
+#define IWL_MVM_RS_INITIAL_MIMO_NUM_RATES       3
+#define IWL_MVM_RS_INITIAL_SISO_NUM_RATES       3
+#define IWL_MVM_RS_INITIAL_LEGACY_NUM_RATES     16
+#define IWL_MVM_RS_SECONDARY_LEGACY_NUM_RATES   16
+#define IWL_MVM_RS_SECONDARY_SISO_NUM_RATES     3
+#define IWL_MVM_RS_SECONDARY_SISO_RETRIES       1
+#define IWL_MVM_RS_RATE_MIN_FAILURE_TH		3
+#define IWL_MVM_RS_RATE_MIN_SUCCESS_TH		8
+#define IWL_MVM_RS_STAY_IN_COLUMN_TIMEOUT	5	/* Seconds */
+#define IWL_MVM_RS_IDLE_TIMEOUT			5	/* Seconds */
+#define IWL_MVM_RS_MISSED_RATE_MAX		15
+#define IWL_MVM_RS_LEGACY_FAILURE_LIMIT		160
+#define IWL_MVM_RS_LEGACY_SUCCESS_LIMIT		480
+#define IWL_MVM_RS_LEGACY_TABLE_COUNT		160
+#define IWL_MVM_RS_NON_LEGACY_FAILURE_LIMIT	400
+#define IWL_MVM_RS_NON_LEGACY_SUCCESS_LIMIT	4500
+#define IWL_MVM_RS_NON_LEGACY_TABLE_COUNT	1500
+#define IWL_MVM_RS_SR_FORCE_DECREASE		15	/* percent */
+#define IWL_MVM_RS_SR_NO_DECREASE		85	/* percent */
+#define IWL_MVM_RS_AGG_TIME_LIMIT	        4000    /* 4 msecs. valid 100-8000 */
+#define IWL_MVM_RS_AGG_DISABLE_START	        3
+#define IWL_MVM_RS_TPC_SR_FORCE_INCREASE	75	/* percent */
+#define IWL_MVM_RS_TPC_SR_NO_INCREASE		85	/* percent */
+#define IWL_MVM_RS_TPC_TX_POWER_STEP		3
 
 #endif /* __MVM_CONSTANTS_H */
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 568829d..7ba6e5d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -42,25 +42,12 @@
 
 #define RS_NAME "iwl-mvm-rs"
 
-#define NUM_TRY_BEFORE_ANT_TOGGLE       1
-#define RS_LEGACY_RETRIES_PER_RATE      1
-#define RS_HT_VHT_RETRIES_PER_RATE      2
-#define RS_HT_VHT_RETRIES_PER_RATE_TW   1
-#define RS_INITIAL_MIMO_NUM_RATES       3
-#define RS_INITIAL_SISO_NUM_RATES       3
-#define RS_INITIAL_LEGACY_NUM_RATES     LINK_QUAL_MAX_RETRY_NUM
-#define RS_SECONDARY_LEGACY_NUM_RATES   LINK_QUAL_MAX_RETRY_NUM
-#define RS_SECONDARY_SISO_NUM_RATES     3
-#define RS_SECONDARY_SISO_RETRIES       1
-
 #define IWL_RATE_MAX_WINDOW		62	/* # tx in history window */
-#define IWL_RATE_MIN_FAILURE_TH		3	/* min failures to calc tpt */
-#define IWL_RATE_MIN_SUCCESS_TH		8	/* min successes to calc tpt */
 
-/* max allowed rate miss before sync LQ cmd */
-#define IWL_MISSED_RATE_MAX		15
-#define RS_STAY_IN_COLUMN_TIMEOUT       (5*HZ)
-#define RS_IDLE_TIMEOUT                 (5*HZ)
+/* Calculations of success ratio are done in fixed point where 12800 is 100%.
+ * Use this macro when dealing with thresholds consts set as a percentage
+ */
+#define RS_PERCENT(x) (128 * x)
 
 static u8 rs_ht_to_legacy[] = {
 	[IWL_RATE_MCS_0_INDEX] = IWL_RATE_6M_INDEX,
@@ -613,7 +600,8 @@ static s32 get_expected_tpt(struct iwl_scale_tbl_info *tbl, int rs_index)
  * at this rate.  window->data contains the bitmask of successful
  * packets.
  */
-static int _rs_collect_tx_data(struct iwl_scale_tbl_info *tbl,
+static int _rs_collect_tx_data(struct iwl_mvm *mvm,
+			       struct iwl_scale_tbl_info *tbl,
 			       int scale_index, int attempts, int successes,
 			       struct iwl_rate_scale_data *window)
 {
@@ -668,8 +656,8 @@ static int _rs_collect_tx_data(struct iwl_scale_tbl_info *tbl,
 	fail_count = window->counter - window->success_counter;
 
 	/* Calculate average throughput, if we have enough history. */
-	if ((fail_count >= IWL_RATE_MIN_FAILURE_TH) ||
-	    (window->success_counter >= IWL_RATE_MIN_SUCCESS_TH))
+	if ((fail_count >= IWL_MVM_RS_RATE_MIN_FAILURE_TH) ||
+	    (window->success_counter >= IWL_MVM_RS_RATE_MIN_SUCCESS_TH))
 		window->average_tpt = (window->success_ratio * tpt + 64) / 128;
 	else
 		window->average_tpt = IWL_INVALID_VALUE;
@@ -677,7 +665,8 @@ static int _rs_collect_tx_data(struct iwl_scale_tbl_info *tbl,
 	return 0;
 }
 
-static int rs_collect_tx_data(struct iwl_lq_sta *lq_sta,
+static int rs_collect_tx_data(struct iwl_mvm *mvm,
+			      struct iwl_lq_sta *lq_sta,
 			      struct iwl_scale_tbl_info *tbl,
 			      int scale_index, int attempts, int successes,
 			      u8 reduced_txp)
@@ -698,7 +687,7 @@ static int rs_collect_tx_data(struct iwl_lq_sta *lq_sta,
 	/* Select window for current tx bit rate */
 	window = &(tbl->win[scale_index]);
 
-	ret = _rs_collect_tx_data(tbl, scale_index, attempts, successes,
+	ret = _rs_collect_tx_data(mvm, tbl, scale_index, attempts, successes,
 				  window);
 	if (ret)
 		return ret;
@@ -707,7 +696,7 @@ static int rs_collect_tx_data(struct iwl_lq_sta *lq_sta,
 		return -EINVAL;
 
 	window = &tbl->tpc_win[reduced_txp];
-	return _rs_collect_tx_data(tbl, scale_index, attempts, successes,
+	return _rs_collect_tx_data(mvm, tbl, scale_index, attempts, successes,
 				   window);
 }
 
@@ -1125,7 +1114,8 @@ void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	}
 
 	if (time_after(jiffies,
-		       (unsigned long)(lq_sta->last_tx + RS_IDLE_TIMEOUT))) {
+		       (unsigned long)(lq_sta->last_tx +
+				       (IWL_MVM_RS_IDLE_TIMEOUT * HZ)))) {
 		int t;
 
 		IWL_DEBUG_RATE(mvm, "Tx idle for too long. reinit rs\n");
@@ -1158,7 +1148,7 @@ void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		 * ... driver.
 		 */
 		lq_sta->missed_rate_counter++;
-		if (lq_sta->missed_rate_counter > IWL_MISSED_RATE_MAX) {
+		if (lq_sta->missed_rate_counter > IWL_MVM_RS_MISSED_RATE_MAX) {
 			lq_sta->missed_rate_counter = 0;
 			IWL_DEBUG_RATE(mvm,
 				       "Too many rates mismatch. Send sync LQ. rs_state %d\n",
@@ -1213,7 +1203,7 @@ void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 
 		ucode_rate = le32_to_cpu(table->rs_table[0]);
 		rs_rate_from_ucode_rate(ucode_rate, info->band, &rate);
-		rs_collect_tx_data(lq_sta, curr_tbl, rate.index,
+		rs_collect_tx_data(mvm, lq_sta, curr_tbl, rate.index,
 				   info->status.ampdu_len,
 				   info->status.ampdu_ack_len,
 				   reduced_txp);
@@ -1249,7 +1239,7 @@ void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 			else
 				continue;
 
-			rs_collect_tx_data(lq_sta, tmp_tbl, rate.index, 1,
+			rs_collect_tx_data(mvm, lq_sta, tmp_tbl, rate.index, 1,
 					   i < retries ? 0 : legacy_success,
 					   reduced_txp);
 		}
@@ -1303,13 +1293,13 @@ static void rs_set_stay_in_table(struct iwl_mvm *mvm, u8 is_legacy,
 	IWL_DEBUG_RATE(mvm, "Moving to RS_STATE_STAY_IN_COLUMN\n");
 	lq_sta->rs_state = RS_STATE_STAY_IN_COLUMN;
 	if (is_legacy) {
-		lq_sta->table_count_limit = IWL_LEGACY_TABLE_COUNT;
-		lq_sta->max_failure_limit = IWL_LEGACY_FAILURE_LIMIT;
-		lq_sta->max_success_limit = IWL_LEGACY_SUCCESS_LIMIT;
+		lq_sta->table_count_limit = IWL_MVM_RS_LEGACY_TABLE_COUNT;
+		lq_sta->max_failure_limit = IWL_MVM_RS_LEGACY_FAILURE_LIMIT;
+		lq_sta->max_success_limit = IWL_MVM_RS_LEGACY_SUCCESS_LIMIT;
 	} else {
-		lq_sta->table_count_limit = IWL_NONE_LEGACY_TABLE_COUNT;
-		lq_sta->max_failure_limit = IWL_NONE_LEGACY_FAILURE_LIMIT;
-		lq_sta->max_success_limit = IWL_NONE_LEGACY_SUCCESS_LIMIT;
+		lq_sta->table_count_limit = IWL_MVM_RS_NON_LEGACY_TABLE_COUNT;
+		lq_sta->max_failure_limit = IWL_MVM_RS_NON_LEGACY_FAILURE_LIMIT;
+		lq_sta->max_success_limit = IWL_MVM_RS_NON_LEGACY_SUCCESS_LIMIT;
 	}
 	lq_sta->table_count = 0;
 	lq_sta->total_failed = 0;
@@ -1427,7 +1417,7 @@ static s32 rs_get_best_rate(struct iwl_mvm *mvm,
 	u32 target_tpt;
 	int rate_idx;
 
-	if (success_ratio > RS_SR_NO_DECREASE) {
+	if (success_ratio > IWL_MVM_RS_SR_NO_DECREASE) {
 		target_tpt = 100 * expected_current_tpt;
 		IWL_DEBUG_RATE(mvm,
 			       "SR %d high. Find rate exceeding EXPECTED_CURRENT %d\n",
@@ -1495,7 +1485,7 @@ static void rs_stay_in_table(struct iwl_lq_sta *lq_sta, bool force_search)
 			flush_interval_passed =
 				time_after(jiffies,
 					   (unsigned long)(lq_sta->flush_timer +
-						RS_STAY_IN_COLUMN_TIMEOUT));
+							   (IWL_MVM_RS_STAY_IN_COLUMN_TIMEOUT * HZ)));
 
 		/*
 		 * Check if we should allow search for new modulation mode.
@@ -1735,7 +1725,8 @@ static enum rs_action rs_get_rate_action(struct iwl_mvm *mvm,
 {
 	enum rs_action action = RS_ACTION_STAY;
 
-	if ((sr <= RS_SR_FORCE_DECREASE) || (current_tpt == 0)) {
+	if ((sr <= RS_PERCENT(IWL_MVM_RS_SR_FORCE_DECREASE)) ||
+	    (current_tpt == 0)) {
 		IWL_DEBUG_RATE(mvm,
 			       "Decrease rate because of low SR\n");
 		return RS_ACTION_DOWNSCALE;
@@ -1794,7 +1785,7 @@ static enum rs_action rs_get_rate_action(struct iwl_mvm *mvm,
 
 out:
 	if ((action == RS_ACTION_DOWNSCALE) && (low != IWL_RATE_INVALID)) {
-		if (sr >= RS_SR_NO_DECREASE) {
+		if (sr >= RS_PERCENT(IWL_MVM_RS_SR_NO_DECREASE)) {
 			IWL_DEBUG_RATE(mvm,
 				       "SR is above NO DECREASE. Avoid downscale\n");
 			action = RS_ACTION_STAY;
@@ -1836,11 +1827,11 @@ static bool rs_stbc_allow(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 static void rs_get_adjacent_txp(struct iwl_mvm *mvm, int index,
 				int *weaker, int *stronger)
 {
-	*weaker = index + TPC_TX_POWER_STEP;
+	*weaker = index + IWL_MVM_RS_TPC_TX_POWER_STEP;
 	if (*weaker > TPC_MAX_REDUCTION)
 		*weaker = TPC_INVALID;
 
-	*stronger = index - TPC_TX_POWER_STEP;
+	*stronger = index - IWL_MVM_RS_TPC_TX_POWER_STEP;
 	if (*stronger < 0)
 		*stronger = TPC_INVALID;
 }
@@ -1896,7 +1887,8 @@ static enum tpc_action rs_get_tpc_action(struct iwl_mvm *mvm,
 	}
 
 	/* Too many failures, increase txp */
-	if (sr <= TPC_SR_FORCE_INCREASE || current_tpt == 0) {
+	if (sr <= RS_PERCENT(IWL_MVM_RS_TPC_SR_FORCE_INCREASE) ||
+	    current_tpt == 0) {
 		IWL_DEBUG_RATE(mvm, "increase txp because of weak SR\n");
 		return TPC_ACTION_NO_RESTIRCTION;
 	}
@@ -1919,7 +1911,8 @@ static enum tpc_action rs_get_tpc_action(struct iwl_mvm *mvm,
 	}
 
 	/* next, increase if needed */
-	if (sr < TPC_SR_NO_INCREASE && strong != TPC_INVALID) {
+	if (sr < RS_PERCENT(IWL_MVM_RS_TPC_SR_NO_INCREASE) &&
+	    strong != TPC_INVALID) {
 		if (weak_tpt == IWL_INVALID_VALUE &&
 		    strong_tpt != IWL_INVALID_VALUE &&
 		    current_tpt < strong_tpt) {
@@ -2117,8 +2110,8 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 	 * in current association (use new rate found above).
 	 */
 	fail_count = window->counter - window->success_counter;
-	if ((fail_count < IWL_RATE_MIN_FAILURE_TH) &&
-	    (window->success_counter < IWL_RATE_MIN_SUCCESS_TH)) {
+	if ((fail_count < IWL_MVM_RS_RATE_MIN_FAILURE_TH) &&
+	    (window->success_counter < IWL_MVM_RS_RATE_MIN_SUCCESS_TH)) {
 		IWL_DEBUG_RATE(mvm,
 			       "(%s: %d): Test Window: succ %d total %d\n",
 			       rs_pretty_lq_type(rate->type),
@@ -2720,7 +2713,7 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	 * previous packets? Need to have IEEE 802.1X auth succeed immediately
 	 * after assoc.. */
 
-	lq_sta->missed_rate_counter = IWL_MISSED_RATE_MAX;
+	lq_sta->missed_rate_counter = IWL_MVM_RS_MISSED_RATE_MAX;
 	lq_sta->band = sband->band;
 	/*
 	 * active legacy rates as per supported rates bitmap
@@ -2925,14 +2918,14 @@ static void rs_build_rates_table(struct iwl_mvm *mvm,
 	rate.stbc = rs_stbc_allow(mvm, sta, lq_sta);
 
 	if (is_siso(&rate)) {
-		num_rates = RS_INITIAL_SISO_NUM_RATES;
-		num_retries = RS_HT_VHT_RETRIES_PER_RATE;
+		num_rates = IWL_MVM_RS_INITIAL_SISO_NUM_RATES;
+		num_retries = IWL_MVM_RS_HT_VHT_RETRIES_PER_RATE;
 	} else if (is_mimo(&rate)) {
-		num_rates = RS_INITIAL_MIMO_NUM_RATES;
-		num_retries = RS_HT_VHT_RETRIES_PER_RATE;
+		num_rates = IWL_MVM_RS_INITIAL_MIMO_NUM_RATES;
+		num_retries = IWL_MVM_RS_HT_VHT_RETRIES_PER_RATE;
 	} else {
-		num_rates = RS_INITIAL_LEGACY_NUM_RATES;
-		num_retries = RS_LEGACY_RETRIES_PER_RATE;
+		num_rates = IWL_MVM_RS_INITIAL_LEGACY_NUM_RATES;
+		num_retries = IWL_MVM_RS_LEGACY_RETRIES_PER_RATE;
 		toggle_ant = true;
 	}
 
@@ -2943,12 +2936,12 @@ static void rs_build_rates_table(struct iwl_mvm *mvm,
 	rs_get_lower_rate_down_column(lq_sta, &rate);
 
 	if (is_siso(&rate)) {
-		num_rates = RS_SECONDARY_SISO_NUM_RATES;
-		num_retries = RS_SECONDARY_SISO_RETRIES;
+		num_rates = IWL_MVM_RS_SECONDARY_SISO_NUM_RATES;
+		num_retries = IWL_MVM_RS_SECONDARY_SISO_RETRIES;
 		lq_cmd->mimo_delim = index;
 	} else if (is_legacy(&rate)) {
-		num_rates = RS_SECONDARY_LEGACY_NUM_RATES;
-		num_retries = RS_LEGACY_RETRIES_PER_RATE;
+		num_rates = IWL_MVM_RS_SECONDARY_LEGACY_NUM_RATES;
+		num_retries = IWL_MVM_RS_LEGACY_RETRIES_PER_RATE;
 	} else {
 		WARN_ON_ONCE(1);
 	}
@@ -2961,8 +2954,8 @@ static void rs_build_rates_table(struct iwl_mvm *mvm,
 
 	rs_get_lower_rate_down_column(lq_sta, &rate);
 
-	num_rates = RS_SECONDARY_LEGACY_NUM_RATES;
-	num_retries = RS_LEGACY_RETRIES_PER_RATE;
+	num_rates = IWL_MVM_RS_SECONDARY_LEGACY_NUM_RATES;
+	num_retries = IWL_MVM_RS_LEGACY_RETRIES_PER_RATE;
 
 	rs_fill_rates_for_column(mvm, lq_sta, &rate, lq_cmd->rs_table, &index,
 				 num_rates, num_retries, valid_tx_ant,
@@ -2979,9 +2972,9 @@ static void rs_fill_lq_cmd(struct iwl_mvm *mvm,
 	struct iwl_mvm_sta *mvmsta;
 	struct iwl_mvm_vif *mvmvif;
 
-	lq_cmd->agg_disable_start_th = LINK_QUAL_AGG_DISABLE_START_DEF;
+	lq_cmd->agg_disable_start_th = IWL_MVM_RS_AGG_DISABLE_START;
 	lq_cmd->agg_time_limit =
-		cpu_to_le16(LINK_QUAL_AGG_TIME_LIMIT_DEF);
+		cpu_to_le16(IWL_MVM_RS_AGG_TIME_LIMIT);
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 	if (lq_sta->pers.dbg_fixed_rate) {
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.h b/drivers/net/wireless/iwlwifi/mvm/rs.h
index defd70a..f8f5bf2 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.h
@@ -137,42 +137,10 @@ enum {
 
 #define IWL_INVALID_VALUE    -1
 
-#define IWL_MIN_RSSI_VAL                 -100
-#define IWL_MAX_RSSI_VAL                    0
-
-/* These values specify how many Tx frame attempts before
- * searching for a new modulation mode */
-#define IWL_LEGACY_FAILURE_LIMIT	160
-#define IWL_LEGACY_SUCCESS_LIMIT	480
-#define IWL_LEGACY_TABLE_COUNT		160
-
-#define IWL_NONE_LEGACY_FAILURE_LIMIT	400
-#define IWL_NONE_LEGACY_SUCCESS_LIMIT	4500
-#define IWL_NONE_LEGACY_TABLE_COUNT	1500
-
-/* Success ratio (ACKed / attempted tx frames) values (perfect is 128 * 100) */
-#define IWL_RS_GOOD_RATIO		12800	/* 100% */
-#define IWL_RATE_SCALE_SWITCH		10880	/*  85% */
-#define IWL_RATE_HIGH_TH		10880	/*  85% */
-#define IWL_RATE_INCREASE_TH		6400	/*  50% */
-#define RS_SR_FORCE_DECREASE		1920	/*  15% */
-#define RS_SR_NO_DECREASE		10880	/*  85% */
-
-#define TPC_SR_FORCE_INCREASE		9600	/* 75% */
-#define TPC_SR_NO_INCREASE		10880	/* 85% */
-#define TPC_TX_POWER_STEP		3
 #define TPC_MAX_REDUCTION		15
 #define TPC_NO_REDUCTION		0
 #define TPC_INVALID			0xff
 
-#define LINK_QUAL_AGG_TIME_LIMIT_DEF	(4000) /* 4 milliseconds */
-#define LINK_QUAL_AGG_TIME_LIMIT_MAX	(8000)
-#define LINK_QUAL_AGG_TIME_LIMIT_MIN	(100)
-
-#define LINK_QUAL_AGG_DISABLE_START_DEF	(3)
-#define LINK_QUAL_AGG_DISABLE_START_MAX	(255)
-#define LINK_QUAL_AGG_DISABLE_START_MIN	(0)
-
 #define LINK_QUAL_AGG_FRAME_LIMIT_DEF	(63)
 #define LINK_QUAL_AGG_FRAME_LIMIT_MAX	(63)
 #define LINK_QUAL_AGG_FRAME_LIMIT_MIN	(0)
@@ -181,14 +149,7 @@ enum {
 
 /* load per tid defines for A-MPDU activation */
 #define IWL_AGG_TPT_THREHOLD	0
-#define IWL_AGG_LOAD_THRESHOLD	10
 #define IWL_AGG_ALL_TID		0xff
-#define TID_QUEUE_CELL_SPACING	50	/*mS */
-#define TID_QUEUE_MAX_SIZE	20
-#define TID_ROUND_VALUE		5	/* mS */
-
-#define TID_MAX_TIME_DIFF ((TID_QUEUE_MAX_SIZE - 1) * TID_QUEUE_CELL_SPACING)
-#define TIME_WRAP_AROUND(x, y) (((y) > (x)) ? (y) - (x) : (0-(x)) + (y))
 
 enum iwl_table_type {
 	LQ_NONE,
-- 
1.9.1

