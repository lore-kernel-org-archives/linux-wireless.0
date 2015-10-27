Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:55828 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbbJ0JRR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 05:17:17 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH] staging: wilc1000: fix build error on SPI
Date: Tue, 27 Oct 2015 18:20:14 +0900
Message-ID: <1445937614-12127-1-git-send-email-glen.lee@atmel.com> (sfid-20151027_101721_124433_7864AD02)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wilc_netdev_init function has parameters to pass but no argument is passed
when bus type SPI is selected. Which causes build error.
This patch passes argument &wilc to the function wilc_netdev_init.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 9f899da..ded302a 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1736,6 +1736,10 @@ int wilc_netdev_init(struct wilc **wilc)
 /*The 1st function called after module inserted*/
 static int __init init_wilc_driver(void)
 {
+#ifdef WILC_SPI
+	struct wilc *wilc;
+#endif
+
 #if defined(WILC_DEBUGFS)
 	if (wilc_debugfs_init() < 0) {
 		PRINT_D(GENERIC_DBG, "fail to create debugfs for wilc driver\n");
@@ -1762,7 +1766,7 @@ static int __init init_wilc_driver(void)
 	}
 #else
 	PRINT_D(INIT_DBG, "Initializing netdev\n");
-	if (wilc_netdev_init())
+	if (wilc_netdev_init(&wilc))
 		PRINT_ER("Couldn't initialize netdev\n");
 	return 0;
 #endif
-- 
1.9.1

