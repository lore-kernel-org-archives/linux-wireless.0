Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:5084 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756262Ab0BTAhX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 19:37:23 -0500
Subject: [PATCH v2] compat: move debugfs_remove_recursive() to compat-2.6.27
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20100220000921.15525.55155.stgit@mj.roinet.com>
References: <20100220000921.15525.55155.stgit@mj.roinet.com>
Content-Type: text/plain
Date: Fri, 19 Feb 2010 19:37:10 -0500
Message-Id: <1266626230.25707.60.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

compat: move debugfs_remove_recursive() to compat-2.6.27

From: Pavel Roskin <proski@gnu.org>

debugfs_remove_recursive() appeared in Linux 2.6.27, so it should be in
compat-2.6.27, not in compat-2.6.26.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

This is revision 2, with Signed-off-by and with linux/debugfs.h moved
from compat-2.6.26.h to compat-2.6.27.h.  I assume including Linux
headers from compat headers is preferred over declaring the needed
structures.

 compat/compat-2.6.26.c        |   32 --------------------------------
 compat/compat-2.6.27.c        |   32 ++++++++++++++++++++++++++++++++
 include/linux/compat-2.6.26.h |    8 --------
 include/linux/compat-2.6.27.h |    8 ++++++++
 4 files changed, 40 insertions(+), 40 deletions(-)

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
index 4fef36a..240f84f 100644
--- a/compat/compat-2.6.27.c
+++ b/compat/compat-2.6.27.c
@@ -206,6 +206,38 @@ unsigned int sdio_align_size(struct sdio_func *func, unsigned int sz)
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
index 498fe44..2bee30e 100644
--- a/include/linux/compat-2.6.26.h
+++ b/include/linux/compat-2.6.26.h
@@ -11,20 +11,12 @@
 #include <linux/jiffies.h>
 #include <net/sock.h>
 #include <linux/fs.h>
-#include <linux/debugfs.h>
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,24))
 #include <net/net_namespace.h>
 #endif
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
index e9de41e..f4c77ce 100644
--- a/include/linux/compat-2.6.27.h
+++ b/include/linux/compat-2.6.27.h
@@ -5,6 +5,7 @@
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,27))
 
+#include <linux/debugfs.h>
 #include <linux/list.h>
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
@@ -214,4 +215,11 @@ static inline void dma_sync_single_range_for_device(struct device *dev,
 
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,27)) */
 
+#if defined(CONFIG_DEBUG_FS)
+void debugfs_remove_recursive(struct dentry *dentry);
+#else
+static inline void debugfs_remove_recursive(struct dentry *dentry)
+{ }
+#endif
+
 #endif /* LINUX_26_27_COMPAT_H */

