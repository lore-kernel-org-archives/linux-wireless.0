Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:43604 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937Ab3DVKJ6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Apr 2013 06:09:58 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, karl.beldan@gmail.com
Subject: [PATCH v5 3/3] mac80211/minstrel: use the new rate control API
Date: Mon, 22 Apr 2013 12:09:53 +0200
Message-Id: <1366625393-11647-3-git-send-email-nbd@openwrt.org> (sfid-20130422_121006_275476_93DC0C4C)
In-Reply-To: <1366625393-11647-1-git-send-email-nbd@openwrt.org>
References: <1366625393-11647-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pass the rate selection table to mac80211 from minstrel_update_stats.
Only rates for sample attempts are set in info->control.rates, with deferred
sampling, only the second slot gets changed.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/rc80211_minstrel.c | 200 ++++++++++++++++++++++------------------
 net/mac80211/rc80211_minstrel.h |   2 +
 2 files changed, 111 insertions(+), 91 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index eda290f..ac7ef54 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -84,6 +84,50 @@ minstrel_sort_best_tp_rates(struct minstrel_sta_info *mi, int i, u8 *tp_list)
 }
 
 static void
+minstrel_set_rate(struct minstrel_sta_info *mi, struct ieee80211_sta_rates *ratetbl,
+		  int offset, int idx)
+{
+	struct minstrel_rate *r = &mi->r[idx];
+
+	ratetbl->rate[offset].idx = r->rix;
+	ratetbl->rate[offset].count = r->adjusted_retry_count;
+	ratetbl->rate[offset].count_cts = r->retry_count_cts;
+	ratetbl->rate[offset].count_rts = r->retry_count_rtscts;
+}
+
+static void
+minstrel_update_rates(struct minstrel_priv *mp, struct minstrel_sta_info *mi)
+{
+	struct ieee80211_sta_rates *ratetbl;
+	int i = 0;
+
+	ratetbl = kzalloc(sizeof(*ratetbl), GFP_ATOMIC);
+	if (!ratetbl)
+		return;
+
+	/* Start with max_tp_rate */
+	minstrel_set_rate(mi, ratetbl, i++, mi->max_tp_rate[0]);
+
+	if (mp->hw->max_rates >= 3) {
+		/* At least 3 tx rates supported, use max_tp_rate2 next */
+		minstrel_set_rate(mi, ratetbl, i++, mi->max_tp_rate[1]);
+	}
+
+	if (mp->hw->max_rates >= 2) {
+		/* At least 2 tx rates supported, use max_prob_rate next */
+		minstrel_set_rate(mi, ratetbl, i++, mi->max_prob_rate);
+	}
+
+	/* Use lowest rate last */
+	ratetbl->rate[i].idx = mi->lowest_rix;
+	ratetbl->rate[i].count = mp->max_retry;
+	ratetbl->rate[i].count_cts = mp->max_retry;
+	ratetbl->rate[i].count_rts = mp->max_retry;
+
+	rate_control_set_rates(mp->hw, mi->sta, ratetbl);
+}
+
+static void
 minstrel_update_stats(struct minstrel_priv *mp, struct minstrel_sta_info *mi)
 {
 	u8 tmp_tp_rate[MAX_THR_RATES];
@@ -161,6 +205,8 @@ minstrel_update_stats(struct minstrel_priv *mp, struct minstrel_sta_info *mi)
 
 	/* Reset update timer */
 	mi->stats_update = jiffies;
+
+	minstrel_update_rates(mp, mi);
 }
 
 static void
