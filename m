Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:44672 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321Ab2HOIlV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2012 04:41:21 -0400
Received: by ghrr11 with SMTP id r11so1510307ghr.19
        for <linux-wireless@vger.kernel.org>; Wed, 15 Aug 2012 01:41:21 -0700 (PDT)
From: Syam Sidhardhan <syamsidhardh@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, lauro.venancio@openbossa.org,
	aloisio.almeida@openbossa.org, sameo@linux.intel.com
Subject: [PATCH] NFC: use module_platform_driver macro for nfcwilink.c
Date: Wed, 15 Aug 2012 14:04:10 +0530
Message-Id: <1345019650-5030-1-git-send-email-s.syam@samsung.com> (sfid-20120815_104128_419559_691FCBF7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simplify the code by make use of module_platform_driver macro.

Signed-off-by: Syam Sidhardhan <s.syam@samsung.com>
---
 drivers/nfc/nfcwilink.c |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/drivers/nfc/nfcwilink.c b/drivers/nfc/nfcwilink.c
index e7fd493..827f039 100644
--- a/drivers/nfc/nfcwilink.c
+++ b/drivers/nfc/nfcwilink.c
@@ -604,21 +604,7 @@ static struct platform_driver nfcwilink_driver = {
 	},
 };
 
-/* ------- Module Init/Exit interfaces ------ */
-static int __init nfcwilink_init(void)
-{
-	printk(KERN_INFO "NFC Driver for TI WiLink");
-
-	return platform_driver_register(&nfcwilink_driver);
-}
-
-static void __exit nfcwilink_exit(void)
-{
-	platform_driver_unregister(&nfcwilink_driver);
-}
-
-module_init(nfcwilink_init);
-module_exit(nfcwilink_exit);
+module_platform_driver(nfcwilink_driver);
 
 /* ------ Module Info ------ */
 
-- 
1.7.9.5

