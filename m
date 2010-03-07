Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:30410 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521Ab0CGR7e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Mar 2010 12:59:34 -0500
Received: by fg-out-1718.google.com with SMTP id l26so892032fgb.1
        for <linux-wireless@vger.kernel.org>; Sun, 07 Mar 2010 09:59:33 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Felix Fietkau <nbd@openwrt.org>
Subject: Re: [RFC v2] minstrel_ht: new rate control module for 802.11n
Date: Sun, 7 Mar 2010 18:59:25 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	Derek Smithies <derek@indranet.co.nz>,
	Benoit PAPILLAULT <benoit.papillault@free.fr>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	=?iso-8859-1?q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>,
	Bob Copeland <me@bobcopeland.com>
References: <4B93D6D3.80702@openwrt.org>
In-Reply-To: <4B93D6D3.80702@openwrt.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201003071859.25848.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 07 March 2010 17:39:47 Felix Fietkau wrote:
> here is an updated version of my minstrel_ht code. Since the last
> version, I've added the following improvements:
> 
> - Use accurate A-MPDU statistics from tx feedback
> - Rewrite the sampling algorithm to optimize for good A-MPDU lengths
>   and faster throughput recovery
> - Implement .rate_update to handle changes in HT capabilities or 
>   channel bandwidth
> - Remove the private tx flags hack
> 
> With the new version, performance has improved visibly for HT40 in all
> of my tests. I think it's getting closer to being ready for inclusion.
> ---
Just released carl9170 1.0.3.1 which now uses minstrel_ht.

I found a few things, not sure if they are bugs in the driver
or minstrel_ht code. (Patch attached, but added the comments
as a response to the code) 

