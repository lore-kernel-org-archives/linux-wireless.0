Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:37782 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751500AbdJELiM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Oct 2017 07:38:12 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 1/2] fq: support filtering a given tin
Date: Thu,  5 Oct 2017 13:38:07 +0200
Message-Id: <20171005113808.3889-1-johannes@sipsolutions.net> (sfid-20171005_133816_831618_F6473326)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add to the FQ API a way to filter a given tin, in order to
remove frames that fulfil certain criteria according to a
filter function.

This will be used by mac80211 to remove frames belonging to
an AP VLAN interface that's being removed.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/fq.h      |  7 ++++
 include/net/fq_impl.h | 92 ++++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 83 insertions(+), 16 deletions(-)

diff --git a/include/net/fq.h b/include/net/fq.h
index 6d8521a30c5c..ac944a686840 100644
--- a/include/net/fq.h
+++ b/include/net/fq.h
@@ -90,6 +90,13 @@ typedef void fq_skb_free_t(struct fq *,
 			   struct fq_flow *,
 			   struct sk_buff *);
 
+/* Return %true to filter (drop) the frame. */
+typedef bool fq_skb_filter_t(struct fq *,
+			     struct fq_tin *,
+			     struct fq_flow *,
+			     struct sk_buff *,
+			     void *);
+
 typedef struct fq_flow *fq_flow_get_default_t(struct fq *,
 					      struct fq_tin *,
 					      int idx,
diff --git a/include/net/fq_impl.h b/include/net/fq_impl.h
index 4e6131cd3f43..b27f13d22a90 100644
--- a/include/net/fq_impl.h
+++ b/include/net/fq_impl.h
@@ -12,24 +12,9 @@
 
 /* functions that are embedded into includer */
 
-static struct sk_buff *fq_flow_dequeue(struct fq *fq,
-				       struct fq_flow *flow)
+static void fq_rejigger_backlog(struct fq *fq, struct fq_flow *flow)
 {
-	struct fq_tin *tin = flow->tin;
 	struct fq_flow *i;
-	struct sk_buff *skb;
-
-	lockdep_assert_held(&fq->lock);
-
-	skb = __skb_dequeue(&flow->queue);
-	if (!skb)
-		return NULL;
-
-	tin->backlog_bytes -= skb->len;
-	tin->backlog_packets--;
-	flow->backlog -= skb->len;
-	fq->backlog--;
-	fq->memory_usage -= skb->truesize;
 
 	if (flow->backlog == 0) {
 		list_del_init(&flow->backlogchain);
@@ -43,6 +28,34 @@ static struct sk_buff *fq_flow_dequeue(struct fq *fq,
 		list_move_tail(&flow->backlogchain,
 			       &i->backlogchain);
 	}
+}
+
+static void fq_adjust_removal(struct fq *fq,
+			      struct fq_flow *flow,
+			      struct sk_buff *skb)
+{
+	struct fq_tin *tin = flow->tin;
+
+	tin->backlog_bytes -= skb->len;
+	tin->backlog_packets--;
+	flow->backlog -= skb->len;
+	fq->backlog--;
+	fq->memory_usage -= skb->truesize;
+}
+
+static struct sk_buff *fq_flow_dequeue(struct fq *fq,
+				       struct fq_flow *flow)
+{
+	struct sk_buff *skb;
+
+	lockdep_assert_held(&fq->lock);
+
+	skb = __skb_dequeue(&flow->queue);
+	if (!skb)
+		return NULL;
+
+	fq_adjust_removal(fq, flow, skb);
+	fq_rejigger_backlog(fq, flow);
 
 	return skb;
 }
@@ -188,6 +201,53 @@ static void fq_tin_enqueue(struct fq *fq,
 	}
 }
 
+static void fq_flow_filter(struct fq *fq,
+			   struct fq_flow *flow,
+			   fq_skb_filter_t filter_func,
+			   void *filter_data,
+			   fq_skb_free_t free_func)
+{
+	struct fq_tin *tin = flow->tin;
+	struct sk_buff *skb, *tmp;
+
+	lockdep_assert_held(&fq->lock);
+
+	skb_queue_walk_safe(&flow->queue, skb, tmp) {
+		if (!filter_func(fq, tin, flow, skb, filter_data))
+			continue;
+
+		__skb_unlink(skb, &flow->queue);
+		fq_adjust_removal(fq, flow, skb);
+		free_func(fq, tin, flow, skb);
+	}
+
+	fq_rejigger_backlog(fq, flow);
+}
+
+static void fq_tin_filter(struct fq *fq,
+			  struct fq_tin *tin,
+			  fq_skb_filter_t filter_func,
+			  void *filter_data,
+			  fq_skb_free_t free_func)
+{
+	struct list_head *head;
+	struct fq_flow *flow;
+
+	lockdep_assert_held(&fq->lock);
+
+	for (;;) {
+		head = &tin->new_flows;
+		if (list_empty(head)) {
+			head = &tin->old_flows;
+			if (list_empty(head))
+				break;
+		}
+
+		flow = list_first_entry(head, struct fq_flow, flowchain);
+		fq_flow_filter(fq, flow, filter_func, filter_data, free_func);
+	}
+}
+
 static void fq_flow_reset(struct fq *fq,
 			  struct fq_flow *flow,
 			  fq_skb_free_t free_func)
-- 
2.14.2
