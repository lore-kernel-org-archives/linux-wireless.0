Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:59555 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbZIWSus (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2009 14:50:48 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] [compat-2.6] fix build problems
Date: Wed, 23 Sep 2009 20:50:43 +0200
Message-Id: <1253731843-1045-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IRQ_WAKE_THREAD is not defined in kernel < 2.6.30
in include/linux/irqreturn.h .

In 09-threaded-irq.patch the condition was wrong.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat-2.6.30.h               |    2 ++
 compat/patches/09-threaded-irq.patch |    8 ++++----
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/compat/compat-2.6.30.h b/compat/compat-2.6.30.h
index 6a7c8fb..ed31198 100644
--- a/compat/compat-2.6.30.h
+++ b/compat/compat-2.6.30.h
@@ -14,6 +14,8 @@
 #define TP_ARGS(args...)	TPARGS(args)
 #endif
 
+#define IRQ_WAKE_THREAD	(2)
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30)) */
 
 #endif /* LINUX_26_30_COMPAT_H */
diff --git a/compat/patches/09-threaded-irq.patch b/compat/patches/09-threaded-irq.patch
index e6daa15..4b9a361 100644
--- a/compat/patches/09-threaded-irq.patch
+++ b/compat/patches/09-threaded-irq.patch
@@ -25,15 +25,15 @@ thread in process context as well.
  		}
  	} else {
 +#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)
- 		err = request_threaded_irq(dev->dev->irq, b43_interrupt_handler,
- 					   b43_interrupt_thread_handler,
- 					   IRQF_SHARED, KBUILD_MODNAME, dev);
-+#else
 +		err = compat_request_threaded_irq(&dev->irq_compat,
 +						  dev->dev->irq,
 +						  b43_interrupt_handler,
 +						  b43_interrupt_thread_handler,
 +						  IRQF_SHARED, KBUILD_MODNAME, dev);
++#else
+ 		err = request_threaded_irq(dev->dev->irq, b43_interrupt_handler,
+ 					   b43_interrupt_thread_handler,
+ 					   IRQF_SHARED, KBUILD_MODNAME, dev);
 +#endif
  		if (err) {
  			b43err(dev->wl, "Cannot request IRQ-%d\n", dev->dev->irq);
-- 
1.6.2.1

