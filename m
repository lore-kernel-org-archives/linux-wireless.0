Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blu0-omc2-s37.blu0.hotmail.com ([65.55.111.112]:27897 "EHLO
	blu0-omc2-s37.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758075Ab2DYGPp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 02:15:45 -0400
Message-ID: <BLU0-SMTP82C47BE220DF48CBDE20BCAC270@phx.gbl> (sfid-20120425_081547_370974_3B45CD3B)
From: Nathan Hintz <nlhintz@hotmail.com>
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, hauke@hauke-m.de,
	Nathan Hintz <nlhintz@hotmail.com>
Subject: [PATCH 4/6] bcma: reads/writes are always 4 bytes, so always map 4 bytes
Date: Tue, 24 Apr 2012 23:15:17 -0700
In-Reply-To: <1335334519-18820-1-git-send-email-nlhintz@hotmail.com>
References: <1335334519-18820-1-git-send-email-nlhintz@hotmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 drivers/bcma/driver_pci_host.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/bcma/driver_pci_host.c b/drivers/bcma/driver_pci_host.c
index 3578e1a..0833265 100644
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

