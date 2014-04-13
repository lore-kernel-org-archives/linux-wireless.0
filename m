Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:41755 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052AbaDMTUT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:20:19 -0400
Received: by mail-wi0-f175.google.com with SMTP id cc10so3136113wib.8
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:20:17 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/47] iwlwifi: mvm: add ATPC implementation
Date: Sun, 13 Apr 2014 22:19:20 +0300
Message-Id: <1397416802-32403-5-git-send-email-egrumbach@gmail.com> (sfid-20140413_212029_304860_241D82F4)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Implement Adaptive Tx Power Control algorithm.

ATPC basically tries to decrease the tx power
as much as possible while the throughput is
not being hurt.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/coex.c |  11 ++
 drivers/net/wireless/iwlwifi/mvm/mvm.h  |   2 +
 drivers/net/wireless/iwlwifi/mvm/rs.c   | 211 +++++++++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/mvm/rs.h   |  12 ++
 4 files changed, 233 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index 685f7e8..4bd47c9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -1215,6 +1215,17 @@ bool iwl_mvm_bt_coex_is_mimo_allowed(struct iwl_mvm *mvm,
 	return iwl_get_coex_type(mvm, mvmsta->vif) == BT_COEX_TIGHT_LUT;
 }
 
+bool iwl_mvm_bt_coex_is_tpc_allowed(struct iwl_mvm *mvm,
+				    enum ieee80211_band band)
+{
+	u32 bt_activity = le32_to_cpu(mvm->last_bt_notif.bt_activity_grading);
+
+	if (band != IEEE80211_BAND_2GHZ)
+		return false;
+
+	return bt_activity >= BT_LOW_TRAFFIC;
+}
+
 u8 iwl_mvm_bt_coex_tx_prio(struct iwl_mvm *mvm, struct ieee80211_hdr *hdr,
 			   struct ieee80211_tx_info *info, u8 ac)
 {
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index b032511..5420700 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -936,6 +936,8 @@ u16 iwl_mvm_coex_agg_time_limit(struct iwl_mvm *mvm,
 				struct ieee80211_sta *sta);
 bool iwl_mvm_bt_coex_is_mimo_allowed(struct iwl_mvm *mvm,
 				     struct ieee80211_sta *sta);
+bool iwl_mvm_bt_coex_is_tpc_allowed(struct iwl_mvm *mvm,
+				    enum ieee80211_band band);
 u8 iwl_mvm_bt_coex_tx_prio(struct iwl_mvm *mvm, struct ieee80211_hdr *hdr,
 			   struct ieee80211_tx_info *info, u8 ac);
 int iwl_mvm_bt_coex_reduced_txp(struct iwl_mvm *mvm, u8 sta_id, bool enable);
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 568abd6..fd090bc 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -509,6 +509,9 @@ static void rs_rate_scale_clear_tbl_windows(struct iwl_scale_tbl_info *tbl)
 
 	for (i = 0; i < IWL_RATE_COUNT; i++)
 		rs_rate_scale_clear_window(&tbl->win[i]);
+
+	for (i = 0; i < ARRAY_SIZE(tbl->tpc_win); i++)
+		rs_rate_scale_clear_window(&tbl->tpc_win[i]);
 }
 
 static inline u8 rs_is_valid_ant(u8 valid_antenna, u8 ant_type)
