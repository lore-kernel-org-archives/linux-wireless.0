Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:56929 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbbKJXnC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2015 18:43:02 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 17/20] staging/wilc1000: remove WILC_SDIO/WILC_SPI macros
Date: Wed, 11 Nov 2015 00:42:37 +0100
Message-Id: <1447198960-2760143-18-git-send-email-arnd@arndb.de> (sfid-20151111_004511_810830_88D44A86)
In-Reply-To: <1447198960-2760143-1-git-send-email-arnd@arndb.de>
References: <1447198960-2760143-1-git-send-email-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The last remaining user of WILC_SDIO macro checks for the correct
time to wait in an interrupt for the PLL to settle. We can
replace this with a runtime check and remove both WILC_SDIO and
WILC_SPI, as we no longer need conditional compilation based on
the hardware type.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/wilc1000/Makefile    | 3 +--
 drivers/staging/wilc1000/wilc_wlan.c | 5 ++++-
 drivers/staging/wilc1000/wilc_wlan.h | 7 ++-----
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/Makefile b/drivers/staging/wilc1000/Makefile
index fe480c76c521..dcba27bd3bce 100644
--- a/drivers/staging/wilc1000/Makefile
+++ b/drivers/staging/wilc1000/Makefile
@@ -1,7 +1,6 @@
 obj-$(CONFIG_WILC1000) += wilc1000.o
 
-ccflags-$(CONFIG_WILC1000_SDIO) += -DWILC_SDIO -DCOMPLEMENT_BOOT
-ccflags-$(CONFIG_WILC1000_SPI) += -DWILC_SPI
+ccflags-$(CONFIG_WILC1000_SDIO) += -DCOMPLEMENT_BOOT
 
 ccflags-y += -DSTA_FIRMWARE=\"atmel/wilc1000_fw.bin\" \
 		-DAP_FIRMWARE=\"atmel/wilc1000_ap_fw.bin\" \
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 5e37ec65d3bb..f72f976906cc 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1067,7 +1067,10 @@ static void wilc_pllupdate_isr_ext(u32 int_stats)
 
 	g_wlan.hif_func.hif_clear_int_ext(PLL_INT_CLR);
 
-	mdelay(WILC_PLL_TO);
+	if (g_wlan.io_type == HIF_SDIO)
+		mdelay(WILC_PLL_TO_SDIO);
+	else
+		mdelay(WILC_PLL_TO_SPI);
 
 	while (!(ISWILC1000(wilc_get_chipid(true)) && --trials)) {
 		PRINT_D(TX_DBG, "PLL update retrying\n");
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 44a590f80def..90ef650e722d 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -134,11 +134,8 @@
 #define WILC_CFG_RSP_STATUS	2
 #define WILC_CFG_RSP_SCAN	3
 
-#ifdef WILC_SDIO
-#define WILC_PLL_TO		4
-#else
-#define WILC_PLL_TO		2
-#endif
+#define WILC_PLL_TO_SDIO	4
+#define WILC_PLL_TO_SPI		2
 #define ABORT_INT		BIT(31)
 
 /*******************************************/
-- 
2.1.0.rc2

