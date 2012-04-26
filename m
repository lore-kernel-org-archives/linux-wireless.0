Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blu0-omc2-s6.blu0.hotmail.com ([65.55.111.81]:3305 "EHLO
	blu0-omc2-s6.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751843Ab2DZEYZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2012 00:24:25 -0400
Message-ID: <BLU0-SMTP45801EF76571272A7C9B084AC240@phx.gbl> (sfid-20120426_062428_458616_C5EABF5D)
From: Nathan Hintz <nlhintz@hotmail.com>
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, hauke@hauke-m.de,
	Nathan Hintz <nlhintz@hotmail.com>
Subject: [PATCH v2 3/6] bcma: Account for variable PCI memory base/size
Date: Wed, 25 Apr 2012 21:23:51 -0700
In-Reply-To: <1335414234-11424-1-git-send-email-nlhintz@hotmail.com>
References: <1335414234-11424-1-git-send-email-nlhintz@hotmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Nathan Hintz <nlhintz@hotmail.com>
---
 drivers/bcma/driver_pci_host.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/bcma/driver_pci_host.c b/drivers/bcma/driver_pci_host.c
index d2097a1..8407b25 100644
--- a/drivers/bcma/driver_pci_host.c
+++ b/drivers/bcma/driver_pci_host.c
@@ -491,8 +491,8 @@ void __devinit bcma_core_pci_hostmode_init(struct bcma_drv_pci *pc)
 	/* Ok, ready to run, register it to the system.
 	 * The following needs change, if we want to port hostmode
 	 * to non-MIPS platform. */
-	io_map_base = (unsigned long)ioremap_nocache(BCMA_SOC_PCI_MEM,
-						     0x04000000);
+	io_map_base = (unsigned long)ioremap_nocache(pc_host->mem_resource.start,
+						     resource_size(&pc_host->mem_resource));
 	pc_host->pci_controller.io_map_base = io_map_base;
 	set_io_port_base(pc_host->pci_controller.io_map_base);
 	/* Give some time to the PCI controller to configure itself with the new
-- 
1.7.7.6

