Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:54875 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbbJTWsN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 18:48:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-wireless@vger.kernel.org
Cc: Rachel Kim <rachel.kim@atmel.com>, devel@driverdev.osuosl.org,
	Chris Park <chris.park@atmel.com>, gregkh@linuxfoundation.org,
	Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	linux-kernel@vger.kernel.org, Tony Cho <tony.cho@atmel.com>,
	Glen Lee <glen.lee@atmel.com>, Leo Kim <leo.kim@atmel.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 16/19] staging/wilc1000: remove WILC_SDIO/WILC_SPI macros
Date: Wed, 21 Oct 2015 00:47:35 +0200
Message-Id: <1445381258-1455986-17-git-send-email-arnd@arndb.de> (sfid-20151021_005227_079585_80F829D8)
In-Reply-To: <1445381258-1455986-1-git-send-email-arnd@arndb.de>
References: <1445381258-1455986-1-git-send-email-arnd@arndb.de>
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
index b96fee8f94f2..9ce30e92ea3a 100644
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
index d12a4e7df32c..038c9b2eee6c 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1238,7 +1238,10 @@ static void wilc_pllupdate_isr_ext(u32 int_stats)
 	g_wlan.hif_func.hif_clear_int_ext(PLL_INT_CLR);
 
 	/* Waiting for PLL */
-	mdelay(WILC_PLL_TO);
+	if (g_wlan.io_func->io_type == HIF_SDIO)
+		mdelay(WILC_PLL_TO_SDIO);
+	else
+		mdelay(WILC_PLL_TO_SPI);
 
 	/* poll till read a valid data */
 	while (!(ISWILC1000(wilc_get_chipid(true)) && --trials)) {
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 2e9b5d50ff7e..2f636534fc5d 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -143,11 +143,8 @@
 #define WILC_CFG_RSP_STATUS 2
 #define WILC_CFG_RSP_SCAN 3
 
-#ifdef WILC_SDIO
-#define WILC_PLL_TO	4
-#else
-#define WILC_PLL_TO	2
-#endif
+#define WILC_PLL_TO_SDIO	4
+#define WILC_PLL_TO_SPI		2
 
 
 #define ABORT_INT   BIT(31)
-- 
2.1.0.rc2

