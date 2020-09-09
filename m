Return-Path: <SRS0=opxm=CS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35FDEC10DAA
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Sep 2020 16:01:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF2BD20639
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Sep 2020 16:01:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730484AbgIIQB1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Sep 2020 12:01:27 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:11761 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730723AbgIIQBQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Sep 2020 12:01:16 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 9899E644A066854496B7;
        Wed,  9 Sep 2020 21:59:16 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Wed, 9 Sep 2020
 21:59:08 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] wlcore: Remove unused macro WL1271_SUSPEND_SLEEP
Date:   Wed, 9 Sep 2020 21:59:05 +0800
Message-ID: <20200909135905.35728-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

commit 45aa7f071b06 ("wlcore: Use generic runtime pm calls for wowlan elp configuration")
left behind this, remove it.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/ti/wlcore/main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index d2bbd5108f7e..6863fd552d5e 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -30,7 +30,6 @@
 #include "sysfs.h"
 
 #define WL1271_BOOT_RETRIES 3
-#define WL1271_SUSPEND_SLEEP 100
 #define WL1271_WAKEUP_TIMEOUT 500
 
 static char *fwlog_param;
-- 
2.17.1


