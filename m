Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50038 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754360AbcK1H5P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Nov 2016 02:57:15 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: zajec5@gmail.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH] bcma: add Dell Inspiron 3148
Date: Mon, 28 Nov 2016 08:57:12 +0100
Message-Id: <20161128075712.10785-1-jslaby@suse.cz> (sfid-20161128_085742_294592_8556A591)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is what is in the laptop:
01:00.0 Network controller [0280]: Broadcom Limited BCM43142 802.11b/g/n [14e4:4365] (rev 01)
        Subsystem: Dell Device [1028:0018]
        Flags: bus master, fast devsel, latency 0, IRQ 18
        Memory at b0400000 (64-bit, non-prefetchable) [size=32K]
        Capabilities: [40] Power Management version 3
        Capabilities: [58] Vendor Specific Information: Len=78 <?>
        Capabilities: [48] MSI: Enable- Count=1/1 Maskable- 64bit+
        Capabilities: [d0] Express Endpoint, MSI 00
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [13c] Virtual Channel
        Capabilities: [160] Device Serial Number 00-00-9a-ff-ff-f3-40-b8
        Capabilities: [16c] Power Budgeting <?>

With the patch, I can see:
bcma: bus0: Found chip with id 43142, rev 0x01 and package 0x08
bcma: bus0: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x28, class 0x0)
bcma: bus0: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x21, class 0x0)
bcma: bus0: Core 2 found: PCIe (manuf 0x4BF, id 0x820, rev 0x16, class 0x0)
bcma: bus0: Core 3 found: UNKNOWN (manuf 0x43B, id 0x368, rev 0x00, class 0x0)
bcma: bus0: Bus registered

The wifi is not currently supported by brcmsmac yet:
brcmsmac bcma1:1: mfg 4bf core 812 rev 33 class 0 irq 18
brcmsmac: unknown device id 4365

So don't expect a working wifi from this patch :).

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Rafał Miłecki <zajec5@gmail.com>
Cc: <linux-wireless@vger.kernel.org>
---
 drivers/bcma/host_pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
index bd46569e0e52..925842996986 100644
--- a/drivers/bcma/host_pci.c
+++ b/drivers/bcma/host_pci.c
@@ -295,6 +295,7 @@ static const struct pci_device_id bcma_pci_bridge_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4359) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4360) },
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_BROADCOM, 0x4365, PCI_VENDOR_ID_DELL, 0x0016) },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_BROADCOM, 0x4365, PCI_VENDOR_ID_DELL, 0x0018) },
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_BROADCOM, 0x4365, PCI_VENDOR_ID_FOXCONN, 0xe092) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x43a0) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x43a9) },
-- 
2.10.2
