Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:40605 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758577Ab3CDSsg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 13:48:36 -0500
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	nbd@openwrt.org, thomas@net.t-labs.tu-berlin.de
Subject: [PATCH v3 3/7] mac80211: add documentation and verbose variable names in
Date: Mon,  4 Mar 2013 19:48:20 +0100
Message-Id: <1362422905-78079-4-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20130304_194850_151067_1E5A8017)
In-Reply-To: <1362422905-78079-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1362422905-78079-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add documentation and more verbose variable names to minstrel's
multi-rate-retry setup within function minstrel_get_rate() to
increase the readability of the algorithm.

Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
---
 net/mac80211/rc80211_minstrel.c | 81 +++++++++++++++++++++++++----------------
 net/mac80211/rc80211_minstrel.h |  2 +-
 2 files changed, 50 insertions(+), 33 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index c9b9902..152bb0e 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -78,7 +78,6 @@ minstrel_update_stats(struct minstrel_priv *mp, struct minstrel_sta_info *mi)
 	u32 usecs;
 	int i;
 
-	mi->stats_update = jiffies;
 	for (i = 0; i < mi->n_rates; i++) {
 		struct minstrel_rate *mr = &mi->r[i];
 
@@ -144,6 +143,9 @@ minstrel_update_stats(struct minstrel_priv *mp, struct minstrel_sta_info *mi)
 	mi->max_tp_rate = index_max_tp;
 	mi->max_tp_rate2 = index_max_tp2;
 	mi->max_prob_rate = index_max_prob;
+
+	/* Reset update timer */
+	mi->stats_update = jiffies;
 }
 
 static void
