Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:47980 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362AbbG1Ist (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2015 04:48:49 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <austin.shin@atmel.com>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<jude.lee@atmel.com>, <robin.hwang@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 07/21] staging: wilc1000: remove preprocessor conditionals unused
Date: Tue, 28 Jul 2015 17:47:26 +0900
Message-ID: <1438073261-28315-8-git-send-email-tony.cho@atmel.com> (sfid-20150728_104856_118608_ED90975B)
In-Reply-To: <1438073261-28315-1-git-send-email-tony.cho@atmel.com>
References: <1438073261-28315-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unused preprocessor conditionals for the
PLAT_AML8726_M3_BACKUP and PLAT_AML8726_M3 which are not used and so
dead codes. They are also platform-dependent codes.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/wilc_sdio.c | 174 +----------------------------------
 1 file changed, 1 insertion(+), 173 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 967df95..ea545c9 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -13,12 +13,7 @@
 #ifdef WILC1000_SINGLE_TRANSFER
 #define WILC_SDIO_BLOCK_SIZE 256
 #else
- #if defined(PLAT_AML8726_M3) /* johnny */
-	#define WILC_SDIO_BLOCK_SIZE 512
-	#define MAX_SEG_SIZE (1 << 12) /* 4096 */
- #else
-	#define WILC_SDIO_BLOCK_SIZE 512
- #endif
+#define WILC_SDIO_BLOCK_SIZE 512
 #endif
 
 typedef struct {
@@ -356,88 +351,6 @@ static int sdio_write(uint32_t addr, uint8_t *buf, uint32_t size)
 	nleft = size % block_size;
 
 	if (nblk > 0) {
-
-#if defined(PLAT_AML8726_M3_BACKUP) /* johnny */
-		int i;
-
-		for (i = 0; i < nblk; i++) {
-			cmd.block_mode = 0; /* 1; */
-			cmd.increment = 1;
-			cmd.count = block_size; /* nblk; */
-			cmd.buffer = buf;
-			cmd.block_size = block_size;
-			if (addr > 0) {
-				if (!sdio_set_func0_csa_address(addr))
-					goto _fail_;
-			}
-			if (!g_sdio.sdio_cmd53(&cmd)) {
-				g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd53 [%x], block send...\n", addr);
-				goto _fail_;
-			}
-
-			if (addr > 0)
-				addr += block_size;     /* addr += nblk*block_size; */
-
-			buf += block_size;              /* buf += nblk*block_size; */
-		}
-
-#elif defined(PLAT_AML8726_M3) /* johnny */
-
-		int i;
-		int rest;
-		int seg_cnt;
-
-		seg_cnt = (nblk * block_size) / MAX_SEG_SIZE;
-		rest = (nblk * block_size) & (MAX_SEG_SIZE - 1);
-
-		for (i = 0; i < seg_cnt; i++) {
-			cmd.block_mode = 1;
-			cmd.increment = 1;
-			cmd.count = MAX_SEG_SIZE / block_size;
-			cmd.buffer = buf;
-			cmd.block_size = block_size;
-
-			if (addr > 0) {
-				if (!sdio_set_func0_csa_address(addr))
-					goto _fail_;
-			}
-			if (!g_sdio.sdio_cmd53(&cmd)) {
-				g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd53 [%x], block send...\n", addr);
-				goto _fail_;
-			}
-
-			if (addr > 0)
-				addr += MAX_SEG_SIZE;
-
-			buf += MAX_SEG_SIZE;
-
-		}
-
-		if (rest > 0) {
-			cmd.block_mode = 1;
-			cmd.increment = 1;
-			cmd.count = rest / block_size;
-			cmd.buffer = buf;
-			cmd.block_size = block_size; /* johnny : prevent it from setting unexpected value */
-
-			if (addr > 0) {
-				if (!sdio_set_func0_csa_address(addr))
-					goto _fail_;
-			}
-			if (!g_sdio.sdio_cmd53(&cmd)) {
-				g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd53 [%x], bytes send...\n", addr);
-				goto _fail_;
-			}
-
-			if (addr > 0)
-				addr += rest;
-
-			buf += rest;
-
-		}
-
-#else
-
 		cmd.block_mode = 1;
 		cmd.increment = 1;
 		cmd.count = nblk;
@@ -454,8 +367,6 @@ static int sdio_write(uint32_t addr, uint8_t *buf, uint32_t size)
 		if (addr > 0)
 			addr += nblk * block_size;
 		buf += nblk * block_size;
-
-#endif /* platform */
 	}
 
 	if (nleft > 0) {
@@ -582,87 +493,6 @@ static int sdio_read(uint32_t addr, uint8_t *buf, uint32_t size)
 	nleft = size % block_size;
 
 	if (nblk > 0) {
-
-#if defined(PLAT_AML8726_M3_BACKUP) /* johnny */
-
-		int i;
-
-		for (i = 0; i < nblk; i++) {
-			cmd.block_mode = 0; /* 1; */
-			cmd.increment = 1;
-			cmd.count = block_size; /* nblk; */
-			cmd.buffer = buf;
-			cmd.block_size = block_size;
-			if (addr > 0) {
-				if (!sdio_set_func0_csa_address(addr))
-					goto _fail_;
-			}
-			if (!g_sdio.sdio_cmd53(&cmd)) {
-				g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd53 [%x], block read...\n", addr);
-				goto _fail_;
-			}
-			if (addr > 0)
-				addr += block_size;             /* addr += nblk*block_size; */
-			buf += block_size;              /* buf += nblk*block_size; */
-		}
-
-#elif defined(PLAT_AML8726_M3) /* johnny */
-
-		int i;
-		int rest;
-		int seg_cnt;
-
-		seg_cnt = (nblk * block_size) / MAX_SEG_SIZE;
-		rest = (nblk * block_size) & (MAX_SEG_SIZE - 1);
-
-		for (i = 0; i < seg_cnt; i++) {
-			cmd.block_mode = 1;
-			cmd.increment = 1;
-			cmd.count = MAX_SEG_SIZE / block_size;
-			cmd.buffer = buf;
-			cmd.block_size = block_size;
-
-			if (addr > 0) {
-				if (!sdio_set_func0_csa_address(addr))
-					goto _fail_;
-			}
-			if (!g_sdio.sdio_cmd53(&cmd)) {
-				g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd53 [%x], block read...\n", addr);
-				goto _fail_;
-			}
-
-			if (addr > 0)
-				addr += MAX_SEG_SIZE;
-
-			buf += MAX_SEG_SIZE;
-
-		}
-
-		if (rest > 0) {
-			cmd.block_mode = 1;
-			cmd.increment = 1;
-			cmd.count = rest / block_size;
-			cmd.buffer = buf;
-			cmd.block_size = block_size; /* johnny : prevent it from setting unexpected value */
-
-			if (addr > 0) {
-				if (!sdio_set_func0_csa_address(addr))
-					goto _fail_;
-			}
-			if (!g_sdio.sdio_cmd53(&cmd)) {
-				g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd53 [%x], block read...\n", addr);
-				goto _fail_;
-			}
-
-			if (addr > 0)
-				addr += rest;
-
-			buf += rest;
-
-		}
-
-#else
-
 		cmd.block_mode = 1;
 		cmd.increment = 1;
 		cmd.count = nblk;
@@ -679,8 +509,6 @@ static int sdio_read(uint32_t addr, uint8_t *buf, uint32_t size)
 		if (addr > 0)
 			addr += nblk * block_size;
 		buf += nblk * block_size;
-
-#endif /* platform */
 	}       /* if (nblk > 0) */
 
 	if (nleft > 0) {
-- 
1.9.1

