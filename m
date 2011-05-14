Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:46002 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753729Ab1ENRrj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 May 2011 13:47:39 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat: add header linux/printk.h
Date: Sat, 14 May 2011 19:47:32 +0200
Message-Id: <1305395252-21873-1-git-send-email-hauke@hauke-m.de> (sfid-20110514_194743_759541_AD6EC58A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some drivers are including linux/printk.h and this is not available for
kernel < 2.6.37, but the needed declared methods are all in
linux/kernel.h.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/printk.h |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/printk.h

diff --git a/include/linux/printk.h b/include/linux/printk.h
new file mode 100644
index 0000000..c0822ac
--- /dev/null
+++ b/include/linux/printk.h
@@ -0,0 +1,12 @@
+#ifndef _COMPAT_LINUX_PRINTK_H
+#define _COMPAT_LINUX_PRINTK_H 1
+
+#include <linux/version.h>
+
+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,36))
+#include_next <linux/printk.h>
+#else
+#include <linux/kernel.h>
+#endif /* (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,35)) */
+
+#endif	/* _COMPAT_LINUX_PRINTK_H */
-- 
1.7.4.1

