Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39563 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbXFVIkm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2007 04:40:42 -0400
Message-Id: <20070621221758.178131000@sipsolutions.net>
References: <20070621221603.778432000@sipsolutions.net>
Date: Fri, 22 Jun 2007 00:16:10 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
Subject: [PATCH 07/14] mac80211: rx cleanups (2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some more outdenting to make the code more readable.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/rx.c |   42 ++++++++++++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 14 deletions(-)

--- wireless-dev.orig/net/mac80211/rx.c	2007-06-21 22:04:10.758638003 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-06-21 22:07:01.148638003 +0200
@@ -1554,21 +1554,35 @@ void __ieee80211_rx(struct ieee80211_hw 
 		if (!prepres)
 			continue;
 
-		if (prev) {
-			skb_new = skb_copy(skb, GFP_ATOMIC);
-			if (!skb_new) {
-				if (net_ratelimit())
-					printk(KERN_DEBUG "%s: failed to copy "
-					       "multicast frame for %s",
-					       local->mdev->name, prev->dev->name);
-				continue;
-			}
-			rx.skb = skb_new;
-			rx.dev = prev->dev;
-			rx.sdata = prev;
-			ieee80211_invoke_rx_handlers(local, local->rx_handlers,
-						     &rx, sta);
+		/*
+		 * frame is destined for this interface, but if it's not
+		 * also for the previous one we handle that after the
+		 * loop to avoid copying the SKB once too much
+		 */
+
+		if (!prev) {
+			prev = sdata;
+			continue;
+		}
+
+		/*
+		 * frame was destined for the previous interface
+		 * so invoke RX handlers for it
+		 */
+
+		skb_new = skb_copy(skb, GFP_ATOMIC);
+		if (!skb_new) {
+			if (net_ratelimit())
+				printk(KERN_DEBUG "%s: failed to copy "
+				       "multicast frame for %s",
+				       local->mdev->name, prev->dev->name);
+			continue;
 		}
+		rx.skb = skb_new;
+		rx.dev = prev->dev;
+		rx.sdata = prev;
+		ieee80211_invoke_rx_handlers(local, local->rx_handlers,
+					     &rx, sta);
 		prev = sdata;
 	}
 	if (prev) {

-- 

