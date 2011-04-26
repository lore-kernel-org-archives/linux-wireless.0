Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:41964 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758499Ab1DZVtv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2011 17:49:51 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat-wireless: fix compile problem with IRQF_ONESHOT
Date: Tue, 26 Apr 2011 23:49:44 +0200
Message-Id: <1303854584-12297-1-git-send-email-hauke@hauke-m.de> (sfid-20110426_234955_223206_E2D781F0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IRQF_ONESHOT was introduced in kernel 2.6.32 and wl12xx uses it.
This patch reverts back to the old behavior when older kernels are used.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/09-threaded-irq.patch |   23 +++++++++++++++++------
 1 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/patches/09-threaded-irq.patch b/patches/09-threaded-irq.patch
index 82c817f..0e25e21 100644
--- a/patches/09-threaded-irq.patch
+++ b/patches/09-threaded-irq.patch
@@ -63,22 +63,33 @@ thread in process context as well.
  /* Data structure for the WLAN parts (802.11 cores) of the b43 chip. */
 --- a/drivers/net/wireless/wl12xx/spi.c
 +++ b/drivers/net/wireless/wl12xx/spi.c
-@@ -417,9 +417,20 @@ static int __devinit wl1271_probe(struct
+@@ -405,10 +405,14 @@ static int __devinit wl1271_probe(struct
+ 	wl->tcxo_clock = pdata->board_tcxo_clock;
+ 	wl->platform_quirks = pdata->platform_quirks;
+ 
++#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,32)
++	irqflags = IRQF_TRIGGER_RISING;
++#else
+ 	if (wl->platform_quirks & WL12XX_PLATFORM_QUIRK_EDGE_IRQ)
+ 		irqflags = IRQF_TRIGGER_RISING;
+ 	else
+ 		irqflags = IRQF_TRIGGER_HIGH | IRQF_ONESHOT;
++#endif
+ 
+ 	wl->irq = spi->irq;
+ 	if (wl->irq < 0) {
+@@ -417,9 +421,16 @@ static int __devinit wl1271_probe(struct
  		goto out_free;
  	}
  
 +#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)
 +	ret = compat_request_threaded_irq(&wl->irq_compat, wl->irq,
 +					  wl1271_hardirq, wl1271_irq,
-+					  IRQF_TRIGGER_RISING,
++					  irqflags,
 +					  DRIVER_NAME, wl);
 +#else
  	ret = request_threaded_irq(wl->irq, wl1271_hardirq, wl1271_irq,
-+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,32)
-+                                  IRQF_TRIGGER_RISING,
-+#else
  				   irqflags,
-+#endif
  				   DRIVER_NAME, wl);
 +#endif
  	if (ret < 0) {
-- 
1.7.1

