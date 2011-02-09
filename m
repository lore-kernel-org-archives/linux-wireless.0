Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:21895 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755892Ab1BIOpO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 09:45:14 -0500
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000019984.msg
	for <linux-wireless@vger.kernel.org>; Wed, 09 Feb 2011 16:44:38 +0200
Subject: Re: SSB AI support code ([RFC6/11] SSB introduce bus_check_core
	routine)
From: George Kashperko <george@znau.edu.ua>
To: George Kashperko <george@znau.edu.ua>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1297258590.17400.37.camel@dev.znau.edu.ua>
References: <1297258590.17400.37.camel@dev.znau.edu.ua>
Content-Type: text/plain
Date: Wed, 09 Feb 2011 16:37:45 +0200
Message-Id: <1297262265.18053.30.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: George Kashperko <george@znau.edu.ua>

Move part of the SB-style bus scan code into separate routine
in order to reuse it later with AI-style bus scan.
Signed-off-by: George Kashperko <george@znau.edu.ua>
---
 drivers/ssb/scan.c        |  172 +++++++++++++++++++-----------------
 drivers/ssb/ssb_private.h |    6 +
 2 files changed, 96 insertions(+), 82 deletions(-)
--- linux-next-20110203.orig/drivers/ssb/scan.c	2011-02-06 02:39:46.000000000 +0200
+++ linux-next-20110203/drivers/ssb/scan.c	2011-02-06 02:45:21.000000000 +0200
@@ -265,6 +265,95 @@ static int we_support_multiple_80211_cor
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
+	return 0;
+}
+
 int ssb_bus_scan(struct ssb_bus *bus,
 		 unsigned long baseaddr)
 {
@@ -352,87 +441,8 @@ int ssb_bus_scan(struct ssb_bus *bus,
 		dev->bus = bus;
 		dev->ops = bus->ops;
 
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
--- linux-next-20110203.orig/drivers/ssb/ssb_private.h	2011-02-06 02:39:46.000000000 +0200
+++ linux-next-20110203/drivers/ssb/ssb_private.h	2011-02-06 02:31:47.000000000 +0200
@@ -191,7 +191,6 @@ extern int ssb_devices_freeze(struct ssb
 extern int ssb_devices_thaw(struct ssb_freeze_context *ctx);
 
 
-
 /* b43_pci_bridge.c */
 #ifdef CONFIG_SSB_B43_PCI_BRIDGE
 extern int __init b43_pci_ssb_bridge_init(void);
@@ -206,6 +205,11 @@ static inline void b43_pci_ssb_bridge_ex
 }
 #endif /* CONFIG_SSB_B43_PCI_BRIDGE */
 
+
+/* Search support routines */
+extern int ssb_bus_check_core(struct ssb_device *dev, int *nr_80211_cores,
+			      int corenum);
+
 /* SB-style bus core control and state registers */
 #define SSB_TMSLOW		0x0F98     /* SB Target State Low */
 #define  SSB_TMSLOW_RESET	0x00000001 /* Reset */



