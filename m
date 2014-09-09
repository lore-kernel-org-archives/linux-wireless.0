Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:49994 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751176AbaIIVWU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2014 17:22:20 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	nbd@nbd.name, thomas@net.t-labs.tu-berlin.de, ikstream86@gmail.com
Subject: [PATCH v2 2/2] mac80211: improve minstrel_ht rate sorting by throughput & probability
Date: Tue,  9 Sep 2014 23:22:14 +0200
Message-Id: <1410297734-21187-3-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20140909_232225_161297_560C8C8D)
In-Reply-To: <1410297734-21187-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1410297734-21187-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch improves the way minstrel_ht sorts rates according to throughput
and success probability. 3 FOR-loops across the entire rate and mcs group set
in function minstrel_ht_update_stats() which where used to determine the
fastest, second fastest and most robust rate are reduced to 2 FOR-loop.

The sorted list of rates according throughput is extended to the best four
rates as we need them in upcoming joint rate and power control. The sorting
is done via the new function minstrel_ht_sort_best_tp_rates(). The annotation
of those 4 best throughput rates in the debugfs file rc-stats is changes to:
"A,B,C,D", where A is the fastest rate and C the 4th fastest.

---
v2: fix coding style issues, thx the Felix Fietkau

Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Tested-by: Stefan Venz <ikstream86@gmail.com>
---
 net/mac80211/rc80211_minstrel_ht.c         | 303 +++++++++++++++++++----------
 net/mac80211/rc80211_minstrel_ht.h         |  19 +-
 net/mac80211/rc80211_minstrel_ht_debugfs.c |  10 +-
 3 files changed, 213 insertions(+), 119 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 85c1e74..df90ce2 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -135,7 +135,7 @@ minstrel_ht_update_rates(struct minstrel_priv *mp, struct minstrel_ht_sta *mi);
 static int
 minstrel_ht_get_group_idx(struct ieee80211_tx_rate *rate)
 {
-	return GROUP_IDX((rate->idx / 8) + 1,
+	return GROUP_IDX((rate->idx / MCS_GROUP_RATES) + 1,
 			 !!(rate->flags & IEEE80211_TX_RC_SHORT_GI),
 			 !!(rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH));
 }
@@ -233,12 +233,151 @@ minstrel_ht_calc_tp(struct minstrel_ht_sta *mi, int group, int rate)
 }
 
 /*
+ * Find & sort topmost throughput rates
+ *
+ * If multiple rates provide equal throughput the sorting is based on their
+ * current success probability. Higher success probability is preferred among
+ * MCS groups, CCK rates do not provide aggregation and are therefore at last.
+ */
+static void
+minstrel_ht_sort_best_tp_rates(struct minstrel_ht_sta *mi, u8 index,
+			       u8 *tp_list)
+{
+	int cur_group, cur_idx, cur_thr, cur_prob;
+	int tmp_group, tmp_idx, tmp_thr, tmp_prob;
+	int j = MAX_THR_RATES;
+
+	cur_group = index / MCS_GROUP_RATES;
+	cur_idx = index  % MCS_GROUP_RATES;
+	cur_thr = mi->groups[cur_group].rates[cur_idx].cur_tp;
+	cur_prob = mi->groups[cur_group].rates[cur_idx].probability;
+
+	tmp_group = tp_list[j - 1] / MCS_GROUP_RATES;
+	tmp_idx = tp_list[j - 1] % MCS_GROUP_RATES;
+	tmp_thr = mi->groups[tmp_group].rates[tmp_idx].cur_tp;
+	tmp_prob = mi->groups[tmp_group].rates[tmp_idx].probability;
+
+	while (j > 0 && (cur_thr > tmp_thr ||
+	      (cur_thr == tmp_thr && cur_prob > tmp_prob))) {
+		j--;
+		tmp_group = tp_list[j - 1] / MCS_GROUP_RATES;
+		tmp_idx = tp_list[j - 1] % MCS_GROUP_RATES;
+		tmp_thr = mi->groups[tmp_group].rates[tmp_idx].cur_tp;
+		tmp_prob = mi->groups[tmp_group].rates[tmp_idx].probability;
+	}
+
+	if (j < MAX_THR_RATES - 1) {
+		memmove(&tp_list[j + 1], &tp_list[j], (sizeof(*tp_list) *
+		       (MAX_THR_RATES - (j + 1))));
+	}
+	if (j < MAX_THR_RATES)
+		tp_list[j] = index;
+}
+
+/*
+ * Find and set the topmost probability rate per sta and per group
+ */
+static void
+minstrel_ht_set_best_prob_rate(struct minstrel_ht_sta *mi, u8 index)
+{
+	struct minstrel_mcs_group_data *mg;
+	struct minstrel_rate_stats *mr;
+	int tmp_group, tmp_idx, tmp_tp, tmp_prob, max_tp_group;
+
+	mg = &mi->groups[index / MCS_GROUP_RATES];
+	mr = &mg->rates[index % MCS_GROUP_RATES];
+
+	tmp_group = mi->max_prob_rate / MCS_GROUP_RATES;
+	tmp_idx = mi->max_prob_rate % MCS_GROUP_RATES;
+	tmp_tp = mi->groups[tmp_group].rates[tmp_idx].cur_tp;
+	tmp_prob = mi->groups[tmp_group].rates[tmp_idx].probability;
+
+	/* if max_tp_rate[0] is from MCS_GROUP max_prob_rate get selected from
+	 * MCS_GROUP as well as CCK_GROUP rates do not allow aggregation */
+	max_tp_group = mi->max_tp_rate[0] / MCS_GROUP_RATES;
+	if((index / MCS_GROUP_RATES == MINSTREL_CCK_GROUP) &&
+	    (max_tp_group != MINSTREL_CCK_GROUP))
+		return;
+
+	if (mr->probability > MINSTREL_FRAC(75, 100)) {
+		if (mr->cur_tp > tmp_tp)
+			mi->max_prob_rate = index;
+		if (mr->cur_tp > mg->rates[mg->max_group_prob_rate].cur_tp)
+			mg->max_group_prob_rate = index;
+	} else {
+		if (mr->probability > tmp_prob)
+			mi->max_prob_rate = index;
+		if (mr->probability > mg->rates[mg->max_group_prob_rate].probability)
+			mg->max_group_prob_rate = index;
+	}
+}
+
+
+/*
+ * Assign new rate set per sta and use CCK rates only if the fastest
+ * rate (max_tp_rate[0]) is from CCK group. This prohibits such sorted
+ * rate sets where MCS and CCK rates are mixed, because CCK rates can
+ * not use aggregation.
+ */
+static void
+minstrel_ht_assign_best_tp_rates(struct minstrel_ht_sta *mi,
+				 u8 tmp_mcs_tp_rate[MAX_THR_RATES],
+				 u8 tmp_cck_tp_rate[MAX_THR_RATES])
+{
+	unsigned int tmp_group, tmp_idx, tmp_cck_tp, tmp_mcs_tp;
+	int i;
+
+	tmp_group = tmp_cck_tp_rate[0] / MCS_GROUP_RATES;
+	tmp_idx = tmp_cck_tp_rate[0] % MCS_GROUP_RATES;
+	tmp_cck_tp = mi->groups[tmp_group].rates[tmp_idx].cur_tp;
+
+	tmp_group = tmp_mcs_tp_rate[0] / MCS_GROUP_RATES;
+	tmp_idx = tmp_mcs_tp_rate[0] % MCS_GROUP_RATES;
+	tmp_mcs_tp = mi->groups[tmp_group].rates[tmp_idx].cur_tp;
+
+	if (tmp_cck_tp > tmp_mcs_tp) {
+		for(i = 0; i < MAX_THR_RATES; i++) {
+			minstrel_ht_sort_best_tp_rates(mi, tmp_cck_tp_rate[i],
+						       tmp_mcs_tp_rate);
+		}
+	}
+
+}
+
+/*
+ * Try to increase robustness of max_prob rate by decrease number of
+ * streams if possible.
+ */
+static inline void
+minstrel_ht_prob_rate_reduce_streams(struct minstrel_ht_sta *mi)
+{
+	struct minstrel_mcs_group_data *mg;
+	struct minstrel_rate_stats *mr;
+	int tmp_max_streams, group;
+	int tmp_tp = 0;
+
+	tmp_max_streams = minstrel_mcs_groups[mi->max_tp_rate[0] /
+			  MCS_GROUP_RATES].streams;
+	for (group = 0; group < ARRAY_SIZE(minstrel_mcs_groups); group++) {
+		mg = &mi->groups[group];
+		if (!mg->supported || group == MINSTREL_CCK_GROUP)
+			continue;
+		mr = minstrel_get_ratestats(mi, mg->max_group_prob_rate);
+		if (tmp_tp < mr->cur_tp &&
+		   (minstrel_mcs_groups[group].streams < tmp_max_streams)) {
+				mi->max_prob_rate = mg->max_group_prob_rate;
+				tmp_tp = mr->cur_tp;
+		}
+	}
+}
+
+/*
  * Update rate statistics and select new primary rates
  *
  * Rules for rate selection:
  *  - max_prob_rate must use only one stream, as a tradeoff between delivery
  *    probability and throughput during strong fluctuations
- *  - as long as the max prob rate has a probability of more than 3/4, pick
+ *  - as long as the max prob rate has a probability of more than 75%, pick
  *    higher throughput rates, even if the probablity is a bit lower
  */
 static void
