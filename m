Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blu0-omc2-s6.blu0.hotmail.com ([65.55.111.81]:23004 "EHLO
	blu0-omc2-s6.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758075Ab2DYGPm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 02:15:42 -0400
Message-ID: <BLU0-SMTP82FF4247B6804576EBAE9AAC270@phx.gbl> (sfid-20120425_081544_436929_16779094)
From: Nathan Hintz <nlhintz@hotmail.com>
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, hauke@hauke-m.de,
	Nathan Hintz <nlhintz@hotmail.com>
Subject: [PATCH 3/6] bcma: Account for variable PCI memory base/size
Date: Tue, 24 Apr 2012 23:15:16 -0700
In-Reply-To: <1335334519-18820-1-git-send-email-nlhintz@hotmail.com>
References: <1335334519-18820-1-git-send-email-nlhintz@hotmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 drivers/bcma/driver_pci_host.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/bcma/driver_pci_host.c b/drivers/bcma/driver_pci_host.c
index d2097a1..3578e1a 100644
--- a/drivers/bcma/driver_pci_host.c
+++ b/drivers/bcma/driver_pci_host.c
@@ -491,8 +491,9 @@ void __devinit bcma_core_pci_hostmode_init(struct bcma_drv_pci *pc)
 	/* Ok, ready to run, register it to the system.
 	 * The following needs change, if we want to port hostmode
 	 * to non-MIPS platform. */
-	io_map_base = (unsigned long)ioremap_nocache(BCMA_SOC_PCI_MEM,
-						     0x04000000);
+	io_map_base = (unsigned long)ioremap_nocache(pc_host->mem_resource.start,
+						     pc_host->mem_resource.end -
+						     pc_host->mem_resource.start + 1);
 	pc_host->pci_controller.io_map_base = io_map_base;
 	set_io_port_base(pc_host->pci_controller.io_map_base);
 	/* Give some time to the PCI controller to configure itself with the new
-- 
1.7.7.6

