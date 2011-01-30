Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41674 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab1A3MYf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 07:24:35 -0500
Received: by mail-ey0-f174.google.com with SMTP id 27so2146783eye.19
        for <linux-wireless@vger.kernel.org>; Sun, 30 Jan 2011 04:24:34 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 08/21] rt2x00: Convert rt61pci to use tasklets
Date: Sun, 30 Jan 2011 13:19:08 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201101301316.04044.IvDoorn@gmail.com> <201101301318.14610.IvDoorn@gmail.com> <201101301318.39263.IvDoorn@gmail.com>
In-Reply-To: <201101301318.39263.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201101301319.08812.IvDoorn@gmail.com>
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
 drivers/net/wireless/rt2x00/rt61pci.c |  175 ++++++++++++++++++++++++---------
 1 files changed, 130 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index f14cc45..351055d 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1142,6 +1142,11 @@ static void rt61pci_start_queue(struct data_queue *queue)
 		rt2x00pci_register_write(rt2x00dev, TXRX_CSR0, reg);
 		break;
 	case QID_BEACON:
+		/*
+		 * Allow the tbtt tasklet to be scheduled.
+		 */
+		tasklet_enable(&rt2x00dev->tbtt_tasklet);
+
 		rt2x00pci_register_read(rt2x00dev, TXRX_CSR9, &reg);
 		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_TICKING, 1);
 		rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 1);
@@ -1221,6 +1226,11 @@ static void rt61pci_stop_queue(struct data_queue *queue)
 		rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 0);
 		rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 0);
 		rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, reg);
+
+		/*
+		 * Wait for possibly running tbtt tasklets.
+		 */
+		tasklet_disable(&rt2x00dev->tbtt_tasklet);
 		break;
 	default:
 		break;
@@ -1710,6 +1720,7 @@ static void rt61pci_toggle_irq(struct rt2x00_dev *rt2x00dev,
 	int mask = (state == STATE_RADIO_IRQ_OFF) ||
 		   (state == STATE_RADIO_IRQ_OFF_ISR);
 	u32 reg;
+	unsigned long flags;
 
 	/*
 	 * When interrupts are being enabled, the interrupt registers
@@ -1721,12 +1732,21 @@ static void rt61pci_toggle_irq(struct rt2x00_dev *rt2x00dev,
 
 		rt2x00pci_register_read(rt2x00dev, MCU_INT_SOURCE_CSR, &reg);
 		rt2x00pci_register_write(rt2x00dev, MCU_INT_SOURCE_CSR, reg);
+
+		/*
+		 * Enable tasklets.
+		 */
+		tasklet_enable(&rt2x00dev->txstatus_tasklet);
+		tasklet_enable(&rt2x00dev->rxdone_tasklet);
+		tasklet_enable(&rt2x00dev->autowake_tasklet);
 	}
 
 	/*
 	 * Only toggle the interrupts bits we are going to use.
 	 * Non-checked interrupt bits are disabled by default.
 	 */
+	spin_lock_irqsave(&rt2x00dev->irqmask_lock, flags);
+
 	rt2x00pci_register_read(rt2x00dev, INT_MASK_CSR, &reg);
 	rt2x00_set_field32(&reg, INT_MASK_CSR_TXDONE, mask);
 	rt2x00_set_field32(&reg, INT_MASK_CSR_RXDONE, mask);
@@ -1746,6 +1766,17 @@ static void rt61pci_toggle_irq(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&reg, MCU_INT_MASK_CSR_7, mask);
 	rt2x00_set_field32(&reg, MCU_INT_MASK_CSR_TWAKEUP, mask);
 	rt2x00pci_register_write(rt2x00dev, MCU_INT_MASK_CSR, reg);
+
+	spin_unlock_irqrestore(&rt2x00dev->irqmask_lock, flags);
+
+	if (state == STATE_RADIO_IRQ_OFF) {
+		/*
+		 * Ensure that all tasklets are finished.
+		 */
+		tasklet_disable(&rt2x00dev->txstatus_tasklet);
+		tasklet_disable(&rt2x00dev->rxdone_tasklet);
+		tasklet_disable(&rt2x00dev->autowake_tasklet);
+	}
 }
 
 static int rt61pci_enable_radio(struct rt2x00_dev *rt2x00dev)
