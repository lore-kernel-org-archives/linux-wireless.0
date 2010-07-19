Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41227 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936464Ab0GSSPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jul 2010 14:15:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] wireless: use netif_rx_ni in ieee80211_send_layer2_update
Date: Mon, 19 Jul 2010 14:04:51 -0400
Message-Id: <1279562691-6232-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These synthetic frames are all triggered from userland requests in
process context.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/cfg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 5b8b446..9854039 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -632,7 +632,7 @@ static void ieee80211_send_layer2_update(struct sta_info *sta)
 	skb->dev = sta->sdata->dev;
 	skb->protocol = eth_type_trans(skb, sta->sdata->dev);
 	memset(skb->cb, 0, sizeof(skb->cb));
-	netif_rx(skb);
+	netif_rx_ni(skb);
 }
 
 static void sta_apply_parameters(struct ieee80211_local *local,
-- 
1.7.1.1

