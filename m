Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:57364 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759333AbYBTSIj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2008 13:08:39 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] ssb: Add support for 8bit register access
Date: Wed, 20 Feb 2008 19:08:10 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200802201908.10831.mb@bu3sch.de> (sfid-20080220_180907_636572_CE869A95)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds support for 8bit wide register reads/writes.
This is needed in order to support the gigabit ethernet core.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

For 2.6.26

Index: wireless-testing/drivers/ssb/main.c
===================================================================
--- wireless-testing.orig/drivers/ssb/main.c	2008-02-19 17:43:00.000000000 +0100
+++ wireless-testing/drivers/ssb/main.c	2008-02-20 19:01:19.000000000 +0100
@@ -505,6 +505,14 @@ error:
 	return err;
 }
 
+static u8 ssb_ssb_read8(struct ssb_device *dev, u16 offset)
+{
+	struct ssb_bus *bus = dev->bus;
+
+	offset += dev->core_index * SSB_CORE_SIZE;
+	return readb(bus->mmio + offset);
+}
+
 static u16 ssb_ssb_read16(struct ssb_device *dev, u16 offset)
 {
 	struct ssb_bus *bus = dev->bus;
@@ -521,6 +529,14 @@ static u32 ssb_ssb_read32(struct ssb_dev
 	return readl(bus->mmio + offset);
 }
 
+static void ssb_ssb_write8(struct ssb_device *dev, u16 offset, u8 value)
+{
+	struct ssb_bus *bus = dev->bus;
+
+	offset += dev->core_index * SSB_CORE_SIZE;
+	writeb(value, bus->mmio + offset);
+}
+
 static void ssb_ssb_write16(struct ssb_device *dev, u16 offset, u16 value)
 {
 	struct ssb_bus *bus = dev->bus;
@@ -539,8 +555,10 @@ static void ssb_ssb_write32(struct ssb_d
 
 /* Ops for the plain SSB bus without a host-device (no PCI or PCMCIA). */
 static const struct ssb_bus_ops ssb_ssb_ops = {
+	.read8		= ssb_ssb_read8,
 	.read16		= ssb_ssb_read16,
 	.read32		= ssb_ssb_read32,
+	.write8		= ssb_ssb_write8,
 	.write16	= ssb_ssb_write16,
 	.write32	= ssb_ssb_write32,
 };
Index: wireless-testing/drivers/ssb/pci.c
===================================================================
--- wireless-testing.orig/drivers/ssb/pci.c	2008-02-16 19:08:13.000000000 +0100
+++ wireless-testing/drivers/ssb/pci.c	2008-02-20 19:01:19.000000000 +0100
@@ -572,6 +572,19 @@ static inline int ssb_pci_assert_buspowe
 }
 #endif /* DEBUG */
 
+static u8 ssb_pci_read8(struct ssb_device *dev, u16 offset)
+{
+	struct ssb_bus *bus = dev->bus;
+
+	if (unlikely(ssb_pci_assert_buspower(bus)))
+		return 0xFF;
+	if (unlikely(bus->mapped_device != dev)) {
+		if (unlikely(ssb_pci_switch_core(bus, dev)))
+			return 0xFF;
+	}
+	return ioread8(bus->mmio + offset);
+}
+
 static u16 ssb_pci_read16(struct ssb_device *dev, u16 offset)
 {
 	struct ssb_bus *bus = dev->bus;
@@ -598,6 +611,19 @@ static u32 ssb_pci_read32(struct ssb_dev
 	return ioread32(bus->mmio + offset);
 }
 
+static void ssb_pci_write8(struct ssb_device *dev, u16 offset, u8 value)
+{
+	struct ssb_bus *bus = dev->bus;
+
+	if (unlikely(ssb_pci_assert_buspower(bus)))
+		return;
+	if (unlikely(bus->mapped_device != dev)) {
+		if (unlikely(ssb_pci_switch_core(bus, dev)))
+			return;
+	}
+	iowrite8(value, bus->mmio + offset);
+}
+
 static void ssb_pci_write16(struct ssb_device *dev, u16 offset, u16 value)
 {
 	struct ssb_bus *bus = dev->bus;
@@ -626,8 +652,10 @@ static void ssb_pci_write32(struct ssb_d
 
 /* Not "static", as it's used in main.c */
 const struct ssb_bus_ops ssb_pci_ops = {
+	.read8		= ssb_pci_read8,
 	.read16		= ssb_pci_read16,
 	.read32		= ssb_pci_read32,
+	.write8		= ssb_pci_write8,
 	.write16	= ssb_pci_write16,
 	.write32	= ssb_pci_write32,
 };
Index: wireless-testing/drivers/ssb/pcmcia.c
===================================================================
--- wireless-testing.orig/drivers/ssb/pcmcia.c	2008-02-16 19:08:13.000000000 +0100
+++ wireless-testing/drivers/ssb/pcmcia.c	2008-02-20 19:01:19.000000000 +0100
@@ -172,6 +172,22 @@ static int select_core_and_segment(struc
 	return 0;
 }
 
+static u8 ssb_pcmcia_read8(struct ssb_device *dev, u16 offset)
+{
+	struct ssb_bus *bus = dev->bus;
+	unsigned long flags;
+	int err;
+	u8 value = 0xFF;
+
+	spin_lock_irqsave(&bus->bar_lock, flags);
+	err = select_core_and_segment(dev, &offset);
+	if (likely(!err))
+		value = readb(bus->mmio + offset);
+	spin_unlock_irqrestore(&bus->bar_lock, flags);
+
+	return value;
+}
+
 static u16 ssb_pcmcia_read16(struct ssb_device *dev, u16 offset)
 {
 	struct ssb_bus *bus = dev->bus;
@@ -206,6 +222,20 @@ static u32 ssb_pcmcia_read32(struct ssb_
 	return (lo | (hi << 16));
 }
 
+static void ssb_pcmcia_write8(struct ssb_device *dev, u16 offset, u8 value)
+{
+	struct ssb_bus *bus = dev->bus;
+	unsigned long flags;
+	int err;
+
+	spin_lock_irqsave(&bus->bar_lock, flags);
+	err = select_core_and_segment(dev, &offset);
+	if (likely(!err))
+		writeb(value, bus->mmio + offset);
+	mmiowb();
+	spin_unlock_irqrestore(&bus->bar_lock, flags);
+}
+
 static void ssb_pcmcia_write16(struct ssb_device *dev, u16 offset, u16 value)
 {
 	struct ssb_bus *bus = dev->bus;
@@ -238,8 +268,10 @@ static void ssb_pcmcia_write32(struct ss
 
 /* Not "static", as it's used in main.c */
 const struct ssb_bus_ops ssb_pcmcia_ops = {
+	.read8		= ssb_pcmcia_read8,
 	.read16		= ssb_pcmcia_read16,
 	.read32		= ssb_pcmcia_read32,
+	.write8		= ssb_pcmcia_write8,
 	.write16	= ssb_pcmcia_write16,
 	.write32	= ssb_pcmcia_write32,
 };
Index: wireless-testing/include/linux/ssb/ssb.h
===================================================================
--- wireless-testing.orig/include/linux/ssb/ssb.h	2008-02-19 17:43:00.000000000 +0100
+++ wireless-testing/include/linux/ssb/ssb.h	2008-02-20 19:01:19.000000000 +0100
@@ -72,8 +72,10 @@ struct ssb_device;
 /* Lowlevel read/write operations on the device MMIO.
  * Internal, don't use that outside of ssb. */
 struct ssb_bus_ops {
+	u8 (*read8)(struct ssb_device *dev, u16 offset);
 	u16 (*read16)(struct ssb_device *dev, u16 offset);
 	u32 (*read32)(struct ssb_device *dev, u16 offset);
+	void (*write8)(struct ssb_device *dev, u16 offset, u8 value);
 	void (*write16)(struct ssb_device *dev, u16 offset, u16 value);
 	void (*write32)(struct ssb_device *dev, u16 offset, u32 value);
 };
@@ -344,6 +346,10 @@ void ssb_device_disable(struct ssb_devic
 
 
 /* Device MMIO register read/write functions. */
+static inline u8 ssb_read8(struct ssb_device *dev, u16 offset)
+{
+	return dev->ops->read8(dev, offset);
+}
 static inline u16 ssb_read16(struct ssb_device *dev, u16 offset)
 {
 	return dev->ops->read16(dev, offset);
@@ -352,6 +358,10 @@ static inline u32 ssb_read32(struct ssb_
 {
 	return dev->ops->read32(dev, offset);
 }
+static inline void ssb_write8(struct ssb_device *dev, u16 offset, u8 value)
+{
+	dev->ops->write8(dev, offset, value);
+}
 static inline void ssb_write16(struct ssb_device *dev, u16 offset, u16 value)
 {
 	dev->ops->write16(dev, offset, value);

-- 
Greetings Michael.
