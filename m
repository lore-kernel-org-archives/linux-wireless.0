Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59816
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754717AbYGOKFa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2008 06:05:30 -0400
Date: Tue, 15 Jul 2008 03:05:31 -0700 (PDT)
Message-Id: <20080715.030531.227856924.davem@davemloft.net> (sfid-20080715_120537_181575_FA8F6515)
To: johannes@sipsolutions.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: TXQ real_num_tx_queues comments/questions
From: David Miller <davem@davemloft.net>
In-Reply-To: <1216115349.3535.20.camel@johannes.berg>
References: <1216114621.3535.18.camel@johannes.berg>
	<20080715.023954.234208581.davem@davemloft.net>
	<1216115349.3535.20.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 15 Jul 2008 11:49:09 +0200

> Yes, I think we can fix it by deferring the requeue to a workqueue,
> using synchronize_net() and putting RCU protection against the
> select_queue call.

I'm respinning my net-tx-2.6 tree at the moment and I'll
make patch 8 look like below.

When I get to the mac80211 bits I'll add the appropriate
synchronize_net() call.

netdev: Add netdev->select_queue() method.

Devices or device layers can set this to control the queue selection
performed by dev_pick_tx().

This function runs under RCU protection, which allows overriding
functions to have some way of synchronizing with things like dynamic
->real_num_tx_queues adjustments.

This makes the spinlock prefetch in dev_queue_xmit() a little bit
less effective, but that's the price right now for correctness.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index fdac115..9464e64 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -724,6 +724,9 @@ struct net_device
 	void                    (*poll_controller)(struct net_device *dev);
 #endif
 
+	u16			(*select_queue)(struct net_device *dev,
+						struct sk_buff *skb);
+
 #ifdef CONFIG_NET_NS
 	/* Network namespace this network device is inside */
 	struct net		*nd_net;
diff --git a/net/core/dev.c b/net/core/dev.c
index f027a1a..7ca9564 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1670,6 +1670,9 @@ static struct netdev_queue *dev_pick_tx(struct net_device *dev,
 {
 	u16 queue_index = 0;
 
+	if (dev->select_queue)
+		queue_index = dev->select_queue(dev, skb);
+
 	skb_set_queue_mapping(skb, queue_index);
 	return netdev_get_tx_queue(dev, queue_index);
 }
@@ -1710,14 +1713,14 @@ int dev_queue_xmit(struct sk_buff *skb)
 	}
 
 gso:
-	txq = dev_pick_tx(dev, skb);
-	spin_lock_prefetch(&txq->lock);
-
 	/* Disable soft irqs for various locks below. Also
 	 * stops preemption for RCU.
 	 */
 	rcu_read_lock_bh();
 
+	txq = dev_pick_tx(dev, skb);
+	spin_lock_prefetch(&txq->lock);
+
 	/* Updates of qdisc are serialized by queue->lock.
 	 * The struct Qdisc which is pointed to by qdisc is now a
 	 * rcu structure - it may be accessed without acquiring
