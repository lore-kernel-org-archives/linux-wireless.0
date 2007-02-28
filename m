Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:30963 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933231AbXB1RRA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 12:17:00 -0500
Received: by nf-out-0910.google.com with SMTP id o25so617517nfa
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 09:16:58 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/28] rt2x00: Add debugfs support
Date: Wed, 28 Feb 2007 18:16:52 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200702281507.13953.IvDoorn@gmail.com> <1172679612.5015.35.camel@johannes.berg> <200702281732.08221.IvDoorn@gmail.com>
In-Reply-To: <200702281732.08221.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702281816.52512.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch will add debugfs support to rt2x00.
It will add these files into the debugfs directory that has been
created by the wiphy handler.
This patch also has the MODULE_VERSION() and the LINUX_VERSION_CODE
removed.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/drivers/net/wireless/mac80211/rt2x00/Kconfig b/drivers/net/wireless/mac80211/rt2x00/Kconfig
index 6e7bd2b..5b6a1ec 100644
--- a/drivers/net/wireless/mac80211/rt2x00/Kconfig
+++ b/drivers/net/wireless/mac80211/rt2x00/Kconfig
@@ -81,3 +81,11 @@ config RT73USB_DEBUG
 	depends on RT73USB
 	---help---
 	Enable debugging output.
+
+config RT2X00_DEBUGFS
+	tristate "Ralink debugfs support"
+	depends on RT2X00 && DEBUG_FS
+	---help---
+	Enable creation of debugfs files for the rt2x00 drivers.
+	These debugfs files support both reading and writing of the
+	most important register types of the rt2x00 devices.
diff --git a/drivers/net/wireless/mac80211/rt2x00/Makefile b/drivers/net/wireless/mac80211/rt2x00/Makefile
index 8051b41..df706c7 100644
--- a/drivers/net/wireless/mac80211/rt2x00/Makefile
+++ b/drivers/net/wireless/mac80211/rt2x00/Makefile
@@ -3,3 +3,4 @@ obj-$(CONFIG_RT2500PCI)		+= rt2500pci.o
 obj-$(CONFIG_RT61PCI)		+= rt61pci.o
 obj-$(CONFIG_RT2500USB)		+= rt2500usb.o
 obj-$(CONFIG_RT73USB)		+= rt73usb.o
+obj-$(CONFIG_RT2X00_DEBUGFS)	+= rt2x00debug.o
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
index 042b604..8a728c4 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
@@ -244,6 +244,80 @@ static inline void rt2x00_desc_write(struct data_desc *desc,
 	desc->word[word] = cpu_to_le32(value);
 }
 
+#ifdef CONFIG_RT2X00_DEBUGFS
+#define CSR_OFFSET(__word)	( CSR_REG_BASE + ((__word) * sizeof(u32)) )
+
+static void rt2400pci_read_csr(struct rt2x00_dev *rt2x00dev,
+	const unsigned long word, void *data)
+{
+	rt2x00_register_read(rt2x00dev, CSR_OFFSET(word), data);
+}
+
+static void rt2400pci_write_csr(struct rt2x00_dev *rt2x00dev,
+	const unsigned long word, void *data)
+{
+	rt2x00_register_write(rt2x00dev, CSR_OFFSET(word), *((u32*)data));
+}
+
+static void rt2400pci_read_eeprom(struct rt2x00_dev *rt2x00dev,
+	const unsigned long word, void *data)
+{
+	rt2x00_eeprom_read(rt2x00dev, word, (u16*)data);
+}
+
+static void rt2400pci_write_eeprom(struct rt2x00_dev *rt2x00dev,
+	const unsigned long word, void *data)
+{
+	rt2x00_eeprom_write(rt2x00dev, word, *(u16*)data);
+}
+
+static void rt2400pci_read_bbp(struct rt2x00_dev *rt2x00dev,
+	const unsigned long word, void *data)
+{
+	rt2x00_bbp_read(rt2x00dev, word, ((u8*)data));
+}
+
+static void rt2400pci_write_bbp(struct rt2x00_dev *rt2x00dev,
+	const unsigned long word, void *data)
+{
+	rt2x00_bbp_write(rt2x00dev, word, *((u8*)data));
+}
+
+static void rt2400pci_open_debugfs(struct rt2x00_dev *rt2x00dev)
+{
+	struct rt2x00debug *debug = &rt2x00dev->debug;
+
+	debug->wiphy			= rt2x00dev->hw->wiphy;
+	debug->owner 			= THIS_MODULE;
+	debug->mod_name			= DRV_NAME;
+	debug->mod_version		= DRV_VERSION;
+	debug->reg_csr.read		= rt2400pci_read_csr;
+	debug->reg_csr.write		= rt2400pci_write_csr;
+	debug->reg_csr.word_size	= sizeof(u32);
+	debug->reg_csr.length		= CSR_REG_SIZE;
+	debug->reg_eeprom.read		= rt2400pci_read_eeprom;
+	debug->reg_eeprom.write		= rt2400pci_write_eeprom;
+	debug->reg_eeprom.word_size	= sizeof(u16);
+	debug->reg_eeprom.length	= EEPROM_SIZE;
+	debug->reg_bbp.read		= rt2400pci_read_bbp;
+	debug->reg_bbp.write		= rt2400pci_write_bbp;
+	debug->reg_bbp.word_size	= sizeof(u8);
+	debug->reg_bbp.length		= BBP_SIZE;
+	debug->rt2x00dev 		= rt2x00dev;
+
+	if (rt2x00debug_register(debug))
+		ERROR("Failed to register debug handler.\n");
+}
+
+static void rt2400pci_close_debugfs(struct rt2x00_dev *rt2x00dev)
+{
+	rt2x00debug_deregister(&rt2x00dev->debug);
+}
+#else /* CONFIG_RT2X00_DEBUGFS */
+static inline void rt2400pci_open_debugfs(struct rt2x00_dev *rt2x00dev){}
+static inline void rt2400pci_close_debugfs(struct rt2x00_dev *rt2x00dev){}
+#endif /* CONFIG_RT2X00_DEBUGFS */
+
 /*
  * Configuration handlers.
  */
