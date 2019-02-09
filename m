Return-Path: <SRS0=Ta2d=QQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B8DEC282CB
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 11:08:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 625DF218D2
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 11:08:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbfBILIr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Feb 2019 06:08:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48124 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbfBILIr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Feb 2019 06:08:47 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A2AF8E6A79;
        Sat,  9 Feb 2019 11:08:46 +0000 (UTC)
Received: from localhost (ovpn-204-22.brq.redhat.com [10.40.204.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1DC5A60474;
        Sat,  9 Feb 2019 11:08:45 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Subject: [RFC/RFT 3/8] rt2800: move txstatus pending routine
Date:   Sat,  9 Feb 2019 12:08:33 +0100
Message-Id: <1549710518-15650-4-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1549710518-15650-1-git-send-email-sgruszka@redhat.com>
References: <1549710518-15650-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Sat, 09 Feb 2019 11:08:46 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move rt2800usb_txstatus_pending routine to rt2800lib. It will be reused
by rt2800mmio code.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 17 +++++++++++++++++
 drivers/net/wireless/ralink/rt2x00/rt2800lib.h |  1 +
 drivers/net/wireless/ralink/rt2x00/rt2800usb.c | 22 +++-------------------
 3 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index fdf7813d9be6..745f344521ee 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -1183,6 +1183,23 @@ bool rt2800_txstatus_timeout(struct rt2x00_dev *rt2x00dev)
 }
 EXPORT_SYMBOL_GPL(rt2800_txstatus_timeout);
 
+/*
+ * test if there is an entry in any TX queue for which DMA is done
+ * but the TX status has not been returned yet
+ */
+bool rt2800_txstatus_pending(struct rt2x00_dev *rt2x00dev)
+{
+	struct data_queue *queue;
+
+	tx_queue_for_each(rt2x00dev, queue) {
+		if (rt2x00queue_get_entry(queue, Q_INDEX_DMA_DONE) !=
+		    rt2x00queue_get_entry(queue, Q_INDEX_DONE))
+			return true;
+	}
+	return false;
+}
+EXPORT_SYMBOL_GPL(rt2800_txstatus_pending);
+
 void rt2800_txdone_nostatus(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_queue *queue;
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.h b/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
index 506c319070dd..759eab2b70c3 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
@@ -198,6 +198,7 @@ void rt2800_txdone_entry(struct queue_entry *entry, u32 status, __le32 *txwi,
 void rt2800_txdone(struct rt2x00_dev *rt2x00dev, unsigned int quota);
 void rt2800_txdone_nostatus(struct rt2x00_dev *rt2x00dev);
 bool rt2800_txstatus_timeout(struct rt2x00_dev *rt2x00dev);
+bool rt2800_txstatus_pending(struct rt2x00_dev *rt2x00dev);
 
 void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc);
 void rt2800_clear_beacon(struct queue_entry *entry);
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
index 0bdcab374203..46f2239698a3 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
@@ -100,22 +100,6 @@ static void rt2800usb_stop_queue(struct data_queue *queue)
 	}
 }
 
-/*
- * test if there is an entry in any TX queue for which DMA is done
- * but the TX status has not been returned yet
- */
-static bool rt2800usb_txstatus_pending(struct rt2x00_dev *rt2x00dev)
-{
-	struct data_queue *queue;
-
-	tx_queue_for_each(rt2x00dev, queue) {
-		if (rt2x00queue_get_entry(queue, Q_INDEX_DMA_DONE) !=
-		    rt2x00queue_get_entry(queue, Q_INDEX_DONE))
-			return true;
-	}
-	return false;
-}
-
 #define TXSTATUS_READ_INTERVAL 1000000
 
 static bool rt2800usb_tx_sta_fifo_read_completed(struct rt2x00_dev *rt2x00dev,
@@ -145,7 +129,7 @@ static bool rt2800usb_tx_sta_fifo_read_completed(struct rt2x00_dev *rt2x00dev,
 	if (rt2800_txstatus_timeout(rt2x00dev))
 		queue_work(rt2x00dev->workqueue, &rt2x00dev->txdone_work);
 
-	if (rt2800usb_txstatus_pending(rt2x00dev)) {
+	if (rt2800_txstatus_pending(rt2x00dev)) {
 		/* Read register after 1 ms */
 		hrtimer_start(&rt2x00dev->txstatus_timer,
 			      TXSTATUS_READ_INTERVAL,
@@ -160,7 +144,7 @@ static bool rt2800usb_tx_sta_fifo_read_completed(struct rt2x00_dev *rt2x00dev,
 	 * clear_bit someone could do rt2x00usb_interrupt_txdone, so recheck
 	 * here again if status reading is needed.
 	 */
-	if (rt2800usb_txstatus_pending(rt2x00dev) &&
+	if (rt2800_txstatus_pending(rt2x00dev) &&
 	    !test_and_set_bit(TX_STATUS_READING, &rt2x00dev->flags))
 		return true;
 	else
@@ -489,7 +473,7 @@ static void rt2800usb_work_txdone(struct work_struct *work)
 		 * if the medium is busy, thus the TX_STA_FIFO entry is
 		 * also delayed -> use a timer to retrieve it.
 		 */
-		if (rt2800usb_txstatus_pending(rt2x00dev))
+		if (rt2800_txstatus_pending(rt2x00dev))
 			rt2800usb_async_read_tx_status(rt2x00dev);
 	}
 }
-- 
2.7.5

