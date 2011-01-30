Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48218 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab1A3MYh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 07:24:37 -0500
Received: by mail-ew0-f46.google.com with SMTP id 5so2118506ewy.19
        for <linux-wireless@vger.kernel.org>; Sun, 30 Jan 2011 04:24:36 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 09/21] rt2x00: Convert rt2500pci interrupt handling to use tasklets
Date: Sun, 30 Jan 2011 13:19:37 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201101301316.04044.IvDoorn@gmail.com> <201101301318.39263.IvDoorn@gmail.com> <201101301319.08812.IvDoorn@gmail.com>
In-Reply-To: <201101301319.08812.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201101301319.38761.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Fix interrupt processing on slow machines by using individual tasklets
for each different device interrupt. This ensures that while a RX or TX
status tasklet is scheduled only the according device interrupt is
masked and other interrupts such as TBTT can still be processed.

Also, this allows us to use tasklet_hi_schedule for TBTT processing
which is required to not send out beacons with a wrong DTIM count (due
to delayed periodic beacon updates). Furthermore, this improves the
latency between the TBTT and sending out buffered multi- and broadcast
traffic.

As a nice bonus, the interrupt handling overhead should be much lower.

Compile-tested only.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500pci.c |  150 +++++++++++++++++++++++--------
 1 files changed, 111 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 5225ae1..7daa483 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -735,6 +735,11 @@ static void rt2500pci_start_queue(struct data_queue *queue)
 		rt2x00pci_register_write(rt2x00dev, RXCSR0, reg);
 		break;
 	case QID_BEACON:
+		/*
+		 * Allow the tbtt tasklet to be scheduled.
+		 */
+		tasklet_enable(&rt2x00dev->tbtt_tasklet);
+
 		rt2x00pci_register_read(rt2x00dev, CSR14, &reg);
 		rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 1);
 		rt2x00_set_field32(&reg, CSR14_TBCN, 1);
@@ -796,6 +801,11 @@ static void rt2500pci_stop_queue(struct data_queue *queue)
 		rt2x00_set_field32(&reg, CSR14_TBCN, 0);
 		rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 0);
 		rt2x00pci_register_write(rt2x00dev, CSR14, reg);
+
+		/*
+		 * Wait for possibly running tbtt tasklets.
+		 */
+		tasklet_disable(&rt2x00dev->tbtt_tasklet);
 		break;
 	default:
 		break;
@@ -1119,6 +1129,7 @@ static void rt2500pci_toggle_irq(struct rt2x00_dev *rt2x00dev,
 	int mask = (state == STATE_RADIO_IRQ_OFF) ||
 		   (state == STATE_RADIO_IRQ_OFF_ISR);
 	u32 reg;
+	unsigned long flags;
 
 	/*
 	 * When interrupts are being enabled, the interrupt registers
@@ -1127,12 +1138,20 @@ static void rt2500pci_toggle_irq(struct rt2x00_dev *rt2x00dev,
 	if (state == STATE_RADIO_IRQ_ON) {
 		rt2x00pci_register_read(rt2x00dev, CSR7, &reg);
 		rt2x00pci_register_write(rt2x00dev, CSR7, reg);
+
+		/*
+		 * Enable tasklets.
+		 */
+		tasklet_enable(&rt2x00dev->txstatus_tasklet);
+		tasklet_enable(&rt2x00dev->rxdone_tasklet);
 	}
 
 	/*
 	 * Only toggle the interrupts bits we are going to use.
 	 * Non-checked interrupt bits are disabled by default.
 	 */
+	spin_lock_irqsave(&rt2x00dev->irqmask_lock, flags);
+
 	rt2x00pci_register_read(rt2x00dev, CSR8, &reg);
 	rt2x00_set_field32(&reg, CSR8_TBCN_EXPIRE, mask);
 	rt2x00_set_field32(&reg, CSR8_TXDONE_TXRING, mask);
@@ -1140,6 +1159,16 @@ static void rt2500pci_toggle_irq(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&reg, CSR8_TXDONE_PRIORING, mask);
 	rt2x00_set_field32(&reg, CSR8_RXDONE, mask);
 	rt2x00pci_register_write(rt2x00dev, CSR8, reg);
