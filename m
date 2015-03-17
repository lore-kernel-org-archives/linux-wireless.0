Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:45831 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932751AbbCQR2S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2015 13:28:18 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, nbd@nbd.name,
	thomas@net.t-labs.tu-berlin.de
Subject: [PATCH v3 06/10] mac80211: improve Minstrel variable & function naming
Date: Tue, 17 Mar 2015 18:29:15 +0100
Message-Id: <1426613359-31306-6-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20150317_182900_660428_297704C3)
In-Reply-To: <1426613359-31306-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1426613359-31306-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch ensures a consistent usage of variable names for type
"minstrel_rate_stats" to be used as "mrs" and from type minstrel_rate
as "mr" across both Minstrel & Minstrel-HT. In addition some
variable and function names got changed to more meaningful ones.

Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
---
 net/mac80211/rc80211_minstrel.c            |  26 +++----
 net/mac80211/rc80211_minstrel.h            |  13 ++--
 net/mac80211/rc80211_minstrel_debugfs.c    |   4 +-
 net/mac80211/rc80211_minstrel_ht.c         | 112 ++++++++++++++---------------
 net/mac80211/rc80211_minstrel_ht.h         |   2 +-
 net/mac80211/rc80211_minstrel_ht_debugfs.c |  36 +++++-----
 6 files changed, 98 insertions(+), 95 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index 4858e67..89db6cf 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -137,9 +137,9 @@ minstrel_calc_rate_stats(struct minstrel_rate_stats *mrs)
 		mrs->sample_skipped = 0;
 		mrs->cur_prob = MINSTREL_FRAC(mrs->success, mrs->attempts);
 		if (unlikely(!mrs->att_hist))
-			mrs->probability = mrs->cur_prob;
+			mrs->prob_ewma = mrs->cur_prob;
 		else
