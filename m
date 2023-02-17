Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99FA6C636CC
	for <linux-wireless@archiver.kernel.org>; Fri, 17 Feb 2023 03:01:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbjBQDBQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 16 Feb 2023 22:01:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBQDBP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Feb 2023 22:01:15 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 800255382B
        for <linux-wireless@vger.kernel.org>; Thu, 16 Feb 2023 19:01:14 -0800 (PST)
Received: from dggpemm100007.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PHxNq4ZgYzGphk;
        Fri, 17 Feb 2023 10:59:23 +0800 (CST)
Received: from huawei.com (10.175.103.91) by dggpemm100007.china.huawei.com
 (7.185.36.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.6; Fri, 17 Feb
 2023 11:01:12 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-wireless@vger.kernel.org>, <ath11k@lists.infradead.org>
CC:     <kvalo@kernel.org>, <quic_kathirve@quicinc.com>,
        <quic_srirrama@quicinc.com>, <yangyingliang@huawei.com>,
        <liwei391@huawei.com>
Subject: [PATCH -next] wifi: ath11k: fix return value check in ath11k_ahb_probe()
Date:   Fri, 17 Feb 2023 11:00:31 +0800
Message-ID: <20230217030031.4021289-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm100007.china.huawei.com (7.185.36.116)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

ioremap() returns NULL pointer not PTR_ERR() when it fails,
so replace the IS_ERR() check with NULL pointer check.

Fixes: b42b3678c91f ("wifi: ath11k: remap ce register space for IPQ5018")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/wireless/ath/ath11k/ahb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
index 920abce9053a..bad3946b44bf 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -1174,7 +1174,7 @@ static int ath11k_ahb_probe(struct platform_device *pdev)
 		 * to a new space for accessing them.
 		 */
 		ab->mem_ce = ioremap(ce_remap->base, ce_remap->size);
-		if (IS_ERR(ab->mem_ce)) {
+		if (!ab->mem_ce) {
 			dev_err(&pdev->dev, "ce ioremap error\n");
 			ret = -ENOMEM;
 			goto err_core_free;
-- 
2.25.1

