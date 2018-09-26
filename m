Return-Path: <SRS0=mZ/2=MI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65D88C43382
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 10:25:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23A80214DC
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 10:25:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 23A80214DC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727411AbeIZQhX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Sep 2018 12:37:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56814 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726602AbeIZQhX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Sep 2018 12:37:23 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E55CF30832D1;
        Wed, 26 Sep 2018 10:25:07 +0000 (UTC)
Received: from localhost (ovpn-204-192.brq.redhat.com [10.40.204.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 75088579B;
        Wed, 26 Sep 2018 10:25:07 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Daniel Golle <daniel@makrotopia.org>,
        Mathias Kresin <dev@kresin.me>, Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 5/5] rt2800: flush and txstatus rework for rt2800mmio
Date:   Wed, 26 Sep 2018 12:24:57 +0200
Message-Id: <1537957497-7790-6-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1537957497-7790-1-git-send-email-sgruszka@redhat.com>
References: <1537957497-7790-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Wed, 26 Sep 2018 10:25:08 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Implement custom rt2800mmio flush routine and change txstatus
routine to read TX_STA_FIFO also in the tasklet.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c  |  14 ++-
 drivers/net/wireless/ralink/rt2x00/rt2800mmio.c | 118 ++++++++++++++++++------
 drivers/net/wireless/ralink/rt2x00/rt2800mmio.h |   1 +
 drivers/net/wireless/ralink/rt2x00/rt2800pci.c  |   2 +-
 4 files changed, 97 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 595cb9c90b81..9e7b8933d30c 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -1147,7 +1147,7 @@ static inline bool rt2800_entry_txstatus_timeout(struct rt2x00_dev *rt2x00dev,
 		return false;
 
 	if (test_bit(DEVICE_STATE_FLUSHING, &rt2x00dev->flags))
-		tout = msecs_to_jiffies(100);
+		tout = msecs_to_jiffies(50);
 	else
 		tout = msecs_to_jiffies(2000);
 
@@ -1163,15 +1163,13 @@ bool rt2800_txstatus_timeout(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_queue *queue;
 	struct queue_entry *entry;
-	unsigned long tout;
 
-	if (test_bit(DEVICE_STATE_FLUSHING, &rt2x00dev->flags))
-		tout = msecs_to_jiffies(50);
-	else
-		tout = msecs_to_jiffies(1000);
+	if (!test_bit(DEVICE_STATE_FLUSHING, &rt2x00dev->flags)) {
+		unsigned long tout = msecs_to_jiffies(1000);
 
-	if (time_before(jiffies, rt2x00dev->last_nostatus_check + tout))
-		return false;
+		if (time_before(jiffies, rt2x00dev->last_nostatus_check + tout))
+			return false;
+	}
 
 	rt2x00dev->last_nostatus_check = jiffies;
 
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c b/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
index d0426314c2df..ddb88cfeace2 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
@@ -191,21 +191,6 @@ static inline void rt2800mmio_enable_interrupt(struct rt2x00_dev *rt2x00dev,
 	spin_unlock_irq(&rt2x00dev->irqmask_lock);
 }
 
-void rt2800mmio_txstatus_tasklet(unsigned long data)
-{
-	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
-
-	rt2800_txdone(rt2x00dev);
-
-	if (rt2800_txstatus_timeout(rt2x00dev))
-		rt2800_txdone_nostatus(rt2x00dev);
-
-	if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
-		rt2800mmio_enable_interrupt(rt2x00dev,
-					    INT_SOURCE_CSR_TX_FIFO_STATUS);
-}
-EXPORT_SYMBOL_GPL(rt2800mmio_txstatus_tasklet);
-
 void rt2800mmio_pretbtt_tasklet(unsigned long data)
 {
 	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
@@ -270,12 +255,26 @@ void rt2800mmio_autowake_tasklet(unsigned long data)
 }
 EXPORT_SYMBOL_GPL(rt2800mmio_autowake_tasklet);
 
-static void rt2800mmio_txstatus_interrupt(struct rt2x00_dev *rt2x00dev)
+static void rt2800mmio_txdone(struct rt2x00_dev *rt2x00dev)
+{
+	bool timeout = false;
+
+	while (!kfifo_is_empty(&rt2x00dev->txstatus_fifo) ||
+	       (timeout = rt2800_txstatus_timeout(rt2x00dev))) {
+
+		rt2800_txdone(rt2x00dev);
+
+		if (timeout)
+			rt2800_txdone_nostatus(rt2x00dev);
+	}
+}
+
+static bool rt2800mmio_fetch_txstatus(struct rt2x00_dev *rt2x00dev)
 {
 	u32 status;
-	int i;
+	bool more = false;
 
-	/*
+	/* FIXEME: rewrite this comment
 	 * The TX_FIFO_STATUS interrupt needs special care. We should
 	 * read TX_STA_FIFO but we should do it immediately as otherwise
 	 * the register can overflow and we would lose status reports.
@@ -286,25 +285,37 @@ static void rt2800mmio_txstatus_interrupt(struct rt2x00_dev *rt2x00dev)
 	 * because we can schedule the tasklet multiple times (when the
 	 * interrupt fires again during tx status processing).
 	 *
-	 * Since we have only one producer and one consumer we don't
+	 * txstatus tasklet is called with INT_SOURCE_CSR_TX_FIFO_STATUS
+	 * disabled so have only one producer and one consumer - we don't
 	 * need to lock the kfifo.
 	 */
-	for (i = 0; i < rt2x00dev->tx->limit; i++) {
+	while (!kfifo_is_full(&rt2x00dev->txstatus_fifo)) {
 		status = rt2x00mmio_register_read(rt2x00dev, TX_STA_FIFO);
-
 		if (!rt2x00_get_field32(status, TX_STA_FIFO_VALID))
 			break;
 
-		if (!kfifo_put(&rt2x00dev->txstatus_fifo, status)) {
-			rt2x00_warn(rt2x00dev, "TX status FIFO overrun, drop tx status report\n");
-			break;
-		}
+		kfifo_put(&rt2x00dev->txstatus_fifo, status);
+		more = true;
 	}
 
-	/* Schedule the tasklet for processing the tx status. */
-	tasklet_schedule(&rt2x00dev->txstatus_tasklet);
+	return more;
 }
 
+void rt2800mmio_txstatus_tasklet(unsigned long data)
+{
+	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
+
+	do {
+		rt2800mmio_txdone(rt2x00dev);
+
+	} while (rt2800mmio_fetch_txstatus(rt2x00dev));
+
+	if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
+		rt2800mmio_enable_interrupt(rt2x00dev,
+					    INT_SOURCE_CSR_TX_FIFO_STATUS);
+}
+EXPORT_SYMBOL_GPL(rt2800mmio_txstatus_tasklet);
+
 irqreturn_t rt2800mmio_interrupt(int irq, void *dev_instance)
 {
 	struct rt2x00_dev *rt2x00dev = dev_instance;
@@ -327,8 +338,10 @@ irqreturn_t rt2800mmio_interrupt(int irq, void *dev_instance)
 	 */
 	mask = ~reg;
 
-	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_TX_FIFO_STATUS))
-		rt2800mmio_txstatus_interrupt(rt2x00dev);
+	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_TX_FIFO_STATUS)) {
+		rt2800mmio_fetch_txstatus(rt2x00dev);
+		tasklet_schedule(&rt2x00dev->txstatus_tasklet);
+	}
 
 	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_PRE_TBTT))
 		tasklet_hi_schedule(&rt2x00dev->pretbtt_tasklet);
