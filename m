Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:26877 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab1BQW3O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Feb 2011 17:29:14 -0500
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000022257.msg
	for <linux-wireless@vger.kernel.org>; Fri, 18 Feb 2011 00:28:36 +0200
Subject: Re: [RFC] AI support (8/14 ssb ssb_bus_detect routine)
From: George Kashperko <george@znau.edu.ua>
To: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1297980093.13554.5.camel@maggie>
References: <1297958316.5623.27.camel@dev.znau.edu.ua>
	 (sfid-20110217_170718_357395_57E8418D)  <1297980093.13554.5.camel@maggie>
Content-Type: text/plain
Date: Fri, 18 Feb 2011 00:20:47 +0200
Message-Id: <1297981247.23381.22.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: George Kashperko <george@znau.edu.ua>

Diagnostic messages in main.c with chip type info.
Move piece of code out of ssb_bus_scan to introduce basic bus detection
routine for later extension with AI-style bus detection.
Signed-off-by: George Kashperko <george@znau.edu.ua>
---
 drivers/ssb/main.c                        |   34 +++++++++----
 drivers/ssb/scan.c                        |   51 +++++++++++++-------
 include/linux/ssb/ssb_driver_chipcommon.h |   12 ++++
 3 files changed, 72 insertions(+), 25 deletions(-)
--- linux-wireless-testing.orig/drivers/ssb/main.c	2011-02-17 15:48:23.000000000 +0200
+++ linux-wireless-testing/drivers/ssb/main.c	2011-02-17 15:48:51.000000000 +0200
@@ -850,6 +850,16 @@ err_disable_xtal:
 	return err;
 }
 
+static const char *ssb_chipco_chiptype_name(struct ssb_bus *bus)
+{
+	switch (bus->chipco.chiptype) {
+	case SSB_CHIPCO_SB:
+		return "SB";
+	default:
+		return "UNKNOWN";
+	}
+}
+
 #ifdef CONFIG_SSB_PCIHOST
 int ssb_bus_pcibus_register(struct ssb_bus *bus,
 			    struct pci_dev *host_pci)
@@ -862,11 +872,14 @@ int ssb_bus_pcibus_register(struct ssb_b
 
 	err = ssb_bus_register(bus, ssb_pci_get_invariants, 0);
 	if (!err) {
-		ssb_printk(KERN_INFO PFX "Sonics Silicon Backplane found on "
-			   "PCI device %s\n", dev_name(&host_pci->dev));
+		ssb_printk(KERN_INFO PFX "Sonics Silicon Backplane "
+			   "(%s type) found on PCI device %s\n",
+			   ssb_chipco_chiptype_name(bus),
+			   dev_name(&host_pci->dev));
 	} else {
 		ssb_printk(KERN_ERR PFX "Failed to register PCI version"
-			   " of SSB with error %d\n", err);
+			   " of SSB (%s type) with error %d\n",
+			   ssb_chipco_chiptype_name(bus), err);
 	}
 
 	return err;
