Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59602 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761876Ab0HFSuA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Aug 2010 14:50:00 -0400
Received: by mail-ew0-f46.google.com with SMTP id 23so2918051ewy.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 Aug 2010 11:50:00 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 5/7] rt2x00: Implement TX status reporting for rt2800usb
Date: Fri, 6 Aug 2010 20:47:57 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
References: <201008062045.05288.IvDoorn@gmail.com> <201008062046.54483.IvDoorn@gmail.com> <201008062047.21710.IvDoorn@gmail.com>
In-Reply-To: <201008062047.21710.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201008062047.58607.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The TX_STA_FIFO register which is used for per-frame TX frame
status reporting is also valid on rt2800usb. We can move the
rt2800pci_txdone function into rt2800lib where it can also
be used by rt2800usb.

rt2800usb needs to overwrite the txdone work handler to
a different function.

Both rt2800usb as rt2800_txdone need to take into account
that IO failures can occur while uploading the URB, which
means that when obtaining the new entry the IO status must
be checked.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |  117 +++++++++++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2800lib.h |    4 +
 drivers/net/wireless/rt2x00/rt2800pci.c |  108 +----------------------------
 drivers/net/wireless/rt2x00/rt2800usb.c |   40 ++++++++++-
 4 files changed, 162 insertions(+), 107 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 6f1eb58..827a258 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1,4 +1,5 @@
 /*
+	Copyright (C) 2010 Willow Garage <http://www.willowgarage.com>
 	Copyright (C) 2010 Ivo van Doorn <IvDoorn@gmail.com>
 	Copyright (C) 2009 Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
 	Copyright (C) 2009 Gertjan van Wingerde <gwingerde@gmail.com>
@@ -572,6 +573,122 @@ void rt2800_process_rxwi(struct queue_entry *entry,
 }
 EXPORT_SYMBOL_GPL(rt2800_process_rxwi);
 
+void rt2800_txdone(struct rt2x00_dev *rt2x00dev)
+{
+	struct data_queue *queue;
+	struct queue_entry *entry;
+	__le32 *txwi;
+	struct txdone_entry_desc txdesc;
+	u32 word;
+	u32 reg;
+	int wcid, ack, pid, tx_wcid, tx_ack, tx_pid;
+	u16 mcs, real_mcs;
+	int i;
+
+	/*
+	 * TX_STA_FIFO is a stack of X entries, hence read TX_STA_FIFO
+	 * at most X times and also stop processing once the TX_STA_FIFO_VALID
+	 * flag is not set anymore.
+	 *
+	 * The legacy drivers use X=TX_RING_SIZE but state in a comment
+	 * that the TX_STA_FIFO stack has a size of 16. We stick to our
+	 * tx ring size for now.
+	 */
+	for (i = 0; i < TX_ENTRIES; i++) {
+		rt2800_register_read(rt2x00dev, TX_STA_FIFO, &reg);
+		if (!rt2x00_get_field32(reg, TX_STA_FIFO_VALID))
+			break;
+
+		wcid	= rt2x00_get_field32(reg, TX_STA_FIFO_WCID);
+		ack	= rt2x00_get_field32(reg, TX_STA_FIFO_TX_ACK_REQUIRED);
+		pid	= rt2x00_get_field32(reg, TX_STA_FIFO_PID_TYPE);
+
+		/*
+		 * Skip this entry when it contains an invalid
+		 * queue identication number.
+		 */
+		if (pid <= 0 || pid > QID_RX)
+			continue;
+
+		queue = rt2x00queue_get_queue(rt2x00dev, pid - 1);
+		if (unlikely(!queue))
+			continue;
+
+		/*
+		 * Inside each queue, we process each entry in a chronological
+		 * order. We first check that the queue is not empty.
+		 */
+		entry = NULL;
+		while (!rt2x00queue_empty(queue)) {
+			entry = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
+			if (!test_bit(ENTRY_DATA_IO_FAILED, &entry->flags))
+				break;
+
+			rt2x00lib_txdone_noinfo(entry, TXDONE_FAILURE);
+		}
+
+		if (!entry || rt2x00queue_empty(queue))
+			break;
+
+		/*
+		 * Check if we got a match by looking at WCID/ACK/PID
+		 * fields
+		 */
+		txwi = rt2800_drv_get_txwi(entry);
+
+		rt2x00_desc_read(txwi, 1, &word);
+		tx_wcid	= rt2x00_get_field32(word, TXWI_W1_WIRELESS_CLI_ID);
+		tx_ack	= rt2x00_get_field32(word, TXWI_W1_ACK);
+		tx_pid	= rt2x00_get_field32(word, TXWI_W1_PACKETID);
+
+		if ((wcid != tx_wcid) || (ack != tx_ack) || (pid != tx_pid))
+			WARNING(rt2x00dev, "invalid TX_STA_FIFO content");
+
+		/*
+		 * Obtain the status about this packet.
+		 */
+		txdesc.flags = 0;
+		rt2x00_desc_read(txwi, 0, &word);
+		mcs = rt2x00_get_field32(word, TXWI_W0_MCS);
+		mcs = rt2x00_get_field32(reg, TX_STA_FIFO_MCS);
+		real_mcs = rt2x00_get_field32(reg, TX_STA_FIFO_MCS);
+
+		/*
+		 * Ralink has a retry mechanism using a global fallback
+		 * table. We setup this fallback table to try the immediate
+		 * lower rate for all rates. In the TX_STA_FIFO, the MCS field
+		 * always contains the MCS used for the last transmission, be
+		 * it successful or not.
+		 */
+		if (rt2x00_get_field32(reg, TX_STA_FIFO_TX_SUCCESS)) {
+			/*
+			 * Transmission succeeded. The number of retries is
+			 * mcs - real_mcs
+			 */
+			__set_bit(TXDONE_SUCCESS, &txdesc.flags);
+			txdesc.retry = ((mcs > real_mcs) ? mcs - real_mcs : 0);
+		} else {
+			/*
+			 * Transmission failed. The number of retries is
+			 * always 7 in this case (for a total number of 8
+			 * frames sent).
+			 */
+			__set_bit(TXDONE_FAILURE, &txdesc.flags);
+			txdesc.retry = rt2x00dev->long_retry;
+		}
+
+		/*
+		 * the frame was retried at least once
+		 * -> hw used fallback rates
+		 */
+		if (txdesc.retry)
+			__set_bit(TXDONE_FALLBACK, &txdesc.flags);
+
+		rt2x00lib_txdone(entry, &txdesc);
+	}
+}
+EXPORT_SYMBOL_GPL(rt2800_txdone);
+
 void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless/rt2x00/rt2800lib.h
