Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59394 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826Ab1D0PCS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2011 11:02:18 -0400
Received: by bwz15 with SMTP id 15so1455241bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 27 Apr 2011 08:02:17 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?q?Michael=20B=C3=BCsch?= <mb@bu3sch.de>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2] ssb: pci: separate workarounds
Date: Wed, 27 Apr 2011 17:39:47 +0200
Message-Id: <1303918788-4903-1-git-send-email-zajec5@gmail.com> (sfid-20110427_170222_322429_A25C8E47)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/ssb/driver_pcicore.c |   98 +++++++++++++++++++++++++-----------------
 1 files changed, 58 insertions(+), 40 deletions(-)

diff --git a/drivers/ssb/driver_pcicore.c b/drivers/ssb/driver_pcicore.c
index dbda168..adde4f0 100644
--- a/drivers/ssb/driver_pcicore.c
+++ b/drivers/ssb/driver_pcicore.c
@@ -21,6 +21,8 @@ static u16 ssb_pcie_mdio_read(struct ssb_pcicore *pc, u8 device, u8 address);
 static void ssb_pcie_mdio_write(struct ssb_pcicore *pc, u8 device,
 				u8 address, u16 data);
 
+static void ssb_commit_settings(struct ssb_bus *bus);
+
 static inline
 u32 pcicore_read32(struct ssb_pcicore *pc, u16 offset)
 {
@@ -430,6 +432,60 @@ static void ssb_pcicore_serdes_workaround(struct ssb_pcicore *pc)
 		ssb_pcie_mdio_write(pc, serdes_pll_device, 1, tmp & ~0x4000);
 }
 
+static void ssb_pcicore_pci_setup_workarounds(struct ssb_pcicore *pc)
+{
+	struct ssb_device *pdev = pc->dev;
+	struct ssb_bus *bus = pdev->bus;
+	u32 tmp;
+
+	tmp = pcicore_read32(pc, SSB_PCICORE_SBTOPCI2);
+	tmp |= SSB_PCICORE_SBTOPCI_PREF;
+	tmp |= SSB_PCICORE_SBTOPCI_BURST;
+	pcicore_write32(pc, SSB_PCICORE_SBTOPCI2, tmp);
+
+	if (pdev->id.revision < 5) {
+		tmp = ssb_read32(pdev, SSB_IMCFGLO);
+		tmp &= ~SSB_IMCFGLO_SERTO;
+		tmp |= 2;
+		tmp &= ~SSB_IMCFGLO_REQTO;
+		tmp |= 3 << SSB_IMCFGLO_REQTO_SHIFT;
+		ssb_write32(pdev, SSB_IMCFGLO, tmp);
+		ssb_commit_settings(bus);
+	} else if (pdev->id.revision >= 11) {
+		tmp = pcicore_read32(pc, SSB_PCICORE_SBTOPCI2);
+		tmp |= SSB_PCICORE_SBTOPCI_MRM;
+		pcicore_write32(pc, SSB_PCICORE_SBTOPCI2, tmp);
+	}
+}
+
+static void ssb_pcicore_pcie_setup_workarounds(struct ssb_pcicore *pc)
+{
+	struct ssb_device *pdev = pc->dev;
+	u32 tmp;
+
+	if ((pdev->id.revision == 0) || (pdev->id.revision == 1)) {
+		/* TLP Workaround register. */
+		tmp = ssb_pcie_read(pc, 0x4);
+		tmp |= 0x8;
+		ssb_pcie_write(pc, 0x4, tmp);
+	}
+	if (pdev->id.revision == 0) {
+		const u8 serdes_rx_device = 0x1F;
+
+		ssb_pcie_mdio_write(pc, serdes_rx_device,
+					2 /* Timer */, 0x8128);
+		ssb_pcie_mdio_write(pc, serdes_rx_device,
+					6 /* CDR */, 0x0100);
+		ssb_pcie_mdio_write(pc, serdes_rx_device,
+					7 /* CDR BW */, 0x1466);
+	} else if (pdev->id.revision == 1) {
+		/* DLLP Link Control register. */
+		tmp = ssb_pcie_read(pc, 0x100);
+		tmp |= 0x40;
+		ssb_pcie_write(pc, 0x100, tmp);
+	}
+}
+
 /**************************************************
  * Generic and Clientmode operation code.
  **************************************************/
@@ -646,48 +702,10 @@ int ssb_pcicore_dev_irqvecs_enable(struct ssb_pcicore *pc,
 	if (pc->setup_done)
 		goto out;
 	if (pdev->id.coreid == SSB_DEV_PCI) {
-		tmp = pcicore_read32(pc, SSB_PCICORE_SBTOPCI2);
-		tmp |= SSB_PCICORE_SBTOPCI_PREF;
-		tmp |= SSB_PCICORE_SBTOPCI_BURST;
-		pcicore_write32(pc, SSB_PCICORE_SBTOPCI2, tmp);
-
-		if (pdev->id.revision < 5) {
-			tmp = ssb_read32(pdev, SSB_IMCFGLO);
-			tmp &= ~SSB_IMCFGLO_SERTO;
-			tmp |= 2;
-			tmp &= ~SSB_IMCFGLO_REQTO;
-			tmp |= 3 << SSB_IMCFGLO_REQTO_SHIFT;
-			ssb_write32(pdev, SSB_IMCFGLO, tmp);
-			ssb_commit_settings(bus);
-		} else if (pdev->id.revision >= 11) {
-			tmp = pcicore_read32(pc, SSB_PCICORE_SBTOPCI2);
-			tmp |= SSB_PCICORE_SBTOPCI_MRM;
-			pcicore_write32(pc, SSB_PCICORE_SBTOPCI2, tmp);
-		}
+		ssb_pcicore_pci_setup_workarounds(pc);
 	} else {
 		WARN_ON(pdev->id.coreid != SSB_DEV_PCIE);
-		//TODO: Better make defines for all these magic PCIE values.
-		if ((pdev->id.revision == 0) || (pdev->id.revision == 1)) {
-			/* TLP Workaround register. */
-			tmp = ssb_pcie_read(pc, 0x4);
-			tmp |= 0x8;
-			ssb_pcie_write(pc, 0x4, tmp);
-		}
-		if (pdev->id.revision == 0) {
-			const u8 serdes_rx_device = 0x1F;
-
-			ssb_pcie_mdio_write(pc, serdes_rx_device,
-					    2 /* Timer */, 0x8128);
-			ssb_pcie_mdio_write(pc, serdes_rx_device,
-					    6 /* CDR */, 0x0100);
-			ssb_pcie_mdio_write(pc, serdes_rx_device,
-					    7 /* CDR BW */, 0x1466);
-		} else if (pdev->id.revision == 1) {
-			/* DLLP Link Control register. */
-			tmp = ssb_pcie_read(pc, 0x100);
-			tmp |= 0x40;
-			ssb_pcie_write(pc, 0x100, tmp);
-		}
+		ssb_pcicore_pcie_setup_workarounds(pc);
 	}
 	pc->setup_done = 1;
 out:
-- 
1.7.3.4

