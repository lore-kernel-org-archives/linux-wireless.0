Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59602 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761726Ab0HFStv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Aug 2010 14:49:51 -0400
Received: by ewy23 with SMTP id 23so2918051ewy.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 Aug 2010 11:49:49 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/7] rt2x00: Move USB tx/rx done handling to workqueue
Date: Fri, 6 Aug 2010 20:45:38 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
References: <201008062045.05288.IvDoorn@gmail.com>
In-Reply-To: <201008062045.05288.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201008062045.39547.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move all TX and RX completion handling into a work structure,
which is handeled on the mac80211 workqueue. This simplifies
the code in rt2x00lib since it no longer needs to check if the
device is USB or PCI to decide which mac80211 function should be used.

In the watchdog some changes are needed since it can no longer rely
on the TX completion function to be run while looping through the
entries. (Both functions now work on the same workqueue, so this
would deadlock). So the watchdog now waits for the URB to return,
and handle the TX status report directly.

As a side-effect, the debugfs entry for the RX queue now correctly
displays the positions of the INDEX and INDEX_DONE counters. This
also implies that it is not possible to perform checks like queue_empty()
and queue_full() on the RX queue.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h      |    9 ++-
 drivers/net/wireless/rt2x00/rt2x00dev.c   |   35 +++-----
 drivers/net/wireless/rt2x00/rt2x00queue.c |    7 +-
 drivers/net/wireless/rt2x00/rt2x00queue.h |    6 +-
 drivers/net/wireless/rt2x00/rt2x00usb.c   |  133 +++++++++++++++++++++--------
 5 files changed, 128 insertions(+), 62 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index c21af38..5276c19 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -1,5 +1,6 @@
 /*
-	Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
+	Copyright (C) 2010 Willow Garage <http://www.willowgarage.com>
+	Copyright (C) 2004 - 2010 Ivo van Doorn <IvDoorn@gmail.com>
 	Copyright (C) 2004 - 2009 Gertjan van Wingerde <gwingerde@gmail.com>
 	<http://rt2x00.serialmonkey.com>
 
@@ -862,6 +863,12 @@ struct rt2x00_dev {
 	 */
 	struct work_struct intf_work;
 
+	/**
+	 * Scheduled work for TX/RX done handling (USB devices)
+	 */
+	struct work_struct rxdone_work;
+	struct work_struct txdone_work;
+
 	/*
 	 * Data queue arrays for RX, TX and Beacon.
 	 * The Beacon array also contains the Atim queue
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 585e816..94621bd 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1,5 +1,6 @@
 /*
-	Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
+	Copyright (C) 2010 Willow Garage <http://www.willowgarage.com>
+	Copyright (C) 2004 - 2010 Ivo van Doorn <IvDoorn@gmail.com>
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
@@ -383,15 +384,7 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 	 * send the status report back.
 	 */
 	if (!(skbdesc_flags & SKBDESC_NOT_MAC80211))
-		/*
-		 * Only PCI and SOC devices process the tx status in process
-		 * context. Hence use ieee80211_tx_status for PCI and SOC
-		 * devices and stick to ieee80211_tx_status_irqsafe for USB.
-		 */
-		if (rt2x00_is_usb(rt2x00dev))
-			ieee80211_tx_status_irqsafe(rt2x00dev->hw, entry->skb);
-		else
-			ieee80211_tx_status(rt2x00dev->hw, entry->skb);
+		ieee80211_tx_status(rt2x00dev->hw, entry->skb);
 	else
 		dev_kfree_skb_any(entry->skb);
 
@@ -403,7 +396,6 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 
 	rt2x00dev->ops->lib->clear_entry(entry);
 