@@ -2656,6 +2730,11 @@ static int rt2400pci_init_hw(struct rt2x00_dev *rt2x00dev)
 static void rt2400pci_free_dev(struct rt2x00_dev *rt2x00dev)
 {
 	/*
+	 * Close debugfs entry.
+	 */
+	rt2400pci_close_debugfs(rt2x00dev);
+
+	/*
 	 * Free workqueue.
 	 */
 	if (likely(rt2x00dev->workqueue)) {
@@ -2754,6 +2833,11 @@ static int rt2400pci_alloc_dev(struct pci_dev *pci_dev,
 		goto exit;
 	}
 
+	/*
+	 * Open the debugfs entry.
+	 */
+	rt2400pci_open_debugfs(rt2x00dev);
+
 	return 0;
 
 exit:
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.h b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.h
index 9b2d8f8..ab0bc97 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.h
@@ -50,6 +50,7 @@
 #define CSR_REG_SIZE			0x014c
 #define EEPROM_BASE			0x0000
 #define EEPROM_SIZE			0x0100
+#define BBP_SIZE			0x0020
 
 /*
  * Control/Status Registers(CSR).
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
index 60f2364..ea44bf3 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
@@ -244,6 +244,80 @@ static inline void rt2x00_desc_write(struct data_desc *desc,
 	desc->word[word] = cpu_to_le32(value);
 }
 
+#ifdef CONFIG_RT2X00_DEBUGFS
+#define CSR_OFFSET(__word)	( CSR_REG_BASE + ((__word) * sizeof(u32)) )
+
+static void rt2500pci_read_csr(struct rt2x00_dev *rt2x00dev,
+	const unsigned long word, void *data)
+{
+	rt2x00_register_read(rt2x00dev, CSR_OFFSET(word), data);
+}
+
+static void rt2500pci_write_csr(struct rt2x00_dev *rt2x00dev,
+	const unsigned long word, void *data)
+{
+	rt2x00_register_write(rt2x00dev, CSR_OFFSET(word), *((u32*)data));
+}
+
+static void rt2500pci_read_eeprom(struct rt2x00_dev *rt2x00dev,
+	const unsigned long word, void *data)
+{
+	rt2x00_eeprom_read(rt2x00dev, word, (u16*)data);
+}
+
+static void rt2500pci_write_eeprom(struct rt2x00_dev *rt2x00dev,
+	const unsigned long word, void *data)
+{
+	rt2x00_eeprom_write(rt2x00dev, word, *(u16*)data);
+}
+
+static void rt2500pci_read_bbp(struct rt2x00_dev *rt2x00dev,
+	const unsigned long word, void *data)
+{
+	rt2x00_bbp_read(rt2x00dev, word, ((u8*)data));
+}
+
+static void rt2500pci_write_bbp(struct rt2x00_dev *rt2x00dev,
+	const unsigned long word, void *data)
+{
+	rt2x00_bbp_write(rt2x00dev, word, *((u8*)data));
+}
+
+static void rt2500pci_open_debugfs(struct rt2x00_dev *rt2x00dev)
+{
+	struct rt2x00debug *debug = &rt2x00dev->debug;
+
+	debug->wiphy			= rt2x00dev->hw->wiphy;
+	debug->owner 			= THIS_MODULE;
+	debug->mod_name			= DRV_NAME;
+	debug->mod_version		= DRV_VERSION;
+	debug->reg_csr.read		= rt2500pci_read_csr;
+	debug->reg_csr.write		= rt2500pci_write_csr;
+	debug->reg_csr.word_size	= sizeof(u32);
+	debug->reg_csr.length		= CSR_REG_SIZE;
+	debug->reg_eeprom.read		= rt2500pci_read_eeprom;
+	debug->reg_eeprom.write		= rt2500pci_write_eeprom;
+	debug->reg_eeprom.word_size	= sizeof(u16);
+	debug->reg_eeprom.length	= EEPROM_SIZE;
+	debug->reg_bbp.read		= rt2500pci_read_bbp;
+	debug->reg_bbp.write		= rt2500pci_write_bbp;
+	debug->reg_bbp.word_size	= sizeof(u8);
+	debug->reg_bbp.length		= BBP_SIZE;
+	debug->rt2x00dev 		= rt2x00dev;
+
+	if (rt2x00debug_register(debug))
+		ERROR("Failed to register debug handler.\n");
+}
+
+static void rt2500pci_close_debugfs(struct rt2x00_dev *rt2x00dev)
+{
+	rt2x00debug_deregister(&rt2x00dev->debug);
+}
+#else /* CONFIG_RT2X00_DEBUGFS */
+static inline void rt2500pci_open_debugfs(struct rt2x00_dev *rt2x00dev){}
+static inline void rt2500pci_close_debugfs(struct rt2x00_dev *rt2x00dev){}
+#endif /* CONFIG_RT2X00_DEBUGFS */
+
 /*
  * Configuration handlers.
  */
@@ -2967,6 +3041,11 @@ static int rt2500pci_init_hw(struct rt2x00_dev *rt2x00dev)
 static void rt2500pci_free_dev(struct rt2x00_dev *rt2x00dev)
 {
 	/*
+	 * Close debugfs entry.
+	 */
+	rt2500pci_close_debugfs(rt2x00dev);
+
+	/*
 	 * Free workqueue.
 	 */
 	if (likely(rt2x00dev->workqueue)) {
@@ -3066,6 +3145,11 @@ static int rt2500pci_alloc_dev(struct pci_dev *pci_dev,
 		goto exit;
 	}
 
+	/*
+	 * Open the debugfs entry.
+	 */
+	rt2500pci_open_debugfs(rt2x00dev);
+
 	return 0;
 
 exit:
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.h b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.h
index 931081f..fc4a865 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.h
@@ -61,6 +61,7 @@
 #define CSR_REG_SIZE			0x0174
 #define EEPROM_BASE			0x0000
 #define EEPROM_SIZE			0x0200
+#define BBP_SIZE			0x0040
 
 /*
  * Control/Status Registers(CSR).
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
index 21da4be..b9d7059 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
@@ -298,6 +298,80 @@ static inline void rt2x00_desc_write(struct data_desc *desc,
 	desc->word[word] = cpu_to_le32(value);
 }
 
+#ifdef CONFIG_RT2X00_DEBUGFS
+#define CSR_OFFSET(__word)	( CSR_REG_BASE + ((__word) * sizeof(u16)) )
+
+static void rt2500usb_read_csr(struct rt2x00_dev *rt2x00dev,
+	const unsigned long word, void *data)
+{
+	rt2x00_register_read(rt2x00dev, CSR_OFFSET(word), data);
+}
+
+static void rt2500usb_write_csr(struct rt2x00_dev *rt2x00dev,
+	const unsigned long word, void *data)
+{
+	rt2x00_register_write(rt2x00dev, CSR_OFFSET(word), *((u16*)data));
+}
+
+static void rt2500usb_read_eeprom(struct rt2x00_dev *rt2x00dev,
+	const unsigned long word, void *data)
+{
+	rt2x00_eeprom_read(rt2x00dev, word, (u16*)data);
+}
+
+static void rt2500usb_write_eeprom(struct rt2x00_dev *rt2x00dev,
+	const unsigned long word, void *data)
+{
+	rt2x00_eeprom_write(rt2x00dev, word, *(u16*)data);
+}
+
+static void rt2500usb_read_bbp(struct rt2x00_dev *rt2x00dev,
+	const unsigned long word, void *data)
+{
+	rt2x00_bbp_read(rt2x00dev, word, ((u8*)data));
+}
+
+static void rt2500usb_write_bbp(struct rt2x00_dev *rt2x00dev,
+	const unsigned long word, void *data)
+{
+	rt2x00_bbp_write(rt2x00dev, word, *((u8*)data));
+}
+
+static void rt2500usb_open_debugfs(struct rt2x00_dev *rt2x00dev)
+{
+	struct rt2x00debug *debug = &rt2x00dev->debug;
+
+	debug->wiphy			= rt2x00dev->hw->wiphy;
+	debug->owner 			= THIS_MODULE;
+	debug->mod_name			= DRV_NAME;
+	debug->mod_version		= DRV_VERSION;
+	debug->reg_csr.read		= rt2500usb_read_csr;
+	debug->reg_csr.write		= rt2500usb_write_csr;
+	debug->reg_csr.word_size	= sizeof(u16);
+	debug->reg_csr.length		= CSR_REG_SIZE;
+	debug->reg_eeprom.read		= rt2500usb_read_eeprom;
+	debug->reg_eeprom.write		= rt2500usb_write_eeprom;
+	debug->reg_eeprom.word_size	= sizeof(u16);
+	debug->reg_eeprom.length	= EEPROM_SIZE;
+	debug->reg_bbp.read		= rt2500usb_read_bbp;
+	debug->reg_bbp.write		= rt2500usb_write_bbp;
+	debug->reg_bbp.word_size	= sizeof(u8);
+	debug->reg_bbp.length		= BBP_SIZE;
+	debug->rt2x00dev 		= rt2x00dev;
+
+	if (rt2x00debug_register(debug))
+		ERROR("Failed to register debug handler.\n");
+}
+
+static void rt2500usb_close_debugfs(struct rt2x00_dev *rt2x00dev)
+{
+	rt2x00debug_deregister(&rt2x00dev->debug);
+}
+#else /* CONFIG_RT2X00_DEBUGFS */
+static inline void rt2500usb_open_debugfs(struct rt2x00_dev *rt2x00dev){}
+static inline void rt2500usb_close_debugfs(struct rt2x00_dev *rt2x00dev){}
+#endif /* CONFIG_RT2X00_DEBUGFS */
+
 /*
  * Configuration handlers.
  */
@@ -2810,6 +2884,11 @@ static int rt2500usb_init_hw(struct rt2x00_dev *rt2x00dev)
 static void rt2500usb_free_dev(struct rt2x00_dev *rt2x00dev)
 {
 	/*
+	 * Close debugfs entry.
+	 */
+	rt2500usb_close_debugfs(rt2x00dev);
+
+	/*
 	 * Free workqueue.
 	 */
 	if (likely(rt2x00dev->workqueue)) {
@@ -2890,6 +2969,11 @@ static int rt2500usb_alloc_dev(struct usb_interface *usb_intf,
 		goto exit;
 	}
 
+	/*
+	 * Open the debugfs entry.
+	 */
+	rt2500usb_open_debugfs(rt2x00dev);
+
 	return 0;
 
 exit:
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.h b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.h
index 6c9a58b..7f97799 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.h
@@ -54,6 +54,7 @@
 #define CSR_REG_SIZE			0x0100
 #define EEPROM_BASE			0x0000
 #define EEPROM_SIZE			0x006a
+#define BBP_SIZE			0x0060
 
 /*
  * Control/Status Registers(CSR).
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00.h b/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
index ed292b6..368a8c5 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
@@ -28,6 +28,11 @@
 #ifndef RT2X00_H
 #define RT2X00_H
 
+#if defined( CONFIG_RT2X00_DEBUGFS) || defined( CONFIG_RT2X00_DEBUGFS_MODULE)
+#define CONFIG_RT2X00_DEBUGFS
+#include "rt2x00debug.h"
+#endif /* CONFIG_RT2X00_DEBUGFS */
+
 /*
  * Module information.
  */
@@ -953,6 +958,13 @@ struct rt2x00_dev {
 	void __iomem *csr_addr;
 
 	/*
+	 * If enabled, the structure for the debugfs files.
+	 */
+#ifdef CONFIG_RT2X00_DEBUGFS
+	struct rt2x00debug debug;
+#endif /* CONFIG_RT2X00_DEBUGFS */
+
+	/*
 	 * Queue for deferred work.
 	 */
 	struct workqueue_struct *workqueue;
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00debug.c b/drivers/net/wireless/mac80211/rt2x00/rt2x00debug.c
new file mode 100644
index 0000000..d0697da
--- /dev/null
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00debug.c
@@ -0,0 +1,372 @@
+/*
+	Copyright (C) 2004 - 2007 rt2x00 SourceForge Project
+	<http://rt2x00.serialmonkey.com>
+
+	This program is free software; you can redistribute it and/or modify
+	it under the terms of the GNU General Public License as published by
+	the Free Software Foundation; either version 2 of the License, or
+	(at your option) any later version.
+
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty of
+	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+	GNU General Public License for more details.
+
+	You should have received a copy of the GNU General Public License
+	along with this program; if not, write to the
+	Free Software Foundation, Inc.,
+	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+/*
+	Module: rt2x00debug
+	Abstract: rt2x00debug specific routines.
+	Supported chipsets: RT2460, RT2560, RT2570,
+	rt2561, rt2561s, rt2661 & rt2573.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/version.h>
+#include <linux/init.h>
+#include <linux/debugfs.h>
+
+#include <net/wireless.h>
+
+#include <asm/uaccess.h>
+
+#include "rt2x00debug.h"
+
+#define PRINT_REG8_STR		( "0x%.2x\n" )
+#define PRINT_REG16_STR		( "0x%.4x\n" )
+#define PRINT_REG32_STR		( "0x%.8x\n" )
+#define PRINT_REG_LEN_MAX	( 16 )
+#define PRINT_LINE_LEN_MAX	( 32 )
+
+struct rt2x00debug_intf {
+	/*
+	 * Reference to the rt2x00debug structure
+	 * which can be used to communicate with
+	 * the registers.
+	 */
+	struct rt2x00debug *debug;
+
+	/*
+	 * Debugfs entries for:
+	 * - driver file
+	 * - chipset file
+	 * - register offset/value files
+	 * - eeprom offset/value files
+	 * - bbp offset/value files
+	 */
+	struct dentry *driver_entry;
+	struct dentry *chipset_entry;
+	struct dentry *csr_off_entry;
+	struct dentry *csr_val_entry;
+	struct dentry *eeprom_off_entry;
+	struct dentry *eeprom_val_entry;
+	struct dentry *bbp_off_entry;
+	struct dentry *bbp_val_entry;
+
+	/*
+	 * Driver and chipset files will use a data buffer
+	 * that has been created in advance. This will simplify
+	 * the code since we can use the debugfs functions.
+	 */
+	struct debugfs_blob_wrapper driver_blob;
+	struct debugfs_blob_wrapper chipset_blob;
+
+	/*
+	 * Requested offset for each register type.
+	 */
+	unsigned int offset_csr;
+	unsigned int offset_eeprom;
+	unsigned int offset_bbp;
+};
+
+static int rt2x00debug_file_open(struct inode *inode, struct file *file)
+{
+	struct rt2x00debug_intf *intf = inode->i_private;
+
+	file->private_data = inode->i_private;
+
+	if (!try_module_get(intf->debug->owner))
+		return -EBUSY;
+
+	return 0;
+}
+
+static int rt2x00debug_file_release(struct inode *inode, struct file *file)
+{
+	struct rt2x00debug_intf *intf = file->private_data;
+
+	module_put(intf->debug->owner);
+
+	return 0;
+}
+
+static ssize_t rt2x00debug_file_read(void *device, char __user *buf,
+	loff_t *offset, unsigned int word, struct rt2x00debug_reg *reg)
+{
+	unsigned long value;
+	unsigned int size;
+	char *line;
+
+	if (*offset)
+		return 0;
+
+	line = kzalloc(PRINT_REG_LEN_MAX, GFP_KERNEL);
+	if (!line)
+		return -ENOMEM;
+
+	reg->read(device, word, &value);
+
+	if (reg->word_size == sizeof(u8))
+		size = sprintf(line, PRINT_REG8_STR, (u8)value);
+	else if (reg->word_size == sizeof(u16))
+		size = sprintf(line, PRINT_REG16_STR, (u16)value);
+	else
+		size = sprintf(line, PRINT_REG32_STR, (u32)value);
+
+	if (copy_to_user(buf, line, size))
+		goto exit;
+
+	kfree(line);
+
+	*offset += size;
+	return size;
+
+exit:
+	kfree(line);
+
+	return -EFAULT;
+}
+
+static ssize_t rt2x00debug_file_write(void *device, const char __user *buf,
+	loff_t *offset, unsigned int word, unsigned int length,
+	struct rt2x00debug_reg *reg)
+{
+	unsigned long value;
+	int size;
+	char *line;
+
+	line = kzalloc(length, GFP_KERNEL);
+	if (!line)
+		return -ENOMEM;
+
+	if (copy_from_user(line, buf, length))
+		goto exit;
+
+	size = strlen(line);
+	value = simple_strtoul(line, NULL, 0);
+
+	reg->write(device, word, &value);
+
+	kfree(line);
+
+	*offset += size;
+	return size;
+
+exit:
+	kfree(line);
+
+	return -EFAULT;
+}
+
+#define RT2X00DEBUGFS_OPS_READ(__name)					\
+	static ssize_t rt2x00debug_read_##__name(struct file *file,	\
+		char __user *buf, size_t length, loff_t *offset)	\
+	{								\
+		struct rt2x00debug_intf *intf =	file->private_data;	\
+		struct rt2x00debug *debug = intf->debug;		\
+		struct rt2x00debug_reg *reg = &debug->reg_##__name;	\
+									\
+		if (intf->offset_##__name > reg->length)		\
+			return -EINVAL;					\
+									\
+		return rt2x00debug_file_read(debug->rt2x00dev, buf,	\
+			offset, intf->offset_##__name, reg);		\
+	}
+
+RT2X00DEBUGFS_OPS_READ(csr);
+RT2X00DEBUGFS_OPS_READ(eeprom);
+RT2X00DEBUGFS_OPS_READ(bbp);
+
+#define RT2X00DEBUGFS_OPS_WRITE(__name)					\
+	static ssize_t rt2x00debug_write_##__name(struct file *file,	\
+		const char __user *buf, size_t length, loff_t *offset)	\
+	{								\
+		struct rt2x00debug_intf *intf =	file->private_data;	\
+		struct rt2x00debug *debug = intf->debug;		\
+		struct rt2x00debug_reg *reg = &debug->reg_##__name;	\
+									\
+		if (intf->offset_##__name > reg->length)		\
+			return -EINVAL;					\
+									\
+		return rt2x00debug_file_write(debug->rt2x00dev, buf,	\
+			offset, intf->offset_##__name, length, reg);	\
+	}
+
+RT2X00DEBUGFS_OPS_WRITE(csr);
+RT2X00DEBUGFS_OPS_WRITE(eeprom);
+RT2X00DEBUGFS_OPS_WRITE(bbp);
+
+#define RT2X00DEBUGFS_OPS(__name)					\
+	static const struct file_operations rt2x00debug_fop_##__name = {\
+		.owner		= THIS_MODULE,				\
+		.read		= rt2x00debug_read_##__name,		\
+		.write		= rt2x00debug_write_##__name,		\
+		.open		= rt2x00debug_file_open,		\
+		.release	= rt2x00debug_file_release,		\
+	};
+
+RT2X00DEBUGFS_OPS(csr);
+RT2X00DEBUGFS_OPS(eeprom);
+RT2X00DEBUGFS_OPS(bbp);
+
+static struct dentry *rt2x00debug_create_file_driver(const char *name,
+	struct rt2x00debug_intf *intf, struct debugfs_blob_wrapper *blob)
+{
+	struct rt2x00debug *debug = intf->debug;
+	char *data;
+
+	data = kzalloc(3 * PRINT_LINE_LEN_MAX, GFP_KERNEL);
+	if (!data)
+		return NULL;
+
+	blob->data = data;
+	data += sprintf(data, "driver: %s\n", debug->mod_name);
+	data += sprintf(data, "version: %s\n", debug->mod_version);
+	data += sprintf(data, "compiled: %s %s\n", __DATE__, __TIME__);
+	blob->size = strlen(blob->data);
+
+	return debugfs_create_blob(name, S_IRUGO,
+		debug->wiphy->debugfsdir, blob);
+}
+
+static struct dentry *rt2x00debug_create_file_chipset(const char *name,
+	struct rt2x00debug_intf *intf, struct debugfs_blob_wrapper *blob)
+{
+	struct rt2x00debug *debug = intf->debug;
+	char *data;
+
+	data = kzalloc(3 * PRINT_LINE_LEN_MAX, GFP_KERNEL);
+	if (!data)
+		return NULL;
+
+	blob->data = data;
+	data += sprintf(data, "csr length: %d\n", debug->reg_csr.length);
+	data += sprintf(data, "eeprom length: %d\n", debug->reg_eeprom.length);
+	data += sprintf(data, "bbp length: %d\n", debug->reg_bbp.length);
+	blob->size = strlen(blob->data);
+
+	return debugfs_create_blob(name, S_IRUGO,
+		debug->wiphy->debugfsdir, blob);
+}
+
+int rt2x00debug_register(struct rt2x00debug *debug)
+{
+	struct rt2x00debug_intf *intf;
+
+	intf = kzalloc(sizeof(struct rt2x00debug_intf), GFP_KERNEL);
+	if (!intf)
+		return -ENOMEM;
+
+	intf->debug = debug;
+	debug->priv = intf;
+
+	intf->driver_entry = rt2x00debug_create_file_driver("driver",
+		intf, &intf->driver_blob);
+	if (IS_ERR(intf->driver_entry))
+		goto exit;
+
+	intf->chipset_entry = rt2x00debug_create_file_chipset("chipset",
+		intf, &intf->chipset_blob);
+	if (IS_ERR(intf->chipset_entry))
+		goto exit;
+
+	intf->csr_off_entry = debugfs_create_u32("csr_offset",
+		S_IRUGO | S_IWUSR, debug->wiphy->debugfsdir,
+		&intf->offset_csr);
+	if (IS_ERR(intf->csr_off_entry))
+		goto exit;
+
+	intf->csr_val_entry = debugfs_create_file("csr_value",
+		S_IRUGO | S_IWUSR, debug->wiphy->debugfsdir, intf,
+		&rt2x00debug_fop_csr);
+	if (IS_ERR(intf->csr_val_entry))
+		goto exit;
+
+	intf->eeprom_off_entry = debugfs_create_u32("eeprom_offset",
+		S_IRUGO | S_IWUSR, debug->wiphy->debugfsdir,
+		&intf->offset_eeprom);
+	if (IS_ERR(intf->eeprom_off_entry))
+		goto exit;
+
+	intf->eeprom_val_entry = debugfs_create_file("eeprom_value",
+		S_IRUGO | S_IWUSR, debug->wiphy->debugfsdir, intf,
+		&rt2x00debug_fop_eeprom);
+	if (IS_ERR(intf->eeprom_val_entry))
+		goto exit;
+
+	intf->bbp_off_entry = debugfs_create_u32("bbp_offset",
+		S_IRUGO | S_IWUSR, debug->wiphy->debugfsdir,
+		&intf->offset_bbp);
+	if (IS_ERR(intf->bbp_off_entry))
+		goto exit;
+
+	intf->bbp_val_entry = debugfs_create_file("bbp_value",
+		S_IRUGO | S_IWUSR, debug->wiphy->debugfsdir, intf,
+		&rt2x00debug_fop_bbp);
+	if (IS_ERR(intf->bbp_val_entry))
+		goto exit;
+
+	return 0;
+
+exit:
+	rt2x00debug_deregister(debug);
+
+	return -ENOMEM;
+}
+EXPORT_SYMBOL_GPL(rt2x00debug_register);
+
+void rt2x00debug_deregister(struct rt2x00debug *debug)
+{
+	struct rt2x00debug_intf *intf = debug->priv;
+
+	if (!intf)
+		return;
+
+	debugfs_remove(intf->bbp_val_entry);
+	debugfs_remove(intf->bbp_off_entry);
+	debugfs_remove(intf->eeprom_val_entry);
+	debugfs_remove(intf->eeprom_off_entry);
+	debugfs_remove(intf->csr_val_entry);
+	debugfs_remove(intf->csr_off_entry);
+	debugfs_remove(intf->chipset_entry);
+	debugfs_remove(intf->driver_entry);
+	kfree(intf->chipset_blob.data);
+	kfree(intf->driver_blob.data);
+	kfree(intf);
+}
+EXPORT_SYMBOL_GPL(rt2x00debug_deregister);
+
+/*
+ * rt2x00debug module information.
+ */
+MODULE_AUTHOR("http://rt2x00.serialmonkey.com");
+MODULE_DESCRIPTION("Debugfs support for rt2x00 drivers.");
+MODULE_LICENSE("GPL");
+
+static int __init rt2x00debug_init(void)
+{
+	return 0;
+}
+
+static void __exit rt2x00debug_exit(void)
+{
+
+}
+
+module_init(rt2x00debug_init);
+module_exit(rt2x00debug_exit);
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00debug.h b/drivers/net/wireless/mac80211/rt2x00/rt2x00debug.h
new file mode 100644
index 0000000..9fd083b
--- /dev/null
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00debug.h
@@ -0,0 +1,84 @@
+/*
+	Copyright (C) 2004 - 2007 rt2x00 SourceForge Project
+	<http://rt2x00.serialmonkey.com>
+
+	This program is free software; you can redistribute it and/or modify
+	it under the terms of the GNU General Public License as published by
+	the Free Software Foundation; either version 2 of the License, or
+	(at your option) any later version.
+
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty of
+	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+	GNU General Public License for more details.
+
+	You should have received a copy of the GNU General Public License
+	along with this program; if not, write to the
+	Free Software Foundation, Inc.,
+	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+/*
+	Module: rt2x00debug
+	Abstract: Data structures for the rt2x00debug module.
+	Supported chipsets: RT2460, RT2560, RT2570,
+	rt2561, rt2561s, rt2661 & rt2573.
+ */
+
+#ifndef RT2X00DEBUG_H
+#define RT2X00DEBUG_H
+
+struct rt2x00_dev;
+
+typedef void (debug_access_t)(struct rt2x00_dev *rt2x00dev,
+	const unsigned long word, void *data);
+
+struct rt2x00debug_reg {
+	debug_access_t *read;
+	debug_access_t *write;
+
+	unsigned int word_size;
+	unsigned int length;
+};
+
+struct rt2x00debug {
+	/*
+	 * wiphy structure this entry belongs to.
+	 */
+	struct wiphy *wiphy;
+
+	/*
+	 * Reference to the modules structure.
+	 */
+	struct module *owner;
+
+	/*
+	 * Driver module information
+	 */
+	char *mod_name;
+	char *mod_version;
+
+	/*
+	 * Register access information.
+	 */
+	struct rt2x00debug_reg reg_csr;
+	struct rt2x00debug_reg reg_eeprom;
+	struct rt2x00debug_reg reg_bbp;
+
+	/*
+	 * Pointer to driver structure where
+	 * this debugfs entry belongs to.
+	 */
+	struct rt2x00_dev *rt2x00dev;
+
+	/*
+	 * Pointer to rt2x00debug private data,
+	 * individual driver should not touch this.
+	 */
+	void *priv;
+};
+
+extern int rt2x00debug_register(struct rt2x00debug *debug);
+extern void rt2x00debug_deregister(struct rt2x00debug *debug);
+
+#endif /* RT2X00DEBUG_H */
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
index 23232bc..a1c176d 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
@@ -276,6 +276,80 @@ static inline void rt2x00_desc_write(struct data_desc *desc,
 	desc->word[word] = cpu_to_le32(value);
 }
 
+#ifdef CONFIG_RT2X00_DEBUGFS
+#define CSR_OFFSET(__word)	( CSR_REG_BASE + ((__word) * sizeof(u32)) )
+
+static void rt61pci_read_csr(struct rt2x00_dev *rt2x00dev,
+	const unsigned long word, void *data)
+{
+	rt2x00_register_read(rt2x00dev, CSR_OFFSET(word), data);
+}
+
+static void rt61pci_write_csr(struct rt2x00_dev *rt2x00dev,
+	const unsigned long word, void *data)
+{
+	rt2x00_register_write(rt2x00dev, CSR_OFFSET(word), *((u32*)data));
+}
+
+static void rt61pci_read_eeprom(struct rt2x00_dev *rt2x00dev,
+	const unsigned long word, void *data)
+{
+	rt2x00_eeprom_read(rt2x00dev, word, (u16*)data);
+}
+
+static void rt61pci_write_eeprom(struct rt2x00_dev *rt2x00dev,
+	const unsigned long word, void *data)
+{
+	rt2x00_eeprom_write(rt2x00dev, word, *(u16*)data);
+}
+
+static void rt61pci_read_bbp(struct rt2x00_dev *rt2x00dev,
+	const unsigned long word, void *data)
+{
+	rt2x00_bbp_read(rt2x00dev, word, ((u8*)data));
+}
+
+static void rt61pci_write_bbp(struct rt2x00_dev *rt2x00dev,
+	const unsigned long word, void *data)
+{
+	rt2x00_bbp_write(rt2x00dev, word, *((u8*)data));
+}
+
+static void rt61pci_open_debugfs(struct rt2x00_dev *rt2x00dev)
+{
+	struct rt2x00debug *debug = &rt2x00dev->debug;
+
+	debug->wiphy			= rt2x00dev->hw->wiphy;
+	debug->owner 			= THIS_MODULE;
+	debug->mod_name			= DRV_NAME;
+	debug->mod_version		= DRV_VERSION;
+	debug->reg_csr.read		= rt61pci_read_csr;
+	debug->reg_csr.write		= rt61pci_write_csr;
+	debug->reg_csr.word_size	= sizeof(u32);
+	debug->reg_csr.length		= CSR_REG_SIZE;
+	debug->reg_eeprom.read		= rt61pci_read_eeprom;
+	debug->reg_eeprom.write		= rt61pci_write_eeprom;
+	debug->reg_eeprom.word_size	= sizeof(u16);
+	debug->reg_eeprom.length	= EEPROM_SIZE;
+	debug->reg_bbp.read		= rt61pci_read_bbp;
+	debug->reg_bbp.write		= rt61pci_write_bbp;
+	debug->reg_bbp.word_size	= sizeof(u8);
+	debug->reg_bbp.length		= BBP_SIZE;
+	debug->rt2x00dev 		= rt2x00dev;
+
+	if (rt2x00debug_register(debug))
+		ERROR("Failed to register debug handler.\n");
+}
+
+static void rt61pci_close_debugfs(struct rt2x00_dev *rt2x00dev)
+{
+	rt2x00debug_deregister(&rt2x00dev->debug);
+}
+#else /* CONFIG_RT2X00_DEBUGFS */
+static inline void rt61pci_open_debugfs(struct rt2x00_dev *rt2x00dev){}
+static inline void rt61pci_close_debugfs(struct rt2x00_dev *rt2x00dev){}
+#endif /* CONFIG_RT2X00_DEBUGFS */
+
 /*
  * Configuration handlers.
  */
@@ -3486,6 +3560,11 @@ static int rt61pci_init_hw(struct rt2x00_dev *rt2x00dev)
 static void rt61pci_free_dev(struct rt2x00_dev *rt2x00dev)
 {
 	/*
+	 * Close debugfs entry.
+	 */
+	rt61pci_close_debugfs(rt2x00dev);
+
+	/*
 	 * Free workqueue.
 	 */
 	if (likely(rt2x00dev->workqueue)) {
@@ -3590,6 +3669,11 @@ static int rt61pci_alloc_dev(struct pci_dev *pci_dev,
 		goto exit;
 	}
 
+	/*
+	 * Open the debugfs entry.
+	 */
+	rt61pci_open_debugfs(rt2x00dev);
+
 	return 0;
 
 exit:
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt61pci.h b/drivers/net/wireless/mac80211/rt2x00/rt61pci.h
index 6c7a16f..6db5e9c 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt61pci.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt61pci.h
@@ -54,6 +54,7 @@
 #define CSR_REG_SIZE			0x04b0
 #define EEPROM_BASE			0x0000
 #define EEPROM_SIZE			0x0100
+#define BBP_SIZE			0x0080
 
 /*
  * PCI registers.
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
index 2a9eb4d..680a589 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
@@ -283,6 +283,80 @@ static inline void rt2x00_desc_write(struct data_desc *desc,
 	desc->word[word] = cpu_to_le32(value);
 }
 
+#ifdef CONFIG_RT2X00_DEBUGFS
+#define CSR_OFFSET(__word)	( CSR_REG_BASE + ((__word) * sizeof(u32)) )
+
+static void rt73usb_read_csr(struct rt2x00_dev *rt2x00dev,
+	const unsigned long word, void *data)
+{
+	rt2x00_register_read(rt2x00dev, CSR_OFFSET(word), data);
+}
+
+static void rt73usb_write_csr(struct rt2x00_dev *rt2x00dev,
+	const unsigned long word, void *data)
+{
+	rt2x00_register_write(rt2x00dev, CSR_OFFSET(word), *((u32*)data));
+}
+
+static void rt73usb_read_eeprom(struct rt2x00_dev *rt2x00dev,
+	const unsigned long word, void *data)
+{
+	rt2x00_eeprom_read(rt2x00dev, word, (u16*)data);
+}
+
+static void rt73usb_write_eeprom(struct rt2x00_dev *rt2x00dev,
+	const unsigned long word, void *data)
+{
+	rt2x00_eeprom_write(rt2x00dev, word, *(u16*)data);
+}
+
+static void rt73usb_read_bbp(struct rt2x00_dev *rt2x00dev,
+	const unsigned long word, void *data)
+{
+	rt2x00_bbp_read(rt2x00dev, word, ((u8*)data));
+}
+
+static void rt73usb_write_bbp(struct rt2x00_dev *rt2x00dev,
+	const unsigned long word, void *data)
+{
+	rt2x00_bbp_write(rt2x00dev, word, *((u8*)data));
+}
+
+static void rt73usb_open_debugfs(struct rt2x00_dev *rt2x00dev)
+{
+	struct rt2x00debug *debug = &rt2x00dev->debug;
+
+	debug->wiphy			= rt2x00dev->hw->wiphy;
+	debug->owner 			= THIS_MODULE;
+	debug->mod_name			= DRV_NAME;
+	debug->mod_version		= DRV_VERSION;
+	debug->reg_csr.read		= rt73usb_read_csr;
+	debug->reg_csr.write		= rt73usb_write_csr;
+	debug->reg_csr.word_size	= sizeof(u32);
+	debug->reg_csr.length		= CSR_REG_SIZE;
+	debug->reg_eeprom.read		= rt73usb_read_eeprom;
+	debug->reg_eeprom.write		= rt73usb_write_eeprom;
+	debug->reg_eeprom.word_size	= sizeof(u16);
+	debug->reg_eeprom.length	= EEPROM_SIZE;
+	debug->reg_bbp.read		= rt73usb_read_bbp;
+	debug->reg_bbp.write		= rt73usb_write_bbp;
+	debug->reg_bbp.word_size	= sizeof(u8);
+	debug->reg_bbp.length		= BBP_SIZE;
+	debug->rt2x00dev 		= rt2x00dev;
+
+	if (rt2x00debug_register(debug))
+		ERROR("Failed to register debug handler.\n");
+}
+
+static void rt73usb_close_debugfs(struct rt2x00_dev *rt2x00dev)
+{
+	rt2x00debug_deregister(&rt2x00dev->debug);
+}
+#else /* CONFIG_RT2X00_DEBUGFS */
+static inline void rt73usb_open_debugfs(struct rt2x00_dev *rt2x00dev){}
+static inline void rt73usb_close_debugfs(struct rt2x00_dev *rt2x00dev){}
+#endif /* CONFIG_RT2X00_DEBUGFS */
+
 /*
  * Configuration handlers.
  */
@@ -3142,6 +3216,11 @@ static int rt73usb_init_hw(struct rt2x00_dev *rt2x00dev)
 static void rt73usb_free_dev(struct rt2x00_dev *rt2x00dev)
 {
 	/*
+	 * Close debugfs entry.
+	 */
+	rt73usb_close_debugfs(rt2x00dev);
+
+	/*
 	 * Free workqueue.
 	 */
 	if (likely(rt2x00dev->workqueue)) {
@@ -3227,6 +3306,11 @@ static int rt73usb_alloc_dev(struct usb_interface *usb_intf,
 		goto exit;
 	}
 
+	/*
+	 * Open the debugfs entry.
+	 */
+	rt73usb_open_debugfs(rt2x00dev);
+
 	return 0;
 
 exit:
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt73usb.h b/drivers/net/wireless/mac80211/rt2x00/rt73usb.h
index 372cc8b..4f7d338 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt73usb.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt73usb.h
@@ -52,6 +52,7 @@
 #define CSR_REG_SIZE			0x04b0
 #define EEPROM_BASE			0x0000
 #define EEPROM_SIZE			0x0100
+#define BBP_SIZE			0x0080
 
 /*
  * USB registers.
