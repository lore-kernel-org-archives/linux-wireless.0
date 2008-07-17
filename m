Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49376
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759237AbYGQMSj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2008 08:18:39 -0400
Date: Thu, 17 Jul 2008 05:18:34 -0700 (PDT)
Message-Id: <20080717.051834.03644637.davem@davemloft.net> (sfid-20080717_141843_231189_613BD3D1)
To: netdev@vger.kernel.org
CC: kaber@trash.net, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Subject: [PATCH 31/31]: pkt_sched: Make default qdisc nonshared-multiqueue
 safe.
From: David Miller <davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Instead of 'pfifo_fast' we have just plain 'fifo_fast'.
No priority queues, just a straight FIFO.

This is necessary in order to legally have a seperate
qdisc per queue in multi-TX-queue setups, and thus get
full parallelization.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/sched/sch_generic.c |   99 ++++++++++------------------------------------
 1 files changed, 22 insertions(+), 77 deletions(-)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 8fc580b..e244c46 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -349,99 +349,44 @@ static struct Qdisc noqueue_qdisc = {
 };
 
 
-static const u8 prio2band[TC_PRIO_MAX+1] =
-	{ 1, 2, 2, 2, 1, 2, 0, 0 , 1, 1, 1, 1, 1, 1, 1, 1 };
-
-/* 3-band FIFO queue: old style, but should be a bit faster than
-   generic prio+fifo combination.
- */
-
-#define PFIFO_FAST_BANDS 3
-
-static inline struct sk_buff_head *prio2list(struct sk_buff *skb,
-					     struct Qdisc *qdisc)
-{
-	struct sk_buff_head *list = qdisc_priv(qdisc);
-	return list + prio2band[skb->priority & TC_PRIO_MAX];
-}
-
-static int pfifo_fast_enqueue(struct sk_buff *skb, struct Qdisc* qdisc)
+static int fifo_fast_enqueue(struct sk_buff *skb, struct Qdisc* qdisc)
 {
-	struct sk_buff_head *list = prio2list(skb, qdisc);
+	struct sk_buff_head *list = &qdisc->q;
 
-	if (skb_queue_len(list) < qdisc_dev(qdisc)->tx_queue_len) {
-		qdisc->q.qlen++;
+	if (skb_queue_len(list) < qdisc_dev(qdisc)->tx_queue_len)
 		return __qdisc_enqueue_tail(skb, qdisc, list);
-	}
 
 	return qdisc_drop(skb, qdisc);
 }
 
-static struct sk_buff *pfifo_fast_dequeue(struct Qdisc* qdisc)
+static struct sk_buff *fifo_fast_dequeue(struct Qdisc* qdisc)
 {
-	int prio;
-	struct sk_buff_head *list = qdisc_priv(qdisc);
+	struct sk_buff_head *list = &qdisc->q;
 
-	for (prio = 0; prio < PFIFO_FAST_BANDS; prio++) {
-		if (!skb_queue_empty(list + prio)) {
-			qdisc->q.qlen--;
-			return __qdisc_dequeue_head(qdisc, list + prio);
-		}
-	}
+	if (!skb_queue_empty(list))
+		return __qdisc_dequeue_head(qdisc, list);
 
 	return NULL;
 }
 
-static int pfifo_fast_requeue(struct sk_buff *skb, struct Qdisc* qdisc)
+static int fifo_fast_requeue(struct sk_buff *skb, struct Qdisc* qdisc)
 {
-	qdisc->q.qlen++;
-	return __qdisc_requeue(skb, qdisc, prio2list(skb, qdisc));
+	return __qdisc_requeue(skb, qdisc, &qdisc->q);
 }
 
-static void pfifo_fast_reset(struct Qdisc* qdisc)
+static void fifo_fast_reset(struct Qdisc* qdisc)
 {
-	int prio;
-	struct sk_buff_head *list = qdisc_priv(qdisc);
-
-	for (prio = 0; prio < PFIFO_FAST_BANDS; prio++)
-		__qdisc_reset_queue(qdisc, list + prio);
-
+	__qdisc_reset_queue(qdisc, &qdisc->q);
 	qdisc->qstats.backlog = 0;
-	qdisc->q.qlen = 0;
 }
 
-static int pfifo_fast_dump(struct Qdisc *qdisc, struct sk_buff *skb)
-{
-	struct tc_prio_qopt opt = { .bands = PFIFO_FAST_BANDS };
-
-	memcpy(&opt.priomap, prio2band, TC_PRIO_MAX+1);
-	NLA_PUT(skb, TCA_OPTIONS, sizeof(opt), &opt);
-	return skb->len;
-
-nla_put_failure:
-	return -1;
-}
-
-static int pfifo_fast_init(struct Qdisc *qdisc, struct nlattr *opt)
-{
-	int prio;
-	struct sk_buff_head *list = qdisc_priv(qdisc);
-
-	for (prio = 0; prio < PFIFO_FAST_BANDS; prio++)
-		skb_queue_head_init(list + prio);
-
-	return 0;
-}
-
-static struct Qdisc_ops pfifo_fast_ops __read_mostly = {
-	.id		=	"pfifo_fast",
-	.priv_size	=	PFIFO_FAST_BANDS * sizeof(struct sk_buff_head),
-	.enqueue	=	pfifo_fast_enqueue,
-	.dequeue	=	pfifo_fast_dequeue,
-	.requeue	=	pfifo_fast_requeue,
-	.init		=	pfifo_fast_init,
-	.reset		=	pfifo_fast_reset,
-	.dump		=	pfifo_fast_dump,
+static struct Qdisc_ops fifo_fast_ops __read_mostly = {
+	.id		=	"fifo_fast",
+	.priv_size	=	0,
+	.enqueue	=	fifo_fast_enqueue,
+	.dequeue	=	fifo_fast_dequeue,
+	.requeue	=	fifo_fast_requeue,
+	.reset		=	fifo_fast_reset,
 	.owner		=	THIS_MODULE,
 };
 
@@ -570,7 +515,7 @@ static void attach_one_default_qdisc(struct net_device *dev,
 
 	if (dev->tx_queue_len) {
 		qdisc = qdisc_create_dflt(dev, dev_queue,
-					  &pfifo_fast_ops, TC_H_ROOT);
+					  &fifo_fast_ops, TC_H_ROOT);
 		if (!qdisc) {
 			printk(KERN_INFO "%s: activation failed\n", dev->name);
 			return;
@@ -601,9 +546,9 @@ void dev_activate(struct net_device *dev)
 	int need_watchdog;
 
 	/* No queueing discipline is attached to device;
-	   create default one i.e. pfifo_fast for devices,
-	   which need queueing and noqueue_qdisc for
-	   virtual interfaces
+	 * create default one i.e. fifo_fast for devices,
+	 * which need queueing and noqueue_qdisc for
+	 * virtual interfaces.
 	 */
 
 	if (dev_all_qdisc_sleeping_noop(dev))
-- 
1.5.6.2.255.gbed62

