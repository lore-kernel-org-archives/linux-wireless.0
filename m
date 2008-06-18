Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:39529 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420AbYFRWjl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2008 18:39:41 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Add debugfs files for MMIO register access
Date: Thu, 19 Jun 2008 00:35:49 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200806190035.49644.mb@bu3sch.de> (sfid-20080619_003944_077820_420D853A)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds debugfs files for reading and writing arbitrary
wireless core registers. This is useful for debugging.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, please have a nice vacation and queue this for 2.6.27, if you are bored. :P


Index: wireless-testing/drivers/net/wireless/b43/debugfs.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/debugfs.c	2008-06-15 15:48:05.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/debugfs.c	2008-06-18 23:57:39.000000000 +0200
@@ -71,12 +71,121 @@ struct b43_dfs_file * fops_to_dfs_file(s
 					  fmt , ##x);		\
 		else						\
 			printk(KERN_ERR "b43: fappend overflow\n"); \
 	} while (0)
 
 
+/* The biggest MMIO address that we allow access to from the debugfs files. */
+#define B43_MAX_MMIO_ACCESS	(0xF00 - 1)
+
+static ssize_t mmio16read__read_file(struct b43_wldev *dev,
+				     char *buf, size_t bufsize)
+{
+	ssize_t count = 0;
+	unsigned int addr;
+	u16 val;
+
+	addr = dev->dfsentry->mmio16read_next;
+	if (addr > B43_MAX_MMIO_ACCESS)
+		return -EDESTADDRREQ;
+
+	val = b43_read16(dev, addr);
+	fappend("0x%04X\n", val);
+
+	return count;
+}
+
+static int mmio16read__write_file(struct b43_wldev *dev,
+				  const char *buf, size_t count)
+{
+	unsigned int addr;
+	int res;
+
+	res = sscanf(buf, "0x%X", &addr);
+	if (res != 1)
+		return -EINVAL;
+	if (addr > B43_MAX_MMIO_ACCESS)
+		return -EADDRNOTAVAIL;
+
+	dev->dfsentry->mmio16read_next = addr;
+
+	return 0;
+}
+
+static int mmio16write__write_file(struct b43_wldev *dev,
+				   const char *buf, size_t count)
+{
+	unsigned int addr, val;
+	int res;
+
+	res = sscanf(buf, "0x%X = 0x%X", &addr, &val);
+	if (res != 2)
+		return -EINVAL;
+	if (addr > B43_MAX_MMIO_ACCESS)
+		return -EADDRNOTAVAIL;
+	if (val > 0xFFFF)
+		return -E2BIG;
+
+	b43_write16(dev, addr, val);
+
+	return 0;
+}
+
+static ssize_t mmio32read__read_file(struct b43_wldev *dev,
+				     char *buf, size_t bufsize)
+{
+	ssize_t count = 0;
+	unsigned int addr;
+	u32 val;
+
+	addr = dev->dfsentry->mmio32read_next;
+	if (addr > B43_MAX_MMIO_ACCESS)
+		return -EDESTADDRREQ;
+
+	val = b43_read32(dev, addr);
+	fappend("0x%08X\n", val);
+
+	return count;
+}
+
+static int mmio32read__write_file(struct b43_wldev *dev,
+				  const char *buf, size_t count)
+{
+	unsigned int addr;
+	int res;
+
+	res = sscanf(buf, "0x%X", &addr);
+	if (res != 1)
+		return -EINVAL;
+	if (addr > B43_MAX_MMIO_ACCESS)
+		return -EADDRNOTAVAIL;
+
+	dev->dfsentry->mmio32read_next = addr;
+
+	return 0;
+}
+
+static int mmio32write__write_file(struct b43_wldev *dev,
+				   const char *buf, size_t count)
+{
+	unsigned int addr, val;
+	int res;
+
+	res = sscanf(buf, "0x%X = 0x%X", &addr, &val);
+	if (res != 2)
+		return -EINVAL;
+	if (addr > B43_MAX_MMIO_ACCESS)
+		return -EADDRNOTAVAIL;
+	if (val > 0xFFFFFFFF)
+		return -E2BIG;
+
+	b43_write32(dev, addr, val);
+
+	return 0;
+}
+
 /* wl->irq_lock is locked */
 static ssize_t tsf_read_file(struct b43_wldev *dev,
 			     char *buf, size_t bufsize)
 {
 	ssize_t count = 0;
 	u64 tsf;
@@ -493,12 +602,16 @@ out_unlock:
 		},						\
 		.file_struct_offset = offsetof(struct b43_dfsentry, \
 					       file_##name),	\
 		.take_irqlock	= _take_irqlock,		\
 	}
 
