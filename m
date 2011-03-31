Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:34006 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758609Ab1CaQW0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2011 12:22:26 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	Ido Yariv <ido@wizery.com>
Subject: [PATCH 2/5] compat-wireless: backport threaded irq for wl12xx_spi
Date: Thu, 31 Mar 2011 18:22:04 +0200
Message-Id: <1301588527-16615-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1301588527-16615-1-git-send-email-hauke@hauke-m.de>
References: <1301588527-16615-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This backports threaded irq support for kernel < 2.6.31 for wl12xx_spi.
This is only compile tested as I do not have such a device.

Luis please add this into the linux-2.6.39.y branch.

CC: Ido Yariv <ido@wizery.com>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/09-threaded-irq.patch |   61 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 61 insertions(+), 0 deletions(-)

diff --git a/patches/09-threaded-irq.patch b/patches/09-threaded-irq.patch
index f62933e..9822acb 100644
--- a/patches/09-threaded-irq.patch
+++ b/patches/09-threaded-irq.patch
@@ -61,3 +61,64 @@ thread in process context as well.
  };
  
  /* Data structure for the WLAN parts (802.11 cores) of the b43 chip. */
+--- a/drivers/net/wireless/wl12xx/spi.c
++++ b/drivers/net/wireless/wl12xx/spi.c
+@@ -408,9 +408,20 @@ static int __devinit wl1271_probe(struct
+ 		goto out_free;
+ 	}
+ 
++#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)
++	ret = compat_request_threaded_irq(&wl->irq_compat, wl->irq,
++					  wl1271_hardirq, wl1271_irq,
++					  IRQF_TRIGGER_RISING,
++					  DRIVER_NAME, wl);
++#else
+ 	ret = request_threaded_irq(wl->irq, wl1271_hardirq, wl1271_irq,
++#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,32)
++				   IRQF_TRIGGER_RISING,
++#else
+ 				   IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
++#endif
+ 				   DRIVER_NAME, wl);
++#endif
+ 	if (ret < 0) {
+ 		wl1271_error("request_irq() failed: %d", ret);
+ 		goto out_free;
+@@ -431,7 +442,11 @@ static int __devinit wl1271_probe(struct
+ 	return 0;
+ 
+  out_irq:
++#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)
++	compat_free_threaded_irq(&wl->irq_compat);
++#else
+ 	free_irq(wl->irq, wl);
++#endif
+ 
+  out_free:
+ 	wl1271_free_hw(wl);
+@@ -444,7 +459,12 @@ static int __devexit wl1271_remove(struc
+ 	struct wl1271 *wl = dev_get_drvdata(&spi->dev);
+ 
+ 	wl1271_unregister_hw(wl);
++#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)
++	compat_free_threaded_irq(&wl->irq_compat);
++	compat_destroy_threaded_irq(&wl->irq_compat);
++#else
+ 	free_irq(wl->irq, wl);
++#endif
+ 	wl1271_free_hw(wl);
+ 
+ 	return 0;
+--- a/drivers/net/wireless/wl12xx/wl12xx.h
++++ b/drivers/net/wireless/wl12xx/wl12xx.h
+@@ -544,6 +544,10 @@ struct wl1271 {
+ 
+ 	/* Quirks of specific hardware revisions */
+ 	unsigned int quirks;
++
++#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)
++	struct compat_threaded_irq irq_compat;
++#endif
+ };
+ 
+ struct wl1271_station {
-- 
1.7.1

