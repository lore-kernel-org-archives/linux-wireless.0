Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:56768 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbYACSBP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2008 13:01:15 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] ssb: Fix probing of PCI cores if PCI and PCIE core is available
Date: Thu, 3 Jan 2008 18:59:25 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200801031859.25596.mb@bu3sch.de> (sfid-20080103_180124_861880_19E7C434)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will make sure that always the correct core is selected, even if
there are both a PCI and PCI-E core on a PCI or PCI-E card.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, as this is a bugfix it should probably go into 2.6.24.

Index: wireless-2.6/drivers/ssb/scan.c
===================================================================
--- wireless-2.6.orig/drivers/ssb/scan.c	2008-01-02 18:49:22.000000000 +0100
+++ wireless-2.6/drivers/ssb/scan.c	2008-01-03 18:56:30.000000000 +0100
@@ -388,6 +388,17 @@ int ssb_bus_scan(struct ssb_bus *bus,
 		case SSB_DEV_PCI:
 		case SSB_DEV_PCIE:
 #ifdef CONFIG_SSB_DRIVER_PCICORE
+			if (bus->bustype == SSB_BUSTYPE_PCI) {
+				/* Ignore PCI cores on PCI-E cards.
+				 * Ignore PCI-E cores on PCI cards. */
+				if (dev->id.coreid == SSB_DEV_PCI) {
+					if (bus->host_pci->is_pcie)
+						continue;
+				} else {
+					if (!bus->host_pci->is_pcie)
+						continue;
+				}
+			}
 			if (bus->pcicore.dev) {
 				ssb_printk(KERN_WARNING PFX
 					   "WARNING: Multiple PCI(E) cores found\n");
