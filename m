Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39018 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077Ab0EJVW7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 17:22:59 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat: move kparam_{block,unblock}_sysfs_write
Date: Mon, 10 May 2010 23:22:48 +0200
Message-Id: <1273526569-22845-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

kparam_block_sysfs_write and kparam_unblock_sysfs_write will introduced
in kernel 2.6.35 and not 2.6.33.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.33.h |    3 ---
 include/linux/compat-2.6.35.h |    3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/compat-2.6.33.h b/include/linux/compat-2.6.33.h
index 70e5f98..0b434fc 100644
--- a/include/linux/compat-2.6.33.h
+++ b/include/linux/compat-2.6.33.h
@@ -54,9 +54,6 @@ static inline void compat_release_firmware(const struct firmware *fw)
 #define IFF_DONT_BRIDGE 0x800		/* disallow bridging this ether dev */
 /* source: include/linux/if.h */
 
-#define kparam_block_sysfs_write(a)
-#define kparam_unblock_sysfs_write(a)
-
 /* this will never happen on older kernels */
 #define NETDEV_POST_INIT 0xffff
 
diff --git a/include/linux/compat-2.6.35.h b/include/linux/compat-2.6.35.h
index 9c6e696..278af5e 100644
--- a/include/linux/compat-2.6.35.h
+++ b/include/linux/compat-2.6.35.h
@@ -23,6 +23,9 @@ static inline wait_queue_head_t *sk_sleep(struct sock *sk)
 #define usb_alloc_coherent(dev, size, mem_flags, dma) usb_buffer_alloc(dev, size, mem_flags, dma)
 #define usb_free_coherent(dev, size, addr, dma) usb_buffer_free(dev, size, addr, dma)
 
+#define kparam_block_sysfs_write(a)
+#define kparam_unblock_sysfs_write(a)
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35)) */
 
 #endif /* LINUX_26_35_COMPAT_H */
-- 
1.7.0.4

