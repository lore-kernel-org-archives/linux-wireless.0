Return-Path: <SRS0=A7Z7=R6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AB22C10F00
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 09:58:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD55B2070B
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 09:58:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733002AbfC0J6q (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Mar 2019 05:58:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58154 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731668AbfC0J6p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Mar 2019 05:58:45 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C5B213002F4E;
        Wed, 27 Mar 2019 09:58:44 +0000 (UTC)
Received: from localhost (unknown [10.40.205.179])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 569C15C28D;
        Wed, 27 Mar 2019 09:58:44 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Subject: [PATCH 5/8] rt2800mmio: use timer and work for handling tx statuses timeouts
Date:   Wed, 27 Mar 2019 10:58:28 +0100
Message-Id: <1553680711-15730-6-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1553680711-15730-1-git-send-email-sgruszka@redhat.com>
References: <1553680711-15730-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Wed, 27 Mar 2019 09:58:44 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Sometimes we can get into situation when there are pending statuses,
but we do not get INT_SOURCE_CSR_TX_FIFO_STATUS. Handle this situation
by arming timeout timer and read statuses (it will fix case when
we just do not have irq) and queue work to handle case we missed
statues from hardware FIFO.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800mmio.c | 81 +++++++++++++++++++++++--
 drivers/net/wireless/ralink/rt2x00/rt2800mmio.h |  1 +
 drivers/net/wireless/ralink/rt2x00/rt2800pci.c  |  2 +-
 drivers/net/wireless/ralink/rt2x00/rt2800soc.c  |  2 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c  |  4 ++
 5 files changed, 82 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c b/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
index 3d4e37a9854e..ecc4c9332ec7 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
@@ -426,6 +426,9 @@ void rt2800mmio_start_queue(struct data_queue *queue)
 }
 EXPORT_SYMBOL_GPL(rt2800mmio_start_queue);
 
+/* 200 ms */
+#define TXSTATUS_TIMEOUT 200000000
+
 void rt2800mmio_kick_queue(struct data_queue *queue)
 {
 	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
@@ -440,6 +443,8 @@ void rt2800mmio_kick_queue(struct data_queue *queue)
 		entry = rt2x00queue_get_entry(queue, Q_INDEX);
 		rt2x00mmio_register_write(rt2x00dev, TX_CTX_IDX(queue->qid),
 					  entry->entry_idx);
+		hrtimer_start(&rt2x00dev->txstatus_timer,
+			      TXSTATUS_TIMEOUT, HRTIMER_MODE_REL);
 		break;
 	case QID_MGMT:
 		entry = rt2x00queue_get_entry(queue, Q_INDEX);
@@ -484,12 +489,8 @@ void rt2800mmio_flush_queue(struct data_queue *queue, bool drop)
 		 * For TX queues schedule completion tasklet to catch
 		 * tx status timeouts, othewise just wait.
 		 */
-		if (tx_queue) {
-			tasklet_disable(&rt2x00dev->txstatus_tasklet);
-			rt2800_txdone(rt2x00dev, UINT_MAX);
-			rt2800_txdone_nostatus(rt2x00dev);
-			tasklet_enable(&rt2x00dev->txstatus_tasklet);
-		}
+		if (tx_queue)
+			queue_work(rt2x00dev->workqueue, &rt2x00dev->txdone_work);
 
 		/*
 		 * Wait for a little while to give the driver
@@ -627,6 +628,10 @@ void rt2800mmio_clear_entry(struct queue_entry *entry)
 		word = rt2x00_desc_read(entry_priv->desc, 1);
 		rt2x00_set_field32(&word, TXD_W1_DMA_DONE, 1);
 		rt2x00_desc_write(entry_priv->desc, 1, word);
+
+		/* If last entry stop txstatus timer */
+		if (entry->queue->length == 1)
+			hrtimer_cancel(&rt2x00dev->txstatus_timer);
 	}
 }
 EXPORT_SYMBOL_GPL(rt2800mmio_clear_entry);
@@ -759,6 +764,70 @@ int rt2800mmio_enable_radio(struct rt2x00_dev *rt2x00dev)
 }
 EXPORT_SYMBOL_GPL(rt2800mmio_enable_radio);
 
