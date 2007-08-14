Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:50346
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765537AbXHNRA6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 13:00:58 -0400
Message-Id: <20070814165749.227375000@bu3sch.de>
References: <20070814165746.863593000@bu3sch.de>
Date: Tue, 14 Aug 2007 18:57:51 +0200
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: [patch 5/7] ssb: Add Broadcom 43xx PCI to SSB bridge
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: ssb-merge-new/drivers/ssb/Makefile
===================================================================
--- ssb-merge-new.orig/drivers/ssb/Makefile	2007-08-13 17:35:33.000000000 +0200
+++ ssb-merge-new/drivers/ssb/Makefile	2007-08-13 17:35:49.000000000 +0200
@@ -11,4 +11,8 @@ ssb-$(CONFIG_SSB_DRIVER_MIPS)		+= driver
 ssb-$(CONFIG_SSB_DRIVER_EXTIF)		+= driver_extif.o
 ssb-$(CONFIG_SSB_DRIVER_PCICORE)	+= driver_pcicore.o
 
+# b43 pci-ssb-bridge driver
+# Not strictly a part of SSB, but kept here for convenience
+ssb-$(CONFIG_SSB_PCIHOST)		+= b43_pci_bridge.o
+
 obj-$(CONFIG_SSB)			+= ssb.o
Index: ssb-merge-new/drivers/ssb/b43_pci_bridge.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ ssb-merge-new/drivers/ssb/b43_pci_bridge.c	2007-08-13 17:42:24.000000000 +0200
@@ -0,0 +1,45 @@
+/*
+ * Broadcom 43xx PCI-SSB bridge module
+ *
+ * This technically is a seperate PCI driver module, but
+ * because of its small size we include it in the SSB core
+ * instead of creating a standalone module.
+ *
+ * Copyright 2007  Michael Buesch <mb@bu3sch.de>
+ *
+ * Licensed under the GNU/GPL. See COPYING for details.
+ */
+
+#include <linux/pci.h>
+#include <linux/ssb/ssb.h>
+
+
+static const struct pci_device_id b43_pci_bridge_tbl[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4307) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4311) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4312) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4318) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4319) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4320) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4321) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4324) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4325) },
+	{ 0, },
+};
+MODULE_DEVICE_TABLE(pci, b43_pci_bridge_tbl);
+
+static struct pci_driver b43_pci_bridge_driver = {
+	.name = "b43-pci-bridge",
+	.id_table = b43_pci_bridge_tbl,
+};
+
+
+int __init b43_pci_ssb_bridge_init(void)
+{
+	return ssb_pcihost_register(&b43_pci_bridge_driver);
+}
+
+void __exit b43_pci_ssb_bridge_exit(void)
+{
+	ssb_pcihost_unregister(&b43_pci_bridge_driver);
+}
Index: ssb-merge-new/drivers/ssb/main.c
===================================================================
--- ssb-merge-new.orig/drivers/ssb/main.c	2007-08-13 17:35:49.000000000 +0200
+++ ssb-merge-new/drivers/ssb/main.c	2007-08-13 17:40:14.000000000 +0200
@@ -1121,12 +1121,21 @@ static int __init ssb_modinit(void)
 	if (err)
 		bus_unregister(&ssb_bustype);
 
+	err = b43_pci_ssb_bridge_init();
+	if (err) {
+		ssb_printk(KERN_ERR "Broadcom 43xx PCI-SSB-bridge "
+			   "initialization failed");
+		/* don't fail SSB init because of this */
+		err = 0;
+	}
+
 	return err;
 }
 subsys_initcall(ssb_modinit);
 
 static void __exit ssb_modexit(void)
 {
+	b43_pci_ssb_bridge_exit();
 	bus_unregister(&ssb_bustype);
 }
 module_exit(ssb_modexit)
Index: ssb-merge-new/drivers/ssb/ssb_private.h
===================================================================
--- ssb-merge-new.orig/drivers/ssb/ssb_private.h	2007-08-13 17:35:33.000000000 +0200
+++ ssb-merge-new/drivers/ssb/ssb_private.h	2007-08-13 17:35:49.000000000 +0200
@@ -119,4 +119,18 @@ extern int ssb_devices_freeze(struct ssb
 extern int ssb_devices_thaw(struct ssb_bus *bus);
 extern struct ssb_bus *ssb_pci_dev_to_bus(struct pci_dev *pdev);
 
+/* b43_pci_bridge.c */
+#ifdef CONFIG_SSB_PCIHOST
+extern int __init b43_pci_ssb_bridge_init(void);
+extern void __exit b43_pci_ssb_bridge_exit(void);
+#else /* CONFIG_SSB_PCIHOST */
+static inline int b43_pci_ssb_bridge_init(void)
+{
+	return 0;
+}
+static inline void b43_pci_ssb_bridge_exit(void)
+{
+}
+#endif /* CONFIG_SSB_PCIHOST */
+
 #endif /* LINUX_SSB_PRIVATE_H_ */

-- 

