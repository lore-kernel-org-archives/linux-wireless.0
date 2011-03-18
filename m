Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52596 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab1CRLC5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 07:02:57 -0400
Received: by bwz15 with SMTP id 15so3230945bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 04:02:55 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?q?Michael=20B=C3=BCsch?= <mb@bu3sch.de>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [RFC][PATCH] ssb: separate common scanning functions
Date: Fri, 18 Mar 2011 13:02:53 +0100
Message-Id: <1300449773-11255-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
To keep ssb clean and avoid bigger code duplications, my idea is to:
1) Rename ssb directory to bcmb (like Broadcom's bus)
2) Have two *separated* drivers in it: ssb and ai
3) Share common function between ssb and ai
Example of such a common functions can be translating enum to *char and
(re)mapping MMIO.
---
 drivers/ssb/Makefile      |    2 +-
 drivers/ssb/bcmb_scan.c   |  182 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/ssb/bcmb_scan.h   |   13 +++
 drivers/ssb/scan.c        |  163 ----------------------------------------
 drivers/ssb/ssb_private.h |    3 +-
 5 files changed, 197 insertions(+), 166 deletions(-)
 create mode 100644 drivers/ssb/bcmb_scan.c
 create mode 100644 drivers/ssb/bcmb_scan.h

diff --git a/drivers/ssb/Makefile b/drivers/ssb/Makefile
index 656e58b..a91045e 100644
--- a/drivers/ssb/Makefile
+++ b/drivers/ssb/Makefile
@@ -1,5 +1,5 @@
 # core
-ssb-y					+= main.o scan.o
+ssb-y					+= main.o bcmb_scan.o scan.o
 ssb-$(CONFIG_SSB_EMBEDDED)		+= embedded.o
 ssb-$(CONFIG_SSB_SPROM)			+= sprom.o
 
