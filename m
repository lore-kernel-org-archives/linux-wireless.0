Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54208 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756515AbcLNTrM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Dec 2016 14:47:12 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, thomas.huehn@evernet-eg.de
Subject: [PATCH 02/10] mac80211: minstrel_ht: move short preamble check out of get_rate
Date: Wed, 14 Dec 2016 20:46:55 +0100
Message-Id: <20161214194703.33429-2-nbd@nbd.name> (sfid-20161214_204754_204270_6B14F7E1)
In-Reply-To: <20161214194703.33429-1-nbd@nbd.name>
References: <20161214194703.33429-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Test short preamble support in minstrel_ht_update_caps instead of
looking at the per-packet flag. Makes the code more efficient.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/rc80211_minstrel_ht.c | 22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index ed8a34d..ae45dcb 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -14,6 +14,7 @@
 #include <linux/ieee80211.h>
 #include <net/mac80211.h>
 #include "rate.h"
+#include "sta_info.h"
 #include "rc80211_minstrel.h"
 #include "rc80211_minstrel_ht.h"
 
@@ -1049,22 +1050,6 @@ minstrel_get_sample_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 }
 
 static void
-minstrel_ht_check_cck_shortpreamble(struct minstrel_priv *mp,
-				    struct minstrel_ht_sta *mi, bool val)
-{
-	u8 supported = mi->supported[MINSTREL_CCK_GROUP];
-
-	if (!supported || !mi->cck_supported_short)
-		return;
-
-	if (supported & (mi->cck_supported_short << (val * 4)))
-		return;
-
-	supported ^= mi->cck_supported_short | (mi->cck_supported_short << 4);
-	mi->supported[MINSTREL_CCK_GROUP] = supported;
-}
-
-static void
 minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
                      struct ieee80211_tx_rate_control *txrc)
 {
@@ -1087,7 +1072,6 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 		minstrel_aggr_check(sta, txrc->skb);
 
 	info->flags |= mi->tx_flags;
-	minstrel_ht_check_cck_shortpreamble(mp, mi, txrc->short_preamble);
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 	if (mp->fixed_rate_idx != -1)
@@ -1168,6 +1152,7 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 	struct ieee80211_mcs_info *mcs = &sta->ht_cap.mcs;
 	u16 sta_cap = sta->ht_cap.cap;
 	struct ieee80211_sta_vht_cap *vht_cap = &sta->vht_cap;
+	struct sta_info *sinfo = container_of(sta, struct sta_info, sta);
 	int use_vht;
 	int n_supported = 0;
 	int ack_dur;
@@ -1293,6 +1278,9 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 	if (!n_supported)
 		goto use_legacy;
 
+	if (test_sta_flag(sinfo, WLAN_STA_SHORT_PREAMBLE))
+		mi->cck_supported_short |= mi->cck_supported_short << 4;
+
 	/* create an initial rate table with the lowest supported rates */
 	minstrel_ht_update_stats(mp, mi);
 	minstrel_ht_update_rates(mp, mi);
-- 
2.10.1
