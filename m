Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:33168 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756591Ab1FIWFQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 18:05:16 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, jonas.gorski@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/5] compat: add support for kernel 3.0
Date: Fri, 10 Jun 2011 00:04:43 +0200
Message-Id: <1307657087-23900-1-git-send-email-hauke@hauke-m.de> (sfid-20110610_000522_190700_6B840504)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kernel 2.6.40 is now 3.0. The br_port_exists() is function is not in
3.0 yet, so it should go to compat-3.1.h

Add to compat-3.0-stable
---
 include/linux/compat-2.6.h                      |    2 +-
 include/linux/{compat-2.6.40.h => compat-3.1.h} |   12 +++++-------
 2 files changed, 6 insertions(+), 8 deletions(-)
 rename include/linux/{compat-2.6.40.h => compat-3.1.h} (73%)

diff --git a/include/linux/compat-2.6.h b/include/linux/compat-2.6.h
index 8e45fc0..893a159 100644
--- a/include/linux/compat-2.6.h
+++ b/include/linux/compat-2.6.h
@@ -32,6 +32,6 @@
 #include <linux/compat-2.6.37.h>
 #include <linux/compat-2.6.38.h>
 #include <linux/compat-2.6.39.h>
-#include <linux/compat-2.6.40.h>
+#include <linux/compat-3.1.h>
 
 #endif /* LINUX_26_COMPAT_H */
diff --git a/include/linux/compat-2.6.40.h b/include/linux/compat-3.1.h
similarity index 73%
rename from include/linux/compat-2.6.40.h
rename to include/linux/compat-3.1.h
index b3fc8f7..855490e 100644
--- a/include/linux/compat-2.6.40.h
+++ b/include/linux/compat-3.1.h
@@ -1,11 +1,9 @@
-#ifndef LINUX_26_40_COMPAT_H
-#define LINUX_26_40_COMPAT_H
+#ifndef LINUX_3_1_COMPAT_H
+#define LINUX_3_1_COMPAT_H
 
 #include <linux/version.h>
 
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,40))
-
-#include <linux/rcupdate.h>
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(3,1,0))
 
 /*
  * This is not part of The 2.6.37 kernel yet but we
@@ -24,6 +22,6 @@
 #define br_port_exists(dev)	(dev->br_port)
 #endif
 
-#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,40)) */
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,1,0)) */
 
-#endif /* LINUX_26_40_COMPAT_H */
+#endif /* LINUX_3_1_COMPAT_H */
-- 
1.7.4.1

