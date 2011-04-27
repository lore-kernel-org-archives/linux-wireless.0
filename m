Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:60783 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812Ab1D0SEZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2011 14:04:25 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat: backport vzalloc()
Date: Wed, 27 Apr 2011 20:04:16 +0200
Message-Id: <1303927456-7067-1-git-send-email-hauke@hauke-m.de> (sfid-20110427_200428_132859_14FBE974)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

vzalloc() is used in rtl8192ce now.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat-2.6.37.c        |   19 +++++++++++++++++++
 include/linux/compat-2.6.37.h |    2 ++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/compat/compat-2.6.37.c b/compat/compat-2.6.37.c
index 8636c65..c49efea 100644
--- a/compat/compat-2.6.37.c
+++ b/compat/compat-2.6.37.c
@@ -334,4 +334,23 @@ void compat_led_classdev_unregister(struct led_classdev *led_cdev)
 }
 EXPORT_SYMBOL(compat_led_classdev_unregister);
 
+/**
+ *	vzalloc - allocate virtually contiguous memory with zero fill
+ *	@size:	allocation size
+ *	Allocate enough pages to cover @size from the page level
+ *	allocator and map them into contiguous kernel virtual space.
+ *	The memory allocated is set to zero.
+ *
+ *	For tight control over page level allocator and protection flags
+ *	use __vmalloc() instead.
+ */
+void *vzalloc(unsigned long size)
+{
+	void *buf;
+	buf = vmalloc(size);
+	memset(buf, 0, size);
+	return buf;
+}
+EXPORT_SYMBOL(vzalloc);
+
 #endif
diff --git a/include/linux/compat-2.6.37.h b/include/linux/compat-2.6.37.h
index cee23a8..57868f5 100644
--- a/include/linux/compat-2.6.37.h
+++ b/include/linux/compat-2.6.37.h
@@ -110,6 +110,8 @@ extern void compat_led_brightness_set(struct led_classdev *led_cdev,
 
 #define netdev_refcnt_read(a) atomic_read(&a->refcnt)
 
+extern void *vzalloc(unsigned long size);
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,37)) */
 
 #endif /* LINUX_26_37_COMPAT_H */
-- 
1.7.1

