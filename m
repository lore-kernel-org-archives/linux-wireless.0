Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:58433 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487Ab2I3WND (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Sep 2012 18:13:03 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] bcma: do not initialize deactivated PCIe cores
Date: Mon,  1 Oct 2012 00:12:54 +0200
Message-Id: <1349043174-5371-1-git-send-email-hauke@hauke-m.de> (sfid-20121001_001308_516363_ADC1DABA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Before it was tried to initialize the deactivated PCIe core in client
mode, but this causes the SoC to hang. Just do not initialize it at all
and ignore the core it is not working and nothing is connected to it
when the specific bit is set in the boardflags.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_pci_host.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/bcma/driver_pci_host.c b/drivers/bcma/driver_pci_host.c
index 63172c9..e564495 100644
--- a/drivers/bcma/driver_pci_host.c
+++ b/drivers/bcma/driver_pci_host.c
@@ -35,11 +35,6 @@ bool __devinit bcma_core_pci_is_in_hostmode(struct bcma_drv_pci *pc)
 	    chipid_top != 0x5300)
 		return false;
 
-	if (bus->sprom.boardflags_lo & BCMA_CORE_PCI_BFL_NOPCI) {
-		bcma_info(bus, "This PCI core is disabled and not working\n");
-		return false;
-	}
-
 	bcma_core_enable(pc->core, 0);
 
 	return !mips_busprobe32(tmp, pc->core->io_addr);
@@ -396,6 +391,11 @@ void __devinit bcma_core_pci_hostmode_init(struct bcma_drv_pci *pc)
 
 	bcma_info(bus, "PCIEcore in host mode found\n");
 
+	if (bus->sprom.boardflags_lo & BCMA_CORE_PCI_BFL_NOPCI) {
+		bcma_info(bus, "This PCIE core is disabled and not working\n");
+		return;
+	}
+
 	pc_host = kzalloc(sizeof(*pc_host), GFP_KERNEL);
 	if (!pc_host)  {
 		bcma_err(bus, "can not allocate memory");
-- 
1.7.9.5

