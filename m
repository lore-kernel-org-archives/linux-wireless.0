Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:43942 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074AbZIHRbF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2009 13:31:05 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ssb: Implement SDIO host bus support
Date: Tue, 8 Sep 2009 19:30:12 +0200
Cc: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	Albert Herranz <albert_herranz@yahoo.es>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200909081930.12806.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Albert Herranz <albert_herranz@yahoo.es>

Add support for communicating with a Sonics Silicon Backplane through a
SDIO interface, as found in the Nintendo Wii WLAN daughter card.

The Nintendo Wii WLAN card includes a custom Broadcom 4318 chip with
a SDIO host interface.

Signed-off-by: Albert Herranz <albert_herranz@yahoo.es>
Signed-off-by: Michael Buesch <mb@bu3sch.de>

---
 drivers/ssb/Kconfig       |   14 +
 drivers/ssb/Makefile      |    1 +
 drivers/ssb/main.c        |   58 +++++-
 drivers/ssb/scan.c        |   11 +
 drivers/ssb/sdio.c        |  611 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/ssb/ssb_private.h |   40 +++
 include/linux/ssb/ssb.h   |   32 +++
 7 files changed, 766 insertions(+), 1 deletions(-)
 create mode 100644 drivers/ssb/sdio.c

Index: wireless-testing/drivers/ssb/Kconfig
===================================================================
--- wireless-testing.orig/drivers/ssb/Kconfig	2009-09-08 19:13:49.000000000 +0200
+++ wireless-testing/drivers/ssb/Kconfig	2009-09-08 19:14:13.000000000 +0200
@@ -66,6 +66,20 @@ config SSB_PCMCIAHOST
 
 	  If unsure, say N
 
+config SSB_SDIOHOST_POSSIBLE
+	bool
+	depends on SSB && (MMC = y || MMC = SSB)
+	default y
+
+config SSB_SDIOHOST
+	bool "Support for SSB on SDIO-bus host"
+	depends on SSB_SDIOHOST_POSSIBLE
+	help
+	  Support for a Sonics Silicon Backplane on top
+	  of a SDIO device.
+
+	  If unsure, say N
+
 config SSB_SILENT
 	bool "No SSB kernel messages"
 	depends on SSB && EMBEDDED
Index: wireless-testing/drivers/ssb/Makefile
===================================================================
--- wireless-testing.orig/drivers/ssb/Makefile	2009-09-08 19:13:49.000000000 +0200
+++ wireless-testing/drivers/ssb/Makefile	2009-09-08 19:14:13.000000000 +0200
@@ -6,6 +6,7 @@ ssb-$(CONFIG_SSB_SPROM)			+= sprom.o
 # host support
 ssb-$(CONFIG_SSB_PCIHOST)		+= pci.o pcihost_wrapper.o
 ssb-$(CONFIG_SSB_PCMCIAHOST)		+= pcmcia.o
+ssb-$(CONFIG_SSB_SDIOHOST)		+= sdio.o
 
 # built-in drivers
 ssb-y					+= driver_chipcommon.o
Index: wireless-testing/drivers/ssb/main.c
===================================================================
--- wireless-testing.orig/drivers/ssb/main.c	2009-09-08 19:13:49.000000000 +0200
+++ wireless-testing/drivers/ssb/main.c	2009-09-08 19:14:13.000000000 +0200
@@ -17,6 +17,7 @@
 #include <linux/ssb/ssb_driver_gige.h>
 #include <linux/dma-mapping.h>
 #include <linux/pci.h>
+#include <linux/mmc/sdio_func.h>
 
 #include <pcmcia/cs_types.h>
 #include <pcmcia/cs.h>
@@ -88,6 +89,25 @@ found:
 }
 #endif /* CONFIG_SSB_PCMCIAHOST */
 
