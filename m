Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:37448 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758666Ab3BNUJx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 15:09:53 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org, IvDoorn@gmail.com,
	gwingerde@gmail.com, helmut.schaa@googlemail.com
Cc: Solomon Peachy <speachy@sagrad.com>,
	Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH] rt2800usb: Add support for eeprom writes.
Date: Thu, 14 Feb 2013 15:09:40 -0500
Message-Id: <1360872580-24334-2-git-send-email-pizza@shaftnet.org> (sfid-20130214_210956_025336_92E83CA9)
In-Reply-To: <1360872580-24334-1-git-send-email-pizza@shaftnet.org>
References: <1360872580-24334-1-git-send-email-pizza@shaftnet.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Solomon Peachy <speachy@sagrad.com>

This adds another file under debugfs:

/debug/ieee80211/phyX/rt2800usb/register/eeprom_commit

reading from that file will re-read the eeprom data from device flash
writing to that file will store the current eeprom data to device flash.

Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
---
 .../drivers/net/wireless/rt2x00/rt2800lib.h        | 10 ++++++
 .../drivers/net/wireless/rt2x00/rt2800usb.c        |  8 ++++-
 .../drivers/net/wireless/rt2x00/rt2x00debug.c      | 40 ++++++++++++++++++++++
 .../drivers/net/wireless/rt2x00/rt2x00usb.h        | 19 ++++++++++
 4 files changed, 76 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless/rt2x00/rt2800lib.h
index a128cea..d653c09 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -44,6 +44,7 @@ struct rt2800_ops {
 			    const struct rt2x00_field32 field, u32 *reg);
 
 	void (*read_eeprom)(struct rt2x00_dev *rt2x00dev);
+	void (*write_eeprom)(struct rt2x00_dev *rt2x00dev);
 	bool (*hwcrypt_disabled)(struct rt2x00_dev *rt2x00dev);
 
 	int (*drv_write_firmware)(struct rt2x00_dev *rt2x00dev,
@@ -124,6 +125,15 @@ static inline void rt2800_read_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2800ops->read_eeprom(rt2x00dev);
 }
 
+static inline void rt2800_write_eeprom(struct rt2x00_dev *rt2x00dev)
+{
+	const struct rt2800_ops *rt2800ops = rt2x00dev->ops->drv;
+
+	if (rt2800ops->write_eeprom)
+		rt2800ops->write_eeprom(rt2x00dev);
+}
+
+
 static inline bool rt2800_hwcrypt_disabled(struct rt2x00_dev *rt2x00dev)
 {
 	const struct rt2800_ops *rt2800ops = rt2x00dev->ops->drv;
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 85a4b62..22d14d2 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -743,7 +743,12 @@ static void rt2800usb_read_eeprom(struct rt2x00_dev *rt2x00dev)
 		rt2x00usb_eeprom_read(rt2x00dev, rt2x00dev->eeprom,
 				      EEPROM_SIZE);
 }
-
+static void rt2800usb_write_eeprom(struct rt2x00_dev *rt2x00dev)
+{
+	if (!rt2800_efuse_detect(rt2x00dev))
+		rt2x00usb_eeprom_write(rt2x00dev, rt2x00dev->eeprom,
+				       EEPROM_SIZE);
+}
 static int rt2800usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