@@ -2223,61 +2254,80 @@ static void rt61pci_wakeup(struct rt2x00_dev *rt2x00dev)
 	rt61pci_config(rt2x00dev, &libconf, IEEE80211_CONF_CHANGE_PS);
 }
 
-static irqreturn_t rt61pci_interrupt_thread(int irq, void *dev_instance)
+static void rt61pci_enable_interrupt(struct rt2x00_dev *rt2x00dev,
+				     struct rt2x00_field32 irq_field)
 {
-	struct rt2x00_dev *rt2x00dev = dev_instance;
-	u32 reg = rt2x00dev->irqvalue[0];
-	u32 reg_mcu = rt2x00dev->irqvalue[1];
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
-	 * 1 - Rx ring done interrupt.
-	 */
-	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_RXDONE))
-		rt2x00pci_rxdone(rt2x00dev);
+	rt2x00pci_register_read(rt2x00dev, INT_MASK_CSR, &reg);
+	rt2x00_set_field32(&reg, irq_field, 0);
+	rt2x00pci_register_write(rt2x00dev, INT_MASK_CSR, reg);
 
-	/*
-	 * 2 - Tx ring done interrupt.
-	 */
-	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_TXDONE))
-		rt61pci_txdone(rt2x00dev);
+	spin_unlock_irqrestore(&rt2x00dev->irqmask_lock, flags);
+}
 
-	/*
-	 * 3 - Handle MCU command done.
-	 */
-	if (reg_mcu)
-		rt2x00pci_register_write(rt2x00dev,
-					 M2H_CMD_DONE_CSR, 0xffffffff);
+static void rt61pci_enable_mcu_interrupt(struct rt2x00_dev *rt2x00dev,
+					 struct rt2x00_field32 irq_field)
+{
+	unsigned long flags;
+	u32 reg;
 
 	/*
-	 * 4 - MCU Autowakeup interrupt.
+	 * Enable a single MCU interrupt. The interrupt mask register
+	 * access needs locking.
 	 */
-	if (rt2x00_get_field32(reg_mcu, MCU_INT_SOURCE_CSR_TWAKEUP))
-		rt61pci_wakeup(rt2x00dev);
+	spin_lock_irqsave(&rt2x00dev->irqmask_lock, flags);
 
-	/*
-	 * 5 - Beacon done interrupt.
-	 */
-	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_BEACON_DONE))
-		rt2x00lib_beacondone(rt2x00dev);
+	rt2x00pci_register_read(rt2x00dev, MCU_INT_MASK_CSR, &reg);
+	rt2x00_set_field32(&reg, irq_field, 0);
+	rt2x00pci_register_write(rt2x00dev, MCU_INT_MASK_CSR, reg);
 
-	/* Enable interrupts again. */
-	rt2x00dev->ops->lib->set_device_state(rt2x00dev,
-					      STATE_RADIO_IRQ_ON_ISR);
-	return IRQ_HANDLED;
+	spin_unlock_irqrestore(&rt2x00dev->irqmask_lock, flags);
 }
 
