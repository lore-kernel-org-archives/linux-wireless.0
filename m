Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56523 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab0FXTAN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jun 2010 15:00:13 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/2] mac80211: use netif_receive_skb in ieee80211_tx_status callpath
Date: Thu, 24 Jun 2010 14:47:33 -0400
Message-Id: <1277405253-23735-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This avoids the extra queueing from calling netif_rx.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/status.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 34da679..10caec5 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -377,7 +377,7 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 				skb2 = skb_clone(skb, GFP_ATOMIC);
 				if (skb2) {
 					skb2->dev = prev_dev;
-					netif_rx(skb2);
+					netif_receive_skb(skb2);
 				}
 			}
 
@@ -386,7 +386,7 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 	}
 	if (prev_dev) {
 		skb->dev = prev_dev;
-		netif_rx(skb);
+		netif_receive_skb(skb);
 		skb = NULL;
 	}
 	rcu_read_unlock();
-- 
1.7.0.1

