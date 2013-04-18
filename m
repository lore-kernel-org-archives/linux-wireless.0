Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:60659 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964925Ab3DRCbS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 22:31:18 -0400
Received: by mail-we0-f181.google.com with SMTP id r6so1729141wey.40
        for <linux-wireless@vger.kernel.org>; Wed, 17 Apr 2013 19:31:16 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 18 Apr 2013 10:31:16 +0800
Message-ID: <CAPgLHd-cTe_+yhaYCDjsqm3Dr+O_VPEB9ansvYb-GVzJXgQfQA@mail.gmail.com> (sfid-20130418_043124_589471_857A8D24)
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

