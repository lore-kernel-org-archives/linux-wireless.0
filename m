Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:26842 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab1BQW1J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Feb 2011 17:27:09 -0500
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000022255.msg
	for <linux-wireless@vger.kernel.org>; Fri, 18 Feb 2011 00:26:31 +0200
Subject: Re: [RFC] AI support (7/14 ssb bus_check_core routine)
From: George Kashperko <george@znau.edu.ua>
To: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1297980093.13554.5.camel@maggie>
References: <1297958316.5623.27.camel@dev.znau.edu.ua>
	 (sfid-20110217_170718_357395_57E8418D)  <1297980093.13554.5.camel@maggie>
Content-Type: text/plain
Date: Fri, 18 Feb 2011 00:18:42 +0200
Message-Id: <1297981122.23381.19.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: George Kashperko <george@znau.edu.ua>

Move part of the SB-style bus scan code into separate routine
in order to reuse it later with AI-style bus scan.
Signed-off-by: George Kashperko <george@znau.edu.ua>
---
 drivers/ssb/scan.c        |  173 +++++++++++++++++++-----------------
 drivers/ssb/ssb_private.h |    2 
 2 files changed, 94 insertions(+), 81 deletions(-)
--- linux-wireless-testing.orig/drivers/ssb/scan.c	2011-02-17 14:05:12.000000000 +0200
+++ linux-wireless-testing/drivers/ssb/scan.c	2011-02-17 14:32:49.000000000 +0200
@@ -265,6 +265,96 @@ static int we_support_multiple_80211_cor
 	return 0;
 }
 
