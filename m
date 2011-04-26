Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51229 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755493Ab1DZTSI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2011 15:18:08 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat-wireless: make patches apply again
Date: Tue, 26 Apr 2011 21:17:10 +0200
Message-Id: <1303845431-972-1-git-send-email-hauke@hauke-m.de> (sfid-20110426_211812_301918_7F24556A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/09-threaded-irq.patch |   35 +++++++++++++++++++++++------------
 1 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/patches/09-threaded-irq.patch b/patches/09-threaded-irq.patch
index 9822acb..0e25e21 100644
--- a/patches/09-threaded-irq.patch
+++ b/patches/09-threaded-irq.patch
@@ -63,28 +63,39 @@ thread in process context as well.
  /* Data structure for the WLAN parts (802.11 cores) of the b43 chip. */
 --- a/drivers/net/wireless/wl12xx/spi.c
 +++ b/drivers/net/wireless/wl12xx/spi.c
-@@ -408,9 +408,20 @@ static int __devinit wl1271_probe(struct
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
-+				   IRQF_TRIGGER_RISING,
-+#else
- 				   IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
-+#endif
+ 				   irqflags,
  				   DRIVER_NAME, wl);
 +#endif
  	if (ret < 0) {
  		wl1271_error("request_irq() failed: %d", ret);
  		goto out_free;
-@@ -431,7 +442,11 @@ static int __devinit wl1271_probe(struct
+@@ -440,7 +451,11 @@ static int __devinit wl1271_probe(struct
  	return 0;
  
   out_irq:
@@ -96,7 +107,7 @@ thread in process context as well.
  
   out_free:
  	wl1271_free_hw(wl);
-@@ -444,7 +459,12 @@ static int __devexit wl1271_remove(struc
+@@ -453,7 +468,12 @@ static int __devexit wl1271_remove(struc
  	struct wl1271 *wl = dev_get_drvdata(&spi->dev);
  
  	wl1271_unregister_hw(wl);
@@ -111,10 +122,10 @@ thread in process context as well.
  	return 0;
 --- a/drivers/net/wireless/wl12xx/wl12xx.h
 +++ b/drivers/net/wireless/wl12xx/wl12xx.h
-@@ -544,6 +544,10 @@ struct wl1271 {
+@@ -582,6 +582,10 @@ struct wl1271 {
  
- 	/* Quirks of specific hardware revisions */
- 	unsigned int quirks;
+ 	/* Platform limitations */
+ 	unsigned int platform_quirks;
 +
 +#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)
 +	struct compat_threaded_irq irq_compat;
-- 
1.7.1

