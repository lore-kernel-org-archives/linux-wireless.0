Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:42390 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757290Ab2KZXaV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 18:30:21 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, zajec5@gmail.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] bcma: handle return value of pci_assign_resource
Date: Tue, 27 Nov 2012 00:30:04 +0100
Message-Id: <1353972604-28254-1-git-send-email-hauke@hauke-m.de> (sfid-20121127_003024_878873_017CA384)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes the following warning:

  CC      drivers/bcma/driver_pci_host.o
drivers/bcma/driver_pci_host.c: In function 'bcma_core_pci_fixup_addresses':
drivers/bcma/driver_pci_host.c:555:23: error: ignoring return value of
'pci_assign_resource', declared with attribute warn_unused_result
[-Werror=unused-result]

Reported-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_pci_host.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/bcma/driver_pci_host.c b/drivers/bcma/driver_pci_host.c
index e564495..e6b5c89 100644
--- a/drivers/bcma/driver_pci_host.c
+++ b/drivers/bcma/driver_pci_host.c
@@ -538,7 +538,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_ANY_ID, PCI_ANY_ID, bcma_core_pci_fixup_pcibridge);
 static void bcma_core_pci_fixup_addresses(struct pci_dev *dev)
 {
 	struct resource *res;
-	int pos;
+	int pos, err;
 
 	if (dev->bus->ops->read != bcma_core_pci_hostmode_read_config) {
 		/* This is not a device on the PCI-core bridge. */
@@ -551,8 +551,12 @@ static void bcma_core_pci_fixup_addresses(struct pci_dev *dev)
 
 	for (pos = 0; pos < 6; pos++) {
 		res = &dev->resource[pos];
-		if (res->flags & (IORESOURCE_IO | IORESOURCE_MEM))
-			pci_assign_resource(dev, pos);
+		if (res->flags & (IORESOURCE_IO | IORESOURCE_MEM)) {
+			err = pci_assign_resource(dev, pos);
+			if (err)
+				pr_err("PCI: Problem fixing up the addresses on %s\n",
+				       pci_name(dev));
+		}
 	}
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_ANY_ID, PCI_ANY_ID, bcma_core_pci_fixup_addresses);
-- 
1.7.10.4

