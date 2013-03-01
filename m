Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:36843 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751308Ab3CARhp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Mar 2013 12:37:45 -0500
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes.berg@intel.com,
	nbd@openwrt.org, thomas@net.t-labs.tu-berlin.de
Subject: [PATCH 7/7] mac80211: improve minstrels rate sorting by means of throughput & probability
Date: Fri,  1 Mar 2013 18:37:36 +0100
Message-Id: <1362159456-39448-8-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20130301_183800_661115_25E8B40B)
In-Reply-To: <1362159456-39448-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1362159456-39448-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch improves the way minstrel sorts rates according to throughput
and success probability. 3 FOR-loops across the entire rate set in function
minstrel_update_stats() which where used to determine the fastest, second
fastest and most robust rate are reduced to 1 FOR-loop.

The sorted list of rates according throughput is extended to the best four
rates as we need them in upcoming joint rate and power control.

The most robust rate selection is aligned with minstrel_ht's approach.
Once any success probability is above 95% the one with the highest
throughput is chosen as most robust rate. If success probabilities of all
rates are below 95%, the rate with the highest succ. prob. is elected as
most robust one

Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
---
 net/mac80211/rc80211_minstrel.c         | 66 +++++++++++++++++----------------
 net/mac80211/rc80211_minstrel.h         | 10 +++--
 net/mac80211/rc80211_minstrel_debugfs.c |  6 ++-
 3 files changed, 45 insertions(+), 37 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index 8af71f6..221b5f4 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -72,13 +72,17 @@ rix_to_ndx(struct minstrel_sta_info *mi, int rix)
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
+		int j = MAX_THR_RATES;
 
 		usecs = mr->perfect_tx_time;
 		if (!usecs)
@@ -120,35 +124,35 @@ minstrel_update_stats(struct minstrel_priv *mp, struct minstrel_sta_info *mi)
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
+		/* Find 1st, 2nd, 3rd & 4th best throughput rate */
+		//printk(KERN_ERR "before sort: max_tp_rate[0]= %i, [1]= %i, [2]= %i, [3]= %i,", mi->max_tp_rate[0], mi->max_tp_rate[1], mi->max_tp_rate[2], mi->max_tp_rate[3]);
+		while (j > 0 && mr->cur_tp > mi->r[tmp_tp_rate[j - 1]].cur_tp)
+			j--;
+		if (j < MAX_THR_RATES - 1)
+			memmove(&tmp_tp_rate[j + 1], &tmp_tp_rate[j], MAX_THR_RATES - (j + 1));
+		if (j < MAX_THR_RATES)
+			tmp_tp_rate[j] = i;
+		//printk(KERN_ERR "after sort with j=%i : max_tp_rate[0]= %i, [1]= %i, [2]= %i, [3]= %i,", j, mi->max_tp_rate[0], mi->max_tp_rate[1], mi->max_tp_rate[2], mi->max_tp_rate[3]);
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
@@ -254,7 +258,7 @@ minstrel_get_rate(void *priv, struct ieee80211_sta *sta,
 		sampling_ratio = mp->lookaround_rate;
 
 	/* init rateindex [ndx] with max throughput rate */
-	ndx = mi->max_tp_rate;
+	ndx = mi->max_tp_rate[0];
 
 	/* increase sum packet counter */
 	mi->packet_count++;
@@ -322,7 +326,7 @@ minstrel_get_rate(void *priv, struct ieee80211_sta *sta,
 	 * to use it, as this only wastes precious airtime */
 	if (!mrr_capable && rate_sampling &&
 	   (mi->r[ndx].probability > MINSTREL_FRAC(95, 100)))
-		ndx = mi->max_tp_rate;
+		ndx = mi->max_tp_rate[0];
 
 	/* mrr setup for 1st stage */
 	ar[0].idx = mi->r[ndx].rix;
@@ -342,9 +346,9 @@ minstrel_get_rate(void *priv, struct ieee80211_sta *sta,
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
index 49a770b..85ebf42 100644
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
@@ -80,7 +82,7 @@ struct minstrel_sta_info {
 	bool prev_sample;
 
 	/* sampling table */
-	void *sample_table;
+	u8 *sample_table;
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct dentry *dbg_stats;
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