-			mrs->probability = minstrel_ewma(mrs->probability,
+			mrs->prob_ewma = minstrel_ewma(mrs->prob_ewma,
 						     mrs->cur_prob, EWMA_LEVEL);
 		mrs->att_hist += mrs->attempts;
 		mrs->succ_hist += mrs->success;
@@ -176,15 +176,15 @@ minstrel_update_stats(struct minstrel_priv *mp, struct minstrel_sta_info *mi)
 		minstrel_calc_rate_stats(mrs);
 
 		/* Update throughput per rate, reset thr. below 10% success */
-		if (mrs->probability < MINSTREL_FRAC(10, 100))
+		if (mrs->prob_ewma < MINSTREL_FRAC(10, 100))
 			mrs->cur_tp = 0;
 		else
-			mrs->cur_tp = mrs->probability * (1000000 / usecs);
+			mrs->cur_tp = mrs->prob_ewma * (1000000 / usecs);
 
 		/* Sample less often below the 10% chance of success.
 		 * Sample less often above the 95% chance of success. */
-		if (mrs->probability > MINSTREL_FRAC(95, 100) ||
-		    mrs->probability < MINSTREL_FRAC(10, 100)) {
+		if (mrs->prob_ewma > MINSTREL_FRAC(95, 100) ||
+		    mrs->prob_ewma < MINSTREL_FRAC(10, 100)) {
 			mr->adjusted_retry_count = mrs->retry_count >> 1;
 			if (mr->adjusted_retry_count > 2)
 				mr->adjusted_retry_count = 2;
@@ -204,11 +204,11 @@ minstrel_update_stats(struct minstrel_priv *mp, struct minstrel_sta_info *mi)
 		 * choose the maximum throughput rate as max_prob_rate
 		 * (2) if all success probabilities < 95%, the rate with
 		 * highest success probability is chosen as max_prob_rate */
-		if (mrs->probability >= MINSTREL_FRAC(95, 100)) {
+		if (mrs->prob_ewma >= MINSTREL_FRAC(95, 100)) {
 			if (mrs->cur_tp >= mi->r[tmp_prob_rate].stats.cur_tp)
 				tmp_prob_rate = i;
 		} else {
-			if (mrs->probability >= mi->r[tmp_prob_rate].stats.probability)
+			if (mrs->prob_ewma >= mi->r[tmp_prob_rate].stats.prob_ewma)
 				tmp_prob_rate = i;
 		}
 	}
@@ -227,7 +227,7 @@ minstrel_update_stats(struct minstrel_priv *mp, struct minstrel_sta_info *mi)
 #endif
 
 	/* Reset update timer */
-	mi->stats_update = jiffies;
+	mi->last_stats_update = jiffies;
 
 	minstrel_update_rates(mp, mi);
 }
@@ -265,7 +265,7 @@ minstrel_tx_status(void *priv, struct ieee80211_supported_band *sband,
 	if (mi->sample_deferred > 0)
 		mi->sample_deferred--;
 
-	if (time_after(jiffies, mi->stats_update +
+	if (time_after(jiffies, mi->last_stats_update +
 				(mp->update_interval * HZ) / 1000))
 		minstrel_update_stats(mp, mi);
 }
@@ -397,7 +397,7 @@ minstrel_get_rate(void *priv, struct ieee80211_sta *sta,
 	 * has a probability of >95%, we shouldn't be attempting
 	 * to use it, as this only wastes precious airtime */
 	if (!mrr_capable &&
-	   (mi->r[ndx].stats.probability > MINSTREL_FRAC(95, 100)))
+	   (mi->r[ndx].stats.prob_ewma > MINSTREL_FRAC(95, 100)))
 		return;
 
 	mi->prev_sample = true;
@@ -531,7 +531,7 @@ minstrel_rate_init(void *priv, struct ieee80211_supported_band *sband,
 	}
 
 	mi->n_rates = n;
-	mi->stats_update = jiffies;
+	mi->last_stats_update = jiffies;
 
 	init_sample_table(mi);
 	minstrel_update_rates(mp, mi);
@@ -565,7 +565,7 @@ minstrel_alloc_sta(void *priv, struct ieee80211_sta *sta, gfp_t gfp)
 	if (!mi->sample_table)
 		goto error1;
 
-	mi->stats_update = jiffies;
+	mi->last_stats_update = jiffies;
 	return mi;
 
 error1:
diff --git a/net/mac80211/rc80211_minstrel.h b/net/mac80211/rc80211_minstrel.h
index 728144c..58f2870 100644
--- a/net/mac80211/rc80211_minstrel.h
+++ b/net/mac80211/rc80211_minstrel.h
@@ -38,11 +38,14 @@ struct minstrel_rate_stats {
 	/* total attempts/success counters */
 	u64 att_hist, succ_hist;
 
-	/* current throughput */
+	/* current EWMA of rate throughput */
 	unsigned int cur_tp;
 
-	/* packet delivery probabilities */
-	unsigned int cur_prob, probability;
+	/* statistis of packet delivery probability
+	 *  cur_prob  - current prob within last update intervall
+	 *  prob_ewma - exponential weighted moving average of prob */
+	unsigned int cur_prob;
+	unsigned int prob_ewma;
 
 	/* maximum retry counts */
 	u8 retry_count;
@@ -70,7 +73,7 @@ struct minstrel_rate {
 struct minstrel_sta_info {
 	struct ieee80211_sta *sta;
 
-	unsigned long stats_update;
+	unsigned long last_stats_update;
 	unsigned int sp_ack_dur;
 	unsigned int rate_avg;
 
@@ -133,7 +136,7 @@ void minstrel_add_sta_debugfs(void *priv, void *priv_sta, struct dentry *dir);
 void minstrel_remove_sta_debugfs(void *priv, void *priv_sta);
 
 /* Recalculate success probabilities and counters for a given rate using EWMA */
-void minstrel_calc_rate_stats(struct minstrel_rate_stats *mr);
+void minstrel_calc_rate_stats(struct minstrel_rate_stats *mrs);
 
 /* debugfs */
 int minstrel_stats_open(struct inode *inode, struct file *file);
diff --git a/net/mac80211/rc80211_minstrel_debugfs.c b/net/mac80211/rc80211_minstrel_debugfs.c
index 8c35402..5f219e9 100644
--- a/net/mac80211/rc80211_minstrel_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_debugfs.c
@@ -107,7 +107,7 @@ minstrel_stats_open(struct inode *inode, struct file *file)
 
 		tp = MINSTREL_TRUNC(mrs->cur_tp / 10);
 		prob = MINSTREL_TRUNC(mrs->cur_prob * 1000);
-		eprob = MINSTREL_TRUNC(mrs->probability * 1000);
+		eprob = MINSTREL_TRUNC(mrs->prob_ewma * 1000);
 
 		p += sprintf(p, " %4u.%1u   %3u.%1u     %3u.%1u %3u"
 				"   %3u %-3u   %9llu   %-9llu\n",
@@ -175,7 +175,7 @@ minstrel_stats_csv_open(struct inode *inode, struct file *file)
 
 		tp = MINSTREL_TRUNC(mrs->cur_tp / 10);
 		prob = MINSTREL_TRUNC(mrs->cur_prob * 1000);
-		eprob = MINSTREL_TRUNC(mrs->probability * 1000);
+		eprob = MINSTREL_TRUNC(mrs->prob_ewma * 1000);
 
 		p += sprintf(p, "%u.%u,%u.%u,%u.%u,%u,%u,%u,"
 				"%llu,%llu,%d,%d\n",
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 7afa562..aca8b64 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -320,16 +320,16 @@ minstrel_get_ratestats(struct minstrel_ht_sta *mi, int index)
 static void
 minstrel_ht_calc_tp(struct minstrel_ht_sta *mi, int group, int rate)
 {
-	struct minstrel_rate_stats *mr;
+	struct minstrel_rate_stats *mrs;
 	unsigned int nsecs = 0;
-	unsigned int tp;
-	unsigned int prob;
+	unsigned int tmp_prob_ewma;
 
-	mr = &mi->groups[group].rates[rate];
-	prob = mr->probability;
+	mrs = &mi->groups[group].rates[rate];
+	tmp_prob_ewma = mrs->prob_ewma;
 
-	if (prob < MINSTREL_FRAC(1, 10)) {
-		mr->cur_tp = 0;
+	/* do not account throughput if sucess prob is below 10% */
+	if (mrs->prob_ewma < MINSTREL_FRAC(10, 100)) {
+		mrs->cur_tp = 0;
 		return;
 	}
 
@@ -337,8 +337,8 @@ minstrel_ht_calc_tp(struct minstrel_ht_sta *mi, int group, int rate)
 	 * For the throughput calculation, limit the probability value to 90% to
 	 * account for collision related packet error rate fluctuation
 	 */
-	if (prob > MINSTREL_FRAC(9, 10))
-		prob = MINSTREL_FRAC(9, 10);
+	if (mrs->prob_ewma > MINSTREL_FRAC(90, 100))
+		tmp_prob_ewma = MINSTREL_FRAC(90, 100);
 
 	if (group != MINSTREL_CCK_GROUP)
 		nsecs = 1000 * mi->overhead / MINSTREL_TRUNC(mi->avg_ampdu_len);
@@ -346,8 +346,7 @@ minstrel_ht_calc_tp(struct minstrel_ht_sta *mi, int group, int rate)
 	nsecs += minstrel_mcs_groups[group].duration[rate];
 
 	/* prob is scaled - see MINSTREL_FRAC above */
-	tp = 1000000 * ((prob * 1000) / nsecs);
-	mr->cur_tp = MINSTREL_TRUNC(tp);
+	mrs->cur_tp = MINSTREL_TRUNC(1000000 * ((tmp_prob_ewma * 1000) / nsecs));
 }
 
 /*
@@ -368,13 +367,13 @@ minstrel_ht_sort_best_tp_rates(struct minstrel_ht_sta *mi, u16 index,
 	cur_group = index / MCS_GROUP_RATES;
 	cur_idx = index  % MCS_GROUP_RATES;
 	cur_thr = mi->groups[cur_group].rates[cur_idx].cur_tp;
-	cur_prob = mi->groups[cur_group].rates[cur_idx].probability;
+	cur_prob = mi->groups[cur_group].rates[cur_idx].prob_ewma;
 
 	do {
 		tmp_group = tp_list[j - 1] / MCS_GROUP_RATES;
 		tmp_idx = tp_list[j - 1] % MCS_GROUP_RATES;
 		tmp_thr = mi->groups[tmp_group].rates[tmp_idx].cur_tp;
-		tmp_prob = mi->groups[tmp_group].rates[tmp_idx].probability;
+		tmp_prob = mi->groups[tmp_group].rates[tmp_idx].prob_ewma;
 		if (cur_thr < tmp_thr ||
 		    (cur_thr == tmp_thr && cur_prob <= tmp_prob))
 			break;
@@ -396,16 +395,16 @@ static void
 minstrel_ht_set_best_prob_rate(struct minstrel_ht_sta *mi, u16 index)
 {
 	struct minstrel_mcs_group_data *mg;
-	struct minstrel_rate_stats *mr;
+	struct minstrel_rate_stats *mrs;
 	int tmp_group, tmp_idx, tmp_tp, tmp_prob, max_tp_group;
 
 	mg = &mi->groups[index / MCS_GROUP_RATES];
-	mr = &mg->rates[index % MCS_GROUP_RATES];
+	mrs = &mg->rates[index % MCS_GROUP_RATES];
 
 	tmp_group = mi->max_prob_rate / MCS_GROUP_RATES;
 	tmp_idx = mi->max_prob_rate % MCS_GROUP_RATES;
 	tmp_tp = mi->groups[tmp_group].rates[tmp_idx].cur_tp;
-	tmp_prob = mi->groups[tmp_group].rates[tmp_idx].probability;
+	tmp_prob = mi->groups[tmp_group].rates[tmp_idx].prob_ewma;
 
 	/* if max_tp_rate[0] is from MCS_GROUP max_prob_rate get selected from
 	 * MCS_GROUP as well as CCK_GROUP rates do not allow aggregation */
@@ -414,15 +413,15 @@ minstrel_ht_set_best_prob_rate(struct minstrel_ht_sta *mi, u16 index)
 	    (max_tp_group != MINSTREL_CCK_GROUP))
 		return;
 
-	if (mr->probability > MINSTREL_FRAC(75, 100)) {
-		if (mr->cur_tp > tmp_tp)
+	if (mrs->prob_ewma > MINSTREL_FRAC(75, 100)) {
+		if (mrs->cur_tp > tmp_tp)
 			mi->max_prob_rate = index;
-		if (mr->cur_tp > mg->rates[mg->max_group_prob_rate].cur_tp)
+		if (mrs->cur_tp > mg->rates[mg->max_group_prob_rate].cur_tp)
 			mg->max_group_prob_rate = index;
 	} else {
-		if (mr->probability > tmp_prob)
+		if (mrs->prob_ewma > tmp_prob)
 			mi->max_prob_rate = index;
-		if (mr->probability > mg->rates[mg->max_group_prob_rate].probability)
+		if (mrs->prob_ewma > mg->rates[mg->max_group_prob_rate].prob_ewma)
 			mg->max_group_prob_rate = index;
 	}
 }
@@ -467,7 +466,7 @@ static inline void
 minstrel_ht_prob_rate_reduce_streams(struct minstrel_ht_sta *mi)
 {
 	struct minstrel_mcs_group_data *mg;
-	struct minstrel_rate_stats *mr;
+	struct minstrel_rate_stats *mrs;
 	int tmp_max_streams, group;
 	int tmp_tp = 0;
 
@@ -477,11 +476,11 @@ minstrel_ht_prob_rate_reduce_streams(struct minstrel_ht_sta *mi)
 		mg = &mi->groups[group];
 		if (!mg->supported || group == MINSTREL_CCK_GROUP)
 			continue;
-		mr = minstrel_get_ratestats(mi, mg->max_group_prob_rate);
-		if (tmp_tp < mr->cur_tp &&
+		mrs = minstrel_get_ratestats(mi, mg->max_group_prob_rate);
+		if (tmp_tp < mrs->cur_tp &&
 		   (minstrel_mcs_groups[group].streams < tmp_max_streams)) {
 				mi->max_prob_rate = mg->max_group_prob_rate;
-				tmp_tp = mr->cur_tp;
+				tmp_tp = mrs->cur_tp;
 		}
 	}
 }
@@ -499,7 +498,7 @@ static void
 minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 {
 	struct minstrel_mcs_group_data *mg;
-	struct minstrel_rate_stats *mr;
+	struct minstrel_rate_stats *mrs;
 	int group, i, j;
 	u16 tmp_mcs_tp_rate[MAX_THR_RATES], tmp_group_tp_rate[MAX_THR_RATES];
 	u16 tmp_cck_tp_rate[MAX_THR_RATES], index;
@@ -539,12 +538,12 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 
 			index = MCS_GROUP_RATES * group + i;
 
-			mr = &mg->rates[i];
-			mr->retry_updated = false;
-			minstrel_calc_rate_stats(mr);
+			mrs = &mg->rates[i];
+			mrs->retry_updated = false;
+			minstrel_calc_rate_stats(mrs);
 			minstrel_ht_calc_tp(mi, group, i);
 
-			if (!mr->cur_tp)
+			if (!mrs->cur_tp)
 				continue;
 
 			/* Find max throughput rate set */
@@ -588,7 +587,7 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 #endif
 
 	/* Reset update timer */
-	mi->stats_update = jiffies;
+	mi->last_stats_update = jiffies;
 }
 
 static bool
@@ -611,7 +610,7 @@ minstrel_ht_txstat_valid(struct minstrel_priv *mp, struct ieee80211_tx_rate *rat
 }
 
 static void
-minstrel_next_sample_idx(struct minstrel_ht_sta *mi)
+minstrel_set_next_sample_idx(struct minstrel_ht_sta *mi)
 {
 	struct minstrel_mcs_group_data *mg;
 
@@ -752,7 +751,8 @@ minstrel_ht_tx_status(void *priv, struct ieee80211_supported_band *sband,
 		update = true;
 	}
 
-	if (time_after(jiffies, mi->stats_update + (mp->update_interval / 2 * HZ) / 1000)) {
+	if (time_after(jiffies, mi->last_stats_update +
+				(mp->update_interval / 2 * HZ) / 1000)) {
 		update = true;
 		minstrel_ht_update_stats(mp, mi);
 	}
@@ -765,7 +765,7 @@ static void
 minstrel_calc_retransmit(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
                          int index)
 {
-	struct minstrel_rate_stats *mr;
+	struct minstrel_rate_stats *mrs;
 	const struct mcs_group *group;
 	unsigned int tx_time, tx_time_rtscts, tx_time_data;
 	unsigned int cw = mp->cw_min;
@@ -774,16 +774,16 @@ minstrel_calc_retransmit(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 	unsigned int ampdu_len = MINSTREL_TRUNC(mi->avg_ampdu_len);
 	unsigned int overhead = 0, overhead_rtscts = 0;
 
-	mr = minstrel_get_ratestats(mi, index);
-	if (mr->probability < MINSTREL_FRAC(1, 10)) {
-		mr->retry_count = 1;
-		mr->retry_count_rtscts = 1;
+	mrs = minstrel_get_ratestats(mi, index);
+	if (mrs->prob_ewma < MINSTREL_FRAC(1, 10)) {
+		mrs->retry_count = 1;
+		mrs->retry_count_rtscts = 1;
 		return;
 	}
 
-	mr->retry_count = 2;
-	mr->retry_count_rtscts = 2;
-	mr->retry_updated = true;
+	mrs->retry_count = 2;
+	mrs->retry_count_rtscts = 2;
+	mrs->retry_updated = true;
 
 	group = &minstrel_mcs_groups[index / MCS_GROUP_RATES];
 	tx_time_data = group->duration[index % MCS_GROUP_RATES] * ampdu_len / 1000;
@@ -814,9 +814,9 @@ minstrel_calc_retransmit(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 		tx_time_rtscts += ctime + overhead_rtscts + tx_time_data;
 
 		if (tx_time_rtscts < mp->segment_size)
-			mr->retry_count_rtscts++;
+			mrs->retry_count_rtscts++;
 	} while ((tx_time < mp->segment_size) &&
-	         (++mr->retry_count < mp->max_retry));
+	         (++mrs->retry_count < mp->max_retry));
 }
 
 
@@ -825,22 +825,22 @@ minstrel_ht_set_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
                      struct ieee80211_sta_rates *ratetbl, int offset, int index)
 {
 	const struct mcs_group *group = &minstrel_mcs_groups[index / MCS_GROUP_RATES];
-	struct minstrel_rate_stats *mr;
+	struct minstrel_rate_stats *mrs;
 	u8 idx;
 	u16 flags = group->flags;
 
-	mr = minstrel_get_ratestats(mi, index);
-	if (!mr->retry_updated)
+	mrs = minstrel_get_ratestats(mi, index);
+	if (!mrs->retry_updated)
 		minstrel_calc_retransmit(mp, mi, index);
 
-	if (mr->probability < MINSTREL_FRAC(20, 100) || !mr->retry_count) {
+	if (mrs->prob_ewma < MINSTREL_FRAC(20, 100) || !mrs->retry_count) {
 		ratetbl->rate[offset].count = 2;
 		ratetbl->rate[offset].count_rts = 2;
 		ratetbl->rate[offset].count_cts = 2;
 	} else {
-		ratetbl->rate[offset].count = mr->retry_count;
-		ratetbl->rate[offset].count_cts = mr->retry_count;
-		ratetbl->rate[offset].count_rts = mr->retry_count_rtscts;
+		ratetbl->rate[offset].count = mrs->retry_count;
+		ratetbl->rate[offset].count_cts = mrs->retry_count;
+		ratetbl->rate[offset].count_rts = mrs->retry_count_rtscts;
 	}
 
 	if (index / MCS_GROUP_RATES == MINSTREL_CCK_GROUP)
@@ -898,7 +898,7 @@ minstrel_get_duration(int index)
 static int
 minstrel_get_sample_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 {
-	struct minstrel_rate_stats *mr;
+	struct minstrel_rate_stats *mrs;
 	struct minstrel_mcs_group_data *mg;
 	unsigned int sample_dur, sample_group, cur_max_tp_streams;
 	int sample_idx = 0;
@@ -914,12 +914,12 @@ minstrel_get_sample_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 	sample_group = mi->sample_group;
 	mg = &mi->groups[sample_group];
 	sample_idx = sample_table[mg->column][mg->index];
-	minstrel_next_sample_idx(mi);
+	minstrel_set_next_sample_idx(mi);
 
 	if (!(mg->supported & BIT(sample_idx)))
 		return -1;
 
-	mr = &mg->rates[sample_idx];
+	mrs = &mg->rates[sample_idx];
 	sample_idx += sample_group * MCS_GROUP_RATES;
 
 	/*
@@ -936,7 +936,7 @@ minstrel_get_sample_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 	 * Do not sample if the probability is already higher than 95%
 	 * to avoid wasting airtime.
 	 */
-	if (mr->probability > MINSTREL_FRAC(95, 100))
+	if (mrs->prob_ewma > MINSTREL_FRAC(95, 100))
 		return -1;
 
 	/*
@@ -951,7 +951,7 @@ minstrel_get_sample_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 	    (cur_max_tp_streams - 1 <
 	     minstrel_mcs_groups[sample_group].streams ||
 	     sample_dur >= minstrel_get_duration(mi->max_prob_rate))) {
-		if (mr->sample_skipped < 20)
+		if (mrs->sample_skipped < 20)
 			return -1;
 
 		if (mi->sample_slow++ > 2)
@@ -1105,7 +1105,7 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 	memset(mi, 0, sizeof(*mi));
 
 	mi->sta = sta;
-	mi->stats_update = jiffies;
+	mi->last_stats_update = jiffies;
 
 	ack_dur = ieee80211_frame_duration(sband->band, 10, 60, 1, 1, 0);
 	mi->overhead = ieee80211_frame_duration(sband->band, 0, 60, 1, 1, 0);
diff --git a/net/mac80211/rc80211_minstrel_ht.h b/net/mac80211/rc80211_minstrel_ht.h
index 3cc30e8..fa21a82 100644
--- a/net/mac80211/rc80211_minstrel_ht.h
+++ b/net/mac80211/rc80211_minstrel_ht.h
@@ -78,7 +78,7 @@ struct minstrel_ht_sta {
 	u16 max_prob_rate;
 
 	/* time of last status update */
-	unsigned long stats_update;
+	unsigned long last_stats_update;
 
 	/* overhead time in usec for each frame */
 	unsigned int overhead;
diff --git a/net/mac80211/rc80211_minstrel_ht_debugfs.c b/net/mac80211/rc80211_minstrel_ht_debugfs.c
index 133d7b6..53db416 100644
--- a/net/mac80211/rc80211_minstrel_ht_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_ht_debugfs.c
@@ -38,7 +38,7 @@ minstrel_ht_stats_dump(struct minstrel_ht_sta *mi, int i, char *p)
 		gimode = 'S';
 
 	for (j = 0; j < MCS_GROUP_RATES; j++) {
-		struct minstrel_rate_stats *mr = &mi->groups[i].rates[j];
+		struct minstrel_rate_stats *mrs = &mi->groups[i].rates[j];
 		static const int bitrates[4] = { 10, 20, 55, 110 };
 		int idx = i * MCS_GROUP_RATES + j;
 
@@ -81,20 +81,20 @@ minstrel_ht_stats_dump(struct minstrel_ht_sta *mi, int i, char *p)
 		tx_time = DIV_ROUND_CLOSEST(mg->duration[j], 1000);
 		p += sprintf(p, "%6u   ", tx_time);
 
-		tp = mr->cur_tp / 10;
-		prob = MINSTREL_TRUNC(mr->cur_prob * 1000);
-		eprob = MINSTREL_TRUNC(mr->probability * 1000);
+		tp = mrs->cur_tp / 10;
+		prob = MINSTREL_TRUNC(mrs->cur_prob * 1000);
+		eprob = MINSTREL_TRUNC(mrs->prob_ewma * 1000);
 
 		p += sprintf(p, "%4u.%1u   %3u.%1u     %3u.%1u "
 				"%3u   %3u %-3u   %9llu   %-9llu\n",
 				tp / 10, tp % 10,
 				eprob / 10, eprob % 10,
 				prob / 10, prob % 10,
-				mr->retry_count,
-				mr->last_success,
-				mr->last_attempts,
-				(unsigned long long)mr->succ_hist,
-				(unsigned long long)mr->att_hist);
+				mrs->retry_count,
+				mrs->last_success,
+				mrs->last_attempts,
+				(unsigned long long)mrs->succ_hist,
+				(unsigned long long)mrs->att_hist);
 	}
 
 	return p;
@@ -183,7 +183,7 @@ minstrel_ht_stats_csv_dump(struct minstrel_ht_sta *mi, int i, char *p,
 		gimode = 'S';
 
 	for (j = 0; j < MCS_GROUP_RATES; j++) {
-		struct minstrel_rate_stats *mr = &mi->groups[i].rates[j];
+		struct minstrel_rate_stats *mrs = &mi->groups[i].rates[j];
 		static const int bitrates[4] = { 10, 20, 55, 110 };
 		int idx = i * MCS_GROUP_RATES + j;
 
@@ -225,19 +225,19 @@ minstrel_ht_stats_csv_dump(struct minstrel_ht_sta *mi, int i, char *p,
 		tx_time = DIV_ROUND_CLOSEST(mg->duration[j], 1000);
 		p += sprintf(p, "%u,", tx_time);
 
-		tp = mr->cur_tp / 10;
-		prob = MINSTREL_TRUNC(mr->cur_prob * 1000);
-		eprob = MINSTREL_TRUNC(mr->probability * 1000);
+		tp = mrs->cur_tp / 10;
+		prob = MINSTREL_TRUNC(mrs->cur_prob * 1000);
+		eprob = MINSTREL_TRUNC(mrs->prob_ewma * 1000);
 
 		p += sprintf(p, "%u.%u,%u.%u,%u.%u,%u,%u,%u,%llu,%llu,",
 				tp / 10, tp % 10,
 				eprob / 10, eprob % 10,
 				prob / 10, prob % 10,
-				mr->retry_count,
-				mr->last_success,
-				mr->last_attempts,
-				(unsigned long long)mr->succ_hist,
-				(unsigned long long)mr->att_hist);
+				mrs->retry_count,
+				mrs->last_success,
+				mrs->last_attempts,
+				(unsigned long long)mrs->succ_hist,
+				(unsigned long long)mrs->att_hist);
 		p += sprintf(p, "%d,%d,%d.%d\n",
 				max(0, (int) mi->total_packets -
 				(int) mi->sample_packets),
-- 
2.3.0