diff --git a/drivers/ssb/bcmb_scan.c b/drivers/ssb/bcmb_scan.c
new file mode 100644
index 0000000..17b93f7
--- /dev/null
+++ b/drivers/ssb/bcmb_scan.c
@@ -0,0 +1,182 @@
+/*
+ * Sonics Silicon Backplane
+ * Bus scanning
+ *
+ * Copyright (C) 2005-2007 Michael Buesch <mb@bu3sch.de>
+ * Copyright (C) 2005 Martin Langer <martin-langer@gmx.de>
+ * Copyright (C) 2005 Stefano Brivio <st3@riseup.net>
+ * Copyright (C) 2005 Danny van Dyk <kugelfang@gentoo.org>
+ * Copyright (C) 2005 Andreas Jaggi <andreas.jaggi@waterwave.ch>
+ * Copyright (C) 2006 Broadcom Corporation.
+ *
+ * Licensed under the GNU/GPL. See COPYING for details.
+ */
+
+#include <linux/ssb/ssb.h>
+#include <linux/pci.h>
+#include <linux/io.h>
+
+#include "bcmb_scan.h"
+
+#include "ssb_private.h"
+
+const char *ssb_core_name(u16 coreid)
+{
+	switch (coreid) {
+	case SSB_DEV_CHIPCOMMON:
+		return "ChipCommon";
+	case SSB_DEV_ILINE20:
+		return "ILine 20";
+	case SSB_DEV_SDRAM:
+		return "SDRAM";
+	case SSB_DEV_PCI:
+		return "PCI";
+	case SSB_DEV_MIPS:
+		return "MIPS";
+	case SSB_DEV_ETHERNET:
+		return "Fast Ethernet";
+	case SSB_DEV_V90:
+		return "V90";
+	case SSB_DEV_USB11_HOSTDEV:
+		return "USB 1.1 Hostdev";
+	case SSB_DEV_ADSL:
+		return "ADSL";
+	case SSB_DEV_ILINE100:
+		return "ILine 100";
+	case SSB_DEV_IPSEC:
+		return "IPSEC";
+	case SSB_DEV_PCMCIA:
+		return "PCMCIA";
+	case SSB_DEV_INTERNAL_MEM:
+		return "Internal Memory";
+	case SSB_DEV_MEMC_SDRAM:
+		return "MEMC SDRAM";
+	case SSB_DEV_EXTIF:
+		return "EXTIF";
+	case SSB_DEV_80211:
+		return "IEEE 802.11";
+	case SSB_DEV_MIPS_3302:
+		return "MIPS 3302";
+	case SSB_DEV_USB11_HOST:
+		return "USB 1.1 Host";
+	case SSB_DEV_USB11_DEV:
+		return "USB 1.1 Device";
+	case SSB_DEV_USB20_HOST:
+		return "USB 2.0 Host";
+	case SSB_DEV_USB20_DEV:
+		return "USB 2.0 Device";
+	case SSB_DEV_SDIO_HOST:
+		return "SDIO Host";
+	case SSB_DEV_ROBOSWITCH:
+		return "Roboswitch";
+	case SSB_DEV_PARA_ATA:
+		return "PATA";
+	case SSB_DEV_SATA_XORDMA:
+		return "SATA XOR-DMA";
+	case SSB_DEV_ETHERNET_GBIT:
+		return "GBit Ethernet";
+	case SSB_DEV_PCIE:
+		return "PCI-E";
+	case SSB_DEV_MIMO_PHY:
+		return "MIMO PHY";
+	case SSB_DEV_SRAM_CTRLR:
+		return "SRAM Controller";
+	case SSB_DEV_MINI_MACPHY:
+		return "Mini MACPHY";
+	case SSB_DEV_ARM_1176:
+		return "ARM 1176";
+	case SSB_DEV_ARM_7TDMI:
+		return "ARM 7TDMI";
+	}
+	return "UNKNOWN";
+}
+
+u32 scan_read32(struct ssb_bus *bus, u8 current_coreidx,
+		       u16 offset)
+{
+	u32 lo, hi;
+
+	switch (bus->bustype) {
+	case SSB_BUSTYPE_SSB:
+		offset += current_coreidx * SSB_CORE_SIZE;
+		break;
+	case SSB_BUSTYPE_PCI:
+		break;
+	case SSB_BUSTYPE_PCMCIA:
+		if (offset >= 0x800) {
+			ssb_pcmcia_switch_segment(bus, 1);
+			offset -= 0x800;
+		} else
+			ssb_pcmcia_switch_segment(bus, 0);
+		lo = readw(bus->mmio + offset);
+		hi = readw(bus->mmio + offset + 2);
+		return lo | (hi << 16);
+	case SSB_BUSTYPE_SDIO:
+		offset += current_coreidx * SSB_CORE_SIZE;
+		return ssb_sdio_scan_read32(bus, offset);
+	}
+	return readl(bus->mmio + offset);
+}
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
+void ssb_iounmap(struct ssb_bus *bus)
+{
+	switch (bus->bustype) {
+	case SSB_BUSTYPE_SSB:
+	case SSB_BUSTYPE_PCMCIA:
+		iounmap(bus->mmio);
+		break;
+	case SSB_BUSTYPE_PCI:
+#ifdef CONFIG_SSB_PCIHOST
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
+void __iomem *ssb_ioremap(struct ssb_bus *bus, unsigned long baseaddr)
+{
+	void __iomem *mmio = NULL;
+
+	switch (bus->bustype) {
+	case SSB_BUSTYPE_SSB:
+		/* Only map the first core for now. */
+		/* fallthrough... */
+	case SSB_BUSTYPE_PCMCIA:
+		mmio = ioremap(baseaddr, SSB_CORE_SIZE);
+		break;
+	case SSB_BUSTYPE_PCI:
+#ifdef CONFIG_SSB_PCIHOST
+		mmio = pci_iomap(bus->host_pci, 0, ~0UL);
+#else
+		SSB_BUG_ON(1); /* Can't reach this code. */
+#endif
+		break;
+	case SSB_BUSTYPE_SDIO:
+		/* Nothing to ioremap in the SDIO case, just fake it */
+		mmio = (void __iomem *)baseaddr;
+		break;
+	}
+
+	return mmio;
+}
diff --git a/drivers/ssb/bcmb_scan.h b/drivers/ssb/bcmb_scan.h
new file mode 100644
index 0000000..f1fd16c
--- /dev/null
+++ b/drivers/ssb/bcmb_scan.h
@@ -0,0 +1,13 @@
+#ifndef BCMB_SCAN_H_
+#define BCMB_SCAN_H_
+
+extern const char *ssb_core_name(u16 coreid);
+
+extern u32 scan_read32(struct ssb_bus *bus, u8 current_coreidx,
+			    u16 offset);
+extern int scan_switchcore(struct ssb_bus *bus, u8 coreidx);
+
+extern void ssb_iounmap(struct ssb_bus *bus);
+extern void __iomem *ssb_ioremap(struct ssb_bus *bus, unsigned long baseaddr);
+
+#endif
diff --git a/drivers/ssb/scan.c b/drivers/ssb/scan.c
index 29884c0..0087795 100644
--- a/drivers/ssb/scan.c
+++ b/drivers/ssb/scan.c
@@ -22,78 +22,6 @@
 
 #include "ssb_private.h"
 
-
-const char *ssb_core_name(u16 coreid)
-{
-	switch (coreid) {
-	case SSB_DEV_CHIPCOMMON:
-		return "ChipCommon";
-	case SSB_DEV_ILINE20:
-		return "ILine 20";
-	case SSB_DEV_SDRAM:
-		return "SDRAM";
-	case SSB_DEV_PCI:
-		return "PCI";
-	case SSB_DEV_MIPS:
-		return "MIPS";
-	case SSB_DEV_ETHERNET:
-		return "Fast Ethernet";
-	case SSB_DEV_V90:
-		return "V90";
-	case SSB_DEV_USB11_HOSTDEV:
-		return "USB 1.1 Hostdev";
-	case SSB_DEV_ADSL:
-		return "ADSL";
-	case SSB_DEV_ILINE100:
-		return "ILine 100";
-	case SSB_DEV_IPSEC:
-		return "IPSEC";
-	case SSB_DEV_PCMCIA:
-		return "PCMCIA";
-	case SSB_DEV_INTERNAL_MEM:
-		return "Internal Memory";
-	case SSB_DEV_MEMC_SDRAM:
-		return "MEMC SDRAM";
-	case SSB_DEV_EXTIF:
-		return "EXTIF";
-	case SSB_DEV_80211:
-		return "IEEE 802.11";
-	case SSB_DEV_MIPS_3302:
-		return "MIPS 3302";
-	case SSB_DEV_USB11_HOST:
-		return "USB 1.1 Host";
-	case SSB_DEV_USB11_DEV:
-		return "USB 1.1 Device";
-	case SSB_DEV_USB20_HOST:
-		return "USB 2.0 Host";
-	case SSB_DEV_USB20_DEV:
-		return "USB 2.0 Device";
-	case SSB_DEV_SDIO_HOST:
-		return "SDIO Host";
-	case SSB_DEV_ROBOSWITCH:
-		return "Roboswitch";
-	case SSB_DEV_PARA_ATA:
-		return "PATA";
-	case SSB_DEV_SATA_XORDMA:
-		return "SATA XOR-DMA";
-	case SSB_DEV_ETHERNET_GBIT:
-		return "GBit Ethernet";
-	case SSB_DEV_PCIE:
-		return "PCI-E";
-	case SSB_DEV_MIMO_PHY:
-		return "MIMO PHY";
-	case SSB_DEV_SRAM_CTRLR:
-		return "SRAM Controller";
-	case SSB_DEV_MINI_MACPHY:
-		return "Mini MACPHY";
-	case SSB_DEV_ARM_1176:
-		return "ARM 1176";
-	case SSB_DEV_ARM_7TDMI:
-		return "ARM 7TDMI";
-	}
-	return "UNKNOWN";
-}
-
 static u16 pcidev_to_chipid(struct pci_dev *pci_dev)
 {
 	u16 chipid_fallback = 0;
@@ -157,97 +85,6 @@ static u8 chipid_to_nrcores(u16 chipid)
 	return 1;
 }
 
-static u32 scan_read32(struct ssb_bus *bus, u8 current_coreidx,
-		       u16 offset)
-{
-	u32 lo, hi;
-
-	switch (bus->bustype) {
-	case SSB_BUSTYPE_SSB:
-		offset += current_coreidx * SSB_CORE_SIZE;
-		break;
-	case SSB_BUSTYPE_PCI:
-		break;
-	case SSB_BUSTYPE_PCMCIA:
-		if (offset >= 0x800) {
-			ssb_pcmcia_switch_segment(bus, 1);
-			offset -= 0x800;
-		} else
-			ssb_pcmcia_switch_segment(bus, 0);
-		lo = readw(bus->mmio + offset);
-		hi = readw(bus->mmio + offset + 2);
-		return lo | (hi << 16);
-	case SSB_BUSTYPE_SDIO:
-		offset += current_coreidx * SSB_CORE_SIZE;
-		return ssb_sdio_scan_read32(bus, offset);
-	}
-	return readl(bus->mmio + offset);
-}
-
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
-void ssb_iounmap(struct ssb_bus *bus)
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
-static void __iomem *ssb_ioremap(struct ssb_bus *bus,
-				 unsigned long baseaddr)
-{
-	void __iomem *mmio = NULL;
-
-	switch (bus->bustype) {
-	case SSB_BUSTYPE_SSB:
-		/* Only map the first core for now. */
-		/* fallthrough... */
-	case SSB_BUSTYPE_PCMCIA:
-		mmio = ioremap(baseaddr, SSB_CORE_SIZE);
-		break;
-	case SSB_BUSTYPE_PCI:
-#ifdef CONFIG_SSB_PCIHOST
-		mmio = pci_iomap(bus->host_pci, 0, ~0UL);
-#else
-		SSB_BUG_ON(1); /* Can't reach this code. */
-#endif
-		break;
-	case SSB_BUSTYPE_SDIO:
-		/* Nothing to ioremap in the SDIO case, just fake it */
-		mmio = (void __iomem *)baseaddr;
-		break;
-	}
-
-	return mmio;
-}
-
 static int we_support_multiple_80211_cores(struct ssb_bus *bus)
 {
 	/* More than one 802.11 core is only supported by special chips.
diff --git a/drivers/ssb/ssb_private.h b/drivers/ssb/ssb_private.h
index 0331139..929a722 100644
--- a/drivers/ssb/ssb_private.h
+++ b/drivers/ssb/ssb_private.h
@@ -4,6 +4,7 @@
 #include <linux/ssb/ssb.h>
 #include <linux/types.h>
 
+#include "bcmb_scan.h"
 
 #define PFX	"ssb: "
 
@@ -156,10 +157,8 @@ static inline int ssb_sdio_init(struct ssb_bus *bus)
 
 
 /* scan.c */
-extern const char *ssb_core_name(u16 coreid);
 extern int ssb_bus_scan(struct ssb_bus *bus,
 			unsigned long baseaddr);
-extern void ssb_iounmap(struct ssb_bus *ssb);
 
 
 /* sprom.c */
-- 
1.7.3.4

