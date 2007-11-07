Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:43923 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750886AbXKGRfD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2007 12:35:03 -0500
Date: Wed, 7 Nov 2007 18:33:37 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: [PATCH] b43legacy: fix shared IRQ race condition
Message-ID: <20071107183337.4a77dbd4@morte> (sfid-20071107_173508_247738_9B313847)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix an IRQ race condition in b43legacy. If we call
b43legacy_wireless_core_stop(), it will set the status of the device to
INITIALIZED and the IRQ handler won't care any longer about IRQs, thus the
kernel will disable the IRQ if it's shared (unless we boot it with the
'irqpoll' option). So we must disable IRQs before changing the device
status.


Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>

---

--- wireless-2.6/drivers/net/wireless/b43legacy/main.c.orig	2007-11-07 18:27:54.710703615 +0100
+++ wireless-2.6/drivers/net/wireless/b43legacy/main.c	2007-11-07 18:29:37.731201996 +0100
@@ -2682,6 +2682,17 @@
 
 	if (b43legacy_status(dev) < B43legacy_STAT_STARTED)
 		return;
+
+	/* Disable and sync interrupts. We must do this before than
+	 * setting the status to INITIALIZED, as the interrupt handler
+	 * won't care about IRQs then. */
+	spin_lock_irqsave(&wl->irq_lock, flags);
+	dev->irq_savedstate = b43legacy_interrupt_disable(dev,
+							  B43legacy_IRQ_ALL);
+	b43legacy_read32(dev, B43legacy_MMIO_GEN_IRQ_MASK); /* flush */
+	spin_unlock_irqrestore(&wl->irq_lock, flags);
+	b43legacy_synchronize_irq(dev);
+
 	b43legacy_set_status(dev, B43legacy_STAT_INITIALIZED);
 
 	mutex_unlock(&wl->mutex);
@@ -2692,14 +2703,6 @@
 
 	ieee80211_stop_queues(wl->hw); /* FIXME this could cause a deadlock */
 
-	/* Disable and sync interrupts. */
-	spin_lock_irqsave(&wl->irq_lock, flags);
-	dev->irq_savedstate = b43legacy_interrupt_disable(dev,
-							  B43legacy_IRQ_ALL);
-	b43legacy_read32(dev, B43legacy_MMIO_GEN_IRQ_MASK); /* flush */
-	spin_unlock_irqrestore(&wl->irq_lock, flags);
-	b43legacy_synchronize_irq(dev);
-
 	b43legacy_mac_suspend(dev);
 	free_irq(dev->dev->irq, dev);
 	b43legacydbg(wl, "Wireless interface stopped\n");


-- 
Ciao
Stefano
