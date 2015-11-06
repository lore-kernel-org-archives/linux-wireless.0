Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:47652 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032934AbbKFJji (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 04:39:38 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 24/26] staging: wilc1000: remove os_context
Date: Fri, 6 Nov 2015 18:40:21 +0900
Message-ID: <1446802823-22598-25-git-send-email-glen.lee@atmel.com> (sfid-20151106_110755_836131_E27CDA05)
In-Reply-To: <1446802823-22598-1-git-send-email-glen.lee@atmel.com>
References: <1446802823-22598-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes variable os_context of wilc_sdio_t and wilc_spi_t because
os_context is not used, and delete it's related code.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_sdio.c | 2 --
 drivers/staging/wilc1000/wilc_spi.c  | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 01a8e5b..a5307a7 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -15,7 +15,6 @@
 #define WILC_SDIO_BLOCK_SIZE 512
 
 typedef struct {
-	void *os_context;
 	u32 block_size;
 	wilc_debug_func dPrint;
 	int nint;
@@ -560,7 +559,6 @@ static int sdio_init(wilc_wlan_inp_t *inp, wilc_debug_func func)
 	memset(&g_sdio, 0, sizeof(wilc_sdio_t));
 
 	g_sdio.dPrint = func;
-	g_sdio.os_context = inp->os_context.os_private;
 
 	if (!linux_sdio_init()) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed io init bus...\n");
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index fe16d70..5a6bbfd 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -13,7 +13,6 @@
 #include "linux_wlan_spi.h"
 
 typedef struct {
-	void *os_context;
 	wilc_debug_func dPrint;
 	int crc_off;
 	int nint;
@@ -965,7 +964,6 @@ static int wilc_spi_init(wilc_wlan_inp_t *inp, wilc_debug_func func)
 	memset(&g_spi, 0, sizeof(wilc_spi_t));
 
 	g_spi.dPrint = func;
-	g_spi.os_context = inp->os_context.os_private;
 	if (!linux_spi_init()) {
 		PRINT_ER("[wilc spi]: Failed io init bus...\n");
 		return 0;
-- 
1.9.1

