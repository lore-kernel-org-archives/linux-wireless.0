Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:27066 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab1BQWjt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Feb 2011 17:39:49 -0500
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000022268.msg
	for <linux-wireless@vger.kernel.org>; Fri, 18 Feb 2011 00:39:11 +0200
Subject: Re: [RFC] AI support (13/14 ssb add AI support)
From: George Kashperko <george@znau.edu.ua>
To: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1297980093.13554.5.camel@maggie>
References: <1297958316.5623.27.camel@dev.znau.edu.ua>
	 (sfid-20110217_170718_357395_57E8418D)  <1297980093.13554.5.camel@maggie>
Content-Type: text/plain
Date: Fri, 18 Feb 2011 00:31:22 +0200
Message-Id: <1297981882.23381.38.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: George Kashperko <george@znau.edu.ua>

Add support for AI-style bus.
Signed-off-by: George Kashperko <george@znau.edu.ua>
---
 drivers/ssb/Kconfig                       |   11 
 drivers/ssb/Makefile                      |    1 
 drivers/ssb/main.c                        |    2 
 drivers/ssb/scan.c                        |   47 +-
 drivers/ssb/ssb_ai.c                      |  407 ++++++++++++++++++++
 drivers/ssb/ssb_ai.h                      |   79 +++
 drivers/ssb/ssb_private.h                 |    6 
 include/linux/ssb/ssb.h                   |   44 ++
 include/linux/ssb/ssb_driver_chipcommon.h |    3 
 include/linux/ssb/ssb_regs.h              |    1 
 10 files changed, 593 insertions(+), 8 deletions(-)
--- linux-wireless-testing.orig/drivers/ssb/Kconfig	2011-02-17 15:56:58.000000000 +0200
+++ linux-wireless-testing/drivers/ssb/Kconfig	2011-02-17 15:57:14.000000000 +0200
@@ -32,6 +32,17 @@ config SSB_BUS_SB
 	help
 	  Sonics Silicon Backplane SB-style bus
 
+config SSB_BUS_AI_POSSIBLE
+	bool
+	default y if SSB && EXPERIMENTAL
+
+config SSB_BUS_AI
+	bool "AI style bus"
+	depends on SSB_BUS_AI_POSSIBLE
+	default n
+	help
+	  Broadcom AI-style bus
+
 # Common SPROM support routines
 config SSB_SPROM
 	bool
--- linux-wireless-testing.orig/drivers/ssb/main.c	2011-02-17 15:56:58.000000000 +0200
+++ linux-wireless-testing/drivers/ssb/main.c	2011-02-17 15:57:14.000000000 +0200
@@ -855,6 +855,8 @@ static const char *ssb_chipco_chiptype_n
 	switch (bus->chipco.chiptype) {
 	case SSB_CHIPCO_SB:
 		return "SB";
+	case SSB_CHIPCO_AI:
+		return "AI";
 	default:
 		return "UNKNOWN";
 	}
--- linux-wireless-testing.orig/drivers/ssb/Makefile	2011-02-17 15:56:58.000000000 +0200
+++ linux-wireless-testing/drivers/ssb/Makefile	2011-02-17 15:57:14.000000000 +0200
@@ -1,6 +1,7 @@
 # core
 ssb-y					+= main.o scan.o
 ssb-$(CONFIG_SSB_BUS_SB)		+= ssb_sb.o
+ssb-$(CONFIG_SSB_BUS_AI)		+= ssb_ai.o
 ssb-$(CONFIG_SSB_EMBEDDED)		+= embedded.o
 ssb-$(CONFIG_SSB_SPROM)			+= sprom.o
 
--- linux-wireless-testing.orig/drivers/ssb/scan.c	2011-02-17 15:57:09.000000000 +0200
+++ linux-wireless-testing/drivers/ssb/scan.c	2011-02-17 15:57:14.000000000 +0200
@@ -326,19 +326,48 @@ int ssb_bus_check_core(struct ssb_device
 	return 0;
 }
 
