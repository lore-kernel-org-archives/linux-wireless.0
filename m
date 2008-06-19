Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:33114 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754116AbYFSRhF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 13:37:05 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Add debugfs files for random SHM access
Date: Thu, 19 Jun 2008 19:33:51 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200806191933.52218.mb@bu3sch.de> (sfid-20080619_193710_884275_7CDAEE93)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds debugfs files for random SHM access.
This is needed in order to implement firmware and driver debugging
scripts in userspace.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---


John, please apply this to 2.6.27


Index: wireless-testing/drivers/net/wireless/b43/debugfs.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/debugfs.c	2008-06-18 23:57:39.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/debugfs.c	2008-06-19 12:49:10.000000000 +0200
@@ -71,12 +71,174 @@ struct b43_dfs_file * fops_to_dfs_file(s
 					  fmt , ##x);		\
 		else						\
 			printk(KERN_ERR "b43: fappend overflow\n"); \
 	} while (0)
 
 
+/* The biggest address values for SHM access from the debugfs files. */
+#define B43_MAX_SHM_ROUTING	4
+#define B43_MAX_SHM_ADDR	0xFFFF
+
+static ssize_t shm16read__read_file(struct b43_wldev *dev,
+				    char *buf, size_t bufsize)
+{
+	ssize_t count = 0;
+	unsigned int routing, addr;
+	u16 val;
+
+	routing = dev->dfsentry->shm16read_routing_next;
+	addr = dev->dfsentry->shm16read_addr_next;
+	if ((routing > B43_MAX_SHM_ROUTING) ||
+	    (addr > B43_MAX_SHM_ADDR))
+		return -EDESTADDRREQ;
+
+	val = b43_shm_read16(dev, routing, addr);
+	fappend("0x%04X\n", val);
+
+	return count;
+}
+
+static int shm16read__write_file(struct b43_wldev *dev,
+				 const char *buf, size_t count)
+{
+	unsigned int routing, addr;
+	int res;
+
+	res = sscanf(buf, "0x%X 0x%X", &routing, &addr);
+	if (res != 2)
+		return -EINVAL;
+	if (routing > B43_MAX_SHM_ROUTING)
+		return -EADDRNOTAVAIL;
+	if (addr > B43_MAX_SHM_ADDR)
+		return -EADDRNOTAVAIL;
+	if (routing == B43_SHM_SHARED) {
+		if ((addr % 2) != 0)
+			return -EADDRNOTAVAIL;
+	}
+
+	dev->dfsentry->shm16read_routing_next = routing;
+	dev->dfsentry->shm16read_addr_next = addr;
+
+	return 0;
+}
+
+static int shm16write__write_file(struct b43_wldev *dev,
+				  const char *buf, size_t count)
+{
+	unsigned int routing, addr, mask, set;
+	u16 val;
+	int res;
+	unsigned long flags;
+
+	res = sscanf(buf, "0x%X 0x%X 0x%X 0x%X",
+		     &routing, &addr, &mask, &set);
+	if (res != 4)
+		return -EINVAL;
+	if (routing > B43_MAX_SHM_ROUTING)
+		return -EADDRNOTAVAIL;
+	if (addr > B43_MAX_SHM_ADDR)
+		return -EADDRNOTAVAIL;
+	if (routing == B43_SHM_SHARED) {
+		if ((addr % 2) != 0)
+			return -EADDRNOTAVAIL;
+	}
+	if ((mask > 0xFFFF) || (set > 0xFFFF))
+		return -E2BIG;
+
+	spin_lock_irqsave(&dev->wl->shm_lock, flags);
+	if (mask == 0)
+		val = 0;
+	else
+		val = __b43_shm_read16(dev, routing, addr);
+	val &= mask;
+	val |= set;
+	__b43_shm_write16(dev, routing, addr, val);
+	spin_unlock_irqrestore(&dev->wl->shm_lock, flags);
+
+	return 0;
+}
+
+static ssize_t shm32read__read_file(struct b43_wldev *dev,
+				    char *buf, size_t bufsize)
+{
+	ssize_t count = 0;
+	unsigned int routing, addr;
+	u32 val;
+
+	routing = dev->dfsentry->shm32read_routing_next;
+	addr = dev->dfsentry->shm32read_addr_next;
+	if ((routing > B43_MAX_SHM_ROUTING) ||
+	    (addr > B43_MAX_SHM_ADDR))
+		return -EDESTADDRREQ;
+
+	val = b43_shm_read32(dev, routing, addr);
+	fappend("0x%08X\n", val);
+
+	return count;
+}
+
+static int shm32read__write_file(struct b43_wldev *dev,
+				 const char *buf, size_t count)
+{
+	unsigned int routing, addr;
+	int res;
+
+	res = sscanf(buf, "0x%X 0x%X", &routing, &addr);
+	if (res != 2)
+		return -EINVAL;
+	if (routing > B43_MAX_SHM_ROUTING)
+		return -EADDRNOTAVAIL;
+	if (addr > B43_MAX_SHM_ADDR)
+		return -EADDRNOTAVAIL;
+	if (routing == B43_SHM_SHARED) {
+		if ((addr % 2) != 0)
+			return -EADDRNOTAVAIL;
+	}
+
+	dev->dfsentry->shm32read_routing_next = routing;
+	dev->dfsentry->shm32read_addr_next = addr;
+
+	return 0;
+}
+
+static int shm32write__write_file(struct b43_wldev *dev,
+				  const char *buf, size_t count)
+{
+	unsigned int routing, addr, mask, set;
+	u32 val;
+	int res;
+	unsigned long flags;
+
+	res = sscanf(buf, "0x%X 0x%X 0x%X 0x%X",
+		     &routing, &addr, &mask, &set);
+	if (res != 4)
+		return -EINVAL;
+	if (routing > B43_MAX_SHM_ROUTING)
+		return -EADDRNOTAVAIL;
+	if (addr > B43_MAX_SHM_ADDR)
+		return -EADDRNOTAVAIL;
+	if (routing == B43_SHM_SHARED) {
+		if ((addr % 2) != 0)
+			return -EADDRNOTAVAIL;
+	}
+	if ((mask > 0xFFFFFFFF) || (set > 0xFFFFFFFF))
+		return -E2BIG;
+
+	spin_lock_irqsave(&dev->wl->shm_lock, flags);
+	if (mask == 0)
+		val = 0;
+	else
+		val = __b43_shm_read32(dev, routing, addr);
+	val &= mask;
+	val |= set;
+	__b43_shm_write32(dev, routing, addr, val);
+	spin_unlock_irqrestore(&dev->wl->shm_lock, flags);
+
+	return 0;
+}
+
 /* The biggest MMIO address that we allow access to from the debugfs files. */
 #define B43_MAX_MMIO_ACCESS	(0xF00 - 1)
 
 static ssize_t mmio16read__read_file(struct b43_wldev *dev,
 				     char *buf, size_t bufsize)
 {
@@ -602,12 +764,16 @@ out_unlock:
 		},						\
 		.file_struct_offset = offsetof(struct b43_dfsentry, \
 					       file_##name),	\
 		.take_irqlock	= _take_irqlock,		\
 	}
 
