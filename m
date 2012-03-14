Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760447Ab2CNKSo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2012 06:18:44 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 2/5] rt2x00: rt2800usb: rework txdone code
Date: Wed, 14 Mar 2012 11:16:18 +0100
Message-Id: <1331720181-18564-2-git-send-email-sgruszka@redhat.com> (sfid-20120314_111848_533663_9DC0B2A3)
In-Reply-To: <1331720181-18564-1-git-send-email-sgruszka@redhat.com>
References: <1331720181-18564-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch change txdone code to make it similar like txdone in rt2800pci,
process only one entry from queue matching tx status.

Before we processed all pending entries from queue until PACKEDID match,
that caused that we do not report tx statuses correctly.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |   72 +++++++++++++-----------------
 1 files changed, 31 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 8e1855a..4eaa628 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -438,35 +438,25 @@ static int rt2800usb_get_tx_data_len(struct queue_entry *entry)
 /*
  * TX control handlers
  */
-static bool rt2800usb_txdone_entry_check(struct queue_entry *entry, u32 reg)
+static enum txdone_entry_desc_flags
+rt2800usb_txdone_entry_check(struct queue_entry *entry, u32 reg)
 {
 	__le32 *txwi;
 	u32 word;
 	int wcid, ack, pid;
 	int tx_wcid, tx_ack, tx_pid;
 
-	if (test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags) ||
-	    !test_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags)) {
-		WARNING(entry->queue->rt2x00dev,
-			"Data pending for entry %u in queue %u\n",
-			entry->entry_idx, entry->queue->qid);
-		cond_resched();
-		return false;
-	}
-
-	wcid	= rt2x00_get_field32(reg, TX_STA_FIFO_WCID);
-	ack	= rt2x00_get_field32(reg, TX_STA_FIFO_TX_ACK_REQUIRED);
-	pid	= rt2x00_get_field32(reg, TX_STA_FIFO_PID_TYPE);
-
 	/*
 	 * This frames has returned with an IO error,
 	 * so the status report is not intended for this
 	 * frame.
 	 */
-	if (test_bit(ENTRY_DATA_IO_FAILED, &entry->flags)) {
-		rt2x00lib_txdone_noinfo(entry, TXDONE_FAILURE);
-		return false;
-	}
+	if (test_bit(ENTRY_DATA_IO_FAILED, &entry->flags))
+		return TXDONE_FAILURE;
+
+	wcid	= rt2x00_get_field32(reg, TX_STA_FIFO_WCID);
+	ack	= rt2x00_get_field32(reg, TX_STA_FIFO_TX_ACK_REQUIRED);
+	pid	= rt2x00_get_field32(reg, TX_STA_FIFO_PID_TYPE);
 
 	/*
 	 * Validate if this TX status report is intended for
@@ -482,12 +472,11 @@ static bool rt2800usb_txdone_entry_check(struct queue_entry *entry, u32 reg)
 	if ((wcid != tx_wcid) || (ack != tx_ack) || (pid != tx_pid)) {
 		WARNING(entry->queue->rt2x00dev,
 			"TX status report missed for queue %d entry %d\n",
-		entry->queue->qid, entry->entry_idx);
-		rt2x00lib_txdone_noinfo(entry, TXDONE_UNKNOWN);
-		return false;
+			entry->queue->qid, entry->entry_idx);
+		return TXDONE_UNKNOWN;
 	}
 
-	return true;
+	return TXDONE_SUCCESS;
 }
 
 static void rt2800usb_txdone(struct rt2x00_dev *rt2x00dev)
@@ -496,35 +485,36 @@ static void rt2800usb_txdone(struct rt2x00_dev *rt2x00dev)
 	struct queue_entry *entry;
 	u32 reg;
 	u8 qid;
+	enum txdone_entry_desc_flags done_status;
 
 	while (kfifo_get(&rt2x00dev->txstatus_fifo, &reg)) {
-
-		/* TX_STA_FIFO_PID_QUEUE is a 2-bit field, thus
-		 * qid is guaranteed to be one of the TX QIDs
+		/*
+		 * TX_STA_FIFO_PID_QUEUE is a 2-bit field, thus qid is
+		 * guaranteed to be one of the TX QIDs .
 		 */
 		qid = rt2x00_get_field32(reg, TX_STA_FIFO_PID_QUEUE);
 		queue = rt2x00queue_get_tx_queue(rt2x00dev, qid);
-		if (unlikely(!queue)) {
-			WARNING(rt2x00dev, "Got TX status for an unavailable "
+
+		if (unlikely(rt2x00queue_empty(queue))) {
+			WARNING(rt2x00dev, "Got TX status for an empty "
 					   "queue %u, dropping\n", qid);
-			continue;
+			break;
 		}
 
-		/*
-		 * Inside each queue, we process each entry in a chronological
-		 * order. We first check that the queue is not empty.
-		 */
-		entry = NULL;
-		while (!rt2x00queue_empty(queue)) {
-			entry = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
-			if (rt2800usb_txdone_entry_check(entry, reg))
-				break;
-			entry = NULL;
+		entry = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
+
+		if (unlikely(test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags) ||
+			     !test_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags))) {
+			WARNING(rt2x00dev, "Data pending for entry %u "
+					   "in queue %u\n", entry->entry_idx, qid);
+			break;
 		}
 
-		if (entry)
-			rt2800_txdone_entry(entry, reg,
-					    rt2800usb_get_txwi(entry));
+		done_status = rt2800usb_txdone_entry_check(entry, reg);
+		if (likely(done_status == TXDONE_SUCCESS))
+			rt2800_txdone_entry(entry, reg, rt2800usb_get_txwi(entry));
+		else
+			rt2x00lib_txdone_noinfo(entry, done_status);
 	}
 }
 
-- 
1.7.1