index 8f97518..3b572c6 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -1,4 +1,6 @@
 /*
+	Copyright (C) 2010 Willow Garage <http://www.willowgarage.com>
+	Copyright (C) 2010 Ivo van Doorn <IvDoorn@gmail.com>
 	Copyright (C) 2009 Bartlomiej Zolnierkiewicz
 
 	This program is free software; you can redistribute it and/or modify
@@ -147,6 +149,8 @@ void rt2800_write_tx_data(struct queue_entry *entry,
 			  struct txentry_desc *txdesc);
 void rt2800_process_rxwi(struct queue_entry *entry, struct rxdone_entry_desc *txdesc);
 
+void rt2800_txdone(struct rt2x00_dev *rt2x00dev);
+
 void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc);
 
 extern const struct rt2x00debug rt2800_rt2x00debug;
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index f415f6d..4390f2b 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -1,5 +1,5 @@
 /*
-	Copyright (C) 2009 Ivo van Doorn <IvDoorn@gmail.com>
+	Copyright (C) 2009 - 2010 Ivo van Doorn <IvDoorn@gmail.com>
 	Copyright (C) 2009 Alban Browaeys <prahal@yahoo.com>
 	Copyright (C) 2009 Felix Fietkau <nbd@openwrt.org>
 	Copyright (C) 2009 Luis Correia <luis.f.correia@gmail.com>
@@ -724,110 +724,6 @@ static void rt2800pci_fill_rxdone(struct queue_entry *entry,
 /*
  * Interrupt functions.
  */
