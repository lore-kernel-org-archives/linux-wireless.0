Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blu0-omc2-s18.blu0.hotmail.com ([65.55.111.93]:23891 "EHLO
	blu0-omc2-s18.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750789Ab2EEE50 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 May 2012 00:57:26 -0400
Message-ID: <BLU0-SMTP1987E82C091C976034235C0AC2D0@phx.gbl> (sfid-20120505_065729_881637_ACC321BD)
From: Nathan Hintz <nlhintz@hotmail.com>
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, hauke@hauke-m.de,
	Nathan Hintz <nlhintz@hotmail.com>
Subject: [PATCH v3 4/6] bcma: reads/writes are always 4 bytes, so always map 4 bytes
Date: Fri, 4 May 2012 21:56:34 -0700
In-Reply-To: <1336193796-32599-1-git-send-email-nlhintz@hotmail.com>
References: <1336193796-32599-1-git-send-email-nlhintz@hotmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Modify ioremap_nocache calls to reflect the number of bytes read/written.

Signed-off-by: Nathan Hintz <nlhintz@hotmail.com>
---
 drivers/bcma/driver_pci_host.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/bcma/driver_pci_host.c b/drivers/bcma/driver_pci_host.c
index 8407b25..b9a86ed 100644
--- a/drivers/bcma/driver_pci_host.c
+++ b/drivers/bcma/driver_pci_host.c
@@ -119,7 +119,7 @@ static int bcma_extpci_read_config(struct bcma_drv_pci *pc, unsigned int dev,
 		if (unlikely(!addr))
 			goto out;
 		err = -ENOMEM;
-		mmio = ioremap_nocache(addr, len);
+		mmio = ioremap_nocache(addr, sizeof(val));
 		if (!mmio)
 			goto out;
 
@@ -171,7 +171,7 @@ static int bcma_extpci_write_config(struct bcma_drv_pci *pc, unsigned int dev,
 			addr = pc->core->addr + BCMA_CORE_PCI_PCICFG0;
 			addr |= (func << 8);
 			addr |= (off & 0xfc);
-			mmio = ioremap_nocache(addr, len);
+			mmio = ioremap_nocache(addr, sizeof(val));
 			if (!mmio)
 				goto out;
 		}
@@ -180,7 +180,7 @@ static int bcma_extpci_write_config(struct bcma_drv_pci *pc, unsigned int dev,
 		if (unlikely(!addr))
 			goto out;
 		err = -ENOMEM;
-		mmio = ioremap_nocache(addr, len);
+		mmio = ioremap_nocache(addr, sizeof(val));
 		if (!mmio)
 			goto out;
 
-- 
1.7.7.6

