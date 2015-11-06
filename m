Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:47532 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032971AbbKFJjP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 04:39:15 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 20/26] staging: wilc1000: remove function pointer io_init
Date: Fri, 6 Nov 2015 18:40:17 +0900
Message-ID: <1446802823-22598-21-git-send-email-glen.lee@atmel.com> (sfid-20151106_110754_427736_CBE6640D)
In-Reply-To: <1446802823-22598-1-git-send-email-glen.lee@atmel.com>
References: <1446802823-22598-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes function pointer io_init of wilc_wlan_io_func_t and it's
related codes, and call the function linux_spi_init directly.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c   | 2 --
 drivers/staging/wilc1000/wilc_spi.c     | 8 +++-----
 drivers/staging/wilc1000/wilc_wlan_if.h | 1 -
 3 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 3aa636a..119f55d 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -892,11 +892,9 @@ void linux_to_wlan(wilc_wlan_inp_t *nwi, struct wilc *nic)
 
 #ifdef WILC_SDIO
 	nwi->io_func.io_type = HIF_SDIO;
-	nwi->io_func.io_init = linux_sdio_init;
 	nwi->io_func.io_deinit = linux_sdio_deinit;
 #else
 	nwi->io_func.io_type = HIF_SPI;
-	nwi->io_func.io_init = linux_spi_init;
 	nwi->io_func.io_deinit = linux_spi_deinit;
 #endif
 }
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index bda7b10..30b1744 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -966,11 +966,9 @@ static int wilc_spi_init(wilc_wlan_inp_t *inp, wilc_debug_func func)
 
 	g_spi.dPrint = func;
 	g_spi.os_context = inp->os_context.os_private;
-	if (inp->io_func.io_init) {
-		if (!inp->io_func.io_init(g_spi.os_context)) {
-			PRINT_ER("[wilc spi]: Failed io init bus...\n");
-			return 0;
-		}
+	if (!linux_spi_init(g_spi.os_context)) {
+		PRINT_ER("[wilc spi]: Failed io init bus...\n");
+		return 0;
 	} else {
 		return 0;
 	}
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 0f15795..d0b5bc3 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -74,7 +74,6 @@ typedef struct {
 
 typedef struct {
 	int io_type;
-	int (*io_init)(void *);
 	void (*io_deinit)(void *);
 } wilc_wlan_io_func_t;
 
-- 
1.9.1

