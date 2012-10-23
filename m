Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:32995 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab2JWFXO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Oct 2012 01:23:14 -0400
Received: by mail-qa0-f53.google.com with SMTP id s11so105457qaa.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Oct 2012 22:23:13 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 23 Oct 2012 13:23:13 +0800
Message-ID: <CAPgLHd9_Hx+XiHTZkEcP53fJTT5Ys5aPd+ngM=3Vh9VK9JQcaQ@mail.gmail.com> (sfid-20121023_072318_537702_5F239B2E)
Subject: [PATCH] wlcore: sdio: use platform_device_unregister in wl1271_remove()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: coelho@ti.com, linville@tuxdriver.com
Cc: yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

platform_device_unregister() only calls platform_device_del() and
platform_device_put(), thus use platform_device_unregister() to
simplify the code.

Also the documents in platform.c shows that platform_device_del
and platform_device_put must _only_ be externally called in error
cases.  All other usage is a bug.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/net/wireless/ti/wlcore/sdio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
index 73ace4b..4960bcd 100644
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -326,8 +326,7 @@ static void __devexit wl1271_remove(struct sdio_func *func)
 	/* Undo decrement done above in wl1271_probe */
 	pm_runtime_get_noresume(&func->dev);
 
-	platform_device_del(glue->core);
-	platform_device_put(glue->core);
+	platform_device_unregister(glue->core);
 	kfree(glue);
 }
 


