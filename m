Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:19839 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366AbXIYSot convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2007 14:44:49 -0400
Received: by ug-out-1314.google.com with SMTP id z38so993626ugc
        for <linux-wireless@vger.kernel.org>; Tue, 25 Sep 2007 11:44:48 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 7/12] rt2x00: Add rt2x00dev->flags to debugfs
Date: Tue, 25 Sep 2007 20:56:13 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200709252052.34803.IvDoorn@gmail.com>
In-Reply-To: <200709252052.34803.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200709252056.13525.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From aff2d533a74a6346d704321ff87b8874353ed5fa Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Tue, 25 Sep 2007 20:13:51 +0200
Subject: [PATCH] rt2x00: Add rt2x00dev->flags to debugfs

Loosely based on the patch by Matthijs Kooijman,
this will add the dev_flags entry into debugfs which
will display rt2x00dev->flags.
This will allow easier debugging of flag handling.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00debug.c |   37 +++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
index 4d2aaec..9275d6f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -57,6 +57,7 @@ struct rt2x00debug_intf {
 	 * - driver folder
 	 * - driver file
 	 * - chipset file
+	 * - device flags file
 	 * - register offset/value files
 	 * - eeprom offset/value files
 	 * - bbp offset/value files
@@ -65,6 +66,7 @@ struct rt2x00debug_intf {
 	struct dentry *driver_folder;
 	struct dentry *driver_entry;
 	struct dentry *chipset_entry;
+	struct dentry *dev_flags;
 	struct dentry *csr_off_entry;
 	struct dentry *csr_val_entry;
 	struct dentry *eeprom_off_entry;
@@ -193,6 +195,34 @@ RT2X00DEBUGFS_OPS(eeprom, "0x%.4x\n", u16);
 RT2X00DEBUGFS_OPS(bbp, "0x%.2x\n", u8);
 RT2X00DEBUGFS_OPS(rf, "0x%.8x\n", u32);
 
+static ssize_t rt2x00debug_read_dev_flags(struct file *file,
+					  char __user *buf,
+					  size_t length,
+					  loff_t *offset)
+{
+	struct rt2x00debug_intf *intf =	file->private_data;
+	char line[16];
+	size_t size;
+
+	if (*offset)
+		return 0;
+
+	size = sprintf(line, "0x%.8x\n", (unsigned int)intf->rt2x00dev->flags);
+
+	if (copy_to_user(buf, line, size))
+		return -EFAULT;
+
+	*offset += size;
+	return size;
+}
+
+static const struct file_operations rt2x00debug_fop_dev_flags = {
+	.owner		= THIS_MODULE,
+	.read		= rt2x00debug_read_dev_flags,
+	.open		= rt2x00debug_file_open,
+	.release	= rt2x00debug_file_release,
+};
+
 static struct dentry *rt2x00debug_create_file_driver(const char *name,
 						     struct rt2x00debug_intf
 						     *intf,
@@ -270,6 +300,12 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 	if (IS_ERR(intf->chipset_entry))
 		goto exit;
 
+	intf->dev_flags = debugfs_create_file("dev_flags", S_IRUGO,
+					      intf->driver_folder, intf,
+					      &rt2x00debug_fop_dev_flags);
+	if (IS_ERR(intf->dev_flags))
+		goto exit;
+
 #define RT2X00DEBUGFS_CREATE_ENTRY(__intf, __name)		\
 ({								\
 	(__intf)->__name##_off_entry =				\
@@ -320,6 +356,7 @@ void rt2x00debug_deregister(struct rt2x00_dev *rt2x00dev)
 	debugfs_remove(intf->eeprom_off_entry);
 	debugfs_remove(intf->csr_val_entry);
 	debugfs_remove(intf->csr_off_entry);
+	debugfs_remove(intf->dev_flags);
 	debugfs_remove(intf->chipset_entry);
 	debugfs_remove(intf->driver_entry);
 	debugfs_remove(intf->driver_folder);
-- 
1.5.3.2

