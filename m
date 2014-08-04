Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:29881 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbaHDIWt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2014 04:22:49 -0400
From: Dedy Lansky <qca_dlansky@qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 14/14] wil6210: fix access after free in wil_pcie_remove()
Date: Mon, 4 Aug 2014 11:20:54 +0300
Message-ID: <1407140454-31639-15-git-send-email-qca_dlansky@qca.qualcomm.com> (sfid-20140804_102907_165892_E1BADB38)
In-Reply-To: <1407140454-31639-1-git-send-email-qca_dlansky@qca.qualcomm.com>
References: <1407140454-31639-1-git-send-email-qca_dlansky@qca.qualcomm.com>
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

