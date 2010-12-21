Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:50651 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933281Ab0LUBCQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 20:02:16 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	Ivo van Doorn <IvDoorn@gmail.com>
Subject: [PATCH 4/7] rt2x00: Use pci_is_pcie()
Date: Tue, 21 Dec 2010 02:01:53 +0100
Message-Id: <1292893316-26694-5-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1292893316-26694-1-git-send-email-hauke@hauke-m.de>
References: <1292893316-26694-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use function pci_is_pcie() instead of accessing struct member directly.

CC: Ivo van Doorn <IvDoorn@gmail.com>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/rt2x00/rt2x00pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index 28e6ff1..73631c6 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -286,7 +286,7 @@ int rt2x00pci_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 	rt2x00dev->irq = pci_dev->irq;
 	rt2x00dev->name = pci_name(pci_dev);
 
-	if (pci_dev->is_pcie)
+	if (pci_is_pcie(pci_dev))
 		rt2x00_set_chip_intf(rt2x00dev, RT2X00_CHIP_INTF_PCIE);
 	else
 		rt2x00_set_chip_intf(rt2x00dev, RT2X00_CHIP_INTF_PCI);
-- 
1.7.1

