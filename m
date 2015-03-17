Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:45834 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932778AbbCQR2S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2015 13:28:18 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, nbd@nbd.name,
	thomas@net.t-labs.tu-berlin.de
Subject: [PATCH v3 08/10] mac80211: add max. lossless throughput per rate to rc_stats
Date: Tue, 17 Mar 2015 18:29:17 +0100
Message-Id: <1426613359-31306-8-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20150317_182828_119509_F4D037F9)
In-Reply-To: <1426613359-31306-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1426613359-31306-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds the new statistic "maximum possible lossless
throughput" to Minstrels and Minstrel-HTs rc_stats (in debugfs). This
enables comprehensive comparison between current per-rate throughput
and max. achievable per-rate throughput.

Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
---
 net/mac80211/rc80211_minstrel.c            | 10 ++++
 net/mac80211/rc80211_minstrel.h            |  1 +
 net/mac80211/rc80211_minstrel_debugfs.c    | 18 ++++---
 net/mac80211/rc80211_minstrel_ht.c         | 84 ++++++++++++++++--------------
 net/mac80211/rc80211_minstrel_ht.h         |  4 +-
 net/mac80211/rc80211_minstrel_ht_debugfs.c | 24 +++++----
 6 files changed, 83 insertions(+), 58 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index d985227..c2afe51 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -85,6 +85,16 @@ int minstrel_get_tp_avg(struct minstrel_rate *mr)
 		return MINSTREL_TRUNC(mr->stats.prob_ewma * (100000 / usecs));
 }
 
+/* return max. potential lossless throughput */
+inline int
+minstrel_get_tp_max(struct minstrel_rate *mr)
+{
+	if (!mr->perfect_tx_time)
+		return 0;
+
+	return 100000 / mr->perfect_tx_time;
+}
+
 /* find & sort topmost throughput rates */
 static inline void
 minstrel_sort_best_tp_rates(struct minstrel_sta_info *mi, int i, u8 *tp_list)
diff --git a/net/mac80211/rc80211_minstrel.h b/net/mac80211/rc80211_minstrel.h
index 490df3b..6693d8d 100644
--- a/net/mac80211/rc80211_minstrel.h
+++ b/net/mac80211/rc80211_minstrel.h
@@ -135,6 +135,7 @@ void minstrel_remove_sta_debugfs(void *priv, void *priv_sta);
 /* Recalculate success probabilities and counters for a given rate using EWMA */
 void minstrel_calc_rate_stats(struct minstrel_rate_stats *mrs);
 int minstrel_get_tp_avg(struct minstrel_rate *mr);
+int minstrel_get_tp_max(struct minstrel_rate *mr);
 
 /* debugfs */
 int minstrel_stats_open(struct inode *inode, struct file *file);
