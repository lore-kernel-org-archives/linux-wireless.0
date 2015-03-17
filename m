Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:45819 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932589AbbCQR2Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2015 13:28:16 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, nbd@nbd.name,
	thomas@net.t-labs.tu-berlin.de
Subject: [PATCH v3 05/10] mac80211: unify Minstrel & Minstrel-HTs calculation of rate statistics
Date: Tue, 17 Mar 2015 18:29:14 +0100
Message-Id: <1426613359-31306-5-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20150317_182835_548216_047F8443)
In-Reply-To: <1426613359-31306-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1426613359-31306-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch unifies the calculation of Minstrels and Minstrel-HTs
per-rate statistic. The new common function minstrel_calc_rate_stats()
is called when a statistic update is performed.

Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
---
 net/mac80211/rc80211_minstrel.c    | 44 ++++++++++++++++++++++++--------------
 net/mac80211/rc80211_minstrel.h    |  3 +++
 net/mac80211/rc80211_minstrel_ht.c | 28 +-----------------------
 3 files changed, 32 insertions(+), 43 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index 7c86a00..4858e67 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -127,6 +127,32 @@ minstrel_update_rates(struct minstrel_priv *mp, struct minstrel_sta_info *mi)
 	rate_control_set_rates(mp->hw, mi->sta, ratetbl);
 }
 
+/*
+* Recalculate success probabilities and counters for a given rate using EWMA
+*/
+void
+minstrel_calc_rate_stats(struct minstrel_rate_stats *mrs)
+{
+	if (unlikely(mrs->attempts > 0)) {
+		mrs->sample_skipped = 0;
+		mrs->cur_prob = MINSTREL_FRAC(mrs->success, mrs->attempts);
+		if (unlikely(!mrs->att_hist))
+			mrs->probability = mrs->cur_prob;
+		else
+			mrs->probability = minstrel_ewma(mrs->probability,
+						     mrs->cur_prob, EWMA_LEVEL);
+		mrs->att_hist += mrs->attempts;
+		mrs->succ_hist += mrs->success;
+	} else {
+		mrs->sample_skipped++;
+	}
+
+	mrs->last_success = mrs->success;
+	mrs->last_attempts = mrs->attempts;
+	mrs->success = 0;
+	mrs->attempts = 0;
+}
+
 static void
 minstrel_update_stats(struct minstrel_priv *mp, struct minstrel_sta_info *mi)
 {
@@ -146,22 +172,8 @@ minstrel_update_stats(struct minstrel_priv *mp, struct minstrel_sta_info *mi)
 		if (!usecs)
 			usecs = 1000000;
 
-		if (unlikely(mrs->attempts > 0)) {
-			mrs->sample_skipped = 0;
-			mrs->cur_prob = MINSTREL_FRAC(mrs->success,
-						      mrs->attempts);
-			mrs->succ_hist += mrs->success;
-			mrs->att_hist += mrs->attempts;
-			mrs->probability = minstrel_ewma(mrs->probability,
-							 mrs->cur_prob,
-							 EWMA_LEVEL);
-		} else
-			mrs->sample_skipped++;
-
-		mrs->last_success = mrs->success;
-		mrs->last_attempts = mrs->attempts;
-		mrs->success = 0;
-		mrs->attempts = 0;
+		/* Update success probabilities per rate */
+		minstrel_calc_rate_stats(mrs);
 
 		/* Update throughput per rate, reset thr. below 10% success */
 		if (mrs->probability < MINSTREL_FRAC(10, 100))
diff --git a/net/mac80211/rc80211_minstrel.h b/net/mac80211/rc80211_minstrel.h
index 9613e73..728144c 100644
--- a/net/mac80211/rc80211_minstrel.h
+++ b/net/mac80211/rc80211_minstrel.h
@@ -132,6 +132,9 @@ extern const struct rate_control_ops mac80211_minstrel;
 void minstrel_add_sta_debugfs(void *priv, void *priv_sta, struct dentry *dir);
 void minstrel_remove_sta_debugfs(void *priv, void *priv_sta);
 
+/* Recalculate success probabilities and counters for a given rate using EWMA */
+void minstrel_calc_rate_stats(struct minstrel_rate_stats *mr);
+
 /* debugfs */
 int minstrel_stats_open(struct inode *inode, struct file *file);
 int minstrel_stats_csv_open(struct inode *inode, struct file *file);
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 60698fc..7afa562 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -313,32 +313,6 @@ minstrel_get_ratestats(struct minstrel_ht_sta *mi, int index)
 	return &mi->groups[index / MCS_GROUP_RATES].rates[index % MCS_GROUP_RATES];
 }
 
-
-/*
- * Recalculate success probabilities and counters for a rate using EWMA
- */
-static void
-minstrel_calc_rate_ewma(struct minstrel_rate_stats *mr)
-{
-	if (unlikely(mr->attempts > 0)) {
-		mr->sample_skipped = 0;
-		mr->cur_prob = MINSTREL_FRAC(mr->success, mr->attempts);
-		if (!mr->att_hist)
-			mr->probability = mr->cur_prob;
-		else
-			mr->probability = minstrel_ewma(mr->probability,
-				mr->cur_prob, EWMA_LEVEL);
-		mr->att_hist += mr->attempts;
-		mr->succ_hist += mr->success;
-	} else {
-		mr->sample_skipped++;
-	}
-	mr->last_success = mr->success;
-	mr->last_attempts = mr->attempts;
-	mr->success = 0;
-	mr->attempts = 0;
-}
-
 /*
  * Calculate throughput based on the average A-MPDU length, taking into account
  * the expected number of retransmissions and their expected length
@@ -567,7 +541,7 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 
 			mr = &mg->rates[i];
 			mr->retry_updated = false;
-			minstrel_calc_rate_ewma(mr);
+			minstrel_calc_rate_stats(mr);
 			minstrel_ht_calc_tp(mi, group, i);
 
 			if (!mr->cur_tp)
-- 
2.3.0