+
+	spin_unlock_irqrestore(&rt2x00dev->irqmask_lock, flags);
+
+	if (state == STATE_RADIO_IRQ_OFF) {
+		/*
+		 * Ensure that all tasklets are finished.
+		 */
+		tasklet_disable(&rt2x00dev->txstatus_tasklet);
+		tasklet_disable(&rt2x00dev->rxdone_tasklet);
+	}
 }
 
 static int rt2500pci_enable_radio(struct rt2x00_dev *rt2x00dev)
@@ -1418,58 +1447,71 @@ static void rt2500pci_txdone(struct rt2x00_dev *rt2x00dev,
 	}
 }
 
-static irqreturn_t rt2500pci_interrupt_thread(int irq, void *dev_instance)
+static void rt2500pci_enable_interrupt(struct rt2x00_dev *rt2x00dev,
+				       struct rt2x00_field32 irq_field)
 {
-	struct rt2x00_dev *rt2x00dev = dev_instance;
-	u32 reg = rt2x00dev->irqvalue[0];
+	unsigned long flags;
+	u32 reg;
 
 	/*
-	 * Handle interrupts, walk through all bits
-	 * and run the tasks, the bits are checked in order of
-	 * priority.
+	 * Enable a single interrupt. The interrupt mask register
+	 * access needs locking.
 	 */
+	spin_lock_irqsave(&rt2x00dev->irqmask_lock, flags);
 
-	/*
-	 * 1 - Beacon timer expired interrupt.
-	 */
-	if (rt2x00_get_field32(reg, CSR7_TBCN_EXPIRE))
-		rt2x00lib_beacondone(rt2x00dev);
+	rt2x00pci_register_read(rt2x00dev, CSR8, &reg);
+	rt2x00_set_field32(&reg, irq_field, 0);
+	rt2x00pci_register_write(rt2x00dev, CSR8, reg);
 
-	/*
-	 * 2 - Rx ring done interrupt.
-	 */
-	if (rt2x00_get_field32(reg, CSR7_RXDONE))
-		rt2x00pci_rxdone(rt2x00dev);
+	spin_unlock_irqrestore(&rt2x00dev->irqmask_lock, flags);
+}
 
