Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51033 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab0HWSFK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 14:05:10 -0400
Received: by gxk23 with SMTP id 23so2219777gxk.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Aug 2010 11:05:09 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3/8] rt2x00: Move direct access to queue->entries to rt2x00queue.c
Date: Mon, 23 Aug 2010 19:54:21 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201008231953.40629.IvDoorn@gmail.com> <201008231954.03752.IvDoorn@gmail.com>
In-Reply-To: <201008231954.03752.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201008231954.22661.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All access to queue->entries through the Q_INDEX/Q_INDEX_DONE
variables must be done using spinlock protection. It is best
to manage this completely from rt2x00queue.c.

For safely looping through all entries in the queue, the function
rt2x00queue_for_each_entry is added which will walk from from a index
range in a safe manner.

This also fixes rt2x00usb which walked the entries list from
0 to length to kill each entry (killing entries must be done
from Q_INDEX_DONE to Q_INDEX to enforce TX status reporting to
occur in the correct order.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c   |    4 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c |   45 +++++++++++++++++
 drivers/net/wireless/rt2x00/rt2x00queue.h |   16 ++++++
 drivers/net/wireless/rt2x00/rt2x00usb.c   |   75 ++++++++---------------------
 4 files changed, 83 insertions(+), 57 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index af1c691..a5e5870 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -629,7 +629,7 @@ static void rt2800pci_write_tx_desc(struct queue_entry *entry,
 static void rt2800pci_kick_tx_queue(struct data_queue *queue)
 {
 	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
-	unsigned int idx = queue->index[Q_INDEX];
+	struct queue_entry *entry = rt2x00queue_get_entry(queue, Q_INDEX);
 	unsigned int qidx = 0;
 
 	if (queue->qid == QID_MGMT)
@@ -637,7 +637,7 @@ static void rt2800pci_kick_tx_queue(struct data_queue *queue)
 	else
 		qidx = queue->qid;
 
-	rt2800_register_write(rt2x00dev, TX_CTX_IDX(qidx), idx);
+	rt2800_register_write(rt2x00dev, TX_CTX_IDX(qidx), entry->entry_idx);
 }
 
 static void rt2800pci_kill_tx_queue(struct data_queue *queue)
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index a083857..a2bd176 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -625,6 +625,51 @@ int rt2x00queue_update_beacon(struct rt2x00_dev *rt2x00dev,
 	return 0;
 }
 
+void rt2x00queue_for_each_entry(struct data_queue *queue,
+				enum queue_index start,
+				enum queue_index end,
+				void (*fn)(struct queue_entry *entry))
+{
+	unsigned long irqflags;
+	unsigned int index_start;
+	unsigned int index_end;
+	unsigned int i;
+
+	if (unlikely(start >= Q_INDEX_MAX || end >= Q_INDEX_MAX)) {
+		ERROR(queue->rt2x00dev,
+		      "Entry requested from invalid index range (%d - %d)\n",
+		      start, end);
+		return;
+	}
+
+	/*
+	 * Only protect the range we are going to loop over,
+	 * if during our loop a extra entry is set to pending
+	 * it should not be kicked during this run, since it
+	 * is part of another TX operation.
+	 */
+	spin_lock_irqsave(&queue->lock, irqflags);
+	index_start = queue->index[start];
+	index_end = queue->index[end];
+	spin_unlock_irqrestore(&queue->lock, irqflags);
+
+	/*
+	 * Start from the TX done pointer, this guarentees that we will
+	 * send out all frames in the correct order.
+	 */
+	if (index_start < index_end) {
+		for (i = index_start; i < index_end; i++)
+			fn(&queue->entries[i]);
+	} else {
+		for (i = index_start; i < queue->limit; i++)
+			fn(&queue->entries[i]);
+
+		for (i = 0; i < index_end; i++)
+			fn(&queue->entries[i]);
+	}
+}
+EXPORT_SYMBOL_GPL(rt2x00queue_for_each_entry);
+
 struct data_queue *rt2x00queue_get_queue(struct rt2x00_dev *rt2x00dev,
 					 const enum data_queue_qid queue)
 {
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 2d3bf84..46a3be1 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -571,6 +571,22 @@ struct data_queue_desc {
 	queue_loop(__entry, (__dev)->tx, queue_end(__dev))
 
 /**
+ * rt2x00queue_for_each_entry - Loop through all entries in the queue
+ * @queue: Pointer to @data_queue
+ * @start: &enum queue_index Pointer to start index
+ * @end: &enum queue_index Pointer to end index
+ * @fn: The function to call for each &struct queue_entry
+ *
+ * This will walk through all entries in the queue, in chronological
+ * order. This means it will start at the current @start pointer
+ * and will walk through the queue until it reaches the @end pointer.
+ */
+void rt2x00queue_for_each_entry(struct data_queue *queue,
+				enum queue_index start,
+				enum queue_index end,
+				void (*fn)(struct queue_entry *entry));
+
+/**
  * rt2x00queue_empty - Check if the queue is empty.
  * @queue: Queue to check if empty.
  */
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 1d2eb46..6cc7aa4 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -225,7 +225,7 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
 	ieee80211_queue_work(rt2x00dev->hw, &rt2x00dev->txdone_work);
 }
 
-static inline void rt2x00usb_kick_tx_entry(struct queue_entry *entry)
+static void rt2x00usb_kick_tx_entry(struct queue_entry *entry)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct usb_device *usb_dev = to_usb_device_intf(rt2x00dev->dev);
@@ -252,69 +252,34 @@ static inline void rt2x00usb_kick_tx_entry(struct queue_entry *entry)
 
 void rt2x00usb_kick_tx_queue(struct data_queue *queue)
 {
-	unsigned long irqflags;
-	unsigned int index;
-	unsigned int index_done;
-	unsigned int i;
-
-	/*
-	 * Only protect the range we are going to loop over,
-	 * if during our loop a extra entry is set to pending
-	 * it should not be kicked during this run, since it
-	 * is part of another TX operation.
-	 */
-	spin_lock_irqsave(&queue->lock, irqflags);
-	index = queue->index[Q_INDEX];
-	index_done = queue->index[Q_INDEX_DONE];
-	spin_unlock_irqrestore(&queue->lock, irqflags);
-
-	/*
-	 * Start from the TX done pointer, this guarentees that we will
-	 * send out all frames in the correct order.
-	 */
-	if (index_done < index) {
-		for (i = index_done; i < index; i++)
-			rt2x00usb_kick_tx_entry(&queue->entries[i]);
-	} else {
-		for (i = index_done; i < queue->limit; i++)
-			rt2x00usb_kick_tx_entry(&queue->entries[i]);
-
-		for (i = 0; i < index; i++)
-			rt2x00usb_kick_tx_entry(&queue->entries[i]);
-	}
+	rt2x00queue_for_each_entry(queue, Q_INDEX_DONE, Q_INDEX,
+				   rt2x00usb_kick_tx_entry);
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_kick_tx_queue);
 
-void rt2x00usb_kill_tx_queue(struct data_queue *queue)
+static void rt2x00usb_kill_tx_entry(struct queue_entry *entry)
 {
-	struct queue_entry_priv_usb *entry_priv;
-	struct queue_entry_priv_usb_bcn *bcn_priv;
-	unsigned int i;
-	bool kill_guard;
+	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
+	struct queue_entry_priv_usb *entry_priv = entry->priv_data;
+	struct queue_entry_priv_usb_bcn *bcn_priv = entry->priv_data;
 
-	/*
-	 * When killing the beacon queue, we must also kill
-	 * the beacon guard byte.
-	 */
-	kill_guard =
-	    (queue->qid == QID_BEACON) &&
-	    (test_bit(DRIVER_REQUIRE_BEACON_GUARD, &queue->rt2x00dev->flags));
+	if (!test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
+		return;
+
+	usb_kill_urb(entry_priv->urb);
 
 	/*
-	 * Cancel all entries.
+	 * Kill guardian urb (if required by driver).
 	 */
-	for (i = 0; i < queue->limit; i++) {
-		entry_priv = queue->entries[i].priv_data;
-		usb_kill_urb(entry_priv->urb);
+	if ((entry->queue->qid == QID_BEACON) &&
+	    (test_bit(DRIVER_REQUIRE_BEACON_GUARD, &rt2x00dev->flags)))
+		usb_kill_urb(bcn_priv->guardian_urb);
+}
 
-		/*
-		 * Kill guardian urb (if required by driver).
-		 */
-		if (kill_guard) {
-			bcn_priv = queue->entries[i].priv_data;
-			usb_kill_urb(bcn_priv->guardian_urb);
-		}
-	}
+void rt2x00usb_kill_tx_queue(struct data_queue *queue)
+{
+	rt2x00queue_for_each_entry(queue, Q_INDEX_DONE, Q_INDEX,
+				   rt2x00usb_kill_tx_entry);
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_kill_tx_queue);
 
-- 
1.7.2.1

