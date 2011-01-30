Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41674 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab1A3MYd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 07:24:33 -0500
Received: by mail-ey0-f174.google.com with SMTP id 27so2146783eye.19
        for <linux-wireless@vger.kernel.org>; Sun, 30 Jan 2011 04:24:33 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 07/21] rt2x00: Convert rt2800pci to use tasklets
Date: Sun, 30 Jan 2011 13:18:38 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201101301316.04044.IvDoorn@gmail.com> <201101301317.53313.IvDoorn@gmail.com> <201101301318.14610.IvDoorn@gmail.com>
In-Reply-To: <201101301318.14610.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201101301318.39263.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Fix interrupt processing on slow machines by using individual tasklets
for each different device interrupt. This ensures that while a RX or TX
status tasklet is scheduled only the according device interrupt is
masked and other interrupts such as TBTT can still be processed.

Also, this allows us to use tasklet_hi_schedule for TBTT and PRETBTT
processing which is required to not send out beacons with a wrong DTIM
count (due to delayed periodic beacon updates). Furthermore, this
improves the latency between the TBTT and sending out buffered multi-
and broadcast traffic.

As a nice bonus, the interrupt handling overhead is reduced such that
rt2800pci gains around 25% more throuhput on a rt3052 MIPS board.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |  173 ++++++++++++++++++++-----------
 1 files changed, 114 insertions(+), 59 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index e4d97ad..31483c7 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -200,6 +200,13 @@ static void rt2800pci_start_queue(struct data_queue *queue)
 		rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
 		break;
 	case QID_BEACON:
+		/*
+		 * Allow beacon tasklets to be scheduled for periodic
+		 * beacon updates.
+		 */
+		tasklet_enable(&rt2x00dev->tbtt_tasklet);
+		tasklet_enable(&rt2x00dev->pretbtt_tasklet);
+
 		rt2800_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
 		rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_TICKING, 1);
 		rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE, 1);
@@ -258,6 +265,12 @@ static void rt2800pci_stop_queue(struct data_queue *queue)
 		rt2800_register_read(rt2x00dev, INT_TIMER_EN, &reg);
 		rt2x00_set_field32(&reg, INT_TIMER_EN_PRE_TBTT_TIMER, 0);
 		rt2800_register_write(rt2x00dev, INT_TIMER_EN, reg);
+
+		/*
+		 * Wait for tbtt tasklets to finish.
+		 */
+		tasklet_disable(&rt2x00dev->tbtt_tasklet);
+		tasklet_disable(&rt2x00dev->pretbtt_tasklet);
 		break;
 	default:
 		break;
@@ -408,6 +421,7 @@ static void rt2800pci_toggle_irq(struct rt2x00_dev *rt2x00dev,
 	int mask = (state == STATE_RADIO_IRQ_ON) ||
 		   (state == STATE_RADIO_IRQ_ON_ISR);
 	u32 reg;
+	unsigned long flags;
 
 	/*
 	 * When interrupts are being enabled, the interrupt registers
@@ -417,10 +431,16 @@ static void rt2800pci_toggle_irq(struct rt2x00_dev *rt2x00dev,
 		rt2800_register_read(rt2x00dev, INT_SOURCE_CSR, &reg);
 		rt2800_register_write(rt2x00dev, INT_SOURCE_CSR, reg);
 
+		/*
+		 * Enable tasklets. The beacon related tasklets are
+		 * enabled when the beacon queue is started.
+		 */
 		tasklet_enable(&rt2x00dev->txstatus_tasklet);
-	} else if (state == STATE_RADIO_IRQ_OFF)
-		tasklet_disable(&rt2x00dev->txstatus_tasklet);
+		tasklet_enable(&rt2x00dev->rxdone_tasklet);
+		tasklet_enable(&rt2x00dev->autowake_tasklet);
+	}
 
+	spin_lock_irqsave(&rt2x00dev->irqmask_lock, flags);
 	rt2800_register_read(rt2x00dev, INT_MASK_CSR, &reg);
 	rt2x00_set_field32(&reg, INT_MASK_CSR_RXDELAYINT, 0);
 	rt2x00_set_field32(&reg, INT_MASK_CSR_TXDELAYINT, 0);
@@ -441,6 +461,17 @@ static void rt2800pci_toggle_irq(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&reg, INT_MASK_CSR_RX_COHERENT, 0);
 	rt2x00_set_field32(&reg, INT_MASK_CSR_TX_COHERENT, 0);
 	rt2800_register_write(rt2x00dev, INT_MASK_CSR, reg);
