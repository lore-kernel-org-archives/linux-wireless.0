Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:23631 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbXK0Tjo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 14:39:44 -0500
Received: by ug-out-1314.google.com with SMTP id z38so1321058ugc
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2007 11:39:43 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 03/11] rt2x00: Move register value/offset files into new folder
Date: Tue, 27 Nov 2007 21:48:16 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200711272146.53518.IvDoorn@gmail.com>
In-Reply-To: <200711272146.53518.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200711272148.17095.IvDoorn@gmail.com> (sfid-20071127_194249_294536_7F235747)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup debugfs interface by moving the csr/bbp/rf/eeprom value/offset
entries into the "register" folder.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00debug.c |   42 +++++++++++++++++-----------
 1 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
index 6dc9a25..92efc5a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -50,18 +50,20 @@ struct rt2x00debug_intf {
 	/*
 	 * Debugfs entries for:
 	 * - driver folder
-	 * - driver file
-	 * - chipset file
-	 * - device flags file
-	 * - register offset/value files
-	 * - eeprom offset/value files
-	 * - bbp offset/value files
-	 * - rf offset/value files
+	 *   - driver file
+	 *   - chipset file
+	 *   - device flags file
+	 *   - register folder
+	 *     - csr offset/value files
+	 *     - eeprom offset/value files
+	 *     - bbp offset/value files
+	 *     - rf offset/value files
 	 */
 	struct dentry *driver_folder;
 	struct dentry *driver_entry;
 	struct dentry *chipset_entry;
 	struct dentry *dev_flags;
+	struct dentry *register_folder;
 	struct dentry *csr_off_entry;
 	struct dentry *csr_val_entry;
 	struct dentry *eeprom_off_entry;
@@ -115,7 +117,7 @@ static ssize_t rt2x00debug_read_##__name(struct file *file,	\
 					 size_t length,		\
 					 loff_t *offset)	\
 {								\
-	struct rt2x00debug_intf *intf =	file->private_data;	\
+	struct rt2x00debug_intf *intf = file->private_data;	\
 	const struct rt2x00debug *debug = intf->debug;		\
 	char line[16];						\
 	size_t size;						\
@@ -145,7 +147,7 @@ static ssize_t rt2x00debug_write_##__name(struct file *file,	\
 					  size_t length,	\
 					  loff_t *offset)	\
 {								\
-	struct rt2x00debug_intf *intf =	file->private_data;	\
+	struct rt2x00debug_intf *intf = file->private_data;	\
 	const struct rt2x00debug *debug = intf->debug;		\
 	char line[16];						\
 	size_t size;						\
@@ -301,12 +303,17 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 	if (IS_ERR(intf->dev_flags))
 		goto exit;
 
-#define RT2X00DEBUGFS_CREATE_ENTRY(__intf, __name)		\
+	intf->register_folder =
+	    debugfs_create_dir("register", intf->driver_folder);
+	if (IS_ERR(intf->register_folder))
+		goto exit;
+
+#define RT2X00DEBUGFS_CREATE_REGISTER_ENTRY(__intf, __name)	\
 ({								\
 	(__intf)->__name##_off_entry =				\
 	    debugfs_create_u32(__stringify(__name) "_offset",	\
 			       S_IRUGO | S_IWUSR,		\
-			       (__intf)->driver_folder,		\
+			       (__intf)->register_folder,	\
 			       &(__intf)->offset_##__name);	\
 	if (IS_ERR((__intf)->__name##_off_entry))		\
 		goto exit;					\
@@ -314,18 +321,18 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 	(__intf)->__name##_val_entry =				\
 	    debugfs_create_file(__stringify(__name) "_value",	\
 				S_IRUGO | S_IWUSR,		\
-				(__intf)->driver_folder,	\
+				(__intf)->register_folder,	\
 				(__intf), &rt2x00debug_fop_##__name);\
 	if (IS_ERR((__intf)->__name##_val_entry))		\
 		goto exit;					\
 })
 
-	RT2X00DEBUGFS_CREATE_ENTRY(intf, csr);
-	RT2X00DEBUGFS_CREATE_ENTRY(intf, eeprom);
-	RT2X00DEBUGFS_CREATE_ENTRY(intf, bbp);
-	RT2X00DEBUGFS_CREATE_ENTRY(intf, rf);
+	RT2X00DEBUGFS_CREATE_REGISTER_ENTRY(intf, csr);
+	RT2X00DEBUGFS_CREATE_REGISTER_ENTRY(intf, eeprom);
+	RT2X00DEBUGFS_CREATE_REGISTER_ENTRY(intf, bbp);
+	RT2X00DEBUGFS_CREATE_REGISTER_ENTRY(intf, rf);
 
-#undef RT2X00DEBUGFS_CREATE_ENTRY
+#undef RT2X00DEBUGFS_CREATE_REGISTER_ENTRY
 
 	return;
 
@@ -351,6 +358,7 @@ void rt2x00debug_deregister(struct rt2x00_dev *rt2x00dev)
 	debugfs_remove(intf->eeprom_off_entry);
 	debugfs_remove(intf->csr_val_entry);
 	debugfs_remove(intf->csr_off_entry);
+	debugfs_remove(intf->register_folder);
 	debugfs_remove(intf->dev_flags);
 	debugfs_remove(intf->chipset_entry);
 	debugfs_remove(intf->driver_entry);
-- 
1.5.3.6

