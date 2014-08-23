Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from test.hauke-m.de ([5.39.93.123]:43261 "EHLO test.hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbaHWP6V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Aug 2014 11:58:21 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Cc: zajec5@gmail.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2] bcma: add PCI ID for spromless BCM43217
Date: Sat, 23 Aug 2014 17:58:11 +0200
Message-Id: <1408809491-14081-1-git-send-email-hauke@hauke-m.de> (sfid-20140823_175824_233329_23B1CCF9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds the PCI ID a BCM43217 without a sprom.
This devices was found on a Netgear R6250 attached to a BCM4708 ARM SoC.

bcma: bus1: Found chip with id 0xA8D1, rev 0x00 and package 0x08
bcma: bus1: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x27, class 0x0)
bcma: bus1: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x1E, class 0x0)
bcma: bus1: Core 2 found: PCIe (manuf 0x4BF, id 0x820, rev 0x14, class 0x0)

b43-phy0: Broadcom 43217 WLAN found (core revision 30)
b43-phy0: Found PHY: Analog 9, Type 4 (N), Revision 17
b43-phy0: Found Radio: Manuf 0x17F, ID 0x2057, Revision 14, Version 1

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
v2:
 - change comment: this is actually a BCM43217 and add some logs
 - add comment with pci id in hex

 drivers/bcma/host_pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
index 294a7dd..f032ed6 100644
--- a/drivers/bcma/host_pci.c
+++ b/drivers/bcma/host_pci.c
@@ -282,6 +282,7 @@ static const struct pci_device_id bcma_pci_bridge_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x43a9) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x43aa) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4727) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 43227) },	/* 0xA8DB */
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, bcma_pci_bridge_tbl);
-- 
1.9.1

