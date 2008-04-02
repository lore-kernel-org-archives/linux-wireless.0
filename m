Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:54360 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847AbYDBRul (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 13:50:41 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] ssb: Add support for block-I/O
Date: Wed, 2 Apr 2008 19:46:56 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200804021946.56310.mb@bu3sch.de> (sfid-20080402_185044_736211_9DD6C2AB)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds support for block based I/O to SSB.
This is needed in order to efficiently support PIO data
transfers to the card.
The block-I/O support is only compiled, if it's selected by the
weird driver that needs it. So there's no overhead for sane devices.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, please apply to 2.6.26


Index: wireless-testing/drivers/ssb/pci.c
===================================================================
--- wireless-testing.orig/drivers/ssb/pci.c	2008-03-30 18:39:07.000000000 +0200
+++ wireless-testing/drivers/ssb/pci.c	2008-04-02 18:21:12.000000000 +0200
@@ -610,12 +610,47 @@ static u32 ssb_pci_read32(struct ssb_dev
 		if (unlikely(ssb_pci_switch_core(bus, dev)))
 			return 0xFFFFFFFF;
 	}
 	return ioread32(bus->mmio + offset);
 }
 
+#ifdef CONFIG_SSB_BLOCKIO
+static void ssb_pci_block_read(struct ssb_device *dev, void *buffer,
+			       size_t count, u16 offset, u8 reg_width)
+{
+	struct ssb_bus *bus = dev->bus;
+	void __iomem *addr = bus->mmio + offset;
+
+	if (unlikely(ssb_pci_assert_buspower(bus)))
+		goto error;
+	if (unlikely(bus->mapped_device != dev)) {
+		if (unlikely(ssb_pci_switch_core(bus, dev)))
+			goto error;
+	}
+	switch (reg_width) {
+	case sizeof(u8):
+		ioread8_rep(addr, buffer, count);
+		break;
+	case sizeof(u16):
+		SSB_WARN_ON(count & 1);
+		ioread16_rep(addr, buffer, count >> 1);
+		break;
+	case sizeof(u32):
+		SSB_WARN_ON(count & 3);
+		ioread32_rep(addr, buffer, count >> 2);
+		break;
+	default:
+		SSB_WARN_ON(1);
+	}
+
+	return;
+error:
+	memset(buffer, 0xFF, count);
+}
+#endif /* CONFIG_SSB_BLOCKIO */
+
 static void ssb_pci_write8(struct ssb_device *dev, u16 offset, u8 value)
 {
 	struct ssb_bus *bus = dev->bus;
 
 	if (unlikely(ssb_pci_assert_buspower(bus)))
 		return;
@@ -649,20 +684,55 @@ static void ssb_pci_write32(struct ssb_d
 		if (unlikely(ssb_pci_switch_core(bus, dev)))
 			return;
 	}
 	iowrite32(value, bus->mmio + offset);
 }
 
