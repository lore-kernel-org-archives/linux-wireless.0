Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:33422 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbXLVVCF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2007 16:02:05 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] ssb: Fix PCMCIA lowlevel register access
Date: Sat, 22 Dec 2007 22:01:36 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200712222201.36705.mb@bu3sch.de> (sfid-20071222_210211_573822_58F0B335)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes lowlevel register access for PCMCIA based devices.

The patch also adds a temporary workaround for the device mac address.
It simply adds generation of a random address. The real SPROM extraction
will follow in another patch.
The temporary workaround will be removed then, but for now it's OK.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-2.6/drivers/ssb/pcmcia.c
===================================================================
--- wireless-2.6.orig/drivers/ssb/pcmcia.c	2007-12-09 21:33:20.000000000 +0100
+++ wireless-2.6/drivers/ssb/pcmcia.c	2007-12-09 22:16:59.000000000 +0100
@@ -94,7 +94,6 @@ int ssb_pcmcia_switch_core(struct ssb_bu
 			   struct ssb_device *dev)
 {
 	int err;
-	unsigned long flags;
 
 #if SSB_VERBOSE_PCMCIACORESWITCH_DEBUG
 	ssb_printk(KERN_INFO PFX
@@ -103,11 +102,9 @@ int ssb_pcmcia_switch_core(struct ssb_bu
 		   dev->core_index);
 #endif
 
-	spin_lock_irqsave(&bus->bar_lock, flags);
 	err = ssb_pcmcia_switch_coreidx(bus, dev->core_index);
 	if (!err)
 		bus->mapped_device = dev;
-	spin_unlock_irqrestore(&bus->bar_lock, flags);
 
 	return err;
 }
@@ -115,14 +112,12 @@ int ssb_pcmcia_switch_core(struct ssb_bu
 int ssb_pcmcia_switch_segment(struct ssb_bus *bus, u8 seg)
 {
 	int attempts = 0;
-	unsigned long flags;
 	conf_reg_t reg;
-	int res, err = 0;
+	int res;
 
 	SSB_WARN_ON((seg != 0) && (seg != 1));
 	reg.Offset = 0x34;
 	reg.Function = 0;
-	spin_lock_irqsave(&bus->bar_lock, flags);
 	while (1) {
 		reg.Action = CS_WRITE;
 		reg.Value = seg;
@@ -143,13 +138,11 @@ int ssb_pcmcia_switch_segment(struct ssb
 		udelay(10);
 	}
 	bus->mapped_pcmcia_seg = seg;
-out_unlock:
-	spin_unlock_irqrestore(&bus->bar_lock, flags);
-	return err;
+
+	return 0;
 error:
 	ssb_printk(KERN_ERR PFX "Failed to switch pcmcia segment\n");
-	err = -ENODEV;
-	goto out_unlock;
+	return -ENODEV;
 }
 
 static int select_core_and_segment(struct ssb_device *dev,
@@ -182,22 +175,33 @@ static int select_core_and_segment(struc
 static u16 ssb_pcmcia_read16(struct ssb_device *dev, u16 offset)
 {
 	struct ssb_bus *bus = dev->bus;
+	unsigned long flags;
+	int err;
+	u16 value = 0xFFFF;
 
-	if (unlikely(select_core_and_segment(dev, &offset)))
-		return 0xFFFF;
+	spin_lock_irqsave(&bus->bar_lock, flags);
+	err = select_core_and_segment(dev, &offset);
+	if (likely(!err))
+		value = readw(bus->mmio + offset);
+	spin_unlock_irqrestore(&bus->bar_lock, flags);
 
-	return readw(bus->mmio + offset);
+	return value;
 }
 
 static u32 ssb_pcmcia_read32(struct ssb_device *dev, u16 offset)
 {
 	struct ssb_bus *bus = dev->bus;
-	u32 lo, hi;
+	unsigned long flags;
+	int err;
+	u32 lo = 0xFFFFFFFF, hi = 0xFFFFFFFF;
 
-	if (unlikely(select_core_and_segment(dev, &offset)))
-		return 0xFFFFFFFF;
-	lo = readw(bus->mmio + offset);
-	hi = readw(bus->mmio + offset + 2);
+	spin_lock_irqsave(&bus->bar_lock, flags);
+	err = select_core_and_segment(dev, &offset);
+	if (likely(!err)) {
+		lo = readw(bus->mmio + offset);
+		hi = readw(bus->mmio + offset + 2);
+	}
+	spin_unlock_irqrestore(&bus->bar_lock, flags);
 
 	return (lo | (hi << 16));
 }
@@ -205,22 +209,31 @@ static u32 ssb_pcmcia_read32(struct ssb_
 static void ssb_pcmcia_write16(struct ssb_device *dev, u16 offset, u16 value)
 {
 	struct ssb_bus *bus = dev->bus;
+	unsigned long flags;
+	int err;
 
-	if (unlikely(select_core_and_segment(dev, &offset)))
-		return;
-	writew(value, bus->mmio + offset);
+	spin_lock_irqsave(&bus->bar_lock, flags);
+	err = select_core_and_segment(dev, &offset);
+	if (likely(!err))
+		writew(value, bus->mmio + offset);
+	mmiowb();
+	spin_unlock_irqrestore(&bus->bar_lock, flags);
 }
 
 static void ssb_pcmcia_write32(struct ssb_device *dev, u16 offset, u32 value)
 {
 	struct ssb_bus *bus = dev->bus;
+	unsigned long flags;
+	int err;
 
-	if (unlikely(select_core_and_segment(dev, &offset)))
-		return;
-	writeb((value & 0xFF000000) >> 24, bus->mmio + offset + 3);
-	writeb((value & 0x00FF0000) >> 16, bus->mmio + offset + 2);
-	writeb((value & 0x0000FF00) >> 8, bus->mmio + offset + 1);
-	writeb((value & 0x000000FF) >> 0, bus->mmio + offset + 0);
+	spin_lock_irqsave(&bus->bar_lock, flags);
+	err = select_core_and_segment(dev, &offset);
+	if (likely(!err)) {
+		writew((value & 0x0000FFFF), bus->mmio + offset);
+		writew(((value & 0xFFFF0000) >> 16), bus->mmio + offset + 2);
+	}
+	mmiowb();
+	spin_unlock_irqrestore(&bus->bar_lock, flags);
 }
 
 /* Not "static", as it's used in main.c */
@@ -231,10 +244,12 @@ const struct ssb_bus_ops ssb_pcmcia_ops 
 	.write32	= ssb_pcmcia_write32,
 };
 
+#include <linux/etherdevice.h>
 int ssb_pcmcia_get_invariants(struct ssb_bus *bus,
 			      struct ssb_init_invariants *iv)
 {
 	//TODO
+	random_ether_addr(iv->sprom.il0mac);
 	return 0;
 }
 
Index: wireless-2.6/include/linux/ssb/ssb.h
===================================================================
--- wireless-2.6.orig/include/linux/ssb/ssb.h	2007-12-09 22:16:39.000000000 +0100
+++ wireless-2.6/include/linux/ssb/ssb.h	2007-12-09 22:16:59.000000000 +0100
@@ -231,7 +231,8 @@ struct ssb_bus {
 	struct ssb_device *mapped_device;
 	/* Currently mapped PCMCIA segment. (bustype == SSB_BUSTYPE_PCMCIA only) */
 	u8 mapped_pcmcia_seg;
-	/* Lock for core and segment switching. */
+	/* Lock for core and segment switching.
+	 * On PCMCIA-host busses this is used to protect the whole MMIO access. */
 	spinlock_t bar_lock;
 
 	/* The bus this backplane is running on. */
