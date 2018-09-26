Return-Path: <SRS0=mZ/2=MI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0335C43382
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 10:25:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6576A214DC
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 10:25:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6576A214DC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727380AbeIZQhS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Sep 2018 12:37:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49664 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726602AbeIZQhS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Sep 2018 12:37:18 -0400
Received: from smtp.corp.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.26])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9B718307D97F;
        Wed, 26 Sep 2018 10:25:02 +0000 (UTC)
Received: from localhost (ovpn-204-192.brq.redhat.com [10.40.204.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2786E3001658;
        Wed, 26 Sep 2018 10:25:01 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Daniel Golle <daniel@makrotopia.org>,
        Mathias Kresin <dev@kresin.me>, Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 2/5] rt2800mmio: use txdone/txstatus routines from lib
Date:   Wed, 26 Sep 2018 12:24:54 +0200
Message-Id: <1537957497-7790-3-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1537957497-7790-1-git-send-email-sgruszka@redhat.com>
References: <1537957497-7790-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.26
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Wed, 26 Sep 2018 10:25:02 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use usb txdone/txstatus routines (now in rt2800libc) for mmio devices.

Note this also change how we handle INT_SOURCE_CSR_TX_FIFO_STATUS
interrupt. Now it is disabled since IRQ routine till end of the txstatus
tasklet (the same behaviour like others interrupts). Reason to do not
disable this interrupt was not to miss any tx status from 16 entries
FIFO register. Now, since we check for tx status timeout, we can
allow to miss some tx statuses. However this will be improved in further
patch where I also implement read status FIFO register in the tasklet.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800mmio.c  | 180 +----------------------
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.c |   1 +
 2 files changed, 9 insertions(+), 172 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c b/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
index e1a7ed7e4892..aa8449a5e8fe 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
@@ -175,161 +175,6 @@ static void rt2800mmio_wakeup(struct rt2x00_dev *rt2x00dev)
 	rt2800_config(rt2x00dev, &libconf, IEEE80211_CONF_CHANGE_PS);
 }
 
