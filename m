Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:49748 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753407AbbCXUJ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2015 16:09:57 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, nbd@nbd.name,
	thomas@net.t-labs.tu-berlin.de
Subject: [PATCH v4 07/10] mac80211: restructure per-rate throughput calculation into function
Date: Tue, 24 Mar 2015 21:09:40 +0100
Message-Id: <1427227783-4531-8-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20150324_211017_382830_99AC88B8)
In-Reply-To: <1427227783-4531-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1427227783-4531-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch moves Minstrels and Minstrel-HTs per-rate throughput
calculation (EWMA(thr)) into a dedicated function to be called.
Therefore the variable "unsigned int cur_tp" within struct
"minstrel_rate_stats" becomes obsolete.  and is removed to free
up its space.

Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
---
 net/mac80211/rc80211_minstrel.c            | 43 +++++++++++------
 net/mac80211/rc80211_minstrel.h            |  4 +-
 net/mac80211/rc80211_minstrel_debugfs.c    | 12 ++---
 net/mac80211/rc80211_minstrel_ht.c         | 77 ++++++++++++++++++------------
 net/mac80211/rc80211_minstrel_ht.h         |  1 +
 net/mac80211/rc80211_minstrel_ht_debugfs.c | 12 ++---
 6 files changed, 88 insertions(+), 61 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index 89db6cf..d985227 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -69,14 +69,32 @@ rix_to_ndx(struct minstrel_sta_info *mi, int rix)
 	return i;
 }
 
