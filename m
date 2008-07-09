Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:40572 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbYGITod (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 15:44:33 -0400
Received: by wf-out-1314.google.com with SMTP id 27so3007816wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jul 2008 12:44:33 -0700 (PDT)
Subject: [PATCH 2/4] mac80211: wme.c replace QD_NUM macro with static inline
From: Harvey Harrison <harvey.harrison@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 09 Jul 2008 12:44:32 -0700
Message-Id: <1215632672.476.85.camel@brick> (sfid-20080709_214436_357461_47E917D7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/wme.c |   37 ++++++++++++++++++++-----------------
 1 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 5c666f7..a6cb0df 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -20,8 +20,11 @@
 
 /* maximum number of hardware queues we support. */
 #define QD_MAX_QUEUES (IEEE80211_MAX_AMPDU_QUEUES + IEEE80211_MAX_QUEUES)
-/* current number of hardware queues we support. */
-#define QD_NUM(hw) ((hw)->queues + (hw)->ampdu_queues)
+
+static unsigned int qd_num_hw_queues(const struct ieee80211_hw *hw)
+{
+	return hw->queues + hw->ampdu_queues;
+}
 
 /*
  * Default mapping in classifier to work with default
@@ -157,7 +160,7 @@ static int wme_qdiscop_enqueue(struct sk_buff *skb, struct Qdisc* qd)
 		tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
 		if (sta) {
 			int ampdu_queue = sta->tid_to_tx_q[tid];
-			if ((ampdu_queue < QD_NUM(hw)) &&
+			if ((ampdu_queue < qd_num_hw_queues(hw)) &&
 			    test_bit(ampdu_queue, q->qdisc_pool)) {
 				queue = ampdu_queue;
 				info->flags |= IEEE80211_TX_CTL_AMPDU;
@@ -194,7 +197,7 @@ static int wme_qdiscop_enqueue(struct sk_buff *skb, struct Qdisc* qd)
 		sta = sta_info_get(local, hdr->addr1);
 		if (sta) {
 			int ampdu_queue = sta->tid_to_tx_q[tid];
-			if ((ampdu_queue < QD_NUM(hw)) &&
+			if ((ampdu_queue < qd_num_hw_queues(hw)) &&
 			    test_bit(ampdu_queue, q->qdisc_pool)) {
 				queue = ampdu_queue;
 				info->flags |= IEEE80211_TX_CTL_AMPDU;
@@ -257,7 +260,7 @@ static struct sk_buff *wme_qdiscop_dequeue(struct Qdisc* qd)
 	int queue;
 
 	/* check all the h/w queues in numeric/priority order */
-	for (queue = 0; queue < QD_NUM(hw); queue++) {
+	for (queue = 0; queue < qd_num_hw_queues(hw); queue++) {
 		/* see if there is room in this hardware queue */
 		if (__netif_subqueue_stopped(local->mdev, queue) ||
 		    !test_bit(queue, q->qdisc_pool))
@@ -292,7 +295,7 @@ static void wme_qdiscop_reset(struct Qdisc* qd)
 
 	/* QUESTION: should we have some hardware flush functionality here? */
 
-	for (queue = 0; queue < QD_NUM(hw); queue++) {
+	for (queue = 0; queue < qd_num_hw_queues(hw); queue++) {
 		skb_queue_purge(&q->requeued[queue]);
 		qdisc_reset(q->queues[queue]);
 	}
@@ -309,7 +312,7 @@ static void wme_qdiscop_destroy(struct Qdisc* qd)
 
 	tcf_destroy_chain(&q->filter_list);
 
-	for (queue = 0; queue < QD_NUM(hw); queue++) {
+	for (queue = 0; queue < qd_num_hw_queues(hw); queue++) {
 		skb_queue_purge(&q->requeued[queue]);
 		qdisc_destroy(q->queues[queue]);
 		q->queues[queue] = &noop_qdisc;
@@ -357,7 +360,7 @@ static int wme_qdiscop_init(struct Qdisc *qd, struct nlattr *opt)
 		err = wme_qdiscop_tune(qd, opt);
 
 	/* create child queues */
-	for (i = 0; i < QD_NUM(hw); i++) {
+	for (i = 0; i < qd_num_hw_queues(hw); i++) {
 		skb_queue_head_init(&q->requeued[i]);
 		q->queues[i] = qdisc_create_dflt(qd->dev, &pfifo_qdisc_ops,
 						 qd->handle);
@@ -389,7 +392,7 @@ static int wme_classop_graft(struct Qdisc *qd, unsigned long arg,
 	struct ieee80211_hw *hw = &local->hw;
 	unsigned long queue = arg - 1;
 
-	if (queue >= QD_NUM(hw))
+	if (queue >= qd_num_hw_queues(hw))
 		return -EINVAL;
 
 	if (!new)
@@ -413,7 +416,7 @@ wme_classop_leaf(struct Qdisc *qd, unsigned long arg)
 	struct ieee80211_hw *hw = &local->hw;
 	unsigned long queue = arg - 1;
 
-	if (queue >= QD_NUM(hw))
+	if (queue >= qd_num_hw_queues(hw))
 		return NULL;
 
 	return q->queues[queue];
@@ -426,7 +429,7 @@ static unsigned long wme_classop_get(struct Qdisc *qd, u32 classid)
 	struct ieee80211_hw *hw = &local->hw;
 	unsigned long queue = TC_H_MIN(classid);
 
-	if (queue - 1 >= QD_NUM(hw))
+	if (queue - 1 >= qd_num_hw_queues(hw))
 		return 0;
 
 	return queue;
@@ -452,7 +455,7 @@ static int wme_classop_change(struct Qdisc *qd, u32 handle, u32 parent,
 	struct ieee80211_local *local = wdev_priv(qd->dev->ieee80211_ptr);
 	struct ieee80211_hw *hw = &local->hw;
 
-	if (cl - 1 > QD_NUM(hw))
+	if (cl - 1 > qd_num_hw_queues(hw))
 		return -ENOENT;
 
 	/* TODO: put code to program hardware queue parameters here,
@@ -469,7 +472,7 @@ static int wme_classop_delete(struct Qdisc *qd, unsigned long cl)
 	struct ieee80211_local *local = wdev_priv(qd->dev->ieee80211_ptr);
 	struct ieee80211_hw *hw = &local->hw;
 
-	if (cl - 1 > QD_NUM(hw))
+	if (cl - 1 > qd_num_hw_queues(hw))
 		return -ENOENT;
 	return 0;
 }
@@ -482,7 +485,7 @@ static int wme_classop_dump_class(struct Qdisc *qd, unsigned long cl,
 	struct ieee80211_local *local = wdev_priv(qd->dev->ieee80211_ptr);
 	struct ieee80211_hw *hw = &local->hw;
 
-	if (cl - 1 > QD_NUM(hw))
+	if (cl - 1 > qd_num_hw_queues(hw))
 		return -ENOENT;
 	tcm->tcm_handle = TC_H_MIN(cl);
 	tcm->tcm_parent = qd->handle;
@@ -500,7 +503,7 @@ static void wme_classop_walk(struct Qdisc *qd, struct qdisc_walker *arg)
 	if (arg->stop)
 		return;
 
-	for (queue = 0; queue < QD_NUM(hw); queue++) {
+	for (queue = 0; queue < qd_num_hw_queues(hw); queue++) {
 		if (arg->count < arg->skip) {
 			arg->count++;
 			continue;
@@ -623,7 +626,7 @@ int ieee80211_ht_agg_queue_add(struct ieee80211_local *local,
 		return -EPERM;
 
 	/* try to get a Qdisc from the pool */
-	for (i = local->hw.queues; i < QD_NUM(&local->hw); i++)
+	for (i = local->hw.queues; i < qd_num_hw_queues(&local->hw); i++)
 		if (!test_and_set_bit(i, q->qdisc_pool)) {
 			ieee80211_stop_queue(local_to_hw(local), i);
 			sta->tid_to_tx_q[tid] = i;
@@ -659,7 +662,7 @@ void ieee80211_ht_agg_queue_remove(struct ieee80211_local *local,
 
 	/* return the qdisc to the pool */
 	clear_bit(agg_queue, q->qdisc_pool);
-	sta->tid_to_tx_q[tid] = QD_NUM(hw);
+	sta->tid_to_tx_q[tid] = qd_num_hw_queues(hw);
 
 	if (requeue)
 		ieee80211_requeue(local, agg_queue);
-- 
1.5.6.1.322.ge904b


