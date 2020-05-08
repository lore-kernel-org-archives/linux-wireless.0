Return-Path: <SRS0=6+7Q=6W=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AA3BC38A2A
	for <linux-wireless@archiver.kernel.org>; Fri,  8 May 2020 07:49:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E9FD208D6
	for <linux-wireless@archiver.kernel.org>; Fri,  8 May 2020 07:49:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgEHHtg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 May 2020 03:49:36 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:55152 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726036AbgEHHtf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 May 2020 03:49:35 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 8D9EC4EC0E4D702EDF94;
        Fri,  8 May 2020 15:49:33 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Fri, 8 May 2020 15:49:23 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     Wei Yongjun <weiyongjun1@huawei.com>, <ath11k@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH next] ath11k: convert to devm_platform_get_and_ioremap_resource
Date:   Fri, 8 May 2020 07:53:23 +0000
Message-ID: <20200508075323.81128-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use the helper function that wraps the calls to platform_get_resource()
and devm_ioremap_resource() together.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/wireless/ath/ath11k/ahb.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
index 3b2b76d602f2..d4ad99eb0e16 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -891,13 +891,7 @@ static int ath11k_ahb_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!mem_res) {
-		dev_err(&pdev->dev, "failed to get IO memory resource\n");
-		return -ENXIO;
-	}
-
-	mem = devm_ioremap_resource(&pdev->dev, mem_res);
+	mem = devm_platform_get_and_ioremap_resource(pdev, 0, &mem_res);
 	if (IS_ERR(mem)) {
 		dev_err(&pdev->dev, "ioremap error\n");
 		return PTR_ERR(mem);



