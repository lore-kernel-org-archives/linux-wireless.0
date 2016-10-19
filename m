Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:55827 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S943765AbcJSPA6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Oct 2016 11:00:58 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Wim Van Sebroeck <wim@iguana.be>,
        Guenter Roeck <linux@roeck-us.net>
Cc: Alexander Usyskin <alexander.usyskin@intel.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-watchdog@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 2/5] watchdog: mei_wdt: use module_mei_cl_driver macro
Date: Wed, 19 Oct 2016 16:33:28 +0300
Message-Id: <1476884011-20645-3-git-send-email-tomas.winkler@intel.com> (sfid-20161019_174150_683185_81DD8F39)
In-Reply-To: <1476884011-20645-1-git-send-email-tomas.winkler@intel.com>
References: <1476884011-20645-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace boilerplate driver registration with module_mei_cl_driver macro.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/watchdog/mei_wdt.c | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/drivers/watchdog/mei_wdt.c b/drivers/watchdog/mei_wdt.c
index 630bd189f167..116be477c8fd 100644
--- a/drivers/watchdog/mei_wdt.c
+++ b/drivers/watchdog/mei_wdt.c
@@ -699,25 +699,7 @@ static struct mei_cl_driver mei_wdt_driver = {
 	.remove = mei_wdt_remove,
 };
 
-static int __init mei_wdt_init(void)
-{
-	int ret;
-
-	ret = mei_cldev_driver_register(&mei_wdt_driver);
-	if (ret) {
-		pr_err(KBUILD_MODNAME ": module registration failed\n");
-		return ret;
-	}
-	return 0;
-}
-
-static void __exit mei_wdt_exit(void)
-{
-	mei_cldev_driver_unregister(&mei_wdt_driver);
-}
-
-module_init(mei_wdt_init);
-module_exit(mei_wdt_exit);
+module_mei_cl_driver(mei_wdt_driver);
 
 MODULE_AUTHOR("Intel Corporation");
 MODULE_LICENSE("GPL");
-- 
2.7.4
