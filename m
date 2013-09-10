Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:59339 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab3IJLau (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 07:30:50 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MSW004Q5QN07GJ0@mailout1.samsung.com> for
 linux-wireless@vger.kernel.org; Tue, 10 Sep 2013 20:30:49 +0900 (KST)
From: Jingoo Han <jg1.han@samsung.com>
To: "'John W. Linville'" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>,
	'Christian Lamparter' <chunkeey@googlemail.com>,
	'Alexey Khoroshilov' <khoroshilov@ispras.ru>,
	'Larry Finger' <Larry.Finger@lwfinger.net>
References: <00b101ceae16$ecb87c30$c6297490$%han@samsung.com>
In-reply-to: <00b101ceae16$ecb87c30$c6297490$%han@samsung.com>
Subject: [PATCH 11/12] wireless: p54pci: remove unnecessary pci_set_drvdata()
Date: Tue, 10 Sep 2013 20:30:49 +0900
Message-id: <00bc01ceae19$33093560$991ba020$%han@samsung.com> (sfid-20130910_133053_375953_BF93E33E)
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/net/wireless/p54/p54pci.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
index 57e3af8..f9a07b0 100644
--- a/drivers/net/wireless/p54/p54pci.c
+++ b/drivers/net/wireless/p54/p54pci.c
@@ -631,7 +631,6 @@ static int p54p_probe(struct pci_dev *pdev,
 	iounmap(priv->map);
 
  err_free_dev:
-	pci_set_drvdata(pdev, NULL);
 	p54_free_common(dev);
 
  err_free_reg:
-- 
1.7.10.4


