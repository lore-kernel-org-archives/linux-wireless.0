Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:47372 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161044AbbKFJik (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 04:38:40 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 14/26] staging: wilc1000: remove function pointer spi_rx of wilc_spi_t
Date: Fri, 6 Nov 2015 18:40:11 +0900
Message-ID: <1446802823-22598-15-git-send-email-glen.lee@atmel.com> (sfid-20151106_103846_385867_E07129A6)
In-Reply-To: <1446802823-22598-1-git-send-email-glen.lee@atmel.com>
References: <1446802823-22598-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes function pointer spi_rx of wilc_spi_t and just call
linux_spi_read instead.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_spi.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index fd0d762..f584d7e 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -14,7 +14,6 @@
 
 typedef struct {
 	void *os_context;
-	int (*spi_rx)(u8 *, u32);
 	int (*spi_trx)(u8 *, u8 *, u32);
 	int (*spi_max_speed)(void);
 	wilc_debug_func dPrint;
@@ -231,13 +230,13 @@ static int spi_cmd_rsp(u8 cmd)
 	if ((cmd == CMD_RESET) ||
 	    (cmd == CMD_TERMINATE) ||
 	    (cmd == CMD_REPEAT)) {
-		if (!g_spi.spi_rx(&rsp, 1)) {
+		if (!linux_spi_read(&rsp, 1)) {
 			result = N_FAIL;
 			goto _fail_;
 		}
 	}
 
-	if (!g_spi.spi_rx(&rsp, 1)) {
+	if (!linux_spi_read(&rsp, 1)) {
 		PRINT_ER("[wilc spi]: Failed cmd response read, bus error...\n");
 		result = N_FAIL;
 		goto _fail_;
@@ -252,7 +251,7 @@ static int spi_cmd_rsp(u8 cmd)
 	/**
 	 *      State response
 	 **/
-	if (!g_spi.spi_rx(&rsp, 1)) {
+	if (!linux_spi_read(&rsp, 1)) {
 		PRINT_ER("[wilc spi]: Failed cmd state read, bus error...\n");
 		result = N_FAIL;
 		goto _fail_;
@@ -524,7 +523,7 @@ static int spi_cmd_complete(u8 cmd, u32 adr, u8 *b, u32 sz, u8 clockless)
 				/**
 				 * Read bytes
 				 **/
-				if (!g_spi.spi_rx(&b[ix], nbytes)) {
+				if (!linux_spi_read(&b[ix], nbytes)) {
 					PRINT_ER("[wilc spi]: Failed data block read, bus error...\n");
 					result = N_FAIL;
 					goto _error_;
@@ -534,7 +533,7 @@ static int spi_cmd_complete(u8 cmd, u32 adr, u8 *b, u32 sz, u8 clockless)
 				 * Read Crc
 				 **/
 				if (!g_spi.crc_off) {
-					if (!g_spi.spi_rx(crc, 2)) {
+					if (!linux_spi_read(crc, 2)) {
 						PRINT_ER("[wilc spi]: Failed data block crc read, bus error...\n");
 						result = N_FAIL;
 						goto _error_;
@@ -565,7 +564,7 @@ static int spi_cmd_complete(u8 cmd, u32 adr, u8 *b, u32 sz, u8 clockless)
 				 **/
 				retry = 10;
 				do {
-					if (!g_spi.spi_rx(&rsp, 1)) {
+					if (!linux_spi_read(&rsp, 1)) {
 						PRINT_ER("[wilc spi]: Failed data response read, bus error...\n");
 						result = N_FAIL;
 						break;
@@ -581,7 +580,7 @@ static int spi_cmd_complete(u8 cmd, u32 adr, u8 *b, u32 sz, u8 clockless)
 				/**
 				 * Read bytes
 				 **/
-				if (!g_spi.spi_rx(&b[ix], nbytes)) {
+				if (!linux_spi_read(&b[ix], nbytes)) {
 					PRINT_ER("[wilc spi]: Failed data block read, bus error...\n");
 					result = N_FAIL;
 					break;
@@ -591,7 +590,7 @@ static int spi_cmd_complete(u8 cmd, u32 adr, u8 *b, u32 sz, u8 clockless)
 				 * Read Crc
 				 **/
 				if (!g_spi.crc_off) {
-					if (!g_spi.spi_rx(crc, 2)) {
+					if (!linux_spi_read(crc, 2)) {
 						PRINT_ER("[wilc spi]: Failed data block crc read, bus error...\n");
 						result = N_FAIL;
 						break;
@@ -629,7 +628,7 @@ static int spi_data_read(u8 *b, u32 sz)
 		 **/
 		retry = 10;
 		do {
-			if (!g_spi.spi_rx(&rsp, 1)) {
+			if (!linux_spi_read(&rsp, 1)) {
 				PRINT_ER("[wilc spi]: Failed data response read, bus error...\n");
 				result = N_FAIL;
 				break;
@@ -650,7 +649,7 @@ static int spi_data_read(u8 *b, u32 sz)
 		/**
 		 *      Read bytes
 		 **/
-		if (!g_spi.spi_rx(&b[ix], nbytes)) {
+		if (!linux_spi_read(&b[ix], nbytes)) {
 			PRINT_ER("[wilc spi]: Failed data block read, bus error...\n");
 			result = N_FAIL;
 			break;
@@ -660,7 +659,7 @@ static int spi_data_read(u8 *b, u32 sz)
 		 *      Read Crc
 		 **/
 		if (!g_spi.crc_off) {
-			if (!g_spi.spi_rx(crc, 2)) {
+			if (!linux_spi_read(crc, 2)) {
 				PRINT_ER("[wilc spi]: Failed data block crc read, bus error...\n");
 				result = N_FAIL;
 				break;
@@ -977,7 +976,6 @@ static int wilc_spi_init(wilc_wlan_inp_t *inp, wilc_debug_func func)
 	} else {
 		return 0;
 	}
-	g_spi.spi_rx = inp->io_func.u.spi.spi_rx;
 	g_spi.spi_trx = inp->io_func.u.spi.spi_trx;
 	g_spi.spi_max_speed = inp->io_func.u.spi.spi_max_speed;
 
-- 
1.9.1

