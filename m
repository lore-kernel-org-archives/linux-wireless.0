Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755565Ab1KRIVj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:21:39 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8Ldca022626
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:21:39 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 23/77] iwlegacy: s/IL_RATE/RATE/
Date: Fri, 18 Nov 2011 09:21:45 +0100
Message-Id: <1321604559-10707-23-git-send-email-sgruszka@redhat.com> (sfid-20111118_092158_348795_79013B9E)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-3945-rs.c   |  160 ++++++++--------
 drivers/net/wireless/iwlegacy/iwl-3945.c      |   92 +++++-----
 drivers/net/wireless/iwlegacy/iwl-3945.h      |    4 +-
 drivers/net/wireless/iwlegacy/iwl-4965-lib.c  |    8 +-
 drivers/net/wireless/iwlegacy/iwl-4965-rs.c   |  180 +++++++++---------
 drivers/net/wireless/iwlegacy/iwl-4965-sta.c  |    4 +-
 drivers/net/wireless/iwlegacy/iwl-4965-tx.c   |    2 +-
 drivers/net/wireless/iwlegacy/iwl-commands.h  |    2 +-
 drivers/net/wireless/iwlegacy/iwl-core.c      |   16 +-
 drivers/net/wireless/iwlegacy/iwl-legacy-rs.h |  244 ++++++++++++------------
 drivers/net/wireless/iwlegacy/iwl-sta.c       |    2 +-
 drivers/net/wireless/iwlegacy/iwl3945-base.c  |    8 +-
 drivers/net/wireless/iwlegacy/iwl4965-base.c  |    6 +-
 13 files changed, 364 insertions(+), 364 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-3945-rs.c b/drivers/net/wireless/iwlegacy/iwl-3945-rs.c
index 5c855e8..92fa436 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-3945-rs.c
@@ -42,19 +42,19 @@
 
 #define RS_NAME "iwl-3945-rs"
 
