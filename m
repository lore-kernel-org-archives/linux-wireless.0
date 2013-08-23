Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51223 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756154Ab3HWWct (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 18:32:49 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 4/5] bcma: add bcma_core_pci_power_save()
Date: Sat, 24 Aug 2013 00:32:33 +0200
Message-Id: <1377297154-14525-4-git-send-email-hauke@hauke-m.de> (sfid-20130824_003253_651175_EA8AE76F)
In-Reply-To: <1377297154-14525-1-git-send-email-hauke@hauke-m.de>
References: <1377297154-14525-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This enables or disables power saving on the PCIe bus when the wifi is
in operation or not.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_pci.c            |   36 +++++++++++++++++++++++++++++++---
 include/linux/bcma/bcma_driver_pci.h |   20 +++++++++++++++++++
 2 files changed, 53 insertions(+), 3 deletions(-)

diff --git a/drivers/bcma/driver_pci.c b/drivers/bcma/driver_pci.c
index d51d194..c9fd694 100644
--- a/drivers/bcma/driver_pci.c
+++ b/drivers/bcma/driver_pci.c
@@ -31,7 +31,7 @@ static void bcma_pcie_write(struct bcma_drv_pci *pc, u32 address, u32 data)
 	pcicore_write32(pc, BCMA_CORE_PCI_PCIEIND_DATA, data);
 }
 
-static void bcma_pcie_mdio_set_phy(struct bcma_drv_pci *pc, u8 phy)
+static void bcma_pcie_mdio_set_phy(struct bcma_drv_pci *pc, u16 phy)
 {
 	u32 v;
 	int i;
@@ -55,7 +55,7 @@ static void bcma_pcie_mdio_set_phy(struct bcma_drv_pci *pc, u8 phy)
 	}
 }
 
-static u16 bcma_pcie_mdio_read(struct bcma_drv_pci *pc, u8 device, u8 address)
+static u16 bcma_pcie_mdio_read(struct bcma_drv_pci *pc, u16 device, u8 address)
 {
 	int max_retries = 10;
 	u16 ret = 0;
@@ -98,7 +98,7 @@ static u16 bcma_pcie_mdio_read(struct bcma_drv_pci *pc, u8 device, u8 address)
 	return ret;
 }
 
-static void bcma_pcie_mdio_write(struct bcma_drv_pci *pc, u8 device,
+static void bcma_pcie_mdio_write(struct bcma_drv_pci *pc, u16 device,
 				u8 address, u16 data)
 {
 	int max_retries = 10;
@@ -137,6 +137,13 @@ static void bcma_pcie_mdio_write(struct bcma_drv_pci *pc, u8 device,
 	pcicore_write32(pc, BCMA_CORE_PCI_MDIO_CONTROL, 0);
 }
 
+static u16 bcma_pcie_mdio_writeread(struct bcma_drv_pci *pc, u16 device,
+				    u8 address, u16 data)
+{
+	bcma_pcie_mdio_write(pc, device, address, data);
+	return bcma_pcie_mdio_read(pc, device, address);
+}
+
 /**************************************************
  * Workarounds.
  **************************************************/
@@ -203,6 +210,25 @@ static void bcma_core_pci_config_fixup(struct bcma_drv_pci *pc)
 	}
 }
 
+static void bcma_core_pci_power_save(struct bcma_drv_pci *pc, bool up)
+{
+	u16 data;
+
+	if (pc->core->id.rev >= 15 && pc->core->id.rev <= 20) {
+		data = up ? 0x74 : 0x7C;
+		bcma_pcie_mdio_writeread(pc, BCMA_CORE_PCI_MDIO_BLK1,
+					 BCMA_CORE_PCI_MDIO_BLK1_MGMT1, 0x7F64);
+		bcma_pcie_mdio_writeread(pc, BCMA_CORE_PCI_MDIO_BLK1,
+					 BCMA_CORE_PCI_MDIO_BLK1_MGMT3, data);
+	} else if (pc->core->id.rev >= 21 && pc->core->id.rev <= 22) {
+		data = up ? 0x75 : 0x7D;
+		bcma_pcie_mdio_writeread(pc, BCMA_CORE_PCI_MDIO_BLK1,
+					 BCMA_CORE_PCI_MDIO_BLK1_MGMT1, 0x7E65);
+		bcma_pcie_mdio_writeread(pc, BCMA_CORE_PCI_MDIO_BLK1,
+					 BCMA_CORE_PCI_MDIO_BLK1_MGMT3, data);
+	}
+}
+
 /**************************************************
  * Init.
  **************************************************/
@@ -284,6 +310,8 @@ void bcma_core_pci_up(struct bcma_bus *bus)
 
 	pc = &bus->drv_pci[0];
 
+	bcma_core_pci_power_save(pc, true);
+
 	bcma_core_pci_extend_L1timer(pc, true);
 }
 EXPORT_SYMBOL_GPL(bcma_core_pci_up);
@@ -298,5 +326,7 @@ void bcma_core_pci_down(struct bcma_bus *bus)
 	pc = &bus->drv_pci[0];
 
 	bcma_core_pci_extend_L1timer(pc, false);
+
+	bcma_core_pci_power_save(pc, false);
 }
 EXPORT_SYMBOL_GPL(bcma_core_pci_down);
diff --git a/include/linux/bcma/bcma_driver_pci.h b/include/linux/bcma/bcma_driver_pci.h
index 0234955..d66033f 100644
--- a/include/linux/bcma/bcma_driver_pci.h
+++ b/include/linux/bcma/bcma_driver_pci.h
@@ -181,6 +181,26 @@ struct pci_dev;
 
 #define BCMA_CORE_PCI_CFG_DEVCTRL		0xd8
 
+#define BCMA_CORE_PCI_
+
+/* MDIO devices (SERDES modules) */
+#define BCMA_CORE_PCI_MDIO_IEEE0		0x000
+#define BCMA_CORE_PCI_MDIO_IEEE1		0x001
+#define BCMA_CORE_PCI_MDIO_BLK0			0x800
+#define BCMA_CORE_PCI_MDIO_BLK1			0x801
+#define  BCMA_CORE_PCI_MDIO_BLK1_MGMT0		0x16
+#define  BCMA_CORE_PCI_MDIO_BLK1_MGMT1		0x17
+#define  BCMA_CORE_PCI_MDIO_BLK1_MGMT2		0x18
+#define  BCMA_CORE_PCI_MDIO_BLK1_MGMT3		0x19
+#define  BCMA_CORE_PCI_MDIO_BLK1_MGMT4		0x1A
+#define BCMA_CORE_PCI_MDIO_BLK2			0x802
+#define BCMA_CORE_PCI_MDIO_BLK3			0x803
+#define BCMA_CORE_PCI_MDIO_BLK4			0x804
+#define BCMA_CORE_PCI_MDIO_TXPLL		0x808	/* TXPLL register block idx */
+#define BCMA_CORE_PCI_MDIO_TXCTRL0		0x820
+#define BCMA_CORE_PCI_MDIO_SERDESID		0x831
+#define BCMA_CORE_PCI_MDIO_RXCTRL0		0x840
+
 /* PCIE Root Capability Register bits (Host mode only) */
 #define BCMA_CORE_PCI_RC_CRS_VISIBILITY		0x0001
 
-- 
1.7.10.4

