Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blu0-omc2-s17.blu0.hotmail.com ([65.55.111.92]:45307 "EHLO
	blu0-omc2-s17.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750789Ab2EEE51 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 May 2012 00:57:27 -0400
Message-ID: <BLU0-SMTP19859353614C6D8E5AA91CCAC2D0@phx.gbl> (sfid-20120505_065731_179056_C0AD62DB)
From: Nathan Hintz <nlhintz@hotmail.com>
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, hauke@hauke-m.de,
	Nathan Hintz <nlhintz@hotmail.com>
Subject: [PATCH v3 5/6] bcma: Add __devexit to bcma_host_pci_remove
Date: Fri, 4 May 2012 21:56:35 -0700
In-Reply-To: <1336193796-32599-1-git-send-email-nlhintz@hotmail.com>
References: <1336193796-32599-1-git-send-email-nlhintz@hotmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add missing __devexit attribute to bcma_host_pci_remove.

Signed-off-by: Nathan Hintz <nlhintz@hotmail.com>
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

