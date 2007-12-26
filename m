Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:46202 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbXLZNt2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Dec 2007 08:49:28 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Remove PIO support
Date: Wed, 26 Dec 2007 14:41:30 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200712261441.30437.mb@bu3sch.de> (sfid-20071226_134936_351777_3A34487A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove b43 PIO support.
DMA works well on all supported devices. There's no reason to use PIO.
Additionally, new devices don't support PIO in hardware anymore.
b43 PIO support is dead and unused code.

After applying this patch please do
git rm drivers/net/wireless/b43/pio.h
git rm drivers/net/wireless/b43/pio.c
to remove the main PIO support code.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-2.6/drivers/net/wireless/b43/Kconfig
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/Kconfig	2007-12-26 14:31:03.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/Kconfig	2007-12-26 14:32:49.000000000 +0100
@@ -83,51 +83,3 @@ config B43_DEBUG
 
 	  Say Y, if you want to find out why the driver does not
 	  work for you.
-
-config B43_DMA
-	bool
-	depends on B43
-config B43_PIO
-	bool
-	depends on B43
-
-choice
-	prompt "Broadcom 43xx data transfer mode"
-	depends on B43
-	default B43_DMA_AND_PIO_MODE
-
-config B43_DMA_AND_PIO_MODE
-	bool "DMA + PIO"
-	select B43_DMA
-	select B43_PIO
-	---help---
-	  Include both, Direct Memory Access (DMA) and Programmed I/O (PIO)
-	  data transfer modes.
-	  The actually used mode is selectable through the module
-	  parameter "pio". If the module parameter is pio=0, DMA is used.
-	  Otherwise PIO is used. DMA is default.
-
-	  If unsure, choose this option.
-
-config B43_DMA_MODE
-	bool "DMA (Direct Memory Access) only"
-	select B43_DMA
-	---help---
-	  Only include Direct Memory Access (DMA).
-	  This reduces the size of the driver module, by omitting the PIO code.
-
-config B43_PIO_MODE
-	bool "PIO (Programmed I/O) only"
-	select B43_PIO
-	---help---
-	  Only include Programmed I/O (PIO).
-	  This reduces the size of the driver module, by omitting the DMA code.
-	  Please note that PIO transfers are slow (compared to DMA).
-
-	  Also note that not all devices of the 43xx series support PIO.
-	  The 4306 (Apple Airport Extreme and others) supports PIO, while
-	  the 4318 is known to _not_ support PIO.
-
-	  Only use PIO, if DMA does not work for you.
-
-endchoice
Index: wireless-2.6/drivers/net/wireless/b43/Makefile
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/Makefile	2007-12-26 14:31:03.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/Makefile	2007-12-26 14:33:36.000000000 +0100
@@ -1,4 +1,3 @@
-# b43 core
 b43-y				+= main.o
 b43-y				+= tables.o
 b43-y				+= phy.o
@@ -6,16 +5,10 @@ b43-y				+= sysfs.o
 b43-y				+= xmit.o
 b43-y				+= lo.o
 b43-y				+= wa.o
-# b43 RFKILL button support
+b43-y				+= dma.o
 b43-$(CONFIG_B43_RFKILL)	+= rfkill.o
-# b43 LED support
 b43-$(CONFIG_B43_LEDS)		+= leds.o
-# b43 PCMCIA support
 b43-$(CONFIG_B43_PCMCIA)	+= pcmcia.o
-# b43 debugging
 b43-$(CONFIG_B43_DEBUG)		+= debugfs.o
-# b43 DMA and PIO
-b43-$(CONFIG_B43_DMA)		+= dma.o
-b43-$(CONFIG_B43_PIO)		+= pio.o
 
 obj-$(CONFIG_B43)		+= b43.o
Index: wireless-2.6/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/b43.h	2007-12-26 14:31:03.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/b43.h	2007-12-26 14:32:49.000000000 +0100
@@ -68,11 +68,6 @@
 #define B43_MMIO_DMA64_BASE3		0x2C0
 #define B43_MMIO_DMA64_BASE4		0x300
 #define B43_MMIO_DMA64_BASE5		0x340
-/* PIO */
-#define B43_MMIO_PIO1_BASE		0x300
-#define B43_MMIO_PIO2_BASE		0x310
-#define B43_MMIO_PIO3_BASE		0x320
-#define B43_MMIO_PIO4_BASE		0x330
 
 #define B43_MMIO_PHY_VER		0x3E0
 #define B43_MMIO_PHY_RADIO		0x3E2
@@ -577,14 +572,6 @@ struct b43_dma {
 	struct b43_dmaring *rx_ring3;	/* only available on core.rev < 5 */
 };
 
-/* Data structures for PIO transmission, per 80211 core. */
-struct b43_pio {
-	struct b43_pioqueue *queue0;
-	struct b43_pioqueue *queue1;
-	struct b43_pioqueue *queue2;
-	struct b43_pioqueue *queue3;
-};
-
 /* Context information for a noise calculation (Link Quality). */
 struct b43_noise_calculation {
 	u8 channel_at_start;
@@ -700,7 +687,6 @@ struct b43_wldev {
 	/* Saved init status for handling suspend. */
 	int suspend_init_status;
 
-	bool __using_pio;	/* Internal, use b43_using_pio(). */
 	bool bad_frames_preempt;	/* Use "Bad Frames Preemption" (default off) */
 	bool reg124_set_0x4;	/* Some variable to keep track of IRQ stuff. */
 	bool short_preamble;	/* TRUE, if short preamble is enabled. */
@@ -709,12 +695,9 @@ struct b43_wldev {
 
 	/* PHY/Radio device. */
 	struct b43_phy phy;
-	union {
-		/* DMA engines. */
-		struct b43_dma dma;
-		/* PIO engines. */
-		struct b43_pio pio;
-	};
+
+	/* DMA engines. */
+	struct b43_dma dma;
 
 	/* Various statistics about the physical device. */
 	struct b43_stats stats;
@@ -769,28 +752,6 @@ static inline struct b43_wl *hw_to_b43_w
 	return hw->priv;
 }
 
-/* Helper function, which returns a boolean.
- * TRUE, if PIO is used; FALSE, if DMA is used.
- */
-#if defined(CONFIG_B43_DMA) && defined(CONFIG_B43_PIO)
-static inline int b43_using_pio(struct b43_wldev *dev)
-{
-	return dev->__using_pio;
-}
-#elif defined(CONFIG_B43_DMA)
-static inline int b43_using_pio(struct b43_wldev *dev)
-{
-	return 0;
-}
-#elif defined(CONFIG_B43_PIO)
-static inline int b43_using_pio(struct b43_wldev *dev)
-{
-	return 1;
-}
-#else
-# error "Using neither DMA nor PIO? Confused..."
-#endif
-
 static inline struct b43_wldev *dev_to_b43_wldev(struct device *dev)
 {
 	struct ssb_device *ssb_dev = dev_to_ssb_dev(dev);
Index: wireless-2.6/drivers/net/wireless/b43/debugfs.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/debugfs.c	2007-12-26 14:31:03.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/debugfs.c	2007-12-26 14:32:49.000000000 +0100
@@ -34,7 +34,6 @@
 #include "main.h"
 #include "debugfs.h"
 #include "dma.h"
-#include "pio.h"
 #include "xmit.h"
 
 
Index: wireless-2.6/drivers/net/wireless/b43/dma.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/dma.c	2007-12-26 14:31:03.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/dma.c	2007-12-26 14:32:49.000000000 +0100
@@ -915,11 +915,7 @@ static void b43_destroy_dmaring(struct b
 
 void b43_dma_free(struct b43_wldev *dev)
 {
-	struct b43_dma *dma;
-
-	if (b43_using_pio(dev))
-		return;
-	dma = &dev->dma;
+	struct b43_dma *dma = &dev->dma;
 
 	b43_destroy_dmaring(dma->rx_ring3);
 	dma->rx_ring3 = NULL;
@@ -954,16 +950,11 @@ int b43_dma_init(struct b43_wldev *dev)
 
 	err = ssb_dma_set_mask(dev->dev, dmamask);
 	if (err) {
-#ifdef B43_PIO
-		b43warn(dev->wl, "DMA for this device not supported. "
-			"Falling back to PIO\n");
-		dev->__using_pio = 1;
-		return -EAGAIN;
-#else
-		b43err(dev->wl, "DMA for this device not supported and "
-		       "no PIO support compiled in\n");
+		b43err(dev->wl, "The machine/kernel does not support "
+		       "the required DMA mask (0x%08X%08X)\n",
+		       (unsigned int)((dmamask & 0xFFFFFFFF00000000ULL) >> 32),
+		       (unsigned int)(dmamask & 0x00000000FFFFFFFFULL));
 		return -EOPNOTSUPP;
-#endif
 	}
 
 	err = -ENOMEM;
Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c	2007-12-26 14:31:03.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/main.c	2007-12-26 14:32:49.000000000 +0100
@@ -46,7 +46,6 @@
 #include "debugfs.h"
 #include "phy.h"
 #include "dma.h"
-#include "pio.h"
 #include "sysfs.h"
 #include "xmit.h"
 #include "lo.h"
@@ -58,17 +57,6 @@ MODULE_AUTHOR("Stefano Brivio");
 MODULE_AUTHOR("Michael Buesch");
 MODULE_LICENSE("GPL");
 
-extern char *nvram_get(char *name);
-
-#if defined(CONFIG_B43_DMA) && defined(CONFIG_B43_PIO)
-static int modparam_pio;
-module_param_named(pio, modparam_pio, int, 0444);
-MODULE_PARM_DESC(pio, "enable(1) / disable(0) PIO mode");
-#elif defined(CONFIG_B43_DMA)
-# define modparam_pio	0
-#elif defined(CONFIG_B43_PIO)
-# define modparam_pio	1
-#endif
 
 static int modparam_bad_frames_preempt;
 module_param_named(bad_frames_preempt, modparam_bad_frames_preempt, int, 0444);
@@ -1447,20 +1435,12 @@ static void b43_interrupt_tasklet(struct
 		handle_irq_noise(dev);
 
 	/* Check the DMA reason registers for received data. */
-	if (dma_reason[0] & B43_DMAIRQ_RX_DONE) {
-		if (b43_using_pio(dev))
-			b43_pio_rx(dev->pio.queue0);
-		else
-			b43_dma_rx(dev->dma.rx_ring0);
-	}
+	if (dma_reason[0] & B43_DMAIRQ_RX_DONE)
+		b43_dma_rx(dev->dma.rx_ring0);
+	if (dma_reason[3] & B43_DMAIRQ_RX_DONE)
+		b43_dma_rx(dev->dma.rx_ring3);
 	B43_WARN_ON(dma_reason[1] & B43_DMAIRQ_RX_DONE);
 	B43_WARN_ON(dma_reason[2] & B43_DMAIRQ_RX_DONE);
-	if (dma_reason[3] & B43_DMAIRQ_RX_DONE) {
-		if (b43_using_pio(dev))
-			b43_pio_rx(dev->pio.queue3);
-		else
-			b43_dma_rx(dev->dma.rx_ring3);
-	}
 	B43_WARN_ON(dma_reason[4] & B43_DMAIRQ_RX_DONE);
 	B43_WARN_ON(dma_reason[5] & B43_DMAIRQ_RX_DONE);
 
@@ -1472,29 +1452,8 @@ static void b43_interrupt_tasklet(struct
 	spin_unlock_irqrestore(&dev->wl->irq_lock, flags);
 }
 
-static void pio_irq_workaround(struct b43_wldev *dev, u16 base, int queueidx)
-{
-	u16 rxctl;
-
-	rxctl = b43_read16(dev, base + B43_PIO_RXCTL);
-	if (rxctl & B43_PIO_RXCTL_DATAAVAILABLE)
-		dev->dma_reason[queueidx] |= B43_DMAIRQ_RX_DONE;
-	else
-		dev->dma_reason[queueidx] &= ~B43_DMAIRQ_RX_DONE;
-}
-
 static void b43_interrupt_ack(struct b43_wldev *dev, u32 reason)
 {
-	if (b43_using_pio(dev) &&
-	    (dev->dev->id.revision < 3) &&
-	    (!(reason & B43_IRQ_PIO_WORKAROUND))) {
-		/* Apply a PIO specific workaround to the dma_reasons */
-		pio_irq_workaround(dev, B43_MMIO_PIO1_BASE, 0);
-		pio_irq_workaround(dev, B43_MMIO_PIO2_BASE, 1);
-		pio_irq_workaround(dev, B43_MMIO_PIO3_BASE, 2);
-		pio_irq_workaround(dev, B43_MMIO_PIO4_BASE, 3);
-	}
-
 	b43_write32(dev, B43_MMIO_GEN_IRQ_REASON, reason);
 
 	b43_write32(dev, B43_MMIO_DMA0_REASON, dev->dma_reason[0]);
@@ -2225,14 +2184,6 @@ static int b43_chip_init(struct b43_wlde
 	b43_write32(dev, B43_MMIO_MACCTL, b43_read32(dev, B43_MMIO_MACCTL)
 		    | B43_MACCTL_INFRA);
 
-	if (b43_using_pio(dev)) {
-		b43_write32(dev, 0x0210, 0x00000100);
-		b43_write32(dev, 0x0230, 0x00000100);
-		b43_write32(dev, 0x0250, 0x00000100);
-		b43_write32(dev, 0x0270, 0x00000100);
-		b43_shm_write16(dev, B43_SHM_SHARED, 0x0034, 0x0000);
-	}
-
 	/* Probe Response Timeout value */
 	/* FIXME: Default to 0, has to be set by ioctl probably... :-/ */
 	b43_shm_write16(dev, B43_SHM_SHARED, 0x0074, 0x0000);
@@ -2513,19 +2464,13 @@ static int b43_op_tx(struct ieee80211_hw
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev = wl->current_dev;
 	int err = -ENODEV;
-	unsigned long flags;
 
 	if (unlikely(!dev))
 		goto out;
 	if (unlikely(b43_status(dev) < B43_STAT_STARTED))
 		goto out;
 	/* DMA-TX is done without a global lock. */
-	if (b43_using_pio(dev)) {
-		spin_lock_irqsave(&wl->irq_lock, flags);
-		err = b43_pio_tx(dev, skb, ctl);
-		spin_unlock_irqrestore(&wl->irq_lock, flags);
-	} else
-		err = b43_dma_tx(dev, skb, ctl);
+	err = b43_dma_tx(dev, skb, ctl);
 out:
 	if (unlikely(err))
 		return NETDEV_TX_BUSY;
@@ -2551,10 +2496,7 @@ static int b43_op_get_tx_stats(struct ie
 		goto out;
 	spin_lock_irqsave(&wl->irq_lock, flags);
 	if (likely(b43_status(dev) >= B43_STAT_STARTED)) {
-		if (b43_using_pio(dev))
-			b43_pio_get_tx_stats(dev, stats);
-		else
-			b43_dma_get_tx_stats(dev, stats);
+		b43_dma_get_tx_stats(dev, stats);
 		err = 0;
 	}
 	spin_unlock_irqrestore(&wl->irq_lock, flags);
@@ -3336,7 +3278,6 @@ static void b43_wireless_core_exit(struc
 
 	b43_leds_exit(dev);
 	b43_rng_exit(dev->wl);
-	b43_pio_free(dev);
 	b43_dma_free(dev);
 	b43_chip_exit(dev);
 	b43_radio_turn_off(dev, 1);
@@ -3430,17 +3371,10 @@ static int b43_wireless_core_init(struct
 	/* Maximum Contention Window */
 	b43_shm_write16(dev, B43_SHM_SCRATCH, B43_SHM_SC_MAXCONT, 0x3FF);
 
-	do {
-		if (b43_using_pio(dev)) {
-			err = b43_pio_init(dev);
-		} else {
-			err = b43_dma_init(dev);
-			if (!err)
-				b43_qos_init(dev);
-		}
-	} while (err == -EAGAIN);
+	err = b43_dma_init(dev);
 	if (err)
 		goto err_chip_exit;
+	b43_qos_init(dev);
 
 //FIXME
 #if 1
@@ -3891,8 +3825,6 @@ static int b43_one_core_attach(struct ss
 	tasklet_init(&wldev->isr_tasklet,
 		     (void (*)(unsigned long))b43_interrupt_tasklet,
 		     (unsigned long)wldev);
-	if (modparam_pio)
-		wldev->__using_pio = 1;
 	INIT_LIST_HEAD(&wldev->list);
 
 	err = b43_wireless_core_attach(wldev);
Index: wireless-2.6/drivers/net/wireless/b43/xmit.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/xmit.c	2007-12-26 14:31:03.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/xmit.c	2007-12-26 14:32:49.000000000 +0100
@@ -30,7 +30,7 @@
 #include "xmit.h"
 #include "phy.h"
 #include "dma.h"
-#include "pio.h"
+
 
 /* Extract the bitrate out of a CCK PLCP header. */
 static u8 b43_plcp_get_bitrate_cck(struct b43_plcp_hdr6 *plcp)
@@ -593,10 +593,7 @@ void b43_handle_txstatus(struct b43_wlde
 			dev->wl->ieee_stats.dot11RTSSuccessCount++;
 	}
 
-	if (b43_using_pio(dev))
-		b43_pio_handle_txstatus(dev, status);
-	else
-		b43_dma_handle_txstatus(dev, status);
+	b43_dma_handle_txstatus(dev, status);
 }
 
 /* Handle TX status report as received through DMA/PIO queues */
@@ -625,19 +622,13 @@ void b43_handle_hwtxstatus(struct b43_wl
 /* Stop any TX operation on the device (suspend the hardware queues) */
 void b43_tx_suspend(struct b43_wldev *dev)
 {
-	if (b43_using_pio(dev))
-		b43_pio_freeze_txqueues(dev);
-	else
-		b43_dma_tx_suspend(dev);
+	b43_dma_tx_suspend(dev);
 }
 
 /* Resume any TX operation on the device (resume the hardware queues) */
 void b43_tx_resume(struct b43_wldev *dev)
 {
-	if (b43_using_pio(dev))
-		b43_pio_thaw_txqueues(dev);
-	else
-		b43_dma_tx_resume(dev);
+	b43_dma_tx_resume(dev);
 }
 
 #if 0
Index: wireless-2.6/drivers/net/wireless/b43/dma.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/dma.h	2007-12-09 21:33:18.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/dma.h	2007-12-26 14:34:35.000000000 +0100
@@ -170,8 +170,6 @@ struct b43_dmadesc_generic {
 #define B43_DMA0_RX_BUFFERSIZE	(2304 + 100)
 #define B43_DMA3_RX_BUFFERSIZE	16
 
-#ifdef CONFIG_B43_DMA
-
 struct sk_buff;
 struct b43_private;
 struct b43_txstatus;
@@ -286,52 +284,4 @@ void b43_dma_handle_txstatus(struct b43_
 
 void b43_dma_rx(struct b43_dmaring *ring);
 
-#else /* CONFIG_B43_DMA */
-
-static inline int b43_dma_init(struct b43_wldev *dev)
-{
-	return 0;
-}
-static inline void b43_dma_free(struct b43_wldev *dev)
-{
-}
-static inline
-    int b43_dmacontroller_rx_reset(struct b43_wldev *dev,
-				   u16 dmacontroller_mmio_base, int dma64)
-{
-	return 0;
-}
-static inline
-    int b43_dmacontroller_tx_reset(struct b43_wldev *dev,
-				   u16 dmacontroller_mmio_base, int dma64)
-{
-	return 0;
-}
-static inline
-    void b43_dma_get_tx_stats(struct b43_wldev *dev,
-			      struct ieee80211_tx_queue_stats *stats)
-{
-}
-static inline
-    int b43_dma_tx(struct b43_wldev *dev,
-		   struct sk_buff *skb, struct ieee80211_tx_control *ctl)
-{
-	return 0;
-}
-static inline
-    void b43_dma_handle_txstatus(struct b43_wldev *dev,
-				 const struct b43_txstatus *status)
-{
-}
-static inline void b43_dma_rx(struct b43_dmaring *ring)
-{
-}
-static inline void b43_dma_tx_suspend(struct b43_wldev *dev)
-{
-}
-static inline void b43_dma_tx_resume(struct b43_wldev *dev)
-{
-}
-
-#endif /* CONFIG_B43_DMA */
 #endif /* B43_DMA_H_ */
