Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44985 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753298Ab2EXNc7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 May 2012 09:32:59 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@qca.qualcomm.com
Subject: [PATCH v2] compat: rename compat-3.5.c to compat-3.4.c
Date: Thu, 24 May 2012 15:32:57 +0200
Message-Id: <1337866377-12475-1-git-send-email-nbd@openwrt.org> (sfid-20120524_153302_748055_A5D9F27F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It only contains simple_open, which is already available on Linux 3.4.
Fixes duplicate symbol issues on 3.4

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 compat/Makefile            |    2 +-
 compat/compat-3.4.c        |   20 ++++++++++++++++++++
 compat/compat-3.5.c        |   20 --------------------
 include/linux/compat-3.4.h |    2 ++
 include/linux/compat-3.5.h |    2 --
 5 files changed, 23 insertions(+), 23 deletions(-)
 create mode 100644 compat/compat-3.4.c
 delete mode 100644 compat/compat-3.5.c

diff --git a/compat/Makefile b/compat/Makefile
index bda677b..667e727 100644
--- a/compat/Makefile
+++ b/compat/Makefile
@@ -37,7 +37,7 @@ compat-$(CONFIG_COMPAT_KERNEL_2_6_39) += \
 compat-$(CONFIG_COMPAT_KERNEL_3_0) += compat-3.0.o
 compat-$(CONFIG_COMPAT_KERNEL_3_2) += compat-3.2.o
 compat-$(CONFIG_COMPAT_KERNEL_3_3) += compat-3.3.o
-compat-$(CONFIG_COMPAT_KERNEL_3_5) += compat-3.5.o
+compat-$(CONFIG_COMPAT_KERNEL_3_4) += compat-3.4.o
 
 compat-$(CONFIG_COMPAT_CORDIC) += cordic.o
 compat-$(CONFIG_COMPAT_CRC8) += crc8.o
diff --git a/compat/compat-3.4.c b/compat/compat-3.4.c
new file mode 100644
index 0000000..5d516f0
--- /dev/null
+++ b/compat/compat-3.4.c
@@ -0,0 +1,20 @@
+/*
+ * Copyright 2012  Luis R. Rodriguez <mcgrof@frijolero.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Compatibility file for Linux wireless for kernels 3.5.
+ */
+
+#include <linux/fs.h>
+#include <linux/module.h>
+
+int simple_open(struct inode *inode, struct file *file)
+{
+	if (inode->i_private)
+		file->private_data = inode->i_private;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(simple_open);
diff --git a/compat/compat-3.5.c b/compat/compat-3.5.c
deleted file mode 100644
index 5d516f0..0000000
--- a/compat/compat-3.5.c
+++ /dev/null
@@ -1,20 +0,0 @@
-/*
- * Copyright 2012  Luis R. Rodriguez <mcgrof@frijolero.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * Compatibility file for Linux wireless for kernels 3.5.
- */
-
-#include <linux/fs.h>
-#include <linux/module.h>
-
-int simple_open(struct inode *inode, struct file *file)
-{
-	if (inode->i_private)
-		file->private_data = inode->i_private;
-	return 0;
-}
-EXPORT_SYMBOL_GPL(simple_open);
diff --git a/include/linux/compat-3.4.h b/include/linux/compat-3.4.h
index 1b72374..377d036 100644
--- a/include/linux/compat-3.4.h
+++ b/include/linux/compat-3.4.h
@@ -75,6 +75,8 @@ static inline void eth_hw_addr_random(struct net_device *dev)
 	module_driver(__pci_driver, pci_register_driver, \
 		       pci_unregister_driver)
 
+extern int simple_open(struct inode *inode, struct file *file);
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,4,0)) */
 
 #endif /* LINUX_5_4_COMPAT_H */
diff --git a/include/linux/compat-3.5.h b/include/linux/compat-3.5.h
index c837deb..0bb35bb 100644
--- a/include/linux/compat-3.5.h
+++ b/include/linux/compat-3.5.h
@@ -8,8 +8,6 @@
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(3,5,0))
 
-extern int simple_open(struct inode *inode, struct file *file);
-
 /* Backports tty_lock: Localise the lock */
 #define tty_lock(__tty) tty_lock()
 #define tty_unlock(__tty) tty_unlock()
-- 
1.7.3.2

