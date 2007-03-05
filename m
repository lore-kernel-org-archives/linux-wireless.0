Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:60088 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbXCESUl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2007 13:20:41 -0500
Received: by ug-out-1314.google.com with SMTP id 44so1325818uga
        for <linux-wireless@vger.kernel.org>; Mon, 05 Mar 2007 10:20:35 -0800 (PST)
To: "John Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Make rt2x00debug structure interface independent
Date: Mon, 5 Mar 2007 19:20:24 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200703051920.25011.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rt2x00debug structure was 90% interface independent,
this patch will remove the last interface dependent fields
which allows us to make the rt2x00debug structure a static field
inside each rt2x00 driver.

This patch also moves the rt2x00 debugfs files into a seperate folder
_within_ the debugfs dentry provided by the wiphy structure. This will
prevent rt2x00 dentry file names to accidently interfere with dentry
files from others (i.e. mac80211).

This patch will make moving rt2x00debug into the rt2x00lib structure easier,
but that will be handled in a different patch later. ;)

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
index 93813bc..4f612a0 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
@@ -225,35 +225,40 @@ static void rt2400pci_write_bbp(struct rt2x00_dev *rt2x00dev,
 	rt2x00_bbp_write(rt2x00dev, word, *((u8*)data));
 }
 
+static struct rt2x00debug rt2400pci_rt2x00debug = {
+	.owner 		= THIS_MODULE,
+	.mod_name	= DRV_NAME,
+	.mod_version	= DRV_VERSION,
+	.reg_csr	= {
+		.read		= rt2400pci_read_csr,
+		.write		= rt2400pci_write_csr,
+		.word_size	= sizeof(u32),
+		.length		= CSR_REG_SIZE,
+	},
+	.reg_eeprom	= {
+		.read		= rt2400pci_read_eeprom,
+		.write		= rt2400pci_write_eeprom,
+		.word_size	= sizeof(u16),
+		.length		= EEPROM_SIZE,
+	},
+	.reg_bbp	= {
+		.read		= rt2400pci_read_bbp,
+		.write		= rt2400pci_write_bbp,
+		.word_size	= sizeof(u8),
+		.length		= BBP_SIZE,
+	},
+};
+
 static void rt2400pci_open_debugfs(struct rt2x00_dev *rt2x00dev)
 {
-	struct rt2x00debug *debug = &rt2x00dev->debug;
-
-	debug->wiphy			= rt2x00dev->hw->wiphy;
-	debug->owner 			= THIS_MODULE;
-	debug->mod_name			= DRV_NAME;
-	debug->mod_version		= DRV_VERSION;
-	debug->reg_csr.read		= rt2400pci_read_csr;
-	debug->reg_csr.write		= rt2400pci_write_csr;
-	debug->reg_csr.word_size	= sizeof(u32);
-	debug->reg_csr.length		= CSR_REG_SIZE;
-	debug->reg_eeprom.read		= rt2400pci_read_eeprom;
-	debug->reg_eeprom.write		= rt2400pci_write_eeprom;
-	debug->reg_eeprom.word_size	= sizeof(u16);
-	debug->reg_eeprom.length	= EEPROM_SIZE;
-	debug->reg_bbp.read		= rt2400pci_read_bbp;
-	debug->reg_bbp.write		= rt2400pci_write_bbp;
-	debug->reg_bbp.word_size	= sizeof(u8);
-	debug->reg_bbp.length		= BBP_SIZE;
-	debug->rt2x00dev 		= rt2x00dev;
-
-	if (rt2x00debug_register(debug))
+	if (!rt2x00debug_register(&rt2400pci_rt2x00debug,
+		rt2x00dev->hw->wiphy, rt2x00dev))
 		ERROR("Failed to register debug handler.\n");
 }
 
 static void rt2400pci_close_debugfs(struct rt2x00_dev *rt2x00dev)
 {
-	rt2x00debug_deregister(&rt2x00dev->debug);
+	rt2x00debug_deregister(&rt2x00dev->debugfs_data);
 }
 #else /* CONFIG_RT2X00_DEBUGFS */
 static inline void rt2400pci_open_debugfs(struct rt2x00_dev *rt2x00dev){}
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
index a4c8bdf..46ca323 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
@@ -225,35 +225,40 @@ static void rt2500pci_write_bbp(struct rt2x00_dev *rt2x00dev,
 	rt2x00_bbp_write(rt2x00dev, word, *((u8*)data));
 }
 