+#ifdef CONFIG_SSB_SDIOHOST
+struct ssb_bus *ssb_sdio_func_to_bus(struct sdio_func *func)
+{
+	struct ssb_bus *bus;
+
+	ssb_buses_lock();
+	list_for_each_entry(bus, &buses, list) {
+		if (bus->bustype == SSB_BUSTYPE_SDIO &&
+		    bus->host_sdio == func)
+			goto found;
+	}
+	bus = NULL;
+found:
+	ssb_buses_unlock();
+
+	return bus;
+}
+#endif /* CONFIG_SSB_SDIOHOST */
+
 int ssb_for_each_bus_call(unsigned long data,
 			  int (*func)(struct ssb_bus *bus, unsigned long data))
 {
@@ -469,6 +489,12 @@ static int ssb_devices_register(struct s
 			dev->parent = &bus->host_pcmcia->dev;
 #endif
 			break;
+		case SSB_BUSTYPE_SDIO:
+#ifdef CONFIG_SSB_SDIO
+			sdev->irq = bus->host_sdio->dev.irq;
+			dev->parent = &bus->host_sdio->dev;
+#endif
+			break;
 		case SSB_BUSTYPE_SSB:
 			dev->dma_mask = &dev->coherent_dma_mask;
 			break;
@@ -724,12 +750,18 @@ static int ssb_bus_register(struct ssb_b
 	err = ssb_pci_xtal(bus, SSB_GPIO_XTAL | SSB_GPIO_PLL, 1);
 	if (err)
 		goto out;
+
+	/* Init SDIO-host device (if any), before the scan */
+	err = ssb_sdio_init(bus);
+	if (err)
+		goto err_disable_xtal;
+
 	ssb_buses_lock();
 	bus->busnumber = next_busnumber;
 	/* Scan for devices (cores) */
 	err = ssb_bus_scan(bus, baseaddr);
 	if (err)
-		goto err_disable_xtal;
+		goto err_sdio_exit;
 
 	/* Init PCI-host device (if any) */
 	err = ssb_pci_init(bus);
@@ -776,6 +808,8 @@ err_pci_exit:
 	ssb_pci_exit(bus);
 err_unmap:
 	ssb_iounmap(bus);
+err_sdio_exit:
+	ssb_sdio_exit(bus);
 err_disable_xtal:
 	ssb_buses_unlock();
 	ssb_pci_xtal(bus, SSB_GPIO_XTAL | SSB_GPIO_PLL, 0);
@@ -825,6 +859,28 @@ int ssb_bus_pcmciabus_register(struct ss
 EXPORT_SYMBOL(ssb_bus_pcmciabus_register);
 #endif /* CONFIG_SSB_PCMCIAHOST */
 
+#ifdef CONFIG_SSB_SDIOHOST
+int ssb_bus_sdiobus_register(struct ssb_bus *bus, struct sdio_func *func,
+			     unsigned int quirks)
+{
+	int err;
+
+	bus->bustype = SSB_BUSTYPE_SDIO;
+	bus->host_sdio = func;
+	bus->ops = &ssb_sdio_ops;
+	bus->quirks = quirks;
+
+	err = ssb_bus_register(bus, ssb_sdio_get_invariants, ~0);
+	if (!err) {
+		ssb_printk(KERN_INFO PFX "Sonics Silicon Backplane found on "
+			   "SDIO device %s\n", sdio_func_id(func));
+	}
+
+	return err;
+}
+EXPORT_SYMBOL(ssb_bus_sdiobus_register);
+#endif /* CONFIG_SSB_PCMCIAHOST */
+
 int ssb_bus_ssbbus_register(struct ssb_bus *bus,
 			    unsigned long baseaddr,
 			    ssb_invariants_func_t get_invariants)
Index: wireless-testing/drivers/ssb/scan.c
===================================================================
--- wireless-testing.orig/drivers/ssb/scan.c	2009-09-08 19:13:49.000000000 +0200
+++ wireless-testing/drivers/ssb/scan.c	2009-09-08 19:14:13.000000000 +0200
@@ -175,6 +175,9 @@ static u32 scan_read32(struct ssb_bus *b
 		} else
 			ssb_pcmcia_switch_segment(bus, 0);
 		break;
+	case SSB_BUSTYPE_SDIO:
+		offset += current_coreidx * SSB_CORE_SIZE;
+		return ssb_sdio_scan_read32(bus, offset);
 	}
 	return readl(bus->mmio + offset);
 }
@@ -188,6 +191,8 @@ static int scan_switchcore(struct ssb_bu
 		return ssb_pci_switch_coreidx(bus, coreidx);
 	case SSB_BUSTYPE_PCMCIA:
 		return ssb_pcmcia_switch_coreidx(bus, coreidx);
+	case SSB_BUSTYPE_SDIO:
+		return ssb_sdio_scan_switch_coreidx(bus, coreidx);
 	}
 	return 0;
 }
@@ -206,6 +211,8 @@ void ssb_iounmap(struct ssb_bus *bus)
 		SSB_BUG_ON(1); /* Can't reach this code. */
 #endif
 		break;
+	case SSB_BUSTYPE_SDIO:
+		break;
 	}
 	bus->mmio = NULL;
 	bus->mapped_device = NULL;
@@ -230,6 +237,10 @@ static void __iomem *ssb_ioremap(struct 
 		SSB_BUG_ON(1); /* Can't reach this code. */
 #endif
 		break;
+	case SSB_BUSTYPE_SDIO:
+		/* Nothing to ioremap in the SDIO case, just fake it */
+		mmio = (void __iomem *)baseaddr;
+		break;
 	}
 
 	return mmio;
