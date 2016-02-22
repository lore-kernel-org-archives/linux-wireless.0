Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:20945 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176AbcBVKUu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2016 05:20:50 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>,
	Chris Park <chris.park@atmel.com>
Subject: [PATCH V4 22/24] staging: wilc1000: removes usused PRINT_XX(region...)
Date: Mon, 22 Feb 2016 19:14:29 +0900
Message-ID: <1456136071-10502-23-git-send-email-leo.kim@atmel.com> (sfid-20160222_112101_482962_917709F2)
In-Reply-To: <1456136071-10502-1-git-send-email-leo.kim@atmel.com>
References: <1456136071-10502-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chris Park <chris.park@atmel.com>

This patch removes unused PRINT_XX(region...)
because already removed in used to region feature of whole wilc source.
Also, removes unnecessary related region extern variable.

Signed-off-by: Chris Park <chris.park@atmel.com>
Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan_common.h | 69 ----------------------------
 1 file changed, 69 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan_common.h b/drivers/staging/wilc1000/linux_wlan_common.h
index 57d3901..2e2109c 100644
--- a/drivers/staging/wilc1000/linux_wlan_common.h
+++ b/drivers/staging/wilc1000/linux_wlan_common.h
@@ -2,83 +2,14 @@
 #define LINUX_WLAN_COMMON_H
 
 #if defined(WILC_DEBUGFS)
-extern atomic_t WILC_DEBUG_LEVEL;
-
 #define DEBUG           BIT(0)
 #define INFO            BIT(1)
 #define WRN             BIT(2)
 #define ERR             BIT(3)
-
-#define PRINT_D(region, ...)						\
-	do {								\
-		if ((atomic_read(&WILC_DEBUG_LEVEL) & DEBUG)) {	\
-			printk("DBG [%s: %d]", __func__, __LINE__);	\
-			printk(__VA_ARGS__);				\
-		}							\
-	} while (0)
-
-#define PRINT_INFO(region, ...)						\
-	do {								\
-		if ((atomic_read(&WILC_DEBUG_LEVEL) & INFO)) {	\
-			printk("INFO [%s]", __func__);			\
-			printk(__VA_ARGS__);				\
-		}							\
-	} while (0)
-
-#define PRINT_WRN(region, ...)						\
-	do {								\
-		if ((atomic_read(&WILC_DEBUG_LEVEL) & WRN)) {	\
-			printk("WRN [%s: %d]", __func__, __LINE__);	\
-			printk(__VA_ARGS__);				\
-		}							\
-	} while (0)
-
-#define PRINT_ER(...)							\
-	do {								\
-		if ((atomic_read(&WILC_DEBUG_LEVEL) & ERR)) {	\
-			printk("ERR [%s: %d]", __func__, __LINE__);	\
-			printk(__VA_ARGS__);				\
-		}							\
-	} while (0)
-
 #else
-
-#define REGION  (INIT_DBG | GENERIC_DBG | CFG80211_DBG | FIRM_DBG | HOSTAPD_DBG)
-
 #define DEBUG       1
 #define INFO        0
 #define WRN         0
-
-#define PRINT_D(region, ...)						\
-	do {								\
-		if (DEBUG == 1 && ((REGION)&(region))) {		\
-			printk("DBG [%s: %d]", __func__, __LINE__);	\
-			printk(__VA_ARGS__);				\
-		}							\
-	} while (0)
-
-#define PRINT_INFO(region, ...)						\
-	do {								\
-		if (INFO == 1 && ((REGION)&(region))) {			\
-			printk("INFO [%s]", __func__);			\
-			printk(__VA_ARGS__);				\
-		}							\
-	} while (0)
-
-#define PRINT_WRN(region, ...)						\
-	do {								\
-		if (WRN == 1 && ((REGION)&(region))) {			\
-			printk("WRN [%s: %d]", __func__, __LINE__);	\
-			printk(__VA_ARGS__);				\
-		}							\
-	} while (0)
-
-#define PRINT_ER(...)							\
-	do {								\
-		printk("ERR [%s: %d]", __func__, __LINE__);		\
-		printk(__VA_ARGS__);					\
-	} while (0)
-
 #endif
 
 #define LINUX_RX_SIZE	(96 * 1024)
-- 
1.9.1

