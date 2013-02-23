Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53774 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757539Ab3BWWag (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Feb 2013 17:30:36 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] bcma: init spin lock
Date: Sat, 23 Feb 2013 23:30:22 +0100
Message-Id: <1361658622-29719-1-git-send-email-hauke@hauke-m.de> (sfid-20130223_233040_187437_AD75DBB5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This spin lock was not initialized.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_pci_host.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bcma/driver_pci_host.c b/drivers/bcma/driver_pci_host.c
index d3bde6c..30629a3 100644
--- a/drivers/bcma/driver_pci_host.c
+++ b/drivers/bcma/driver_pci_host.c
@@ -404,6 +404,8 @@ void bcma_core_pci_hostmode_init(struct bcma_drv_pci *pc)
 		return;
 	}
 
+	spin_lock_init(&pc_host->cfgspace_lock);
+
 	pc->host_controller = pc_host;
 	pc_host->pci_controller.io_resource = &pc_host->io_resource;
 	pc_host->pci_controller.mem_resource = &pc_host->mem_resource;
-- 
1.7.10.4

