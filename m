Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:33687 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932097AbaHVONE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2014 10:13:04 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	nbd@nbd.name, thomas@net.t-labs.tu-berlin.de, ikstream86@gmail.com
Subject: [PATCH 1/2] mac80211: Unify rate statistic variables between Minstrel & Minstrel_HT
Date: Fri, 22 Aug 2014 16:05:32 +0200
Message-Id: <1408716333-18492-2-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20140822_161312_962983_D8F19141)
In-Reply-To: <1408716333-18492-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1408716333-18492-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Minstrel and Mintrel_HT use individual structs to keep track of rate
statistics. Unify those variables in struct minstrel_rate_stats and
move it to rc80211_minstrel.h for common usage. This is a clean-up
patch to prepare Minstrel and Minstrel_HT codebase for upcoming TPC.

Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
---
 net/mac80211/rc80211_minstrel.c         | 98 +++++++++++++++++----------------
 net/mac80211/rc80211_minstrel.h         | 43 ++++++++-------
 net/mac80211/rc80211_minstrel_debugfs.c | 19 ++++---
 net/mac80211/rc80211_minstrel_ht.h      | 22 --------
 4 files changed, 85 insertions(+), 97 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index 1c1469c..2baa7ed 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -75,7 +75,7 @@ minstrel_sort_best_tp_rates(struct minstrel_sta_info *mi, int i, u8 *tp_list)
 {
 	int j = MAX_THR_RATES;
 
-	while (j > 0 && mi->r[i].cur_tp > mi->r[tp_list[j - 1]].cur_tp)
+	while (j > 0 && mi->r[i].stats.cur_tp > mi->r[tp_list[j - 1]].stats.cur_tp)
 		j--;
 	if (j < MAX_THR_RATES - 1)
 		memmove(&tp_list[j + 1], &tp_list[j], MAX_THR_RATES - (j + 1));
@@ -92,7 +92,7 @@ minstrel_set_rate(struct minstrel_sta_info *mi, struct ieee80211_sta_rates *rate
 	ratetbl->rate[offset].idx = r->rix;
 	ratetbl->rate[offset].count = r->adjusted_retry_count;
 	ratetbl->rate[offset].count_cts = r->retry_count_cts;
-	ratetbl->rate[offset].count_rts = r->retry_count_rtscts;
+	ratetbl->rate[offset].count_rts = r->stats.retry_count_rtscts;
 }
 
 static void
@@ -140,44 +140,46 @@ minstrel_update_stats(struct minstrel_priv *mp, struct minstrel_sta_info *mi)
 
 	for (i = 0; i < mi->n_rates; i++) {
 		struct minstrel_rate *mr = &mi->r[i];
+		struct minstrel_rate_stats *mrs = &mi->r[i].stats;
 
 		usecs = mr->perfect_tx_time;
 		if (!usecs)
 			usecs = 1000000;
 
-		if (unlikely(mr->attempts > 0)) {
-			mr->sample_skipped = 0;
-			mr->cur_prob = MINSTREL_FRAC(mr->success, mr->attempts);
-			mr->succ_hist += mr->success;
-			mr->att_hist += mr->attempts;
-			mr->probability = minstrel_ewma(mr->probability,
-							mr->cur_prob,
-							EWMA_LEVEL);
+		if (unlikely(mrs->attempts > 0)) {
+			mrs->sample_skipped = 0;
+			mrs->cur_prob = MINSTREL_FRAC(mrs->success,
+						      mrs->attempts);
+			mrs->succ_hist += mrs->success;
+			mrs->att_hist += mrs->attempts;
+			mrs->probability = minstrel_ewma(mrs->probability,
+							 mrs->cur_prob,
+							 EWMA_LEVEL);
 		} else
-			mr->sample_skipped++;
+			mrs->sample_skipped++;
 
-		mr->last_success = mr->success;
-		mr->last_attempts = mr->attempts;
-		mr->success = 0;
-		mr->attempts = 0;
+		mrs->last_success = mrs->success;
+		mrs->last_attempts = mrs->attempts;
+		mrs->success = 0;
+		mrs->attempts = 0;
 
 		/* Update throughput per rate, reset thr. below 10% success */
-		if (mr->probability < MINSTREL_FRAC(10, 100))
-			mr->cur_tp = 0;
+		if (mrs->probability < MINSTREL_FRAC(10, 100))
+			mrs->cur_tp = 0;
 		else
-			mr->cur_tp = mr->probability * (1000000 / usecs);
+			mrs->cur_tp = mrs->probability * (1000000 / usecs);
 
 		/* Sample less often below the 10% chance of success.
 		 * Sample less often above the 95% chance of success. */
-		if (mr->probability > MINSTREL_FRAC(95, 100) ||
-		    mr->probability < MINSTREL_FRAC(10, 100)) {
-			mr->adjusted_retry_count = mr->retry_count >> 1;
+		if (mrs->probability > MINSTREL_FRAC(95, 100) ||
+		    mrs->probability < MINSTREL_FRAC(10, 100)) {
+			mr->adjusted_retry_count = mrs->retry_count >> 1;
 			if (mr->adjusted_retry_count > 2)
 				mr->adjusted_retry_count = 2;
 			mr->sample_limit = 4;
 		} else {
 			mr->sample_limit = -1;
-			mr->adjusted_retry_count = mr->retry_count;
+			mr->adjusted_retry_count = mrs->retry_count;
 		}
 		if (!mr->adjusted_retry_count)
 			mr->adjusted_retry_count = 2;
@@ -190,11 +192,11 @@ minstrel_update_stats(struct minstrel_priv *mp, struct minstrel_sta_info *mi)
 		 * choose the maximum throughput rate as max_prob_rate
 		 * (2) if all success probabilities < 95%, the rate with
 		 * highest success probability is choosen as max_prob_rate */
-		if (mr->probability >= MINSTREL_FRAC(95, 100)) {
-			if (mr->cur_tp >= mi->r[tmp_prob_rate].cur_tp)
+		if (mrs->probability >= MINSTREL_FRAC(95, 100)) {
+			if (mrs->cur_tp >= mi->r[tmp_prob_rate].stats.cur_tp)
 				tmp_prob_rate = i;
 		} else {
-			if (mr->probability >= mi->r[tmp_prob_rate].probability)
+			if (mrs->probability >= mi->r[tmp_prob_rate].stats.probability)
 				tmp_prob_rate = i;
 		}
 	}
@@ -240,14 +242,14 @@ minstrel_tx_status(void *priv, struct ieee80211_supported_band *sband,
 		if (ndx < 0)
 			continue;
 
-		mi->r[ndx].attempts += ar[i].count;
+		mi->r[ndx].stats.attempts += ar[i].count;
 
 		if ((i != IEEE80211_TX_MAX_RATES - 1) && (ar[i + 1].idx < 0))
-			mi->r[ndx].success += success;
+			mi->r[ndx].stats.success += success;
 	}
 
 	if ((info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE) && (i >= 0))
-		mi->sample_count++;
+		mi->sample_packets++;
 
 	if (mi->sample_deferred > 0)
 		mi->sample_deferred--;
@@ -265,7 +267,7 @@ minstrel_get_retry_count(struct minstrel_rate *mr,
 	unsigned int retry = mr->adjusted_retry_count;
 
 	if (info->control.use_rts)
-		retry = max(2U, min(mr->retry_count_rtscts, retry));
+		retry = max(2U, min(mr->stats.retry_count_rtscts, retry));
 	else if (info->control.use_cts_prot)
 		retry = max(2U, min(mr->retry_count_cts, retry));
 	return retry;
@@ -317,15 +319,15 @@ minstrel_get_rate(void *priv, struct ieee80211_sta *sta,
 		sampling_ratio = mp->lookaround_rate;
 
 	/* increase sum packet counter */
-	mi->packet_count++;
+	mi->total_packets++;
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 	if (mp->fixed_rate_idx != -1)
 		return;
 #endif
 
-	delta = (mi->packet_count * sampling_ratio / 100) -
-			(mi->sample_count + mi->sample_deferred / 2);
+	delta = (mi->total_packets * sampling_ratio / 100) -
+			(mi->sample_packets + mi->sample_deferred / 2);
 
 	/* delta < 0: no sampling required */
 	prev_sample = mi->prev_sample;
@@ -333,10 +335,10 @@ minstrel_get_rate(void *priv, struct ieee80211_sta *sta,
 	if (delta < 0 || (!mrr_capable && prev_sample))
 		return;
 
-	if (mi->packet_count >= 10000) {
+	if (mi->total_packets >= 10000) {
 		mi->sample_deferred = 0;
-		mi->sample_count = 0;
-		mi->packet_count = 0;
+		mi->sample_packets = 0;
+		mi->total_packets = 0;
 	} else if (delta > mi->n_rates * 2) {
 		/* With multi-rate retry, not every planned sample
 		 * attempt actually gets used, due to the way the retry
@@ -347,7 +349,7 @@ minstrel_get_rate(void *priv, struct ieee80211_sta *sta,
 		 * starts getting worse, minstrel would start bursting
 		 * out lots of sampling frames, which would result
 		 * in a large throughput loss. */
-		mi->sample_count += (delta - mi->n_rates * 2);
+		mi->sample_packets += (delta - mi->n_rates * 2);
 	}
 
 	/* get next random rate sample */
@@ -361,7 +363,7 @@ minstrel_get_rate(void *priv, struct ieee80211_sta *sta,
 	 */
 	if (mrr_capable &&
 	    msr->perfect_tx_time > mr->perfect_tx_time &&
-	    msr->sample_skipped < 20) {
+	    msr->stats.sample_skipped < 20) {
 		/* Only use IEEE80211_TX_CTL_RATE_CTRL_PROBE to mark
 		 * packets that have the sampling rate deferred to the
 		 * second MRR stage. Increase the sample counter only
@@ -375,7 +377,7 @@ minstrel_get_rate(void *priv, struct ieee80211_sta *sta,
 		if (!msr->sample_limit != 0)
 			return;
 
-		mi->sample_count++;
+		mi->sample_packets++;
 		if (msr->sample_limit > 0)
 			msr->sample_limit--;
 	}
@@ -384,7 +386,7 @@ minstrel_get_rate(void *priv, struct ieee80211_sta *sta,
 	 * has a probability of >95%, we shouldn't be attempting
 	 * to use it, as this only wastes precious airtime */
 	if (!mrr_capable &&
-	   (mi->r[ndx].probability > MINSTREL_FRAC(95, 100)))
+	   (mi->r[ndx].stats.probability > MINSTREL_FRAC(95, 100)))
 		return;
 
 	mi->prev_sample = true;
@@ -459,6 +461,7 @@ minstrel_rate_init(void *priv, struct ieee80211_supported_band *sband,
 
 	for (i = 0; i < sband->n_bitrates; i++) {
 		struct minstrel_rate *mr = &mi->r[n];
+		struct minstrel_rate_stats *mrs = &mi->r[n].stats;
 		unsigned int tx_time = 0, tx_time_cts = 0, tx_time_rtscts = 0;
 		unsigned int tx_time_single;
 		unsigned int cw = mp->cw_min;
@@ -471,6 +474,7 @@ minstrel_rate_init(void *priv, struct ieee80211_supported_band *sband,
 
 		n++;
 		memset(mr, 0, sizeof(*mr));
+		memset(mrs, 0, sizeof(*mrs));
 
 		mr->rix = i;
 		shift = ieee80211_chandef_get_shift(chandef);
@@ -482,9 +486,9 @@ minstrel_rate_init(void *priv, struct ieee80211_supported_band *sband,
 		/* calculate maximum number of retransmissions before
 		 * fallback (based on maximum segment size) */
 		mr->sample_limit = -1;
-		mr->retry_count = 1;
+		mrs->retry_count = 1;
 		mr->retry_count_cts = 1;
-		mr->retry_count_rtscts = 1;
+		mrs->retry_count_rtscts = 1;
 		tx_time = mr->perfect_tx_time + mi->sp_ack_dur;
 		do {
 			/* add one retransmission */
@@ -501,13 +505,13 @@ minstrel_rate_init(void *priv, struct ieee80211_supported_band *sband,
 				(mr->retry_count_cts < mp->max_retry))
 				mr->retry_count_cts++;
 			if ((tx_time_rtscts < mp->segment_size) &&
-				(mr->retry_count_rtscts < mp->max_retry))
-				mr->retry_count_rtscts++;
+				(mrs->retry_count_rtscts < mp->max_retry))
+				mrs->retry_count_rtscts++;
 		} while ((tx_time < mp->segment_size) &&
-				(++mr->retry_count < mp->max_retry));
-		mr->adjusted_retry_count = mr->retry_count;
+				(++mr->stats.retry_count < mp->max_retry));
+		mr->adjusted_retry_count = mrs->retry_count;
 		if (!(sband->bitrates[i].flags & IEEE80211_RATE_ERP_G))
-			mr->retry_count_cts = mr->retry_count;
+			mr->retry_count_cts = mrs->retry_count;
 	}
 
 	for (i = n; i < sband->n_bitrates; i++) {
@@ -665,7 +669,7 @@ static u32 minstrel_get_expected_throughput(void *priv_sta)
 	/* convert pkt per sec in kbps (1200 is the average pkt size used for
 	 * computing cur_tp
 	 */
-	return MINSTREL_TRUNC(mi->r[idx].cur_tp) * 1200 * 8 / 1024;
+	return MINSTREL_TRUNC(mi->r[idx].stats.cur_tp) * 1200 * 8 / 1024;
 }
 
 const struct rate_control_ops mac80211_minstrel = {
diff --git a/net/mac80211/rc80211_minstrel.h b/net/mac80211/rc80211_minstrel.h
index 046d1bd..97eca86 100644
--- a/net/mac80211/rc80211_minstrel.h
+++ b/net/mac80211/rc80211_minstrel.h
@@ -31,6 +31,27 @@ minstrel_ewma(int old, int new, int weight)
 	return (new * (EWMA_DIV - weight) + old * weight) / EWMA_DIV;
 }
 
+struct minstrel_rate_stats {
+	/* current / last sampling period attempts/success counters */
+	unsigned int attempts, last_attempts;
+	unsigned int success, last_success;
+
+	/* total attempts/success counters */
+	u64 att_hist, succ_hist;
+
+	/* current throughput */
+	unsigned int cur_tp;
+
+	/* packet delivery probabilities */
+	unsigned int cur_prob, probability;
+
+	/* maximum retry counts */
+	unsigned int retry_count;
+	unsigned int retry_count_rtscts;
+
+	u8 sample_skipped;
+	bool retry_updated;
+};
 
 struct minstrel_rate {
 	int bitrate;
@@ -40,26 +61,10 @@ struct minstrel_rate {
 	unsigned int ack_time;
 
 	int sample_limit;
-	unsigned int retry_count;
 	unsigned int retry_count_cts;
-	unsigned int retry_count_rtscts;
 	unsigned int adjusted_retry_count;
 
-	u32 success;
-	u32 attempts;
-	u32 last_attempts;
-	u32 last_success;
-	u8 sample_skipped;
-
-	/* parts per thousand */
-	u32 cur_prob;
-	u32 probability;
-
-	/* per-rate throughput */
-	u32 cur_tp;
-
-	u64 succ_hist;
-	u64 att_hist;
+	struct minstrel_rate_stats stats;
 };
 
 struct minstrel_sta_info {
@@ -73,8 +78,8 @@ struct minstrel_sta_info {
 
 	u8 max_tp_rate[MAX_THR_RATES];
 	u8 max_prob_rate;
-	unsigned int packet_count;
-	unsigned int sample_count;
+	unsigned int total_packets;
+	unsigned int sample_packets;
 	int sample_deferred;
 
 	unsigned int sample_row;
diff --git a/net/mac80211/rc80211_minstrel_debugfs.c b/net/mac80211/rc80211_minstrel_debugfs.c
index fd0b9ca..edde723 100644
--- a/net/mac80211/rc80211_minstrel_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_debugfs.c
@@ -72,6 +72,7 @@ minstrel_stats_open(struct inode *inode, struct file *file)
 			"this succ/attempt   success    attempts\n");
 	for (i = 0; i < mi->n_rates; i++) {
 		struct minstrel_rate *mr = &mi->r[i];
+		struct minstrel_rate_stats *mrs = &mi->r[i].stats;
 
 		*(p++) = (i == mi->max_tp_rate[0]) ? 'A' : ' ';
 		*(p++) = (i == mi->max_tp_rate[1]) ? 'B' : ' ';
@@ -81,24 +82,24 @@ minstrel_stats_open(struct inode *inode, struct file *file)
 		p += sprintf(p, "%3u%s", mr->bitrate / 2,
 				(mr->bitrate & 1 ? ".5" : "  "));
 
-		tp = MINSTREL_TRUNC(mr->cur_tp / 10);
-		prob = MINSTREL_TRUNC(mr->cur_prob * 1000);
-		eprob = MINSTREL_TRUNC(mr->probability * 1000);
+		tp = MINSTREL_TRUNC(mrs->cur_tp / 10);
+		prob = MINSTREL_TRUNC(mrs->cur_prob * 1000);
+		eprob = MINSTREL_TRUNC(mrs->probability * 1000);
 
 		p += sprintf(p, "  %6u.%1u   %6u.%1u   %6u.%1u        "
 				"   %3u(%3u)  %8llu    %8llu\n",
 				tp / 10, tp % 10,
 				eprob / 10, eprob % 10,
 				prob / 10, prob % 10,
-				mr->last_success,
-				mr->last_attempts,
-				(unsigned long long)mr->succ_hist,
-				(unsigned long long)mr->att_hist);
+				mrs->last_success,
+				mrs->last_attempts,
+				(unsigned long long)mrs->succ_hist,
+				(unsigned long long)mrs->att_hist);
 	}
 	p += sprintf(p, "\nTotal packet count::    ideal %d      "
 			"lookaround %d\n\n",
-			mi->packet_count - mi->sample_count,
-			mi->sample_count);
+			mi->total_packets - mi->sample_packets,
+			mi->sample_packets);
 	ms->len = p - ms->buf;
 
 	return 0;
diff --git a/net/mac80211/rc80211_minstrel_ht.h b/net/mac80211/rc80211_minstrel_ht.h
index d655586..5fee938 100644
--- a/net/mac80211/rc80211_minstrel_ht.h
+++ b/net/mac80211/rc80211_minstrel_ht.h
@@ -26,28 +26,6 @@ struct mcs_group {
 
 extern const struct mcs_group minstrel_mcs_groups[];
 
-struct minstrel_rate_stats {
-	/* current / last sampling period attempts/success counters */
-	unsigned int attempts, last_attempts;
-	unsigned int success, last_success;
-
-	/* total attempts/success counters */
-	u64 att_hist, succ_hist;
-
-	/* current throughput */
-	unsigned int cur_tp;
-
-	/* packet delivery probabilities */
-	unsigned int cur_prob, probability;
-
-	/* maximum retry counts */
-	unsigned int retry_count;
-	unsigned int retry_count_rtscts;
-
-	bool retry_updated;
-	u8 sample_skipped;
-};
-
 struct minstrel_mcs_group_data {
 	u8 index;
 	u8 column;
-- 
2.1.0

