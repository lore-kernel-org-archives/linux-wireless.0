Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755565Ab1KRIVg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:21:36 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8LaXD015707
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:21:36 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 22/77] iwlegacy: s/window/win/
Date: Fri, 18 Nov 2011 09:21:44 +0100
Message-Id: <1321604559-10707-22-git-send-email-sgruszka@redhat.com> (sfid-20111118_092142_347611_530BE45C)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-3945-rs.c  |  108 ++++++++++----------
 drivers/net/wireless/iwlegacy/iwl-4965-hw.h  |    4 +-
 drivers/net/wireless/iwlegacy/iwl-4965-rs.c  |  134 +++++++++++++-------------
 drivers/net/wireless/iwlegacy/iwl-4965-tx.c  |   14 ++--
 drivers/net/wireless/iwlegacy/iwl-4965.c     |    2 +-
 drivers/net/wireless/iwlegacy/iwl-commands.h |   16 ++--
 drivers/net/wireless/iwlegacy/iwl-core.c     |    6 +-
 drivers/net/wireless/iwlegacy/iwl-dev.h      |   12 +-
 drivers/net/wireless/iwlegacy/iwl-prph.h     |   12 +-
 drivers/net/wireless/iwlegacy/iwl-tx.c       |   10 +-
 10 files changed, 159 insertions(+), 159 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-3945-rs.c b/drivers/net/wireless/iwlegacy/iwl-3945-rs.c
index ebee6c3..5c855e8 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-3945-rs.c
@@ -131,24 +131,24 @@ static u8 il3945_get_rate_index_by_rssi(s32 rssi, enum ieee80211_band band)
 	return tpt_table[index].index;
 }
 
-static void il3945_clear_window(struct il3945_rate_scale_data *window)
+static void il3945_clear_win(struct il3945_rate_scale_data *win)
 {
-	window->data = 0;
-	window->success_counter = 0;
-	window->success_ratio = -1;
-	window->counter = 0;
-	window->average_tpt = IL_INVALID_VALUE;
-	window->stamp = 0;
+	win->data = 0;
+	win->success_counter = 0;
+	win->success_ratio = -1;
+	win->counter = 0;
+	win->average_tpt = IL_INVALID_VALUE;
+	win->stamp = 0;
 }
 
 /**
- * il3945_rate_scale_flush_windows - flush out the rate scale windows
+ * il3945_rate_scale_flush_wins - flush out the rate scale wins
  *
- * Returns the number of windows that have gathered data but were
+ * Returns the number of wins that have gathered data but were
  * not flushed.  If there were any that were not flushed, then
  * reschedule the rate flushing routine.
  */
-static int il3945_rate_scale_flush_windows(struct il3945_rs_sta *rs_sta)
+static int il3945_rate_scale_flush_wins(struct il3945_rs_sta *rs_sta)
 {
 	int unflushed = 0;
 	int i;
@@ -170,7 +170,7 @@ static int il3945_rate_scale_flush_windows(struct il3945_rs_sta *rs_sta)
 			D_RATE("flushing %d samples of rate "
 				       "index %d\n",
 				       rs_sta->win[i].counter, i);
-			il3945_clear_window(&rs_sta->win[i]);
+			il3945_clear_win(&rs_sta->win[i]);
 		} else
 			unflushed++;
 		spin_unlock_irqrestore(&rs_sta->lock, flags);
@@ -193,7 +193,7 @@ static void il3945_bg_rate_scale_flush(unsigned long data)
 
 	D_RATE("enter\n");
 
-	unflushed = il3945_rate_scale_flush_windows(rs_sta);
+	unflushed = il3945_rate_scale_flush_wins(rs_sta);
 
 	spin_lock_irqsave(&rs_sta->lock, flags);
 
