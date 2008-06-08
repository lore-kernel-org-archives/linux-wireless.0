Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:45416 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756081AbYFHVh3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jun 2008 17:37:29 -0400
Received: by ug-out-1314.google.com with SMTP id h2so1022998ugf.16
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jun 2008 14:37:28 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 01/10] rt2x00: Implement rt2x00usb_kick_tx_queue()
Date: Sun, 8 Jun 2008 23:42:40 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200806082341.58616.IvDoorn@gmail.com>
In-Reply-To: <200806082341.58616.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200806082342.40422.IvDoorn@gmail.com> (sfid-20080608_233732_332673_9FF552DE)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2x00usb_kick_tx_queue() will loop over all entries
within the INDEX_DONE->INDEX range and kick each entry
which is pending to be kicked. This makes the kick_tx_queue
approach work the same as with the PCI drivers which
will allow for more code generalisation into rt2x00lib.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c   |    4 ++-
 drivers/net/wireless/rt2x00/rt2x00queue.h |    3 ++
 drivers/net/wireless/rt2x00/rt2x00usb.c   |   48 ++++++++++++++++++++++++++++-
 drivers/net/wireless/rt2x00/rt2x00usb.h   |   11 ++++++
 drivers/net/wireless/rt2x00/rt73usb.c     |    4 ++-
 5 files changed, 67 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 0d51b74..6abb4c5 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1116,8 +1116,10 @@ static void rt2500usb_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 {
 	u16 reg;
 
-	if (queue != QID_BEACON)
+	if (queue != QID_BEACON) {
+		rt2x00usb_kick_tx_queue(rt2x00dev, queue);
 		return;
+	}
 
 	rt2500usb_register_read(rt2x00dev, TXRX_CSR19, &reg);
 	if (!rt2x00_get_field16(reg, TXRX_CSR19_BEACON_GEN)) {
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 4d00ced..303d556 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -260,11 +260,14 @@ struct txentry_desc {
  * @ENTRY_OWNER_DEVICE_CRYPTO: This entry is owned by the device for data
  *	encryption or decryption. The entry should only be touched after
  *	the device has signaled it is done with it.
+ * @ENTRY_DATA_PENDING: This entry contains a valid frame and is waiting
+ *	for the signal to start sending.
  */
 enum queue_entry_flags {
 	ENTRY_BCN_ASSIGNED,
 	ENTRY_OWNER_DEVICE_DATA,
 	ENTRY_OWNER_DEVICE_CRYPTO,
+	ENTRY_DATA_PENDING,
 };
 
 /**
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 86f1ab7..eff10b9 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -232,9 +232,10 @@ int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
 	 * Initialize URB and send the frame to the device.
 	 */
 	__set_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags);
+	__set_bit(ENTRY_DATA_PENDING, &entry->flags);
+
 	usb_fill_bulk_urb(entry_priv->urb, usb_dev, usb_sndbulkpipe(usb_dev, 1),
 			  skb->data, length, rt2x00usb_interrupt_txdone, entry);
-	usb_submit_urb(entry_priv->urb, GFP_ATOMIC);
 
 	rt2x00queue_index_inc(queue, Q_INDEX);
 
@@ -242,6 +243,51 @@ int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_write_tx_data);
 
+static inline void rt2x00usb_kick_tx_entry(struct queue_entry *entry)
+{
+	struct queue_entry_priv_usb *entry_priv = entry->priv_data;
+
+	if (__test_and_clear_bit(ENTRY_DATA_PENDING, &entry->flags))
+		usb_submit_urb(entry_priv->urb, GFP_ATOMIC);
+}
+
+void rt2x00usb_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
+			     const enum data_queue_qid qid)
+{
+	struct data_queue *queue = rt2x00queue_get_queue(rt2x00dev, qid);
+	unsigned long irqflags;
+	unsigned int index;
+	unsigned int index_done;
+	unsigned int i;
+
+	/*
+	 * Only protect the range we are going to loop over,
+	 * if during our loop a extra entry is set to pending
+	 * it should not be kicked during this run, since it
+	 * is part of another TX operation.
+	 */
+	spin_lock_irqsave(&queue->lock, irqflags);
+	index = queue->index[Q_INDEX];
+	index_done = queue->index[Q_INDEX_DONE];
+	spin_unlock_irqrestore(&queue->lock, irqflags);
+
+	/*
+	 * Start from the TX done pointer, this guarentees that we will
+	 * send out all frames in the correct order.
+	 */
+	if (index_done < index) {
+		for (i = index_done; i < index; i++)
+			rt2x00usb_kick_tx_entry(&queue->entries[i]);
+	} else {
+		for (i = index_done; i < queue->limit; i++)
+			rt2x00usb_kick_tx_entry(&queue->entries[i]);
+
+		for (i = 0; i < index; i++)
+			rt2x00usb_kick_tx_entry(&queue->entries[i]);
+	}
+}
+EXPORT_SYMBOL_GPL(rt2x00usb_kick_tx_queue);
+
 /*
  * RX data handlers.
  */
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.h b/drivers/net/wireless/rt2x00/rt2x00usb.h
index 26f53f8..460d32c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
@@ -245,6 +245,17 @@ struct queue_entry_priv_usb_bcn {
 	struct urb *guardian_urb;
 };
 
+/**
+ * rt2x00usb_kick_tx_queue - Kick data queue
+ * @rt2x00dev: Pointer to &struct rt2x00_dev
+ * @qid: Data queue to kick
+ *
+ * This will walk through all entries of the queue and push all pending
+ * frames to the hardware as a single burst.
+ */
+void rt2x00usb_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
+			     const enum data_queue_qid qid);
+
 /*
  * Device initialization handlers.
  */
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index db1fc13..5e5f603 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1350,8 +1350,10 @@ static void rt73usb_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 {
 	u32 reg;
 
-	if (queue != QID_BEACON)
+	if (queue != QID_BEACON) {
+		rt2x00usb_kick_tx_queue(rt2x00dev, queue);
 		return;
+	}
 
 	/*
 	 * For Wi-Fi faily generated beacons between participating stations.
-- 
1.5.5.3

