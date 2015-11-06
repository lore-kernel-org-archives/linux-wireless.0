Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:47329 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161044AbbKFJi2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 04:38:28 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 12/26] staging: wilc1000: remove function pointer spi_tx of wilc_spi_t
Date: Fri, 6 Nov 2015 18:40:09 +0900
Message-ID: <1446802823-22598-13-git-send-email-glen.lee@atmel.com> (sfid-20151106_103836_018629_41CD928B)
In-Reply-To: <1446802823-22598-1-git-send-email-glen.lee@atmel.com>
References: <1446802823-22598-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes function pointer spi_tx of wilc_spi_t and call
linux_spi_write directly.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_spi.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 946bda7..fd0d762 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -10,10 +10,10 @@
 #include <linux/string.h>
 #include "wilc_wlan_if.h"
 #include "wilc_wlan.h"
+#include "linux_wlan_spi.h"
 
 typedef struct {
 	void *os_context;
-	int (*spi_tx)(u8 *, u32);
 	int (*spi_rx)(u8 *, u32);
 	int (*spi_trx)(u8 *, u8 *, u32);
 	int (*spi_max_speed)(void);
@@ -211,7 +211,7 @@ static int spi_cmd(u8 cmd, u32 adr, u32 data, u32 sz, u8 clockless)
 		else
 			len -= 1;
 
-		if (!g_spi.spi_tx(bc, len)) {
+		if (!linux_spi_write(bc, len)) {
 			PRINT_ER("[wilc spi]: Failed cmd write, bus error...\n");
 			result = N_FAIL;
 		}
@@ -709,7 +709,7 @@ static int spi_data_write(u8 *b, u32 sz)
 				order = 0x2;
 		}
 		cmd |= order;
-		if (!g_spi.spi_tx(&cmd, 1)) {
+		if (!linux_spi_write(&cmd, 1)) {
 			PRINT_ER("[wilc spi]: Failed data block cmd write, bus error...\n");
 			result = N_FAIL;
 			break;
@@ -718,7 +718,7 @@ static int spi_data_write(u8 *b, u32 sz)
 		/**
 		 *      Write data
 		 **/
-		if (!g_spi.spi_tx(&b[ix], nbytes)) {
+		if (!linux_spi_write(&b[ix], nbytes)) {
 			PRINT_ER("[wilc spi]: Failed data block write, bus error...\n");
 			result = N_FAIL;
 			break;
@@ -728,7 +728,7 @@ static int spi_data_write(u8 *b, u32 sz)
 		 *      Write Crc
 		 **/
 		if (!g_spi.crc_off) {
-			if (!g_spi.spi_tx(crc, 2)) {
+			if (!linux_spi_write(crc, 2)) {
 				PRINT_ER("[wilc spi]: Failed data block crc write, bus error...\n");
 				result = N_FAIL;
 				break;
@@ -977,7 +977,6 @@ static int wilc_spi_init(wilc_wlan_inp_t *inp, wilc_debug_func func)
 	} else {
 		return 0;
 	}
-	g_spi.spi_tx = inp->io_func.u.spi.spi_tx;
 	g_spi.spi_rx = inp->io_func.u.spi.spi_rx;
 	g_spi.spi_trx = inp->io_func.u.spi.spi_trx;
 	g_spi.spi_max_speed = inp->io_func.u.spi.spi_max_speed;
-- 
1.9.1

