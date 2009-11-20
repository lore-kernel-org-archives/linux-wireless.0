Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54757 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754349AbZKTWCL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 17:02:11 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/3] [compat-2.6] Add IFF_DONT_BRIDGE definition to compat
Date: Fri, 20 Nov 2009 23:01:51 +0100
Message-Id: <1258754513-4546-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1258754513-4546-1-git-send-email-hauke@hauke-m.de>
References: <1258754513-4546-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The IFF_DONT_BRIDGE flag will not be interpreted by an old kernel, but
it does not hurt the kernel if it is set but not read by the non
wireless network code.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat-2.6.33.c                      |   16 ++++++++++++++++
 compat/compat-2.6.33.h                      |   15 +++++++++++++++
 compat/compat.h                             |    1 +
 compat/patches/98-add-compat-wireless.patch |    3 ++-
 4 files changed, 34 insertions(+), 1 deletions(-)
 create mode 100644 compat/compat-2.6.33.c
 create mode 100644 compat/compat-2.6.33.h

diff --git a/compat/compat-2.6.33.c b/compat/compat-2.6.33.c
new file mode 100644
index 0000000..2fccadb
--- /dev/null
+++ b/compat/compat-2.6.33.c
@@ -0,0 +1,16 @@
+/*
+ * Copyright 2007	Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Compatibility file for Linux wireless for kernels 2.6.33.
+ */
+
+#include <net/compat.h>
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33))
+
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)) */
+
diff --git a/compat/compat-2.6.33.h b/compat/compat-2.6.33.h
new file mode 100644
index 0000000..528627e
--- /dev/null
+++ b/compat/compat-2.6.33.h
@@ -0,0 +1,15 @@
+#ifndef LINUX_26_33_COMPAT_H
+#define LINUX_26_33_COMPAT_H
+
+#include <linux/autoconf.h>
+#include <linux/version.h>
+#include <linux/compat_autoconf.h>
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33))
+
+#define IFF_DONT_BRIDGE 0x800		/* disallow bridging this ether dev */
+/* source: include/linux/if.h */
+
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)) */
+
+#endif /* LINUX_26_33_COMPAT_H */
diff --git a/compat/compat.h b/compat/compat.h
index 05612b2..76e998d 100644
--- a/compat/compat.h
+++ b/compat/compat.h
@@ -21,5 +21,6 @@
 #include <net/compat-2.6.30.h>
 #include <net/compat-2.6.31.h>
 #include <net/compat-2.6.32.h>
+#include <net/compat-2.6.33.h>
 
 #endif /* LINUX_26_COMPAT_H */
diff --git a/compat/patches/98-add-compat-wireless.patch b/compat/patches/98-add-compat-wireless.patch
index e78c63f..0bbf85b 100644
--- a/compat/patches/98-add-compat-wireless.patch
+++ b/compat/patches/98-add-compat-wireless.patch
@@ -20,7 +20,7 @@ added compat.h also for ssb, I forget.
 
 --- a/net/wireless/Makefile	2009-08-07 12:27:50.836497001 -0700
 +++ b/net/wireless/Makefile	2009-08-07 12:27:51.952497240 -0700
-@@ -15,3 +15,16 @@
+@@ -15,3 +15,17 @@
  cfg80211-$(CONFIG_CFG80211_WEXT) += wext-compat.o wext-sme.o
  
  ccflags-y += -D__CHECK_ENDIAN__
@@ -36,6 +36,7 @@ added compat.h also for ssb, I forget.
 +cfg80211-$(CONFIG_COMPAT_WIRELESS_30) += compat-2.6.30.o
 +cfg80211-$(CONFIG_COMPAT_WIRELESS_31) += compat-2.6.31.o
 +cfg80211-$(CONFIG_COMPAT_WIRELESS_32) += compat-2.6.32.o
++cfg80211-$(CONFIG_COMPAT_WIRELESS_33) += compat-2.6.33.o
 +
 --- a/include/net/cfg80211.h
 +++ b/include/net/cfg80211.h
-- 
1.6.3.3

