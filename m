Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53097 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868Ab1DRNfo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 09:35:44 -0400
Received: by mail-fx0-f46.google.com with SMTP id 17so2833789fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2011 06:35:44 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 04/23] rt2x00: Make rt2x00_queue_entry_for_each more flexible
Date: Mon, 18 Apr 2011 15:27:43 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201104181526.01722.IvDoorn@gmail.com> <201104181526.37747.IvDoorn@gmail.com> <201104181527.06956.IvDoorn@gmail.com>
In-Reply-To: <201104181527.06956.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201104181527.44542.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Allow passing a void pointer to rt2x00_queue_entry_for_each which in
turn in provided to the callback function.

Furthermore, allow the callback function to stop processing by returning
true. And also notify the caller of rt2x00_queue_entry_for_each if the
loop was canceled by the callback.

No functional changes, just preparation for an upcoming patch.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00queue.c |   28 +++++++++++++++++--------
 drivers/net/wireless/rt2x00/rt2x00queue.h |   10 +++++++-
 drivers/net/wireless/rt2x00/rt2x00usb.c   |   32 +++++++++++++++++++---------
 3 files changed, 49 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index d03eef2..458bb48 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -650,10 +650,12 @@ int rt2x00queue_update_beacon(struct rt2x00_dev *rt2x00dev,
 	return ret;
 }
 
