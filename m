Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:45835 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932848AbbCQR2S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2015 13:28:18 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, nbd@nbd.name,
	thomas@net.t-labs.tu-berlin.de
Subject: [PATCH v3 10/10] mac80211: add standard deviation to Minstrels throughput statistic
Date: Tue, 17 Mar 2015 18:29:19 +0100
Message-Id: <1426613359-31306-10-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20150317_182904_332299_9BAA852F)
In-Reply-To: <1426613359-31306-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1426613359-31306-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds the statistical descriptor "standard deviation"
to better describe the current properties of Minstrel and
Minstrel-HTs success probability distribution. The standard
deviation (SD) is calculated as exponential weighted moving
standard deviation (EWMSD) and its current value is added as
new column in all rc_stats (in debugfs).

Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
---
 net/mac80211/rc80211_minstrel.c            | 19 ++++++++++++++-----
 net/mac80211/rc80211_minstrel.h            | 22 +++++++++++++++++++++-
 net/mac80211/rc80211_minstrel_debugfs.c    | 19 ++++++++++++-------
 net/mac80211/rc80211_minstrel_ht_debugfs.c | 14 +++++++++-----
 4 files changed, 56 insertions(+), 18 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index c2afe51..30512d0 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -156,7 +156,7 @@ minstrel_update_rates(struct minstrel_priv *mp, struct minstrel_sta_info *mi)
 }
 
 /*
-* Recalculate success probabilities and counters for a given rate using EWMA
+* Recalculate statistics and counters of a given rate
 */
 void
 minstrel_calc_rate_stats(struct minstrel_rate_stats *mrs)
