Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-02.rdc-kc.rr.com ([24.94.166.122]:50243 "EHLO
	ms-smtp-02.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759227AbXIJPgt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2007 11:36:49 -0400
Date: Mon, 10 Sep 2007 10:33:21 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] b43legacy: Add debugfs file to dump shared memory
Message-ID: <46e563c1./VcIP+GCZUv+o4RX%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Buesch <mb@bu3sch.de>

This adds a file to dump the SHM.
Note that SHM dumping is racy, as the microcode continues to run
while we dump the SHM.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Larry Finger <larry.finger@lwfinger.net>
---

Index: wireless-dev/drivers/net/wireless/b43legacy/debugfs.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/b43legacy/debugfs.c
+++ wireless-dev/drivers/net/wireless/b43legacy/debugfs.c
@@ -151,6 +151,42 @@ out_unlock_bb:
 	return res;
 }
 
+static ssize_t shm_read_file(struct file *file, char __user * userbuf,
+			     size_t count, loff_t * ppos)
+{
+	struct b43legacy_wldev *dev = file->private_data;
+	const size_t len = ARRAY_SIZE(big_buffer);
+	u8 *buf = big_buffer;
+	__le16 *le16buf = (__le16*)big_buffer;
+	size_t pos = 0;
+	ssize_t res;
+	unsigned long flags;
+	int i;
+	u16 tmp;
+
+	mutex_lock(&big_buffer_mutex);
+	mutex_lock(&dev->wl->mutex);
+	spin_lock_irqsave(&dev->wl->irq_lock, flags);
+	if (b43legacy_status(dev) < B43legacy_STAT_INITIALIZED) {
+		fappend("Board not initialized.\n");
+		goto out;
+	}
+
+	for (i = 0; i < 0x1000; i++) {
+		tmp = b43legacy_shm_read16(dev, B43legacy_SHM_SHARED, 2 * i);
+		le16buf[i] = cpu_to_le16(tmp);
+		pos += sizeof(tmp);
+	}
+
+out:
+	spin_unlock_irqrestore(&dev->wl->irq_lock, flags);
+	mutex_unlock(&dev->wl->mutex);
+	res = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
+	mutex_unlock(&big_buffer_mutex);
+
+	return res;
+}
+
 static ssize_t ucode_regs_read_file(struct file *file, char __user * userbuf,
 				    size_t count, loff_t * ppos)
 {
@@ -382,6 +418,11 @@ static struct file_operations ucode_regs
 	.open = open_file_generic,
 };
 
+static struct file_operations shm_fops = {
+	.read = shm_read_file,
+	.open = open_file_generic,
+};
+
 static struct file_operations txstat_fops = {
 	.read = txstat_read_file,
 	.write = write_file_dummy,
@@ -484,6 +525,10 @@ void b43legacy_debugfs_add_device(struct
 						   dev, &ucode_regs_fops);
 	if (IS_ERR(e->dentry_ucode_regs))
 		e->dentry_ucode_regs = NULL;
+	e->dentry_shm = debugfs_create_file("shm", 0400, e->subdir,
+					    dev, &shm_fops);
+	if (IS_ERR(e->dentry_shm))
+		e->dentry_shm = NULL;
 	e->dentry_txstat = debugfs_create_file("tx_status", 0400, e->subdir,
 						dev, &txstat_fops);
 	if (IS_ERR(e->dentry_txstat))
@@ -514,6 +559,7 @@ void b43legacy_debugfs_remove_device(str
 	b43legacy_remove_dynamic_debug(dev);
 	debugfs_remove(e->dentry_tsf);
 	debugfs_remove(e->dentry_ucode_regs);
+	debugfs_remove(e->dentry_shm);
 	debugfs_remove(e->dentry_txstat);
 	debugfs_remove(e->dentry_restart);
 	debugfs_remove(e->dentry_power);
Index: wireless-dev/drivers/net/wireless/b43legacy/debugfs.h
===================================================================
--- wireless-dev.orig/drivers/net/wireless/b43legacy/debugfs.h
+++ wireless-dev/drivers/net/wireless/b43legacy/debugfs.h
@@ -33,6 +33,7 @@ struct b43legacy_dfsentry {
 	struct dentry *subdir;
 	struct dentry *dentry_tsf;
 	struct dentry *dentry_ucode_regs;
+	struct dentry *dentry_shm;
 	struct dentry *dentry_txstat;
 	struct dentry *dentry_restart;
 	struct dentry *dentry_power;