-	clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags);
 	rt2x00queue_index_inc(entry->queue, Q_INDEX_DONE);
 
 	/*
@@ -463,6 +455,10 @@ void rt2x00lib_rxdone(struct rt2x00_dev *rt2x00dev,
 	struct ieee80211_rx_status *rx_status = &rt2x00dev->rx_status;
 	unsigned int header_length;
 	int rate_idx;
+
+	if (test_bit(ENTRY_DATA_IO_FAILED, &entry->flags))
+		goto submit_entry;
+
 	/*
 	 * Allocate a new sk_buffer. If no new buffer available, drop the
 	 * received frame and reuse the existing buffer.
@@ -540,26 +536,17 @@ void rt2x00lib_rxdone(struct rt2x00_dev *rt2x00dev,
 	 */
 	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_RXDONE, entry->skb);
 	memcpy(IEEE80211_SKB_RXCB(entry->skb), rx_status, sizeof(*rx_status));
-
-	/*
-	 * Currently only PCI and SOC devices handle rx interrupts in process
-	 * context. Hence, use ieee80211_rx_irqsafe for USB and ieee80211_rx_ni
-	 * for PCI and SOC devices.
-	 */
-	if (rt2x00_is_usb(rt2x00dev))
-		ieee80211_rx_irqsafe(rt2x00dev->hw, entry->skb);
-	else
-		ieee80211_rx_ni(rt2x00dev->hw, entry->skb);
+	ieee80211_rx_ni(rt2x00dev->hw, entry->skb);
 
 	/*
 	 * Replace the skb with the freshly allocated one.
 	 */
 	entry->skb = skb;
-	entry->flags = 0;
 
+submit_entry:
 	rt2x00dev->ops->lib->clear_entry(entry);
-
 	rt2x00queue_index_inc(entry->queue, Q_INDEX);
+	rt2x00queue_index_inc(entry->queue, Q_INDEX_DONE);
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_rxdone);
 
@@ -1017,6 +1004,8 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
 	 * Stop all work.
 	 */
 	cancel_work_sync(&rt2x00dev->intf_work);
+	cancel_work_sync(&rt2x00dev->rxdone_work);
+	cancel_work_sync(&rt2x00dev->txdone_work);
 
 	/*
 	 * Uninitialize device.
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index a3401d3..1822095 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -1,5 +1,6 @@
 /*
-	Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
+	Copyright (C) 2010 Willow Garage <http://www.willowgarage.com>
+	Copyright (C) 2004 - 2010 Ivo van Doorn <IvDoorn@gmail.com>
 	Copyright (C) 2004 - 2009 Gertjan van Wingerde <gwingerde@gmail.com>
 	<http://rt2x00.serialmonkey.com>
 
@@ -730,9 +731,9 @@ void rt2x00queue_init_queues(struct rt2x00_dev *rt2x00dev)
 		rt2x00queue_reset(queue);
 
 		for (i = 0; i < queue->limit; i++) {
-			queue->entries[i].flags = 0;
-
 			rt2x00dev->ops->lib->clear_entry(&queue->entries[i]);
+			if (queue->qid == QID_RX)
+				rt2x00queue_index_inc(queue, Q_INDEX);
 		}
 	}
 }
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 191e777..38b47919 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
+	Copyright (C) 2004 - 2010 Ivo van Doorn <IvDoorn@gmail.com>
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
@@ -363,12 +363,16 @@ struct txentry_desc {
  *	the device has signaled it is done with it.
  * @ENTRY_DATA_PENDING: This entry contains a valid frame and is waiting
  *	for the signal to start sending.
+ * @ENTRY_DATA_IO_FAILED: Hardware indicated that an IO error occured
+ *	while transfering the data to the hardware. No TX status report will
+ *	be expected from the hardware.
  */
 enum queue_entry_flags {
 	ENTRY_BCN_ASSIGNED,
 	ENTRY_OWNER_DEVICE_DATA,
 	ENTRY_OWNER_DEVICE_CRYPTO,
 	ENTRY_DATA_PENDING,
+	ENTRY_DATA_IO_FAILED
 };
 
 /**
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index ff3a366..3f13101 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -1,5 +1,6 @@
 /*
-	Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
+	Copyright (C) 2010 Willow Garage <http://www.willowgarage.com>
+	Copyright (C) 2004 - 2010 Ivo van Doorn <IvDoorn@gmail.com>
 	<http://rt2x00.serialmonkey.com>
 
 	This program is free software; you can redistribute it and/or modify
@@ -167,19 +168,12 @@ EXPORT_SYMBOL_GPL(rt2x00usb_regbusy_read);
 /*
  * TX data handlers.
  */
