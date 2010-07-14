Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:41396 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757883Ab0GNUuI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jul 2010 16:50:08 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	philipp_subx@redfish-solutions.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat-wireless: backport threaded-irq for rt2x00
Date: Wed, 14 Jul 2010 22:49:58 +0200
Message-Id: <1279140598-6509-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This backport was done like for the b43 driver. This was just build tested.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/09-threaded-irq.patch |   55 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/patches/09-threaded-irq.patch b/patches/09-threaded-irq.patch
index c1a33e1..cdc506d 100644
--- a/patches/09-threaded-irq.patch
+++ b/patches/09-threaded-irq.patch
@@ -61,3 +61,58 @@ thread in process context as well.
  };
  
  /* Data structure for the WLAN parts (802.11 cores) of the b43 chip. */
+--- a/drivers/net/wireless/rt2x00/rt2x00.h
++++ b/drivers/net/wireless/rt2x00/rt2x00.h
+@@ -882,6 +882,9 @@ struct rt2x00_dev {
+ 	 * and interrupt thread routine.
+ 	 */
+ 	u32 irqvalue[2];
++#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)
++	struct compat_threaded_irq irq_compat;
++#endif
+ };
+ 
+ /*
+--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
++++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
+@@ -153,10 +153,18 @@ int rt2x00pci_initialize(struct rt2x00_d
+ 	/*
+ 	 * Register interrupt handler.
+ 	 */
++#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)
++	status = compat_request_threaded_irq(&rt2x00dev->irq_compat,
++					  rt2x00dev->irq,
++					  rt2x00dev->ops->lib->irq_handler,
++					  rt2x00dev->ops->lib->irq_handler_thread,
++					  IRQF_SHARED, rt2x00dev->name, rt2x00dev);
++#else
+ 	status = request_threaded_irq(rt2x00dev->irq,
+ 				      rt2x00dev->ops->lib->irq_handler,
+ 				      rt2x00dev->ops->lib->irq_handler_thread,
+ 				      IRQF_SHARED, rt2x00dev->name, rt2x00dev);
++#endif
+ 	if (status) {
+ 		ERROR(rt2x00dev, "IRQ %d allocation failed (error %d).\n",
+ 		      rt2x00dev->irq, status);
+@@ -180,7 +188,11 @@ void rt2x00pci_uninitialize(struct rt2x0
+ 	/*
+ 	 * Free irq line.
+ 	 */
++#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)
++	compat_free_threaded_irq(&rt2x00dev->irq_compat);
++#else
+ 	free_irq(rt2x00dev->irq, rt2x00dev);
++#endif
+ 
+ 	/*
+ 	 * Free DMA
+@@ -195,6 +207,9 @@ EXPORT_SYMBOL_GPL(rt2x00pci_uninitialize
+  */
+ static void rt2x00pci_free_reg(struct rt2x00_dev *rt2x00dev)
+ {
++#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)
++	compat_destroy_threaded_irq(&rt2x00dev->irq_compat);
++#endif
+ 	kfree(rt2x00dev->rf);
+ 	rt2x00dev->rf = NULL;
+ 
-- 
1.7.0.4

