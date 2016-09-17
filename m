Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34789 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751959AbcIQTnJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Sep 2016 15:43:09 -0400
From: Christian Lamparter <chunkeey@googlemail.com>
To: gregkh@linuxfoundation.org, Kalle Valo <kvalo@codeaurora.org>
Cc: Christian Lamparter <chunkeey@gmail.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org, Nicolai Stange <nicstange@gmail.com>,
        Ben Greear <greearb@candelatech.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 1/4] debugfs: introduce a public file_operations accessor
Date: Sat, 17 Sep 2016 21:43:01 +0200
Message-Id: <48411543620969bebb37a1a9ea7b8f451cdfdd31.1474140477.git.chunkeey@gmail.com> (sfid-20160917_214315_952994_A43B1158)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch introduces an accessor which can be used
by the users of debugfs (drivers, fs, ...) to get the
original file_operations struct. It also removes the
REAL_FOPS_DEREF macro in file.c and converts the code
to use the public version.

Previously, REAL_FOPS_DEREF was only available within
the file.c of debugfs. But having a public getter
available for debugfs users is important as some
drivers (carl9170 and b43) use the pointer of the
original file_operations in conjunction with container_of()
within their debugfs implementations.

Reviewed-by: Nicolai Stange <nicstange@gmail.com>
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
---
 fs/debugfs/file.c       | 13 +++++--------
 include/linux/debugfs.h | 17 +++++++++++++++++
 2 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index 592059f..309f4e9 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -97,9 +97,6 @@ EXPORT_SYMBOL_GPL(debugfs_use_file_finish);
 
 #define F_DENTRY(filp) ((filp)->f_path.dentry)
 
-#define REAL_FOPS_DEREF(dentry)					\
-	((const struct file_operations *)(dentry)->d_fsdata)
-
 static int open_proxy_open(struct inode *inode, struct file *filp)
 {
 	const struct dentry *dentry = F_DENTRY(filp);
@@ -112,7 +109,7 @@ static int open_proxy_open(struct inode *inode, struct file *filp)
 		goto out;
 	}
 
-	real_fops = REAL_FOPS_DEREF(dentry);
+	real_fops = debugfs_real_fops(filp);
 	real_fops = fops_get(real_fops);
 	if (!real_fops) {
 		/* Huh? Module did not clean up after itself at exit? */
@@ -143,7 +140,7 @@ static ret_type full_proxy_ ## name(proto)				\
 {									\
 	const struct dentry *dentry = F_DENTRY(filp);			\
 	const struct file_operations *real_fops =			\
-		REAL_FOPS_DEREF(dentry);				\
+		debugfs_real_fops(filp);				\
 	int srcu_idx;							\
 	ret_type r;							\
 									\
@@ -176,7 +173,7 @@ static unsigned int full_proxy_poll(struct file *filp,
 				struct poll_table_struct *wait)
 {
 	const struct dentry *dentry = F_DENTRY(filp);
-	const struct file_operations *real_fops = REAL_FOPS_DEREF(dentry);
+	const struct file_operations *real_fops = debugfs_real_fops(filp);
 	int srcu_idx;
 	unsigned int r = 0;
 
@@ -193,7 +190,7 @@ static unsigned int full_proxy_poll(struct file *filp,
 static int full_proxy_release(struct inode *inode, struct file *filp)
 {
 	const struct dentry *dentry = F_DENTRY(filp);
-	const struct file_operations *real_fops = REAL_FOPS_DEREF(dentry);
+	const struct file_operations *real_fops = debugfs_real_fops(filp);
 	const struct file_operations *proxy_fops = filp->f_op;
 	int r = 0;
 
@@ -241,7 +238,7 @@ static int full_proxy_open(struct inode *inode, struct file *filp)
 		goto out;
 	}
 
-	real_fops = REAL_FOPS_DEREF(dentry);
+	real_fops = debugfs_real_fops(filp);
 	real_fops = fops_get(real_fops);
 	if (!real_fops) {
 		/* Huh? Module did not cleanup after itself at exit? */
diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index 1438e23..4d3f0d1 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -45,6 +45,23 @@ extern struct dentry *arch_debugfs_dir;
 
 extern struct srcu_struct debugfs_srcu;
 
+/**
+ * debugfs_real_fops - getter for the real file operation
+ * @filp: a pointer to a struct file
+ *
+ * Must only be called under the protection established by
+ * debugfs_use_file_start().
+ */
+static inline const struct file_operations *debugfs_real_fops(struct file *filp)
+	__must_hold(&debugfs_srcu)
+{
+	/*
+	 * Neither the pointer to the struct file_operations, nor its
+	 * contents ever change -- srcu_dereference() is not needed here.
+	 */
+	return filp->f_path.dentry->d_fsdata;
+}
+
 #if defined(CONFIG_DEBUG_FS)
 
 struct dentry *debugfs_create_file(const char *name, umode_t mode,
-- 
2.9.3