Index: wireless-testing/drivers/ssb/sdio.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-testing/drivers/ssb/sdio.c	2009-09-08 19:14:13.000000000 +0200
@@ -0,0 +1,610 @@
+/*
+ * Sonics Silicon Backplane
+ * SDIO-Hostbus related functions
+ *
+ * Copyright 2009 Albert Herranz <albert_herranz@yahoo.es>
+ *
+ * Based on drivers/ssb/pcmcia.c
+ * Copyright 2006 Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2007-2008 Michael Buesch <mb@bu3sch.de>
+ *
+ * Licensed under the GNU/GPL. See COPYING for details.
+ *
+ */
+
+#include <linux/ssb/ssb.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/etherdevice.h>
+#include <linux/mmc/sdio_func.h>
+
+#include "ssb_private.h"
+
+/* Define the following to 1 to enable a printk on each coreswitch. */
+#define SSB_VERBOSE_SDIOCORESWITCH_DEBUG		1
+
+
+/* Hardware invariants CIS tuples */
+#define SSB_SDIO_CIS			0x80
+#define  SSB_SDIO_CIS_SROMREV		0x00
+#define  SSB_SDIO_CIS_ID		0x01
+#define  SSB_SDIO_CIS_BOARDREV		0x02
+#define  SSB_SDIO_CIS_PA		0x03
+#define   SSB_SDIO_CIS_PA_PA0B0_LO	0
+#define   SSB_SDIO_CIS_PA_PA0B0_HI	1
+#define   SSB_SDIO_CIS_PA_PA0B1_LO	2
+#define   SSB_SDIO_CIS_PA_PA0B1_HI	3
+#define   SSB_SDIO_CIS_PA_PA0B2_LO	4
+#define   SSB_SDIO_CIS_PA_PA0B2_HI	5
+#define   SSB_SDIO_CIS_PA_ITSSI		6
+#define   SSB_SDIO_CIS_PA_MAXPOW	7
+#define  SSB_SDIO_CIS_OEMNAME		0x04
+#define  SSB_SDIO_CIS_CCODE		0x05
+#define  SSB_SDIO_CIS_ANTENNA		0x06
+#define  SSB_SDIO_CIS_ANTGAIN		0x07
+#define  SSB_SDIO_CIS_BFLAGS		0x08
+#define  SSB_SDIO_CIS_LEDS		0x09
+
+#define CISTPL_FUNCE_LAN_NODE_ID        0x04	/* same as in PCMCIA */
+
+
+/*
+ * Function 1 miscellaneous registers.
+ *
+ * Definitions match src/include/sbsdio.h from the
+ * Android Open Source Project
+ * http://android.git.kernel.org/?p=platform/system/wlan/broadcom.git
+ *
+ */
+#define SBSDIO_FUNC1_SBADDRLOW	0x1000a	/* SB Address window Low (b15) */
+#define SBSDIO_FUNC1_SBADDRMID	0x1000b	/* SB Address window Mid (b23-b16) */
+#define SBSDIO_FUNC1_SBADDRHIGH	0x1000c	/* SB Address window High (b24-b31) */
+
+/* valid bits in SBSDIO_FUNC1_SBADDRxxx regs */
+#define SBSDIO_SBADDRLOW_MASK	0x80	/* Valid address bits in SBADDRLOW */
+#define SBSDIO_SBADDRMID_MASK	0xff	/* Valid address bits in SBADDRMID */
+#define SBSDIO_SBADDRHIGH_MASK	0xff	/* Valid address bits in SBADDRHIGH */
+
+#define SBSDIO_SB_OFT_ADDR_MASK	0x7FFF	/* sb offset addr is <= 15 bits, 32k */
+
+/* REVISIT: this flag doesn't seem to matter */
+#define SBSDIO_SB_ACCESS_2_4B_FLAG	0x8000	/* forces 32-bit SB access */
+
+
+/*
+ * Address map within the SDIO function address space (128K).
+ *
+ *   Start   End     Description
+ *   ------- ------- ------------------------------------------
+ *   0x00000 0x0ffff selected backplane address window (64K)
+ *   0x10000 0x1ffff backplane control registers (max 64K)
+ *
+ * The current address window is configured by writing to registers
+ * SBADDRLOW, SBADDRMID and SBADDRHIGH.
+ *
+ * In order to access the contents of a 32-bit Silicon Backplane address
+ * the backplane address window must be first loaded with the highest
+ * 16 bits of the target address. Then, an access must be done to the
+ * SDIO function address space using the lower 15 bits of the address.
+ * Bit 15 of the address must be set when doing 32 bit accesses.
+ *
+ * 10987654321098765432109876543210
+ * WWWWWWWWWWWWWWWWW                 SB Address Window
+ *                 OOOOOOOOOOOOOOOO  Offset within SB Address Window
+ *                 a                 32-bit access flag
+ */
+
+
+/*
+ * SSB I/O via SDIO.
+ *
+ * NOTE: SDIO address @addr is 17 bits long (SDIO address space is 128K).
+ */
+
+static inline struct device *ssb_sdio_dev(struct ssb_bus *bus)
+{
+	return &bus->host_sdio->dev;
+}
+
+/* host claimed */
+static int ssb_sdio_writeb(struct ssb_bus *bus, unsigned int addr, u8 val)
+{
+	int error = 0;
+
+	sdio_writeb(bus->host_sdio, val, addr, &error);
+	if (unlikely(error)) {
+		dev_dbg(ssb_sdio_dev(bus), "%08X <- %02x, error %d\n",
+			addr, val, error);
+	}
+
+	return error;
+}
+
+#if 0
+static u8 ssb_sdio_readb(struct ssb_bus *bus, unsigned int addr)
+{
+	u8 val;
+	int error = 0;
+
+	val = sdio_readb(bus->host_sdio, addr, &error);
+	if (unlikely(error)) {
+		dev_dbg(ssb_sdio_dev(bus), "%08X -> %02x, error %d\n",
+			addr, val, error);
+	}
+
+	return val;
+}
+#endif
+
+/* host claimed */
+static int ssb_sdio_set_sbaddr_window(struct ssb_bus *bus, u32 address)
+{
+	int error;
+
+	error = ssb_sdio_writeb(bus, SBSDIO_FUNC1_SBADDRLOW,
+				(address >> 8) & SBSDIO_SBADDRLOW_MASK);
+	if (error)
+		goto out;
+	error = ssb_sdio_writeb(bus, SBSDIO_FUNC1_SBADDRMID,
+				(address >> 16) & SBSDIO_SBADDRMID_MASK);
+	if (error)
+		goto out;
+	error = ssb_sdio_writeb(bus, SBSDIO_FUNC1_SBADDRHIGH,
+				(address >> 24) & SBSDIO_SBADDRHIGH_MASK);
+	if (error)
+		goto out;
+	bus->sdio_sbaddr = address;
+out:
+	if (error) {
+		dev_dbg(ssb_sdio_dev(bus), "failed to set address window"
+			" to 0x%08x, error %d\n", address, error);
+	}
+
+	return error;
+}
+
+/* for enumeration use only */
+u32 ssb_sdio_scan_read32(struct ssb_bus *bus, u16 offset)
+{
+	u32 val;
+	int error;
+
+	sdio_claim_host(bus->host_sdio);
+	val = sdio_readl(bus->host_sdio, offset, &error);
+	sdio_release_host(bus->host_sdio);
+	if (unlikely(error)) {
+		dev_dbg(ssb_sdio_dev(bus), "%04X:%04X > %08x, error %d\n",
+			bus->sdio_sbaddr >> 16, offset, val, error);
+	}
+
+	return val;
+}
+
+/* for enumeration use only */
+int ssb_sdio_scan_switch_coreidx(struct ssb_bus *bus, u8 coreidx)
+{
+	u32 sbaddr;
+	int error;
+
+	sbaddr = (coreidx * SSB_CORE_SIZE) + SSB_ENUM_BASE;
+	sdio_claim_host(bus->host_sdio);
+	error = ssb_sdio_set_sbaddr_window(bus, sbaddr);
+	sdio_release_host(bus->host_sdio);
+	if (error) {
+		dev_err(ssb_sdio_dev(bus), "failed to switch to core %u,"
+			" error %d\n", coreidx, error);
+		goto out;
+	}
+out:
+	return error;
+}
+
+/* host must be already claimed */
+int ssb_sdio_switch_core(struct ssb_bus *bus, struct ssb_device *dev)
+{
+	u8 coreidx = dev->core_index;
+	u32 sbaddr;
+	int error = 0;
+
+	sbaddr = (coreidx * SSB_CORE_SIZE) + SSB_ENUM_BASE;
+	if (unlikely(bus->sdio_sbaddr != sbaddr)) {
+#if SSB_VERBOSE_SDIOCORESWITCH_DEBUG
+		dev_info(ssb_sdio_dev(bus),
+			   "switching to %s core, index %d\n",
+			   ssb_core_name(dev->id.coreid), coreidx);
+#endif
+		error = ssb_sdio_set_sbaddr_window(bus, sbaddr);
+		if (error) {
+			dev_dbg(ssb_sdio_dev(bus), "failed to switch to"
+				" core %u, error %d\n", coreidx, error);
+			goto out;
+		}
+		bus->mapped_device = dev;
+	}
+
+out:
+	return error;
+}
+
+static u8 ssb_sdio_read8(struct ssb_device *dev, u16 offset)
+{
+	struct ssb_bus *bus = dev->bus;
+	u8 val = 0xff;
+	int error = 0;
+
+	sdio_claim_host(bus->host_sdio);
+	if (unlikely(ssb_sdio_switch_core(bus, dev)))
+		goto out;
+	offset |= bus->sdio_sbaddr & 0xffff;
+	offset &= SBSDIO_SB_OFT_ADDR_MASK;
+	val = sdio_readb(bus->host_sdio, offset, &error);
+	if (error) {
+		dev_dbg(ssb_sdio_dev(bus), "%04X:%04X > %02x, error %d\n",
+			bus->sdio_sbaddr >> 16, offset, val, error);
+	}
+out:
+	sdio_release_host(bus->host_sdio);
+
+	return val;
+}
+
+static u16 ssb_sdio_read16(struct ssb_device *dev, u16 offset)
+{
+	struct ssb_bus *bus = dev->bus;
+	u16 val = 0xffff;
+	int error = 0;
+
+	sdio_claim_host(bus->host_sdio);
+	if (unlikely(ssb_sdio_switch_core(bus, dev)))
+		goto out;
+	offset |= bus->sdio_sbaddr & 0xffff;
+	offset &= SBSDIO_SB_OFT_ADDR_MASK;
+	val = sdio_readw(bus->host_sdio, offset, &error);
+	if (error) {
+		dev_dbg(ssb_sdio_dev(bus), "%04X:%04X > %04x, error %d\n",
+			bus->sdio_sbaddr >> 16, offset, val, error);
+	}
+out:
+	sdio_release_host(bus->host_sdio);
+
+	return val;
+}
+
+static u32 ssb_sdio_read32(struct ssb_device *dev, u16 offset)
+{
+	struct ssb_bus *bus = dev->bus;
+	u32 val = 0xffffffff;
+	int error = 0;
+
+	sdio_claim_host(bus->host_sdio);
+	if (unlikely(ssb_sdio_switch_core(bus, dev)))
+		goto out;
+	offset |= bus->sdio_sbaddr & 0xffff;
+	offset &= SBSDIO_SB_OFT_ADDR_MASK;
+	offset |= SBSDIO_SB_ACCESS_2_4B_FLAG;	/* 32 bit data access */
+	val = sdio_readl(bus->host_sdio, offset, &error);
+	if (error) {
+		dev_dbg(ssb_sdio_dev(bus), "%04X:%04X > %08x, error %d\n",
+			bus->sdio_sbaddr >> 16, offset, val, error);
+	}
+out:
+	sdio_release_host(bus->host_sdio);
+
+	return val;
+}
+
+#ifdef CONFIG_SSB_BLOCKIO
+static void ssb_sdio_block_read(struct ssb_device *dev, void *buffer,
+				  size_t count, u16 offset, u8 reg_width)
+{
+	size_t saved_count = count;
+	struct ssb_bus *bus = dev->bus;
+	int error = 0;
+
+	sdio_claim_host(bus->host_sdio);
+	if (unlikely(ssb_sdio_switch_core(bus, dev))) {
+		error = -EIO;
+		memset(buffer, 0xff, count);
+		goto err_out;
+	}
+	offset |= bus->sdio_sbaddr & 0xffff;
+	offset &= SBSDIO_SB_OFT_ADDR_MASK;
+
+	switch (reg_width) {
+	case sizeof(u8): {
+		error = sdio_readsb(bus->host_sdio, buffer, offset, count);
+		break;
+	}
+	case sizeof(u16): {
+		SSB_WARN_ON(count & 1);
+		error = sdio_readsb(bus->host_sdio, buffer, offset, count);
+		break;
+	}
+	case sizeof(u32): {
+		SSB_WARN_ON(count & 3);
+		offset |= SBSDIO_SB_ACCESS_2_4B_FLAG;	/* 32 bit data access */
+		error = sdio_readsb(bus->host_sdio, buffer, offset, count);
+		break;
+	}
+	default:
+		SSB_WARN_ON(1);
+	}
+	if (!error)
+		goto out;
+
+err_out:
+	dev_dbg(ssb_sdio_dev(bus), "%04X:%04X (width=%u, len=%u), error %d\n",
+		bus->sdio_sbaddr >> 16, offset, reg_width, saved_count, error);
+out:
+	sdio_release_host(bus->host_sdio);
+}
+#endif /* CONFIG_SSB_BLOCKIO */
+
+static void ssb_sdio_write8(struct ssb_device *dev, u16 offset, u8 val)
+{
+	struct ssb_bus *bus = dev->bus;
+	int error = 0;
+
+	sdio_claim_host(bus->host_sdio);
+	if (unlikely(ssb_sdio_switch_core(bus, dev)))
+		goto out;
+	offset |= bus->sdio_sbaddr & 0xffff;
+	offset &= SBSDIO_SB_OFT_ADDR_MASK;
+	sdio_writeb(bus->host_sdio, val, offset, &error);
+	if (error) {
+		dev_dbg(ssb_sdio_dev(bus), "%04X:%04X < %02x, error %d\n",
+			bus->sdio_sbaddr >> 16, offset, val, error);
+	}
+out:
+	sdio_release_host(bus->host_sdio);
+}
+
+static void ssb_sdio_write16(struct ssb_device *dev, u16 offset, u16 val)
+{
+	struct ssb_bus *bus = dev->bus;
+	int error = 0;
+
+	sdio_claim_host(bus->host_sdio);
+	if (unlikely(ssb_sdio_switch_core(bus, dev)))
+		goto out;
+	offset |= bus->sdio_sbaddr & 0xffff;
+	offset &= SBSDIO_SB_OFT_ADDR_MASK;
+	sdio_writew(bus->host_sdio, val, offset, &error);
+	if (error) {
+		dev_dbg(ssb_sdio_dev(bus), "%04X:%04X < %04x, error %d\n",
+			bus->sdio_sbaddr >> 16, offset, val, error);
+	}
+out:
+	sdio_release_host(bus->host_sdio);
+}
+
+static void ssb_sdio_write32(struct ssb_device *dev, u16 offset, u32 val)
+{
+	struct ssb_bus *bus = dev->bus;
+	int error = 0;
+
+	sdio_claim_host(bus->host_sdio);
+	if (unlikely(ssb_sdio_switch_core(bus, dev)))
+		goto out;
+	offset |= bus->sdio_sbaddr & 0xffff;
+	offset &= SBSDIO_SB_OFT_ADDR_MASK;
+	offset |= SBSDIO_SB_ACCESS_2_4B_FLAG;	/* 32 bit data access */
+	sdio_writel(bus->host_sdio, val, offset, &error);
+	if (error) {
+		dev_dbg(ssb_sdio_dev(bus), "%04X:%04X < %08x, error %d\n",
+			bus->sdio_sbaddr >> 16, offset, val, error);
+	}
+	if (bus->quirks & SSB_QUIRK_SDIO_READ_AFTER_WRITE32)
+		sdio_readl(bus->host_sdio, 0, &error);
+out:
+	sdio_release_host(bus->host_sdio);
+}
+
+#ifdef CONFIG_SSB_BLOCKIO
+static void ssb_sdio_block_write(struct ssb_device *dev, const void *buffer,
+				   size_t count, u16 offset, u8 reg_width)
+{
+	size_t saved_count = count;
+	struct ssb_bus *bus = dev->bus;
+	int error = 0;
+
+	sdio_claim_host(bus->host_sdio);
+	if (unlikely(ssb_sdio_switch_core(bus, dev))) {
+		error = -EIO;
+		memset((void *)buffer, 0xff, count);
+		goto err_out;
+	}
+	offset |= bus->sdio_sbaddr & 0xffff;
+	offset &= SBSDIO_SB_OFT_ADDR_MASK;
+
+	switch (reg_width) {
+	case sizeof(u8):
+		error = sdio_writesb(bus->host_sdio, offset,
+				     (void *)buffer, count);
+		break;
+	case sizeof(u16):
+		SSB_WARN_ON(count & 1);
+		error = sdio_writesb(bus->host_sdio, offset,
+				     (void *)buffer, count);
+		break;
+	case sizeof(u32):
+		SSB_WARN_ON(count & 3);
+		offset |= SBSDIO_SB_ACCESS_2_4B_FLAG;	/* 32 bit data access */
+		error = sdio_writesb(bus->host_sdio, offset,
+				     (void *)buffer, count);
+		break;
+	default:
+		SSB_WARN_ON(1);
+	}
+	if (!error)
+		goto out;
+
+err_out:
+	dev_dbg(ssb_sdio_dev(bus), "%04X:%04X (width=%u, len=%u), error %d\n",
+		bus->sdio_sbaddr >> 16, offset, reg_width, saved_count, error);
+out:
+	sdio_release_host(bus->host_sdio);
+}
+
+#endif /* CONFIG_SSB_BLOCKIO */
+
+/* Not "static", as it's used in main.c */
+const struct ssb_bus_ops ssb_sdio_ops = {
+	.read8		= ssb_sdio_read8,
+	.read16		= ssb_sdio_read16,
+	.read32		= ssb_sdio_read32,
+	.write8		= ssb_sdio_write8,
+	.write16	= ssb_sdio_write16,
+	.write32	= ssb_sdio_write32,
+#ifdef CONFIG_SSB_BLOCKIO
+	.block_read	= ssb_sdio_block_read,
+	.block_write	= ssb_sdio_block_write,
+#endif
+};
+
+#define GOTO_ERROR_ON(condition, description) do {	\
+	if (unlikely(condition)) {			\
+		error_description = description;	\
+		goto error;				\
+	}						\
+  } while (0)
+
+int ssb_sdio_get_invariants(struct ssb_bus *bus,
+			    struct ssb_init_invariants *iv)
+{
+	struct ssb_sprom *sprom = &iv->sprom;
+	struct ssb_boardinfo *bi = &iv->boardinfo;
+	const char *error_description = "none";
+	struct sdio_func_tuple *tuple;
+	void *mac;
+
+	memset(sprom, 0xFF, sizeof(*sprom));
+	sprom->boardflags_lo = 0;
+	sprom->boardflags_hi = 0;
+
+	tuple = bus->host_sdio->tuples;
+	while (tuple) {
+		switch (tuple->code) {
+		case 0x22: /* extended function */
+			switch (tuple->data[0]) {
+			case CISTPL_FUNCE_LAN_NODE_ID:
+				GOTO_ERROR_ON((tuple->size != 7) &&
+					      (tuple->data[1] != 6),
+					      "mac tpl size");
+				/* fetch the MAC address. */
+				mac = tuple->data + 2;
+				memcpy(sprom->il0mac, mac, ETH_ALEN);
+				memcpy(sprom->et1mac, mac, ETH_ALEN);
+				break;
+			default:
+				break;
+			}
+			break;
+		case 0x80: /* vendor specific tuple */
+			switch (tuple->data[0]) {
+			case SSB_SDIO_CIS_SROMREV:
+				GOTO_ERROR_ON(tuple->size != 2,
+					      "sromrev tpl size");
+				sprom->revision = tuple->data[1];
+				break;
+			case SSB_SDIO_CIS_ID:
+				GOTO_ERROR_ON((tuple->size != 5) &&
+					      (tuple->size != 7),
+					      "id tpl size");
+				bi->vendor = tuple->data[1] |
+					     (tuple->data[2]<<8);
+				break;
+			case SSB_SDIO_CIS_BOARDREV:
+				GOTO_ERROR_ON(tuple->size != 2,
+					      "boardrev tpl size");
+				sprom->board_rev = tuple->data[1];
+				break;
+			case SSB_SDIO_CIS_PA:
+				GOTO_ERROR_ON((tuple->size != 9) &&
+					      (tuple->size != 10),
+					      "pa tpl size");
+				sprom->pa0b0 = tuple->data[1] |
+					 ((u16)tuple->data[2] << 8);
+				sprom->pa0b1 = tuple->data[3] |
+					 ((u16)tuple->data[4] << 8);
+				sprom->pa0b2 = tuple->data[5] |
+					 ((u16)tuple->data[6] << 8);
+				sprom->itssi_a = tuple->data[7];
+				sprom->itssi_bg = tuple->data[7];
+				sprom->maxpwr_a = tuple->data[8];
+				sprom->maxpwr_bg = tuple->data[8];
+				break;
+			case SSB_SDIO_CIS_OEMNAME:
+				/* Not present */
+				break;
+			case SSB_SDIO_CIS_CCODE:
+				GOTO_ERROR_ON(tuple->size != 2,
+					      "ccode tpl size");
+				sprom->country_code = tuple->data[1];
+				break;
+			case SSB_SDIO_CIS_ANTENNA:
+				GOTO_ERROR_ON(tuple->size != 2,
+					      "ant tpl size");
+				sprom->ant_available_a = tuple->data[1];
+				sprom->ant_available_bg = tuple->data[1];
+				break;
+			case SSB_SDIO_CIS_ANTGAIN:
+				GOTO_ERROR_ON(tuple->size != 2,
+					      "antg tpl size");
+				sprom->antenna_gain.ghz24.a0 = tuple->data[1];
+				sprom->antenna_gain.ghz24.a1 = tuple->data[1];
+				sprom->antenna_gain.ghz24.a2 = tuple->data[1];
+				sprom->antenna_gain.ghz24.a3 = tuple->data[1];
+				sprom->antenna_gain.ghz5.a0 = tuple->data[1];
+				sprom->antenna_gain.ghz5.a1 = tuple->data[1];
+				sprom->antenna_gain.ghz5.a2 = tuple->data[1];
+				sprom->antenna_gain.ghz5.a3 = tuple->data[1];
+				break;
+			case SSB_SDIO_CIS_BFLAGS:
+				GOTO_ERROR_ON((tuple->size != 3) &&
+					      (tuple->size != 5),
+					      "bfl tpl size");
+				sprom->boardflags_lo = tuple->data[1] |
+						 ((u16)tuple->data[2] << 8);
+				break;
+			case SSB_SDIO_CIS_LEDS:
+				GOTO_ERROR_ON(tuple->size != 5,
+					      "leds tpl size");
+				sprom->gpio0 = tuple->data[1];
+				sprom->gpio1 = tuple->data[2];
+				sprom->gpio2 = tuple->data[3];
+				sprom->gpio3 = tuple->data[4];
+				break;
+			default:
+				break;
+			}
+			break;
+		default:
+			break;
+		}
+		tuple = tuple->next;
+	}
+
+	return 0;
+error:
+	dev_err(ssb_sdio_dev(bus), "failed to fetch device invariants: %s\n",
+		error_description);
+	return -ENODEV;
+}
+
+void ssb_sdio_exit(struct ssb_bus *bus)
+{
+	if (bus->bustype != SSB_BUSTYPE_SDIO)
+		return;
+	/* Nothing to do here. */
+}
+
+int ssb_sdio_init(struct ssb_bus *bus)
+{
+	if (bus->bustype != SSB_BUSTYPE_SDIO)
+		return 0;
+
+	bus->sdio_sbaddr = ~0;
+
+	return 0;
+}
Index: wireless-testing/drivers/ssb/ssb_private.h
===================================================================
--- wireless-testing.orig/drivers/ssb/ssb_private.h	2009-09-08 19:13:49.000000000 +0200
+++ wireless-testing/drivers/ssb/ssb_private.h	2009-09-08 19:14:13.000000000 +0200
@@ -114,6 +114,46 @@ static inline int ssb_pcmcia_init(struct
 }
 #endif /* CONFIG_SSB_PCMCIAHOST */
 
