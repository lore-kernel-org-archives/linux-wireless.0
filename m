Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39353 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754670Ab2DZSIi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2012 14:08:38 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [RFC c 6/9] compat: move simple_open()
Date: Thu, 26 Apr 2012 20:07:51 +0200
Message-Id: <1335463674-13003-11-git-send-email-hauke@hauke-m.de> (sfid-20120426_200841_382742_8BC19336)
In-Reply-To: <1335463674-13003-1-git-send-email-hauke@hauke-m.de>
References: <1335463674-13003-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-3.5.h |    2 --
 include/linux/fs.h         |   14 ++++++++++++++
 2 files changed, 14 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/fs.h

diff --git a/include/linux/compat-3.5.h b/include/linux/compat-3.5.h
index 9c10a42..07a79a6 100644
--- a/include/linux/compat-3.5.h
+++ b/include/linux/compat-3.5.h
@@ -6,8 +6,6 @@
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(3,5,0))
 
-extern int simple_open(struct inode *inode, struct file *file);
-
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,5,0)) */
 
 #endif /* LINUX_3_5_COMPAT_H */
diff --git a/include/linux/fs.h b/include/linux/fs.h
new file mode 100644
index 0000000..f0412ba
--- /dev/null
+++ b/include/linux/fs.h
@@ -0,0 +1,14 @@
+#ifndef _COMPAT_LINUX_FS_H
+#define _COMPAT_LINUX_FS_H
+
+#include_next <linux/fs.h>
+
+#include <linux/version.h>
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(3,5,0))
+
+extern int simple_open(struct inode *inode, struct file *file);
+
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,5,0)) */
+
+#endif	/* _COMPAT_LINUX_FS_H */
-- 
1.7.9.5

