Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63520 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929Ab0JBJfT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Oct 2010 05:35:19 -0400
Received: by mail-wy0-f174.google.com with SMTP id 28so3658520wyb.19
        for <linux-wireless@vger.kernel.org>; Sat, 02 Oct 2010 02:35:18 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 03/20] rt2x00: rework tx status handling in rt2800pci
Date: Sat, 2 Oct 2010 11:27:35 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
References: <201010021126.18748.IvDoorn@gmail.com> <201010021127.04544.IvDoorn@gmail.com>
In-Reply-To: <201010021127.04544.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010021127.36277.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

This patch changes the way tx status reports are handled by rt2800pci.
Previously rt2800pci would sometimes lose tx status reports as the
TX_STA_FIFO register is a fifo of 16 entries that can overflow in case
we don't read it often/fast enough. Since interrupts are disabled in the
device during the execution of the interrupt thread it happend sometimes
under high network and CPU load that processing took too long and a few
tx status reports were dropped by the hw.

To fix this issue the TX_STA_FIFO register is read directly in the
interrupt handler and stored in a kfifo which is large enough to hold
all status reports of all used tx queues.

To process the status reports a new tasklet txstatus_tasklet is used.
Using the already used interrupt thread is not possible since we don't
want to disable the TX_FIFO_STATUS interrupt while processing them and
it is not possible to schedule the interrupt thread multiple times for
execution. A tasklet instead can be scheduled multiple times which
allows to leave the TX_FIFO_STATUS interrupt enabled while a previously
scheduled tasklet is still executing.

In short: All other interrupts are handled in the interrupt thread as
before. Only the TX_FIFO_STATUS interrupt is partly handled in the
interrupt handler and finished in the according tasklet.

One drawback of this patch is that it duplicates some code from
rt2800lib. However, that can be cleaned up in the future once the
rt2800usb and rt2800pci tx status handling converge more.

Using this patch on a Ralink RT3052 embedded board gives me a reliable
wireless connection even under high CPU and network load. I've
transferred several gigabytes without any queue lockups.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |  150 ++++++++++++++++++++++++++++---
 drivers/net/wireless/rt2x00/rt2x00.h    |   17 ++++
 drivers/net/wireless/rt2x00/rt2x00dev.c |   34 +++++++
 3 files changed, 188 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 005ee15..3806454 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -660,6 +660,63 @@ static void rt2800pci_wakeup(struct rt2x00_dev *rt2x00dev)
 	rt2800_config(rt2x00dev, &libconf, IEEE80211_CONF_CHANGE_PS);
 }
 
+static void rt2800pci_txdone(struct rt2x00_dev *rt2x00dev)
+{
+	struct data_queue *queue;
+	struct queue_entry *entry;
+	u32 status;
+	u8 qid;
+
+	while (!kfifo_is_empty(&rt2x00dev->txstatus_fifo)) {
+		/* Now remove the tx status from the FIFO */
+		if (kfifo_out(&rt2x00dev->txstatus_fifo, &status,
+			      sizeof(status)) != sizeof(status)) {
+			WARN_ON(1);
+			break;
+		}
+
+		qid = rt2x00_get_field32(status, TX_STA_FIFO_PID_TYPE) - 1;
+		if (qid >= QID_RX) {
+			/*
+			 * Unknown queue, this shouldn't happen. Just drop
+			 * this tx status.
+			 */
+			WARNING(rt2x00dev, "Got TX status report with "
+					   "unexpected pid %u, dropping", qid);
+			break;
+		}
+
+		queue = rt2x00queue_get_queue(rt2x00dev, qid);
+		if (unlikely(queue == NULL)) {
+			/*
+			 * The queue is NULL, this shouldn't happen. Stop
+			 * processing here and drop the tx status
+			 */
+			WARNING(rt2x00dev, "Got TX status for an unavailable "
+					   "queue %u, dropping", qid);
+			break;
+		}
+
+		if (rt2x00queue_empty(queue)) {
+			/*
+			 * The queue is empty. Stop processing here
+			 * and drop the tx status.
+			 */
+			WARNING(rt2x00dev, "Got TX status for an empty "
+					   "queue %u, dropping", qid);
+			break;
+		}
+
+		entry = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
+		rt2800_txdone_entry(entry, status);
+	}
+}
+
+static void rt2800pci_txstatus_tasklet(unsigned long data)
+{
+	rt2800pci_txdone((struct rt2x00_dev *)data);
+}
+
 static irqreturn_t rt2800pci_interrupt_thread(int irq, void *dev_instance)
 {
 	struct rt2x00_dev *rt2x00dev = dev_instance;
@@ -684,13 +741,7 @@ static irqreturn_t rt2800pci_interrupt_thread(int irq, void *dev_instance)
 		rt2x00pci_rxdone(rt2x00dev);
 
 	/*
-	 * 4 - Tx done interrupt.
-	 */
-	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_TX_FIFO_STATUS))
-		rt2800_txdone(rt2x00dev);
-
-	/*
-	 * 5 - Auto wakeup interrupt.
+	 * 4 - Auto wakeup interrupt.
 	 */
 	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_AUTO_WAKEUP))
 		rt2800pci_wakeup(rt2x00dev);