-static bool rt2800mmio_txdone_entry_check(struct queue_entry *entry, u32 status)
-{
-	__le32 *txwi;
-	u32 word;
-	int wcid, tx_wcid;
-
-	wcid = rt2x00_get_field32(status, TX_STA_FIFO_WCID);
-
-	txwi = rt2800_drv_get_txwi(entry);
-	word = rt2x00_desc_read(txwi, 1);
-	tx_wcid = rt2x00_get_field32(word, TXWI_W1_WIRELESS_CLI_ID);
-
-	return (tx_wcid == wcid);
-}
-
-static bool rt2800mmio_txdone_find_entry(struct queue_entry *entry, void *data)
-{
-	u32 status = *(u32 *)data;
-
-	/*
-	 * rt2800pci hardware might reorder frames when exchanging traffic
-	 * with multiple BA enabled STAs.
-	 *
-	 * For example, a tx queue
-	 *    [ STA1 | STA2 | STA1 | STA2 ]
-	 * can result in tx status reports
-	 *    [ STA1 | STA1 | STA2 | STA2 ]
-	 * when the hw decides to aggregate the frames for STA1 into one AMPDU.
-	 *
-	 * To mitigate this effect, associate the tx status to the first frame
-	 * in the tx queue with a matching wcid.
-	 */
-	if (rt2800mmio_txdone_entry_check(entry, status) &&
-	    !test_bit(ENTRY_DATA_STATUS_SET, &entry->flags)) {
-		/*
-		 * Got a matching frame, associate the tx status with
-		 * the frame
-		 */
-		entry->status = status;
-		set_bit(ENTRY_DATA_STATUS_SET, &entry->flags);
-		return true;
-	}
-
-	/* Check the next frame */
-	return false;
-}
-
-static bool rt2800mmio_txdone_match_first(struct queue_entry *entry, void *data)
-{
-	u32 status = *(u32 *)data;
-
-	/*
-	 * Find the first frame without tx status and assign this status to it
-	 * regardless if it matches or not.
-	 */
-	if (!test_bit(ENTRY_DATA_STATUS_SET, &entry->flags)) {
-		/*
-		 * Got a matching frame, associate the tx status with
-		 * the frame
-		 */
-		entry->status = status;
-		set_bit(ENTRY_DATA_STATUS_SET, &entry->flags);
-		return true;
-	}
-
-	/* Check the next frame */
-	return false;
-}
-static bool rt2800mmio_txdone_release_entries(struct queue_entry *entry,
-					      void *data)
-{
-	if (test_bit(ENTRY_DATA_STATUS_SET, &entry->flags)) {
-		rt2800_txdone_entry(entry, entry->status,
-				    rt2800mmio_get_txwi(entry), true);
-		return false;
-	}
-
-	/* No more frames to release */
-	return true;
-}
-
-static bool rt2800mmio_txdone(struct rt2x00_dev *rt2x00dev)
-{
-	struct data_queue *queue;
-	u32 status;
-	u8 qid;
-	int max_tx_done = 16;
-
-	while (kfifo_get(&rt2x00dev->txstatus_fifo, &status)) {
-		qid = rt2x00_get_field32(status, TX_STA_FIFO_PID_QUEUE);
-		if (unlikely(qid >= QID_RX)) {
-			/*
-			 * Unknown queue, this shouldn't happen. Just drop
-			 * this tx status.
-			 */
-			rt2x00_warn(rt2x00dev, "Got TX status report with unexpected pid %u, dropping\n",
-				    qid);
-			break;
-		}
-
-		queue = rt2x00queue_get_tx_queue(rt2x00dev, qid);
-		if (unlikely(queue == NULL)) {
-			/*
-			 * The queue is NULL, this shouldn't happen. Stop
-			 * processing here and drop the tx status
-			 */
-			rt2x00_warn(rt2x00dev, "Got TX status for an unavailable queue %u, dropping\n",
-				    qid);
-			break;
-		}
-
-		if (unlikely(rt2x00queue_empty(queue))) {
-			/*
-			 * The queue is empty. Stop processing here
-			 * and drop the tx status.
-			 */
-			rt2x00_warn(rt2x00dev, "Got TX status for an empty queue %u, dropping\n",
-				    qid);
-			break;
-		}
-
-		/*
-		 * Let's associate this tx status with the first
-		 * matching frame.
-		 */
-		if (!rt2x00queue_for_each_entry(queue, Q_INDEX_DONE,
-						Q_INDEX, &status,
-						rt2800mmio_txdone_find_entry)) {
-			/*
-			 * We cannot match the tx status to any frame, so just
-			 * use the first one.
-			 */
-			if (!rt2x00queue_for_each_entry(queue, Q_INDEX_DONE,
-							Q_INDEX, &status,
-							rt2800mmio_txdone_match_first)) {
-				rt2x00_warn(rt2x00dev, "No frame found for TX status on queue %u, dropping\n",
-					    qid);
-				break;
-			}
-		}
-
-		/*
-		 * Release all frames with a valid tx status.
-		 */
-		rt2x00queue_for_each_entry(queue, Q_INDEX_DONE,
-					   Q_INDEX, NULL,
-					   rt2800mmio_txdone_release_entries);
-
-		if (--max_tx_done == 0)
-			break;
-	}
-
-	return !max_tx_done;
-}
-
 static inline void rt2800mmio_enable_interrupt(struct rt2x00_dev *rt2x00dev,
 					       struct rt2x00_field32 irq_field)
 {
@@ -349,14 +194,14 @@ static inline void rt2800mmio_enable_interrupt(struct rt2x00_dev *rt2x00dev,
 void rt2800mmio_txstatus_tasklet(unsigned long data)
 {
 	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
-	if (rt2800mmio_txdone(rt2x00dev))
-		tasklet_schedule(&rt2x00dev->txstatus_tasklet);
 
-	/*
-	 * No need to enable the tx status interrupt here as we always
-	 * leave it enabled to minimize the possibility of a tx status
-	 * register overflow. See comment in interrupt handler.
-	 */
+	rt2800_txdone(rt2x00dev);
+
+	rt2800_txdone_nostatus(rt2x00dev);
+
+	if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
+		rt2800mmio_enable_interrupt(rt2x00dev,
+					    INT_SOURCE_CSR_TX_FIFO_STATUS);
 }
 EXPORT_SYMBOL_GPL(rt2800mmio_txstatus_tasklet);
 
@@ -440,10 +285,6 @@ static void rt2800mmio_txstatus_interrupt(struct rt2x00_dev *rt2x00dev)
 	 * because we can schedule the tasklet multiple times (when the
 	 * interrupt fires again during tx status processing).
 	 *
-	 * Furthermore we don't disable the TX_FIFO_STATUS
-	 * interrupt here but leave it enabled so that the TX_STA_FIFO
-	 * can also be read while the tx status tasklet gets executed.
-	 *
 	 * Since we have only one producer and one consumer we don't
 	 * need to lock the kfifo.
 	 */
@@ -485,13 +326,8 @@ irqreturn_t rt2800mmio_interrupt(int irq, void *dev_instance)
 	 */
 	mask = ~reg;
 
-	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_TX_FIFO_STATUS)) {
+	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_TX_FIFO_STATUS))
 		rt2800mmio_txstatus_interrupt(rt2x00dev);
-		/*
-		 * Never disable the TX_FIFO_STATUS interrupt.
-		 */
-		rt2x00_set_field32(&mask, INT_MASK_CSR_TX_FIFO_STATUS, 1);
-	}
 
 	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_PRE_TBTT))
 		tasklet_hi_schedule(&rt2x00dev->pretbtt_tasklet);
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
index 710e9641552e..6e8beb7ea350 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
@@ -113,6 +113,7 @@ int rt2x00queue_map_txskb(struct queue_entry *entry)
 		return -ENOMEM;
 
 	skbdesc->flags |= SKBDESC_DMA_MAPPED_TX;
+	rt2x00lib_dmadone(entry);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(rt2x00queue_map_txskb);
-- 
2.7.5

