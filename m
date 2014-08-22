Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:33686 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932093AbaHVOND (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2014 10:13:03 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	nbd@nbd.name, thomas@net.t-labs.tu-berlin.de, ikstream86@gmail.com
Subject: [PATCH 2/2] mac80211: improve minstrel_ht rate sorting by throughput & probability
Date: Fri, 22 Aug 2014 16:05:33 +0200
Message-Id: <1408716333-18492-3-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20140822_161310_042053_9C7ECDD9)
In-Reply-To: <1408716333-18492-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1408716333-18492-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch improves the way minstrel_ht sorts rates according to throughput
and success probability. 3 FOR-loops across the entire rate and mcs group set
in function minstrel_ht_update_stats() which where used to determine the
fastest, second fastest and most robust rate are reduced to 2 FOR-loops.

The sorted list of rates according throughput is extended to the best four
rates as we need them in upcoming joint rate and power control. The sorting
is done via the new function minstrel_ht_sort_best_tp_rates(). The annotation
of those 4 best throughput rates in the debugfs file rc-stats is changes to:
"A,B,C,D", where A is the fastest rate and D the 4th fastest.

Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Tested-by: Stefan Venz <ikstream86@gmail.com>
---
 net/mac80211/rc80211_minstrel_ht.c         | 215 ++++++++++++++++-------------
 net/mac80211/rc80211_minstrel_ht.h         |  17 +--
 net/mac80211/rc80211_minstrel_ht_debugfs.c |   8 +-
 3 files changed, 128 insertions(+), 112 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 85c1e74..7f03c01 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -204,7 +204,6 @@ minstrel_ht_calc_tp(struct minstrel_ht_sta *mi, int group, int rate)
 {
 	struct minstrel_rate_stats *mr;
 	unsigned int nsecs = 0;
-	unsigned int tp;
 	unsigned int prob;
 
 	mr = &mi->groups[group].rates[rate];
@@ -228,8 +227,47 @@ minstrel_ht_calc_tp(struct minstrel_ht_sta *mi, int group, int rate)
 	nsecs += minstrel_mcs_groups[group].duration[rate];
 
 	/* prob is scaled - see MINSTREL_FRAC above */
-	tp = 1000000 * ((prob * 1000) / nsecs);
-	mr->cur_tp = MINSTREL_TRUNC(tp);
+	mr->cur_tp = 1000000 * ((prob * 1000) / nsecs);
+}
+
+/*
+ * Find & sort topmost throughput rates
+ *
+ * If multiple rates provide equal throughput the sorting is based on their
+ * current success probability. Higher success probability is preferred among
+ * MCS groups, CCK rates do not provide aggregation and are therefore at last.
+ */
+static inline void
+minstrel_ht_sort_best_tp_rates(struct minstrel_ht_sta *mi, unsigned int index,
+			       unsigned int *tp_list)
+{
+	int j = MAX_THR_RATES;
+	unsigned int cur_group, cur_idx, cur_thr, cur_prob;
+	unsigned int tmp_group, tmp_idx;
+
+	cur_group = index / MCS_GROUP_RATES;
+	cur_idx = index % MCS_GROUP_RATES;
+	cur_thr = mi->groups[cur_group].rates[cur_idx].cur_tp;
+	cur_prob = mi->groups[cur_group].rates[cur_idx].probability;
+	tmp_group = tp_list[j - 1] / MCS_GROUP_RATES;
+	tmp_idx = tp_list[j - 1] % MCS_GROUP_RATES;
+
+
+	while (j > 0 && (cur_thr > mi->groups[tmp_group].rates[tmp_idx].cur_tp ||
+	       (cur_thr == mi->groups[tmp_group].rates[tmp_idx].cur_tp &&
+	       cur_prob > mi->groups[tmp_group].rates[tmp_idx].probability &&
+	       cur_group != MINSTREL_CCK_GROUP))) {
+			j--;
+			tmp_group = tp_list[j - 1] / MCS_GROUP_RATES;
+			tmp_idx = tp_list[j - 1] % MCS_GROUP_RATES;
+	}
+
+	if (j < MAX_THR_RATES - 1) {
+		memmove(&tp_list[j + 1], &tp_list[j], (sizeof(*tp_list) *
+		       (MAX_THR_RATES - (j + 1))));
+	}
+	if (j < MAX_THR_RATES)
+		tp_list[j] = index;
 }
 
 /*
@@ -238,7 +276,7 @@ minstrel_ht_calc_tp(struct minstrel_ht_sta *mi, int group, int rate)
  * Rules for rate selection:
  *  - max_prob_rate must use only one stream, as a tradeoff between delivery
  *    probability and throughput during strong fluctuations
- *  - as long as the max prob rate has a probability of more than 3/4, pick
+ *  - as long as the max prob rate has a probability of more than 75%, pick
  *    higher throughput rates, even if the probablity is a bit lower
  */
 static void