@@ -887,8 +900,9 @@ int ssb_bus_pcmciabus_register(struct ss
 
 	err = ssb_bus_register(bus, ssb_pcmcia_get_invariants, baseaddr);
 	if (!err) {
-		ssb_printk(KERN_INFO PFX "Sonics Silicon Backplane found on "
-			   "PCMCIA device %s\n", pcmcia_dev->devname);
+		ssb_printk(KERN_INFO PFX "Sonics Silicon Backplane "
+			   "(%s type) found on PCMCIA device %s\n",
+			   ssb_chipco_chiptype_name(bus), pcmcia_dev->devname);
 	}
 
 	return err;
@@ -909,8 +923,9 @@ int ssb_bus_sdiobus_register(struct ssb_
 
 	err = ssb_bus_register(bus, ssb_sdio_get_invariants, ~0);
 	if (!err) {
-		ssb_printk(KERN_INFO PFX "Sonics Silicon Backplane found on "
-			   "SDIO device %s\n", sdio_func_id(func));
+		ssb_printk(KERN_INFO PFX "Sonics Silicon Backplane "
+			   "(%s type) found on SDIO device %s\n",
+			   ssb_chipco_chiptype_name(bus), sdio_func_id(func));
 	}
 
 	return err;
@@ -929,8 +944,9 @@ int ssb_bus_ssbbus_register(struct ssb_b
 
 	err = ssb_bus_register(bus, get_invariants, baseaddr);
 	if (!err) {
-		ssb_printk(KERN_INFO PFX "Sonics Silicon Backplane found at "
-			   "address 0x%08lX\n", baseaddr);
+		ssb_printk(KERN_INFO PFX "Sonics Silicon Backplane "
+			   "(%s type) found at address 0x%08lX\n",
+			   ssb_chipco_chiptype_name(bus), baseaddr);
 	}
 
 	return err;
--- linux-wireless-testing.orig/drivers/ssb/scan.c	2011-02-17 15:48:23.000000000 +0200
+++ linux-wireless-testing/drivers/ssb/scan.c	2011-02-17 15:50:23.000000000 +0200
@@ -355,24 +355,11 @@ int ssb_bus_check_core(struct ssb_device
 	return 0;
 }
 
-int ssb_bus_scan(struct ssb_bus *bus,
-		 unsigned long baseaddr)
+/* Detect bus type and major bus information */
+static int ssb_bus_detect(struct ssb_bus *bus)
 {
-	int err = -ENOMEM;
-	void __iomem *mmio;
 	u32 idhi, cc, rev, tmp;
-	int dev_i, i;
-	struct ssb_device *dev;
-	int nr_80211_cores = 0;
-
-	mmio = ssb_ioremap(bus, baseaddr);
-	if (!mmio)
-		goto out;
-	bus->mmio = mmio;
-
-	err = scan_switchcore(bus, 0); /* Switch to first core */
-	if (err)
-		goto err_unmap;
+	enum ssb_chipco_chiptype chiptype = SSB_CHIPCO_SB;
 
 	idhi = scan_read32(bus, 0, SSB_IDHIGH);
 	cc = (idhi & SSB_IDHIGH_CC) >> SSB_IDHIGH_CC_SHIFT;
@@ -383,6 +370,7 @@ int ssb_bus_scan(struct ssb_bus *bus,
 	if (cc == SSB_DEV_CHIPCOMMON) {
 		tmp = scan_read32(bus, 0, SSB_CHIPCO_CHIPID);
 
+		chiptype = SSB_CHIPCO_TYPE(tmp);
 		bus->chip_id = (tmp & SSB_CHIPCO_IDMASK);
 		bus->chip_rev = (tmp & SSB_CHIPCO_REVMASK) >>
 				SSB_CHIPCO_REVSHIFT;
@@ -412,8 +400,39 @@ int ssb_bus_scan(struct ssb_bus *bus,
 		ssb_printk(KERN_ERR PFX
 			   "More than %d ssb cores found (%d)\n",
 			   SSB_MAX_NR_CORES, bus->nr_devices);
+		return -ENOMEM;
+	}
+
+	bus->chipco.chiptype = chiptype;
+	return chiptype == SSB_CHIPCO_SB ? 0 : -ENODEV;
+}
+
+int ssb_bus_scan(struct ssb_bus *bus, unsigned long baseaddr)
+{
+	int err = -ENOMEM;
+	void __iomem *mmio;
+	u32 idhi;
+	int dev_i, i;
+	struct ssb_device *dev;
+	int nr_80211_cores = 0;
+
+	mmio = ssb_ioremap(bus, baseaddr);
+	if (!mmio)
+		goto out;
+	bus->mmio = mmio;
+
+	err = scan_switchcore(bus, 0); /* Switch to first core */
+	if (err)
+		goto err_unmap;
+
+	err = ssb_bus_detect(bus);
+	if (err) {
+		ssb_printk(KERN_ERR PFX
+			   "ERROR: Unknown SSB chip type %d detected\n",
+			   bus->chipco.chiptype);
 		goto err_unmap;
 	}
+
 	if (bus->bustype == SSB_BUSTYPE_SSB) {
 		/* Now that we know the number of cores,
 		 * remap the whole IO space for all cores.
--- linux-wireless-testing.orig/include/linux/ssb/ssb_driver_chipcommon.h	2011-02-17 15:48:23.000000000 +0200
+++ linux-wireless-testing/include/linux/ssb/ssb_driver_chipcommon.h	2011-02-17 15:48:45.000000000 +0200
@@ -16,6 +16,9 @@
 /** ChipCommon core registers. **/
 
 #define SSB_CHIPCO_CHIPID		0x0000
+#define  SSB_CHIPCO_TYPE_MASK		0xF0000000
+#define  SSB_CHIPCO_TYPE_SHIFT		28
+#define   SSB_CHIPCO_TYPE_SB		0
 #define  SSB_CHIPCO_IDMASK		0x0000FFFF
 #define  SSB_CHIPCO_REVMASK		0x000F0000
 #define  SSB_CHIPCO_REVSHIFT		16
@@ -248,6 +251,9 @@
 #define SSB_CHIPCO_PLLCTL_ADDR			0x0660
 #define SSB_CHIPCO_PLLCTL_DATA			0x0664
 
+/** ChipCommon core registers identification macro helpers **/
+#define SSB_CHIPCO_TYPE(cid) (((cid) & SSB_CHIPCO_TYPE_MASK) >> \
+			      SSB_CHIPCO_TYPE_SHIFT)
 
 
 /** PMU PLL registers */
@@ -575,10 +581,16 @@ struct ssb_chipcommon_pmu {
 	u32 crystalfreq;	/* The active crystal frequency (in kHz) */
 };
 
+/* Chipcommon implementation type */
+enum ssb_chipco_chiptype {
+	SSB_CHIPCO_SB = SSB_CHIPCO_TYPE(SSB_CHIPCO_TYPE_SB), /* SB-style bus */
+};
+
 struct ssb_chipcommon {
 	struct ssb_device *dev;
 	u32 capabilities;
 	u32 status;
+	enum ssb_chipco_chiptype chiptype;
 	/* Fast Powerup Delay constant */
 	u16 fast_pwrup_delay;
 	struct ssb_chipcommon_pmu pmu;



