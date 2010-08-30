Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42497 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab0H3TQl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Aug 2010 15:16:41 -0400
Received: by mail-ey0-f174.google.com with SMTP id 5so3422616eyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Aug 2010 12:16:40 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 09/10] rt2x00: Split watchdog check into a DMA and STATUS timeout
Date: Mon, 30 Aug 2010 21:15:19 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201008302112.25578.IvDoorn@gmail.com> <201008302114.38933.IvDoorn@gmail.com> <201008302114.56989.IvDoorn@gmail.com>
In-Reply-To: <201008302114.56989.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201008302115.20431.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The watchdog for rt2800usb triggers frequently causing all URB's
to be canceled often enough to interrupt the normal TX flow.
More research indicated that not the URB upload to the USB host
were hanging, but instead the TX status reports.

To correctly detect what is going on, we introduce Q_INDEX_DMA_DONE
which is an index counter between Q_INDEX_DONE and Q_INDEX and indicates
if the frame has been transfered to the device.

This also requires the rt2x00queue timeout functions to be updated
to differentiate between a DMA timeout (time between Q_INDEX and
Q_INDEX_DMA_DONE timeout) and a STATUS timeout (time between
Q_INDEX_DMA_DONE and Q_INDEX_DONE timeout)

All Q_INDEX_DMA_DONE code was taken from the RFC from
Helmut Schaa <helmut.schaa@googlemail.com> for the implementation
for watchdog for rt2800pci.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h      |    1 +
 drivers/net/wireless/rt2x00/rt2x00debug.c |    5 +++--
 drivers/net/wireless/rt2x00/rt2x00dev.c   |    6 ++++++
 drivers/net/wireless/rt2x00/rt2x00queue.c |   13 ++++++++-----
 drivers/net/wireless/rt2x00/rt2x00queue.h |   21 +++++++++++++++++----
 drivers/net/wireless/rt2x00/rt2x00usb.c   |   27 ++++++++++++++++++++++++---
 6 files changed, 59 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 762f6b4..0ae942c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -1070,6 +1070,7 @@ static inline void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
  */
 void rt2x00lib_beacondone(struct rt2x00_dev *rt2x00dev);
 void rt2x00lib_pretbtt(struct rt2x00_dev *rt2x00dev);
+void rt2x00lib_dmadone(struct queue_entry *entry);
 void rt2x00lib_txdone(struct queue_entry *entry,
 		      struct txdone_entry_desc *txdesc);
 void rt2x00lib_txdone_noinfo(struct queue_entry *entry, u32 status);
diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
index 7a907bc..a211e77 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -338,14 +338,15 @@ static ssize_t rt2x00debug_read_queue_stats(struct file *file,
 		return -ENOMEM;
 
 	temp = data +
-	    sprintf(data, "qid\tcount\tlimit\tlength\tindex\tdone\n");
+	    sprintf(data, "qid\tcount\tlimit\tlength\tindex\tdma done\tdone\n");
 
 	queue_for_each(intf->rt2x00dev, queue) {
 		spin_lock_irqsave(&queue->lock, irqflags);
 
-		temp += sprintf(temp, "%d\t%d\t%d\t%d\t%d\t%d\n", queue->qid,
+		temp += sprintf(temp, "%d\t%d\t%d\t%d\t%d\t%d\t%d\n", queue->qid,
 				queue->count, queue->limit, queue->length,
 				queue->index[Q_INDEX],
+				queue->index[Q_INDEX_DMA_DONE],
 				queue->index[Q_INDEX_DONE]);
 
 		spin_unlock_irqrestore(&queue->lock, irqflags);
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 580595b..053fdd3 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -251,6 +251,12 @@ void rt2x00lib_pretbtt(struct rt2x00_dev *rt2x00dev)
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_pretbtt);
 
+void rt2x00lib_dmadone(struct queue_entry *entry)
+{
+	rt2x00queue_index_inc(entry->queue, Q_INDEX_DMA_DONE);
+}
+EXPORT_SYMBOL_GPL(rt2x00lib_dmadone);
+
 void rt2x00lib_txdone(struct queue_entry *entry,
 		      struct txdone_entry_desc *txdesc)
 {
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 7b25d66..eede999 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -731,13 +731,13 @@ void rt2x00queue_index_inc(struct data_queue *queue, enum queue_index index)
 	if (queue->index[index] >= queue->limit)
 		queue->index[index] = 0;
 
+	queue->last_action[index] = jiffies;
+
 	if (index == Q_INDEX) {
 		queue->length++;
-		queue->last_index = jiffies;
 	} else if (index == Q_INDEX_DONE) {
 		queue->length--;
 		queue->count++;
-		queue->last_index_done = jiffies;
 	}
 
 	spin_unlock_irqrestore(&queue->lock, irqflags);
@@ -746,14 +746,17 @@ void rt2x00queue_index_inc(struct data_queue *queue, enum queue_index index)
 static void rt2x00queue_reset(struct data_queue *queue)
 {
 	unsigned long irqflags;
+	unsigned int i;
 
 	spin_lock_irqsave(&queue->lock, irqflags);
 
 	queue->count = 0;
 	queue->length = 0;
-	queue->last_index = jiffies;
-	queue->last_index_done = jiffies;
-	memset(queue->index, 0, sizeof(queue->index));
+
+	for (i = 0; i < Q_INDEX_MAX; i++) {
+		queue->index[i] = 0;
+		queue->last_action[i] = jiffies;
+	}
 
 	spin_unlock_irqrestore(&queue->lock, irqflags);
 }
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 0e38a91..d81d85f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -401,6 +401,8 @@ struct queue_entry {
  *
  * @Q_INDEX: Index pointer to the current entry in the queue, if this entry is
  *	owned by the hardware then the queue is considered to be full.
+ * @Q_INDEX_DMA_DONE: Index pointer for the next entry which will have been
+ *	transfered to the hardware.
  * @Q_INDEX_DONE: Index pointer to the next entry which will be completed by
  *	the hardware and for which we need to run the txdone handler. If this
  *	entry is not owned by the hardware the queue is considered to be empty.
@@ -409,6 +411,7 @@ struct queue_entry {
  */
 enum queue_index {
 	Q_INDEX,
+	Q_INDEX_DMA_DONE,
 	Q_INDEX_DONE,
 	Q_INDEX_MAX,
 };
@@ -445,13 +448,12 @@ struct data_queue {
 	enum data_queue_qid qid;
 
 	spinlock_t lock;
-	unsigned long last_index;
-	unsigned long last_index_done;
 	unsigned int count;
 	unsigned short limit;
 	unsigned short threshold;
 	unsigned short length;
 	unsigned short index[Q_INDEX_MAX];
+	unsigned long last_action[Q_INDEX_MAX];
 
 	unsigned short txop;
 	unsigned short aifs;
@@ -616,12 +618,23 @@ static inline int rt2x00queue_threshold(struct data_queue *queue)
 }
 
 /**
- * rt2x00queue_timeout - Check if a timeout occured for this queue
+ * rt2x00queue_timeout - Check if a timeout occured for STATUS reorts
  * @queue: Queue to check.
  */
 static inline int rt2x00queue_timeout(struct data_queue *queue)
 {
-	return time_after(queue->last_index, queue->last_index_done + (HZ / 10));
+	return time_after(queue->last_action[Q_INDEX_DMA_DONE],
+			  queue->last_action[Q_INDEX_DONE] + (HZ / 10));
+}
+
+/**
+ * rt2x00queue_timeout - Check if a timeout occured for DMA transfers
+ * @queue: Queue to check.
+ */
+static inline int rt2x00queue_dma_timeout(struct data_queue *queue)
+{
+	return time_after(queue->last_action[Q_INDEX],
+			  queue->last_action[Q_INDEX_DMA_DONE] + (HZ / 10));
 }
 
 /**
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 6cc7aa4..aec6440 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -213,6 +213,11 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
 		return;
 
 	/*
+	 * Report the frame as DMA done
+	 */
+	rt2x00lib_dmadone(entry);
+
+	/*
 	 * Check if the frame was correctly uploaded
 	 */
 	if (urb->status)
@@ -283,13 +288,14 @@ void rt2x00usb_kill_tx_queue(struct data_queue *queue)
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_kill_tx_queue);
 
-static void rt2x00usb_watchdog_reset_tx(struct data_queue *queue)
+static void rt2x00usb_watchdog_tx_dma(struct data_queue *queue)
 {
 	struct queue_entry *entry;
 	struct queue_entry_priv_usb *entry_priv;
 	unsigned short threshold = queue->threshold;
 
-	WARNING(queue->rt2x00dev, "TX queue %d timed out, invoke reset", queue->qid);
+	WARNING(queue->rt2x00dev, "TX queue %d DMA timed out,"
+		" invoke forced forced reset", queue->qid);
 
 	/*
 	 * Temporarily disable the TX queue, this will force mac80211
@@ -331,13 +337,23 @@ static void rt2x00usb_watchdog_reset_tx(struct data_queue *queue)
 	ieee80211_wake_queue(queue->rt2x00dev->hw, queue->qid);
 }
 
+static void rt2x00usb_watchdog_tx_status(struct data_queue *queue)
+{
+	WARNING(queue->rt2x00dev, "TX queue %d status timed out,"
+		" invoke forced tx handler", queue->qid);
+
+	ieee80211_queue_work(queue->rt2x00dev->hw, &queue->rt2x00dev->txdone_work);
+}
+
 void rt2x00usb_watchdog(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_queue *queue;
 
 	tx_queue_for_each(rt2x00dev, queue) {
+		if (rt2x00queue_dma_timeout(queue))
+			rt2x00usb_watchdog_tx_dma(queue);
 		if (rt2x00queue_timeout(queue))
-			rt2x00usb_watchdog_reset_tx(queue);
+			rt2x00usb_watchdog_tx_status(queue);
 	}
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_watchdog);
@@ -383,6 +399,11 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 		return;
 
 	/*
+	 * Report the frame as DMA done
+	 */
+	rt2x00lib_dmadone(entry);
+
+	/*
 	 * Check if the received data is simply too small
 	 * to be actually valid, or if the urb is signaling
 	 * a problem.
-- 
1.7.2.2

