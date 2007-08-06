Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-01.rdc-kc.rr.com ([24.94.166.115]:53237 "EHLO
	ms-smtp-01.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760689AbXHFUWg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2007 16:22:36 -0400
Date: Mon, 06 Aug 2007 15:22:14 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [RFC] bcm43xx-mac80211: Add TX power set file to debugfs
Message-ID: <46b782f6.XGqOxV2KvXubz5jy%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For testing purposes, this patch adds a file named "power_level" to the
debugfs for bcm43xx-mac80211. If this file is read, it returns the current
setting for the "Desired power level". Writing a number between 5 and 18
will set that value as the new value for the desired power setting.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_debugfs.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_debugfs.c
+++ wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_debugfs.c
@@ -151,6 +151,74 @@ out_unlock_bb:
 	return res;
 }
 
+static ssize_t power_read_file(struct file *file, char __user *userbuf,
+			     size_t count, loff_t *ppos)
+{
+	struct bcm43xx_wldev *dev = file->private_data;
+	const size_t len = ARRAY_SIZE(big_buffer);
+	char *buf = big_buffer;
+	size_t pos = 0;
+	ssize_t res;
+	unsigned long flags;
+
+	mutex_lock(&big_buffer_mutex);
+	mutex_lock(&dev->wl->mutex);
+	spin_lock_irqsave(&dev->wl->irq_lock, flags);
+	if (bcm43xx_status(dev) < BCM43xx_STAT_STARTED) {
+		fappend("Board not initialized.\n");
+		goto out;
+	}
+	fappend("%d dBm\n",dev->phy.power_level);
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
+static ssize_t power_write_file(struct file *file, const char __user *user_buf,
+			      size_t count, loff_t *ppos)
+{
+	struct bcm43xx_wldev *dev = file->private_data;
+	char *buf = big_buffer;
+	ssize_t buf_size;
+	ssize_t res;
+	unsigned long flags;
+	int power;
+
+	mutex_lock(&big_buffer_mutex);
+	buf_size = min(count, ARRAY_SIZE(big_buffer) - 1);
+	if (copy_from_user(buf, user_buf, buf_size)) {
+	        res = -EFAULT;
+		goto out_unlock_bb;
+	}
+	mutex_lock(&dev->wl->mutex);
+	spin_lock_irqsave(&dev->wl->irq_lock, flags);
+	if (bcm43xx_status(dev) < BCM43xx_STAT_STARTED) {
+		bcmerr(dev->wl, "debugfs: Board not initialized.\n");
+		res = -EFAULT;
+		goto out_unlock;
+	}
+	if ((sscanf(buf, "%d", &power) != 1) || (power > 18 || power < 5)) {
+		bcmerr(dev->wl, "debugfs: Invalid values for power level\n");
+		res = -EINVAL;
+		goto out_unlock;
+	}
+	dev->phy.power_level = power;
+	res = buf_size;
+
+out_unlock:
+	spin_unlock_irqrestore(&dev->wl->irq_lock, flags);
+	mutex_unlock(&dev->wl->mutex);
+out_unlock_bb:
+	mutex_unlock(&big_buffer_mutex);
+
+	return res;
+}
+
 static ssize_t txstat_read_file(struct file *file, char __user *userbuf,
 				size_t count, loff_t *ppos)
 {
@@ -405,6 +473,12 @@ static struct file_operations restart_fo
 	.open = open_file_generic,
 };
 
+static struct file_operations power_fops = {
+	.read = power_read_file,
+	.write = power_write_file,
+	.open = open_file_generic,
+};
+
 
 int bcm43xx_debug(struct bcm43xx_wldev *dev, enum bcm43xx_dyndbg feature)
 {
@@ -495,6 +569,11 @@ void bcm43xx_debugfs_add_device(struct b
 	if (IS_ERR(e->dentry_restart))
 		e->dentry_restart = NULL;
 
+	e->dentry_power = debugfs_create_file("power_level", 0600, e->subdir,
+					     dev, &power_fops);
+	if (IS_ERR(e->dentry_power))
+		e->dentry_power = NULL;
+
 	bcm43xx_add_dynamic_debug(dev);
 }
 
@@ -512,6 +591,7 @@ void bcm43xx_debugfs_remove_device(struc
 	debugfs_remove(e->dentry_txstat);
 	debugfs_remove(e->dentry_restart);
 	debugfs_remove(e->dentry_txpower_g);
+	debugfs_remove(e->dentry_power);
 	debugfs_remove(e->subdir);
 	kfree(e->txstatlog.log);
 	kfree(e);
Index: wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_debugfs.h
===================================================================
--- wireless-dev.orig/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_debugfs.h
+++ wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_debugfs.h
@@ -35,6 +35,7 @@ struct bcm43xx_dfsentry {
 	struct dentry *dentry_txstat;
 	struct dentry *dentry_txpower_g;
 	struct dentry *dentry_restart;
+	struct dentry *dentry_power;
 
 	struct bcm43xx_wldev *dev;
 
Index: wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c
+++ wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c
@@ -2762,12 +2762,11 @@ static int bcm43xx_dev_config(struct iee
 	}
 
 	/* Adjust the desired TX power level. */
-	if (conf->power_level != 0) {
-		if (conf->power_level != phy->power_level) {
-			phy->power_level = conf->power_level;
-			bcm43xx_phy_xmitpower(dev);
-		}
-	}
+	if (conf->power_level != 0 && phy->power_level == 0) {
+		phy->power_level = conf->power_level;
+	} else
+		phy->power_level = 10;
+	bcm43xx_phy_xmitpower(dev);
 
 	/* Hide/Show the SSID (AP mode only). */
 	if (conf->flags & IEEE80211_CONF_SSID_HIDDEN) {
