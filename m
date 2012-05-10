Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64514 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab2EJCdW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 22:33:22 -0400
Received: by mail-yw0-f46.google.com with SMTP id m54so1006656yhm.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 May 2012 19:33:21 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: dmitry.tarnyagin@stericsson.com
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 3/3] cw1200: use list_for_each_entry_safe and friends
Date: Wed,  9 May 2012 22:32:35 -0400
Message-Id: <1336617155-7455-3-git-send-email-me@bobcopeland.com> (sfid-20120510_043326_412290_F0BAE029)
In-Reply-To: <1336617155-7455-1-git-send-email-me@bobcopeland.com>
References: <1336617155-7455-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This saves a few lines of code over the equivalent while() loop.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/staging/cw1200/queue.c |   23 +++++++++--------------
 drivers/staging/cw1200/sta.c   |    6 ++----
 2 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/cw1200/queue.c b/drivers/staging/cw1200/queue.c
index 014e6b2..969456e 100644
--- a/drivers/staging/cw1200/queue.c
+++ b/drivers/staging/cw1200/queue.c
@@ -70,11 +70,9 @@ static inline u32 cw1200_queue_make_packet_id(u8 queue_generation, u8 queue_id,
 static void cw1200_queue_post_gc(struct cw1200_queue_stats *stats,
 				 struct list_head *gc_list)
 {
-	struct cw1200_queue_item *item;
+	struct cw1200_queue_item *item, *tmp;
 
-	while (!list_empty(gc_list)) {
-		item = list_first_entry(
-			gc_list, struct cw1200_queue_item, head);
+	list_for_each_entry_safe(item, tmp, gc_list, head) {
 		list_del(&item->head);
 		stats->skb_dtor(stats->priv, item->skb, &item->txpriv);
 		kfree(item);
@@ -97,12 +95,10 @@ static void __cw1200_queue_gc(struct cw1200_queue *queue,
 			      bool unlock)
 {
 	struct cw1200_queue_stats *stats = queue->stats;
-	struct cw1200_queue_item *item = NULL;
+	struct cw1200_queue_item *item = NULL, *tmp;
 	bool wakeup_stats = false;
 
-	while (!list_empty(&queue->queue)) {
-		item = list_first_entry(
-			&queue->queue, struct cw1200_queue_item, head);
+	list_for_each_entry_safe(item, tmp, &queue->queue, head) {
 		if (jiffies - item->queue_timestamp < queue->ttl)
 			break;
 		--queue->num_queued;
@@ -212,13 +208,12 @@ int cw1200_queue_clear(struct cw1200_queue *queue)
 	int i;
 	LIST_HEAD(gc_list);
 	struct cw1200_queue_stats *stats = queue->stats;
+	struct cw1200_queue_item *item, *tmp;
 
 	spin_lock_bh(&queue->lock);
 	queue->generation++;
 	list_splice_tail_init(&queue->queue, &queue->pending);
-	while (!list_empty(&queue->pending)) {
-		struct cw1200_queue_item *item = list_first_entry(
-			&queue->pending, struct cw1200_queue_item, head);
+	list_for_each_entry_safe(item, tmp, &queue->pending, head) {
 		WARN_ON(!item->skb);
 		cw1200_queue_register_post_gc(&gc_list, item);
 		item->skb = NULL;
@@ -421,11 +416,11 @@ int cw1200_queue_requeue(struct cw1200_queue *queue, u32 packetID)
 
 int cw1200_queue_requeue_all(struct cw1200_queue *queue)
 {
+	struct cw1200_queue_item *item, *tmp;
 	struct cw1200_queue_stats *stats = queue->stats;
 	spin_lock_bh(&queue->lock);
-	while (!list_empty(&queue->pending)) {
-		struct cw1200_queue_item *item = list_entry(
-			queue->pending.prev, struct cw1200_queue_item, head);
+
+	list_for_each_entry_safe_reverse(item, tmp, &queue->pending, head) {
 
 		--queue->num_pending;
 		++queue->link_map_cache[item->txpriv.link_id];
diff --git a/drivers/staging/cw1200/sta.c b/drivers/staging/cw1200/sta.c
index 42bca38..a379f11 100644
--- a/drivers/staging/cw1200/sta.c
+++ b/drivers/staging/cw1200/sta.c
@@ -28,10 +28,8 @@
 
 static inline void __cw1200_free_event_queue(struct list_head *list)
 {
-	while (!list_empty(list)) {
-		struct cw1200_wsm_event *event =
-			list_first_entry(list, struct cw1200_wsm_event,
-			link);
+	struct cw1200_wsm_event *event, *tmp;
+	list_for_each_entry_safe(event, tmp, list, link) {
 		list_del(&event->link);
 		kfree(event);
 	}
-- 
1.7.6

