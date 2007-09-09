Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:44049
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbXIIMSd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Sep 2007 08:18:33 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH v2] b43: Simplify and cleanup debugfs infrastructure
Date: Sun, 9 Sep 2007 14:17:23 +0200
Cc: Larry Finger <larry.finger@lwfinger.net>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200709091417.24918.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a major cleanup and simplification of the debugfs
infrastructure. All the debugfs related FS handling code (copy_*_user, etc...)
and the locking is handled in common functions. The debugging implementation
files only have to care about their actual job anymore.
This shrinks the function size.

A few macros were also added to simplify adding new files.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <larry.finger@lwfinger.net>

Index: wireless-dev/drivers/net/wireless/b43/debugfs.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/b43/debugfs.c	2007-09-09 13:51:20.000000000 +0200
+++ wireless-dev/drivers/net/wireless/b43/debugfs.c	2007-09-09 13:51:39.000000000 +0200
@@ -4,7 +4,7 @@
 
   debugfs driver debugging code
 
-  Copyright (c) 2005 Michael Buesch <mb@bu3sch.de>
+  Copyright (c) 2005-2007 Michael Buesch <mb@bu3sch.de>
 
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
@@ -37,308 +37,155 @@
 #include "pio.h"
 #include "xmit.h"
 
-#define REALLY_BIG_BUFFER_SIZE	(1024*256)
 
-static struct b43_debugfs fs;
-static char big_buffer[1024 * 256];
-static DEFINE_MUTEX(big_buffer_mutex);
+/* The root directory. */
+struct dentry *rootdir;
 
-static ssize_t write_file_dummy(struct file *file, const char __user * buf,
-				size_t count, loff_t * ppos)
-{
-	return count;
-}
+struct b43_debugfs_fops {
+	ssize_t (*read)(struct b43_wldev *dev, char *buf, size_t bufsize);
+	int (*write)(struct b43_wldev *dev, const char *buf, size_t count);
+	struct file_operations fops;
+	/* Offset of struct b43_dfs_file in struct b43_dfsentry */
+	size_t file_struct_offset;
+	/* Take wl->irq_lock before calling read/write? */
+	bool take_irqlock;
+};
 
-static int open_file_generic(struct inode *inode, struct file *file)
+static inline
+struct b43_dfs_file * fops_to_dfs_file(struct b43_wldev *dev,
+				       const struct b43_debugfs_fops *dfops)
 {
-	file->private_data = inode->i_private;
-	return 0;
+	void *p;
+
+	p = dev->dfsentry;
+	p += dfops->file_struct_offset;
+
+	return p;
 }
 
-#define fappend(fmt, x...)	pos += snprintf(buf + pos, len - pos, fmt , ##x)
 