+/* return current EMWA throughput */
+int minstrel_get_tp_avg(struct minstrel_rate *mr)
+{
+	int usecs;
+
+	usecs = mr->perfect_tx_time;
+	if (!usecs)
+		usecs = 1000000;
+
+	/* reset thr. below 10% success */
+	if (mr->stats.prob_ewma < MINSTREL_FRAC(10, 100))
+		return 0;
+	else
+		return MINSTREL_TRUNC(mr->stats.prob_ewma * (100000 / usecs));
+}
+
 /* find & sort topmost throughput rates */
 static inline void
 minstrel_sort_best_tp_rates(struct minstrel_sta_info *mi, int i, u8 *tp_list)
 {
 	int j = MAX_THR_RATES;
 
-	while (j > 0 && mi->r[i].stats.cur_tp > mi->r[tp_list[j - 1]].stats.cur_tp)
+	while (j > 0 && (minstrel_get_tp_avg(&mi->r[i]) >
+	       minstrel_get_tp_avg(&mi->r[tp_list[j - 1]])))
 		j--;
+
 	if (j < MAX_THR_RATES - 1)
 		memmove(&tp_list[j + 1], &tp_list[j], MAX_THR_RATES - (j + 1));
 	if (j < MAX_THR_RATES)
@@ -158,8 +176,7 @@ minstrel_update_stats(struct minstrel_priv *mp, struct minstrel_sta_info *mi)
 {
 	u8 tmp_tp_rate[MAX_THR_RATES];
 	u8 tmp_prob_rate = 0;
-	u32 usecs;
-	int i;
+	int i, tmp_cur_tp, tmp_prob_tp;
 
 	for (i = 0; i < MAX_THR_RATES; i++)
 	    tmp_tp_rate[i] = 0;
@@ -168,19 +185,9 @@ minstrel_update_stats(struct minstrel_priv *mp, struct minstrel_sta_info *mi)
 		struct minstrel_rate *mr = &mi->r[i];
 		struct minstrel_rate_stats *mrs = &mi->r[i].stats;
 
-		usecs = mr->perfect_tx_time;
-		if (!usecs)
-			usecs = 1000000;
-
 		/* Update success probabilities per rate */
 		minstrel_calc_rate_stats(mrs);
 
-		/* Update throughput per rate, reset thr. below 10% success */
-		if (mrs->prob_ewma < MINSTREL_FRAC(10, 100))
-			mrs->cur_tp = 0;
-		else
-			mrs->cur_tp = mrs->prob_ewma * (1000000 / usecs);
-
 		/* Sample less often below the 10% chance of success.
 		 * Sample less often above the 95% chance of success. */
 		if (mrs->prob_ewma > MINSTREL_FRAC(95, 100) ||
@@ -205,7 +212,9 @@ minstrel_update_stats(struct minstrel_priv *mp, struct minstrel_sta_info *mi)
 		 * (2) if all success probabilities < 95%, the rate with
 		 * highest success probability is chosen as max_prob_rate */
 		if (mrs->prob_ewma >= MINSTREL_FRAC(95, 100)) {
-			if (mrs->cur_tp >= mi->r[tmp_prob_rate].stats.cur_tp)
+			tmp_cur_tp = minstrel_get_tp_avg(mr);
+			tmp_prob_tp = minstrel_get_tp_avg(&mi->r[tmp_prob_rate]);
+			if (tmp_cur_tp >= tmp_prob_tp)
 				tmp_prob_rate = i;
 		} else {
 			if (mrs->prob_ewma >= mi->r[tmp_prob_rate].stats.prob_ewma)
@@ -676,11 +685,15 @@ static u32 minstrel_get_expected_throughput(void *priv_sta)
 {
 	struct minstrel_sta_info *mi = priv_sta;
 	int idx = mi->max_tp_rate[0];
+	int tmp_cur_tp;
 
 	/* convert pkt per sec in kbps (1200 is the average pkt size used for
 	 * computing cur_tp
 	 */
-	return MINSTREL_TRUNC(mi->r[idx].stats.cur_tp) * 1200 * 8 / 1024;
+	tmp_cur_tp = minstrel_get_tp_avg(&mi->r[idx]);
+	tmp_cur_tp = tmp_cur_tp * 1200 * 8 / 1024;
+
+	return tmp_cur_tp;
 }
 
 const struct rate_control_ops mac80211_minstrel = {
diff --git a/net/mac80211/rc80211_minstrel.h b/net/mac80211/rc80211_minstrel.h
index 58f2870..490df3b 100644
--- a/net/mac80211/rc80211_minstrel.h
+++ b/net/mac80211/rc80211_minstrel.h
@@ -38,9 +38,6 @@ struct minstrel_rate_stats {
 	/* total attempts/success counters */
 	u64 att_hist, succ_hist;
 
-	/* current EWMA of rate throughput */
-	unsigned int cur_tp;
-
 	/* statistis of packet delivery probability
 	 *  cur_prob  - current prob within last update intervall
 	 *  prob_ewma - exponential weighted moving average of prob */
@@ -137,6 +134,7 @@ void minstrel_remove_sta_debugfs(void *priv, void *priv_sta);
 
 /* Recalculate success probabilities and counters for a given rate using EWMA */
 void minstrel_calc_rate_stats(struct minstrel_rate_stats *mrs);
+int minstrel_get_tp_avg(struct minstrel_rate *mr);
 
 /* debugfs */
 int minstrel_stats_open(struct inode *inode, struct file *file);
diff --git a/net/mac80211/rc80211_minstrel_debugfs.c b/net/mac80211/rc80211_minstrel_debugfs.c
index 5f219e9..4d6eeef 100644
--- a/net/mac80211/rc80211_minstrel_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_debugfs.c
@@ -75,7 +75,7 @@ minstrel_stats_open(struct inode *inode, struct file *file)
 {
 	struct minstrel_sta_info *mi = inode->i_private;
 	struct minstrel_debugfs_info *ms;
-	unsigned int i, tp, prob, eprob;
+	unsigned int i, tp_avg, prob, eprob;
 	char *p;
 
 	ms = kmalloc(2048, GFP_KERNEL);
@@ -105,13 +105,13 @@ minstrel_stats_open(struct inode *inode, struct file *file)
 		p += sprintf(p, "%3u  ", i);
 		p += sprintf(p, "%6u  ", mr->perfect_tx_time);
 
-		tp = MINSTREL_TRUNC(mrs->cur_tp / 10);
+		tp_avg = minstrel_get_tp_avg(mr);
 		prob = MINSTREL_TRUNC(mrs->cur_prob * 1000);
 		eprob = MINSTREL_TRUNC(mrs->prob_ewma * 1000);
 
 		p += sprintf(p, " %4u.%1u   %3u.%1u     %3u.%1u %3u"
 				"   %3u %-3u   %9llu   %-9llu\n",
-				tp / 10, tp % 10,
+				tp_avg / 10, tp_avg % 10,
 				eprob / 10, eprob % 10,
 				prob / 10, prob % 10,
 				mrs->retry_count,
@@ -145,7 +145,7 @@ minstrel_stats_csv_open(struct inode *inode, struct file *file)
 	struct minstrel_sta_info *mi = inode->i_private;
 	struct minstrel_debugfs_info *ms;
 	struct timeval tv;
-	unsigned int i, tp, prob, eprob;
+	unsigned int i, tp_avg, prob, eprob;
 	char *p;
 
 	ms = kmalloc(2048, GFP_KERNEL);
@@ -173,13 +173,13 @@ minstrel_stats_csv_open(struct inode *inode, struct file *file)
 		p += sprintf(p, "%u,", i);
 		p += sprintf(p, "%u,",mr->perfect_tx_time);
 
-		tp = MINSTREL_TRUNC(mrs->cur_tp / 10);
+		tp_avg = minstrel_get_tp_avg(mr);
 		prob = MINSTREL_TRUNC(mrs->cur_prob * 1000);
 		eprob = MINSTREL_TRUNC(mrs->prob_ewma * 1000);
 
 		p += sprintf(p, "%u.%u,%u.%u,%u.%u,%u,%u,%u,"
 				"%llu,%llu,%d,%d\n",
-				tp / 10, tp % 10,
+				tp_avg / 10, tp_avg % 10,
 				eprob / 10, eprob % 10,
 				prob / 10, prob % 10,
 				mrs->retry_count,
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index aca8b64..7202e34 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -314,11 +314,11 @@ minstrel_get_ratestats(struct minstrel_ht_sta *mi, int index)
 }
 
 /*
- * Calculate throughput based on the average A-MPDU length, taking into account
- * the expected number of retransmissions and their expected length
+ * Return current throughput based on the average A-MPDU length, taking into
+ * account the expected number of retransmissions and their expected length
  */
-static void
-minstrel_ht_calc_tp(struct minstrel_ht_sta *mi, int group, int rate)
+int
+minstrel_ht_get_tp_avg(struct minstrel_ht_sta *mi, int group, int rate)
 {
 	struct minstrel_rate_stats *mrs;
 	unsigned int nsecs = 0;
@@ -328,10 +328,8 @@ minstrel_ht_calc_tp(struct minstrel_ht_sta *mi, int group, int rate)
 	tmp_prob_ewma = mrs->prob_ewma;
 
 	/* do not account throughput if sucess prob is below 10% */
-	if (mrs->prob_ewma < MINSTREL_FRAC(10, 100)) {
-		mrs->cur_tp = 0;
-		return;
-	}
+	if (mrs->prob_ewma < MINSTREL_FRAC(10, 100))
+		return 0;
 
 	/*
 	 * For the throughput calculation, limit the probability value to 90% to
@@ -346,7 +344,7 @@ minstrel_ht_calc_tp(struct minstrel_ht_sta *mi, int group, int rate)
 	nsecs += minstrel_mcs_groups[group].duration[rate];
 
 	/* prob is scaled - see MINSTREL_FRAC above */
-	mrs->cur_tp = MINSTREL_TRUNC(1000000 * ((tmp_prob_ewma * 1000) / nsecs));
+	return MINSTREL_TRUNC(100000 * ((tmp_prob_ewma * 1000) / nsecs));
 }
 
 /*
@@ -360,22 +358,22 @@ static void
 minstrel_ht_sort_best_tp_rates(struct minstrel_ht_sta *mi, u16 index,
 			       u16 *tp_list)
 {
-	int cur_group, cur_idx, cur_thr, cur_prob;
-	int tmp_group, tmp_idx, tmp_thr, tmp_prob;
+	int cur_group, cur_idx, cur_tp_avg, cur_prob;
+	int tmp_group, tmp_idx, tmp_tp_avg, tmp_prob;
 	int j = MAX_THR_RATES;
 
 	cur_group = index / MCS_GROUP_RATES;
 	cur_idx = index  % MCS_GROUP_RATES;
-	cur_thr = mi->groups[cur_group].rates[cur_idx].cur_tp;
+	cur_tp_avg = minstrel_ht_get_tp_avg(mi, cur_group, cur_idx);
 	cur_prob = mi->groups[cur_group].rates[cur_idx].prob_ewma;
 
 	do {
 		tmp_group = tp_list[j - 1] / MCS_GROUP_RATES;
 		tmp_idx = tp_list[j - 1] % MCS_GROUP_RATES;
-		tmp_thr = mi->groups[tmp_group].rates[tmp_idx].cur_tp;
+		tmp_tp_avg = minstrel_ht_get_tp_avg(mi, tmp_group, tmp_idx);
 		tmp_prob = mi->groups[tmp_group].rates[tmp_idx].prob_ewma;
-		if (cur_thr < tmp_thr ||
-		    (cur_thr == tmp_thr && cur_prob <= tmp_prob))
+		if (cur_tp_avg < tmp_tp_avg ||
+		    (cur_tp_avg == tmp_tp_avg && cur_prob <= tmp_prob))
 			break;
 		j--;
 	} while (j > 0);
@@ -396,14 +394,19 @@ minstrel_ht_set_best_prob_rate(struct minstrel_ht_sta *mi, u16 index)
 {
 	struct minstrel_mcs_group_data *mg;
 	struct minstrel_rate_stats *mrs;
-	int tmp_group, tmp_idx, tmp_tp, tmp_prob, max_tp_group;
+	int tmp_group, tmp_idx, tmp_tp_avg, tmp_prob;
+	int max_tp_group, cur_tp_avg, cur_group, cur_idx;
+	int max_group_prob_rate_group, max_group_prob_rate_idx;
+	int max_group_prob_rate_tp_avg;
 
+	cur_group = index / MCS_GROUP_RATES;
+	cur_idx = index % MCS_GROUP_RATES;
 	mg = &mi->groups[index / MCS_GROUP_RATES];
 	mrs = &mg->rates[index % MCS_GROUP_RATES];
 
 	tmp_group = mi->max_prob_rate / MCS_GROUP_RATES;
 	tmp_idx = mi->max_prob_rate % MCS_GROUP_RATES;
-	tmp_tp = mi->groups[tmp_group].rates[tmp_idx].cur_tp;
+	tmp_tp_avg = minstrel_ht_get_tp_avg(mi, tmp_group, tmp_idx);
 	tmp_prob = mi->groups[tmp_group].rates[tmp_idx].prob_ewma;
 
 	/* if max_tp_rate[0] is from MCS_GROUP max_prob_rate get selected from
@@ -414,9 +417,18 @@ minstrel_ht_set_best_prob_rate(struct minstrel_ht_sta *mi, u16 index)
 		return;
 
 	if (mrs->prob_ewma > MINSTREL_FRAC(75, 100)) {
-		if (mrs->cur_tp > tmp_tp)
+		cur_tp_avg = minstrel_ht_get_tp_avg(mi, cur_group, cur_idx);
+		if (cur_tp_avg > tmp_tp_avg)
 			mi->max_prob_rate = index;
-		if (mrs->cur_tp > mg->rates[mg->max_group_prob_rate].cur_tp)
+
+		max_group_prob_rate_group = mg->max_group_prob_rate /
+								MCS_GROUP_RATES;
+		max_group_prob_rate_idx = mg->max_group_prob_rate %
+								MCS_GROUP_RATES;
+		max_group_prob_rate_tp_avg = minstrel_ht_get_tp_avg(mi,
+						max_group_prob_rate_group,
+						max_group_prob_rate_idx);
+		if (cur_tp_avg > max_group_prob_rate_tp_avg)
 			mg->max_group_prob_rate = index;
 	} else {
 		if (mrs->prob_ewma > tmp_prob)
@@ -443,11 +455,11 @@ minstrel_ht_assign_best_tp_rates(struct minstrel_ht_sta *mi,
 
 	tmp_group = tmp_cck_tp_rate[0] / MCS_GROUP_RATES;
 	tmp_idx = tmp_cck_tp_rate[0] % MCS_GROUP_RATES;
-	tmp_cck_tp = mi->groups[tmp_group].rates[tmp_idx].cur_tp;
+	tmp_cck_tp = minstrel_ht_get_tp_avg(mi, tmp_group, tmp_idx);
 
 	tmp_group = tmp_mcs_tp_rate[0] / MCS_GROUP_RATES;
 	tmp_idx = tmp_mcs_tp_rate[0] % MCS_GROUP_RATES;
-	tmp_mcs_tp = mi->groups[tmp_group].rates[tmp_idx].cur_tp;
+	tmp_mcs_tp = minstrel_ht_get_tp_avg(mi, tmp_group, tmp_idx);
 
 	if (tmp_cck_tp > tmp_mcs_tp) {
 		for(i = 0; i < MAX_THR_RATES; i++) {
@@ -466,8 +478,7 @@ static inline void
 minstrel_ht_prob_rate_reduce_streams(struct minstrel_ht_sta *mi)
 {
 	struct minstrel_mcs_group_data *mg;
-	struct minstrel_rate_stats *mrs;
-	int tmp_max_streams, group;
+	int tmp_max_streams, group, tmp_idx;
 	int tmp_tp = 0;
 
 	tmp_max_streams = minstrel_mcs_groups[mi->max_tp_rate[0] /
@@ -476,11 +487,14 @@ minstrel_ht_prob_rate_reduce_streams(struct minstrel_ht_sta *mi)
 		mg = &mi->groups[group];
 		if (!mg->supported || group == MINSTREL_CCK_GROUP)
 			continue;
-		mrs = minstrel_get_ratestats(mi, mg->max_group_prob_rate);
-		if (tmp_tp < mrs->cur_tp &&
+
+		tmp_idx = mg->max_group_prob_rate % MCS_GROUP_RATES;
+
+		if (tmp_tp < minstrel_ht_get_tp_avg(mi, group, tmp_idx) &&
 		   (minstrel_mcs_groups[group].streams < tmp_max_streams)) {
 				mi->max_prob_rate = mg->max_group_prob_rate;
-				tmp_tp = mrs->cur_tp;
+				tmp_tp = minstrel_ht_get_tp_avg(mi, group,
+								tmp_idx);
 		}
 	}
 }
@@ -541,9 +555,8 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 			mrs = &mg->rates[i];
 			mrs->retry_updated = false;
 			minstrel_calc_rate_stats(mrs);
-			minstrel_ht_calc_tp(mi, group, i);
 
-			if (!mrs->cur_tp)
+			if (minstrel_ht_get_tp_avg(mi, group, i) == 0)
 				continue;
 
 			/* Find max throughput rate set */
@@ -1302,7 +1315,7 @@ static u32 minstrel_ht_get_expected_throughput(void *priv_sta)
 {
 	struct minstrel_ht_sta_priv *msp = priv_sta;
 	struct minstrel_ht_sta *mi = &msp->ht;
-	int i, j;
+	int i, j, tp_avg;
 
 	if (!msp->is_ht)
 		return mac80211_minstrel.get_expected_throughput(priv_sta);
@@ -1310,8 +1323,10 @@ static u32 minstrel_ht_get_expected_throughput(void *priv_sta)
 	i = mi->max_tp_rate[0] / MCS_GROUP_RATES;
 	j = mi->max_tp_rate[0] % MCS_GROUP_RATES;
 
-	/* convert cur_tp from pkt per second in kbps */
-	return mi->groups[i].rates[j].cur_tp * AVG_PKT_SIZE * 8 / 1024;
+	/* convert tp_avg from pkt per second in kbps */
+	tp_avg = minstrel_ht_get_tp_avg(mi, i, j) * AVG_PKT_SIZE * 8 / 1024;
+
+	return tp_avg;
 }
 
 static const struct rate_control_ops mac80211_minstrel_ht = {
diff --git a/net/mac80211/rc80211_minstrel_ht.h b/net/mac80211/rc80211_minstrel_ht.h
index fa21a82..68dce4f 100644
--- a/net/mac80211/rc80211_minstrel_ht.h
+++ b/net/mac80211/rc80211_minstrel_ht.h
@@ -121,5 +121,6 @@ struct minstrel_ht_sta_priv {
 
 void minstrel_ht_add_sta_debugfs(void *priv, void *priv_sta, struct dentry *dir);
 void minstrel_ht_remove_sta_debugfs(void *priv, void *priv_sta);
+int minstrel_ht_get_tp_avg(struct minstrel_ht_sta *mi, int group, int rate);
 
 #endif
diff --git a/net/mac80211/rc80211_minstrel_ht_debugfs.c b/net/mac80211/rc80211_minstrel_ht_debugfs.c
index 53db416..52ed8f5 100644
--- a/net/mac80211/rc80211_minstrel_ht_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_ht_debugfs.c
@@ -19,7 +19,7 @@ static char *
 minstrel_ht_stats_dump(struct minstrel_ht_sta *mi, int i, char *p)
 {
 	const struct mcs_group *mg;
-	unsigned int j, tp, prob, eprob, tx_time;
+	unsigned int j, tp_avg, prob, eprob, tx_time;
 	char htmode = '2';
 	char gimode = 'L';
 	u32 gflags;
@@ -81,13 +81,13 @@ minstrel_ht_stats_dump(struct minstrel_ht_sta *mi, int i, char *p)
 		tx_time = DIV_ROUND_CLOSEST(mg->duration[j], 1000);
 		p += sprintf(p, "%6u   ", tx_time);
 
-		tp = mrs->cur_tp / 10;
+		tp_avg = minstrel_ht_get_tp_avg(mi, i, j);
 		prob = MINSTREL_TRUNC(mrs->cur_prob * 1000);
 		eprob = MINSTREL_TRUNC(mrs->prob_ewma * 1000);
 
 		p += sprintf(p, "%4u.%1u   %3u.%1u     %3u.%1u "
 				"%3u   %3u %-3u   %9llu   %-9llu\n",
-				tp / 10, tp % 10,
+				tp_avg / 10, tp_avg % 10,
 				eprob / 10, eprob % 10,
 				prob / 10, prob % 10,
 				mrs->retry_count,
@@ -164,7 +164,7 @@ minstrel_ht_stats_csv_dump(struct minstrel_ht_sta *mi, int i, char *p,
 			    struct timeval tv)
 {
 	const struct mcs_group *mg;
-	unsigned int j, tp, prob, eprob, tx_time;
+	unsigned int j, tp_avg, prob, eprob, tx_time;
 	char htmode = '2';
 	char gimode = 'L';
 	u32 gflags;
@@ -225,12 +225,12 @@ minstrel_ht_stats_csv_dump(struct minstrel_ht_sta *mi, int i, char *p,
 		tx_time = DIV_ROUND_CLOSEST(mg->duration[j], 1000);
 		p += sprintf(p, "%u,", tx_time);
 
-		tp = mrs->cur_tp / 10;
+		tp_avg = minstrel_ht_get_tp_avg(mi, i, j);
 		prob = MINSTREL_TRUNC(mrs->cur_prob * 1000);
 		eprob = MINSTREL_TRUNC(mrs->prob_ewma * 1000);
 
 		p += sprintf(p, "%u.%u,%u.%u,%u.%u,%u,%u,%u,%llu,%llu,",
-				tp / 10, tp % 10,
+				tp_avg / 10, tp_avg % 10,
 				eprob / 10, eprob % 10,
 				prob / 10, prob % 10,
 				mrs->retry_count,
-- 
2.3.0