diff --git a/net/mac80211/rc80211_minstrel_debugfs.c b/net/mac80211/rc80211_minstrel_debugfs.c
index 4d6eeef..3ed69ef 100644
--- a/net/mac80211/rc80211_minstrel_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_debugfs.c
@@ -75,7 +75,7 @@ minstrel_stats_open(struct inode *inode, struct file *file)
 {
 	struct minstrel_sta_info *mi = inode->i_private;
 	struct minstrel_debugfs_info *ms;
-	unsigned int i, tp_avg, prob, eprob;
+	unsigned int i, tp_max, tp_avg, prob, eprob;
 	char *p;
 
 	ms = kmalloc(2048, GFP_KERNEL);
@@ -85,9 +85,9 @@ minstrel_stats_open(struct inode *inode, struct file *file)
 	file->private_data = ms;
 	p = ms->buf;
 	p += sprintf(p, "\n");
-	p += sprintf(p, "best   _______rate_____    __statistics__    "
+	p += sprintf(p, "best   __________rate_________    __statistics__    "
 			"________last_______    ______sum-of________\n");
-	p += sprintf(p, "rate  [name idx airtime]  [ ø(tp) ø(prob)]  "
+	p += sprintf(p, "rate  [name idx airtime max_tp]  [ ø(tp) ø(prob)]  "
 			"[prob.|retry|suc|att]  [#success | #attempts]\n");
 
 	for (i = 0; i < mi->n_rates; i++) {
@@ -103,14 +103,16 @@ minstrel_stats_open(struct inode *inode, struct file *file)
 		p += sprintf(p, " %3u%s ", mr->bitrate / 2,
 				(mr->bitrate & 1 ? ".5" : "  "));
 		p += sprintf(p, "%3u  ", i);
-		p += sprintf(p, "%6u  ", mr->perfect_tx_time);
+		p += sprintf(p, "%6u ", mr->perfect_tx_time);
 
+		tp_max = minstrel_get_tp_max(mr);
 		tp_avg = minstrel_get_tp_avg(mr);
 		prob = MINSTREL_TRUNC(mrs->cur_prob * 1000);
 		eprob = MINSTREL_TRUNC(mrs->prob_ewma * 1000);
 
-		p += sprintf(p, " %4u.%1u   %3u.%1u     %3u.%1u %3u"
+		p += sprintf(p, "%4u.%1u   %4u.%1u   %3u.%1u     %3u.%1u %3u"
 				"   %3u %-3u   %9llu   %-9llu\n",
+				tp_max / 10, tp_max % 10,
 				tp_avg / 10, tp_avg % 10,
 				eprob / 10, eprob % 10,
 				prob / 10, prob % 10,
@@ -145,7 +147,7 @@ minstrel_stats_csv_open(struct inode *inode, struct file *file)
 	struct minstrel_sta_info *mi = inode->i_private;
 	struct minstrel_debugfs_info *ms;
 	struct timeval tv;
-	unsigned int i, tp_avg, prob, eprob;
+	unsigned int i, tp_max, tp_avg, prob, eprob;
 	char *p;
 
 	ms = kmalloc(2048, GFP_KERNEL);
@@ -173,12 +175,14 @@ minstrel_stats_csv_open(struct inode *inode, struct file *file)
 		p += sprintf(p, "%u,", i);
 		p += sprintf(p, "%u,",mr->perfect_tx_time);
 
+		tp_max = minstrel_get_tp_max(mr);
 		tp_avg = minstrel_get_tp_avg(mr);
 		prob = MINSTREL_TRUNC(mrs->cur_prob * 1000);
 		eprob = MINSTREL_TRUNC(mrs->prob_ewma * 1000);
 
-		p += sprintf(p, "%u.%u,%u.%u,%u.%u,%u,%u,%u,"
+		p += sprintf(p, "%u.%u,%u.%u,%u.%u,%u.%u,%u,%u,%u,"
 				"%llu,%llu,%d,%d\n",
+				tp_max / 10, tp_max % 10,
 				tp_avg / 10, tp_avg % 10,
 				eprob / 10, eprob % 10,
 				prob / 10, prob % 10,
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 7202e34..7430a1d 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -318,33 +318,30 @@ minstrel_get_ratestats(struct minstrel_ht_sta *mi, int index)
  * account the expected number of retransmissions and their expected length
  */
 int
-minstrel_ht_get_tp_avg(struct minstrel_ht_sta *mi, int group, int rate)
+minstrel_ht_get_tp_avg(struct minstrel_ht_sta *mi, int group, int rate,
+		       int prob_ewma)
 {
-	struct minstrel_rate_stats *mrs;
 	unsigned int nsecs = 0;
-	unsigned int tmp_prob_ewma;
-
-	mrs = &mi->groups[group].rates[rate];
-	tmp_prob_ewma = mrs->prob_ewma;
 
 	/* do not account throughput if sucess prob is below 10% */
-	if (mrs->prob_ewma < MINSTREL_FRAC(10, 100))
+	if (prob_ewma < MINSTREL_FRAC(10, 100))
 		return 0;
 
-	/*
-	 * For the throughput calculation, limit the probability value to 90% to
-	 * account for collision related packet error rate fluctuation
-	 */
-	if (mrs->prob_ewma > MINSTREL_FRAC(90, 100))
-		tmp_prob_ewma = MINSTREL_FRAC(90, 100);
-
 	if (group != MINSTREL_CCK_GROUP)
 		nsecs = 1000 * mi->overhead / MINSTREL_TRUNC(mi->avg_ampdu_len);
 
 	nsecs += minstrel_mcs_groups[group].duration[rate];
 
-	/* prob is scaled - see MINSTREL_FRAC above */
-	return MINSTREL_TRUNC(100000 * ((tmp_prob_ewma * 1000) / nsecs));
+	/*
+	 * For the throughput calculation, limit the probability value to 90% to
+	 * account for collision related packet error rate fluctuation
+	 * (prob is scaled - see MINSTREL_FRAC above)
+	 */
+	if (prob_ewma > MINSTREL_FRAC(90, 100))
+		return MINSTREL_TRUNC(100000 * ((MINSTREL_FRAC(90, 100) * 1000)
+								      / nsecs));
+	else
+		return MINSTREL_TRUNC(100000 * ((prob_ewma * 1000) / nsecs));
 }
 
 /*
@@ -364,14 +361,15 @@ minstrel_ht_sort_best_tp_rates(struct minstrel_ht_sta *mi, u16 index,
 
 	cur_group = index / MCS_GROUP_RATES;
 	cur_idx = index  % MCS_GROUP_RATES;
-	cur_tp_avg = minstrel_ht_get_tp_avg(mi, cur_group, cur_idx);
 	cur_prob = mi->groups[cur_group].rates[cur_idx].prob_ewma;
+	cur_tp_avg = minstrel_ht_get_tp_avg(mi, cur_group, cur_idx, cur_prob);
 
 	do {
 		tmp_group = tp_list[j - 1] / MCS_GROUP_RATES;
 		tmp_idx = tp_list[j - 1] % MCS_GROUP_RATES;
-		tmp_tp_avg = minstrel_ht_get_tp_avg(mi, tmp_group, tmp_idx);
 		tmp_prob = mi->groups[tmp_group].rates[tmp_idx].prob_ewma;
+		tmp_tp_avg = minstrel_ht_get_tp_avg(mi, tmp_group, tmp_idx,
+						    tmp_prob);
 		if (cur_tp_avg < tmp_tp_avg ||
 		    (cur_tp_avg == tmp_tp_avg && cur_prob <= tmp_prob))
 			break;
@@ -396,8 +394,8 @@ minstrel_ht_set_best_prob_rate(struct minstrel_ht_sta *mi, u16 index)
 	struct minstrel_rate_stats *mrs;
 	int tmp_group, tmp_idx, tmp_tp_avg, tmp_prob;
 	int max_tp_group, cur_tp_avg, cur_group, cur_idx;
-	int max_group_prob_rate_group, max_group_prob_rate_idx;
-	int max_group_prob_rate_tp_avg;
+	int max_gpr_group, max_gpr_idx;
+	int max_gpr_tp_avg, max_gpr_prob;
 
 	cur_group = index / MCS_GROUP_RATES;
 	cur_idx = index % MCS_GROUP_RATES;
@@ -406,8 +404,8 @@ minstrel_ht_set_best_prob_rate(struct minstrel_ht_sta *mi, u16 index)
 
 	tmp_group = mi->max_prob_rate / MCS_GROUP_RATES;
 	tmp_idx = mi->max_prob_rate % MCS_GROUP_RATES;
-	tmp_tp_avg = minstrel_ht_get_tp_avg(mi, tmp_group, tmp_idx);
 	tmp_prob = mi->groups[tmp_group].rates[tmp_idx].prob_ewma;
+	tmp_tp_avg = minstrel_ht_get_tp_avg(mi, tmp_group, tmp_idx, tmp_prob);
 
 	/* if max_tp_rate[0] is from MCS_GROUP max_prob_rate get selected from
 	 * MCS_GROUP as well as CCK_GROUP rates do not allow aggregation */
@@ -417,18 +415,18 @@ minstrel_ht_set_best_prob_rate(struct minstrel_ht_sta *mi, u16 index)
 		return;
 
 	if (mrs->prob_ewma > MINSTREL_FRAC(75, 100)) {
-		cur_tp_avg = minstrel_ht_get_tp_avg(mi, cur_group, cur_idx);
+		cur_tp_avg = minstrel_ht_get_tp_avg(mi, cur_group, cur_idx,
+						    mrs->prob_ewma);
 		if (cur_tp_avg > tmp_tp_avg)
 			mi->max_prob_rate = index;
 
-		max_group_prob_rate_group = mg->max_group_prob_rate /
-								MCS_GROUP_RATES;
-		max_group_prob_rate_idx = mg->max_group_prob_rate %
-								MCS_GROUP_RATES;
-		max_group_prob_rate_tp_avg = minstrel_ht_get_tp_avg(mi,
-						max_group_prob_rate_group,
-						max_group_prob_rate_idx);
-		if (cur_tp_avg > max_group_prob_rate_tp_avg)
+		max_gpr_group = mg->max_group_prob_rate / MCS_GROUP_RATES;
+		max_gpr_idx = mg->max_group_prob_rate %	MCS_GROUP_RATES;
+		max_gpr_prob = mi->groups[max_gpr_group].rates[max_gpr_idx].prob_ewma;
+		max_gpr_tp_avg = minstrel_ht_get_tp_avg(mi, max_gpr_group,
+							max_gpr_idx,
+							max_gpr_prob);
+		if (cur_tp_avg > max_gpr_tp_avg)
 			mg->max_group_prob_rate = index;
 	} else {
 		if (mrs->prob_ewma > tmp_prob)
@@ -450,16 +448,18 @@ minstrel_ht_assign_best_tp_rates(struct minstrel_ht_sta *mi,
 				 u16 tmp_mcs_tp_rate[MAX_THR_RATES],
 				 u16 tmp_cck_tp_rate[MAX_THR_RATES])
 {
-	unsigned int tmp_group, tmp_idx, tmp_cck_tp, tmp_mcs_tp;
+	unsigned int tmp_group, tmp_idx, tmp_cck_tp, tmp_mcs_tp, tmp_prob;
 	int i;
 
 	tmp_group = tmp_cck_tp_rate[0] / MCS_GROUP_RATES;
 	tmp_idx = tmp_cck_tp_rate[0] % MCS_GROUP_RATES;
-	tmp_cck_tp = minstrel_ht_get_tp_avg(mi, tmp_group, tmp_idx);
+	tmp_prob = mi->groups[tmp_group].rates[tmp_idx].prob_ewma;
+	tmp_cck_tp = minstrel_ht_get_tp_avg(mi, tmp_group, tmp_idx, tmp_prob);
 
 	tmp_group = tmp_mcs_tp_rate[0] / MCS_GROUP_RATES;
 	tmp_idx = tmp_mcs_tp_rate[0] % MCS_GROUP_RATES;
-	tmp_mcs_tp = minstrel_ht_get_tp_avg(mi, tmp_group, tmp_idx);
+	tmp_prob = mi->groups[tmp_group].rates[tmp_idx].prob_ewma;
+	tmp_mcs_tp = minstrel_ht_get_tp_avg(mi, tmp_group, tmp_idx, tmp_prob);
 
 	if (tmp_cck_tp > tmp_mcs_tp) {
 		for(i = 0; i < MAX_THR_RATES; i++) {
@@ -478,7 +478,7 @@ static inline void
 minstrel_ht_prob_rate_reduce_streams(struct minstrel_ht_sta *mi)
 {
 	struct minstrel_mcs_group_data *mg;
-	int tmp_max_streams, group, tmp_idx;
+	int tmp_max_streams, group, tmp_idx, tmp_prob;
 	int tmp_tp = 0;
 
 	tmp_max_streams = minstrel_mcs_groups[mi->max_tp_rate[0] /
@@ -489,12 +489,14 @@ minstrel_ht_prob_rate_reduce_streams(struct minstrel_ht_sta *mi)
 			continue;
 
 		tmp_idx = mg->max_group_prob_rate % MCS_GROUP_RATES;
+		tmp_prob = mi->groups[group].rates[tmp_idx].prob_ewma;
 
-		if (tmp_tp < minstrel_ht_get_tp_avg(mi, group, tmp_idx) &&
+		if (tmp_tp < minstrel_ht_get_tp_avg(mi, group, tmp_idx, tmp_prob) &&
 		   (minstrel_mcs_groups[group].streams < tmp_max_streams)) {
 				mi->max_prob_rate = mg->max_group_prob_rate;
 				tmp_tp = minstrel_ht_get_tp_avg(mi, group,
-								tmp_idx);
+								tmp_idx,
+								tmp_prob);
 		}
 	}
 }
@@ -513,7 +515,7 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 {
 	struct minstrel_mcs_group_data *mg;
 	struct minstrel_rate_stats *mrs;
-	int group, i, j;
+	int group, i, j, cur_prob;
 	u16 tmp_mcs_tp_rate[MAX_THR_RATES], tmp_group_tp_rate[MAX_THR_RATES];
 	u16 tmp_cck_tp_rate[MAX_THR_RATES], index;
 
@@ -555,8 +557,9 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 			mrs = &mg->rates[i];
 			mrs->retry_updated = false;
 			minstrel_calc_rate_stats(mrs);
+			cur_prob = mrs->prob_ewma;
 
-			if (minstrel_ht_get_tp_avg(mi, group, i) == 0)
+			if (minstrel_ht_get_tp_avg(mi, group, i, cur_prob) == 0)
 				continue;
 
 			/* Find max throughput rate set */
@@ -1315,16 +1318,17 @@ static u32 minstrel_ht_get_expected_throughput(void *priv_sta)
 {
 	struct minstrel_ht_sta_priv *msp = priv_sta;
 	struct minstrel_ht_sta *mi = &msp->ht;
-	int i, j, tp_avg;
+	int i, j, prob, tp_avg;
 
 	if (!msp->is_ht)
 		return mac80211_minstrel.get_expected_throughput(priv_sta);
 
 	i = mi->max_tp_rate[0] / MCS_GROUP_RATES;
 	j = mi->max_tp_rate[0] % MCS_GROUP_RATES;
+	prob = mi->groups[i].rates[j].prob_ewma;
 
 	/* convert tp_avg from pkt per second in kbps */
-	tp_avg = minstrel_ht_get_tp_avg(mi, i, j) * AVG_PKT_SIZE * 8 / 1024;
+	tp_avg = minstrel_ht_get_tp_avg(mi, i, j, prob) * AVG_PKT_SIZE * 8 / 1024;
 
 	return tp_avg;
 }
diff --git a/net/mac80211/rc80211_minstrel_ht.h b/net/mac80211/rc80211_minstrel_ht.h
index 68dce4f..850d352 100644
--- a/net/mac80211/rc80211_minstrel_ht.h
+++ b/net/mac80211/rc80211_minstrel_ht.h
@@ -121,6 +121,8 @@ struct minstrel_ht_sta_priv {
 
 void minstrel_ht_add_sta_debugfs(void *priv, void *priv_sta, struct dentry *dir);
 void minstrel_ht_remove_sta_debugfs(void *priv, void *priv_sta);
-int minstrel_ht_get_tp_avg(struct minstrel_ht_sta *mi, int group, int rate);
+int minstrel_ht_get_tp_avg(struct minstrel_ht_sta *mi, int group, int rate,
+			   int prob_ewma);
+int minstrel_ht_get_tp_max(struct minstrel_ht_sta *mi, int group, int rate);
 
 #endif
diff --git a/net/mac80211/rc80211_minstrel_ht_debugfs.c b/net/mac80211/rc80211_minstrel_ht_debugfs.c
index 52ed8f5..de034e4 100644
--- a/net/mac80211/rc80211_minstrel_ht_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_ht_debugfs.c
@@ -19,7 +19,7 @@ static char *
 minstrel_ht_stats_dump(struct minstrel_ht_sta *mi, int i, char *p)
 {
 	const struct mcs_group *mg;
-	unsigned int j, tp_avg, prob, eprob, tx_time;
+	unsigned int j, tp_max, tp_avg, prob, eprob, tx_time;
 	char htmode = '2';
 	char gimode = 'L';
 	u32 gflags;
@@ -79,14 +79,16 @@ minstrel_ht_stats_dump(struct minstrel_ht_sta *mi, int i, char *p)
 
 		/* tx_time[rate(i)] in usec */
 		tx_time = DIV_ROUND_CLOSEST(mg->duration[j], 1000);
-		p += sprintf(p, "%6u   ", tx_time);
+		p += sprintf(p, "%6u  ", tx_time);
 
-		tp_avg = minstrel_ht_get_tp_avg(mi, i, j);
+		tp_max = minstrel_ht_get_tp_avg(mi, i, j, MINSTREL_FRAC(100, 100));
+		tp_avg = minstrel_ht_get_tp_avg(mi, i, j, mrs->prob_ewma);
 		prob = MINSTREL_TRUNC(mrs->cur_prob * 1000);
 		eprob = MINSTREL_TRUNC(mrs->prob_ewma * 1000);
 
-		p += sprintf(p, "%4u.%1u   %3u.%1u     %3u.%1u "
+		p += sprintf(p, "%4u.%1u    %4u.%1u   %3u.%1u    %3u.%1u "
 				"%3u   %3u %-3u   %9llu   %-9llu\n",
+				tp_max / 10, tp_max % 10,
 				tp_avg / 10, tp_avg % 10,
 				eprob / 10, eprob % 10,
 				prob / 10, prob % 10,
@@ -125,11 +127,11 @@ minstrel_ht_stats_open(struct inode *inode, struct file *file)
 	p = ms->buf;
 
 	p += sprintf(p, "\n");
-	p += sprintf(p, "              best   ________rate______    "
+	p += sprintf(p, "              best   ____________rate__________    "
 			"__statistics__    ________last_______    "
 			"______sum-of________\n");
-	p += sprintf(p, "mode guard #  rate  [name   idx airtime]  [ ø(tp) "
-			"ø(prob)]  [prob.|retry|suc|att]  [#success | "
+	p += sprintf(p, "mode guard #  rate  [name   idx airtime  max_tp]  "
+			"[ ø(tp) ø(prob)]  [prob.|retry|suc|att]  [#success | "
 			"#attempts]\n");
 
 	p = minstrel_ht_stats_dump(mi, MINSTREL_CCK_GROUP, p);
@@ -164,7 +166,7 @@ minstrel_ht_stats_csv_dump(struct minstrel_ht_sta *mi, int i, char *p,
 			    struct timeval tv)
 {
 	const struct mcs_group *mg;
-	unsigned int j, tp_avg, prob, eprob, tx_time;
+	unsigned int j, tp_max, tp_avg, prob, eprob, tx_time;
 	char htmode = '2';
 	char gimode = 'L';
 	u32 gflags;
@@ -225,11 +227,13 @@ minstrel_ht_stats_csv_dump(struct minstrel_ht_sta *mi, int i, char *p,
 		tx_time = DIV_ROUND_CLOSEST(mg->duration[j], 1000);
 		p += sprintf(p, "%u,", tx_time);
 
-		tp_avg = minstrel_ht_get_tp_avg(mi, i, j);
+		tp_max = minstrel_ht_get_tp_avg(mi, i, j, MINSTREL_FRAC(100, 100));
+		tp_avg = minstrel_ht_get_tp_avg(mi, i, j, mrs->prob_ewma);
 		prob = MINSTREL_TRUNC(mrs->cur_prob * 1000);
 		eprob = MINSTREL_TRUNC(mrs->prob_ewma * 1000);
 
-		p += sprintf(p, "%u.%u,%u.%u,%u.%u,%u,%u,%u,%llu,%llu,",
+		p += sprintf(p, "%u.%u,%u.%u,%u.%u,%u.%u,%u,%u,%u,%llu,%llu,",
+				tp_max / 10, tp_max % 10,
 				tp_avg / 10, tp_avg % 10,
 				eprob / 10, eprob % 10,
 				prob / 10, prob % 10,
-- 
2.3.0