+/* sdio.c */
+#ifdef CONFIG_SSB_SDIOHOST
+extern int ssb_sdio_get_invariants(struct ssb_bus *bus,
+				     struct ssb_init_invariants *iv);
+
+extern u32 ssb_sdio_scan_read32(struct ssb_bus *bus, u16 offset);
+extern int ssb_sdio_switch_core(struct ssb_bus *bus, struct ssb_device *dev);
+extern int ssb_sdio_scan_switch_coreidx(struct ssb_bus *bus, u8 coreidx);
+extern int ssb_sdio_hardware_setup(struct ssb_bus *bus);
+extern void ssb_sdio_exit(struct ssb_bus *bus);
+extern int ssb_sdio_init(struct ssb_bus *bus);
+
+extern const struct ssb_bus_ops ssb_sdio_ops;
+#else /* CONFIG_SSB_SDIOHOST */
+static inline u32 ssb_sdio_scan_read32(struct ssb_bus *bus, u16 offset)
+{
+	return 0;
+}
+static inline int ssb_sdio_switch_core(struct ssb_bus *bus,
+					 struct ssb_device *dev)
+{
+	return 0;
+}
+static inline int ssb_sdio_scan_switch_coreidx(struct ssb_bus *bus, u8 coreidx)
+{
+	return 0;
+}
+static inline int ssb_sdio_hardware_setup(struct ssb_bus *bus)
+{
+	return 0;
+}
+static inline void ssb_sdio_exit(struct ssb_bus *bus)
+{
+}
+static inline int ssb_sdio_init(struct ssb_bus *bus)
+{
+	return 0;
+}
+#endif /* CONFIG_SSB_SDIOHOST */
+
 
 /* scan.c */
 extern const char *ssb_core_name(u16 coreid);
