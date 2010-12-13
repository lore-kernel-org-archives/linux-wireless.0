Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f45.google.com ([209.85.215.45]:47560 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747Ab0LMLk3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 06:40:29 -0500
Received: by mail-ew0-f45.google.com with SMTP id 10so3803451ewy.4
        for <linux-wireless@vger.kernel.org>; Mon, 13 Dec 2010 03:40:28 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 12/17] rt2x00: Cleanup RX index counting
Date: Mon, 13 Dec 2010 12:36:00 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201012131231.28313.IvDoorn@gmail.com> <201012131235.19063.IvDoorn@gmail.com> <201012131235.41811.IvDoorn@gmail.com>
In-Reply-To: <201012131235.41811.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012131236.01268.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the rt2x00_dmastart function to rt2x00lib which
marks the queue_entry as "owned by device", and increased
the Q_INDEX number.

This cleanups up the index handling by rt2x00lib which
at until so far used hackish approaches to keep the
RX queue index numbering sane.

The rt2x00pci.c changes are from Helmut Schaa

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h      |    1 +
 drivers/net/wireless/rt2x00/rt2x00dev.c   |   11 ++++++++---
 drivers/net/wireless/rt2x00/rt2x00pci.c   |    7 +++++++
 drivers/net/wireless/rt2x00/rt2x00queue.c |    5 +----
 drivers/net/wireless/rt2x00/rt2x00usb.c   |    2 ++
 5 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 520e736..556b744 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -1170,6 +1170,7 @@ static inline void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
  */
 void rt2x00lib_beacondone(struct rt2x00_dev *rt2x00dev);
 void rt2x00lib_pretbtt(struct rt2x00_dev *rt2x00dev);
+void rt2x00lib_dmastart(struct queue_entry *entry);
 void rt2x00lib_dmadone(struct queue_entry *entry);
 void rt2x00lib_txdone(struct queue_entry *entry,
 		      struct txdone_entry_desc *txdesc);
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 01c8415..f3ae949 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -226,6 +226,13 @@ void rt2x00lib_pretbtt(struct rt2x00_dev *rt2x00dev)
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_pretbtt);
 
+void rt2x00lib_dmastart(struct queue_entry *entry)
+{
+	set_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags);
+	rt2x00queue_index_inc(entry->queue, Q_INDEX);
+}
+EXPORT_SYMBOL_GPL(rt2x00lib_dmastart);
+
 void rt2x00lib_dmadone(struct queue_entry *entry)
 {
 	clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags);
@@ -552,10 +559,8 @@ submit_entry:
 	entry->flags = 0;
 	rt2x00queue_index_inc(entry->queue, Q_INDEX_DONE);
 	if (test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags) &&
-	    test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags)) {
+	    test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
 		rt2x00dev->ops->lib->clear_entry(entry);
-		rt2x00queue_index_inc(entry->queue, Q_INDEX);
-	}
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_rxdone);
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index 868ca19..28e6ff1 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -82,6 +82,13 @@ void rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
 		skbdesc->desc_len = entry->queue->desc_size;
 
 		/*
+		 * DMA is already done, notify rt2x00lib that
+		 * it finished successfully.
+		 */
+		rt2x00lib_dmastart(entry);
+		rt2x00lib_dmadone(entry);
+
+		/*
 		 * Send the frame to rt2x00lib for further processing.
 		 */
 		rt2x00lib_rxdone(entry);
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 313a8fa..52cc92d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -968,11 +968,8 @@ void rt2x00queue_init_queues(struct rt2x00_dev *rt2x00dev)
 	queue_for_each(rt2x00dev, queue) {
 		rt2x00queue_reset(queue);
 
-		for (i = 0; i < queue->limit; i++) {
+		for (i = 0; i < queue->limit; i++)
 			rt2x00dev->ops->lib->clear_entry(&queue->entries[i]);
-			if (queue->qid == QID_RX)
-				rt2x00queue_index_inc(queue, Q_INDEX);
-		}
 	}
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index cd80eec..cd29ebc 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -330,6 +330,8 @@ static void rt2x00usb_kick_rx_entry(struct queue_entry *entry)
 	if (test_and_set_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
 		return;
 
+	rt2x00lib_dmastart(entry);
+
 	usb_fill_bulk_urb(entry_priv->urb, usb_dev,
 			  usb_rcvbulkpipe(usb_dev, entry->queue->usb_endpoint),
 			  entry->skb->data, entry->skb->len,
-- 
1.7.2.3

