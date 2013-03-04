Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:40616 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756790Ab3CDSsi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 13:48:38 -0500
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	nbd@openwrt.org, thomas@net.t-labs.tu-berlin.de
Subject: [PATCH v3 7/7] mac80211: improve minstrels rate sorting by means of throughput & probability
Date: Mon,  4 Mar 2013 19:48:24 +0100
Message-Id: <1362422905-78079-8-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20130304_194841_408230_24A4C548)
In-Reply-To: <1362422905-78079-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1362422905-78079-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch improves the way minstrel sorts rates according to throughput
and success probability. 3 FOR-loops across the entire rate set in function
minstrel_update_stats() which where used to determine the fastest, second
fastest and most robust rate are reduced to 1 FOR-loop.

The sorted list of rates according throughput is extended to the best four
rates as we need them in upcoming joint rate and power control. The sorting
is done via the new function minstrel_sort_best_tp_rates().

The most robust rate selection is aligned with minstrel_ht's approach.
Once any success probability is above 95% the one with the highest
throughput is chosen as most robust rate. If success probabilities of all
rates are below 95%, the rate with the highest succ. prob. is elected as
most robust one

Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
---
 net/mac80211/rc80211_minstrel.c         | 71 +++++++++++++++++++--------------
 net/mac80211/rc80211_minstrel.h         |  8 ++--
 net/mac80211/rc80211_minstrel_debugfs.c |  6 ++-
 3 files changed, 49 insertions(+), 36 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index de88ae7..66e6ae4 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -69,14 +69,31 @@ rix_to_ndx(struct minstrel_sta_info *mi, int rix)
 	return i;
 }
 
+/* find & sort topmost throughput rates */
+static inline void
+minstrel_sort_best_tp_rates(struct minstrel_sta_info *mi, int i, u8 *tp_list)
+{
+	int j = MAX_THR_RATES;
+
+	while (j > 0 && mi->r[i].cur_tp > mi->r[tp_list[j - 1]].cur_tp)
+		j--;
+	if (j < MAX_THR_RATES - 1)
+		memmove(&tp_list[j + 1], &tp_list[j], MAX_THR_RATES - (j + 1));
+	if (j < MAX_THR_RATES)
+		tp_list[j] = i;
+}
+
 static void
 minstrel_update_stats(struct minstrel_priv *mp, struct minstrel_sta_info *mi)
 {
-	u32 max_tp = 0, index_max_tp = 0, index_max_tp2 = 0;
-	u32 max_prob = 0, index_max_prob = 0;
+	u8 tmp_tp_rate[MAX_THR_RATES];
+	u8 tmp_prob_rate = 0;
 	u32 usecs;
 	int i;
 
+	for (i=0; i < MAX_THR_RATES; i++)
+	    tmp_tp_rate[i] = 0;
+
 	for (i = 0; i < mi->n_rates; i++) {
 		struct minstrel_rate *mr = &mi->r[i];
 
@@ -120,35 +137,27 @@ minstrel_update_stats(struct minstrel_priv *mp, struct minstrel_sta_info *mi)
 		}
 		if (!mr->adjusted_retry_count)
 			mr->adjusted_retry_count = 2;
-	}
 