+static void rt61pci_txstatus_tasklet(unsigned long data)
+{
+	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
+	rt61pci_txdone(rt2x00dev);
+	rt61pci_enable_interrupt(rt2x00dev, INT_MASK_CSR_TXDONE);
+}
+
+static void rt61pci_tbtt_tasklet(unsigned long data)
+{
+	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
+	rt2x00lib_beacondone(rt2x00dev);
+	rt61pci_enable_interrupt(rt2x00dev, INT_MASK_CSR_BEACON_DONE);
+}
+
+static void rt61pci_rxdone_tasklet(unsigned long data)
+{
+	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
+	rt2x00pci_rxdone(rt2x00dev);
+	rt61pci_enable_interrupt(rt2x00dev, INT_MASK_CSR_RXDONE);
+}
+
+static void rt61pci_autowake_tasklet(unsigned long data)
+{
+	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
+	rt61pci_wakeup(rt2x00dev);
+	rt2x00pci_register_write(rt2x00dev,
+				 M2H_CMD_DONE_CSR, 0xffffffff);
+	rt61pci_enable_mcu_interrupt(rt2x00dev, MCU_INT_MASK_CSR_TWAKEUP);
+}
 
 static irqreturn_t rt61pci_interrupt(int irq, void *dev_instance)
 {
 	struct rt2x00_dev *rt2x00dev = dev_instance;
-	u32 reg_mcu;
-	u32 reg;
+	u32 reg_mcu, mask_mcu;
+	u32 reg, mask;
+	unsigned long flags;
 
 	/*
 	 * Get the interrupt sources & saved to local variable.
@@ -2295,14 +2345,46 @@ static irqreturn_t rt61pci_interrupt(int irq, void *dev_instance)
 	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
 		return IRQ_HANDLED;
 
-	/* Store irqvalues for use in the interrupt thread. */
-	rt2x00dev->irqvalue[0] = reg;
-	rt2x00dev->irqvalue[1] = reg_mcu;
+	/*
+	 * Schedule tasklets for interrupt handling.
+	 */
+	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_RXDONE))
+		tasklet_schedule(&rt2x00dev->rxdone_tasklet);
+
+	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_TXDONE))
+		tasklet_schedule(&rt2x00dev->txstatus_tasklet);
+
+	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_BEACON_DONE))
+		tasklet_hi_schedule(&rt2x00dev->tbtt_tasklet);
+
+	if (rt2x00_get_field32(reg_mcu, MCU_INT_SOURCE_CSR_TWAKEUP))
+		tasklet_schedule(&rt2x00dev->autowake_tasklet);
+
+	/*
+	 * Since INT_MASK_CSR and INT_SOURCE_CSR use the same bits
+	 * for interrupts and interrupt masks we can just use the value of
+	 * INT_SOURCE_CSR to create the interrupt mask.
+	 */
+	mask = reg;
+	mask_mcu = reg_mcu;
+
+	/*
+	 * Disable all interrupts for which a tasklet was scheduled right now,
+	 * the tasklet will reenable the appropriate interrupts.
+	 */
+	spin_lock_irqsave(&rt2x00dev->irqmask_lock, flags);
+
+	rt2x00pci_register_read(rt2x00dev, INT_MASK_CSR, &reg);
+	reg |= mask;
+	rt2x00pci_register_write(rt2x00dev, INT_MASK_CSR, reg);
 
-	/* Disable interrupts, will be enabled again in the interrupt thread. */
-	rt2x00dev->ops->lib->set_device_state(rt2x00dev,
-					      STATE_RADIO_IRQ_OFF_ISR);
-	return IRQ_WAKE_THREAD;
+	rt2x00pci_register_read(rt2x00dev, MCU_INT_MASK_CSR, &reg);
+	reg |= mask_mcu;
+	rt2x00pci_register_write(rt2x00dev, MCU_INT_MASK_CSR, reg);
+
+	spin_unlock_irqrestore(&rt2x00dev->irqmask_lock, flags);
+
+	return IRQ_HANDLED;
 }
 
 /*
@@ -2896,7 +2978,10 @@ static const struct ieee80211_ops rt61pci_mac80211_ops = {
 
 static const struct rt2x00lib_ops rt61pci_rt2x00_ops = {
 	.irq_handler		= rt61pci_interrupt,
-	.irq_handler_thread	= rt61pci_interrupt_thread,
+	.txstatus_tasklet	= rt61pci_txstatus_tasklet,
+	.tbtt_tasklet		= rt61pci_tbtt_tasklet,
+	.rxdone_tasklet		= rt61pci_rxdone_tasklet,
+	.autowake_tasklet	= rt61pci_autowake_tasklet,
 	.probe_hw		= rt61pci_probe_hw,
 	.get_firmware_name	= rt61pci_get_firmware_name,
 	.check_firmware		= rt61pci_check_firmware,
-- 
1.7.2.3