+	spin_unlock_irqrestore(&rt2x00dev->irqmask_lock, flags);
+
+	if (state == STATE_RADIO_IRQ_OFF) {
+		/*
+		 * Ensure that all tasklets are finished before
+		 * disabling the interrupts.
+		 */
+		tasklet_disable(&rt2x00dev->txstatus_tasklet);
+		tasklet_disable(&rt2x00dev->rxdone_tasklet);
+		tasklet_disable(&rt2x00dev->autowake_tasklet);
+	}
 }
 
 static int rt2800pci_init_registers(struct rt2x00_dev *rt2x00dev)
@@ -721,45 +752,60 @@ static void rt2800pci_txdone(struct rt2x00_dev *rt2x00dev)
 	}
 }
 
-static void rt2800pci_txstatus_tasklet(unsigned long data)
-{
-	rt2800pci_txdone((struct rt2x00_dev *)data);
-}
-
-static irqreturn_t rt2800pci_interrupt_thread(int irq, void *dev_instance)
+static void rt2800pci_enable_interrupt(struct rt2x00_dev *rt2x00dev,
+				       struct rt2x00_field32 irq_field)
 {
-	struct rt2x00_dev *rt2x00dev = dev_instance;
-	u32 reg = rt2x00dev->irqvalue[0];
+	unsigned long flags;
+	u32 reg;
 
 	/*
-	 * 1 - Pre TBTT interrupt.
+	 * Enable a single interrupt. The interrupt mask register
+	 * access needs locking.
 	 */
-	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_PRE_TBTT))
-		rt2x00lib_pretbtt(rt2x00dev);
+	spin_lock_irqsave(&rt2x00dev->irqmask_lock, flags);
+	rt2800_register_read(rt2x00dev, INT_MASK_CSR, &reg);
+	rt2x00_set_field32(&reg, irq_field, 1);
+	rt2800_register_write(rt2x00dev, INT_MASK_CSR, reg);
+	spin_unlock_irqrestore(&rt2x00dev->irqmask_lock, flags);
+}
 
-	/*
-	 * 2 - Beacondone interrupt.
-	 */
-	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_TBTT))
-		rt2x00lib_beacondone(rt2x00dev);
+static void rt2800pci_txstatus_tasklet(unsigned long data)
+{
+	rt2800pci_txdone((struct rt2x00_dev *)data);
 
 	/*
-	 * 3 - Rx ring done interrupt.
+	 * No need to enable the tx status interrupt here as we always
+	 * leave it enabled to minimize the possibility of a tx status
+	 * register overflow. See comment in interrupt handler.
 	 */
-	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_RX_DONE))
-		rt2x00pci_rxdone(rt2x00dev);
+}
 
-	/*
-	 * 4 - Auto wakeup interrupt.
-	 */
-	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_AUTO_WAKEUP))
-		rt2800pci_wakeup(rt2x00dev);
+static void rt2800pci_pretbtt_tasklet(unsigned long data)
+{
+	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
+	rt2x00lib_pretbtt(rt2x00dev);
+	rt2800pci_enable_interrupt(rt2x00dev, INT_MASK_CSR_PRE_TBTT);
+}
 
-	/* Enable interrupts again. */
-	rt2x00dev->ops->lib->set_device_state(rt2x00dev,
-					      STATE_RADIO_IRQ_ON_ISR);
+static void rt2800pci_tbtt_tasklet(unsigned long data)
+{
+	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
+	rt2x00lib_beacondone(rt2x00dev);
+	rt2800pci_enable_interrupt(rt2x00dev, INT_MASK_CSR_TBTT);
+}
 
-	return IRQ_HANDLED;
+static void rt2800pci_rxdone_tasklet(unsigned long data)
+{
+	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
+	rt2x00pci_rxdone(rt2x00dev);
+	rt2800pci_enable_interrupt(rt2x00dev, INT_MASK_CSR_RX_DONE);
+}
+
+static void rt2800pci_autowake_tasklet(unsigned long data)
+{
+	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
+	rt2800pci_wakeup(rt2x00dev);
+	rt2800pci_enable_interrupt(rt2x00dev, INT_MASK_CSR_AUTO_WAKEUP);
 }
 
 static void rt2800pci_txstatus_interrupt(struct rt2x00_dev *rt2x00dev)
