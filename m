Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53097 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029Ab1DRNf5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 09:35:57 -0400
Received: by mail-fx0-f46.google.com with SMTP id 17so2833789fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2011 06:35:57 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 09/23] rt2x00: fix queue timeout checks
Date: Mon, 18 Apr 2011 15:29:38 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201104181526.01722.IvDoorn@gmail.com> <201104181528.51457.IvDoorn@gmail.com> <201104181529.13131.IvDoorn@gmail.com>
In-Reply-To: <201104181529.13131.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201104181529.39237.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Stezenbach <js@sig21.net>

Add a timestamp to each queue entry which is updated whenever
the status of the entry changes, and remove the per-queue
timestamps.  The previous check was incorrect and caused both
false positives and false negatives.

With the corrected check it comes apparent that the TX status
usually times out on rt2800usb unless there is sufficient traffic
(i.e. the next TX will complete the previous TX status).

Signed-off-by: Johannes Stezenbach <js@sig21.net>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c   |    8 ++++----
 drivers/net/wireless/rt2x00/rt2x00lib.h   |    6 +++---
 drivers/net/wireless/rt2x00/rt2x00queue.c |   11 +++++------
 drivers/net/wireless/rt2x00/rt2x00queue.h |   23 +++++++++++++----------
 drivers/net/wireless/rt2x00/rt2x00usb.c   |   20 ++++++++++++++++++--
 5 files changed, 43 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index af25b01..2e490e0 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -225,7 +225,7 @@ EXPORT_SYMBOL_GPL(rt2x00lib_pretbtt);
 void rt2x00lib_dmastart(struct queue_entry *entry)
 {
 	set_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags);
-	rt2x00queue_index_inc(entry->queue, Q_INDEX);
+	rt2x00queue_index_inc(entry, Q_INDEX);
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_dmastart);
 
@@ -233,7 +233,7 @@ void rt2x00lib_dmadone(struct queue_entry *entry)
 {
 	set_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags);
 	clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags);
-	rt2x00queue_index_inc(entry->queue, Q_INDEX_DMA_DONE);
+	rt2x00queue_index_inc(entry, Q_INDEX_DMA_DONE);
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_dmadone);
 
@@ -392,7 +392,7 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 
 	rt2x00dev->ops->lib->clear_entry(entry);
 
-	rt2x00queue_index_inc(entry->queue, Q_INDEX_DONE);
+	rt2x00queue_index_inc(entry, Q_INDEX_DONE);
 
 	/*
 	 * If the data queue was below the threshold before the txdone
@@ -559,7 +559,7 @@ void rt2x00lib_rxdone(struct queue_entry *entry)
 
 submit_entry:
 	entry->flags = 0;
-	rt2x00queue_index_inc(entry->queue, Q_INDEX_DONE);
+	rt2x00queue_index_inc(entry, Q_INDEX_DONE);
 	if (test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags) &&
 	    test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
 		rt2x00dev->ops->lib->clear_entry(entry);
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index bbee2cd..57ede6c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -175,14 +175,14 @@ int rt2x00queue_clear_beacon(struct rt2x00_dev *rt2x00dev,
 
 /**
  * rt2x00queue_index_inc - Index incrementation function
- * @queue: Queue (&struct data_queue) to perform the action on.
+ * @entry: Queue entry (&struct queue_entry) to perform the action on.
  * @index: Index type (&enum queue_index) to perform the action on.
  *
- * This function will increase the requested index on the queue,
+ * This function will increase the requested index on the entry's queue,
  * it will grab the appropriate locks and handle queue overflow events by
  * resetting the index to the start of the queue.
  */
