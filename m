Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cyberdimension.org ([80.67.179.20]:48164 "EHLO
        lime1-a20.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751706AbeBHQcj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Feb 2018 11:32:39 -0500
From: Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: [PATCH] bcma: add HP Stream Notebook
Date: Thu,  8 Feb 2018 17:25:42 +0100
Message-Id: <20180208162542.20100-1-GNUtoo@no-log.org> (sfid-20180208_173256_691564_C2E9D719)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In this laptop we have the following PCI device:
02:00.0 Network controller [0280]: Broadcom Limited BCM43142 802.11b/g/n [14e4:4365] (rev 01)
	Subsystem: Hewlett-Packard Company BCM43142 802.11b/g/n [103c:804a]
	[...]
	Region 0: Memory at 91000000 (64-bit, non-prefetchable) [size=32K]
	[...]

With this patch, we can now see its WiFi chip:
  bcma: bus0: Found chip with id 43142, rev 0x01 and package 0x08
  bcma: bus0: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x28, class 0x0)
  bcma: bus0: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x21, class 0x0)
  bcma: bus0: Core 2 found: PCIe (manuf 0x4BF, id 0x820, rev 0x16, class 0x0)
  bcma: bus0: Core 3 found: UNKNOWN (manuf 0x43B, id 0x368, rev 0x00, class 0x0)
  bcma: bus0: Found rev 15 PMU (capabilities 0x518C5E0F)
  bcma: bus0: SPROM offset 0x840
  bcma: bus0: Found SPROM revision 10
  bcma: bus0: Workarounds unknown or not needed for device 0xA886
  bcma: bus0: Bus registered

But it not yet supported by brcmsmac so it won't work for now:
  brcmsmac bcma0:1: brcms_b_attach wl0: vendor 0x14e4 device 0x4365
  brcmsmac: unknown device id 4365

Signed-off-by: Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
---
 drivers/bcma/host_pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
index 925842996986..63410ecfe640 100644
--- a/drivers/bcma/host_pci.c
+++ b/drivers/bcma/host_pci.c
@@ -297,6 +297,7 @@ static const struct pci_device_id bcma_pci_bridge_tbl[] = {
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_BROADCOM, 0x4365, PCI_VENDOR_ID_DELL, 0x0016) },
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_BROADCOM, 0x4365, PCI_VENDOR_ID_DELL, 0x0018) },
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_BROADCOM, 0x4365, PCI_VENDOR_ID_FOXCONN, 0xe092) },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_BROADCOM, 0x4365, PCI_VENDOR_ID_HP, 0x804a) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x43a0) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x43a9) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x43aa) },
-- 
2.16.1
