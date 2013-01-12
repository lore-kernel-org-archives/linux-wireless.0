Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blu0-omc2-s30.blu0.hotmail.com ([65.55.111.105]:31849 "EHLO
	blu0-omc2-s30.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752618Ab3ALKrT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jan 2013 05:47:19 -0500
Message-ID: <BLU0-SMTP988620BB0129B03EE7F0EBAC280@phx.gbl> (sfid-20130112_114721_844981_C6A69486)
From: Nathan Hintz <nlhintz@hotmail.com>
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, hauke@hauke-m.de,
	Nathan Hintz <nlhintz@hotmail.com>
Subject: [PATCH 5/5] bcma: use consistent case for 'hex' constants
Date: Sat, 12 Jan 2013 02:46:17 -0800
In-Reply-To: <1357987577-20661-1-git-send-email-nlhintz@hotmail.com>
References: <1357987577-20661-1-git-send-email-nlhintz@hotmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Nathan Hintz <nlhintz@hotmail.com>
---
 drivers/bcma/driver_pci_host.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/bcma/driver_pci_host.c b/drivers/bcma/driver_pci_host.c
index 92800b4..d3bde6c 100644
--- a/drivers/bcma/driver_pci_host.c
+++ b/drivers/bcma/driver_pci_host.c
@@ -106,7 +106,7 @@ static int bcma_extpci_read_config(struct bcma_drv_pci *pc, unsigned int dev,
 		} else {
 			addr = BCMA_CORE_PCI_PCICFG0;
 			addr |= (func << 8);
-			addr |= (off & 0xfc);
+			addr |= (off & 0xFC);
 			val = pcicore_read32(pc, addr);
 		}
 	} else {
@@ -119,7 +119,7 @@ static int bcma_extpci_read_config(struct bcma_drv_pci *pc, unsigned int dev,
 			goto out;
 
 		if (mips_busprobe32(val, mmio)) {
-			val = 0xffffffff;
+			val = 0xFFFFFFFF;
 			goto unmap;
 		}
 	}
@@ -171,7 +171,7 @@ static int bcma_extpci_write_config(struct bcma_drv_pci *pc, unsigned int dev,
 		} else {
 			addr = BCMA_CORE_PCI_PCICFG0;
 			addr |= (func << 8);
-			addr |= (off & 0xfc);
+			addr |= (off & 0xFC);
 			val = pcicore_read32(pc, addr);
 		}
 	} else {
@@ -184,7 +184,7 @@ static int bcma_extpci_write_config(struct bcma_drv_pci *pc, unsigned int dev,
 			goto out;
 
 		if (mips_busprobe32(val, mmio)) {
-			val = 0xffffffff;
+			val = 0xFFFFFFFF;
 			goto unmap;
 		}
 	}
@@ -279,7 +279,7 @@ static u8 bcma_find_pci_capability(struct bcma_drv_pci *pc, unsigned int dev,
 	/* check for Header type 0 */
 	bcma_extpci_read_config(pc, dev, func, PCI_HEADER_TYPE, &byte_val,
 				sizeof(u8));
-	if ((byte_val & 0x7f) != PCI_HEADER_TYPE_NORMAL)
+	if ((byte_val & 0x7F) != PCI_HEADER_TYPE_NORMAL)
 		return cap_ptr;
 
 	/* check if the capability pointer field exists */
-- 
1.7.7.6

