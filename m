Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:26536 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030348AbbKEFe1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 00:34:27 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 10/38] staging: wilc1000: linux_wlan: remove unused define CUSTOMER_PLATFORM
Date: Thu, 5 Nov 2015 14:36:11 +0900
Message-ID: <1446701799-24870-10-git-send-email-glen.lee@atmel.com> (sfid-20151105_063430_585307_62294CED)
In-Reply-To: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
References: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch remove unused define CUSTOMER_PLATFORM from linux_wlan.c.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index d50f0d6..a9052ed 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -31,18 +31,11 @@
 #include "linux_wlan_spi.h"
 #endif
 
-#if defined(CUSTOMER_PLATFORM)
-/*
- TODO : Write power control functions as customer platform.
- */
-#else
-
  #define _linux_wlan_device_power_on()		{}
  #define _linux_wlan_device_power_off()		{}
 
  #define _linux_wlan_device_detection()		{}
  #define _linux_wlan_device_removal()		{}
-#endif
 
 extern bool g_obtainingIP;
 extern void resolve_disconnect_aberration(void *drvHandler);
@@ -278,15 +271,7 @@ static int init_irq(struct net_device *dev)
 	/*GPIO request*/
 	if ((gpio_request(GPIO_NUM, "WILC_INTR") == 0) &&
 	    (gpio_direction_input(GPIO_NUM) == 0)) {
-#if defined(CUSTOMER_PLATFORM)
-/*
- TODO : save the registerd irq number to the private wilc context in kernel.
- *
- * ex) nic->dev_irq_num = gpio_to_irq(GPIO_NUM);
- */
-#else
 		wl->dev_irq_num = gpio_to_irq(GPIO_NUM);
-#endif
 	} else {
 		ret = -1;
 		PRINT_ER("could not obtain gpio for WILC_INTR\n");
-- 
1.9.1

