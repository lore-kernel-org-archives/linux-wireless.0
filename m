Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:34152 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933995AbZIDU6O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Sep 2009 16:58:14 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 1/5] b43: Use a threaded IRQ handler
Date: Fri, 4 Sep 2009 22:51:29 +0200
Cc: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	Albert Herranz <albert_herranz@yahoo.es>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200909042251.29868.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use a threaded IRQ handler to allow locking the mutex and
sleeping while executing an interrupt.
This removes usage of the irq_lock spinlock, but introduces
a new hardirq_lock, which is _only_ used for the PCI/SSB lowlevel
hard-irq handler. Sleeping busses (SDIO) will use mutex instead.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-testing/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/b43.h	2009-09-04 22:15:30.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/b43.h	2009-09-04 22:15:32.000000000 +0200
@@ -616,6 +616,12 @@ struct b43_wl {
 	/* Pointer to the ieee80211 hardware data structure */
 	struct ieee80211_hw *hw;
 
+	/* Global driver mutex. Every operation must run with this mutex locked. */
+	struct mutex mutex;
+	/* Hard-IRQ spinlock. This lock protects things used in the hard-IRQ
+	 * handler, only. This basically is just the IRQ mask register. */
+	spinlock_t hardirq_lock;
+
 	/* The number of queues that were registered with the mac80211 subsystem
 	 * initially. This is a backup copy of hw->queues in case hw->queues has
 	 * to be dynamically lowered at runtime (Firmware does not support QoS).
@@ -623,8 +629,6 @@ struct b43_wl {
 	 * from the mac80211 subsystem. */
 	u16 mac80211_initially_registered_queues;
 
-	struct mutex mutex;
-	spinlock_t irq_lock;
 	/* R/W lock for data transmission.
 	 * Transmissions on 2+ queues can run concurrently, but somebody else
 	 * might sync with TX by write_lock_irqsave()'ing. */
@@ -665,8 +669,7 @@ struct b43_wl {
 	bool radiotap_enabled;
 	bool radio_enabled;
 
-	/* The beacon we are currently using (AP or IBSS mode).
-	 * This beacon stuff is protected by the irq_lock. */
+	/* The beacon we are currently using (AP or IBSS mode). */
 	struct sk_buff *current_beacon;
 	bool beacon0_uploaded;
 	bool beacon1_uploaded;
@@ -754,14 +757,6 @@ enum {
 		smp_wmb();					\
 					} while (0)
 
-/* XXX---   HOW LOCKING WORKS IN B43   ---XXX
- *
- * You should always acquire both, wl->mutex and wl->irq_lock unless:
- * - You don't need to acquire wl->irq_lock, if the interface is stopped.
- * - You don't need to acquire wl->mutex in the IRQ handler, IRQ tasklet
- *   and packet TX path (and _ONLY_ there.)
- */
-
 /* Data structure for one wireless device (802.11 core) */
 struct b43_wldev {
 	struct ssb_device *dev;
@@ -807,14 +802,12 @@ struct b43_wldev {
 	u32 dma_reason[6];
 	/* The currently active generic-interrupt mask. */
 	u32 irq_mask;
+
 	/* Link Quality calculation context. */
 	struct b43_noise_calculation noisecalc;
 	/* if > 0 MAC is suspended. if == 0 MAC is enabled. */
 	int mac_suspended;
 
-	/* Interrupt Service Routine tasklet (bottom-half) */
-	struct tasklet_struct isr_tasklet;
-
 	/* Periodic tasks */
 	struct delayed_work periodic_work;
 	unsigned int periodic_state;
Index: wireless-testing/drivers/net/wireless/b43/debugfs.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/debugfs.c	2009-09-04 22:15:30.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/debugfs.c	2009-09-04 22:15:32.000000000 +0200
@@ -46,8 +46,6 @@ struct b43_debugfs_fops {
 	struct file_operations fops;
 	/* Offset of struct b43_dfs_file in struct b43_dfsentry */
 	size_t file_struct_offset;
-	/* Take wl->irq_lock before calling read/write? */
-	bool take_irqlock;
 };
 
 static inline
@@ -372,14 +370,12 @@ static ssize_t txstat_read_file(struct b
 {
 	struct b43_txstatus_log *log = &dev->dfsentry->txstatlog;
 	ssize_t count = 0;
-	unsigned long flags;
 	int i, idx;
 	struct b43_txstatus *stat;
 
-	spin_lock_irqsave(&log->lock, flags);
 	if (log->end < 0) {
 		fappend("Nothing transmitted, yet\n");
-		goto out_unlock;
+		goto out;
 	}
 	fappend("b43 TX status reports:\n\n"
 		"index | cookie | seq | phy_stat | frame_count | "
@@ -409,13 +405,11 @@ static ssize_t txstat_read_file(struct b
 			break;
 		i++;
 	}
-out_unlock:
-	spin_unlock_irqrestore(&log->lock, flags);
+out:
 
 	return count;
 }
 
-/* wl->irq_lock is locked */
 static int restart_write_file(struct b43_wldev *dev,
 			      const char *buf, size_t count)
 {
@@ -556,12 +550,7 @@ static ssize_t b43_debugfs_read(struct f
 			goto out_unlock;
 		}
 		memset(buf, 0, bufsize);
-		if (dfops->take_irqlock) {
-			spin_lock_irq(&dev->wl->irq_lock);
-			ret = dfops->read(dev, buf, bufsize);
-			spin_unlock_irq(&dev->wl->irq_lock);
-		} else
-			ret = dfops->read(dev, buf, bufsize);
+		ret = dfops->read(dev, buf, bufsize);
 		if (ret <= 0) {
 			free_pages((unsigned long)buf, buforder);
 			err = ret;
@@ -623,12 +612,7 @@ static ssize_t b43_debugfs_write(struct 
 		err = -EFAULT;
 		goto out_freepage;
 	}
-	if (dfops->take_irqlock) {
-		spin_lock_irq(&dev->wl->irq_lock);
-		err = dfops->write(dev, buf, count);
-		spin_unlock_irq(&dev->wl->irq_lock);
-	} else
-		err = dfops->write(dev, buf, count);
+	err = dfops->write(dev, buf, count);
 	if (err)
 		goto out_freepage;
 
@@ -641,7 +625,7 @@ out_unlock:
 }
 
 
-#define B43_DEBUGFS_FOPS(name, _read, _write, _take_irqlock)	\
+#define B43_DEBUGFS_FOPS(name, _read, _write)			\
 	static struct b43_debugfs_fops fops_##name = {		\
 		.read	= _read,				\
 		.write	= _write,				\
@@ -652,20 +636,19 @@ out_unlock:
 		},						\
 		.file_struct_offset = offsetof(struct b43_dfsentry, \
 					       file_##name),	\
-		.take_irqlock	= _take_irqlock,		\
 	}
 
-B43_DEBUGFS_FOPS(shm16read, shm16read__read_file, shm16read__write_file, 1);
-B43_DEBUGFS_FOPS(shm16write, NULL, shm16write__write_file, 1);
-B43_DEBUGFS_FOPS(shm32read, shm32read__read_file, shm32read__write_file, 1);
-B43_DEBUGFS_FOPS(shm32write, NULL, shm32write__write_file, 1);
-B43_DEBUGFS_FOPS(mmio16read, mmio16read__read_file, mmio16read__write_file, 1);
-B43_DEBUGFS_FOPS(mmio16write, NULL, mmio16write__write_file, 1);
-B43_DEBUGFS_FOPS(mmio32read, mmio32read__read_file, mmio32read__write_file, 1);
-B43_DEBUGFS_FOPS(mmio32write, NULL, mmio32write__write_file, 1);
-B43_DEBUGFS_FOPS(txstat, txstat_read_file, NULL, 0);
-B43_DEBUGFS_FOPS(restart, NULL, restart_write_file, 1);
-B43_DEBUGFS_FOPS(loctls, loctls_read_file, NULL, 0);
+B43_DEBUGFS_FOPS(shm16read, shm16read__read_file, shm16read__write_file);
+B43_DEBUGFS_FOPS(shm16write, NULL, shm16write__write_file);
+B43_DEBUGFS_FOPS(shm32read, shm32read__read_file, shm32read__write_file);
+B43_DEBUGFS_FOPS(shm32write, NULL, shm32write__write_file);
+B43_DEBUGFS_FOPS(mmio16read, mmio16read__read_file, mmio16read__write_file);
+B43_DEBUGFS_FOPS(mmio16write, NULL, mmio16write__write_file);
+B43_DEBUGFS_FOPS(mmio32read, mmio32read__read_file, mmio32read__write_file);
+B43_DEBUGFS_FOPS(mmio32write, NULL, mmio32write__write_file);
+B43_DEBUGFS_FOPS(txstat, txstat_read_file, NULL);
+B43_DEBUGFS_FOPS(restart, NULL, restart_write_file);
+B43_DEBUGFS_FOPS(loctls, loctls_read_file, NULL);
 
 
 bool b43_debug(struct b43_wldev *dev, enum b43_dyndbg feature)
@@ -738,7 +721,6 @@ void b43_debugfs_add_device(struct b43_w
 		return;
 	}
 	log->end = -1;
-	spin_lock_init(&log->lock);
 
 	dev->dfsentry = e;
 
@@ -822,7 +804,6 @@ void b43_debugfs_remove_device(struct b4
 	kfree(e);
 }
 
-/* Called with IRQs disabled. */
 void b43_debugfs_log_txstat(struct b43_wldev *dev,
 			    const struct b43_txstatus *status)
 {
@@ -834,14 +815,12 @@ void b43_debugfs_log_txstat(struct b43_w
 	if (!e)
 		return;
 	log = &e->txstatlog;
-	spin_lock(&log->lock); /* IRQs are already disabled. */
 	i = log->end + 1;
 	if (i == B43_NR_LOGGED_TXSTATUS)
 		i = 0;
 	log->end = i;
 	cur = &(log->log[i]);
 	memcpy(cur, status, sizeof(*cur));
-	spin_unlock(&log->lock);
 }
 
 void b43_debugfs_init(void)
Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2009-09-04 22:15:30.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2009-09-04 22:17:06.000000000 +0200
@@ -291,7 +291,7 @@ static struct ieee80211_supported_band b
 
 static void b43_wireless_core_exit(struct b43_wldev *dev);
 static int b43_wireless_core_init(struct b43_wldev *dev);
-static void b43_wireless_core_stop(struct b43_wldev *dev);
+static struct b43_wldev * b43_wireless_core_stop(struct b43_wldev *dev);
 static int b43_wireless_core_start(struct b43_wldev *dev);
 
 static int b43_ratelimit(struct b43_wl *wl)
@@ -685,16 +685,6 @@ static void b43_short_slot_timing_disabl
 	b43_set_slot_time(dev, 20);
 }
 
-/* Synchronize IRQ top- and bottom-half.
- * IRQs must be masked before calling this.
- * This must not be called with the irq_lock held.
- */
-static void b43_synchronize_irq(struct b43_wldev *dev)
-{
-	synchronize_irq(dev->dev->irq);
-	tasklet_kill(&dev->isr_tasklet);
-}
-
 /* DummyTransmission function, as documented on
  * http://bcm-v4.sipsolutions.net/802.11/DummyTransmission
  */
@@ -720,8 +710,7 @@ void b43_dummy_transmission(struct b43_w
 		buffer[0] = 0x000B846E;
 	}
 
-	spin_lock_irq(&wl->irq_lock);
-	write_lock(&wl->tx_lock);
+	write_lock_irq(&wl->tx_lock);
 
 	for (i = 0; i < 5; i++)
 		b43_ram_write(dev, i * 4, buffer[i]);
@@ -779,8 +768,7 @@ void b43_dummy_transmission(struct b43_w
 	if (phy->radio_ver == 0x2050 && phy->radio_rev <= 0x5)
 		b43_radio_write16(dev, 0x0051, 0x0037);
 
-	write_unlock(&wl->tx_lock);
-	spin_unlock_irq(&wl->irq_lock);
+	write_unlock_irq(&wl->tx_lock);
 }
 
 static void key_write(struct b43_wldev *dev,
@@ -1620,6 +1608,27 @@ static void handle_irq_beacon(struct b43
 	}
 }
 
+static void b43_do_beacon_update_trigger_work(struct b43_wldev *dev)
+{
+	u32 old_irq_mask = dev->irq_mask;
+
+	/* update beacon right away or defer to irq */
+	handle_irq_beacon(dev);
+	if (old_irq_mask != dev->irq_mask) {
+		/* The handler updated the IRQ mask. */
+		B43_WARN_ON(!dev->irq_mask);
+		if (b43_read32(dev, B43_MMIO_GEN_IRQ_MASK)) {
+			b43_write32(dev, B43_MMIO_GEN_IRQ_MASK, dev->irq_mask);
+		} else {
+			/* Device interrupts are currently disabled. That means
+			 * we just ran the hardirq handler and scheduled the
+			 * IRQ thread. The thread will write the IRQ mask when
+			 * it finished, so there's nothing to do here. Writing
+			 * the mask _here_ would incorrectly re-enable IRQs. */
+		}
+	}
+}
+
 static void b43_beacon_update_trigger_work(struct work_struct *work)
 {
 	struct b43_wl *wl = container_of(work, struct b43_wl,
@@ -1629,19 +1638,22 @@ static void b43_beacon_update_trigger_wo
 	mutex_lock(&wl->mutex);
 	dev = wl->current_dev;
 	if (likely(dev && (b43_status(dev) >= B43_STAT_INITIALIZED))) {
-		spin_lock_irq(&wl->irq_lock);
-		/* update beacon right away or defer to irq */
-		handle_irq_beacon(dev);
-		/* The handler might have updated the IRQ mask. */
-		b43_write32(dev, B43_MMIO_GEN_IRQ_MASK, dev->irq_mask);
-		mmiowb();
-		spin_unlock_irq(&wl->irq_lock);
+		if (0 /*FIXME dev->dev->bus->bustype == SSB_BUSTYPE_SDIO*/) {
+			/* wl->mutex is enough. */
+			b43_do_beacon_update_trigger_work(dev);
+			mmiowb();
+		} else {
+			spin_lock_irq(&wl->hardirq_lock);
+			b43_do_beacon_update_trigger_work(dev);
+			mmiowb();
+			spin_unlock_irq(&wl->hardirq_lock);
+		}
 	}
 	mutex_unlock(&wl->mutex);
 }
 
 /* Asynchronously update the packet templates in template RAM.
- * Locking: Requires wl->irq_lock to be locked. */
+ * Locking: Requires wl->mutex to be locked. */
 static void b43_update_templates(struct b43_wl *wl)
 {
 	struct sk_buff *beacon;
@@ -1778,18 +1790,15 @@ out:
 			B43_DEBUGIRQ_REASON_REG, B43_DEBUGIRQ_ACK);
 }
 
-/* Interrupt handler bottom-half */
-static void b43_interrupt_tasklet(struct b43_wldev *dev)
+static void b43_do_interrupt_thread(struct b43_wldev *dev)
 {
 	u32 reason;
 	u32 dma_reason[ARRAY_SIZE(dev->dma_reason)];
 	u32 merged_dma_reason = 0;
 	int i;
-	unsigned long flags;
-
-	spin_lock_irqsave(&dev->wl->irq_lock, flags);
 
-	B43_WARN_ON(b43_status(dev) != B43_STAT_STARTED);
+	if (unlikely(b43_status(dev) != B43_STAT_STARTED))
+		return;
 
 	reason = dev->irq_reason;
 	for (i = 0; i < ARRAY_SIZE(dma_reason); i++) {
@@ -1822,8 +1831,6 @@ static void b43_interrupt_tasklet(struct
 			       dma_reason[2], dma_reason[3],
 			       dma_reason[4], dma_reason[5]);
 			b43_controller_restart(dev, "DMA error");
-			mmiowb();
-			spin_unlock_irqrestore(&dev->wl->irq_lock, flags);
 			return;
 		}
 		if (merged_dma_reason & B43_DMAIRQ_NONFATALMASK) {
@@ -1867,47 +1874,36 @@ static void b43_interrupt_tasklet(struct
 	if (reason & B43_IRQ_TX_OK)
 		handle_irq_transmit_status(dev);
 
+	/* Re-enable interrupts on the device by restoring the current interrupt mask. */
 	b43_write32(dev, B43_MMIO_GEN_IRQ_MASK, dev->irq_mask);
-	mmiowb();
-	spin_unlock_irqrestore(&dev->wl->irq_lock, flags);
 }
 
-static void b43_interrupt_ack(struct b43_wldev *dev, u32 reason)
+/* Interrupt thread handler. Handles device interrupts in thread context. */
+static irqreturn_t b43_interrupt_thread_handler(int irq, void *dev_id)
 {
-	b43_write32(dev, B43_MMIO_GEN_IRQ_REASON, reason);
+	struct b43_wldev *dev = dev_id;
 
-	b43_write32(dev, B43_MMIO_DMA0_REASON, dev->dma_reason[0]);
-	b43_write32(dev, B43_MMIO_DMA1_REASON, dev->dma_reason[1]);
-	b43_write32(dev, B43_MMIO_DMA2_REASON, dev->dma_reason[2]);
-	b43_write32(dev, B43_MMIO_DMA3_REASON, dev->dma_reason[3]);
-	b43_write32(dev, B43_MMIO_DMA4_REASON, dev->dma_reason[4]);
-/* Unused ring
-	b43_write32(dev, B43_MMIO_DMA5_REASON, dev->dma_reason[5]);
-*/
+	mutex_lock(&dev->wl->mutex);
+	b43_do_interrupt_thread(dev);
+	mmiowb();
+	mutex_unlock(&dev->wl->mutex);
+
+	return IRQ_HANDLED;
 }
 
-/* Interrupt handler top-half */
-static irqreturn_t b43_interrupt_handler(int irq, void *dev_id)
+static irqreturn_t b43_do_interrupt(struct b43_wldev *dev)
 {
-	irqreturn_t ret = IRQ_NONE;
-	struct b43_wldev *dev = dev_id;
 	u32 reason;
 
-	B43_WARN_ON(!dev);
+	/* This code runs under wl->hardirq_lock, but _only_ on non-SDIO busses.
+	 * On SDIO, this runs under wl->mutex. */
 
-	spin_lock(&dev->wl->irq_lock);
-
-	if (unlikely(b43_status(dev) < B43_STAT_STARTED)) {
-		/* This can only happen on shared IRQ lines. */
-		goto out;
-	}
 	reason = b43_read32(dev, B43_MMIO_GEN_IRQ_REASON);
 	if (reason == 0xffffffff)	/* shared IRQ */
-		goto out;
-	ret = IRQ_HANDLED;
+		return IRQ_NONE;
 	reason &= dev->irq_mask;
 	if (!reason)
-		goto out;
+		return IRQ_HANDLED;
 
 	dev->dma_reason[0] = b43_read32(dev, B43_MMIO_DMA0_REASON)
 	    & 0x0001DC00;
@@ -1924,15 +1920,38 @@ static irqreturn_t b43_interrupt_handler
 	    & 0x0000DC00;
 */
 
-	b43_interrupt_ack(dev, reason);
-	/* disable all IRQs. They are enabled again in the bottom half. */
+	/* ACK the interrupt. */
+	b43_write32(dev, B43_MMIO_GEN_IRQ_REASON, reason);
+	b43_write32(dev, B43_MMIO_DMA0_REASON, dev->dma_reason[0]);
+	b43_write32(dev, B43_MMIO_DMA1_REASON, dev->dma_reason[1]);
+	b43_write32(dev, B43_MMIO_DMA2_REASON, dev->dma_reason[2]);
+	b43_write32(dev, B43_MMIO_DMA3_REASON, dev->dma_reason[3]);
+	b43_write32(dev, B43_MMIO_DMA4_REASON, dev->dma_reason[4]);
+/* Unused ring
+	b43_write32(dev, B43_MMIO_DMA5_REASON, dev->dma_reason[5]);
+*/
+
+	/* Disable IRQs on the device. The IRQ thread handler will re-enable them. */
 	b43_write32(dev, B43_MMIO_GEN_IRQ_MASK, 0);
-	/* save the reason code and call our bottom half. */
+	/* Save the reason bitmasks for the IRQ thread handler. */
 	dev->irq_reason = reason;
-	tasklet_schedule(&dev->isr_tasklet);
-out:
+
+	return IRQ_WAKE_THREAD;
+}
+
+/* Interrupt handler top-half. This runs with interrupts disabled. */
+static irqreturn_t b43_interrupt_handler(int irq, void *dev_id)
+{
+	struct b43_wldev *dev = dev_id;
+	irqreturn_t ret;
+
+	if (unlikely(b43_status(dev) < B43_STAT_STARTED))
+		return IRQ_NONE;
+
+	spin_lock(&dev->wl->hardirq_lock);
+	ret = b43_do_interrupt(dev);
 	mmiowb();
-	spin_unlock(&dev->wl->irq_lock);
+	spin_unlock(&dev->wl->hardirq_lock);
 
 	return ret;
 }
@@ -3038,15 +3057,12 @@ static void b43_security_init(struct b43
 static int b43_rng_read(struct hwrng *rng, u32 *data)
 {
 	struct b43_wl *wl = (struct b43_wl *)rng->priv;
-	unsigned long flags;
 
-	/* Don't take wl->mutex here, as it could deadlock with
-	 * hwrng internal locking. It's not needed to take
-	 * wl->mutex here, anyway. */
+	/* FIXME: We need to take wl->mutex here to make sure the device
+	 * is not going away from under our ass. However it could deadlock
+	 * with hwrng internal locking. */
 
-	spin_lock_irqsave(&wl->irq_lock, flags);
 	*data = b43_read16(wl->current_dev, B43_MMIO_RNG);
-	spin_unlock_irqrestore(&wl->irq_lock, flags);
 
 	return (sizeof(u16));
 }
@@ -3283,22 +3299,20 @@ static int b43_op_get_tx_stats(struct ie
 			       struct ieee80211_tx_queue_stats *stats)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
-	struct b43_wldev *dev = wl->current_dev;
-	unsigned long flags;
+	struct b43_wldev *dev;
 	int err = -ENODEV;
 
-	if (!dev)
-		goto out;
-	spin_lock_irqsave(&wl->irq_lock, flags);
-	if (likely(b43_status(dev) >= B43_STAT_STARTED)) {
+	mutex_lock(&wl->mutex);
+	dev = wl->current_dev;
+	if (dev && b43_status(dev) >= B43_STAT_STARTED) {
 		if (b43_using_pio_transfers(dev))
 			b43_pio_get_tx_stats(dev, stats);
 		else
 			b43_dma_get_tx_stats(dev, stats);
 		err = 0;
 	}
-	spin_unlock_irqrestore(&wl->irq_lock, flags);
-out:
+	mutex_unlock(&wl->mutex);
+
 	return err;
 }
 
@@ -3306,11 +3320,10 @@ static int b43_op_get_stats(struct ieee8
 			    struct ieee80211_low_level_stats *stats)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
-	unsigned long flags;
 
-	spin_lock_irqsave(&wl->irq_lock, flags);
+	mutex_lock(&wl->mutex);
 	memcpy(stats, &wl->ieee_stats, sizeof(*stats));
-	spin_unlock_irqrestore(&wl->irq_lock, flags);
+	mutex_unlock(&wl->mutex);
 
 	return 0;
 }
@@ -3322,7 +3335,6 @@ static u64 b43_op_get_tsf(struct ieee802
 	u64 tsf;
 
 	mutex_lock(&wl->mutex);
-	spin_lock_irq(&wl->irq_lock);
 	dev = wl->current_dev;
 
 	if (dev && (b43_status(dev) >= B43_STAT_INITIALIZED))
@@ -3330,7 +3342,6 @@ static u64 b43_op_get_tsf(struct ieee802
 	else
 		tsf = 0;
 
-	spin_unlock_irq(&wl->irq_lock);
 	mutex_unlock(&wl->mutex);
 
 	return tsf;
@@ -3342,13 +3353,11 @@ static void b43_op_set_tsf(struct ieee80
 	struct b43_wldev *dev;
 
 	mutex_lock(&wl->mutex);
-	spin_lock_irq(&wl->irq_lock);
 	dev = wl->current_dev;
 
 	if (dev && (b43_status(dev) >= B43_STAT_INITIALIZED))
 		b43_tsf_write(dev, tsf);
 
-	spin_unlock_irq(&wl->irq_lock);
 	mutex_unlock(&wl->mutex);
 }
 
@@ -3434,7 +3443,7 @@ static int b43_switch_band(struct b43_wl
 	prev_status = b43_status(down_dev);
 	/* Shutdown the currently running core. */
 	if (prev_status >= B43_STAT_STARTED)
-		b43_wireless_core_stop(down_dev);
+		down_dev = b43_wireless_core_stop(down_dev);
 	if (prev_status >= B43_STAT_INITIALIZED)
 		b43_wireless_core_exit(down_dev);
 
@@ -3498,7 +3507,6 @@ static int b43_op_config(struct ieee8021
 	struct b43_wldev *dev;
 	struct b43_phy *phy;
 	struct ieee80211_conf *conf = &hw->conf;
-	unsigned long flags;
 	int antenna;
 	int err = 0;
 
@@ -3529,13 +3537,11 @@ static int b43_op_config(struct ieee8021
 
 	/* Adjust the desired TX power level. */
 	if (conf->power_level != 0) {
-		spin_lock_irqsave(&wl->irq_lock, flags);
 		if (conf->power_level != phy->desired_txpower) {
 			phy->desired_txpower = conf->power_level;
 			b43_phy_txpower_check(dev, B43_TXPWR_IGNORE_TIME |
 						   B43_TXPWR_IGNORE_TSSI);
 		}
-		spin_unlock_irqrestore(&wl->irq_lock, flags);
 	}
 
 	/* Antennas for RX and management frame TX. */
@@ -3620,7 +3626,6 @@ static void b43_op_bss_info_changed(stru
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev;
-	unsigned long flags;
 
 	mutex_lock(&wl->mutex);
 
@@ -3630,7 +3635,6 @@ static void b43_op_bss_info_changed(stru
 
 	B43_WARN_ON(wl->vif != vif);
 
-	spin_lock_irqsave(&wl->irq_lock, flags);
 	if (changed & BSS_CHANGED_BSSID) {
 		if (conf->bssid)
 			memcpy(wl->bssid, conf->bssid, ETH_ALEN);
@@ -3648,7 +3652,6 @@ static void b43_op_bss_info_changed(stru
 		if (changed & BSS_CHANGED_BSSID)
 			b43_write_mac_bssid_templates(dev);
 	}
-	spin_unlock_irqrestore(&wl->irq_lock, flags);
 
 	b43_mac_suspend(dev);
 
@@ -3683,18 +3686,15 @@ static int b43_op_set_key(struct ieee802
 	u8 algorithm;
 	u8 index;
 	int err;
+	unsigned long flags;
 	static const u8 bcast_addr[ETH_ALEN] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
 
 	if (modparam_nohwcrypt)
 		return -ENOSPC; /* User disabled HW-crypto */
 
 	mutex_lock(&wl->mutex);
-	spin_lock_irq(&wl->irq_lock);
-	write_lock(&wl->tx_lock);
-	/* Why do we need all this locking here?
-	 * mutex     -> Every config operation must take it.
-	 * irq_lock  -> We modify the dev->key array, which is accessed
-	 *              in the IRQ handlers.
+	write_lock_irqsave(&wl->tx_lock, flags);
+	/* mutex     -> Every config operation must take it.
 	 * tx_lock   -> We modify the dev->key array, which is accessed
 	 *              in the TX handler.
 	 */
@@ -3789,8 +3789,7 @@ out_unlock:
 		       sta ? sta->addr : bcast_addr);
 		b43_dump_keymemory(dev);
 	}
-	write_unlock(&wl->tx_lock);
-	spin_unlock_irq(&wl->irq_lock);
+	write_unlock_irqrestore(&wl->tx_lock, flags);
 	mutex_unlock(&wl->mutex);
 
 	return err;
@@ -3801,15 +3800,15 @@ static void b43_op_configure_filter(stru
 				    u64 multicast)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
-	struct b43_wldev *dev = wl->current_dev;
-	unsigned long flags;
+	struct b43_wldev *dev;
 
+	mutex_lock(&wl->mutex);
+	dev = wl->current_dev;
 	if (!dev) {
 		*fflags = 0;
-		return;
+		goto out_unlock;
 	}
 
-	spin_lock_irqsave(&wl->irq_lock, flags);
 	*fflags &= FIF_PROMISC_IN_BSS |
 		  FIF_ALLMULTI |
 		  FIF_FCSFAIL |
@@ -3830,41 +3829,66 @@ static void b43_op_configure_filter(stru
 
 	if (changed && b43_status(dev) >= B43_STAT_INITIALIZED)
 		b43_adjust_opmode(dev);
-	spin_unlock_irqrestore(&wl->irq_lock, flags);
+
+out_unlock:
+	mutex_unlock(&wl->mutex);
 }
 
-/* Locking: wl->mutex */
-static void b43_wireless_core_stop(struct b43_wldev *dev)
+/* Locking: wl->mutex
+ * Returns the current dev. This might be different from the passed in dev,
+ * because the core might be gone away while we unlocked the mutex. */
+static struct b43_wldev * b43_wireless_core_stop(struct b43_wldev *dev)
 {
 	struct b43_wl *wl = dev->wl;
-	unsigned long flags;
+	struct b43_wldev *orig_dev;
 
-	if (b43_status(dev) < B43_STAT_STARTED)
-		return;
+redo:
+	if (!dev || b43_status(dev) < B43_STAT_STARTED)
+		return dev;
 
-	/* Disable and sync interrupts. We must do this before than
-	 * setting the status to INITIALIZED, as the interrupt handler
-	 * won't care about IRQs then. */
-	spin_lock_irqsave(&wl->irq_lock, flags);
-	b43_write32(dev, B43_MMIO_GEN_IRQ_MASK, 0);
-	b43_read32(dev, B43_MMIO_GEN_IRQ_MASK);	/* flush */
-	spin_unlock_irqrestore(&wl->irq_lock, flags);
-	b43_synchronize_irq(dev);
+	/* Disable periodic work. Unlock to avoid deadlocks. */
+	mutex_unlock(&wl->mutex);
+	cancel_delayed_work_sync(&dev->periodic_work);
+	mutex_lock(&wl->mutex);
+	dev = wl->current_dev;
+	if (!dev || b43_status(dev) < B43_STAT_STARTED) {
+		/* Whoops, aliens ate up the device while we were unlocked. */
+		return dev;
+	}
 
-	write_lock_irqsave(&wl->tx_lock, flags);
+	/* Disable interrupts on the device. */
 	b43_set_status(dev, B43_STAT_INITIALIZED);
-	write_unlock_irqrestore(&wl->tx_lock, flags);
-
-	b43_pio_stop(dev);
+	if (0 /*FIXME dev->dev->bus->bustype == SSB_BUSTYPE_SDIO*/) {
+		/* wl->mutex is locked. That is enough. */
+		b43_write32(dev, B43_MMIO_GEN_IRQ_MASK, 0);
+		b43_read32(dev, B43_MMIO_GEN_IRQ_MASK);	/* Flush */
+	} else {
+		spin_lock_irq(&wl->hardirq_lock);
+		b43_write32(dev, B43_MMIO_GEN_IRQ_MASK, 0);
+		b43_read32(dev, B43_MMIO_GEN_IRQ_MASK);	/* Flush */
+		spin_unlock_irq(&wl->hardirq_lock);
+	}
+	/* Synchronize the interrupt handlers. Unlock to avoid deadlocks. */
+	orig_dev = dev;
 	mutex_unlock(&wl->mutex);
-	/* Must unlock as it would otherwise deadlock. No races here.
-	 * Cancel the possibly running self-rearming periodic work. */
-	cancel_delayed_work_sync(&dev->periodic_work);
+	synchronize_irq(dev->dev->irq);
 	mutex_lock(&wl->mutex);
+	dev = wl->current_dev;
+	if (!dev)
+		return dev;
+	if (dev != orig_dev) {
+		if (b43_status(dev) >= B43_STAT_STARTED)
+			goto redo;
+		return dev;
+	}
+	B43_WARN_ON(b43_read32(dev, B43_MMIO_GEN_IRQ_MASK));
 
+	b43_pio_stop(dev);
 	b43_mac_suspend(dev);
 	free_irq(dev->dev->irq, dev);
 	b43dbg(wl, "Wireless interface stopped\n");
+
+	return dev;
 }
 
 /* Locking: wl->mutex */
@@ -3875,8 +3899,9 @@ static int b43_wireless_core_start(struc
 	B43_WARN_ON(b43_status(dev) != B43_STAT_INITIALIZED);
 
 	drain_txstatus_queue(dev);
-	err = request_irq(dev->dev->irq, b43_interrupt_handler,
-			  IRQF_SHARED, KBUILD_MODNAME, dev);
+	err = request_threaded_irq(dev->dev->irq, b43_interrupt_handler,
+				   b43_interrupt_thread_handler,
+				   IRQF_SHARED, KBUILD_MODNAME, dev);
 	if (err) {
 		b43err(dev->wl, "Cannot request IRQ-%d\n", dev->dev->irq);
 		goto out;
@@ -4155,8 +4180,8 @@ static void b43_wireless_core_exit(struc
 {
 	u32 macctl;
 
-	B43_WARN_ON(b43_status(dev) > B43_STAT_INITIALIZED);
-	if (b43_status(dev) != B43_STAT_INITIALIZED)
+	B43_WARN_ON(dev && b43_status(dev) > B43_STAT_INITIALIZED);
+	if (!dev || b43_status(dev) != B43_STAT_INITIALIZED)
 		return;
 	b43_set_status(dev, B43_STAT_UNINIT);
 
@@ -4309,7 +4334,6 @@ static int b43_op_add_interface(struct i
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev;
-	unsigned long flags;
 	int err = -EOPNOTSUPP;
 
 	/* TODO: allow WDS/AP devices to coexist */
@@ -4333,12 +4357,10 @@ static int b43_op_add_interface(struct i
 	wl->if_type = conf->type;
 	memcpy(wl->mac_addr, conf->mac_addr, ETH_ALEN);
 
-	spin_lock_irqsave(&wl->irq_lock, flags);
 	b43_adjust_opmode(dev);
 	b43_set_pretbtt(dev);
 	b43_set_synth_pu_delay(dev, 0);
 	b43_upload_card_macaddress(dev);
-	spin_unlock_irqrestore(&wl->irq_lock, flags);
 
 	err = 0;
  out_mutex_unlock:
@@ -4352,7 +4374,6 @@ static void b43_op_remove_interface(stru
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev = wl->current_dev;
-	unsigned long flags;
 
 	b43dbg(wl, "Removing Interface type %d\n", conf->type);
 
@@ -4364,11 +4385,9 @@ static void b43_op_remove_interface(stru
 
 	wl->operating = 0;
 
-	spin_lock_irqsave(&wl->irq_lock, flags);
 	b43_adjust_opmode(dev);
 	memset(wl->mac_addr, 0, ETH_ALEN);
 	b43_upload_card_macaddress(dev);
-	spin_unlock_irqrestore(&wl->irq_lock, flags);
 
 	mutex_unlock(&wl->mutex);
 }
@@ -4428,10 +4447,15 @@ static void b43_op_stop(struct ieee80211
 	cancel_work_sync(&(wl->beacon_update_trigger));
 
 	mutex_lock(&wl->mutex);
-	if (b43_status(dev) >= B43_STAT_STARTED)
-		b43_wireless_core_stop(dev);
+	if (b43_status(dev) >= B43_STAT_STARTED) {
+		dev = b43_wireless_core_stop(dev);
+		if (!dev)
+			goto out_unlock;
+	}
 	b43_wireless_core_exit(dev);
 	wl->radio_enabled = 0;
+
+out_unlock:
 	mutex_unlock(&wl->mutex);
 
 	cancel_work_sync(&(wl->txpower_adjust_work));
@@ -4441,11 +4465,10 @@ static int b43_op_beacon_set_tim(struct 
 				 struct ieee80211_sta *sta, bool set)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
-	unsigned long flags;
 
-	spin_lock_irqsave(&wl->irq_lock, flags);
+	mutex_lock(&wl->mutex);
 	b43_update_templates(wl);
-	spin_unlock_irqrestore(&wl->irq_lock, flags);
+	mutex_unlock(&wl->mutex);
 
 	return 0;
 }
@@ -4526,8 +4549,13 @@ static void b43_chip_reset(struct work_s
 
 	prev_status = b43_status(dev);
 	/* Bring the device down... */
-	if (prev_status >= B43_STAT_STARTED)
-		b43_wireless_core_stop(dev);
+	if (prev_status >= B43_STAT_STARTED) {
+		dev = b43_wireless_core_stop(dev);
+		if (!dev) {
+			err = -ENODEV;
+			goto out;
+		}
+	}
 	if (prev_status >= B43_STAT_INITIALIZED)
 		b43_wireless_core_exit(dev);
 
@@ -4742,9 +4770,6 @@ static int b43_one_core_attach(struct ss
 	wldev->wl = wl;
 	b43_set_status(wldev, B43_STAT_UNINIT);
 	wldev->bad_frames_preempt = modparam_bad_frames_preempt;
-	tasklet_init(&wldev->isr_tasklet,
-		     (void (*)(unsigned long))b43_interrupt_tasklet,
-		     (unsigned long)wldev);
 	INIT_LIST_HEAD(&wldev->list);
 
 	err = b43_wireless_core_attach(wldev);
@@ -4841,11 +4866,11 @@ static int b43_wireless_init(struct ssb_
 
 	/* Initialize struct b43_wl */
 	wl->hw = hw;
-	spin_lock_init(&wl->irq_lock);
 	rwlock_init(&wl->tx_lock);
 	spin_lock_init(&wl->leds_lock);
 	spin_lock_init(&wl->shm_lock);
 	mutex_init(&wl->mutex);
+	spin_lock_init(&wl->hardirq_lock);
 	INIT_LIST_HEAD(&wl->devlist);
 	INIT_WORK(&wl->beacon_update_trigger, b43_beacon_update_trigger_work);
 	INIT_WORK(&wl->txpower_adjust_work, b43_phy_txpower_adjust_work);
@@ -4946,8 +4971,8 @@ static int b43_suspend(struct ssb_device
 	wldev->suspend_in_progress = true;
 	wldev->suspend_init_status = b43_status(wldev);
 	if (wldev->suspend_init_status >= B43_STAT_STARTED)
-		b43_wireless_core_stop(wldev);
-	if (wldev->suspend_init_status >= B43_STAT_INITIALIZED)
+		wldev = b43_wireless_core_stop(wldev);
+	if (wldev && wldev->suspend_init_status >= B43_STAT_INITIALIZED)
 		b43_wireless_core_exit(wldev);
 	mutex_unlock(&wl->mutex);
 
Index: wireless-testing/drivers/net/wireless/b43/phy_common.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy_common.c	2009-09-04 22:15:30.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/phy_common.c	2009-09-04 22:15:32.000000000 +0200
@@ -347,7 +347,6 @@ void b43_phy_txpower_adjust_work(struct 
 	mutex_unlock(&wl->mutex);
 }
 
-/* Called with wl->irq_lock locked */
 void b43_phy_txpower_check(struct b43_wldev *dev, unsigned int flags)
 {
 	struct b43_phy *phy = &dev->phy;
Index: wireless-testing/drivers/net/wireless/b43/phy_common.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy_common.h	2009-09-04 22:15:30.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/phy_common.h	2009-09-04 22:15:32.000000000 +0200
@@ -131,7 +131,7 @@ enum b43_txpwr_result {
  * 			If the parameter "ignore_tssi" is true, the TSSI values should
  * 			be ignored and a recalculation of the power settings should be
  * 			done even if the TSSI values did not change.
- * 			This callback is called with wl->irq_lock held and must not sleep.
+ * 			This function may sleep, but should not.
  * 			Must not be NULL.
  * @adjust_txpower:	Write the previously calculated TX power settings
  * 			(from @recalc_txpower) to the hardware.
@@ -379,7 +379,6 @@ void b43_software_rfkill(struct b43_wlde
  *
  * Compare the current TX power output to the desired power emission
  * and schedule an adjustment in case it mismatches.
- * Requires wl->irq_lock locked.
  *
  * @flags:	OR'ed enum b43_phy_txpower_check_flags flags.
  * 		See the docs below.
Index: wireless-testing/drivers/net/wireless/b43/phy_g.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy_g.c	2009-09-04 22:15:30.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/phy_g.c	2009-09-04 22:15:32.000000000 +0200
@@ -2823,8 +2823,6 @@ static void b43_gphy_op_adjust_txpower(s
 
 	b43_mac_suspend(dev);
 
-	spin_lock_irq(&dev->wl->irq_lock);
-
 	/* Calculate the new attenuation values. */
 	bbatt = gphy->bbatt.att;
 	bbatt += gphy->bbatt_delta;
@@ -2864,11 +2862,6 @@ static void b43_gphy_op_adjust_txpower(s
 	gphy->rfatt.att = rfatt;
 	gphy->bbatt.att = bbatt;
 
-	/* We drop the lock early, so we can sleep during hardware
-	 * adjustment. Possible races with op_recalc_txpower are harmless,
-	 * as we will be called once again in case we raced. */
-	spin_unlock_irq(&dev->wl->irq_lock);
-
 	if (b43_debug(dev, B43_DBG_XMITPOWER))
 		b43dbg(dev->wl, "Adjusting TX power\n");
 
Index: wireless-testing/drivers/net/wireless/b43/phy_g.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy_g.h	2009-09-04 22:15:30.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/phy_g.h	2009-09-04 22:15:32.000000000 +0200
@@ -141,8 +141,7 @@ struct b43_phy_g {
 	int tgt_idle_tssi;
 	/* Current idle TSSI */
 	int cur_idle_tssi;
-	/* The current average TSSI.
-	 * Needs irq_lock, as it's updated in the IRQ path. */
+	/* The current average TSSI. */
 	u8 average_tssi;
 	/* Current TX power level attenuation control values */
 	struct b43_bbatt bbatt;
Index: wireless-testing/drivers/net/wireless/b43/sysfs.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/sysfs.c	2009-09-04 22:15:30.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/sysfs.c	2009-09-04 22:15:32.000000000 +0200
@@ -94,7 +94,6 @@ static ssize_t b43_attr_interfmode_store
 					 const char *buf, size_t count)
 {
 	struct b43_wldev *wldev = dev_to_b43_wldev(dev);
-	unsigned long flags;
 	int err;
 	int mode;
 
@@ -120,7 +119,6 @@ static ssize_t b43_attr_interfmode_store
 	}
 
 	mutex_lock(&wldev->wl->mutex);
-	spin_lock_irqsave(&wldev->wl->irq_lock, flags);
 
 	if (wldev->phy.ops->interf_mitigation) {
 		err = wldev->phy.ops->interf_mitigation(wldev, mode);
@@ -132,7 +130,6 @@ static ssize_t b43_attr_interfmode_store
 		err = -ENOSYS;
 
 	mmiowb();
-	spin_unlock_irqrestore(&wldev->wl->irq_lock, flags);
 	mutex_unlock(&wldev->wl->mutex);
 
 	return err ? err : count;
Index: wireless-testing/drivers/net/wireless/b43/dma.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/dma.c	2009-09-04 22:15:30.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/dma.c	2009-09-04 22:15:32.000000000 +0200
@@ -1387,7 +1387,6 @@ out_unlock:
 	return err;
 }
 
-/* Called with IRQs disabled. */
 void b43_dma_handle_txstatus(struct b43_wldev *dev,
 			     const struct b43_txstatus *status)
 {
@@ -1402,7 +1401,7 @@ void b43_dma_handle_txstatus(struct b43_
 	if (unlikely(!ring))
 		return;
 
-	spin_lock(&ring->lock); /* IRQs are already disabled. */
+	spin_lock_irq(&ring->lock);
 
 	B43_WARN_ON(!ring->tx);
 	ops = ring->ops;
@@ -1463,7 +1462,7 @@ void b43_dma_handle_txstatus(struct b43_
 		}
 	}
 
-	spin_unlock(&ring->lock);
+	spin_unlock_irq(&ring->lock);
 }
 
 void b43_dma_get_tx_stats(struct b43_wldev *dev,
Index: wireless-testing/drivers/net/wireless/b43/pio.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/pio.c	2009-09-04 22:15:30.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/pio.c	2009-09-04 22:15:32.000000000 +0200
@@ -570,7 +570,6 @@ out_unlock:
 	return err;
 }
 
-/* Called with IRQs disabled. */
 void b43_pio_handle_txstatus(struct b43_wldev *dev,
 			     const struct b43_txstatus *status)
 {
@@ -584,7 +583,7 @@ void b43_pio_handle_txstatus(struct b43_
 		return;
 	B43_WARN_ON(!pack);
 
-	spin_lock(&q->lock); /* IRQs are already disabled. */
+	spin_lock_irq(&q->lock);
 
 	info = IEEE80211_SKB_CB(pack->skb);
 
@@ -604,7 +603,7 @@ void b43_pio_handle_txstatus(struct b43_
 		q->stopped = 0;
 	}
 
-	spin_unlock(&q->lock);
+	spin_unlock_irq(&q->lock);
 }
 
 void b43_pio_get_tx_stats(struct b43_wldev *dev,
Index: wireless-testing/drivers/net/wireless/b43/debugfs.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/debugfs.h	2009-09-04 22:15:30.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/debugfs.h	2009-09-04 22:15:32.000000000 +0200
@@ -23,9 +23,10 @@ struct dentry;
 #define B43_NR_LOGGED_TXSTATUS	100
 
 struct b43_txstatus_log {
+	/* This structure is protected by wl->mutex */
+
 	struct b43_txstatus *log;
 	int end;
-	spinlock_t lock;
 };
 
 struct b43_dfs_file {

-- 
Greetings, Michael.
