Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:34578 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab2JWFWs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Oct 2012 01:22:48 -0400
Received: by mail-qc0-f174.google.com with SMTP id o22so1961428qcr.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Oct 2012 22:22:48 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 23 Oct 2012 13:22:48 +0800
Message-ID: <CAPgLHd_nBOfMzHuL3GtwOjsV3+jKMdCxL+cJr9xT0-0fBGabrQ@mail.gmail.com> (sfid-20121023_072255_031357_CE137544)
Subject: [PATCH] wlcore: spi: use platform_device_unregister in wl1271_remove()
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
 drivers/net/wireless/ti/wlcore/spi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/spi.c b/drivers/net/wireless/ti/wlcore/spi.c
index a519bc3..76838a4 100644
--- a/drivers/net/wireless/ti/wlcore/spi.c
+++ b/drivers/net/wireless/ti/wlcore/spi.c
@@ -407,8 +407,7 @@ static int __devexit wl1271_remove(struct spi_device *spi)
 {
 	struct wl12xx_spi_glue *glue = spi_get_drvdata(spi);
 
-	platform_device_del(glue->core);
-	platform_device_put(glue->core);
+	platform_device_unregister(glue->core);
 	kfree(glue);
 
 	return 0;