+/* returns 0 if the core is ok and -1 if the core should be ignored */
+int ssb_bus_check_core(struct ssb_device *dev, int *nr_80211_cores, int corenum)
+{
+	struct ssb_bus *bus = dev->bus;
+
+	printk(KERN_DEBUG PFX
+		    "Core %d found: %s "
+		    "(cc 0x%03X, rev 0x%02X, vendor 0x%04X)\n",
+		    corenum, ssb_core_name(dev->id.coreid),
+		    dev->id.coreid, dev->id.revision, dev->id.vendor);
+
+	switch (dev->id.coreid) {
+	case SSB_DEV_80211:
+		(*nr_80211_cores)++;
+		if (*nr_80211_cores > 1) {
+			if (!we_support_multiple_80211_cores(bus)) {
+				ssb_dprintk(KERN_INFO PFX "Ignoring additional "
+					    "802.11 core\n");
+				return -1;
+			}
+		}
+		break;
+	case SSB_DEV_EXTIF:
+#ifdef CONFIG_SSB_DRIVER_EXTIF
+		if (bus->extif.dev) {
+			ssb_printk(KERN_WARNING PFX
+				   "WARNING: Multiple EXTIFs found\n");
+			break;
+		}
+		bus->extif.dev = dev;
+#endif /* CONFIG_SSB_DRIVER_EXTIF */
+		break;
+	case SSB_DEV_CHIPCOMMON:
+		if (bus->chipco.dev) {
+			ssb_printk(KERN_WARNING PFX
+				   "WARNING: Multiple ChipCommon found\n");
+			break;
+		}
+		bus->chipco.dev = dev;
+		break;
+	case SSB_DEV_MIPS:
+	case SSB_DEV_MIPS_3302:
+#ifdef CONFIG_SSB_DRIVER_MIPS
+		if (bus->mipscore.dev) {
+			ssb_printk(KERN_WARNING PFX
+				   "WARNING: Multiple MIPS cores found\n");
+			break;
+		}
+		bus->mipscore.dev = dev;
+#endif /* CONFIG_SSB_DRIVER_MIPS */
+		break;
+	case SSB_DEV_PCI:
+	case SSB_DEV_PCIE:
+#ifdef CONFIG_SSB_DRIVER_PCICORE
+		if (bus->bustype == SSB_BUSTYPE_PCI) {
+			/* Ignore PCI cores on PCI-E cards.
+			 * Ignore PCI-E cores on PCI cards. */
+			if (dev->id.coreid == SSB_DEV_PCI) {
+				if (pci_is_pcie(bus->host_pci))
+					return -1;
+			} else {
+				if (!pci_is_pcie(bus->host_pci))
+					return -1;
+			}
+		}
+		if (bus->pcicore.dev) {
+			ssb_printk(KERN_WARNING PFX
+				   "WARNING: Multiple PCI(E) cores found\n");
+			break;
+		}
+		bus->pcicore.dev = dev;
+#endif /* CONFIG_SSB_DRIVER_PCICORE */
+		break;
+	case SSB_DEV_ETHERNET:
+		if (bus->bustype == SSB_BUSTYPE_PCI) {
+			if (bus->host_pci->vendor == PCI_VENDOR_ID_BROADCOM &&
+			    (bus->host_pci->device & 0xFF00) == 0x4300) {
+				/* This is a dangling ethernet core on a
+				 * wireless device. Ignore it. */
+				return -1;
+			}
+		}
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
 int ssb_bus_scan(struct ssb_bus *bus,
 		 unsigned long baseaddr)
 {
@@ -353,87 +443,8 @@ int ssb_bus_scan(struct ssb_bus *bus,
 		dev->ops = bus->ops;
 		dev->helpers = &ssb_helpers_sb;
 
-		printk(KERN_DEBUG PFX
-			    "Core %d found: %s "
-			    "(cc 0x%03X, rev 0x%02X, vendor 0x%04X)\n",
-			    i, ssb_core_name(dev->id.coreid),
-			    dev->id.coreid, dev->id.revision, dev->id.vendor);
-
-		switch (dev->id.coreid) {
-		case SSB_DEV_80211:
-			nr_80211_cores++;
-			if (nr_80211_cores > 1) {
-				if (!we_support_multiple_80211_cores(bus)) {
-					ssb_dprintk(KERN_INFO PFX "Ignoring additional "
-						    "802.11 core\n");
-					continue;
-				}
-			}
-			break;
-		case SSB_DEV_EXTIF:
-#ifdef CONFIG_SSB_DRIVER_EXTIF
-			if (bus->extif.dev) {
-				ssb_printk(KERN_WARNING PFX
-					   "WARNING: Multiple EXTIFs found\n");
-				break;
-			}
-			bus->extif.dev = dev;
-#endif /* CONFIG_SSB_DRIVER_EXTIF */
-			break;
-		case SSB_DEV_CHIPCOMMON:
-			if (bus->chipco.dev) {
-				ssb_printk(KERN_WARNING PFX
-					   "WARNING: Multiple ChipCommon found\n");
-				break;
-			}
-			bus->chipco.dev = dev;
-			break;
-		case SSB_DEV_MIPS:
-		case SSB_DEV_MIPS_3302:
-#ifdef CONFIG_SSB_DRIVER_MIPS
-			if (bus->mipscore.dev) {
-				ssb_printk(KERN_WARNING PFX
-					   "WARNING: Multiple MIPS cores found\n");
-				break;
-			}
-			bus->mipscore.dev = dev;
-#endif /* CONFIG_SSB_DRIVER_MIPS */
-			break;
-		case SSB_DEV_PCI:
-		case SSB_DEV_PCIE:
-#ifdef CONFIG_SSB_DRIVER_PCICORE
-			if (bus->bustype == SSB_BUSTYPE_PCI) {
-				/* Ignore PCI cores on PCI-E cards.
-				 * Ignore PCI-E cores on PCI cards. */
-				if (dev->id.coreid == SSB_DEV_PCI) {
-					if (pci_is_pcie(bus->host_pci))
-						continue;
-				} else {
-					if (!pci_is_pcie(bus->host_pci))
-						continue;
-				}
-			}
-			if (bus->pcicore.dev) {
-				ssb_printk(KERN_WARNING PFX
-					   "WARNING: Multiple PCI(E) cores found\n");
-				break;
-			}
-			bus->pcicore.dev = dev;
-#endif /* CONFIG_SSB_DRIVER_PCICORE */
-			break;
-		case SSB_DEV_ETHERNET:
-			if (bus->bustype == SSB_BUSTYPE_PCI) {
-				if (bus->host_pci->vendor == PCI_VENDOR_ID_BROADCOM &&
-				    (bus->host_pci->device & 0xFF00) == 0x4300) {
-					/* This is a dangling ethernet core on a
-					 * wireless device. Ignore it. */
-					continue;
-				}
-			}
-			break;
-		default:
-			break;
-		}
+		if (ssb_bus_check_core(dev, &nr_80211_cores, i) < 0)
+			continue;
 
 		dev_i++;
 	}
--- linux-wireless-testing.orig/drivers/ssb/ssb_private.h	2011-02-17 14:28:49.000000000 +0200
+++ linux-wireless-testing/drivers/ssb/ssb_private.h	2011-02-17 14:29:06.000000000 +0200
@@ -160,6 +160,8 @@ extern const char *ssb_core_name(u16 cor
 extern int ssb_bus_scan(struct ssb_bus *bus,
 			unsigned long baseaddr);
 extern void ssb_iounmap(struct ssb_bus *ssb);
+extern int ssb_bus_check_core(struct ssb_device *dev, int *nr_80211_cores,
+			      int corenum);
 
 
 /* sprom.c */



