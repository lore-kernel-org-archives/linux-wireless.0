Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:36723 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099AbaHFHcp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2014 03:32:45 -0400
From: Dedy Lansky <qca_dlansky@qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH v2 13/13] wil6210: fix access after free in wil_pcie_remove()
Date: Wed, 6 Aug 2014 10:32:01 +0300
Message-ID: <1407310322-22568-14-git-send-email-qca_dlansky@qca.qualcomm.com> (sfid-20140806_095908_438532_DCC33B56)
In-Reply-To: <1407310322-22568-1-git-send-email-qca_dlansky@qca.qualcomm.com>
References: <1407310322-22568-1-git-send-email-qca_dlansky@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

'wil'  released in wil_if_free(); save iomapped address aside to
properly unmap it.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/pcie_bus.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index cf0b219..38dcbea 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -218,12 +218,13 @@ static int wil_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 static void wil_pcie_remove(struct pci_dev *pdev)
 {
 	struct wil6210_priv *wil = pci_get_drvdata(pdev);
+	void __iomem *csr = wil->csr;
 
 	wil6210_debugfs_remove(wil);
 	wil_if_pcie_disable(wil);
 	wil_if_remove(wil);
 	wil_if_free(wil);
-	pci_iounmap(pdev, wil->csr);
+	pci_iounmap(pdev, csr);
 	pci_release_region(pdev, 0);
 	pci_disable_device(pdev);
 }
-- 
1.8.5.2

