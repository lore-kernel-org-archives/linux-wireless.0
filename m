Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:53387 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139Ab0BTAJg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 19:09:36 -0500
Subject: [PATCH] compat: move debugfs_remove_recursive() to compat-2.6.27
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
From: Pavel Roskin <proski@gnu.org>
Date: Fri, 19 Feb 2010 19:09:21 -0500
Message-ID: <20100220000921.15525.55155.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

debugfs_remove_recursive() appeared in Linux 2.6.27, so it should be in
compat-2.6.27, not in compat-2.6.26.
---
 compat/compat-2.6.26.c        |   32 --------------------------------
 compat/compat-2.6.27.c        |   33 +++++++++++++++++++++++++++++++++
 include/linux/compat-2.6.26.h |    7 -------
 include/linux/compat-2.6.27.h |    9 +++++++++
 4 files changed, 42 insertions(+), 39 deletions(-)

diff --git a/compat/compat-2.6.26.c b/compat/compat-2.6.26.c
index 82134c2..b9bf9e7 100644
--- a/compat/compat-2.6.26.c
+++ b/compat/compat-2.6.26.c
@@ -89,37 +89,5 @@ int dev_set_name(struct device *dev, const char *fmt, ...)
 }
 EXPORT_SYMBOL_GPL(dev_set_name);
 
-/*
- * Backport of debugfs_remove_recursive() without using the internals globals
- * which are used by the kernel's version with:
- * simple_release_fs(&debugfs_mount, &debugfs_mount_count);
- */
-void debugfs_remove_recursive(struct dentry *dentry)
-{
-	struct dentry *last = NULL;
-
-	/* Sanity checks */
-	if (!dentry || !dentry->d_parent || !dentry->d_parent->d_inode)
-		return;
-
-	while (dentry != last) {
-		struct dentry *child = dentry;
-
-		/* Find a child without children */
-		while (!list_empty(&child->d_subdirs))
-			child = list_entry(child->d_subdirs.next,
-					   struct dentry,
-					   d_u.d_child);
-
-		/* Bail out if we already tried to remove that entry */
-		if (child == last)
-			return;
-
-		last = child;
-		debugfs_remove(child);
-	}
-}
-EXPORT_SYMBOL_GPL(debugfs_remove_recursive);
-
 #endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,26) */
 
diff --git a/compat/compat-2.6.27.c b/compat/compat-2.6.27.c
index 4fef36a..a226a0f 100644
--- a/compat/compat-2.6.27.c
+++ b/compat/compat-2.6.27.c
@@ -12,6 +12,7 @@
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,27))
 
+#include <linux/debugfs.h>
 #include <linux/pci.h>
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,24))
 #include <linux/mmc/sdio.h>
@@ -206,6 +207,38 @@ unsigned int sdio_align_size(struct sdio_func *func, unsigned int sz)
 EXPORT_SYMBOL_GPL(sdio_align_size);
 #endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,24) */
 
+/*
+ * Backport of debugfs_remove_recursive() without using the internals globals
+ * which are used by the kernel's version with:
+ * simple_release_fs(&debugfs_mount, &debugfs_mount_count);
+ */
+void debugfs_remove_recursive(struct dentry *dentry)
+{
+	struct dentry *last = NULL;
+
+	/* Sanity checks */
+	if (!dentry || !dentry->d_parent || !dentry->d_parent->d_inode)
+		return;
+
+	while (dentry != last) {
+		struct dentry *child = dentry;
+
+		/* Find a child without children */
+		while (!list_empty(&child->d_subdirs))
+			child = list_entry(child->d_subdirs.next,
+					   struct dentry,
+					   d_u.d_child);
+
+		/* Bail out if we already tried to remove that entry */
+		if (child == last)
+			return;
+
+		last = child;
+		debugfs_remove(child);
+	}
+}
+EXPORT_SYMBOL_GPL(debugfs_remove_recursive);
+
 
 #endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,27) */
 
diff --git a/include/linux/compat-2.6.26.h b/include/linux/compat-2.6.26.h
index 498fe44..d98d2a6 100644
--- a/include/linux/compat-2.6.26.h
+++ b/include/linux/compat-2.6.26.h
@@ -18,13 +18,6 @@
 #include <linux/fs.h>
 #include <linux/types.h>
 
-#if defined(CONFIG_DEBUG_FS)
-void debugfs_remove_recursive(struct dentry *dentry);
-#else
-static inline void debugfs_remove_recursive(struct dentry *dentry)
-{ }
-#endif
-
 /* These jiffie helpers added as of 2.6.26 */
 
 /*
diff --git a/include/linux/compat-2.6.27.h b/include/linux/compat-2.6.27.h
index e9de41e..72b6847 100644
--- a/include/linux/compat-2.6.27.h
+++ b/include/linux/compat-2.6.27.h
@@ -214,4 +214,13 @@ static inline void dma_sync_single_range_for_device(struct device *dev,
 
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,27)) */
 
+struct dentry;
+
+#if defined(CONFIG_DEBUG_FS)
+void debugfs_remove_recursive(struct dentry *dentry);
+#else
+static inline void debugfs_remove_recursive(struct dentry *dentry)
+{ }
+#endif
+
 #endif /* LINUX_26_27_COMPAT_H */