-void rt2x00queue_index_inc(struct data_queue *queue, enum queue_index index);
+void rt2x00queue_index_inc(struct queue_entry *entry, enum queue_index index);
 
 /**
  * rt2x00queue_init_queues - Initialize all data queues
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 458bb48..df8817f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -561,7 +561,7 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
 
 	set_bit(ENTRY_DATA_PENDING, &entry->flags);
 
-	rt2x00queue_index_inc(queue, Q_INDEX);
+	rt2x00queue_index_inc(entry, Q_INDEX);
 	rt2x00queue_write_tx_descriptor(entry, &txdesc);
 	rt2x00queue_kick_tx_queue(queue, &txdesc);
 
@@ -727,8 +727,9 @@ struct queue_entry *rt2x00queue_get_entry(struct data_queue *queue,
 }
 EXPORT_SYMBOL_GPL(rt2x00queue_get_entry);
 
-void rt2x00queue_index_inc(struct data_queue *queue, enum queue_index index)
+void rt2x00queue_index_inc(struct queue_entry *entry, enum queue_index index)
 {
+	struct data_queue *queue = entry->queue;
 	unsigned long irqflags;
 
 	if (unlikely(index >= Q_INDEX_MAX)) {
@@ -743,7 +744,7 @@ void rt2x00queue_index_inc(struct data_queue *queue, enum queue_index index)
 	if (queue->index[index] >= queue->limit)
 		queue->index[index] = 0;
 
-	queue->last_action[index] = jiffies;
+	entry->last_action = jiffies;
 
 	if (index == Q_INDEX) {
 		queue->length++;
@@ -969,10 +970,8 @@ static void rt2x00queue_reset(struct data_queue *queue)
 	queue->count = 0;
 	queue->length = 0;
 
-	for (i = 0; i < Q_INDEX_MAX; i++) {
+	for (i = 0; i < Q_INDEX_MAX; i++)
 		queue->index[i] = 0;
-		queue->last_action[i] = jiffies;
-	}
 
 	spin_unlock_irqrestore(&queue->index_lock, irqflags);
 }
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 6b66452..36f4d03 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -364,6 +364,7 @@ enum queue_entry_flags {
  * struct queue_entry: Entry inside the &struct data_queue
  *
  * @flags: Entry flags, see &enum queue_entry_flags.
+ * @last_action: Timestamp of last change.
  * @queue: The data queue (&struct data_queue) to which this entry belongs.
  * @skb: The buffer which is currently being transmitted (for TX queue),
  *	or used to directly recieve data in (for RX queue).
@@ -373,6 +374,7 @@ enum queue_entry_flags {
  */
 struct queue_entry {
 	unsigned long flags;
+	unsigned long last_action;
 
 	struct data_queue *queue;
 
@@ -463,7 +465,6 @@ struct data_queue {
 	unsigned short threshold;
 	unsigned short length;
 	unsigned short index[Q_INDEX_MAX];
-	unsigned long last_action[Q_INDEX_MAX];
 
 	unsigned short txop;
 	unsigned short aifs;
@@ -635,22 +636,24 @@ static inline int rt2x00queue_threshold(struct data_queue *queue)
 
 /**
  * rt2x00queue_status_timeout - Check if a timeout occured for STATUS reports
- * @queue: Queue to check.
+ * @entry: Queue entry to check.
  */
-static inline int rt2x00queue_status_timeout(struct data_queue *queue)
+static inline int rt2x00queue_status_timeout(struct queue_entry *entry)
 {
-	return time_after(queue->last_action[Q_INDEX_DMA_DONE],
-			  queue->last_action[Q_INDEX_DONE] + (HZ / 10));
+	if (!test_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags))
+		return false;
+	return time_after(jiffies, entry->last_action + msecs_to_jiffies(100));
 }
 
 /**
- * rt2x00queue_timeout - Check if a timeout occured for DMA transfers
- * @queue: Queue to check.
+ * rt2x00queuedma__timeout - Check if a timeout occured for DMA transfers
+ * @entry: Queue entry to check.
  */
-static inline int rt2x00queue_dma_timeout(struct data_queue *queue)
+static inline int rt2x00queue_dma_timeout(struct queue_entry *entry)
 {
-	return time_after(queue->last_action[Q_INDEX],
-			  queue->last_action[Q_INDEX_DMA_DONE] + (HZ / 10));
+	if (!test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
+		return false;
+	return time_after(jiffies, entry->last_action + msecs_to_jiffies(100));
 }
 
 /**
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 5fbab6f..14736e2 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -521,15 +521,31 @@ static void rt2x00usb_watchdog_tx_status(struct data_queue *queue)
 	queue_work(queue->rt2x00dev->workqueue, &queue->rt2x00dev->txdone_work);
 }
 
+static int rt2x00usb_status_timeout(struct data_queue *queue)
+{
+	struct queue_entry *entry;
+
+	entry = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
+	return rt2x00queue_status_timeout(entry);
+}
+
+static int rt2x00usb_dma_timeout(struct data_queue *queue)
+{
+	struct queue_entry *entry;
+
+	entry = rt2x00queue_get_entry(queue, Q_INDEX_DMA_DONE);
+	return rt2x00queue_dma_timeout(entry);
+}
+
 void rt2x00usb_watchdog(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_queue *queue;
 
 	tx_queue_for_each(rt2x00dev, queue) {
 		if (!rt2x00queue_empty(queue)) {
-			if (rt2x00queue_dma_timeout(queue))
+			if (rt2x00usb_dma_timeout(queue))
 				rt2x00usb_watchdog_tx_dma(queue);
-			if (rt2x00queue_status_timeout(queue))
+			if (rt2x00usb_status_timeout(queue))
 				rt2x00usb_watchdog_tx_status(queue);
 		}
 	}
-- 
1.7.2.3