@@ -246,9 +284,9 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 {
 	struct minstrel_mcs_group_data *mg;
 	struct minstrel_rate_stats *mr;
-	int cur_prob, cur_prob_tp, cur_tp, cur_tp2;
-	int group, i, index;
-	bool mi_rates_valid = false;
+	int group, i, j, index;
+	unsigned int tmp_tp_rate[MAX_THR_RATES], tmp_group_tp_rate[MAX_THR_RATES];
+	int tmp_group, tmp_idx, tmp_tp, tmp_prob, tmp_max_streams;
 
 	if (mi->ampdu_packets > 0) {
 		mi->avg_ampdu_len = minstrel_ewma(mi->avg_ampdu_len,
@@ -260,13 +298,13 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 	mi->sample_slow = 0;
 	mi->sample_count = 0;
 
-	for (group = 0; group < ARRAY_SIZE(minstrel_mcs_groups); group++) {
-		bool mg_rates_valid = false;
+	/* Initialize global rate indexes */
+	for(j = 0; j < MAX_THR_RATES; j++){
+		tmp_tp_rate[j] = 0;
+	}
 
-		cur_prob = 0;
-		cur_prob_tp = 0;
-		cur_tp = 0;
-		cur_tp2 = 0;
+	/* Find best rate sets */
+	for (group = 0; group < ARRAY_SIZE(minstrel_mcs_groups); group++) {
 
 		mg = &mi->groups[group];
 		if (!mg->supported)
@@ -274,24 +312,17 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 
 		mi->sample_count++;
 
+		/* (re)Initialize group rate indexes */
+		for(j = 0; j < MAX_THR_RATES; j++){
+			tmp_group_tp_rate[j] = group;
+		}
+
 		for (i = 0; i < MCS_GROUP_RATES; i++) {
 			if (!(mg->supported & BIT(i)))
 				continue;
 
 			index = MCS_GROUP_RATES * group + i;
 
-			/* initialize rates selections starting indexes */
-			if (!mg_rates_valid) {
-				mg->max_tp_rate = mg->max_tp_rate2 =
-					mg->max_prob_rate = i;
-				if (!mi_rates_valid) {
-					mi->max_tp_rate = mi->max_tp_rate2 =
-						mi->max_prob_rate = index;
-					mi_rates_valid = true;
-				}
-				mg_rates_valid = true;
-			}
-
 			mr = &mg->rates[i];
 			mr->retry_updated = false;
 			minstrel_calc_rate_ewma(mr);
@@ -300,82 +331,72 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 			if (!mr->cur_tp)
 				continue;
 
-			if ((mr->cur_tp > cur_prob_tp && mr->probability >
-			     MINSTREL_FRAC(3, 4)) || mr->probability > cur_prob) {
-				mg->max_prob_rate = index;
-				cur_prob = mr->probability;
-				cur_prob_tp = mr->cur_tp;
-			}
-
-			if (mr->cur_tp > cur_tp) {
-				swap(index, mg->max_tp_rate);
-				cur_tp = mr->cur_tp;
-				mr = minstrel_get_ratestats(mi, index);
-			}
-
-			if (index >= mg->max_tp_rate)
-				continue;
-
-			if (mr->cur_tp > cur_tp2) {
-				mg->max_tp_rate2 = index;
-				cur_tp2 = mr->cur_tp;
+			/* Find global max throughput rate set */
+			minstrel_ht_sort_best_tp_rates(mi, index, tmp_tp_rate);
+
+			/* Find max throughput rate set within a group */
+			minstrel_ht_sort_best_tp_rates(mi, index,
+						       tmp_group_tp_rate);
+
+			/* Find max probability rate per group and global*/
+			tmp_group = mi->max_prob_rate / MCS_GROUP_RATES;
+			tmp_idx = mi->max_prob_rate % MCS_GROUP_RATES;
+			tmp_tp = mi->groups[tmp_group].rates[tmp_idx].cur_tp;
+			tmp_prob = mi->groups[tmp_group].rates[tmp_idx].probability;
+
+			if (mr->probability > MINSTREL_FRAC(75, 100)) {
+				if (mr->cur_tp > tmp_tp)
+					mi->max_prob_rate = index;
+				if (mr->cur_tp >
+				    mg->rates[mg->max_group_prob_rate].cur_tp)
+					mg->max_group_prob_rate = index;
+			} else {
+				if (mr->probability > tmp_prob)
+					mi->max_prob_rate = index;
+				if (mr->probability >
+				    mg->rates[mg->max_group_prob_rate].probability)
+					mg->max_group_prob_rate = index;
 			}
 		}
-	}
-
-	/* try to sample all available rates during each interval */
-	mi->sample_count *= 8;
 
-	cur_prob = 0;
-	cur_prob_tp = 0;
-	cur_tp = 0;
-	cur_tp2 = 0;
-	for (group = 0; group < ARRAY_SIZE(minstrel_mcs_groups); group++) {
-		mg = &mi->groups[group];
-		if (!mg->supported)
-			continue;
-
-		mr = minstrel_get_ratestats(mi, mg->max_tp_rate);
-		if (cur_tp < mr->cur_tp) {
-			mi->max_tp_rate2 = mi->max_tp_rate;
-			cur_tp2 = cur_tp;
-			mi->max_tp_rate = mg->max_tp_rate;
-			cur_tp = mr->cur_tp;
-			mi->max_prob_streams = minstrel_mcs_groups[group].streams - 1;
-		}
-
-		mr = minstrel_get_ratestats(mi, mg->max_tp_rate2);
-		if (cur_tp2 < mr->cur_tp) {
-			mi->max_tp_rate2 = mg->max_tp_rate2;
-			cur_tp2 = mr->cur_tp;
-		}
+		/* Assign the new rate set per MCS group */
+		memcpy(mg->max_group_tp_rate, tmp_group_tp_rate,
+		       sizeof(mg->max_group_tp_rate));
 	}
 
-	if (mi->max_prob_streams < 1)
-		mi->max_prob_streams = 1;
+	/* Assign the new rate set per sta */
+	memcpy(mi->max_tp_rate, tmp_tp_rate, sizeof(mi->max_tp_rate));
 
+	/* Decrease #streams in order to increase robustness of max_prob rate */
+	tmp_tp = 0;
+	tmp_max_streams = minstrel_mcs_groups[mi->max_tp_rate[0] /
+			  MCS_GROUP_RATES].streams;
 	for (group = 0; group < ARRAY_SIZE(minstrel_mcs_groups); group++) {
 		mg = &mi->groups[group];
 		if (!mg->supported)
 			continue;
-		mr = minstrel_get_ratestats(mi, mg->max_prob_rate);
-		if (cur_prob_tp < mr->cur_tp &&
-		    minstrel_mcs_groups[group].streams <= mi->max_prob_streams) {
-			mi->max_prob_rate = mg->max_prob_rate;
-			cur_prob = mr->cur_prob;
-			cur_prob_tp = mr->cur_tp;
+		mr = minstrel_get_ratestats(mi, mg->max_group_prob_rate);
+		if (tmp_tp < mr->cur_tp &&
+		   (minstrel_mcs_groups[group].streams <= tmp_max_streams - 1)) {
+			mi->max_prob_rate = mg->max_group_prob_rate;
+			tmp_tp = mr->cur_tp;
 		}
 	}
 
+	/* try to sample all available rates during each interval */
+	mi->sample_count *= 8;
+
 #ifdef CONFIG_MAC80211_DEBUGFS
 	/* use fixed index if set */
 	if (mp->fixed_rate_idx != -1) {
-		mi->max_tp_rate = mp->fixed_rate_idx;
-		mi->max_tp_rate2 = mp->fixed_rate_idx;
+		for (i = 0; i < 4; i++) {
+			mi->max_tp_rate[i] = mp->fixed_rate_idx;
+		}
 		mi->max_prob_rate = mp->fixed_rate_idx;
 	}
 #endif
 
+	/* Reset update timer */
 	mi->stats_update = jiffies;
 }
 
@@ -437,9 +458,9 @@ minstrel_downgrade_rate(struct minstrel_ht_sta *mi, unsigned int *idx,
 			continue;
 
 		if (primary)
-			*idx = mi->groups[group].max_tp_rate;
+			*idx = mi->groups[group].max_group_tp_rate[0];
 		else
-			*idx = mi->groups[group].max_tp_rate2;
+			*idx = mi->groups[group].max_group_tp_rate[1];
 		break;
 	}
 }
@@ -524,19 +545,19 @@ minstrel_ht_tx_status(void *priv, struct ieee80211_supported_band *sband,
 	 * check for sudden death of spatial multiplexing,
 	 * downgrade to a lower number of streams if necessary.
 	 */
-	rate = minstrel_get_ratestats(mi, mi->max_tp_rate);
+	rate = minstrel_get_ratestats(mi, mi->max_tp_rate[0]);
 	if (rate->attempts > 30 &&
 	    MINSTREL_FRAC(rate->success, rate->attempts) <
 	    MINSTREL_FRAC(20, 100)) {
-		minstrel_downgrade_rate(mi, &mi->max_tp_rate, true);
+		minstrel_downgrade_rate(mi, &mi->max_tp_rate[0], true);
 		update = true;
 	}
 
-	rate2 = minstrel_get_ratestats(mi, mi->max_tp_rate2);
+	rate2 = minstrel_get_ratestats(mi, mi->max_tp_rate[1]);
 	if (rate2->attempts > 30 &&
 	    MINSTREL_FRAC(rate2->success, rate2->attempts) <
 	    MINSTREL_FRAC(20, 100)) {
-		minstrel_downgrade_rate(mi, &mi->max_tp_rate2, false);
+		minstrel_downgrade_rate(mi, &mi->max_tp_rate[1], false);
 		update = true;
 	}
 
@@ -661,12 +682,12 @@ minstrel_ht_update_rates(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 	if (!rates)
 		return;
 
-	/* Start with max_tp_rate */
-	minstrel_ht_set_rate(mp, mi, rates, i++, mi->max_tp_rate);
+	/* Start with max_tp_rate[0] */
+	minstrel_ht_set_rate(mp, mi, rates, i++, mi->max_tp_rate[0]);
 
 	if (mp->hw->max_rates >= 3) {
-		/* At least 3 tx rates supported, use max_tp_rate2 next */
-		minstrel_ht_set_rate(mp, mi, rates, i++, mi->max_tp_rate2);
+		/* At least 3 tx rates supported, use max_tp_rate[1] next */
+		minstrel_ht_set_rate(mp, mi, rates, i++, mi->max_tp_rate[1]);
 	}
 
 	if (mp->hw->max_rates >= 2) {
@@ -718,8 +739,8 @@ minstrel_get_sample_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 	 * to the frame. Hence, don't use sampling for the currently
 	 * used rates.
 	 */
-	if (sample_idx == mi->max_tp_rate ||
-	    sample_idx == mi->max_tp_rate2 ||
+	if (sample_idx == mi->max_tp_rate[0] ||
+	    sample_idx == mi->max_tp_rate[1] ||
 	    sample_idx == mi->max_prob_rate)
 		return -1;
 
@@ -735,8 +756,8 @@ minstrel_get_sample_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 	 * if the link is working perfectly.
 	 */
 	sample_dur = minstrel_get_duration(sample_idx);
-	if (sample_dur >= minstrel_get_duration(mi->max_tp_rate2) &&
-	    (mi->max_prob_streams <
+	if (sample_dur >= minstrel_get_duration(mi->max_tp_rate[1]) &&
+	    (minstrel_mcs_groups[mi->max_tp_rate[0] / MCS_GROUP_RATES].streams <
 	     minstrel_mcs_groups[sample_group].streams ||
 	     sample_dur >= minstrel_get_duration(mi->max_prob_rate))) {
 		if (mr->sample_skipped < 20)
@@ -1041,8 +1062,8 @@ static u32 minstrel_ht_get_expected_throughput(void *priv_sta)
 	if (!msp->is_ht)
 		return mac80211_minstrel.get_expected_throughput(priv_sta);
 
-	i = mi->max_tp_rate / MCS_GROUP_RATES;
-	j = mi->max_tp_rate % MCS_GROUP_RATES;
+	i = mi->max_tp_rate[0] / MCS_GROUP_RATES;
+	j = mi->max_tp_rate[0] % MCS_GROUP_RATES;
 
 	/* convert cur_tp from pkt per second in kbps */
 	return mi->groups[i].rates[j].cur_tp * AVG_PKT_SIZE * 8 / 1024;
diff --git a/net/mac80211/rc80211_minstrel_ht.h b/net/mac80211/rc80211_minstrel_ht.h
index 5fee938..1dddfb5 100644
--- a/net/mac80211/rc80211_minstrel_ht.h
+++ b/net/mac80211/rc80211_minstrel_ht.h
@@ -33,10 +33,9 @@ struct minstrel_mcs_group_data {
 	/* bitfield of supported MCS rates of this group */
 	u8 supported;
 
-	/* selected primary rates */
-	unsigned int max_tp_rate;
-	unsigned int max_tp_rate2;
-	unsigned int max_prob_rate;
+	/* sorted rate set within a MCS group*/
+	unsigned int max_group_tp_rate[MAX_THR_RATES];
+	unsigned int max_group_prob_rate;
 
 	/* MCS rate statistics */
 	struct minstrel_rate_stats rates[MCS_GROUP_RATES];
@@ -52,15 +51,9 @@ struct minstrel_ht_sta {
 	/* ampdu length (EWMA) */
 	unsigned int avg_ampdu_len;
 
-	/* best throughput rate */
-	unsigned int max_tp_rate;
-
-	/* second best throughput rate */
-	unsigned int max_tp_rate2;
-
-	/* best probability rate */
+	/* overall sorted rate set */
+	unsigned int max_tp_rate[MAX_THR_RATES];
 	unsigned int max_prob_rate;
-	unsigned int max_prob_streams;
 
 	/* time of last status update */
 	unsigned long stats_update;
diff --git a/net/mac80211/rc80211_minstrel_ht_debugfs.c b/net/mac80211/rc80211_minstrel_ht_debugfs.c
index 3e7d793..dab4769 100644
--- a/net/mac80211/rc80211_minstrel_ht_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_ht_debugfs.c
@@ -46,8 +46,10 @@ minstrel_ht_stats_dump(struct minstrel_ht_sta *mi, int i, char *p)
 		else
 			p += sprintf(p, "HT%c0/%cGI ", htmode, gimode);
 
-		*(p++) = (idx == mi->max_tp_rate) ? 'T' : ' ';
-		*(p++) = (idx == mi->max_tp_rate2) ? 't' : ' ';
+		*(p++) = (idx == mi->max_tp_rate[0]) ? 'A' : ' ';
+		*(p++) = (idx == mi->max_tp_rate[1]) ? 'B' : ' ';
+		*(p++) = (idx == mi->max_tp_rate[2]) ? 'C' : ' ';
+		*(p++) = (idx == mi->max_tp_rate[3]) ? 'D' : ' ';
 		*(p++) = (idx == mi->max_prob_rate) ? 'P' : ' ';
 
 		if (i == max_mcs) {
@@ -57,7 +59,7 @@ minstrel_ht_stats_dump(struct minstrel_ht_sta *mi, int i, char *p)
 			p += sprintf(p, " MCS%-2u", (mg->streams - 1) * 8 + j);
 		}
 
-		tp = mr->cur_tp / 10;
+		tp = MINSTREL_TRUNC(mr->cur_tp / 10);
 		prob = MINSTREL_TRUNC(mr->cur_prob * 1000);
 		eprob = MINSTREL_TRUNC(mr->probability * 1000);
 
-- 
2.1.0

