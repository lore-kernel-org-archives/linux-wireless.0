Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:26980 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab1BQWf7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Feb 2011 17:35:59 -0500
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000022264.msg
	for <linux-wireless@vger.kernel.org>; Fri, 18 Feb 2011 00:35:21 +0200
Subject: Re: [RFC] AI support (11/14 ssb separate SB-specific code)
From: George Kashperko <george@znau.edu.ua>
To: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1297980093.13554.5.camel@maggie>
References: <1297958316.5623.27.camel@dev.znau.edu.ua>
	 (sfid-20110217_170718_357395_57E8418D)  <1297980093.13554.5.camel@maggie>
Content-Type: text/plain
Date: Fri, 18 Feb 2011 00:27:31 +0200
Message-Id: <1297981651.23381.32.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: George Kashperko <george@znau.edu.ua>

Move SB-specific code to separate file.
Signed-off-by: George Kashperko <george@znau.edu.ua>
---
 drivers/ssb/Kconfig           |   11 +
 drivers/ssb/Makefile          |    1 
 drivers/ssb/driver_mipscore.c |   11 -
 drivers/ssb/main.c            |  188 --------------------
 drivers/ssb/scan.c            |   74 --------
 drivers/ssb/ssb_private.h     |   32 ---
 drivers/ssb/ssb_sb.c          |  289 ++++++++++++++++++++++++++++++++
 drivers/ssb/ssb_sb.h          |   52 +++++
 8 files changed, 361 insertions(+), 297 deletions(-)
--- linux-wireless-testing.orig/drivers/ssb/driver_mipscore.c	2011-02-17 16:00:21.000000000 +0200
+++ linux-wireless-testing/drivers/ssb/driver_mipscore.c	2011-02-17 15:55:25.000000000 +0200
@@ -52,16 +52,6 @@ static inline u32 ssb_irqflag(struct ssb
 	return dev->bus->mipscore.irqflag(dev);
 }
 
