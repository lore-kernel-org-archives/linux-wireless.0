Return-Path: <SRS0=mZ/2=MI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57EEAC43382
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 10:25:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04846214DC
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 10:25:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 04846214DC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbeIZQhQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Sep 2018 12:37:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10488 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726602AbeIZQhQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Sep 2018 12:37:16 -0400
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.25])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D9A4130BB53A;
        Wed, 26 Sep 2018 10:25:00 +0000 (UTC)
Received: from localhost (ovpn-204-192.brq.redhat.com [10.40.204.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3FBD62010DB8;
        Wed, 26 Sep 2018 10:25:00 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Daniel Golle <daniel@makrotopia.org>,
        Mathias Kresin <dev@kresin.me>, Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 1/5] rt2800: move usb specific txdone/txstatus routines to rt2800lib
Date:   Wed, 26 Sep 2018 12:24:53 +0200
Message-Id: <1537957497-7790-2-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1537957497-7790-1-git-send-email-sgruszka@redhat.com>
References: <1537957497-7790-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.25
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Wed, 26 Sep 2018 10:25:01 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In order to reuse usb txdone/txstatus routines for mmio, move them
to common rt2800lib.c file.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 138 ++++++++++++++++++++++++
 drivers/net/wireless/ralink/rt2x00/rt2800lib.h |   3 +
 drivers/net/wireless/ralink/rt2x00/rt2800usb.c | 143 +------------------------
 3 files changed, 145 insertions(+), 139 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index a567bc273ffc..9f2835729016 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -957,6 +957,47 @@ static void rt2800_rate_from_status(struct skb_frame_desc *skbdesc,
 	skbdesc->tx_rate_flags = flags;
 }
 
+static bool rt2800_txdone_entry_check(struct queue_entry *entry, u32 reg)
+{
+	__le32 *txwi;
+	u32 word;
+	int wcid, ack, pid;
+	int tx_wcid, tx_ack, tx_pid, is_agg;
+
+	/*
+	 * This frames has returned with an IO error,
+	 * so the status report is not intended for this
+	 * frame.
+	 */
+	if (test_bit(ENTRY_DATA_IO_FAILED, &entry->flags))
+		return false;
+
+	wcid	= rt2x00_get_field32(reg, TX_STA_FIFO_WCID);
+	ack	= rt2x00_get_field32(reg, TX_STA_FIFO_TX_ACK_REQUIRED);
+	pid	= rt2x00_get_field32(reg, TX_STA_FIFO_PID_TYPE);
+	is_agg	= rt2x00_get_field32(reg, TX_STA_FIFO_TX_AGGRE);
+
+	/*
+	 * Validate if this TX status report is intended for
+	 * this entry by comparing the WCID/ACK/PID fields.
+	 */
+	txwi = rt2800_drv_get_txwi(entry);
+
+	word = rt2x00_desc_read(txwi, 1);
+	tx_wcid = rt2x00_get_field32(word, TXWI_W1_WIRELESS_CLI_ID);
+	tx_ack  = rt2x00_get_field32(word, TXWI_W1_ACK);
+	tx_pid  = rt2x00_get_field32(word, TXWI_W1_PACKETID);
+
+	if (wcid != tx_wcid || ack != tx_ack || (!is_agg && pid != tx_pid)) {
+		rt2x00_dbg(entry->queue->rt2x00dev,
+			   "TX status report missed for queue %d entry %d\n",
+			   entry->queue->qid, entry->entry_idx);
+		return false;
+	}
+
+	return true;
+}
+
 void rt2800_txdone_entry(struct queue_entry *entry, u32 status, __le32 *txwi,
 			 bool match)
 {
@@ -1059,6 +1100,103 @@ void rt2800_txdone_entry(struct queue_entry *entry, u32 status, __le32 *txwi,
 }
 EXPORT_SYMBOL_GPL(rt2800_txdone_entry);
 
+void rt2800_txdone(struct rt2x00_dev *rt2x00dev)
+{
+	struct data_queue *queue;
+	struct queue_entry *entry;
+	u32 reg;
+	u8 qid;
+	bool match;
+
+	while (kfifo_get(&rt2x00dev->txstatus_fifo, &reg)) {
+		/*
+		 * TX_STA_FIFO_PID_QUEUE is a 2-bit field, thus qid is
+		 * guaranteed to be one of the TX QIDs .
+		 */
+		qid = rt2x00_get_field32(reg, TX_STA_FIFO_PID_QUEUE);
+		queue = rt2x00queue_get_tx_queue(rt2x00dev, qid);
+
+		if (unlikely(rt2x00queue_empty(queue))) {
+			rt2x00_dbg(rt2x00dev, "Got TX status for an empty queue %u, dropping\n",
+				   qid);
+			break;
+		}
+
+		entry = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
+
+		if (unlikely(test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags) ||
+			     !test_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags))) {
+			rt2x00_warn(rt2x00dev, "Data pending for entry %u in queue %u\n",
+				    entry->entry_idx, qid);
+			break;
+		}
+
+		match = rt2800_txdone_entry_check(entry, reg);
+		rt2800_txdone_entry(entry, reg, rt2800_drv_get_txwi(entry), match);
+	}
+}
+EXPORT_SYMBOL_GPL(rt2800_txdone);
+
+static inline bool rt2800_entry_txstatus_timeout(struct queue_entry *entry)
+{
+	bool tout;
+
+	if (!test_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags))
+		return false;
+
+	tout = time_after(jiffies, entry->last_action + msecs_to_jiffies(500));
+	if (unlikely(tout))
+		rt2x00_dbg(entry->queue->rt2x00dev,
+			   "TX status timeout for entry %d in queue %d\n",
+			   entry->entry_idx, entry->queue->qid);
+	return tout;
+
+}
+
+bool rt2800_txstatus_timeout(struct rt2x00_dev *rt2x00dev)
+{
+	struct data_queue *queue;
+	struct queue_entry *entry;
+
+	tx_queue_for_each(rt2x00dev, queue) {
+		entry = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
+		if (rt2800_entry_txstatus_timeout(entry))
+			return true;
+	}
+	return false;
+}
+EXPORT_SYMBOL_GPL(rt2800_txstatus_timeout);
+
+void rt2800_txdone_nostatus(struct rt2x00_dev *rt2x00dev)
+{
+	struct data_queue *queue;
+	struct queue_entry *entry;
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
+			    !test_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags))
+				break;
+
+			if (test_bit(ENTRY_DATA_IO_FAILED, &entry->flags) ||
+			    rt2800_entry_txstatus_timeout(entry))
+				rt2x00lib_txdone_noinfo(entry, TXDONE_FAILURE);
+			else
+				break;
+		}
+	}
+}
+EXPORT_SYMBOL_GPL(rt2800_txdone_nostatus);
+
 static unsigned int rt2800_hw_beacon_base(struct rt2x00_dev *rt2x00dev,
 					  unsigned int index)
 {
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.h b/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
index 51d9c2a932cc..0dff2c7b3010 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
@@ -195,6 +195,9 @@ void rt2800_process_rxwi(struct queue_entry *entry, struct rxdone_entry_desc *tx
 
 void rt2800_txdone_entry(struct queue_entry *entry, u32 status, __le32 *txwi,
 			 bool match);
+void rt2800_txdone(struct rt2x00_dev *rt2x00dev);
+void rt2800_txdone_nostatus(struct rt2x00_dev *rt2x00dev);
+bool rt2800_txstatus_timeout(struct rt2x00_dev *rt2x00dev);
 
 void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc);
 void rt2800_clear_beacon(struct queue_entry *entry);
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
index 98a7313fea4a..19eabf16147b 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
@@ -116,35 +116,6 @@ static bool rt2800usb_txstatus_pending(struct rt2x00_dev *rt2x00dev)
 	return false;
 }
 
