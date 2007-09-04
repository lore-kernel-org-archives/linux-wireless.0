Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:33093
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbXIDNRF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2007 09:17:05 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Add debugfs file to dump microcode registers
Date: Tue, 4 Sep 2007 15:16:00 +0200
Cc: bcm43xx-dev@lists.berlios.de,
	Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200709041516.01095.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds a debugfs file to dump all microcode registers.
Note that the dumping is racy, as microcode continues to run
while we loop over each register to dump it.

Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Larry Finger <larry.finger@lwfinger.net>
Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-dev/drivers/net/wireless/b43/debugfs.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/b43/debugfs.c	2007-08-31 16:51:12.000000000 +0200
+++ wireless-dev/drivers/net/wireless/b43/debugfs.c	2007-08-31 17:39:23.000000000 +0200
@@ -148,6 +148,39 @@ static ssize_t tsf_write_file(struct fil
 	return res;
 }
 
+static ssize_t ucode_regs_read_file(struct file *file, char __user * userbuf,
+				    size_t count, loff_t * ppos)
+{
+	struct b43_wldev *dev = file->private_data;
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
+	if (b43_status(dev) < B43_STAT_INITIALIZED) {
+		fappend("Board not initialized.\n");
+		goto out;
+	}
+
+	for (i = 0; i < 64; i++) {
+		fappend("r%d = 0x%04x\n", i,
+			b43_shm_read16(dev, B43_SHM_SCRATCH, i));
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
 static ssize_t txstat_read_file(struct file *file, char __user * userbuf,
 				size_t count, loff_t * ppos)
 {
@@ -470,6 +503,11 @@ static struct file_operations tsf_fops =
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
@@ -575,6 +613,10 @@ void b43_debugfs_add_device(struct b43_w
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
@@ -607,6 +649,7 @@ void b43_debugfs_remove_device(struct b4
 	b43_remove_dynamic_debug(dev);
 	debugfs_remove(e->dentry_loctls);
 	debugfs_remove(e->dentry_tsf);
+	debugfs_remove(e->dentry_ucode_regs);
 	debugfs_remove(e->dentry_txstat);
 	debugfs_remove(e->dentry_restart);
 	debugfs_remove(e->dentry_txpower_g);
Index: wireless-dev/drivers/net/wireless/b43/debugfs.h
===================================================================
--- wireless-dev.orig/drivers/net/wireless/b43/debugfs.h	2007-08-31 16:51:12.000000000 +0200
+++ wireless-dev/drivers/net/wireless/b43/debugfs.h	2007-08-31 17:39:23.000000000 +0200
@@ -31,6 +31,7 @@ struct b43_txstatus_log {
 struct b43_dfsentry {
 	struct dentry *subdir;
 	struct dentry *dentry_tsf;
+	struct dentry *dentry_ucode_regs;
 	struct dentry *dentry_txstat;
 	struct dentry *dentry_txpower_g;
 	struct dentry *dentry_restart;
