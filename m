Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-04.rdc-kc.rr.com ([24.94.166.116]:38093 "EHLO
	ms-smtp-04.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759551AbXIJPct (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2007 11:32:49 -0400
Date: Mon, 10 Sep 2007 10:32:09 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] b43legacy: Add debugfs file to dump microcode registers
Message-ID: <46e56379.mCmo8qy1TlkjFpJ9%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Buesch <mb@bu3sch.de>

This adds a debugfs file to dump all microcode registers.
Note that the dumping is racy, as microcode continues to run
while we loop over each register to dump it.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Larry Finger <larry.finger@lwfinger.net>

Index: wireless-dev/drivers/net/wireless/b43legacy/debugfs.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/b43legacy/debugfs.c
+++ wireless-dev/drivers/net/wireless/b43legacy/debugfs.c
@@ -151,6 +151,39 @@ out_unlock_bb:
 	return res;
 }
 
+static ssize_t ucode_regs_read_file(struct file *file, char __user * userbuf,
+				    size_t count, loff_t * ppos)
+{
+	struct b43legacy_wldev *dev = file->private_data;
+	const size_t len = ARRAY_SIZE(big_buffer);
+	char *buf = big_buffer;
+	size_t pos = 0;
+	ssize_t res;
+	unsigned long flags;
+	int i;
+
+	mutex_lock(&big_buffer_mutex);
+	mutex_lock(&dev->wl->mutex);
+	spin_lock_irqsave(&dev->wl->irq_lock, flags);
+	if (b43legacy_status(dev) < B43legacy_STAT_INITIALIZED) {
+		fappend("Board not initialized.\n");
+		goto out;
+	}
+
+	for (i = 0; i < 64; i++) {
+		fappend("r%d = 0x%04x\n", i,
+			b43legacy_shm_read16(dev, B43legacy_SHM_WIRELESS, i));
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
 static ssize_t power_read_file(struct file *file, char __user *userbuf,
 			     size_t count, loff_t *ppos)
 {
@@ -344,6 +377,11 @@ static struct file_operations tsf_fops =
 	.open = open_file_generic,
 };
 
+static struct file_operations ucode_regs_fops = {
+	.read = ucode_regs_read_file,
+	.open = open_file_generic,
+};
+
 static struct file_operations txstat_fops = {
 	.read = txstat_read_file,
 	.write = write_file_dummy,
@@ -442,6 +480,10 @@ void b43legacy_debugfs_add_device(struct
 					     dev, &tsf_fops);
 	if (IS_ERR(e->dentry_tsf))
 		e->dentry_tsf = NULL;
+	e->dentry_ucode_regs = debugfs_create_file("ucode_regs", 0400, e->subdir,
+						   dev, &ucode_regs_fops);
+	if (IS_ERR(e->dentry_ucode_regs))
+		e->dentry_ucode_regs = NULL;
 	e->dentry_txstat = debugfs_create_file("tx_status", 0400, e->subdir,
 						dev, &txstat_fops);
 	if (IS_ERR(e->dentry_txstat))
@@ -471,6 +513,7 @@ void b43legacy_debugfs_remove_device(str
 		return;
 	b43legacy_remove_dynamic_debug(dev);
 	debugfs_remove(e->dentry_tsf);
+	debugfs_remove(e->dentry_ucode_regs);
 	debugfs_remove(e->dentry_txstat);
 	debugfs_remove(e->dentry_restart);
 	debugfs_remove(e->dentry_power);
Index: wireless-dev/drivers/net/wireless/b43legacy/debugfs.h
===================================================================
--- wireless-dev.orig/drivers/net/wireless/b43legacy/debugfs.h
+++ wireless-dev/drivers/net/wireless/b43legacy/debugfs.h
@@ -32,6 +32,7 @@ struct b43legacy_txstatus_log {
 struct b43legacy_dfsentry {
 	struct dentry *subdir;
 	struct dentry *dentry_tsf;
+	struct dentry *dentry_ucode_regs;
 	struct dentry *dentry_txstat;
 	struct dentry *dentry_restart;
 	struct dentry *dentry_power;
