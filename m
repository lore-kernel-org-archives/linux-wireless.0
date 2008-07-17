Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51700
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758972AbYGQMSH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2008 08:18:07 -0400
Date: Thu, 17 Jul 2008 05:18:06 -0700 (PDT)
Message-Id: <20080717.051806.95156549.davem@davemloft.net> (sfid-20080717_141813_590756_F8246A75)
To: netdev@vger.kernel.org
CC: kaber@trash.net, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Subject: [PATCH 27/31]: pkt_sched: Kill qdisc_lock_tree and
 qdisc_unlock_tree.
From: David Miller <davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


No longer used.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 include/net/sch_generic.h |    3 ---
 net/sched/sch_generic.c   |   36 +++---------------------------------
 2 files changed, 3 insertions(+), 36 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 60e1e9f..1eef8d0 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -180,9 +180,6 @@ static inline struct net_device *qdisc_dev(struct Qdisc *qdisc)
 	return qdisc->dev_queue->dev;
 }
 
-extern void qdisc_lock_tree(struct net_device *dev);
-extern void qdisc_unlock_tree(struct net_device *dev);
-
 static inline void sch_tree_lock(struct Qdisc *q)
 {
 	spin_lock_bh(qdisc_root_lock(q));
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 8cdf0b4..3d53e92 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -29,44 +29,14 @@
 /* Main transmission queue. */
 
 /* Modifications to data participating in scheduling must be protected with
- * queue->lock spinlock.
+ * qdisc_root_lock(qdisc) spinlock.
  *
  * The idea is the following:
- * - enqueue, dequeue are serialized via top level device
- *   spinlock queue->lock.
- * - ingress filtering is serialized via top level device
- *   spinlock dev->rx_queue.lock.
+ * - enqueue, dequeue are serialized via qdisc root lock
+ * - ingress filtering is also serialized via qdisc root lock
  * - updates to tree and tree walking are only done under the rtnl mutex.
  */
 
-void qdisc_lock_tree(struct net_device *dev)
-	__acquires(dev->rx_queue.lock)
-{
-	unsigned int i;
-
-	local_bh_disable();
-	for (i = 0; i < dev->num_tx_queues; i++) {
-		struct netdev_queue *txq = netdev_get_tx_queue(dev, i);
-		spin_lock(&txq->lock);
-	}
-	spin_lock(&dev->rx_queue.lock);
-}
-EXPORT_SYMBOL(qdisc_lock_tree);
-
-void qdisc_unlock_tree(struct net_device *dev)
-	__releases(dev->rx_queue.lock)
-{
-	unsigned int i;
-
-	spin_unlock(&dev->rx_queue.lock);
-	for (i = 0; i < dev->num_tx_queues; i++) {
-		struct netdev_queue *txq = netdev_get_tx_queue(dev, i);
-		spin_unlock(&txq->lock);
-	}
-	local_bh_enable();
-}
-EXPORT_SYMBOL(qdisc_unlock_tree);
-
 static inline int qdisc_qlen(struct Qdisc *q)
 {
 	return q->q.qlen;
-- 
1.5.6.2.255.gbed62