@@ -240,13 +286,12 @@ minstrel_get_rate(void *priv, struct ieee80211_sta *sta,
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct minstrel_sta_info *mi = priv_sta;
 	struct minstrel_priv *mp = priv;
-	struct ieee80211_tx_rate *ar = info->control.rates;
-	unsigned int ndx, sample_ndx = 0;
+	struct ieee80211_tx_rate *rate = &info->control.rates[0];
+	struct minstrel_rate *msr, *mr;
+	unsigned int ndx;
 	bool mrr_capable;
-	bool indirect_rate_sampling = false;
-	bool rate_sampling = false;
-	int i, delta;
-	int mrr_ndx[3];
+	bool prev_sample = mi->prev_sample;
+	int delta;
 	int sampling_ratio;
 
 	/* management/no-ack frames do not use rate control */
@@ -262,107 +307,75 @@ minstrel_get_rate(void *priv, struct ieee80211_sta *sta,
 	else
 		sampling_ratio = mp->lookaround_rate;
 
-	/* init rateindex [ndx] with max throughput rate */
-	ndx = mi->max_tp_rate[0];
-
 	/* increase sum packet counter */
 	mi->packet_count++;
 
 	delta = (mi->packet_count * sampling_ratio / 100) -
 			(mi->sample_count + mi->sample_deferred / 2);
 
-	/* delta > 0: sampling required */
-	if ((delta > 0) && (mrr_capable || !mi->prev_sample)) {
-		struct minstrel_rate *msr;
-		if (mi->packet_count >= 10000) {
-			mi->sample_deferred = 0;
-			mi->sample_count = 0;
-			mi->packet_count = 0;
-		} else if (delta > mi->n_rates * 2) {
-			/* With multi-rate retry, not every planned sample
-			 * attempt actually gets used, due to the way the retry
-			 * chain is set up - [max_tp,sample,prob,lowest] for
-			 * sample_rate < max_tp.
-			 *
-			 * If there's too much sampling backlog and the link
-			 * starts getting worse, minstrel would start bursting
-			 * out lots of sampling frames, which would result
-			 * in a large throughput loss. */
-			mi->sample_count += (delta - mi->n_rates * 2);
-		}
+	/* delta < 0: no sampling required */
+	mi->prev_sample = false;
+	if (delta < 0 || (!mrr_capable && prev_sample))
+		return;
 
-		/* get next random rate sample */
-		sample_ndx = minstrel_get_next_sample(mi);
-		msr = &mi->r[sample_ndx];
-		rate_sampling = true;
-
-		/* Decide if direct ( 1st mrr stage) or indirect (2nd mrr stage)
-		 * rate sampling method should be used.
-		 * Respect such rates that are not sampled for 20 interations.
-		 */
-		if (mrr_capable &&
-		    msr->perfect_tx_time > mi->r[ndx].perfect_tx_time &&
-		    msr->sample_skipped < 20)
-				indirect_rate_sampling = true;
-
-		if (!indirect_rate_sampling) {
-			if (msr->sample_limit != 0) {
-				ndx = sample_ndx;
-				mi->sample_count++;
-				if (msr->sample_limit > 0)
-					msr->sample_limit--;
-			} else
-				rate_sampling = false;
-		} else {
-			/* Only use IEEE80211_TX_CTL_RATE_CTRL_PROBE to mark
-			 * packets that have the sampling rate deferred to the
-			 * second MRR stage. Increase the sample counter only
-			 * if the deferred sample rate was actually used.
-			 * Use the sample_deferred counter to make sure that
-			 * the sampling is not done in large bursts */
-			info->flags |= IEEE80211_TX_CTL_RATE_CTRL_PROBE;
-			mi->sample_deferred++;
-		}
+	if (mi->packet_count >= 10000) {
+		mi->sample_deferred = 0;
+		mi->sample_count = 0;
+		mi->packet_count = 0;
+	} else if (delta > mi->n_rates * 2) {
+		/* With multi-rate retry, not every planned sample
+		 * attempt actually gets used, due to the way the retry
+		 * chain is set up - [max_tp,sample,prob,lowest] for
+		 * sample_rate < max_tp.
+		 *
+		 * If there's too much sampling backlog and the link
+		 * starts getting worse, minstrel would start bursting
+		 * out lots of sampling frames, which would result
+		 * in a large throughput loss. */
+		mi->sample_count += (delta - mi->n_rates * 2);
+	}
+
+	/* get next random rate sample */
+	ndx = minstrel_get_next_sample(mi);
+	msr = &mi->r[ndx];
+	mr = &mi->r[mi->max_tp_rate[0]];
+
+	/* Decide if direct ( 1st mrr stage) or indirect (2nd mrr stage)
+	 * rate sampling method should be used.
+	 * Respect such rates that are not sampled for 20 interations.
+	 */
+	if (mrr_capable &&
+	    msr->perfect_tx_time > mr->perfect_tx_time &&
+	    msr->sample_skipped < 20) {
+		/* Only use IEEE80211_TX_CTL_RATE_CTRL_PROBE to mark
+		 * packets that have the sampling rate deferred to the
+		 * second MRR stage. Increase the sample counter only
+		 * if the deferred sample rate was actually used.
+		 * Use the sample_deferred counter to make sure that
+		 * the sampling is not done in large bursts */
+		info->flags |= IEEE80211_TX_CTL_RATE_CTRL_PROBE;
+		rate++;
+		mi->sample_deferred++;
+	} else {
+		if (!msr->sample_limit != 0)
+			return;
+
+		mi->sample_count++;
+		if (msr->sample_limit > 0)
+			msr->sample_limit--;
 	}
-	mi->prev_sample = rate_sampling;
 
 	/* If we're not using MRR and the sampling rate already
 	 * has a probability of >95%, we shouldn't be attempting
 	 * to use it, as this only wastes precious airtime */
-	if (!mrr_capable && rate_sampling &&
+	if (!mrr_capable &&
 	   (mi->r[ndx].probability > MINSTREL_FRAC(95, 100)))
-		ndx = mi->max_tp_rate[0];
-
-	/* mrr setup for 1st stage */
-	ar[0].idx = mi->r[ndx].rix;
-	ar[0].count = minstrel_get_retry_count(&mi->r[ndx], info);
-
-	/* non mrr setup for 2nd stage */
-	if (!mrr_capable) {
-		if (!rate_sampling)
-			ar[0].count = mp->max_retry;
-		ar[1].idx = mi->lowest_rix;
-		ar[1].count = mp->max_retry;
 		return;
-	}
 
-	/* mrr setup for 2nd stage */
-	if (rate_sampling) {
-		if (indirect_rate_sampling)
-			mrr_ndx[0] = sample_ndx;
-		else
-			mrr_ndx[0] = mi->max_tp_rate[0];
-	} else {
-		mrr_ndx[0] = mi->max_tp_rate[1];
-	}
+	mi->prev_sample = true;
 
-	/* mrr setup for 3rd & 4th stage */
-	mrr_ndx[1] = mi->max_prob_rate;
-	mrr_ndx[2] = 0;
-	for (i = 1; i < 4; i++) {
-		ar[i].idx = mi->r[mrr_ndx[i - 1]].rix;
-		ar[i].count = mi->r[mrr_ndx[i - 1]].adjusted_retry_count;
-	}
+	rate->idx = mi->r[ndx].rix;
+	rate->count = minstrel_get_retry_count(&mi->r[ndx], info);
 }
 
 
@@ -412,12 +425,16 @@ minstrel_rate_init(void *priv, struct ieee80211_supported_band *sband,
 	unsigned int i, n = 0;
 	unsigned int t_slot = 9; /* FIXME: get real slot time */
 
+	mi->sta = sta;
 	mi->lowest_rix = rate_lowest_index(sband, sta);
 	ctl_rate = &sband->bitrates[mi->lowest_rix];
 	mi->sp_ack_dur = ieee80211_frame_duration(sband->band, 10,
 				ctl_rate->bitrate,
 				!!(ctl_rate->flags & IEEE80211_RATE_ERP_G), 1);
 
+	memset(mi->max_tp_rate, 0, sizeof(mi->max_tp_rate));
+	mi->max_prob_rate = 0;
+
 	for (i = 0; i < sband->n_bitrates; i++) {
 		struct minstrel_rate *mr = &mi->r[n];
 		unsigned int tx_time = 0, tx_time_cts = 0, tx_time_rtscts = 0;
@@ -473,6 +490,7 @@ minstrel_rate_init(void *priv, struct ieee80211_supported_band *sband,
 	mi->stats_update = jiffies;
 
 	init_sample_table(mi);
+	minstrel_update_rates(mp, mi);
 }
 
 static void *
diff --git a/net/mac80211/rc80211_minstrel.h b/net/mac80211/rc80211_minstrel.h
index b9f8535..f4301f4 100644
--- a/net/mac80211/rc80211_minstrel.h
+++ b/net/mac80211/rc80211_minstrel.h
@@ -63,6 +63,8 @@ struct minstrel_rate {
 };
 
 struct minstrel_sta_info {
+	struct ieee80211_sta *sta;
+
 	unsigned long stats_update;
 	unsigned int sp_ack_dur;
 	unsigned int rate_avg;
-- 
1.8.0.2