-static s32 il3945_expected_tpt_g[IL_RATE_COUNT_3945] = {
+static s32 il3945_expected_tpt_g[RATE_COUNT_3945] = {
 	7, 13, 35, 58, 0, 0, 76, 104, 130, 168, 191, 202
 };
 
-static s32 il3945_expected_tpt_g_prot[IL_RATE_COUNT_3945] = {
+static s32 il3945_expected_tpt_g_prot[RATE_COUNT_3945] = {
 	7, 13, 35, 58, 0, 0, 0, 80, 93, 113, 123, 125
 };
 
-static s32 il3945_expected_tpt_a[IL_RATE_COUNT_3945] = {
+static s32 il3945_expected_tpt_a[RATE_COUNT_3945] = {
 	0, 0, 0, 0, 40, 57, 72, 98, 121, 154, 177, 186
 };
 
-static s32 il3945_expected_tpt_b[IL_RATE_COUNT_3945] = {
+static s32 il3945_expected_tpt_b[RATE_COUNT_3945] = {
 	7, 13, 35, 58, 0, 0, 0, 0, 0, 0, 0, 0
 };
 
@@ -64,39 +64,39 @@ struct il3945_tpt_entry {
 };
 
 static struct il3945_tpt_entry il3945_tpt_table_a[] = {
-	{-60, IL_RATE_54M_INDEX},
-	{-64, IL_RATE_48M_INDEX},
-	{-72, IL_RATE_36M_INDEX},
-	{-80, IL_RATE_24M_INDEX},
-	{-84, IL_RATE_18M_INDEX},
-	{-85, IL_RATE_12M_INDEX},
-	{-87, IL_RATE_9M_INDEX},
-	{-89, IL_RATE_6M_INDEX}
+	{-60, RATE_54M_INDEX},
+	{-64, RATE_48M_INDEX},
+	{-72, RATE_36M_INDEX},
+	{-80, RATE_24M_INDEX},
+	{-84, RATE_18M_INDEX},
+	{-85, RATE_12M_INDEX},
+	{-87, RATE_9M_INDEX},
+	{-89, RATE_6M_INDEX}
 };
 
 static struct il3945_tpt_entry il3945_tpt_table_g[] = {
-	{-60, IL_RATE_54M_INDEX},
-	{-64, IL_RATE_48M_INDEX},
-	{-68, IL_RATE_36M_INDEX},
-	{-80, IL_RATE_24M_INDEX},
-	{-84, IL_RATE_18M_INDEX},
-	{-85, IL_RATE_12M_INDEX},
-	{-86, IL_RATE_11M_INDEX},
-	{-88, IL_RATE_5M_INDEX},
-	{-90, IL_RATE_2M_INDEX},
-	{-92, IL_RATE_1M_INDEX}
+	{-60, RATE_54M_INDEX},
+	{-64, RATE_48M_INDEX},
+	{-68, RATE_36M_INDEX},
+	{-80, RATE_24M_INDEX},
+	{-84, RATE_18M_INDEX},
+	{-85, RATE_12M_INDEX},
+	{-86, RATE_11M_INDEX},
+	{-88, RATE_5M_INDEX},
+	{-90, RATE_2M_INDEX},
+	{-92, RATE_1M_INDEX}
 };
 
-#define IL_RATE_MAX_WINDOW          62
-#define IL_RATE_FLUSH		(3*HZ)
-#define IL_RATE_WIN_FLUSH       (HZ/2)
+#define RATE_MAX_WINDOW          62
+#define RATE_FLUSH		(3*HZ)
+#define RATE_WIN_FLUSH       (HZ/2)
 #define IL39_RATE_HIGH_TH          11520
 #define IL_SUCCESS_UP_TH	   8960
 #define IL_SUCCESS_DOWN_TH	  10880
-#define IL_RATE_MIN_FAILURE_TH       6
-#define IL_RATE_MIN_SUCCESS_TH       8
-#define IL_RATE_DECREASE_TH       1920
-#define IL_RATE_RETRY_TH	     15
+#define RATE_MIN_FAILURE_TH       6
+#define RATE_MIN_SUCCESS_TH       8
+#define RATE_DECREASE_TH       1920
+#define RATE_RETRY_TH	     15
 
 static u8 il3945_get_rate_index_by_rssi(s32 rssi, enum ieee80211_band band)
 {
@@ -157,16 +157,16 @@ static int il3945_rate_scale_flush_wins(struct il3945_rs_sta *rs_sta)
 
 	/*
 	 * For each rate, if we have collected data on that rate
-	 * and it has been more than IL_RATE_WIN_FLUSH
+	 * and it has been more than RATE_WIN_FLUSH
 	 * since we flushed, clear out the gathered stats
 	 */
-	for (i = 0; i < IL_RATE_COUNT_3945; i++) {
+	for (i = 0; i < RATE_COUNT_3945; i++) {
 		if (!rs_sta->win[i].counter)
 			continue;
 
 		spin_lock_irqsave(&rs_sta->lock, flags);
 		if (time_after(jiffies, rs_sta->win[i].stamp +
-			       IL_RATE_WIN_FLUSH)) {
+			       RATE_WIN_FLUSH)) {
 			D_RATE("flushing %d samples of rate "
 				       "index %d\n",
 				       rs_sta->win[i].counter, i);
@@ -179,8 +179,8 @@ static int il3945_rate_scale_flush_wins(struct il3945_rs_sta *rs_sta)
 	return unflushed;
 }
 
-#define IL_RATE_FLUSH_MAX              5000	/* msec */
-#define IL_RATE_FLUSH_MIN              50	/* msec */
+#define RATE_FLUSH_MAX              5000	/* msec */
+#define RATE_FLUSH_MIN              50	/* msec */
 #define IL_AVERAGE_PACKETS             1500
 
 static void il3945_bg_rate_scale_flush(unsigned long data)
@@ -217,12 +217,12 @@ static void il3945_bg_rate_scale_flush(unsigned long data)
 
 		if (pps) {
 			duration = (IL_AVERAGE_PACKETS * 1000) / pps;
-			if (duration < IL_RATE_FLUSH_MIN)
-				duration = IL_RATE_FLUSH_MIN;
-			else if (duration > IL_RATE_FLUSH_MAX)
-				duration = IL_RATE_FLUSH_MAX;
+			if (duration < RATE_FLUSH_MIN)
+				duration = RATE_FLUSH_MIN;
+			else if (duration > RATE_FLUSH_MAX)
+				duration = RATE_FLUSH_MAX;
 		} else
-			duration = IL_RATE_FLUSH_MAX;
+			duration = RATE_FLUSH_MAX;
 
 		rs_sta->flush_time = msecs_to_jiffies(duration);
 
@@ -234,7 +234,7 @@ static void il3945_bg_rate_scale_flush(unsigned long data)
 
 		rs_sta->last_partial_flush = jiffies;
 	} else {
-		rs_sta->flush_time = IL_RATE_FLUSH;
+		rs_sta->flush_time = RATE_FLUSH;
 		rs_sta->flush_pending = 0;
 	}
 	/* If there weren't any unflushed entries, we don't schedule the timer
@@ -278,13 +278,13 @@ static void il3945_collect_tx_data(struct il3945_rs_sta *rs_sta,
 	 * we keep these bitmaps!).
 	 * */
 	while (retries > 0) {
-		if (win->counter >= IL_RATE_MAX_WINDOW) {
+		if (win->counter >= RATE_MAX_WINDOW) {
 
 			/* remove earliest */
-			win->counter = IL_RATE_MAX_WINDOW - 1;
+			win->counter = RATE_MAX_WINDOW - 1;
 
-			if (win->data & (1ULL << (IL_RATE_MAX_WINDOW - 1))) {
-				win->data &= ~(1ULL << (IL_RATE_MAX_WINDOW - 1));
+			if (win->data & (1ULL << (RATE_MAX_WINDOW - 1))) {
+				win->data &= ~(1ULL << (RATE_MAX_WINDOW - 1));
 				win->success_counter--;
 			}
 		}
@@ -315,8 +315,8 @@ static void il3945_collect_tx_data(struct il3945_rs_sta *rs_sta,
 	fail_count = win->counter - win->success_counter;
 
 	/* Calculate average throughput, if we have enough history. */
-	if (fail_count >= IL_RATE_MIN_FAILURE_TH ||
-	    win->success_counter >= IL_RATE_MIN_SUCCESS_TH)
+	if (fail_count >= RATE_MIN_FAILURE_TH ||
+	    win->success_counter >= RATE_MIN_SUCCESS_TH)
 		win->average_tpt = ((win->success_ratio *
 				rs_sta->expected_tpt[index] + 64) / 128);
 	else
@@ -351,20 +351,20 @@ void il3945_rs_rate_init(struct il_priv *il, struct ieee80211_sta *sta, u8 sta_i
 
 	rs_sta->il = il;
 
-	rs_sta->start_rate = IL_RATE_INVALID;
+	rs_sta->start_rate = RATE_INVALID;
 
 	/* default to just 802.11b */
 	rs_sta->expected_tpt = il3945_expected_tpt_b;
 
 	rs_sta->last_partial_flush = jiffies;
 	rs_sta->last_flush = jiffies;
-	rs_sta->flush_time = IL_RATE_FLUSH;
+	rs_sta->flush_time = RATE_FLUSH;
 	rs_sta->last_tx_packets = 0;
 
 	rs_sta->rate_scale_flush.data = (unsigned long)rs_sta;
 	rs_sta->rate_scale_flush.function = il3945_bg_rate_scale_flush;
 
-	for (i = 0; i < IL_RATE_COUNT_3945; i++)
+	for (i = 0; i < RATE_COUNT_3945; i++)
 		il3945_clear_win(&rs_sta->win[i]);
 
 	/* TODO: what is a good starting rate for STA? About middle? Maybe not
@@ -457,11 +457,11 @@ static void il3945_rs_tx_status(void *il_rate, struct ieee80211_supported_band *
 
 	retries = info->status.rates[0].count;
 	/* Sanity Check for retries */
-	if (retries > IL_RATE_RETRY_TH)
-		retries = IL_RATE_RETRY_TH;
+	if (retries > RATE_RETRY_TH)
+		retries = RATE_RETRY_TH;
 
 	first_index = sband->bitrates[info->status.rates[0].idx].hw_value;
-	if (first_index < 0 || first_index >= IL_RATE_COUNT_3945) {
+	if (first_index < 0 || first_index >= RATE_COUNT_3945) {
 		D_RATE("leave: Rate out of bounds: %d\n", first_index);
 		return;
 	}
@@ -549,8 +549,8 @@ static void il3945_rs_tx_status(void *il_rate, struct ieee80211_supported_band *
 static u16 il3945_get_adjacent_rate(struct il3945_rs_sta *rs_sta,
 				 u8 index, u16 rate_mask, enum ieee80211_band band)
 {
-	u8 high = IL_RATE_INVALID;
-	u8 low = IL_RATE_INVALID;
+	u8 high = RATE_INVALID;
+	u8 low = RATE_INVALID;
 	struct il_priv *il __maybe_unused = rs_sta->il;
 
 	/* 802.11A walks to the next literal adjacent rate in
@@ -570,7 +570,7 @@ static u16 il3945_get_adjacent_rate(struct il3945_rs_sta *rs_sta,
 
 		/* Find the next rate that is in the rate mask */
 		i = index + 1;
-		for (mask = (1 << i); i < IL_RATE_COUNT_3945;
+		for (mask = (1 << i); i < RATE_COUNT_3945;
 		     i++, mask <<= 1) {
 			if (rate_mask & mask) {
 				high = i;
@@ -582,12 +582,12 @@ static u16 il3945_get_adjacent_rate(struct il3945_rs_sta *rs_sta,
 	}
 
 	low = index;
-	while (low != IL_RATE_INVALID) {
+	while (low != RATE_INVALID) {
 		if (rs_sta->tgg)
 			low = il3945_rates[low].prev_rs_tgg;
 		else
 			low = il3945_rates[low].prev_rs;
-		if (low == IL_RATE_INVALID)
+		if (low == RATE_INVALID)
 			break;
 		if (rate_mask & (1 << low))
 			break;
@@ -595,12 +595,12 @@ static u16 il3945_get_adjacent_rate(struct il3945_rs_sta *rs_sta,
 	}
 
 	high = index;
-	while (high != IL_RATE_INVALID) {
+	while (high != RATE_INVALID) {
 		if (rs_sta->tgg)
 			high = il3945_rates[high].next_rs_tgg;
 		else
 			high = il3945_rates[high].next_rs;
-		if (high == IL_RATE_INVALID)
+		if (high == RATE_INVALID)
 			break;
 		if (rate_mask & (1 << high))
 			break;
@@ -631,8 +631,8 @@ static void il3945_rs_get_rate(void *il_r, struct ieee80211_sta *sta,
 {
 	struct ieee80211_supported_band *sband = txrc->sband;
 	struct sk_buff *skb = txrc->skb;
-	u8 low = IL_RATE_INVALID;
-	u8 high = IL_RATE_INVALID;
+	u8 low = RATE_INVALID;
+	u8 high = RATE_INVALID;
 	u16 high_low;
 	int index;
 	struct il3945_rs_sta *rs_sta = il_sta;
@@ -665,10 +665,10 @@ static void il3945_rs_get_rate(void *il_r, struct ieee80211_sta *sta,
 	max_rate_idx = txrc->max_rate_idx;
 	if (sband->band == IEEE80211_BAND_5GHZ && max_rate_idx != -1)
 		max_rate_idx += IL_FIRST_OFDM_RATE;
-	if (max_rate_idx < 0 || max_rate_idx >= IL_RATE_COUNT)
+	if (max_rate_idx < 0 || max_rate_idx >= RATE_COUNT)
 		max_rate_idx = -1;
 
-	index = min(rs_sta->last_txrate_idx & 0xffff, IL_RATE_COUNT_3945 - 1);
+	index = min(rs_sta->last_txrate_idx & 0xffff, RATE_COUNT_3945 - 1);
 
 	if (sband->band == IEEE80211_BAND_5GHZ)
 		rate_mask = rate_mask << IL_FIRST_OFDM_RATE;
@@ -678,11 +678,11 @@ static void il3945_rs_get_rate(void *il_r, struct ieee80211_sta *sta,
 	/* for recent assoc, choose best rate regarding
 	 * to rssi value
 	 */
-	if (rs_sta->start_rate != IL_RATE_INVALID) {
+	if (rs_sta->start_rate != RATE_INVALID) {
 		if (rs_sta->start_rate < index &&
 		   (rate_mask & (1 << rs_sta->start_rate)))
 			index = rs_sta->start_rate;
-		rs_sta->start_rate = IL_RATE_INVALID;
+		rs_sta->start_rate = RATE_INVALID;
 	}
 
 	/* force user max rate if set by user */
@@ -695,8 +695,8 @@ static void il3945_rs_get_rate(void *il_r, struct ieee80211_sta *sta,
 
 	fail_count = win->counter - win->success_counter;
 
-	if (fail_count < IL_RATE_MIN_FAILURE_TH &&
-	    win->success_counter < IL_RATE_MIN_SUCCESS_TH) {
+	if (fail_count < RATE_MIN_FAILURE_TH &&
+	    win->success_counter < RATE_MIN_SUCCESS_TH) {
 		spin_unlock_irqrestore(&rs_sta->lock, flags);
 
 		D_RATE("Invalid average_tpt on rate %d: "
@@ -722,13 +722,13 @@ static void il3945_rs_get_rate(void *il_r, struct ieee80211_sta *sta,
 
 	/* If user set max rate, dont allow higher than user constrain */
 	if (max_rate_idx != -1 && max_rate_idx < high)
-		high = IL_RATE_INVALID;
+		high = RATE_INVALID;
 
 	/* Collect Measured throughputs of adjacent rates */
-	if (low != IL_RATE_INVALID)
+	if (low != RATE_INVALID)
 		low_tpt = rs_sta->win[low].average_tpt;
 
-	if (high != IL_RATE_INVALID)
+	if (high != RATE_INVALID)
 		high_tpt = rs_sta->win[high].average_tpt;
 
 	spin_unlock_irqrestore(&rs_sta->lock, flags);
@@ -736,7 +736,7 @@ static void il3945_rs_get_rate(void *il_r, struct ieee80211_sta *sta,
 	scale_action = 0;
 
 	/* Low success ratio , need to drop the rate */
-	if (win->success_ratio < IL_RATE_DECREASE_TH || !current_tpt) {
+	if (win->success_ratio < RATE_DECREASE_TH || !current_tpt) {
 		D_RATE("decrease rate because of low success_ratio\n");
 		scale_action = -1;
 	/* No throughput measured yet for adjacent rates,
@@ -744,9 +744,9 @@ static void il3945_rs_get_rate(void *il_r, struct ieee80211_sta *sta,
 	} else if (low_tpt == IL_INVALID_VALUE &&
 		   high_tpt == IL_INVALID_VALUE) {
 
-		if (high != IL_RATE_INVALID && win->success_ratio >= IL_RATE_INCREASE_TH)
+		if (high != RATE_INVALID && win->success_ratio >= RATE_INCREASE_TH)
 			scale_action = 1;
-		else if (low != IL_RATE_INVALID)
+		else if (low != RATE_INVALID)
 			scale_action = 0;
 
 	/* Both adjacent throughputs are measured, but neither one has
@@ -768,7 +768,7 @@ static void il3945_rs_get_rate(void *il_r, struct ieee80211_sta *sta,
 			/* High rate has better throughput, Increase
 			 * rate */
 			if (high_tpt > current_tpt &&
-				win->success_ratio >= IL_RATE_INCREASE_TH)
+				win->success_ratio >= RATE_INCREASE_TH)
 				scale_action = 1;
 			else {
 				D_RATE(
@@ -780,7 +780,7 @@ static void il3945_rs_get_rate(void *il_r, struct ieee80211_sta *sta,
 				D_RATE(
 				    "decrease rate because of low tpt\n");
 				scale_action = -1;
-			} else if (win->success_ratio >= IL_RATE_INCREASE_TH) {
+			} else if (win->success_ratio >= RATE_INCREASE_TH) {
 				/* Lower rate has better
 				 * throughput,decrease rate */
 				scale_action = 1;
@@ -790,8 +790,8 @@ static void il3945_rs_get_rate(void *il_r, struct ieee80211_sta *sta,
 
 	/* Sanity check; asked for decrease, but success rate or throughput
 	 * has been good at old rate.  Don't change it. */
-	if (scale_action == -1 && low != IL_RATE_INVALID &&
-	    (win->success_ratio > IL_RATE_HIGH_TH ||
+	if (scale_action == -1 && low != RATE_INVALID &&
+	    (win->success_ratio > RATE_HIGH_TH ||
 	     current_tpt > 100 * rs_sta->expected_tpt[low]))
 		scale_action = 0;
 
@@ -799,13 +799,13 @@ static void il3945_rs_get_rate(void *il_r, struct ieee80211_sta *sta,
 	case -1:
 
 		/* Decrese rate */
-		if (low != IL_RATE_INVALID)
+		if (low != RATE_INVALID)
 			index = low;
 		break;
 
 	case 1:
 		/* Increase rate */
-		if (high != IL_RATE_INVALID)
+		if (high != RATE_INVALID)
 			index = high;
 
 		break;
@@ -860,7 +860,7 @@ static ssize_t il3945_sta_dbgfs_stats_table_read(struct file *file,
 			lq_sta->tx_packets,
 			lq_sta->last_txrate_idx,
 			lq_sta->start_rate, jiffies_to_msecs(lq_sta->flush_time));
-	for (j = 0; j < IL_RATE_COUNT_3945; j++) {
+	for (j = 0; j < RATE_COUNT_3945; j++) {
 		desc += sprintf(buff+desc,
 				"counter=%d success=%d %%=%d\n",
 				lq_sta->win[j].counter,
diff --git a/drivers/net/wireless/iwlegacy/iwl-3945.c b/drivers/net/wireless/iwlegacy/iwl-3945.c
index fa4c33a..728a90c 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945.c
+++ b/drivers/net/wireless/iwlegacy/iwl-3945.c
@@ -52,26 +52,26 @@
 #include "iwl-3945-debugfs.h"
 
 #define IL_DECLARE_RATE_INFO(r, ip, in, rp, rn, pp, np)    \
-	[IL_RATE_##r##M_INDEX] = { IL_RATE_##r##M_PLCP,   \
-				    IL_RATE_##r##M_IEEE,   \
-				    IL_RATE_##ip##M_INDEX, \
-				    IL_RATE_##in##M_INDEX, \
-				    IL_RATE_##rp##M_INDEX, \
-				    IL_RATE_##rn##M_INDEX, \
-				    IL_RATE_##pp##M_INDEX, \
-				    IL_RATE_##np##M_INDEX, \
-				    IL_RATE_##r##M_INDEX_TABLE, \
-				    IL_RATE_##ip##M_INDEX_TABLE }
+	[RATE_##r##M_INDEX] = { RATE_##r##M_PLCP,   \
+				    RATE_##r##M_IEEE,   \
+				    RATE_##ip##M_INDEX, \
+				    RATE_##in##M_INDEX, \
+				    RATE_##rp##M_INDEX, \
+				    RATE_##rn##M_INDEX, \
+				    RATE_##pp##M_INDEX, \
+				    RATE_##np##M_INDEX, \
+				    RATE_##r##M_INDEX_TABLE, \
+				    RATE_##ip##M_INDEX_TABLE }
 
 /*
  * Parameter order:
  *   rate, prev rate, next rate, prev tgg rate, next tgg rate
  *
  * If there isn't a valid next or previous rate then INV is used which
- * maps to IL_RATE_INVALID
+ * maps to RATE_INVALID
  *
  */
-const struct il3945_rate_info il3945_rates[IL_RATE_COUNT_3945] = {
+const struct il3945_rate_info il3945_rates[RATE_COUNT_3945] = {
 	IL_DECLARE_RATE_INFO(1, INV, 2, INV, 2, INV, 2),    /*  1mbps */
 	IL_DECLARE_RATE_INFO(2, 1, 5, 1, 5, 1, 5),          /*  2mbps */
 	IL_DECLARE_RATE_INFO(5, 2, 6, 2, 11, 2, 11),        /*5.5mbps */
@@ -90,7 +90,7 @@ static inline u8 il3945_get_prev_ieee_rate(u8 rate_index)
 {
 	u8 rate = il3945_rates[rate_index].prev_ieee;
 
-	if (rate == IL_RATE_INVALID)
+	if (rate == RATE_INVALID)
 		rate = rate_index;
 	return rate;
 }
@@ -194,7 +194,7 @@ static int il3945_hwrate_to_plcp_idx(u8 plcp)
 {
 	int idx;
 
-	for (idx = 0; idx < IL_RATE_COUNT_3945; idx++)
+	for (idx = 0; idx < RATE_COUNT_3945; idx++)
 		if (il3945_rates[idx].plcp == plcp)
 			return idx;
 	return -1;
@@ -246,16 +246,16 @@ int il3945_rs_next_rate(struct il_priv *il, int rate)
 
 	switch (il->band) {
 	case IEEE80211_BAND_5GHZ:
-		if (rate == IL_RATE_12M_INDEX)
-			next_rate = IL_RATE_9M_INDEX;
-		else if (rate == IL_RATE_6M_INDEX)
-			next_rate = IL_RATE_6M_INDEX;
+		if (rate == RATE_12M_INDEX)
+			next_rate = RATE_9M_INDEX;
+		else if (rate == RATE_6M_INDEX)
+			next_rate = RATE_6M_INDEX;
 		break;
 	case IEEE80211_BAND_2GHZ:
 		if (!(il->_3945.sta_supp_rates & IL_OFDM_RATES_MASK) &&
 		    il_is_associated(il)) {
-			if (rate == IL_RATE_11M_INDEX)
-				next_rate = IL_RATE_5M_INDEX;
+			if (rate == RATE_11M_INDEX)
+				next_rate = RATE_5M_INDEX;
 		}
 		break;
 
@@ -675,7 +675,7 @@ void il3945_hw_build_tx_cmd_rate(struct il_priv *il,
 				  int sta_id, int tx_id)
 {
 	u16 hw_value = ieee80211_get_tx_rate(il->hw, info)->hw_value;
-	u16 rate_index = min(hw_value & 0xffff, IL_RATE_COUNT_3945);
+	u16 rate_index = min(hw_value & 0xffff, RATE_COUNT_3945);
 	u16 rate_mask;
 	int rate;
 	u8 rts_retry_limit;
@@ -689,7 +689,7 @@ void il3945_hw_build_tx_cmd_rate(struct il_priv *il,
 
 	/* We need to figure out how to get the sta->supp_rates while
 	 * in this running context */
-	rate_mask = IL_RATES_MASK_3945;
+	rate_mask = RATES_MASK_3945;
 
 	/* Set retry limit on DATA packets and Probe Responses*/
 	if (ieee80211_is_probe_resp(fc))
@@ -1330,7 +1330,7 @@ static void il3945_hw_reg_set_scan_power(struct il_priv *il, u32 scan_tbl_index,
 	/* use this channel group's 6Mbit clipping/saturation pwr,
 	 *   but cap at regulatory scan power restriction (set during init
 	 *   based on eeprom channel data) for this channel.  */
-	power = min(ch_info->scan_power, clip_pwrs[IL_RATE_6M_INDEX_TABLE]);
+	power = min(ch_info->scan_power, clip_pwrs[RATE_6M_INDEX_TABLE]);
 
 	power = min(power, il->tx_power_user_lmt);
 	scan_power_info->requested_power = power;
@@ -1342,7 +1342,7 @@ static void il3945_hw_reg_set_scan_power(struct il_priv *il, u32 scan_tbl_index,
 	 *   *index*. */
 	power_index = ch_info->power_info[rate_index].power_table_index
 	    - (power - ch_info->power_info
-	       [IL_RATE_6M_INDEX_TABLE].requested_power) * 2;
+	       [RATE_6M_INDEX_TABLE].requested_power) * 2;
 
 	/* store reference index that we use when adjusting *all* scan
 	 *   powers.  So we can accommodate user (all channel) or spectrum
@@ -1466,7 +1466,7 @@ static int il3945_hw_reg_set_new_power(struct il_priv *il,
 	power_info = ch_info->power_info;
 
 	/* update OFDM Txpower settings */
-	for (i = IL_RATE_6M_INDEX_TABLE; i <= IL_RATE_54M_INDEX_TABLE;
+	for (i = RATE_6M_INDEX_TABLE; i <= RATE_54M_INDEX_TABLE;
 	     i++, ++power_info) {
 		int delta_idx;
 
@@ -1490,14 +1490,14 @@ static int il3945_hw_reg_set_new_power(struct il_priv *il,
 	 *    ... all CCK power settings for a given channel are the *same*. */
 	if (power_changed) {
 		power =
-		    ch_info->power_info[IL_RATE_12M_INDEX_TABLE].
+		    ch_info->power_info[RATE_12M_INDEX_TABLE].
 		    requested_power + IL_CCK_FROM_OFDM_POWER_DIFF;
 
 		/* do all CCK rates' il3945_channel_power_info structures */
-		for (i = IL_RATE_1M_INDEX_TABLE; i <= IL_RATE_11M_INDEX_TABLE; i++) {
+		for (i = RATE_1M_INDEX_TABLE; i <= RATE_11M_INDEX_TABLE; i++) {
 			power_info->requested_power = power;
 			power_info->base_power_index =
-			    ch_info->power_info[IL_RATE_12M_INDEX_TABLE].
+			    ch_info->power_info[RATE_12M_INDEX_TABLE].
 			    base_power_index + IL_CCK_FROM_OFDM_INDEX_DIFF;
 			++power_info;
 		}
@@ -1574,7 +1574,7 @@ static int il3945_hw_reg_comp_txpower_temp(struct il_priv *il)
 							      ref_temp);
 
 		/* set tx power value for all rates, OFDM and CCK */
-		for (rate_index = 0; rate_index < IL_RATE_COUNT_3945;
+		for (rate_index = 0; rate_index < RATE_COUNT_3945;
 		     rate_index++) {
 			int power_idx =
 			    ch_info->power_info[rate_index].base_power_index;
@@ -1597,7 +1597,7 @@ static int il3945_hw_reg_comp_txpower_temp(struct il_priv *il)
 		for (scan_tbl_index = 0;
 		     scan_tbl_index < IL_NUM_SCAN_RATES; scan_tbl_index++) {
 			s32 actual_index = (scan_tbl_index == 0) ?
-			    IL_RATE_1M_INDEX_TABLE : IL_RATE_6M_INDEX_TABLE;
+			    RATE_1M_INDEX_TABLE : RATE_6M_INDEX_TABLE;
 			il3945_hw_reg_set_scan_power(il, scan_tbl_index,
 					   actual_index, clip_pwrs,
 					   ch_info, a_band);
@@ -2010,21 +2010,21 @@ static void il3945_hw_reg_init_channel_groups(struct il_priv *il)
 
 		/* fill in channel group's nominal powers for each rate */
 		for (rate_index = 0;
-		     rate_index < IL_RATE_COUNT_3945; rate_index++, clip_pwrs++) {
+		     rate_index < RATE_COUNT_3945; rate_index++, clip_pwrs++) {
 			switch (rate_index) {
-			case IL_RATE_36M_INDEX_TABLE:
+			case RATE_36M_INDEX_TABLE:
 				if (i == 0)	/* B/G */
 					*clip_pwrs = satur_pwr;
 				else	/* A */
 					*clip_pwrs = satur_pwr - 5;
 				break;
-			case IL_RATE_48M_INDEX_TABLE:
+			case RATE_48M_INDEX_TABLE:
 				if (i == 0)
 					*clip_pwrs = satur_pwr - 7;
 				else
 					*clip_pwrs = satur_pwr - 10;
 				break;
-			case IL_RATE_54M_INDEX_TABLE:
+			case RATE_54M_INDEX_TABLE:
 				if (i == 0)
 					*clip_pwrs = satur_pwr - 9;
 				else
@@ -2139,7 +2139,7 @@ int il3945_txpower_set_from_eeprom(struct il_priv *il)
 		}
 
 		/* set tx power for CCK rates, based on OFDM 12 Mbit settings*/
-		pwr_info = &ch_info->power_info[IL_RATE_12M_INDEX_TABLE];
+		pwr_info = &ch_info->power_info[RATE_12M_INDEX_TABLE];
 		power = pwr_info->requested_power +
 			IL_CCK_FROM_OFDM_POWER_DIFF;
 		pwr_index = pwr_info->power_table_index +
@@ -2169,7 +2169,7 @@ int il3945_txpower_set_from_eeprom(struct il_priv *il)
 		for (scan_tbl_index = 0;
 		     scan_tbl_index < IL_NUM_SCAN_RATES; scan_tbl_index++) {
 			s32 actual_index = (scan_tbl_index == 0) ?
-				IL_RATE_1M_INDEX_TABLE : IL_RATE_6M_INDEX_TABLE;
+				RATE_1M_INDEX_TABLE : RATE_6M_INDEX_TABLE;
 			il3945_hw_reg_set_scan_power(il, scan_tbl_index,
 				actual_index, clip_pwrs, ch_info, a_band);
 		}
@@ -2289,7 +2289,7 @@ static int il3945_manage_ibss_station(struct il_priv *il,
 
 		il3945_sync_sta(il, vif_priv->ibss_bssid_sta_id,
 				 (il->band == IEEE80211_BAND_5GHZ) ?
-				 IL_RATE_6M_PLCP : IL_RATE_1M_PLCP);
+				 RATE_6M_PLCP : RATE_1M_PLCP);
 		il3945_rate_scale_init(il->hw, vif_priv->ibss_bssid_sta_id);
 
 		return 0;
@@ -2326,17 +2326,17 @@ int il3945_init_hw_rate_table(struct il_priv *il)
 		D_RATE("Select A mode rate scale\n");
 		/* If one of the following CCK rates is used,
 		 * have it fall back to the 6M OFDM rate */
-		for (i = IL_RATE_1M_INDEX_TABLE;
-			i <= IL_RATE_11M_INDEX_TABLE; i++)
+		for (i = RATE_1M_INDEX_TABLE;
+			i <= RATE_11M_INDEX_TABLE; i++)
 			table[i].next_rate_index =
 			  il3945_rates[IL_FIRST_OFDM_RATE].table_rs_index;
 
 		/* Don't fall back to CCK rates */
-		table[IL_RATE_12M_INDEX_TABLE].next_rate_index =
-						IL_RATE_9M_INDEX_TABLE;
+		table[RATE_12M_INDEX_TABLE].next_rate_index =
+						RATE_9M_INDEX_TABLE;
 
 		/* Don't drop out of OFDM rates */
-		table[IL_RATE_6M_INDEX_TABLE].next_rate_index =
+		table[RATE_6M_INDEX_TABLE].next_rate_index =
 		    il3945_rates[IL_FIRST_OFDM_RATE].table_rs_index;
 		break;
 
@@ -2349,14 +2349,14 @@ int il3945_init_hw_rate_table(struct il_priv *il)
 		    il_is_associated(il)) {
 
 			index = IL_FIRST_CCK_RATE;
-			for (i = IL_RATE_6M_INDEX_TABLE;
-			     i <= IL_RATE_54M_INDEX_TABLE; i++)
+			for (i = RATE_6M_INDEX_TABLE;
+			     i <= RATE_54M_INDEX_TABLE; i++)
 				table[i].next_rate_index =
 					il3945_rates[index].table_rs_index;
 
-			index = IL_RATE_11M_INDEX_TABLE;
+			index = RATE_11M_INDEX_TABLE;
 			/* CCK shouldn't fall back to OFDM... */
-			table[index].next_rate_index = IL_RATE_5M_INDEX_TABLE;
+			table[index].next_rate_index = RATE_5M_INDEX_TABLE;
 		}
 		break;
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-3945.h b/drivers/net/wireless/iwlegacy/iwl-3945.h
index 967e733..80fcbf8 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945.h
+++ b/drivers/net/wireless/iwlegacy/iwl-3945.h
@@ -96,7 +96,7 @@ struct il3945_rs_sta {
 	u8 flush_pending;
 	u8 start_rate;
 	struct timer_list rate_scale_flush;
-	struct il3945_rate_scale_data win[IL_RATE_COUNT_3945];
+	struct il3945_rate_scale_data win[RATE_COUNT_3945];
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct dentry *rs_sta_dbgfs_stats_table_file;
 #endif
@@ -300,7 +300,7 @@ int il3945_request_scan(struct il_priv *il, struct ieee80211_vif *vif);
 void il3945_post_scan(struct il_priv *il);
 
 /* rates */
-extern const struct il3945_rate_info il3945_rates[IL_RATE_COUNT_3945];
+extern const struct il3945_rate_info il3945_rates[RATE_COUNT_3945];
 
 /* Requires full declaration of il_priv before including */
 #include "iwl-io.h"
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-lib.c b/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
index 57fc190..ee04977 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
@@ -423,7 +423,7 @@ int il4965_hwrate_to_mac80211_idx(u32 rate_n_flags, enum ieee80211_band band)
 	} else {
 		if (band == IEEE80211_BAND_5GHZ)
 			band_offset = IL_FIRST_OFDM_RATE;
-		for (idx = band_offset; idx < IL_RATE_COUNT_LEGACY; idx++)
+		for (idx = band_offset; idx < RATE_COUNT_LEGACY; idx++)
 			if (il_rates[idx].plcp == (rate_n_flags & 0xFF))
 				return idx - band_offset;
 	}
@@ -870,14 +870,14 @@ int il4965_request_scan(struct il_priv *il, struct ieee80211_vif *vif)
 						RXON_FLG_CHANNEL_MODE_MSK)
 				       >> RXON_FLG_CHANNEL_MODE_POS;
 		if (chan_mod == CHANNEL_MODE_PURE_40) {
-			rate = IL_RATE_6M_PLCP;
+			rate = RATE_6M_PLCP;
 		} else {
-			rate = IL_RATE_1M_PLCP;
+			rate = RATE_1M_PLCP;
 			rate_flags = RATE_MCS_CCK_MSK;
 		}
 		break;
 	case IEEE80211_BAND_5GHZ:
-		rate = IL_RATE_6M_PLCP;
+		rate = RATE_6M_PLCP;
 		break;
 	default:
 		IL_WARN("Invalid scan band\n");
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-rs.c b/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
index 5d88a45..e31ee20 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
@@ -46,23 +46,23 @@
 #define IL_NUMBER_TRY      1
 #define IL_HT_NUMBER_TRY   3
 
-#define IL_RATE_MAX_WINDOW		62	/* # tx in history win */
-#define IL_RATE_MIN_FAILURE_TH		6	/* min failures to calc tpt */
-#define IL_RATE_MIN_SUCCESS_TH		8	/* min successes to calc tpt */
+#define RATE_MAX_WINDOW		62	/* # tx in history win */
+#define RATE_MIN_FAILURE_TH		6	/* min failures to calc tpt */
+#define RATE_MIN_SUCCESS_TH		8	/* min successes to calc tpt */
 
 /* max allowed rate miss before sync LQ cmd */
 #define IL_MISSED_RATE_MAX		15
 /* max time to accum history 2 seconds */
-#define IL_RATE_SCALE_FLUSH_INTVL   (3*HZ)
+#define RATE_SCALE_FLUSH_INTVL   (3*HZ)
 
 static u8 rs_ht_to_legacy[] = {
-	IL_RATE_6M_INDEX, IL_RATE_6M_INDEX,
-	IL_RATE_6M_INDEX, IL_RATE_6M_INDEX,
-	IL_RATE_6M_INDEX,
-	IL_RATE_6M_INDEX, IL_RATE_9M_INDEX,
-	IL_RATE_12M_INDEX, IL_RATE_18M_INDEX,
-	IL_RATE_24M_INDEX, IL_RATE_36M_INDEX,
-	IL_RATE_48M_INDEX, IL_RATE_54M_INDEX
+	RATE_6M_INDEX, RATE_6M_INDEX,
+	RATE_6M_INDEX, RATE_6M_INDEX,
+	RATE_6M_INDEX,
+	RATE_6M_INDEX, RATE_9M_INDEX,
+	RATE_12M_INDEX, RATE_18M_INDEX,
+	RATE_24M_INDEX, RATE_36M_INDEX,
+	RATE_48M_INDEX, RATE_54M_INDEX
 };
 
 static const u8 ant_toggle_lookup[] = {
@@ -77,26 +77,26 @@ static const u8 ant_toggle_lookup[] = {
 };
 
 #define IL_DECLARE_RATE_INFO(r, s, ip, in, rp, rn, pp, np)    \
-	[IL_RATE_##r##M_INDEX] = { IL_RATE_##r##M_PLCP,      \
-				    IL_RATE_SISO_##s##M_PLCP, \
-				    IL_RATE_MIMO2_##s##M_PLCP,\
-				    IL_RATE_##r##M_IEEE,      \
-				    IL_RATE_##ip##M_INDEX,    \
-				    IL_RATE_##in##M_INDEX,    \
-				    IL_RATE_##rp##M_INDEX,    \
-				    IL_RATE_##rn##M_INDEX,    \
-				    IL_RATE_##pp##M_INDEX,    \
-				    IL_RATE_##np##M_INDEX }
+	[RATE_##r##M_INDEX] = { RATE_##r##M_PLCP,      \
+				    RATE_SISO_##s##M_PLCP, \
+				    RATE_MIMO2_##s##M_PLCP,\
+				    RATE_##r##M_IEEE,      \
+				    RATE_##ip##M_INDEX,    \
+				    RATE_##in##M_INDEX,    \
+				    RATE_##rp##M_INDEX,    \
+				    RATE_##rn##M_INDEX,    \
+				    RATE_##pp##M_INDEX,    \
+				    RATE_##np##M_INDEX }
 
 /*
  * Parameter order:
  *   rate, ht rate, prev rate, next rate, prev tgg rate, next tgg rate
  *
  * If there isn't a valid next or previous rate then INV is used which
- * maps to IL_RATE_INVALID
+ * maps to RATE_INVALID
  *
  */
-const struct il_rate_info il_rates[IL_RATE_COUNT] = {
+const struct il_rate_info il_rates[RATE_COUNT] = {
 	IL_DECLARE_RATE_INFO(1, INV, INV, 2, INV, 2, INV, 2),    /*  1mbps */
 	IL_DECLARE_RATE_INFO(2, INV, 1, 5, 1, 5, 1, 5),          /*  2mbps */
 	IL_DECLARE_RATE_INFO(5, INV, 2, 6, 2, 11, 2, 11),        /*5.5mbps */
@@ -120,12 +120,12 @@ static int il4965_hwrate_to_plcp_idx(u32 rate_n_flags)
 	if (rate_n_flags & RATE_MCS_HT_MSK) {
 		idx = (rate_n_flags & 0xff);
 
-		if (idx >= IL_RATE_MIMO2_6M_PLCP)
-			idx = idx - IL_RATE_MIMO2_6M_PLCP;
+		if (idx >= RATE_MIMO2_6M_PLCP)
+			idx = idx - RATE_MIMO2_6M_PLCP;
 
 		idx += IL_FIRST_OFDM_RATE;
 		/* skip 9M not supported in ht*/
-		if (idx >= IL_RATE_9M_INDEX)
+		if (idx >= RATE_9M_INDEX)
 			idx += 1;
 		if (idx >= IL_FIRST_OFDM_RATE && idx <= IL_LAST_OFDM_RATE)
 			return idx;
@@ -169,32 +169,32 @@ static void il4965_rs_dbgfs_set_mcs(struct il_lq_sta *lq_sta,
  * (2.4 GHz) band.
  */
 
-static s32 expected_tpt_legacy[IL_RATE_COUNT] = {
+static s32 expected_tpt_legacy[RATE_COUNT] = {
 	7, 13, 35, 58, 40, 57, 72, 98, 121, 154, 177, 186, 0
 };
 
-static s32 expected_tpt_siso20MHz[4][IL_RATE_COUNT] = {
+static s32 expected_tpt_siso20MHz[4][RATE_COUNT] = {
 	{0, 0, 0, 0, 42, 0,  76, 102, 124, 158, 183, 193, 202}, /* Norm */
 	{0, 0, 0, 0, 46, 0,  82, 110, 132, 167, 192, 202, 210}, /* SGI */
 	{0, 0, 0, 0, 48, 0,  93, 135, 176, 251, 319, 351, 381}, /* AGG */
 	{0, 0, 0, 0, 53, 0, 102, 149, 193, 275, 348, 381, 413}, /* AGG+SGI */
 };
 
-static s32 expected_tpt_siso40MHz[4][IL_RATE_COUNT] = {
+static s32 expected_tpt_siso40MHz[4][RATE_COUNT] = {
 	{0, 0, 0, 0,  77, 0, 127, 160, 184, 220, 242, 250, 257}, /* Norm */
 	{0, 0, 0, 0,  83, 0, 135, 169, 193, 229, 250, 257, 264}, /* SGI */
 	{0, 0, 0, 0,  96, 0, 182, 259, 328, 451, 553, 598, 640}, /* AGG */
 	{0, 0, 0, 0, 106, 0, 199, 282, 357, 487, 593, 640, 683}, /* AGG+SGI */
 };
 
-static s32 expected_tpt_mimo2_20MHz[4][IL_RATE_COUNT] = {
+static s32 expected_tpt_mimo2_20MHz[4][RATE_COUNT] = {
 	{0, 0, 0, 0,  74, 0, 123, 155, 179, 213, 235, 243, 250}, /* Norm */
 	{0, 0, 0, 0,  81, 0, 131, 164, 187, 221, 242, 250, 256}, /* SGI */
 	{0, 0, 0, 0,  92, 0, 175, 250, 317, 436, 534, 578, 619}, /* AGG */
 	{0, 0, 0, 0, 102, 0, 192, 273, 344, 470, 573, 619, 660}, /* AGG+SGI*/
 };
 
-static s32 expected_tpt_mimo2_40MHz[4][IL_RATE_COUNT] = {
+static s32 expected_tpt_mimo2_40MHz[4][RATE_COUNT] = {
 	{0, 0, 0, 0, 123, 0, 182, 214, 235, 264, 279, 285, 289}, /* Norm */
 	{0, 0, 0, 0, 131, 0, 191, 222, 242, 270, 284, 289, 293}, /* SGI */
 	{0, 0, 0, 0, 180, 0, 327, 446, 545, 708, 828, 878, 922}, /* AGG */
@@ -202,7 +202,7 @@ static s32 expected_tpt_mimo2_40MHz[4][IL_RATE_COUNT] = {
 };
 
 /* mbps, mcs */
-static const struct il_rate_mcs_info il_rate_mcs[IL_RATE_COUNT] = {
+static const struct il_rate_mcs_info il_rate_mcs[RATE_COUNT] = {
 	{  "1", "BPSK DSSS"},
 	{  "2", "QPSK DSSS"},
 	{"5.5", "BPSK CCK"},
@@ -418,10 +418,10 @@ static int il4965_rs_collect_tx_data(struct il_scale_tbl_info *tbl,
 			      int scale_index, int attempts, int successes)
 {
 	struct il_rate_scale_data *win = NULL;
-	static const u64 mask = (((u64)1) << (IL_RATE_MAX_WINDOW - 1));
+	static const u64 mask = (((u64)1) << (RATE_MAX_WINDOW - 1));
 	s32 fail_count, tpt;
 
-	if (scale_index < 0 || scale_index >= IL_RATE_COUNT)
+	if (scale_index < 0 || scale_index >= RATE_COUNT)
 		return -EINVAL;
 
 	/* Select win for current tx bit rate */
@@ -439,10 +439,10 @@ static int il4965_rs_collect_tx_data(struct il_scale_tbl_info *tbl,
 	 * we keep these bitmaps!).
 	 */
 	while (attempts > 0) {
-		if (win->counter >= IL_RATE_MAX_WINDOW) {
+		if (win->counter >= RATE_MAX_WINDOW) {
 
 			/* remove earliest */
-			win->counter = IL_RATE_MAX_WINDOW - 1;
+			win->counter = RATE_MAX_WINDOW - 1;
 
 			if (win->data & mask) {
 				win->data &= ~mask;
@@ -476,8 +476,8 @@ static int il4965_rs_collect_tx_data(struct il_scale_tbl_info *tbl,
 	fail_count = win->counter - win->success_counter;
 
 	/* Calculate average throughput, if we have enough history. */
-	if (fail_count >= IL_RATE_MIN_FAILURE_TH ||
-	    win->success_counter >= IL_RATE_MIN_SUCCESS_TH)
+	if (fail_count >= RATE_MIN_FAILURE_TH ||
+	    win->success_counter >= RATE_MIN_SUCCESS_TH)
 		win->average_tpt = (win->success_ratio * tpt + 64) / 128;
 	else
 		win->average_tpt = IL_INVALID_VALUE;
@@ -557,7 +557,7 @@ static int il4965_rs_get_tbl_info_from_mcs(const u32 rate_n_flags,
 	memset(tbl, 0, sizeof(struct il_scale_tbl_info));
 	*rate_idx = il4965_hwrate_to_plcp_idx(rate_n_flags);
 
-	if (*rate_idx  == IL_RATE_INVALID) {
+	if (*rate_idx  == RATE_INVALID) {
 		*rate_idx = -1;
 		return -EINVAL;
 	}
@@ -591,7 +591,7 @@ static int il4965_rs_get_tbl_info_from_mcs(const u32 rate_n_flags,
 		mcs = il4965_rs_extract_rate(rate_n_flags);
 
 		/* SISO */
-		if (mcs <= IL_RATE_SISO_60M_PLCP) {
+		if (mcs <= RATE_SISO_60M_PLCP) {
 			if (il4965_num_of_ant == 1)
 				tbl->lq_type = LQ_SISO; /*else NONE*/
 		/* MIMO2 */
@@ -669,8 +669,8 @@ static u16
 il4965_rs_get_adjacent_rate(struct il_priv *il, u8 index, u16 rate_mask,
 				int rate_type)
 {
-	u8 high = IL_RATE_INVALID;
-	u8 low = IL_RATE_INVALID;
+	u8 high = RATE_INVALID;
+	u8 low = RATE_INVALID;
 
 	/* 802.11A or ht walks to the next literal adjacent rate in
 	 * the rate table */
@@ -689,7 +689,7 @@ il4965_rs_get_adjacent_rate(struct il_priv *il, u8 index, u16 rate_mask,
 
 		/* Find the next rate that is in the rate mask */
 		i = index + 1;
-		for (mask = (1 << i); i < IL_RATE_COUNT; i++, mask <<= 1) {
+		for (mask = (1 << i); i < RATE_COUNT; i++, mask <<= 1) {
 			if (rate_mask & mask) {
 				high = i;
 				break;
@@ -700,9 +700,9 @@ il4965_rs_get_adjacent_rate(struct il_priv *il, u8 index, u16 rate_mask,
 	}
 
 	low = index;
-	while (low != IL_RATE_INVALID) {
+	while (low != RATE_INVALID) {
 		low = il_rates[low].prev_rs;
-		if (low == IL_RATE_INVALID)
+		if (low == RATE_INVALID)
 			break;
 		if (rate_mask & (1 << low))
 			break;
@@ -710,9 +710,9 @@ il4965_rs_get_adjacent_rate(struct il_priv *il, u8 index, u16 rate_mask,
 	}
 
 	high = index;
-	while (high != IL_RATE_INVALID) {
+	while (high != RATE_INVALID) {
 		high = il_rates[high].next_rs;
-		if (high == IL_RATE_INVALID)
+		if (high == RATE_INVALID)
 			break;
 		if (rate_mask & (1 << high))
 			break;
@@ -776,7 +776,7 @@ static u32 il4965_rs_get_lower_rate(struct il_lq_sta *lq_sta,
 					tbl->lq_type);
 	low = high_low & 0xff;
 
-	if (low == IL_RATE_INVALID)
+	if (low == RATE_INVALID)
 		low = scale_index;
 
 out:
@@ -856,7 +856,7 @@ il4965_rs_tx_status(void *il_r, struct ieee80211_supported_band *sband,
 	/* For HT packets, map MCS to PLCP */
 	if (mac_flags & IEEE80211_TX_RC_MCS) {
 		mac_index &= RATE_MCS_CODE_MSK;	/* Remove # of streams */
-		if (mac_index >= (IL_RATE_9M_INDEX - IL_FIRST_OFDM_RATE))
+		if (mac_index >= (RATE_9M_INDEX - IL_FIRST_OFDM_RATE))
 			mac_index++;
 		/*
 		 * mac80211 HT index is always zero-indexed; we need to move
@@ -1023,7 +1023,7 @@ static void il4965_rs_set_expected_tpt_table(struct il_lq_sta *lq_sta,
 				      struct il_scale_tbl_info *tbl)
 {
 	/* Used to choose among HT tables */
-	s32 (*ht_tbl_pointer)[IL_RATE_COUNT];
+	s32 (*ht_tbl_pointer)[RATE_COUNT];
 
 	/* Check for invalid LQ type */
 	if (WARN_ON_ONCE(!is_legacy(tbl->lq_type) && !is_Ht(tbl->lq_type))) {
@@ -1089,7 +1089,7 @@ static s32 il4965_rs_get_best_rate(struct il_priv *il,
 	u16 high_low;
 	s8 rate = index;
 
-	new_rate = high = low = start_hi = IL_RATE_INVALID;
+	new_rate = high = low = start_hi = RATE_INVALID;
 
 	for (; ;) {
 		high_low = il4965_rs_get_adjacent_rate(il, rate, rate_mask,
@@ -1114,16 +1114,16 @@ static s32 il4965_rs_get_best_rate(struct il_priv *il,
 		 *    "active" throughput (under perfect conditions).
 		 */
 		if ((100 * tpt_tbl[rate] > lq_sta->last_tpt &&
-		     (active_sr > IL_RATE_DECREASE_TH &&
-		      active_sr <= IL_RATE_HIGH_TH &&
+		     (active_sr > RATE_DECREASE_TH &&
+		      active_sr <= RATE_HIGH_TH &&
 		      tpt_tbl[rate] <= active_tpt)) ||
-		    (active_sr >= IL_RATE_SCALE_SWITCH &&
+		    (active_sr >= RATE_SCALE_SWITCH &&
 		     tpt_tbl[rate] > active_tpt)) {
 
 			/* (2nd or later pass)
 			 * If we've already tried to raise the rate, and are
 			 * now trying to lower it, use the higher rate. */
-			if (start_hi != IL_RATE_INVALID) {
+			if (start_hi != RATE_INVALID) {
 				new_rate = start_hi;
 				break;
 			}
@@ -1131,7 +1131,7 @@ static s32 il4965_rs_get_best_rate(struct il_priv *il,
 			new_rate = rate;
 
 			/* Loop again with lower rate */
-			if (low != IL_RATE_INVALID)
+			if (low != RATE_INVALID)
 				rate = low;
 
 			/* Lower rate not available, use the original */
@@ -1143,11 +1143,11 @@ static s32 il4965_rs_get_best_rate(struct il_priv *il,
 			/* (2nd or later pass)
 			 * If we've already tried to lower the rate, and are
 			 * now trying to raise it, use the lower rate. */
-			if (new_rate != IL_RATE_INVALID)
+			if (new_rate != RATE_INVALID)
 				break;
 
 			/* Loop again with higher rate */
-			else if (high != IL_RATE_INVALID) {
+			else if (high != RATE_INVALID) {
 				start_hi = high;
 				rate = high;
 
@@ -1207,7 +1207,7 @@ static int il4965_rs_switch_to_mimo2(struct il_priv *il,
 
 	D_RATE("LQ: MIMO2 best rate %d mask %X\n",
 				rate, rate_mask);
-	if (rate == IL_RATE_INVALID || !((1 << rate) & rate_mask)) {
+	if (rate == RATE_INVALID || !((1 << rate) & rate_mask)) {
 		D_RATE(
 				"Can't switch with index %d rate mask %x\n",
 						rate, rate_mask);
@@ -1259,7 +1259,7 @@ static int il4965_rs_switch_to_siso(struct il_priv *il,
 	rate = il4965_rs_get_best_rate(il, lq_sta, tbl, rate_mask, index);
 
 	D_RATE("LQ: get best rate %d mask %X\n", rate, rate_mask);
-	if (rate == IL_RATE_INVALID || !((1 << rate) & rate_mask)) {
+	if (rate == RATE_INVALID || !((1 << rate) & rate_mask)) {
 		D_RATE(
 			"can not switch with index %d rate mask %x\n",
 			     rate, rate_mask);
@@ -1286,7 +1286,7 @@ static int il4965_rs_move_legacy_other(struct il_priv *il,
 				&(lq_sta->lq_info[(1 - lq_sta->active_tbl)]);
 	struct il_rate_scale_data *win = &(tbl->win[index]);
 	u32 sz = (sizeof(struct il_scale_tbl_info) -
-		  (sizeof(struct il_rate_scale_data) * IL_RATE_COUNT));
+		  (sizeof(struct il_rate_scale_data) * RATE_COUNT));
 	u8 start_action;
 	u8 valid_tx_ant = il->hw_params.valid_tx_ant;
 	u8 tx_chains_num = il->hw_params.tx_chains_num;
@@ -1404,7 +1404,7 @@ static int il4965_rs_move_siso_to_other(struct il_priv *il,
 	struct il_rate_scale_data *win = &(tbl->win[index]);
 	struct ieee80211_sta_ht_cap *ht_cap = &sta->ht_cap;
 	u32 sz = (sizeof(struct il_scale_tbl_info) -
-		  (sizeof(struct il_rate_scale_data) * IL_RATE_COUNT));
+		  (sizeof(struct il_rate_scale_data) * RATE_COUNT));
 	u8 start_action;
 	u8 valid_tx_ant = il->hw_params.valid_tx_ant;
 	u8 tx_chains_num = il->hw_params.tx_chains_num;
@@ -1526,7 +1526,7 @@ static int il4965_rs_move_mimo2_to_other(struct il_priv *il,
 	struct il_rate_scale_data *win = &(tbl->win[index]);
 	struct ieee80211_sta_ht_cap *ht_cap = &sta->ht_cap;
 	u32 sz = (sizeof(struct il_scale_tbl_info) -
-		  (sizeof(struct il_rate_scale_data) * IL_RATE_COUNT));
+		  (sizeof(struct il_rate_scale_data) * RATE_COUNT));
 	u8 start_action;
 	u8 valid_tx_ant = il->hw_params.valid_tx_ant;
 	u8 tx_chains_num = il->hw_params.tx_chains_num;
@@ -1663,7 +1663,7 @@ il4965_rs_stay_in_table(struct il_lq_sta *lq_sta, bool force_search)
 			flush_interval_passed =
 			time_after(jiffies,
 					(unsigned long)(lq_sta->flush_timer +
-					IL_RATE_SCALE_FLUSH_INTVL));
+					RATE_SCALE_FLUSH_INTVL));
 
 		/*
 		 * Check if we should allow search for new modulation mode.
@@ -1703,7 +1703,7 @@ il4965_rs_stay_in_table(struct il_lq_sta *lq_sta, bool force_search)
 
 				D_RATE(
 					"LQ: stay in table clear win\n");
-				for (i = 0; i < IL_RATE_COUNT; i++)
+				for (i = 0; i < RATE_COUNT; i++)
 					il4965_rs_rate_scale_clear_win(
 						&(tbl->win[i]));
 			}
@@ -1713,7 +1713,7 @@ il4965_rs_stay_in_table(struct il_lq_sta *lq_sta, bool force_search)
 		 * bitmaps and stats in active table (this will become the new
 		 * "search" table). */
 		if (!lq_sta->stay_in_tbl) {
-			for (i = 0; i < IL_RATE_COUNT; i++)
+			for (i = 0; i < RATE_COUNT; i++)
 				il4965_rs_rate_scale_clear_win(
 							&(tbl->win[i]));
 		}
@@ -1752,8 +1752,8 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 	struct ieee80211_conf *conf = &hw->conf;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	int low = IL_RATE_INVALID;
-	int high = IL_RATE_INVALID;
+	int low = RATE_INVALID;
+	int high = RATE_INVALID;
 	int index;
 	int i;
 	struct il_rate_scale_data *win = NULL;
@@ -1884,8 +1884,8 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 	 * in current association (use new rate found above).
 	 */
 	fail_count = win->counter - win->success_counter;
-	if (fail_count < IL_RATE_MIN_FAILURE_TH &&
-	    win->success_counter < IL_RATE_MIN_SUCCESS_TH) {
+	if (fail_count < RATE_MIN_FAILURE_TH &&
+	    win->success_counter < RATE_MIN_SUCCESS_TH) {
 		D_RATE("LQ: still below TH. succ=%d total=%d "
 			       "for index %d\n",
 			       win->success_counter, win->counter, index);
@@ -1971,21 +1971,21 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 	/* If user set max rate, dont allow higher than user constrain */
 	if (lq_sta->max_rate_idx != -1 &&
 	    lq_sta->max_rate_idx < high)
-		high = IL_RATE_INVALID;
+		high = RATE_INVALID;
 
 	sr = win->success_ratio;
 
 	/* Collect measured throughputs for current and adjacent rates */
 	current_tpt = win->average_tpt;
-	if (low != IL_RATE_INVALID)
+	if (low != RATE_INVALID)
 		low_tpt = tbl->win[low].average_tpt;
-	if (high != IL_RATE_INVALID)
+	if (high != RATE_INVALID)
 		high_tpt = tbl->win[high].average_tpt;
 
 	scale_action = 0;
 
 	/* Too many failures, decrease rate */
-	if (sr <= IL_RATE_DECREASE_TH || current_tpt == 0) {
+	if (sr <= RATE_DECREASE_TH || current_tpt == 0) {
 		D_RATE(
 			"decrease rate because of low success_ratio\n");
 		scale_action = -1;
@@ -1994,9 +1994,9 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 	} else if (low_tpt == IL_INVALID_VALUE &&
 		   high_tpt == IL_INVALID_VALUE) {
 
-		if (high != IL_RATE_INVALID && sr >= IL_RATE_INCREASE_TH)
+		if (high != RATE_INVALID && sr >= RATE_INCREASE_TH)
 			scale_action = 1;
-		else if (low != IL_RATE_INVALID)
+		else if (low != RATE_INVALID)
 			scale_action = 0;
 	}
 
@@ -2013,7 +2013,7 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 		if (high_tpt != IL_INVALID_VALUE) {
 			/* Higher rate has better throughput */
 			if (high_tpt > current_tpt &&
-			    sr >= IL_RATE_INCREASE_TH) {
+			    sr >= RATE_INCREASE_TH) {
 				scale_action = 1;
 			} else {
 				scale_action = 0;
@@ -2026,7 +2026,7 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 				D_RATE(
 				    "decrease rate because of low tpt\n");
 				scale_action = -1;
-			} else if (sr >= IL_RATE_INCREASE_TH) {
+			} else if (sr >= RATE_INCREASE_TH) {
 				scale_action = 1;
 			}
 		}
@@ -2034,14 +2034,14 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 
 	/* Sanity check; asked for decrease, but success rate or throughput
 	 * has been good at old rate.  Don't change it. */
-	if (scale_action == -1 && low != IL_RATE_INVALID &&
-	    (sr > IL_RATE_HIGH_TH || current_tpt > 100 * tbl->expected_tpt[low]))
+	if (scale_action == -1 && low != RATE_INVALID &&
+	    (sr > RATE_HIGH_TH || current_tpt > 100 * tbl->expected_tpt[low]))
 		scale_action = 0;
 
 	switch (scale_action) {
 	case -1:
 		/* Decrease starting rate, update uCode's rate table */
-		if (low != IL_RATE_INVALID) {
+		if (low != RATE_INVALID) {
 			update_lq = 1;
 			index = low;
 		}
@@ -2049,7 +2049,7 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 		break;
 	case 1:
 		/* Increase starting rate, update uCode's rate table */
-		if (high != IL_RATE_INVALID) {
+		if (high != RATE_INVALID) {
 			update_lq = 1;
 			index = high;
 		}
@@ -2102,7 +2102,7 @@ lq_update:
 		if (lq_sta->search_better_tbl) {
 			/* Access the "search" table, clear its history. */
 			tbl = &(lq_sta->lq_info[(1 - lq_sta->active_tbl)]);
-			for (i = 0; i < IL_RATE_COUNT; i++)
+			for (i = 0; i < RATE_COUNT; i++)
 				il4965_rs_rate_scale_clear_win(
 							&(tbl->win[i]));
 
@@ -2208,7 +2208,7 @@ static void il4965_rs_initialize_lq(struct il_priv *il,
 
 	tbl = &(lq_sta->lq_info[active_tbl]);
 
-	if (i < 0 || i >= IL_RATE_COUNT)
+	if (i < 0 || i >= RATE_COUNT)
 		i = 0;
 
 	rate = il_rates[i].plcp;
@@ -2251,7 +2251,7 @@ il4965_rs_get_rate(void *il_r, struct ieee80211_sta *sta, void *il_sta,
 		    lq_sta->max_rate_idx != -1)
 			lq_sta->max_rate_idx += IL_FIRST_OFDM_RATE;
 		if (lq_sta->max_rate_idx < 0 ||
-		    lq_sta->max_rate_idx >= IL_RATE_COUNT)
+		    lq_sta->max_rate_idx >= RATE_COUNT)
 			lq_sta->max_rate_idx = -1;
 	}
 
@@ -2275,7 +2275,7 @@ il4965_rs_get_rate(void *il_r, struct ieee80211_sta *sta, void *il_sta,
 		/* 6M and 9M shared same MCS index */
 		rate_idx = (rate_idx > 0) ? (rate_idx - 1) : 0;
 		if (il4965_rs_extract_rate(lq_sta->last_rate_n_flags) >=
-			 IL_RATE_MIMO2_6M_PLCP)
+			 RATE_MIMO2_6M_PLCP)
 			rate_idx = rate_idx + MCS_INDEX_PER_STREAM;
 		info->control.rates[0].flags = IEEE80211_TX_RC_MCS;
 		if (lq_sta->last_rate_n_flags & RATE_MCS_SGI_MSK)
@@ -2292,7 +2292,7 @@ il4965_rs_get_rate(void *il_r, struct ieee80211_sta *sta, void *il_sta,
 					IEEE80211_TX_RC_GREEN_FIELD;
 	} else {
 		/* Check for invalid rates */
-		if (rate_idx < 0 || rate_idx >= IL_RATE_COUNT_LEGACY ||
+		if (rate_idx < 0 || rate_idx >= RATE_COUNT_LEGACY ||
 		    (sband->band == IEEE80211_BAND_5GHZ &&
 		     rate_idx < IL_FIRST_OFDM_RATE))
 			rate_idx = rate_lowest_index(sband, sta);
@@ -2345,14 +2345,14 @@ il4965_rs_rate_init(struct il_priv *il,
 	lq_sta->lq.sta_id = sta_id;
 
 	for (j = 0; j < LQ_SIZE; j++)
-		for (i = 0; i < IL_RATE_COUNT; i++)
+		for (i = 0; i < RATE_COUNT; i++)
 			il4965_rs_rate_scale_clear_win(
 					&lq_sta->lq_info[j].win[i]);
 
 	lq_sta->flush_timer = 0;
 	lq_sta->supp_rates = sta->supp_rates[sband->band];
 	for (j = 0; j < LQ_SIZE; j++)
-		for (i = 0; i < IL_RATE_COUNT; i++)
+		for (i = 0; i < RATE_COUNT; i++)
 			il4965_rs_rate_scale_clear_win(
 					&lq_sta->lq_info[j].win[i]);
 
@@ -2745,7 +2745,7 @@ static ssize_t il4965_rs_sta_dbgfs_stats_table_read(struct file *file,
 				lq_sta->lq_info[i].is_dup,
 				lq_sta->is_green,
 				lq_sta->lq_info[i].current_rate);
-		for (j = 0; j < IL_RATE_COUNT; j++) {
+		for (j = 0; j < RATE_COUNT; j++) {
 			desc += sprintf(buff+desc,
 				"counter=%d success=%d %%=%d\n",
 				lq_sta->lq_info[i].win[j].counter,
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-sta.c b/drivers/net/wireless/iwlegacy/iwl-4965-sta.c
index a82d444..278517c 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-sta.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-sta.c
@@ -50,9 +50,9 @@ il4965_sta_alloc_lq(struct il_priv *il, u8 sta_id)
 	/* Set up the rate scaling to start at selected rate, fall back
 	 * all the way down to 1M in IEEE order, and then spin on 1M */
 	if (il->band == IEEE80211_BAND_5GHZ)
-		r = IL_RATE_6M_INDEX;
+		r = RATE_6M_INDEX;
 	else
-		r = IL_RATE_1M_INDEX;
+		r = RATE_1M_INDEX;
 
 	if (r >= IL_FIRST_CCK_RATE && r <= IL_LAST_CCK_RATE)
 		rate_flags |= RATE_MCS_CCK_MSK;
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-tx.c b/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
index 68c86e0..9671e10 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
@@ -196,7 +196,7 @@ static void il4965_tx_cmd_build_rate(struct il_priv *il,
 	 */
 	rate_idx = info->control.rates[0].idx;
 	if ((info->control.rates[0].flags & IEEE80211_TX_RC_MCS) ||
-	    rate_idx < 0 || rate_idx > IL_RATE_COUNT_LEGACY)
+	    rate_idx < 0 || rate_idx > RATE_COUNT_LEGACY)
 		rate_idx = rate_lowest_index(&il->bands[info->band],
 				info->control.sta);
 	/* For 5 GHZ band, remap mac80211 rate indices into driver indices */
diff --git a/drivers/net/wireless/iwlegacy/iwl-commands.h b/drivers/net/wireless/iwlegacy/iwl-commands.h
index d1876d0..aed1101 100644
--- a/drivers/net/wireless/iwlegacy/iwl-commands.h
+++ b/drivers/net/wireless/iwlegacy/iwl-commands.h
@@ -2094,7 +2094,7 @@ struct il_link_quality_cmd {
 	 * 4965 devices works its way through table when retrying Tx.
 	 */
 	struct {
-		__le32 rate_n_flags;	/* RATE_MCS_*, IL_RATE_* */
+		__le32 rate_n_flags;	/* RATE_MCS_*, RATE_* */
 	} rs_table[LINK_QUAL_MAX_RETRY_NUM];
 	__le32 reserved2;
 } __packed;
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.c b/drivers/net/wireless/iwlegacy/iwl-core.c
index 6742a65..de952fb 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.c
+++ b/drivers/net/wireless/iwlegacy/iwl-core.c
@@ -174,7 +174,7 @@ int il_init_geos(struct il_priv *il)
 	if (!channels)
 		return -ENOMEM;
 
-	rates = kzalloc((sizeof(struct ieee80211_rate) * IL_RATE_COUNT_LEGACY),
+	rates = kzalloc((sizeof(struct ieee80211_rate) * RATE_COUNT_LEGACY),
 			GFP_KERNEL);
 	if (!rates) {
 		kfree(channels);
@@ -186,7 +186,7 @@ int il_init_geos(struct il_priv *il)
 	sband->channels = &channels[ARRAY_SIZE(il_eeprom_band_1)];
 	/* just OFDM */
 	sband->bitrates = &rates[IL_FIRST_OFDM_RATE];
-	sband->n_bitrates = IL_RATE_COUNT_LEGACY - IL_FIRST_OFDM_RATE;
+	sband->n_bitrates = RATE_COUNT_LEGACY - IL_FIRST_OFDM_RATE;
 
 	if (il->cfg->sku & IL_SKU_N)
 		il_init_ht_hw_capab(il, &sband->ht_cap,
@@ -196,7 +196,7 @@ int il_init_geos(struct il_priv *il)
 	sband->channels = channels;
 	/* OFDM & CCK */
 	sband->bitrates = rates;
-	sband->n_bitrates = IL_RATE_COUNT_LEGACY;
+	sband->n_bitrates = RATE_COUNT_LEGACY;
 
 	if (il->cfg->sku & IL_SKU_N)
 		il_init_ht_hw_capab(il, &sband->ht_cap,
@@ -454,8 +454,8 @@ il_check_rxon_cmd(struct il_priv *il, struct il_rxon_context *ctx)
 	}
 
 	/* make sure basic rates 6Mbps and 1Mbps are supported */
-	if ((rxon->ofdm_basic_rates & IL_RATE_6M_MASK) == 0 &&
-	    (rxon->cck_basic_rates & IL_RATE_1M_MASK) == 0) {
+	if ((rxon->ofdm_basic_rates & RATE_6M_MASK) == 0 &&
+	    (rxon->cck_basic_rates & RATE_1M_MASK) == 0) {
 		IL_WARN("neither 1 nor 6 are basic\n");
 		error = true;
 	}
@@ -566,9 +566,9 @@ u8 il_get_lowest_plcp(struct il_priv *il,
 	 * the beacon skb from mac80211.
 	 */
 	if (ctx->staging.flags & RXON_FLG_BAND_24G_MSK)
-		return IL_RATE_1M_PLCP;
+		return RATE_1M_PLCP;
 	else
-		return IL_RATE_6M_PLCP;
+		return RATE_6M_PLCP;
 }
 EXPORT_SYMBOL(il_get_lowest_plcp);
 
@@ -835,7 +835,7 @@ void il_set_rate(struct il_priv *il)
 
 	for (i = 0; i < hw->n_bitrates; i++) {
 		rate = &(hw->bitrates[i]);
-		if (rate->hw_value < IL_RATE_COUNT_LEGACY)
+		if (rate->hw_value < RATE_COUNT_LEGACY)
 			il->active_rate |= (1 << rate->hw_value);
 	}
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-legacy-rs.h b/drivers/net/wireless/iwlegacy/iwl-legacy-rs.h
index 19fa92d..6670f2e 100644
--- a/drivers/net/wireless/iwlegacy/iwl-legacy-rs.h
+++ b/drivers/net/wireless/iwlegacy/iwl-legacy-rs.h
@@ -28,10 +28,10 @@
 #define __il_rs_h__
 
 struct il_rate_info {
-	u8 plcp;	/* uCode API:  IL_RATE_6M_PLCP, etc. */
-	u8 plcp_siso;	/* uCode API:  IL_RATE_SISO_6M_PLCP, etc. */
-	u8 plcp_mimo2;	/* uCode API:  IL_RATE_MIMO2_6M_PLCP, etc. */
-	u8 ieee;	/* MAC header:  IL_RATE_6M_IEEE, etc. */
+	u8 plcp;	/* uCode API:  RATE_6M_PLCP, etc. */
+	u8 plcp_siso;	/* uCode API:  RATE_SISO_6M_PLCP, etc. */
+	u8 plcp_mimo2;	/* uCode API:  RATE_MIMO2_6M_PLCP, etc. */
+	u8 ieee;	/* MAC header:  RATE_6M_IEEE, etc. */
 	u8 prev_ieee;    /* previous rate in IEEE speeds */
 	u8 next_ieee;    /* next rate in IEEE speeds */
 	u8 prev_rs;      /* previous rate used in rs algo */
@@ -41,8 +41,8 @@ struct il_rate_info {
 };
 
 struct il3945_rate_info {
-	u8 plcp;		/* uCode API:  IL_RATE_6M_PLCP, etc. */
-	u8 ieee;		/* MAC header:  IL_RATE_6M_IEEE, etc. */
+	u8 plcp;		/* uCode API:  RATE_6M_PLCP, etc. */
+	u8 ieee;		/* MAC header:  RATE_6M_IEEE, etc. */
 	u8 prev_ieee;		/* previous rate in IEEE speeds */
 	u8 next_ieee;		/* next rate in IEEE speeds */
 	u8 prev_rs;		/* previous rate used in rs algo */
@@ -56,153 +56,153 @@ struct il3945_rate_info {
 
 /*
  * These serve as indexes into
- * struct il_rate_info il_rates[IL_RATE_COUNT];
+ * struct il_rate_info il_rates[RATE_COUNT];
  */
 enum {
-	IL_RATE_1M_INDEX = 0,
-	IL_RATE_2M_INDEX,
-	IL_RATE_5M_INDEX,
-	IL_RATE_11M_INDEX,
-	IL_RATE_6M_INDEX,
-	IL_RATE_9M_INDEX,
-	IL_RATE_12M_INDEX,
-	IL_RATE_18M_INDEX,
-	IL_RATE_24M_INDEX,
-	IL_RATE_36M_INDEX,
-	IL_RATE_48M_INDEX,
-	IL_RATE_54M_INDEX,
-	IL_RATE_60M_INDEX,
-	IL_RATE_COUNT,
-	IL_RATE_COUNT_LEGACY = IL_RATE_COUNT - 1,	/* Excluding 60M */
-	IL_RATE_COUNT_3945 = IL_RATE_COUNT - 1,
-	IL_RATE_INVM_INDEX = IL_RATE_COUNT,
-	IL_RATE_INVALID = IL_RATE_COUNT,
+	RATE_1M_INDEX = 0,
+	RATE_2M_INDEX,
+	RATE_5M_INDEX,
+	RATE_11M_INDEX,
+	RATE_6M_INDEX,
+	RATE_9M_INDEX,
+	RATE_12M_INDEX,
+	RATE_18M_INDEX,
+	RATE_24M_INDEX,
+	RATE_36M_INDEX,
+	RATE_48M_INDEX,
+	RATE_54M_INDEX,
+	RATE_60M_INDEX,
+	RATE_COUNT,
+	RATE_COUNT_LEGACY = RATE_COUNT - 1,	/* Excluding 60M */
+	RATE_COUNT_3945 = RATE_COUNT - 1,
+	RATE_INVM_INDEX = RATE_COUNT,
+	RATE_INVALID = RATE_COUNT,
 };
 
 enum {
-	IL_RATE_6M_INDEX_TABLE = 0,
-	IL_RATE_9M_INDEX_TABLE,
-	IL_RATE_12M_INDEX_TABLE,
-	IL_RATE_18M_INDEX_TABLE,
-	IL_RATE_24M_INDEX_TABLE,
-	IL_RATE_36M_INDEX_TABLE,
-	IL_RATE_48M_INDEX_TABLE,
-	IL_RATE_54M_INDEX_TABLE,
-	IL_RATE_1M_INDEX_TABLE,
-	IL_RATE_2M_INDEX_TABLE,
-	IL_RATE_5M_INDEX_TABLE,
-	IL_RATE_11M_INDEX_TABLE,
-	IL_RATE_INVM_INDEX_TABLE = IL_RATE_INVM_INDEX - 1,
+	RATE_6M_INDEX_TABLE = 0,
+	RATE_9M_INDEX_TABLE,
+	RATE_12M_INDEX_TABLE,
+	RATE_18M_INDEX_TABLE,
+	RATE_24M_INDEX_TABLE,
+	RATE_36M_INDEX_TABLE,
+	RATE_48M_INDEX_TABLE,
+	RATE_54M_INDEX_TABLE,
+	RATE_1M_INDEX_TABLE,
+	RATE_2M_INDEX_TABLE,
+	RATE_5M_INDEX_TABLE,
+	RATE_11M_INDEX_TABLE,
+	RATE_INVM_INDEX_TABLE = RATE_INVM_INDEX - 1,
 };
 
 enum {
-	IL_FIRST_OFDM_RATE = IL_RATE_6M_INDEX,
-	IL39_LAST_OFDM_RATE = IL_RATE_54M_INDEX,
-	IL_LAST_OFDM_RATE = IL_RATE_60M_INDEX,
-	IL_FIRST_CCK_RATE = IL_RATE_1M_INDEX,
-	IL_LAST_CCK_RATE = IL_RATE_11M_INDEX,
+	IL_FIRST_OFDM_RATE = RATE_6M_INDEX,
+	IL39_LAST_OFDM_RATE = RATE_54M_INDEX,
+	IL_LAST_OFDM_RATE = RATE_60M_INDEX,
+	IL_FIRST_CCK_RATE = RATE_1M_INDEX,
+	IL_LAST_CCK_RATE = RATE_11M_INDEX,
 };
 
 /* #define vs. enum to keep from defaulting to 'large integer' */
-#define	IL_RATE_6M_MASK   (1 << IL_RATE_6M_INDEX)
-#define	IL_RATE_9M_MASK   (1 << IL_RATE_9M_INDEX)
-#define	IL_RATE_12M_MASK  (1 << IL_RATE_12M_INDEX)
-#define	IL_RATE_18M_MASK  (1 << IL_RATE_18M_INDEX)
-#define	IL_RATE_24M_MASK  (1 << IL_RATE_24M_INDEX)
-#define	IL_RATE_36M_MASK  (1 << IL_RATE_36M_INDEX)
-#define	IL_RATE_48M_MASK  (1 << IL_RATE_48M_INDEX)
-#define	IL_RATE_54M_MASK  (1 << IL_RATE_54M_INDEX)
-#define IL_RATE_60M_MASK  (1 << IL_RATE_60M_INDEX)
-#define	IL_RATE_1M_MASK   (1 << IL_RATE_1M_INDEX)
-#define	IL_RATE_2M_MASK   (1 << IL_RATE_2M_INDEX)
-#define	IL_RATE_5M_MASK   (1 << IL_RATE_5M_INDEX)
-#define	IL_RATE_11M_MASK  (1 << IL_RATE_11M_INDEX)
+#define	RATE_6M_MASK   (1 << RATE_6M_INDEX)
+#define	RATE_9M_MASK   (1 << RATE_9M_INDEX)
+#define	RATE_12M_MASK  (1 << RATE_12M_INDEX)
+#define	RATE_18M_MASK  (1 << RATE_18M_INDEX)
+#define	RATE_24M_MASK  (1 << RATE_24M_INDEX)
+#define	RATE_36M_MASK  (1 << RATE_36M_INDEX)
+#define	RATE_48M_MASK  (1 << RATE_48M_INDEX)
+#define	RATE_54M_MASK  (1 << RATE_54M_INDEX)
+#define RATE_60M_MASK  (1 << RATE_60M_INDEX)
+#define	RATE_1M_MASK   (1 << RATE_1M_INDEX)
+#define	RATE_2M_MASK   (1 << RATE_2M_INDEX)
+#define	RATE_5M_MASK   (1 << RATE_5M_INDEX)
+#define	RATE_11M_MASK  (1 << RATE_11M_INDEX)
 
 /* uCode API values for legacy bit rates, both OFDM and CCK */
 enum {
-	IL_RATE_6M_PLCP  = 13,
-	IL_RATE_9M_PLCP  = 15,
-	IL_RATE_12M_PLCP = 5,
-	IL_RATE_18M_PLCP = 7,
-	IL_RATE_24M_PLCP = 9,
-	IL_RATE_36M_PLCP = 11,
-	IL_RATE_48M_PLCP = 1,
-	IL_RATE_54M_PLCP = 3,
-	IL_RATE_60M_PLCP = 3,/*FIXME:RS:should be removed*/
-	IL_RATE_1M_PLCP  = 10,
-	IL_RATE_2M_PLCP  = 20,
-	IL_RATE_5M_PLCP  = 55,
-	IL_RATE_11M_PLCP = 110,
-	/*FIXME:RS:add IL_RATE_LEGACY_INVM_PLCP = 0,*/
+	RATE_6M_PLCP  = 13,
+	RATE_9M_PLCP  = 15,
+	RATE_12M_PLCP = 5,
+	RATE_18M_PLCP = 7,
+	RATE_24M_PLCP = 9,
+	RATE_36M_PLCP = 11,
+	RATE_48M_PLCP = 1,
+	RATE_54M_PLCP = 3,
+	RATE_60M_PLCP = 3,/*FIXME:RS:should be removed*/
+	RATE_1M_PLCP  = 10,
+	RATE_2M_PLCP  = 20,
+	RATE_5M_PLCP  = 55,
+	RATE_11M_PLCP = 110,
+	/*FIXME:RS:add RATE_LEGACY_INVM_PLCP = 0,*/
 };
 
 /* uCode API values for OFDM high-throughput (HT) bit rates */
 enum {
-	IL_RATE_SISO_6M_PLCP = 0,
-	IL_RATE_SISO_12M_PLCP = 1,
-	IL_RATE_SISO_18M_PLCP = 2,
-	IL_RATE_SISO_24M_PLCP = 3,
-	IL_RATE_SISO_36M_PLCP = 4,
-	IL_RATE_SISO_48M_PLCP = 5,
-	IL_RATE_SISO_54M_PLCP = 6,
-	IL_RATE_SISO_60M_PLCP = 7,
-	IL_RATE_MIMO2_6M_PLCP  = 0x8,
-	IL_RATE_MIMO2_12M_PLCP = 0x9,
-	IL_RATE_MIMO2_18M_PLCP = 0xa,
-	IL_RATE_MIMO2_24M_PLCP = 0xb,
-	IL_RATE_MIMO2_36M_PLCP = 0xc,
-	IL_RATE_MIMO2_48M_PLCP = 0xd,
-	IL_RATE_MIMO2_54M_PLCP = 0xe,
-	IL_RATE_MIMO2_60M_PLCP = 0xf,
-	IL_RATE_SISO_INVM_PLCP,
-	IL_RATE_MIMO2_INVM_PLCP = IL_RATE_SISO_INVM_PLCP,
+	RATE_SISO_6M_PLCP = 0,
+	RATE_SISO_12M_PLCP = 1,
+	RATE_SISO_18M_PLCP = 2,
+	RATE_SISO_24M_PLCP = 3,
+	RATE_SISO_36M_PLCP = 4,
+	RATE_SISO_48M_PLCP = 5,
+	RATE_SISO_54M_PLCP = 6,
+	RATE_SISO_60M_PLCP = 7,
+	RATE_MIMO2_6M_PLCP  = 0x8,
+	RATE_MIMO2_12M_PLCP = 0x9,
+	RATE_MIMO2_18M_PLCP = 0xa,
+	RATE_MIMO2_24M_PLCP = 0xb,
+	RATE_MIMO2_36M_PLCP = 0xc,
+	RATE_MIMO2_48M_PLCP = 0xd,
+	RATE_MIMO2_54M_PLCP = 0xe,
+	RATE_MIMO2_60M_PLCP = 0xf,
+	RATE_SISO_INVM_PLCP,
+	RATE_MIMO2_INVM_PLCP = RATE_SISO_INVM_PLCP,
 };
 
 /* MAC header values for bit rates */
 enum {
-	IL_RATE_6M_IEEE  = 12,
-	IL_RATE_9M_IEEE  = 18,
-	IL_RATE_12M_IEEE = 24,
-	IL_RATE_18M_IEEE = 36,
-	IL_RATE_24M_IEEE = 48,
-	IL_RATE_36M_IEEE = 72,
-	IL_RATE_48M_IEEE = 96,
-	IL_RATE_54M_IEEE = 108,
-	IL_RATE_60M_IEEE = 120,
-	IL_RATE_1M_IEEE  = 2,
-	IL_RATE_2M_IEEE  = 4,
-	IL_RATE_5M_IEEE  = 11,
-	IL_RATE_11M_IEEE = 22,
+	RATE_6M_IEEE  = 12,
+	RATE_9M_IEEE  = 18,
+	RATE_12M_IEEE = 24,
+	RATE_18M_IEEE = 36,
+	RATE_24M_IEEE = 48,
+	RATE_36M_IEEE = 72,
+	RATE_48M_IEEE = 96,
+	RATE_54M_IEEE = 108,
+	RATE_60M_IEEE = 120,
+	RATE_1M_IEEE  = 2,
+	RATE_2M_IEEE  = 4,
+	RATE_5M_IEEE  = 11,
+	RATE_11M_IEEE = 22,
 };
 
 #define IL_CCK_BASIC_RATES_MASK    \
-	(IL_RATE_1M_MASK          | \
-	IL_RATE_2M_MASK)
+	(RATE_1M_MASK          | \
+	RATE_2M_MASK)
 
 #define IL_CCK_RATES_MASK          \
 	(IL_CCK_BASIC_RATES_MASK  | \
-	IL_RATE_5M_MASK          | \
-	IL_RATE_11M_MASK)
+	RATE_5M_MASK          | \
+	RATE_11M_MASK)
 
 #define IL_OFDM_BASIC_RATES_MASK   \
-	(IL_RATE_6M_MASK         | \
-	IL_RATE_12M_MASK         | \
-	IL_RATE_24M_MASK)
+	(RATE_6M_MASK         | \
+	RATE_12M_MASK         | \
+	RATE_24M_MASK)
 
 #define IL_OFDM_RATES_MASK         \
 	(IL_OFDM_BASIC_RATES_MASK | \
-	IL_RATE_9M_MASK          | \
-	IL_RATE_18M_MASK         | \
-	IL_RATE_36M_MASK         | \
-	IL_RATE_48M_MASK         | \
-	IL_RATE_54M_MASK)
+	RATE_9M_MASK          | \
+	RATE_18M_MASK         | \
+	RATE_36M_MASK         | \
+	RATE_48M_MASK         | \
+	RATE_54M_MASK)
 
 #define IL_BASIC_RATES_MASK         \
 	(IL_OFDM_BASIC_RATES_MASK | \
 	 IL_CCK_BASIC_RATES_MASK)
 
-#define IL_RATES_MASK ((1 << IL_RATE_COUNT) - 1)
-#define IL_RATES_MASK_3945 ((1 << IL_RATE_COUNT_3945) - 1)
+#define RATES_MASK ((1 << RATE_COUNT) - 1)
+#define RATES_MASK_3945 ((1 << RATE_COUNT_3945) - 1)
 
 #define IL_INVALID_VALUE    -1
 
@@ -221,10 +221,10 @@ enum {
 
 /* Success ratio (ACKed / attempted tx frames) values (perfect is 128 * 100) */
 #define IL_RS_GOOD_RATIO		12800	/* 100% */
-#define IL_RATE_SCALE_SWITCH		10880	/*  85% */
-#define IL_RATE_HIGH_TH		10880	/*  85% */
-#define IL_RATE_INCREASE_TH		6400	/*  50% */
-#define IL_RATE_DECREASE_TH		1920	/*  15% */
+#define RATE_SCALE_SWITCH		10880	/*  85% */
+#define RATE_HIGH_TH		10880	/*  85% */
+#define RATE_INCREASE_TH		6400	/*  50% */
+#define RATE_DECREASE_TH		1920	/*  15% */
 
 /* possible actions when in legacy mode */
 #define IL_LEGACY_SWITCH_ANTENNA1      0
@@ -268,7 +268,7 @@ enum {
 #define TID_MAX_TIME_DIFF ((TID_QUEUE_MAX_SIZE - 1) * TID_QUEUE_CELL_SPACING)
 #define TIME_WRAP_AROUND(x, y) (((y) > (x)) ? (y) - (x) : (0-(x)) + (y))
 
-extern const struct il_rate_info il_rates[IL_RATE_COUNT];
+extern const struct il_rate_info il_rates[RATE_COUNT];
 
 enum il_table_type {
 	LQ_NONE,
@@ -331,7 +331,7 @@ struct il_scale_tbl_info {
 	u8 max_search;	/* maximun number of tables we can search */
 	s32 *expected_tpt;	/* throughput metrics; expected_tpt_G, etc. */
 	u32 current_rate;  /* rate_n_flags, uCode API format */
-	struct il_rate_scale_data win[IL_RATE_COUNT]; /* rate histories */
+	struct il_rate_scale_data win[RATE_COUNT]; /* rate histories */
 };
 
 struct il_traffic_load {
@@ -371,7 +371,7 @@ struct il_lq_sta {
 	u8 is_dup;
 	enum ieee80211_band band;
 
-	/* The following are bitmaps of rates; IL_RATE_6M_MASK, etc. */
+	/* The following are bitmaps of rates; RATE_6M_MASK, etc. */
 	u32 supp_rates;
 	u16 active_legacy_rate;
 	u16 active_siso_rate;
diff --git a/drivers/net/wireless/iwlegacy/iwl-sta.c b/drivers/net/wireless/iwlegacy/iwl-sta.c
index 3c354a8..dcaa3fb 100644
--- a/drivers/net/wireless/iwlegacy/iwl-sta.c
+++ b/drivers/net/wireless/iwlegacy/iwl-sta.c
@@ -314,7 +314,7 @@ u8 il_prep_station(struct il_priv *il, struct il_rxon_context *ctx,
 
 	/* 3945 only */
 	rate = (il->band == IEEE80211_BAND_5GHZ) ?
-		IL_RATE_6M_PLCP : IL_RATE_1M_PLCP;
+		RATE_6M_PLCP : RATE_1M_PLCP;
 	/* Turn on both antennas for the station... */
 	station->sta.rate_n_flags = cpu_to_le16(rate | RATE_MCS_ANT_AB_MSK);
 
diff --git a/drivers/net/wireless/iwlegacy/iwl3945-base.c b/drivers/net/wireless/iwlegacy/iwl3945-base.c
index c602570..1fc9bfb 100644
--- a/drivers/net/wireless/iwlegacy/iwl3945-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl3945-base.c
@@ -1654,7 +1654,7 @@ static void il3945_init_hw_rates(struct il_priv *il,
 {
 	int i;
 
-	for (i = 0; i < IL_RATE_COUNT_LEGACY; i++) {
+	for (i = 0; i < RATE_COUNT_LEGACY; i++) {
 		rates[i].bitrate = il3945_rates[i].ieee * 5;
 		rates[i].hw_value = i; /* Rate scaling will work on indexes */
 		rates[i].hw_value_short = i;
@@ -2239,7 +2239,7 @@ static void il3945_alive_start(struct il_priv *il)
 
 	ieee80211_wake_queues(il->hw);
 
-	il->active_rate = IL_RATES_MASK_3945;
+	il->active_rate = RATES_MASK_3945;
 
 	il_power_update_mode(il, true);
 
@@ -2642,11 +2642,11 @@ int il3945_request_scan(struct il_priv *il, struct ieee80211_vif *vif)
 	switch (il->scan_band) {
 	case IEEE80211_BAND_2GHZ:
 		scan->flags = RXON_FLG_BAND_24G_MSK | RXON_FLG_AUTO_DETECT_MSK;
-		scan->tx_cmd.rate = IL_RATE_1M_PLCP;
+		scan->tx_cmd.rate = RATE_1M_PLCP;
 		band = IEEE80211_BAND_2GHZ;
 		break;
 	case IEEE80211_BAND_5GHZ:
-		scan->tx_cmd.rate = IL_RATE_6M_PLCP;
+		scan->tx_cmd.rate = RATE_6M_PLCP;
 		band = IEEE80211_BAND_5GHZ;
 		break;
 	default:
diff --git a/drivers/net/wireless/iwlegacy/iwl4965-base.c b/drivers/net/wireless/iwlegacy/iwl4965-base.c
index 736c2f5..bc5a008 100644
--- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
@@ -1757,7 +1757,7 @@ static void il4965_alive_start(struct il_priv *il)
 
 	ieee80211_wake_queues(il->hw);
 
-	il->active_rate = IL_RATES_MASK;
+	il->active_rate = RATES_MASK;
 
 	if (il_is_associated_ctx(ctx)) {
 		struct il_rxon_cmd *active_rxon =
@@ -2711,7 +2711,7 @@ static void il4965_init_hw_rates(struct il_priv *il,
 {
 	int i;
 
-	for (i = 0; i < IL_RATE_COUNT_LEGACY; i++) {
+	for (i = 0; i < RATE_COUNT_LEGACY; i++) {
 		rates[i].bitrate = il_rates[i].ieee * 5;
 		rates[i].hw_value = i; /* Rate scaling will work on indexes */
 		rates[i].hw_value_short = i;
@@ -2721,7 +2721,7 @@ static void il4965_init_hw_rates(struct il_priv *il,
 			 * If CCK != 1M then set short preamble rate flag.
 			 */
 			rates[i].flags |=
-				(il_rates[i].plcp == IL_RATE_1M_PLCP) ?
+				(il_rates[i].plcp == RATE_1M_PLCP) ?
 					0 : IEEE80211_RATE_SHORT_PREAMBLE;
 		}
 	}
-- 
1.7.1

