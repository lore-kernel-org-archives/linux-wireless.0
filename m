Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:53531 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbaJ1MUl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 08:20:41 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 1/3] debugfs: add helper function to create device related seq_file
Date: Tue, 28 Oct 2014 13:19:10 +0100
Message-ID: <1414498752-9746-2-git-send-email-arend@broadcom.com> (sfid-20141028_132046_370422_5F6267D8)
In-Reply-To: <1414498752-9746-1-git-send-email-arend@broadcom.com>
References: <1414498752-9746-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds a helper function that simplifies adding a
so-called single_open sequence file for device drivers. The
calling device driver needs to provide a read function and
a device pointer. The field struct seq_file::private will
reference the device pointer upon call to the read function
so the driver can obtain his data from it and do its task
of providing the file content using seq_printf() calls and
alike. Using this helper function also gets rid of the need
to specify file operations per debugfs file.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 fs/debugfs/file.c       | 54 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/debugfs.h | 16 ++++++++++++++-
 2 files changed, 69 insertions(+), 1 deletion(-)

diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index 76c08c2..088b3fc 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -22,6 +22,7 @@
 #include <linux/io.h>
 #include <linux/slab.h>
 #include <linux/atomic.h>
+#include <linux/device.h>
 
 static ssize_t default_read_file(struct file *file, char __user *buf,
 				 size_t count, loff_t *ppos)
@@ -761,3 +762,56 @@ struct dentry *debugfs_create_regset32(const char *name, umode_t mode,
 EXPORT_SYMBOL_GPL(debugfs_create_regset32);
 
 #endif /* CONFIG_HAS_IOMEM */
+
+struct debugfs_devm_entry {
+	int (*read)(struct seq_file *seq, void *data);
+	struct device *dev;
+};
+
+static int debugfs_devm_entry_open(struct inode *inode, struct file *f)
+{
+	struct debugfs_devm_entry *entry = inode->i_private;
+
+	return single_open(f, entry->read, entry->dev);
+}
+
+static const struct file_operations debugfs_devm_entry_ops = {
+	.owner = THIS_MODULE,
+	.open = debugfs_devm_entry_open,
+	.release = single_release,
+	.read = seq_read,
+	.llseek = seq_lseek
+};
+
+/**
+ * debugfs_create_devm_seqfile - create a debugfs file that is bound to device.
+ *
+ * @dev: device related to this debugfs file.
+ * @name: name of the debugfs file.
+ * @parent: a pointer to the parent dentry for this file.  This should be a
+ *	directory dentry if set.  If this parameter is %NULL, then the
+ *	file will be created in the root of the debugfs filesystem.
+ * @read_fn: function pointer called to print the seq_file content.
+ */
+struct dentry *debugfs_create_devm_seqfile(struct device *dev, const char *name,
+					   struct dentry *parent,
+					   int (*read_fn)(struct seq_file *s,
+					   	   	  void *data))
+{
+	struct debugfs_devm_entry *entry;
+
+	if (IS_ERR(parent))
+		return ERR_PTR(-ENOENT);
+
+	entry = devm_kzalloc(dev, sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return ERR_PTR(-ENOMEM);
+
+	entry->read = read_fn;
+	entry->dev = dev;
+
+	return debugfs_create_file(name, S_IRUGO, parent, entry,
+				   &debugfs_devm_entry_ops);
+}
+EXPORT_SYMBOL_GPL(debugfs_create_devm_seqfile);
+
diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index 4d0b4d1..f8c0db4 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -99,13 +99,18 @@ struct dentry *debugfs_create_u32_array(const char *name, umode_t mode,
 					struct dentry *parent,
 					u32 *array, u32 elements);
 
+struct dentry *debugfs_create_devm_seqfile(struct device *dev, const char *name,
+					   struct dentry *parent,
+					   int (*read_fn)(struct seq_file *s,
+					   	   	  void *data));
+
 bool debugfs_initialized(void);
 
 #else
 
 #include <linux/err.h>
 
-/* 
+/*
  * We do not return NULL from these functions if CONFIG_DEBUG_FS is not enabled
  * so users have a chance to detect if there was a real error or not.  We don't
  * want to duplicate the design decision mistakes of procfs and devfs again.
@@ -251,6 +256,15 @@ static inline struct dentry *debugfs_create_u32_array(const char *name, umode_t
 	return ERR_PTR(-ENODEV);
 }
 
+static inline struct dentry *debugfs_create_devm_seqfile(struct device *dev,
+							 const char *name,
+							 struct dentry *parent,
+					   int (*read_fn)(struct seq_file *s,
+					   	   	  void *data))
+{
+	return ERR_PTR(-ENODEV);
+}
+
 #endif
 
 #endif
-- 
1.9.1

