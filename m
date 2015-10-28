Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:6088 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932312AbbJ1Hqh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:46:37 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 11/12] staging: wilc1000: rename os_context to wilc
Date: Wed, 28 Oct 2015 16:48:27 +0900
Message-ID: <1446018508-17889-11-git-send-email-glen.lee@atmel.com> (sfid-20151028_084644_565737_3B966A34)
In-Reply-To: <1446018508-17889-1-git-send-email-glen.lee@atmel.com>
References: <1446018508-17889-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch rename os_context to wilc because it is used as struct wilc and
move os_private from struct wilc_wlan_os_context_t to struct wilc_wlan_inp_t.
Finally, delete wilc_wlan_os_context_t.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c   | 2 +-
 drivers/staging/wilc1000/wilc_sdio.c    | 6 +++---
 drivers/staging/wilc1000/wilc_spi.c     | 6 +++---
 drivers/staging/wilc1000/wilc_wlan_if.h | 6 +-----
 4 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 017799f..d0161cd 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1012,7 +1012,7 @@ void linux_to_wlan(wilc_wlan_inp_t *nwi, struct wilc *nic)
 
 	PRINT_D(INIT_DBG, "Linux to Wlan services ...\n");
 
-	nwi->os_context.os_private = (void *)nic;
+	nwi->wilc = (void *)nic;
 
 #ifdef WILC_SDIO
 	nwi->io_func.io_type = HIF_SDIO;
diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 300c571..82f68eb 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -14,7 +14,7 @@
 #define WILC_SDIO_BLOCK_SIZE 512
 
 typedef struct {
-	void *os_context;
+	void *wilc;
 	u32 block_size;
 	int (*sdio_cmd52)(sdio_cmd52_t *);
 	int (*sdio_cmd53)(sdio_cmd53_t *);
@@ -563,10 +563,10 @@ static int sdio_init(wilc_wlan_inp_t *inp, wilc_debug_func func)
 	memset(&g_sdio, 0, sizeof(wilc_sdio_t));
 
 	g_sdio.dPrint = func;
-	g_sdio.os_context = inp->os_context.os_private;
+	g_sdio.wilc = inp->wilc;
 
 	if (inp->io_func.io_init) {
-		if (!inp->io_func.io_init(g_sdio.os_context)) {
+		if (!inp->io_func.io_init(g_sdio.wilc)) {
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed io init bus...\n");
 			return 0;
 		}
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 599508b..9a72fbb 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -12,7 +12,7 @@
 #include "wilc_wlan.h"
 
 typedef struct {
-	void *os_context;
+	void *wilc;
 	int (*spi_tx)(u8 *, u32);
 	int (*spi_rx)(u8 *, u32);
 	int (*spi_trx)(u8 *, u8 *, u32);
@@ -968,9 +968,9 @@ static int spi_init(wilc_wlan_inp_t *inp, wilc_debug_func func)
 	memset(&g_spi, 0, sizeof(wilc_spi_t));
 
 	g_spi.dPrint = func;
-	g_spi.os_context = inp->os_context.os_private;
+	g_spi.wilc = inp->wilc;
 	if (inp->io_func.io_init) {
-		if (!inp->io_func.io_init(g_spi.os_context)) {
+		if (!inp->io_func.io_init(g_spi.wilc)) {
 			PRINT_ER("[wilc spi]: Failed io init bus...\n");
 			return 0;
 		}
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 139cc6d..a6bf969 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -99,11 +99,7 @@ typedef struct {
 #define WILC_MAC_INDICATE_SCAN		0x2
 
 typedef struct {
-	void *os_private;
-} wilc_wlan_os_context_t;
-
-typedef struct {
-	wilc_wlan_os_context_t os_context;
+	void *wilc;
 	wilc_wlan_io_func_t io_func;
 } wilc_wlan_inp_t;
 
-- 
1.9.1

