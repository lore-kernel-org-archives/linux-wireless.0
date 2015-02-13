Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:49172 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752811AbbBMO6G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2015 09:58:06 -0500
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, nbd@nbd.name,
	thomas@net.t-labs.tu-berlin.de
Subject: [PATCH v2 08/10] mac80211: add max. lossless throughput per rate to rc_stats
Date: Fri, 13 Feb 2015 15:57:50 +0100
Message-Id: <1423839472-15625-9-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20150213_155821_681710_FE885A98)
In-Reply-To: <1423839472-15625-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1423839472-15625-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds the new statistic "maximum possible lossless
throughput" to Minstrels and Minstrel-HTs rc_stats (in debugfs). This
enables comprehensive comparison between current per-rate throughput
and max. achievable per-rate throughput.

Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
---
 net/mac80211/rc80211_minstrel.c            | 12 ++++++++++++
 net/mac80211/rc80211_minstrel.h            |  1 +
 net/mac80211/rc80211_minstrel_debugfs.c    | 18 +++++++++++-------
 net/mac80211/rc80211_minstrel_ht.c         | 19 +++++++++++++++++++
 net/mac80211/rc80211_minstrel_ht.h         |  1 +
 net/mac80211/rc80211_minstrel_ht_debugfs.c | 20 ++++++++++++--------
 6 files changed, 56 insertions(+), 15 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index 28de2f7a..42dfef8 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -87,7 +87,19 @@ int minstrel_get_tp_avg(struct minstrel_rate *mr)
 	return tp_avg;
 }
 
+/* return max. potential lossless throughput */
+int minstrel_get_tp_max(struct minstrel_rate *mr)
+{
+	int tp_max, usecs;
 
+	usecs = mr->perfect_tx_time;
+	if (!usecs)
+		usecs = 1000000;
+
+	tp_max = 100000 / usecs;
+
+	return tp_max;
+}
 
 /* find & sort topmost throughput rates */
 static inline void
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
index d8ccef7..182d552 100644
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
index 2a55f63..b62b04e 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -350,6 +350,25 @@ minstrel_ht_get_tp_avg(struct minstrel_ht_sta *mi, int group, int rate)
 }
 
 /*
+ * Return max. potential lossless throughput based on the average A-MPDU
+ */
+int
+minstrel_ht_get_tp_max(struct minstrel_ht_sta *mi, int group, int rate)
+{
+	unsigned int nsecs = 0;
+	unsigned int tp_max;
+
+	if (group != MINSTREL_CCK_GROUP)
+		nsecs = 1000 * mi->overhead / MINSTREL_TRUNC(mi->avg_ampdu_len);
+
+	nsecs += minstrel_mcs_groups[group].duration[rate];
+	tp_max = 100000000 / nsecs;
+
+	return tp_max;
+}
+
+
+/*
  * Find & sort topmost throughput rates
  *
  * If multiple rates provide equal throughput the sorting is based on their
diff --git a/net/mac80211/rc80211_minstrel_ht.h b/net/mac80211/rc80211_minstrel_ht.h
index 68dce4f..b1ea339 100644
--- a/net/mac80211/rc80211_minstrel_ht.h
+++ b/net/mac80211/rc80211_minstrel_ht.h
@@ -122,5 +122,6 @@ struct minstrel_ht_sta_priv {
 void minstrel_ht_add_sta_debugfs(void *priv, void *priv_sta, struct dentry *dir);
 void minstrel_ht_remove_sta_debugfs(void *priv, void *priv_sta);
 int minstrel_ht_get_tp_avg(struct minstrel_ht_sta *mi, int group, int rate);
+int minstrel_ht_get_tp_max(struct minstrel_ht_sta *mi, int group, int rate);
 
 #endif
diff --git a/net/mac80211/rc80211_minstrel_ht_debugfs.c b/net/mac80211/rc80211_minstrel_ht_debugfs.c
index ce3baab..e70961f 100644
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
 
+		tp_max = minstrel_ht_get_tp_max(mi, i, j);
 		tp_avg = minstrel_ht_get_tp_avg(mi, i, j);
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
 
+		tp_max = minstrel_ht_get_tp_max(mi, i, j);
 		tp_avg = minstrel_ht_get_tp_avg(mi, i, j);
 		prob = MINSTREL_TRUNC(mrs->cur_prob * 1000);
 		eprob = MINSTREL_TRUNC(mrs->prob_ewma * 1000);
 
-		p += sprintf(p, "%u.%u,%u.%u,%u.%u,%u,%u,%u,%llu,%llu,",
+		p += sprintf(p, "%u.%u,%u.%u,%u.%u,%u.%u,%u,%u,%u,%llu,%llu,",
+				tp_max / 10, tp_max % 10,
 				tp_avg / 10, tp_avg % 10,
 				eprob / 10, eprob % 10,
 				prob / 10, prob % 10,
-- 
2.2.2

