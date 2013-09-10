Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:55651 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab3IJL1K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 07:27:10 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MSW00MA4QGQDH10@mailout2.samsung.com> for
 linux-wireless@vger.kernel.org; Tue, 10 Sep 2013 20:27:09 +0900 (KST)
From: Jingoo Han <jg1.han@samsung.com>
To: "'John W. Linville'" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>,
	'Stanislav Yakovlev' <stas.yakovlev@gmail.com>
References: <00b101ceae16$ecb87c30$c6297490$%han@samsung.com>
In-reply-to: <00b101ceae16$ecb87c30$c6297490$%han@samsung.com>
Subject: [PATCH 08/12] wireless: ipw2x00: remove unnecessary pci_set_drvdata()
Date: Tue, 10 Sep 2013 20:27:09 +0900
Message-id: <00b901ceae18$afc7fb50$0f57f1f0$%han@samsung.com> (sfid-20130910_132713_759992_260065B6)
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/net/wireless/ipw2x00/ipw2200.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index 6b823a1..f394af7 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -11885,7 +11885,6 @@ static int ipw_pci_probe(struct pci_dev *pdev,
 	pci_release_regions(pdev);
       out_pci_disable_device:
 	pci_disable_device(pdev);
-	pci_set_drvdata(pdev, NULL);
       out_free_libipw:
 	free_libipw(priv->net_dev, 0);
       out:
@@ -11966,7 +11965,6 @@ static void ipw_pci_remove(struct pci_dev *pdev)
 	iounmap(priv->hw_base);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
-	pci_set_drvdata(pdev, NULL);
 	/* wiphy_unregister needs to be here, before free_libipw */
 	wiphy_unregister(priv->ieee->wdev.wiphy);
 	kfree(priv->ieee->a_band.channels);
-- 
1.7.10.4


