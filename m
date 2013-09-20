Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:55540 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202Ab3ITJAd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Sep 2013 05:00:33 -0400
Received: by mail-pa0-f44.google.com with SMTP id fz6so467825pac.31
        for <linux-wireless@vger.kernel.org>; Fri, 20 Sep 2013 02:00:33 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-nfc@lists.01.org
Cc: linux-wireless@vger.kernel.org, sameo@linux.intel.com,
	lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	sachin.kamat@linaro.org, Ilan Elias <ilane@ti.com>
Subject: [PATCH 1/2] NFC: Remove redundant dev_set_drvdata
Date: Fri, 20 Sep 2013 14:30:40 +0530
Message-Id: <1379667641-31149-1-git-send-email-sachin.kamat@linaro.org> (sfid-20130920_110037_416532_0A714956)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Driver core sets driver data to NULL upon failure or remove.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Ilan Elias <ilane@ti.com>
---
Series compile tested.
---
 drivers/nfc/nfcwilink.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/nfc/nfcwilink.c b/drivers/nfc/nfcwilink.c
index 59f95d8..9b1d91ee 100644
--- a/drivers/nfc/nfcwilink.c
+++ b/drivers/nfc/nfcwilink.c
@@ -578,8 +578,6 @@ static int nfcwilink_remove(struct platform_device *pdev)
 	nci_unregister_device(ndev);
 	nci_free_device(ndev);
 
-	dev_set_drvdata(&pdev->dev, NULL);
-
 	return 0;
 }
 
-- 
1.7.9.5

