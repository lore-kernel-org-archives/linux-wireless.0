Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:48225 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932107AbXGaSeG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 14:34:06 -0400
Received: by ug-out-1314.google.com with SMTP id j3so121186ugf
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2007 11:34:06 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 07/24] rt2x00: Add RF register contents to Debugfs
Date: Tue, 31 Jul 2007 20:37:10 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707312037.10861.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From fc0bd58f962e513c6d542fc7bb72b4493509529c Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Fri, 27 Jul 2007 20:18:37 +0200
Subject: [PATCH 07/24] rt2x00: Add RF register contents to Debugfs

With RF register access working the same as the other
registers we can now easily add support for it with debugfs.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2400pci.c   |    6 ++++++
 drivers/net/wireless/rt2500pci.c   |    6 ++++++
 drivers/net/wireless/rt2500usb.c   |    6 ++++++
 drivers/net/wireless/rt2x00debug.c |    9 +++++++++
 drivers/net/wireless/rt2x00debug.h |    1 +
 drivers/net/wireless/rt61pci.c     |    6 ++++++
 drivers/net/wireless/rt73usb.c     |    6 ++++++
 7 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2400pci.c b/drivers/net/wireless/rt2400pci.c
index 520c38c..45bc993 100644
--- a/drivers/net/wireless/rt2400pci.c
+++ b/drivers/net/wireless/rt2400pci.c
@@ -232,6 +232,12 @@ static const struct rt2x00debug rt2400pci_rt2x00debug = {
 		.word_size	= sizeof(u8),
 		.word_count	= BBP_SIZE / sizeof(u8),
 	},
+	.rf	= {
+		.read		= rt2x00_rf_read,
+		.write		= rt2400pci_rf_write,
+		.word_size	= sizeof(u32),
+		.word_count	= RF_SIZE / sizeof(u32),
+	},
 };
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 
diff --git a/drivers/net/wireless/rt2500pci.c b/drivers/net/wireless/rt2500pci.c
index f2ea9bf..3117e0b 100644
--- a/drivers/net/wireless/rt2500pci.c
+++ b/drivers/net/wireless/rt2500pci.c
@@ -232,6 +232,12 @@ static const struct rt2x00debug rt2500pci_rt2x00debug = {
 		.word_size	= sizeof(u8),
 		.word_count	= BBP_SIZE / sizeof(u8),
 	},
+	.rf	= {
+		.read		= rt2x00_rf_read,
+		.write		= rt2500pci_rf_write,
+		.word_size	= sizeof(u32),
+		.word_count	= RF_SIZE / sizeof(u32),
+	},
 };
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 
diff --git a/drivers/net/wireless/rt2500usb.c b/drivers/net/wireless/rt2500usb.c
index b9ae223..89cb347 100644
--- a/drivers/net/wireless/rt2500usb.c
+++ b/drivers/net/wireless/rt2500usb.c
@@ -238,6 +238,12 @@ static const struct rt2x00debug rt2500usb_rt2x00debug = {
 		.word_size	= sizeof(u8),
 		.word_count	= BBP_SIZE / sizeof(u8),
 	},
