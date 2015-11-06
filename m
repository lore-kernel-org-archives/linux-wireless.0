Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:47075 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031997AbbKFJhk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 04:37:40 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 04/26] staging: wilc1000: remove function pointer sdio_cmd53
Date: Fri, 6 Nov 2015 18:40:01 +0900
Message-ID: <1446802823-22598-5-git-send-email-glen.lee@atmel.com> (sfid-20151106_103750_253137_5BCBEE51)
In-Reply-To: <1446802823-22598-1-git-send-email-glen.lee@atmel.com>
References: <1446802823-22598-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes function pointer sdio_cmd53 of wilc_sdio_t and just call
the function directly.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_sdio.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index a2d6318..1176946 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -17,7 +17,6 @@
 typedef struct {
 	void *os_context;
 	u32 block_size;
-	int (*sdio_cmd53)(sdio_cmd53_t *);
 	int (*sdio_set_max_speed)(void);
 	int (*sdio_set_default_speed)(void);
 	wilc_debug_func dPrint;
@@ -257,7 +256,7 @@ static int sdio_write_reg(u32 addr, u32 data)
 		cmd.buffer = (u8 *)&data;
 		cmd.block_size = g_sdio.block_size; /* johnny : prevent it from setting unexpected value */
 
-		if (!g_sdio.sdio_cmd53(&cmd)) {
+		if (!linux_sdio_cmd53(&cmd)) {
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd53, write reg (%08x)...\n", addr);
 			goto _fail_;
 		}
@@ -320,7 +319,7 @@ static int sdio_write(u32 addr, u8 *buf, u32 size)
 			if (!sdio_set_func0_csa_address(addr))
 				goto _fail_;
 		}
-		if (!g_sdio.sdio_cmd53(&cmd)) {
+		if (!linux_sdio_cmd53(&cmd)) {
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd53 [%x], block send...\n", addr);
 			goto _fail_;
 		}
@@ -341,7 +340,7 @@ static int sdio_write(u32 addr, u8 *buf, u32 size)
 			if (!sdio_set_func0_csa_address(addr))
 				goto _fail_;
 		}
-		if (!g_sdio.sdio_cmd53(&cmd)) {
+		if (!linux_sdio_cmd53(&cmd)) {
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd53 [%x], bytes send...\n", addr);
 			goto _fail_;
 		}
@@ -384,7 +383,7 @@ static int sdio_read_reg(u32 addr, u32 *data)
 
 		cmd.block_size = g_sdio.block_size; /* johnny : prevent it from setting unexpected value */
 
-		if (!g_sdio.sdio_cmd53(&cmd)) {
+		if (!linux_sdio_cmd53(&cmd)) {
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd53, read reg (%08x)...\n", addr);
 			goto _fail_;
 		}
@@ -451,7 +450,7 @@ static int sdio_read(u32 addr, u8 *buf, u32 size)
 			if (!sdio_set_func0_csa_address(addr))
 				goto _fail_;
 		}
-		if (!g_sdio.sdio_cmd53(&cmd)) {
+		if (!linux_sdio_cmd53(&cmd)) {
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd53 [%x], block read...\n", addr);
 			goto _fail_;
 		}
@@ -472,7 +471,7 @@ static int sdio_read(u32 addr, u8 *buf, u32 size)
 			if (!sdio_set_func0_csa_address(addr))
 				goto _fail_;
 		}
-		if (!g_sdio.sdio_cmd53(&cmd)) {
+		if (!linux_sdio_cmd53(&cmd)) {
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd53 [%x], bytes read...\n", addr);
 			goto _fail_;
 		}
@@ -574,7 +573,6 @@ static int sdio_init(wilc_wlan_inp_t *inp, wilc_debug_func func)
 		return 0;
 	}
 
-	g_sdio.sdio_cmd53	= inp->io_func.u.sdio.sdio_cmd53;
 	g_sdio.sdio_set_max_speed	= inp->io_func.u.sdio.sdio_set_max_speed;
 	g_sdio.sdio_set_default_speed	= inp->io_func.u.sdio.sdio_set_default_speed;
 
-- 
1.9.1

