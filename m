Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:34848 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762646AbbA3RXI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 12:23:08 -0500
Received: by mail-wg0-f54.google.com with SMTP id b13so27998112wgh.13
        for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2015 09:23:07 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>, brcm80211-dev-list@broadcom.com,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 4/4] bcma: enable support for PCIe Gen 2 host devices
Date: Fri, 30 Jan 2015 18:22:46 +0100
Message-Id: <1422638566-7593-4-git-send-email-zajec5@gmail.com> (sfid-20150130_182313_646444_3EBE401A)
In-Reply-To: <1422638566-7593-1-git-send-email-zajec5@gmail.com>
References: <1422638566-7593-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/bcma_private.h |  1 +
 drivers/bcma/host_pci.c     | 15 ++++++++++++++-
 drivers/bcma/main.c         |  2 +-
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index 3692912..29565e3 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -26,6 +26,7 @@ bool bcma_wait_value(struct bcma_device *core, u16 reg, u32 mask, u32 value,
 		     int timeout);
 void bcma_prepare_core(struct bcma_bus *bus, struct bcma_device *core);
 void bcma_init_bus(struct bcma_bus *bus);
+void bcma_unregister_cores(struct bcma_bus *bus);
 int bcma_bus_register(struct bcma_bus *bus);
 void bcma_bus_unregister(struct bcma_bus *bus);
 int __init bcma_bus_early_register(struct bcma_bus *bus);
diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
index 5fb87a8..a62a2f9 100644
--- a/drivers/bcma/host_pci.c
+++ b/drivers/bcma/host_pci.c
@@ -213,16 +213,26 @@ static int bcma_host_pci_probe(struct pci_dev *dev,
 	/* Initialize struct, detect chip */
 	bcma_init_bus(bus);
 
+	/* Scan bus to find out generation of PCIe core */
+	err = bcma_bus_scan(bus);
+	if (err)
+		goto err_pci_unmap_mmio;
+
+	if (bcma_find_core(bus, BCMA_CORE_PCIE2))
+		bus->host_is_pcie2 = true;
+
 	/* Register */
 	err = bcma_bus_register(bus);
 	if (err)
-		goto err_pci_unmap_mmio;
+		goto err_unregister_cores;
 
 	pci_set_drvdata(dev, bus);
 
 out:
 	return err;
 
+err_unregister_cores:
+	bcma_unregister_cores(bus);
 err_pci_unmap_mmio:
 	pci_iounmap(dev, bus->mmio);
 err_pci_release_regions:
@@ -283,9 +293,12 @@ static const struct pci_device_id bcma_pci_bridge_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4357) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4358) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4359) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4360) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4365) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x43a0) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x43a9) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x43aa) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x43b1) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4727) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 43227) },	/* 0xa8db, BCM43217 (sic!) */
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 43228) },	/* 0xa8dc */
diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 38bde6e..9635f10 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -363,7 +363,7 @@ static int bcma_register_devices(struct bcma_bus *bus)
 	return 0;
 }
 
-static void bcma_unregister_cores(struct bcma_bus *bus)
+void bcma_unregister_cores(struct bcma_bus *bus)
 {
 	struct bcma_device *core, *tmp;
 
-- 
1.8.4.5

