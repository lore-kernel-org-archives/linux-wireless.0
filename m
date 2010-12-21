Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:50665 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933189Ab0LUBCV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 20:02:21 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 7/7] rtlwifi: Use pci_pcie_cap()
Date: Tue, 21 Dec 2010 02:01:56 +0100
Message-Id: <1292893316-26694-8-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1292893316-26694-1-git-send-email-hauke@hauke-m.de>
References: <1292893316-26694-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use function pci_pcie_cap() instead of accessing struct member directly.

CC: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/rtlwifi/pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index bf3b574..353e203 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -1608,7 +1608,7 @@ static bool _rtl_pci_find_adapter(struct pci_dev *pdev,
 		pcipriv->ndis_adapter.pcibridge_funcnum =
 		    PCI_FUNC(bridge_pdev->devfn);
 		pcipriv->ndis_adapter.pcibridge_pciehdr_offset =
-		    bridge_pdev->pcie_cap;
+		    pci_pcie_cap(bridge_pdev);
 		pcipriv->ndis_adapter.pcicfg_addrport =
 		    (pcipriv->ndis_adapter.pcibridge_busnum << 16) |
 		    (pcipriv->ndis_adapter.pcibridge_devnum << 11) |
-- 
1.7.1

