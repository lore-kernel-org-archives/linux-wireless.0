Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:35753 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S932261AbeEWKfZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 May 2018 06:35:25 -0400
From: YueHaibing <yuehaibing@huawei.com>
To: <simon@thekelleys.org.uk>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>
CC: <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] atmel: Add missing call to pci_disable_device()
Date: Wed, 23 May 2018 18:34:45 +0800
Message-ID: <20180523103445.8372-1-yuehaibing@huawei.com> (sfid-20180523_123529_508073_D472540E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

add pci_disable_device in error handling while init_atmel_card failed.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/atmel/atmel_pci.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/atmel/atmel_pci.c b/drivers/net/wireless/atmel/atmel_pci.c
index bcf1f27..30df58a 100644
--- a/drivers/net/wireless/atmel/atmel_pci.c
+++ b/drivers/net/wireless/atmel/atmel_pci.c
@@ -61,8 +61,10 @@ static int atmel_pci_probe(struct pci_dev *pdev,
 	dev = init_atmel_card(pdev->irq, pdev->resource[1].start,
 			      ATMEL_FW_TYPE_506,
 			      &pdev->dev, NULL, NULL);
-	if (!dev)
+	if (!dev) {
+		pci_disable_device(pdev);
 		return -ENODEV;
+	}
 
 	pci_set_drvdata(pdev, dev);
 	return 0;
-- 
2.7.0
