Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blu0-omc2-s27.blu0.hotmail.com ([65.55.111.102]:21664 "EHLO
	blu0-omc2-s27.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752618Ab3ALKrM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jan 2013 05:47:12 -0500
Message-ID: <BLU0-SMTP98B4D57175D7A700330D59AC280@phx.gbl> (sfid-20130112_114717_852536_D2EEAD3C)
From: Nathan Hintz <nlhintz@hotmail.com>
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, hauke@hauke-m.de,
	Nathan Hintz <nlhintz@hotmail.com>
Subject: [PATCH 3/5] bcma: don't map/unmap a subset of the PCI config space
Date: Sat, 12 Jan 2013 02:46:15 -0800
In-Reply-To: <1357987577-20661-1-git-send-email-nlhintz@hotmail.com>
References: <1357987577-20661-1-git-send-email-nlhintz@hotmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For PCI config space access offsets < 256 for device '0',
bcma_extpci_write_config performs an 'ioremap_nocache' on a 4 byte
section of the PCI config space (an area that has already
previously been mapped), and then subsequently unmaps that 4 byte
section.  This can't be a good thing for future read access from
that now unmapped location.  Modify the config space writes to use
the existing access functions (similar to how it is done for the reads).

Signed-off-by: Nathan Hintz <nlhintz@hotmail.com>
---
 drivers/bcma/driver_pci_host.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/bcma/driver_pci_host.c b/drivers/bcma/driver_pci_host.c
index 187cc9f..e1381ba 100644
--- a/drivers/bcma/driver_pci_host.c
+++ b/drivers/bcma/driver_pci_host.c
@@ -149,7 +149,7 @@ static int bcma_extpci_write_config(struct bcma_drv_pci *pc, unsigned int dev,
 				   const void *buf, int len)
 {
 	int err = -EINVAL;
-	u32 addr = 0, val = 0;
+	u32 addr, val;
 	void __iomem *mmio = 0;
 	u16 chipid = pc->core->bus->chipinfo.id;
 
@@ -165,12 +165,10 @@ static int bcma_extpci_write_config(struct bcma_drv_pci *pc, unsigned int dev,
 		 * requires indirect access.
 		 */
 		if (off < PCI_CONFIG_SPACE_SIZE) {
-			addr = pc->core->addr + BCMA_CORE_PCI_PCICFG0;
+			addr = BCMA_CORE_PCI_PCICFG0;
 			addr |= (func << 8);
 			addr |= (off & 0xfc);
-			mmio = ioremap_nocache(addr, sizeof(val));
-			if (!mmio)
-				goto out;
+			val = pcicore_read32(pc, addr);
 		}
 	} else {
 		addr = bcma_get_cfgspace_addr(pc, dev, func, off);
@@ -189,12 +187,10 @@ static int bcma_extpci_write_config(struct bcma_drv_pci *pc, unsigned int dev,
 
 	switch (len) {
 	case 1:
-		val = readl(mmio);
 		val &= ~(0xFF << (8 * (off & 3)));
 		val |= *((const u8 *)buf) << (8 * (off & 3));
 		break;
 	case 2:
-		val = readl(mmio);
 		val &= ~(0xFFFF << (8 * (off & 3)));
 		val |= *((const u16 *)buf) << (8 * (off & 3));
 		break;
@@ -202,13 +198,17 @@ static int bcma_extpci_write_config(struct bcma_drv_pci *pc, unsigned int dev,
 		val = *((const u32 *)buf);
 		break;
 	}
-	if (dev == 0 && !addr) {
+	if (dev == 0) {
 		/* accesses to config registers with offsets >= 256
 		 * requires indirect access.
 		 */
-		addr = (func << 12);
-		addr |= (off & 0x0FFF);
-		bcma_pcie_write_config(pc, addr, val);
+		if (off >= PCI_CONFIG_SPACE_SIZE) {
+			addr = (func << 12);
+			addr |= (off & 0x0FFF);
+			bcma_pcie_write_config(pc, addr, val);
+		} else {
+			pcicore_write32(pc, addr, val);
+		}
 	} else {
 		writel(val, mmio);
 
-- 
1.7.7.6

