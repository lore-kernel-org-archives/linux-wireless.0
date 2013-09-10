Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:55714 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab3IJL1v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 07:27:51 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MSW0056CQHYP8C0@mailout2.samsung.com> for
 linux-wireless@vger.kernel.org; Tue, 10 Sep 2013 20:27:50 +0900 (KST)
From: Jingoo Han <jg1.han@samsung.com>
To: "'John W. Linville'" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>,
	'Lennert Buytenhek' <buytenh@wantstofly.org>
References: <00b101ceae16$ecb87c30$c6297490$%han@samsung.com>
In-reply-to: <00b101ceae16$ecb87c30$c6297490$%han@samsung.com>
Subject: [PATCH 09/12] wireless: mwl8k: remove unnecessary pci_set_drvdata()
Date: Tue, 10 Sep 2013 20:27:49 +0900
Message-id: <00ba01ceae18$c81b3f00$5851bd00$%han@samsung.com> (sfid-20130910_132754_797054_E86D1A86)
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/net/wireless/mwl8k.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index a3707fd..b953ad6 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -6093,7 +6093,6 @@ err_iounmap:
 	if (priv->sram != NULL)
 		pci_iounmap(pdev, priv->sram);
 
-	pci_set_drvdata(pdev, NULL);
 	ieee80211_free_hw(hw);
 
 err_free_reg:
@@ -6147,7 +6146,6 @@ static void mwl8k_remove(struct pci_dev *pdev)
 unmap:
 	pci_iounmap(pdev, priv->regs);
 	pci_iounmap(pdev, priv->sram);
-	pci_set_drvdata(pdev, NULL);
 	ieee80211_free_hw(hw);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
-- 
1.7.10.4