-	for (i = 0; i < mi->n_rates; i++) {
-		struct minstrel_rate *mr = &mi->r[i];
-		if (max_tp < mr->cur_tp) {
-			index_max_tp = i;
-			max_tp = mr->cur_tp;
-		}
-		if (max_prob < mr->probability) {
-			index_max_prob = i;
-			max_prob = mr->probability;
+		minstrel_sort_best_tp_rates(mi, i, tmp_tp_rate);
+
+		/* To determine the most robust rate (max_prob_rate) used at
+		 * 3rd mmr stage we distinct between two cases:
+		 * (1) if any success probabilitiy >= 95%, out of those rates
+		 * choose the maximum throughput rate as max_prob_rate
+		 * (2) if all success probabilities < 95%, the rate with
+		 * highest success probability is choosen as max_prob_rate */
+		if (mr->probability >= MINSTREL_FRAC(95,100)) {
+			if (mr->cur_tp >= mi->r[tmp_prob_rate].cur_tp)
+				tmp_prob_rate = i;
+		} else {
+			if (mr->probability >= mi->r[tmp_prob_rate].probability)
+				tmp_prob_rate = i;
 		}
 	}
 
-	max_tp = 0;
-	for (i = 0; i < mi->n_rates; i++) {
-		struct minstrel_rate *mr = &mi->r[i];
-
-		if (i == index_max_tp)
-			continue;
-
-		if (max_tp < mr->cur_tp) {
-			index_max_tp2 = i;
-			max_tp = mr->cur_tp;
-		}
-	}
-	mi->max_tp_rate = index_max_tp;
-	mi->max_tp_rate2 = index_max_tp2;
-	mi->max_prob_rate = index_max_prob;
+	/* Assign the new rate set */
+	memcpy(mi->max_tp_rate, tmp_tp_rate, sizeof(mi->max_tp_rate));
+	mi->max_prob_rate = tmp_prob_rate;
 
 	/* Reset update timer */
 	mi->stats_update = jiffies;
@@ -254,7 +263,7 @@ minstrel_get_rate(void *priv, struct ieee80211_sta *sta,
 		sampling_ratio = mp->lookaround_rate;
 
 	/* init rateindex [ndx] with max throughput rate */
-	ndx = mi->max_tp_rate;
+	ndx = mi->max_tp_rate[0];
 
 	/* increase sum packet counter */
 	mi->packet_count++;
@@ -322,7 +331,7 @@ minstrel_get_rate(void *priv, struct ieee80211_sta *sta,
 	 * to use it, as this only wastes precious airtime */
 	if (!mrr_capable && rate_sampling &&
 	   (mi->r[ndx].probability > MINSTREL_FRAC(95, 100)))
-		ndx = mi->max_tp_rate;
+		ndx = mi->max_tp_rate[0];
 
 	/* mrr setup for 1st stage */
 	ar[0].idx = mi->r[ndx].rix;
@@ -342,9 +351,9 @@ minstrel_get_rate(void *priv, struct ieee80211_sta *sta,
 		if (indirect_rate_sampling)
 			mrr_ndx[0] = sample_ndx;
 		else
-			mrr_ndx[0] = mi->max_tp_rate;
+			mrr_ndx[0] = mi->max_tp_rate[0];
 	} else {
-		mrr_ndx[0] = mi->max_tp_rate2;
+		mrr_ndx[0] = mi->max_tp_rate[1];
 	}
 
 	/* mrr setup for 3rd & 4th stage */
diff --git a/net/mac80211/rc80211_minstrel.h b/net/mac80211/rc80211_minstrel.h
index a0ccc57..85ebf42 100644
--- a/net/mac80211/rc80211_minstrel.h
+++ b/net/mac80211/rc80211_minstrel.h
@@ -18,6 +18,9 @@
 #define MINSTREL_FRAC(val, div) (((val) << MINSTREL_SCALE) / div)
 #define MINSTREL_TRUNC(val) ((val) >> MINSTREL_SCALE)
 
+/* number of highest throughput rates to consider*/
+#define MAX_THR_RATES 4
+
 /*
  * Perform EWMA (Exponentially Weighted Moving Average) calculation
   */
@@ -65,9 +68,8 @@ struct minstrel_sta_info {
 
 	unsigned int lowest_rix;
 
-	unsigned int max_tp_rate;
-	unsigned int max_tp_rate2;
-	unsigned int max_prob_rate;
+	u8 max_tp_rate[MAX_THR_RATES];
+	u8 max_prob_rate;
 	unsigned int packet_count;
 	unsigned int sample_count;
 	int sample_deferred;
diff --git a/net/mac80211/rc80211_minstrel_debugfs.c b/net/mac80211/rc80211_minstrel_debugfs.c
index c0ebfac..d104834 100644
--- a/net/mac80211/rc80211_minstrel_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_debugfs.c
@@ -73,8 +73,10 @@ minstrel_stats_open(struct inode *inode, struct file *file)
 	for (i = 0; i < mi->n_rates; i++) {
 		struct minstrel_rate *mr = &mi->r[i];
 
-		*(p++) = (i == mi->max_tp_rate) ? 'T' : ' ';
-		*(p++) = (i == mi->max_tp_rate2) ? 't' : ' ';
+		*(p++) = (i == mi->max_tp_rate[0]) ? 'A' : ' ';
+		*(p++) = (i == mi->max_tp_rate[1]) ? 'B' : ' ';
+		*(p++) = (i == mi->max_tp_rate[2]) ? 'C' : ' ';
+		*(p++) = (i == mi->max_tp_rate[3]) ? 'D' : ' ';
 		*(p++) = (i == mi->max_prob_rate) ? 'P' : ' ';
 		p += sprintf(p, "%3u%s", mr->bitrate / 2,
 				(mr->bitrate & 1 ? ".5" : "  "));
-- 
1.8.1.1