+	.rf	= {
+		.read		= rt2x00_rf_read,
+		.write		= rt2500usb_rf_write,
+		.word_size	= sizeof(u32),
+		.word_count	= RF_SIZE / sizeof(u32),
+	},
 };
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 
diff --git a/drivers/net/wireless/rt2x00debug.c b/drivers/net/wireless/rt2x00debug.c
index 3ff07e2..786fa6c 100644
--- a/drivers/net/wireless/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00debug.c
@@ -59,6 +59,7 @@ struct rt2x00debug_intf {
 	 * - register offset/value files
 	 * - eeprom offset/value files
 	 * - bbp offset/value files
+	 * - rf offset/value files
 	 */
 	struct dentry *driver_folder;
 	struct dentry *driver_entry;
@@ -69,6 +70,8 @@ struct rt2x00debug_intf {
 	struct dentry *eeprom_val_entry;
 	struct dentry *bbp_off_entry;
 	struct dentry *bbp_val_entry;
+	struct dentry *rf_off_entry;
+	struct dentry *rf_val_entry;
 
 	/*
 	 * Driver and chipset files will use a data buffer
@@ -84,6 +87,7 @@ struct rt2x00debug_intf {
 	unsigned int offset_csr;
 	unsigned int offset_eeprom;
 	unsigned int offset_bbp;
+	unsigned int offset_rf;
 };
 
 static int rt2x00debug_file_open(struct inode *inode, struct file *file)
@@ -175,6 +179,7 @@ static const struct file_operations rt2x00debug_fop_##__name = {\
 RT2X00DEBUGFS_OPS(csr, "0x%.8x\n", u32);
 RT2X00DEBUGFS_OPS(eeprom, "0x%.4x\n", u16);
 RT2X00DEBUGFS_OPS(bbp, "0x%.2x\n", u8);
+RT2X00DEBUGFS_OPS(rf, "0x%.8x\n", u32);
 
 static struct dentry *rt2x00debug_create_file_driver(const char *name,
 	struct rt2x00debug_intf *intf, struct debugfs_blob_wrapper *blob)
@@ -208,6 +213,7 @@ static struct dentry *rt2x00debug_create_file_chipset(const char *name,
 	data += sprintf(data, "csr length: %d\n", debug->csr.word_count);
 	data += sprintf(data, "eeprom length: %d\n", debug->eeprom.word_count);
 	data += sprintf(data, "bbp length: %d\n", debug->bbp.word_count);
+	data += sprintf(data, "rf length: %d\n", debug->rf.word_count);
 	blob->size = strlen(blob->data);
 
 	return debugfs_create_blob(name, S_IRUGO, intf->driver_folder, blob);
@@ -263,6 +269,7 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 	RT2X00DEBUGFS_CREATE_ENTRY(csr);
 	RT2X00DEBUGFS_CREATE_ENTRY(eeprom);
 	RT2X00DEBUGFS_CREATE_ENTRY(bbp);
+	RT2X00DEBUGFS_CREATE_ENTRY(rf);
 
 #undef RT2X00DEBUGFS_CREATE_ENTRY
 
@@ -282,6 +289,8 @@ void rt2x00debug_deregister(struct rt2x00_dev *rt2x00dev)
 	if (unlikely(!intf))
 		return;
 
+	debugfs_remove(intf->rf_val_entry);
+	debugfs_remove(intf->rf_off_entry);
 	debugfs_remove(intf->bbp_val_entry);
 	debugfs_remove(intf->bbp_off_entry);
 	debugfs_remove(intf->eeprom_val_entry);
diff --git a/drivers/net/wireless/rt2x00debug.h b/drivers/net/wireless/rt2x00debug.h
index 82b4df8..21a513a 100644
--- a/drivers/net/wireless/rt2x00debug.h
+++ b/drivers/net/wireless/rt2x00debug.h
@@ -52,6 +52,7 @@ struct rt2x00debug {
 	RT2X00DEBUGFS_REGISTER_ENTRY(csr, u32);
 	RT2X00DEBUGFS_REGISTER_ENTRY(eeprom, u16);
 	RT2X00DEBUGFS_REGISTER_ENTRY(bbp, u8);
+	RT2X00DEBUGFS_REGISTER_ENTRY(rf, u32);
 };
 
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
diff --git a/drivers/net/wireless/rt61pci.c b/drivers/net/wireless/rt61pci.c
index 3059b45..fb0c5c5 100644
--- a/drivers/net/wireless/rt61pci.c
+++ b/drivers/net/wireless/rt61pci.c
@@ -256,6 +256,12 @@ static const struct rt2x00debug rt61pci_rt2x00debug = {
 		.word_size	= sizeof(u8),
 		.word_count	= BBP_SIZE / sizeof(u8),
 	},
+	.rf	= {
+		.read		= rt2x00_rf_read,
+		.write		= rt61pci_rf_write,
+		.word_size	= sizeof(u32),
+		.word_count	= RF_SIZE / sizeof(u32),
+	},
 };
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 
diff --git a/drivers/net/wireless/rt73usb.c b/drivers/net/wireless/rt73usb.c
index 6a7b1f9..07e6087 100644
--- a/drivers/net/wireless/rt73usb.c
+++ b/drivers/net/wireless/rt73usb.c
@@ -235,6 +235,12 @@ static const struct rt2x00debug rt73usb_rt2x00debug = {
 		.word_size	= sizeof(u8),
 		.word_count	= BBP_SIZE / sizeof(u8),
 	},
+	.rf	= {
+		.read		= rt2x00_rf_read,
+		.write		= rt73usb_rf_write,
+		.word_size	= sizeof(u32),
+		.word_count	= RF_SIZE / sizeof(u32),
+	},
 };
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 
-- 
1.5.2.4

