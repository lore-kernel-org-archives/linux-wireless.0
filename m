Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:47285 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002Ab0JUArf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Oct 2010 20:47:35 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 3/3] mac80211: minstrel_ht - reduce the overhead of rate sampling
Date: Thu, 21 Oct 2010 02:47:25 +0200
Message-Id: <1287622045-21795-3-git-send-email-nbd@openwrt.org>
In-Reply-To: <1287622045-21795-2-git-send-email-nbd@openwrt.org>
References: <1287622045-21795-1-git-send-email-nbd@openwrt.org>
 <1287622045-21795-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

- reduce the number of retransmission attempts for sample rates
- sample lower rates less often
- do not use RTS/CTS for sampling frames
- increase the time between sampling attempts

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/rc80211_minstrel_ht.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 2a18d66..2d6f025 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -407,8 +407,8 @@ minstrel_ht_tx_status(void *priv, struct ieee80211_supported_band *sband,
 	mi->ampdu_len += info->status.ampdu_len;
 
 	if (!mi->sample_wait && !mi->sample_tries && mi->sample_count > 0) {
-		mi->sample_wait = 4 + 2 * MINSTREL_TRUNC(mi->avg_ampdu_len);
-		mi->sample_tries = 3;
+		mi->sample_wait = 16 + 2 * MINSTREL_TRUNC(mi->avg_ampdu_len);
+		mi->sample_tries = 2;
 		mi->sample_count--;
 	}
 
@@ -506,7 +506,9 @@ minstrel_ht_set_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 	if (!mr->retry_updated)
 		minstrel_calc_retransmit(mp, mi, index);
 
-	if (mr->probability < MINSTREL_FRAC(20, 100))
+	if (sample)
+		rate->count = 1;
+	else if (mr->probability < MINSTREL_FRAC(20, 100))
 		rate->count = 2;
 	else if (rtscts)
 		rate->count = mr->retry_count_rtscts;
@@ -562,7 +564,7 @@ minstrel_get_sample_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 	 */
 	if (minstrel_get_duration(sample_idx) >
 	    minstrel_get_duration(mi->max_tp_rate)) {
-		if (mr->sample_skipped < 10)
+		if (mr->sample_skipped < 20)
 			goto next;
 
 		if (mi->sample_slow++ > 2)
@@ -586,6 +588,7 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 	struct minstrel_ht_sta *mi = &msp->ht;
 	struct minstrel_priv *mp = priv;
 	int sample_idx;
+	bool sample = false;
 
 	if (rate_control_send_low(sta, priv_sta, txrc))
 		return;
@@ -596,10 +599,11 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 	info->flags |= mi->tx_flags;
 	sample_idx = minstrel_get_sample_rate(mp, mi);
 	if (sample_idx >= 0) {
+		sample = true;
 		minstrel_ht_set_rate(mp, mi, &ar[0], sample_idx,
 			txrc, true, false);
 		minstrel_ht_set_rate(mp, mi, &ar[1], mi->max_tp_rate,
-			txrc, false, true);
+			txrc, false, false);
 		info->flags |= IEEE80211_TX_CTL_RATE_CTRL_PROBE;
 	} else {
 		minstrel_ht_set_rate(mp, mi, &ar[0], mi->max_tp_rate,
@@ -607,7 +611,7 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 		minstrel_ht_set_rate(mp, mi, &ar[1], mi->max_tp_rate2,
 			txrc, false, true);
 	}
-	minstrel_ht_set_rate(mp, mi, &ar[2], mi->max_prob_rate, txrc, false, true);
+	minstrel_ht_set_rate(mp, mi, &ar[2], mi->max_prob_rate, txrc, false, !sample);
 
 	ar[3].count = 0;
 	ar[3].idx = -1;
-- 
1.7.2.2

