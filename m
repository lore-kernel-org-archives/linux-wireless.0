Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:32901 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947506AbcBRUSP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2016 15:18:15 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, apenwarr@gmail.com
Subject: [PATCH] mac80211: minstrel_ht: set default tx aggregation timeout to 0
Date: Thu, 18 Feb 2016 19:49:18 +0100
Message-Id: <1455821358-37534-1-git-send-email-nbd@openwrt.org> (sfid-20160218_211821_907564_F7379B63)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The value 5000 was put here with the addition of the timeout field to
ieee80211_start_tx_ba_session. It was originally added in mac80211 to
save resources for drivers like iwlwifi, which only supports a limited
number of concurrent aggregation sessions.

Since iwlwifi does not use minstrel_ht and other drivers don't need
this, 0 is a better default - especially since there have been
recent reports of aggregation setup related issues reproduced with
ath9k. This should improve stability without causing any adverse
effects.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/rc80211_minstrel_ht.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 3928dbd..a7d9227 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -691,7 +691,7 @@ minstrel_aggr_check(struct ieee80211_sta *pubsta, struct sk_buff *skb)
 	if (likely(sta->ampdu_mlme.tid_tx[tid]))
 		return;
 
-	ieee80211_start_tx_ba_session(pubsta, tid, 5000);
+	ieee80211_start_tx_ba_session(pubsta, tid, 0);
 }
 
 static void
-- 
2.2.2

