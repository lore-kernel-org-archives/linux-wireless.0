Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56525 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab0FXTAN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jun 2010 15:00:13 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/2] mac80211: use netif_receive_skb in ieee80211_rx callpath
Date: Thu, 24 Jun 2010 14:47:24 -0400
Message-Id: <1277405244-23697-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This avoids the extra queueing from calling netif_rx.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/rx.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index ab58a5d..d70e1a9 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -293,7 +293,7 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 			skb2 = skb_clone(skb, GFP_ATOMIC);
 			if (skb2) {
 				skb2->dev = prev_dev;
-				netif_rx(skb2);
+				netif_receive_skb(skb2);
 			}
 		}
 
@@ -304,7 +304,7 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 
 	if (prev_dev) {
 		skb->dev = prev_dev;
-		netif_rx(skb);
+		netif_receive_skb(skb);
 	} else
 		dev_kfree_skb(skb);
 
@@ -1578,7 +1578,7 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 			/* deliver to local stack */
 			skb->protocol = eth_type_trans(skb, dev);
 			memset(skb->cb, 0, sizeof(skb->cb));
-			netif_rx(skb);
+			netif_receive_skb(skb);
 		}
 	}
 
@@ -2244,7 +2244,7 @@ static void ieee80211_rx_cooked_monitor(struct ieee80211_rx_data *rx,
 			skb2 = skb_clone(skb, GFP_ATOMIC);
 			if (skb2) {
 				skb2->dev = prev_dev;
-				netif_rx(skb2);
+				netif_receive_skb(skb2);
 			}
 		}
 
@@ -2255,7 +2255,7 @@ static void ieee80211_rx_cooked_monitor(struct ieee80211_rx_data *rx,
 
 	if (prev_dev) {
 		skb->dev = prev_dev;
-		netif_rx(skb);
+		netif_receive_skb(skb);
 		skb = NULL;
 	} else
 		goto out_free_skb;
-- 
1.7.0.1

