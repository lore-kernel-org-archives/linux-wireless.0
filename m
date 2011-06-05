Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:33039 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756156Ab1FEWIT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jun 2011 18:08:19 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linux-wireless@vger.kernel.org, linux-mips@linux-mips.org
Cc: zajec5@gmail.com, mb@bu3sch.de, george@znau.edu.ua,
	arend@broadcom.com, b43-dev@lists.infradead.org,
	bernhardloos@googlemail.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [RFC][PATCH 03/10] bcma: add embedded bus
Date: Mon,  6 Jun 2011 00:07:31 +0200
Message-Id: <1307311658-15853-4-git-send-email-hauke@hauke-m.de> (sfid-20110606_000822_492248_23C42BA9)
In-Reply-To: <1307311658-15853-1-git-send-email-hauke@hauke-m.de>
References: <1307311658-15853-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support for using bcma on an embedded bus. An embedded
system like the bcm4716 could register this bus and it searches for the
bcma cores then.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/Kconfig               |    5 ++
 drivers/bcma/Makefile              |    1 +
 drivers/bcma/host_embedded.c       |   93 ++++++++++++++++++++++++++++++++++++
 drivers/bcma/main.c                |    1 +
 drivers/bcma/scan.c                |   29 ++++++++++-
 include/linux/bcma/bcma.h          |    3 +
 include/linux/bcma/bcma_embedded.h |    8 +++
 7 files changed, 138 insertions(+), 2 deletions(-)
 create mode 100644 drivers/bcma/host_embedded.c
 create mode 100644 include/linux/bcma/bcma_embedded.h

diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
index 83e9adf..0390e32 100644
--- a/drivers/bcma/Kconfig
+++ b/drivers/bcma/Kconfig
@@ -27,6 +27,11 @@ config BCMA_HOST_PCI
 	bool "Support for BCMA on PCI-host bus"
 	depends on BCMA_HOST_PCI_POSSIBLE
 
+config BCMA_HOST_EMBEDDED
+	bool
+	depends on BCMA && MIPS
+	default n
+
 config BCMA_DEBUG
 	bool "BCMA debugging"
 	depends on BCMA
diff --git a/drivers/bcma/Makefile b/drivers/bcma/Makefile
index 0d56245..e509b1b 100644
--- a/drivers/bcma/Makefile
+++ b/drivers/bcma/Makefile
@@ -2,6 +2,7 @@ bcma-y					+= main.o scan.o core.o
 bcma-y					+= driver_chipcommon.o driver_chipcommon_pmu.o
 bcma-y					+= driver_pci.o
 bcma-$(CONFIG_BCMA_HOST_PCI)		+= host_pci.o
+bcma-$(CONFIG_BCMA_HOST_EMBEDDED)	+= host_embedded.o
 obj-$(CONFIG_BCMA)			+= bcma.o
 
 ccflags-$(CONFIG_BCMA_DEBUG)		:= -DDEBUG
diff --git a/drivers/bcma/host_embedded.c b/drivers/bcma/host_embedded.c
new file mode 100644
index 0000000..6942440
--- /dev/null
+++ b/drivers/bcma/host_embedded.c
@@ -0,0 +1,93 @@
+/*
+ * Broadcom specific AMBA
+ * PCI Host
+ *
+ * Licensed under the GNU/GPL. See COPYING for details.
+ */
+
+#include "bcma_private.h"
+#include "scan.h"
+#include <linux/bcma/bcma.h>
+
+static u8 bcma_host_bcma_read8(struct bcma_device *core, u16 offset)
+{
+	offset += core->core_index * BCMA_CORE_SIZE;
+	return readb(core->bus->mmio + offset);
+}
+
+static u16 bcma_host_bcma_read16(struct bcma_device *core, u16 offset)
+{
+	offset += core->core_index * BCMA_CORE_SIZE;
+	return readw(core->bus->mmio + offset);
+}
+
+static u32 bcma_host_bcma_read32(struct bcma_device *core, u16 offset)
+{
+	offset += core->core_index * BCMA_CORE_SIZE;
+	return readl(core->bus->mmio + offset);
+}
+
+static void bcma_host_bcma_write8(struct bcma_device *core, u16 offset,
+				 u8 value)
+{
+	offset += core->core_index * BCMA_CORE_SIZE;
+	writeb(value, core->bus->mmio + offset);
+}
+
+static void bcma_host_bcma_write16(struct bcma_device *core, u16 offset,
+				 u16 value)
+{
+	offset += core->core_index * BCMA_CORE_SIZE;
+	writew(value, core->bus->mmio + offset);
+}
+
+static void bcma_host_bcma_write32(struct bcma_device *core, u16 offset,
+				 u32 value)
+{
+	offset += core->core_index * BCMA_CORE_SIZE;
+	writel(value, core->bus->mmio + offset);
+}
+
+static u32 bcma_host_bcma_aread32(struct bcma_device *core, u16 offset)
+{
+	offset += core->core_index * BCMA_CORE_SIZE;
+	return readl(core->bus->host_embedded + offset);
+}
+
+static void bcma_host_bcma_awrite32(struct bcma_device *core, u16 offset,
+				  u32 value)
+{
+	offset += core->core_index * BCMA_CORE_SIZE;
+	writel(value, core->bus->host_embedded + offset);
+}
+
+const struct bcma_host_ops bcma_host_bcma_ops = {
+	.read8		= bcma_host_bcma_read8,
+	.read16		= bcma_host_bcma_read16,
+	.read32		= bcma_host_bcma_read32,
+	.write8		= bcma_host_bcma_write8,
+	.write16	= bcma_host_bcma_write16,
+	.write32	= bcma_host_bcma_write32,
+	.aread32	= bcma_host_bcma_aread32,
+	.awrite32	= bcma_host_bcma_awrite32,
+};
+
+int bcma_host_bcma_register(struct bcma_bus *bus)
+{
+	u32 __iomem *mmio;
+
+	/* iomap only first core. We have to read some register on this core
+	 * to get the number of cores. This is sone in bcma_scan()
+	 */
+	mmio = ioremap(BCMA_ADDR_BASE, BCMA_CORE_SIZE * 1);
+	if (!mmio)
+		return -ENOMEM;
+	bus->mmio = mmio;
+
+	/* Host specific */
+	bus->hosttype = BCMA_HOSTTYPE_EMBEDDED;
+	bus->ops = &bcma_host_bcma_ops;
+
+	/* Register */
+	return bcma_bus_register(bus);
+}
diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 1afa107..c5bcb5f 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -119,6 +119,7 @@ static int bcma_register_cores(struct bcma_bus *bus)
 			break;
 		case BCMA_HOSTTYPE_NONE:
 		case BCMA_HOSTTYPE_SDIO:
