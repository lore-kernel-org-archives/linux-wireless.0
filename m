Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA0B1C433B4
	for <linux-wireless@archiver.kernel.org>; Tue, 18 May 2021 02:52:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A71561209
	for <linux-wireless@archiver.kernel.org>; Tue, 18 May 2021 02:52:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239396AbhERCx6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 17 May 2021 22:53:58 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:3013 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237572AbhERCx5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 May 2021 22:53:57 -0400
Received: from dggems704-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FkgTq6qlszlfZG
        for <linux-wireless@vger.kernel.org>; Tue, 18 May 2021 10:50:23 +0800 (CST)
Received: from dggeme759-chm.china.huawei.com (10.3.19.105) by
 dggems704-chm.china.huawei.com (10.3.19.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 18 May 2021 10:52:39 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggeme759-chm.china.huawei.com (10.3.19.105) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 18 May 2021 10:52:38 +0800
From:   Tian Tao <tiantao6@hisilicon.com>
To:     <m@bues.ch>
CC:     <linux-wireless@vger.kernel.org>, Tian Tao <tiantao6@hisilicon.com>
Subject: [PATCH] ssb: remove unreachable code
Date:   Tue, 18 May 2021 10:52:32 +0800
Message-ID: <1621306352-3632-1-git-send-email-tiantao6@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggeme759-chm.china.huawei.com (10.3.19.105)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The return value of ssb_bus_unregister can only be 0 or 1, so this
condition if (err == -EBUSY) will not hold, so delete it.

Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
---
 drivers/ssb/main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index 0a26984..8fcf53c 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -431,9 +431,7 @@ void ssb_bus_unregister(struct ssb_bus *bus)
 	int err;
 
 	err = ssb_gpio_unregister(bus);
-	if (err == -EBUSY)
-		pr_debug("Some GPIOs are still in use\n");
-	else if (err)
+	if (err)
 		pr_debug("Can not unregister GPIO driver: %i\n", err);
 
 	ssb_buses_lock();
-- 
2.7.4

