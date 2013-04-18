Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f41.google.com ([209.85.214.41]:49022 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935682Ab3DRApx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 20:45:53 -0400
Received: by mail-bk0-f41.google.com with SMTP id i18so1029711bkv.0
        for <linux-wireless@vger.kernel.org>; Wed, 17 Apr 2013 17:45:52 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 18 Apr 2013 08:45:52 +0800
Message-ID: <CAPgLHd_9=2hkXtu1H5DJaQ-pE=AZwwRCrz02xTSxNveW840Rew@mail.gmail.com> (sfid-20130418_024559_734808_73F0B1E9)
Subject: [PATCH] net: rfkill: fix error return code in rfkill_gpio_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: johannes@sipsolutions.net, linville@tuxdriver.com
Cc: yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the error handling
case instead of 0, as returned elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 net/rfkill/rfkill-gpio.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
index 78fc093..6d75e73 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -131,6 +131,7 @@ static int rfkill_gpio_probe(struct platform_device *pdev)
 		rfkill->pwr_clk = clk_get(&pdev->dev, pdata->power_clk_name);
 		if (IS_ERR(rfkill->pwr_clk)) {
 			pr_warn("%s: can't find pwr_clk.\n", __func__);
+			ret = PTR_ERR(rfkill->pwr_clk);
 			goto fail_shutdown_name;
 		}
 	}
@@ -153,8 +154,10 @@ static int rfkill_gpio_probe(struct platform_device *pdev)
 
 	rfkill->rfkill_dev = rfkill_alloc(pdata->name, &pdev->dev, pdata->type,
 				&rfkill_gpio_ops, rfkill);
-	if (!rfkill->rfkill_dev)
+	if (!rfkill->rfkill_dev) {
+		ret = -ENOMEM;
 		goto fail_shutdown;
+	}
 
 	ret = rfkill_register(rfkill->rfkill_dev);
 	if (ret < 0)