@@ -246,9 +385,9 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 {
 	struct minstrel_mcs_group_data *mg;
 	struct minstrel_rate_stats *mr;
-	int cur_prob, cur_prob_tp, cur_tp, cur_tp2;
-	int group, i, index;
-	bool mi_rates_valid = false;
+	int group, i, j;
+	u8 tmp_mcs_tp_rate[MAX_THR_RATES], tmp_group_tp_rate[MAX_THR_RATES];
+	u8 tmp_cck_tp_rate[MAX_THR_RATES], index;
 
 	if (mi->ampdu_packets > 0) {
 		mi->avg_ampdu_len = minstrel_ewma(mi->avg_ampdu_len,
@@ -260,13 +399,14 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 	mi->sample_slow = 0;
 	mi->sample_count = 0;
 
-	for (group = 0; group < ARRAY_SIZE(minstrel_mcs_groups); group++) {
-		bool mg_rates_valid = false;
+	/* Initialize global rate indexes */
+	for(j = 0; j < MAX_THR_RATES; j++){
+		tmp_mcs_tp_rate[j] = 0;
+		tmp_cck_tp_rate[j] = 0;
+	}
 
-		cur_prob = 0;
-		cur_prob_tp = 0;
-		cur_tp = 0;
-		cur_tp2 = 0;
+	/* Find best rate sets within all MCS groups*/
+	for (group = 0; group < ARRAY_SIZE(minstrel_mcs_groups); group++) {
 
 		mg = &mi->groups[group];
 		if (!mg->supported)
@@ -274,24 +414,16 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 
 		mi->sample_count++;
 
+		/* (re)Initialize group rate indexes */
+		for(j = 0; j < MAX_THR_RATES; j++)
+			tmp_group_tp_rate[j] = group;
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
@@ -300,82 +432,47 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
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
+			/* Find max throughput rate set */
+			if (group != MINSTREL_CCK_GROUP) {
+				minstrel_ht_sort_best_tp_rates(mi, index,
+							       tmp_mcs_tp_rate);
+			} else if (group == MINSTREL_CCK_GROUP) {
+				minstrel_ht_sort_best_tp_rates(mi, index,
+							       tmp_cck_tp_rate);
 			}
-		}
-	}
 
-	/* try to sample all available rates during each interval */
-	mi->sample_count *= 8;
+			/* Find max throughput rate set within a group */
+			minstrel_ht_sort_best_tp_rates(mi, index,
+						       tmp_group_tp_rate);
 
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
+			/* Find max probability rate per group and global */
+			minstrel_ht_set_best_prob_rate(mi, index);
 		}
 
-		mr = minstrel_get_ratestats(mi, mg->max_tp_rate2);
-		if (cur_tp2 < mr->cur_tp) {
-			mi->max_tp_rate2 = mg->max_tp_rate2;
-			cur_tp2 = mr->cur_tp;
-		}
+		memcpy(mg->max_group_tp_rate, tmp_group_tp_rate,
+		       sizeof(mg->max_group_tp_rate));
 	}
 
-	if (mi->max_prob_streams < 1)
-		mi->max_prob_streams = 1;
+	/* Assign new rate set per sta */
+	minstrel_ht_assign_best_tp_rates(mi, tmp_mcs_tp_rate, tmp_cck_tp_rate);
+	memcpy(mi->max_tp_rate, tmp_mcs_tp_rate, sizeof(mi->max_tp_rate));
 
-	for (group = 0; group < ARRAY_SIZE(minstrel_mcs_groups); group++) {
-		mg = &mi->groups[group];
-		if (!mg->supported)
-			continue;
-		mr = minstrel_get_ratestats(mi, mg->max_prob_rate);
-		if (cur_prob_tp < mr->cur_tp &&
-		    minstrel_mcs_groups[group].streams <= mi->max_prob_streams) {
-			mi->max_prob_rate = mg->max_prob_rate;
-			cur_prob = mr->cur_prob;
-			cur_prob_tp = mr->cur_tp;
-		}
-	}
+	/* Try to increase robustness of max_prob_rate*/
+	minstrel_ht_prob_rate_reduce_streams(mi);
+
+	/* try to sample all available rates during each interval */
+	mi->sample_count *= 8;
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 	/* use fixed index if set */
 	if (mp->fixed_rate_idx != -1) {
-		mi->max_tp_rate = mp->fixed_rate_idx;
-		mi->max_tp_rate2 = mp->fixed_rate_idx;
+		for (i = 0; i < 4; i++)
+			mi->max_tp_rate[i] = mp->fixed_rate_idx;
 		mi->max_prob_rate = mp->fixed_rate_idx;
 	}
 #endif
 
+	/* Reset update timer */
 	mi->stats_update = jiffies;
 }
 
