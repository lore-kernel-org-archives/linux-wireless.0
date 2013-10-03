Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:38295 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637Ab3JCLt1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Oct 2013 07:49:27 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	arend@broadcom.com, brcm80211-dev-list@broadcom.com,
	jogo@openwrt.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/3] bcma: reject PCI cards in bcma.
Date: Thu,  3 Oct 2013 13:49:09 +0200
Message-Id: <1380800951-28643-1-git-send-email-hauke@hauke-m.de> (sfid-20131003_134931_076773_4049FAB8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

bcma currently only supports PCIe cards and no PCI cards, reject them
if we find them. I have never heard of any PCI card using the AI bus
(bcma), all of them are using ssb instead.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/host_pci.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
index a355e63..a1caf9c 100644
--- a/drivers/bcma/host_pci.c
+++ b/drivers/bcma/host_pci.c
@@ -188,8 +188,11 @@ static int bcma_host_pci_probe(struct pci_dev *dev,
 		pci_write_config_dword(dev, 0x40, val & 0xffff00ff);
 
 	/* SSB needed additional powering up, do we have any AMBA PCI cards? */
-	if (!pci_is_pcie(dev))
-		bcma_err(bus, "PCI card detected, report problems.\n");
+	if (!pci_is_pcie(dev)) {
+		bcma_err(bus, "PCI card detected, they are not supported.\n");
+		err = -ENXIO;
+		goto err_pci_release_regions;
+	}
 
 	/* Map MMIO */
 	err = -ENOMEM;
-- 
1.7.10.4

