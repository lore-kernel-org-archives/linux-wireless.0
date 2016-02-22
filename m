Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:31687 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbcBVEoq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Feb 2016 23:44:46 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>,
	Chris Park <chris.park@atmel.com>
Subject: [PATCH RESEND 08/10] staging: wilc1000: move MODALIS and GPIO_NUM define to wilc_wlan.h file
Date: Mon, 22 Feb 2016 13:41:17 +0900
Message-ID: <1456116079-7161-8-git-send-email-leo.kim@atmel.com> (sfid-20160222_054448_800120_3D22A85F)
In-Reply-To: <1456116079-7161-1-git-send-email-leo.kim@atmel.com>
References: <1456116079-7161-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chris Park <chris.park@atmel.com>

This patch moves MODALIS and GPIO_NUM define to wilc_wlan.h file.
MODALIS and GPIO_NUM define are used to two files (wilc_sdio.c,
wilc_spi.c), these files already include wilc_wlan.h file in common.

Signed-off-by: Chris Park <chris.park@atmel.com>
Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan_common.h | 2 --
 drivers/staging/wilc1000/wilc_wlan.h         | 2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan_common.h b/drivers/staging/wilc1000/linux_wlan_common.h
index 5a53512..37848c0 100644
--- a/drivers/staging/wilc1000/linux_wlan_common.h
+++ b/drivers/staging/wilc1000/linux_wlan_common.h
@@ -31,7 +31,5 @@
 
 #else
 /* base on SAMA5D3_Xplained Board */
-	#define MODALIAS	"WILC_SPI"
-	#define GPIO_NUM	0x44
 #endif
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 792d338..bcd4bfa 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -131,6 +131,8 @@
 #define LINUX_RX_SIZE		(96 * 1024)
 #define LINUX_TX_SIZE		(64 * 1024)
 
+#define MODALIAS		"WILC_SPI"
+#define GPIO_NUM		0x44
 /*******************************************/
 /*        E0 and later Interrupt flags.    */
 /*******************************************/
-- 
1.9.1