+#ifdef CONFIG_SSB_BLOCKIO
+static void ssb_pci_block_write(struct ssb_device *dev, const void *buffer,
+				size_t count, u16 offset, u8 reg_width)
+{
+	struct ssb_bus *bus = dev->bus;
+	void __iomem *addr = bus->mmio + offset;
+
+	if (unlikely(ssb_pci_assert_buspower(bus)))
+		return;
+	if (unlikely(bus->mapped_device != dev)) {
+		if (unlikely(ssb_pci_switch_core(bus, dev)))
+			return;
+	}
+	switch (reg_width) {
+	case sizeof(u8):
+		iowrite8_rep(addr, buffer, count);
+		break;
+	case sizeof(u16):
+		SSB_WARN_ON(count & 1);
+		iowrite16_rep(addr, buffer, count >> 1);
+		break;
+	case sizeof(u32):
+		SSB_WARN_ON(count & 3);
+		iowrite32_rep(addr, buffer, count >> 2);
+		break;
+	default:
+		SSB_WARN_ON(1);
+	}
+}
+#endif /* CONFIG_SSB_BLOCKIO */
+
 /* Not "static", as it's used in main.c */
 const struct ssb_bus_ops ssb_pci_ops = {
 	.read8		= ssb_pci_read8,
 	.read16		= ssb_pci_read16,
 	.read32		= ssb_pci_read32,
 	.write8		= ssb_pci_write8,
 	.write16	= ssb_pci_write16,
 	.write32	= ssb_pci_write32,
+#ifdef CONFIG_SSB_BLOCKIO
+	.block_read	= ssb_pci_block_read,
+	.block_write	= ssb_pci_block_write,
+#endif
 };
 
 static ssize_t ssb_pci_attr_sprom_show(struct device *pcidev,
 				       struct device_attribute *attr,
 				       char *buf)
 {
Index: wireless-testing/include/linux/ssb/ssb.h
===================================================================
--- wireless-testing.orig/include/linux/ssb/ssb.h	2008-04-02 18:20:51.000000000 +0200
+++ wireless-testing/include/linux/ssb/ssb.h	2008-04-02 18:21:12.000000000 +0200
@@ -75,12 +75,18 @@ struct ssb_bus_ops {
 	u8 (*read8)(struct ssb_device *dev, u16 offset);
 	u16 (*read16)(struct ssb_device *dev, u16 offset);
 	u32 (*read32)(struct ssb_device *dev, u16 offset);
 	void (*write8)(struct ssb_device *dev, u16 offset, u8 value);
 	void (*write16)(struct ssb_device *dev, u16 offset, u16 value);
 	void (*write32)(struct ssb_device *dev, u16 offset, u32 value);
+#ifdef CONFIG_SSB_BLOCKIO
+	void (*block_read)(struct ssb_device *dev, void *buffer,
+			   size_t count, u16 offset, u8 reg_width);
+	void (*block_write)(struct ssb_device *dev, const void *buffer,
+			    size_t count, u16 offset, u8 reg_width);
+#endif
 };
 
 
 /* Core-ID values. */
 #define SSB_DEV_CHIPCOMMON	0x800
 #define SSB_DEV_ILINE20		0x801
@@ -371,12 +377,25 @@ static inline void ssb_write16(struct ss
 	dev->ops->write16(dev, offset, value);
 }
 static inline void ssb_write32(struct ssb_device *dev, u16 offset, u32 value)
 {
 	dev->ops->write32(dev, offset, value);
 }
+#ifdef CONFIG_SSB_BLOCKIO
+static inline void ssb_block_read(struct ssb_device *dev, void *buffer,
+				  size_t count, u16 offset, u8 reg_width)
+{
+	dev->ops->block_read(dev, buffer, count, offset, reg_width);
+}
+
+static inline void ssb_block_write(struct ssb_device *dev, const void *buffer,
+				   size_t count, u16 offset, u8 reg_width)
+{
+	dev->ops->block_write(dev, buffer, count, offset, reg_width);
+}
+#endif /* CONFIG_SSB_BLOCKIO */
 
 
 /* Translation (routing) bits that need to be ORed to DMA
  * addresses before they are given to a device. */
 extern u32 ssb_dma_translation(struct ssb_device *dev);
 #define SSB_DMA_TRANSLATION_MASK	0xC0000000
Index: wireless-testing/drivers/ssb/pcmcia.c
===================================================================
--- wireless-testing.orig/drivers/ssb/pcmcia.c	2008-04-02 18:20:51.000000000 +0200
+++ wireless-testing/drivers/ssb/pcmcia.c	2008-04-02 18:21:12.000000000 +0200
@@ -282,12 +282,70 @@ static u32 ssb_pcmcia_read32(struct ssb_
 	}
 	spin_unlock_irqrestore(&bus->bar_lock, flags);
 
 	return (lo | (hi << 16));
 }
 
+#ifdef CONFIG_SSB_BLOCKIO
+static void ssb_pcmcia_block_read(struct ssb_device *dev, void *buffer,
+				  size_t count, u16 offset, u8 reg_width)
+{
+	struct ssb_bus *bus = dev->bus;
+	unsigned long flags;
+	void __iomem *addr = bus->mmio + offset;
+	int err;
+
+	spin_lock_irqsave(&bus->bar_lock, flags);
+	err = select_core_and_segment(dev, &offset);
+	if (unlikely(err)) {
+		memset(buffer, 0xFF, count);
+		goto unlock;
+	}
+	switch (reg_width) {
+	case sizeof(u8): {
+		u8 *buf = buffer;
+
+		while (count) {
+			*buf = __raw_readb(addr);
+			buf++;
+			count--;
+		}
+		break;
+	}
+	case sizeof(u16): {
+		__le16 *buf = buffer;
+
+		SSB_WARN_ON(count & 1);
+		while (count) {
+			*buf = (__force __le16)__raw_readw(addr);
+			buf++;
+			count -= 2;
+		}
+		break;
+	}
+	case sizeof(u32): {
+		__le16 *buf = buffer;
+
+		SSB_WARN_ON(count & 3);
+		while (count) {
+			*buf = (__force __le16)__raw_readw(addr);
+			buf++;
+			*buf = (__force __le16)__raw_readw(addr + 2);
+			buf++;
+			count -= 4;
+		}
+		break;
+	}
+	default:
+		SSB_WARN_ON(1);
+	}
+unlock:
+	spin_unlock_irqrestore(&bus->bar_lock, flags);
+}
+#endif /* CONFIG_SSB_BLOCKIO */
+
 static void ssb_pcmcia_write8(struct ssb_device *dev, u16 offset, u8 value)
 {
 	struct ssb_bus *bus = dev->bus;
 	unsigned long flags;
 	int err;
 
@@ -326,20 +384,81 @@ static void ssb_pcmcia_write32(struct ss
 		writew(((value & 0xFFFF0000) >> 16), bus->mmio + offset + 2);
 	}
 	mmiowb();
 	spin_unlock_irqrestore(&bus->bar_lock, flags);
 }
 
