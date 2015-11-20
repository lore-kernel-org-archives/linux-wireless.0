Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:53447 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758949AbbKTHxP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2015 02:53:15 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 1/6] staging: wilc1000: remove unused variable
Date: Fri, 20 Nov 2015 16:56:31 +0900
Message-ID: <1448006196-28555-1-git-send-email-glen.lee@atmel.com> (sfid-20151120_085321_544788_02A7BC57)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wilc_sdio_func is not used anymore so just delete it.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan_sdio.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index 92633aa..ae31f7d 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -11,8 +11,6 @@
 
 #define SDIO_MODALIAS "wilc1000_sdio"
 
-static struct sdio_func *wilc_sdio_func;
-
 #define SDIO_VENDOR_ID_WILC 0x0296
 #define SDIO_DEVICE_ID_WILC 0x5347
 
@@ -105,7 +103,6 @@ static int linux_sdio_probe(struct sdio_func *func, const struct sdio_device_id
 	}
 
 	PRINT_D(INIT_DBG, "Initializing netdev\n");
-	wilc_sdio_func = func;
 	if (wilc_netdev_init(&wilc, &func->dev, HIF_SDIO, gpio,
 			     &wilc_hif_sdio)) {
 		PRINT_ER("Couldn't initialize netdev\n");
-- 
1.9.1

