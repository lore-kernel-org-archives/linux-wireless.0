Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:40282 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756459Ab3CDOWa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 09:22:30 -0500
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	nbd@openwrt.org, thomas@net.t-labs.tu-berlin.de
Subject: [PATCH v2 2/7] mac80211: merge value scaling macros of minstrel_ht and minstrel
Date: Mon,  4 Mar 2013 15:22:12 +0100
Message-Id: <1362406937-69969-3-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20130304_152236_464829_0F405A24)
In-Reply-To: <1362406937-69969-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1362406937-69969-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Both minstrel versions use individual ways to scale up integer values
to perform calculations. Merge minstrel_ht's scaling macros into
minstrels header file and use them in both minstrel versions.

Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
---
 net/mac80211/rc80211_minstrel.c         | 9 ++++-----
 net/mac80211/rc80211_minstrel.h         | 5 +++++
 net/mac80211/rc80211_minstrel_debugfs.c | 6 +++---
 net/mac80211/rc80211_minstrel_ht.h      | 5 -----
 4 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index d78f629..c9b9902 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -86,10 +86,8 @@ minstrel_update_stats(struct minstrel_priv *mp, struct minstrel_sta_info *mi)
 		if (!usecs)
 			usecs = 1000000;
 
-		/* To avoid rounding issues, probabilities scale from 0 (0%)
-		 * to 18000 (100%) */
 		if (mr->attempts) {
-			mr->cur_prob = (mr->success * 18000) / mr->attempts;
+			mr->cur_prob = MINSTREL_FRAC(mr->success, mr->attempts);
 			mr->succ_hist += mr->success;
 			mr->att_hist += mr->attempts;
 			mr->probability = minstrel_ewma(mr->probability,
@@ -105,7 +103,8 @@ minstrel_update_stats(struct minstrel_priv *mp, struct minstrel_sta_info *mi)
 
 		/* Sample less often below the 10% chance of success.
 		 * Sample less often above the 95% chance of success. */
-		if ((mr->probability > 17100) || (mr->probability < 1800)) {
+		if (mr->probability > MINSTREL_FRAC(95, 100) ||
+		    mr->probability < MINSTREL_FRAC(10, 100)) {
 			mr->adjusted_retry_count = mr->retry_count >> 1;
 			if (mr->adjusted_retry_count > 2)
 				mr->adjusted_retry_count = 2;
@@ -300,7 +299,7 @@ minstrel_get_rate(void *priv, struct ieee80211_sta *sta,
 	/* If we're not using MRR and the sampling rate already
 	 * has a probability of >95%, we shouldn't be attempting
 	 * to use it, as this only wastes precious airtime */
-	if (!mrr && sample && (mi->r[ndx].probability > 17100))
+	if (!mrr && sample && (mi->r[ndx].probability > MINSTREL_FRAC(95, 100)))
 		ndx = mi->max_tp_rate;
 
 	ar[0].idx = mi->r[ndx].rix;
diff --git a/net/mac80211/rc80211_minstrel.h b/net/mac80211/rc80211_minstrel.h
index 98db93f..fda4a61 100644
--- a/net/mac80211/rc80211_minstrel.h
+++ b/net/mac80211/rc80211_minstrel.h
@@ -11,6 +11,11 @@
 
 #define EWMA_LEVEL 75	/* ewma weighting factor [%] */
 
+/* scaled fraction values */
+#define MINSTREL_SCALE  16
+#define MINSTREL_FRAC(val, div) (((val) << MINSTREL_SCALE) / div)
+#define MINSTREL_TRUNC(val) ((val) >> MINSTREL_SCALE)
+
 /*
  * Perform EWMA (Exponentially Weighted Moving Average) calculation
   */
diff --git a/net/mac80211/rc80211_minstrel_debugfs.c b/net/mac80211/rc80211_minstrel_debugfs.c
index d5a5622..c0ebfac 100644
--- a/net/mac80211/rc80211_minstrel_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_debugfs.c
@@ -79,9 +79,9 @@ minstrel_stats_open(struct inode *inode, struct file *file)
 		p += sprintf(p, "%3u%s", mr->bitrate / 2,
 				(mr->bitrate & 1 ? ".5" : "  "));
 
-		tp = mr->cur_tp / ((18000 << 10) / 96);
-		prob = mr->cur_prob / 18;
-		eprob = mr->probability / 18;
+		tp = MINSTREL_TRUNC(mr->cur_tp / 10);
+		prob = MINSTREL_TRUNC(mr->cur_prob * 1000);
+		eprob = MINSTREL_TRUNC(mr->probability * 1000);
 
 		p += sprintf(p, "  %6u.%1u   %6u.%1u   %6u.%1u        "
 				"%3u(%3u)   %8llu    %8llu\n",
diff --git a/net/mac80211/rc80211_minstrel_ht.h b/net/mac80211/rc80211_minstrel_ht.h
index 302dbd5..4ee5999 100644
--- a/net/mac80211/rc80211_minstrel_ht.h
+++ b/net/mac80211/rc80211_minstrel_ht.h
@@ -16,11 +16,6 @@
 #define MINSTREL_MAX_STREAMS	3
 #define MINSTREL_STREAM_GROUPS	4
 
-/* scaled fraction values */
-#define MINSTREL_SCALE	16
-#define MINSTREL_FRAC(val, div) (((val) << MINSTREL_SCALE) / div)
-#define MINSTREL_TRUNC(val) ((val) >> MINSTREL_SCALE)
-
 #define MCS_GROUP_RATES	8
 
 struct mcs_group {
-- 
1.8.1.1

