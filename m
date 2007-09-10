Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-03.rdc-kc.rr.com ([24.94.166.129]:50091 "EHLO
	ms-smtp-03.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759227AbXIJPhH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2007 11:37:07 -0400
Date: Mon, 10 Sep 2007 10:35:03 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] b43legacy: Simplify debugfs
Message-ID: <46e56427.mxTGpcMPk134swg1%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Buesch <mb@bu3sch.de>

This is a major cleanup and simplification of the debugfs
infrastructure. All the debugfs related FS handling code (copy_*_user, etc...)
and the locking is handled in common functions. The debugging implementation
files only have to care about their actual job anymore.
This shrinks the function size.

A few macros were also added to simplify adding new files.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Larry Finger <larry.finger@lwfinger.net>
---

 drivers/net/wireless/b43legacy/debugfs.c |  652 ++++++++++++-------------------
 drivers/net/wireless/b43legacy/debugfs.h |   29 -
 2 files changed, 287 insertions(+), 394 deletions(-)


Index: wireless-dev/drivers/net/wireless/b43legacy/debugfs.h
===================================================================
--- wireless-dev.orig/drivers/net/wireless/b43legacy/debugfs.h
+++ wireless-dev/drivers/net/wireless/b43legacy/debugfs.h
@@ -23,22 +23,26 @@ struct dentry;
 struct b43legacy_txstatus_log {
 	struct b43legacy_txstatus *log;
 	int end;
-	int printing;
-	char printbuf[(B43legacy_NR_LOGGED_TXSTATUS * 70) + 200];
-	size_t buf_avail;
 	spinlock_t lock;	/* lock for debugging */
 };
 
