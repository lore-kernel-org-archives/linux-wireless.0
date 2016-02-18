Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:60185 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946295AbcBRUNd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2016 15:13:33 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, egrumbach@gmail.com
Subject: [PATCH 2/2] mac80211: minstrel_ht: set A-MSDU tx limits based on selected max_prob_rate
Date: Thu, 18 Feb 2016 19:39:22 +0100
Message-Id: <1455820762-22876-2-git-send-email-nbd@openwrt.org> (sfid-20160218_211341_142391_BBA2DCDD)
In-Reply-To: <1455820762-22876-1-git-send-email-nbd@openwrt.org>
References: <1455820762-22876-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prevents excessive A-MSDU aggregation at low data rates or bad
conditions.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/rc80211_minstrel_ht.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 3928dbd..ad8859c 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -882,6 +882,39 @@ minstrel_ht_set_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 	ratetbl->rate[offset].flags = flags;
 }
 
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
+		return 1500;
+
+	/*
+	 * If the rate is slower than single-stream MCS7, limit A-MSDU to twice
+	 * the usual data packet size
+	 */
+	if (g->duration[rate] > MCS_DURATION(1, 0, 260))
+		return 3000;
+
+	/* unlimited */
+	return 0;
+}
+
 static void
 minstrel_ht_update_rates(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 {
@@ -906,6 +939,7 @@ minstrel_ht_update_rates(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 		minstrel_ht_set_rate(mp, mi, rates, i++, mi->max_prob_rate);
 	}
 
+	mi->sta->max_rc_amsdu_len = minstrel_ht_get_max_amsdu_len(mi);
 	rates->rate[i].idx = -1;
 	rate_control_set_rates(mp->hw, mi->sta, rates);
 }
-- 
2.2.2