-	/*
-	 * 3 - Atim ring transmit done interrupt.
-	 */
-	if (rt2x00_get_field32(reg, CSR7_TXDONE_ATIMRING))
-		rt2500pci_txdone(rt2x00dev, QID_ATIM);
+static void rt2500pci_txstatus_tasklet(unsigned long data)
+{
+	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
+	u32 reg;
+	unsigned long flags;
 
 	/*
-	 * 4 - Priority ring transmit done interrupt.
+	 * Handle all tx queues.
 	 */
-	if (rt2x00_get_field32(reg, CSR7_TXDONE_PRIORING))
-		rt2500pci_txdone(rt2x00dev, QID_AC_VO);
+	rt2500pci_txdone(rt2x00dev, QID_ATIM);
+	rt2500pci_txdone(rt2x00dev, QID_AC_VO);
+	rt2500pci_txdone(rt2x00dev, QID_AC_VI);
 
 	/*
-	 * 5 - Tx ring transmit done interrupt.
+	 * Enable all TXDONE interrupts again.
 	 */
-	if (rt2x00_get_field32(reg, CSR7_TXDONE_TXRING))
-		rt2500pci_txdone(rt2x00dev, QID_AC_VI);
+	spin_lock_irqsave(&rt2x00dev->irqmask_lock, flags);
 
-	/* Enable interrupts again. */
-	rt2x00dev->ops->lib->set_device_state(rt2x00dev,
-					      STATE_RADIO_IRQ_ON_ISR);
+	rt2x00pci_register_read(rt2x00dev, CSR8, &reg);
+	rt2x00_set_field32(&reg, CSR8_TXDONE_TXRING, 0);
+	rt2x00_set_field32(&reg, CSR8_TXDONE_ATIMRING, 0);
+	rt2x00_set_field32(&reg, CSR8_TXDONE_PRIORING, 0);
+	rt2x00pci_register_write(rt2x00dev, CSR8, reg);
 
-	return IRQ_HANDLED;
+	spin_unlock_irqrestore(&rt2x00dev->irqmask_lock, flags);
+}
+
+static void rt2500pci_tbtt_tasklet(unsigned long data)
+{
+	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
+	rt2x00lib_beacondone(rt2x00dev);
+	rt2500pci_enable_interrupt(rt2x00dev, CSR8_TBCN_EXPIRE);
+}
+
+static void rt2500pci_rxdone_tasklet(unsigned long data)
+{
+	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
+	rt2x00pci_rxdone(rt2x00dev);
+	rt2500pci_enable_interrupt(rt2x00dev, CSR8_RXDONE);
 }
 
 static irqreturn_t rt2500pci_interrupt(int irq, void *dev_instance)
 {
 	struct rt2x00_dev *rt2x00dev = dev_instance;
-	u32 reg;
+	u32 reg, mask;
+	unsigned long flags;
 
 	/*
 	 * Get the interrupt sources & saved to local variable.
@@ -1484,14 +1526,42 @@ static irqreturn_t rt2500pci_interrupt(int irq, void *dev_instance)
 	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
 		return IRQ_HANDLED;
 
-	/* Store irqvalues for use in the interrupt thread. */
-	rt2x00dev->irqvalue[0] = reg;
+	mask = reg;
+
+	/*
+	 * Schedule tasklets for interrupt handling.
+	 */
+	if (rt2x00_get_field32(reg, CSR7_TBCN_EXPIRE))
+		tasklet_hi_schedule(&rt2x00dev->tbtt_tasklet);
+
+	if (rt2x00_get_field32(reg, CSR7_RXDONE))
+		tasklet_schedule(&rt2x00dev->rxdone_tasklet);
+
+	if (rt2x00_get_field32(reg, CSR7_TXDONE_ATIMRING) ||
+	    rt2x00_get_field32(reg, CSR7_TXDONE_PRIORING) ||
+	    rt2x00_get_field32(reg, CSR7_TXDONE_TXRING)) {
+		tasklet_schedule(&rt2x00dev->txstatus_tasklet);
+		/*
+		 * Mask out all txdone interrupts.
+		 */
+		rt2x00_set_field32(&mask, CSR8_TXDONE_TXRING, 1);
+		rt2x00_set_field32(&mask, CSR8_TXDONE_ATIMRING, 1);
+		rt2x00_set_field32(&mask, CSR8_TXDONE_PRIORING, 1);
+	}
+
+	/*
+	 * Disable all interrupts for which a tasklet was scheduled right now,
+	 * the tasklet will reenable the appropriate interrupts.
+	 */
+	spin_lock_irqsave(&rt2x00dev->irqmask_lock, flags);
 
-	/* Disable interrupts, will be enabled again in the interrupt thread. */
-	rt2x00dev->ops->lib->set_device_state(rt2x00dev,
-					      STATE_RADIO_IRQ_OFF_ISR);
+	rt2x00pci_register_read(rt2x00dev, CSR8, &reg);
+	reg |= mask;
+	rt2x00pci_register_write(rt2x00dev, CSR8, reg);
+
+	spin_unlock_irqrestore(&rt2x00dev->irqmask_lock, flags);
 
-	return IRQ_WAKE_THREAD;
+	return IRQ_HANDLED;
 }
 
 /*
@@ -1948,7 +2018,9 @@ static const struct ieee80211_ops rt2500pci_mac80211_ops = {
 
 static const struct rt2x00lib_ops rt2500pci_rt2x00_ops = {
 	.irq_handler		= rt2500pci_interrupt,
-	.irq_handler_thread	= rt2500pci_interrupt_thread,
+	.txstatus_tasklet	= rt2500pci_txstatus_tasklet,
+	.tbtt_tasklet		= rt2500pci_tbtt_tasklet,
+	.rxdone_tasklet		= rt2500pci_rxdone_tasklet,
 	.probe_hw		= rt2500pci_probe_hw,
 	.initialize		= rt2x00pci_initialize,
 	.uninitialize		= rt2x00pci_uninitialize,
-- 
1.7.2.3

