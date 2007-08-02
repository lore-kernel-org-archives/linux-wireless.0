Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-04.rdc-kc.rr.com ([24.94.166.116]:36864 "EHLO
	ms-smtp-04.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbXHBPxb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 11:53:31 -0400
Date: Thu, 02 Aug 2007 10:53:17 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [RFC 2/10] Port of bcm43xx from softmac to mac80211
Message-ID: <46b1fded.0g4ZHvU7XwSzeJVs%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This if file 2 of 10 of the port of the bcm43xx driver from softmac
to mac80211.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_debugfs.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_debugfs.c
+++ linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_debugfs.c
@@ -4,7 +4,7 @@
 
   debugfs driver debugging code
 
-  Copyright (c) 2005 Michael Buesch <mbuesch@freenet.de>
+  Copyright (c) 2005 Michael Buesch <mb@bu3sch.de>
 
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
@@ -30,7 +30,7 @@
 #include <linux/slab.h>
 #include <linux/netdevice.h>
 #include <linux/pci.h>
-#include <asm/io.h>
+#include <linux/mutex.h>
 
 #include "bcm43xx.h"
 #include "bcm43xx_main.h"
@@ -42,8 +42,8 @@
 #define REALLY_BIG_BUFFER_SIZE	(1024*256)
 
 static struct bcm43xx_debugfs fs;
-static char really_big_buffer[REALLY_BIG_BUFFER_SIZE];
-static DECLARE_MUTEX(big_buffer_sem);
+static char big_buffer[1024*256];
+static DEFINE_MUTEX(big_buffer_mutex);
 
 
 static ssize_t write_file_dummy(struct file *file, const char __user *buf,
@@ -60,440 +60,368 @@ static int open_file_generic(struct inod
 
 #define fappend(fmt, x...)	pos += snprintf(buf + pos, len - pos, fmt , ##x)
 
-static ssize_t devinfo_read_file(struct file *file, char __user *userbuf,
-				 size_t count, loff_t *ppos)
-{
-	const size_t len = REALLY_BIG_BUFFER_SIZE;
-
-	struct bcm43xx_private *bcm = file->private_data;
-	char *buf = really_big_buffer;
-	size_t pos = 0;
-	ssize_t res;
-	struct net_device *net_dev;
-	struct pci_dev *pci_dev;
-	unsigned long flags;
-	u16 tmp16;
-	int i;
-
-	down(&big_buffer_sem);
-
-	mutex_lock(&bcm->mutex);
-	spin_lock_irqsave(&bcm->irq_lock, flags);
-	if (bcm43xx_status(bcm) != BCM43xx_STAT_INITIALIZED) {
-		fappend("Board not initialized.\n");
-		goto out;
-	}
-	net_dev = bcm->net_dev;
-	pci_dev = bcm->pci_dev;
-
-	/* This is where the information is written to the "devinfo" file */
-	fappend("*** %s devinfo ***\n", net_dev->name);
-	fappend("vendor:           0x%04x   device:           0x%04x\n",
-		pci_dev->vendor, pci_dev->device);
-	fappend("subsystem_vendor: 0x%04x   subsystem_device: 0x%04x\n",
-		pci_dev->subsystem_vendor, pci_dev->subsystem_device);
-	fappend("IRQ: %d\n", bcm->irq);
-	fappend("mmio_addr: 0x%p\n", bcm->mmio_addr);
-	fappend("chip_id: 0x%04x   chip_rev: 0x%02x\n", bcm->chip_id, bcm->chip_rev);
-	if ((bcm->core_80211[0].rev >= 3) && (bcm43xx_read32(bcm, 0x0158) & (1 << 16)))
-		fappend("Radio disabled by hardware!\n");
-	if ((bcm->core_80211[0].rev < 3) && !(bcm43xx_read16(bcm, 0x049A) & (1 << 4)))
-		fappend("Radio disabled by hardware!\n");
-	fappend("board_vendor: 0x%04x   board_type: 0x%04x\n", bcm->board_vendor,
-	        bcm->board_type);
-
-	fappend("\nCores:\n");
-#define fappend_core(name, info) fappend("core \"" name "\" %s, %s, id: 0x%04x, "	\
-					 "rev: 0x%02x, index: 0x%02x\n",		\
-					 (info).available				\
-						? "available" : "nonavailable",		\
-					 (info).enabled					\
-						? "enabled" : "disabled",		\
-					 (info).id, (info).rev, (info).index)
-	fappend_core("CHIPCOMMON", bcm->core_chipcommon);
-	fappend_core("PCI", bcm->core_pci);
-	fappend_core("first 80211", bcm->core_80211[0]);
-	fappend_core("second 80211", bcm->core_80211[1]);
-#undef fappend_core
-	tmp16 = bcm43xx_read16(bcm, BCM43xx_MMIO_GPIO_CONTROL);
-	fappend("LEDs: ");
-	for (i = 0; i < BCM43xx_NR_LEDS; i++)
-		fappend("%d ", !!(tmp16 & (1 << i)));
-	fappend("\n");
-
-out:
-	spin_unlock_irqrestore(&bcm->irq_lock, flags);
-	mutex_unlock(&bcm->mutex);
-	res = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
-	up(&big_buffer_sem);
-	return res;
-}
-
 static ssize_t drvinfo_read_file(struct file *file, char __user *userbuf,
 				 size_t count, loff_t *ppos)
 {
-	const size_t len = REALLY_BIG_BUFFER_SIZE;
-
-	char *buf = really_big_buffer;
+	const size_t len = ARRAY_SIZE(big_buffer);
+	char *buf = big_buffer;
 	size_t pos = 0;
 	ssize_t res;
 
-	down(&big_buffer_sem);
-
+	mutex_lock(&big_buffer_mutex);
 	/* This is where the information is written to the "driver" file */
 	fappend(KBUILD_MODNAME " driver\n");
 	fappend("Compiled at: %s %s\n", __DATE__, __TIME__);
-
 	res = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
-	up(&big_buffer_sem);
-	return res;
-}
-
-static ssize_t spromdump_read_file(struct file *file, char __user *userbuf,
-				 size_t count, loff_t *ppos)
-{
-	const size_t len = REALLY_BIG_BUFFER_SIZE;
-
-	struct bcm43xx_private *bcm = file->private_data;
-	char *buf = really_big_buffer;
-	size_t pos = 0;
-	ssize_t res;
-	unsigned long flags;
-
-	down(&big_buffer_sem);
-	mutex_lock(&bcm->mutex);
-	spin_lock_irqsave(&bcm->irq_lock, flags);
-	if (bcm43xx_status(bcm) != BCM43xx_STAT_INITIALIZED) {
-		fappend("Board not initialized.\n");
-		goto out;
-	}
+	mutex_unlock(&big_buffer_mutex);
 
-	/* This is where the information is written to the "sprom_dump" file */
-	fappend("boardflags: 0x%04x\n", bcm->sprom.boardflags);
-
-out:
-	spin_unlock_irqrestore(&bcm->irq_lock, flags);
-	mutex_unlock(&bcm->mutex);
-	res = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
-	up(&big_buffer_sem);
 	return res;
 }
 
 static ssize_t tsf_read_file(struct file *file, char __user *userbuf,
 			     size_t count, loff_t *ppos)
 {
-	const size_t len = REALLY_BIG_BUFFER_SIZE;
-
-	struct bcm43xx_private *bcm = file->private_data;
-	char *buf = really_big_buffer;
+	struct bcm43xx_wldev *dev = file->private_data;
+	const size_t len = ARRAY_SIZE(big_buffer);
+	char *buf = big_buffer;
 	size_t pos = 0;
 	ssize_t res;
 	unsigned long flags;
 	u64 tsf;
 
-	down(&big_buffer_sem);
-	mutex_lock(&bcm->mutex);
-	spin_lock_irqsave(&bcm->irq_lock, flags);
-	if (bcm43xx_status(bcm) != BCM43xx_STAT_INITIALIZED) {
+	mutex_lock(&big_buffer_mutex);
+	mutex_lock(&dev->wl->mutex);
+	spin_lock_irqsave(&dev->wl->irq_lock, flags);
+	if (bcm43xx_status(dev) < BCM43xx_STAT_STARTED) {
 		fappend("Board not initialized.\n");
 		goto out;
 	}
-	bcm43xx_tsf_read(bcm, &tsf);
+	bcm43xx_tsf_read(dev, &tsf);
 	fappend("0x%08x%08x\n",
 		(unsigned int)((tsf & 0xFFFFFFFF00000000ULL) >> 32),
 		(unsigned int)(tsf & 0xFFFFFFFFULL));
 
 out:
-	spin_unlock_irqrestore(&bcm->irq_lock, flags);
-	mutex_unlock(&bcm->mutex);
+	spin_unlock_irqrestore(&dev->wl->irq_lock, flags);
+	mutex_unlock(&dev->wl->mutex);
 	res = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
-	up(&big_buffer_sem);
+	mutex_unlock(&big_buffer_mutex);
+
 	return res;
 }
 
 static ssize_t tsf_write_file(struct file *file, const char __user *user_buf,
 			      size_t count, loff_t *ppos)
 {
-	struct bcm43xx_private *bcm = file->private_data;
-	char *buf = really_big_buffer;
+	struct bcm43xx_wldev *dev = file->private_data;
+	char *buf = big_buffer;
 	ssize_t buf_size;
 	ssize_t res;
 	unsigned long flags;
 	u64 tsf;
 
-	buf_size = min(count, sizeof (really_big_buffer) - 1);
-	down(&big_buffer_sem);
+	mutex_lock(&big_buffer_mutex);
+	buf_size = min(count, ARRAY_SIZE(big_buffer) - 1);
 	if (copy_from_user(buf, user_buf, buf_size)) {
 	        res = -EFAULT;
-		goto out_up;
+		goto out_unlock_bb;
 	}
-	mutex_lock(&bcm->mutex);
-	spin_lock_irqsave(&bcm->irq_lock, flags);
-	if (bcm43xx_status(bcm) != BCM43xx_STAT_INITIALIZED) {
-		printk(KERN_INFO PFX "debugfs: Board not initialized.\n");
+	mutex_lock(&dev->wl->mutex);
+	spin_lock_irqsave(&dev->wl->irq_lock, flags);
+	if (bcm43xx_status(dev) < BCM43xx_STAT_STARTED) {
+		bcmerr(dev->wl, "debugfs: Board not initialized.\n");
 		res = -EFAULT;
 		goto out_unlock;
 	}
-	if (sscanf(buf, "%lli", &tsf) != 1) {
-		printk(KERN_INFO PFX "debugfs: invalid values for \"tsf\"\n");
+	if (sscanf(buf, "%llu", (unsigned long long *)(&tsf)) != 1) {
+		bcmerr(dev->wl, "debugfs: invalid values for \"tsf\"\n");
 		res = -EINVAL;
 		goto out_unlock;
 	}
-	bcm43xx_tsf_write(bcm, tsf);
+	bcm43xx_tsf_write(dev, tsf);
 	mmiowb();
 	res = buf_size;
-	
+
 out_unlock:
-	spin_unlock_irqrestore(&bcm->irq_lock, flags);
-	mutex_unlock(&bcm->mutex);
-out_up:
-	up(&big_buffer_sem);
+	spin_unlock_irqrestore(&dev->wl->irq_lock, flags);
+	mutex_unlock(&dev->wl->mutex);
+out_unlock_bb:
+	mutex_unlock(&big_buffer_mutex);
+
 	return res;
 }
 
 static ssize_t txstat_read_file(struct file *file, char __user *userbuf,
 				size_t count, loff_t *ppos)
 {
-	const size_t len = REALLY_BIG_BUFFER_SIZE;
-
-	struct bcm43xx_private *bcm = file->private_data;
-	char *buf = really_big_buffer;
+	struct bcm43xx_wldev *dev = file->private_data;
+	struct bcm43xx_dfsentry *e = dev->dfsentry;
+	struct bcm43xx_txstatus_log *log = &e->txstatlog;
+	unsigned long flags;
+	char *buf = log->printbuf;
+	const size_t len = ARRAY_SIZE(log->printbuf);
 	size_t pos = 0;
 	ssize_t res;
-	unsigned long flags;
-	struct bcm43xx_dfsentry *e;
-	struct bcm43xx_xmitstatus *status;
-	int i, cnt, j = 0;
+	int i;
+	int idx;
+	struct bcm43xx_txstatus *stat;
 
-	down(&big_buffer_sem);
-	mutex_lock(&bcm->mutex);
-	spin_lock_irqsave(&bcm->irq_lock, flags);
-
-	fappend("Last %d logged xmitstatus blobs (Latest first):\n\n",
-		BCM43xx_NR_LOGGED_XMITSTATUS);
-	e = bcm->dfsentry;
-	if (e->xmitstatus_printing == 0) {
-		/* At the beginning, make a copy of all data to avoid
-		 * concurrency, as this function is called multiple
-		 * times for big logs. Without copying, the data might
-		 * change between reads. This would result in total trash.
-		 */
-		e->xmitstatus_printing = 1;
-		e->saved_xmitstatus_ptr = e->xmitstatus_ptr;
-		e->saved_xmitstatus_cnt = e->xmitstatus_cnt;
-		memcpy(e->xmitstatus_print_buffer, e->xmitstatus_buffer,
-		       BCM43xx_NR_LOGGED_XMITSTATUS * sizeof(*(e->xmitstatus_buffer)));
-	}
-	i = e->saved_xmitstatus_ptr - 1;
-	if (i < 0)
-		i = BCM43xx_NR_LOGGED_XMITSTATUS - 1;
-	cnt = e->saved_xmitstatus_cnt;
-	while (cnt) {
-		status = e->xmitstatus_print_buffer + i;
-		fappend("0x%02x:   cookie: 0x%04x,  flags: 0x%02x,  "
-			"cnt1: 0x%02x,  cnt2: 0x%02x,  seq: 0x%04x,  "
-			"unk: 0x%04x\n", j,
-			status->cookie, status->flags,
-			status->cnt1, status->cnt2, status->seq,
-			status->unknown);
-		j++;
-		cnt--;
-		i--;
-		if (i < 0)
-			i = BCM43xx_NR_LOGGED_XMITSTATUS - 1;
+	mutex_lock(&big_buffer_mutex);
+	spin_lock_irqsave(&log->lock, flags);
+	if (!log->printing) {
+		log->printing = 1;
+		fappend("bcm43xx TX status reports:\n\n"
+			"index | cookie | seq | phy_stat | frame_count | "
+			"rts_count | supp_reason | pm_indicated | "
+			"intermediate | for_ampdu | acked\n"
+			"---\n");
+		i = log->end + 1;
+		idx = 0;
+		while (1) {
+			if (i == BCM43xx_NR_LOGGED_TXSTATUS)
+				i = 0;
+			stat = &(log->log[i]);
+			if (stat->cookie) {
+				fappend("%03d | "
+					"0x%04X | 0x%04X | 0x%02X | "
+					"0x%X | 0x%X | "
+					"%u | %u | "
+					"%u | %u | %u\n",
+					idx,
+					stat->cookie, stat->seq, stat->phy_stat,
+					stat->frame_count, stat->rts_count,
+					stat->supp_reason, stat->pm_indicated,
+					stat->intermediate, stat->for_ampdu,
+					stat->acked);
+				idx++;
+			}
+			if (i == log->end)
+				break;
+			i++;
+		}
+		log->buf_avail = pos;
 	}
+	memcpy(big_buffer, buf,
+	       min(log->buf_avail, ARRAY_SIZE(big_buffer)));
+	spin_unlock_irqrestore(&log->lock, flags);
+
+	res = simple_read_from_buffer(userbuf, count, ppos,
+				      big_buffer,
+				      log->buf_avail);
+	if (*ppos == log->buf_avail) {
+		spin_lock_irqsave(&log->lock, flags);
+		log->printing = 0;
+		spin_unlock_irqrestore(&log->lock, flags);
+	}
+	mutex_unlock(&big_buffer_mutex);
 
-	spin_unlock_irqrestore(&bcm->irq_lock, flags);
-	res = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
-	spin_lock_irqsave(&bcm->irq_lock, flags);
-	if (*ppos == pos) {
-		/* Done. Drop the copied data. */
-		e->xmitstatus_printing = 0;
-	}
-	spin_unlock_irqrestore(&bcm->irq_lock, flags);
-	mutex_unlock(&bcm->mutex);
-	up(&big_buffer_sem);
 	return res;
 }
 
 static ssize_t restart_write_file(struct file *file, const char __user *user_buf,
 				  size_t count, loff_t *ppos)
 {
-	struct bcm43xx_private *bcm = file->private_data;
-	char *buf = really_big_buffer;
+	struct bcm43xx_wldev *dev = file->private_data;
+	char *buf = big_buffer;
 	ssize_t buf_size;
 	ssize_t res;
 	unsigned long flags;
 
-	buf_size = min(count, sizeof (really_big_buffer) - 1);
-	down(&big_buffer_sem);
+	mutex_lock(&big_buffer_mutex);
+	buf_size = min(count, ARRAY_SIZE(big_buffer) - 1);
 	if (copy_from_user(buf, user_buf, buf_size)) {
 	        res = -EFAULT;
-		goto out_up;
+		goto out_unlock_bb;
 	}
-	mutex_lock(&(bcm)->mutex);
-	spin_lock_irqsave(&(bcm)->irq_lock, flags);
-	if (bcm43xx_status(bcm) != BCM43xx_STAT_INITIALIZED) {
-		printk(KERN_INFO PFX "debugfs: Board not initialized.\n");
+	mutex_lock(&dev->wl->mutex);
+	spin_lock_irqsave(&dev->wl->irq_lock, flags);
+	if (bcm43xx_status(dev) < BCM43xx_STAT_INITIALIZED) {
+		bcmerr(dev->wl, "debugfs: Board not initialized.\n");
 		res = -EFAULT;
 		goto out_unlock;
 	}
 	if (count > 0 && buf[0] == '1') {
-		bcm43xx_controller_restart(bcm, "manually restarted");
+		bcm43xx_controller_restart(dev, "manually restarted");
 		res = count;
-	} else
+	} else {
 		res = -EINVAL;
+	}
 
 out_unlock:
-	spin_unlock_irqrestore(&(bcm)->irq_lock, flags);
-	mutex_unlock(&(bcm)->mutex);
-out_up:
-	up(&big_buffer_sem);
+	spin_unlock_irqrestore(&dev->wl->irq_lock, flags);
+	mutex_unlock(&dev->wl->mutex);
+out_unlock_bb:
+	mutex_unlock(&big_buffer_mutex);
+
 	return res;
 }
 
 #undef fappend
 
 
-static const struct file_operations devinfo_fops = {
-	.read = devinfo_read_file,
-	.write = write_file_dummy,
-	.open = open_file_generic,
-};
-
-static const struct file_operations spromdump_fops = {
-	.read = spromdump_read_file,
-	.write = write_file_dummy,
-	.open = open_file_generic,
-};
-
-static const struct file_operations drvinfo_fops = {
+static struct file_operations drvinfo_fops = {
 	.read = drvinfo_read_file,
 	.write = write_file_dummy,
 	.open = open_file_generic,
 };
 
-static const struct file_operations tsf_fops = {
+static struct file_operations tsf_fops = {
 	.read = tsf_read_file,
 	.write = tsf_write_file,
 	.open = open_file_generic,
 };
 
-static const struct file_operations txstat_fops = {
+static struct file_operations txstat_fops = {
 	.read = txstat_read_file,
 	.write = write_file_dummy,
 	.open = open_file_generic,
 };
 
-static const struct file_operations restart_fops = {
+static struct file_operations restart_fops = {
 	.write = restart_write_file,
 	.open = open_file_generic,
 };
 
 
-void bcm43xx_debugfs_add_device(struct bcm43xx_private *bcm)
+int bcm43xx_debug(struct bcm43xx_wldev *dev, enum bcm43xx_dyndbg feature)
+{
+	return !!(dev->dfsentry->dyn_debug[feature]);
+}
+
+static void bcm43xx_remove_dynamic_debug(struct bcm43xx_wldev *dev)
+{
+	struct bcm43xx_dfsentry *e = dev->dfsentry;
+	int i;
+
+	for (i = 0; i < __BCM43xx_NR_DYNDBG; i++)
+		debugfs_remove(e->dyn_debug_dentries[i]);
+}
+
+static void bcm43xx_add_dynamic_debug(struct bcm43xx_wldev *dev)
+{
+	struct bcm43xx_dfsentry *e = dev->dfsentry;
+	struct dentry *d;
+
+#define add_dyn_dbg(name, id, initstate) do {		\
+	e->dyn_debug[id] = (initstate);			\
+	d = debugfs_create_bool(name, 0600, e->subdir,	\
+				&(e->dyn_debug[id]));	\
+	if (!IS_ERR(d))					\
+		e->dyn_debug_dentries[id] = d;		\
+				} while (0)
+
+	add_dyn_dbg("debug_xmitpower", BCM43xx_DBG_XMITPOWER, 0);
+	add_dyn_dbg("debug_dmaoverflow", BCM43xx_DBG_DMAOVERFLOW, 0);
+	add_dyn_dbg("debug_dmaverbose", BCM43xx_DBG_DMAVERBOSE, 0);
+	add_dyn_dbg("debug_pwork_fast", BCM43xx_DBG_PWORK_FAST, 0);
+	add_dyn_dbg("debug_pwork_stop", BCM43xx_DBG_PWORK_STOP, 0);
+
+#undef add_dyn_dbg
+}
+
+void bcm43xx_debugfs_add_device(struct bcm43xx_wldev *dev)
 {
 	struct bcm43xx_dfsentry *e;
-	char devdir[IFNAMSIZ];
+	struct bcm43xx_txstatus_log *log;
+	char devdir[16];
 
-	assert(bcm);
+	BCM43xx_BUG_ON(!dev);
 	e = kzalloc(sizeof(*e), GFP_KERNEL);
 	if (!e) {
-		printk(KERN_ERR PFX "out of memory\n");
+		bcmerr(dev->wl, "debugfs: add device OOM\n");
 		return;
 	}
-	e->bcm = bcm;
-	e->xmitstatus_buffer = kzalloc(BCM43xx_NR_LOGGED_XMITSTATUS
-				       * sizeof(*(e->xmitstatus_buffer)),
-				       GFP_KERNEL);
-	if (!e->xmitstatus_buffer) {
-		printk(KERN_ERR PFX "out of memory\n");
+	e->dev = dev;
+	log = &e->txstatlog;
+	log->log = kcalloc(BCM43xx_NR_LOGGED_TXSTATUS,
+			   sizeof(struct bcm43xx_txstatus),
+			   GFP_KERNEL);
+	if (!log->log) {
+		bcmerr(dev->wl, "debugfs: add device txstatus OOM\n");
 		kfree(e);
 		return;
 	}
-	e->xmitstatus_print_buffer = kzalloc(BCM43xx_NR_LOGGED_XMITSTATUS
-					     * sizeof(*(e->xmitstatus_buffer)),
-					     GFP_KERNEL);
-	if (!e->xmitstatus_print_buffer) {
-		printk(KERN_ERR PFX "out of memory\n");
+	log->end = -1;
+	spin_lock_init(&log->lock);
+
+	dev->dfsentry = e;
+
+	snprintf(devdir, sizeof(devdir), "%s", wiphy_name(dev->wl->hw->wiphy));
+	e->subdir = debugfs_create_dir(devdir, fs.root);
+	if (!e->subdir || IS_ERR(e->subdir)) {
+		e->subdir = NULL;
+		kfree(log->log);
 		kfree(e);
 		return;
 	}
 
+	e->dentry_tsf = debugfs_create_file("tsf", 0600, e->subdir,
+					     dev, &tsf_fops);
+	if (IS_ERR(e->dentry_tsf))
+		e->dentry_tsf = NULL;
+	e->dentry_txstat = debugfs_create_file("tx_status", 0400, e->subdir,
+						dev, &txstat_fops);
+	if (IS_ERR(e->dentry_txstat))
+		e->dentry_txstat = NULL;
+	e->dentry_restart = debugfs_create_file("restart", 0200, e->subdir,
+						dev, &restart_fops);
+	if (IS_ERR(e->dentry_restart))
+		e->dentry_restart = NULL;
 
-	bcm->dfsentry = e;
-
-	strncpy(devdir, bcm->net_dev->name, ARRAY_SIZE(devdir));
-	e->subdir = debugfs_create_dir(devdir, fs.root);
-	e->dentry_devinfo = debugfs_create_file("devinfo", 0444, e->subdir,
-						bcm, &devinfo_fops);
-	if (!e->dentry_devinfo)
-		printk(KERN_ERR PFX "debugfs: creating \"devinfo\" for \"%s\" failed!\n", devdir);
-	e->dentry_spromdump = debugfs_create_file("sprom_dump", 0444, e->subdir,
-						  bcm, &spromdump_fops);
-	if (!e->dentry_spromdump)
-		printk(KERN_ERR PFX "debugfs: creating \"sprom_dump\" for \"%s\" failed!\n", devdir);
-	e->dentry_tsf = debugfs_create_file("tsf", 0666, e->subdir,
-	                                    bcm, &tsf_fops);
-	if (!e->dentry_tsf)
-		printk(KERN_ERR PFX "debugfs: creating \"tsf\" for \"%s\" failed!\n", devdir);
-	e->dentry_txstat = debugfs_create_file("tx_status", 0444, e->subdir,
-						bcm, &txstat_fops);
-	if (!e->dentry_txstat)
-		printk(KERN_ERR PFX "debugfs: creating \"tx_status\" for \"%s\" failed!\n", devdir);
-	e->dentry_restart = debugfs_create_file("restart", 0222, e->subdir,
-						bcm, &restart_fops);
-	if (!e->dentry_restart)
-		printk(KERN_ERR PFX "debugfs: creating \"restart\" for \"%s\" failed!\n", devdir);
+	bcm43xx_add_dynamic_debug(dev);
 }
 
-void bcm43xx_debugfs_remove_device(struct bcm43xx_private *bcm)
+void bcm43xx_debugfs_remove_device(struct bcm43xx_wldev *dev)
 {
 	struct bcm43xx_dfsentry *e;
 
-	if (!bcm)
+	if (!dev)
 		return;
 
-	e = bcm->dfsentry;
-	assert(e);
-	debugfs_remove(e->dentry_spromdump);
-	debugfs_remove(e->dentry_devinfo);
+	e = dev->dfsentry;
+	if (!e)
+		return;
+	bcm43xx_remove_dynamic_debug(dev);
 	debugfs_remove(e->dentry_tsf);
 	debugfs_remove(e->dentry_txstat);
 	debugfs_remove(e->dentry_restart);
 	debugfs_remove(e->subdir);
-	kfree(e->xmitstatus_buffer);
-	kfree(e->xmitstatus_print_buffer);
+	kfree(e->txstatlog.log);
 	kfree(e);
 }
 
-void bcm43xx_debugfs_log_txstat(struct bcm43xx_private *bcm,
-				struct bcm43xx_xmitstatus *status)
+void bcm43xx_debugfs_log_txstat(struct bcm43xx_wldev *dev,
+				const struct bcm43xx_txstatus *status)
 {
-	struct bcm43xx_dfsentry *e;
-	struct bcm43xx_xmitstatus *savedstatus;
+	struct bcm43xx_dfsentry *e = dev->dfsentry;
+	struct bcm43xx_txstatus_log *log;
+	struct bcm43xx_txstatus *cur;
+	int i;
 
-	/* This is protected by bcm->_lock */
-	e = bcm->dfsentry;
-	assert(e);
-	savedstatus = e->xmitstatus_buffer + e->xmitstatus_ptr;
-	memcpy(savedstatus, status, sizeof(*status));
-	e->xmitstatus_ptr++;
-	if (e->xmitstatus_ptr >= BCM43xx_NR_LOGGED_XMITSTATUS)
-		e->xmitstatus_ptr = 0;
-	if (e->xmitstatus_cnt < BCM43xx_NR_LOGGED_XMITSTATUS)
-		e->xmitstatus_cnt++;
+	log = &e->txstatlog;
+	BCM43xx_WARN_ON(!irqs_disabled());
+	spin_lock(&log->lock);
+	i = log->end + 1;
+	if (i == BCM43xx_NR_LOGGED_TXSTATUS)
+		i = 0;
+	log->end = i;
+	cur = &(log->log[i]);
+	memcpy(cur, status, sizeof(*cur));
+	spin_unlock(&log->lock);
 }
 
 void bcm43xx_debugfs_init(void)
 {
 	memset(&fs, 0, sizeof(fs));
 	fs.root = debugfs_create_dir(KBUILD_MODNAME, NULL);
-	if (!fs.root)
-		printk(KERN_ERR PFX "debugfs: creating \"" KBUILD_MODNAME "\" subdir failed!\n");
-	fs.dentry_driverinfo = debugfs_create_file("driver", 0444, fs.root, NULL, &drvinfo_fops);
-	if (!fs.dentry_driverinfo)
-		printk(KERN_ERR PFX "debugfs: creating \"" KBUILD_MODNAME "/driver\" failed!\n");
+	if (!fs.root || IS_ERR(fs.root)) {
+		fs.root = NULL;
+		return;
+	}
+	fs.dentry_driverinfo = debugfs_create_file("driver", 0444, fs.root,
+						   NULL, &drvinfo_fops);
+	if (IS_ERR(fs.dentry_driverinfo))
+		fs.dentry_driverinfo = NULL;
 }
 
 void bcm43xx_debugfs_exit(void)
@@ -501,56 +429,3 @@ void bcm43xx_debugfs_exit(void)
 	debugfs_remove(fs.dentry_driverinfo);
 	debugfs_remove(fs.root);
 }
-
-void bcm43xx_printk_dump(const char *data,
-			 size_t size,
-			 const char *description)
-{
-	size_t i;
-	char c;
-
-	printk(KERN_INFO PFX "Data dump (%s, %zd bytes):",
-	       description, size);
-	for (i = 0; i < size; i++) {
-		c = data[i];
-		if (i % 8 == 0)
-			printk("\n" KERN_INFO PFX "0x%08zx:  0x%02x, ", i, c & 0xff);
-		else
-			printk("0x%02x, ", c & 0xff);
-	}
-	printk("\n");
-}
-
-void bcm43xx_printk_bitdump(const unsigned char *data,
-			    size_t bytes, int msb_to_lsb,
-			    const char *description)
-{
-	size_t i;
-	int j;
-	const unsigned char *d;
-
-	printk(KERN_INFO PFX "*** Bitdump (%s, %zd bytes, %s) ***",
-	       description, bytes, msb_to_lsb ? "MSB to LSB" : "LSB to MSB");
-	for (i = 0; i < bytes; i++) {
-		d = data + i;
-		if (i % 8 == 0)
-			printk("\n" KERN_INFO PFX "0x%08zx:  ", i);
-		if (msb_to_lsb) {
-			for (j = 7; j >= 0; j--) {
-				if (*d & (1 << j))
-					printk("1");
-				else
-					printk("0");
-			}
-		} else {
-			for (j = 0; j < 8; j++) {
-				if (*d & (1 << j))
-					printk("1");
-				else
-					printk("0");
-			}
-		}
-		printk(" ");
-	}
-	printk("\n");
-}
Index: linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_debugfs.h
===================================================================
--- linux-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_debugfs.h
+++ linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_debugfs.h
@@ -1,41 +1,48 @@
 #ifndef BCM43xx_DEBUGFS_H_
 #define BCM43xx_DEBUGFS_H_
 
-struct bcm43xx_private;
-struct bcm43xx_xmitstatus;
+struct bcm43xx_wldev;
+struct bcm43xx_txstatus;
 
-#ifdef CONFIG_BCM43XX_DEBUG
+enum bcm43xx_dyndbg { /* Dynamic debugging features */
+	BCM43xx_DBG_XMITPOWER,
+	BCM43xx_DBG_DMAOVERFLOW,
+	BCM43xx_DBG_DMAVERBOSE,
+	BCM43xx_DBG_PWORK_FAST,
+	BCM43xx_DBG_PWORK_STOP,
+	__BCM43xx_NR_DYNDBG,
+};
 
-#include <linux/list.h>
-#include <asm/semaphore.h>
+
+#ifdef CONFIG_BCM43XX_DEBUG
 
 struct dentry;
 
-/* limited by the size of the "really_big_buffer" */
-#define BCM43xx_NR_LOGGED_XMITSTATUS	100
+#define BCM43xx_NR_LOGGED_TXSTATUS	100
+
+struct bcm43xx_txstatus_log {
+	struct bcm43xx_txstatus *log;
+	int end;
+	int printing;
+	char printbuf[(BCM43xx_NR_LOGGED_TXSTATUS * 70) + 200];
+	size_t buf_avail;
+	spinlock_t lock;	/* lock for debugging */
+};
 
 struct bcm43xx_dfsentry {
 	struct dentry *subdir;
-	struct dentry *dentry_devinfo;
-	struct dentry *dentry_spromdump;
 	struct dentry *dentry_tsf;
 	struct dentry *dentry_txstat;
 	struct dentry *dentry_restart;
 
-	struct bcm43xx_private *bcm;
+	struct bcm43xx_wldev *dev;
+
+	struct bcm43xx_txstatus_log txstatlog;
 
-	/* saved xmitstatus. */
-	struct bcm43xx_xmitstatus *xmitstatus_buffer;
-	int xmitstatus_ptr;
-	int xmitstatus_cnt;
-	/* We need a seperate buffer while printing to avoid
-	 * concurrency issues. (New xmitstatus can arrive
-	 * while we are printing).
-	 */
-	struct bcm43xx_xmitstatus *xmitstatus_print_buffer;
-	int saved_xmitstatus_ptr;
-	int saved_xmitstatus_cnt;
-	int xmitstatus_printing;
+	/* Enabled/Disabled list for the dynamic debugging features. */
+	u32 dyn_debug[__BCM43xx_NR_DYNDBG];
+	/* Dentries for the dynamic debugging entries. */
+	struct dentry *dyn_debug_dentries[__BCM43xx_NR_DYNDBG];
 };
 
 struct bcm43xx_debugfs {
@@ -43,76 +50,35 @@ struct bcm43xx_debugfs {
 	struct dentry *dentry_driverinfo;
 };
 
+int bcm43xx_debug(struct bcm43xx_wldev *dev, enum bcm43xx_dyndbg feature);
+
 void bcm43xx_debugfs_init(void);
 void bcm43xx_debugfs_exit(void);
-void bcm43xx_debugfs_add_device(struct bcm43xx_private *bcm);
-void bcm43xx_debugfs_remove_device(struct bcm43xx_private *bcm);
-void bcm43xx_debugfs_log_txstat(struct bcm43xx_private *bcm,
-				struct bcm43xx_xmitstatus *status);
-
-/* Debug helper: Dump binary data through printk. */
-void bcm43xx_printk_dump(const char *data,
-			 size_t size,
-			 const char *description);
-/* Debug helper: Dump bitwise binary data through printk. */
-void bcm43xx_printk_bitdump(const unsigned char *data,
-			    size_t bytes, int msb_to_lsb,
-			    const char *description);
-#define bcm43xx_printk_bitdumpt(pointer, msb_to_lsb, description) \
-	do {									\
-		bcm43xx_printk_bitdump((const unsigned char *)(pointer),	\
-				       sizeof(*(pointer)),			\
-				       (msb_to_lsb),				\
-				       (description));				\
-	} while (0)
+void bcm43xx_debugfs_add_device(struct bcm43xx_wldev *dev);
+void bcm43xx_debugfs_remove_device(struct bcm43xx_wldev *dev);
+void bcm43xx_debugfs_log_txstat(struct bcm43xx_wldev *dev,
+				const struct bcm43xx_txstatus *status);
 
 #else /* CONFIG_BCM43XX_DEBUG*/
 
 static inline
+int bcm43xx_debug(struct bcm43xx_wldev *dev, enum bcm43xx_dyndbg feature)
+{
+	return 0;
+}
+
+static inline
 void bcm43xx_debugfs_init(void) { }
 static inline
 void bcm43xx_debugfs_exit(void) { }
 static inline
-void bcm43xx_debugfs_add_device(struct bcm43xx_private *bcm) { }
-static inline
-void bcm43xx_debugfs_remove_device(struct bcm43xx_private *bcm) { }
-static inline
-void bcm43xx_debugfs_log_txstat(struct bcm43xx_private *bcm,
-				struct bcm43xx_xmitstatus *status) { }
-
+void bcm43xx_debugfs_add_device(struct bcm43xx_wldev *dev) { }
 static inline
-void bcm43xx_printk_dump(const char *data,
-			 size_t size,
-			 const char *description)
-{
-}
+void bcm43xx_debugfs_remove_device(struct bcm43xx_wldev *dev) { }
 static inline
-void bcm43xx_printk_bitdump(const unsigned char *data,
-			    size_t bytes, int msb_to_lsb,
-			    const char *description)
-{
-}
-#define bcm43xx_printk_bitdumpt(pointer, msb_to_lsb, description)  do { /* nothing */ } while (0)
+void bcm43xx_debugfs_log_txstat(struct bcm43xx_wldev *dev,
+				const struct bcm43xx_txstatus *status) { }
 
 #endif /* CONFIG_BCM43XX_DEBUG*/
 
-/* Ugly helper macros to make incomplete code more verbose on runtime */
-#ifdef TODO
-# undef TODO
-#endif
-#define TODO()  \
-	do {										\
-		printk(KERN_INFO PFX "TODO: Incomplete code in %s() at %s:%d\n",	\
-		       __FUNCTION__, __FILE__, __LINE__);				\
-	} while (0)
-
-#ifdef FIXME
-# undef FIXME
-#endif
-#define FIXME()  \
-	do {										\
-		printk(KERN_INFO PFX "FIXME: Possibly broken code in %s() at %s:%d\n",	\
-		       __FUNCTION__, __FILE__, __LINE__);				\
-	} while (0)
-
 #endif /* BCM43xx_DEBUGFS_H_ */

