Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blu0-omc2-s13.blu0.hotmail.com ([65.55.111.88]:9075 "EHLO
	blu0-omc2-s13.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752618Ab3ALKrP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jan 2013 05:47:15 -0500
Message-ID: <BLU0-SMTP989EDC8A841E1B9D693EC8AC280@phx.gbl> (sfid-20130112_114719_535353_EBBECE28)
From: Nathan Hintz <nlhintz@hotmail.com>
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, hauke@hauke-m.de,
	Nathan Hintz <nlhintz@hotmail.com>
Subject: [PATCH 4/5] bcma: add support for 1 and 2 byte extended config space access
Date: Sat, 12 Jan 2013 02:46:16 -0800
In-Reply-To: <1357987577-20661-1-git-send-email-nlhintz@hotmail.com>
References: <1357987577-20661-1-git-send-email-nlhintz@hotmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The sanity checks allow 1 and 2 byte reads/writes of the extended
PCI config space to proceed; however, the code only supports 4
byte reads/writes.  This patch adds support for 1 and 2 byte
reads/writes of the extended PCI config space.

Signed-off-by: Nathan Hintz <nlhintz@hotmail.com>
---
 drivers/bcma/driver_pci_host.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/bcma/driver_pci_host.c b/drivers/bcma/driver_pci_host.c
index e1381ba..92800b4 100644
--- a/drivers/bcma/driver_pci_host.c
+++ b/drivers/bcma/driver_pci_host.c
@@ -101,7 +101,7 @@ static int bcma_extpci_read_config(struct bcma_drv_pci *pc, unsigned int dev,
 		 */
 		if (off >= PCI_CONFIG_SPACE_SIZE) {
 			addr = (func << 12);
-			addr |= (off & 0x0FFF);
+			addr |= (off & 0x0FFC);
 			val = bcma_pcie_read_config(pc, addr);
 		} else {
 			addr = BCMA_CORE_PCI_PCICFG0;
@@ -164,7 +164,11 @@ static int bcma_extpci_write_config(struct bcma_drv_pci *pc, unsigned int dev,
 		/* accesses to config registers with offsets >= 256
 		 * requires indirect access.
 		 */
-		if (off < PCI_CONFIG_SPACE_SIZE) {
+		if (off >= PCI_CONFIG_SPACE_SIZE) {
+			addr = (func << 12);
+			addr |= (off & 0x0FFC);
+			val = bcma_pcie_read_config(pc, addr);
+		} else {
 			addr = BCMA_CORE_PCI_PCICFG0;
 			addr |= (func << 8);
 			addr |= (off & 0xfc);
@@ -202,13 +206,10 @@ static int bcma_extpci_write_config(struct bcma_drv_pci *pc, unsigned int dev,
 		/* accesses to config registers with offsets >= 256
 		 * requires indirect access.
 		 */
-		if (off >= PCI_CONFIG_SPACE_SIZE) {
-			addr = (func << 12);
-			addr |= (off & 0x0FFF);
+		if (off >= PCI_CONFIG_SPACE_SIZE)
 			bcma_pcie_write_config(pc, addr, val);
-		} else {
+		else
 			pcicore_write32(pc, addr, val);
-		}
 	} else {
 		writel(val, mmio);
 
-- 
1.7.7.6

