Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:59379
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756284AbaKSTIQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 14:08:16 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH v2 1/7] mac80211: minstrel_ht: move aggregation check to .get_rate()
Date: Wed, 19 Nov 2014 20:08:07 +0100
Message-Id: <1416424093-19439-1-git-send-email-nbd@openwrt.org> (sfid-20141119_200825_085239_61F71084)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Preparation for adding a no-skb tx status path

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/rc80211_minstrel_ht.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 62ff7cf..2641dc8 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -782,9 +782,6 @@ minstrel_ht_tx_status(void *priv, struct ieee80211_supported_band *sband,
 	if (time_after(jiffies, mi->stats_update + (mp->update_interval / 2 * HZ) / 1000)) {
 		update = true;
 		minstrel_ht_update_stats(mp, mi);
-		if (!(info->flags & IEEE80211_TX_CTL_AMPDU) &&
-		    mi->max_prob_rate / MCS_GROUP_RATES != MINSTREL_CCK_GROUP)
-			minstrel_aggr_check(sta, skb);
 	}
 
 	if (update)
@@ -1026,6 +1023,10 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 	if (!msp->is_ht)
 		return mac80211_minstrel.get_rate(priv, sta, &msp->legacy, txrc);
 
+	if (!(info->flags & IEEE80211_TX_CTL_AMPDU) &&
+	    mi->max_prob_rate / MCS_GROUP_RATES != MINSTREL_CCK_GROUP)
+		minstrel_aggr_check(sta, txrc->skb);
+
 	info->flags |= mi->tx_flags;
 	minstrel_ht_check_cck_shortpreamble(mp, mi, txrc->short_preamble);
 
-- 
2.1.2

