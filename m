Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:9566 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab3KYBtz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 20:49:55 -0500
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MWS003TYQF67AA0@mailout1.samsung.com> for
 linux-wireless@vger.kernel.org; Mon, 25 Nov 2013 10:49:54 +0900 (KST)
From: Jingoo Han <jg1.han@samsung.com>
To: "'John W. Linville'" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>,
	'Stanislav Yakovlev' <stas.yakovlev@gmail.com>
Subject: [PATCH 1/3] wireless: ipw2100: remove unnecessary pci_set_drvdata()
Date: Mon, 25 Nov 2013 10:49:53 +0900
Message-id: <000601cee980$a2d1b0a0$e87511e0$%han@samsung.com> (sfid-20131125_024958_692619_E5C7A5B4)
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/net/wireless/ipw2x00/ipw2100.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2100.c b/drivers/net/wireless/ipw2x00/ipw2100.c
index f8ab193..2f4233a 100644
--- a/drivers/net/wireless/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/ipw2x00/ipw2100.c
@@ -6362,7 +6362,6 @@ out:
 				   &ipw2100_attribute_group);
 
 		free_libipw(dev, 0);
-		pci_set_drvdata(pci_dev, NULL);
 	}
 
 	pci_iounmap(pci_dev, ioaddr);
-- 
1.7.10.4