+static inline bool ssb_can_read_idhi(void)
+{
+#ifdef CONFIG_MIPS
+	return cpu_data[0].cputype != CPU_74K;
+#else
+	return true;
+#endif
+}
+
 /* Detect bus type and major bus information */
 static int ssb_bus_detect(struct ssb_bus *bus)
 {
-	u32 idhi, cc, rev, tmp;
+	u32 idhi, rev, tmp;
+	bool have_chipcommon = true;
 	enum ssb_chipco_chiptype chiptype = SSB_CHIPCO_SB;
 
-	idhi = scan_read32(bus, 0, SSB_IDHIGH);
-	cc = (idhi & SSB_IDHIGH_CC) >> SSB_IDHIGH_CC_SHIFT;
-	rev = (idhi & SSB_IDHIGH_RCLO);
-	rev |= (idhi & SSB_IDHIGH_RCHI) >> SSB_IDHIGH_RCHI_SHIFT;
+	/* the problem goes like this:
+	 *  if we access the normal core id backplane registers on an AI soc,
+	 *   the thing hangs.
+	 *  To figure out, if we have an AI soc, we have to look in a
+	 *   chipcommon register.
+	 *  The 4710 doesn't have a chipcommon but we can't figure this out
+	 *   without scanning the cores, and we don't know, if we have to use
+	 *   the AI or normal method.
+	 *  All known AI socs have a 74k cpu, so let's take this as an
+	 *   indicator that we have a chipcommon core and hope for the best.
+	 */
+	rev = 0;
+	if (ssb_can_read_idhi()) {
+		idhi = scan_read32(bus, 0, SSB_IDHIGH);
+		if (((idhi & SSB_IDHIGH_CC) >> SSB_IDHIGH_CC_SHIFT) !=
+		    SSB_DEV_CHIPCOMMON) {
+			have_chipcommon = false;
+		} else {
+			rev = (idhi & SSB_IDHIGH_RCLO);
+			rev |= (idhi & SSB_IDHIGH_RCHI) >>
+				SSB_IDHIGH_RCHI_SHIFT;
+		}
+	}
 
 	bus->nr_devices = 0;
-	if (cc == SSB_DEV_CHIPCOMMON) {
+	if (have_chipcommon) {
 		tmp = scan_read32(bus, 0, SSB_CHIPCO_CHIPID);
 
 		chiptype = SSB_CHIPCO_TYPE(tmp);
@@ -375,7 +404,8 @@ static int ssb_bus_detect(struct ssb_bus
 	}
 
 	bus->chipco.chiptype = chiptype;
-	return chiptype == SSB_CHIPCO_SB ? 0 : -ENODEV;
+	return (chiptype == SSB_CHIPCO_SB ||
+		chiptype == SSB_CHIPCO_AI) ? 0 : -ENODEV;
 }
 
 int ssb_bus_scan(struct ssb_bus *bus, unsigned long baseaddr)
@@ -416,6 +446,9 @@ int ssb_bus_scan(struct ssb_bus *bus, un
 	case SSB_CHIPCO_SB:
 		err = ssb_bus_scan_sb(bus, baseaddr);
 		break;
+	case SSB_CHIPCO_AI:
+		err = ssb_bus_scan_ai(bus, baseaddr);
+		break;
 	default:
 		SSB_WARN_ON(1);
 		err = -ENODEV;
--- linux-wireless-testing.orig/drivers/ssb/ssb_ai.c	1970-01-01 03:00:00.000000000 +0300
+++ linux-wireless-testing/drivers/ssb/ssb_ai.c	2011-02-17 15:57:14.000000000 +0200
@@ -0,0 +1,407 @@
+/*
+ * Sonics Silicon Backplane
+ * AI Specific Subsystem core
+ *
+ * Copyright 2011, George Kashperko <george@znau.edu.ua>
+ * Copyright 2010, Bernhard Loos <bernhardloos@googlemail.com>
+ * Copyright (C) 2006 Broadcom Corporation.
+ *
+ * Licensed under the GNU/GPL. See COPYING for details.
+ */
+
+#include <linux/delay.h>
+#include <linux/ssb/ssb.h>
+#include <linux/ssb/ssb_regs.h>
+
+#include "ssb_private.h"
+#include "ssb_ai.h"
+
+
+static inline u32 ssb_airead32(struct ssb_device *dev, u16 offset)
+{
+	return dev->ai.ops->read32(dev, offset);
+}
+
+static inline void ssb_aiwrite32(struct ssb_device *dev, u16 offset, u32 value)
+{
+	dev->ai.ops->write32(dev, offset, value);
+}
+
+static u32 ssb_ssb_airead32(struct ssb_device *dev, u16 offset)
+{
+	struct ssb_bus *bus = dev->bus;
+
+	offset += dev->core_index * SSB_CORE_SIZE;
+	return readl(bus->ai.mmio + offset);
+}
+
+static void ssb_ssb_aiwrite32(struct ssb_device *dev, u16 offset, u32 value)
+{
+	struct ssb_bus *bus = dev->bus;
+
+	offset += dev->core_index * SSB_CORE_SIZE;
+	return writel(value, bus->ai.mmio + offset);
+}
+
+struct ssb_bus_aiops ssb_ssb_aiops = {
+	.read32		= ssb_ssb_airead32,
+	.write32	= ssb_ssb_aiwrite32,
+};
+
+/* The 47162a0 hangs when reading its registers */
+static inline bool ssb_bcm47162a0_quirk(struct ssb_device *dev)
+{
+	return dev->bus->chip_id == 47162 && dev->bus->chip_rev == 0 &&
+	       dev->id.coreid == SSB_DEV_MIPS_74K;
+}
+
+static u32 ssb_core_ctl_flags_ai(struct ssb_device *dev, u32 mask, u32 val)
+{
+	if (ssb_bcm47162a0_quirk(dev)) {
+		ssb_printk(KERN_ERR PFX "%s: Accessing MIPS DMP register "
+		       "(IOCTL) on 47162a0", __func__);
+		return 0;
+	}
+
+	SSB_WARN_ON((~mask | val) & 0xFFFF0000);
+
+	if (~mask || val) {
+		u32 tmp = (ssb_airead32(dev, SSB_AI_IOCTL) & mask) | val;
+		ssb_aiwrite32(dev, SSB_AI_IOCTL, tmp);
+	}
+
+	return ssb_airead32(dev, SSB_AI_IOCTL);
+}
+
+static u32 ssb_core_state_flags_ai(struct ssb_device *dev)
+{
+	if (ssb_bcm47162a0_quirk(dev)) {
+		ssb_printk(KERN_ERR PFX "%s: Accessing MIPS DMP register "
+			   "(IOSTAT) on 47162a0", __func__);
+		return 0;
+	}
+	return ssb_airead32(dev, SSB_AI_IOSTAT);
+}
+
+#ifdef CONFIG_SSB_DRIVER_MIPS
+/* return -1 if no irq is supported */
+static u32 ssb_irqflag_ai(struct ssb_device *dev)
+{
+	u32 flag;
+
+	if (ssb_bcm47162a0_quirk(dev))
+		return dev->core_index;
+
+	flag = ssb_airead32(dev, SSB_AI_oobselouta30) & 0x1F;
+
+	if (flag && flag != 0x1F)
+		return flag;
+	else
+		/* not irq supported */
+		return -1;
+}
+#endif /* CONFIG_SSB_DRIVER_MIPS */
+
+static int ssb_device_is_enabled_ai(struct ssb_device *dev)
+{
+	return (ssb_airead32(dev, SSB_AI_RESETCTL) &
+		SSB_AI_RESETCTL_RESET) == 0;
+}
+
+static void ssb_aiioctl_write(struct ssb_device *dev, u32 flags)
+{
+	u32 dummy;
+	ssb_aiwrite32(dev, SSB_AI_IOCTL, flags);
+	dummy = ssb_airead32(dev, SSB_AI_IOCTL);
+	udelay(1);
+}
+
+static void ssb_device_disable_ai(struct ssb_device *dev,
+				  u32 core_specific_flags)
+{
+	SSB_WARN_ON(core_specific_flags & 0xFFFF0000);
+	if (ssb_airead32(dev, SSB_AI_RESETCTL) & SSB_AI_RESETCTL_RESET)
+		return;
+	ssb_aiioctl_write(dev, core_specific_flags);
+	udelay(9);
+	ssb_aiwrite32(dev, SSB_AI_RESETCTL, SSB_AI_RESETCTL_RESET);
+	udelay(1);
+}
+
+static void ssb_device_enable_ai(struct ssb_device *dev,
+				 u32 core_specific_flags)
+{
+	ssb_device_disable_ai(dev, core_specific_flags);
+
+	ssb_aiioctl_write(dev, core_specific_flags | SSB_CORECTL_FGC |
+			       SSB_CORECTL_CLOCK);
+	ssb_aiwrite32(dev, SSB_AI_RESETCTL, 0);
+	udelay(1);
+
+	ssb_aiioctl_write(dev, core_specific_flags | SSB_CORECTL_CLOCK);
+}
+
+static u32 ssb_admatch_base_ai(struct ssb_device *dev, u32 adm)
+{
+	switch (adm) {
+	case SSB_ADMATCH0:
+		return dev->ai.core[0].base;
+	case SSB_ADMATCH1:
+		return dev->ai.core[1].base;
+	default:
+		printk(KERN_ERR PFX "Need to parse the erom again "
+				    "to find addr space %d\n",
+				    adm & SSB_ADM_TYPE);
+		return 0;
+	}
+}
+
+static u32 ssb_admatch_size_ai(struct ssb_device *dev, u32 adm)
+{
+	switch (adm) {
+	case SSB_ADMATCH0:
+		return dev->ai.core[0].size;
+	case SSB_ADMATCH1:
+		return dev->ai.core[1].size;
+	default:
+		printk(KERN_ERR PFX "Need to parse the erom again "
+				    "to find addr space %d size\n",
+				    adm & SSB_ADM_TYPE);
+		return 0;
+	}
+}
+
+const struct ssb_bus_helpers ssb_helpers_ai = {
+	.device_is_enabled	= ssb_device_is_enabled_ai,
+	.device_enable		= ssb_device_enable_ai,
+	.device_disable		= ssb_device_disable_ai,
+	.admatch_base		= ssb_admatch_base_ai,
+	.admatch_size		= ssb_admatch_size_ai,
+	.core_ctl_flags		= ssb_core_ctl_flags_ai,
+	.core_state_flags	= ssb_core_state_flags_ai,
+};
+
+void ssb_iounmap_ai(struct ssb_bus *bus)
+{
+	switch (bus->bustype) {
+	case SSB_BUSTYPE_SSB:
+		iounmap(bus->mmio);
+		iounmap(bus->ai.mmio);
+		break;
+	default:
+		break;
+	}
+	bus->mmio = NULL;
+	bus->ai.mmio = NULL;
+	bus->mapped_device = NULL;
+	bus->ai.mapped_device = NULL;
+}
+
+static u32 get_erom_ent(struct ssb_bus *bus, u32 **eromptr, u32 mask, u32 match)
+{
+	u32 ent;
+
+	while (1) {
+		ent = readl(*eromptr);
+		(*eromptr)++;
+
+		if (mask == 0)
+			break;
+
+		if ((ent & SSB_EROM_VALID) == 0)
+			continue;
+
+		if (ent == (SSB_EROM_END | SSB_EROM_VALID))
+			break;
+
+		if ((ent & mask) == match)
+			break;
+	}
+	return ent;
+}
+
+static u32 get_adress_space_descriptor(struct ssb_bus *bus, u32 **eromptr,
+				       uint st, u32 *addrl, u32 *sizel)
+{
+	u32 asd, sz, szd, expect;
+
+	expect = SSB_EROM_ASD | st;
+	if (st == SSB_EROM_ASD_ST_SWRAP)
+		expect |= 1 << SSB_EROM_ASD_SP_SHIFT;
+
+	asd = get_erom_ent(bus, eromptr, SSB_EROM_ASD_SP_MASK | SSB_EROM_TAG |
+			   SSB_EROM_ASD_ST_MASK, expect);
+
+	*addrl = asd & SSB_EROM_ASD_ADDR_MASK;
+
+	/* 64bit addresses are not supported */
+	BUG_ON(asd & SSB_EROM_ASD_AG32);
+
+	sz = asd & SSB_EROM_ASD_SZ_MASK;
+	if (sz == SSB_EROM_ASD_SZ_SZD) {
+		szd = get_erom_ent(bus, eromptr, 0, 0);
+		*sizel = szd & SSB_EROM_ASD_SZ_MASK;
+	} else
+		*sizel = SSB_EROM_ASD_SZ_BASE << (sz >> SSB_EROM_ASD_SZ_SHIFT);
+
+	return asd;
+}
+
+int ssb_bus_scan_ai(struct ssb_bus *bus, unsigned long baseaddr)
+{
+	int dev_i = 0, nr_80211_cores = 0;
+	struct ssb_device *dev;
+	u32 erombase;
+	u32 __iomem *eromptr, *eromend;
+
+	erombase = scan_read32(bus, 0, SSB_CHIPCO_EROM);
+
+	switch (bus->bustype) {
+	case SSB_BUSTYPE_SSB:
+		bus->ai.ops = &ssb_ssb_aiops;
+		eromptr = ioremap(erombase, SSB_CORE_SIZE);
+		if (!eromptr)
+			return -ENOMEM;
+		break;
+	default:
+		return -ENODEV;
+	}
+
+	eromend = eromptr + SSB_CORE_SIZE / sizeof(u32);
+
+#ifdef CONFIG_SSB_DRIVER_MIPS
+	bus->mipscore.irqflag = ssb_irqflag_ai;
+#endif /* CONFIG_SSB_DRIVER_MIPS */
+
+	while (eromptr < eromend) {
+		u32 cia, cib, asd, sizel, addrl, nmw, nsp;
+
+		dev = &(bus->devices[dev_i]);
+
+		cia = get_erom_ent(bus, &eromptr, SSB_EROM_TAG, SSB_EROM_CI);
+		if (cia == (SSB_EROM_END | SSB_EROM_VALID)) {
+			ssb_dprintk(KERN_INFO PFX
+				    "Found END of erom after %d cores\n",
+				    dev_i);
+			if (dev_i != bus->nr_devices)
+				ssb_printk(KERN_WARNING PFX
+					   "Expected %d cores but got %d\n",
+					   bus->nr_devices, dev_i);
+			break;
+		}
+		cib = get_erom_ent(bus, &eromptr, 0, 0);
+		if ((cib & SSB_EROM_TAG) != SSB_EROM_CI) {
+			ssb_printk(KERN_ERR PFX "CIA not followed by CIB\n");
+			return -EIO;
+		}
+
+		dev->id.coreid = SSB_EROM_CIA_CID(cia);
+		dev->id.vendor = SSB_EROM_CIA_MFG(cia);
+		dev->id.revision = SSB_EROM_CIB_REV(cib);
+		dev->core_index = dev_i;
+		dev->bus = bus;
+		dev->helpers = &ssb_helpers_ai;
+		dev->ops = bus->ops;
+		dev->ai.ops = bus->ai.ops;
+
+		nmw = SSB_EROM_CIB_NMW(cib);
+		nsp = SSB_EROM_CIB_NSP(cib);
+
+		if (((dev->id.coreid == SSB_DEV_DEFAULT) &&
+		     (dev->id.vendor == SSB_VENDOR_ARM)) ||
+			(nmw == 0 && SSB_EROM_CIB_NSW(cib) == 0) || (nsp == 0))
+			continue;
+
+		/* see if it is a bridge */
+		if ((SSB_EROM_ASD_ST_MASK &
+		    get_erom_ent(bus, &eromptr, SSB_EROM_TAG, SSB_EROM_ASD)) ==
+		    SSB_EROM_ASD_ST_BRIDGE)
+			/* don't record bridges */
+			continue;
+		else
+			eromptr--;
+
+		/* First Slave Address Descriptor should be port 0:
+		 * the main register space for the core
+		 */
+		asd = get_adress_space_descriptor(bus, &eromptr,
+						  SSB_EROM_ASD_ST_SLAVE,
+						  &addrl, &sizel);
+		if (sizel != SSB_CORE_SIZE ||
+		    addrl != SSB_ENUM_BASE + SSB_CORE_SIZE * dev_i) {
+			ssb_printk(KERN_ERR PFX
+				   "Malformed or unsupported register address "
+				   "space descriptor for core %d:\n"
+				   "\texpected 0x%x, got 0x%x, size 0x%x\n",
+				   dev_i, SSB_ENUM_BASE + SSB_CORE_SIZE * dev_i,
+				   addrl, sizel);
+			return -EIO;
+		}
+
+		dev->ai.core[0].base = addrl;
+		dev->ai.core[0].size = sizel;
+
+		/* Try to get one more Slave Address Descriptor in port 0 */
+		asd = get_erom_ent(bus, &eromptr, SSB_EROM_VALID,
+				   SSB_EROM_VALID) & (SSB_EROM_ASD_SP_MASK |
+						      SSB_EROM_ASD_ST_MASK |
+						      SSB_EROM_TAG);
+		eromptr--;
+		if (asd == SSB_EROM_ASD) {
+			asd = get_adress_space_descriptor(bus, &eromptr,
+							  SSB_EROM_ASD_ST_SLAVE,
+							  &addrl, &sizel);
+			if (sizel != SSB_CORE_SIZE) {
+				ssb_printk(KERN_ERR PFX
+					   "Malformed or unsupported ai "
+					   "address space descriptor for "
+					   "core %d:\n\texpected 0x%x size, "
+					   "got 0x%x size\n",
+					   dev_i, SSB_CORE_SIZE, sizel);
+				return -EIO;
+			}
+			dev->ai.core[1].base = addrl;
+			dev->ai.core[1].size = sizel;
+		}
+
+		if (nmw)
+			asd = get_adress_space_descriptor(bus, &eromptr,
+							  SSB_EROM_ASD_ST_MWRAP,
+							  &addrl, &sizel);
+		else
+			asd = get_adress_space_descriptor(bus, &eromptr,
+							  SSB_EROM_ASD_ST_SWRAP,
+							  &addrl, &sizel);
+
+		if (sizel != SSB_CORE_SIZE ||
+		    addrl != SSB_AI_BASE + SSB_CORE_SIZE * dev_i) {
+			ssb_printk(KERN_ERR PFX
+				   "Malformed or unsupported ai "
+				   "address space descriptor for "
+				   "core %d:\n\texpected 0x%x, "
+				   "got 0x%x, size 0x%x\n",
+				   dev_i, SSB_AI_BASE + SSB_CORE_SIZE * dev_i,
+				   addrl, sizel);
+			return -EIO;
+		}
+
+		if (ssb_bus_check_core(dev, &nr_80211_cores, dev_i) < 0)
+			continue;
+
+		dev_i++;
+	}
+	bus->nr_devices = dev_i;
+
+	if (eromptr >= eromend)
+		ssb_printk(KERN_WARNING PFX
+			   "Reached end of erom without finding END");
+
+	if (bus->bustype == SSB_BUSTYPE_SSB && dev_i) {
+		/* remap as we got final num of cores */
+		bus->ai.mmio = ioremap(SSB_AI_BASE, SSB_CORE_SIZE * dev_i);
+		if (!bus->ai.mmio)
+			return -ENOMEM;
+	}
+
+	return 0;
+}
--- linux-wireless-testing.orig/drivers/ssb/ssb_ai.h	1970-01-01 03:00:00.000000000 +0300
+++ linux-wireless-testing/drivers/ssb/ssb_ai.h	2011-02-17 15:57:14.000000000 +0200
@@ -0,0 +1,79 @@
+#ifndef LINUX_SSB_AI_H_
+#define LINUX_SSB_AI_H_
+
+#ifdef CONFIG_SSB_BUS_AI
+
+#define SSB_AI_BASE			0x18100000U /* base for AI registers */
+
+/* EROM parsing defines */
+#define SSB_EROM_VALID			1
+#define SSB_EROM_END			0x0E
+#define SSB_EROM_TAG			0x0E
+
+/* Adress Space Descriptor */
+#define SSB_EROM_ASD			0x4
+#define  SSB_EROM_ASD_SP_MASK		0x00000F00
+#define  SSB_EROM_ASD_SP_SHIFT		8
+#define  SSB_EROM_ASD_ST_MASK		0x000000c0
+#define  SSB_EROM_ASD_ST_SLAVE		0x00000000
+#define  SSB_EROM_ASD_ST_BRIDGE		0x00000040
+#define  SSB_EROM_ASD_ST_MWRAP		0x000000C0
+#define  SSB_EROM_ASD_ST_SWRAP		0x00000080
+#define  SSB_EROM_ASD_ADDR_MASK		0xFFFFF000
+#define  SSB_EROM_ASD_AG32		0x00000008
+#define  SSB_EROM_ASD_SZ_MASK		0x00000030
+#define  SSB_EROM_ASD_SZ_SZD		0x00000030
+#define  SSB_EROM_ASD_SZ_SHIFT		4
+#define  SSB_EROM_ASD_SZ_BASE		0x00001000
+#define SSB_EROM_CI			0
+#define  SSB_EROM_CIA_CID_MASK		0x000FFF00
+#define  SSB_EROM_CIA_CID_SHIFT		8
+#define  SSB_EROM_CIA_MFG_MASK		0xFFF00000
+#define  SSB_EROM_CIA_MFG_SHIFT		20
+#define  SSB_EROM_CIB_REV_MASK		0xFF000000
+#define  SSB_EROM_CIB_REV_SHIFT		24
+#define  SSB_EROM_CIB_NMW_MASK		0x0007C000
+#define  SSB_EROM_CIB_NMW_SHIFT		14
+#define  SSB_EROM_CIB_NSW_MASK		0x00F80000
+#define  SSB_EROM_CIB_NSW_SHIFT		19
+#define  SSB_EROM_CIB_NSP_MASK		0x00003E00
+#define SSB_EROM_CIB_NSP_SHIFT		9
+
+/* Adress Space Descriptor macro defs */
+#define SSB_EROM_CIA_CID(cia) (((cia) & SSB_EROM_CIA_CID_MASK) >> \
+			       SSB_EROM_CIA_CID_SHIFT)
+#define SSB_EROM_CIA_MFG(cia) (((cia) & SSB_EROM_CIA_MFG_MASK) >> \
+			       SSB_EROM_CIA_MFG_SHIFT)
+#define SSB_EROM_CIB_REV(cib) (((cib) & SSB_EROM_CIB_REV_MASK) >> \
+			       SSB_EROM_CIB_REV_SHIFT)
+#define SSB_EROM_CIB_NMW(cib) (((cib) & SSB_EROM_CIB_NMW_MASK) >> \
+			       SSB_EROM_CIB_NMW_SHIFT)
+#define SSB_EROM_CIB_NSW(cib) (((cib) & SSB_EROM_CIB_NSW_MASK) >> \
+			       SSB_EROM_CIB_NSW_SHIFT)
+#define SSB_EROM_CIB_NSP(cib) (((cib) & SSB_EROM_CIB_NSP_MASK) >> \
+			       SSB_EROM_CIB_NSP_SHIFT)
+
+/* AI config space registers */
+#define SSB_AI_oobselouta30		0x100
+#define SSB_AI_IOCTL			0x408 /* maybe 0x40C for big endian */
+#define SSB_AI_IOSTAT			0x500
+#define SSB_AI_RESETCTL			0x800 /* maybe 0x804 for big endian */
+#define  SSB_AI_RESETCTL_RESET		1
+
+extern void ssb_iounmap_ai(struct ssb_bus *bus);
+extern int ssb_bus_scan_ai(struct ssb_bus *bus, unsigned long baseaddr);
+
+#else /* CONFIG_SSB_BUS_AI */
+
+static inline void ssb_iounmap_ai(struct ssb_bus *bus)
+{
+}
+
+static inline int ssb_bus_scan_ai(struct ssb_bus *bus, unsigned long baseaddr)
+{
+	return -ENODEV;
+}
+
+#endif /* CONFIG_SSB_BUS_AI */
+
+#endif /* !LINUX_SSB_AI_H_ */
--- linux-wireless-testing.orig/drivers/ssb/ssb_private.h	2011-02-17 15:56:58.000000000 +0200
+++ linux-wireless-testing/drivers/ssb/ssb_private.h	2011-02-17 15:57:14.000000000 +0200
@@ -4,6 +4,7 @@
 #include <linux/ssb/ssb.h>
 #include <linux/types.h>
 #include "ssb_sb.h"
