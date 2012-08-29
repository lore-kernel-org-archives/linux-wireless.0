Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59491 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212Ab2H2RdK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Aug 2012 13:33:10 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr13so1592856pbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Aug 2012 10:33:10 -0700 (PDT)
From: Devendra Naga <devendra.aaru@gmail.com>
To: Luciano Coelho <coelho@ti.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Arik Nemtsov <arik@wizery.com>, Ido Reis <idor@ti.com>,
	linux-wireless@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH] wl18xx: use module_platform_driver
Date: Wed, 29 Aug 2012 23:03:01 +0530
Message-Id: <1346261581-21613-1-git-send-email-devendra.aaru@gmail.com> (sfid-20120829_193315_065672_4F59F9B6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

the driver's init and exit routines can be implemented with the
module_platform_driver, as the init and exit code is same as
that of the module_platform_driver

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 69042bb..0b3e21b 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1539,18 +1539,7 @@ static struct platform_driver wl18xx_driver = {
 	}
 };
 
-static int __init wl18xx_init(void)
-{
-	return platform_driver_register(&wl18xx_driver);
-}
-module_init(wl18xx_init);
-
-static void __exit wl18xx_exit(void)
-{
-	platform_driver_unregister(&wl18xx_driver);
-}
-module_exit(wl18xx_exit);
-
+module_platform_driver(wl18xx_driver);
 module_param_named(ht_mode, ht_mode_param, charp, S_IRUSR);
 MODULE_PARM_DESC(ht_mode, "Force HT mode: wide or siso20");
 
-- 
1.7.9.5