@@ -164,11 +164,20 @@ minstrel_calc_rate_stats(struct minstrel_rate_stats *mrs)
 	if (unlikely(mrs->attempts > 0)) {
 		mrs->sample_skipped = 0;
 		mrs->cur_prob = MINSTREL_FRAC(mrs->success, mrs->attempts);
-		if (unlikely(!mrs->att_hist))
+		if (unlikely(!mrs->att_hist)) {
 			mrs->prob_ewma = mrs->cur_prob;
-		else
+		} else {
+			/* update exponential weighted moving variance */
+			mrs->prob_ewmsd = minstrel_ewmsd(mrs->prob_ewmsd,
+							 mrs->cur_prob,
+							 mrs->prob_ewma,
+							 EWMA_LEVEL);
+
+			/*update exponential weighted moving avarage */
 			mrs->prob_ewma = minstrel_ewma(mrs->prob_ewma,
-						     mrs->cur_prob, EWMA_LEVEL);
+						       mrs->cur_prob,
+						       EWMA_LEVEL);
+		}
 		mrs->att_hist += mrs->attempts;
 		mrs->succ_hist += mrs->success;
 	} else {
@@ -195,7 +204,7 @@ minstrel_update_stats(struct minstrel_priv *mp, struct minstrel_sta_info *mi)
 		struct minstrel_rate *mr = &mi->r[i];
 		struct minstrel_rate_stats *mrs = &mi->r[i].stats;
 
-		/* Update success probabilities per rate */
+		/* Update statistics of success probability per rate */
 		minstrel_calc_rate_stats(mrs);
 
 		/* Sample less often below the 10% chance of success.
diff --git a/net/mac80211/rc80211_minstrel.h b/net/mac80211/rc80211_minstrel.h
index 38158b0..713c81e 100644
--- a/net/mac80211/rc80211_minstrel.h
+++ b/net/mac80211/rc80211_minstrel.h
@@ -35,6 +35,24 @@ minstrel_ewma(int old, int new, int weight)
 	return old + incr;
 }
 
+/*
+ * Perform EWMSD (Exponentially Weighted Moving Standard Deviation) calculation
+ */
+static inline int
+minstrel_ewmsd(int old_ewmsd, int cur_prob, int prob_ewma, int weight)
+{
+	int diff, incr, tmp_var;
+
+	/* calculate exponential weighted moving variance */
+	diff = MINSTREL_TRUNC((cur_prob - prob_ewma) * 1000000);
+	incr = (EWMA_DIV - weight) * diff / EWMA_DIV;
+	tmp_var = old_ewmsd * old_ewmsd;
+	tmp_var = weight * (tmp_var + diff * incr / 1000000) / EWMA_DIV;
+
+	/* return standard deviation */
+	return (u16) int_sqrt(tmp_var);
+}
+
 struct minstrel_rate_stats {
 	/* current / last sampling period attempts/success counters */
 	u16 attempts, last_attempts;
@@ -45,9 +63,11 @@ struct minstrel_rate_stats {
 
 	/* statistis of packet delivery probability
 	 *  cur_prob  - current prob within last update intervall
-	 *  prob_ewma - exponential weighted moving average of prob */
+	 *  prob_ewma - exponential weighted moving average of prob
+	 *  prob_ewmsd - exp. weighted moving standard deviation of prob */
 	unsigned int cur_prob;
 	unsigned int prob_ewma;
+	u16 prob_ewmsd;
 
 	/* maximum retry counts */
 	u8 retry_count;
diff --git a/net/mac80211/rc80211_minstrel_debugfs.c b/net/mac80211/rc80211_minstrel_debugfs.c
index 3ed69ef..0a60bac 100644
--- a/net/mac80211/rc80211_minstrel_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_debugfs.c
@@ -85,10 +85,12 @@ minstrel_stats_open(struct inode *inode, struct file *file)
 	file->private_data = ms;
 	p = ms->buf;
 	p += sprintf(p, "\n");
-	p += sprintf(p, "best   __________rate_________    __statistics__    "
-			"________last_______    ______sum-of________\n");
-	p += sprintf(p, "rate  [name idx airtime max_tp]  [ ø(tp) ø(prob)]  "
-			"[prob.|retry|suc|att]  [#success | #attempts]\n");
+	p += sprintf(p, "best   __________rate_________    ______"
+			"statistics______    ________last_______    "
+			"______sum-of________\n");
+	p += sprintf(p, "rate  [name idx airtime max_tp]  [ ø(tp) ø(prob) "
+			"sd(prob)]  [prob.|retry|suc|att]  "
+			"[#success | #attempts]\n");
 
 	for (i = 0; i < mi->n_rates; i++) {
 		struct minstrel_rate *mr = &mi->r[i];
@@ -110,11 +112,13 @@ minstrel_stats_open(struct inode *inode, struct file *file)
 		prob = MINSTREL_TRUNC(mrs->cur_prob * 1000);
 		eprob = MINSTREL_TRUNC(mrs->prob_ewma * 1000);
 
-		p += sprintf(p, "%4u.%1u   %4u.%1u   %3u.%1u     %3u.%1u %3u"
-				"   %3u %-3u   %9llu   %-9llu\n",
+		p += sprintf(p, "%4u.%1u   %4u.%1u   %3u.%1u    %3u.%1u"
+				"     %3u.%1u %3u   %3u %-3u   "
+				"%9llu   %-9llu\n",
 				tp_max / 10, tp_max % 10,
 				tp_avg / 10, tp_avg % 10,
 				eprob / 10, eprob % 10,
+				mrs->prob_ewmsd / 10, mrs->prob_ewmsd % 10,
 				prob / 10, prob % 10,
 				mrs->retry_count,
 				mrs->last_success,
@@ -180,11 +184,12 @@ minstrel_stats_csv_open(struct inode *inode, struct file *file)
 		prob = MINSTREL_TRUNC(mrs->cur_prob * 1000);
 		eprob = MINSTREL_TRUNC(mrs->prob_ewma * 1000);
 
-		p += sprintf(p, "%u.%u,%u.%u,%u.%u,%u.%u,%u,%u,%u,"
+		p += sprintf(p, "%u.%u,%u.%u,%u.%u,%u.%u,%u.%u,%u,%u,%u,"
 				"%llu,%llu,%d,%d\n",
 				tp_max / 10, tp_max % 10,
 				tp_avg / 10, tp_avg % 10,
 				eprob / 10, eprob % 10,
+				mrs->prob_ewmsd / 10, mrs->prob_ewmsd % 10,
 				prob / 10, prob % 10,
 				mrs->retry_count,
 				mrs->last_success,
diff --git a/net/mac80211/rc80211_minstrel_ht_debugfs.c b/net/mac80211/rc80211_minstrel_ht_debugfs.c
index de034e4..e950059 100644
--- a/net/mac80211/rc80211_minstrel_ht_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_ht_debugfs.c
@@ -86,11 +86,13 @@ minstrel_ht_stats_dump(struct minstrel_ht_sta *mi, int i, char *p)
 		prob = MINSTREL_TRUNC(mrs->cur_prob * 1000);
 		eprob = MINSTREL_TRUNC(mrs->prob_ewma * 1000);
 
-		p += sprintf(p, "%4u.%1u    %4u.%1u   %3u.%1u    %3u.%1u "
-				"%3u   %3u %-3u   %9llu   %-9llu\n",
+		p += sprintf(p, "%4u.%1u   %4u.%1u   %3u.%1u    %3u.%1u"
+				"     %3u.%1u %3u   %3u %-3u   "
+				"%9llu   %-9llu\n",
 				tp_max / 10, tp_max % 10,
 				tp_avg / 10, tp_avg % 10,
 				eprob / 10, eprob % 10,
+				mrs->prob_ewmsd / 10, mrs->prob_ewmsd % 10,
 				prob / 10, prob % 10,
 				mrs->retry_count,
 				mrs->last_success,
@@ -128,10 +130,10 @@ minstrel_ht_stats_open(struct inode *inode, struct file *file)
 
 	p += sprintf(p, "\n");
 	p += sprintf(p, "              best   ____________rate__________    "
-			"__statistics__    ________last_______    "
+			"______statistics______    ________last_______    "
 			"______sum-of________\n");
 	p += sprintf(p, "mode guard #  rate  [name   idx airtime  max_tp]  "
-			"[ ø(tp) ø(prob)]  [prob.|retry|suc|att]  [#success | "
+			"[ ø(tp) ø(prob) sd(prob)]  [prob.|retry|suc|att]  [#success | "
 			"#attempts]\n");
 
 	p = minstrel_ht_stats_dump(mi, MINSTREL_CCK_GROUP, p);
@@ -232,10 +234,12 @@ minstrel_ht_stats_csv_dump(struct minstrel_ht_sta *mi, int i, char *p,
 		prob = MINSTREL_TRUNC(mrs->cur_prob * 1000);
 		eprob = MINSTREL_TRUNC(mrs->prob_ewma * 1000);
 
-		p += sprintf(p, "%u.%u,%u.%u,%u.%u,%u.%u,%u,%u,%u,%llu,%llu,",
+		p += sprintf(p, "%u.%u,%u.%u,%u.%u,%u.%u,%u.%u,%u,%u,"
+				"%u,%llu,%llu,",
 				tp_max / 10, tp_max % 10,
 				tp_avg / 10, tp_avg % 10,
 				eprob / 10, eprob % 10,
+				mrs->prob_ewmsd / 10, mrs->prob_ewmsd % 10,
 				prob / 10, prob % 10,
 				mrs->retry_count,
 				mrs->last_success,
-- 
2.3.0

