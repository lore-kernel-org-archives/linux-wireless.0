Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:55099 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab3IJLWM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 07:22:12 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MSW00F3EQ8TQH11@mailout2.samsung.com> for
 linux-wireless@vger.kernel.org; Tue, 10 Sep 2013 20:22:10 +0900 (KST)
From: Jingoo Han <jg1.han@samsung.com>
To: "'John W. Linville'" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>,
	'Thomas Huehn' <thomas@net.t-labs.tu-berlin.de>,
	'Karl Beldan' <karl.beldan@rivierawaves.com>
References: <00b101ceae16$ecb87c30$c6297490$%han@samsung.com>
In-reply-to: <00b101ceae16$ecb87c30$c6297490$%han@samsung.com>
Subject: [PATCH 04/12] wireless: adm8211: remove unnecessary pci_set_drvdata()
Date: Tue, 10 Sep 2013 20:22:10 +0900
Message-id: <00b501ceae17$fdd33040$f97990c0$%han@samsung.com> (sfid-20130910_132215_852629_140F5E74)
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/net/wireless/adm8211.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index f9a24e5..cfce83e 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -1924,7 +1924,6 @@ static int adm8211_probe(struct pci_dev *pdev,
 	pci_iounmap(pdev, priv->map);
 
  err_free_dev:
-	pci_set_drvdata(pdev, NULL);
 	ieee80211_free_hw(dev);
 
  err_free_reg:
-- 
1.7.10.4


