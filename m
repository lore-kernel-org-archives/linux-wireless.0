Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:39913 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab3COI7I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Mar 2013 04:59:08 -0400
Received: by mail-bk0-f44.google.com with SMTP id j4so1428121bkw.31
        for <linux-wireless@vger.kernel.org>; Fri, 15 Mar 2013 01:59:04 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linville@tuxdriver.com
Cc: IvDoorn@gmail.com, gwingerde@gmail.com, stf_xl@wp.pl,
	linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 1/2] rt2x00: Revert "rt2x00: remove unused argument"
Date: Fri, 15 Mar 2013 09:57:56 +0100
Message-Id: <1363337877-20986-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20130315_095913_067580_C15B77D3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit db36f792370959ff26458f80942cf98fe8249d95
since I'm going to use the data pointer that was removed in
a follow up patch.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2x00queue.c |   10 ++++++----
 drivers/net/wireless/rt2x00/rt2x00queue.h |    5 ++++-
 drivers/net/wireless/rt2x00/rt2x00usb.c   |   20 +++++++++++++-------
 3 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 4d91795..952a049 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -832,7 +832,9 @@ int rt2x00queue_update_beacon(struct rt2x00_dev *rt2x00dev,
 bool rt2x00queue_for_each_entry(struct data_queue *queue,
 				enum queue_index start,
 				enum queue_index end,
-				bool (*fn)(struct queue_entry *entry))
+				void *data,
+				bool (*fn)(struct queue_entry *entry,
+					   void *data))
 {
 	unsigned long irqflags;
 	unsigned int index_start;
@@ -863,17 +865,17 @@ bool rt2x00queue_for_each_entry(struct data_queue *queue,
 	 */
 	if (index_start < index_end) {
 		for (i = index_start; i < index_end; i++) {
-			if (fn(&queue->entries[i]))
+			if (fn(&queue->entries[i], data))
 				return true;
 		}
 	} else {
 		for (i = index_start; i < queue->limit; i++) {
-			if (fn(&queue->entries[i]))
+			if (fn(&queue->entries[i], data))
 				return true;
 		}
 
 		for (i = 0; i < index_end; i++) {
-			if (fn(&queue->entries[i]))
+			if (fn(&queue->entries[i], data))
 				return true;
 		}
 	}
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 9b8c10a..5f1392c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -584,6 +584,7 @@ struct data_queue_desc {
  * @queue: Pointer to @data_queue
  * @start: &enum queue_index Pointer to start index
  * @end: &enum queue_index Pointer to end index
+ * @data: Data to pass to the callback function
  * @fn: The function to call for each &struct queue_entry
  *
  * This will walk through all entries in the queue, in chronological
@@ -596,7 +597,9 @@ struct data_queue_desc {
 bool rt2x00queue_for_each_entry(struct data_queue *queue,
 				enum queue_index start,
 				enum queue_index end,
-				bool (*fn)(struct queue_entry *entry));
+				void *data,
+				bool (*fn)(struct queue_entry *entry,
+					   void *data));
 
 /**
  * rt2x00queue_empty - Check if the queue is empty.
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 40ea807..5e50d4f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -285,7 +285,7 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
 		queue_work(rt2x00dev->workqueue, &rt2x00dev->txdone_work);
 }
 
-static bool rt2x00usb_kick_tx_entry(struct queue_entry *entry)
+static bool rt2x00usb_kick_tx_entry(struct queue_entry *entry, void *data)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct usb_device *usb_dev = to_usb_device_intf(rt2x00dev->dev);
@@ -390,7 +390,7 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 	queue_work(rt2x00dev->workqueue, &rt2x00dev->rxdone_work);
 }
 
-static bool rt2x00usb_kick_rx_entry(struct queue_entry *entry)
+static bool rt2x00usb_kick_rx_entry(struct queue_entry *entry, void *data)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct usb_device *usb_dev = to_usb_device_intf(rt2x00dev->dev);
@@ -427,12 +427,18 @@ void rt2x00usb_kick_queue(struct data_queue *queue)
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
-			rt2x00queue_for_each_entry(queue, Q_INDEX, Q_INDEX_DONE,
+			rt2x00queue_for_each_entry(queue,
+						   Q_INDEX,
+						   Q_INDEX_DONE,
+						   NULL,
 						   rt2x00usb_kick_rx_entry);
 		break;
 	default:
@@ -441,7 +447,7 @@ void rt2x00usb_kick_queue(struct data_queue *queue)
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_kick_queue);
 
-static bool rt2x00usb_flush_entry(struct queue_entry *entry)
+static bool rt2x00usb_flush_entry(struct queue_entry *entry, void *data)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct queue_entry_priv_usb *entry_priv = entry->priv_data;
@@ -468,7 +474,7 @@ void rt2x00usb_flush_queue(struct data_queue *queue, bool drop)
 	unsigned int i;
 
 	if (drop)
-		rt2x00queue_for_each_entry(queue, Q_INDEX_DONE, Q_INDEX,
+		rt2x00queue_for_each_entry(queue, Q_INDEX_DONE, Q_INDEX, NULL,
 					   rt2x00usb_flush_entry);
 
 	/*
@@ -559,7 +565,7 @@ void rt2x00usb_clear_entry(struct queue_entry *entry)
 	entry->flags = 0;
 
 	if (entry->queue->qid == QID_RX)
-		rt2x00usb_kick_rx_entry(entry);
+		rt2x00usb_kick_rx_entry(entry, NULL);
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_clear_entry);
 
-- 
1.7.10.4

