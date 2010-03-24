Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:30729 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888Ab0CXVZV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Mar 2010 17:25:21 -0400
Subject: [PATCH] compat-wireless: update 22-multiqueue.patch for the current
 linux-next
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
From: Pavel Roskin <proski@gnu.org>
Date: Wed, 24 Mar 2010 17:25:20 -0400
Message-ID: <20100324212520.15474.94735.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adjust for spacing change in net/mac80211/util.c.  Add a replacement for
netif_tx_wake_queue() for net/mac80211/tx.c

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 0 files changed, 0 insertions(+), 0 deletions(-)

diff --git a/patches/22-multiqueue.patch b/patches/22-multiqueue.patch
index 421c32f..4485b94 100644
--- a/patches/22-multiqueue.patch
+++ b/patches/22-multiqueue.patch
@@ -65,21 +65,21 @@ queue by using skb_set_queue_mapping(skb, 0) through ieee80211_tx_skb()
  static void __ieee80211_wake_queue(struct ieee80211_hw *hw, int queue,
  				   enum queue_stop_reason reason)
  {
-@@ -286,7 +298,14 @@ static void __ieee80211_wake_queue(struc
- 
- 	rcu_read_lock();
- 	list_for_each_entry_rcu(sdata, &local->interfaces, list)
+@@ -284,7 +296,14 @@ static void __ieee80211_wake_queue(struc
+ 	if (skb_queue_empty(&local->pending[queue])) {
+ 		rcu_read_lock();
+ 		list_for_each_entry_rcu(sdata, &local->interfaces, list)
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27))
- 		netif_tx_wake_queue(netdev_get_tx_queue(sdata->dev, queue));
+ 			netif_tx_wake_queue(netdev_get_tx_queue(sdata->dev, queue));
 +#elif (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,23))
-+		netif_start_subqueue(sdata->dev, queue);
++			netif_start_subqueue(sdata->dev, queue);
 +#else
-+		if (ieee80211_all_queues_started(hw))
-+			netif_wake_queue(sdata->dev);
++			if (ieee80211_all_queues_started(hw))
++				netif_wake_queue(sdata->dev);
 +#endif
- 	rcu_read_unlock();
- }
- 
+ 		rcu_read_unlock();
+ 	} else
+ 		tasklet_schedule(&local->tx_pending_tasklet);
 @@ -321,7 +340,13 @@ static void __ieee80211_stop_queue(struc
  
  	rcu_read_lock();
@@ -107,6 +107,22 @@ queue by using skb_set_queue_mapping(skb, 0) through ieee80211_tx_skb()
  	ieee80211_set_qos_hdr(local, skb);
  	ieee80211_tx(sdata, skb, false);
  	rcu_read_unlock();
+@@ -2039,8 +2039,15 @@ void ieee80211_tx_pending(unsigned long 
+ 
+ 		if (skb_queue_empty(&local->pending[i]))
+ 			list_for_each_entry_rcu(sdata, &local->interfaces, list)
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27))
+ 				netif_tx_wake_queue(
+ 					netdev_get_tx_queue(sdata->dev, i));
++#elif (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,23))
++				netif_start_subqueue(sdata->dev, i);
++#else
++				if (ieee80211_all_queues_started(hw))
++					netif_wake_queue(sdata->dev);
++#endif
+ 	}
+ 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
+ 
 --- a/net/mac80211/iface.c
 +++ b/net/mac80211/iface.c
 @@ -660,11 +660,13 @@ static void ieee80211_teardown_sdata(str
