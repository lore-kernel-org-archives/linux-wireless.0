Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:40602 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758520Ab3CDSsf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 13:48:35 -0500
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	nbd@openwrt.org, thomas@net.t-labs.tu-berlin.de
Subject: [PATCH v3 1/7] mac80211: merge EWMA calculation of minstrel_ht and minstrel
Date: Mon,  4 Mar 2013 19:48:18 +0100
Message-Id: <1362422905-78079-2-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20130304_194840_596116_7D4CCC9F)
In-Reply-To: <1362422905-78079-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1362422905-78079-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Both rate control algorithms (minstrel and minstrel_ht) calculate
averages based on EWMA. Shift function minstrel_ewma() into
rc80211_minstrel.h and make use of it in both minstrel version.
Also shift the default EWMA level (75%) definition to the header file
and clean up variable usage.

Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
---
 net/mac80211/rc80211_minstrel.c    | 15 +++++----------
 net/mac80211/rc80211_minstrel.h    | 13 ++++++++++++-
 net/mac80211/rc80211_minstrel_ht.c | 10 ----------
 3 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index eea45a2..d78f629 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -76,7 +76,6 @@ minstrel_update_stats(struct minstrel_priv *mp, struct minstrel_sta_info *mi)
 	u32 max_tp = 0, index_max_tp = 0, index_max_tp2 = 0;
 	u32 max_prob = 0, index_max_prob = 0;
 	u32 usecs;
-	u32 p;
 	int i;
 
 	mi->stats_update = jiffies;
@@ -90,14 +89,13 @@ minstrel_update_stats(struct minstrel_priv *mp, struct minstrel_sta_info *mi)
 		/* To avoid rounding issues, probabilities scale from 0 (0%)
 		 * to 18000 (100%) */
 		if (mr->attempts) {
-			p = (mr->success * 18000) / mr->attempts;
+			mr->cur_prob = (mr->success * 18000) / mr->attempts;
 			mr->succ_hist += mr->success;
 			mr->att_hist += mr->attempts;
-			mr->cur_prob = p;
-			p = ((p * (100 - mp->ewma_level)) + (mr->probability *
-				mp->ewma_level)) / 100;
-			mr->probability = p;
-			mr->cur_tp = p * (1000000 / usecs);
+			mr->probability = minstrel_ewma(mr->probability,
+							mr->cur_prob,
+							EWMA_LEVEL);
+			mr->cur_tp = mr->probability * (1000000 / usecs);
 		}
 
 		mr->last_success = mr->success;
@@ -542,9 +540,6 @@ minstrel_alloc(struct ieee80211_hw *hw, struct dentry *debugfsdir)
 	mp->lookaround_rate = 5;
 	mp->lookaround_rate_mrr = 10;
 
-	/* moving average weight for EWMA */
-	mp->ewma_level = 75;
-
 	/* maximum time that the hw is allowed to stay in one MRR segment */
 	mp->segment_size = 6000;
 
diff --git a/net/mac80211/rc80211_minstrel.h b/net/mac80211/rc80211_minstrel.h
index 5ecf757..98db93f 100644
--- a/net/mac80211/rc80211_minstrel.h
+++ b/net/mac80211/rc80211_minstrel.h
@@ -9,6 +9,18 @@
 #ifndef __RC_MINSTREL_H
 #define __RC_MINSTREL_H
 
+#define EWMA_LEVEL 75	/* ewma weighting factor [%] */
+
+/*
+ * Perform EWMA (Exponentially Weighted Moving Average) calculation
+  */
+static inline int
+minstrel_ewma(int old, int new, int weight)
+{
+	return (new * (100 - weight) + old * weight) / 100;
+}
+
+
 struct minstrel_rate {
 	int bitrate;
 	int rix;
@@ -73,7 +85,6 @@ struct minstrel_priv {
 	unsigned int cw_min;
 	unsigned int cw_max;
 	unsigned int max_retry;
-	unsigned int ewma_level;
 	unsigned int segment_size;
 	unsigned int update_interval;
 	unsigned int lookaround_rate;
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 3af141c..a3081e5 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -18,7 +18,6 @@
 
 #define AVG_PKT_SIZE	1200
 #define SAMPLE_COLUMNS	10
-#define EWMA_LEVEL		75
 
 /* Number of bits for an average sized packet */
 #define MCS_NBITS (AVG_PKT_SIZE << 3)
@@ -129,15 +128,6 @@ const struct mcs_group minstrel_mcs_groups[] = {
 static u8 sample_table[SAMPLE_COLUMNS][MCS_GROUP_RATES];
 
 /*
- * Perform EWMA (Exponentially Weighted Moving Average) calculation
- */
-static int
-minstrel_ewma(int old, int new, int weight)
-{
-	return (new * (100 - weight) + old * weight) / 100;
-}
-
-/*
  * Look up an MCS group index based on mac80211 rate information
  */
 static int
-- 
1.8.1.1

