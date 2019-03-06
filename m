Return-Path: <SRS0=PZxT=RJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C63F9C10F0C
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Mar 2019 11:48:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0FCD2064A
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Mar 2019 11:48:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728859AbfCFLse (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Mar 2019 06:48:34 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:50898 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725267AbfCFLsd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Mar 2019 06:48:33 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 6DA90A83D8D7A150B959;
        Wed,  6 Mar 2019 19:48:30 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.408.0; Wed, 6 Mar 2019
 19:48:23 +0800
From:   Yue Haibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <kvalo@codeaurora.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] ray_cs: use remove_proc_subtree to simplify procfs code
Date:   Wed, 6 Mar 2019 19:48:12 +0800
Message-ID: <20190306114812.30480-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

Use remove_proc_subtree to remove the whole subtree

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/ray_cs.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index d561659..ee4d810 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -2820,11 +2820,7 @@ static void __exit exit_ray_cs(void)
 	pr_debug("ray_cs: cleanup_module\n");
 
 #ifdef CONFIG_PROC_FS
-	remove_proc_entry("driver/ray_cs/ray_cs", NULL);
-	remove_proc_entry("driver/ray_cs/essid", NULL);
-	remove_proc_entry("driver/ray_cs/net_type", NULL);
-	remove_proc_entry("driver/ray_cs/translate", NULL);
-	remove_proc_entry("driver/ray_cs", NULL);
+	remove_proc_subtree("driver/ray_cs", NULL);
 #endif
 
 	pcmcia_unregister_driver(&ray_driver);
-- 
2.7.0


