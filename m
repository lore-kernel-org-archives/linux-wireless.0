Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:56187 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab3IJLcU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 07:32:20 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MSW00FDLQPOQH11@mailout2.samsung.com> for
 linux-wireless@vger.kernel.org; Tue, 10 Sep 2013 20:32:19 +0900 (KST)
From: Jingoo Han <jg1.han@samsung.com>
To: "'John W. Linville'" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>
References: <00b101ceae16$ecb87c30$c6297490$%han@samsung.com>
In-reply-to: <00b101ceae16$ecb87c30$c6297490$%han@samsung.com>
Subject: [PATCH 12/12] wireless: rtl818x: remove unnecessary pci_set_drvdata()
Date: Tue, 10 Sep 2013 20:32:19 +0900
Message-id: <00bd01ceae19$68baa180$3a2fe480$%han@samsung.com> (sfid-20130910_133224_164242_6DC966A4)
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index fc207b2..a91506b 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -1122,7 +1122,6 @@ static int rtl8180_probe(struct pci_dev *pdev,
 	iounmap(priv->map);
 
  err_free_dev:
-	pci_set_drvdata(pdev, NULL);
 	ieee80211_free_hw(dev);
 
  err_free_reg:
-- 
1.7.10.4


