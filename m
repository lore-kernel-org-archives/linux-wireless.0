Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:22570 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab1BIOrF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 09:47:05 -0500
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000019990.msg
	for <linux-wireless@vger.kernel.org>; Wed, 09 Feb 2011 16:46:28 +0200
Subject: Re: SSB AI support code ([RFC7/11] SSB introduce ssb_bus_detect
	routine)
From: George Kashperko <george@znau.edu.ua>
To: George Kashperko <george@znau.edu.ua>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1297258590.17400.37.camel@dev.znau.edu.ua>
References: <1297258590.17400.37.camel@dev.znau.edu.ua>
Content-Type: text/plain
Date: Wed, 09 Feb 2011 16:39:37 +0200
Message-Id: <1297262377.18053.32.camel@dev.znau.edu.ua>
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
--- linux-next-20110203.orig/drivers/ssb/main.c	2011-02-08 13:34:23.000000000 +0200
+++ linux-next-20110203/drivers/ssb/main.c	2011-02-08 13:19:40.000000000 +0200
@@ -838,6 +838,16 @@ err_disable_xtal:
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
@@ -850,11 +860,14 @@ int ssb_bus_pcibus_register(struct ssb_b
 
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
@@ -875,8 +888,9 @@ int ssb_bus_pcmciabus_register(struct ss
 
 	err = ssb_bus_register(bus, ssb_pcmcia_get_invariants, baseaddr);
 	if (!err) {
-		ssb_printk(KERN_INFO PFX "Sonics Silicon Backplane found on "
-			   "PCMCIA device %s\n", pcmcia_dev->devname);
+		ssb_printk(KERN_INFO PFX "Sonics Silicon Backplane "
+			   "(%s type) found on PCMCIA device %s\n",
+			   ssb_chipco_chiptype_name(bus), pcmcia_dev->devname);
 	}
 
 	return err;
@@ -897,8 +911,9 @@ int ssb_bus_sdiobus_register(struct ssb_
 
 	err = ssb_bus_register(bus, ssb_sdio_get_invariants, ~0);
 	if (!err) {
-		ssb_printk(KERN_INFO PFX "Sonics Silicon Backplane found on "
-			   "SDIO device %s\n", sdio_func_id(func));
+		ssb_printk(KERN_INFO PFX "Sonics Silicon Backplane "
+			   "(%s type) found on SDIO device %s\n",
+			   ssb_chipco_chiptype_name(bus), sdio_func_id(func));
 	}
 
 	return err;
@@ -917,8 +932,9 @@ int ssb_bus_ssbbus_register(struct ssb_b
 
 	err = ssb_bus_register(bus, get_invariants, baseaddr);
 	if (!err) {
-		ssb_printk(KERN_INFO PFX "Sonics Silicon Backplane found at "
-			   "address 0x%08lX\n", baseaddr);
+		ssb_printk(KERN_INFO PFX "Sonics Silicon Backplane "
+			   "(%s type) found at address 0x%08lX\n",
+			   ssb_chipco_chiptype_name(bus), baseaddr);
 	}
 
 	return err;
--- linux-next-20110203.orig/drivers/ssb/scan.c	2011-02-08 13:34:23.000000000 +0200
+++ linux-next-20110203/drivers/ssb/scan.c	2011-02-08 13:33:43.000000000 +0200
@@ -354,24 +354,11 @@ int ssb_bus_check_core(struct ssb_device
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
@@ -411,8 +398,40 @@ int ssb_bus_scan(struct ssb_bus *bus,
 		ssb_printk(KERN_ERR PFX
 			   "More than %d ssb cores found (%d)\n",
 			   SSB_MAX_NR_CORES, bus->nr_devices);
+		return -ENOMEM;
+	}
+
+	bus->chipco.chiptype = chiptype;
+	return chiptype != SSB_CHIPCO_SB;
+}
+
+int ssb_bus_scan(struct ssb_bus *bus,
+		 unsigned long baseaddr)
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
+	if (ssb_bus_detect(bus)) {
+		ssb_printk(KERN_ERR PFX
+			   "ERROR: Unknown SSB chip type %d detected\n",
+			   bus->chipco.chiptype);
+		err = -ENODEV;
 		goto err_unmap;
 	}
+
 	if (bus->bustype == SSB_BUSTYPE_SSB) {
 		/* Now that we know the number of cores,
 		 * remap the whole IO space for all cores.
--- linux-next-20110203.orig/include/linux/ssb/ssb_driver_chipcommon.h	2011-02-08 13:34:23.000000000 +0200
+++ linux-next-20110203/include/linux/ssb/ssb_driver_chipcommon.h	2011-02-08 13:19:40.000000000 +0200
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



