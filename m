Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:41553 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbYDSOy3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Apr 2008 10:54:29 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Add more btcoexist workarounds
Date: Sat, 19 Apr 2008 16:53:00 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200804191653.00459.mb@bu3sch.de> (sfid-20080419_155433_601830_028E9F37)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds more workarounds for devices with broken BT bits.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, this is for 2.6.26


Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-04-18 21:00:58.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2008-04-19 16:43:36.000000000 +0200
@@ -4420,12 +4420,18 @@ static int b43_one_core_attach(struct ss
 
       err_kfree_wldev:
 	kfree(wldev);
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
 
 	/* boardflags workarounds */
 	if (bus->boardinfo.vendor == SSB_BOARDVENDOR_DELL &&
@@ -4433,16 +4439,15 @@ static void b43_sprom_fixup(struct ssb_b
 		bus->sprom.boardflags_lo |= B43_BFL_BTCOEXIST;
 	if (bus->boardinfo.vendor == PCI_VENDOR_ID_APPLE &&
 	    bus->boardinfo.type == 0x4E && bus->boardinfo.rev > 0x40)
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
 
 static void b43_wireless_exit(struct ssb_device *dev, struct b43_wl *wl)
 {
