Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31331 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753433AbXLCLpg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2007 06:45:36 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, yi.zhu@intel.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ben Cahill <ben.m.cahill@intel.com>
Subject: [PATCH 04/34] iwl4965: add comments to rate scaling code
Date: Mon,  3 Dec 2007 13:43:16 +0200
Message-Id: <11966822291956-git-send-email-tomas.winkler@intel.com> (sfid-20071203_120552_868273_5A83BFA4)
In-Reply-To: <11966822293932-git-send-email-tomas.winkler@intel.com>
References: <11966822261109-git-send-email-tomas.winkler@intel.com>
 <11966822291406-git-send-email-tomas.winkler@intel.com>
 <1196682229843-git-send-email-tomas.winkler@intel.com>
 <11966822293932-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Add comments to rate scaling code.

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c  |  468 +++++++++++++++++++++++----
 drivers/net/wireless/iwlwifi/iwl-4965-rs.h  |   45 ++-
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    3 +
 4 files changed, 443 insertions(+), 75 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index 6a835e8..d0953bd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -47,13 +47,12 @@
 #define IWL_NUMBER_TRY      1
 #define IWL_HT_NUMBER_TRY   3
 
-#define IWL_RATE_MAX_WINDOW		62
-#define IWL_RATE_HIGH_TH		10880
-#define IWL_RATE_MIN_FAILURE_TH		6
-#define IWL_RATE_MIN_SUCCESS_TH		8
-#define IWL_RATE_DECREASE_TH		1920
-#define IWL_RATE_INCREASE_TH            8960
-#define IWL_RATE_SCALE_FLUSH_INTVL   (2*HZ)        /*2 seconds */
+#define IWL_RATE_MAX_WINDOW		62	/* # tx in history window */
+#define IWL_RATE_MIN_FAILURE_TH		6	/* min failures to calc tpt */
+#define IWL_RATE_MIN_SUCCESS_TH		8	/* min successes to calc tpt */
+
+/* max time to accum history 2 seconds */
+#define IWL_RATE_SCALE_FLUSH_INTVL   (2*HZ)
 
 static u8 rs_ht_to_legacy[] = {
 	IWL_RATE_6M_INDEX, IWL_RATE_6M_INDEX,
@@ -69,54 +68,74 @@ struct iwl4965_rate {
 	u32 rate_n_flags;
 } __attribute__ ((packed));
 
+/**
+ * struct iwl4965_rate_scale_data -- tx success history for one rate
+ */
 struct iwl4965_rate_scale_data {
-	u64 data;
-	s32 success_counter;
-	s32 success_ratio;
-	s32 counter;
-	s32 average_tpt;
+	u64 data;		/* bitmap of successful frames */
+	s32 success_counter;	/* number of frames successful */
+	s32 success_ratio;	/* per-cent * 128  */
+	s32 counter;		/* number of frames attempted */
+	s32 average_tpt;	/* success ratio * expected throughput */
 	unsigned long stamp;
 };
 
+/**
+ * struct iwl4965_scale_tbl_info -- tx params and success history for all rates
+ *
+ * There are two of these in struct iwl_rate_scale_priv,
+ * one for "active", and one for "search".
+ */
 struct iwl4965_scale_tbl_info {
 	enum iwl4965_table_type lq_type;
 	enum iwl4965_antenna_type antenna_type;
-	u8 is_SGI;
-	u8 is_fat;
-	u8 is_dup;
-	u8 action;
-	s32 *expected_tpt;
-	struct iwl4965_rate current_rate;
-	struct iwl4965_rate_scale_data win[IWL_RATE_COUNT];
+	u8 is_SGI;	/* 1 = short guard interval */
+	u8 is_fat;	/* 1 = 40 MHz channel width */
+	u8 is_dup;	/* 1 = duplicated data streams */
+	u8 action;	/* change modulation; IWL_[LEGACY/SISO/MIMO]_SWITCH_* */
+	s32 *expected_tpt;	/* throughput metrics; expected_tpt_G, etc. */
+	struct iwl4965_rate current_rate;  /* rate_n_flags, uCode API format */
+	struct iwl4965_rate_scale_data win[IWL_RATE_COUNT]; /* rate histories */
 };
 
+/**
+ * struct iwl_rate_scale_priv -- driver's rate scaling private structure
+ *
+ * Pointer to this gets passed back and forth between driver and mac80211.
+ */
 struct iwl4965_rate_scale_priv {
-	u8 active_tbl;
-	u8 enable_counter;
-	u8 stay_in_tbl;
-	u8 search_better_tbl;
+	u8 active_tbl;		/* index of active table, range 0-1 */
+	u8 enable_counter;	/* indicates HT mode */
+	u8 stay_in_tbl;		/* 1: disallow, 0: allow search for new mode */
+	u8 search_better_tbl;	/* 1: currently trying alternate mode */
 	s32 last_tpt;
+
+	/* The following determine when to search for a new mode */
 	u32 table_count_limit;
-	u32 max_failure_limit;
-	u32 max_success_limit;
+	u32 max_failure_limit;	/* # failed frames before new search */
+	u32 max_success_limit;	/* # successful frames before new search */
 	u32 table_count;
-	u32 total_failed;
-	u32 total_success;
-	u32 flush_timer;
-	u8 action_counter;
+	u32 total_failed;	/* total failed frames, any/all rates */
+	u32 total_success;	/* total successful frames, any/all rates */
+	u32 flush_timer;	/* time staying in mode before new search */
+
+	u8 action_counter;	/* # mode-switch actions tried */
 	u8 antenna;
 	u8 valid_antenna;
 	u8 is_green;
 	u8 is_dup;
 	u8 phymode;
 	u8 ibss_sta_added;
+
+	/* The following are bitmaps of rates; IWL_RATE_6M_MASK, etc. */
 	u32 supp_rates;
 	u16 active_rate;
 	u16 active_siso_rate;
 	u16 active_mimo_rate;
 	u16 active_rate_basic;
+
 	struct iwl4965_link_quality_cmd lq;
-	struct iwl4965_scale_tbl_info lq_info[LQ_SIZE];
+	struct iwl4965_scale_tbl_info lq_info[LQ_SIZE]; /* "active", "search" */
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct dentry *rs_sta_dbgfs_scale_table_file;
 	struct dentry *rs_sta_dbgfs_stats_table_file;
@@ -142,6 +161,12 @@ static void rs_dbgfs_set_mcs(struct iwl4965_rate_scale_priv *rs_priv,
 				struct iwl4965_rate *mcs, int index)
 {}
 #endif
+
+/*
+ * Expected throughput metrics for following rates:
+ * 1, 2, 5.5, 11, 6, 9, 12, 18, 24, 36, 48, 54, 60 MBits
+ * "G" is the only table that supports CCK (the first 4 rates).
+ */
 static s32 expected_tpt_A[IWL_RATE_COUNT] = {
 	0, 0, 0, 0, 40, 57, 72, 98, 121, 154, 177, 186, 186
 };
@@ -244,6 +269,13 @@ static void rs_rate_scale_clear_window(struct iwl4965_rate_scale_data *window)
 	window->stamp = 0;
 }
 
+/**
+ * rs_collect_tx_data - Update the success/failure sliding window
+ *
+ * We keep a sliding window of the last 62 packets transmitted
+ * at this rate.  window->data contains the bitmask of successful
+ * packets.
+ */
 static int rs_collect_tx_data(struct iwl4965_rate_scale_data *windows,
 			      int scale_index, s32 tpt, u32 status)
 {
@@ -255,10 +287,18 @@ static int rs_collect_tx_data(struct iwl4965_rate_scale_data *windows,
 	if (scale_index < 0 || scale_index >= IWL_RATE_COUNT)
 		return -EINVAL;
 
+	/* Select data for current tx bit rate */
 	window = &(windows[scale_index]);
 
+	/*
+	 * Keep track of only the latest 62 tx frame attempts in this rate's
+	 * history window; anything older isn't really relevant any more.
+	 * If we have filled up the sliding window, drop the oldest attempt;
+	 * if the oldest attempt (highest bit in bitmap) shows "success",
+	 * subtract "1" from the success counter (this is the main reason
+	 * we keep these bitmaps!).
+	 */
 	if (window->counter >= win_size) {
-
 		window->counter = win_size - 1;
 		mask = 1;
 		mask = (mask << (win_size - 1));
@@ -268,7 +308,11 @@ static int rs_collect_tx_data(struct iwl4965_rate_scale_data *windows,
 		}
 	}
 
+	/* Increment frames-attempted counter */
 	window->counter = window->counter + 1;
+
+	/* Shift bitmap by one frame (throw away oldest history),
+	 * OR in "1", and increment "success" if this frame was successful. */
 	mask = window->data;
 	window->data = (mask << 1);
 	if (status != 0) {
@@ -276,6 +320,7 @@ static int rs_collect_tx_data(struct iwl4965_rate_scale_data *windows,
 		window->data |= 0x1;
 	}
 
+	/* Calculate current success ratio, avoid divide-by-0! */
 	if (window->counter > 0)
 		window->success_ratio = 128 * (100 * window->success_counter)
 					/ window->counter;
@@ -284,17 +329,22 @@ static int rs_collect_tx_data(struct iwl4965_rate_scale_data *windows,
 
 	fail_count = window->counter - window->success_counter;
 
+	/* Calculate average throughput, if we have enough history. */
 	if ((fail_count >= IWL_RATE_MIN_FAILURE_TH) ||
 	    (window->success_counter >= IWL_RATE_MIN_SUCCESS_TH))
 		window->average_tpt = (window->success_ratio * tpt + 64) / 128;
 	else
 		window->average_tpt = IWL_INVALID_VALUE;
 
+	/* Tag this window as having been updated */
 	window->stamp = jiffies;
 
 	return 0;
 }
 
+/*
+ * Fill uCode API rate_n_flags field, based on "search" or "active" table.
+ */
 static void rs_mcs_from_tbl(struct iwl4965_rate *mcs_rate,
 			   struct iwl4965_scale_tbl_info *tbl,
 			   int index, u8 use_green)
@@ -349,6 +399,10 @@ static void rs_mcs_from_tbl(struct iwl4965_rate *mcs_rate,
 	}
 }
 
+/*
+ * Interpret uCode API's rate_n_flags format,
+ * fill "search" or "active" tx mode table.
+ */
 static int rs_get_tbl_info_from_mcs(const struct iwl4965_rate *mcs_rate,
 				    int phymode, struct iwl4965_scale_tbl_info *tbl,
 				    int *rate_idx)
@@ -362,11 +416,12 @@ static int rs_get_tbl_info_from_mcs(const struct iwl4965_rate *mcs_rate,
 		*rate_idx = -1;
 		return -EINVAL;
 	}
-	tbl->is_SGI = 0;
+	tbl->is_SGI = 0;	/* default legacy setup */
 	tbl->is_fat = 0;
 	tbl->is_dup = 0;
-	tbl->antenna_type = ANT_BOTH;
+	tbl->antenna_type = ANT_BOTH;	/* default MIMO setup */
 
+	/* legacy rate format */
 	if (!(mcs_rate->rate_n_flags & RATE_MCS_HT_MSK)) {
 		ant_msk = (mcs_rate->rate_n_flags & RATE_MCS_ANT_AB_MSK);
 
@@ -386,6 +441,7 @@ static int rs_get_tbl_info_from_mcs(const struct iwl4965_rate *mcs_rate,
 		}
 		*rate_idx = index;
 
+	/* HT rate format, SISO (might be 20 MHz legacy or 40 MHz fat width) */
 	} else if (iwl4965_rate_get_rate(mcs_rate->rate_n_flags)
 					<= IWL_RATE_SISO_60M_PLCP) {
 		tbl->lq_type = LQ_SISO;
@@ -410,6 +466,8 @@ static int rs_get_tbl_info_from_mcs(const struct iwl4965_rate *mcs_rate,
 			tbl->is_dup = 1;
 
 		*rate_idx = index;
+
+	/* HT rate format, MIMO (might be 20 MHz legacy or 40 MHz fat width) */
 	} else {
 		tbl->lq_type = LQ_MIMO;
 		if (mcs_rate->rate_n_flags & RATE_MCS_SGI_MSK)
@@ -563,8 +621,9 @@ static void rs_get_lower_rate(struct iwl4965_rate_scale_priv *lq_data,
 
 	rs_get_supported_rates(lq_data, NULL, tbl->lq_type, &rate_mask);
 
-	/* mask with station rate restriction */
+	/* Mask with station rate restriction */
 	if (is_legacy(tbl->lq_type)) {
+		/* supp_rates has no CCK bits in A mode */
 		if (lq_data->phymode == (u8) MODE_IEEE80211A)
 			rate_mask  = (u16)(rate_mask &
 			   (lq_data->supp_rates << IWL_FIRST_OFDM_RATE));
@@ -572,7 +631,7 @@ static void rs_get_lower_rate(struct iwl4965_rate_scale_priv *lq_data,
 			rate_mask = (u16)(rate_mask & lq_data->supp_rates);
 	}
 
-	/* if we did switched from HT to legacy check current rate */
+	/* If we switched from HT to legacy, check current rate */
 	if (switch_to_legacy && (rate_mask & (1 << scale_index))) {
 		rs_mcs_from_tbl(mcs_rate, tbl, scale_index, is_green);
 		return;
@@ -587,6 +646,9 @@ static void rs_get_lower_rate(struct iwl4965_rate_scale_priv *lq_data,
 		rs_mcs_from_tbl(mcs_rate, tbl, scale_index, is_green);
 }
 
+/*
+ * mac80211 sends us Tx status
+ */
 static void rs_tx_status(void *priv_rate,
 			 struct net_device *dev,
 			 struct sk_buff *skb,
@@ -640,11 +702,14 @@ static void rs_tx_status(void *priv_rate,
 	table = &lq->lq;
 	active_index = lq->active_tbl;
 
+	/* Get mac80211 antenna info */
 	lq->antenna = (lq->valid_antenna & local->hw.conf.antenna_sel_tx);
 	if (!lq->antenna)
 		lq->antenna = lq->valid_antenna;
 
+	/* Ignore mac80211 antenna info for now */
 	lq->antenna = lq->valid_antenna;
+
 	curr_tbl = &(lq->lq_info[active_index]);
 	search_tbl = &(lq->lq_info[(1 - active_index)]);
 	window = (struct iwl4965_rate_scale_data *)
@@ -663,6 +728,14 @@ static void rs_tx_status(void *priv_rate,
 		return;
 	}
 
+	/*
+	 * Ignore this Tx frame response if its initial rate doesn't match
+	 * that of latest Link Quality command.  There may be stragglers
+	 * from a previous Link Quality command, but we're no longer interested
+	 * in those; they're either from the "active" mode while we're trying
+	 * to check "search" mode, or a prior "search" mode after we've moved
+	 * to a new "search" mode (which might become the new "active" mode).
+	 */
 	if (retries &&
 	    (tx_mcs.rate_n_flags !=
 				le32_to_cpu(table->rs_table[0].rate_n_flags))) {
@@ -673,12 +746,17 @@ static void rs_tx_status(void *priv_rate,
 		return;
 	}
 
+	/* Update frame history window with "failure" for each Tx retry. */
 	while (retries) {
+		/* Look up the rate and other info used for each tx attempt.
+		 * Each tx attempt steps one entry deeper in the rate table. */
 		tx_mcs.rate_n_flags =
 		    le32_to_cpu(table->rs_table[index].rate_n_flags);
 		rs_get_tbl_info_from_mcs(&tx_mcs, priv->phymode,
 					  &tbl_type, &rs_index);
 
+		/* If type matches "search" table,
+		 * add failure to "search" history */
 		if ((tbl_type.lq_type == search_tbl->lq_type) &&
 		    (tbl_type.antenna_type == search_tbl->antenna_type) &&
 		    (tbl_type.is_SGI == search_tbl->is_SGI)) {
@@ -686,8 +764,10 @@ static void rs_tx_status(void *priv_rate,
 				tpt = search_tbl->expected_tpt[rs_index];
 			else
 				tpt = 0;
-			rs_collect_tx_data(search_win,
-					    rs_index, tpt, 0);
+			rs_collect_tx_data(search_win, rs_index, tpt, 0);
+
+		/* Else if type matches "current/active" table,
+		 * add failure to "current/active" history */
 		} else if ((tbl_type.lq_type == curr_tbl->lq_type) &&
 			   (tbl_type.antenna_type == curr_tbl->antenna_type) &&
 			   (tbl_type.is_SGI == curr_tbl->is_SGI)) {
@@ -697,6 +777,9 @@ static void rs_tx_status(void *priv_rate,
 				tpt = 0;
 			rs_collect_tx_data(window, rs_index, tpt, 0);
 		}
+
+		/* If not searching for a new mode, increment failed counter
+		 * ... this helps determine when to start searching again */
 		if (lq->stay_in_tbl)
 			lq->total_failed++;
 		--retries;
@@ -704,6 +787,11 @@ static void rs_tx_status(void *priv_rate,
 
 	}
 
+	/*
+	 * Find (by rate) the history window to update with final Tx attempt;
+	 * if Tx was successful first try, use original rate,
+	 * else look up the rate that was, finally, successful.
+	 */
 	if (!tx_resp->retry_count)
 		tx_mcs.rate_n_flags = tx_resp->control.tx_rate;
 	else
@@ -713,11 +801,14 @@ static void rs_tx_status(void *priv_rate,
 	rs_get_tbl_info_from_mcs(&tx_mcs, priv->phymode,
 				  &tbl_type, &rs_index);
 
+	/* Update frame history window with "success" if Tx got ACKed ... */
 	if (tx_resp->flags & IEEE80211_TX_STATUS_ACK)
 		status = 1;
 	else
 		status = 0;
 
+	/* If type matches "search" table,
+	 * add final tx status to "search" history */
 	if ((tbl_type.lq_type == search_tbl->lq_type) &&
 	    (tbl_type.antenna_type == search_tbl->antenna_type) &&
 	    (tbl_type.is_SGI == search_tbl->is_SGI)) {
@@ -727,6 +818,9 @@ static void rs_tx_status(void *priv_rate,
 			tpt = 0;
 		rs_collect_tx_data(search_win,
 				    rs_index, tpt, status);
+
+	/* Else if type matches "current/active" table,
+	 * add final tx status to "current/active" history */
 	} else if ((tbl_type.lq_type == curr_tbl->lq_type) &&
 		   (tbl_type.antenna_type == curr_tbl->antenna_type) &&
 		   (tbl_type.is_SGI == curr_tbl->is_SGI)) {
@@ -737,6 +831,8 @@ static void rs_tx_status(void *priv_rate,
 		rs_collect_tx_data(window, rs_index, tpt, status);
 	}
 
+	/* If not searching for new mode, increment success/failed counter
+	 * ... these help determine when to start searching again */
 	if (lq->stay_in_tbl) {
 		if (status)
 			lq->total_success++;
@@ -744,6 +840,7 @@ static void rs_tx_status(void *priv_rate,
 			lq->total_failed++;
 	}
 
+	/* See if there's a better rate or modulation mode to try. */
 	rs_rate_scale_perform(priv, dev, hdr, sta);
 	sta_info_put(sta);
 	return;
@@ -773,11 +870,19 @@ static u8 rs_is_other_ant_connected(u8 valid_antenna,
 	return 0;
 }
 
+/*
+ * Begin a period of staying with a selected modulation mode.
+ * Set "stay_in_tbl" flag to prevent any mode switches.
+ * Set frame tx success limits according to legacy vs. high-throughput,
+ * and reset overall (spanning all rates) tx success history statistics.
+ * These control how long we stay using same modulation mode before
+ * searching for a new mode.
+ */
 static void rs_set_stay_in_table(u8 is_legacy,
 				 struct iwl4965_rate_scale_priv *lq_data)
 {
 	IWL_DEBUG_HT("we are staying in the same table\n");
-	lq_data->stay_in_tbl = 1;
+	lq_data->stay_in_tbl = 1;	/* only place this gets set */
 	if (is_legacy) {
 		lq_data->table_count_limit = IWL_LEGACY_TABLE_COUNT;
 		lq_data->max_failure_limit = IWL_LEGACY_FAILURE_LIMIT;
@@ -792,6 +897,9 @@ static void rs_set_stay_in_table(u8 is_legacy,
 	lq_data->total_success = 0;
 }
 
+/*
+ * Find correct throughput table for given mode of modulation
+ */
 static void rs_get_expected_tpt_table(struct iwl4965_rate_scale_priv *lq_data,
 				      struct iwl4965_scale_tbl_info *tbl)
 {
@@ -826,17 +934,33 @@ static void rs_get_expected_tpt_table(struct iwl4965_rate_scale_priv *lq_data,
 }
 
 #ifdef CONFIG_IWL4965_HT
+/*
+ * Find starting rate for new "search" high-throughput mode of modulation.
+ * Goal is to find lowest expected rate (under perfect conditions) that is
+ * above the current measured throughput of "active" mode, to give new mode
+ * a fair chance to prove itself without too many challenges.
+ *
+ * This gets called when transitioning to more aggressive modulation
+ * (i.e. legacy to SISO or MIMO, or SISO to MIMO), as well as less aggressive
+ * (i.e. MIMO to SISO).  When moving to MIMO, bit rate will typically need
+ * to decrease to match "active" throughput.  When moving from MIMO to SISO,
+ * bit rate will typically need to increase, but not if performance was bad.
+ */
 static s32 rs_get_best_rate(struct iwl4965_priv *priv,
 			    struct iwl4965_rate_scale_priv *lq_data,
-			    struct iwl4965_scale_tbl_info *tbl,
+			    struct iwl4965_scale_tbl_info *tbl,	/* "search" */
 			    u16 rate_mask, s8 index, s8 rate)
 {
+	/* "active" values */
 	struct iwl4965_scale_tbl_info *active_tbl =
 	    &(lq_data->lq_info[lq_data->active_tbl]);
-	s32 new_rate, high, low, start_hi;
 	s32 active_sr = active_tbl->win[index].success_ratio;
-	s32 *tpt_tbl = tbl->expected_tpt;
 	s32 active_tpt = active_tbl->expected_tpt[index];
+
+	/* expected "search" throughput */
+	s32 *tpt_tbl = tbl->expected_tpt;
+
+	s32 new_rate, high, low, start_hi;
 	u16 high_low;
 
 	new_rate = high = low = start_hi = IWL_RATE_INVALID;
@@ -847,6 +971,21 @@ static s32 rs_get_best_rate(struct iwl4965_priv *priv,
 		low = high_low & 0xff;
 		high = (high_low >> 8) & 0xff;
 
+		/*
+		 * Lower the "search" bit rate, to give new "search" mode
+		 * approximately the same throughput as "active" if:
+		 *
+		 * 1) "Active" mode has been working modestly well (but not
+		 *    great), and expected "search" throughput (under perfect
+		 *    conditions) at candidate rate is above the actual
+		 *    measured "active" throughput (but less than expected
+		 *    "active" throughput under perfect conditions).
+		 * OR
+		 * 2) "Active" mode has been working perfectly or very well
+		 *    and expected "search" throughput (under perfect
+		 *    conditions) at candidate rate is above expected
+		 *    "active" throughput (under perfect conditions).
+		 */
 		if ((((100 * tpt_tbl[rate]) > lq_data->last_tpt) &&
 		     ((active_sr > IWL_RATE_DECREASE_TH) &&
 		      (active_sr <= IWL_RATE_HIGH_TH) &&
@@ -854,21 +993,38 @@ static s32 rs_get_best_rate(struct iwl4965_priv *priv,
 		    ((active_sr >= IWL_RATE_SCALE_SWITCH) &&
 		     (tpt_tbl[rate] > active_tpt))) {
 
+			/* (2nd or later pass)
+			 * If we've already tried to raise the rate, and are
+			 * now trying to lower it, use the higher rate. */
 			if (start_hi != IWL_RATE_INVALID) {
 				new_rate = start_hi;
 				break;
 			}
+
 			new_rate = rate;
+
+			/* Loop again with lower rate */
 			if (low != IWL_RATE_INVALID)
 				rate = low;
+
+			/* Lower rate not available, use the original */
 			else
 				break;
+
+		/* Else try to raise the "search" rate to match "active" */
 		} else {
+			/* (2nd or later pass)
+			 * If we've already tried to lower the rate, and are
+			 * now trying to raise it, use the lower rate. */
 			if (new_rate != IWL_RATE_INVALID)
 				break;
+
+			/* Loop again with higher rate */
 			else if (high != IWL_RATE_INVALID) {
 				start_hi = high;
 				rate = high;
+
+			/* Higher rate not available, use the original */
 			} else {
 				new_rate = rate;
 				break;
@@ -885,6 +1041,9 @@ static inline u8 rs_is_both_ant_supp(u8 valid_antenna)
 	return (rs_is_ant_connected(valid_antenna, ANT_BOTH));
 }
 
+/*
+ * Set up search table for MIMO
+ */
 static int rs_switch_to_mimo(struct iwl4965_priv *priv,
 			     struct iwl4965_rate_scale_priv *lq_data,
 			     struct ieee80211_conf *conf,
@@ -908,6 +1067,7 @@ static int rs_switch_to_mimo(struct iwl4965_priv *priv,
 	if (priv->current_ht_config.tx_mimo_ps_mode == IWL_MIMO_PS_STATIC)
 		return -1;
 
+	/* Need both Tx chains/antennas to support MIMO */
 	if (!rs_is_both_ant_supp(lq_data->antenna))
 		return -1;
 
@@ -946,6 +1106,9 @@ static int rs_switch_to_mimo(struct iwl4965_priv *priv,
 #endif				/*CONFIG_IWL4965_HT */
 }
 
+/*
+ * Set up search table for SISO
+ */
 static int rs_switch_to_siso(struct iwl4965_priv *priv,
 			     struct iwl4965_rate_scale_priv *lq_data,
 			     struct ieee80211_conf *conf,
@@ -1006,6 +1169,9 @@ static int rs_switch_to_siso(struct iwl4965_priv *priv,
 #endif				/*CONFIG_IWL4965_HT */
 }
 
+/*
+ * Try to switch to new modulation mode from legacy
+ */
 static int rs_move_legacy_other(struct iwl4965_priv *priv,
 				struct iwl4965_rate_scale_priv *lq_data,
 				struct ieee80211_conf *conf,
@@ -1029,12 +1195,17 @@ static int rs_move_legacy_other(struct iwl4965_priv *priv,
 
 			search_tbl->lq_type = LQ_NONE;
 			lq_data->action_counter++;
+
+			/* Don't change antenna if success has been great */
 			if (window->success_ratio >= IWL_RS_GOOD_RATIO)
 				break;
+
+			/* Don't change antenna if other one is not connected */
 			if (!rs_is_other_ant_connected(lq_data->antenna,
 							tbl->antenna_type))
 				break;
 
+			/* Set up search table to try other antenna */
 			memcpy(search_tbl, tbl, sz);
 
 			rs_toggle_antenna(&(search_tbl->current_rate),
@@ -1045,6 +1216,8 @@ static int rs_move_legacy_other(struct iwl4965_priv *priv,
 
 		case IWL_LEGACY_SWITCH_SISO:
 			IWL_DEBUG_HT("LQ: Legacy switch to SISO\n");
+
+			/* Set up search table to try SISO */
 			memcpy(search_tbl, tbl, sz);
 			search_tbl->lq_type = LQ_SISO;
 			search_tbl->is_SGI = 0;
@@ -1060,6 +1233,8 @@ static int rs_move_legacy_other(struct iwl4965_priv *priv,
 			break;
 		case IWL_LEGACY_SWITCH_MIMO:
 			IWL_DEBUG_HT("LQ: Legacy switch MIMO\n");
+
+			/* Set up search table to try MIMO */
 			memcpy(search_tbl, tbl, sz);
 			search_tbl->lq_type = LQ_MIMO;
 			search_tbl->is_SGI = 0;
@@ -1092,6 +1267,9 @@ static int rs_move_legacy_other(struct iwl4965_priv *priv,
 
 }
 
+/*
+ * Try to switch to new modulation mode from SISO
+ */
 static int rs_move_siso_to_other(struct iwl4965_priv *priv,
 				 struct iwl4965_rate_scale_priv *lq_data,
 				 struct ieee80211_conf *conf,
@@ -1184,6 +1362,9 @@ static int rs_move_siso_to_other(struct iwl4965_priv *priv,
 	return 0;
 }
 
+/*
+ * Try to switch to new modulation mode from MIMO
+ */
 static int rs_move_mimo_to_other(struct iwl4965_priv *priv,
 				 struct iwl4965_rate_scale_priv *lq_data,
 				 struct ieee80211_conf *conf,
@@ -1206,6 +1387,8 @@ static int rs_move_mimo_to_other(struct iwl4965_priv *priv,
 		case IWL_MIMO_SWITCH_ANTENNA_A:
 		case IWL_MIMO_SWITCH_ANTENNA_B:
 			IWL_DEBUG_HT("LQ: MIMO SWITCH TO SISO\n");
+
+			/* Set up new search table for SISO */
 			memcpy(search_tbl, tbl, sz);
 			search_tbl->lq_type = LQ_SISO;
 			search_tbl->is_SGI = 0;
@@ -1225,6 +1408,8 @@ static int rs_move_mimo_to_other(struct iwl4965_priv *priv,
 
 		case IWL_MIMO_SWITCH_GI:
 			IWL_DEBUG_HT("LQ: MIMO SWITCH TO GI\n");
+
+			/* Set up new search table for MIMO */
 			memcpy(search_tbl, tbl, sz);
 			search_tbl->lq_type = LQ_MIMO;
 			search_tbl->antenna_type = ANT_BOTH;
@@ -1234,6 +1419,13 @@ static int rs_move_mimo_to_other(struct iwl4965_priv *priv,
 			else
 				search_tbl->is_SGI = 1;
 			lq_data->search_better_tbl = 1;
+
+			/*
+			 * If active table already uses the fastest possible
+			 * modulation (dual stream with short guard interval),
+			 * and it's working well, there's no need to look
+			 * for a better type of modulation!
+			 */
 			if ((tbl->lq_type == LQ_MIMO) &&
 			    (tbl->is_SGI)) {
 				s32 tpt = lq_data->last_tpt / 100;
@@ -1266,6 +1458,13 @@ static int rs_move_mimo_to_other(struct iwl4965_priv *priv,
 
 }
 
+/*
+ * Check whether we should continue using same modulation mode, or
+ * begin search for a new mode, based on:
+ * 1) # tx successes or failures while using this mode
+ * 2) # times calling this function
+ * 3) elapsed time in this mode (not used, for now)
+ */
 static void rs_stay_in_table(struct iwl4965_rate_scale_priv *lq_data)
 {
 	struct iwl4965_scale_tbl_info *tbl;
@@ -1277,15 +1476,27 @@ static void rs_stay_in_table(struct iwl4965_rate_scale_priv *lq_data)
 
 	tbl = &(lq_data->lq_info[active_tbl]);
 
+	/* If we've been disallowing search, see if we should now allow it */
 	if (lq_data->stay_in_tbl) {
 
+		/* Elapsed time using current modulation mode */
 		if (lq_data->flush_timer)
 			flush_interval_passed =
 			    time_after(jiffies,
 				       (unsigned long)(lq_data->flush_timer +
 					IWL_RATE_SCALE_FLUSH_INTVL));
 
+		/* For now, disable the elapsed time criterion */
 		flush_interval_passed = 0;
+
+		/*
+		 * Check if we should allow search for new modulation mode.
+		 * If many frames have failed or succeeded, or we've used
+		 * this same modulation for a long time, allow search, and
+		 * reset history stats that keep track of whether we should
+		 * allow a new search.  Also (below) reset all bitmaps and
+		 * stats in active history.
+		 */
 		if ((lq_data->total_failed > lq_data->max_failure_limit) ||
 		    (lq_data->total_success > lq_data->max_success_limit) ||
 		    ((!lq_data->search_better_tbl) && (lq_data->flush_timer)
@@ -1294,10 +1505,19 @@ static void rs_stay_in_table(struct iwl4965_rate_scale_priv *lq_data)
 				     lq_data->total_failed,
 				     lq_data->total_success,
 				     flush_interval_passed);
-			lq_data->stay_in_tbl = 0;
+
+			/* Allow search for new mode */
+			lq_data->stay_in_tbl = 0;	/* only place reset */
 			lq_data->total_failed = 0;
 			lq_data->total_success = 0;
 			lq_data->flush_timer = 0;
+
+		/*
+		 * Else if we've used this modulation mode enough repetitions
+		 * (regardless of elapsed time or success/failure), reset
+		 * history bitmaps and rate-specific stats for all rates in
+		 * active table.
+		 */
 		} else {
 			lq_data->table_count++;
 			if (lq_data->table_count >=
@@ -1311,6 +1531,9 @@ static void rs_stay_in_table(struct iwl4965_rate_scale_priv *lq_data)
 			}
 		}
 
+		/* If transitioning to allow "search", reset all history
+		 * bitmaps and stats in active table (this will become the new
+		 * "search" table). */
 		if (!lq_data->stay_in_tbl) {
 			for (i = 0; i < IWL_RATE_COUNT; i++)
 				rs_rate_scale_clear_window(&(tbl->win[i]));
@@ -1318,6 +1541,9 @@ static void rs_stay_in_table(struct iwl4965_rate_scale_priv *lq_data)
 	}
 }
 
+/*
+ * Do rate scaling and search for new modulation mode.
+ */
 static void rs_rate_scale_perform(struct iwl4965_priv *priv,
 				  struct net_device *dev,
 				  struct ieee80211_hdr *hdr,
@@ -1366,6 +1592,11 @@ static void rs_rate_scale_perform(struct iwl4965_priv *priv,
 	}
 	lq_data = (struct iwl4965_rate_scale_priv *)sta->rate_ctrl_priv;
 
+	/*
+	 * Select rate-scale / modulation-mode table to work with in
+	 * the rest of this function:  "search" if searching for better
+	 * modulation mode, or "active" if doing rate scaling within a mode.
+	 */
 	if (!lq_data->search_better_tbl)
 		active_tbl = lq_data->active_tbl;
 	else
@@ -1374,11 +1605,13 @@ static void rs_rate_scale_perform(struct iwl4965_priv *priv,
 	tbl = &(lq_data->lq_info[active_tbl]);
 	is_green = lq_data->is_green;
 
+	/* current tx rate */
 	index = sta->last_txrate;
 
 	IWL_DEBUG_RATE("Rate scale index %d for type %d\n", index,
 		       tbl->lq_type);
 
+	/* rates available for this association, and for modulation mode */
 	rs_get_supported_rates(lq_data, hdr, tbl->lq_type,
 				&rate_mask);
 
@@ -1387,6 +1620,7 @@ static void rs_rate_scale_perform(struct iwl4965_priv *priv,
 	/* mask with station rate restriction */
 	if (is_legacy(tbl->lq_type)) {
 		if (lq_data->phymode == (u8) MODE_IEEE80211A)
+			/* supp_rates has no CCK bits in A mode */
 			rate_scale_index_msk = (u16) (rate_mask &
 				(lq_data->supp_rates << IWL_FIRST_OFDM_RATE));
 		else
@@ -1399,11 +1633,13 @@ static void rs_rate_scale_perform(struct iwl4965_priv *priv,
 	if (!rate_scale_index_msk)
 		rate_scale_index_msk = rate_mask;
 
+	/* If current rate is no longer supported on current association,
+	 * or user changed preferences for rates, find a new supported rate. */
 	if (index < 0 || !((1 << index) & rate_scale_index_msk)) {
 		index = IWL_INVALID_VALUE;
 		update_lq = 1;
 
-		/* get the lowest available rate */
+		/* get the highest available rate */
 		for (i = 0; i <= IWL_RATE_COUNT; i++) {
 			if ((1 << i) & rate_scale_index_msk)
 				index = i;
@@ -1415,11 +1651,19 @@ static void rs_rate_scale_perform(struct iwl4965_priv *priv,
 		}
 	}
 
+	/* Get expected throughput table and history window for current rate */
 	if (!tbl->expected_tpt)
 		rs_get_expected_tpt_table(lq_data, tbl);
 
 	window = &(tbl->win[index]);
 
+	/*
+	 * If there is not enough history to calculate actual average
+	 * throughput, keep analyzing results of more tx frames, without
+	 * changing rate or mode (bypass most of the rest of this function).
+	 * Set up new rate table in uCode only if old rate is not supported
+	 * in current association (use new rate found above).
+	 */
 	fail_count = window->counter - window->success_counter;
 	if (((fail_count < IWL_RATE_MIN_FAILURE_TH) &&
 	     (window->success_counter < IWL_RATE_MIN_SUCCESS_TH))
@@ -1427,8 +1671,15 @@ static void rs_rate_scale_perform(struct iwl4965_priv *priv,
 		IWL_DEBUG_RATE("LQ: still below TH succ %d total %d "
 			       "for index %d\n",
 			       window->success_counter, window->counter, index);
+
+		/* Can't calculate this yet; not enough history */
 		window->average_tpt = IWL_INVALID_VALUE;
+
+		/* Should we stay with this modulation mode,
+		 * or search for a new one? */
 		rs_stay_in_table(lq_data);
+
+		/* Set up new rate table in uCode, if needed */
 		if (update_lq) {
 			rs_mcs_from_tbl(&mcs_rate, tbl, index, is_green);
 			rs_fill_link_cmd(lq_data, &mcs_rate, &lq_data->lq);
@@ -1436,13 +1687,19 @@ static void rs_rate_scale_perform(struct iwl4965_priv *priv,
 		}
 		goto out;
 
+	/* Else we have enough samples; calculate estimate of
+	 * actual average throughput */
 	} else
 		window->average_tpt = ((window->success_ratio *
 					tbl->expected_tpt[index] + 64) / 128);
 
+	/* If we are searching for better modulation mode, check success. */
 	if (lq_data->search_better_tbl) {
 		int success_limit = IWL_RATE_SCALE_SWITCH;
 
+		/* If good success, continue using the "search" mode;
+		 * no need to send new link quality command, since we're
+		 * continuing to use the setup that we've been trying. */
 		if ((window->success_ratio > success_limit) ||
 		    (window->average_tpt > lq_data->last_tpt)) {
 			if (!is_legacy(tbl->lq_type)) {
@@ -1454,55 +1711,78 @@ static void rs_rate_scale_perform(struct iwl4965_priv *priv,
 					     lq_data->last_tpt);
 				lq_data->enable_counter = 1;
 			}
+			/* Swap tables; "search" becomes "active" */
 			lq_data->active_tbl = active_tbl;
 			current_tpt = window->average_tpt;
+
+		/* Else poor success; go back to mode in "active" table */
 		} else {
+			/* Nullify "search" table */
 			tbl->lq_type = LQ_NONE;
+
+			/* Revert to "active" table */
 			active_tbl = lq_data->active_tbl;
 			tbl = &(lq_data->lq_info[active_tbl]);
 
+			/* Revert to "active" rate and throughput info */
 			index = iwl4965_rate_index_from_plcp(
 				tbl->current_rate.rate_n_flags);
+			current_tpt = lq_data->last_tpt;
 
+			/* Need to set up a new rate table in uCode */
 			update_lq = 1;
-			current_tpt = lq_data->last_tpt;
 			IWL_DEBUG_HT("XXY GO BACK TO OLD TABLE\n");
 		}
+
+		/* Either way, we've made a decision; modulation mode
+		 * search is done, allow rate adjustment next time. */
 		lq_data->search_better_tbl = 0;
-		done_search = 1;
+		done_search = 1;	/* Don't switch modes below! */
 		goto lq_update;
 	}
 
+	/* (Else) not in search of better modulation mode, try for better
+	 * starting rate, while staying in this mode. */
 	high_low = rs_get_adjacent_rate(index, rate_scale_index_msk,
 					tbl->lq_type);
 	low = high_low & 0xff;
 	high = (high_low >> 8) & 0xff;
 
+	/* Collect measured throughputs for current and adjacent rates */
 	current_tpt = window->average_tpt;
-
 	if (low != IWL_RATE_INVALID)
 		low_tpt = tbl->win[low].average_tpt;
-
 	if (high != IWL_RATE_INVALID)
 		high_tpt = tbl->win[high].average_tpt;
 
-
+	/* Assume rate increase */
 	scale_action = 1;
 
+	/* Too many failures, decrease rate */
 	if ((window->success_ratio <= IWL_RATE_DECREASE_TH) ||
 	    (current_tpt == 0)) {
 		IWL_DEBUG_RATE("decrease rate because of low success_ratio\n");
 		scale_action = -1;
+
+	/* No throughput measured yet for adjacent rates; try increase. */
 	} else if ((low_tpt == IWL_INVALID_VALUE) &&
 		   (high_tpt == IWL_INVALID_VALUE))
 		scale_action = 1;
+
+	/* Both adjacent throughputs are measured, but neither one has better
+	 * throughput; we're using the best rate, don't change it! */
 	else if ((low_tpt != IWL_INVALID_VALUE) &&
 		 (high_tpt != IWL_INVALID_VALUE) &&
 		 (low_tpt < current_tpt) &&
 		 (high_tpt < current_tpt))
 		scale_action = 0;
+
+	/* At least one adjacent rate's throughput is measured,
+	 * and may have better performance. */
 	else {
+		/* Higher adjacent rate's throughput is measured */
 		if (high_tpt != IWL_INVALID_VALUE) {
+			/* Higher rate has better throughput */
 			if (high_tpt > current_tpt)
 				scale_action = 1;
 			else {
@@ -1510,7 +1790,10 @@ static void rs_rate_scale_perform(struct iwl4965_priv *priv,
 				    ("decrease rate because of high tpt\n");
 				scale_action = -1;
 			}
+
+		/* Lower adjacent rate's throughput is measured */
 		} else if (low_tpt != IWL_INVALID_VALUE) {
+			/* Lower rate has better throughput */
 			if (low_tpt > current_tpt) {
 				IWL_DEBUG_RATE
 				    ("decrease rate because of low tpt\n");
@@ -1520,23 +1803,30 @@ static void rs_rate_scale_perform(struct iwl4965_priv *priv,
 		}
 	}
 
+	/* Sanity check; asked for decrease, but success rate or throughput
+	 * has been good at old rate.  Don't change it. */
 	if (scale_action == -1) {
 		if ((low != IWL_RATE_INVALID) &&
 		    ((window->success_ratio > IWL_RATE_HIGH_TH) ||
 		     (current_tpt > (100 * tbl->expected_tpt[low]))))
 			scale_action = 0;
+
+	/* Sanity check; asked for increase, but success rate has not been great
+	 * even at old rate, higher rate will be worse.  Don't change it. */
 	} else if ((scale_action == 1) &&
 		   (window->success_ratio < IWL_RATE_INCREASE_TH))
 		scale_action = 0;
 
 	switch (scale_action) {
 	case -1:
+		/* Decrease starting rate, update uCode's rate table */
 		if (low != IWL_RATE_INVALID) {
 			update_lq = 1;
 			index = low;
 		}
 		break;
 	case 1:
+		/* Increase starting rate, update uCode's rate table */
 		if (high != IWL_RATE_INVALID) {
 			update_lq = 1;
 			index = high;
@@ -1544,6 +1834,7 @@ static void rs_rate_scale_perform(struct iwl4965_priv *priv,
 
 		break;
 	case 0:
+		/* No change */
 	default:
 		break;
 	}
@@ -1553,16 +1844,28 @@ static void rs_rate_scale_perform(struct iwl4965_priv *priv,
 		     index, scale_action, low, high, tbl->lq_type);
 
  lq_update:
+	/* Replace uCode's rate table for the destination station. */
 	if (update_lq) {
 		rs_mcs_from_tbl(&mcs_rate, tbl, index, is_green);
 		rs_fill_link_cmd(lq_data, &mcs_rate, &lq_data->lq);
 		rs_send_lq_cmd(priv, &lq_data->lq, CMD_ASYNC);
 	}
+
+	/* Should we stay with this modulation mode, or search for a new one? */
 	rs_stay_in_table(lq_data);
 
+	/*
+	 * Search for new modulation mode if we're:
+	 * 1)  Not changing rates right now
+	 * 2)  Not just finishing up a search
+	 * 3)  Allowing a new search
+	 */
 	if (!update_lq && !done_search && !lq_data->stay_in_tbl) {
+		/* Save current throughput to compare with "search" throughput*/
 		lq_data->last_tpt = current_tpt;
 
+		/* Select a new "search" modulation mode to try.
+		 * If one is found, set up the new "search" table. */
 		if (is_legacy(tbl->lq_type))
 			rs_move_legacy_other(priv, lq_data, conf, sta, index);
 		else if (is_siso(tbl->lq_type))
@@ -1570,11 +1873,14 @@ static void rs_rate_scale_perform(struct iwl4965_priv *priv,
 		else
 			rs_move_mimo_to_other(priv, lq_data, conf, sta, index);
 
+		/* If new "search" mode was selected, set up in uCode table */
 		if (lq_data->search_better_tbl) {
+			/* Access the "search" table, clear its history. */
 			tbl = &(lq_data->lq_info[(1 - lq_data->active_tbl)]);
 			for (i = 0; i < IWL_RATE_COUNT; i++)
 				rs_rate_scale_clear_window(&(tbl->win[i]));
 
+			/* Use new "search" start rate */
 			index = iwl4965_rate_index_from_plcp(
 					tbl->current_rate.rate_n_flags);
 
@@ -1584,8 +1890,13 @@ static void rs_rate_scale_perform(struct iwl4965_priv *priv,
 					 &lq_data->lq);
 			rs_send_lq_cmd(priv, &lq_data->lq, CMD_ASYNC);
 		}
-		tbl1 = &(lq_data->lq_info[lq_data->active_tbl]);
 
+		/* If the "active" (non-search) mode was legacy,
+		 * and we've tried switching antennas,
+		 * but we haven't been able to try HT modes (not available),
+		 * stay with best antenna legacy modulation for a while
+		 * before next round of mode comparisons. */
+		tbl1 = &(lq_data->lq_info[lq_data->active_tbl]);
 		if (is_legacy(tbl1->lq_type) &&
 #ifdef CONFIG_IWL4965_HT
 		   (!(conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE)) &&
@@ -1596,9 +1907,13 @@ static void rs_rate_scale_perform(struct iwl4965_priv *priv,
 			rs_set_stay_in_table(1, lq_data);
 		}
 
+		/* If we're in an HT mode, and all 3 mode switch actions
+		 * have been tried and compared, stay in this best modulation
+		 * mode for a while before next round of mode comparisons. */
 		if (lq_data->enable_counter &&
 		    (lq_data->action_counter >= IWL_ACTION_LIMIT)) {
 #ifdef CONFIG_IWL4965_HT_AGG
+			/* If appropriate, set up aggregation! */
 			if ((lq_data->last_tpt > TID_AGG_TPT_THREHOLD) &&
 			    (priv->lq_mngr.agg_ctrl.auto_agg)) {
 				priv->lq_mngr.agg_ctrl.tid_retry =
@@ -1609,6 +1924,14 @@ static void rs_rate_scale_perform(struct iwl4965_priv *priv,
 			lq_data->action_counter = 0;
 			rs_set_stay_in_table(0, lq_data);
 		}
+
+	/*
+	 * Else, don't search for a new modulation mode.
+	 * Put new timestamp in stay-in-modulation-mode flush timer if:
+	 * 1)  Not changing rates right now
+	 * 2)  Not just finishing up a search
+	 * 3)  flush timer is empty
+	 */
 	} else {
 		if ((!update_lq) && (!done_search) && (!lq_data->flush_timer))
 			lq_data->flush_timer = jiffies;
@@ -1834,15 +2157,14 @@ static void rs_rate_init(void *priv_rate, void *priv_sta,
 		priv->assoc_station_added = 1;
 	}
 
+	/* Find highest tx rate supported by hardware and destination station */
 	for (i = 0; i < mode->num_rates; i++) {
 		if ((sta->supp_rates & BIT(i)) &&
 		    (mode->rates[i].flags & IEEE80211_RATE_SUPPORTED))
 			sta->txrate = i;
 	}
 	sta->last_txrate = sta->txrate;
-	/* For MODE_IEEE80211A mode cck rate are at end
-	 * rate table
-	 */
+	/* For MODE_IEEE80211A, cck rates are at end of rate table */
 	if (local->hw.conf.phymode == MODE_IEEE80211A)
 		sta->last_txrate += IWL_FIRST_OFDM_RATE;
 
@@ -1855,12 +2177,18 @@ static void rs_rate_init(void *priv_rate, void *priv_sta,
 	crl->active_rate_basic = priv->active_rate_basic;
 	crl->phymode = priv->phymode;
 #ifdef CONFIG_IWL4965_HT
+	/*
+	 * active_siso_rate mask includes 9 MBits (bit 5), and CCK (bits 0-3),
+	 * supp_rates[] does not; shift to convert format, force 9 MBits off.
+	 */
+
 	crl->active_siso_rate = (priv->current_ht_config.supp_mcs_set[0] << 1);
 	crl->active_siso_rate |=
 			(priv->current_ht_config.supp_mcs_set[0] & 0x1);
 	crl->active_siso_rate &= ~((u16)0x2);
 	crl->active_siso_rate = crl->active_siso_rate << IWL_FIRST_OFDM_RATE;
 
+	/* Same here */
 	crl->active_mimo_rate = (priv->current_ht_config.supp_mcs_set[1] << 1);
 	crl->active_mimo_rate |=
 			(priv->current_ht_config.supp_mcs_set[1] & 0x1);
@@ -1891,11 +2219,14 @@ static void rs_fill_link_cmd(struct iwl4965_rate_scale_priv *lq_data,
 	struct iwl4965_rate new_rate;
 	struct iwl4965_scale_tbl_info tbl_type = { 0 };
 
+	/* Override starting rate (index 0) if needed for debug purposes */
 	rs_dbgfs_set_mcs(lq_data, tx_mcs, index);
 
+	/* Interpret rate_n_flags */
 	rs_get_tbl_info_from_mcs(tx_mcs, lq_data->phymode,
 				  &tbl_type, &rate_idx);
 
+	/* How many times should we repeat the initial rate? */
 	if (is_legacy(tbl_type.lq_type)) {
 		ant_toggle_count = 1;
 		repeat_rate = IWL_NUMBER_TRY;
@@ -1904,19 +2235,27 @@ static void rs_fill_link_cmd(struct iwl4965_rate_scale_priv *lq_data,
 
 	lq_cmd->general_params.mimo_delimiter =
 			is_mimo(tbl_type.lq_type) ? 1 : 0;
+
+	/* Fill 1st table entry (index 0) */
 	lq_cmd->rs_table[index].rate_n_flags =
 			cpu_to_le32(tx_mcs->rate_n_flags);
 	new_rate.rate_n_flags = tx_mcs->rate_n_flags;
 
 	if (is_mimo(tbl_type.lq_type) || (tbl_type.antenna_type == ANT_MAIN))
-		lq_cmd->general_params.single_stream_ant_msk = 1;
+		lq_cmd->general_params.single_stream_ant_msk
+			= LINK_QUAL_ANT_A_MSK;
 	else
-		lq_cmd->general_params.single_stream_ant_msk = 2;
+		lq_cmd->general_params.single_stream_ant_msk
+			= LINK_QUAL_ANT_B_MSK;
 
 	index++;
 	repeat_rate--;
 
+	/* Fill rest of rate table */
 	while (index < LINK_QUAL_MAX_RETRY_NUM) {
+		/* Repeat initial/next rate.
+		 * For legacy IWL_NUMBER_TRY == 1, this loop will not execute.
+		 * For HT IWL_HT_NUMBER_TRY == 3, this executes twice. */
 		while (repeat_rate > 0 && (index < LINK_QUAL_MAX_RETRY_NUM)) {
 			if (is_legacy(tbl_type.lq_type)) {
 				if (ant_toggle_count <
@@ -1928,7 +2267,10 @@ static void rs_fill_link_cmd(struct iwl4965_rate_scale_priv *lq_data,
 				}
 			}
 
+			/* Override next rate if needed for debug purposes */
 			rs_dbgfs_set_mcs(lq_data, &new_rate, index);
+
+			/* Fill next table entry */
 			lq_cmd->rs_table[index].rate_n_flags =
 					cpu_to_le32(new_rate.rate_n_flags);
 			repeat_rate--;
@@ -1938,12 +2280,17 @@ static void rs_fill_link_cmd(struct iwl4965_rate_scale_priv *lq_data,
 		rs_get_tbl_info_from_mcs(&new_rate, lq_data->phymode, &tbl_type,
 						&rate_idx);
 
+		/* Indicate to uCode which entries might be MIMO.
+		 * If initial rate was MIMO, this will finally end up
+		 * as (IWL_HT_NUMBER_TRY * 2), after 2nd pass, otherwise 0. */
 		if (is_mimo(tbl_type.lq_type))
 			lq_cmd->general_params.mimo_delimiter = index;
 
+		/* Get next rate */
 		rs_get_lower_rate(lq_data, &tbl_type, rate_idx,
 				  use_ht_possible, &new_rate);
 
+		/* How many times should we repeat the next rate? */
 		if (is_legacy(tbl_type.lq_type)) {
 			if (ant_toggle_count < NUM_TRY_BEFORE_ANTENNA_TOGGLE)
 				ant_toggle_count++;
@@ -1955,9 +2302,14 @@ static void rs_fill_link_cmd(struct iwl4965_rate_scale_priv *lq_data,
 		} else
 			repeat_rate = IWL_HT_NUMBER_TRY;
 
+		/* Don't allow HT rates after next pass.
+		 * rs_get_lower_rate() will change type to LQ_A or LQ_G. */
 		use_ht_possible = 0;
 
+		/* Override next rate if needed for debug purposes */
 		rs_dbgfs_set_mcs(lq_data, &new_rate, index);
+
+		/* Fill next table entry */
 		lq_cmd->rs_table[index].rate_n_flags =
 				cpu_to_le32(new_rate.rate_n_flags);
 
@@ -2053,9 +2405,9 @@ static ssize_t rs_sta_dbgfs_scale_table_write(struct file *file,
 	else
 		rs_priv->dbg_fixed.rate_n_flags = 0;
 
-	rs_priv->active_rate = 0x0FFF;
-	rs_priv->active_siso_rate = 0x1FD0;
-	rs_priv->active_mimo_rate = 0x1FD0;
+	rs_priv->active_rate = 0x0FFF;		/* 1 - 54 MBits, includes CCK */
+	rs_priv->active_siso_rate = 0x1FD0;	/* 6 - 60 MBits, no 9, no CCK */
+	rs_priv->active_mimo_rate = 0x1FD0;	/* 6 - 60 MBits, no 9, no CCK */
 
 	IWL_DEBUG_RATE("sta_id %d rate 0x%X\n",
 		rs_priv->lq.sta_id, rs_priv->dbg_fixed.rate_n_flags);
@@ -2256,7 +2608,7 @@ int iwl4965_fill_rs_info(struct ieee80211_hw *hw, char *buf, u8 sta_id)
 
 	/* Display the average rate of all samples taken.
 	 *
-	 * NOTE:  We multiple # of samples by 2 since the IEEE measurement
+	 * NOTE:  We multiply # of samples by 2 since the IEEE measurement
 	 * added from iwl4965_rates is actually 2X the rate */
 	if (samples)
 		count += sprintf(&buf[count],
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.h b/drivers/net/wireless/iwlwifi/iwl-4965-rs.h
index 4259099..86f62d8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.h
@@ -30,10 +30,10 @@
 #include "iwl-4965.h"
 
 struct iwl4965_rate_info {
-	u8 plcp;
-	u8 plcp_siso;
-	u8 plcp_mimo;
-	u8 ieee;
+	u8 plcp;	/* uCode API:  IWL_RATE_6M_PLCP, etc. */
+	u8 plcp_siso;	/* uCode API:  IWL_RATE_SISO_6M_PLCP, etc. */
+	u8 plcp_mimo;	/* uCode API:  IWL_RATE_MIMO_6M_PLCP, etc. */
+	u8 ieee;	/* MAC header:  IWL_RATE_6M_IEEE, etc. */
 	u8 prev_ieee;    /* previous rate in IEEE speeds */
 	u8 next_ieee;    /* next rate in IEEE speeds */
 	u8 prev_rs;      /* previous rate used in rs algo */
@@ -42,6 +42,7 @@ struct iwl4965_rate_info {
 	u8 next_rs_tgg;  /* next rate used in TGG rs algo */
 };
 
+/* For driver (not uCode API) */
 enum {
 	IWL_RATE_1M_INDEX = 0,
 	IWL_RATE_2M_INDEX,
@@ -83,6 +84,7 @@ enum {
 #define	IWL_RATE_5M_MASK   (1<<IWL_RATE_5M_INDEX)
 #define	IWL_RATE_11M_MASK  (1<<IWL_RATE_11M_INDEX)
 
+/* 4965 uCode API values for legacy bit rates, both OFDM and CCK */
 enum {
 	IWL_RATE_6M_PLCP  = 13,
 	IWL_RATE_9M_PLCP  = 15,
@@ -99,7 +101,7 @@ enum {
 	IWL_RATE_11M_PLCP = 110,
 };
 
-/* OFDM HT rate plcp */
+/* 4965 uCode API values for OFDM high-throughput (HT) bit rates */
 enum {
 	IWL_RATE_SISO_6M_PLCP = 0,
 	IWL_RATE_SISO_12M_PLCP = 1,
@@ -121,6 +123,7 @@ enum {
 	IWL_RATE_MIMO_INVM_PLCP = IWL_RATE_SISO_INVM_PLCP,
 };
 
+/* MAC header values for bit rates */
 enum {
 	IWL_RATE_6M_IEEE  = 12,
 	IWL_RATE_9M_IEEE  = 18,
@@ -170,13 +173,8 @@ enum {
 #define IWL_MIN_RSSI_VAL                 -100
 #define IWL_MAX_RSSI_VAL                    0
 
-#define IWL_LEGACY_SWITCH_ANTENNA	0
-#define IWL_LEGACY_SWITCH_SISO		1
-#define IWL_LEGACY_SWITCH_MIMO	        2
-
-#define IWL_RS_GOOD_RATIO		12800
-
-#define IWL_ACTION_LIMIT		3
+/* These values specify how many Tx frame attempts before
+ * searching for a new modulation mode */
 #define IWL_LEGACY_FAILURE_LIMIT	160
 #define IWL_LEGACY_SUCCESS_LIMIT	480
 #define IWL_LEGACY_TABLE_COUNT		160
@@ -185,29 +183,44 @@ enum {
 #define IWL_NONE_LEGACY_SUCCESS_LIMIT	4500
 #define IWL_NONE_LEGACY_TABLE_COUNT	1500
 
-#define IWL_RATE_SCALE_SWITCH		(10880)
+/* Success ratio (ACKed / attempted tx frames) values (perfect is 128 * 100) */
+#define IWL_RS_GOOD_RATIO		12800	/* 100% */
+#define IWL_RATE_SCALE_SWITCH		10880	/*  85% */
+#define IWL_RATE_HIGH_TH		10880	/*  85% */
+#define IWL_RATE_INCREASE_TH            8960	/*  70% */
+#define IWL_RATE_DECREASE_TH		1920	/*  15% */
 
+/* possible actions when in legacy mode */
+#define IWL_LEGACY_SWITCH_ANTENNA	0
+#define IWL_LEGACY_SWITCH_SISO		1
+#define IWL_LEGACY_SWITCH_MIMO	        2
+
+/* possible actions when in siso mode */
 #define IWL_SISO_SWITCH_ANTENNA		0
 #define IWL_SISO_SWITCH_MIMO		1
 #define IWL_SISO_SWITCH_GI		2
 
+/* possible actions when in mimo mode */
 #define IWL_MIMO_SWITCH_ANTENNA_A	0
 #define IWL_MIMO_SWITCH_ANTENNA_B	1
 #define IWL_MIMO_SWITCH_GI		2
 
-#define LQ_SIZE		2
+#define IWL_ACTION_LIMIT		3	/* # possible actions */
+
+#define LQ_SIZE		2	/* 2 mode tables:  "Active" and "Search" */
 
 extern const struct iwl4965_rate_info iwl4965_rates[IWL_RATE_COUNT];
 
 enum iwl4965_table_type {
 	LQ_NONE,
-	LQ_G,
+	LQ_G,		/* legacy types */
 	LQ_A,
-	LQ_SISO,
+	LQ_SISO,	/* high-throughput types */
 	LQ_MIMO,
 	LQ_MAX,
 };
 
+/* 4965 has 2 antennas/chains for Tx (but 3 for Rx) */
 enum iwl4965_antenna_type {
 	ANT_NONE,
 	ANT_MAIN,
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 06e437a..9302125 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -483,7 +483,7 @@ struct iwl_ht_info {
 	u8 supported_chan_width;
 	u16 tx_mimo_ps_mode;
 	u8 is_green_field;
-	u8 sgf;
+	u8 sgf;			/* HT_SHORT_GI_* short guard interval */
 	u8 max_amsdu_size;
 	u8 ampdu_factor;
 	u8 mpdu_density;
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 907def3..0bd4f59 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -1504,6 +1504,7 @@ int iwl4965_rate_index_from_plcp(int plcp)
 {
 	int i = 0;
 
+	/* 4965 HT rate format */
 	if (plcp & RATE_MCS_HT_MSK) {
 		i = (plcp & 0xff);
 
@@ -1517,6 +1518,8 @@ int iwl4965_rate_index_from_plcp(int plcp)
 		if ((i >= IWL_FIRST_OFDM_RATE) &&
 		    (i <= IWL_LAST_OFDM_RATE))
 			return i;
+
+	/* 4965 legacy rate format, search for match in table */
 	} else {
 		for (i = 0; i < ARRAY_SIZE(iwl4965_rates); i++)
 			if (iwl4965_rates[i].plcp == (plcp &0xFF))
-- 
1.5.2.2
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
