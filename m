Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44592 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757588Ab1DXQL0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Apr 2011 12:11:26 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat: do not include kstrto* for kernel >= 2.6.38.4
Date: Sun, 24 Apr 2011 18:11:14 +0200
Message-Id: <1303661475-26632-1-git-send-email-hauke@hauke-m.de> (sfid-20110424_181138_015570_9D84331E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

kstrto* went into kernel 2.6.38.4 and causes conflicts with the version
included in compat-wireless. We use strict_strtol to check if kstrto*
is already available.
kstrto* was not moved to compat-2.6.38.h because kernel version <=
2.6.38.3 needs this backport and some distributions like Ubuntu still
ship an older version of this kernel.

Reported-by: Andreas Hartmann <andihartmann@01019freenet.de>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/kstrtox.c              |    9 +++++++++
 include/linux/compat-2.6.39.h |    7 +++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/compat/kstrtox.c b/compat/kstrtox.c
index 05672e8..10aa91b 100644
--- a/compat/kstrtox.c
+++ b/compat/kstrtox.c
@@ -11,6 +11,14 @@
  *
  * If -E is returned, result is not touched.
  */
+#include <linux/kernel.h>
+/* 
+ * kstrto* was included in kernel 2.6.38.4 and causes conflicts with the
+ * version included in compat-wireless. We use strict_strtol to check if
+ * kstrto* is already available.
+ */
+#ifndef strict_strtol
+
 #include <linux/ctype.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
@@ -225,3 +233,4 @@ int kstrtos8(const char *s, unsigned int base, s8 *res)
 	return 0;
 }
 EXPORT_SYMBOL(kstrtos8);
+#endif /* #ifndef strict_strtol */
diff --git a/include/linux/compat-2.6.39.h b/include/linux/compat-2.6.39.h
index 3a366e2..b4d85fd 100644
--- a/include/linux/compat-2.6.39.h
+++ b/include/linux/compat-2.6.39.h
@@ -94,6 +94,12 @@ static inline struct msi_desc *irq_desc_get_msi_desc(struct irq_desc *desc)
 }
 #endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29)) */
 
+/* 
+ * kstrto* was included in kernel 2.6.38.4 and causes conflicts with the
+ * version included in compat-wireless. We use strict_strtol to check if
+ * kstrto* is already available.
+ */
+#ifndef strict_strtol
 /* Internal, do not use. */
 int __must_check _kstrtoul(const char *s, unsigned int base, unsigned long *res);
 int __must_check _kstrtol(const char *s, unsigned int base, long *res);
@@ -153,6 +159,7 @@ int __must_check kstrtou16(const char *s, unsigned int base, u16 *res);
 int __must_check kstrtos16(const char *s, unsigned int base, s16 *res);
 int __must_check kstrtou8(const char *s, unsigned int base, u8 *res);
 int __must_check kstrtos8(const char *s, unsigned int base, s8 *res);
+#endif /* ifndef strict_strtol */
 
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,39)) */
 
-- 
1.7.1