-static void rt2x00usb_interrupt_txdone(struct urb *urb)
+static void rt2x00usb_work_txdone_entry(struct queue_entry *entry)
 {
-	struct queue_entry *entry = (struct queue_entry *)urb->context;
-	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct txdone_entry_desc txdesc;
 
-	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags) ||
-	    !test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
-		return;
-
 	/*
-	 * Obtain the status about this packet.
-	 * Note that when the status is 0 it does not mean the
+	 * If the transfer to hardware succeeded, it does not mean the
 	 * frame was send out correctly. It only means the frame
 	 * was succesfully pushed to the hardware, we have no
 	 * way to determine the transmission status right now.
@@ -187,15 +181,56 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
 	 * in the register).
 	 */
 	txdesc.flags = 0;
-	if (!urb->status)
-		__set_bit(TXDONE_UNKNOWN, &txdesc.flags);
-	else
+	if (test_bit(ENTRY_DATA_IO_FAILED, &entry->flags))
 		__set_bit(TXDONE_FAILURE, &txdesc.flags);
+	else
+		__set_bit(TXDONE_UNKNOWN, &txdesc.flags);
 	txdesc.retry = 0;
 
 	rt2x00lib_txdone(entry, &txdesc);
 }
 
+static void rt2x00usb_work_txdone(struct work_struct *work)
+{
+	struct rt2x00_dev *rt2x00dev =
+	    container_of(work, struct rt2x00_dev, txdone_work);
+	struct data_queue *queue;
+	struct queue_entry *entry;
+
+	tx_queue_for_each(rt2x00dev, queue) {
+		while (!rt2x00queue_empty(queue)) {
+			entry = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
+
+			if (test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
+				break;
+
+			rt2x00usb_work_txdone_entry(entry);
+		}
+	}
+}
+
+static void rt2x00usb_interrupt_txdone(struct urb *urb)
+{
+	struct queue_entry *entry = (struct queue_entry *)urb->context;
+	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
+
+	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags) ||
+	    !__test_and_clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
+		return;
+
+	/*
+	 * Check if the frame was correctly uploaded
+	 */
+	if (urb->status)
+		__set_bit(ENTRY_DATA_IO_FAILED, &entry->flags);
+
+	/*
+	 * Schedule the delayed work for reading the TX status
+	 * from the device.
+	 */
+	ieee80211_queue_work(rt2x00dev->hw, &rt2x00dev->txdone_work);
+}
+
 static inline void rt2x00usb_kick_tx_entry(struct queue_entry *entry)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
@@ -294,6 +329,7 @@ EXPORT_SYMBOL_GPL(rt2x00usb_kill_tx_queue);
 
 static void rt2x00usb_watchdog_reset_tx(struct data_queue *queue)
 {
+	struct queue_entry *entry;
 	struct queue_entry_priv_usb *entry_priv;
 	unsigned short threshold = queue->threshold;
 
@@ -313,14 +349,22 @@ static void rt2x00usb_watchdog_reset_tx(struct data_queue *queue)
 	 * Reset all currently uploaded TX frames.
 	 */
 	while (!rt2x00queue_empty(queue)) {
-		entry_priv = rt2x00queue_get_entry(queue, Q_INDEX_DONE)->priv_data;
+		entry = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
+		entry_priv = entry->priv_data;
 		usb_kill_urb(entry_priv->urb);
 
 		/*
 		 * We need a short delay here to wait for
-		 * the URB to be canceled and invoked the tx_done handler.
+		 * the URB to be canceled
 		 */
-		udelay(200);
+		do {
+			udelay(100);
+		} while (test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags));
+
+		/*
+		 * Invoke the TX done handler
+		 */
+		rt2x00usb_work_txdone_entry(entry);
 	}
 
 	/*
@@ -345,15 +389,41 @@ EXPORT_SYMBOL_GPL(rt2x00usb_watchdog);
 /*
  * RX data handlers.
  */
