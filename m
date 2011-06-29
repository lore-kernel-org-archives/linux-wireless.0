Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52164 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757995Ab1F2WMb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 18:12:31 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	linux-mips@linux-mips.org
Cc: mb@bu3sch.de, george@znau.edu.ua, arend@broadcom.com,
	b43-dev@lists.infradead.org, bernhardloos@googlemail.com,
	arnd@arndb.de, julian.calaby@gmail.com, sshtylyov@mvista.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [RFC v3 08/13] bcma: add pci(e) host mode
Date: Thu, 30 Jun 2011 00:11:53 +0200
Message-Id: <1309385518-12097-9-git-send-email-hauke@hauke-m.de> (sfid-20110630_001235_556748_33BA2BA4)
In-Reply-To: <1309385518-12097-1-git-send-email-hauke@hauke-m.de>
References: <1309385518-12097-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds some stub for a pci(e) host controller. This controller is
found on some embedded devices to attach other chips.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/Kconfig                 |    6 ++++
 drivers/bcma/Makefile                |    1 +
 drivers/bcma/bcma_private.h          |    6 ++++
 drivers/bcma/driver_pci.c            |   14 ++++++++++-
 drivers/bcma/driver_pci_host.c       |   43 ++++++++++++++++++++++++++++++++++
 include/linux/bcma/bcma_driver_pci.h |    1 +
 6 files changed, 70 insertions(+), 1 deletions(-)
 create mode 100644 drivers/bcma/driver_pci_host.c

diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
index 0bd0a26..810b1ac 100644
--- a/drivers/bcma/Kconfig
+++ b/drivers/bcma/Kconfig
@@ -32,6 +32,12 @@ config BCMA_HOST_SOC
 	depends on BCMA_DRIVER_MIPS
 	default n
 
+config BCMA_DRIVER_PCI_HOSTMODE
+	bool "Hostmode support for BCMA PCI core"
+	depends on BCMA_DRIVER_MIPS
+	help
+	  PCIcore hostmode operation (external PCI bus).
+
 config BCMA_DRIVER_MIPS
 	bool "BCMA Broadcom MIPS core driver"
 	depends on BCMA && MIPS
diff --git a/drivers/bcma/Makefile b/drivers/bcma/Makefile
index 3bb24f5..82de24e 100644
--- a/drivers/bcma/Makefile
+++ b/drivers/bcma/Makefile
@@ -1,6 +1,7 @@
 bcma-y					+= main.o scan.o core.o sprom.o
 bcma-y					+= driver_chipcommon.o driver_chipcommon_pmu.o
 bcma-y					+= driver_pci.o
+bcma-$(CONFIG_BCMA_DRIVER_PCI_HOSTMODE)	+= driver_pci_host.o
 bcma-$(CONFIG_BCMA_DRIVER_MIPS)		+= driver_mips.o
 bcma-$(CONFIG_BCMA_HOST_PCI)		+= host_pci.o
 bcma-$(CONFIG_BCMA_HOST_SOC)		+= host_soc.o
diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index d25dedd..cf81b6e 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -38,6 +38,12 @@ extern int bcma_chipco_serial_init(struct bcma_drv_cc *cc,
 				   struct bcma_drv_mips_serial_port *ports);
 #endif /* CONFIG_BCMA_DRIVER_MIPS */
 
+#ifdef CONFIG_BCMA_DRIVER_PCI_HOSTMODE
+/* driver_pci_host.c */
+int bcma_core_pci_in_hostmode(struct bcma_drv_pci *pc);
+void bcma_core_pci_hostmode_init(struct bcma_drv_pci *pc);
+#endif /* CONFIG_BCMA_DRIVER_PCI_HOSTMODE */
+
 #ifdef CONFIG_BCMA_HOST_PCI
 /* host_pci.c */
 extern int __init bcma_host_pci_init(void);
diff --git a/drivers/bcma/driver_pci.c b/drivers/bcma/driver_pci.c
index 30a3a8a..b5ef812 100644
--- a/drivers/bcma/driver_pci.c
+++ b/drivers/bcma/driver_pci.c
@@ -159,9 +159,21 @@ static void bcma_pcicore_serdes_workaround(struct bcma_drv_pci *pc)
 
 void bcma_core_pci_init(struct bcma_drv_pci *pc)
 {
+	struct bcma_device *core = pc->core;
+
 	if (pc->setup_done)
 		return;
-	bcma_pcicore_serdes_workaround(pc);
+
+	if (!bcma_core_is_enabled(core))
+		bcma_core_enable(core, 0);
+#ifdef CONFIG_BCMA_DRIVER_PCI_HOSTMODE
+	pc->hostmode = bcma_core_pci_in_hostmode(pc);
+	if (pc->hostmode)
+		bcma_core_pci_hostmode_init(pc);
+#endif /* CONFIG_BCMA_DRIVER_PCI_HOSTMODE */
+	if (!pc->hostmode)
+		bcma_pcicore_serdes_workaround(pc);
+
 	pc->setup_done = true;
 }
 
diff --git a/drivers/bcma/driver_pci_host.c b/drivers/bcma/driver_pci_host.c
new file mode 100644
index 0000000..9ffd3e3
--- /dev/null
+++ b/drivers/bcma/driver_pci_host.c
@@ -0,0 +1,43 @@
+/*
+ * Broadcom specific AMBA
+ * PCI Host mode
+ *
+ * Copyright 2005, Broadcom Corporation
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
+void bcma_core_pci_hostmode_init(struct bcma_drv_pci *pc)
+{
+	/* TODO: implement PCI host mode */
+}
+
+int bcma_core_pci_in_hostmode(struct bcma_drv_pci *pc)
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
index 3871b66..b8c7d06 100644
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

