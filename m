Return-Path: <SRS0=5LI1=BA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C73AC433E0
	for <linux-wireless@archiver.kernel.org>; Tue, 21 Jul 2020 08:39:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 019B920709
	for <linux-wireless@archiver.kernel.org>; Tue, 21 Jul 2020 08:39:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728852AbgGUIjs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 21 Jul 2020 04:39:48 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:8342 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728418AbgGUIjs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Jul 2020 04:39:48 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 8CB22C6357DD61580D5E;
        Tue, 21 Jul 2020 16:39:45 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Tue, 21 Jul 2020 16:39:36 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <zajec5@gmail.com>, <linux-wireless@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH] drivers: bcma: remove set but not used variable `addrh` and `sizeh`
Date:   Tue, 21 Jul 2020 16:39:35 +0800
Message-ID: <20200721083935.13306-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/bcma/scan.c: In function 'bcma_erom_get_addr_desc':
drivers/bcma/scan.c:219 warning:
variable `addrh` and `sizeh` set but not used [-Wunused-but-set-variable]

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/bcma/scan.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
index 1a942f734188..d49e7c0de2b6 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -219,7 +219,7 @@ static s32 bcma_erom_get_mst_port(struct bcma_bus *bus, u32 __iomem **eromptr)
 static u32 bcma_erom_get_addr_desc(struct bcma_bus *bus, u32 __iomem **eromptr,
 				  u32 type, u8 port)
 {
-	u32 addrl, addrh, sizeh = 0;
+	u32 addrl;
 	u32 size;
 
 	u32 ent = bcma_erom_get_ent(bus, eromptr);
@@ -233,14 +233,12 @@ static u32 bcma_erom_get_addr_desc(struct bcma_bus *bus, u32 __iomem **eromptr,
 
 	addrl = ent & SCAN_ADDR_ADDR;
 	if (ent & SCAN_ADDR_AG32)
-		addrh = bcma_erom_get_ent(bus, eromptr);
-	else
-		addrh = 0;
+		bcma_erom_get_ent(bus, eromptr);
 
 	if ((ent & SCAN_ADDR_SZ) == SCAN_ADDR_SZ_SZD) {
 		size = bcma_erom_get_ent(bus, eromptr);
 		if (size & SCAN_SIZE_SG32)
-			sizeh = bcma_erom_get_ent(bus, eromptr);
+			bcma_erom_get_ent(bus, eromptr);
 	}
 
 	return addrl;
-- 
2.17.1

