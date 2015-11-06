Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:47417 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033054AbbKFJiw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 04:38:52 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 16/26] staging: wilc1000: remove function pointer spi_trx
Date: Fri, 6 Nov 2015 18:40:13 +0900
Message-ID: <1446802823-22598-17-git-send-email-glen.lee@atmel.com> (sfid-20151106_103858_625601_6681CE5C)
In-Reply-To: <1446802823-22598-1-git-send-email-glen.lee@atmel.com>
References: <1446802823-22598-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes function pointer spi_trx and call linux_spi_write_read
directly.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_spi.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index f584d7e..789635b 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -14,7 +14,6 @@
 
 typedef struct {
 	void *os_context;
-	int (*spi_trx)(u8 *, u8 *, u32);
 	int (*spi_max_speed)(void);
 	wilc_debug_func dPrint;
 	int crc_off;
@@ -408,7 +407,7 @@ static int spi_cmd_complete(u8 cmd, u32 adr, u8 *b, u32 sz, u8 clockless)
 	}
 	rix = len;
 
-	if (!g_spi.spi_trx(wb, rb, len2)) {
+	if (!linux_spi_write_read(wb, rb, len2)) {
 		PRINT_ER("[wilc spi]: Failed cmd write, bus error...\n");
 		result = N_FAIL;
 		return result;
@@ -976,7 +975,6 @@ static int wilc_spi_init(wilc_wlan_inp_t *inp, wilc_debug_func func)
 	} else {
 		return 0;
 	}
-	g_spi.spi_trx = inp->io_func.u.spi.spi_trx;
 	g_spi.spi_max_speed = inp->io_func.u.spi.spi_max_speed;
 
 	/**
-- 
1.9.1

