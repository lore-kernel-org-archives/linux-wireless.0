Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:33073 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756294Ab1FEWI3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jun 2011 18:08:29 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linux-wireless@vger.kernel.org, linux-mips@linux-mips.org
Cc: zajec5@gmail.com, mb@bu3sch.de, george@znau.edu.ua,
	arend@broadcom.com, b43-dev@lists.infradead.org,
	bernhardloos@googlemail.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [RFC][PATCH 07/10] bcma: add pci(e) host mode
Date: Mon,  6 Jun 2011 00:07:35 +0200
Message-Id: <1307311658-15853-8-git-send-email-hauke@hauke-m.de> (sfid-20110606_000833_004335_036BC5E4)
In-Reply-To: <1307311658-15853-1-git-send-email-hauke@hauke-m.de>
References: <1307311658-15853-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds some stub for a pci(e) host controller. This controller is
found on some embedded devices to attach other chips.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/Kconfig                 |    6 ++++
 drivers/bcma/Makefile                |    1 +
 drivers/bcma/bcma_private.h          |    6 ++++
 drivers/bcma/driver_pci.c            |   12 ++++++++-
 drivers/bcma/driver_pci_host.c       |   44 ++++++++++++++++++++++++++++++++++
 include/linux/bcma/bcma_driver_pci.h |    1 +
 6 files changed, 69 insertions(+), 1 deletions(-)
 create mode 100644 drivers/bcma/driver_pci_host.c

diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
index 568d30b..c863a87 100644
--- a/drivers/bcma/Kconfig
+++ b/drivers/bcma/Kconfig
@@ -27,6 +27,12 @@ config BCMA_HOST_PCI
 	bool "Support for BCMA on PCI-host bus"
 	depends on BCMA_HOST_PCI_POSSIBLE
 
+config BCMA_PCICORE_HOSTMODE
+	bool "Hostmode support for BCMA PCI core"
+	depends on BCMA_DRIVER_MIPS
+	help
+	  PCIcore hostmode operation (external PCI bus).
+
 config BCMA_HOST_EMBEDDED
 	bool
 	depends on BCMA_DRIVER_MIPS
diff --git a/drivers/bcma/Makefile b/drivers/bcma/Makefile
index 50ddab8..f99abfe 100644
--- a/drivers/bcma/Makefile
+++ b/drivers/bcma/Makefile
@@ -1,6 +1,7 @@
 bcma-y					+= main.o scan.o core.o
 bcma-y					+= driver_chipcommon.o driver_chipcommon_pmu.o
 bcma-y					+= driver_pci.o
+bcma-$(CONFIG_BCMA_PCICORE_HOSTMODE)	+= driver_pci_host.o
 bcma-$(CONFIG_BCMA_DRIVER_MIPS)		+= driver_mips.o
 bcma-$(CONFIG_BCMA_HOST_PCI)		+= host_pci.o
 bcma-$(CONFIG_BCMA_HOST_EMBEDDED)	+= host_embedded.o
diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index fbabe19..13cf25a 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -29,6 +29,12 @@ extern u32 bcma_pmu_get_clockcpu(struct bcma_drv_cc *cc);
 extern int bcma_chipco_serial_init(struct bcma_drv_cc *cc,
 				   struct bcma_drv_mips_serial_port *ports);
 
+#ifdef CONFIG_BCMA_PCICORE_HOSTMODE
+/* driver_pci_host.c */
+extern int bcma_pcicore_is_in_hostmode(struct bcma_drv_pci *pc);
+extern void bcma_pcicore_init_hostmode(struct bcma_drv_pci *pc);
+#endif /* CONFIG_BCMA_PCICORE_HOSTMODE */
+
 #ifdef CONFIG_BCMA_HOST_PCI
 /* host_pci.c */
 extern int __init bcma_host_pci_init(void);
diff --git a/drivers/bcma/driver_pci.c b/drivers/bcma/driver_pci.c
index 789d68b..cf8cbe0 100644
--- a/drivers/bcma/driver_pci.c
+++ b/drivers/bcma/driver_pci.c
@@ -159,7 +159,17 @@ static void bcma_pcicore_serdes_workaround(struct bcma_drv_pci *pc)
 
 void bcma_core_pci_init(struct bcma_drv_pci *pc)
 {
-	bcma_pcicore_serdes_workaround(pc);
+	struct bcma_device *core = pc->core;
+
+	if (!bcma_core_is_enabled(core))
+		bcma_core_enable(core, 0);
+#ifdef CONFIG_BCMA_PCICORE_HOSTMODE
+	pc->hostmode = bcma_pcicore_is_in_hostmode(pc);
+	if (pc->hostmode)
+		bcma_pcicore_init_hostmode(pc);
+#endif /* CONFIG_BCMA_PCICORE_HOSTMODE */
+	if (!pc->hostmode)
+		bcma_pcicore_serdes_workaround(pc);
 }
 
 int bcma_core_pci_irq_ctl(struct bcma_drv_pci *pc, struct bcma_device *core,
diff --git a/drivers/bcma/driver_pci_host.c b/drivers/bcma/driver_pci_host.c
new file mode 100644
index 0000000..b52c6c9
--- /dev/null
+++ b/drivers/bcma/driver_pci_host.c
@@ -0,0 +1,44 @@
+/*
+ * Broadcom specific AMBA
+ * PCI Core
+ *
+ * Copyright 2005, Broadcom Corporation
+ * Copyright 2006, 2007, Michael Buesch <mb@bu3sch.de>
+ *
+ * Licensed under the GNU/GPL. See COPYING for details.
+ */
+
+#include "bcma_private.h"
+#include <linux/bcma/bcma.h>
+
+#include <asm/paccess.h>
+/* Probe a 32bit value on the bus and catch bus exceptions.
+ * Returns nonzero on a bus exception.
+ * This is MIPS specific */
+#define mips_busprobe32(val, addr)	get_dbe((val), ((u32 *)(addr)))
+
+
+void bcma_pcicore_init_hostmode(struct bcma_drv_pci *pc)
+{
+	/* TODO: implement PCI host mode */
+}
+
+int bcma_pcicore_is_in_hostmode(struct bcma_drv_pci *pc)
+{
+	struct bcma_bus *bus = pc->core->bus;
+	u16 chipid_top;
+	u32 tmp;
+
+	chipid_top = (bus->chipinfo.id & 0xFF00);
+	if (chipid_top != 0x4700 &&
+	    chipid_top != 0x5300)
+		return 0;
+
+/* TODO: add when sprom is available
+ * if (bus->sprom.boardflags_lo & SSB_PCICORE_BFL_NOPCI)
+ *		return 0;
+ */
+
+	return !mips_busprobe32(tmp, (bus->mmio + (pc->core->core_index *
+						   BCMA_CORE_SIZE)));
+}
diff --git a/include/linux/bcma/bcma_driver_pci.h b/include/linux/bcma/bcma_driver_pci.h
index b7e191c..5bbc58f 100644
--- a/include/linux/bcma/bcma_driver_pci.h
+++ b/include/linux/bcma/bcma_driver_pci.h
@@ -78,6 +78,7 @@ struct pci_dev;
 struct bcma_drv_pci {
 	struct bcma_device *core;
 	u8 setup_done:1;
+	u8 hostmode:1;
 };
 
 /* Register access */
-- 
1.7.4.1