@@ -802,6 +807,7 @@ static const struct rt2800_ops rt2800usb_rt2800_ops = {
 	.register_multiwrite	= rt2x00usb_register_multiwrite,
 	.regbusy_read		= rt2x00usb_regbusy_read,
 	.read_eeprom		= rt2800usb_read_eeprom,
+	.write_eeprom		= rt2800usb_write_eeprom,
 	.hwcrypt_disabled	= rt2800usb_hwcrypt_disabled,
 	.drv_write_firmware	= rt2800usb_write_firmware,
 	.drv_init_registers	= rt2800usb_init_registers,
diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
index 3bb8caf..f6776b1 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -86,6 +86,7 @@ struct rt2x00debug_intf {
 	struct dentry *csr_val_entry;
 	struct dentry *eeprom_off_entry;
 	struct dentry *eeprom_val_entry;
+	struct dentry *eeprom_commit_entry;
 	struct dentry *bbp_off_entry;
 	struct dentry *bbp_val_entry;
 	struct dentry *rf_off_entry;
@@ -650,6 +651,37 @@ static struct dentry *rt2x00debug_create_file_chipset(const char *name,
 	return debugfs_create_blob(name, S_IRUSR, intf->driver_folder, blob);
 }
 
+#include "rt2800lib.h"
+static ssize_t rt2x00debug_eeprom_commit_write(struct file *file,
+					       const char __user *buf,
+					       size_t length,
+					       loff_t *offset)
+{
+	struct rt2x00debug_intf *intf = file->private_data;
+
+	rt2800_write_eeprom(intf->rt2x00dev);
+	return length;
+}
+static ssize_t rt2x00debug_eeprom_commit_read(struct file *file,
+					      char __user *buf,
+					      size_t length,
+					      loff_t *offset)
+{
+	struct rt2x00debug_intf *intf = file->private_data;
+
+	rt2800_read_eeprom(intf->rt2x00dev);
+	return 0;
+}
+
+static const struct file_operations rt2x00debug_fop_eeprom_commit = {
+	.owner		= THIS_MODULE,
+	.write		= rt2x00debug_eeprom_commit_write,
+	.read		= rt2x00debug_eeprom_commit_read,
+	.open		= rt2x00debug_file_open,
+	.release	= rt2x00debug_file_release,
+	.llseek		= default_llseek,
+};
+
 void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 {
 	const struct rt2x00debug *debug = rt2x00dev->ops->debugfs;
@@ -730,6 +762,13 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 
 #undef RT2X00DEBUGFS_CREATE_REGISTER_ENTRY
 
+	intf->eeprom_commit_entry =
+		debugfs_create_file("eeprom_commit", S_IRUSR | S_IWUSR,
+				    intf->register_folder,
+				    intf, &rt2x00debug_fop_eeprom_commit);
+	if (IS_ERR(intf->eeprom_commit_entry) || !intf->eeprom_commit_entry)
+		goto exit;
+
 	intf->queue_folder =
 	    debugfs_create_dir("queue", intf->driver_folder);
 	if (IS_ERR(intf->queue_folder) || !intf->queue_folder)
@@ -786,6 +825,7 @@ void rt2x00debug_deregister(struct rt2x00_dev *rt2x00dev)
 	debugfs_remove(intf->bbp_off_entry);
 	debugfs_remove(intf->eeprom_val_entry);
 	debugfs_remove(intf->eeprom_off_entry);
+	debugfs_remove(intf->eeprom_commit_entry);
 	debugfs_remove(intf->csr_val_entry);
 	debugfs_remove(intf->csr_off_entry);
 	debugfs_remove(intf->register_folder);
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.h b/drivers/net/wireless/rt2x00/rt2x00usb.h
index 323ca7b..f8ed3de 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
@@ -203,6 +203,25 @@ static inline int rt2x00usb_eeprom_read(struct rt2x00_dev *rt2x00dev,
 }
 
 /**
+ * rt2x00usb_eeprom_write - Write eeprom to device
+ * @rt2x00dev: Pointer to &struct rt2x00_dev
+ * @eeprom: Pointer to eeprom array to copy the information from
+ * @length: Number of bytes to write to the eeprom
+ *
+ * Simple wrapper around rt2x00usb_vendor_request to write the eeprom
+ * to the device. Note that the eeprom argument _must_ be allocated using
+ * kmalloc for correct handling inside the kernel USB layer.
+ */
+static inline int rt2x00usb_eeprom_write(struct rt2x00_dev *rt2x00dev,
+					 __le16 *eeprom, const u16 length)
+{
+	return rt2x00usb_vendor_request(rt2x00dev, USB_EEPROM_WRITE,
+					USB_VENDOR_REQUEST_OUT, 0, 0,
+					eeprom, length,
+					REGISTER_TIMEOUT16(length));
+}
+
+/**
  * rt2x00usb_register_read - Read 32bit register word
  * @rt2x00dev: Device pointer, see &struct rt2x00_dev.
  * @offset: Register offset
-- 
1.7.11.7