@@ -805,8 +851,8 @@ static void rt2800pci_txstatus_interrupt(struct rt2x00_dev *rt2x00dev)
 static irqreturn_t rt2800pci_interrupt(int irq, void *dev_instance)
 {
 	struct rt2x00_dev *rt2x00dev = dev_instance;
-	u32 reg;
-	irqreturn_t ret = IRQ_HANDLED;
+	u32 reg, mask;
+	unsigned long flags;
 
 	/* Read status and ACK all interrupts */
 	rt2800_register_read(rt2x00dev, INT_SOURCE_CSR, &reg);
@@ -818,38 +864,44 @@ static irqreturn_t rt2800pci_interrupt(int irq, void *dev_instance)
 	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
 		return IRQ_HANDLED;
 
-	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_TX_FIFO_STATUS))
-		rt2800pci_txstatus_interrupt(rt2x00dev);
+	/*
+	 * Since INT_MASK_CSR and INT_SOURCE_CSR use the same bits
+	 * for interrupts and interrupt masks we can just use the value of
+	 * INT_SOURCE_CSR to create the interrupt mask.
+	 */
+	mask = ~reg;
 
-	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_PRE_TBTT) ||
-	    rt2x00_get_field32(reg, INT_SOURCE_CSR_TBTT) ||
-	    rt2x00_get_field32(reg, INT_SOURCE_CSR_RX_DONE) ||
-	    rt2x00_get_field32(reg, INT_SOURCE_CSR_AUTO_WAKEUP)) {
+	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_TX_FIFO_STATUS)) {
+		rt2800pci_txstatus_interrupt(rt2x00dev);
 		/*
-		 * All other interrupts are handled in the interrupt thread.
-		 * Store irqvalue for use in the interrupt thread.
+		 * Never disable the TX_FIFO_STATUS interrupt.
 		 */
-		rt2x00dev->irqvalue[0] = reg;
+		rt2x00_set_field32(&mask, INT_MASK_CSR_TX_FIFO_STATUS, 1);
+	}
 
-		/*
-		 * Disable interrupts, will be enabled again in the
-		 * interrupt thread.
-		*/
-		rt2x00dev->ops->lib->set_device_state(rt2x00dev,
-						      STATE_RADIO_IRQ_OFF_ISR);
+	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_PRE_TBTT))
+		tasklet_hi_schedule(&rt2x00dev->pretbtt_tasklet);
 
-		/*
-		 * Leave the TX_FIFO_STATUS interrupt enabled to not lose any
-		 * tx status reports.
-		 */
-		rt2800_register_read(rt2x00dev, INT_MASK_CSR, &reg);
-		rt2x00_set_field32(&reg, INT_MASK_CSR_TX_FIFO_STATUS, 1);
-		rt2800_register_write(rt2x00dev, INT_MASK_CSR, reg);
+	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_TBTT))
+		tasklet_hi_schedule(&rt2x00dev->tbtt_tasklet);
 
-		ret = IRQ_WAKE_THREAD;
-	}
+	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_RX_DONE))
+		tasklet_schedule(&rt2x00dev->rxdone_tasklet);
 
-	return ret;
+	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_AUTO_WAKEUP))
+		tasklet_schedule(&rt2x00dev->autowake_tasklet);
+
+	/*
+	 * Disable all interrupts for which a tasklet was scheduled right now,
+	 * the tasklet will reenable the appropriate interrupts.
+	 */
+	spin_lock_irqsave(&rt2x00dev->irqmask_lock, flags);
+	rt2800_register_read(rt2x00dev, INT_MASK_CSR, &reg);
+	reg &= mask;
+	rt2800_register_write(rt2x00dev, INT_MASK_CSR, reg);
+	spin_unlock_irqrestore(&rt2x00dev->irqmask_lock, flags);
+
+	return IRQ_HANDLED;
 }
 
 /*
@@ -964,8 +1016,11 @@ static const struct rt2800_ops rt2800pci_rt2800_ops = {
 
 static const struct rt2x00lib_ops rt2800pci_rt2x00_ops = {
 	.irq_handler		= rt2800pci_interrupt,
-	.irq_handler_thread	= rt2800pci_interrupt_thread,
-	.txstatus_tasklet       = rt2800pci_txstatus_tasklet,
+	.txstatus_tasklet	= rt2800pci_txstatus_tasklet,
+	.pretbtt_tasklet	= rt2800pci_pretbtt_tasklet,
+	.tbtt_tasklet		= rt2800pci_tbtt_tasklet,
+	.rxdone_tasklet		= rt2800pci_rxdone_tasklet,
+	.autowake_tasklet	= rt2800pci_autowake_tasklet,
 	.probe_hw		= rt2800pci_probe_hw,
 	.get_firmware_name	= rt2800pci_get_firmware_name,
 	.check_firmware		= rt2800_check_firmware,
-- 
1.7.2.3

