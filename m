Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C229FC0015E
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Aug 2023 07:55:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235464AbjHOHzE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Aug 2023 03:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235457AbjHOHyl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Aug 2023 03:54:41 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B6FADD
        for <linux-wireless@vger.kernel.org>; Tue, 15 Aug 2023 00:54:39 -0700 (PDT)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4RQ3PT0L8KzFqdC;
        Tue, 15 Aug 2023 15:51:41 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemi500012.china.huawei.com
 (7.221.188.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Tue, 15 Aug
 2023 15:54:37 +0800
From:   Li Zetao <lizetao1@huawei.com>
To:     <kvalo@kernel.org>
CC:     <lizetao1@huawei.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH net-next] wlcore: sdio: Use module_sdio_driver macro to simplify the code
Date:   Tue, 15 Aug 2023 15:54:19 +0800
Message-ID: <20230815075419.1067635-1-lizetao1@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use the module_sdio_driver macro to simplify the code, which is the
same as declaring with module_init() and module_exit().

Signed-off-by: Li Zetao <lizetao1@huawei.com>
---
 drivers/net/wireless/ti/wlcore/sdio.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
index cf8d909fa826..f0686635db46 100644
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -442,18 +442,7 @@ static struct sdio_driver wl1271_sdio_driver = {
 #endif
 };
 
-static int __init wl1271_init(void)
-{
-	return sdio_register_driver(&wl1271_sdio_driver);
-}
-
-static void __exit wl1271_exit(void)
-{
-	sdio_unregister_driver(&wl1271_sdio_driver);
-}
-
-module_init(wl1271_init);
-module_exit(wl1271_exit);
+module_sdio_driver(wl1271_sdio_driver);
 
 module_param(dump, bool, 0600);
 MODULE_PARM_DESC(dump, "Enable sdio read/write dumps.");
-- 
2.34.1

