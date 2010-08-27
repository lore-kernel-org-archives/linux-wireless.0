Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40307 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339Ab0H0Lgw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 07:36:52 -0400
Subject: [PATCH] mac80211: use subqueue helpers
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Aug 2010 13:36:49 +0200
Message-ID: <1282909009.4377.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There are subqueue helpers so that we don't
need to get the TX queue and then wake/stop
it, use those helpers.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c   |    3 +--
 net/mac80211/util.c |    4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

--- wireless-testing.orig/net/mac80211/tx.c	2010-08-27 13:26:57.000000000 +0200
+++ wireless-testing/net/mac80211/tx.c	2010-08-27 13:27:11.000000000 +0200
@@ -2070,8 +2070,7 @@ void ieee80211_tx_pending(unsigned long
 
 		if (skb_queue_empty(&local->pending[i]))
 			list_for_each_entry_rcu(sdata, &local->interfaces, list)
-				netif_tx_wake_queue(
-					netdev_get_tx_queue(sdata->dev, i));
+				netif_wake_subqueue(sdata->dev, i);
 	}
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 
--- wireless-testing.orig/net/mac80211/util.c	2010-08-27 13:27:14.000000000 +0200
+++ wireless-testing/net/mac80211/util.c	2010-08-27 13:27:34.000000000 +0200
@@ -284,7 +284,7 @@ static void __ieee80211_wake_queue(struc
 	if (skb_queue_empty(&local->pending[queue])) {
 		rcu_read_lock();
 		list_for_each_entry_rcu(sdata, &local->interfaces, list)
-			netif_tx_wake_queue(netdev_get_tx_queue(sdata->dev, queue));
+			netif_wake_subqueue(sdata->dev, queue);
 		rcu_read_unlock();
 	} else
 		tasklet_schedule(&local->tx_pending_tasklet);
@@ -323,7 +323,7 @@ static void __ieee80211_stop_queue(struc
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdata, &local->interfaces, list)
-		netif_tx_stop_queue(netdev_get_tx_queue(sdata->dev, queue));
+		netif_stop_subqueue(sdata->dev, queue);
 	rcu_read_unlock();
 }
 