+static void rt2800mmio_work_txdone(struct work_struct *work)
+{
+	struct rt2x00_dev *rt2x00dev =
+	    container_of(work, struct rt2x00_dev, txdone_work);
+
+	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
+		return;
+
+	while (!kfifo_is_empty(&rt2x00dev->txstatus_fifo) ||
+	       rt2800_txstatus_timeout(rt2x00dev)) {
+
+		tasklet_disable(&rt2x00dev->txstatus_tasklet);
+		rt2800_txdone(rt2x00dev, UINT_MAX);
+		rt2800_txdone_nostatus(rt2x00dev);
+		tasklet_enable(&rt2x00dev->txstatus_tasklet);
+	}
+
+	if (rt2800_txstatus_pending(rt2x00dev))
+		hrtimer_start(&rt2x00dev->txstatus_timer,
+			      TXSTATUS_TIMEOUT, HRTIMER_MODE_REL);
+}
+
+static enum hrtimer_restart rt2800mmio_tx_sta_fifo_timeout(struct hrtimer *timer)
+{
+	struct rt2x00_dev *rt2x00dev =
+	    container_of(timer, struct rt2x00_dev, txstatus_timer);
+
+	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
+		goto out;
+
+	if (!rt2800_txstatus_pending(rt2x00dev))
+		goto out;
+
+	rt2800mmio_fetch_txstatus(rt2x00dev);
+	if (!kfifo_is_empty(&rt2x00dev->txstatus_fifo))
+		tasklet_schedule(&rt2x00dev->txstatus_tasklet);
+	else
+		queue_work(rt2x00dev->workqueue, &rt2x00dev->txdone_work);
+out:
+	return HRTIMER_NORESTART;
+}
+
+int rt2800mmio_probe_hw(struct rt2x00_dev *rt2x00dev)
+{
+	int retval;
+
+	retval = rt2800_probe_hw(rt2x00dev);
+	if (retval)
+		return retval;
+
+	/*
+	 * Set txstatus timer function.
+	 */
+	rt2x00dev->txstatus_timer.function = rt2800mmio_tx_sta_fifo_timeout;
+
+	/*
+	 * Overwrite TX done handler
+	 */
+	INIT_WORK(&rt2x00dev->txdone_work, rt2800mmio_work_txdone);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rt2800mmio_probe_hw);
+
 MODULE_AUTHOR(DRV_PROJECT);
 MODULE_VERSION(DRV_VERSION);
 MODULE_DESCRIPTION("rt2800 MMIO library");
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800mmio.h b/drivers/net/wireless/ralink/rt2x00/rt2800mmio.h
index 3a513273f414..ca58e6c3a4e5 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800mmio.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800mmio.h
@@ -153,6 +153,7 @@ void rt2800mmio_stop_queue(struct data_queue *queue);
 void rt2800mmio_queue_init(struct data_queue *queue);
 
 /* Initialization functions */
+int rt2800mmio_probe_hw(struct rt2x00_dev *rt2x00dev);
 bool rt2800mmio_get_entry_state(struct queue_entry *entry);
 void rt2800mmio_clear_entry(struct queue_entry *entry);
 int rt2800mmio_init_queues(struct rt2x00_dev *rt2x00dev);
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800pci.c b/drivers/net/wireless/ralink/rt2x00/rt2800pci.c
index 0291441ac548..43e1b1ee96bf 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800pci.c
@@ -346,7 +346,7 @@ static const struct rt2x00lib_ops rt2800pci_rt2x00_ops = {
 	.tbtt_tasklet		= rt2800mmio_tbtt_tasklet,
 	.rxdone_tasklet		= rt2800mmio_rxdone_tasklet,
 	.autowake_tasklet	= rt2800mmio_autowake_tasklet,
-	.probe_hw		= rt2800_probe_hw,
+	.probe_hw		= rt2800mmio_probe_hw,
 	.get_firmware_name	= rt2800pci_get_firmware_name,
 	.check_firmware		= rt2800_check_firmware,
 	.load_firmware		= rt2800_load_firmware,
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800soc.c b/drivers/net/wireless/ralink/rt2x00/rt2800soc.c
index 05a801774713..cc9c2a1d5916 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800soc.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800soc.c
@@ -185,7 +185,7 @@ static const struct rt2x00lib_ops rt2800soc_rt2x00_ops = {
 	.tbtt_tasklet		= rt2800mmio_tbtt_tasklet,
 	.rxdone_tasklet		= rt2800mmio_rxdone_tasklet,
 	.autowake_tasklet	= rt2800mmio_autowake_tasklet,
-	.probe_hw		= rt2800_probe_hw,
+	.probe_hw		= rt2800mmio_probe_hw,
 	.get_firmware_name	= rt2800soc_get_firmware_name,
 	.check_firmware		= rt2800soc_check_firmware,
 	.load_firmware		= rt2800soc_load_firmware,
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
index 357c0941aaad..bdc55d649a88 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
@@ -1391,6 +1391,8 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 	mutex_init(&rt2x00dev->conf_mutex);
 	INIT_LIST_HEAD(&rt2x00dev->bar_list);
 	spin_lock_init(&rt2x00dev->bar_list_lock);
+	hrtimer_init(&rt2x00dev->txstatus_timer, CLOCK_MONOTONIC,
+		     HRTIMER_MODE_REL);
 
 	set_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
 
@@ -1515,6 +1517,8 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
 	cancel_delayed_work_sync(&rt2x00dev->autowakeup_work);
 	cancel_work_sync(&rt2x00dev->sleep_work);
 
+	hrtimer_cancel(&rt2x00dev->txstatus_timer);
+
 	/*
 	 * Kill the tx status tasklet.
 	 */
-- 
2.7.5

