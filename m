Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35291 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334AbcCCV7H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 16:59:07 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, egrumbach@gmail.com
Subject: [PATCH v3 2/2] mac80211: minstrel_ht: set A-MSDU tx limits based on selected max_prob_rate
Date: Thu,  3 Mar 2016 22:59:01 +0100
Message-Id: <1457042341-72716-2-git-send-email-nbd@openwrt.org> (sfid-20160303_225911_734151_2A6AD285)
In-Reply-To: <1457042341-72716-1-git-send-email-nbd@openwrt.org>
References: <1457042341-72716-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prevents excessive A-MSDU aggregation at low data rates or bad
conditions.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/rc80211_minstrel_ht.c | 54 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 3928dbd..a9d5b28 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -882,6 +882,59 @@ minstrel_ht_set_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 	ratetbl->rate[offset].flags = flags;
 }
 
+static inline int
+minstrel_ht_get_prob_ewma(struct minstrel_ht_sta *mi, int rate)
+{
+	int group = rate / MCS_GROUP_RATES;
+	rate %= MCS_GROUP_RATES;
+	return mi->groups[group].rates[rate].prob_ewma;
+}
+
+static int
+minstrel_ht_get_max_amsdu_len(struct minstrel_ht_sta *mi)
+{
+	int group = mi->max_prob_rate / MCS_GROUP_RATES;
+	const struct mcs_group *g = &minstrel_mcs_groups[group];
+	int rate = mi->max_prob_rate % MCS_GROUP_RATES;
+
+	/* Disable A-MSDU if max_prob_rate is bad */
+	if (mi->groups[group].rates[rate].prob_ewma < MINSTREL_FRAC(50, 100))
+		return 1;
+
+	/* If the rate is slower than single-stream MCS1, make A-MSDU limit small */
+	if (g->duration[rate] > MCS_DURATION(1, 0, 52))
+		return 500;
+
+	/*
+	 * If the rate is slower than single-stream MCS4, limit A-MSDU to usual
+	 * data packet size
+	 */
+	if (g->duration[rate] > MCS_DURATION(1, 0, 104))
+		return 1600;
+
+	/*
+	 * If the rate is slower than single-stream MCS7, or if the max throughput
+	 * rate success probability is less than 75%, limit A-MSDU to twice the usual
+	 * data packet size
+	 */
+	if (g->duration[rate] > MCS_DURATION(1, 0, 260) ||
+	    (minstrel_ht_get_prob_ewma(mi, mi->max_tp_rate[0]) <
+	     MINSTREL_FRAC(75, 100)))
+		return 3200;
+
+	/*
+	 * HT A-MPDU limits maximum MPDU size under BA agreement to 4095 bytes.
+	 * Since aggregation sessions are started/stopped without txq flush, use
+	 * the limit here to avoid the complexity of having to de-aggregate
+	 * packets in the queue.
+	 */
+	if (!mi->sta->vht_cap.vht_supported)
+		return IEEE80211_MAX_MPDU_LEN_HT_BA;
+
+	/* unlimited */
+	return 0;
+}
+
 static void
 minstrel_ht_update_rates(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 {
@@ -906,6 +959,7 @@ minstrel_ht_update_rates(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 		minstrel_ht_set_rate(mp, mi, rates, i++, mi->max_prob_rate);
 	}
 
+	mi->sta->max_rc_amsdu_len = minstrel_ht_get_max_amsdu_len(mi);
 	rates->rate[i].idx = -1;
 	rate_control_set_rates(mp->hw, mi->sta, rates);
 }
-- 
2.2.2