+B43_DEBUGFS_FOPS(shm16read, shm16read__read_file, shm16read__write_file, 1);
+B43_DEBUGFS_FOPS(shm16write, NULL, shm16write__write_file, 1);
+B43_DEBUGFS_FOPS(shm32read, shm32read__read_file, shm32read__write_file, 1);
+B43_DEBUGFS_FOPS(shm32write, NULL, shm32write__write_file, 1);
 B43_DEBUGFS_FOPS(mmio16read, mmio16read__read_file, mmio16read__write_file, 1);
 B43_DEBUGFS_FOPS(mmio16write, NULL, mmio16write__write_file, 1);
 B43_DEBUGFS_FOPS(mmio32read, mmio32read__read_file, mmio32read__write_file, 1);
 B43_DEBUGFS_FOPS(mmio32write, NULL, mmio32write__write_file, 1);
 B43_DEBUGFS_FOPS(tsf, tsf_read_file, tsf_write_file, 1);
 B43_DEBUGFS_FOPS(ucode_regs, ucode_regs_read_file, NULL, 1);
@@ -696,12 +862,16 @@ void b43_debugfs_add_device(struct b43_w
 		kfree(e);
 		return;
 	}
 
 	e->mmio16read_next = 0xFFFF; /* invalid address */
 	e->mmio32read_next = 0xFFFF; /* invalid address */