-static u32 ssb_irqflag_sb(struct ssb_device *dev)
-{
-	u32 tpsflag = ssb_read32(dev, SSB_TPSFLAG) & SSB_TPSFLAG_BPFLAG;
-	if (tpsflag && tpsflag != SSB_TPSFLAG_BPFLAG)
-		return tpsflag;
-	else
-		/* not irq supported */
-		return -1;
-}
-
 static struct ssb_device *find_device(struct ssb_device *rdev, int irqflag)
 {
 	struct ssb_bus *bus = rdev->bus;
@@ -246,7 +236,6 @@ void ssb_mipscore_init(struct ssb_mipsco
 	ssb_dprintk(KERN_INFO PFX "Initializing MIPS core...\n");
 
 	bus = mcore->dev->bus;
-	bus->mipscore.irqflag = ssb_irqflag_sb;
 	hz = ssb_clockspeed(bus);
 	if (!hz)
 		hz = 100000000;
--- linux-wireless-testing.orig/drivers/ssb/Kconfig	2011-02-17 16:00:21.000000000 +0200
+++ linux-wireless-testing/drivers/ssb/Kconfig	2011-02-17 16:00:43.000000000 +0200
@@ -9,6 +9,7 @@ menu "Sonics Silicon Backplane"
 config SSB
 	tristate "Sonics Silicon Backplane support"
 	depends on SSB_POSSIBLE
+	select SSB_BUS_SB
 	help
 	  Support for the Sonics Silicon Backplane bus.
 	  You only need to enable this option, if you are
@@ -21,6 +22,16 @@ config SSB
 
 	  If unsure, say N.
 
+config SSB_BUS_SB_POSSIBLE
+	bool
+	default y if SSB
+
+config SSB_BUS_SB
+	bool "SB style bus"
+	depends on SSB_BUS_SB_POSSIBLE
+	help
+	  Sonics Silicon Backplane SB-style bus
+
 # Common SPROM support routines
 config SSB_SPROM
 	bool
--- linux-wireless-testing.orig/drivers/ssb/main.c	2011-02-17 16:00:21.000000000 +0200
+++ linux-wireless-testing/drivers/ssb/main.c	2011-02-17 16:00:43.000000000 +0200
@@ -1129,88 +1129,10 @@ u32 ssb_clockspeed(struct ssb_bus *bus)
 }
 EXPORT_SYMBOL(ssb_clockspeed);
 
-static u32 ssb_tmslow_reject_bitmask(struct ssb_device *dev)
-{
-	u32 rev = ssb_read32(dev, SSB_IDLOW) & SSB_IDLOW_SSBREV;
-
-	/* The REJECT bit changed position in TMSLOW between
-	 * Backplane revisions. */
-	switch (rev) {
-	case SSB_IDLOW_SSBREV_22:
-		return SSB_TMSLOW_REJECT_22;
-	case SSB_IDLOW_SSBREV_23:
-		return SSB_TMSLOW_REJECT_23;
-	case SSB_IDLOW_SSBREV_24:     /* TODO - find the proper REJECT bits */
-	case SSB_IDLOW_SSBREV_25:     /* same here */
-	case SSB_IDLOW_SSBREV_26:     /* same here */
-	case SSB_IDLOW_SSBREV_27:     /* same here */
-		return SSB_TMSLOW_REJECT_23;	/* this is a guess */
-	default:
-		printk(KERN_INFO "ssb: Backplane Revision 0x%.8X\n", rev);
-		WARN_ON(1);
-	}
-	return (SSB_TMSLOW_REJECT_22 | SSB_TMSLOW_REJECT_23);
-}
-
-static int ssb_device_is_enabled_sb(struct ssb_device *dev)
-{
-	u32 val;
-	u32 reject;
-
-	reject = ssb_tmslow_reject_bitmask(dev);
-	val = ssb_read32(dev, SSB_TMSLOW);
-	val &= SSB_TMSLOW_CLOCK | SSB_TMSLOW_RESET | reject;
-
-	return (val == SSB_TMSLOW_CLOCK);
-}
-
-static void ssb_flush_tmslow(struct ssb_device *dev)
-{
-	/* Make _really_ sure the device has finished the TMSLOW
-	 * register write transaction, as we risk running into
-	 * a machine check exception otherwise.
-	 * Do this by reading the register back to commit the
-	 * PCI write and delay an additional usec for the device
-	 * to react to the change. */
-	ssb_read32(dev, SSB_TMSLOW);
-	udelay(1);
-}
-
-static void ssb_device_enable_sb(struct ssb_device *dev, u32 core_specific_flags)
-{
-	u32 val;
-
-	ssb_device_disable(dev, core_specific_flags);
-	core_specific_flags <<= SSB_TMSLOW_FLAGS_SHIFT;
-	ssb_write32(dev, SSB_TMSLOW,
-		    SSB_TMSLOW_RESET | SSB_TMSLOW_CLOCK |
-		    SSB_TMSLOW_FGC | core_specific_flags);
-	ssb_flush_tmslow(dev);
-
-	/* Clear SERR if set. This is a hw bug workaround. */
-	if (ssb_read32(dev, SSB_TMSHIGH) & SSB_TMSHIGH_SERR)
-		ssb_write32(dev, SSB_TMSHIGH, 0);
-
-	val = ssb_read32(dev, SSB_IMSTATE);
-	if (val & (SSB_IMSTATE_IBE | SSB_IMSTATE_TO)) {
-		val &= ~(SSB_IMSTATE_IBE | SSB_IMSTATE_TO);
-		ssb_write32(dev, SSB_IMSTATE, val);
-	}
-
-	ssb_write32(dev, SSB_TMSLOW,
-		    SSB_TMSLOW_CLOCK | SSB_TMSLOW_FGC |
-		    core_specific_flags);
-	ssb_flush_tmslow(dev);
-
-	ssb_write32(dev, SSB_TMSLOW, SSB_TMSLOW_CLOCK |
-		    core_specific_flags);
-	ssb_flush_tmslow(dev);
-}
-
 /* Wait for a bit in a register to get set or unset.
  * timeout is in units of ten-microseconds */
-static int ssb_wait_bit(struct ssb_device *dev, u16 reg, u32 bitmask,
-			int timeout, int set)
+int ssb_wait_bit(struct ssb_device *dev, u16 reg, u32 bitmask,
+		 int timeout, int set)
 {
 	int i;
 	u32 val;
@@ -1233,32 +1155,6 @@ static int ssb_wait_bit(struct ssb_devic
 	return -ETIMEDOUT;
 }
 
-static void ssb_device_disable_sb(struct ssb_device *dev, u32 core_specific_flags)
-{
-	u32 reject;
-
-	if (ssb_read32(dev, SSB_TMSLOW) & SSB_TMSLOW_RESET)
-		return;
-
-	SSB_WARN_ON(core_specific_flags & 0xFFFF0000);
-
-	core_specific_flags <<= SSB_TMSLOW_FLAGS_SHIFT;
-	reject = ssb_tmslow_reject_bitmask(dev);
-	ssb_write32(dev, SSB_TMSLOW, reject | SSB_TMSLOW_CLOCK);
-	ssb_wait_bit(dev, SSB_TMSLOW, reject, 1000, 1);
-	ssb_wait_bit(dev, SSB_TMSHIGH, SSB_TMSHIGH_BUSY, 1000, 0);
-	ssb_write32(dev, SSB_TMSLOW,
-		    SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK |
-		    reject | SSB_TMSLOW_RESET |
-		    core_specific_flags);
-	ssb_flush_tmslow(dev);
-
-	ssb_write32(dev, SSB_TMSLOW,
-		    reject | SSB_TMSLOW_RESET |
-		    core_specific_flags);
-	ssb_flush_tmslow(dev);
-}
-
 u32 ssb_dma_translation(struct ssb_device *dev)
 {
 	switch (dev->bus->bustype) {
@@ -1329,86 +1225,6 @@ error:
 }
 EXPORT_SYMBOL(ssb_bus_powerup);
 
-static u32 ssb_admatch_base_sb(struct ssb_device *dev, u32 adm)
-{
-	u32 base = 0;
-
-	adm = ssb_read32(dev, adm);
-
-	switch (adm & SSB_ADM_TYPE) {
-	case SSB_ADM_TYPE0:
-		base = (adm & SSB_ADM_BASE0);
-		break;
-	case SSB_ADM_TYPE1:
-		SSB_WARN_ON(adm & SSB_ADM_NEG); /* unsupported */
-		base = (adm & SSB_ADM_BASE1);
-		break;
-	case SSB_ADM_TYPE2:
-		SSB_WARN_ON(adm & SSB_ADM_NEG); /* unsupported */
-		base = (adm & SSB_ADM_BASE2);
-		break;
-	default:
-		SSB_WARN_ON(1);
-	}
-
-	return base;
-}
-
-static u32 ssb_admatch_size_sb(struct ssb_device *dev, u32 adm)
-{
-	u32 size = 0;
-
-	adm = ssb_read32(dev, adm);
-
-	switch (adm & SSB_ADM_TYPE) {
-	case SSB_ADM_TYPE0:
-		size = ((adm & SSB_ADM_SZ0) >> SSB_ADM_SZ0_SHIFT);
-		break;
-	case SSB_ADM_TYPE1:
-		SSB_WARN_ON(adm & SSB_ADM_NEG); /* unsupported */
-		size = ((adm & SSB_ADM_SZ1) >> SSB_ADM_SZ1_SHIFT);
-		break;
-	case SSB_ADM_TYPE2:
-		SSB_WARN_ON(adm & SSB_ADM_NEG); /* unsupported */
-		size = ((adm & SSB_ADM_SZ2) >> SSB_ADM_SZ2_SHIFT);
-		break;
-	default:
-		SSB_WARN_ON(1);
-	}
-	size = (1 << (size + 1));
-
-	return size;
-}
-
-static u32 ssb_core_ctl_flags_sb(struct ssb_device *dev, u32 mask, u32 val)
-{
-	mask = ~mask;
-	SSB_WARN_ON((mask | val) & 0xFFFF0000);
-	if (mask || val) {
-		u32 tmp = (ssb_read32(dev, SSB_TMSLOW) &
-			   ~(mask << SSB_TMSLOW_FLAGS_SHIFT)) |
-			   (val << SSB_TMSLOW_FLAGS_SHIFT);
-		ssb_write32(dev, SSB_TMSLOW, tmp);
-	}
-
-	return ssb_read32(dev, SSB_TMSLOW) >> SSB_TMSLOW_FLAGS_SHIFT;
-}
-
-static u32 ssb_core_state_flags_sb(struct ssb_device *dev)
-{
-	return ssb_read32(dev, SSB_TMSHIGH) >> SSB_TMSHIGH_FLAGS_SHIFT;
-}
-
-const struct ssb_bus_helpers ssb_helpers_sb = {
-	.device_is_enabled	= ssb_device_is_enabled_sb,
-	.device_enable		= ssb_device_enable_sb,
-	.device_disable		= ssb_device_disable_sb,
-	.admatch_base		= ssb_admatch_base_sb,
-	.admatch_size		= ssb_admatch_size_sb,
-	.core_ctl_flags		= ssb_core_ctl_flags_sb,
-	.core_state_flags	= ssb_core_state_flags_sb,
-};
-
 static int __init ssb_modinit(void)
 {
 	int err;
--- linux-wireless-testing.orig/drivers/ssb/Makefile	2011-02-17 16:00:21.000000000 +0200
+++ linux-wireless-testing/drivers/ssb/Makefile	2011-02-17 16:00:43.000000000 +0200
@@ -1,5 +1,6 @@
 # core
 ssb-y					+= main.o scan.o
+ssb-$(CONFIG_SSB_BUS_SB)		+= ssb_sb.o
 ssb-$(CONFIG_SSB_EMBEDDED)		+= embedded.o
 ssb-$(CONFIG_SSB_SPROM)			+= sprom.o
 
--- linux-wireless-testing.orig/drivers/ssb/scan.c	2011-02-17 16:00:21.000000000 +0200
+++ linux-wireless-testing/drivers/ssb/scan.c	2011-02-17 16:00:47.000000000 +0200
@@ -157,8 +157,7 @@ static u8 chipid_to_nrcores(u16 chipid)
 	return 1;
 }
 
-static u32 scan_read32(struct ssb_bus *bus, u8 current_coreidx,
-		       u16 offset)
+u32 scan_read32(struct ssb_bus *bus, u8 current_coreidx, u16 offset)
 {
 	u32 lo, hi;
 
@@ -184,42 +183,6 @@ static u32 scan_read32(struct ssb_bus *b
 	return readl(bus->mmio + offset);
 }
 
-static int scan_switchcore(struct ssb_bus *bus, u8 coreidx)
-{
-	switch (bus->bustype) {
-	case SSB_BUSTYPE_SSB:
-		break;
-	case SSB_BUSTYPE_PCI:
-		return ssb_pci_switch_coreidx(bus, coreidx);
-	case SSB_BUSTYPE_PCMCIA:
-		return ssb_pcmcia_switch_coreidx(bus, coreidx);
-	case SSB_BUSTYPE_SDIO:
-		return ssb_sdio_scan_switch_coreidx(bus, coreidx);
-	}
-	return 0;
-}
-
-void ssb_iounmap_sb(struct ssb_bus *bus)
-{
-	switch (bus->bustype) {
-	case SSB_BUSTYPE_SSB:
-	case SSB_BUSTYPE_PCMCIA:
-		iounmap(bus->mmio);
-		break;
-	case SSB_BUSTYPE_PCI:
-#ifdef CONFIG_SSB_PCIHOST
-		pci_iounmap(bus->host_pci, bus->mmio);
-#else
-		SSB_BUG_ON(1); /* Can't reach this code. */
-#endif
-		break;
-	case SSB_BUSTYPE_SDIO:
-		break;
-	}
-	bus->mmio = NULL;
-	bus->mapped_device = NULL;
-}
-
 static void __iomem *ssb_ioremap(struct ssb_bus *bus,
 				 unsigned long baseaddr)
 {
@@ -407,41 +370,6 @@ static int ssb_bus_detect(struct ssb_bus
 	return chiptype == SSB_CHIPCO_SB ? 0 : -ENODEV;
 }
 
-static int ssb_bus_scan_sb(struct ssb_bus *bus, unsigned long baseaddr)
-{
-	u32 idhi;
-	int dev_i, i;
-	struct ssb_device *dev;
-	int nr_80211_cores = 0;
-	int err;
-
-	/* Fetch basic information about each core/device */
-	for (i = 0, dev_i = 0; i < bus->nr_devices; i++) {
-		err = scan_switchcore(bus, i);
-		if (err)
-			return err;
-		dev = &(bus->devices[dev_i]);
-
-		idhi = scan_read32(bus, i, SSB_IDHIGH);
-		dev->id.coreid = (idhi & SSB_IDHIGH_CC) >> SSB_IDHIGH_CC_SHIFT;
-		dev->id.revision = (idhi & SSB_IDHIGH_RCLO);
-		dev->id.revision |= (idhi & SSB_IDHIGH_RCHI) >>
-				    SSB_IDHIGH_RCHI_SHIFT;
-		dev->id.vendor = (idhi & SSB_IDHIGH_VC) >> SSB_IDHIGH_VC_SHIFT;
-		dev->core_index = i;
-		dev->bus = bus;
-		dev->ops = bus->ops;
-		dev->helpers = &ssb_helpers_sb;
-
-		if (ssb_bus_check_core(dev, &nr_80211_cores, i) < 0)
-			continue;
-
-		dev_i++;
-	}
-	bus->nr_devices = dev_i;
-	return 0;
-}
-
 int ssb_bus_scan(struct ssb_bus *bus, unsigned long baseaddr)
 {
 	int err = -ENOMEM;
--- linux-wireless-testing.orig/drivers/ssb/ssb_private.h	2011-02-17 16:00:21.000000000 +0200
+++ linux-wireless-testing/drivers/ssb/ssb_private.h	2011-02-17 16:00:43.000000000 +0200
@@ -3,6 +3,7 @@
 
 #include <linux/ssb/ssb.h>
 #include <linux/types.h>
+#include "ssb_sb.h"
 
 
 #define PFX	"ssb: "
@@ -29,6 +30,9 @@ static inline int __ssb_do_nothing(int x
 # define SSB_BUG_ON(x)		__ssb_do_nothing(unlikely(!!(x)))
 #endif
 
+/* main.c */
+extern int ssb_wait_bit(struct ssb_device *dev, u16 reg, u32 bitmask,
+			int timeout, int set);
 
 /* pci.c */
 #ifdef CONFIG_SSB_PCIHOST
@@ -159,9 +163,9 @@ static inline int ssb_sdio_init(struct s
 extern const char *ssb_core_name(u16 coreid);
 extern int ssb_bus_scan(struct ssb_bus *bus,
 			unsigned long baseaddr);
-extern void ssb_iounmap_sb(struct ssb_bus *bus);
 extern int ssb_bus_check_core(struct ssb_device *dev, int *nr_80211_cores,
 			      int corenum);
+extern u32 scan_read32(struct ssb_bus *bus, u8 current_coreidx, u16 offset);
 static inline void ssb_iounmap(struct ssb_bus *bus)
 {
 	ssb_iounmap_sb(bus);
@@ -212,30 +216,4 @@ static inline void b43_pci_ssb_bridge_ex
 }
 #endif /* CONFIG_SSB_B43_PCI_BRIDGE */
 
-extern const struct ssb_bus_helpers ssb_helpers_sb;
-
-/* SB-style bus core control and state registers */
-#define SSB_TMSLOW		0x0F98     /* SB Target State Low */
-#define  SSB_TMSLOW_RESET	0x00000001 /* Reset */
-#define  SSB_TMSLOW_REJECT_22	0x00000002 /* Reject (Backplane rev 2.2) */
-#define  SSB_TMSLOW_REJECT_23	0x00000004 /* Reject (Backplane rev 2.3) */
-#define  SSB_TMSLOW_PHYCLK	0x00000010 /* MAC PHY Clock Control Enable */
-#define  SSB_TMSLOW_CLOCK	0x00010000 /* Clock Enable */
-#define  SSB_TMSLOW_FGC		0x00020000 /* Force Gated Clocks On */
-#define  SSB_TMSLOW_PE		0x40000000 /* Power Management Enable */
-#define  SSB_TMSLOW_BE		0x80000000 /* BIST Enable */
-#define  SSB_TMSLOW_FLAGS_SHIFT		16 /* Flags shift for TMSLOW
-					    * register of SB-style buses */
-#define SSB_TMSHIGH		0x0F9C     /* SB Target State High */
-#define  SSB_TMSHIGH_SERR	0x00000001 /* S-error */
-#define  SSB_TMSHIGH_INT	0x00000002 /* Interrupt */
-#define  SSB_TMSHIGH_BUSY	0x00000004 /* Busy */
-#define  SSB_TMSHIGH_TO		0x00000020 /* Timeout. Backplane rev >= 2.3 only */
-#define  SSB_TMSHIGH_DMA64	0x10000000 /* 64bit DMA supported */
-#define  SSB_TMSHIGH_GCR	0x20000000 /* Gated Clock Request */
-#define  SSB_TMSHIGH_BISTF	0x40000000 /* BIST Failed */
-#define  SSB_TMSHIGH_BISTD	0x80000000 /* BIST Done */
-#define  SSB_TMSHIGH_FLAGS_SHIFT	16 /* Flags shift for TMSHIGH
-					    * register of SB-style buses */
-
 #endif /* LINUX_SSB_PRIVATE_H_ */
--- linux-wireless-testing.orig/drivers/ssb/ssb_sb.c	1970-01-01 03:00:00.000000000 +0300
+++ linux-wireless-testing/drivers/ssb/ssb_sb.c	2011-02-17 16:01:30.000000000 +0200
@@ -0,0 +1,289 @@
+/*
+ * Sonics Silicon Backplane
+ * SB-specific Subsystem core
+ *
+ * Copyright 2005, Broadcom Corporation
+ * Copyright 2006, 2007, Michael Buesch <mb@bu3sch.de>
+ *
+ * Licensed under the GNU/GPL. See COPYING for details.
+ */
+
+#include <linux/ssb/ssb.h>
+#include <linux/delay.h>
+
+#include "ssb_private.h"
+
+
+static u32 ssb_tmslow_reject_bitmask(struct ssb_device *dev)
+{
+	u32 rev = ssb_read32(dev, SSB_IDLOW) & SSB_IDLOW_SSBREV;
+
+	/* The REJECT bit changed position in TMSLOW between
+	 * Backplane revisions. */
+	switch (rev) {
+	case SSB_IDLOW_SSBREV_22:
+		return SSB_TMSLOW_REJECT_22;
+	case SSB_IDLOW_SSBREV_23:
+		return SSB_TMSLOW_REJECT_23;
+	case SSB_IDLOW_SSBREV_24:     /* TODO - find the proper REJECT bits */
+	case SSB_IDLOW_SSBREV_25:     /* same here */
+	case SSB_IDLOW_SSBREV_26:     /* same here */
+	case SSB_IDLOW_SSBREV_27:     /* same here */
+		return SSB_TMSLOW_REJECT_23;	/* this is a guess */
+	default:
+		printk(KERN_INFO "ssb: Backplane Revision 0x%.8X\n", rev);
+		WARN_ON(1);
+	}
+	return SSB_TMSLOW_REJECT_22 | SSB_TMSLOW_REJECT_23;
+}
+
+static int ssb_device_is_enabled_sb(struct ssb_device *dev)
+{
+	u32 val;
+	u32 reject;
+
+	reject = ssb_tmslow_reject_bitmask(dev);
+	val = ssb_read32(dev, SSB_TMSLOW);
+	val &= SSB_TMSLOW_CLOCK | SSB_TMSLOW_RESET | reject;
+
+	return (val == SSB_TMSLOW_CLOCK);
+}
+
+static void ssb_flush_tmslow(struct ssb_device *dev)
+{
+	/* Make _really_ sure the device has finished the TMSLOW
+	 * register write transaction, as we risk running into
+	 * a machine check exception otherwise.
+	 * Do this by reading the register back to commit the
+	 * PCI write and delay an additional usec for the device
+	 * to react to the change. */
+	ssb_read32(dev, SSB_TMSLOW);
+	udelay(1);
+}
+
+static void ssb_device_disable_sb(struct ssb_device *dev,
+				  u32 core_specific_flags)
+{
+	u32 reject;
+
+	if (ssb_read32(dev, SSB_TMSLOW) & SSB_TMSLOW_RESET)
+		return;
+
+	SSB_WARN_ON(core_specific_flags & 0xFFFF0000);
+
+	core_specific_flags <<= SSB_TMSLOW_FLAGS_SHIFT;
+	reject = ssb_tmslow_reject_bitmask(dev);
+	ssb_write32(dev, SSB_TMSLOW, reject | SSB_TMSLOW_CLOCK);
+	ssb_wait_bit(dev, SSB_TMSLOW, reject, 1000, 1);
+	ssb_wait_bit(dev, SSB_TMSHIGH, SSB_TMSHIGH_BUSY, 1000, 0);
+	ssb_write32(dev, SSB_TMSLOW,
+		    SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK |
+		    reject | SSB_TMSLOW_RESET |
+		    core_specific_flags);
+	ssb_flush_tmslow(dev);
+
+	ssb_write32(dev, SSB_TMSLOW,
+		    reject | SSB_TMSLOW_RESET |
+		    core_specific_flags);
+	ssb_flush_tmslow(dev);
+}
+
+
+static void ssb_device_enable_sb(struct ssb_device *dev,
+				 u32 core_specific_flags)
+{
+	u32 val;
+
+	ssb_device_disable_sb(dev, core_specific_flags);
+	core_specific_flags <<= SSB_TMSLOW_FLAGS_SHIFT;
+	ssb_write32(dev, SSB_TMSLOW,
+		    SSB_TMSLOW_RESET | SSB_TMSLOW_CLOCK |
+		    SSB_TMSLOW_FGC | core_specific_flags);
+	ssb_flush_tmslow(dev);
+
+	/* Clear SERR if set. This is a hw bug workaround. */
+	if (ssb_read32(dev, SSB_TMSHIGH) & SSB_TMSHIGH_SERR)
+		ssb_write32(dev, SSB_TMSHIGH, 0);
+
+	val = ssb_read32(dev, SSB_IMSTATE);
+	if (val & (SSB_IMSTATE_IBE | SSB_IMSTATE_TO)) {
+		val &= ~(SSB_IMSTATE_IBE | SSB_IMSTATE_TO);
+		ssb_write32(dev, SSB_IMSTATE, val);
+	}
+
+	ssb_write32(dev, SSB_TMSLOW,
+		    SSB_TMSLOW_CLOCK | SSB_TMSLOW_FGC |
+		    core_specific_flags);
+	ssb_flush_tmslow(dev);
+
+	ssb_write32(dev, SSB_TMSLOW, SSB_TMSLOW_CLOCK |
+		    core_specific_flags);
+	ssb_flush_tmslow(dev);
+}
+
+static u32 ssb_admatch_base_sb(struct ssb_device *dev, u32 adm)
+{
+	u32 base = 0;
+
+	adm = ssb_read32(dev, adm);
+
+	switch (adm & SSB_ADM_TYPE) {
+	case SSB_ADM_TYPE0:
+		base = (adm & SSB_ADM_BASE0);
+		break;
+	case SSB_ADM_TYPE1:
+		SSB_WARN_ON(adm & SSB_ADM_NEG); /* unsupported */
+		base = (adm & SSB_ADM_BASE1);
+		break;
+	case SSB_ADM_TYPE2:
+		SSB_WARN_ON(adm & SSB_ADM_NEG); /* unsupported */
+		base = (adm & SSB_ADM_BASE2);
+		break;
+	default:
+		SSB_WARN_ON(1);
+	}
+
+	return base;
+}
+
+static u32 ssb_admatch_size_sb(struct ssb_device *dev, u32 adm)
+{
+	u32 size = 0;
+
+	adm = ssb_read32(dev, adm);
+
+	switch (adm & SSB_ADM_TYPE) {
+	case SSB_ADM_TYPE0:
+		size = ((adm & SSB_ADM_SZ0) >> SSB_ADM_SZ0_SHIFT);
+		break;
+	case SSB_ADM_TYPE1:
+		SSB_WARN_ON(adm & SSB_ADM_NEG); /* unsupported */
+		size = ((adm & SSB_ADM_SZ1) >> SSB_ADM_SZ1_SHIFT);
+		break;
+	case SSB_ADM_TYPE2:
+		SSB_WARN_ON(adm & SSB_ADM_NEG); /* unsupported */
+		size = ((adm & SSB_ADM_SZ2) >> SSB_ADM_SZ2_SHIFT);
+		break;
+	default:
+		SSB_WARN_ON(1);
+	}
+	size = (1 << (size + 1));
+
+	return size;
+}
+
+static u32 ssb_core_ctl_flags_sb(struct ssb_device *dev, u32 mask, u32 val)
+{
+	mask = ~mask;
+	SSB_WARN_ON((mask | val) & 0xFFFF0000);
+	if (mask || val) {
+		u32 tmp = (ssb_read32(dev, SSB_TMSLOW) &
+			   ~(mask << SSB_TMSLOW_FLAGS_SHIFT)) |
+			   (val << SSB_TMSLOW_FLAGS_SHIFT);
+		ssb_write32(dev, SSB_TMSLOW, tmp);
+	}
+
+	return ssb_read32(dev, SSB_TMSLOW) >> SSB_TMSLOW_FLAGS_SHIFT;
+}
+
+static u32 ssb_core_state_flags_sb(struct ssb_device *dev)
+{
+	return ssb_read32(dev, SSB_TMSHIGH) >> SSB_TMSHIGH_FLAGS_SHIFT;
+}
+
+const struct ssb_bus_helpers ssb_helpers_sb = {
+	.device_is_enabled	= ssb_device_is_enabled_sb,
+	.device_enable		= ssb_device_enable_sb,
+	.device_disable		= ssb_device_disable_sb,
+	.admatch_base		= ssb_admatch_base_sb,
+	.admatch_size		= ssb_admatch_size_sb,
+	.core_ctl_flags		= ssb_core_ctl_flags_sb,
+	.core_state_flags	= ssb_core_state_flags_sb,
+};
+
+#ifdef CONFIG_SSB_DRIVER_MIPS
+static u32 ssb_irqflag_sb(struct ssb_device *dev)
+{
+	u32 tpsflag = ssb_read32(dev, SSB_TPSFLAG) & SSB_TPSFLAG_BPFLAG;
+	if (tpsflag && tpsflag != SSB_TPSFLAG_BPFLAG)
+		return tpsflag;
+	else
+		/* not irq supported */
+		return -1;
+}
+#endif /* CONFIG_SSB_DRIVER_MIPS */
+
+int scan_switchcore(struct ssb_bus *bus, u8 coreidx)
+{
+	switch (bus->bustype) {
+	case SSB_BUSTYPE_SSB:
+		break;
+	case SSB_BUSTYPE_PCI:
+		return ssb_pci_switch_coreidx(bus, coreidx);
+	case SSB_BUSTYPE_PCMCIA:
+		return ssb_pcmcia_switch_coreidx(bus, coreidx);
+	case SSB_BUSTYPE_SDIO:
+		return ssb_sdio_scan_switch_coreidx(bus, coreidx);
+	}
+	return 0;
+}
+
+void ssb_iounmap_sb(struct ssb_bus *bus)
+{
+	switch (bus->bustype) {
+	case SSB_BUSTYPE_SSB:
+	case SSB_BUSTYPE_PCMCIA:
+		iounmap(bus->mmio);
+		break;
+#ifdef CONFIG_SSB_PCIHOST
+	case SSB_BUSTYPE_PCI:
+		pci_iounmap(bus->host_pci, bus->mmio);
+#else
+		SSB_BUG_ON(1); /* Can't reach this code. */
+#endif
+		break;
+	case SSB_BUSTYPE_SDIO:
+		break;
+	}
+	bus->mmio = NULL;
+	bus->mapped_device = NULL;
+}
+
+int ssb_bus_scan_sb(struct ssb_bus *bus, unsigned long baseaddr)
+{
+	u32 idhi;
+	int dev_i, i;
+	struct ssb_device *dev;
+	int nr_80211_cores = 0;
+	int err;
+
+#ifdef CONFIG_SSB_DRIVER_MIPS
+	bus->mipscore.irqflag = ssb_irqflag_sb;
+#endif /* CONFIG_SSB_DRIVER_MIPS */
+
+	/* Fetch basic information about each core/device */
+	for (i = 0, dev_i = 0; i < bus->nr_devices; i++) {
+		err = scan_switchcore(bus, i);
+		if (err)
+			return err;
+		dev = &(bus->devices[dev_i]);
+
+		idhi = scan_read32(bus, i, SSB_IDHIGH);
+		dev->id.coreid = (idhi & SSB_IDHIGH_CC) >> SSB_IDHIGH_CC_SHIFT;
+		dev->id.revision = (idhi & SSB_IDHIGH_RCLO);
+		dev->id.revision |= (idhi & SSB_IDHIGH_RCHI) >>
+				    SSB_IDHIGH_RCHI_SHIFT;
+		dev->id.vendor = (idhi & SSB_IDHIGH_VC) >> SSB_IDHIGH_VC_SHIFT;
+		dev->core_index = i;
+		dev->bus = bus;
+		dev->ops = bus->ops;
+		dev->helpers = &ssb_helpers_sb;
+
+		if (ssb_bus_check_core(dev, &nr_80211_cores, i) < 0)
+			continue;
+
+		dev_i++;
+	}
+	bus->nr_devices = dev_i;
+	return 0;
+}
--- linux-wireless-testing.orig/drivers/ssb/ssb_sb.h	1970-01-01 03:00:00.000000000 +0300
+++ linux-wireless-testing/drivers/ssb/ssb_sb.h	2011-02-17 15:55:25.000000000 +0200
@@ -0,0 +1,52 @@
+#ifndef LINUX_SSB_SB_H_
+#define LINUX_SSB_SB_H_
+
+#ifdef CONFIG_SSB_BUS_SB
+
+/* SB-style bus core control and state registers */
+#define SSB_TMSLOW		0x0F98     /* SB Target State Low */
+#define  SSB_TMSLOW_RESET	0x00000001 /* Reset */
+#define  SSB_TMSLOW_REJECT_22	0x00000002 /* Reject (Backplane rev 2.2) */
+#define  SSB_TMSLOW_REJECT_23	0x00000004 /* Reject (Backplane rev 2.3) */
+#define  SSB_TMSLOW_PHYCLK	0x00000010 /* MAC PHY Clock Control Enable */
+#define  SSB_TMSLOW_CLOCK	0x00010000 /* Clock Enable */
+#define  SSB_TMSLOW_FGC		0x00020000 /* Force Gated Clocks On */
+#define  SSB_TMSLOW_PE		0x40000000 /* Power Management Enable */
+#define  SSB_TMSLOW_BE		0x80000000 /* BIST Enable */
+#define  SSB_TMSLOW_FLAGS_SHIFT		16 /* Flags shift for TMSLOW
+					    * register of SB-style buses */
+#define SSB_TMSHIGH		0x0F9C     /* SB Target State High */
+#define  SSB_TMSHIGH_SERR	0x00000001 /* S-error */
+#define  SSB_TMSHIGH_INT	0x00000002 /* Interrupt */
+#define  SSB_TMSHIGH_BUSY	0x00000004 /* Busy */
+#define  SSB_TMSHIGH_TO		0x00000020 /* Timeout. Backplane rev >= 2.3 only */
+#define  SSB_TMSHIGH_DMA64	0x10000000 /* 64bit DMA supported */
+#define  SSB_TMSHIGH_GCR	0x20000000 /* Gated Clock Request */
+#define  SSB_TMSHIGH_BISTF	0x40000000 /* BIST Failed */
+#define  SSB_TMSHIGH_BISTD	0x80000000 /* BIST Done */
+#define  SSB_TMSHIGH_FLAGS_SHIFT	16 /* Flags shift for TMSHIGH
+					    * register of SB-style buses */
+
+extern int ssb_bus_scan_sb(struct ssb_bus *bus, unsigned long baseaddr);
+extern int scan_switchcore(struct ssb_bus *bus, u8 coreidx);
+extern void ssb_iounmap_sb(struct ssb_bus *bus);
+
+#else /* CONFIG_SSB_BUS_SB */
+
+static inline int scan_switchcore(struct ssb_bus *bus, u8 coreidx)
+{
+	return 0;
+}
+
+static inline void ssb_iounmap_sb(struct ssb_bus *bus)
+{
+}
+
+static inline int ssb_bus_scan_sb(struct ssb_bus *bus, unsigned long baseaddr)
+{
+	return -ENODEV;
+}
+
+#endif /* CONFIG_SSB_BUS_SB */
+
+#endif /* !LINUX_SSB_SB_H_ */