-void rt2x00queue_for_each_entry(struct data_queue *queue,
+bool rt2x00queue_for_each_entry(struct data_queue *queue,
 				enum queue_index start,
 				enum queue_index end,
-				void (*fn)(struct queue_entry *entry))
+				void *data,
+				bool (*fn)(struct queue_entry *entry,
+					   void *data))
 {
 	unsigned long irqflags;
 	unsigned int index_start;
@@ -664,7 +666,7 @@ void rt2x00queue_for_each_entry(struct data_queue *queue,
 		ERROR(queue->rt2x00dev,
 		      "Entry requested from invalid index range (%d - %d)\n",
 		      start, end);
-		return;
+		return true;
 	}
 
 	/*
@@ -683,15 +685,23 @@ void rt2x00queue_for_each_entry(struct data_queue *queue,
 	 * send out all frames in the correct order.
 	 */
 	if (index_start < index_end) {
-		for (i = index_start; i < index_end; i++)
-			fn(&queue->entries[i]);
+		for (i = index_start; i < index_end; i++) {
+			if (fn(&queue->entries[i], data))
+				return true;
+		}
 	} else {
-		for (i = index_start; i < queue->limit; i++)
-			fn(&queue->entries[i]);
+		for (i = index_start; i < queue->limit; i++) {
+			if (fn(&queue->entries[i], data))
+				return true;
+		}
 
-		for (i = 0; i < index_end; i++)
-			fn(&queue->entries[i]);
+		for (i = 0; i < index_end; i++) {
+			if (fn(&queue->entries[i], data))
+				return true;
+		}
 	}
+
+	return false;
 }
 EXPORT_SYMBOL_GPL(rt2x00queue_for_each_entry);
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 6ae8200..6b66452 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -580,16 +580,22 @@ struct data_queue_desc {
  * @queue: Pointer to @data_queue
  * @start: &enum queue_index Pointer to start index
  * @end: &enum queue_index Pointer to end index
+ * @data: Data to pass to the callback function
  * @fn: The function to call for each &struct queue_entry
  *
  * This will walk through all entries in the queue, in chronological
  * order. This means it will start at the current @start pointer
  * and will walk through the queue until it reaches the @end pointer.
+ *
+ * If fn returns true for an entry rt2x00queue_for_each_entry will stop
+ * processing and return true as well.
  */
-void rt2x00queue_for_each_entry(struct data_queue *queue,
+bool rt2x00queue_for_each_entry(struct data_queue *queue,
 				enum queue_index start,
 				enum queue_index end,
-				void (*fn)(struct queue_entry *entry));
+				void *data,
+				bool (*fn)(struct queue_entry *entry,
+					   void *data));
 
 /**
  * rt2x00queue_empty - Check if the queue is empty.
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 94047e9..0bc8dcc 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -230,7 +230,7 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
 	queue_work(rt2x00dev->workqueue, &rt2x00dev->txdone_work);
 }
 
-static void rt2x00usb_kick_tx_entry(struct queue_entry *entry)
+static bool rt2x00usb_kick_tx_entry(struct queue_entry *entry, void* data)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct usb_device *usb_dev = to_usb_device_intf(rt2x00dev->dev);
@@ -240,7 +240,7 @@ static void rt2x00usb_kick_tx_entry(struct queue_entry *entry)
 
 	if (!test_and_clear_bit(ENTRY_DATA_PENDING, &entry->flags) ||
 	    test_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags))
-		return;
+		return true;
 
 	/*
 	 * USB devices cannot blindly pass the skb->len as the
@@ -261,6 +261,8 @@ static void rt2x00usb_kick_tx_entry(struct queue_entry *entry)
 		set_bit(ENTRY_DATA_IO_FAILED, &entry->flags);
 		rt2x00lib_dmadone(entry);
 	}
+
+	return false;
 }
 
 /*
@@ -323,7 +325,7 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 	queue_work(rt2x00dev->workqueue, &rt2x00dev->rxdone_work);
 }
 
-static void rt2x00usb_kick_rx_entry(struct queue_entry *entry)
+static bool rt2x00usb_kick_rx_entry(struct queue_entry *entry, void* data)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct usb_device *usb_dev = to_usb_device_intf(rt2x00dev->dev);
@@ -332,7 +334,7 @@ static void rt2x00usb_kick_rx_entry(struct queue_entry *entry)
 
 	if (test_and_set_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags) ||
 	    test_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags))
-		return;
+		return true;
 
 	rt2x00lib_dmastart(entry);
 
@@ -348,6 +350,8 @@ static void rt2x00usb_kick_rx_entry(struct queue_entry *entry)
 		set_bit(ENTRY_DATA_IO_FAILED, &entry->flags);
 		rt2x00lib_dmadone(entry);
 	}
+
+	return false;
 }
 
 void rt2x00usb_kick_queue(struct data_queue *queue)
@@ -358,12 +362,18 @@ void rt2x00usb_kick_queue(struct data_queue *queue)
 	case QID_AC_BE:
 	case QID_AC_BK:
 		if (!rt2x00queue_empty(queue))
-			rt2x00queue_for_each_entry(queue, Q_INDEX_DONE, Q_INDEX,
+			rt2x00queue_for_each_entry(queue,
+						   Q_INDEX_DONE,
+						   Q_INDEX,
+						   NULL,
 						   rt2x00usb_kick_tx_entry);
 		break;
 	case QID_RX:
 		if (!rt2x00queue_full(queue))
-			rt2x00queue_for_each_entry(queue, Q_INDEX_DONE, Q_INDEX,
+			rt2x00queue_for_each_entry(queue,
+						   Q_INDEX_DONE,
+						   Q_INDEX,
+						   NULL,
 						   rt2x00usb_kick_rx_entry);
 		break;
 	default:
@@ -372,14 +382,14 @@ void rt2x00usb_kick_queue(struct data_queue *queue)
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_kick_queue);
 
-static void rt2x00usb_flush_entry(struct queue_entry *entry)
+static bool rt2x00usb_flush_entry(struct queue_entry *entry, void* data)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct queue_entry_priv_usb *entry_priv = entry->priv_data;
 	struct queue_entry_priv_usb_bcn *bcn_priv = entry->priv_data;
 
 	if (!test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
-		return;
+		return true;
 
 	usb_kill_urb(entry_priv->urb);
 
@@ -389,6 +399,8 @@ static void rt2x00usb_flush_entry(struct queue_entry *entry)
 	if ((entry->queue->qid == QID_BEACON) &&
 	    (test_bit(REQUIRE_BEACON_GUARD, &rt2x00dev->cap_flags)))
 		usb_kill_urb(bcn_priv->guardian_urb);
+
+	return false;
 }
 
 void rt2x00usb_flush_queue(struct data_queue *queue)
@@ -396,7 +408,7 @@ void rt2x00usb_flush_queue(struct data_queue *queue)
 	struct work_struct *completion;
 	unsigned int i;
 
-	rt2x00queue_for_each_entry(queue, Q_INDEX_DONE, Q_INDEX,
+	rt2x00queue_for_each_entry(queue, Q_INDEX_DONE, Q_INDEX, NULL,
 				   rt2x00usb_flush_entry);
 
 	/*
@@ -489,7 +501,7 @@ void rt2x00usb_clear_entry(struct queue_entry *entry)
 	entry->flags = 0;
 
 	if (entry->queue->qid == QID_RX)
-		rt2x00usb_kick_rx_entry(entry);
+		rt2x00usb_kick_rx_entry(entry, NULL);
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_clear_entry);
 
-- 
1.7.2.3