> --- /dev/null
> +++ b/net/mac80211/rc80211_minstrel_ht.c
> @@ -0,0 +1,800 @@
> [...]
> +
> +static void
> +minstrel_ht_tx_status(void *priv, struct ieee80211_supported_band *sband,
> +                      struct ieee80211_sta *sta, void *priv_sta,
> +                      struct sk_buff *skb)
> +{
> [...]
> +
> +	for (i = 0; !last; i++) {
> +		last = (i == IEEE80211_TX_MAX_RATES - 1) ||
> +		       !minstrel_ht_txstat_valid(&ar[i + 1]);
> +
> +		if (!minstrel_ht_txstat_valid(&ar[i]))
> +			break;
> +
> +		group = minstrel_ht_get_group_idx(&ar[i]);
> +		rate = &mi->groups[group].rates[ar[i].idx % 8];
> +
> +		if (last && (info->flags & IEEE80211_TX_STAT_ACK))
> +			rate->success += info->status.ampdu_ack_len;
> +
> +		rate->attempts += ar[i].count * info->status.ampdu_len;
> +	}
> +
> +	/*
> +	 * check for sudden death of spatial multiplexing,
> +	 * downgrade to a lower number of streams if necessary.
> +	 */
> +	rate = minstrel_get_ratestats(mi, mi->max_tp_rate);
> +	if (MINSTREL_FRAC(rate->success, rate->attempts) <
> +	    MINSTREL_FRAC(20, 100) && rate->attempts > 30)
BUGGED right here. Due to rate->attempts being 0.
so, what about this instead and move the attemps > 30:

	if (rate->attempts > 30 &&
	    MINSTREL_FRAC(rate->success, rate->attempts) <
	    MINSTREL_FRAC(20, 100))

> +		minstrel_downgrade_rate(mi, &mi->max_tp_rate, true);
> +
> +	rate2 = minstrel_get_ratestats(mi, mi->max_tp_rate2);
> +	if (MINSTREL_FRAC(rate->success, rate->attempts) <
> +	    MINSTREL_FRAC(20, 100) && rate->attempts > 30)
(same as above, put "rate->attempts > 30" in front of MINSTREL_FRAC

> [...]
> +static void
> +minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
> +                     struct ieee80211_tx_rate_control *txrc)
> +{
> +	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(txrc->skb);
> +	struct ieee80211_tx_rate *ar = info->status.rates;
> +	struct minstrel_ht_sta_priv *msp = priv_sta;
> +	struct minstrel_ht_sta *mi = &msp->ht;
> +	struct minstrel_priv *mp = priv;
> +	int sample_idx;
> +
> +	if (rate_control_send_low(sta, priv_sta, txrc))
> +		return;
> +
> +	if (!msp->is_ht)
> +		return mac80211_minstrel.get_rate(priv, sta, &msp->legacy, txrc);
> +
> +	minstrel_aggr_check(mp, sta, txrc->skb);

on startup, carl9170 complains about non-aggregated
(CTL_AMPDU not set) MCS frames. I had to add an
alternative path for these _early_ frames. They are
now send with the "lowest" legacy rate and aren't
rejected by the driver/HW.

> +
> +	sample_idx = minstrel_get_sample_rate(mp, mi);
> +	if (sample_idx >= 0) {
> +		minstrel_ht_set_rate(mp, mi, &ar[0], sample_idx,
> +			txrc, true, false);
> +		minstrel_ht_set_rate(mp, mi, &ar[1], mi->max_tp_rate,
> +			txrc, false, true);
> +		info->flags |= IEEE80211_TX_CTL_RATE_CTRL_PROBE;
> +	} else {
> +		minstrel_ht_set_rate(mp, mi, &ar[0], mi->max_tp_rate,
> +			txrc, false, false);
> +		minstrel_ht_set_rate(mp, mi, &ar[1], mi->max_tp_rate2,
> +			txrc, false, true);
> +	}
> +	minstrel_ht_set_rate(mp, mi, &ar[2], mi->max_prob_rate, txrc, false, true);
> +
> +	ar[3].count = 0;
> +	ar[3].idx = -1;
> +
> +	mi->total_packets++;
> +
> +	/* wraparound */
> +	if (mi->total_packets == ~0) {
> +		mi->total_packets = 0;
> +		mi->sample_packets = 0;
> +	}
> +}
> +

> --- /dev/null
> +++ b/net/mac80211/rc80211_minstrel_ht_debugfs.c
> @@ -0,0 +1,120 @@
> [...]
> +static int
> +minstrel_ht_stats_open(struct inode *inode, struct file *file)
> +{
> [...]
> +
> +		for (j = 0; j < MCS_GROUP_RATES; j++) {
> +			struct minstrel_rate_stats *mr = &mi->groups[i].rates[j];
> +			int idx = i * MCS_GROUP_RATES + j;
> +
> +			if (!mi->groups[i].supported & BIT(j))
> +				continue;
> +
gcc complains about !a & b.

> +			p += sprintf(p, "HT%c0/%cGI ", htmode, gimode);
> +
[...]
---
From: Christian Lamparter <chunkeey@googlemail.com>
Subject: mac80211: carl9170 specific minstrel_ht fixes

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 8b60bd8..ef98ccf 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -407,13 +407,15 @@ minstrel_ht_tx_status(void *priv, struct ieee80211_supported_band *sband,
 	 * downgrade to a lower number of streams if necessary.
 	 */
 	rate = minstrel_get_ratestats(mi, mi->max_tp_rate);
-	if (MINSTREL_FRAC(rate->success, rate->attempts) <
-	    MINSTREL_FRAC(20, 100) && rate->attempts > 30)
+	if (rate->attempts > 30 &&
+	    MINSTREL_FRAC(rate->success, rate->attempts) <
+	    MINSTREL_FRAC(20, 100))
 		minstrel_downgrade_rate(mi, &mi->max_tp_rate, true);
 
 	rate2 = minstrel_get_ratestats(mi, mi->max_tp_rate2);
-	if (MINSTREL_FRAC(rate->success, rate->attempts) <
-	    MINSTREL_FRAC(20, 100) && rate->attempts > 30)
+	if (rate->attempts > 30 &&
+	    MINSTREL_FRAC(rate->success, rate->attempts) <
+	    MINSTREL_FRAC(20, 100))
 		minstrel_downgrade_rate(mi, &mi->max_tp_rate2, false);
 
 	if (time_after(jiffies, mi->stats_update + (mp->update_interval / 2 * HZ) / 1000))
@@ -574,6 +576,12 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 
 	minstrel_aggr_check(mp, sta, txrc->skb);
 
+	if (!(info->flags & IEEE80211_TX_CTL_AMPDU)) {
+		ar[0].count = mp->hw->max_rate_tries;
+		ar[0].idx = rate_lowest_index(txrc->sband, sta);
+		goto rate_out;
+	}
+
 	sample_idx = minstrel_get_sample_rate(mp, mi);
 	if (sample_idx >= 0) {
 		minstrel_ht_set_rate(mp, mi, &ar[0], sample_idx,
@@ -589,6 +597,7 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 	}
 	minstrel_ht_set_rate(mp, mi, &ar[2], mi->max_prob_rate, txrc, false, true);
 
+rate_out:
 	ar[3].count = 0;
 	ar[3].idx = -1;
 
diff --git a/net/mac80211/rc80211_minstrel_ht_debugfs.c b/net/mac80211/rc80211_minstrel_ht_debugfs.c
index 4689aac..4fb3ccb 100644
--- a/net/mac80211/rc80211_minstrel_ht_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_ht_debugfs.c
@@ -57,7 +57,7 @@ minstrel_ht_stats_open(struct inode *inode, struct file *file)
 			struct minstrel_rate_stats *mr = &mi->groups[i].rates[j];
 			int idx = i * MCS_GROUP_RATES + j;
 
-			if (!mi->groups[i].supported & BIT(j))
+			if (!(mi->groups[i].supported & BIT(j)))
 				continue;
 
 			p += sprintf(p, "HT%c0/%cGI ", htmode, gimode);
---

Regards,
	Chr