@@ -639,9 +642,11 @@ static int _rs_collect_tx_data(struct iwl_scale_tbl_info *tbl,
 }
 
 static int rs_collect_tx_data(struct iwl_scale_tbl_info *tbl,
-			      int scale_index, int attempts, int successes)
+			      int scale_index, int attempts, int successes,
+			      u8 reduced_txp)
 {
 	struct iwl_rate_scale_data *window = NULL;
+	int ret;
 
 	if (scale_index < 0 || scale_index >= IWL_RATE_COUNT)
 		return -EINVAL;
@@ -649,6 +654,15 @@ static int rs_collect_tx_data(struct iwl_scale_tbl_info *tbl,
 	/* Select window for current tx bit rate */
 	window = &(tbl->win[scale_index]);
 
+	ret = _rs_collect_tx_data(tbl, scale_index, attempts, successes,
+				  window);
+	if (ret)
+		return ret;
+
+	if (WARN_ON_ONCE(reduced_txp > TPC_MAX_REDUCTION))
+		return -EINVAL;
+
+	window = &tbl->tpc_win[reduced_txp];
 	return _rs_collect_tx_data(tbl, scale_index, attempts, successes,
 				   window);
 }
@@ -982,6 +996,7 @@ static void rs_tx_status(void *mvm_r, struct ieee80211_supported_band *sband,
 	u32 ucode_rate;
 	struct rs_rate rate;
 	struct iwl_scale_tbl_info *curr_tbl, *other_tbl, *tmp_tbl;
+	u8 reduced_txp = (uintptr_t)info->status.status_driver_data[0];
 
 	/* Treat uninitialized rate scaling data same as non-existing. */
 	if (!lq_sta) {
@@ -1106,7 +1121,8 @@ static void rs_tx_status(void *mvm_r, struct ieee80211_supported_band *sband,
 		rs_rate_from_ucode_rate(ucode_rate, info->band, &rate);
 		rs_collect_tx_data(curr_tbl, rate.index,
 				   info->status.ampdu_len,
-				   info->status.ampdu_ack_len);
+				   info->status.ampdu_ack_len,
+				   reduced_txp);
 
 		/* Update success/fail counts if not searching for new mode */
 		if (lq_sta->rs_state == RS_STATE_STAY_IN_COLUMN) {
@@ -1140,7 +1156,8 @@ static void rs_tx_status(void *mvm_r, struct ieee80211_supported_band *sband,
 				continue;
 
 			rs_collect_tx_data(tmp_tbl, rate.index, 1,
-					   i < retries ? 0 : legacy_success);
+					   i < retries ? 0 : legacy_success,
+					   reduced_txp);
 		}
 
 		/* Update success/fail counts if not searching for new mode */
@@ -1151,6 +1168,7 @@ static void rs_tx_status(void *mvm_r, struct ieee80211_supported_band *sband,
 	}
 	/* The last TX rate is cached in lq_sta; it's set in if/else above */
 	lq_sta->last_rate_n_flags = ucode_rate;
+	IWL_DEBUG_RATE(mvm, "reduced txpower: %d\n", reduced_txp);
 done:
 	/* See if there's a better rate or modulation mode to try. */
 	if (sta && sta->supp_rates[sband->band])
@@ -1724,6 +1742,189 @@ static enum rs_action rs_get_rate_action(struct iwl_mvm *mvm,
 	return action;
 }
 
+static void rs_get_adjacent_txp(struct iwl_mvm *mvm, int index,
+				int *weaker, int *stronger)
+{
+	*weaker = index + TPC_TX_POWER_STEP;
+	if (*weaker > TPC_MAX_REDUCTION)
+		*weaker = TPC_INVALID;
+
+	*stronger = index - TPC_TX_POWER_STEP;
+	if (*stronger < 0)
+		*stronger = TPC_INVALID;
+}
+
+static bool rs_tpc_allowed(struct iwl_mvm *mvm, struct rs_rate *rate,
+			   enum ieee80211_band band)
+{
+	int index = rate->index;
+
+	/*
+	 * allow tpc only if power management is enabled, or bt coex
+	 * activity grade allows it and we are on 2.4Ghz.
+	 */
+	if (iwlmvm_mod_params.power_scheme == IWL_POWER_SCHEME_CAM &&
+	    !iwl_mvm_bt_coex_is_tpc_allowed(mvm, band))
+		return false;
+
+	IWL_DEBUG_RATE(mvm, "check rate, table type: %d\n", rate->type);
+	if (is_legacy(rate))
+		return index == IWL_RATE_54M_INDEX;
+	if (is_ht(rate))
+		return index == IWL_RATE_MCS_7_INDEX;
+	if (is_vht(rate))
+		return index == IWL_RATE_MCS_7_INDEX ||
+		       index == IWL_RATE_MCS_8_INDEX ||
+		       index == IWL_RATE_MCS_9_INDEX;
+
+	WARN_ON_ONCE(1);
+	return false;
+}
+
+enum tpc_action {
+	TPC_ACTION_STAY,
+	TPC_ACTION_DECREASE,
+	TPC_ACTION_INCREASE,
+	TPC_ACTION_NO_RESTIRCTION,
+};
+
+static enum tpc_action rs_get_tpc_action(struct iwl_mvm *mvm,
+					 s32 sr, int weak, int strong,
+					 int current_tpt,
+					 int weak_tpt, int strong_tpt)
+{
+	/* stay until we have valid tpt */
+	if (current_tpt == IWL_INVALID_VALUE) {
+		IWL_DEBUG_RATE(mvm, "no current tpt. stay.\n");
+		return TPC_ACTION_STAY;
+	}
+
+	/* Too many failures, increase txp */
+	if (sr <= TPC_SR_FORCE_INCREASE || current_tpt == 0) {
+		IWL_DEBUG_RATE(mvm, "increase txp because of weak SR\n");
+		return TPC_ACTION_NO_RESTIRCTION;
+	}
+
+	/* try decreasing first if applicable */
+	if (weak != TPC_INVALID) {
+		if (weak_tpt == IWL_INVALID_VALUE &&
+		    (strong_tpt == IWL_INVALID_VALUE ||
+		     current_tpt >= strong_tpt)) {
+			IWL_DEBUG_RATE(mvm,
+				       "no weak txp measurement. decrease txp\n");
+			return TPC_ACTION_DECREASE;
+		}
+
+		if (weak_tpt > current_tpt) {
+			IWL_DEBUG_RATE(mvm,
+				       "lower txp has better tpt. decrease txp\n");
+			return TPC_ACTION_DECREASE;
+		}
+	}
+
+	/* next, increase if needed */
+	if (sr < TPC_SR_NO_INCREASE && strong != TPC_INVALID) {
+		if (weak_tpt == IWL_INVALID_VALUE &&
+		    strong_tpt != IWL_INVALID_VALUE &&
+		    current_tpt < strong_tpt) {
+			IWL_DEBUG_RATE(mvm,
+				       "higher txp has better tpt. increase txp\n");
+			return TPC_ACTION_INCREASE;
+		}
+
+		if (weak_tpt < current_tpt &&
+		    (strong_tpt == IWL_INVALID_VALUE ||
+		     strong_tpt > current_tpt)) {
+			IWL_DEBUG_RATE(mvm,
+				       "lower txp has worse tpt. increase txp\n");
+			return TPC_ACTION_INCREASE;
+		}
+	}
+
+	IWL_DEBUG_RATE(mvm, "no need to increase or decrease txp - stay\n");
+	return TPC_ACTION_STAY;
+}
+
+static bool rs_tpc_perform(struct iwl_mvm *mvm,
+			   struct ieee80211_sta *sta,
+			   struct iwl_lq_sta *lq_sta,
+			   struct iwl_scale_tbl_info *tbl)
+{
+	struct iwl_mvm_sta *mvm_sta = (void *)sta->drv_priv;
+	struct ieee80211_vif *vif = mvm_sta->vif;
+	struct ieee80211_chanctx_conf *chanctx_conf;
+	enum ieee80211_band band;
+	struct iwl_rate_scale_data *window;
+	struct rs_rate *rate = &tbl->rate;
+	enum tpc_action action;
+	s32 sr;
+	u8 cur = lq_sta->lq.reduced_tpc;
+	int current_tpt;
+	int weak, strong;
+	int weak_tpt = IWL_INVALID_VALUE, strong_tpt = IWL_INVALID_VALUE;
+
+	rcu_read_lock();
+	chanctx_conf = rcu_dereference(vif->chanctx_conf);
+	if (WARN_ON(!chanctx_conf))
+		band = IEEE80211_NUM_BANDS;
+	else
+		band = chanctx_conf->def.chan->band;
+	rcu_read_unlock();
+
+	if (!rs_tpc_allowed(mvm, rate, band)) {
+		IWL_DEBUG_RATE(mvm,
+			       "tpc is not allowed. remove txp restrictions");
+		lq_sta->lq.reduced_tpc = TPC_NO_REDUCTION;
+		return cur != TPC_NO_REDUCTION;
+	}
+
+	rs_get_adjacent_txp(mvm, cur, &weak, &strong);
+
+	/* Collect measured throughputs for current and adjacent rates */
+	window = tbl->tpc_win;
+	sr = window[cur].success_ratio;
+	current_tpt = window[cur].average_tpt;
+	if (weak != TPC_INVALID)
+		weak_tpt = window[weak].average_tpt;
+	if (strong != TPC_INVALID)
+		strong_tpt = window[strong].average_tpt;
+
+	IWL_DEBUG_RATE(mvm,
+		       "(TPC: %d): cur_tpt %d SR %d weak %d strong %d weak_tpt %d strong_tpt %d\n",
+		       cur, current_tpt, sr, weak, strong,
+		       weak_tpt, strong_tpt);
+
+	action = rs_get_tpc_action(mvm, sr, weak, strong,
+				   current_tpt, weak_tpt, strong_tpt);
+
+	/* override actions if we are on the edge */
+	if (weak == TPC_INVALID && action == TPC_ACTION_DECREASE) {
+		IWL_DEBUG_RATE(mvm, "already in lowest txp, stay");
+		action = TPC_ACTION_STAY;
+	} else if (strong == TPC_INVALID &&
+		   (action == TPC_ACTION_INCREASE ||
+		    action == TPC_ACTION_NO_RESTIRCTION)) {
+		IWL_DEBUG_RATE(mvm, "already in highest txp, stay");
+		action = TPC_ACTION_STAY;
+	}
+
+	switch (action) {
+	case TPC_ACTION_DECREASE:
+		lq_sta->lq.reduced_tpc = weak;
+		return true;
+	case TPC_ACTION_INCREASE:
+		lq_sta->lq.reduced_tpc = strong;
+		return true;
+	case TPC_ACTION_NO_RESTIRCTION:
+		lq_sta->lq.reduced_tpc = TPC_NO_REDUCTION;
+		return true;
+	case TPC_ACTION_STAY:
+		/* do nothing */
+		break;
+	}
+	return false;
+}
+
 /*
  * Do rate scaling and search for new modulation mode.
  */
@@ -1973,6 +2174,8 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 		break;
 	case RS_ACTION_STAY:
 		/* No change */
+		update_lq = rs_tpc_perform(mvm, sta, lq_sta, tbl);
+		break;
 	default:
 		break;
 	}
@@ -2584,6 +2787,7 @@ static void rs_fill_lq_cmd(struct iwl_mvm *mvm,
 		rs_build_rates_table_from_fixed(mvm, lq_cmd,
 						lq_sta->band,
 						lq_sta->dbg_fixed_rate);
+		lq_cmd->reduced_tpc = 0;
 		ant = (lq_sta->dbg_fixed_rate & RATE_MCS_ANT_ABC_MSK) >>
 			RATE_MCS_ANT_POS;
 	} else
@@ -2787,6 +2991,7 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 			lq_sta->lq.agg_disable_start_th,
 			lq_sta->lq.agg_frame_cnt_limit);
 
+	desc += sprintf(buff+desc, "reduced tpc=%d\n", lq_sta->lq.reduced_tpc);
 	desc += sprintf(buff+desc,
 			"Start idx [0]=0x%x [1]=0x%x [2]=0x%x [3]=0x%x\n",
 			lq_sta->lq.initial_rate_index[0],
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.h b/drivers/net/wireless/iwlwifi/mvm/rs.h
index 3332b39..d8b0345 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.h
@@ -157,6 +157,13 @@ enum {
 #define IWL_RATE_INCREASE_TH		6400	/*  50% */
 #define RS_SR_FORCE_DECREASE		1920	/*  15% */
 
+#define TPC_SR_FORCE_INCREASE		9600	/* 75% */
+#define TPC_SR_NO_INCREASE		10880	/* 85% */
+#define TPC_TX_POWER_STEP		3
+#define TPC_MAX_REDUCTION		15
+#define TPC_NO_REDUCTION		0
+#define TPC_INVALID			0xff
+
 #define LINK_QUAL_AGG_TIME_LIMIT_DEF	(4000) /* 4 milliseconds */
 #define LINK_QUAL_AGG_TIME_LIMIT_MAX	(8000)
 #define LINK_QUAL_AGG_TIME_LIMIT_MIN	(100)
@@ -279,6 +286,8 @@ struct iwl_scale_tbl_info {
 	enum rs_column column;
 	const u16 *expected_tpt;	/* throughput metrics; expected_tpt_G, etc. */
 	struct iwl_rate_scale_data win[IWL_RATE_COUNT]; /* rate histories */
+	/* per txpower-reduction history */
+	struct iwl_rate_scale_data tpc_win[TPC_MAX_REDUCTION + 1];
 };
 
 enum {
@@ -337,6 +346,9 @@ struct iwl_lq_sta {
 	u32 last_rate_n_flags;
 	/* packets destined for this STA are aggregated */
 	u8 is_agg;
+
+	/* tx power reduce for this sta */
+	int tpc_reduce;
 };
 
 /* Initialize station's rate scaling information after adding station */
-- 
1.8.3.2