-static void rt2800pci_txdone(struct rt2x00_dev *rt2x00dev)
-{
-	struct data_queue *queue;
-	struct queue_entry *entry;
-	__le32 *txwi;
-	struct txdone_entry_desc txdesc;
-	u32 word;
-	u32 reg;
-	int wcid, ack, pid, tx_wcid, tx_ack, tx_pid;
-	u16 mcs, real_mcs;
-	int i;
-
-	/*
-	 * TX_STA_FIFO is a stack of X entries, hence read TX_STA_FIFO
-	 * at most X times and also stop processing once the TX_STA_FIFO_VALID
-	 * flag is not set anymore.
-	 *
-	 * The legacy drivers use X=TX_RING_SIZE but state in a comment
-	 * that the TX_STA_FIFO stack has a size of 16. We stick to our
-	 * tx ring size for now.
-	 */
-	for (i = 0; i < TX_ENTRIES; i++) {
-		rt2800_register_read(rt2x00dev, TX_STA_FIFO, &reg);
-		if (!rt2x00_get_field32(reg, TX_STA_FIFO_VALID))
-			break;
-
-		wcid    = rt2x00_get_field32(reg, TX_STA_FIFO_WCID);
-		ack     = rt2x00_get_field32(reg, TX_STA_FIFO_TX_ACK_REQUIRED);
-		pid     = rt2x00_get_field32(reg, TX_STA_FIFO_PID_TYPE);
-
-		/*
-		 * Skip this entry when it contains an invalid
-		 * queue identication number.
-		 */
-		if (pid <= 0 || pid > QID_RX)
-			continue;
-
-		queue = rt2x00queue_get_queue(rt2x00dev, pid - 1);
-		if (unlikely(!queue))
-			continue;
-
-		/*
-		 * Inside each queue, we process each entry in a chronological
-		 * order. We first check that the queue is not empty.
-		 */
-		if (rt2x00queue_empty(queue))
-			continue;
-		entry = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
-
-		/* Check if we got a match by looking at WCID/ACK/PID
-		 * fields */
-		txwi = (__le32 *) entry->skb->data;
-
-		rt2x00_desc_read(txwi, 1, &word);
-		tx_wcid = rt2x00_get_field32(word, TXWI_W1_WIRELESS_CLI_ID);
-		tx_ack  = rt2x00_get_field32(word, TXWI_W1_ACK);
-		tx_pid  = rt2x00_get_field32(word, TXWI_W1_PACKETID);
-
-		if ((wcid != tx_wcid) || (ack != tx_ack) || (pid != tx_pid))
-			WARNING(rt2x00dev, "invalid TX_STA_FIFO content\n");
-
-		/*
-		 * Obtain the status about this packet.
-		 */
-		txdesc.flags = 0;
-		rt2x00_desc_read(txwi, 0, &word);
-		mcs = rt2x00_get_field32(word, TXWI_W0_MCS);
-		real_mcs = rt2x00_get_field32(reg, TX_STA_FIFO_MCS);
-
-		/*
-		 * Ralink has a retry mechanism using a global fallback
-		 * table. We setup this fallback table to try the immediate
-		 * lower rate for all rates. In the TX_STA_FIFO, the MCS field
-		 * always contains the MCS used for the last transmission, be
-		 * it successful or not.
-		 */
-		if (rt2x00_get_field32(reg, TX_STA_FIFO_TX_SUCCESS)) {
-			/*
-			 * Transmission succeeded. The number of retries is
-			 * mcs - real_mcs
-			 */
-			__set_bit(TXDONE_SUCCESS, &txdesc.flags);
-			txdesc.retry = ((mcs > real_mcs) ? mcs - real_mcs : 0);
-		} else {
-			/*
-			 * Transmission failed. The number of retries is
-			 * always 7 in this case (for a total number of 8
-			 * frames sent).
-			 */
-			__set_bit(TXDONE_FAILURE, &txdesc.flags);
-			txdesc.retry = 7;
-		}
-
-		/*
-		 * the frame was retried at least once
-		 * -> hw used fallback rates
-		 */
-		if (txdesc.retry)
-			__set_bit(TXDONE_FALLBACK, &txdesc.flags);
-
-		rt2x00lib_txdone(entry, &txdesc);
-	}
-}
-
 static void rt2800pci_wakeup(struct rt2x00_dev *rt2x00dev)
 {
 	struct ieee80211_conf conf = { .flags = 0 };
@@ -863,7 +759,7 @@ static irqreturn_t rt2800pci_interrupt_thread(int irq, void *dev_instance)
 	 * 4 - Tx done interrupt.
 	 */
 	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_TX_FIFO_STATUS))
-		rt2800pci_txdone(rt2x00dev);
+		rt2800_txdone(rt2x00dev);
 
 	/*
 	 * 5 - Auto wakeup interrupt.
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 9084b9a..9ad28be 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1,5 +1,6 @@
 /*
-	Copyright (C) 2009 Ivo van Doorn <IvDoorn@gmail.com>
+	Copyright (C) 2010 Willow Garage <http://www.willowgarage.com>
+	Copyright (C) 2009 - 2010 Ivo van Doorn <IvDoorn@gmail.com>
 	Copyright (C) 2009 Mattias Nissler <mattias.nissler@gmx.de>
 	Copyright (C) 2009 Felix Fietkau <nbd@openwrt.org>
 	Copyright (C) 2009 Xose Vazquez Perez <xose.vazquez@gmail.com>
@@ -378,6 +379,38 @@ static int rt2800usb_get_tx_data_len(struct queue_entry *entry)
 }
 
 /*
+ * TX control handlers
+ */
+static void rt2800usb_work_txdone(struct work_struct *work)
+{
+	struct rt2x00_dev *rt2x00dev =
+	    container_of(work, struct rt2x00_dev, txdone_work);
+	struct data_queue *queue;
+	struct queue_entry *entry;
+
+	rt2800_txdone(rt2x00dev);
+
+	/*
+	 * Process any trailing TX status reports for IO failures,
+	 * we loop until we find the first non-IO error entry. This
+	 * can either be a frame which is free, is being uploaded,
+	 * or has completed the upload but didn't have an entry
+	 * in the TX_STAT_FIFO register yet.
+	 */
+	tx_queue_for_each(rt2x00dev, queue) {
+		while (!rt2x00queue_empty(queue)) {
+			entry = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
+
+			if (test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags) ||
+			    !test_bit(ENTRY_DATA_IO_FAILED, &entry->flags))
+				break;
+
+			rt2x00lib_txdone_noinfo(entry, TXDONE_FAILURE);
+		}
+	}
+}
+
+/*
  * RX control handlers
  */
 static void rt2800usb_fill_rxdone(struct queue_entry *entry,
@@ -513,6 +546,11 @@ static int rt2800usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 	 */
 	rt2x00dev->rssi_offset = DEFAULT_RSSI_OFFSET;
 
+	/*
+	 * Overwrite TX done handler
+	 */
+	PREPARE_WORK(&rt2x00dev->txdone_work, rt2800usb_work_txdone);
+
 	return 0;
 }
 
-- 
1.7.2

