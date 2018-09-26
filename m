Return-Path: <SRS0=mZ/2=MI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88617C43382
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 12:43:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BBD12082C
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 12:43:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4BBD12082C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbeIZS4K (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Sep 2018 14:56:10 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13127 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726315AbeIZS4K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Sep 2018 14:56:10 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 25E947D989FAC;
        Wed, 26 Sep 2018 20:43:17 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.399.0; Wed, 26 Sep 2018 20:43:17 +0800
From:   zhong jiang <zhongjiang@huawei.com>
To:     <gregkh@linuxfoundation.org>, <sameo@linux.intel.com>
CC:     <andriy.shevchenko@linux.intel.com>,
        <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] NFC: st-nci: remove a redundant null pointer check
Date:   Wed, 26 Sep 2018 20:30:50 +0800
Message-ID: <1537965050-16579-1-git-send-email-zhongjiang@huawei.com>
X-Mailer: git-send-email 1.7.12.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The dev is impossible is NULL. hence the check is redundant. We
never will hit it.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
v1->v2:
 -  According to Greg's suggestion. just remove the null pointer will be better.

 drivers/nfc/st-nci/spi.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/nfc/st-nci/spi.c b/drivers/nfc/st-nci/spi.c
index 1470559..864fd90 100644
--- a/drivers/nfc/st-nci/spi.c
+++ b/drivers/nfc/st-nci/spi.c
@@ -233,13 +233,6 @@ static int st_nci_spi_probe(struct spi_device *dev)
 	dev_dbg(&dev->dev, "%s\n", __func__);
 	dev_dbg(&dev->dev, "IRQ: %d\n", dev->irq);
 
-	/* Check SPI platform functionnalities */
-	if (!dev) {
-		pr_debug("%s: dev is NULL. Device is not accessible.\n",
-			__func__);
-		return -ENODEV;
-	}
-
 	phy = devm_kzalloc(&dev->dev, sizeof(struct st_nci_spi_phy),
 			   GFP_KERNEL);
 	if (!phy)
-- 
1.7.12.4

