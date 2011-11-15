Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63786 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103Ab1KOPqh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Nov 2011 10:46:37 -0500
Received: by wyh15 with SMTP id 15so7191665wyh.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Nov 2011 07:46:36 -0800 (PST)
From: Patrick Kelle <patrick.kelle81@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, nbd@openwrt.org,
	Patrick Kelle <patrick.kelle81@gmail.com>
Subject: [PATCH] minstrel_ht: Remove unused function parameters
Date: Tue, 15 Nov 2011 16:44:48 +0100
Message-Id: <1321371888-26897-1-git-send-email-patrick.kelle81@gmail.com> (sfid-20111115_164640_924956_8A5D277C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove unused function parameters in the following functions:
minstrel_calc_rate_ewma()
minstrel_ht_calc_tp()
minstrel_aggr_check()
minstrel_ht_set_rate()

Signed-off-by: Patrick Kelle <patrick.kelle81@gmail.com>
---
 net/mac80211/rc80211_minstrel_ht.c |   26 ++++++++++++--------------
 1 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index cdb2853..dd085b0 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -130,7 +130,7 @@ minstrel_get_ratestats(struct minstrel_ht_sta *mi, int index)
  * Recalculate success probabilities and counters for a rate using EWMA
  */
 static void
-minstrel_calc_rate_ewma(struct minstrel_priv *mp, struct minstrel_rate_stats *mr)
+minstrel_calc_rate_ewma(struct minstrel_rate_stats *mr)
 {
 	if (unlikely(mr->attempts > 0)) {
 		mr->sample_skipped = 0;
@@ -156,8 +156,7 @@ minstrel_calc_rate_ewma(struct minstrel_priv *mp, struct minstrel_rate_stats *mr
  * the expected number of retransmissions and their expected length
  */
 static void
-minstrel_ht_calc_tp(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
-                    int group, int rate)
+minstrel_ht_calc_tp(struct minstrel_ht_sta *mi, int group, int rate)
 {
 	struct minstrel_rate_stats *mr;
 	unsigned int usecs;
@@ -226,8 +225,8 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 			mr = &mg->rates[i];
 			mr->retry_updated = false;
 			index = MCS_GROUP_RATES * group + i;
-			minstrel_calc_rate_ewma(mp, mr);
-			minstrel_ht_calc_tp(mp, mi, group, i);
+			minstrel_calc_rate_ewma(mr);
+			minstrel_ht_calc_tp(mi, group, i);
 
 			if (!mr->cur_tp)
 				continue;
@@ -357,7 +356,7 @@ minstrel_downgrade_rate(struct minstrel_ht_sta *mi, unsigned int *idx,
 }
 
 static void
-minstrel_aggr_check(struct minstrel_priv *mp, struct ieee80211_sta *pubsta, struct sk_buff *skb)
+minstrel_aggr_check(struct ieee80211_sta *pubsta, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
@@ -455,7 +454,7 @@ minstrel_ht_tx_status(void *priv, struct ieee80211_supported_band *sband,
 	if (time_after(jiffies, mi->stats_update + (mp->update_interval / 2 * HZ) / 1000)) {
 		minstrel_ht_update_stats(mp, mi);
 		if (!(info->flags & IEEE80211_TX_CTL_AMPDU))
-			minstrel_aggr_check(mp, sta, skb);
+			minstrel_aggr_check(sta, skb);
 	}
 }
 
@@ -515,7 +514,6 @@ minstrel_calc_retransmit(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 static void
 minstrel_ht_set_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
                      struct ieee80211_tx_rate *rate, int index,
-                     struct ieee80211_tx_rate_control *txrc,
                      bool sample, bool rtscts)
 {
 	const struct mcs_group *group = &minstrel_mcs_groups[index / MCS_GROUP_RATES];
@@ -628,11 +626,11 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 	if (sample_idx >= 0) {
 		sample = true;
 		minstrel_ht_set_rate(mp, mi, &ar[0], sample_idx,
-			txrc, true, false);
+			true, false);
 		info->flags |= IEEE80211_TX_CTL_RATE_CTRL_PROBE;
 	} else {
 		minstrel_ht_set_rate(mp, mi, &ar[0], mi->max_tp_rate,
-			txrc, false, false);
+			false, false);
 	}
 
 	if (mp->hw->max_rates >= 3) {
@@ -643,13 +641,13 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 		 */
 		if (sample_idx >= 0)
 			minstrel_ht_set_rate(mp, mi, &ar[1], mi->max_tp_rate,
-				txrc, false, false);
+				false, false);
 		else
 			minstrel_ht_set_rate(mp, mi, &ar[1], mi->max_tp_rate2,
-				txrc, false, true);
+				false, true);
 
 		minstrel_ht_set_rate(mp, mi, &ar[2], mi->max_prob_rate,
-				     txrc, false, !sample);
+				     false, !sample);
 
 		ar[3].count = 0;
 		ar[3].idx = -1;
@@ -660,7 +658,7 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 		 * max_tp_rate -> max_prob_rate by default.
 		 */
 		minstrel_ht_set_rate(mp, mi, &ar[1], mi->max_prob_rate,
-				     txrc, false, !sample);
+				     false, !sample);
 
 		ar[2].count = 0;
 		ar[2].idx = -1;
-- 
1.7.7.1