@@ -204,10 +206,10 @@ static int
 minstrel_get_next_sample(struct minstrel_sta_info *mi)
 {
 	unsigned int sample_ndx;
-	sample_ndx = SAMPLE_TBL(mi, mi->sample_idx, mi->sample_column);
-	mi->sample_idx++;
-	if ((int) mi->sample_idx > (mi->n_rates - 2)) {
-		mi->sample_idx = 0;
+	sample_ndx = SAMPLE_TBL(mi, mi->sample_row, mi->sample_column);
+	mi->sample_row++;
+	if ((int) mi->sample_row > (mi->n_rates - 2)) {
+		mi->sample_row = 0;
 		mi->sample_column++;
 		if (mi->sample_column >= SAMPLE_COLUMNS)
 			mi->sample_column = 0;
@@ -225,31 +227,37 @@ minstrel_get_rate(void *priv, struct ieee80211_sta *sta,
 	struct minstrel_priv *mp = priv;
 	struct ieee80211_tx_rate *ar = info->control.rates;
 	unsigned int ndx, sample_ndx = 0;
-	bool mrr;
-	bool sample_slower = false;
-	bool sample = false;
+	bool mrr_capable;
+	bool indirect_rate_sampling = false;
+	bool rate_sampling = false;
 	int i, delta;
 	int mrr_ndx[3];
-	int sample_rate;
+	int sampling_ratio;
 
+	/* management/no-ack frames do not use rate control */
 	if (rate_control_send_low(sta, priv_sta, txrc))
 		return;
 
-	mrr = mp->has_mrr && !txrc->rts && !txrc->bss_conf->use_cts_prot;
+	/* check multi-rate-retry capabilities & adjust lookaround_rate */
+	mrr_capable = mp->has_mrr &&
+		      !txrc->rts &&
+		      !txrc->bss_conf->use_cts_prot;
+	if (mrr_capable)
+		sampling_ratio = mp->lookaround_rate_mrr;
+	else
+		sampling_ratio = mp->lookaround_rate;
 
+	/* init rateindex [ndx] with max throughput rate */
 	ndx = mi->max_tp_rate;
 
-	if (mrr)
-		sample_rate = mp->lookaround_rate_mrr;
-	else
-		sample_rate = mp->lookaround_rate;
-
+	/* increase sum packet counter */
 	mi->packet_count++;
-	delta = (mi->packet_count * sample_rate / 100) -
+
+	delta = (mi->packet_count * sampling_ratio / 100) -
 			(mi->sample_count + mi->sample_deferred / 2);
 
 	/* delta > 0: sampling required */
-	if ((delta > 0) && (mrr || !mi->prev_sample)) {
+	if ((delta > 0) && (mrr_capable || !mi->prev_sample)) {
 		struct minstrel_rate *msr;
 		if (mi->packet_count >= 10000) {
 			mi->sample_deferred = 0;
@@ -268,21 +276,25 @@ minstrel_get_rate(void *priv, struct ieee80211_sta *sta,
 			mi->sample_count += (delta - mi->n_rates * 2);
 		}
 
+		/* get next random rate sample */
 		sample_ndx = minstrel_get_next_sample(mi);
 		msr = &mi->r[sample_ndx];
-		sample = true;
-		sample_slower = mrr && (msr->perfect_tx_time >
-			mi->r[ndx].perfect_tx_time);
+		rate_sampling = true;
 
-		if (!sample_slower) {
+		/* Decide if direct ( 1st mrr stage) or indirect (2nd mrr stage)
+		 * rate sampling method should be used */
+		if (mrr_capable &&
+		    msr->perfect_tx_time > mi->r[ndx].perfect_tx_time)
+				indirect_rate_sampling = true;
+
+		if (!indirect_rate_sampling) {
 			if (msr->sample_limit != 0) {
 				ndx = sample_ndx;
 				mi->sample_count++;
 				if (msr->sample_limit > 0)
 					msr->sample_limit--;
-			} else {
-				sample = false;
-			}
+			} else
+				rate_sampling = false;
 		} else {
 			/* Only use IEEE80211_TX_CTL_RATE_CTRL_PROBE to mark
 			 * packets that have the sampling rate deferred to the
@@ -294,34 +306,39 @@ minstrel_get_rate(void *priv, struct ieee80211_sta *sta,
 			mi->sample_deferred++;
 		}
 	}
-	mi->prev_sample = sample;
+	mi->prev_sample = rate_sampling;
 
 	/* If we're not using MRR and the sampling rate already
 	 * has a probability of >95%, we shouldn't be attempting
 	 * to use it, as this only wastes precious airtime */
-	if (!mrr && sample && (mi->r[ndx].probability > MINSTREL_FRAC(95, 100)))
+	if (!mrr_capable && rate_sampling &&
+	   (mi->r[ndx].probability > MINSTREL_FRAC(95, 100)))
 		ndx = mi->max_tp_rate;
 
+	/* mrr setup for 1st stage */
 	ar[0].idx = mi->r[ndx].rix;
 	ar[0].count = minstrel_get_retry_count(&mi->r[ndx], info);
 
-	if (!mrr) {
-		if (!sample)
+	/* non mrr setup for 2nd stage */
+	if (!mrr_capable) {
+		if (!rate_sampling)
 			ar[0].count = mp->max_retry;
 		ar[1].idx = mi->lowest_rix;
 		ar[1].count = mp->max_retry;
 		return;
 	}
 
-	/* MRR setup */
-	if (sample) {
-		if (sample_slower)
+	/* mrr setup for 2nd stage */
+	if (rate_sampling) {
+		if (indirect_rate_sampling)
 			mrr_ndx[0] = sample_ndx;
 		else
 			mrr_ndx[0] = mi->max_tp_rate;
 	} else {
 		mrr_ndx[0] = mi->max_tp_rate2;
 	}
+
+	/* mrr setup for 3rd & 4th stage */
 	mrr_ndx[1] = mi->max_prob_rate;
 	mrr_ndx[2] = 0;
 	for (i = 1; i < 4; i++) {
@@ -352,7 +369,7 @@ init_sample_table(struct minstrel_sta_info *mi)
 	u8 rnd[8];
 
 	mi->sample_column = 0;
-	mi->sample_idx = 0;
+	mi->sample_row = 0;
 	memset(mi->sample_table, 0, SAMPLE_COLUMNS * mi->n_rates);
 
 	for (col = 0; col < SAMPLE_COLUMNS; col++) {
diff --git a/net/mac80211/rc80211_minstrel.h b/net/mac80211/rc80211_minstrel.h
index fda4a61..5fb5cb8 100644
--- a/net/mac80211/rc80211_minstrel.h
+++ b/net/mac80211/rc80211_minstrel.h
@@ -69,7 +69,7 @@ struct minstrel_sta_info {
 	unsigned int sample_count;
 	int sample_deferred;
 
-	unsigned int sample_idx;
+	unsigned int sample_row;
 	unsigned int sample_column;
 
 	int n_rates;
-- 
1.8.1.1

