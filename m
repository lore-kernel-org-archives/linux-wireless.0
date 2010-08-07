Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51965 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753786Ab0HGNdB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Aug 2010 09:33:01 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/4] compat: move va_format to compat-2.6.36.h
Date: Sat,  7 Aug 2010 15:32:19 +0200
Message-Id: <1281187941-7168-3-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1281187941-7168-1-git-send-email-hauke@hauke-m.de>
References: <1281187941-7168-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This struct was introduced in kernel 2.6.36 and not 2.6.35.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.35.h |    5 -----
 include/linux/compat-2.6.36.h |    5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/compat-2.6.35.h b/include/linux/compat-2.6.35.h
index d2e82cc..f0562cd 100644
--- a/include/linux/compat-2.6.35.h
+++ b/include/linux/compat-2.6.35.h
@@ -8,11 +8,6 @@
 #include <net/sock.h>
 #include <linux/types.h>
 
-struct va_format {
-	const char *fmt;
-	va_list *va;
-};
-
 /* added on linux/kernel.h */
 #define USHRT_MAX      ((u16)(~0U))
 #define SHRT_MAX       ((s16)(USHRT_MAX>>1))
diff --git a/include/linux/compat-2.6.36.h b/include/linux/compat-2.6.36.h
index 0307108..b14c772 100644
--- a/include/linux/compat-2.6.36.h
+++ b/include/linux/compat-2.6.36.h
@@ -8,6 +8,11 @@
 #define kparam_block_sysfs_write(a)
 #define kparam_unblock_sysfs_write(a)
 
+struct va_format {
+	const char *fmt;
+	va_list *va;
+};
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36)) */
 
 #endif /* LINUX_26_36_COMPAT_H */
-- 
1.7.0.4

