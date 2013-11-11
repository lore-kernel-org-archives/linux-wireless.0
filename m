Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:44927 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab3KKMNS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Nov 2013 07:13:18 -0500
Received: by mail-wg0-f47.google.com with SMTP id y10so919266wgg.2
        for <linux-wireless@vger.kernel.org>; Mon, 11 Nov 2013 04:13:17 -0800 (PST)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: [PATCH] mac80211: minstrel_ht: replace some occurences of MCS_GROUP_RATES
Date: Mon, 11 Nov 2013 13:12:55 +0100
Message-Id: <1384171975-21111-1-git-send-email-karl.beldan@gmail.com> (sfid-20131111_131335_084037_756A9294)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

Consecutive MCSes in [8*(NSS-1)->8*NSS[ have the same number NSS of
streams (except for MCS32 which is mishandled ATM).
ATM minstrel_ht uses MCS_GROUP_RATES in place of this 8 modulus.
This change replaces such occurences and by doing so allows for different
values of MCS_GROUP_RATES (e.g to cope with VHT MCS8,9).

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
---
 net/mac80211/rc80211_minstrel_ht.c         | 9 ++++-----
 net/mac80211/rc80211_minstrel_ht_debugfs.c | 3 +--
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 1076bca..84ae70b 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -135,7 +135,7 @@ minstrel_ht_update_rates(struct minstrel_priv *mp, struct minstrel_ht_sta *mi);
 static int
 minstrel_ht_get_group_idx(struct ieee80211_tx_rate *rate)
 {
-	return GROUP_IDX((rate->idx / MCS_GROUP_RATES) + 1,
+	return GROUP_IDX((rate->idx / 8) + 1,
 			 !!(rate->flags & IEEE80211_TX_RC_SHORT_GI),
 			 !!(rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH));
 }
@@ -148,7 +148,7 @@ minstrel_ht_get_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 
 	if (rate->flags & IEEE80211_TX_RC_MCS) {
 		group = minstrel_ht_get_group_idx(rate);
-		idx = rate->idx % MCS_GROUP_RATES;
+		idx = rate->idx % 8;
 	} else {
 		group = MINSTREL_CCK_GROUP;
 
@@ -636,8 +636,7 @@ minstrel_ht_set_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 		idx = mp->cck_rates[index % ARRAY_SIZE(mp->cck_rates)];
 		flags = 0;
 	} else {
-		idx = index % MCS_GROUP_RATES +
-		      (group->streams - 1) * MCS_GROUP_RATES;
+		idx = index % MCS_GROUP_RATES + (group->streams - 1) * 8;
 		flags = IEEE80211_TX_RC_MCS | group->flags;
 	}
 
@@ -821,7 +820,7 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 	}
 
 	rate->idx = sample_idx % MCS_GROUP_RATES +
-		    (sample_group->streams - 1) * MCS_GROUP_RATES;
+		    (sample_group->streams - 1) * 8;
 	rate->flags = IEEE80211_TX_RC_MCS | sample_group->flags;
 }
 
diff --git a/net/mac80211/rc80211_minstrel_ht_debugfs.c b/net/mac80211/rc80211_minstrel_ht_debugfs.c
index df44a5a..3e7d793 100644
--- a/net/mac80211/rc80211_minstrel_ht_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_ht_debugfs.c
@@ -54,8 +54,7 @@ minstrel_ht_stats_dump(struct minstrel_ht_sta *mi, int i, char *p)
 			int r = bitrates[j % 4];
 			p += sprintf(p, " %2u.%1uM", r / 10, r % 10);
 		} else {
-			p += sprintf(p, " MCS%-2u", (mg->streams - 1) *
-					 MCS_GROUP_RATES + j);
+			p += sprintf(p, " MCS%-2u", (mg->streams - 1) * 8 + j);
 		}
 
 		tp = mr->cur_tp / 10;
-- 
1.8.2

