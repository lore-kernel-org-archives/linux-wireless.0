Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:55220
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764904AbXHWW1F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2007 18:27:05 -0400
Message-Id: <20070823222155.727360000@bu3sch.de>
References: <20070823222153.073035000@bu3sch.de>
Date: Fri, 24 Aug 2007 00:21:57 +0200
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Larry Finger <larry.finger@lwfinger.net>
Subject: [patch 4/7] b43: Add debugfs file to extract LO calibration data
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a file to debugfs to extract the Local Oscillator
calibration data.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <larry.finger@lwfinger.net>

Index: wireless-dev-new/drivers/net/wireless/b43/debugfs.c
===================================================================
--- wireless-dev-new.orig/drivers/net/wireless/b43/debugfs.c	2007-08-22 00:42:34.000000000 +0200
+++ wireless-dev-new/drivers/net/wireless/b43/debugfs.c	2007-08-22 01:38:36.000000000 +0200
@@ -374,6 +374,88 @@ static ssize_t txpower_g_write_file(stru
 	return res;
 }
 
+static size_t append_lo_table(size_t pos, char *buf, const size_t len,
+			      struct b43_loctl table[B43_NR_BB][B43_NR_RF])
+{
+	unsigned int i, j;
+	struct b43_loctl *ctl;
+
+	for (i = 0; i < B43_NR_BB; i++) {
+		for (j = 0; j < B43_NR_RF; j++) {
+			ctl = &(table[i][j]);
+			fappend("(bbatt %2u, rfatt %2u)  ->  "
+				"(I %+3d, Q %+3d, Used: %d, Calibrated: %d)\n",
+				i, j, ctl->i, ctl->q,
+				ctl->used,
+				b43_loctl_is_calibrated(ctl));
+		}
+	}
+
+	return pos;
+}
+
+static ssize_t loctls_read_file(struct file *file, char __user *userbuf,
+				size_t count, loff_t *ppos)
+{
+	struct b43_wldev *dev = file->private_data;
+	const size_t len = ARRAY_SIZE(big_buffer);
+	char *buf = big_buffer;
+	size_t pos = 0;
+	ssize_t res;
+	unsigned long flags;
+	struct b43_txpower_lo_control *lo;
+	unsigned int i;
+
+	mutex_lock(&big_buffer_mutex);
+	mutex_lock(&dev->wl->mutex);
+	spin_lock_irqsave(&dev->wl->irq_lock, flags);
+	if (b43_status(dev) < B43_STAT_INITIALIZED) {
+		fappend("Not initialized\n");
+		goto out;
+	}
+	if (dev->phy.type != B43_PHYTYPE_G) {
+		fappend("Device is not a G-PHY\n");
+		goto out;
+	}
+
+	lo = dev->phy.lo_control;
+	fappend("-- Local Oscillator calibration data --\n\n");
+	fappend("Measured: %d,  Rebuild: %d,  HW-power-control: %d\n",
+		lo->lo_measured,
+		lo->rebuild,
+		dev->phy.hardware_power_control);
+	fappend("TX Bias: 0x%02X,  TX Magn: 0x%02X\n",
+		lo->tx_bias, lo->tx_magn);
+	fappend("Power Vector: 0x%08X%08X\n",
+		(unsigned int)((lo->power_vector & 0xFFFFFFFF00000000ULL) >> 32),
+		(unsigned int)(lo->power_vector & 0x00000000FFFFFFFFULL));
+	fappend("\nControl table WITH PADMIX:\n");
+	pos = append_lo_table(pos, buf, len, lo->with_padmix);
+	fappend("\nControl table WITHOUT PADMIX:\n");
+	pos = append_lo_table(pos, buf, len, lo->no_padmix);
+	fappend("\nUsed RF attenuation values:  Value(WithPadmix flag)\n");
+	for (i = 0; i < lo->rfatt_list.len; i++) {
+		fappend("%u(%d), ",
+			lo->rfatt_list.list[i].att,
+			lo->rfatt_list.list[i].with_padmix);
+	}
+	fappend("\n");
+	fappend("\nUsed Baseband attenuation values:\n");
+	for (i = 0; i < lo->bbatt_list.len; i++) {
+		fappend("%u, ",
+			lo->bbatt_list.list[i].att);
+	}
+	fappend("\n");
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
 #undef fappend
 
 static struct file_operations drvinfo_fops = {
@@ -405,6 +487,12 @@ static struct file_operations restart_fo
 	.open = open_file_generic,
 };
 
+static struct file_operations loctls_fops = {
+	.read = loctls_read_file,
+	.open = open_file_generic,
+};
+
+
 int b43_debug(struct b43_wldev *dev, enum b43_dyndbg feature)
 {
 	return !!(dev->dfsentry && dev->dfsentry->dyn_debug[feature]);
@@ -499,6 +587,10 @@ void b43_debugfs_add_device(struct b43_w
 						dev, &restart_fops);
 	if (IS_ERR(e->dentry_restart))
 		e->dentry_restart = NULL;
+	e->dentry_loctls = debugfs_create_file("loctls", 0400, e->subdir,
+					       dev, &loctls_fops);
+	if (IS_ERR(e->dentry_loctls))
+		e->dentry_loctls = NULL;
 
 	b43_add_dynamic_debug(dev);
 }
@@ -513,6 +605,7 @@ void b43_debugfs_remove_device(struct b4
 	if (!e)
 		return;
 	b43_remove_dynamic_debug(dev);
+	debugfs_remove(e->dentry_loctls);
 	debugfs_remove(e->dentry_tsf);
 	debugfs_remove(e->dentry_txstat);
 	debugfs_remove(e->dentry_restart);
Index: wireless-dev-new/drivers/net/wireless/b43/debugfs.h
===================================================================
--- wireless-dev-new.orig/drivers/net/wireless/b43/debugfs.h	2007-08-22 00:42:34.000000000 +0200
+++ wireless-dev-new/drivers/net/wireless/b43/debugfs.h	2007-08-22 00:42:34.000000000 +0200
@@ -34,6 +34,7 @@ struct b43_dfsentry {
 	struct dentry *dentry_txstat;
 	struct dentry *dentry_txpower_g;
 	struct dentry *dentry_restart;
+	struct dentry *dentry_loctls;
 
 	struct b43_wldev *dev;
 

-- 

