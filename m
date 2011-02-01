Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57913 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab1BAVS3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 16:18:29 -0500
Received: by bwz15 with SMTP id 15so6776084bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 Feb 2011 13:18:28 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH 1/2] compat-wireless: remove compat for threaded_irq in rt2x00
Date: Tue, 1 Feb 2011 22:17:02 +0100
Cc: mcgrof@gmail.com, linux-wireless@vger.kernel.org
References: <1296594827-30742-1-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1296594827-30742-1-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201102012217.03029.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag, 1. Februar 2011 schrieb Hauke Mehrtens:
> rt2x00 does not use threaded_irq any more.

Hehe, sorry for that but the interrupt threading caused performance
issues on embedded devices and also introduced some nasty "bugs" on slow
platforms. Hence, we moved everything to per IRQ tasklets.

Thanks a lot Hauke!

Helmut

> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  patches/09-threaded-irq.patch |   56 -----------------------------------------
>  1 files changed, 0 insertions(+), 56 deletions(-)
> 
> diff --git a/patches/09-threaded-irq.patch b/patches/09-threaded-irq.patch
> index 059e58e..df164e9 100644
> --- a/patches/09-threaded-irq.patch
> +++ b/patches/09-threaded-irq.patch
> @@ -61,59 +61,3 @@ thread in process context as well.
>   };
>   
>   /* Data structure for the WLAN parts (802.11 cores) of the b43 chip. */
> ---- a/drivers/net/wireless/rt2x00/rt2x00.h
> -+++ b/drivers/net/wireless/rt2x00/rt2x00.h
> -@@ -901,6 +901,10 @@ struct rt2x00_dev {
> - 	 * Tasklet for processing tx status reports (rt2800pci).
> - 	 */
> - 	struct tasklet_struct txstatus_tasklet;
> -+
> -+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)
> -+	struct compat_threaded_irq irq_compat;
> -+#endif
> - };
> - 
> - /*
> ---- a/drivers/net/wireless/rt2x00/rt2x00pci.c
> -+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
> -@@ -160,10 +160,18 @@ int rt2x00pci_initialize(struct rt2x00_d
> - 	/*
> - 	 * Register interrupt handler.
> - 	 */
> -+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)
> -+	status = compat_request_threaded_irq(&rt2x00dev->irq_compat,
> -+					  rt2x00dev->irq,
> -+					  rt2x00dev->ops->lib->irq_handler,
> -+					  rt2x00dev->ops->lib->irq_handler_thread,
> -+					  IRQF_SHARED, rt2x00dev->name, rt2x00dev);
> -+#else
> - 	status = request_threaded_irq(rt2x00dev->irq,
> - 				      rt2x00dev->ops->lib->irq_handler,
> - 				      rt2x00dev->ops->lib->irq_handler_thread,
> - 				      IRQF_SHARED, rt2x00dev->name, rt2x00dev);
> -+#endif
> - 	if (status) {
> - 		ERROR(rt2x00dev, "IRQ %d allocation failed (error %d).\n",
> - 		      rt2x00dev->irq, status);
> -@@ -187,7 +195,11 @@ void rt2x00pci_uninitialize(struct rt2x0
> - 	/*
> - 	 * Free irq line.
> - 	 */
> -+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)
> -+	compat_free_threaded_irq(&rt2x00dev->irq_compat);
> -+#else
> - 	free_irq(rt2x00dev->irq, rt2x00dev);
> -+#endif
> - 
> - 	/*
> - 	 * Free DMA
> -@@ -202,6 +214,9 @@ EXPORT_SYMBOL_GPL(rt2x00pci_uninitialize
> -  */
> - static void rt2x00pci_free_reg(struct rt2x00_dev *rt2x00dev)
> - {
> -+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)
> -+	compat_destroy_threaded_irq(&rt2x00dev->irq_compat);
> -+#endif
> - 	kfree(rt2x00dev->rf);
> - 	rt2x00dev->rf = NULL;
> - 
> 