-static inline bool rt2800usb_entry_txstatus_timeout(struct queue_entry *entry)
-{
-	bool tout;
-
-	if (!test_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags))
-		return false;
-
-	tout = time_after(jiffies, entry->last_action + msecs_to_jiffies(500));
-	if (unlikely(tout))
-		rt2x00_dbg(entry->queue->rt2x00dev,
-			   "TX status timeout for entry %d in queue %d\n",
-			   entry->entry_idx, entry->queue->qid);
-	return tout;
-
-}
-
-static bool rt2800usb_txstatus_timeout(struct rt2x00_dev *rt2x00dev)
-{
-	struct data_queue *queue;
-	struct queue_entry *entry;
-
-	tx_queue_for_each(rt2x00dev, queue) {
-		entry = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
-		if (rt2800usb_entry_txstatus_timeout(entry))
-			return true;
-	}
-	return false;
-}
-
 #define TXSTATUS_READ_INTERVAL 1000000
 
 static bool rt2800usb_tx_sta_fifo_read_completed(struct rt2x00_dev *rt2x00dev,
@@ -171,7 +142,7 @@ static bool rt2800usb_tx_sta_fifo_read_completed(struct rt2x00_dev *rt2x00dev,
 	}
 
 	/* Check if there is any entry that timedout waiting on TX status */
-	if (rt2800usb_txstatus_timeout(rt2x00dev))
+	if (rt2800_txstatus_timeout(rt2x00dev))
 		queue_work(rt2x00dev->workqueue, &rt2x00dev->txdone_work);
 
 	if (rt2800usb_txstatus_pending(rt2x00dev)) {
@@ -501,123 +472,17 @@ static int rt2800usb_get_tx_data_len(struct queue_entry *entry)
 /*
  * TX control handlers
  */
-static bool rt2800usb_txdone_entry_check(struct queue_entry *entry, u32 reg)
-{
-	__le32 *txwi;
-	u32 word;
-	int wcid, ack, pid;
-	int tx_wcid, tx_ack, tx_pid, is_agg;
-
-	/*
-	 * This frames has returned with an IO error,
-	 * so the status report is not intended for this
-	 * frame.
-	 */
-	if (test_bit(ENTRY_DATA_IO_FAILED, &entry->flags))
-		return false;
-
-	wcid	= rt2x00_get_field32(reg, TX_STA_FIFO_WCID);
-	ack	= rt2x00_get_field32(reg, TX_STA_FIFO_TX_ACK_REQUIRED);
-	pid	= rt2x00_get_field32(reg, TX_STA_FIFO_PID_TYPE);
-	is_agg	= rt2x00_get_field32(reg, TX_STA_FIFO_TX_AGGRE);
-
-	/*
-	 * Validate if this TX status report is intended for
-	 * this entry by comparing the WCID/ACK/PID fields.
-	 */
-	txwi = rt2800usb_get_txwi(entry);
-
-	word = rt2x00_desc_read(txwi, 1);
-	tx_wcid = rt2x00_get_field32(word, TXWI_W1_WIRELESS_CLI_ID);
-	tx_ack  = rt2x00_get_field32(word, TXWI_W1_ACK);
-	tx_pid  = rt2x00_get_field32(word, TXWI_W1_PACKETID);
-
-	if (wcid != tx_wcid || ack != tx_ack || (!is_agg && pid != tx_pid)) {
-		rt2x00_dbg(entry->queue->rt2x00dev,
-			   "TX status report missed for queue %d entry %d\n",
-			   entry->queue->qid, entry->entry_idx);
-		return false;
-	}
-
-	return true;
-}
-
-static void rt2800usb_txdone(struct rt2x00_dev *rt2x00dev)
-{
-	struct data_queue *queue;
-	struct queue_entry *entry;
-	u32 reg;
-	u8 qid;
-	bool match;
-
-	while (kfifo_get(&rt2x00dev->txstatus_fifo, &reg)) {
-		/*
-		 * TX_STA_FIFO_PID_QUEUE is a 2-bit field, thus qid is
-		 * guaranteed to be one of the TX QIDs .
-		 */
-		qid = rt2x00_get_field32(reg, TX_STA_FIFO_PID_QUEUE);
-		queue = rt2x00queue_get_tx_queue(rt2x00dev, qid);
-
-		if (unlikely(rt2x00queue_empty(queue))) {
-			rt2x00_dbg(rt2x00dev, "Got TX status for an empty queue %u, dropping\n",
-				   qid);
-			break;
-		}
-
-		entry = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
-
-		if (unlikely(test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags) ||
-			     !test_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags))) {
-			rt2x00_warn(rt2x00dev, "Data pending for entry %u in queue %u\n",
-				    entry->entry_idx, qid);
-			break;
-		}
-
-		match = rt2800usb_txdone_entry_check(entry, reg);
-		rt2800_txdone_entry(entry, reg, rt2800usb_get_txwi(entry), match);
-	}
-}
-
-static void rt2800usb_txdone_nostatus(struct rt2x00_dev *rt2x00dev)
-{
-	struct data_queue *queue;
-	struct queue_entry *entry;
-
-	/*
-	 * Process any trailing TX status reports for IO failures,
-	 * we loop until we find the first non-IO error entry. This
-	 * can either be a frame which is free, is being uploaded,
-	 * or has completed the upload but didn't have an entry
-	 * in the TX_STAT_FIFO register yet.
-	 */
-	tx_queue_for_each(rt2x00dev, queue) {
-		while (!rt2x00queue_empty(queue)) {
-			entry = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
-
-			if (test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags) ||
-			    !test_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags))
-				break;
-
-			if (test_bit(ENTRY_DATA_IO_FAILED, &entry->flags) ||
-			    rt2800usb_entry_txstatus_timeout(entry))
-				rt2x00lib_txdone_noinfo(entry, TXDONE_FAILURE);
-			else
-				break;
-		}
-	}
-}
-
 static void rt2800usb_work_txdone(struct work_struct *work)
 {
 	struct rt2x00_dev *rt2x00dev =
 	    container_of(work, struct rt2x00_dev, txdone_work);
 
 	while (!kfifo_is_empty(&rt2x00dev->txstatus_fifo) ||
-	       rt2800usb_txstatus_timeout(rt2x00dev)) {
+	       rt2800_txstatus_timeout(rt2x00dev)) {
 
-		rt2800usb_txdone(rt2x00dev);
+		rt2800_txdone(rt2x00dev);
 
-		rt2800usb_txdone_nostatus(rt2x00dev);
+		rt2800_txdone_nostatus(rt2x00dev);
 
 		/*
 		 * The hw may delay sending the packet after DMA complete
-- 
2.7.5

