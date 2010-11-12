Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:48006 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933009Ab0KLXXU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 18:23:20 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat: add missing pm_runtime.h
Date: Sat, 13 Nov 2010 00:23:15 +0100
Message-Id: <1289604195-13429-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/pm_runtime.h |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/pm_runtime.h

diff --git a/include/linux/pm_runtime.h b/include/linux/pm_runtime.h
new file mode 100644
index 0000000..eec965b
--- /dev/null
+++ b/include/linux/pm_runtime.h
@@ -0,0 +1,14 @@
+#include <linux/version.h>
+
+#ifndef __COMPAT_LINUX_PM_RUNTIME_H
+#define __COMPAT_LINUX_PM_RUNTIME_H
+
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,32))
+#include_next <linux/pm_runtime.h>
+#else
+
+static inline void pm_runtime_enable(struct device *dev) {}
+
+#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,32)) */
+
+#endif
-- 
1.7.1

