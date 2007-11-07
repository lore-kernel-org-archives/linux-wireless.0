Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:54392
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758011AbXKGSE5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2007 13:04:57 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] ssb: Fix PCMCIA-host lowlevel bus access
Date: Wed, 7 Nov 2007 19:03:35 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200711071903.35469.mb@bu3sch.de> (sfid-20071107_180525_099832_81133D2A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes the lowlevel bus access routines for
PCMCIA based devices.

There are still a few issues with register access sideeffects after
this patch. This will be addressed in a later patch.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-2.6/drivers/ssb/pcmcia.c
===================================================================
--- wireless-2.6.orig/drivers/ssb/pcmcia.c	2007-11-06 18:19:27.000000000 +0100
+++ wireless-2.6/drivers/ssb/pcmcia.c	2007-11-07 15:48:37.000000000 +0100
@@ -63,17 +63,17 @@ int ssb_pcmcia_switch_coreidx(struct ssb
 		err = pcmcia_access_configuration_register(pdev, &reg);
 		if (err != CS_SUCCESS)
 			goto error;
-		read_addr |= (reg.Value & 0xF) << 12;
+		read_addr |= ((u32)(reg.Value & 0x0F)) << 12;
 		reg.Offset = 0x30;
 		err = pcmcia_access_configuration_register(pdev, &reg);
 		if (err != CS_SUCCESS)
 			goto error;
-		read_addr |= reg.Value << 16;
+		read_addr |= ((u32)reg.Value) << 16;
 		reg.Offset = 0x32;
 		err = pcmcia_access_configuration_register(pdev, &reg);
 		if (err != CS_SUCCESS)
 			goto error;
-		read_addr |= reg.Value << 24;
+		read_addr |= ((u32)reg.Value) << 24;
 
 		cur_core = (read_addr - SSB_ENUM_BASE) / SSB_CORE_SIZE;
 		if (cur_core == coreidx)
@@ -152,28 +152,29 @@ error:
 	goto out_unlock;
 }
 
-/* These are the main device register access functions.
- * do_select_core is inline to have the likely hotpath inline.
- * All unlikely codepaths are out-of-line. */
-static inline int do_select_core(struct ssb_bus *bus,
-				 struct ssb_device *dev,
-				 u16 *offset)
+static int select_core_and_segment(struct ssb_device *dev,
+				   u16 *offset)
 {
+	struct ssb_bus *bus = dev->bus;
 	int err;
-	u8 need_seg = (*offset >= 0x800) ? 1 : 0;
+	u8 need_segment;
+
+	if (*offset >= 0x800) {
+		*offset -= 0x800;
+		need_segment = 1;
+	} else
+		need_segment = 0;
 
 	if (unlikely(dev != bus->mapped_device)) {
 		err = ssb_pcmcia_switch_core(bus, dev);
 		if (unlikely(err))
 			return err;
 	}
-	if (unlikely(need_seg != bus->mapped_pcmcia_seg)) {
-		err = ssb_pcmcia_switch_segment(bus, need_seg);
+	if (unlikely(need_segment != bus->mapped_pcmcia_seg)) {
+		err = ssb_pcmcia_switch_segment(bus, need_segment);
 		if (unlikely(err))
 			return err;
 	}
-	if (need_seg == 1)
-		*offset -= 0x800;
 
 	return 0;
 }
@@ -181,32 +182,31 @@ static inline int do_select_core(struct 
 static u16 ssb_pcmcia_read16(struct ssb_device *dev, u16 offset)
 {
 	struct ssb_bus *bus = dev->bus;
-	u16 x;
 
-	if (unlikely(do_select_core(bus, dev, &offset)))
+	if (unlikely(select_core_and_segment(dev, &offset)))
 		return 0xFFFF;
-	x = readw(bus->mmio + offset);
 
-	return x;
+	return readw(bus->mmio + offset);
 }
 
 static u32 ssb_pcmcia_read32(struct ssb_device *dev, u16 offset)
 {
 	struct ssb_bus *bus = dev->bus;
-	u32 x;
+	u32 lo, hi;
 
-	if (unlikely(do_select_core(bus, dev, &offset)))
+	if (unlikely(select_core_and_segment(dev, &offset)))
 		return 0xFFFFFFFF;
-	x = readl(bus->mmio + offset);
+	lo = readw(bus->mmio + offset);
+	hi = readw(bus->mmio + offset + 2);
 
-	return x;
+	return (lo | (hi << 16));
 }
 
 static void ssb_pcmcia_write16(struct ssb_device *dev, u16 offset, u16 value)
 {
 	struct ssb_bus *bus = dev->bus;
 
-	if (unlikely(do_select_core(bus, dev, &offset)))
+	if (unlikely(select_core_and_segment(dev, &offset)))
 		return;
 	writew(value, bus->mmio + offset);
 }
@@ -215,12 +215,12 @@ static void ssb_pcmcia_write32(struct ss
 {
 	struct ssb_bus *bus = dev->bus;
 
-	if (unlikely(do_select_core(bus, dev, &offset)))
+	if (unlikely(select_core_and_segment(dev, &offset)))
 		return;
-	readw(bus->mmio + offset);
-	writew(value >> 16, bus->mmio + offset + 2);
-	readw(bus->mmio + offset);
-	writew(value, bus->mmio + offset);
+	writeb((value & 0xFF000000) >> 24, bus->mmio + offset + 3);
+	writeb((value & 0x00FF0000) >> 16, bus->mmio + offset + 2);
+	writeb((value & 0x0000FF00) >> 8, bus->mmio + offset + 1);
+	writeb((value & 0x000000FF) >> 0, bus->mmio + offset + 0);
 }
 
 /* Not "static", as it's used in main.c */
Index: wireless-2.6/drivers/ssb/main.c
===================================================================
--- wireless-2.6.orig/drivers/ssb/main.c	2007-11-06 17:34:27.000000000 +0100
+++ wireless-2.6/drivers/ssb/main.c	2007-11-07 15:54:53.000000000 +0100
@@ -440,6 +440,7 @@ static int ssb_devices_register(struct s
 			break;
 		case SSB_BUSTYPE_PCMCIA:
 #ifdef CONFIG_SSB_PCMCIAHOST
+			sdev->irq = bus->host_pcmcia->irq.AssignedIRQ;
 			dev->parent = &bus->host_pcmcia->dev;
 #endif
 			break;
