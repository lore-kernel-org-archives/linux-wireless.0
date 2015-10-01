Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33826 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932526AbbJANoV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2015 09:44:21 -0400
Received: by padhy16 with SMTP id hy16so75398648pad.1
        for <linux-wireless@vger.kernel.org>; Thu, 01 Oct 2015 06:44:20 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 04/12] staging: wilc1000: fix indentation level
Date: Thu,  1 Oct 2015 22:43:51 +0900
Message-Id: <1443707039-18433-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20151001_154423_959942_8F90B68E)
In-Reply-To: <1443707039-18433-1-git-send-email-chaehyun.lim@gmail.com>
References: <1443707039-18433-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unnecessary block braces and fix indentation.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index bd83da1..a6642d4 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1967,28 +1967,26 @@ static void __exit exit_wilc_driver(void)
 		}
 	}
 
-	{
-	#ifndef WILC_SDIO
-		PRINT_D(INIT_DBG, "SPI unregsiter...\n");
-		spi_unregister_driver(&wilc_bus);
-	#else
-		PRINT_D(INIT_DBG, "SDIO unregsiter...\n");
-		sdio_unregister_driver(&wilc_bus);
-	#endif
+#ifndef WILC_SDIO
+	PRINT_D(INIT_DBG, "SPI unregsiter...\n");
+	spi_unregister_driver(&wilc_bus);
+#else
+	PRINT_D(INIT_DBG, "SDIO unregsiter...\n");
+	sdio_unregister_driver(&wilc_bus);
+#endif
 
-		if (g_linux_wlan != NULL) {
-			kfree(g_linux_wlan);
-			g_linux_wlan = NULL;
-		}
-		printk("Module_exit Done.\n");
+	if (g_linux_wlan != NULL) {
+		kfree(g_linux_wlan);
+		g_linux_wlan = NULL;
+	}
+	printk("Module_exit Done.\n");
 
 #if defined(WILC_DEBUGFS)
-		wilc_debugfs_remove();
+	wilc_debugfs_remove();
 #endif
 
-		linux_wlan_device_detection(0);
-		linux_wlan_device_power(0);
-	}
+	linux_wlan_device_detection(0);
+	linux_wlan_device_power(0);
 }
 module_exit(exit_wilc_driver);
 
-- 
2.6.0