+static struct rt2x00debug rt2500pci_rt2x00debug = {
+	.owner 		= THIS_MODULE,
+	.mod_name	= DRV_NAME,
+	.mod_version	= DRV_VERSION,
+	.reg_csr	= {
+		.read		= rt2500pci_read_csr,
+		.write		= rt2500pci_write_csr,
+		.word_size	= sizeof(u32),
+		.length		= CSR_REG_SIZE,
+	},
+	.reg_eeprom	= {
+		.read		= rt2500pci_read_eeprom,
+		.write		= rt2500pci_write_eeprom,
+		.word_size	= sizeof(u16),
+		.length		= EEPROM_SIZE,
+	},
+	.reg_bbp	= {
+		.read		= rt2500pci_read_bbp,
+		.write		= rt2500pci_write_bbp,
+		.word_size	= sizeof(u8),
+		.length		= BBP_SIZE,
+	},
+};
+
 static void rt2500pci_open_debugfs(struct rt2x00_dev *rt2x00dev)
 {
-	struct rt2x00debug *debug = &rt2x00dev->debug;
-
-	debug->wiphy			= rt2x00dev->hw->wiphy;
-	debug->owner 			= THIS_MODULE;
-	debug->mod_name			= DRV_NAME;
-	debug->mod_version		= DRV_VERSION;
-	debug->reg_csr.read		= rt2500pci_read_csr;
-	debug->reg_csr.write		= rt2500pci_write_csr;
-	debug->reg_csr.word_size	= sizeof(u32);
-	debug->reg_csr.length		= CSR_REG_SIZE;
-	debug->reg_eeprom.read		= rt2500pci_read_eeprom;
-	debug->reg_eeprom.write		= rt2500pci_write_eeprom;
-	debug->reg_eeprom.word_size	= sizeof(u16);
-	debug->reg_eeprom.length	= EEPROM_SIZE;
-	debug->reg_bbp.read		= rt2500pci_read_bbp;
-	debug->reg_bbp.write		= rt2500pci_write_bbp;
-	debug->reg_bbp.word_size	= sizeof(u8);
-	debug->reg_bbp.length		= BBP_SIZE;
-	debug->rt2x00dev 		= rt2x00dev;
-
-	if (rt2x00debug_register(debug))
+	if (!rt2x00debug_register(&rt2500pci_rt2x00debug,
+		rt2x00dev->hw->wiphy, rt2x00dev))
 		ERROR("Failed to register debug handler.\n");
 }
 
 static void rt2500pci_close_debugfs(struct rt2x00_dev *rt2x00dev)
 {
-	rt2x00debug_deregister(&rt2x00dev->debug);
+	rt2x00debug_deregister(&rt2x00dev->debugfs_data);
 }
 #else /* CONFIG_RT2X00_DEBUGFS */
 static inline void rt2500pci_open_debugfs(struct rt2x00_dev *rt2x00dev){}
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
index f3521d8..8c2b955 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
@@ -267,35 +267,40 @@ static void rt2500usb_write_bbp(struct rt2x00_dev *rt2x00dev,
 	rt2x00_bbp_write(rt2x00dev, word, *((u8*)data));
 }
 
