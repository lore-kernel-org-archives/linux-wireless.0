Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:58887 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab3IJL0O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 07:26:14 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MSW008GRQFPSNC0@mailout1.samsung.com> for
 linux-wireless@vger.kernel.org; Tue, 10 Sep 2013 20:26:13 +0900 (KST)
From: Jingoo Han <jg1.han@samsung.com>
To: "'John W. Linville'" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>,
	'Vladimir Kondratiev' <qca_vkondrat@qca.qualcomm.com>,
	wil6210@qca.qualcomm.com
References: <00b101ceae16$ecb87c30$c6297490$%han@samsung.com>
In-reply-to: <00b101ceae16$ecb87c30$c6297490$%han@samsung.com>
Subject: [PATCH 07/12] wireless: wil6210: remove unnecessary pci_set_drvdata()
Date: Tue, 10 Sep 2013 20:26:13 +0900
Message-id: <00b801ceae18$8e5498c0$aafdca40$%han@samsung.com> (sfid-20130910_132617_077047_2D66392E)
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/net/wireless/ath/wil6210/pcie_bus.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index eb1dc7a..eeceab3 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -197,7 +197,6 @@ static void wil_pcie_remove(struct pci_dev *pdev)
 	pci_iounmap(pdev, wil->csr);
 	pci_release_region(pdev, 0);
 	pci_disable_device(pdev);
-	pci_set_drvdata(pdev, NULL);
 }
 
 static DEFINE_PCI_DEVICE_TABLE(wil6210_pcie_ids) = {
-- 
1.7.10.4