+#ifdef CONFIG_SSB_BLOCKIO
+static void ssb_pcmcia_block_write(struct ssb_device *dev, const void *buffer,
+				   size_t count, u16 offset, u8 reg_width)
+{
+	struct ssb_bus *bus = dev->bus;
+	unsigned long flags;
+	void __iomem *addr = bus->mmio + offset;
+	int err;
+
+	spin_lock_irqsave(&bus->bar_lock, flags);
+	err = select_core_and_segment(dev, &offset);
+	if (unlikely(err))
+		goto unlock;
+	switch (reg_width) {
+	case sizeof(u8): {
+		const u8 *buf = buffer;
+
+		while (count) {
+			__raw_writeb(*buf, addr);
+			buf++;
+			count--;
+		}
+		break;
+	}
+	case sizeof(u16): {
+		const __le16 *buf = buffer;
+
+		SSB_WARN_ON(count & 1);
+		while (count) {
+			__raw_writew((__force u16)(*buf), addr);
+			buf++;
+			count -= 2;
+		}
+		break;
+	}
+	case sizeof(u32): {
+		const __le16 *buf = buffer;
+
+		SSB_WARN_ON(count & 3);
+		while (count) {
+			__raw_writew((__force u16)(*buf), addr);
+			buf++;
+			__raw_writew((__force u16)(*buf), addr + 2);
+			buf++;
+			count -= 4;
+		}
+		break;
+	}
+	default:
+		SSB_WARN_ON(1);
+	}
+unlock:
+	mmiowb();
+	spin_unlock_irqrestore(&bus->bar_lock, flags);
+}
+#endif /* CONFIG_SSB_BLOCKIO */
+
 /* Not "static", as it's used in main.c */
 const struct ssb_bus_ops ssb_pcmcia_ops = {
 	.read8		= ssb_pcmcia_read8,
 	.read16		= ssb_pcmcia_read16,
 	.read32		= ssb_pcmcia_read32,
 	.write8		= ssb_pcmcia_write8,
 	.write16	= ssb_pcmcia_write16,
 	.write32	= ssb_pcmcia_write32,
+#ifdef CONFIG_SSB_BLOCKIO
+	.block_read	= ssb_pcmcia_block_read,
+	.block_write	= ssb_pcmcia_block_write,
+#endif
 };
 
 static int ssb_pcmcia_sprom_command(struct ssb_bus *bus, u8 command)
 {
 	unsigned int i;
 	int err;
Index: wireless-testing/drivers/ssb/Kconfig
===================================================================
--- wireless-testing.orig/drivers/ssb/Kconfig	2008-03-30 18:39:07.000000000 +0200
+++ wireless-testing/drivers/ssb/Kconfig	2008-04-02 18:21:12.000000000 +0200
@@ -21,12 +21,17 @@ config SSB
 	  If unsure, say N.
 
 # Common SPROM support routines
 config SSB_SPROM
 	bool
 
+# Support for Block-I/O. SELECT this from the driver that needs it.
+config SSB_BLOCKIO
+	bool
+	depends on SSB
+
 config SSB_PCIHOST_POSSIBLE
 	bool
 	depends on SSB && (PCI = y || PCI = SSB)
 	default y
 
 config SSB_PCIHOST
Index: wireless-testing/drivers/ssb/main.c
===================================================================
--- wireless-testing.orig/drivers/ssb/main.c	2008-04-02 18:20:51.000000000 +0200
+++ wireless-testing/drivers/ssb/main.c	2008-04-02 18:21:12.000000000 +0200
@@ -552,12 +552,61 @@ static u32 ssb_ssb_read32(struct ssb_dev
 	struct ssb_bus *bus = dev->bus;
 
 	offset += dev->core_index * SSB_CORE_SIZE;
 	return readl(bus->mmio + offset);
 }
 
+#ifdef CONFIG_SSB_BLOCKIO
+static void ssb_ssb_block_read(struct ssb_device *dev, void *buffer,
+			       size_t count, u16 offset, u8 reg_width)
+{
+	struct ssb_bus *bus = dev->bus;
+	void __iomem *addr;
+
+	offset += dev->core_index * SSB_CORE_SIZE;
+	addr = bus->mmio + offset;
+
+	switch (reg_width) {
+	case sizeof(u8): {
+		u8 *buf = buffer;
+
+		while (count) {
+			*buf = __raw_readb(addr);
+			buf++;
+			count--;
+		}
+		break;
+	}
+	case sizeof(u16): {
+		__le16 *buf = buffer;
+
+		SSB_WARN_ON(count & 1);
+		while (count) {
+			*buf = (__force __le16)__raw_readw(addr);
+			buf++;
+			count -= 2;
+		}
+		break;
+	}
+	case sizeof(u32): {
+		__le32 *buf = buffer;
+
+		SSB_WARN_ON(count & 3);
+		while (count) {
+			*buf = (__force __le32)__raw_readl(addr);
+			buf++;
+			count -= 4;
+		}
+		break;
+	}
+	default:
+		SSB_WARN_ON(1);
+	}
+}
+#endif /* CONFIG_SSB_BLOCKIO */
+
 static void ssb_ssb_write8(struct ssb_device *dev, u16 offset, u8 value)
 {
 	struct ssb_bus *bus = dev->bus;
 
 	offset += dev->core_index * SSB_CORE_SIZE;
 	writeb(value, bus->mmio + offset);
@@ -576,20 +625,73 @@ static void ssb_ssb_write32(struct ssb_d
 	struct ssb_bus *bus = dev->bus;
 
 	offset += dev->core_index * SSB_CORE_SIZE;
 	writel(value, bus->mmio + offset);
 }
 
+#ifdef CONFIG_SSB_BLOCKIO
+static void ssb_ssb_block_write(struct ssb_device *dev, const void *buffer,
+				size_t count, u16 offset, u8 reg_width)
+{
+	struct ssb_bus *bus = dev->bus;
+	void __iomem *addr;
+
+	offset += dev->core_index * SSB_CORE_SIZE;
+	addr = bus->mmio + offset;
+
+	switch (reg_width) {
+	case sizeof(u8): {
+		const u8 *buf = buffer;
+
+		while (count) {
+			__raw_writeb(*buf, addr);
+			buf++;
+			count--;
+		}
+		break;
+	}
+	case sizeof(u16): {
+		const __le16 *buf = buffer;
+
+		SSB_WARN_ON(count & 1);
+		while (count) {
+			__raw_writew((__force u16)(*buf), addr);
+			buf++;
+			count -= 2;
+		}
+		break;
+	}
+	case sizeof(u32): {
+		const __le32 *buf = buffer;
+
+		SSB_WARN_ON(count & 3);
+		while (count) {
+			__raw_writel((__force u32)(*buf), addr);
+			buf++;
+			count -= 4;
+		}
+		break;
+	}
+	default:
+		SSB_WARN_ON(1);
+	}
+}
+#endif /* CONFIG_SSB_BLOCKIO */
+
 /* Ops for the plain SSB bus without a host-device (no PCI or PCMCIA). */
 static const struct ssb_bus_ops ssb_ssb_ops = {
 	.read8		= ssb_ssb_read8,
 	.read16		= ssb_ssb_read16,
 	.read32		= ssb_ssb_read32,
 	.write8		= ssb_ssb_write8,
 	.write16	= ssb_ssb_write16,
 	.write32	= ssb_ssb_write32,
+#ifdef CONFIG_SSB_BLOCKIO
+	.block_read	= ssb_ssb_block_read,
+	.block_write	= ssb_ssb_block_write,
+#endif
 };
 
 static int ssb_fetch_invariants(struct ssb_bus *bus,
 				ssb_invariants_func_t get_invariants)
 {
 	struct ssb_init_invariants iv;
