Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.228]:7754 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756181AbYBKWKk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2008 17:10:40 -0500
Received: by wr-out-0506.google.com with SMTP id c48so4227642wra.23
        for <linux-wireless@vger.kernel.org>; Mon, 11 Feb 2008 14:10:38 -0800 (PST)
To: linux-wireless@vger.kernel.org
From: Javier Cardona <javier@cozybit.com>
Date: Mon, 11 Feb 2008 14:03:16 -0800
Subject: [PATCH v2] zd1211rw: debugfs access to internal device registers
Message-ID: <47b0c7db.16be600a.5533.50ad@mx.google.com> (sfid-20080211_221048_110421_A5179DAC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Expose the internal CR registers via debugfs, useful for driver development.
For example, to change the tx power for 54 Mbps frames (CR53):

<snip>
$ cd debugfs/ieee80211/phy0/registers
$ echo "53 3f" > wrcr
$ echo "11 4" > wrcr
$ echo "11 0" > wrcr
$ echo 53 > rdcr; cat rdcr;
CR53 [0x90d4] = 0x3f
</snip>

Corrected inaccurate comment:  UNLOCK_PHY_REGS needs to be unset also for read
access.

Changes from v1:

 * use the cfg80211 provided per-wiphy debugfs dir (thanks Johannes!)

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 drivers/net/wireless/zd1211rw/Makefile     |    1 +
 drivers/net/wireless/zd1211rw/zd_chip.h    |    5 +-
 drivers/net/wireless/zd1211rw/zd_debugfs.c |  187 ++++++++++++++++++++++++++++
 drivers/net/wireless/zd1211rw/zd_debugfs.h |    7 +
 drivers/net/wireless/zd1211rw/zd_usb.c     |    3 +
 5 files changed, 202 insertions(+), 1 deletions(-)
 create mode 100644 drivers/net/wireless/zd1211rw/zd_debugfs.c
 create mode 100644 drivers/net/wireless/zd1211rw/zd_debugfs.h

diff --git a/drivers/net/wireless/zd1211rw/Makefile b/drivers/net/wireless/zd1211rw/Makefile
index cc36126..6b83bbd 100644
--- a/drivers/net/wireless/zd1211rw/Makefile
+++ b/drivers/net/wireless/zd1211rw/Makefile
@@ -7,5 +7,6 @@ zd1211rw-objs := zd_chip.o zd_ieee80211.o zd_mac.o \
 
 ifeq ($(CONFIG_ZD1211RW_DEBUG),y)
 EXTRA_CFLAGS += -DDEBUG
+zd1211rw-objs += zd_debugfs.o 
 endif
 
diff --git a/drivers/net/wireless/zd1211rw/zd_chip.h b/drivers/net/wireless/zd1211rw/zd_chip.h
index e44b9d6..5cffbd6 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.h
+++ b/drivers/net/wireless/zd1211rw/zd_chip.h
@@ -504,7 +504,7 @@ enum {
 #define CR_ZD1211_RETRY_MAX		CTL_REG(0x067C)
 
 #define CR_REG1				CTL_REG(0x0680)
-/* Setting the bit UNLOCK_PHY_REGS disallows the write access to physical
+/* Setting the bit UNLOCK_PHY_REGS disallows access to physical
  * registers, so one could argue it is a LOCK bit. But calling it
  * LOCK_PHY_REGS makes it confusing.
  */
@@ -750,6 +750,9 @@ struct zd_chip {
 		patch_cck_gain:1, patch_cr157:1, patch_6m_band_edge:1,
 		new_phy_layout:1, al2230s_bit:1,
 		supports_tx_led:1;
+	struct dentry *debugfs_dir;
+	struct dentry *debugfs_files[4];
+	u32 debugfs_cr;
 };
 
 static inline struct zd_chip *zd_usb_to_chip(struct zd_usb *usb)
diff --git a/drivers/net/wireless/zd1211rw/zd_debugfs.c b/drivers/net/wireless/zd1211rw/zd_debugfs.c
new file mode 100644
index 0000000..b3ff4cb
--- /dev/null
+++ b/drivers/net/wireless/zd1211rw/zd_debugfs.c
@@ -0,0 +1,187 @@
+/* ZD1211 USB-WLAN driver for Linux
+ *
+ * Copyright (C) 2005-2007 Ulrich Kunitz <kune@deine-taler.de>
+ * Copyright (C) 2006-2007 Daniel Drake <dsd@gentoo.org>
+ * Copyright (C) 2006-2007 Michael Wu <flamingice@sourmilk.net>
+ * Copyright (c) 2007 Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+
+/*
+ * Added CR register access via debugfs
+ * Copyright (c) 2008 Javier Cardona <javier@cozybit.com>
+ */
+
+#include <linux/module.h>
+#include <linux/dcache.h>
+#include <linux/debugfs.h>
+#include <linux/delay.h>
+#include <linux/mm.h>
+#include <linux/string.h>
+#include <net/iw_handler.h>
+#include <net/mac80211.h>
+
+#include "zd_chip.h"
+
+static int open_file_generic(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+	return 0;
+}
+
+static const size_t len = PAGE_SIZE;
+
+static ssize_t zd_rdcr_read(struct file *file, char __user *userbuf,
+				  size_t count, loff_t *ppos)
+{
+	struct zd_chip *chip = file->private_data;
+	zd_addr_t regaddr;
+	u16 val;
+	ssize_t pos = 0;
+	int ret;
+	unsigned long addr = get_zeroed_page(GFP_KERNEL);
+	char *buf = (char *)addr;
+
+	regaddr = 0xffff & CTL_REG(chip->debugfs_cr << 2);
+	val = 0;
+
+	mutex_lock(&chip->mutex);
+	zd_chip_lock_phy_regs(chip);
+	ret = zd_ioread16_locked(chip, &val, regaddr);
+	zd_chip_unlock_phy_regs(chip);
+	mutex_unlock(&chip->mutex);
+
+	if (!ret)
+		pos += snprintf(buf+pos, len-pos, "CR%d [0x%x] = 0x%02x\n",
+				chip->debugfs_cr, regaddr, val);
+	else {
+		pos += snprintf(buf+pos, len-pos, "read error CR%d: %d\n",
+				chip->debugfs_cr, ret);
+		pos += snprintf(buf+pos, len-pos, "is interface up?\n");
+	}
+
+	ret = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
+	free_page(addr);
+	return ret;
+}
+
+static ssize_t zd_rdcr_write(struct file *file,
+				    const char __user *userbuf,
+				    size_t count, loff_t *ppos)
+{
+	struct zd_chip *chip = file->private_data;
+	ssize_t res, buf_size;
+	unsigned long addr = get_zeroed_page(GFP_KERNEL);
+	char *buf = (char *)addr;
+
+	buf_size = min(count, len - 1);
+	if (copy_from_user(buf, userbuf, buf_size)) {
+		res = -EFAULT;
+		goto out_unlock;
+	}
+	chip->debugfs_cr = simple_strtoul((char *)buf, NULL, 10);
+	res = count;
+out_unlock:
+	free_page(addr);
+	return res;
+}
+
+static ssize_t zd_wrcr_write(struct file *file,
+				    const char __user *userbuf,
+				    size_t count, loff_t *ppos)
+{
+
+	struct zd_chip *chip = file->private_data;
+	ssize_t res, buf_size;
+	u32 val;
+	u16 regaddr;
+	unsigned long addr = get_zeroed_page(GFP_KERNEL);
+	char *buf = (char *)addr;
+
+	buf_size = min(count, len - 1);
+	if (copy_from_user(buf, userbuf, buf_size)) {
+		res = -EFAULT;
+		goto out_unlock;
+	}
+	res = sscanf(buf, "%d %x", &chip->debugfs_cr, &val);
+	if (res != 2) {
+		res = -EFAULT;
+		goto out_unlock;
+	}
+
+	regaddr = 0xffff & CTL_REG(chip->debugfs_cr << 2);
+
+	mutex_lock(&chip->mutex);
+	zd_chip_lock_phy_regs(chip);
+	zd_iowrite16_locked(chip, val, regaddr);
+	zd_chip_unlock_phy_regs(chip);
+	mutex_unlock(&chip->mutex);
+
+	res = count;
+out_unlock:
+	free_page(addr);
+	return res;
+}
+
+#define FOPS(fread, fwrite) { \
+	.owner = THIS_MODULE, \
+	.open = open_file_generic, \
+	.read = (fread), \
+	.write = (fwrite), \
+}
+
+struct zd_debugfs_files {
+	char *name;
+	int perm;
+	struct file_operations fops;
+};
+
+/* check the size of chip->debugfs_files array before adding to this */
+static struct zd_debugfs_files debugfs_files[] = {
+	{ "rdcr", 0644, FOPS(zd_rdcr_read, zd_rdcr_write), },
+	{ "wrcr", 0600, FOPS(NULL, zd_wrcr_write), },
+};
+
+void zd_debugfs_init(struct zd_chip *chip, struct wiphy *wiphy)
+{
+	int i;
+	struct zd_debugfs_files *files;
+
+	chip->debugfs_dir = debugfs_create_dir("registers" , wiphy->debugfsdir);
+	if (!chip->debugfs_dir)
+		goto exit;
+
+	for (i = 0; i < ARRAY_SIZE(debugfs_files); i++) {
+		files = &debugfs_files[i];
+		chip->debugfs_files[i] = debugfs_create_file(files->name,
+				files->perm, chip->debugfs_dir, chip,
+				&files->fops);
+	}
+exit:
+	return;
+}
+EXPORT_SYMBOL(zd_debugfs_init);
+
+void zd_debugfs_remove(struct zd_chip *chip)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(debugfs_files); i++)
+		debugfs_remove(chip->debugfs_files[i]);
+
+	debugfs_remove(chip->debugfs_dir);
+}
+EXPORT_SYMBOL(zd_debugfs_remove);
diff --git a/drivers/net/wireless/zd1211rw/zd_debugfs.h b/drivers/net/wireless/zd1211rw/zd_debugfs.h
new file mode 100644
index 0000000..2cacf9f
--- /dev/null
+++ b/drivers/net/wireless/zd1211rw/zd_debugfs.h
@@ -0,0 +1,7 @@
+#ifndef _ZD_DEBUGFS_H_
+#define _ZD_DEBUGFS_H_
+
+void zd_debugfs_init(struct zd_chip *chip, struct wiphy *wiphy);
+void zd_debugfs_remove(struct zd_chip *chip);
+
+#endif
diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index e34675c..00a24e7 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -33,6 +33,7 @@
 #include "zd_def.h"
 #include "zd_mac.h"
 #include "zd_usb.h"
+#include "zd_debugfs.h"
 
 static struct usb_device_id usb_ids[] = {
 	/* ZD1211 */
@@ -1167,6 +1168,7 @@ static int probe(struct usb_interface *intf, const struct usb_device_id *id)
 			 "couldn't register device. Error number %d\n", r);
 		goto error;
 	}
+	zd_debugfs_init(&zd_hw_mac(hw)->chip, hw->wiphy);
 
 	dev_dbg_f(&intf->dev, "successful\n");
 	dev_info(&intf->dev, "%s\n", wiphy_name(hw->wiphy));
@@ -1196,6 +1198,7 @@ static void disconnect(struct usb_interface *intf)
 
 	dev_dbg_f(zd_usb_dev(usb), "\n");
 
+	zd_debugfs_remove(&mac->chip);
 	ieee80211_unregister_hw(hw);
 
 	/* Just in case something has gone wrong! */
-- 
1.5.2.4