@@ -248,14 +248,14 @@ static void il3945_bg_rate_scale_flush(unsigned long data)
 }
 
 /**
- * il3945_collect_tx_data - Update the success/failure sliding window
+ * il3945_collect_tx_data - Update the success/failure sliding win
  *
- * We keep a sliding window of the last 64 packets transmitted
- * at this rate.  window->data contains the bitmask of successful
+ * We keep a sliding win of the last 64 packets transmitted
+ * at this rate.  win->data contains the bitmask of successful
  * packets.
  */
 static void il3945_collect_tx_data(struct il3945_rs_sta *rs_sta,
-				struct il3945_rate_scale_data *window,
+				struct il3945_rate_scale_data *win,
 				int success, int retries, int index)
 {
 	unsigned long flags;
@@ -271,34 +271,34 @@ static void il3945_collect_tx_data(struct il3945_rs_sta *rs_sta,
 
 	/*
 	 * Keep track of only the latest 62 tx frame attempts in this rate's
-	 * history window; anything older isn't really relevant any more.
-	 * If we have filled up the sliding window, drop the oldest attempt;
+	 * history win; anything older isn't really relevant any more.
+	 * If we have filled up the sliding win, drop the oldest attempt;
 	 * if the oldest attempt (highest bit in bitmap) shows "success",
 	 * subtract "1" from the success counter (this is the main reason
 	 * we keep these bitmaps!).
 	 * */
 	while (retries > 0) {
-		if (window->counter >= IL_RATE_MAX_WINDOW) {
+		if (win->counter >= IL_RATE_MAX_WINDOW) {
 
 			/* remove earliest */
-			window->counter = IL_RATE_MAX_WINDOW - 1;
+			win->counter = IL_RATE_MAX_WINDOW - 1;
 
-			if (window->data & (1ULL << (IL_RATE_MAX_WINDOW - 1))) {
-				window->data &= ~(1ULL << (IL_RATE_MAX_WINDOW - 1));
-				window->success_counter--;
+			if (win->data & (1ULL << (IL_RATE_MAX_WINDOW - 1))) {
+				win->data &= ~(1ULL << (IL_RATE_MAX_WINDOW - 1));
+				win->success_counter--;
 			}
 		}
 
 		/* Increment frames-attempted counter */
-		window->counter++;
+		win->counter++;
 
 		/* Shift bitmap by one frame (throw away oldest history),
 		 * OR in "1", and increment "success" if this
 		 * frame was successful. */
-		window->data <<= 1;
+		win->data <<= 1;
 		if (success > 0) {
-			window->success_counter++;
-			window->data |= 0x1;
+			win->success_counter++;
+			win->data |= 0x1;
 			success--;
 		}
 
@@ -306,24 +306,24 @@ static void il3945_collect_tx_data(struct il3945_rs_sta *rs_sta,
 	}
 
 	/* Calculate current success ratio, avoid divide-by-0! */
-	if (window->counter > 0)
-		window->success_ratio = 128 * (100 * window->success_counter)
-					/ window->counter;
+	if (win->counter > 0)
+		win->success_ratio = 128 * (100 * win->success_counter)
+					/ win->counter;
 	else
-		window->success_ratio = IL_INVALID_VALUE;
+		win->success_ratio = IL_INVALID_VALUE;
 
-	fail_count = window->counter - window->success_counter;
+	fail_count = win->counter - win->success_counter;
 
 	/* Calculate average throughput, if we have enough history. */
 	if (fail_count >= IL_RATE_MIN_FAILURE_TH ||
-	    window->success_counter >= IL_RATE_MIN_SUCCESS_TH)
-		window->average_tpt = ((window->success_ratio *
+	    win->success_counter >= IL_RATE_MIN_SUCCESS_TH)
+		win->average_tpt = ((win->success_ratio *
 				rs_sta->expected_tpt[index] + 64) / 128);
 	else
-		window->average_tpt = IL_INVALID_VALUE;
+		win->average_tpt = IL_INVALID_VALUE;
 
-	/* Tag this window as having been updated */
-	window->stamp = jiffies;
+	/* Tag this win as having been updated */
+	win->stamp = jiffies;
 
 	spin_unlock_irqrestore(&rs_sta->lock, flags);
 
@@ -365,7 +365,7 @@ void il3945_rs_rate_init(struct il_priv *il, struct ieee80211_sta *sta, u8 sta_i
 	rs_sta->rate_scale_flush.function = il3945_bg_rate_scale_flush;
 
 	for (i = 0; i < IL_RATE_COUNT_3945; i++)
-		il3945_clear_window(&rs_sta->win[i]);
+		il3945_clear_win(&rs_sta->win[i]);
 
 	/* TODO: what is a good starting rate for STA? About middle? Maybe not
 	 * the lowest or the highest rate.. Could consider using RSSI from
@@ -484,7 +484,7 @@ static void il3945_rs_tx_status(void *il_rate, struct ieee80211_supported_band *
 	last_index = first_index;
 
 	/*
-	 * Update the window for each rate.  We determine which rates
+	 * Update the win for each rate.  We determine which rates
 	 * were Tx'd based on the total number of retries vs. the number
 	 * of retries configured for each rate -- currently set to the
 	 * il value 'retry_rate' vs. rate specific
@@ -517,7 +517,7 @@ static void il3945_rs_tx_status(void *il_rate, struct ieee80211_supported_band *
 	}
 
 
-	/* Update the last index window with success/failure based on ACK */
+	/* Update the last index win with success/failure based on ACK */
 	D_RATE("Update rate %d with %s.\n",
 		       last_index,
 		       (info->flags & IEEE80211_TX_STAT_ACK) ?
@@ -526,7 +526,7 @@ static void il3945_rs_tx_status(void *il_rate, struct ieee80211_supported_band *
 			    &rs_sta->win[last_index],
 			    info->flags & IEEE80211_TX_STAT_ACK, 1, last_index);
 
-	/* We updated the rate scale window -- if its been more than
+	/* We updated the rate scale win -- if its been more than
 	 * flush_time since the last run, schedule the flush
 	 * again */
 	spin_lock_irqsave(&rs_sta->lock, flags);
@@ -636,7 +636,7 @@ static void il3945_rs_get_rate(void *il_r, struct ieee80211_sta *sta,
 	u16 high_low;
 	int index;
 	struct il3945_rs_sta *rs_sta = il_sta;
-	struct il3945_rate_scale_data *window = NULL;
+	struct il3945_rate_scale_data *win = NULL;
 	int current_tpt = IL_INVALID_VALUE;
 	int low_tpt = IL_INVALID_VALUE;
 	int high_tpt = IL_INVALID_VALUE;
@@ -691,29 +691,29 @@ static void il3945_rs_get_rate(void *il_r, struct ieee80211_sta *sta,
 			index = max_rate_idx;
 	}
 
-	window = &(rs_sta->win[index]);
+	win = &(rs_sta->win[index]);
 
-	fail_count = window->counter - window->success_counter;
+	fail_count = win->counter - win->success_counter;
 
 	if (fail_count < IL_RATE_MIN_FAILURE_TH &&
-	    window->success_counter < IL_RATE_MIN_SUCCESS_TH) {
+	    win->success_counter < IL_RATE_MIN_SUCCESS_TH) {
 		spin_unlock_irqrestore(&rs_sta->lock, flags);
 
 		D_RATE("Invalid average_tpt on rate %d: "
 			       "counter: %d, success_counter: %d, "
 			       "expected_tpt is %sNULL\n",
 			       index,
-			       window->counter,
-			       window->success_counter,
+			       win->counter,
+			       win->success_counter,
 			       rs_sta->expected_tpt ? "not " : "");
 
 	   /* Can't calculate this yet; not enough history */
-		window->average_tpt = IL_INVALID_VALUE;
+		win->average_tpt = IL_INVALID_VALUE;
 		goto out;
 
 	}
 
-	current_tpt = window->average_tpt;
+	current_tpt = win->average_tpt;
 
 	high_low = il3945_get_adjacent_rate(rs_sta, index, rate_mask,
 					     sband->band);
@@ -736,7 +736,7 @@ static void il3945_rs_get_rate(void *il_r, struct ieee80211_sta *sta,
 	scale_action = 0;
 
 	/* Low success ratio , need to drop the rate */
-	if (window->success_ratio < IL_RATE_DECREASE_TH || !current_tpt) {
+	if (win->success_ratio < IL_RATE_DECREASE_TH || !current_tpt) {
 		D_RATE("decrease rate because of low success_ratio\n");
 		scale_action = -1;
 	/* No throughput measured yet for adjacent rates,
@@ -744,7 +744,7 @@ static void il3945_rs_get_rate(void *il_r, struct ieee80211_sta *sta,
 	} else if (low_tpt == IL_INVALID_VALUE &&
 		   high_tpt == IL_INVALID_VALUE) {
 
-		if (high != IL_RATE_INVALID && window->success_ratio >= IL_RATE_INCREASE_TH)
+		if (high != IL_RATE_INVALID && win->success_ratio >= IL_RATE_INCREASE_TH)
 			scale_action = 1;
 		else if (low != IL_RATE_INVALID)
 			scale_action = 0;
@@ -768,7 +768,7 @@ static void il3945_rs_get_rate(void *il_r, struct ieee80211_sta *sta,
 			/* High rate has better throughput, Increase
 			 * rate */
 			if (high_tpt > current_tpt &&
-				window->success_ratio >= IL_RATE_INCREASE_TH)
+				win->success_ratio >= IL_RATE_INCREASE_TH)
 				scale_action = 1;
 			else {
 				D_RATE(
@@ -780,7 +780,7 @@ static void il3945_rs_get_rate(void *il_r, struct ieee80211_sta *sta,
 				D_RATE(
 				    "decrease rate because of low tpt\n");
 				scale_action = -1;
-			} else if (window->success_ratio >= IL_RATE_INCREASE_TH) {
+			} else if (win->success_ratio >= IL_RATE_INCREASE_TH) {
 				/* Lower rate has better
 				 * throughput,decrease rate */
 				scale_action = 1;
@@ -791,7 +791,7 @@ static void il3945_rs_get_rate(void *il_r, struct ieee80211_sta *sta,
 	/* Sanity check; asked for decrease, but success rate or throughput
 	 * has been good at old rate.  Don't change it. */
 	if (scale_action == -1 && low != IL_RATE_INVALID &&
-	    (window->success_ratio > IL_RATE_HIGH_TH ||
+	    (win->success_ratio > IL_RATE_HIGH_TH ||
 	     current_tpt > 100 * rs_sta->expected_tpt[low]))
 		scale_action = 0;
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-hw.h b/drivers/net/wireless/iwlegacy/iwl-4965-hw.h
index 21ff694..83748c7 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-hw.h
@@ -773,8 +773,8 @@ enum {
  *
  * Each Tx queue uses a byte-count table containing 320 entries:
  * one 16-bit entry for each of 256 TFDs, plus an additional 64 entries that
- * duplicate the first 64 entries (to avoid wrap-around within a Tx window;
- * max Tx window is 64 TFDs).
+ * duplicate the first 64 entries (to avoid wrap-around within a Tx win;
+ * max Tx win is 64 TFDs).
  *
  * When driver sets up a new TFD, it must also enter the total byte count
  * of the frame to be transmitted into the corresponding entry in the byte
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-rs.c b/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
index e99a20c..5d88a45 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
@@ -46,7 +46,7 @@
 #define IL_NUMBER_TRY      1
 #define IL_HT_NUMBER_TRY   3
 
-#define IL_RATE_MAX_WINDOW		62	/* # tx in history window */
+#define IL_RATE_MAX_WINDOW		62	/* # tx in history win */
 #define IL_RATE_MIN_FAILURE_TH		6	/* min failures to calc tpt */
 #define IL_RATE_MIN_SUCCESS_TH		8	/* min successes to calc tpt */
 
@@ -226,14 +226,14 @@ static inline u8 il4965_rs_extract_rate(u32 rate_n_flags)
 }
 
 static void
-il4965_rs_rate_scale_clear_window(struct il_rate_scale_data *window)
+il4965_rs_rate_scale_clear_win(struct il_rate_scale_data *win)
 {
-	window->data = 0;
-	window->success_counter = 0;
-	window->success_ratio = IL_INVALID_VALUE;
-	window->counter = 0;
-	window->average_tpt = IL_INVALID_VALUE;
-	window->stamp = 0;
+	win->data = 0;
+	win->success_counter = 0;
+	win->success_ratio = IL_INVALID_VALUE;
+	win->counter = 0;
+	win->average_tpt = IL_INVALID_VALUE;
+	win->stamp = 0;
 }
 
 static inline u8 il4965_rs_is_valid_ant(u8 valid_antenna, u8 ant_type)
@@ -408,58 +408,58 @@ il4965_get_expected_tpt(struct il_scale_tbl_info *tbl, int rs_index)
 }
 
 /**
- * il4965_rs_collect_tx_data - Update the success/failure sliding window
+ * il4965_rs_collect_tx_data - Update the success/failure sliding win
  *
- * We keep a sliding window of the last 62 packets transmitted
- * at this rate.  window->data contains the bitmask of successful
+ * We keep a sliding win of the last 62 packets transmitted
+ * at this rate.  win->data contains the bitmask of successful
  * packets.
  */
 static int il4965_rs_collect_tx_data(struct il_scale_tbl_info *tbl,
 			      int scale_index, int attempts, int successes)
 {
-	struct il_rate_scale_data *window = NULL;
+	struct il_rate_scale_data *win = NULL;
 	static const u64 mask = (((u64)1) << (IL_RATE_MAX_WINDOW - 1));
 	s32 fail_count, tpt;
 
 	if (scale_index < 0 || scale_index >= IL_RATE_COUNT)
 		return -EINVAL;
 
-	/* Select window for current tx bit rate */
-	window = &(tbl->win[scale_index]);
+	/* Select win for current tx bit rate */
+	win = &(tbl->win[scale_index]);
 
 	/* Get expected throughput */
 	tpt = il4965_get_expected_tpt(tbl, scale_index);
 
 	/*
 	 * Keep track of only the latest 62 tx frame attempts in this rate's
-	 * history window; anything older isn't really relevant any more.
-	 * If we have filled up the sliding window, drop the oldest attempt;
+	 * history win; anything older isn't really relevant any more.
+	 * If we have filled up the sliding win, drop the oldest attempt;
 	 * if the oldest attempt (highest bit in bitmap) shows "success",
 	 * subtract "1" from the success counter (this is the main reason
 	 * we keep these bitmaps!).
 	 */
 	while (attempts > 0) {
-		if (window->counter >= IL_RATE_MAX_WINDOW) {
+		if (win->counter >= IL_RATE_MAX_WINDOW) {
 
 			/* remove earliest */
-			window->counter = IL_RATE_MAX_WINDOW - 1;
+			win->counter = IL_RATE_MAX_WINDOW - 1;
 
-			if (window->data & mask) {
-				window->data &= ~mask;
-				window->success_counter--;
+			if (win->data & mask) {
+				win->data &= ~mask;
+				win->success_counter--;
 			}
 		}
 
 		/* Increment frames-attempted counter */
-		window->counter++;
+		win->counter++;
 
 		/* Shift bitmap by one frame to throw away oldest history */
-		window->data <<= 1;
+		win->data <<= 1;
 
 		/* Mark the most recent #successes attempts as successful */
 		if (successes > 0) {
-			window->success_counter++;
-			window->data |= 0x1;
+			win->success_counter++;
+			win->data |= 0x1;
 			successes--;
 		}
 
@@ -467,23 +467,23 @@ static int il4965_rs_collect_tx_data(struct il_scale_tbl_info *tbl,
 	}
 
 	/* Calculate current success ratio, avoid divide-by-0! */
-	if (window->counter > 0)
-		window->success_ratio = 128 * (100 * window->success_counter)
-					/ window->counter;
+	if (win->counter > 0)
+		win->success_ratio = 128 * (100 * win->success_counter)
+					/ win->counter;
 	else
-		window->success_ratio = IL_INVALID_VALUE;
+		win->success_ratio = IL_INVALID_VALUE;
 
-	fail_count = window->counter - window->success_counter;
+	fail_count = win->counter - win->success_counter;
 
 	/* Calculate average throughput, if we have enough history. */
 	if (fail_count >= IL_RATE_MIN_FAILURE_TH ||
-	    window->success_counter >= IL_RATE_MIN_SUCCESS_TH)
-		window->average_tpt = (window->success_ratio * tpt + 64) / 128;
+	    win->success_counter >= IL_RATE_MIN_SUCCESS_TH)
+		win->average_tpt = (win->success_ratio * tpt + 64) / 128;
 	else
-		window->average_tpt = IL_INVALID_VALUE;
+		win->average_tpt = IL_INVALID_VALUE;
 
-	/* Tag this window as having been updated */
-	window->stamp = jiffies;
+	/* Tag this win as having been updated */
+	win->stamp = jiffies;
 
 	return 0;
 }
@@ -817,7 +817,7 @@ il4965_rs_tx_status(void *il_r, struct ieee80211_supported_band *sband,
 	struct il_rxon_context *ctx = sta_priv->common.ctx;
 
 	D_RATE(
-		"get frame ack response, update rate scale window\n");
+		"get frame ack response, update rate scale win\n");
 
 	/* Treat uninitialized rate scaling data same as non-existing. */
 	if (!lq_sta) {
@@ -1284,7 +1284,7 @@ static int il4965_rs_move_legacy_other(struct il_priv *il,
 	struct il_scale_tbl_info *tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
 	struct il_scale_tbl_info *search_tbl =
 				&(lq_sta->lq_info[(1 - lq_sta->active_tbl)]);
-	struct il_rate_scale_data *window = &(tbl->win[index]);
+	struct il_rate_scale_data *win = &(tbl->win[index]);
 	u32 sz = (sizeof(struct il_scale_tbl_info) -
 		  (sizeof(struct il_rate_scale_data) * IL_RATE_COUNT));
 	u8 start_action;
@@ -1310,7 +1310,7 @@ static int il4965_rs_move_legacy_other(struct il_priv *il,
 				break;
 
 			/* Don't change antenna if success has been great */
-			if (window->success_ratio >= IL_RS_GOOD_RATIO)
+			if (win->success_ratio >= IL_RS_GOOD_RATIO)
 				break;
 
 			/* Set up search table to try other antenna */
@@ -1401,7 +1401,7 @@ static int il4965_rs_move_siso_to_other(struct il_priv *il,
 	struct il_scale_tbl_info *tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
 	struct il_scale_tbl_info *search_tbl =
 				&(lq_sta->lq_info[(1 - lq_sta->active_tbl)]);
-	struct il_rate_scale_data *window = &(tbl->win[index]);
+	struct il_rate_scale_data *win = &(tbl->win[index]);
 	struct ieee80211_sta_ht_cap *ht_cap = &sta->ht_cap;
 	u32 sz = (sizeof(struct il_scale_tbl_info) -
 		  (sizeof(struct il_rate_scale_data) * IL_RATE_COUNT));
@@ -1425,7 +1425,7 @@ static int il4965_rs_move_siso_to_other(struct il_priv *il,
 						tx_chains_num <= 2))
 				break;
 
-			if (window->success_ratio >= IL_RS_GOOD_RATIO)
+			if (win->success_ratio >= IL_RS_GOOD_RATIO)
 				break;
 
 			memcpy(search_tbl, tbl, sz);
@@ -1523,7 +1523,7 @@ static int il4965_rs_move_mimo2_to_other(struct il_priv *il,
 	struct il_scale_tbl_info *tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
 	struct il_scale_tbl_info *search_tbl =
 				&(lq_sta->lq_info[(1 - lq_sta->active_tbl)]);
-	struct il_rate_scale_data *window = &(tbl->win[index]);
+	struct il_rate_scale_data *win = &(tbl->win[index]);
 	struct ieee80211_sta_ht_cap *ht_cap = &sta->ht_cap;
 	u32 sz = (sizeof(struct il_scale_tbl_info) -
 		  (sizeof(struct il_rate_scale_data) * IL_RATE_COUNT));
@@ -1544,7 +1544,7 @@ static int il4965_rs_move_mimo2_to_other(struct il_priv *il,
 			if (tx_chains_num <= 2)
 				break;
 
-			if (window->success_ratio >= IL_RS_GOOD_RATIO)
+			if (win->success_ratio >= IL_RS_GOOD_RATIO)
 				break;
 
 			memcpy(search_tbl, tbl, sz);
@@ -1704,7 +1704,7 @@ il4965_rs_stay_in_table(struct il_lq_sta *lq_sta, bool force_search)
 				D_RATE(
 					"LQ: stay in table clear win\n");
 				for (i = 0; i < IL_RATE_COUNT; i++)
-					il4965_rs_rate_scale_clear_window(
+					il4965_rs_rate_scale_clear_win(
 						&(tbl->win[i]));
 			}
 		}
@@ -1714,7 +1714,7 @@ il4965_rs_stay_in_table(struct il_lq_sta *lq_sta, bool force_search)
 		 * "search" table). */
 		if (!lq_sta->stay_in_tbl) {
 			for (i = 0; i < IL_RATE_COUNT; i++)
-				il4965_rs_rate_scale_clear_window(
+				il4965_rs_rate_scale_clear_win(
 							&(tbl->win[i]));
 		}
 	}
@@ -1756,7 +1756,7 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 	int high = IL_RATE_INVALID;
 	int index;
 	int i;
-	struct il_rate_scale_data *window = NULL;
+	struct il_rate_scale_data *win = NULL;
 	int current_tpt = IL_INVALID_VALUE;
 	int low_tpt = IL_INVALID_VALUE;
 	int high_tpt = IL_INVALID_VALUE;
@@ -1859,7 +1859,7 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 		return;
 	}
 
-	/* Get expected throughput table and history window for current rate */
+	/* Get expected throughput table and history win for current rate */
 	if (!tbl->expected_tpt) {
 		IL_ERR("tbl->expected_tpt is NULL\n");
 		return;
@@ -1870,11 +1870,11 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 	    lq_sta->max_rate_idx < index) {
 		index = lq_sta->max_rate_idx;
 		update_lq = 1;
-		window = &(tbl->win[index]);
+		win = &(tbl->win[index]);
 		goto lq_update;
 	}
 
-	window = &(tbl->win[index]);
+	win = &(tbl->win[index]);
 
 	/*
 	 * If there is not enough history to calculate actual average
@@ -1883,15 +1883,15 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 	 * Set up new rate table in uCode only if old rate is not supported
 	 * in current association (use new rate found above).
 	 */
-	fail_count = window->counter - window->success_counter;
+	fail_count = win->counter - win->success_counter;
 	if (fail_count < IL_RATE_MIN_FAILURE_TH &&
-	    window->success_counter < IL_RATE_MIN_SUCCESS_TH) {
+	    win->success_counter < IL_RATE_MIN_SUCCESS_TH) {
 		D_RATE("LQ: still below TH. succ=%d total=%d "
 			       "for index %d\n",
-			       window->success_counter, window->counter, index);
+			       win->success_counter, win->counter, index);
 
 		/* Can't calculate this yet; not enough history */
-		window->average_tpt = IL_INVALID_VALUE;
+		win->average_tpt = IL_INVALID_VALUE;
 
 		/* Should we stay with this modulation mode,
 		 * or search for a new one? */
@@ -1901,11 +1901,11 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 	}
 	/* Else we have enough samples; calculate estimate of
 	 * actual average throughput */
-	if (window->average_tpt != ((window->success_ratio *
+	if (win->average_tpt != ((win->success_ratio *
 			tbl->expected_tpt[index] + 64) / 128)) {
 		IL_ERR(
 			 "expected_tpt should have been calculated by now\n");
-		window->average_tpt = ((window->success_ratio *
+		win->average_tpt = ((win->success_ratio *
 					tbl->expected_tpt[index] + 64) / 128);
 	}
 
@@ -1914,12 +1914,12 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 		/* If good success, continue using the "search" mode;
 		 * no need to send new link quality command, since we're
 		 * continuing to use the setup that we've been trying. */
-		if (window->average_tpt > lq_sta->last_tpt) {
+		if (win->average_tpt > lq_sta->last_tpt) {
 
 			D_RATE("LQ: SWITCHING TO NEW TABLE "
 					"suc=%d cur-tpt=%d old-tpt=%d\n",
-					window->success_ratio,
-					window->average_tpt,
+					win->success_ratio,
+					win->average_tpt,
 					lq_sta->last_tpt);
 
 			if (!is_legacy(tbl->lq_type))
@@ -1927,15 +1927,15 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 
 			/* Swap tables; "search" becomes "active" */
 			lq_sta->active_tbl = active_tbl;
-			current_tpt = window->average_tpt;
+			current_tpt = win->average_tpt;
 
 		/* Else poor success; go back to mode in "active" table */
 		} else {
 
 			D_RATE("LQ: GOING BACK TO THE OLD TABLE "
 					"suc=%d cur-tpt=%d old-tpt=%d\n",
-					window->success_ratio,
-					window->average_tpt,
+					win->success_ratio,
+					win->average_tpt,
 					lq_sta->last_tpt);
 
 			/* Nullify "search" table */
@@ -1973,10 +1973,10 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 	    lq_sta->max_rate_idx < high)
 		high = IL_RATE_INVALID;
 
-	sr = window->success_ratio;
+	sr = win->success_ratio;
 
 	/* Collect measured throughputs for current and adjacent rates */
-	current_tpt = window->average_tpt;
+	current_tpt = win->average_tpt;
 	if (low != IL_RATE_INVALID)
 		low_tpt = tbl->win[low].average_tpt;
 	if (high != IL_RATE_INVALID)
@@ -2082,7 +2082,7 @@ lq_update:
 	 * 3)  Allowing a new search
 	 */
 	if (!update_lq && !done_search && !lq_sta->stay_in_tbl &&
-	    window->counter) {
+	    win->counter) {
 		/* Save current throughput to compare with "search" throughput*/
 		lq_sta->last_tpt = current_tpt;
 
@@ -2103,7 +2103,7 @@ lq_update:
 			/* Access the "search" table, clear its history. */
 			tbl = &(lq_sta->lq_info[(1 - lq_sta->active_tbl)]);
 			for (i = 0; i < IL_RATE_COUNT; i++)
-				il4965_rs_rate_scale_clear_window(
+				il4965_rs_rate_scale_clear_win(
 							&(tbl->win[i]));
 
 			/* Use new "search" start rate */
@@ -2314,7 +2314,7 @@ static void *il4965_rs_alloc_sta(void *il_rate, struct ieee80211_sta *sta,
 	struct il_priv *il;
 
 	il = (struct il_priv *)il_rate;
-	D_RATE("create station rate scale window\n");
+	D_RATE("create station rate scale win\n");
 
 	lq_sta = &sta_priv->lq_sta;
 
@@ -2346,14 +2346,14 @@ il4965_rs_rate_init(struct il_priv *il,
 
 	for (j = 0; j < LQ_SIZE; j++)
 		for (i = 0; i < IL_RATE_COUNT; i++)
-			il4965_rs_rate_scale_clear_window(
+			il4965_rs_rate_scale_clear_win(
 					&lq_sta->lq_info[j].win[i]);
 
 	lq_sta->flush_timer = 0;
 	lq_sta->supp_rates = sta->supp_rates[sband->band];
 	for (j = 0; j < LQ_SIZE; j++)
 		for (i = 0; i < IL_RATE_COUNT; i++)
-			il4965_rs_rate_scale_clear_window(
+			il4965_rs_rate_scale_clear_win(
 					&lq_sta->lq_info[j].win[i]);
 
 	D_RATE("LQ:"
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-tx.c b/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
index dff48e8..68c86e0 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
@@ -834,7 +834,7 @@ static int il4965_txq_agg_enable(struct il_priv *il, int txq_id,
 	il->txq[txq_id].q.write_ptr = (ssn_idx & 0xff);
 	il4965_set_wr_ptrs(il, txq_id, ssn_idx);
 
-	/* Set up Tx window size and frame limit for this queue */
+	/* Set up Tx win size and frame limit for this queue */
 	il_write_targ_mem(il,
 		il->scd_base_addr + IL49_SCD_CONTEXT_QUEUE_OFFSET(txq_id),
 		(SCD_WIN_SIZE << IL49_SCD_QUEUE_CTX_REG1_WIN_SIZE_POS) &
@@ -1171,7 +1171,7 @@ static int il4965_tx_status_reply_compressed_ba(struct il_priv *il,
 	D_TX_REPLY("BA %d %d\n", agg->start_idx,
 							ba_resp->seq_ctl);
 
-	/* Calculate shift to align block-ack bits with our Tx window bits */
+	/* Calculate shift to align block-ack bits with our Tx win bits */
 	sh = agg->start_idx - SEQ_TO_INDEX(seq_ctl >> 4);
 	if (sh < 0) /* tbw something is wrong with indices */
 		sh += 0x100;
@@ -1260,8 +1260,8 @@ void il4965_rx_reply_compressed_ba(struct il_priv *il,
 	/* "flow" corresponds to Tx queue */
 	u16 scd_flow = le16_to_cpu(ba_resp->scd_flow);
 
-	/* "ssn" is start of block-ack Tx window, corresponds to index
-	 * (in Tx queue's circular buffer) of first TFD/frame in window */
+	/* "ssn" is start of block-ack Tx win, corresponds to index
+	 * (in Tx queue's circular buffer) of first TFD/frame in win */
 	u16 ba_resp_scd_ssn = le16_to_cpu(ba_resp->scd_ssn);
 
 	if (scd_flow >= il->hw_params.max_txq_num) {
@@ -1287,7 +1287,7 @@ void il4965_rx_reply_compressed_ba(struct il_priv *il,
 		return;
 	}
 
-	/* Find index just before block-ack window */
+	/* Find index just before block-ack win */
 	index = il_queue_dec_wrap(ba_resp_scd_ssn & 0xff, txq->q.n_bd);
 
 	spin_lock_irqsave(&il->sta_lock, flags);
@@ -1309,11 +1309,11 @@ void il4965_rx_reply_compressed_ba(struct il_priv *il,
 			   agg->start_idx,
 			   (unsigned long long)agg->bitmap);
 
-	/* Update driver's record of ACK vs. not for each frame in window */
+	/* Update driver's record of ACK vs. not for each frame in win */
 	il4965_tx_status_reply_compressed_ba(il, agg, ba_resp);
 
 	/* Release all TFDs before the SSN, i.e. all TFDs in front of
-	 * block-ack window (we assume that they've been successfully
+	 * block-ack win (we assume that they've been successfully
 	 * transmitted ... if not, it's too late anyway). */
 	if (txq->q.read_ptr != (ba_resp_scd_ssn & 0xff)) {
 		/* calculate mac80211 ampdu sw queue to wake */
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965.c b/drivers/net/wireless/iwlegacy/iwl-4965.c
index 9cfc140..f62475d 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965.c
@@ -1649,7 +1649,7 @@ static int il4965_tx_status_reply_tx(struct il_priv *il,
 		u64 bitmap = 0;
 		int start = agg->start_idx;
 
-		/* Construct bit-map of pending frames within Tx window */
+		/* Construct bit-map of pending frames within Tx win */
 		for (i = 0; i < agg->frame_count; i++) {
 			u16 sc;
 			status = le16_to_cpu(frame_status[i].status);
diff --git a/drivers/net/wireless/iwlegacy/iwl-commands.h b/drivers/net/wireless/iwlegacy/iwl-commands.h
index ea6c0f5..d1876d0 100644
--- a/drivers/net/wireless/iwlegacy/iwl-commands.h
+++ b/drivers/net/wireless/iwlegacy/iwl-commands.h
@@ -754,7 +754,7 @@ struct il4965_rxon_assoc_cmd {
 struct il_rxon_time_cmd {
 	__le64 timestamp;
 	__le16 beacon_interval;
-	__le16 atim_window;
+	__le16 atim_win;
 	__le32 beacon_init_val;
 	__le16 listen_interval;
 	u8 dtim_period;
@@ -803,15 +803,15 @@ struct il_csa_notification {
  * struct il_ac_qos -- QOS timing params for REPLY_QOS_PARAM
  * One for each of 4 EDCA access categories in struct il_qosparam_cmd
  *
- * @cw_min: Contention window, start value in numbers of slots.
+ * @cw_min: Contention win, start value in numbers of slots.
  *          Should be a power-of-2, minus 1.  Device's default is 0x0f.
- * @cw_max: Contention window, max value in numbers of slots.
+ * @cw_max: Contention win, max value in numbers of slots.
  *          Should be a power-of-2, minus 1.  Device's default is 0x3f.
  * @aifsn:  Number of slots in Arbitration Interframe Space (before
  *          performing random backoff timing prior to Tx).  Device default 1.
  * @edca_txop:  Length of Tx opportunity, in uSecs.  Device default is 0.
  *
- * Device will automatically increase contention window by (2*CW) + 1 for each
+ * Device will automatically increase contention win by (2*CW) + 1 for each
  * transmission retry.  Device uses cw_max as a bit mask, ANDed with new CW
  * value, to cap the CW value.
  */
@@ -1948,13 +1948,13 @@ struct il_link_qual_agg_params {
  * speculative mode as the new current active mode.
  *
  * Each history set contains, separately for each possible rate, data for a
- * sliding window of the 62 most recent tx attempts at that rate.  The data
+ * sliding win of the 62 most recent tx attempts at that rate.  The data
  * includes a shifting bitmap of success(1)/failure(0), and sums of successful
  * and attempted frames, from which the driver can additionally calculate a
  * success ratio (success / attempted) and number of failures
- * (attempted - success), and control the size of the window (attempted).
+ * (attempted - success), and control the size of the win (attempted).
  * The driver uses the bit map to remove successes from the success sum, as
- * the oldest tx attempts fall out of the window.
+ * the oldest tx attempts fall out of the win.
  *
  * When the 4965 device makes multiple tx attempts for a given frame, each
  * attempt might be at a different rate, and have different modulation
@@ -2017,7 +2017,7 @@ struct il_link_qual_agg_params {
  *
  * 6)  Re-evaluate the rate after each tx frame.  If working with block-
  *     acknowledge, history and stats may be calculated for the entire
- *     block (including prior history that fits within the history windows),
+ *     block (including prior history that fits within the history wins),
  *     before re-evaluation.
  *
  * FINDING BEST STARTING MODULATION MODE:
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.c b/drivers/net/wireless/iwlegacy/iwl-core.c
index 475bcac..6742a65 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.c
+++ b/drivers/net/wireless/iwlegacy/iwl-core.c
@@ -380,10 +380,10 @@ il_send_rxon_timing(struct il_priv *il, struct il_rxon_context *ctx)
 	beacon_int = vif ? vif->bss_conf.beacon_int : 0;
 
 	/*
-	 * TODO: For IBSS we need to get atim_window from mac80211,
+	 * TODO: For IBSS we need to get atim_win from mac80211,
 	 *	 for now just always use 0
 	 */
-	ctx->timing.atim_window = 0;
+	ctx->timing.atim_win = 0;
 
 	beacon_int = il_adjust_beacon_interval(beacon_int,
 			il->hw_params.max_beacon_itrvl * TIME_UNIT);
@@ -400,7 +400,7 @@ il_send_rxon_timing(struct il_priv *il, struct il_rxon_context *ctx)
 			"beacon interval %d beacon timer %d beacon tim %d\n",
 			le16_to_cpu(ctx->timing.beacon_interval),
 			le32_to_cpu(ctx->timing.beacon_init_val),
-			le16_to_cpu(ctx->timing.atim_window));
+			le16_to_cpu(ctx->timing.atim_win));
 
 	return il_send_cmd_pdu(il, ctx->rxon_timing_cmd,
 				sizeof(ctx->timing), &ctx->timing);
diff --git a/drivers/net/wireless/iwlegacy/iwl-dev.h b/drivers/net/wireless/iwlegacy/iwl-dev.h
index 4388538..18dd253 100644
--- a/drivers/net/wireless/iwlegacy/iwl-dev.h
+++ b/drivers/net/wireless/iwlegacy/iwl-dev.h
@@ -129,7 +129,7 @@ struct il_queue {
 	int read_ptr;         /* last used entry (index) host_r*/
 	/* use for monitoring and recovering the stuck queue */
 	dma_addr_t dma_addr;   /* physical addr for BD's */
-	int n_window;	       /* safe queue window */
+	int n_win;	       /* safe queue win */
 	u32 id;
 	int low_mark;	       /* low watermark, resume queue if free
 				* space more than this */
@@ -377,9 +377,9 @@ struct il_rx_queue {
  * @txq_id: Tx queue used for Tx attempt
  * @frame_count: # frames attempted by Tx command
  * @wait_for_ba: Expect block-ack before next Tx reply
- * @start_idx: Index of 1st Transmit Frame Descriptor (TFD) in Tx window
- * @bitmap0: Low order bitmap, one bit for each frame pending ACK in Tx window
- * @bitmap1: High order, one bit for each frame pending ACK in Tx window
+ * @start_idx: Index of 1st Transmit Frame Descriptor (TFD) in Tx win
+ * @bitmap0: Low order bitmap, one bit for each frame pending ACK in Tx win
+ * @bitmap1: High order, one bit for each frame pending ACK in Tx win
  * @rate_n_flags: Rate at which Tx was attempted
  *
  * If REPLY_TX indicates that aggregation was attempted, driver must wait
@@ -645,10 +645,10 @@ static inline u8 il_get_cmd_index(struct il_queue *q, u32 index,
 	 * the big buffer at end of command array
 	 */
 	if (is_huge)
-		return q->n_window;	/* must be power of 2 */
+		return q->n_win;	/* must be power of 2 */
 
 	/* Otherwise, use normal size buffers */
-	return index & (q->n_window - 1);
+	return index & (q->n_win - 1);
 }
 
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-prph.h b/drivers/net/wireless/iwlegacy/iwl-prph.h
index caa3837..200f295 100644
--- a/drivers/net/wireless/iwlegacy/iwl-prph.h
+++ b/drivers/net/wireless/iwlegacy/iwl-prph.h
@@ -274,13 +274,13 @@
  * The driver sets up each queue to work in one of two modes:
  *
  * 1)  Scheduler-Ack, in which the scheduler automatically supports a
- *     block-ack (BA) window of up to 64 TFDs.  In this mode, each queue
+ *     block-ack (BA) win of up to 64 TFDs.  In this mode, each queue
  *     contains TFDs for a unique combination of Recipient Address (RA)
  *     and Traffic Identifier (TID), that is, traffic of a given
  *     Quality-Of-Service (QOS) priority, destined for a single station.
  *
  *     In scheduler-ack mode, the scheduler keeps track of the Tx status of
- *     each frame within the BA window, including whether it's been transmitted,
+ *     each frame within the BA win, including whether it's been transmitted,
  *     and whether it's been acknowledged by the receiving station.  The device
  *     automatically processes block-acks received from the receiving STA,
  *     and reschedules un-acked frames to be retransmitted (successful
@@ -316,7 +316,7 @@
  */
 
 /**
- * Max Tx window size is the max number of contiguous TFDs that the scheduler
+ * Max Tx win size is the max number of contiguous TFDs that the scheduler
  * can keep track of at one time when creating block-ack chains of frames.
  * Note that "64" matches the number of ack bits in a block-ack packet.
  * Driver should use SCD_WIN_SIZE and SCD_FRAME_LIMIT values to initialize
@@ -377,7 +377,7 @@
 /*
  * Queue (x) Read Pointers (indexes, really!), one for each Tx queue.
  * For FIFO mode, index indicates next frame to transmit.
- * For Scheduler-ACK mode, index indicates first frame in Tx window.
+ * For Scheduler-ACK mode, index indicates first frame in Tx win.
  * Initialized by driver, updated by scheduler.
  */
 #define IL49_SCD_QUEUE_RDPTR(x)  (IL49_SCD_START_OFFSET + 0x64 + (x) * 4)
@@ -414,7 +414,7 @@
  *        Driver should init to "1" for aggregation mode, or "0" otherwise.
  *   7-6: Driver should init to "0"
  *     5: Window Size Left; indicates whether scheduler can request
- *        another TFD, based on window size, etc.  Driver should init
+ *        another TFD, based on win size, etc.  Driver should init
  *        this bit to "1" for aggregation mode, or "0" for non-agg.
  *   4-1: Tx FIFO to use (range 0-7).
  *     0: Queue is active (1), not active (0).
@@ -460,7 +460,7 @@
  * each queue's entry as follows:
  *
  * LS Dword bit fields:
- *  0-06:  Max Tx window size for Scheduler-ACK.  Driver should init to 64.
+ *  0-06:  Max Tx win size for Scheduler-ACK.  Driver should init to 64.
  *
  * MS Dword bit fields:
  * 16-22:  Frame limit.  Driver should init to 10 (0xa).
diff --git a/drivers/net/wireless/iwlegacy/iwl-tx.c b/drivers/net/wireless/iwlegacy/iwl-tx.c
index 2e95b78..b9c417c 100644
--- a/drivers/net/wireless/iwlegacy/iwl-tx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-tx.c
@@ -165,7 +165,7 @@ void il_cmd_queue_unmap(struct il_priv *il)
 		q->read_ptr = il_queue_inc_wrap(q->read_ptr, q->n_bd);
 	}
 
-	i = q->n_window;
+	i = q->n_win;
 	if (txq->meta[i].flags & CMD_MAPPED) {
 		pci_unmap_single(il->pci_dev,
 				 dma_unmap_addr(&txq->meta[i], mapping),
@@ -243,7 +243,7 @@ int il_queue_space(const struct il_queue *q)
 		s -= q->n_bd;
 
 	if (s <= 0)
-		s += q->n_window;
+		s += q->n_win;
 	/* keep some reserve to not confuse empty and full situations */
 	s -= 2;
 	if (s < 0)
@@ -260,7 +260,7 @@ static int il_queue_init(struct il_priv *il, struct il_queue *q,
 			  int count, int slots_num, u32 id)
 {
 	q->n_bd = count;
-	q->n_window = slots_num;
+	q->n_win = slots_num;
 	q->id = id;
 
 	/* count must be power-of-two size, otherwise il_queue_inc_wrap
@@ -271,11 +271,11 @@ static int il_queue_init(struct il_priv *il, struct il_queue *q,
 	 * il_get_cmd_index is broken. */
 	BUG_ON(!is_power_of_2(slots_num));
 
-	q->low_mark = q->n_window / 4;
+	q->low_mark = q->n_win / 4;
 	if (q->low_mark < 4)
 		q->low_mark = 4;
 
-	q->high_mark = q->n_window / 8;
+	q->high_mark = q->n_win / 8;
 	if (q->high_mark < 2)
 		q->high_mark = 2;
 
-- 
1.7.1

