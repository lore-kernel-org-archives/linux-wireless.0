Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:62347 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753764AbZFBWnU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 18:43:20 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 02 Jun 2009 15:43:23 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] mac80211: removed unused variable in ieee80211_tx()
Date: Tue, 2 Jun 2009 15:43:25 -0700
Message-ID: <1243982605-18607-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/tx.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index a910148..1436f74 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1238,7 +1238,6 @@ static void ieee80211_tx(struct net_device *dev, struct sk_buff *skb,
 			 bool txpending)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct sta_info *sta;
 	struct ieee80211_tx_data tx;
 	ieee80211_tx_result res_prepare;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -1270,7 +1269,6 @@ static void ieee80211_tx(struct net_device *dev, struct sk_buff *skb,
 		return;
 	}
 
-	sta = tx.sta;
 	tx.channel = local->hw.conf.channel;
 	info->band = tx.channel->band;
 
-- 
1.5.6.4

