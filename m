Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51673
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757430AbYGQMR0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2008 08:17:26 -0400
Date: Thu, 17 Jul 2008 05:17:26 -0700 (PDT)
Message-Id: <20080717.051726.226040470.davem@davemloft.net> (sfid-20080717_141733_891257_35243809)
To: netdev@vger.kernel.org
CC: kaber@trash.net, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Subject: [PATCH 20/31]: pkt_sched: Perform bulk of qdisc destruction in RCU.
From: David Miller <davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This allows less strict control of access to the qdisc attached to a
netdev_queue.  It is even allowed to enqueue into a qdisc which is
in the process of being destroyed.  The RCU handler will toss out
those packets.

We will need this to handle sharing of a qdisc amongst multiple
TX queues.  In such a setup the lock has to be shared, so will
be inside of the qdisc itself.  At which point the netdev_queue
lock cannot be used to hard synchronize access to the ->qdisc
pointer.

One operation we have to keep inside of qdisc_destroy() is the list
deletion.  It is the only piece of state visible after the RCU quiesce
period, so we have to undo it early and under the appropriate locking.

The operations in the RCU handler do not need any looking because the
qdisc tree is no longer visible to anything at that point.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/sched/sch_generic.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 7e078c5..082db8a 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -545,6 +545,17 @@ EXPORT_SYMBOL(qdisc_reset);
 static void __qdisc_destroy(struct rcu_head *head)
 {
 	struct Qdisc *qdisc = container_of(head, struct Qdisc, q_rcu);
+	const struct Qdisc_ops  *ops = qdisc->ops;
+
+	gen_kill_estimator(&qdisc->bstats, &qdisc->rate_est);
+	if (ops->reset)
+		ops->reset(qdisc);
+	if (ops->destroy)
+		ops->destroy(qdisc);
+
+	module_put(ops->owner);
+	dev_put(qdisc_dev(qdisc));
+
 	kfree((char *) qdisc - qdisc->padded);
 }
 
@@ -552,21 +563,12 @@ static void __qdisc_destroy(struct rcu_head *head)
 
 void qdisc_destroy(struct Qdisc *qdisc)
 {
-	const struct Qdisc_ops  *ops = qdisc->ops;
-
 	if (qdisc->flags & TCQ_F_BUILTIN ||
 	    !atomic_dec_and_test(&qdisc->refcnt))
 		return;
 
 	list_del(&qdisc->list);
-	gen_kill_estimator(&qdisc->bstats, &qdisc->rate_est);
-	if (ops->reset)
-		ops->reset(qdisc);
-	if (ops->destroy)
-		ops->destroy(qdisc);
 
-	module_put(ops->owner);
-	dev_put(qdisc_dev(qdisc));
 	call_rcu(&qdisc->q_rcu, __qdisc_destroy);
 }
 EXPORT_SYMBOL(qdisc_destroy);
-- 
1.5.6.2.255.gbed62