+		case BCMA_HOSTTYPE_EMBEDDED:
 			break;
 		}
 
diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
index 70b39f7..9229615 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -203,7 +203,7 @@ static s32 bcma_erom_get_addr_desc(struct bcma_bus *bus, u32 **eromptr,
 int bcma_bus_scan(struct bcma_bus *bus)
 {
 	u32 erombase;
-	u32 __iomem *eromptr, *eromend;
+	u32 __iomem *eromptr, *eromend, *mmio;
 
 	s32 cia, cib;
 	u8 ports[2], wrappers[2];
@@ -219,9 +219,34 @@ int bcma_bus_scan(struct bcma_bus *bus)
 	bus->chipinfo.id = (tmp & BCMA_CC_ID_ID) >> BCMA_CC_ID_ID_SHIFT;
 	bus->chipinfo.rev = (tmp & BCMA_CC_ID_REV) >> BCMA_CC_ID_REV_SHIFT;
 	bus->chipinfo.pkg = (tmp & BCMA_CC_ID_PKG) >> BCMA_CC_ID_PKG_SHIFT;
+	bus->nr_cores = (tmp & BCMA_CC_ID_NRCORES) >> BCMA_CC_ID_NRCORES_SHIFT;
+
+	/* If we are an embedded device we now know the number of avaliable
+	 * core and ioremap the correct space.
+	 */
+	if (bus->hosttype == BCMA_HOSTTYPE_EMBEDDED) {
+		iounmap(bus->mmio);
+		mmio = ioremap(BCMA_ADDR_BASE, BCMA_CORE_SIZE * bus->nr_cores);
+		if (!mmio)
+			return -ENOMEM;
+		bus->mmio = mmio;
+
+		mmio = ioremap(BCMA_WRAP_BASE, BCMA_CORE_SIZE * bus->nr_cores);
+		if (!mmio)
+			return -ENOMEM;
+		bus->host_embedded = mmio;
+	}
+	/* reset it to 0 as we use it for counting */
+	bus->nr_cores = 0;
 
 	erombase = bcma_scan_read32(bus, 0, BCMA_CC_EROM);
-	eromptr = bus->mmio;
+	if (bus->hosttype == BCMA_HOSTTYPE_EMBEDDED) {
+		eromptr = ioremap(erombase, BCMA_CORE_SIZE);
+		if (!eromptr)
+			return -ENOMEM;
+	} else
+		eromptr = bus->mmio;
+
 	eromend = eromptr + BCMA_CORE_SIZE / sizeof(u32);
 
 	bcma_scan_switch_core(bus, erombase);
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 8b6feca..192c4ae 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -16,6 +16,7 @@ enum bcma_hosttype {
 	BCMA_HOSTTYPE_NONE,
 	BCMA_HOSTTYPE_PCI,
 	BCMA_HOSTTYPE_SDIO,
+	BCMA_HOSTTYPE_EMBEDDED,
 };
 
 struct bcma_chipinfo {
@@ -185,6 +186,8 @@ struct bcma_bus {
 		struct pci_dev *host_pci;
 		/* Pointer to the SDIO device (only for BCMA_HOSTTYPE_SDIO) */
 		struct sdio_func *host_sdio;
+		/* Pointer to the embedded iomem (only for BCMA_HOSTTYPE_EMBEDDED) */
+		void __iomem *host_embedded;
 	};
 
 	struct bcma_chipinfo chipinfo;
diff --git a/include/linux/bcma/bcma_embedded.h b/include/linux/bcma/bcma_embedded.h
new file mode 100644
index 0000000..0faf46d
--- /dev/null
+++ b/include/linux/bcma/bcma_embedded.h
@@ -0,0 +1,8 @@
+#ifndef LINUX_BCMA_EMBEDDED_H_
+#define LINUX_BCMA_EMBEDDED_H_
+
+#include <linux/bcma/bcma.h>
+
+extern int bcma_host_bcma_register(struct bcma_bus *bus);
+
+#endif /* LINUX_BCMA_EMBEDDED_H_ */
-- 
1.7.4.1

