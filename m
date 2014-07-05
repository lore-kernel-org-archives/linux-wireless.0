Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:41338 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759AbaGEAsm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jul 2014 20:48:42 -0400
Received: by mail-wg0-f51.google.com with SMTP id x12so2088864wgg.10
        for <linux-wireless@vger.kernel.org>; Fri, 04 Jul 2014 17:48:40 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [RFC][PATCH] bcma: support for PCIe Gen 2 as host platform
Date: Sat,  5 Jul 2014 02:48:30 +0200
Message-Id: <1404521310-502-1-git-send-email-zajec5@gmail.com> (sfid-20140705_024845_443481_4F8D7472)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I dumped LNKCAP on most of my devices and it seems we can use
PCI_EXP_LNKCAP_SLS_5_0GB to determine if device is PCIe 2.0.

PCIe Gen 1:
14e4:4331	0x00176C11 (hint: PCI_EXP_LNKCAP_SLS_2_5GB)
14e4:4353	0x00176C11 (hint: PCI_EXP_LNKCAP_SLS_2_5GB)
14e4:4359	0x00176811 (hint: PCI_EXP_LNKCAP_SLS_2_5GB)
14e4:4365	0x00076C11 (hint: PCI_EXP_LNKCAP_SLS_2_5GB)
14e4:4727	0x00176C11 (hint: PCI_EXP_LNKCAP_SLS_2_5GB)

PCIe Gen 2:
14e4:4360	0x0046DC12 (hint: PCI_EXP_LNKCAP_SLS_5_0GB)
---
 drivers/bcma/host_pci.c        | 10 ++++++++--
 include/linux/bcma/bcma.h      |  1 +
 include/linux/bcma/bcma_regs.h |  2 ++
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
index e3333053..5328d05 100644
--- a/drivers/bcma/host_pci.c
+++ b/drivers/bcma/host_pci.c
@@ -13,10 +13,12 @@
 
 static void bcma_host_pci_switch_core(struct bcma_device *core)
 {
+	int win2 = core->bus->host_is_pcie2 ?
+		BCMA_PCIE2_BAR0_WIN2 : BCMA_PCI_BAR0_WIN2;
+
 	pci_write_config_dword(core->bus->host_pci, BCMA_PCI_BAR0_WIN,
 			       core->addr);
-	pci_write_config_dword(core->bus->host_pci, BCMA_PCI_BAR0_WIN2,
-			       core->wrap);
+	pci_write_config_dword(core->bus->host_pci, win2, core->wrap);
 	core->bus->mapped_core = core;
 	bcma_debug(core->bus, "Switched to core: 0x%X\n", core->id.id);
 }
@@ -194,6 +196,10 @@ static int bcma_host_pci_probe(struct pci_dev *dev,
 		goto err_pci_release_regions;
 	}
 
+	/* PCIe Gen 2 has some regs different */
+	pcie_capability_read_dword(dev, PCI_EXP_LNKCAP, &val);
+	bus->host_is_pcie2 = !!(val & PCI_EXP_LNKCAP_SLS_5_0GB);
+
 	/* Map MMIO */
 	err = -ENOMEM;
 	bus->mmio = pci_iomap(dev, 0, ~0UL);
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 452286a..9f98e2f 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -315,6 +315,7 @@ struct bcma_bus {
 	const struct bcma_host_ops *ops;
 
 	enum bcma_hosttype hosttype;
+	bool host_is_pcie2; /* Valid for BCMA_HOSTTYPE_PCI only */
 	union {
 		/* Pointer to the PCI bus (only for BCMA_HOSTTYPE_PCI) */
 		struct pci_dev *host_pci;
diff --git a/include/linux/bcma/bcma_regs.h b/include/linux/bcma/bcma_regs.h
index 917dcd7..d02f8b5 100644
--- a/include/linux/bcma/bcma_regs.h
+++ b/include/linux/bcma/bcma_regs.h
@@ -59,6 +59,8 @@
 #define  BCMA_PCI_GPIO_XTAL		0x40	/* PCI config space GPIO 14 for Xtal powerup */
 #define  BCMA_PCI_GPIO_PLL		0x80	/* PCI config space GPIO 15 for PLL powerdown */
 
+#define BCMA_PCIE2_BAR0_WIN2		0x70
+
 /* SiliconBackplane Address Map.
  * All regions may not exist on all chips.
  */
-- 
1.8.4.5

