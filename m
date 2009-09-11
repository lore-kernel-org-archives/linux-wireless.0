Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:46618 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726AbZIKOBR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 10:01:17 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] b43: Fix SDIO interrupt handler deadlock
Date: Fri, 11 Sep 2009 16:00:19 +0200
Cc: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	Albert Herranz <albert_herranz@yahoo.es>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200909111600.20786.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We need to release the SDIO host before locking the driver mutex.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---


Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2009-09-10 20:26:43.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2009-09-11 15:55:19.000000000 +0200
@@ -1914,20 +1914,14 @@ static irqreturn_t b43_interrupt_handler
 static void b43_sdio_interrupt_handler(struct b43_wldev *dev)
 {
 	struct b43_wl *wl = dev->wl;
-	struct sdio_func *func = dev->dev->bus->host_sdio;
 	irqreturn_t ret;
 
-	if (unlikely(b43_status(dev) < B43_STAT_STARTED))
-		return;
-
 	mutex_lock(&wl->mutex);
-	sdio_release_host(func);
 
 	ret = b43_do_interrupt(dev);
 	if (ret == IRQ_WAKE_THREAD)
 		b43_do_interrupt_thread(dev);
 
-	sdio_claim_host(func);
 	mutex_unlock(&wl->mutex);
 }
 
Index: wireless-testing/drivers/net/wireless/b43/sdio.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/sdio.c	2009-09-10 19:23:20.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/sdio.c	2009-09-11 15:54:05.000000000 +0200
@@ -54,7 +54,12 @@ static void b43_sdio_interrupt_dispatche
 	struct b43_sdio *sdio = sdio_get_drvdata(func);
 	struct b43_wldev *dev = sdio->irq_handler_opaque;
 
+	if (unlikely(b43_status(dev) < B43_STAT_STARTED))
+		return;
+
+	sdio_release_host(func);
 	sdio->irq_handler(dev);
+	sdio_claim_host(func);
 }
 
 int b43_sdio_request_irq(struct b43_wldev *dev,

-- 
Greetings, Michael.
