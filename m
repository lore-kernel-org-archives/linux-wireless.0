Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:47271 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbYJOROM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2008 13:14:12 -0400
Message-ID: <48F624D7.4040802@openwrt.org> (sfid-20081015_191416_028867_5FFAA6AC)
Date: Wed, 15 Oct 2008 19:13:59 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] minstrel: improve performance for non-MRR drivers
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch enhances minstrel's performance for non-MRR setups,
by preventing it from sampling slower rates with >95% success
probability and by putting at least 1 non-sample frame between
several sample frames.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
This patch depends on the rate control API rewrite patch.

--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -126,7 +126,9 @@ minstrel_update_stats(struct minstrel_pr
 			mr->adjusted_retry_count = mr->retry_count >> 1;
 			if (mr->adjusted_retry_count > 2)
 				mr->adjusted_retry_count = 2;
+			mr->sample_limit = 4;
 		} else {
+			mr->sample_limit = -1;
 			mr->adjusted_retry_count = mr->retry_count;
 		}
 		if (!mr->adjusted_retry_count)
@@ -265,7 +267,8 @@ minstrel_get_rate(void *priv, struct iee
 			(mi->sample_count + mi->sample_deferred / 2);
 
 	/* delta > 0: sampling required */
-	if (delta > 0) {
+	if ((delta > 0) && (mrr || !mi->prev_sample)) {
+		struct minstrel_rate *msr;
 		if (mi->packet_count >= 10000) {
 			mi->sample_deferred = 0;
 			mi->sample_count = 0;
@@ -284,13 +287,20 @@ minstrel_get_rate(void *priv, struct iee
 		}
 
 		sample_ndx = minstrel_get_next_sample(mi);
+		msr = &mi->r[sample_ndx];
 		sample = true;
-		sample_slower = mrr && (mi->r[sample_ndx].perfect_tx_time >
+		sample_slower = mrr && (msr->perfect_tx_time >
 			mi->r[ndx].perfect_tx_time);
 
 		if (!sample_slower) {
-			ndx = sample_ndx;
-			mi->sample_count++;
+			if (msr->sample_limit != 0) {
+				ndx = sample_ndx;
+				mi->sample_count++;
+				if (msr->sample_limit > 0)
+					msr->sample_limit--;
+			} else {
+				sample = false;
+			}
 		} else {
 			/* Only use IEEE80211_TX_CTL_RATE_CTRL_PROBE to mark
 			 * packets that have the sampling rate deferred to the
@@ -302,10 +312,20 @@ minstrel_get_rate(void *priv, struct iee
 			mi->sample_deferred++;
 		}
 	}
+	mi->prev_sample = sample;
+
+	/* If we're not using MRR and the sampling rate already
+	 * has a probability of >95%, we shouldn't be attempting
+	 * to use it, as this only wastes precious airtime */
+	if (!mrr && sample && (mi->r[ndx].probability > 17100))
+		ndx = mi->max_tp_rate;
+
 	ar[0].idx = mi->r[ndx].rix;
 	ar[0].count = minstrel_get_retry_count(&mi->r[ndx], info);
 
 	if (!mrr) {
+		if (!sample)
+			ar[0].count = mp->max_retry;
 		ar[1].idx = mi->lowest_rix;
 		ar[1].count = mp->max_retry;
 		return;
@@ -401,6 +421,7 @@ minstrel_rate_init(void *priv, struct ie
 
 		/* calculate maximum number of retransmissions before
 		 * fallback (based on maximum segment size) */
+		mr->sample_limit = -1;
 		mr->retry_count = 1;
 		mr->retry_count_cts = 1;
 		mr->retry_count_rtscts = 1;
--- a/net/mac80211/rc80211_minstrel.h
+++ b/net/mac80211/rc80211_minstrel.h
@@ -16,6 +16,7 @@ struct minstrel_rate {
 	unsigned int perfect_tx_time;
 	unsigned int ack_time;
 
+	int sample_limit;
 	unsigned int retry_count;
 	unsigned int retry_count_cts;
 	unsigned int retry_count_rtscts;
@@ -57,6 +58,7 @@ struct minstrel_sta_info {
 
 	int n_rates;
 	struct minstrel_rate *r;
+	bool prev_sample;
 
 	/* sampling table */
 	u8 *sample_table;
