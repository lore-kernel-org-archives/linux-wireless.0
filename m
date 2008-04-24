Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:52702 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbYDXSJI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2008 14:09:08 -0400
From: Michael Buesch <mb@bu3sch.de>
To: stable@kernel.org
Subject: [PATCH stable 3/4] b43: Add more btcoexist workarounds
Date: Thu, 24 Apr 2008 20:04:38 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200804242004.39249.mb@bu3sch.de> (sfid-20080424_200943_428563_77584B79)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds more workarounds for devices with broken BT bits.

This patch is in wireless-testing.git, commit
4b43b16f74b362d4d2ce7df5b761eb838dfd5d32

Signed-off-by: Michael Buesch <mb@bu3sch.de>


Index: linux-2.6.25/drivers/net/wireless/b43/main.c
===================================================================
--- linux-2.6.25.orig/drivers/net/wireless/b43/main.c	2008-04-19 18:32:08.000000000 +0200
+++ linux-2.6.25/drivers/net/wireless/b43/main.c	2008-04-19 18:32:08.000000000 +0200
@@ -4009,6 +4009,12 @@ static int b43_one_core_attach(struct ss
 	return err;
 }
 
+#define IS_PDEV(pdev, _vendor, _device, _subvendor, _subdevice)		( \
+	(pdev->vendor == PCI_VENDOR_ID_##_vendor) &&			\
+	(pdev->device == _device) &&					\
+	(pdev->subsystem_vendor == PCI_VENDOR_ID_##_subvendor) &&	\
+	(pdev->subsystem_device == _subdevice)				)
+
 static void b43_sprom_fixup(struct ssb_bus *bus)
 {
 	struct pci_dev *pdev;
@@ -4022,10 +4028,9 @@ static void b43_sprom_fixup(struct ssb_b
 		bus->sprom.boardflags_lo |= B43_BFL_PACTRL;
 	if (bus->bustype == SSB_BUSTYPE_PCI) {
 		pdev = bus->host_pci;
-		if (pdev->vendor == PCI_VENDOR_ID_BROADCOM &&
-		    pdev->device == 0x4318 &&
-		    pdev->subsystem_vendor == PCI_VENDOR_ID_ASUSTEK &&
-		    pdev->subsystem_device == 0x100F)
+		if (IS_PDEV(pdev, BROADCOM, 0x4318, ASUSTEK, 0x100F) ||
+		    IS_PDEV(pdev, BROADCOM, 0x4320, LINKSYS, 0x0015) ||
+		    IS_PDEV(pdev, BROADCOM, 0x4320, LINKSYS, 0x0013))
 			bus->sprom.boardflags_lo &= ~B43_BFL_BTCOEXIST;
 	}
 }
