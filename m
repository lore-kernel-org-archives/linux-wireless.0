Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:38855 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933669AbYDYTNW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Apr 2008 15:13:22 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Don't disable IRQs in mac_suspend
Date: Fri, 25 Apr 2008 21:10:54 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200804252110.54456.mb@bu3sch.de> (sfid-20080425_211359_012971_C434ECBB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes the IRQ-disable from mac_suspend.
The main advantage of this is to get rid of the IRQ-sync call in mac_suspend.
We need to remove the MAC suspend bit from the IRQ service mask, as otherwise
the IRQ handler would race with us.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, this is for 2.6.27


Index: wireless-testing/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/b43.h	2008-04-25 19:28:42.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/b43.h	2008-04-25 21:05:29.000000000 +0200
@@ -407,14 +407,13 @@ enum {
 #define B43_IRQ_RFKILL			0x10000000
 #define B43_IRQ_TX_OK			0x20000000
 #define B43_IRQ_PHY_G_CHANGED		0x40000000
 #define B43_IRQ_TIMEOUT			0x80000000
 
 #define B43_IRQ_ALL			0xFFFFFFFF
-#define B43_IRQ_MASKTEMPLATE		(B43_IRQ_MAC_SUSPENDED | \
-					 B43_IRQ_TBTT_INDI | \
+#define B43_IRQ_MASKTEMPLATE		(B43_IRQ_TBTT_INDI | \
 					 B43_IRQ_ATIM_END | \
 					 B43_IRQ_PMQ | \
 					 B43_IRQ_MAC_TXERR | \
 					 B43_IRQ_PHY_TXERR | \
 					 B43_IRQ_DMA | \
 					 B43_IRQ_TXFIFO_FLUSH_OK | \
Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-04-25 18:47:08.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2008-04-25 21:05:29.000000000 +0200
@@ -2319,17 +2319,12 @@ void b43_mac_enable(struct b43_wldev *de
 		b43_write32(dev, B43_MMIO_GEN_IRQ_REASON,
 			    B43_IRQ_MAC_SUSPENDED);
 		/* Commit writes */
 		b43_read32(dev, B43_MMIO_MACCTL);
 		b43_read32(dev, B43_MMIO_GEN_IRQ_REASON);
 		b43_power_saving_ctl_bits(dev, 0);
-
-		/* Re-enable IRQs. */
-		spin_lock_irq(&dev->wl->irq_lock);
-		b43_interrupt_enable(dev, dev->irq_savedstate);
-		spin_unlock_irq(&dev->wl->irq_lock);
 	}
 }
 
 /* http://bcm-specs.sipsolutions.net/SuspendMAC */
 void b43_mac_suspend(struct b43_wldev *dev)
 {
@@ -2337,20 +2332,12 @@ void b43_mac_suspend(struct b43_wldev *d
 	u32 tmp;
 
 	might_sleep();
 	B43_WARN_ON(dev->mac_suspended < 0);
 
 	if (dev->mac_suspended == 0) {
-		/* Mask IRQs before suspending MAC. Otherwise
-		 * the MAC stays busy and won't suspend. */
-		spin_lock_irq(&dev->wl->irq_lock);
-		tmp = b43_interrupt_disable(dev, B43_IRQ_ALL);
-		spin_unlock_irq(&dev->wl->irq_lock);
-		b43_synchronize_irq(dev);
-		dev->irq_savedstate = tmp;
-
 		b43_power_saving_ctl_bits(dev, B43_PS_AWAKE);
 		b43_write32(dev, B43_MMIO_MACCTL,
 			    b43_read32(dev, B43_MMIO_MACCTL)
 			    & ~B43_MACCTL_ENABLED);
 		/* force pci to flush the write */
 		b43_read32(dev, B43_MMIO_MACCTL);
