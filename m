Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:51878 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161552AbXDWS6U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2007 14:58:20 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 11/13] mac80211: fix issues in ieee80211 qdisc
Date: Mon, 23 Apr 2007 14:48:14 -0400
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Message-Id: <20070423184814.7029.35933.stgit@magic.sourmilk.net>
In-Reply-To: <20070423184811.7029.24949.stgit@magic.sourmilk.net>
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net>
Content-Type: text/plain;
  charset=utf-8;
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

This patch fixes two issues found by Patrick McHardy:

1. wme_qdiscop_enqueue doesn't increment q.qlen for packets queued to
q->requeued[], which might cause upper layer code to stop dequeueing if
q.qlen reaches zero.
2. wme_discop_destroy leaks classifier module references and memory when
destroying classifiers, it should use tcf_destroy()

It also removes some dead code.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 net/mac80211/wme.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 243da1f..79b4305 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -220,6 +220,7 @@ static int wme_qdiscop_enqueue(struct sk_buff *skb, struct Qdisc* qd)
 
 	if (pkt_data->requeue) {
 		skb_queue_tail(&q->requeued[pkt_data->queue], skb);
+		qd->q.qlen++;
 		return 0;
 	}
 
@@ -313,8 +314,10 @@ static struct sk_buff *wme_qdiscop_dequeue(struct Qdisc* qd)
 
 		/* there is space - try and get a frame */
 		skb = skb_dequeue(&q->requeued[queue]);
-		if (skb)
+		if (skb) {
+			qd->q.qlen--;
 			return skb;
+		}
 
 		qdisc = q->queues[queue];
 		skb = qdisc->dequeue(qdisc);
@@ -356,7 +359,7 @@ static void wme_qdiscop_destroy(struct Qdisc* qd)
 
 	while ((tp = q->filter_list) != NULL) {
 		q->filter_list = tp->next;
-		tp->ops->destroy(tp);
+		tcf_destroy(tp);
 	}
 
 	for (queue=0; queue < hw->queues; queue++) {
@@ -503,7 +506,6 @@ static unsigned long wme_classop_bind(struct Qdisc *qd, unsigned long parent,
 
 static void wme_classop_put(struct Qdisc *q, unsigned long cl)
 {
-	/* printk(KERN_DEBUG "entering %s\n", __func__); */
 }
 
 
@@ -513,7 +515,6 @@ static int wme_classop_change(struct Qdisc *qd, u32 handle, u32 parent,
 	unsigned long cl = *arg;
 	struct ieee80211_local *local = wdev_priv(qd->dev->ieee80211_ptr);
 	struct ieee80211_hw *hw = &local->hw;
-	/* printk(KERN_DEBUG "entering %s\n", __func__); */
 
 	if (cl - 1 > hw->queues)
 		return -ENOENT;
@@ -531,7 +532,6 @@ static int wme_classop_delete(struct Qdisc *qd, unsigned long cl)
 {
 	struct ieee80211_local *local = wdev_priv(qd->dev->ieee80211_ptr);
 	struct ieee80211_hw *hw = &local->hw;
-	/* printk(KERN_DEBUG "entering %s\n", __func__); */
 
 	if (cl - 1 > hw->queues)
 		return -ENOENT;
@@ -545,7 +545,6 @@ static int wme_classop_dump_class(struct Qdisc *qd, unsigned long cl,
 	struct ieee80211_sched_data *q = qdisc_priv(qd);
 	struct ieee80211_local *local = wdev_priv(qd->dev->ieee80211_ptr);
 	struct ieee80211_hw *hw = &local->hw;
-	/* printk(KERN_DEBUG "entering %s\n", __func__); */
 
 	if (cl - 1 > hw->queues)
 		return -ENOENT;
@@ -561,7 +560,6 @@ static void wme_classop_walk(struct Qdisc *qd, struct qdisc_walker *arg)
 	struct ieee80211_local *local = wdev_priv(qd->dev->ieee80211_ptr);
 	struct ieee80211_hw *hw = &local->hw;
 	int queue;
-	/* printk(KERN_DEBUG "entering %s\n", __func__); */
 
 	if (arg->stop)
 		return;
@@ -586,7 +584,6 @@ static struct tcf_proto ** wme_classop_find_tcf(struct Qdisc *qd,
 						unsigned long cl)
 {
 	struct ieee80211_sched_data *q = qdisc_priv(qd);
-	/* printk("entering %s\n", __func__); */
 
 	if (cl)
 		return NULL;

