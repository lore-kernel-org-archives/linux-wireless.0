Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blu0-omc2-s2.blu0.hotmail.com ([65.55.111.77]:11568 "EHLO
	blu0-omc2-s2.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758075Ab2DYGPt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 02:15:49 -0400
Message-ID: <BLU0-SMTP8289CC6BFFDE40C65F796CAC270@phx.gbl> (sfid-20120425_081551_603104_4CA19755)
From: Nathan Hintz <nlhintz@hotmail.com>
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, hauke@hauke-m.de,
	Nathan Hintz <nlhintz@hotmail.com>
Subject: [PATCH 5/6] bcma: Add __devexit to bcma_host_pci_remove
Date: Tue, 24 Apr 2012 23:15:18 -0700
In-Reply-To: <1335334519-18820-1-git-send-email-nlhintz@hotmail.com>
References: <1335334519-18820-1-git-send-email-nlhintz@hotmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 drivers/bcma/host_pci.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
index e3928d6..915ab2f 100644
--- a/drivers/bcma/host_pci.c
+++ b/drivers/bcma/host_pci.c
@@ -222,7 +222,7 @@ err_kfree_bus:
 	return err;
 }
 
-static void bcma_host_pci_remove(struct pci_dev *dev)
+static void __devexit bcma_host_pci_remove(struct pci_dev *dev)
 {
 	struct bcma_bus *bus = pci_get_drvdata(dev);
 
@@ -277,7 +277,7 @@ static struct pci_driver bcma_pci_bridge_driver = {
 	.name = "bcma-pci-bridge",
 	.id_table = bcma_pci_bridge_tbl,
 	.probe = bcma_host_pci_probe,
-	.remove = bcma_host_pci_remove,
+	.remove = __devexit_p(bcma_host_pci_remove),
 	.driver.pm = BCMA_PM_OPS,
 };
 
-- 
1.7.7.6

