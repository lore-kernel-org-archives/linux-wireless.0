Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:33293
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbXIDNSX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2007 09:18:23 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Add debugfs file to dump SHM
Date: Tue, 4 Sep 2007 15:17:28 +0200
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	bcm43xx-dev@lists.berlios.de
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200709041517.28751.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds a file to dump the SHM.
Note that SHM dumping is racy, as the microcode continues to run
while we dump the SHM.

Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Larry Finger <larry.finger@lwfinger.net>
Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-dev/drivers/net/wireless/b43/debugfs.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/b43/debugfs.c	2007-08-31 17:32:28.000000000 +0200
+++ wireless-dev/drivers/net/wireless/b43/debugfs.c	2007-08-31 17:36:52.000000000 +0200
@@ -181,6 +181,42 @@ out:
 	return res;
 }
 
+static ssize_t shm_read_file(struct file *file, char __user * userbuf,
+			     size_t count, loff_t * ppos)
+{
+	struct b43_wldev *dev = file->private_data;
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
+	if (b43_status(dev) < B43_STAT_INITIALIZED) {
+		fappend("Board not initialized.\n");
+		goto out;
+	}
+
+	for (i = 0; i < 0x1000; i++) {
+		tmp = b43_shm_read16(dev, B43_SHM_SHARED, 2 * i);
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
 static ssize_t txstat_read_file(struct file *file, char __user * userbuf,
 				size_t count, loff_t * ppos)
 {
@@ -508,6 +544,11 @@ static struct file_operations ucode_regs
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
@@ -617,6 +658,10 @@ void b43_debugfs_add_device(struct b43_w
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
@@ -650,6 +695,7 @@ void b43_debugfs_remove_device(struct b4
 	debugfs_remove(e->dentry_loctls);
 	debugfs_remove(e->dentry_tsf);
 	debugfs_remove(e->dentry_ucode_regs);
+	debugfs_remove(e->dentry_shm);
 	debugfs_remove(e->dentry_txstat);
 	debugfs_remove(e->dentry_restart);
 	debugfs_remove(e->dentry_txpower_g);
Index: wireless-dev/drivers/net/wireless/b43/debugfs.h
===================================================================
--- wireless-dev.orig/drivers/net/wireless/b43/debugfs.h	2007-08-31 17:32:09.000000000 +0200
+++ wireless-dev/drivers/net/wireless/b43/debugfs.h	2007-08-31 17:32:44.000000000 +0200
@@ -32,6 +32,7 @@ struct b43_dfsentry {
 	struct dentry *subdir;
 	struct dentry *dentry_tsf;
 	struct dentry *dentry_ucode_regs;
+	struct dentry *dentry_shm;
 	struct dentry *dentry_txstat;
 	struct dentry *dentry_txpower_g;
 	struct dentry *dentry_restart;
