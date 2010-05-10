Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39017 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645Ab0EJVW7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 17:22:59 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat: move usb_{alloc,free}_coherent
Date: Mon, 10 May 2010 23:22:49 +0200
Message-Id: <1273526569-22845-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1273526569-22845-1-git-send-email-hauke@hauke-m.de>
References: <1273526569-22845-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

usb_alloc_coherent and usb_free_coherent were introduced in kernel 2.6.34.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.34.h |    3 +++
 include/linux/compat-2.6.35.h |    3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/compat-2.6.34.h b/include/linux/compat-2.6.34.h
index 18ae456..2870a3b 100644
--- a/include/linux/compat-2.6.34.h
+++ b/include/linux/compat-2.6.34.h
@@ -197,6 +197,9 @@ do {							\
  */
 #define sysfs_bin_attr_init(bin_attr) sysfs_attr_init(&(bin_attr)->attr)
 
+#define usb_alloc_coherent(dev, size, mem_flags, dma) usb_buffer_alloc(dev, size, mem_flags, dma)
+#define usb_free_coherent(dev, size, addr, dma) usb_buffer_free(dev, size, addr, dma)
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,34)) */
 
 #endif /* LINUX_26_34_COMPAT_H */
diff --git a/include/linux/compat-2.6.35.h b/include/linux/compat-2.6.35.h
index 278af5e..b850f8a 100644
--- a/include/linux/compat-2.6.35.h
+++ b/include/linux/compat-2.6.35.h
@@ -20,9 +20,6 @@ static inline wait_queue_head_t *sk_sleep(struct sock *sk)
 	return sk->sk_sleep;
 }
 
-#define usb_alloc_coherent(dev, size, mem_flags, dma) usb_buffer_alloc(dev, size, mem_flags, dma)
-#define usb_free_coherent(dev, size, addr, dma) usb_buffer_free(dev, size, addr, dma)
-
 #define kparam_block_sysfs_write(a)
 #define kparam_unblock_sysfs_write(a)
 
-- 
1.7.0.4