+B43_DEBUGFS_FOPS(mmio16read, mmio16read__read_file, mmio16read__write_file, 1);
+B43_DEBUGFS_FOPS(mmio16write, NULL, mmio16write__write_file, 1);
+B43_DEBUGFS_FOPS(mmio32read, mmio32read__read_file, mmio32read__write_file, 1);
+B43_DEBUGFS_FOPS(mmio32write, NULL, mmio32write__write_file, 1);
 B43_DEBUGFS_FOPS(tsf, tsf_read_file, tsf_write_file, 1);
 B43_DEBUGFS_FOPS(ucode_regs, ucode_regs_read_file, NULL, 1);
 B43_DEBUGFS_FOPS(shm, shm_read_file, NULL, 1);
 B43_DEBUGFS_FOPS(txstat, txstat_read_file, NULL, 0);
 B43_DEBUGFS_FOPS(txpower_g, txpower_g_read_file, txpower_g_write_file, 0);
 B43_DEBUGFS_FOPS(restart, NULL, restart_write_file, 1);
@@ -581,24 +694,31 @@ void b43_debugfs_add_device(struct b43_w
 		dev->dfsentry = NULL;
 		kfree(log->log);
 		kfree(e);
 		return;
 	}
 
+	e->mmio16read_next = 0xFFFF; /* invalid address */
+	e->mmio32read_next = 0xFFFF; /* invalid address */
+
 #define ADD_FILE(name, mode)	\
 	do {							\
 		struct dentry *d;				\
 		d = debugfs_create_file(__stringify(name),	\
 					mode, e->subdir, dev,	\
 					&fops_##name.fops);	\
 		e->file_##name.dentry = NULL;			\
 		if (!IS_ERR(d))					\
 			e->file_##name.dentry = d;		\
 	} while (0)
 
 
+	ADD_FILE(mmio16read, 0600);
+	ADD_FILE(mmio16write, 0200);
+	ADD_FILE(mmio32read, 0600);
+	ADD_FILE(mmio32write, 0200);
 	ADD_FILE(tsf, 0600);
 	ADD_FILE(ucode_regs, 0400);
 	ADD_FILE(shm, 0400);
 	ADD_FILE(txstat, 0400);
 	ADD_FILE(txpower_g, 0600);
 	ADD_FILE(restart, 0200);
@@ -617,12 +737,16 @@ void b43_debugfs_remove_device(struct b4
 		return;
 	e = dev->dfsentry;
 	if (!e)
 		return;
 	b43_remove_dynamic_debug(dev);
 
+	debugfs_remove(e->file_mmio16read.dentry);
+	debugfs_remove(e->file_mmio16write.dentry);
+	debugfs_remove(e->file_mmio32read.dentry);
+	debugfs_remove(e->file_mmio32write.dentry);
 	debugfs_remove(e->file_tsf.dentry);
 	debugfs_remove(e->file_ucode_regs.dentry);
 	debugfs_remove(e->file_shm.dentry);
 	debugfs_remove(e->file_txstat.dentry);
 	debugfs_remove(e->file_txpower_g.dentry);
 	debugfs_remove(e->file_restart.dentry);
Index: wireless-testing/drivers/net/wireless/b43/debugfs.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/debugfs.h	2008-06-15 15:48:05.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/debugfs.h	2008-06-18 23:20:41.000000000 +0200
@@ -33,22 +33,31 @@ struct b43_dfs_file {
 };
 
 struct b43_dfsentry {
 	struct b43_wldev *dev;
 	struct dentry *subdir;
 
+	struct b43_dfs_file file_mmio16read;
+	struct b43_dfs_file file_mmio16write;
+	struct b43_dfs_file file_mmio32read;
+	struct b43_dfs_file file_mmio32write;
 	struct b43_dfs_file file_tsf;
 	struct b43_dfs_file file_ucode_regs;
 	struct b43_dfs_file file_shm;
 	struct b43_dfs_file file_txstat;
 	struct b43_dfs_file file_txpower_g;
 	struct b43_dfs_file file_restart;
 	struct b43_dfs_file file_loctls;
 
 	struct b43_txstatus_log txstatlog;
 
+	/* The cached address for the next mmio16read file read */
+	u16 mmio16read_next;
+	/* The cached address for the next mmio32read file read */
+	u16 mmio32read_next;
+
 	/* Enabled/Disabled list for the dynamic debugging features. */
 	u32 dyn_debug[__B43_NR_DYNDBG];
 	/* Dentries for the dynamic debugging entries. */
 	struct dentry *dyn_debug_dentries[__B43_NR_DYNDBG];
 };
 
