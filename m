Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:55827 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S943740AbcJSPAx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Oct 2016 11:00:53 -0400
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
Subject: [char-misc-next 3/5] nfc: mei: use module_mei_cl_driver macro
Date: Wed, 19 Oct 2016 16:33:29 +0300
Message-Id: <1476884011-20645-4-git-send-email-tomas.winkler@intel.com> (sfid-20161019_174201_929276_68EEC5CF)
In-Reply-To: <1476884011-20645-1-git-send-email-tomas.winkler@intel.com>
References: <1476884011-20645-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace boilerplate driver registration with module_mei_cl_driver
macro in pn544 and microread devices.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/nfc/microread/mei.c | 23 +----------------------
 drivers/nfc/pn544/mei.c     | 23 +----------------------
 2 files changed, 2 insertions(+), 44 deletions(-)

diff --git a/drivers/nfc/microread/mei.c b/drivers/nfc/microread/mei.c
index 3092501f26c4..eb5eddf1794e 100644
--- a/drivers/nfc/microread/mei.c
+++ b/drivers/nfc/microread/mei.c
@@ -82,28 +82,7 @@ static struct mei_cl_driver microread_driver = {
 	.remove = microread_mei_remove,
 };
 
-static int microread_mei_init(void)
-{
-	int r;
-
-	pr_debug(DRIVER_DESC ": %s\n", __func__);
-
-	r = mei_cldev_driver_register(&microread_driver);
-	if (r) {
-		pr_err(MICROREAD_DRIVER_NAME ": driver registration failed\n");
-		return r;
-	}
-
-	return 0;
-}
-
-static void microread_mei_exit(void)
-{
-	mei_cldev_driver_unregister(&microread_driver);
-}
-
-module_init(microread_mei_init);
-module_exit(microread_mei_exit);
+module_mei_cl_driver(microread_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION(DRIVER_DESC);
diff --git a/drivers/nfc/pn544/mei.c b/drivers/nfc/pn544/mei.c
index 46d0eb24eef9..ad57a8ec00d6 100644
--- a/drivers/nfc/pn544/mei.c
+++ b/drivers/nfc/pn544/mei.c
@@ -82,28 +82,7 @@ static struct mei_cl_driver pn544_driver = {
 	.remove = pn544_mei_remove,
 };
 
-static int pn544_mei_init(void)
-{
-	int r;
-
-	pr_debug(DRIVER_DESC ": %s\n", __func__);
-
-	r = mei_cldev_driver_register(&pn544_driver);
-	if (r) {
-		pr_err(PN544_DRIVER_NAME ": driver registration failed\n");
-		return r;
-	}
-
-	return 0;
-}
-
-static void pn544_mei_exit(void)
-{
-	mei_cldev_driver_unregister(&pn544_driver);
-}
-
-module_init(pn544_mei_init);
-module_exit(pn544_mei_exit);
+module_mei_cl_driver(pn544_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION(DRIVER_DESC);
-- 
2.7.4
