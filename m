Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:53880 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab3H0O7y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 10:59:54 -0400
Received: by mail-wg0-f49.google.com with SMTP id a12so2102080wgh.28
        for <linux-wireless@vger.kernel.org>; Tue, 27 Aug 2013 07:59:53 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org,
	johannes@sipsolutions.net
Subject: [PATCH 2/2] mac80211: do not override fixed_rate_idx in minstrel_ht_update_stats
Date: Tue, 27 Aug 2013 16:59:47 +0200
Message-Id: <1377615587-6015-3-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20130827_165958_271584_010D32A2)
In-Reply-To: <1377615587-6015-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1377615587-6015-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do not override max_tp_rate, max_tp_rate2 and max_prob_rate configured
according to fixed_rate in minstrel_ht_update_stats throughput computation

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 net/mac80211/rc80211_minstrel_ht.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 339a6b8..597e09a 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -365,6 +365,14 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 		}
 	}
 
+#ifdef CONFIG_MAC80211_DEBUGFS
+	/* use fixed index if set */
+	if (mp->fixed_rate_idx != -1) {
+		mi->max_tp_rate = mp->fixed_rate_idx;
+		mi->max_tp_rate2 = mp->fixed_rate_idx;
+		mi->max_prob_rate = mp->fixed_rate_idx;
+	}
+#endif
 
 	mi->stats_update = jiffies;
 }
@@ -775,6 +783,11 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 	info->flags |= mi->tx_flags;
 	minstrel_ht_check_cck_shortpreamble(mp, mi, txrc->short_preamble);
 
+#ifdef CONFIG_MAC80211_DEBUGFS
+	if (mp->fixed_rate_idx != -1)
+		return;
+#endif
+
 	/* Don't use EAPOL frames for sampling on non-mrr hw */
 	if (mp->hw->max_rates == 1 &&
 	    (info->control.flags & IEEE80211_TX_CTRL_PORT_CTRL_PROTO))
@@ -782,16 +795,6 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 	else
 		sample_idx = minstrel_get_sample_rate(mp, mi);
 
-#ifdef CONFIG_MAC80211_DEBUGFS
-	/* use fixed index if set */
-	if (mp->fixed_rate_idx != -1) {
-		mi->max_tp_rate = mp->fixed_rate_idx;
-		mi->max_tp_rate2 = mp->fixed_rate_idx;
-		mi->max_prob_rate = mp->fixed_rate_idx;
-		sample_idx = -1;
-	}
-#endif
-
 	mi->total_packets++;
 
 	/* wraparound */
-- 
1.8.1.2

