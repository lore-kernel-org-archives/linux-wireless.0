Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:41279 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761306AbZJIScw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2009 14:32:52 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ssb: Put host pointers into a union
Date: Fri, 9 Oct 2009 20:32:10 +0200
Cc: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200910092032.10324.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This slightly shrinks the structure.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Index: wireless-testing/drivers/ssb/driver_pcicore.c
===================================================================
--- wireless-testing.orig/drivers/ssb/driver_pcicore.c	2008-07-20 12:09:34.000000000 +0200
+++ wireless-testing/drivers/ssb/driver_pcicore.c	2009-10-09 19:01:59.000000000 +0200
@@ -551,13 +551,13 @@ int ssb_pcicore_dev_irqvecs_enable(struc
 	might_sleep_if(pdev->id.coreid != SSB_DEV_PCI);
 
 	/* Enable interrupts for this device. */
-	if (bus->host_pci &&
-	    ((pdev->id.revision >= 6) || (pdev->id.coreid == SSB_DEV_PCIE))) {
+	if ((pdev->id.revision >= 6) || (pdev->id.coreid == SSB_DEV_PCIE)) {
 		u32 coremask;
 
 		/* Calculate the "coremask" for the device. */
 		coremask = (1 << dev->core_index);
 
+		SSB_WARN_ON(bus->bustype != SSB_BUSTYPE_PCI);
 		err = pci_read_config_dword(bus->host_pci, SSB_PCI_IRQMASK, &tmp);
 		if (err)
 			goto out;
Index: wireless-testing/include/linux/ssb/ssb.h
===================================================================
--- wireless-testing.orig/include/linux/ssb/ssb.h	2009-09-11 21:27:27.000000000 +0200
+++ wireless-testing/include/linux/ssb/ssb.h	2009-10-09 19:10:42.000000000 +0200
@@ -269,7 +269,8 @@ struct ssb_bus {
 
 	const struct ssb_bus_ops *ops;
 
-	/* The core in the basic address register window. (PCI bus only) */
+	/* The core currently mapped into the MMIO window.
+	 * Not valid on all host-buses. So don't use outside of SSB. */
 	struct ssb_device *mapped_device;
 	union {
 		/* Currently mapped PCMCIA segment. (bustype == SSB_BUSTYPE_PCMCIA only) */
@@ -281,14 +282,17 @@ struct ssb_bus {
 	 * On PCMCIA-host busses this is used to protect the whole MMIO access. */
 	spinlock_t bar_lock;
 
-	/* The bus this backplane is running on. */
+	/* The host-bus this backplane is running on. */
 	enum ssb_bustype bustype;
-	/* Pointer to the PCI bus (only valid if bustype == SSB_BUSTYPE_PCI). */
-	struct pci_dev *host_pci;
-	/* Pointer to the PCMCIA device (only if bustype == SSB_BUSTYPE_PCMCIA). */
-	struct pcmcia_device *host_pcmcia;
-	/* Pointer to the SDIO device (only if bustype == SSB_BUSTYPE_SDIO). */
-	struct sdio_func *host_sdio;
+	/* Pointers to the host-bus. Check bustype before using any of these pointers. */
+	union {
+		/* Pointer to the PCI bus (only valid if bustype == SSB_BUSTYPE_PCI). */
+		struct pci_dev *host_pci;
+		/* Pointer to the PCMCIA device (only if bustype == SSB_BUSTYPE_PCMCIA). */
+		struct pcmcia_device *host_pcmcia;
+		/* Pointer to the SDIO device (only if bustype == SSB_BUSTYPE_SDIO). */
+		struct sdio_func *host_sdio;
+	};
 
 	/* See enum ssb_quirks */
 	unsigned int quirks;

-- 
Greetings, Michael.