@@ -702,10 +753,58 @@ static irqreturn_t rt2800pci_interrupt_thread(int irq, void *dev_instance)
 	return IRQ_HANDLED;
 }
 
+static void rt2800pci_txstatus_interrupt(struct rt2x00_dev *rt2x00dev)
+{
+	u32 status;
+	int i;
+
+	/*
+	 * The TX_FIFO_STATUS interrupt needs special care. We should
+	 * read TX_STA_FIFO but we should do it immediately as otherwise
+	 * the register can overflow and we would lose status reports.
+	 *
+	 * Hence, read the TX_STA_FIFO register and copy all tx status
+	 * reports into a kernel FIFO which is handled in the txstatus
+	 * tasklet. We use a tasklet to process the tx status reports
+	 * because we can schedule the tasklet multiple times (when the
+	 * interrupt fires again during tx status processing).
+	 *
+	 * Furthermore we don't disable the TX_FIFO_STATUS
+	 * interrupt here but leave it enabled so that the TX_STA_FIFO
+	 * can also be read while the interrupt thread gets executed.
+	 *
+	 * Since we have only one producer and one consumer we don't
+	 * need to lock the kfifo.
+	 */
+	for (i = 0; i < TX_ENTRIES; i++) {
+		rt2800_register_read(rt2x00dev, TX_STA_FIFO, &status);
+
+		if (!rt2x00_get_field32(status, TX_STA_FIFO_VALID))
+			break;
+
+		if (kfifo_is_full(&rt2x00dev->txstatus_fifo)) {
+			WARNING(rt2x00dev, "TX status FIFO overrun,"
+				" drop tx status report.\n");
+			break;
+		}
+
+		if (kfifo_in(&rt2x00dev->txstatus_fifo, &status,
+			     sizeof(status)) != sizeof(status)) {
+			WARNING(rt2x00dev, "TX status FIFO overrun,"
+				"drop tx status report.\n");
+			break;
+		}
+	}
+
+	/* Schedule the tasklet for processing the tx status. */
+	tasklet_schedule(&rt2x00dev->txstatus_tasklet);
+}
+
 static irqreturn_t rt2800pci_interrupt(int irq, void *dev_instance)
 {
 	struct rt2x00_dev *rt2x00dev = dev_instance;
 	u32 reg;
+	irqreturn_t ret = IRQ_HANDLED;
 
 	/* Read status and ACK all interrupts */
 	rt2800_register_read(rt2x00dev, INT_SOURCE_CSR, &reg);
@@ -717,15 +816,38 @@ static irqreturn_t rt2800pci_interrupt(int irq, void *dev_instance)
 	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
 		return IRQ_HANDLED;
 
-	/* Store irqvalue for use in the interrupt thread. */
-	rt2x00dev->irqvalue[0] = reg;
+	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_TX_FIFO_STATUS))
+		rt2800pci_txstatus_interrupt(rt2x00dev);
+
+	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_PRE_TBTT) ||
+	    rt2x00_get_field32(reg, INT_SOURCE_CSR_TBTT) ||
+	    rt2x00_get_field32(reg, INT_SOURCE_CSR_RX_DONE) ||
+	    rt2x00_get_field32(reg, INT_SOURCE_CSR_AUTO_WAKEUP)) {
+		/*
+		 * All other interrupts are handled in the interrupt thread.
+		 * Store irqvalue for use in the interrupt thread.
+		 */
+		rt2x00dev->irqvalue[0] = reg;
 
-	/* Disable interrupts, will be enabled again in the interrupt thread. */
-	rt2x00dev->ops->lib->set_device_state(rt2x00dev,
-					      STATE_RADIO_IRQ_OFF_ISR);
+		/*
+		 * Disable interrupts, will be enabled again in the
+		 * interrupt thread.
+		*/
+		rt2x00dev->ops->lib->set_device_state(rt2x00dev,
+						      STATE_RADIO_IRQ_OFF_ISR);
 
+		/*
+		 * Leave the TX_FIFO_STATUS interrupt enabled to not lose any
+		 * tx status reports.
+		 */
+		rt2800_register_read(rt2x00dev, INT_MASK_CSR, &reg);
+		rt2x00_set_field32(&reg, INT_MASK_CSR_TX_FIFO_STATUS, 1);
+		rt2800_register_write(rt2x00dev, INT_MASK_CSR, reg);
 
-	return IRQ_WAKE_THREAD;
+		ret = IRQ_WAKE_THREAD;
+	}
+
+	return ret;
 }
 
 /*
@@ -788,6 +910,7 @@ static int rt2800pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 		__set_bit(DRIVER_REQUIRE_FIRMWARE, &rt2x00dev->flags);
 	__set_bit(DRIVER_REQUIRE_DMA, &rt2x00dev->flags);
 	__set_bit(DRIVER_REQUIRE_L2PAD, &rt2x00dev->flags);
+	__set_bit(DRIVER_REQUIRE_TXSTATUS_FIFO, &rt2x00dev->flags);
 	if (!modparam_nohwcrypt)
 		__set_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags);
 	__set_bit(DRIVER_SUPPORT_LINK_TUNING, &rt2x00dev->flags);
@@ -837,6 +960,7 @@ static const struct rt2800_ops rt2800pci_rt2800_ops = {
 static const struct rt2x00lib_ops rt2800pci_rt2x00_ops = {
 	.irq_handler		= rt2800pci_interrupt,
 	.irq_handler_thread	= rt2800pci_interrupt_thread,
+	.txstatus_tasklet       = rt2800pci_txstatus_tasklet,
 	.probe_hw		= rt2800pci_probe_hw,
 	.get_firmware_name	= rt2800pci_get_firmware_name,
 	.check_firmware		= rt2800_check_firmware,
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 7832a59..bab10ad 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -36,6 +36,7 @@
 #include <linux/mutex.h>
 #include <linux/etherdevice.h>
 #include <linux/input-polldev.h>
+#include <linux/kfifo.h>
 
 #include <net/mac80211.h>
 
@@ -522,6 +523,11 @@ struct rt2x00lib_ops {
 	irq_handler_t irq_handler_thread;
 
 	/*
+	 * TX status tasklet handler.
+	 */
+	void (*txstatus_tasklet) (unsigned long data);
+
+	/*
 	 * Device init handlers.
 	 */
 	int (*probe_hw) (struct rt2x00_dev *rt2x00dev);