Index: wireless-testing/include/linux/ssb/ssb.h
===================================================================
--- wireless-testing.orig/include/linux/ssb/ssb.h	2009-09-08 19:13:49.000000000 +0200
+++ wireless-testing/include/linux/ssb/ssb.h	2009-09-08 19:14:13.000000000 +0200
@@ -238,6 +238,7 @@ enum ssb_bustype {
 	SSB_BUSTYPE_SSB,	/* This SSB bus is the system bus */
 	SSB_BUSTYPE_PCI,	/* SSB is connected to PCI bus */
 	SSB_BUSTYPE_PCMCIA,	/* SSB is connected to PCMCIA bus */
+	SSB_BUSTYPE_SDIO,	/* SSB is connected to SDIO bus */
 };
 
 /* board_vendor */
@@ -270,8 +271,12 @@ struct ssb_bus {
 
 	/* The core in the basic address register window. (PCI bus only) */
 	struct ssb_device *mapped_device;
-	/* Currently mapped PCMCIA segment. (bustype == SSB_BUSTYPE_PCMCIA only) */
-	u8 mapped_pcmcia_seg;
+	union {
+		/* Currently mapped PCMCIA segment. (bustype == SSB_BUSTYPE_PCMCIA only) */
+		u8 mapped_pcmcia_seg;
+		/* Current SSB base address window for SDIO. */
+		u32 sdio_sbaddr;
+	};
 	/* Lock for core and segment switching.
 	 * On PCMCIA-host busses this is used to protect the whole MMIO access. */
 	spinlock_t bar_lock;
@@ -282,6 +287,11 @@ struct ssb_bus {
 	struct pci_dev *host_pci;
 	/* Pointer to the PCMCIA device (only if bustype == SSB_BUSTYPE_PCMCIA). */
 	struct pcmcia_device *host_pcmcia;
+	/* Pointer to the SDIO device (only if bustype == SSB_BUSTYPE_SDIO). */
+	struct sdio_func *host_sdio;
+
+	/* See enum ssb_quirks */
+	unsigned int quirks;
 
 #ifdef CONFIG_SSB_SPROM
 	/* Mutex to protect the SPROM writing. */
@@ -336,6 +346,11 @@ struct ssb_bus {
 #endif /* DEBUG */
 };
 
+enum ssb_quirks {
+	/* SDIO connected card requires performing a read after writing a 32-bit value */
+	SSB_QUIRK_SDIO_READ_AFTER_WRITE32	= (1 << 0),
+};
+
 /* The initialization-invariants. */
 struct ssb_init_invariants {
 	/* Versioning information about the PCB. */
@@ -366,6 +381,12 @@ extern int ssb_bus_pcmciabus_register(st
 				      struct pcmcia_device *pcmcia_dev,
 				      unsigned long baseaddr);
 #endif /* CONFIG_SSB_PCMCIAHOST */
+#ifdef CONFIG_SSB_SDIOHOST
+extern int ssb_bus_sdiobus_register(struct ssb_bus *bus,
+				    struct sdio_func *sdio_func,
+				    unsigned int quirks);
+#endif /* CONFIG_SSB_SDIOHOST */
+
 
 extern void ssb_bus_unregister(struct ssb_bus *bus);
 

-- 
Greetings, Michael.
