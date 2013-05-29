Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:43991 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965541Ab3E2KcY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 May 2013 06:32:24 -0400
Received: by mail-pb0-f44.google.com with SMTP id wz12so9054475pbc.17
        for <linux-wireless@vger.kernel.org>; Wed, 29 May 2013 03:32:23 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, davem@davemloft.net, coelho@ti.com,
	linville@tuxdriver.com, sachin.kamat@linaro.org
Subject: [PATCH 1/2] net: wireless: wl1251: Use module_spi_driver macro
Date: Wed, 29 May 2013 15:48:22 +0530
Message-Id: <1369822703-27769-1-git-send-email-sachin.kamat@linaro.org> (sfid-20130529_123228_083414_5204443A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

module_spi_driver() eliminates some boiler plate and makes code
simpler.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/net/wireless/ti/wl1251/spi.c |   24 +-----------------------
 1 file changed, 1 insertion(+), 23 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/spi.c b/drivers/net/wireless/ti/wl1251/spi.c
index 4c67c2f..dfd0877 100644
--- a/drivers/net/wireless/ti/wl1251/spi.c
+++ b/drivers/net/wireless/ti/wl1251/spi.c
@@ -329,29 +329,7 @@ static struct spi_driver wl1251_spi_driver = {
 	.remove		= wl1251_spi_remove,
 };
 
-static int __init wl1251_spi_init(void)
-{
-	int ret;
-
-	ret = spi_register_driver(&wl1251_spi_driver);
-	if (ret < 0) {
-		wl1251_error("failed to register spi driver: %d", ret);
-		goto out;
-	}
-
-out:
-	return ret;
-}
-
-static void __exit wl1251_spi_exit(void)
-{
-	spi_unregister_driver(&wl1251_spi_driver);
-
-	wl1251_notice("unloaded");
-}
-
-module_init(wl1251_spi_init);
-module_exit(wl1251_spi_exit);
+module_spi_driver(wl1251_spi_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Kalle Valo <kvalo@adurom.com>");
-- 
1.7.9.5

