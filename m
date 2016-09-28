Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34173 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932600AbcI1Oio (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Sep 2016 10:38:44 -0400
Received: by mail-pf0-f196.google.com with SMTP id 21so2247733pfy.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Sep 2016 07:38:44 -0700 (PDT)
From: Wei Yongjun <weiyj.lk@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        Bruno Herrera <bruherrera@gmail.com>,
        Tony Lindgren <tony@atomide.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH -next] wlcore: sdio: drop kfree for memory allocated with devm_kzalloc
Date: Wed, 28 Sep 2016 14:38:36 +0000
Message-Id: <1475073516-7328-1-git-send-email-weiyj.lk@gmail.com> (sfid-20160928_163908_748395_A1889786)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <weiyongjun1@huawei.com>

It's not necessary to free memory allocated with devm_kzalloc
and using kfree leads to a double free.

Fixes: d776fc86b82f ("wlcore: sdio: Populate config firmware data")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/wireless/ti/wlcore/sdio.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
index a6e94b1..47fe7f9 100644
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -391,7 +391,6 @@ static void wl1271_remove(struct sdio_func *func)
 	pm_runtime_get_noresume(&func->dev);
 
 	platform_device_unregister(glue->core);
-	kfree(glue);
 }
 
 #ifdef CONFIG_PM