+#include "ssb_ai.h"
 
 
 #define PFX	"ssb: "
@@ -168,7 +169,10 @@ extern int ssb_bus_check_core(struct ssb
 extern u32 scan_read32(struct ssb_bus *bus, u8 current_coreidx, u16 offset);
 static inline void ssb_iounmap(struct ssb_bus *bus)
 {
-	ssb_iounmap_sb(bus);
+	if (bus->chipco.chiptype == SSB_CHIPCO_AI)
+		ssb_iounmap_ai(bus);
+	else
+		ssb_iounmap_sb(bus);
 }
 
 
--- linux-wireless-testing.orig/include/linux/ssb/ssb_driver_chipcommon.h	2011-02-17 15:51:11.000000000 +0200
+++ linux-wireless-testing/include/linux/ssb/ssb_driver_chipcommon.h	2011-02-17 15:57:14.000000000 +0200
@@ -19,6 +19,7 @@
 #define  SSB_CHIPCO_TYPE_MASK		0xF0000000
 #define  SSB_CHIPCO_TYPE_SHIFT		28
 #define   SSB_CHIPCO_TYPE_SB		0
+#define   SSB_CHIPCO_TYPE_AI		0x10000000
 #define  SSB_CHIPCO_IDMASK		0x0000FFFF
 #define  SSB_CHIPCO_REVMASK		0x000F0000
 #define  SSB_CHIPCO_REVSHIFT		16
@@ -173,6 +174,7 @@
 #define  SSB_CHIPCO_SYSCLKCTL_CLKDIV	0xFFFF0000	/* ClkDiv  (ILP = 1/(4+divisor)) */
 #define  SSB_CHIPCO_SYSCLKCTL_CLKDIV_SHIFT	16
 #define SSB_CHIPCO_CLKSTSTR		0x00C4		/* Rev >= 3 only */
+#define SSB_CHIPCO_EROM			0x00FC		/* EROM for AI socs */
 #define SSB_CHIPCO_PCMCIA_CFG		0x0100
 #define SSB_CHIPCO_PCMCIA_MEMWAIT	0x0104
 #define SSB_CHIPCO_PCMCIA_ATTRWAIT	0x0108
@@ -584,6 +586,7 @@ struct ssb_chipcommon_pmu {
 /* Chipcommon implementation type */
 enum ssb_chipco_chiptype {
 	SSB_CHIPCO_SB = SSB_CHIPCO_TYPE(SSB_CHIPCO_TYPE_SB), /* SB-style bus */
+	SSB_CHIPCO_AI = SSB_CHIPCO_TYPE(SSB_CHIPCO_TYPE_AI), /* AI-style bus */
 };
 
 struct ssb_chipcommon {
--- linux-wireless-testing.orig/include/linux/ssb/ssb.h	2011-02-17 15:57:09.000000000 +0200
+++ linux-wireless-testing/include/linux/ssb/ssb.h	2011-02-17 15:57:14.000000000 +0200
@@ -104,6 +104,46 @@ struct ssb_boardinfo {
 
 
 struct ssb_device;
+#ifdef CONFIG_SSB_BUS_AI
+/* max no of AI addrspaces */
+#define SSB_AI_MAX_ADDRSPACES	2
+
+struct ssb_bus_aiops {
+	u32 (*read32)(struct ssb_device *dev, u16 offset);
+	void (*write32)(struct ssb_device *dev, u16 offset, u32 value);
+};
+
+struct ssb_aiaddrspace {
+	u32 base;
+	u32 size;
+};
+
+/* AI-style bus device-specific data */
+struct ssb_aidevice {
+	/** Internal stuff, don't use directly **/
+	struct ssb_bus_aiops *ops;
+	/* device cores */
+	struct ssb_aiaddrspace core[SSB_AI_MAX_ADDRSPACES];
+};
+
+/* AI-style bus-specific data */
+struct ssb_aibus {
+	/** Internal stuff, don't use directly **/
+	struct ssb_bus_aiops *ops;
+	/* core wrapper IO area */
+	void __iomem *mmio;
+	/* core, which wrapper is currently mapped into the MMIO window */
+	struct ssb_device *mapped_device;
+};
+#else /* CONFIG_SSB_BUS_AI */
+struct ssb_aidevice {
+};
+
+struct ssb_aibus {
+};
+#endif /* CONFIG_SSB_BUS_AI */
+
+
 /* Lowlevel read/write operations on the device MMIO.
  * Internal, don't use that outside of ssb. */
 struct ssb_bus_ops {
@@ -170,9 +210,11 @@ struct ssb_bus_helpers {
 #define SSB_DEV_MIPS_74K	0x82C
 #define SSB_DEV_DDR_CTRLR	0x82E
 #define SSB_DEV_I2S		0x834
+#define SSB_DEV_DEFAULT		0xFFF
 
 /* Vendor-ID values */
 #define SSB_VENDOR_BROADCOM	0x4243
+#define SSB_VENDOR_ARM		0x043B
 
 /* Some kernel subsystems poke with dev->drvdata, so we must use the
  * following ugly workaround to get from struct device to struct ssb_device */
@@ -198,6 +240,7 @@ struct ssb_device {
 	/* Internal-only stuff follows. */
 	void *drvdata;		/* Per-device data */
 	void *devtypedata;	/* Per-devicetype (eg 802.11) data */
+	struct ssb_aidevice ai; /* AI-specific device data */
 };
 
 /* Go from struct device to struct ssb_device. */
@@ -364,6 +407,7 @@ struct ssb_bus {
 
 	/* Internal-only stuff follows. Do not touch. */
 	struct list_head list;
+	struct ssb_aibus ai; /* AI-specific bus data */
 #ifdef CONFIG_SSB_DEBUG
 	/* Is the bus already powered up? */
 	bool powered_up;
--- linux-wireless-testing.orig/include/linux/ssb/ssb_regs.h	2011-02-17 15:40:20.000000000 +0200
+++ linux-wireless-testing/include/linux/ssb/ssb_regs.h	2011-02-17 15:57:14.000000000 +0200
@@ -54,6 +54,7 @@
 #define  SSB_GPIO_HWRAD		0x20	/* PCI config space GPIO 13 for hw radio disable */
 #define  SSB_GPIO_XTAL		0x40	/* PCI config space GPIO 14 for Xtal powerup */
 #define  SSB_GPIO_PLL		0x80	/* PCI config space GPIO 15 for PLL powerdown */
+#define SSB_BAR0_WIN2		0xAC	/* backplane addres space accessed by second 4KB of BAR0 */
 
 
 #define SSB_BAR0_MAX_RETRIES	50