@@ -453,6 +466,53 @@ void rt2800mmio_kick_queue(struct data_queue *queue)
 }
 EXPORT_SYMBOL_GPL(rt2800mmio_kick_queue);
 
+void rt2800mmio_flush_queue(struct data_queue *queue, bool drop)
+{
+	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
+	bool tx_queue = false;
+	unsigned int i;
+
+	switch (queue->qid) {
+	case QID_AC_VO:
+	case QID_AC_VI:
+	case QID_AC_BE:
+	case QID_AC_BK:
+		tx_queue = true;
+		break;
+	case QID_RX:
+		break;
+	default:
+		return;
+	}
+
+	for (i = 0; i < 5; i++) {
+		/*
+		 * Check if the driver is already done, otherwise we
+		 * have to sleep a little while to give the driver/hw
+		 * the oppurtunity to complete interrupt process itself.
+		 */
+		if (rt2x00queue_empty(queue))
+			break;
+
+		/*
+		 * For TX queues schedule completion tasklet to catch
+		 * tx status timeouts, othewise just wait.
+		 */
+		if (tx_queue) {
+			tasklet_disable(&rt2x00dev->txstatus_tasklet);
+			rt2800mmio_txdone(rt2x00dev);
+			tasklet_enable(&rt2x00dev->txstatus_tasklet);
+		}
+
+		/*
+		 * Wait for a little while to give the driver
+		 * the oppurtunity to recover itself.
+		 */
+		msleep(50);
+	}
+}
+EXPORT_SYMBOL_GPL(rt2800mmio_flush_queue);
+
 void rt2800mmio_stop_queue(struct data_queue *queue)
 {
 	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800mmio.h b/drivers/net/wireless/ralink/rt2x00/rt2800mmio.h
index b63312ce3f27..3a513273f414 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800mmio.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800mmio.h
@@ -148,6 +148,7 @@ void rt2800mmio_toggle_irq(struct rt2x00_dev *rt2x00dev,
 /* Queue handlers */
 void rt2800mmio_start_queue(struct data_queue *queue);
 void rt2800mmio_kick_queue(struct data_queue *queue);
+void rt2800mmio_flush_queue(struct data_queue *queue, bool drop);
 void rt2800mmio_stop_queue(struct data_queue *queue);
 void rt2800mmio_queue_init(struct data_queue *queue);
 
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800pci.c b/drivers/net/wireless/ralink/rt2x00/rt2800pci.c
index 71b1affc3885..0291441ac548 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800pci.c
@@ -364,7 +364,7 @@ static const struct rt2x00lib_ops rt2800pci_rt2x00_ops = {
 	.start_queue		= rt2800mmio_start_queue,
 	.kick_queue		= rt2800mmio_kick_queue,
 	.stop_queue		= rt2800mmio_stop_queue,
-	.flush_queue		= rt2x00mmio_flush_queue,
+	.flush_queue		= rt2800mmio_flush_queue,
 	.write_tx_desc		= rt2800mmio_write_tx_desc,
 	.write_tx_data		= rt2800_write_tx_data,
 	.write_beacon		= rt2800_write_beacon,
-- 
2.7.5