+struct b43legacy_dfs_file {
+	struct dentry *dentry;
+	char *buffer;
+	size_t data_len;
+};
+
 struct b43legacy_dfsentry {
+	struct b43legacy_wldev *dev;
 	struct dentry *subdir;
-	struct dentry *dentry_tsf;
-	struct dentry *dentry_ucode_regs;
-	struct dentry *dentry_shm;
-	struct dentry *dentry_txstat;
-	struct dentry *dentry_restart;
-	struct dentry *dentry_power;
 
-	struct b43legacy_wldev *dev;
+	struct b43legacy_dfs_file file_tsf;
+	struct b43legacy_dfs_file file_ucode_regs;
+	struct b43legacy_dfs_file file_shm;
+	struct b43legacy_dfs_file file_txstat;
+	struct b43legacy_dfs_file file_txpower_g;
+	struct b43legacy_dfs_file file_restart;
+	struct b43legacy_dfs_file file_loctls;
 
 	struct b43legacy_txstatus_log txstatlog;
 
@@ -48,11 +52,6 @@ struct b43legacy_dfsentry {
 	struct dentry *dyn_debug_dentries[__B43legacy_NR_DYNDBG];
 };
 
-struct b43legacy_debugfs {
-	struct dentry *root;
-	struct dentry *dentry_driverinfo;
-};
-
 int b43legacy_debug(struct b43legacy_wldev *dev,
 		    enum b43legacy_dyndbg feature);
 
Index: wireless-dev/drivers/net/wireless/b43legacy/debugfs.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/b43legacy/debugfs.c
+++ wireless-dev/drivers/net/wireless/b43legacy/debugfs.c
@@ -4,7 +4,7 @@
 
   debugfs driver debugging code
 
-  Copyright (c) 2005 Michael Buesch <mb@bu3sch.de>
+  Copyright (c) 2005-2007 Michael Buesch <mb@bu3sch.de>
 
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
@@ -23,8 +23,6 @@
 
 */
 
-
-
 #include <linux/fs.h>
 #include <linux/debugfs.h>
 #include <linux/slab.h>
@@ -39,410 +37,317 @@
 #include "pio.h"
 #include "xmit.h"
 
-#define REALLY_BIG_BUFFER_SIZE	(1024 * 256)
 
-static struct b43legacy_debugfs fs;
-static char big_buffer[REALLY_BIG_BUFFER_SIZE];
-static DEFINE_MUTEX(big_buffer_mutex);
+/* The root directory. */
+struct dentry *rootdir;
 
+struct b43legacy_debugfs_fops {
+	ssize_t (*read)(struct b43legacy_wldev *dev, char *buf, size_t bufsize);
+	int (*write)(struct b43legacy_wldev *dev, const char *buf, size_t count);
+	struct file_operations fops;
+	/* Offset of struct b43legacy_dfs_file in struct b43legacy_dfsentry */
+	size_t file_struct_offset;
+	/* Take wl->irq_lock before calling read/write? */
+	bool take_irqlock;
+};
 
-static ssize_t write_file_dummy(struct file *file, const char __user *buf,
-				size_t count, loff_t *ppos)
+static inline
+struct b43legacy_dfs_file * fops_to_dfs_file(struct b43legacy_wldev *dev,
+				       const struct b43legacy_debugfs_fops *dfops)
 {
-	return count;
-}
+	void *p;
 
-static int open_file_generic(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
+	p = dev->dfsentry;
+	p += dfops->file_struct_offset;
+
+	return p;
 }
 
-#define fappend(fmt, x...)	pos += snprintf(buf + pos, len - pos, fmt , ##x)
 
-static ssize_t drvinfo_read_file(struct file *file, char __user *userbuf,
-				 size_t count, loff_t *ppos)
+#define fappend(fmt, x...)	\
+	do {							\
+		if (bufsize - count)				\
+			count += snprintf(buf + count,		\
+					  bufsize - count,	\
+					  fmt , ##x);		\
+		else						\
+			printk(KERN_ERR "b43legacy: fappend overflow\n"); \
+	} while (0)
+
+
+/* wl->irq_lock is locked */
+ssize_t tsf_read_file(struct b43legacy_wldev *dev, char *buf, size_t bufsize)
 {
-	const size_t len = ARRAY_SIZE(big_buffer);
-	char *buf = big_buffer;
-	size_t pos = 0;
-	ssize_t res;
-
-	mutex_lock(&big_buffer_mutex);
-	/* This is where the information is written to the "driver" file */
-	fappend(KBUILD_MODNAME " driver\n");
-	fappend("Compiled at: %s %s\n", __DATE__, __TIME__);
-	res = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
-	mutex_unlock(&big_buffer_mutex);
-
-	return res;
-}
-
-static ssize_t tsf_read_file(struct file *file, char __user *userbuf,
-			     size_t count, loff_t *ppos)
-{
-	struct b43legacy_wldev *dev = file->private_data;
-	const size_t len = ARRAY_SIZE(big_buffer);
-	char *buf = big_buffer;
-	size_t pos = 0;
-	ssize_t res;
-	unsigned long flags;
+	ssize_t count = 0;
 	u64 tsf;
 
-	mutex_lock(&big_buffer_mutex);
-	mutex_lock(&dev->wl->mutex);
-	spin_lock_irqsave(&dev->wl->irq_lock, flags);
-	if (b43legacy_status(dev) < B43legacy_STAT_STARTED) {
-		fappend("Board not initialized.\n");
-		goto out;
-	}
 	b43legacy_tsf_read(dev, &tsf);
 	fappend("0x%08x%08x\n",
 		(unsigned int)((tsf & 0xFFFFFFFF00000000ULL) >> 32),
 		(unsigned int)(tsf & 0xFFFFFFFFULL));
 
-out:
-	spin_unlock_irqrestore(&dev->wl->irq_lock, flags);
-	mutex_unlock(&dev->wl->mutex);
-	res = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
-	mutex_unlock(&big_buffer_mutex);
-
-	return res;
+	return count;
 }
 
-static ssize_t tsf_write_file(struct file *file, const char __user *user_buf,
-			      size_t count, loff_t *ppos)
+/* wl->irq_lock is locked */
+int tsf_write_file(struct b43legacy_wldev *dev, const char *buf, size_t count)
 {
-	struct b43legacy_wldev *dev = file->private_data;
-	char *buf = big_buffer;
-	ssize_t buf_size;
-	ssize_t res;
-	unsigned long flags;
 	u64 tsf;
 
-	mutex_lock(&big_buffer_mutex);
-	buf_size = min(count, ARRAY_SIZE(big_buffer) - 1);
-	if (copy_from_user(buf, user_buf, buf_size)) {
-		res = -EFAULT;
-		goto out_unlock_bb;
-	}
-	mutex_lock(&dev->wl->mutex);
-	spin_lock_irqsave(&dev->wl->irq_lock, flags);
-	if (b43legacy_status(dev) < B43legacy_STAT_STARTED) {
-		b43legacyerr(dev->wl, "debugfs: Board not initialized.\n");
-		res = -EFAULT;
-		goto out_unlock;
-	}
-	if (sscanf(buf, "%llu", (unsigned long long *)(&tsf)) != 1) {
-		b43legacyerr(dev->wl, "debugfs: Invalid values for TSF\n");
-		res = -EINVAL;
-		goto out_unlock;
-	}
+	if (sscanf(buf, "%llu", (unsigned long long *)(&tsf)) != 1)
+		return -EINVAL;
 	b43legacy_tsf_write(dev, tsf);
-	mmiowb();
-	res = buf_size;
-
-out_unlock:
-	spin_unlock_irqrestore(&dev->wl->irq_lock, flags);
-	mutex_unlock(&dev->wl->mutex);
-out_unlock_bb:
-	mutex_unlock(&big_buffer_mutex);
 
-	return res;
+	return 0;
 }
 
-static ssize_t shm_read_file(struct file *file, char __user * userbuf,
-			     size_t count, loff_t * ppos)
+/* wl->irq_lock is locked */
+ssize_t ucode_regs_read_file(struct b43legacy_wldev *dev, char *buf, size_t bufsize)
 {
-	struct b43legacy_wldev *dev = file->private_data;
-	const size_t len = ARRAY_SIZE(big_buffer);
-	u8 *buf = big_buffer;
-	__le16 *le16buf = (__le16*)big_buffer;
-	size_t pos = 0;
-	ssize_t res;
-	unsigned long flags;
+	ssize_t count = 0;
 	int i;
-	u16 tmp;
 
-	mutex_lock(&big_buffer_mutex);
-	mutex_lock(&dev->wl->mutex);
-	spin_lock_irqsave(&dev->wl->irq_lock, flags);
-	if (b43legacy_status(dev) < B43legacy_STAT_INITIALIZED) {
-		fappend("Board not initialized.\n");
-		goto out;
+	for (i = 0; i < 64; i++) {
+		fappend("r%d = 0x%04x\n", i,
+			b43legacy_shm_read16(dev, B43legacy_SHM_WIRELESS, i));
 	}
 
+	return count;
+}
+
+/* wl->irq_lock is locked */
+ssize_t shm_read_file(struct b43legacy_wldev *dev, char *buf, size_t bufsize)
+{
+	ssize_t count = 0;
+	int i;
+	u16 tmp;
+	__le16 *le16buf = (__le16 *)buf;
+
 	for (i = 0; i < 0x1000; i++) {
+		if (bufsize <= 0)
+			break;
 		tmp = b43legacy_shm_read16(dev, B43legacy_SHM_SHARED, 2 * i);
 		le16buf[i] = cpu_to_le16(tmp);
-		pos += sizeof(tmp);
+		count += sizeof(tmp);
+		bufsize -= sizeof(tmp);
 	}
 
-out:
-	spin_unlock_irqrestore(&dev->wl->irq_lock, flags);
-	mutex_unlock(&dev->wl->mutex);
-	res = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
-	mutex_unlock(&big_buffer_mutex);
-
-	return res;
+	return count;
 }
 
-static ssize_t ucode_regs_read_file(struct file *file, char __user * userbuf,
-				    size_t count, loff_t * ppos)
+ssize_t txstat_read_file(struct b43legacy_wldev *dev, char *buf, size_t bufsize)
 {
-	struct b43legacy_wldev *dev = file->private_data;
-	const size_t len = ARRAY_SIZE(big_buffer);
-	char *buf = big_buffer;
-	size_t pos = 0;
-	ssize_t res;
+	struct b43legacy_txstatus_log *log = &dev->dfsentry->txstatlog;
+	ssize_t count = 0;
 	unsigned long flags;
-	int i;
+	int i, idx;
+	struct b43legacy_txstatus *stat;
 
-	mutex_lock(&big_buffer_mutex);
-	mutex_lock(&dev->wl->mutex);
-	spin_lock_irqsave(&dev->wl->irq_lock, flags);
-	if (b43legacy_status(dev) < B43legacy_STAT_INITIALIZED) {
-		fappend("Board not initialized.\n");
-		goto out;
+	spin_lock_irqsave(&log->lock, flags);
+	if (log->end < 0) {
+		fappend("Nothing transmitted, yet\n");
+		goto out_unlock;
 	}
-
-	for (i = 0; i < 64; i++) {
-		fappend("r%d = 0x%04x\n", i,
-			b43legacy_shm_read16(dev, B43legacy_SHM_WIRELESS, i));
+	fappend("b43legacy TX status reports:\n\n"
+		"index | cookie | seq | phy_stat | frame_count | "
+		"rts_count | supp_reason | pm_indicated | "
+		"intermediate | for_ampdu | acked\n" "---\n");
+	i = log->end + 1;
+	idx = 0;
+	while (1) {
+		if (i == B43legacy_NR_LOGGED_TXSTATUS)
+			i = 0;
+		stat = &(log->log[i]);
+		if (stat->cookie) {
+			fappend("%03d | "
+				"0x%04X | 0x%04X | 0x%02X | "
+				"0x%X | 0x%X | "
+				"%u | %u | "
+				"%u | %u | %u\n",
+				idx,
+				stat->cookie, stat->seq, stat->phy_stat,
+				stat->frame_count, stat->rts_count,
+				stat->supp_reason, stat->pm_indicated,
+				stat->intermediate, stat->for_ampdu,
+				stat->acked);
+			idx++;
+		}
+		if (i == log->end)
+			break;
+		i++;
 	}
+out_unlock:
+	spin_unlock_irqrestore(&log->lock, flags);
 
-out:
-	spin_unlock_irqrestore(&dev->wl->irq_lock, flags);
-	mutex_unlock(&dev->wl->mutex);
-	res = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
-	mutex_unlock(&big_buffer_mutex);
-
-	return res;
+	return count;
 }
 
-static ssize_t power_read_file(struct file *file, char __user *userbuf,
-			     size_t count, loff_t *ppos)
+/* wl->irq_lock is locked */
+int restart_write_file(struct b43legacy_wldev *dev, const char *buf, size_t count)
 {
-	struct b43legacy_wldev *dev = file->private_data;
-	const size_t len = ARRAY_SIZE(big_buffer);
-	char *buf = big_buffer;
-	size_t pos = 0;
-	ssize_t res;
-	unsigned long flags;
+	int err = 0;
 
-	mutex_lock(&big_buffer_mutex);
-	mutex_lock(&dev->wl->mutex);
-	spin_lock_irqsave(&dev->wl->irq_lock, flags);
-	if (b43legacy_status(dev) < B43legacy_STAT_STARTED) {
-		fappend("Board not initialized.\n");
-		goto out;
-	}
-	fappend("%d dBm\n", dev->phy.power_level);
+	if (count > 0 && buf[0] == '1') {
+		b43legacy_controller_restart(dev, "manually restarted");
+	} else
+		err = -EINVAL;
 
-out:
-	spin_unlock_irqrestore(&dev->wl->irq_lock, flags);
-	mutex_unlock(&dev->wl->mutex);
-	res = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
-	mutex_unlock(&big_buffer_mutex);
+	return err;
+}
+
+#undef fappend
 
-	return res;
+static int b43legacy_debugfs_open(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+	return 0;
 }
 
-static ssize_t power_write_file(struct file *file, const char __user *user_buf,
-			      size_t count, loff_t *ppos)
+static ssize_t b43legacy_debugfs_read(struct file *file, char __user *userbuf,
+				size_t count, loff_t *ppos)
 {
-	struct b43legacy_wldev *dev = file->private_data;
-	char *buf = big_buffer;
-	ssize_t buf_size;
-	ssize_t res;
-	unsigned long flags;
-	int power;
+	struct b43legacy_wldev *dev;
+	struct b43legacy_debugfs_fops *dfops;
+	struct b43legacy_dfs_file *dfile;
+	ssize_t ret = 0;
+	char *buf;
+	const size_t bufsize = 1024 * 128;
+	const size_t buforder = get_order(bufsize);
+	int err = 0;
+
+	if (!count)
+		return 0;
+	dev = file->private_data;
+	if (!dev)
+		return -ENODEV;
 
-	mutex_lock(&big_buffer_mutex);
-	buf_size = min(count, ARRAY_SIZE(big_buffer) - 1);
-	if (copy_from_user(buf, user_buf, buf_size)) {
-		res = -EFAULT;
-		goto out_unlock_bb;
-	}
 	mutex_lock(&dev->wl->mutex);
-	spin_lock_irqsave(&dev->wl->irq_lock, flags);
-	if (b43legacy_status(dev) < B43legacy_STAT_STARTED) {
-		b43legacyerr(dev->wl, "debugfs: Board not initialized.\n");
-		res = -EFAULT;
+	if (b43legacy_status(dev) < B43legacy_STAT_INITIALIZED) {
+		err = -ENODEV;
 		goto out_unlock;
 	}
-	if ((sscanf(buf, "%d", &power) != 1) || (power > 18 || power < 5)) {
-		b43legacyerr(dev->wl, "debugfs: Invalid values for power"
-			     " level\n");
-		res = -EINVAL;
+
+	dfops = container_of(file->f_op, struct b43legacy_debugfs_fops, fops);
+	if (!dfops->read) {
+		err = -ENOSYS;
 		goto out_unlock;
 	}
-	dev->phy.power_level = power;
-	res = buf_size;
+	dfile = fops_to_dfs_file(dev, dfops);
 
+	if (!dfile->buffer) {
+		buf = (char *)__get_free_pages(GFP_KERNEL, buforder);
+		if (!buf) {
+			err = -ENOMEM;
+			goto out_unlock;
+		}
+		memset(buf, 0, bufsize);
+		if (dfops->take_irqlock) {
+			spin_lock_irq(&dev->wl->irq_lock);
+			ret = dfops->read(dev, buf, bufsize);
+			spin_unlock_irq(&dev->wl->irq_lock);
+		} else
+			ret = dfops->read(dev, buf, bufsize);
+		if (ret <= 0) {
+			free_pages((unsigned long)buf, buforder);
+			err = ret;
+			goto out_unlock;
+		}
+		dfile->data_len = ret;
+		dfile->buffer = buf;
+	}
+
+	ret = simple_read_from_buffer(userbuf, count, ppos,
+				      dfile->buffer,
+				      dfile->data_len);
+	if (*ppos >= dfile->data_len) {
+		free_pages((unsigned long)dfile->buffer, buforder);
+		dfile->buffer = NULL;
+		dfile->data_len = 0;
+	}
 out_unlock:
-	spin_unlock_irqrestore(&dev->wl->irq_lock, flags);
 	mutex_unlock(&dev->wl->mutex);
-out_unlock_bb:
-	mutex_unlock(&big_buffer_mutex);
 
-	return res;
+	return err ? err : ret;
 }
 
-static ssize_t txstat_read_file(struct file *file, char __user *userbuf,
-				size_t count, loff_t *ppos)
+static ssize_t b43legacy_debugfs_write(struct file *file,
+				 const char __user *userbuf,
+				 size_t count, loff_t *ppos)
 {
-	struct b43legacy_wldev *dev = file->private_data;
-	struct b43legacy_dfsentry *e = dev->dfsentry;
-	struct b43legacy_txstatus_log *log = &e->txstatlog;
-	unsigned long flags;
-	char *buf = log->printbuf;
-	const size_t len = ARRAY_SIZE(log->printbuf);
-	size_t pos = 0;
-	ssize_t res;
-	int i;
-	int idx;
-	struct b43legacy_txstatus *stat;
+	struct b43legacy_wldev *dev;
+	struct b43legacy_debugfs_fops *dfops;
+	char *buf;
+	int err = 0;
+
+	if (!count)
+		return 0;
+	if (count > PAGE_SIZE)
+		return -E2BIG;
+	dev = file->private_data;
+	if (!dev)
+		return -ENODEV;
 
-	mutex_lock(&big_buffer_mutex);
-	spin_lock_irqsave(&log->lock, flags);
-	if (!log->printing) {
-		log->printing = 1;
-		fappend("b43legacy TX status reports:\n\n"
-			"index | cookie | seq | phy_stat | frame_count | "
-			"rts_count | supp_reason | pm_indicated | "
-			"intermediate | for_ampdu | acked\n"
-			"---\n");
-		i = log->end + 1;
-		idx = 0;
-		while (1) {
-			if (log->end < 0) {
-				fappend("Nothing transmitted, yet\n");
-				break;
-			}
-			if (i == B43legacy_NR_LOGGED_TXSTATUS)
-				i = 0;
-			stat = &(log->log[i]);
-			if (stat->cookie) {
-				fappend("%03d | "
-					"0x%04X | 0x%04X | 0x%02X | "
-					"0x%X | 0x%X | "
-					"%u | %u | "
-					"%u | %u | %u\n",
-					idx,
-					stat->cookie, stat->seq, stat->phy_stat,
-					stat->frame_count, stat->rts_count,
-					stat->supp_reason, stat->pm_indicated,
-					stat->intermediate, stat->for_ampdu,
-					stat->acked);
-				idx++;
-			}
-			if (i == log->end)
-				break;
-			i++;
-		}
-		log->buf_avail = pos;
+	mutex_lock(&dev->wl->mutex);
+	if (b43legacy_status(dev) < B43legacy_STAT_INITIALIZED) {
+		err = -ENODEV;
+		goto out_unlock;
 	}
-	memcpy(big_buffer, buf,
-	       min(log->buf_avail, ARRAY_SIZE(big_buffer)));
-	spin_unlock_irqrestore(&log->lock, flags);
-
-	res = simple_read_from_buffer(userbuf, count, ppos,
-				      big_buffer,
-				      log->buf_avail);
-	if (*ppos == log->buf_avail) {
-		spin_lock_irqsave(&log->lock, flags);
-		log->printing = 0;
-		spin_unlock_irqrestore(&log->lock, flags);
-	}
-	mutex_unlock(&big_buffer_mutex);
-
-	return res;
-}
-
-static ssize_t restart_write_file(struct file *file,
-				  const char __user *user_buf,
-				  size_t count, loff_t *ppos)
-{
-	struct b43legacy_wldev *dev = file->private_data;
-	char *buf = big_buffer;
-	ssize_t buf_size;
-	ssize_t res;
-	unsigned long flags;
 
-	mutex_lock(&big_buffer_mutex);
-	buf_size = min(count, ARRAY_SIZE(big_buffer) - 1);
-	if (copy_from_user(buf, user_buf, buf_size)) {
-		res = -EFAULT;
-		goto out_unlock_bb;
+	dfops = container_of(file->f_op, struct b43legacy_debugfs_fops, fops);
+	if (!dfops->write) {
+		err = -ENOSYS;
+		goto out_unlock;
 	}
-	mutex_lock(&dev->wl->mutex);
-	spin_lock_irqsave(&dev->wl->irq_lock, flags);
-	if (b43legacy_status(dev) < B43legacy_STAT_INITIALIZED) {
-		b43legacyerr(dev->wl, "debugfs: Board not initialized.\n");
-		res = -EFAULT;
+
+	buf = (char *)get_zeroed_page(GFP_KERNEL);
+	if (!buf) {
+		err = -ENOMEM;
 		goto out_unlock;
 	}
-	if (count > 0 && buf[0] == '1') {
-		b43legacy_controller_restart(dev, "manually restarted");
-		res = count;
+	if (copy_from_user(buf, userbuf, count)) {
+		err = -EFAULT;
+		goto out_freepage;
+	}
+	if (dfops->take_irqlock) {
+		spin_lock_irq(&dev->wl->irq_lock);
+		err = dfops->write(dev, buf, count);
+		spin_unlock_irq(&dev->wl->irq_lock);
 	} else
-		res = -EINVAL;
+		err = dfops->write(dev, buf, count);
+	if (err)
+		goto out_freepage;
 
+out_freepage:
+	free_page((unsigned long)buf);
 out_unlock:
-	spin_unlock_irqrestore(&dev->wl->irq_lock, flags);
 	mutex_unlock(&dev->wl->mutex);
-out_unlock_bb:
-	mutex_unlock(&big_buffer_mutex);
 
-	return res;
+	return err ? err : count;
 }
 
-#undef fappend
-
-
-static struct file_operations drvinfo_fops = {
-	.read = drvinfo_read_file,
-	.write = write_file_dummy,
-	.open = open_file_generic,
-};
-
-static struct file_operations tsf_fops = {
-	.read = tsf_read_file,
-	.write = tsf_write_file,
-	.open = open_file_generic,
-};
-
-static struct file_operations ucode_regs_fops = {
-	.read = ucode_regs_read_file,
-	.open = open_file_generic,
-};
-
-static struct file_operations shm_fops = {
-	.read = shm_read_file,
-	.open = open_file_generic,
-};
-
-static struct file_operations txstat_fops = {
-	.read = txstat_read_file,
-	.write = write_file_dummy,
-	.open = open_file_generic,
-};
 
-static struct file_operations restart_fops = {
-	.write = restart_write_file,
-	.open = open_file_generic,
-};
+#define B43legacy_DEBUGFS_FOPS(name, _read, _write, _take_irqlock)	\
+	static struct b43legacy_debugfs_fops fops_##name = {		\
+		.read	= _read,				\
+		.write	= _write,				\
+		.fops	= {					\
+			.open	= b43legacy_debugfs_open,		\
+			.read	= b43legacy_debugfs_read,		\
+			.write	= b43legacy_debugfs_write,		\
+		},						\
+		.file_struct_offset = offsetof(struct b43legacy_dfsentry, \
+					       file_##name),	\
+		.take_irqlock	= _take_irqlock,		\
+	}
 
-static struct file_operations power_fops = {
-	.read = power_read_file,
-	.write = power_write_file,
-	.open = open_file_generic,
-};
+B43legacy_DEBUGFS_FOPS(tsf, tsf_read_file, tsf_write_file, 1);
+B43legacy_DEBUGFS_FOPS(ucode_regs, ucode_regs_read_file, NULL, 1);
+B43legacy_DEBUGFS_FOPS(shm, shm_read_file, NULL, 1);
+B43legacy_DEBUGFS_FOPS(txstat, txstat_read_file, NULL, 0);
+B43legacy_DEBUGFS_FOPS(restart, NULL, restart_write_file, 1);
 
 
-int b43legacy_debug(struct b43legacy_wldev *dev,
-		    enum b43legacy_dyndbg feature)
+int b43legacy_debug(struct b43legacy_wldev *dev, enum b43legacy_dyndbg feature)
 {
 	return !!(dev->dfsentry && dev->dfsentry->dyn_debug[feature]);
 }
@@ -484,20 +389,18 @@ void b43legacy_debugfs_add_device(struct
 	struct b43legacy_txstatus_log *log;
 	char devdir[16];
 
-	B43legacy_BUG_ON(!dev);
+	B43legacy_WARN_ON(!dev);
 	e = kzalloc(sizeof(*e), GFP_KERNEL);
 	if (!e) {
-		b43legacyerr(dev->wl, "debugfs: OOM while adding device\n");
+		b43legacyerr(dev->wl, "debugfs: add device OOM\n");
 		return;
 	}
 	e->dev = dev;
 	log = &e->txstatlog;
 	log->log = kcalloc(B43legacy_NR_LOGGED_TXSTATUS,
-			   sizeof(struct b43legacy_txstatus),
-			   GFP_KERNEL);
+			   sizeof(struct b43legacy_txstatus), GFP_KERNEL);
 	if (!log->log) {
-		b43legacyerr(dev->wl, "debugfs: OOM while adding device"
-			     " txstatus\n");
+		b43legacyerr(dev->wl, "debugfs: add device txstatus OOM\n");
 		kfree(e);
 		return;
 	}
@@ -507,41 +410,40 @@ void b43legacy_debugfs_add_device(struct
 	dev->dfsentry = e;
 
 	snprintf(devdir, sizeof(devdir), "%s", wiphy_name(dev->wl->hw->wiphy));
-	e->subdir = debugfs_create_dir(devdir, fs.root);
+	e->subdir = debugfs_create_dir(devdir, rootdir);
 	if (!e->subdir || IS_ERR(e->subdir)) {
-		b43legacyerr(dev->wl, "debugfs: cannot create %s directory\n",
-		       devdir);
+		if (e->subdir == ERR_PTR(-ENODEV)) {
+			b43legacydbg(dev->wl, "DebugFS (CONFIG_DEBUG_FS) not "
+			       "enabled in kernel config\n");
+		} else {
+			b43legacyerr(dev->wl, "debugfs: cannot create %s directory\n",
+			       devdir);
+		}
 		dev->dfsentry = NULL;
 		kfree(log->log);
 		kfree(e);
 		return;
 	}
 
-	e->dentry_tsf = debugfs_create_file("tsf", 0600, e->subdir,
-					     dev, &tsf_fops);
-	if (IS_ERR(e->dentry_tsf))
-		e->dentry_tsf = NULL;
-	e->dentry_ucode_regs = debugfs_create_file("ucode_regs", 0400, e->subdir,
-						   dev, &ucode_regs_fops);
-	if (IS_ERR(e->dentry_ucode_regs))
-		e->dentry_ucode_regs = NULL;
-	e->dentry_shm = debugfs_create_file("shm", 0400, e->subdir,
-					    dev, &shm_fops);
-	if (IS_ERR(e->dentry_shm))
-		e->dentry_shm = NULL;
-	e->dentry_txstat = debugfs_create_file("tx_status", 0400, e->subdir,
-						dev, &txstat_fops);
-	if (IS_ERR(e->dentry_txstat))
-		e->dentry_txstat = NULL;
-	e->dentry_restart = debugfs_create_file("restart", 0200, e->subdir,
-						dev, &restart_fops);
-	if (IS_ERR(e->dentry_restart))
-		e->dentry_restart = NULL;
-
-	e->dentry_power = debugfs_create_file("power_level", 0600, e->subdir,
-					     dev, &power_fops);
-	if (IS_ERR(e->dentry_power))
-		e->dentry_power = NULL;
+#define ADD_FILE(name, mode)	\
+	do {							\
+		struct dentry *d;				\
+		d = debugfs_create_file(__stringify(name),	\
+					mode, e->subdir, dev,	\
+					&fops_##name.fops);	\
+		e->file_##name.dentry = NULL;			\
+		if (!IS_ERR(d))					\
+			e->file_##name.dentry = d;		\
+	} while (0)
+
+
+	ADD_FILE(tsf, 0600);
+	ADD_FILE(ucode_regs, 0400);
+	ADD_FILE(shm, 0400);
+	ADD_FILE(txstat, 0400);
+	ADD_FILE(restart, 0200);
+
+#undef ADD_FILE
 
 	b43legacy_add_dynamic_debug(dev);
 }
@@ -552,24 +454,24 @@ void b43legacy_debugfs_remove_device(str
 
 	if (!dev)
 		return;
-
 	e = dev->dfsentry;
 	if (!e)
 		return;
 	b43legacy_remove_dynamic_debug(dev);
-	debugfs_remove(e->dentry_tsf);
-	debugfs_remove(e->dentry_ucode_regs);
-	debugfs_remove(e->dentry_shm);
-	debugfs_remove(e->dentry_txstat);
-	debugfs_remove(e->dentry_restart);
-	debugfs_remove(e->dentry_power);
+
+	debugfs_remove(e->file_tsf.dentry);
+	debugfs_remove(e->file_ucode_regs.dentry);
+	debugfs_remove(e->file_shm.dentry);
+	debugfs_remove(e->file_txstat.dentry);
+	debugfs_remove(e->file_restart.dentry);
+
 	debugfs_remove(e->subdir);
 	kfree(e->txstatlog.log);
 	kfree(e);
 }
 
 void b43legacy_debugfs_log_txstat(struct b43legacy_wldev *dev,
-				  const struct b43legacy_txstatus *status)
+			    const struct b43legacy_txstatus *status)
 {
 	struct b43legacy_dfsentry *e = dev->dfsentry;
 	struct b43legacy_txstatus_log *log;
@@ -592,20 +494,12 @@ void b43legacy_debugfs_log_txstat(struct
 
 void b43legacy_debugfs_init(void)
 {
-	memset(&fs, 0, sizeof(fs));
-	fs.root = debugfs_create_dir(KBUILD_MODNAME, NULL);
-	if (!fs.root || IS_ERR(fs.root)) {
-		fs.root = NULL;
-		return;
-	}
-	fs.dentry_driverinfo = debugfs_create_file("driver", 0444, fs.root,
-						   NULL, &drvinfo_fops);
-	if (IS_ERR(fs.dentry_driverinfo))
-		fs.dentry_driverinfo = NULL;
+	rootdir = debugfs_create_dir(KBUILD_MODNAME, NULL);
+	if (IS_ERR(rootdir))
+		rootdir = NULL;
 }
 
 void b43legacy_debugfs_exit(void)
 {
-	debugfs_remove(fs.dentry_driverinfo);
-	debugfs_remove(fs.root);
+	debugfs_remove(rootdir);
 }
