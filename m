Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47846 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbbCPIIo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2015 04:08:44 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: move netdev stats to common function
Date: Mon, 16 Mar 2015 09:08:41 +0100
Message-Id: <1426493321-5281-1-git-send-email-johannes@sipsolutions.net> (sfid-20150316_090848_469409_E62AF7F0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Move the netdev stats accounting into the common function
ieee80211_deliver_skb() that is called in both places.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 1101563357ea..bdabf349c6ee 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2043,6 +2043,9 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 	struct sta_info *dsta;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
 
+	dev->stats.rx_packets++;
+	dev->stats.rx_bytes += rx->skb->len;
+
 	skb = rx->skb;
 	xmit_skb = NULL;
 
@@ -2173,8 +2176,6 @@ ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx)
 			dev_kfree_skb(rx->skb);
 			continue;
 		}
-		dev->stats.rx_packets++;
-		dev->stats.rx_bytes += rx->skb->len;
 
 		ieee80211_deliver_skb(rx);
 	}
@@ -2397,9 +2398,6 @@ ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 
 	rx->skb->dev = dev;
 
-	dev->stats.rx_packets++;
-	dev->stats.rx_bytes += rx->skb->len;
-
 	if (local->ps_sdata && local->hw.conf.dynamic_ps_timeout > 0 &&
 	    !is_multicast_ether_addr(
 		    ((struct ethhdr *)rx->skb->data)->h_dest) &&
-- 
2.1.4