+static void rt2x00usb_work_rxdone(struct work_struct *work)
+{
+	struct rt2x00_dev *rt2x00dev =
+	    container_of(work, struct rt2x00_dev, rxdone_work);
+	struct queue_entry *entry;
+	struct skb_frame_desc *skbdesc;
+	u8 rxd[32];
+
+	while (!rt2x00queue_empty(rt2x00dev->rx)) {
+		entry = rt2x00queue_get_entry(rt2x00dev->rx, Q_INDEX_DONE);
+
+		if (test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
+			break;
+
+		/*
+		 * Fill in desc fields of the skb descriptor
+		 */
+		skbdesc = get_skb_frame_desc(entry->skb);
+		skbdesc->desc = rxd;
+		skbdesc->desc_len = entry->queue->desc_size;
+
+		/*
+		 * Send the frame to rt2x00lib for further processing.
+		 */
+		rt2x00lib_rxdone(rt2x00dev, entry);
+	}
+}
+
 static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 {
 	struct queue_entry *entry = (struct queue_entry *)urb->context;
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
-	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
-	u8 rxd[32];
 
 	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags) ||
-	    !test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
+	    !__test_and_clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
 		return;
 
 	/*
@@ -361,22 +431,14 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 	 * to be actually valid, or if the urb is signaling
 	 * a problem.
 	 */
-	if (urb->actual_length < entry->queue->desc_size || urb->status) {
-		set_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags);
-		usb_submit_urb(urb, GFP_ATOMIC);
-		return;
-	}
-
-	/*
-	 * Fill in desc fields of the skb descriptor
-	 */
-	skbdesc->desc = rxd;
-	skbdesc->desc_len = entry->queue->desc_size;
+	if (urb->actual_length < entry->queue->desc_size || urb->status)
+		__set_bit(ENTRY_DATA_IO_FAILED, &entry->flags);
 
 	/*
-	 * Send the frame to rt2x00lib for further processing.
+	 * Schedule the delayed work for reading the RX status
+	 * from the device.
 	 */
-	rt2x00lib_rxdone(rt2x00dev, entry);
+	ieee80211_queue_work(rt2x00dev->hw, &rt2x00dev->rxdone_work);
 }
 
 /*
@@ -405,6 +467,8 @@ void rt2x00usb_clear_entry(struct queue_entry *entry)
 	struct queue_entry_priv_usb *entry_priv = entry->priv_data;
 	int pipe;
 
+	entry->flags = 0;
+
 	if (entry->queue->qid == QID_RX) {
 		pipe = usb_rcvbulkpipe(usb_dev, entry->queue->usb_endpoint);
 		usb_fill_bulk_urb(entry_priv->urb, usb_dev, pipe,
@@ -413,8 +477,6 @@ void rt2x00usb_clear_entry(struct queue_entry *entry)
 
 		set_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags);
 		usb_submit_urb(entry_priv->urb, GFP_ATOMIC);
-	} else {
-		entry->flags = 0;
 	}
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_clear_entry);
@@ -659,6 +721,9 @@ int rt2x00usb_probe(struct usb_interface *usb_intf,
 
 	rt2x00_set_chip_intf(rt2x00dev, RT2X00_CHIP_INTF_USB);
 
+	INIT_WORK(&rt2x00dev->rxdone_work, rt2x00usb_work_rxdone);
+	INIT_WORK(&rt2x00dev->txdone_work, rt2x00usb_work_txdone);
+
 	retval = rt2x00usb_alloc_reg(rt2x00dev);
 	if (retval)
 		goto exit_free_device;
-- 
1.7.2

