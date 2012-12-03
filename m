Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40122 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab2LCM4R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 07:56:17 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] minstrel: update stats after processing status
Date: Mon,  3 Dec 2012 13:56:40 +0100
Message-Id: <1354539400-20470-1-git-send-email-johannes@sipsolutions.net> (sfid-20121203_135621_378787_B39B2CAA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of updating stats before sending a packet,
update them after processing the packet's status.
This makes minstrel in line with minstrel_ht.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rc80211_minstrel.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index 79633ae..8c5acdc0 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -154,6 +154,7 @@ minstrel_tx_status(void *priv, struct ieee80211_supported_band *sband,
                    struct ieee80211_sta *sta, void *priv_sta,
 		   struct sk_buff *skb)
 {
+	struct minstrel_priv *mp = priv;
 	struct minstrel_sta_info *mi = priv_sta;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_tx_rate *ar = info->status.rates;
@@ -181,6 +182,10 @@ minstrel_tx_status(void *priv, struct ieee80211_supported_band *sband,
 
 	if (mi->sample_deferred > 0)
 		mi->sample_deferred--;
+
+	if (time_after(jiffies, mi->stats_update +
+				(mp->update_interval * HZ) / 1000))
+		minstrel_update_stats(mp, mi);
 }
 
 
@@ -235,10 +240,6 @@ minstrel_get_rate(void *priv, struct ieee80211_sta *sta,
 
 	mrr = mp->has_mrr && !txrc->rts && !txrc->bss_conf->use_cts_prot;
 
-	if (time_after(jiffies, mi->stats_update + (mp->update_interval *
-			HZ) / 1000))
-		minstrel_update_stats(mp, mi);
-
 	ndx = mi->max_tp_rate;
 
 	if (mrr)
-- 
1.8.0

