Return-Path: <SRS0=Ta2d=QQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 767B7C282C4
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 11:08:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E38E218D2
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 11:08:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbfBILIn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Feb 2019 06:08:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55080 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbfBILIn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Feb 2019 06:08:43 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BBC5DC002967;
        Sat,  9 Feb 2019 11:08:42 +0000 (UTC)
Received: from localhost (ovpn-204-22.brq.redhat.com [10.40.204.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 35E5D6017A;
        Sat,  9 Feb 2019 11:08:42 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Subject: [RFC/RFT 1/8] rt2800: partially restore old mmio txstatus behaviour
Date:   Sat,  9 Feb 2019 12:08:31 +0100
Message-Id: <1549710518-15650-2-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1549710518-15650-1-git-send-email-sgruszka@redhat.com>
References: <1549710518-15650-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Sat, 09 Feb 2019 11:08:42 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Do not disable txstatus interrupt and add quota of processed tx statuses in
one tasklet. Quota is needed to allow to fed device with new frames during
processing of tx statuses.

Patch fixes about 15% performance degradation on some scenarios coused by
0b0d556e0ebb ("rt2800mmio: use txdone/txstatus routines from lib").

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c  |  4 ++--
 drivers/net/wireless/ralink/rt2x00/rt2800lib.h  |  2 +-
 drivers/net/wireless/ralink/rt2x00/rt2800mmio.c | 30 +++++++------------------
 drivers/net/wireless/ralink/rt2x00/rt2800usb.c  |  2 +-
 4 files changed, 12 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 0e95555aec62..fdf7813d9be6 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -1100,7 +1100,7 @@ void rt2800_txdone_entry(struct queue_entry *entry, u32 status, __le32 *txwi,
 }
 EXPORT_SYMBOL_GPL(rt2800_txdone_entry);
 
-void rt2800_txdone(struct rt2x00_dev *rt2x00dev)
+void rt2800_txdone(struct rt2x00_dev *rt2x00dev, unsigned int quota)
 {
 	struct data_queue *queue;
 	struct queue_entry *entry;
@@ -1108,7 +1108,7 @@ void rt2800_txdone(struct rt2x00_dev *rt2x00dev)
 	u8 qid;
 	bool match;
 
-	while (kfifo_get(&rt2x00dev->txstatus_fifo, &reg)) {
+	while (quota-- > 0 && kfifo_get(&rt2x00dev->txstatus_fifo, &reg)) {
 		/*
 		 * TX_STA_FIFO_PID_QUEUE is a 2-bit field, thus qid is
 		 * guaranteed to be one of the TX QIDs .
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.h b/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
index 0dff2c7b3010..506c319070dd 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
@@ -195,7 +195,7 @@ void rt2800_process_rxwi(struct queue_entry *entry, struct rxdone_entry_desc *tx
 
 void rt2800_txdone_entry(struct queue_entry *entry, u32 status, __le32 *txwi,
 			 bool match);
-void rt2800_txdone(struct rt2x00_dev *rt2x00dev);
+void rt2800_txdone(struct rt2x00_dev *rt2x00dev, unsigned int quota);
 void rt2800_txdone_nostatus(struct rt2x00_dev *rt2x00dev);
 bool rt2800_txstatus_timeout(struct rt2x00_dev *rt2x00dev);
 
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c b/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
index ddb88cfeace2..f7635a47dbcd 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
@@ -255,20 +255,6 @@ void rt2800mmio_autowake_tasklet(unsigned long data)
 }
 EXPORT_SYMBOL_GPL(rt2800mmio_autowake_tasklet);
 
-static void rt2800mmio_txdone(struct rt2x00_dev *rt2x00dev)
-{
-	bool timeout = false;
-
-	while (!kfifo_is_empty(&rt2x00dev->txstatus_fifo) ||
-	       (timeout = rt2800_txstatus_timeout(rt2x00dev))) {
-
-		rt2800_txdone(rt2x00dev);
-
-		if (timeout)
-			rt2800_txdone_nostatus(rt2x00dev);
-	}
-}
-
 static bool rt2800mmio_fetch_txstatus(struct rt2x00_dev *rt2x00dev)
 {
 	u32 status;
@@ -305,14 +291,11 @@ void rt2800mmio_txstatus_tasklet(unsigned long data)
 {
 	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
 
-	do {
-		rt2800mmio_txdone(rt2x00dev);
+	rt2800_txdone(rt2x00dev, 16);
 
-	} while (rt2800mmio_fetch_txstatus(rt2x00dev));
+	if (!kfifo_is_empty(&rt2x00dev->txstatus_fifo))
+		tasklet_schedule(&rt2x00dev->txstatus_tasklet);
 
-	if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
-		rt2800mmio_enable_interrupt(rt2x00dev,
-					    INT_SOURCE_CSR_TX_FIFO_STATUS);
 }
 EXPORT_SYMBOL_GPL(rt2800mmio_txstatus_tasklet);
 
@@ -339,8 +322,10 @@ irqreturn_t rt2800mmio_interrupt(int irq, void *dev_instance)
 	mask = ~reg;
 
 	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_TX_FIFO_STATUS)) {
+		rt2x00_set_field32(&mask, INT_MASK_CSR_TX_FIFO_STATUS, 1);
 		rt2800mmio_fetch_txstatus(rt2x00dev);
-		tasklet_schedule(&rt2x00dev->txstatus_tasklet);
+		if (!kfifo_is_empty(&rt2x00dev->txstatus_fifo))
+			tasklet_schedule(&rt2x00dev->txstatus_tasklet);
 	}
 
 	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_PRE_TBTT))
@@ -500,7 +485,8 @@ void rt2800mmio_flush_queue(struct data_queue *queue, bool drop)
 		 */
 		if (tx_queue) {
 			tasklet_disable(&rt2x00dev->txstatus_tasklet);
-			rt2800mmio_txdone(rt2x00dev);
+			rt2800_txdone(rt2x00dev, UINT_MAX);
+			rt2800_txdone_nostatus(rt2x00dev);
 			tasklet_enable(&rt2x00dev->txstatus_tasklet);
 		}
 
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
index 19eabf16147b..0bdcab374203 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
@@ -480,7 +480,7 @@ static void rt2800usb_work_txdone(struct work_struct *work)
 	while (!kfifo_is_empty(&rt2x00dev->txstatus_fifo) ||
 	       rt2800_txstatus_timeout(rt2x00dev)) {
 
-		rt2800_txdone(rt2x00dev);
+		rt2800_txdone(rt2x00dev, UINT_MAX);
 
 		rt2800_txdone_nostatus(rt2x00dev);
 
-- 
2.7.5

