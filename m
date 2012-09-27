Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:57600 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649Ab2I0JRV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 05:17:21 -0400
From: Luciano Coelho <luca@coelho.fi>
To: coelho@ti.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] wl12xx: use module_platform_driver
Date: Thu, 27 Sep 2012 12:06:20 +0300
Message-Id: <1348736780-3165-1-git-send-email-luca@coelho.fi> (sfid-20120927_111724_622612_DA27C965)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use a module_platform_driver declaration instead of replicating the
init and exit functions in the driver.

Based on the patch for wl18xx by Devendra Naga.

Signed-off-by: Luciano Coelho <luca@coelho.fi>
---
 drivers/net/wireless/ti/wl12xx/main.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index f429fc1..30ca727 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1714,17 +1714,7 @@ static struct platform_driver wl12xx_driver = {
 	}
 };
 
-static int __init wl12xx_init(void)
-{
-	return platform_driver_register(&wl12xx_driver);
-}
-module_init(wl12xx_init);
-
-static void __exit wl12xx_exit(void)
-{
-	platform_driver_unregister(&wl12xx_driver);
-}
-module_exit(wl12xx_exit);
+module_platform_driver(wl12xx_driver);
 
 module_param_named(fref, fref_param, charp, 0);
 MODULE_PARM_DESC(fref, "FREF clock: 19.2, 26, 26x, 38.4, 38.4x, 52");
-- 
1.7.10.4