-static ssize_t drvinfo_read_file(struct file *file, char __user * userbuf,
-				 size_t count, loff_t * ppos)
+#define fappend(fmt, x...)	\
+	do {							\
+		if (bufsize - count)				\
+			count += snprintf(buf + count,		\
+					  bufsize - count,	\
+					  fmt , ##x);		\
+		else						\
+			printk(KERN_ERR "b43: fappend overflow\n"); \
+	} while (0)
+
+
+/* wl->irq_lock is locked */
+ssize_t tsf_read_file(struct b43_wldev *dev, char *buf, size_t bufsize)
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
-static ssize_t tsf_read_file(struct file *file, char __user * userbuf,
-			     size_t count, loff_t * ppos)
-{
-	struct b43_wldev *dev = file->private_data;
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
-	if (b43_status(dev) < B43_STAT_STARTED) {
-		fappend("Board not initialized.\n");
-		goto out;
-	}
 	b43_tsf_read(dev, &tsf);
 	fappend("0x%08x%08x\n",
 		(unsigned int)((tsf & 0xFFFFFFFF00000000ULL) >> 32),
 		(unsigned int)(tsf & 0xFFFFFFFFULL));
 
-      out:
-	spin_unlock_irqrestore(&dev->wl->irq_lock, flags);
-	mutex_unlock(&dev->wl->mutex);
-	res = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
-	mutex_unlock(&big_buffer_mutex);
-
-	return res;
+	return count;
 }
 
-static ssize_t tsf_write_file(struct file *file, const char __user * user_buf,
-			      size_t count, loff_t * ppos)
+/* wl->irq_lock is locked */
+int tsf_write_file(struct b43_wldev *dev, const char *buf, size_t count)
 {
-	struct b43_wldev *dev = file->private_data;
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
-	if (b43_status(dev) < B43_STAT_STARTED) {
-		b43err(dev->wl, "debugfs: Board not initialized.\n");
-		res = -EFAULT;
-		goto out_unlock;
-	}
-	if (sscanf(buf, "%llu", (unsigned long long *)(&tsf)) != 1) {
-		b43err(dev->wl, "debugfs: invalid values for \"tsf\"\n");
-		res = -EINVAL;
-		goto out_unlock;
-	}
+	if (sscanf(buf, "%llu", (unsigned long long *)(&tsf)) != 1)
+		return -EINVAL;
 	b43_tsf_write(dev, tsf);
-	mmiowb();
-	res = buf_size;
 
-      out_unlock:
-	spin_unlock_irqrestore(&dev->wl->irq_lock, flags);
-	mutex_unlock(&dev->wl->mutex);
-      out_unlock_bb:
-	mutex_unlock(&big_buffer_mutex);
-
-	return res;
+	return 0;
 }
 
-static ssize_t ucode_regs_read_file(struct file *file, char __user * userbuf,
-				    size_t count, loff_t * ppos)
+/* wl->irq_lock is locked */
+ssize_t ucode_regs_read_file(struct b43_wldev *dev, char *buf, size_t bufsize)
 {
-	struct b43_wldev *dev = file->private_data;
-	const size_t len = ARRAY_SIZE(big_buffer);
-	char *buf = big_buffer;
-	size_t pos = 0;
-	ssize_t res;
-	unsigned long flags;
+	ssize_t count = 0;
 	int i;
 
-	mutex_lock(&big_buffer_mutex);
-	mutex_lock(&dev->wl->mutex);
-	spin_lock_irqsave(&dev->wl->irq_lock, flags);
-	if (b43_status(dev) < B43_STAT_INITIALIZED) {
-		fappend("Board not initialized.\n");
-		goto out;
-	}
-
 	for (i = 0; i < 64; i++) {
 		fappend("r%d = 0x%04x\n", i,
 			b43_shm_read16(dev, B43_SHM_SCRATCH, i));
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
 
-static ssize_t shm_read_file(struct file *file, char __user * userbuf,
-			     size_t count, loff_t * ppos)
+/* wl->irq_lock is locked */
+ssize_t shm_read_file(struct b43_wldev *dev, char *buf, size_t bufsize)
 {
-	struct b43_wldev *dev = file->private_data;
-	const size_t len = ARRAY_SIZE(big_buffer);
-	u8 *buf = big_buffer;
-	__le16 *le16buf = (__le16*)big_buffer;
-	size_t pos = 0;
-	ssize_t res;
-	unsigned long flags;
+	ssize_t count = 0;
 	int i;
 	u16 tmp;
-
-	mutex_lock(&big_buffer_mutex);
-	mutex_lock(&dev->wl->mutex);
-	spin_lock_irqsave(&dev->wl->irq_lock, flags);
-	if (b43_status(dev) < B43_STAT_INITIALIZED) {
-		fappend("Board not initialized.\n");
-		goto out;
-	}
+	__le16 *le16buf = (__le16 *)buf;
 
 	for (i = 0; i < 0x1000; i++) {
+		if (bufsize <= 0)
+			break;
 		tmp = b43_shm_read16(dev, B43_SHM_SHARED, 2 * i);
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
 
-static ssize_t txstat_read_file(struct file *file, char __user * userbuf,
-				size_t count, loff_t * ppos)
+ssize_t txstat_read_file(struct b43_wldev *dev, char *buf, size_t bufsize)
 {
-	struct b43_wldev *dev = file->private_data;
-	struct b43_dfsentry *e = dev->dfsentry;
-	struct b43_txstatus_log *log = &e->txstatlog;
+	struct b43_txstatus_log *log = &dev->dfsentry->txstatlog;
+	ssize_t count = 0;
 	unsigned long flags;
-	char *buf = log->printbuf;
-	const size_t len = ARRAY_SIZE(log->printbuf);
-	size_t pos = 0;
-	ssize_t res;
 	int i, idx;
 	struct b43_txstatus *stat;
 
-	mutex_lock(&big_buffer_mutex);
 	spin_lock_irqsave(&log->lock, flags);
-	if (!log->printing) {
-		log->printing = 1;
-		fappend("b43 TX status reports:\n\n"
-			"index | cookie | seq | phy_stat | frame_count | "
-			"rts_count | supp_reason | pm_indicated | "
-			"intermediate | for_ampdu | acked\n" "---\n");
-		i = log->end + 1;
-		idx = 0;
-		while (1) {
-			if (log->end < 0) {
-				fappend("Nothing transmitted, yet\n");
-				break;
-			}
-			if (i == B43_NR_LOGGED_TXSTATUS)
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
+	if (log->end < 0) {
+		fappend("Nothing transmitted, yet\n");
+		goto out_unlock;
+	}
+	fappend("b43 TX status reports:\n\n"
+		"index | cookie | seq | phy_stat | frame_count | "
+		"rts_count | supp_reason | pm_indicated | "
+		"intermediate | for_ampdu | acked\n" "---\n");
+	i = log->end + 1;
+	idx = 0;
+	while (1) {
+		if (i == B43_NR_LOGGED_TXSTATUS)
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
 		}
-		log->buf_avail = pos;
+		if (i == log->end)
+			break;
+		i++;
 	}
-	memcpy(big_buffer, buf, min(log->buf_avail, ARRAY_SIZE(big_buffer)));
+out_unlock:
 	spin_unlock_irqrestore(&log->lock, flags);
 
-	res = simple_read_from_buffer(userbuf, count, ppos,
-				      big_buffer, log->buf_avail);
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
-				  const char __user * user_buf, size_t count,
-				  loff_t * ppos)
-{
-	struct b43_wldev *dev = file->private_data;
-	char *buf = big_buffer;
-	ssize_t buf_size;
-	ssize_t res;
-	unsigned long flags;
-
-	mutex_lock(&big_buffer_mutex);
-	buf_size = min(count, ARRAY_SIZE(big_buffer) - 1);
-	if (copy_from_user(buf, user_buf, buf_size)) {
-		res = -EFAULT;
-		goto out_unlock_bb;
-	}
-	mutex_lock(&dev->wl->mutex);
-	spin_lock_irqsave(&dev->wl->irq_lock, flags);
-	if (b43_status(dev) < B43_STAT_INITIALIZED) {
-		b43err(dev->wl, "debugfs: Board not initialized.\n");
-		res = -EFAULT;
-		goto out_unlock;
-	}
-	if (count > 0 && buf[0] == '1') {
-		b43_controller_restart(dev, "manually restarted");
-		res = count;
-	} else
-		res = -EINVAL;
-
-      out_unlock:
-	spin_unlock_irqrestore(&dev->wl->irq_lock, flags);
-	mutex_unlock(&dev->wl->mutex);
-      out_unlock_bb:
-	mutex_unlock(&big_buffer_mutex);
-
-	return res;
+	return count;
 }
 
-static ssize_t txpower_g_read_file(struct file *file, char __user * userbuf,
-				   size_t count, loff_t * ppos)
+ssize_t txpower_g_read_file(struct b43_wldev *dev, char *buf, size_t bufsize)
 {
-	struct b43_wldev *dev = file->private_data;
-	const size_t len = ARRAY_SIZE(big_buffer);
-	char *buf = big_buffer;
-	size_t pos = 0;
-	ssize_t res;
-	unsigned long flags;
+	ssize_t count = 0;
 
-	mutex_lock(&big_buffer_mutex);
-	mutex_lock(&dev->wl->mutex);
-	spin_lock_irqsave(&dev->wl->irq_lock, flags);
-	if (b43_status(dev) < B43_STAT_STARTED) {
-		fappend("Not initialized\n");
-		goto out;
-	}
 	if (dev->phy.type != B43_PHYTYPE_G) {
 		fappend("Device is not a G-PHY\n");
 		goto out;
@@ -363,45 +210,22 @@ static ssize_t txpower_g_read_file(struc
 	fappend("Enables manual control with Baseband attenuation 5, "
 		"Radio attenuation 4, No TX Mixer Gain, "
 		"No PA Gain 2dB, With PA Gain 3dB.\n");
-
-      out:
-	spin_unlock_irqrestore(&dev->wl->irq_lock, flags);
-	mutex_unlock(&dev->wl->mutex);
-	res = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
-	mutex_unlock(&big_buffer_mutex);
-
-	return res;
+out:
+	return count;
 }
 
-static ssize_t txpower_g_write_file(struct file *file,
-				    const char __user * user_buf, size_t count,
-				    loff_t * ppos)
-{
-	struct b43_wldev *dev = file->private_data;
-	char *buf = big_buffer;
-	ssize_t buf_size;
-	ssize_t res;
-	unsigned long flags, phy_flags;
-
-	mutex_lock(&big_buffer_mutex);
-	buf_size = min(count, ARRAY_SIZE(big_buffer) - 1);
-	if (copy_from_user(buf, user_buf, buf_size)) {
-		res = -EFAULT;
-		goto out_unlock_bb;
-	}
-	mutex_lock(&dev->wl->mutex);
+int txpower_g_write_file(struct b43_wldev *dev, const char *buf, size_t count)
+{
+	unsigned long flags;
+	unsigned long phy_flags;
+	int err = 0;
+
 	spin_lock_irqsave(&dev->wl->irq_lock, flags);
-	if (b43_status(dev) < B43_STAT_STARTED) {
-		b43err(dev->wl, "debugfs: Board not initialized.\n");
-		res = -ENODEV;
-		goto out_unlock;
-	}
 	if (dev->phy.type != B43_PHYTYPE_G) {
-		b43err(dev->wl, "debugfs: Device is not a G-PHY\n");
-		res = -ENODEV;
+		err = -ENODEV;
 		goto out_unlock;
 	}
-	if ((buf_size >= 4) && (memcmp(buf, "auto", 4) == 0)) {
+	if ((count >= 4) && (memcmp(buf, "auto", 4) == 0)) {
 		/* Automatic control */
 		dev->phy.manual_txpower_control = 0;
 		b43_phy_xmitpower(dev);
@@ -410,9 +234,7 @@ static ssize_t txpower_g_write_file(stru
 		/* Manual control */
 		if (sscanf(buf, "%d %d %d %d %d", &bbatt, &rfatt,
 			   &txmix, &pa2db, &pa3db) != 5) {
-			b43err(dev->wl,
-			       "debugfs: invalid value for \"tx_power_g\"\n");
-			res = -EINVAL;
+			err = -EINVAL;
 			goto out_unlock;
 		}
 		b43_put_attenuation_into_ranges(dev, &bbatt, &rfatt);
@@ -433,18 +255,27 @@ static ssize_t txpower_g_write_file(stru
 		b43_radio_unlock(dev);
 		b43_phy_unlock(dev, phy_flags);
 	}
-	res = buf_size;
-      out_unlock:
+out_unlock:
 	spin_unlock_irqrestore(&dev->wl->irq_lock, flags);
-	mutex_unlock(&dev->wl->mutex);
-      out_unlock_bb:
-	mutex_unlock(&big_buffer_mutex);
 
-	return res;
+	return err;
 }
 
-static size_t append_lo_table(size_t pos, char *buf, const size_t len,
-			      struct b43_loctl table[B43_NR_BB][B43_NR_RF])
+/* wl->irq_lock is locked */
+int restart_write_file(struct b43_wldev *dev, const char *buf, size_t count)
+{
+	int err = 0;
+
+	if (count > 0 && buf[0] == '1') {
+		b43_controller_restart(dev, "manually restarted");
+	} else
+		err = -EINVAL;
+
+	return err;
+}
+
+static ssize_t append_lo_table(ssize_t count, char *buf, const size_t bufsize,
+			       struct b43_loctl table[B43_NR_BB][B43_NR_RF])
 {
 	unsigned int i, j;
 	struct b43_loctl *ctl;
@@ -460,33 +291,20 @@ static size_t append_lo_table(size_t pos
 		}
 	}
 
-	return pos;
+	return count;
 }
 
-static ssize_t loctls_read_file(struct file *file, char __user *userbuf,
-				size_t count, loff_t *ppos)
+ssize_t loctls_read_file(struct b43_wldev *dev, char *buf, size_t bufsize)
 {
-	struct b43_wldev *dev = file->private_data;
-	const size_t len = ARRAY_SIZE(big_buffer);
-	char *buf = big_buffer;
-	size_t pos = 0;
-	ssize_t res;
-	unsigned long flags;
+	ssize_t count = 0;
 	struct b43_txpower_lo_control *lo;
-	unsigned int i;
+	int i, err = 0;
 
-	mutex_lock(&big_buffer_mutex);
-	mutex_lock(&dev->wl->mutex);
-	spin_lock_irqsave(&dev->wl->irq_lock, flags);
-	if (b43_status(dev) < B43_STAT_INITIALIZED) {
-		fappend("Not initialized\n");
-		goto out;
-	}
 	if (dev->phy.type != B43_PHYTYPE_G) {
 		fappend("Device is not a G-PHY\n");
+		err = -ENODEV;
 		goto out;
 	}
-
 	lo = dev->phy.lo_control;
 	fappend("-- Local Oscillator calibration data --\n\n");
 	fappend("Measured: %d,  Rebuild: %d,  HW-power-control: %d\n",
@@ -499,9 +317,9 @@ static ssize_t loctls_read_file(struct f
 		(unsigned int)((lo->power_vector & 0xFFFFFFFF00000000ULL) >> 32),
 		(unsigned int)(lo->power_vector & 0x00000000FFFFFFFFULL));
 	fappend("\nControl table WITH PADMIX:\n");
-	pos = append_lo_table(pos, buf, len, lo->with_padmix);
+	count = append_lo_table(count, buf, bufsize, lo->with_padmix);
 	fappend("\nControl table WITHOUT PADMIX:\n");
-	pos = append_lo_table(pos, buf, len, lo->no_padmix);
+	count = append_lo_table(count, buf, bufsize, lo->no_padmix);
 	fappend("\nUsed RF attenuation values:  Value(WithPadmix flag)\n");
 	for (i = 0; i < lo->rfatt_list.len; i++) {
 		fappend("%u(%d), ",
@@ -517,59 +335,161 @@ static ssize_t loctls_read_file(struct f
 	fappend("\n");
 
 out:
-	spin_unlock_irqrestore(&dev->wl->irq_lock, flags);
-	mutex_unlock(&dev->wl->mutex);
-	res = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
-	mutex_unlock(&big_buffer_mutex);
-
-	return res;
+	return err ? err : count;
 }
 
 #undef fappend
 
-static struct file_operations drvinfo_fops = {
-	.read = drvinfo_read_file,
-	.write = write_file_dummy,
-	.open = open_file_generic,
-};
+static int b43_debugfs_open(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+	return 0;
+}
 
-static struct file_operations tsf_fops = {
-	.read = tsf_read_file,
-	.write = tsf_write_file,
-	.open = open_file_generic,
-};
+static ssize_t b43_debugfs_read(struct file *file, char __user *userbuf,
+				size_t count, loff_t *ppos)
+{
+	struct b43_wldev *dev;
+	struct b43_debugfs_fops *dfops;
+	struct b43_dfs_file *dfile;
+	ssize_t ret;
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
 
-static struct file_operations ucode_regs_fops = {
-	.read = ucode_regs_read_file,
-	.open = open_file_generic,
-};
+	mutex_lock(&dev->wl->mutex);
+	if (b43_status(dev) < B43_STAT_INITIALIZED) {
+		err = -ENODEV;
+		goto out_unlock;
+	}
 
-static struct file_operations shm_fops = {
-	.read = shm_read_file,
-	.open = open_file_generic,
-};
+	dfops = container_of(file->f_op, struct b43_debugfs_fops, fops);
+	if (!dfops->read) {
+		err = -ENOSYS;
+		goto out_unlock;
+	}
+	dfile = fops_to_dfs_file(dev, dfops);
 
-static struct file_operations txstat_fops = {
-	.read = txstat_read_file,
-	.write = write_file_dummy,
-	.open = open_file_generic,
-};
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
 
-static struct file_operations txpower_g_fops = {
-	.read = txpower_g_read_file,
-	.write = txpower_g_write_file,
-	.open = open_file_generic,
-};
+	ret = simple_read_from_buffer(userbuf, count, ppos,
+				      dfile->buffer,
+				      dfile->data_len);
+	if (*ppos >= dfile->data_len) {
+		free_pages((unsigned long)dfile->buffer, buforder);
+		dfile->buffer = NULL;
+		dfile->data_len = 0;
+	}
+out_unlock:
+	mutex_unlock(&dev->wl->mutex);
 
-static struct file_operations restart_fops = {
-	.write = restart_write_file,
-	.open = open_file_generic,
-};
+	return err ? err : ret;
+}
 
-static struct file_operations loctls_fops = {
-	.read = loctls_read_file,
-	.open = open_file_generic,
-};
+static ssize_t b43_debugfs_write(struct file *file,
+				 const char __user *userbuf,
+				 size_t count, loff_t *ppos)
+{
+	struct b43_wldev *dev;
+	struct b43_debugfs_fops *dfops;
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
+
+	mutex_lock(&dev->wl->mutex);
+	if (b43_status(dev) < B43_STAT_INITIALIZED) {
+		err = -ENODEV;
+		goto out_unlock;
+	}
+
+	dfops = container_of(file->f_op, struct b43_debugfs_fops, fops);
+	if (!dfops->write) {
+		err = -ENOSYS;
+		goto out_unlock;
+	}
+
+	buf = (char *)get_zeroed_page(GFP_KERNEL);
+	if (!buf) {
+		err = -ENOMEM;
+		goto out_unlock;
+	}
+	if (copy_from_user(buf, userbuf, count)) {
+		err = -EFAULT;
+		goto out_freepage;
+	}
+	if (dfops->take_irqlock) {
+		spin_lock_irq(&dev->wl->irq_lock);
+		err = dfops->write(dev, buf, count);
+		spin_unlock_irq(&dev->wl->irq_lock);
+	} else
+		err = dfops->write(dev, buf, count);
+	if (err)
+		goto out_freepage;
+
+out_freepage:
+	free_page((unsigned long)buf);
+out_unlock:
+	mutex_unlock(&dev->wl->mutex);
+
+	return err ? err : count;
+}
+
+
+#define B43_DEBUGFS_FOPS(name, _read, _write, _take_irqlock)	\
+	static struct b43_debugfs_fops fops_##name = {		\
+		.read	= _read,				\
+		.write	= _write,				\
+		.fops	= {					\
+			.open	= b43_debugfs_open,		\
+			.read	= b43_debugfs_read,		\
+			.write	= b43_debugfs_write,		\
+		},						\
+		.file_struct_offset = offsetof(struct b43_dfsentry, \
+					       file_##name),	\
+		.take_irqlock	= _take_irqlock,		\
+	}
+
+B43_DEBUGFS_FOPS(tsf, tsf_read_file, tsf_write_file, 1);
+B43_DEBUGFS_FOPS(ucode_regs, ucode_regs_read_file, NULL, 1);
+B43_DEBUGFS_FOPS(shm, shm_read_file, NULL, 1);
+B43_DEBUGFS_FOPS(txstat, txstat_read_file, NULL, 0);
+B43_DEBUGFS_FOPS(txpower_g, txpower_g_read_file, txpower_g_write_file, 0);
+B43_DEBUGFS_FOPS(restart, NULL, restart_write_file, 1);
+B43_DEBUGFS_FOPS(loctls, loctls_read_file, NULL, 0);
 
 
 int b43_debug(struct b43_wldev *dev, enum b43_dyndbg feature)
@@ -635,7 +555,7 @@ void b43_debugfs_add_device(struct b43_w
 	dev->dfsentry = e;
 
 	snprintf(devdir, sizeof(devdir), "%s", wiphy_name(dev->wl->hw->wiphy));
-	e->subdir = debugfs_create_dir(devdir, fs.root);
+	e->subdir = debugfs_create_dir(devdir, rootdir);
 	if (!e->subdir || IS_ERR(e->subdir)) {
 		if (e->subdir == ERR_PTR(-ENODEV)) {
 			b43dbg(dev->wl, "DebugFS (CONFIG_DEBUG_FS) not "
@@ -650,34 +570,27 @@ void b43_debugfs_add_device(struct b43_w
 		return;
 	}
 
-	e->dentry_tsf = debugfs_create_file("tsf", 0600, e->subdir,
-					    dev, &tsf_fops);
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
-					       dev, &txstat_fops);
-	if (IS_ERR(e->dentry_txstat))
-		e->dentry_txstat = NULL;
-	e->dentry_txpower_g = debugfs_create_file("tx_power_g", 0600, e->subdir,
-						  dev, &txpower_g_fops);
-	if (IS_ERR(e->dentry_txpower_g))
-		e->dentry_txpower_g = NULL;
-	e->dentry_restart = debugfs_create_file("restart", 0200, e->subdir,
-						dev, &restart_fops);
-	if (IS_ERR(e->dentry_restart))
-		e->dentry_restart = NULL;
-	e->dentry_loctls = debugfs_create_file("loctls", 0400, e->subdir,
-					       dev, &loctls_fops);
-	if (IS_ERR(e->dentry_loctls))
-		e->dentry_loctls = NULL;
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
+	ADD_FILE(txpower_g, 0600);
+	ADD_FILE(restart, 0200);
+	ADD_FILE(loctls, 0400);
+
+#undef ADD_FILE
 
 	b43_add_dynamic_debug(dev);
 }
@@ -692,13 +605,15 @@ void b43_debugfs_remove_device(struct b4
 	if (!e)
 		return;
 	b43_remove_dynamic_debug(dev);
-	debugfs_remove(e->dentry_loctls);
-	debugfs_remove(e->dentry_tsf);
-	debugfs_remove(e->dentry_ucode_regs);
-	debugfs_remove(e->dentry_shm);
-	debugfs_remove(e->dentry_txstat);
-	debugfs_remove(e->dentry_restart);
-	debugfs_remove(e->dentry_txpower_g);
+
+	debugfs_remove(e->file_tsf.dentry);
+	debugfs_remove(e->file_ucode_regs.dentry);
+	debugfs_remove(e->file_shm.dentry);
+	debugfs_remove(e->file_txstat.dentry);
+	debugfs_remove(e->file_txpower_g.dentry);
+	debugfs_remove(e->file_restart.dentry);
+	debugfs_remove(e->file_loctls.dentry);
+
 	debugfs_remove(e->subdir);
 	kfree(e->txstatlog.log);
 	kfree(e);
@@ -728,20 +643,12 @@ void b43_debugfs_log_txstat(struct b43_w
 
 void b43_debugfs_init(void)
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
 
 void b43_debugfs_exit(void)
 {
-	debugfs_remove(fs.dentry_driverinfo);
-	debugfs_remove(fs.root);
+	debugfs_remove(rootdir);
 }
Index: wireless-dev/drivers/net/wireless/b43/debugfs.h
===================================================================
--- wireless-dev.orig/drivers/net/wireless/b43/debugfs.h	2007-09-09 13:51:20.000000000 +0200
+++ wireless-dev/drivers/net/wireless/b43/debugfs.h	2007-09-09 13:51:39.000000000 +0200
@@ -22,23 +22,26 @@ struct dentry;
 struct b43_txstatus_log {
 	struct b43_txstatus *log;
 	int end;
-	int printing;
-	char printbuf[(B43_NR_LOGGED_TXSTATUS * 70) + 200];
-	size_t buf_avail;
 	spinlock_t lock;
 };
 
+struct b43_dfs_file {
+	struct dentry *dentry;
+	char *buffer;
+	size_t data_len;
+};
+
 struct b43_dfsentry {
+	struct b43_wldev *dev;
 	struct dentry *subdir;
-	struct dentry *dentry_tsf;
-	struct dentry *dentry_ucode_regs;
-	struct dentry *dentry_shm;
-	struct dentry *dentry_txstat;
-	struct dentry *dentry_txpower_g;
-	struct dentry *dentry_restart;
-	struct dentry *dentry_loctls;
 
-	struct b43_wldev *dev;
+	struct b43_dfs_file file_tsf;
+	struct b43_dfs_file file_ucode_regs;
+	struct b43_dfs_file file_shm;
+	struct b43_dfs_file file_txstat;
+	struct b43_dfs_file file_txpower_g;
+	struct b43_dfs_file file_restart;
+	struct b43_dfs_file file_loctls;
 
 	struct b43_txstatus_log txstatlog;
 
@@ -48,11 +51,6 @@ struct b43_dfsentry {
 	struct dentry *dyn_debug_dentries[__B43_NR_DYNDBG];
 };
 
-struct b43_debugfs {
-	struct dentry *root;
-	struct dentry *dentry_driverinfo;
-};
-
 int b43_debug(struct b43_wldev *dev, enum b43_dyndbg feature);
 
 void b43_debugfs_init(void);
@@ -81,31 +79,11 @@ static inline void b43_debugfs_add_devic
 static inline void b43_debugfs_remove_device(struct b43_wldev *dev)
 {
 }
-static inline
-    void b43_debugfs_log_txstat(struct b43_wldev *dev,
-				const struct b43_txstatus *status)
+static inline void b43_debugfs_log_txstat(struct b43_wldev *dev,
+					  const struct b43_txstatus *status)
 {
 }
 
 #endif /* CONFIG_B43_DEBUG */
 
-/* Ugly helper macros to make incomplete code more verbose on runtime */
-#ifdef TODO
-# undef TODO
-#endif
-#define TODO()  \
-	do {									\
-		b43info(NULL, "TODO: Incomplete code in %s() at %s:%d\n",	\
-			__FUNCTION__, __FILE__, __LINE__);			\
-	} while (0)
-
-#ifdef FIXME
-# undef FIXME
-#endif
-#define FIXME()  \
-	do {									\
-		b43info(NULL, "FIXME: Possibly broken code in %s() at %s:%d\n",	\
-			__FUNCTION__, __FILE__, __LINE__);			\
-	} while (0)
-
 #endif /* B43_DEBUGFS_H_ */
Index: wireless-dev/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/b43/main.c	2007-09-09 13:51:24.000000000 +0200
+++ wireless-dev/drivers/net/wireless/b43/main.c	2007-09-09 14:14:32.000000000 +0200
@@ -762,7 +762,6 @@ static void keymac_write(struct b43_wlde
 		 */
 		if (index < 8) {
 			/* TODO write to RCM 16, 19, 22 and 25 */
-			TODO();
 		} else {
 			b43_shm_write32(dev, B43_SHM_SHARED,
 					B43_SHM_SH_PSM + (index * 6) + 0,
Index: wireless-dev/drivers/net/wireless/b43/phy.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/b43/phy.c	2007-09-09 13:50:20.000000000 +0200
+++ wireless-dev/drivers/net/wireless/b43/phy.c	2007-09-09 13:51:39.000000000 +0200
@@ -1147,7 +1147,7 @@ static void b43_phy_inita(struct b43_wld
 		      (b43_phy_read(dev, B43_PHY_A_CRS) & 0xF83C) | 0x0340);
 	b43_phy_write(dev, 0x0034, 0x0001);
 
-	TODO();			//TODO: RSSI AGC
+	//TODO: RSSI AGC
 	b43_phy_write(dev, B43_PHY_A_CRS,
 		      b43_phy_read(dev, B43_PHY_A_CRS) | (1 << 14));
 	b43_radio_init2060(dev);
@@ -1156,7 +1156,7 @@ static void b43_phy_inita(struct b43_wld
 	    ((bus->boardinfo.type == SSB_BOARD_BU4306) ||
 	     (bus->boardinfo.type == SSB_BOARD_BU4309))) {
 		if (phy->lofcal == 0xFFFF) {
-			TODO();	//TODO: LOF Cal
+			//TODO: LOF Cal
 			b43_radio_set_tx_iq(dev);
 		} else
 			b43_radio_write16(dev, 0x001E, phy->lofcal);
@@ -1900,7 +1900,7 @@ static s8 b43_phy_estimate_power_out(str
 		tmp += 0x80;
 		tmp = limit_value(tmp, 0x00, 0xFF);
 		dbm = phy->tssi2dbm[tmp];
-		TODO();		//TODO: There's a FIXME on the specs
+		//TODO: There's a FIXME on the specs
 		break;
 	case B43_PHYTYPE_B:
 	case B43_PHYTYPE_G:
@@ -1986,7 +1986,7 @@ void b43_phy_xmitpower(struct b43_wldev 
 	switch (phy->type) {
 	case B43_PHYTYPE_A:{
 
-			TODO();	//TODO: Nothing for A PHYs yet :-/
+			//TODO: Nothing for A PHYs yet :-/
 
 			break;
 		}
@@ -4127,10 +4127,10 @@ int b43_radio_selectchannel(struct b43_w
 		b43_write16(dev, 0x03F0, freq);
 		b43_radio_write16(dev, 0x0008, r8);
 
-		TODO();		//TODO: write max channel TX power? to Radio 0x2D
+		//TODO: write max channel TX power? to Radio 0x2D
 		tmp = b43_radio_read16(dev, 0x002E);
 		tmp &= 0x0080;
-		TODO();		//TODO: OR tmp with the Power out estimation for this channel?
+		//TODO: OR tmp with the Power out estimation for this channel?
 		b43_radio_write16(dev, 0x002E, tmp);
 
 		if (freq >= 4920 && freq <= 5500) {
@@ -4165,7 +4165,7 @@ int b43_radio_selectchannel(struct b43_w
 		b43_radio_write16(dev, 0x0035, (b43_radio_read16(dev, 0x0035)
 						& 0xFFEF) | 0x0010);
 		b43_radio_set_tx_iq(dev);
-		TODO();		//TODO: TSSI2dbm workaround
+		//TODO: TSSI2dbm workaround
 		b43_phy_xmitpower(dev);	//FIXME correct?
 	} else {
 		if ((channel < 1) || (channel > 14))
@@ -4295,7 +4295,6 @@ static void b43_radio_set_txpower_a(stru
 
 	phy->txpwr_offset = txpower;
 
-	TODO();
 	//TODO: FuncPlaceholder (Adjust BB loft cancel)
 }
 