+static struct rt2x00debug rt2500usb_rt2x00debug = {
+	.owner 		= THIS_MODULE,
+	.mod_name	= DRV_NAME,
+	.mod_version	= DRV_VERSION,
+	.reg_csr	= {
+		.read		= rt2500usb_read_csr,
+		.write		= rt2500usb_write_csr,
+		.word_size	= sizeof(u16),
+		.length		= CSR_REG_SIZE,
+	},
+	.reg_eeprom	= {
+		.read		= rt2500usb_read_eeprom,
+		.write		= rt2500usb_write_eeprom,
+		.word_size	= sizeof(u16),
+		.length		= EEPROM_SIZE,
+	},
+	.reg_bbp	= {
+		.read		= rt2500usb_read_bbp,
+		.write		= rt2500usb_write_bbp,
+		.word_size	= sizeof(u8),
+		.length		= BBP_SIZE,
+	},
+};
+
 static void rt2500usb_open_debugfs(struct rt2x00_dev *rt2x00dev)
 {
-	struct rt2x00debug *debug = &rt2x00dev->debug;
-
-	debug->wiphy			= rt2x00dev->hw->wiphy;
-	debug->owner 			= THIS_MODULE;
-	debug->mod_name			= DRV_NAME;
-	debug->mod_version		= DRV_VERSION;
-	debug->reg_csr.read		= rt2500usb_read_csr;
-	debug->reg_csr.write		= rt2500usb_write_csr;
-	debug->reg_csr.word_size	= sizeof(u16);
-	debug->reg_csr.length		= CSR_REG_SIZE;
-	debug->reg_eeprom.read		= rt2500usb_read_eeprom;
-	debug->reg_eeprom.write		= rt2500usb_write_eeprom;
-	debug->reg_eeprom.word_size	= sizeof(u16);
-	debug->reg_eeprom.length	= EEPROM_SIZE;
-	debug->reg_bbp.read		= rt2500usb_read_bbp;
-	debug->reg_bbp.write		= rt2500usb_write_bbp;
-	debug->reg_bbp.word_size	= sizeof(u8);
-	debug->reg_bbp.length		= BBP_SIZE;
-	debug->rt2x00dev 		= rt2x00dev;
-
-	if (rt2x00debug_register(debug))
+	if (!rt2x00debug_register(&rt2500usb_rt2x00debug,
+		rt2x00dev->hw->wiphy, rt2x00dev))
 		ERROR("Failed to register debug handler.\n");
 }
 
 static void rt2500usb_close_debugfs(struct rt2x00_dev *rt2x00dev)
 {
-	rt2x00debug_deregister(&rt2x00dev->debug);
+	rt2x00debug_deregister(&rt2x00dev->debugfs_data);
 }
 #else /* CONFIG_RT2X00_DEBUGFS */
 static inline void rt2500usb_open_debugfs(struct rt2x00_dev *rt2x00dev){}
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00.h b/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
index 2bbcc6c..ea05d00 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
@@ -984,7 +984,7 @@ struct rt2x00_dev {
 	 * If enabled, the structure for the debugfs files.
 	 */
 #ifdef CONFIG_RT2X00_DEBUGFS
-	struct rt2x00debug debug;
+	void *debugfs_data;
 #endif /* CONFIG_RT2X00_DEBUGFS */
 
 	/*
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00debug.c b/drivers/net/wireless/mac80211/rt2x00/rt2x00debug.c
index d0697da..290fa12 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00debug.c
@@ -31,8 +31,6 @@
 #include <linux/init.h>
 #include <linux/debugfs.h>
 
-#include <net/wireless.h>
-
 #include <asm/uaccess.h>
 
 #include "rt2x00debug.h"
@@ -45,6 +43,12 @@
 
 struct rt2x00debug_intf {
 	/*
+	 * Pointer to driver structure where
+	 * this debugfs entry belongs to.
+	 */
+	struct rt2x00_dev *rt2x00dev;
+
+	/*
 	 * Reference to the rt2x00debug structure
 	 * which can be used to communicate with
 	 * the registers.
@@ -53,12 +57,14 @@ struct rt2x00debug_intf {
 
 	/*
 	 * Debugfs entries for:
+	 * - driver folder
 	 * - driver file
 	 * - chipset file
 	 * - register offset/value files
 	 * - eeprom offset/value files
 	 * - bbp offset/value files
 	 */
+	struct dentry *driver_folder;
 	struct dentry *driver_entry;
 	struct dentry *chipset_entry;
 	struct dentry *csr_off_entry;
@@ -184,7 +190,7 @@ exit:
 		if (intf->offset_##__name > reg->length)		\
 			return -EINVAL;					\
 									\
-		return rt2x00debug_file_read(debug->rt2x00dev, buf,	\
+		return rt2x00debug_file_read(intf->rt2x00dev, buf,	\
 			offset, intf->offset_##__name, reg);		\
 	}
 
@@ -203,7 +209,7 @@ RT2X00DEBUGFS_OPS_READ(bbp);
 		if (intf->offset_##__name > reg->length)		\
 			return -EINVAL;					\
 									\
-		return rt2x00debug_file_write(debug->rt2x00dev, buf,	\
+		return rt2x00debug_file_write(intf->rt2x00dev, buf,	\
 			offset, intf->offset_##__name, length, reg);	\
 	}
 
@@ -240,8 +246,7 @@ static struct dentry *rt2x00debug_create_file_driver(const char *name,
 	data += sprintf(data, "compiled: %s %s\n", __DATE__, __TIME__);
 	blob->size = strlen(blob->data);
 
-	return debugfs_create_blob(name, S_IRUGO,
-		debug->wiphy->debugfsdir, blob);
+	return debugfs_create_blob(name, S_IRUGO, intf->driver_folder, blob);
 }
 
 static struct dentry *rt2x00debug_create_file_chipset(const char *name,
@@ -260,20 +265,25 @@ static struct dentry *rt2x00debug_create_file_chipset(const char *name,
 	data += sprintf(data, "bbp length: %d\n", debug->reg_bbp.length);
 	blob->size = strlen(blob->data);
 
-	return debugfs_create_blob(name, S_IRUGO,
-		debug->wiphy->debugfsdir, blob);
+	return debugfs_create_blob(name, S_IRUGO, intf->driver_folder, blob);
 }
 
-int rt2x00debug_register(struct rt2x00debug *debug)
+void *rt2x00debug_register(struct rt2x00debug *debug, struct wiphy *wiphy,
+	struct rt2x00_dev *rt2x00dev)
 {
 	struct rt2x00debug_intf *intf;
 
 	intf = kzalloc(sizeof(struct rt2x00debug_intf), GFP_KERNEL);
 	if (!intf)
-		return -ENOMEM;
+		return NULL;
 
 	intf->debug = debug;
-	debug->priv = intf;
+	intf->rt2x00dev = rt2x00dev;
+
+	intf->driver_folder = debugfs_create_dir(debug->mod_name,
+		wiphy->debugfsdir);
+	if (IS_ERR(intf->driver_folder))
+		goto exit;
 
 	intf->driver_entry = rt2x00debug_create_file_driver("driver",
 		intf, &intf->driver_blob);
@@ -286,53 +296,50 @@ int rt2x00debug_register(struct rt2x00debug *debug)
 		goto exit;
 
 	intf->csr_off_entry = debugfs_create_u32("csr_offset",
-		S_IRUGO | S_IWUSR, debug->wiphy->debugfsdir,
-		&intf->offset_csr);
+		S_IRUGO | S_IWUSR, intf->driver_folder, &intf->offset_csr);
 	if (IS_ERR(intf->csr_off_entry))
 		goto exit;
 
 	intf->csr_val_entry = debugfs_create_file("csr_value",
-		S_IRUGO | S_IWUSR, debug->wiphy->debugfsdir, intf,
+		S_IRUGO | S_IWUSR, intf->driver_folder, intf,
 		&rt2x00debug_fop_csr);
 	if (IS_ERR(intf->csr_val_entry))
 		goto exit;
 
 	intf->eeprom_off_entry = debugfs_create_u32("eeprom_offset",
-		S_IRUGO | S_IWUSR, debug->wiphy->debugfsdir,
-		&intf->offset_eeprom);
+		S_IRUGO | S_IWUSR, intf->driver_folder, &intf->offset_eeprom);
 	if (IS_ERR(intf->eeprom_off_entry))
 		goto exit;
 
 	intf->eeprom_val_entry = debugfs_create_file("eeprom_value",
-		S_IRUGO | S_IWUSR, debug->wiphy->debugfsdir, intf,
+		S_IRUGO | S_IWUSR, intf->driver_folder, intf,
 		&rt2x00debug_fop_eeprom);
 	if (IS_ERR(intf->eeprom_val_entry))
 		goto exit;
 
 	intf->bbp_off_entry = debugfs_create_u32("bbp_offset",
-		S_IRUGO | S_IWUSR, debug->wiphy->debugfsdir,
-		&intf->offset_bbp);
+		S_IRUGO | S_IWUSR, intf->driver_folder, &intf->offset_bbp);
 	if (IS_ERR(intf->bbp_off_entry))
 		goto exit;
 
 	intf->bbp_val_entry = debugfs_create_file("bbp_value",
-		S_IRUGO | S_IWUSR, debug->wiphy->debugfsdir, intf,
+		S_IRUGO | S_IWUSR, intf->driver_folder, intf,
 		&rt2x00debug_fop_bbp);
 	if (IS_ERR(intf->bbp_val_entry))
 		goto exit;
 
-	return 0;
+	return intf;
 
 exit:
 	rt2x00debug_deregister(debug);
 
-	return -ENOMEM;
+	return NULL;
 }
 EXPORT_SYMBOL_GPL(rt2x00debug_register);
 
-void rt2x00debug_deregister(struct rt2x00debug *debug)
+void rt2x00debug_deregister(void *debugfs_data)
 {
-	struct rt2x00debug_intf *intf = debug->priv;
+	struct rt2x00debug_intf *intf = debugfs_data;
 
 	if (!intf)
 		return;
@@ -345,6 +352,7 @@ void rt2x00debug_deregister(struct rt2x00debug *debug)
 	debugfs_remove(intf->csr_off_entry);
 	debugfs_remove(intf->chipset_entry);
 	debugfs_remove(intf->driver_entry);
+	debugfs_remove(intf->driver_folder);
 	kfree(intf->chipset_blob.data);
 	kfree(intf->driver_blob.data);
 	kfree(intf);
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00debug.h b/drivers/net/wireless/mac80211/rt2x00/rt2x00debug.h
index 9fd083b..ef8401d 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00debug.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00debug.h
@@ -28,6 +28,8 @@
 #ifndef RT2X00DEBUG_H
 #define RT2X00DEBUG_H
 
+#include <net/wireless.h>
+
 struct rt2x00_dev;
 
 typedef void (debug_access_t)(struct rt2x00_dev *rt2x00dev,
@@ -43,11 +45,6 @@ struct rt2x00debug_reg {
 
 struct rt2x00debug {
 	/*
-	 * wiphy structure this entry belongs to.
-	 */
-	struct wiphy *wiphy;
-
-	/*
 	 * Reference to the modules structure.
 	 */
 	struct module *owner;
@@ -64,21 +61,10 @@ struct rt2x00debug {
 	struct rt2x00debug_reg reg_csr;
 	struct rt2x00debug_reg reg_eeprom;
 	struct rt2x00debug_reg reg_bbp;
-
-	/*
-	 * Pointer to driver structure where
-	 * this debugfs entry belongs to.
-	 */
-	struct rt2x00_dev *rt2x00dev;
-
-	/*
-	 * Pointer to rt2x00debug private data,
-	 * individual driver should not touch this.
-	 */
-	void *priv;
 };
 
-extern int rt2x00debug_register(struct rt2x00debug *debug);
-extern void rt2x00debug_deregister(struct rt2x00debug *debug);
+void *rt2x00debug_register(struct rt2x00debug *debug, struct wiphy *wiphy,
+	struct rt2x00_dev *rt2x00dev);
+void rt2x00debug_deregister(void *debugfs_data);
 
 #endif /* RT2X00DEBUG_H */
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
index b34c290..029b506 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
@@ -256,35 +256,40 @@ static void rt61pci_write_bbp(struct rt2x00_dev *rt2x00dev,
 	rt2x00_bbp_write(rt2x00dev, word, *((u8*)data));
 }
 
+static struct rt2x00debug rt61pci_rt2x00debug = {
+	.owner 		= THIS_MODULE,
+	.mod_name	= DRV_NAME,
+	.mod_version	= DRV_VERSION,
+	.reg_csr	= {
+		.read		= rt61pci_read_csr,
+		.write		= rt61pci_write_csr,
+		.word_size	= sizeof(u32),
+		.length		= CSR_REG_SIZE,
+	},
+	.reg_eeprom	= {
+		.read		= rt61pci_read_eeprom,
+		.write		= rt61pci_write_eeprom,
+		.word_size	= sizeof(u16),
+		.length		= EEPROM_SIZE,
+	},
+	.reg_bbp	= {
+		.read		= rt61pci_read_bbp,
+		.write		= rt61pci_write_bbp,
+		.word_size	= sizeof(u8),
+		.length		= BBP_SIZE,
+	},
+};
+
 static void rt61pci_open_debugfs(struct rt2x00_dev *rt2x00dev)
 {
-	struct rt2x00debug *debug = &rt2x00dev->debug;
-
-	debug->wiphy			= rt2x00dev->hw->wiphy;
-	debug->owner 			= THIS_MODULE;
-	debug->mod_name			= DRV_NAME;
-	debug->mod_version		= DRV_VERSION;
-	debug->reg_csr.read		= rt61pci_read_csr;
-	debug->reg_csr.write		= rt61pci_write_csr;
-	debug->reg_csr.word_size	= sizeof(u32);
-	debug->reg_csr.length		= CSR_REG_SIZE;
-	debug->reg_eeprom.read		= rt61pci_read_eeprom;
-	debug->reg_eeprom.write		= rt61pci_write_eeprom;
-	debug->reg_eeprom.word_size	= sizeof(u16);
-	debug->reg_eeprom.length	= EEPROM_SIZE;
-	debug->reg_bbp.read		= rt61pci_read_bbp;
-	debug->reg_bbp.write		= rt61pci_write_bbp;
-	debug->reg_bbp.word_size	= sizeof(u8);
-	debug->reg_bbp.length		= BBP_SIZE;
-	debug->rt2x00dev 		= rt2x00dev;
-
-	if (rt2x00debug_register(debug))
+	if (!rt2x00debug_register(&rt61pci_rt2x00debug,
+		rt2x00dev->hw->wiphy, rt2x00dev))
 		ERROR("Failed to register debug handler.\n");
 }
 
 static void rt61pci_close_debugfs(struct rt2x00_dev *rt2x00dev)
 {
-	rt2x00debug_deregister(&rt2x00dev->debug);
+	rt2x00debug_deregister(&rt2x00dev->debugfs_data);
 }
 #else /* CONFIG_RT2X00_DEBUGFS */
 static inline void rt61pci_open_debugfs(struct rt2x00_dev *rt2x00dev){}
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
index cf42ab8..c27bdcc 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
@@ -263,35 +263,40 @@ static void rt73usb_write_bbp(struct rt2x00_dev *rt2x00dev,
 	rt2x00_bbp_write(rt2x00dev, word, *((u8*)data));
 }
 
+static struct rt2x00debug rt73usb_rt2x00debug = {
+	.owner 		= THIS_MODULE,
+	.mod_name	= DRV_NAME,
+	.mod_version	= DRV_VERSION,
+	.reg_csr	= {
+		.read		= rt73usb_read_csr,
+		.write		= rt73usb_write_csr,
+		.word_size	= sizeof(u32),
+		.length		= CSR_REG_SIZE,
+	},
+	.reg_eeprom	= {
+		.read		= rt73usb_read_eeprom,
+		.write		= rt73usb_write_eeprom,
+		.word_size	= sizeof(u16),
+		.length		= EEPROM_SIZE,
+	},
+	.reg_bbp	= {
+		.read		= rt73usb_read_bbp,
+		.write		= rt73usb_write_bbp,
+		.word_size	= sizeof(u8),
+		.length		= BBP_SIZE,
+	},
+};
+
 static void rt73usb_open_debugfs(struct rt2x00_dev *rt2x00dev)
 {
-	struct rt2x00debug *debug = &rt2x00dev->debug;
-
-	debug->wiphy			= rt2x00dev->hw->wiphy;
-	debug->owner 			= THIS_MODULE;
-	debug->mod_name			= DRV_NAME;
-	debug->mod_version		= DRV_VERSION;
-	debug->reg_csr.read		= rt73usb_read_csr;
-	debug->reg_csr.write		= rt73usb_write_csr;
-	debug->reg_csr.word_size	= sizeof(u32);
-	debug->reg_csr.length		= CSR_REG_SIZE;
-	debug->reg_eeprom.read		= rt73usb_read_eeprom;
-	debug->reg_eeprom.write		= rt73usb_write_eeprom;
-	debug->reg_eeprom.word_size	= sizeof(u16);
-	debug->reg_eeprom.length	= EEPROM_SIZE;
-	debug->reg_bbp.read		= rt73usb_read_bbp;
-	debug->reg_bbp.write		= rt73usb_write_bbp;
-	debug->reg_bbp.word_size	= sizeof(u8);
-	debug->reg_bbp.length		= BBP_SIZE;
-	debug->rt2x00dev 		= rt2x00dev;
-
-	if (rt2x00debug_register(debug))
+	if (!rt2x00debug_register(&rt73usb_rt2x00debug,
+		rt2x00dev->hw->wiphy, rt2x00dev))
 		ERROR("Failed to register debug handler.\n");
 }
 
 static void rt73usb_close_debugfs(struct rt2x00_dev *rt2x00dev)
 {
-	rt2x00debug_deregister(&rt2x00dev->debug);
+	rt2x00debug_deregister(&rt2x00dev->debugfs_data);
 }
 #else /* CONFIG_RT2X00_DEBUGFS */
 static inline void rt73usb_open_debugfs(struct rt2x00_dev *rt2x00dev){}
