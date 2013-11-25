Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:13376 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301Ab3KYDh1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 22:37:27 -0500
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MWS00FUZVEDJE80@mailout3.samsung.com> for
 linux-wireless@vger.kernel.org; Mon, 25 Nov 2013 12:37:25 +0900 (KST)
From: Jingoo Han <jg1.han@samsung.com>
To: "'John W. Linville'" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	=?iso-8859-2?Q?'Rafa=B3_Mi=B3ecki'?= <zajec5@gmail.com>,
	'Jingoo Han' <jg1.han@samsung.com>,
	'Hauke Mehrtens' <hauke@hauke-m.de>
Subject: [PATCH] bcma: pci: remove unnecessary pci_set_drvdata()
Date: Mon, 25 Nov 2013 12:37:24 +0900
Message-id: <002a01cee98f$a817f2e0$f847d8a0$%han@samsung.com> (sfid-20131125_043730_439988_FD163AF7)
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/bcma/host_pci.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
index 6fb98b5..12a4ff7 100644
--- a/drivers/bcma/host_pci.c
+++ b/drivers/bcma/host_pci.c
@@ -238,7 +238,6 @@ static void bcma_host_pci_remove(struct pci_dev *dev)
 	pci_release_regions(dev);
 	pci_disable_device(dev);
 	kfree(bus);
-	pci_set_drvdata(dev, NULL);
 }
 
 #ifdef CONFIG_PM_SLEEP
-- 
1.7.10.4


