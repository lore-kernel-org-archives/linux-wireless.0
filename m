Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50483 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933780AbXC1JMN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2007 05:12:13 -0400
Subject: [PATCH] mac80211: delete pfifo qdisc
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 27 Mar 2007 18:00:50 +0200
Message-Id: <1175011250.9282.6.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since the regular sch_fifo can now be selected even without NET_SCHED we
can use that one instead of shipping our own for the case where the
kernel was built without NET_SCHED.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/Kconfig      |    1 
 net/mac80211/Makefile     |    4 -
 net/mac80211/fifo_qdisc.c |  102 ----------------------------------------------
 net/mac80211/wme.c        |    4 -
 4 files changed, 2 insertions(+), 109 deletions(-)

--- wireless-dev.orig/net/mac80211/Kconfig	2007-03-27 16:33:29.893155480 +0200
+++ wireless-dev/net/mac80211/Kconfig	2007-03-27 16:33:46.203155480 +0200
@@ -7,6 +7,7 @@ config MAC80211
 	select CRC32
 	select WIRELESS_EXT
 	select CFG80211
+	select NET_SCH_FIFO
 	---help---
 	This option enables the hardware independent IEEE 802.11
 	networking stack.
--- wireless-dev.orig/net/mac80211/Makefile	2007-03-27 16:33:29.933155480 +0200
+++ wireless-dev/net/mac80211/Makefile	2007-03-27 16:33:46.203155480 +0200
@@ -19,7 +19,3 @@ mac80211-objs := \
 	wme.o \
 	ieee80211_cfg.o \
 	$(mac80211-objs-y)
-
-ifeq ($(CONFIG_NET_SCHED),)
-  mac80211-objs += fifo_qdisc.o
-endif
--- wireless-dev.orig/net/mac80211/fifo_qdisc.c	2007-03-27 16:33:29.983155480 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,102 +0,0 @@
-/*
- * Copyright 2005, Devicescape Software, Inc.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * If building without CONFIG_NET_SCHED we need a simple
- * fifo qdisc to install by default as the sub-qdisc.
- * This is a simple replacement for sch_fifo.
- */
-
-#include <linux/skbuff.h>
-#include <net/pkt_sched.h>
-#include <net/mac80211.h>
-#include "ieee80211_i.h"
-#include "wme.h"
-
-static int pfifo_enqueue(struct sk_buff *skb, struct Qdisc* qd)
-{
-	struct sk_buff_head *q = qdisc_priv(qd);
-
-	if (skb_queue_len(q) > qd->dev->tx_queue_len) {
-		qd->qstats.drops++;
-		kfree_skb(skb);
-		return NET_XMIT_DROP;
-	}
-
-	skb_queue_tail(q, skb);
-	qd->q.qlen++;
-	qd->bstats.bytes += skb->len;
-	qd->bstats.packets++;
-
-	return NET_XMIT_SUCCESS;
-}
-
-
-static int pfifo_requeue(struct sk_buff *skb, struct Qdisc* qd)
-{
-	struct sk_buff_head *q = qdisc_priv(qd);
-
-	skb_queue_head(q, skb);
-	qd->q.qlen++;
-	qd->bstats.bytes += skb->len;
-	qd->bstats.packets++;
-
-	return NET_XMIT_SUCCESS;
-}
-
-
-static struct sk_buff *pfifo_dequeue(struct Qdisc* qd)
-{
-	struct sk_buff_head *q = qdisc_priv(qd);
-
-	return skb_dequeue(q);
-}
-
-
-static int pfifo_init(struct Qdisc* qd, struct rtattr *opt)
-{
-	struct sk_buff_head *q = qdisc_priv(qd);
-
-	skb_queue_head_init(q);
-	return 0;
-}
-
-
-static void pfifo_reset(struct Qdisc* qd)
-{
-	struct sk_buff_head *q = qdisc_priv(qd);
-
-	skb_queue_purge(q);
-	qd->q.qlen = 0;
-}
-
-
-static int pfifo_dump(struct Qdisc *qd, struct sk_buff *skb)
-{
-	return skb->len;
-}
-
-
-struct Qdisc_ops pfifo_qdisc_ops =
-{
-	.next = NULL,
-	.cl_ops = NULL,
-	.id = "ieee80211_pfifo",
-	.priv_size = sizeof(struct sk_buff_head),
-
-	.enqueue = pfifo_enqueue,
-	.dequeue = pfifo_dequeue,
-	.requeue = pfifo_requeue,
-	.drop = NULL,
-
-	.init = pfifo_init,
-	.reset = pfifo_reset,
-	.destroy = NULL,
-	.change = NULL,
-
-	.dump = pfifo_dump,
-};
-
--- wireless-dev.orig/net/mac80211/wme.c	2007-03-27 16:33:30.053155480 +0200
+++ wireless-dev/net/mac80211/wme.c	2007-03-27 16:33:46.213155480 +0200
@@ -18,8 +18,6 @@
 #include "ieee80211_i.h"
 #include "wme.h"
 
-#define CHILD_QDISC_OPS pfifo_qdisc_ops
-
 static inline int WLAN_FC_IS_QOS_DATA(u16 fc)
 {
 	return (fc & 0x8C) == 0x88;
@@ -417,7 +415,7 @@ static int wme_qdiscop_init(struct Qdisc
 	/* create child queues */
 	for (i = 0; i < queues; i++) {
 		skb_queue_head_init(&q->requeued[i]);
-		q->queues[i] = qdisc_create_dflt(qd->dev, &CHILD_QDISC_OPS,
+		q->queues[i] = qdisc_create_dflt(qd->dev, &pfifo_qdisc_ops,
 						 qd->handle);
 		if (q->queues[i] == 0) {
 			q->queues[i] = &noop_qdisc;


