Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53980 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023Ab1BAVN4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 16:13:56 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat-wireless: remove compat for threaded_irq in rt2x00
Date: Tue,  1 Feb 2011 22:13:46 +0100
Message-Id: <1296594827-30742-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2x00 does not use threaded_irq any more.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/09-threaded-irq.patch |   56 -----------------------------------------
 1 files changed, 0 insertions(+), 56 deletions(-)

diff --git a/patches/09-threaded-irq.patch b/patches/09-threaded-irq.patch
index 059e58e..df164e9 100644
--- a/patches/09-threaded-irq.patch
+++ b/patches/09-threaded-irq.patch
@@ -61,59 +61,3 @@ thread in process context as well.
  };
  
  /* Data structure for the WLAN parts (802.11 cores) of the b43 chip. */
---- a/drivers/net/wireless/rt2x00/rt2x00.h
-+++ b/drivers/net/wireless/rt2x00/rt2x00.h
-@@ -901,6 +901,10 @@ struct rt2x00_dev {
- 	 * Tasklet for processing tx status reports (rt2800pci).
- 	 */
- 	struct tasklet_struct txstatus_tasklet;
-+
-+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)
-+	struct compat_threaded_irq irq_compat;
-+#endif
- };
- 
- /*
---- a/drivers/net/wireless/rt2x00/rt2x00pci.c
-+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
-@@ -160,10 +160,18 @@ int rt2x00pci_initialize(struct rt2x00_d
- 	/*
- 	 * Register interrupt handler.
- 	 */
-+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)
-+	status = compat_request_threaded_irq(&rt2x00dev->irq_compat,
-+					  rt2x00dev->irq,
-+					  rt2x00dev->ops->lib->irq_handler,
-+					  rt2x00dev->ops->lib->irq_handler_thread,
-+					  IRQF_SHARED, rt2x00dev->name, rt2x00dev);
-+#else
- 	status = request_threaded_irq(rt2x00dev->irq,
- 				      rt2x00dev->ops->lib->irq_handler,
- 				      rt2x00dev->ops->lib->irq_handler_thread,
- 				      IRQF_SHARED, rt2x00dev->name, rt2x00dev);
-+#endif
- 	if (status) {
- 		ERROR(rt2x00dev, "IRQ %d allocation failed (error %d).\n",
- 		      rt2x00dev->irq, status);
-@@ -187,7 +195,11 @@ void rt2x00pci_uninitialize(struct rt2x0
- 	/*
- 	 * Free irq line.
- 	 */
-+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)
-+	compat_free_threaded_irq(&rt2x00dev->irq_compat);
-+#else
- 	free_irq(rt2x00dev->irq, rt2x00dev);
-+#endif
- 
- 	/*
- 	 * Free DMA
-@@ -202,6 +214,9 @@ EXPORT_SYMBOL_GPL(rt2x00pci_uninitialize
-  */
- static void rt2x00pci_free_reg(struct rt2x00_dev *rt2x00dev)
- {
-+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)
-+	compat_destroy_threaded_irq(&rt2x00dev->irq_compat);
-+#endif
- 	kfree(rt2x00dev->rf);
- 	rt2x00dev->rf = NULL;
- 
-- 
1.7.1

