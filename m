Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway22.websitewelcome.com ([192.185.46.142]:17945 "EHLO
        gateway22.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729708AbeHECHU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 4 Aug 2018 22:07:20 -0400
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id 69DCB123D8
        for <linux-wireless@vger.kernel.org>; Sat,  4 Aug 2018 19:04:54 -0500 (CDT)
Date: Sat, 4 Aug 2018 19:04:53 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Michael Buesch <m@bues.ch>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] ssb: driver_gige: use true and false for boolean values
Message-ID: <20180805000453.GA19115@embeddedor.com> (sfid-20180805_020500_118917_EFE0CCD8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Return statements in functions returning bool should use true or false
instead of an integer value.

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/ssb/driver_gige.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ssb/driver_gige.c b/drivers/ssb/driver_gige.c
index e973405..ebee6b0 100644
--- a/drivers/ssb/driver_gige.c
+++ b/drivers/ssb/driver_gige.c
@@ -242,7 +242,7 @@ static int ssb_gige_probe(struct ssb_device *sdev,
 bool pdev_is_ssb_gige_core(struct pci_dev *pdev)
 {
 	if (!pdev->resource[0].name)
-		return 0;
+		return false;
 	return (strcmp(pdev->resource[0].name, SSB_GIGE_MEM_RES_NAME) == 0);
 }
 EXPORT_SYMBOL(pdev_is_ssb_gige_core);
-- 
2.7.4
