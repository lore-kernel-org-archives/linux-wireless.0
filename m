Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:5054 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757214AbcBSKAw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2016 05:00:52 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>,
	Chris Park <chris.park@atmel.com>
Subject: [PATCH 3/4] staging: wilc1000: remove useless define in linux_wlan_common.h file
Date: Fri, 19 Feb 2016 18:57:44 +0900
Message-ID: <1455875865-15505-3-git-send-email-leo.kim@atmel.com> (sfid-20160219_110122_090452_3EEB93A5)
In-Reply-To: <1455875865-15505-1-git-send-email-leo.kim@atmel.com>
References: <1455875865-15505-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chris Park <chris.park@atmel.com>

This patch removes useless define in linux_wlan_common.h file

Signed-off-by: Chris Park <chris.park@atmel.com>
Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan_common.h | 32 ----------------------------
 1 file changed, 32 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan_common.h b/drivers/staging/wilc1000/linux_wlan_common.h
index 37848c0..18d902b 100644
--- a/drivers/staging/wilc1000/linux_wlan_common.h
+++ b/drivers/staging/wilc1000/linux_wlan_common.h
@@ -1,35 +1,3 @@
 #ifndef LINUX_WLAN_COMMON_H
 #define LINUX_WLAN_COMMON_H
-
-#if defined(BEAGLE_BOARD)
-	#define SPI_CHANNEL	4
-
-	#if SPI_CHANNEL == 4
-		#define MODALIAS	"wilc_spi4"
-		#define GPIO_NUM	162
-	#else
-		#define MODALIAS	"wilc_spi3"
-		#define GPIO_NUM	133
-	#endif
-#elif defined(PLAT_WMS8304)             /* rachel */
-	#define MODALIAS	"wilc_spi"
-	#define GPIO_NUM	139
-#elif defined(PLAT_RKXXXX)
- #define MODALIAS	"WILC_IRQ"
- #define GPIO_NUM	RK30_PIN3_PD2 /* RK30_PIN3_PA1 */
-/* RK30_PIN3_PD2 */
-/* RK2928_PIN1_PA7 */
-
-#elif defined(CUSTOMER_PLATFORM)
-/*
- TODO : specify MODALIAS name and GPIO number. This is certainly necessary for SPI interface.
- *
- * ex)
- * #define MODALIAS  "WILC_SPI"
- * #define GPIO_NUM  139
- */
-
-#else
-/* base on SAMA5D3_Xplained Board */
-#endif
 #endif
-- 
1.9.1

