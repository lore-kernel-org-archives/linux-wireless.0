Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:40813 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424646AbcBRHeE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2016 02:34:04 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>,
	Chris Park <chris.park@atmel.com>
Subject: [PATCH 24/24] staging: wilc1000: moves LINUX_RX_SIZE, LINUX_TX_SIZE
Date: Thu, 18 Feb 2016 16:27:35 +0900
Message-ID: <1455780455-21365-24-git-send-email-leo.kim@atmel.com> (sfid-20160218_083409_373578_A3B6303B)
In-Reply-To: <1455780455-21365-1-git-send-email-leo.kim@atmel.com>
References: <1455780455-21365-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chris Park <chris.park@atmel.com>

This patch moves LINUX_RX_SIZE and LINUX_TX_SIZE to wilc_wlan.h file
because there are only used to wilc_wlan.c file.

Signed-off-by: Chris Park <chris.park@atmel.com>
Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan_common.h | 4 ----
 drivers/staging/wilc1000/wilc_wlan.h         | 3 +++
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan_common.h b/drivers/staging/wilc1000/linux_wlan_common.h
index 51601aa..aa2c026 100644
--- a/drivers/staging/wilc1000/linux_wlan_common.h
+++ b/drivers/staging/wilc1000/linux_wlan_common.h
@@ -1,10 +1,6 @@
 #ifndef LINUX_WLAN_COMMON_H
 #define LINUX_WLAN_COMMON_H
 
-#define LINUX_RX_SIZE	(96 * 1024)
-#define LINUX_TX_SIZE	(64 * 1024)
-
-
 #define WILC_MULTICAST_TABLE_SIZE	8
 
 #if defined(BEAGLE_BOARD)
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 06d02ab..792d338 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -128,6 +128,9 @@
 #define WILC_PLL_TO_SPI		2
 #define ABORT_INT		BIT(31)
 
+#define LINUX_RX_SIZE		(96 * 1024)
+#define LINUX_TX_SIZE		(64 * 1024)
+
 /*******************************************/
 /*        E0 and later Interrupt flags.    */
 /*******************************************/
-- 
1.9.1

