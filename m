Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blu0-omc2-s1.blu0.hotmail.com ([65.55.111.76]:9523 "EHLO
	blu0-omc2-s1.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750789Ab2EEE5Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 May 2012 00:57:24 -0400
Message-ID: <BLU0-SMTP198C4B7ECA4A96040C7F66AAC2D0@phx.gbl> (sfid-20120505_065728_083400_84C3ADCC)
From: Nathan Hintz <nlhintz@hotmail.com>
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, hauke@hauke-m.de,
	Nathan Hintz <nlhintz@hotmail.com>
Subject: [PATCH v3 3/6] bcma: Account for variable PCI memory base/size
Date: Fri, 4 May 2012 21:56:33 -0700
In-Reply-To: <1336193796-32599-1-git-send-email-nlhintz@hotmail.com>
References: <1336193796-32599-1-git-send-email-nlhintz@hotmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PCI Memory Resource start address and size are variable, dependent on
the H/W configuration.  Modify the computation of io_map_base to use the
computed values.

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