+	e->shm16read_routing_next = 0xFFFFFFFF; /* invalid routing */
+	e->shm16read_addr_next = 0xFFFFFFFF; /* invalid address */
+	e->shm32read_routing_next = 0xFFFFFFFF; /* invalid routing */
+	e->shm32read_addr_next = 0xFFFFFFFF; /* invalid address */
 
 #define ADD_FILE(name, mode)	\
 	do {							\
 		struct dentry *d;				\
 		d = debugfs_create_file(__stringify(name),	\
 					mode, e->subdir, dev,	\
@@ -709,12 +879,16 @@ void b43_debugfs_add_device(struct b43_w
 		e->file_##name.dentry = NULL;			\
 		if (!IS_ERR(d))					\
 			e->file_##name.dentry = d;		\
 	} while (0)
 
 
+	ADD_FILE(shm16read, 0600);
+	ADD_FILE(shm16write, 0200);
+	ADD_FILE(shm32read, 0600);
+	ADD_FILE(shm32write, 0200);
 	ADD_FILE(mmio16read, 0600);
 	ADD_FILE(mmio16write, 0200);
 	ADD_FILE(mmio32read, 0600);
 	ADD_FILE(mmio32write, 0200);
 	ADD_FILE(tsf, 0600);
 	ADD_FILE(ucode_regs, 0400);
@@ -737,12 +911,16 @@ void b43_debugfs_remove_device(struct b4
 		return;
 	e = dev->dfsentry;
 	if (!e)
 		return;
 	b43_remove_dynamic_debug(dev);
 
+	debugfs_remove(e->file_shm16read.dentry);
+	debugfs_remove(e->file_shm16write.dentry);
+	debugfs_remove(e->file_shm32read.dentry);
+	debugfs_remove(e->file_shm32write.dentry);
 	debugfs_remove(e->file_mmio16read.dentry);
 	debugfs_remove(e->file_mmio16write.dentry);
 	debugfs_remove(e->file_mmio32read.dentry);
 	debugfs_remove(e->file_mmio32write.dentry);
 	debugfs_remove(e->file_tsf.dentry);
 	debugfs_remove(e->file_ucode_regs.dentry);
Index: wireless-testing/drivers/net/wireless/b43/debugfs.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/debugfs.h	2008-06-18 23:20:41.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/debugfs.h	2008-06-19 12:43:17.000000000 +0200
@@ -33,12 +33,16 @@ struct b43_dfs_file {
 };
 
 struct b43_dfsentry {
 	struct b43_wldev *dev;
 	struct dentry *subdir;
 
+	struct b43_dfs_file file_shm16read;
+	struct b43_dfs_file file_shm16write;
+	struct b43_dfs_file file_shm32read;
+	struct b43_dfs_file file_shm32write;
 	struct b43_dfs_file file_mmio16read;
 	struct b43_dfs_file file_mmio16write;
 	struct b43_dfs_file file_mmio32read;
 	struct b43_dfs_file file_mmio32write;
 	struct b43_dfs_file file_tsf;
 	struct b43_dfs_file file_ucode_regs;
@@ -52,12 +56,19 @@ struct b43_dfsentry {
 
 	/* The cached address for the next mmio16read file read */
 	u16 mmio16read_next;
 	/* The cached address for the next mmio32read file read */
 	u16 mmio32read_next;
 
+	/* The cached address for the next shm16read file read */
+	u32 shm16read_routing_next;
+	u32 shm16read_addr_next;
+	/* The cached address for the next shm32read file read */
+	u32 shm32read_routing_next;
+	u32 shm32read_addr_next;
+
 	/* Enabled/Disabled list for the dynamic debugging features. */
 	u32 dyn_debug[__B43_NR_DYNDBG];
 	/* Dentries for the dynamic debugging entries. */
 	struct dentry *dyn_debug_dentries[__B43_NR_DYNDBG];
 };
 
Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-06-18 20:15:01.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2008-06-19 12:52:47.000000000 +0200
@@ -370,19 +370,16 @@ static inline void b43_shm_control_word(
 	control = routing;
 	control <<= 16;
 	control |= offset;
 	b43_write32(dev, B43_MMIO_SHM_CONTROL, control);
 }
 
-u32 b43_shm_read32(struct b43_wldev *dev, u16 routing, u16 offset)
+u32 __b43_shm_read32(struct b43_wldev *dev, u16 routing, u16 offset)
 {
-	struct b43_wl *wl = dev->wl;
-	unsigned long flags;
 	u32 ret;
 
-	spin_lock_irqsave(&wl->shm_lock, flags);
 	if (routing == B43_SHM_SHARED) {
 		B43_WARN_ON(offset & 0x0001);
 		if (offset & 0x0003) {
 			/* Unaligned access */
 			b43_shm_control_word(dev, routing, offset >> 2);
 			ret = b43_read16(dev, B43_MMIO_SHM_DATA_UNALIGNED);
@@ -394,24 +391,32 @@ u32 b43_shm_read32(struct b43_wldev *dev
 		}
 		offset >>= 2;
 	}
 	b43_shm_control_word(dev, routing, offset);
 	ret = b43_read32(dev, B43_MMIO_SHM_DATA);
 out:
-	spin_unlock_irqrestore(&wl->shm_lock, flags);
-
 	return ret;
 }
 
-u16 b43_shm_read16(struct b43_wldev * dev, u16 routing, u16 offset)
+u32 b43_shm_read32(struct b43_wldev *dev, u16 routing, u16 offset)
 {
 	struct b43_wl *wl = dev->wl;
 	unsigned long flags;
-	u16 ret;
+	u32 ret;
 
 	spin_lock_irqsave(&wl->shm_lock, flags);
+	ret = __b43_shm_read32(dev, routing, offset);
+	spin_unlock_irqrestore(&wl->shm_lock, flags);
+
+	return ret;
+}
+
+u16 __b43_shm_read16(struct b43_wldev *dev, u16 routing, u16 offset)
+{
+	u16 ret;
+
 	if (routing == B43_SHM_SHARED) {
 		B43_WARN_ON(offset & 0x0001);
 		if (offset & 0x0003) {
 			/* Unaligned access */
 			b43_shm_control_word(dev, routing, offset >> 2);
 			ret = b43_read16(dev, B43_MMIO_SHM_DATA_UNALIGNED);
@@ -420,61 +425,80 @@ u16 b43_shm_read16(struct b43_wldev * de
 		}
 		offset >>= 2;
 	}
 	b43_shm_control_word(dev, routing, offset);
 	ret = b43_read16(dev, B43_MMIO_SHM_DATA);
 out:
-	spin_unlock_irqrestore(&wl->shm_lock, flags);
-
 	return ret;
 }
 
-void b43_shm_write32(struct b43_wldev *dev, u16 routing, u16 offset, u32 value)
+u16 b43_shm_read16(struct b43_wldev *dev, u16 routing, u16 offset)
 {
 	struct b43_wl *wl = dev->wl;
 	unsigned long flags;
+	u16 ret;
 
 	spin_lock_irqsave(&wl->shm_lock, flags);
+	ret = __b43_shm_read16(dev, routing, offset);
+	spin_unlock_irqrestore(&wl->shm_lock, flags);
+
+	return ret;
+}
+
+void __b43_shm_write32(struct b43_wldev *dev, u16 routing, u16 offset, u32 value)
+{
 	if (routing == B43_SHM_SHARED) {
 		B43_WARN_ON(offset & 0x0001);
 		if (offset & 0x0003) {
 			/* Unaligned access */
 			b43_shm_control_word(dev, routing, offset >> 2);
 			b43_write16(dev, B43_MMIO_SHM_DATA_UNALIGNED,
 				    (value >> 16) & 0xffff);
 			b43_shm_control_word(dev, routing, (offset >> 2) + 1);
 			b43_write16(dev, B43_MMIO_SHM_DATA, value & 0xffff);
-			goto out;
+			return;
 		}
 		offset >>= 2;
 	}
 	b43_shm_control_word(dev, routing, offset);
 	b43_write32(dev, B43_MMIO_SHM_DATA, value);
-out:
-	spin_unlock_irqrestore(&wl->shm_lock, flags);
 }
 
-void b43_shm_write16(struct b43_wldev *dev, u16 routing, u16 offset, u16 value)
+void b43_shm_write32(struct b43_wldev *dev, u16 routing, u16 offset, u32 value)
 {
 	struct b43_wl *wl = dev->wl;
 	unsigned long flags;
 
 	spin_lock_irqsave(&wl->shm_lock, flags);
+	__b43_shm_write32(dev, routing, offset, value);
+	spin_unlock_irqrestore(&wl->shm_lock, flags);
+}
+
+void __b43_shm_write16(struct b43_wldev *dev, u16 routing, u16 offset, u16 value)
+{
 	if (routing == B43_SHM_SHARED) {
 		B43_WARN_ON(offset & 0x0001);
 		if (offset & 0x0003) {
 			/* Unaligned access */
 			b43_shm_control_word(dev, routing, offset >> 2);
 			b43_write16(dev, B43_MMIO_SHM_DATA_UNALIGNED, value);
-			goto out;
+			return;
 		}
 		offset >>= 2;
 	}
 	b43_shm_control_word(dev, routing, offset);
 	b43_write16(dev, B43_MMIO_SHM_DATA, value);
-out:
+}
+
+void b43_shm_write16(struct b43_wldev *dev, u16 routing, u16 offset, u16 value)
+{
+	struct b43_wl *wl = dev->wl;
+	unsigned long flags;
+
+	spin_lock_irqsave(&wl->shm_lock, flags);
+	__b43_shm_write16(dev, routing, offset, value);
 	spin_unlock_irqrestore(&wl->shm_lock, flags);
 }
 
 /* Read HostFlags */
 u64 b43_hf_read(struct b43_wldev * dev)
 {
Index: wireless-testing/drivers/net/wireless/b43/main.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.h	2008-06-15 15:48:06.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.h	2008-06-19 12:49:30.000000000 +0200
@@ -92,15 +92,19 @@ u8 b43_ieee80211_antenna_sanitize(struct
 				  u8 antenna_nr);
 
 void b43_tsf_read(struct b43_wldev *dev, u64 * tsf);
 void b43_tsf_write(struct b43_wldev *dev, u64 tsf);
 
 u32 b43_shm_read32(struct b43_wldev *dev, u16 routing, u16 offset);
+u32 __b43_shm_read32(struct b43_wldev *dev, u16 routing, u16 offset);
 u16 b43_shm_read16(struct b43_wldev *dev, u16 routing, u16 offset);
+u16 __b43_shm_read16(struct b43_wldev *dev, u16 routing, u16 offset);
 void b43_shm_write32(struct b43_wldev *dev, u16 routing, u16 offset, u32 value);
+void __b43_shm_write32(struct b43_wldev *dev, u16 routing, u16 offset, u32 value);
 void b43_shm_write16(struct b43_wldev *dev, u16 routing, u16 offset, u16 value);
+void __b43_shm_write16(struct b43_wldev *dev, u16 routing, u16 offset, u16 value);
 
 u64 b43_hf_read(struct b43_wldev *dev);
 void b43_hf_write(struct b43_wldev *dev, u64 value);
 
 void b43_dummy_transmission(struct b43_wldev *dev);
 