@@ -651,6 +657,7 @@ enum rt2x00_flags {
 	DRIVER_REQUIRE_DMA,
 	DRIVER_REQUIRE_COPY_IV,
 	DRIVER_REQUIRE_L2PAD,
+	DRIVER_REQUIRE_TXSTATUS_FIFO,
 
 	/*
 	 * Driver features
@@ -884,6 +891,16 @@ struct rt2x00_dev {
 	 * and interrupt thread routine.
 	 */
 	u32 irqvalue[2];
+
+	/*
+	 * FIFO for storing tx status reports between isr and tasklet.
+	 */
+	struct kfifo txstatus_fifo;
+
+	/*
+	 * Tasklet for processing tx status reports (rt2800pci).
+	 */
+	struct tasklet_struct txstatus_tasklet;
 };
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 053fdd3..b03e6e4 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -813,6 +813,30 @@ static int rt2x00lib_probe_hw(struct rt2x00_dev *rt2x00dev)
 		rt2x00dev->hw->extra_tx_headroom += RT2X00_ALIGN_SIZE;
 
 	/*
+	 * Allocate tx status FIFO for driver use.
+	 */
+	if (test_bit(DRIVER_REQUIRE_TXSTATUS_FIFO, &rt2x00dev->flags) &&
+	    rt2x00dev->ops->lib->txstatus_tasklet) {
+		/*
+		 * Allocate txstatus fifo and tasklet, we use a size of 512
+		 * for the kfifo which is big enough to store 512/4=128 tx
+		 * status reports. In the worst case (tx status for all tx
+		 * queues gets reported before we've got a chance to handle
+		 * them) 24*4=384 tx status reports need to be cached.
+		 */
+		status = kfifo_alloc(&rt2x00dev->txstatus_fifo, 512,
+				     GFP_KERNEL);
+		if (status)
+			return status;
+
+		/* tasklet for processing the tx status reports. */
+		tasklet_init(&rt2x00dev->txstatus_tasklet,
+			     rt2x00dev->ops->lib->txstatus_tasklet,
+			     (unsigned long)rt2x00dev);
+
+	}
+
+	/*
 	 * Register HW.
 	 */
 	status = ieee80211_register_hw(rt2x00dev->hw);
@@ -1028,6 +1052,16 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
 	cancel_work_sync(&rt2x00dev->txdone_work);
 
 	/*
+	 * Free the tx status fifo.
+	 */
+	kfifo_free(&rt2x00dev->txstatus_fifo);
+
+	/*
+	 * Kill the tx status tasklet.
+	 */
+	tasklet_kill(&rt2x00dev->txstatus_tasklet);
+
+	/*
 	 * Uninitialize device.
 	 */
 	rt2x00lib_uninitialize(rt2x00dev);
-- 
1.7.2.3

