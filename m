Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2EB1C433E6
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Dec 2020 13:25:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B96DA2222B
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Dec 2020 13:25:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728979AbgLXNZM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 24 Dec 2020 08:25:12 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10081 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728367AbgLXNZM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Dec 2020 08:25:12 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4D1rPK2plszM7G6;
        Thu, 24 Dec 2020 21:23:33 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Thu, 24 Dec 2020 21:24:19 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH v2 -next] atmel: at76c50x: use DEFINE_MUTEX() for mutex lock
Date:   Thu, 24 Dec 2020 21:24:56 +0800
Message-ID: <20201224132456.31341-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

mutex lock can be initialized automatically with DEFINE_MUTEX()
rather than explicitly calling mutex_init().

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/wireless/atmel/at76c50x-usb.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/atmel/at76c50x-usb.c b/drivers/net/wireless/atmel/at76c50x-usb.c
index 404257800033..7582761c61e2 100644
--- a/drivers/net/wireless/atmel/at76c50x-usb.c
+++ b/drivers/net/wireless/atmel/at76c50x-usb.c
@@ -101,7 +101,7 @@ do {									\
 static uint at76_debug = DBG_DEFAULTS;
 
 /* Protect against concurrent firmware loading and parsing */
-static struct mutex fw_mutex;
+static DEFINE_MUTEX(fw_mutex);
 
 static struct fwentry firmwares[] = {
 	[0] = { "" },
@@ -2572,8 +2572,6 @@ static int __init at76_mod_init(void)
 
 	printk(KERN_INFO DRIVER_DESC " " DRIVER_VERSION " loading\n");
 
-	mutex_init(&fw_mutex);
-
 	/* register this driver with the USB subsystem */
 	result = usb_register(&at76_driver);
 	if (result < 0)
-- 
2.22.0

