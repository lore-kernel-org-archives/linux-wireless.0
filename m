Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:37704 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031547AbbKFCRw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:17:52 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 58/73] staging: wilc1000: fixes prefer using the BIT macro
Date: Fri, 6 Nov 2015 11:19:57 +0900
Message-ID: <1446776412-30670-9-git-send-email-glen.lee@atmel.com> (sfid-20151106_031755_107492_E9A35D85)
In-Reply-To: <1446776412-30670-1-git-send-email-glen.lee@atmel.com>
References: <1446776412-30670-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch fixes the warning reported by checkpatch.pl
for prefer using the BIT macro.
And, removes unnecessary bit increase defines.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.h | 39 +++++++++++++-----------------------
 1 file changed, 14 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index ba70630..6ca2544 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -110,25 +110,14 @@
 #define WILC_GP_REG_0			0x149c
 #define WILC_GP_REG_1			0x14a0
 
-#define rHAVE_SDIO_IRQ_GPIO_BIT		0
-#define rHAVE_USE_PMU_BIT		1
-#define rHAVE_SLEEP_CLK_SRC_RTC_BIT	2
-#define rHAVE_SLEEP_CLK_SRC_XO_BIT	3
-#define rHAVE_EXT_PA_INV_TX_RX_BIT	4
-#define rHAVE_LEGACY_RF_SETTINGS_BIT	5
-#define rHAVE_XTAL_24_BIT		6
-#define rHAVE_DISABLE_WILC_UART_BIT	7
-
-
-#define WILC_HAVE_SDIO_IRQ_GPIO		(1 << rHAVE_SDIO_IRQ_GPIO_BIT)
-#define WILC_HAVE_USE_PMU		(1 << rHAVE_USE_PMU_BIT)
-#define WILC_HAVE_SLEEP_CLK_SRC_RTC	(1 << rHAVE_SLEEP_CLK_SRC_RTC_BIT)
-#define WILC_HAVE_SLEEP_CLK_SRC_XO	(1 << rHAVE_SLEEP_CLK_SRC_XO_BIT)
-#define WILC_HAVE_EXT_PA_INV_TX_RX	(1 << rHAVE_EXT_PA_INV_TX_RX_BIT)
-#define WILC_HAVE_LEGACY_RF_SETTINGS	(1 << rHAVE_LEGACY_RF_SETTINGS_BIT)
-#define WILC_HAVE_XTAL_24		(1 << rHAVE_XTAL_24_BIT)
-#define WILC_HAVE_DISABLE_WILC_UART	(1 << rHAVE_DISABLE_WILC_UART_BIT)
-
+#define WILC_HAVE_SDIO_IRQ_GPIO		BIT(0)
+#define WILC_HAVE_USE_PMU		BIT(1)
+#define WILC_HAVE_SLEEP_CLK_SRC_RTC	BIT(2)
+#define WILC_HAVE_SLEEP_CLK_SRC_XO	BIT(3)
+#define WILC_HAVE_EXT_PA_INV_TX_RX	BIT(4)
+#define WILC_HAVE_LEGACY_RF_SETTINGS	BIT(5)
+#define WILC_HAVE_XTAL_24		BIT(6)
+#define WILC_HAVE_DISABLE_WILC_UART	BIT(7)
 
 /********************************************
  *
@@ -171,12 +160,12 @@
 /*******************************************/
 #define IRG_FLAGS_OFFSET	16
 #define IRQ_DMA_WD_CNT_MASK	((1ul << IRG_FLAGS_OFFSET) - 1)
-#define INT_0			(1 << IRG_FLAGS_OFFSET)
-#define INT_1			(1 << (IRG_FLAGS_OFFSET + 1))
-#define INT_2			(1 << (IRG_FLAGS_OFFSET + 2))
-#define INT_3			(1 << (IRG_FLAGS_OFFSET + 3))
-#define INT_4			(1 << (IRG_FLAGS_OFFSET + 4))
-#define INT_5			(1 << (IRG_FLAGS_OFFSET + 5))
+#define INT_0			BIT(IRG_FLAGS_OFFSET)
+#define INT_1			BIT(IRG_FLAGS_OFFSET + 1)
+#define INT_2			BIT(IRG_FLAGS_OFFSET + 2)
+#define INT_3			BIT(IRG_FLAGS_OFFSET + 3)
+#define INT_4			BIT(IRG_FLAGS_OFFSET + 4)
+#define INT_5			BIT(IRG_FLAGS_OFFSET + 5)
 #define MAX_NUM_INT		6
 
 /*******************************************/
-- 
1.9.1

