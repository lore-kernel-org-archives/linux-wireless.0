Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:60499 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753424Ab1FBQfq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 12:35:46 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 4/9] compat-wireless: make patches apply again
Date: Thu,  2 Jun 2011 18:35:20 +0200
Message-Id: <1307032525-18916-5-git-send-email-hauke@hauke-m.de> (sfid-20110602_183604_392486_12E6848C)
In-Reply-To: <1307032525-18916-1-git-send-email-hauke@hauke-m.de>
References: <1307032525-18916-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/09-threaded-irq.patch |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/patches/09-threaded-irq.patch b/patches/09-threaded-irq.patch
index acfe043..d13e3cc 100644
--- a/patches/09-threaded-irq.patch
+++ b/patches/09-threaded-irq.patch
@@ -6,39 +6,39 @@ thread in process context as well.
 
 --- a/drivers/net/wireless/b43/main.c
 +++ b/drivers/net/wireless/b43/main.c
-@@ -3970,8 +3970,13 @@ redo:
- 	if (dev->sdev->bus->bustype == SSB_BUSTYPE_SDIO) {
+@@ -3971,8 +3971,13 @@ redo:
+ 	if (b43_bus_host_is_sdio(dev->dev)) {
  		b43_sdio_free_irq(dev);
  	} else {
 +#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)
 +		compat_synchronize_threaded_irq(&dev->irq_compat);
 +		compat_free_threaded_irq(&dev->irq_compat);
 +#else
- 		synchronize_irq(dev->sdev->irq);
- 		free_irq(dev->sdev->irq, dev);
+ 		synchronize_irq(dev->dev->irq);
+ 		free_irq(dev->dev->irq, dev);
 +#endif
  	}
  	mutex_lock(&wl->mutex);
  	dev = wl->current_dev;
-@@ -4011,9 +4016,17 @@ static int b43_wireless_core_start(struc
+@@ -4012,9 +4017,17 @@ static int b43_wireless_core_start(struc
  			goto out;
  		}
  	} else {
 +#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)
 +		err = compat_request_threaded_irq(&dev->irq_compat,
-+						  dev->sdev->irq,
++						  dev->dev->irq,
 +						  b43_interrupt_handler,
 +						  b43_interrupt_thread_handler,
 +						  IRQF_SHARED, KBUILD_MODNAME, dev);
 +#else
- 		err = request_threaded_irq(dev->sdev->irq, b43_interrupt_handler,
+ 		err = request_threaded_irq(dev->dev->irq, b43_interrupt_handler,
  					   b43_interrupt_thread_handler,
  					   IRQF_SHARED, KBUILD_MODNAME, dev);
 +#endif
  		if (err) {
  			b43err(dev->wl, "Cannot request IRQ-%d\n",
- 			       dev->sdev->irq);
-@@ -4728,6 +4741,10 @@ static int b43_setup_bands(struct b43_wl
+ 			       dev->dev->irq);
+@@ -4734,6 +4747,10 @@ static int b43_setup_bands(struct b43_wl
  
  static void b43_wireless_core_detach(struct b43_wldev *dev)
  {
@@ -51,7 +51,7 @@ thread in process context as well.
  	b43_release_firmware(dev);
 --- a/drivers/net/wireless/b43/b43.h
 +++ b/drivers/net/wireless/b43/b43.h
-@@ -772,6 +772,9 @@ struct b43_wldev {
+@@ -774,6 +774,9 @@ struct b43_wldev {
  	unsigned int tx_count;
  	unsigned int rx_count;
  #endif
-- 
1.7.4.1

