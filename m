Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:58848 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754171Ab1EVKsE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 May 2011 06:48:04 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/3] compat-wireless: adapt rename of dev to sdev in b43
Date: Sun, 22 May 2011 12:47:06 +0200
Message-Id: <1306061227-4159-2-git-send-email-hauke@hauke-m.de> (sfid-20110522_124807_850988_A1490D58)
In-Reply-To: <1306061227-4159-1-git-send-email-hauke@hauke-m.de>
References: <1306061227-4159-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adapt changes from "b43: rename b43_wldev's field with ssb_device to sdev"

This was missing in commit "compat-wireless: fix applying of 09-threaded-irq.patch"

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/09-threaded-irq.patch |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/patches/09-threaded-irq.patch b/patches/09-threaded-irq.patch
index d0f1d65..acfe043 100644
--- a/patches/09-threaded-irq.patch
+++ b/patches/09-threaded-irq.patch
@@ -26,7 +26,7 @@ thread in process context as well.
  	} else {
 +#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)
 +		err = compat_request_threaded_irq(&dev->irq_compat,
-+						  dev->dev->irq,
++						  dev->sdev->irq,
 +						  b43_interrupt_handler,
 +						  b43_interrupt_thread_handler,
 +						  IRQF_SHARED, KBUILD_MODNAME, dev);
@@ -43,7 +43,7 @@ thread in process context as well.
  static void b43_wireless_core_detach(struct b43_wldev *dev)
  {
 +#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)
-+	if (dev->dev->bus->bustype != SSB_BUSTYPE_SDIO)
++	if (dev->sdev->bus->bustype != SSB_BUSTYPE_SDIO)
 +		compat_destroy_threaded_irq(&dev->irq_compat);
 +#endif
  	/* We release firmware that late to not be required to re-request
-- 
1.7.4.1

