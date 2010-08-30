Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42497 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab0H3TQ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Aug 2010 15:16:28 -0400
Received: by mail-ey0-f174.google.com with SMTP id 5so3422616eyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Aug 2010 12:16:28 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 04/10] rt2x00: Validate TX status results with current data entry
Date: Mon, 30 Aug 2010 21:13:30 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201008302112.25578.IvDoorn@gmail.com> <201008302112.48658.IvDoorn@gmail.com> <201008302113.09605.IvDoorn@gmail.com>
In-Reply-To: <201008302113.09605.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201008302113.31006.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of printing a warning when the PID, ACK, or WCID of
an entry don't match the TX status report, we should skip the
entry to search for the entry which actually does match
the TX status data.

This reduces the number of watchdog errors on the TX queues
for rt2800usb, and seems to improve the reliability of the
TX flow a bit.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   73 +++++++++++++++++++++----------
 1 files changed, 50 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 967f3e5..c8af221 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -581,6 +581,49 @@ void rt2800_process_rxwi(struct queue_entry *entry,
 }
 EXPORT_SYMBOL_GPL(rt2800_process_rxwi);
 
+static bool rt2800_txdone_entry_check(struct queue_entry *entry, u32 reg)
+{
+	__le32 *txwi;
+	u32 word;
+	int wcid, ack, pid;
+	int tx_wcid, tx_ack, tx_pid;
+
+	wcid	= rt2x00_get_field32(reg, TX_STA_FIFO_WCID);
+	ack	= rt2x00_get_field32(reg, TX_STA_FIFO_TX_ACK_REQUIRED);
+	pid	= rt2x00_get_field32(reg, TX_STA_FIFO_PID_TYPE);
+
+	/*
+	 * This frames has returned with an IO error,
+	 * so the status report is not intended for this
+	 * frame.
+	 */
+	if (test_bit(ENTRY_DATA_IO_FAILED, &entry->flags)) {
+		rt2x00lib_txdone_noinfo(entry, TXDONE_FAILURE);
+		return false;
+	}
+
+	/*
+	 * Validate if this TX status report is intended for
+	 * this entry by comparing the WCID/ACK/PID fields.
+	 */
+	txwi = rt2800_drv_get_txwi(entry);
+
+	rt2x00_desc_read(txwi, 1, &word);
+	tx_wcid = rt2x00_get_field32(word, TXWI_W1_WIRELESS_CLI_ID);
+	tx_ack  = rt2x00_get_field32(word, TXWI_W1_ACK);
+	tx_pid  = rt2x00_get_field32(word, TXWI_W1_PACKETID);
+
+	if ((wcid != tx_wcid) || (ack != tx_ack) || (pid != tx_pid)) {
+		WARNING(entry->queue->rt2x00dev,
+			"TX status report missed for queue %d entry %d\n",
+		entry->queue->qid, entry->entry_idx);
+		rt2x00lib_txdone_noinfo(entry, TXDONE_UNKNOWN);
+		return false;
+	}
+
+	return true;
+}
+
 void rt2800_txdone(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_queue *queue;
@@ -589,8 +632,8 @@ void rt2800_txdone(struct rt2x00_dev *rt2x00dev)
 	struct txdone_entry_desc txdesc;
 	u32 word;
 	u32 reg;
-	int wcid, ack, pid, tx_wcid, tx_ack, tx_pid;
 	u16 mcs, real_mcs;
+	u8 pid;
 	int i;
 
 	/*
@@ -607,18 +650,15 @@ void rt2800_txdone(struct rt2x00_dev *rt2x00dev)
 		if (!rt2x00_get_field32(reg, TX_STA_FIFO_VALID))
 			break;
 
-		wcid	= rt2x00_get_field32(reg, TX_STA_FIFO_WCID);
-		ack	= rt2x00_get_field32(reg, TX_STA_FIFO_TX_ACK_REQUIRED);
-		pid	= rt2x00_get_field32(reg, TX_STA_FIFO_PID_TYPE);
-
 		/*
 		 * Skip this entry when it contains an invalid
 		 * queue identication number.
 		 */
-		if (pid <= 0 || pid > QID_RX)
+		pid = rt2x00_get_field32(reg, TX_STA_FIFO_PID_TYPE) - 1;
+		if (pid >= QID_RX)
 			continue;
 
-		queue = rt2x00queue_get_queue(rt2x00dev, pid - 1);
+		queue = rt2x00queue_get_queue(rt2x00dev, pid);
 		if (unlikely(!queue))
 			continue;
 
@@ -627,35 +667,22 @@ void rt2800_txdone(struct rt2x00_dev *rt2x00dev)
 		 * order. We first check that the queue is not empty.
 		 */
 		entry = NULL;
+		txwi = NULL;
 		while (!rt2x00queue_empty(queue)) {
 			entry = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
-			if (!test_bit(ENTRY_DATA_IO_FAILED, &entry->flags))
+			if (rt2800_txdone_entry_check(entry, reg))
 				break;
-
-			rt2x00lib_txdone_noinfo(entry, TXDONE_FAILURE);
 		}
 
 		if (!entry || rt2x00queue_empty(queue))
 			break;
 
-		/*
-		 * Check if we got a match by looking at WCID/ACK/PID
-		 * fields
-		 */
-		txwi = rt2800_drv_get_txwi(entry);
-
-		rt2x00_desc_read(txwi, 1, &word);
-		tx_wcid	= rt2x00_get_field32(word, TXWI_W1_WIRELESS_CLI_ID);
-		tx_ack	= rt2x00_get_field32(word, TXWI_W1_ACK);
-		tx_pid	= rt2x00_get_field32(word, TXWI_W1_PACKETID);
-
-		if ((wcid != tx_wcid) || (ack != tx_ack) || (pid != tx_pid))
-			WARNING(rt2x00dev, "invalid TX_STA_FIFO content");
 
 		/*
 		 * Obtain the status about this packet.
 		 */
 		txdesc.flags = 0;
+		txwi = rt2800_drv_get_txwi(entry);
 		rt2x00_desc_read(txwi, 0, &word);
 		mcs = rt2x00_get_field32(word, TXWI_W0_MCS);
 		real_mcs = rt2x00_get_field32(reg, TX_STA_FIFO_MCS);
-- 
1.7.2.2

