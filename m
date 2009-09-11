Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:37740 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756724AbZIKVFg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 17:05:36 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] b43: Fix IRQ sync for SDIO
Date: Fri, 11 Sep 2009 23:04:04 +0200
Cc: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	Albert Herranz <albert_herranz@yahoo.es>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200909112304.04810.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

synchronize_irq is meaningless for SDIO. sdio_release_irq will
sync the IRQ thread for us.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2009-09-11 22:50:17.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2009-09-11 22:52:25.000000000 +0200
@@ -3854,10 +3854,15 @@ redo:
 		b43_read32(dev, B43_MMIO_GEN_IRQ_MASK);	/* Flush */
 		spin_unlock_irq(&wl->hardirq_lock);
 	}
-	/* Synchronize the interrupt handlers. Unlock to avoid deadlocks. */
+	/* Synchronize and free the interrupt handlers. Unlock to avoid deadlocks. */
 	orig_dev = dev;
 	mutex_unlock(&wl->mutex);
-	synchronize_irq(dev->dev->irq);
+	if (dev->dev->bus->bustype == SSB_BUSTYPE_SDIO) {
+		b43_sdio_free_irq(dev);
+	} else {
+		synchronize_irq(dev->dev->irq);
+		free_irq(dev->dev->irq, dev);
+	}
 	mutex_lock(&wl->mutex);
 	dev = wl->current_dev;
 	if (!dev)
@@ -3874,10 +3879,6 @@ redo:
 		dev_kfree_skb(skb_dequeue(&wl->tx_queue));
 
 	b43_mac_suspend(dev);
-	if (dev->dev->bus->bustype == SSB_BUSTYPE_SDIO)
-		b43_sdio_free_irq(dev);
-	else
-		free_irq(dev->dev->irq, dev);
 	b43_leds_exit(dev);
 	b43dbg(wl, "Wireless interface stopped\n");
 

-- 
Greetings, Michael.