@@ -420,8 +517,7 @@ minstrel_next_sample_idx(struct minstrel_ht_sta *mi)
 }
 
 static void
-minstrel_downgrade_rate(struct minstrel_ht_sta *mi, unsigned int *idx,
-			bool primary)
+minstrel_downgrade_rate(struct minstrel_ht_sta *mi, u8 *idx, bool primary)
 {
 	int group, orig_group;
 
@@ -437,9 +533,9 @@ minstrel_downgrade_rate(struct minstrel_ht_sta *mi, unsigned int *idx,
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
@@ -524,19 +620,19 @@ minstrel_ht_tx_status(void *priv, struct ieee80211_supported_band *sband,
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
 
@@ -661,12 +757,12 @@ minstrel_ht_update_rates(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
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
@@ -691,7 +787,7 @@ minstrel_get_sample_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 {
 	struct minstrel_rate_stats *mr;
 	struct minstrel_mcs_group_data *mg;
-	unsigned int sample_dur, sample_group;
+	unsigned int sample_dur, sample_group, cur_max_tp_streams;
 	int sample_idx = 0;
 
 	if (mi->sample_wait > 0) {
@@ -718,8 +814,8 @@ minstrel_get_sample_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 	 * to the frame. Hence, don't use sampling for the currently
 	 * used rates.
 	 */
-	if (sample_idx == mi->max_tp_rate ||
-	    sample_idx == mi->max_tp_rate2 ||
+	if (sample_idx == mi->max_tp_rate[0] ||
+	    sample_idx == mi->max_tp_rate[1] ||
 	    sample_idx == mi->max_prob_rate)
 		return -1;
 
@@ -734,9 +830,12 @@ minstrel_get_sample_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 	 * Make sure that lower rates get sampled only occasionally,
 	 * if the link is working perfectly.
 	 */
+
+	cur_max_tp_streams = minstrel_mcs_groups[mi->max_tp_rate[0] /
+		MCS_GROUP_RATES].streams;
 	sample_dur = minstrel_get_duration(sample_idx);
-	if (sample_dur >= minstrel_get_duration(mi->max_tp_rate2) &&
-	    (mi->max_prob_streams <
+	if (sample_dur >= minstrel_get_duration(mi->max_tp_rate[1]) &&
+	    (cur_max_tp_streams - 1 <
 	     minstrel_mcs_groups[sample_group].streams ||
 	     sample_dur >= minstrel_get_duration(mi->max_prob_rate))) {
 		if (mr->sample_skipped < 20)
@@ -1041,8 +1140,8 @@ static u32 minstrel_ht_get_expected_throughput(void *priv_sta)
 	if (!msp->is_ht)
 		return mac80211_minstrel.get_expected_throughput(priv_sta);
 
-	i = mi->max_tp_rate / MCS_GROUP_RATES;
-	j = mi->max_tp_rate % MCS_GROUP_RATES;
+	i = mi->max_tp_rate[0] / MCS_GROUP_RATES;
+	j = mi->max_tp_rate[0] % MCS_GROUP_RATES;
 
 	/* convert cur_tp from pkt per second in kbps */
 	return mi->groups[i].rates[j].cur_tp * AVG_PKT_SIZE * 8 / 1024;
diff --git a/net/mac80211/rc80211_minstrel_ht.h b/net/mac80211/rc80211_minstrel_ht.h
index 5fee938..01570e0 100644
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
+	u8 max_group_tp_rate[MAX_THR_RATES];
+	u8 max_group_prob_rate;
 
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
-	unsigned int max_prob_rate;
-	unsigned int max_prob_streams;
+	/* overall sorted rate set */
+	u8 max_tp_rate[MAX_THR_RATES];
+	u8 max_prob_rate;
 
 	/* time of last status update */
 	unsigned long stats_update;
diff --git a/net/mac80211/rc80211_minstrel_ht_debugfs.c b/net/mac80211/rc80211_minstrel_ht_debugfs.c
index 3e7d793..a72ad46 100644
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
@@ -100,8 +102,8 @@ minstrel_ht_stats_open(struct inode *inode, struct file *file)
 
 	file->private_data = ms;
 	p = ms->buf;
-	p += sprintf(p, "type         rate     throughput  ewma prob   this prob  "
-			"retry   this succ/attempt   success    attempts\n");
+	p += sprintf(p, "type           rate     throughput  ewma prob   "
+		     "this prob  retry   this succ/attempt   success    attempts\n");
 
 	p = minstrel_ht_stats_dump(mi, max_mcs, p);
 	for (i = 0; i < max_mcs; i++)
-- 
2.1.0

