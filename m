Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:44510 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632AbYBSQuj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2008 11:50:39 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] ssb: Fix pcicore cardbus mode
Date: Tue, 19 Feb 2008 17:46:48 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200802191746.48870.mb@bu3sch.de> (sfid-20080219_165055_474342_39895DD3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes the pcicore driver to not die a horrible
crash death when inserting a cardbus card.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

For 2.6.25.


Index: wireless-testing/drivers/ssb/driver_pcicore.c
===================================================================
--- wireless-testing.orig/drivers/ssb/driver_pcicore.c	2008-02-16 19:08:13.000000000 +0100
+++ wireless-testing/drivers/ssb/driver_pcicore.c	2008-02-19 17:43:00.000000000 +0100
@@ -11,6 +11,7 @@
 #include <linux/ssb/ssb.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
+#include <linux/ssb/ssb_embedded.h>
 
 #include "ssb_private.h"
 
@@ -27,6 +28,18 @@ void pcicore_write32(struct ssb_pcicore 
 	ssb_write32(pc->dev, offset, value);
 }
 
+static inline
+u16 pcicore_read16(struct ssb_pcicore *pc, u16 offset)
+{
+	return ssb_read16(pc->dev, offset);
+}
+
+static inline
+void pcicore_write16(struct ssb_pcicore *pc, u16 offset, u16 value)
+{
+	ssb_write16(pc->dev, offset, value);
+}
+
 /**************************************************
  * Code for hostmode operation.
  **************************************************/
@@ -117,8 +130,10 @@ static u32 get_cfgspace_addr(struct ssb_
 	u32 addr = 0;
 	u32 tmp;
 
-	if (unlikely(pc->cardbusmode && dev > 1))
+	/* We do only have one cardbus device behind the bridge. */
+	if (pc->cardbusmode && (dev >= 1))
 		goto out;
+
 	if (bus == 0) {
 		/* Type 0 transaction */
 		if (unlikely(dev >= SSB_PCI_SLOT_MAX))
@@ -318,7 +333,16 @@ static void ssb_pcicore_init_hostmode(st
 	pcicore_write32(pc, SSB_PCICORE_ARBCTL, val);
 	udelay(1); /* Assertion time demanded by the PCI standard */
 
-	/*TODO cardbus mode */
+	if (pc->dev->bus->has_cardbus_slot) {
+		ssb_dprintk(KERN_INFO PFX "CardBus slot detected\n");
+		pc->cardbusmode = 1;
+		/* GPIO 1 resets the bridge */
+		ssb_gpio_out(pc->dev->bus, 1, 1);
+		ssb_gpio_outen(pc->dev->bus, 1, 1);
+		pcicore_write16(pc, SSB_PCICORE_SPROM(0),
+				pcicore_read16(pc, SSB_PCICORE_SPROM(0))
+				| 0x0400);
+	}
 
 	/* 64MB I/O window */
 	pcicore_write32(pc, SSB_PCICORE_SBTOPCI0,
Index: wireless-testing/drivers/ssb/main.c
===================================================================
--- wireless-testing.orig/drivers/ssb/main.c	2008-02-19 15:38:01.000000000 +0100
+++ wireless-testing/drivers/ssb/main.c	2008-02-19 17:43:00.000000000 +0100
@@ -557,6 +557,7 @@ static int ssb_fetch_invariants(struct s
 		goto out;
 	memcpy(&bus->boardinfo, &iv.boardinfo, sizeof(iv.boardinfo));
 	memcpy(&bus->sprom, &iv.sprom, sizeof(iv.sprom));
+	bus->has_cardbus_slot = iv.has_cardbus_slot;
 out:
 	return err;
 }
Index: wireless-testing/include/linux/ssb/ssb.h
===================================================================
--- wireless-testing.orig/include/linux/ssb/ssb.h	2008-02-19 15:01:00.000000000 +0100
+++ wireless-testing/include/linux/ssb/ssb.h	2008-02-19 17:43:00.000000000 +0100
@@ -282,6 +282,8 @@ struct ssb_bus {
 	struct ssb_boardinfo boardinfo;
 	/* Contents of the SPROM. */
 	struct ssb_sprom sprom;
+	/* If the board has a cardbus slot, this is set to true. */
+	bool has_cardbus_slot;
 
 #ifdef CONFIG_SSB_EMBEDDED
 	/* Lock for GPIO register access. */
@@ -299,8 +301,13 @@ struct ssb_bus {
 
 /* The initialization-invariants. */
 struct ssb_init_invariants {
+	/* Versioning information about the PCB. */
 	struct ssb_boardinfo boardinfo;
+	/* The SPROM information. That's either stored in an
+	 * EEPROM or NVRAM on the board. */
 	struct ssb_sprom sprom;
+	/* If the board has a cardbus slot, this is set to true. */
+	bool has_cardbus_slot;
 };
 /* Type of function to fetch the invariants. */
 typedef int (*ssb_invariants_func_t)(struct ssb_bus *bus,
Index: wireless-testing/include/linux/ssb/ssb_driver_pci.h
===================================================================
--- wireless-testing.orig/include/linux/ssb/ssb_driver_pci.h	2008-02-16 19:08:15.000000000 +0100
+++ wireless-testing/include/linux/ssb/ssb_driver_pci.h	2008-02-19 17:43:00.000000000 +0100
@@ -51,6 +51,11 @@
 #define  SSB_PCICORE_SBTOPCI1_MASK	0xFC000000
 #define SSB_PCICORE_SBTOPCI2		0x0108	/* Backplane to PCI translation 2 (sbtopci2) */
 #define  SSB_PCICORE_SBTOPCI2_MASK	0xC0000000
+#define SSB_PCICORE_PCICFG0		0x0400	/* PCI config space 0 (rev >= 8) */
+#define SSB_PCICORE_PCICFG1		0x0500	/* PCI config space 1 (rev >= 8) */
+#define SSB_PCICORE_PCICFG2		0x0600	/* PCI config space 2 (rev >= 8) */
+#define SSB_PCICORE_PCICFG3		0x0700	/* PCI config space 3 (rev >= 8) */
+#define SSB_PCICORE_SPROM(wordoffset)	(0x0800 + ((wordoffset) * 2)) /* SPROM shadow area (72 bytes) */
 
 /* SBtoPCIx */
 #define SSB_PCICORE_SBTOPCI_MEM		0x00000000


-- 
Greetings Michael.
