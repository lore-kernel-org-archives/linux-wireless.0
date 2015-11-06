Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:47021 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031997AbbKFJh3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 04:37:29 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 02/26] staging: wilc1000: remove function pointer sdio_cmd52
Date: Fri, 6 Nov 2015 18:39:59 +0900
Message-ID: <1446802823-22598-3-git-send-email-glen.lee@atmel.com> (sfid-20151106_103736_472645_E218BA28)
In-Reply-To: <1446802823-22598-1-git-send-email-glen.lee@atmel.com>
References: <1446802823-22598-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes function pointer sdio_cmd52 of wilc_sdio_t and just call
the function directly.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_sdio.c | 53 ++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index cfa76b2..a2d6318 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -10,13 +10,13 @@
 #include <linux/string.h>
 #include "wilc_wlan_if.h"
 #include "wilc_wlan.h"
+#include "linux_wlan_sdio.h"
 
 #define WILC_SDIO_BLOCK_SIZE 512
 
 typedef struct {
 	void *os_context;
 	u32 block_size;
-	int (*sdio_cmd52)(sdio_cmd52_t *);
 	int (*sdio_cmd53)(sdio_cmd53_t *);
 	int (*sdio_set_max_speed)(void);
 	int (*sdio_set_default_speed)(void);
@@ -51,21 +51,21 @@ static int sdio_set_func0_csa_address(u32 adr)
 	cmd.raw = 0;
 	cmd.address = 0x10c;
 	cmd.data = (u8)adr;
-	if (!g_sdio.sdio_cmd52(&cmd)) {
+	if (!linux_sdio_cmd52(&cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0x10c data...\n");
 		goto _fail_;
 	}
 
 	cmd.address = 0x10d;
 	cmd.data = (u8)(adr >> 8);
-	if (!g_sdio.sdio_cmd52(&cmd)) {
+	if (!linux_sdio_cmd52(&cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0x10d data...\n");
 		goto _fail_;
 	}
 
 	cmd.address = 0x10e;
 	cmd.data = (u8)(adr >> 16);
-	if (!g_sdio.sdio_cmd52(&cmd)) {
+	if (!linux_sdio_cmd52(&cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0x10e data...\n");
 		goto _fail_;
 	}
@@ -84,14 +84,14 @@ static int sdio_set_func0_block_size(u32 block_size)
 	cmd.raw = 0;
 	cmd.address = 0x10;
 	cmd.data = (u8)block_size;
-	if (!g_sdio.sdio_cmd52(&cmd)) {
+	if (!linux_sdio_cmd52(&cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0x10 data...\n");
 		goto _fail_;
 	}
 
 	cmd.address = 0x11;
 	cmd.data = (u8)(block_size >> 8);
-	if (!g_sdio.sdio_cmd52(&cmd)) {
+	if (!linux_sdio_cmd52(&cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0x11 data...\n");
 		goto _fail_;
 	}
@@ -116,13 +116,13 @@ static int sdio_set_func1_block_size(u32 block_size)
 	cmd.raw = 0;
 	cmd.address = 0x110;
 	cmd.data = (u8)block_size;
-	if (!g_sdio.sdio_cmd52(&cmd)) {
+	if (!linux_sdio_cmd52(&cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0x110 data...\n");
 		goto _fail_;
 	}
 	cmd.address = 0x111;
 	cmd.data = (u8)(block_size >> 8);
-	if (!g_sdio.sdio_cmd52(&cmd)) {
+	if (!linux_sdio_cmd52(&cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0x111 data...\n");
 		goto _fail_;
 	}
@@ -143,7 +143,7 @@ static int sdio_clear_int(void)
 	cmd.raw = 0;
 	cmd.address = 0x4;
 	cmd.data = 0;
-	g_sdio.sdio_cmd52(&cmd);
+	linux_sdio_cmd52(&cmd);
 
 	return cmd.data;
 #else
@@ -170,7 +170,7 @@ u32 sdio_xfer_cnt(void)
 	cmd.raw = 0;
 	cmd.address = 0x1C;
 	cmd.data = 0;
-	g_sdio.sdio_cmd52(&cmd);
+	linux_sdio_cmd52(&cmd);
 	cnt = cmd.data;
 
 	cmd.read_write = 0;
@@ -178,7 +178,7 @@ u32 sdio_xfer_cnt(void)
 	cmd.raw = 0;
 	cmd.address = 0x1D;
 	cmd.data = 0;
-	g_sdio.sdio_cmd52(&cmd);
+	linux_sdio_cmd52(&cmd);
 	cnt |= (cmd.data << 8);
 
 	cmd.read_write = 0;
@@ -186,7 +186,7 @@ u32 sdio_xfer_cnt(void)
 	cmd.raw = 0;
 	cmd.address = 0x1E;
 	cmd.data = 0;
-	g_sdio.sdio_cmd52(&cmd);
+	linux_sdio_cmd52(&cmd);
 	cnt |= (cmd.data << 16);
 
 	return cnt;
@@ -209,7 +209,7 @@ int sdio_check_bs(void)
 	cmd.raw = 0;
 	cmd.address = 0xc;
 	cmd.data = 0;
-	if (!g_sdio.sdio_cmd52(&cmd)) {
+	if (!linux_sdio_cmd52(&cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Fail cmd 52, get BS register...\n");
 		goto _fail_;
 	}
@@ -235,7 +235,7 @@ static int sdio_write_reg(u32 addr, u32 data)
 		cmd.raw = 0;
 		cmd.address = addr;
 		cmd.data = data;
-		if (!g_sdio.sdio_cmd52(&cmd)) {
+		if (!linux_sdio_cmd52(&cmd)) {
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd 52, read reg (%08x) ...\n", addr);
 			goto _fail_;
 		}
@@ -363,7 +363,7 @@ static int sdio_read_reg(u32 addr, u32 *data)
 		cmd.function = 0;
 		cmd.raw = 0;
 		cmd.address = addr;
-		if (!g_sdio.sdio_cmd52(&cmd)) {
+		if (!linux_sdio_cmd52(&cmd)) {
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd 52, read reg (%08x) ...\n", addr);
 			goto _fail_;
 		}
@@ -574,7 +574,6 @@ static int sdio_init(wilc_wlan_inp_t *inp, wilc_debug_func func)
 		return 0;
 	}
 
-	g_sdio.sdio_cmd52	= inp->io_func.u.sdio.sdio_cmd52;
 	g_sdio.sdio_cmd53	= inp->io_func.u.sdio.sdio_cmd53;
 	g_sdio.sdio_set_max_speed	= inp->io_func.u.sdio.sdio_set_max_speed;
 	g_sdio.sdio_set_default_speed	= inp->io_func.u.sdio.sdio_set_default_speed;
@@ -587,7 +586,7 @@ static int sdio_init(wilc_wlan_inp_t *inp, wilc_debug_func func)
 	cmd.raw = 1;
 	cmd.address = 0x100;
 	cmd.data = 0x80;
-	if (!g_sdio.sdio_cmd52(&cmd)) {
+	if (!linux_sdio_cmd52(&cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Fail cmd 52, enable csa...\n");
 		goto _fail_;
 	}
@@ -609,7 +608,7 @@ static int sdio_init(wilc_wlan_inp_t *inp, wilc_debug_func func)
 	cmd.raw = 1;
 	cmd.address = 0x2;
 	cmd.data = 0x2;
-	if (!g_sdio.sdio_cmd52(&cmd)) {
+	if (!linux_sdio_cmd52(&cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio] Fail cmd 52, set IOE register...\n");
 		goto _fail_;
 	}
@@ -624,7 +623,7 @@ static int sdio_init(wilc_wlan_inp_t *inp, wilc_debug_func func)
 	loop = 3;
 	do {
 		cmd.data = 0;
-		if (!g_sdio.sdio_cmd52(&cmd)) {
+		if (!linux_sdio_cmd52(&cmd)) {
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Fail cmd 52, get IOR register...\n");
 			goto _fail_;
 		}
@@ -653,7 +652,7 @@ static int sdio_init(wilc_wlan_inp_t *inp, wilc_debug_func func)
 	cmd.raw = 1;
 	cmd.address = 0x4;
 	cmd.data = 0x3;
-	if (!g_sdio.sdio_cmd52(&cmd)) {
+	if (!linux_sdio_cmd52(&cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Fail cmd 52, set IEN register...\n");
 		goto _fail_;
 	}
@@ -703,7 +702,7 @@ static int sdio_read_size(u32 *size)
 	cmd.raw = 0;
 	cmd.address = 0xf2;
 	cmd.data = 0;
-	g_sdio.sdio_cmd52(&cmd);
+	linux_sdio_cmd52(&cmd);
 	tmp = cmd.data;
 
 	/* cmd.read_write = 0; */
@@ -711,7 +710,7 @@ static int sdio_read_size(u32 *size)
 	/* cmd.raw = 0; */
 	cmd.address = 0xf3;
 	cmd.data = 0;
-	g_sdio.sdio_cmd52(&cmd);
+	linux_sdio_cmd52(&cmd);
 	tmp |= (cmd.data << 8);
 
 	*size = tmp;
@@ -733,7 +732,7 @@ static int sdio_read_int(u32 *int_status)
 	cmd.function = 1;
 	cmd.address = 0x04;
 	cmd.data = 0;
-	g_sdio.sdio_cmd52(&cmd);
+	linux_sdio_cmd52(&cmd);
 
 	if (cmd.data & BIT(0))
 		tmp |= INT_0;
@@ -766,7 +765,7 @@ static int sdio_read_int(u32 *int_status)
 		cmd.raw = 0;
 		cmd.address = 0xf7;
 		cmd.data = 0;
-		g_sdio.sdio_cmd52(&cmd);
+		linux_sdio_cmd52(&cmd);
 		irq_flags = cmd.data & 0x1f;
 		tmp |= ((irq_flags >> 0) << IRG_FLAGS_OFFSET);
 	}
@@ -813,7 +812,7 @@ static int sdio_clear_int_ext(u32 val)
 			cmd.address = 0xf8;
 			cmd.data = reg;
 
-			ret = g_sdio.sdio_cmd52(&cmd);
+			ret = linux_sdio_cmd52(&cmd);
 			if (!ret) {
 				g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0xf8 data (%d) ...\n", __LINE__);
 				goto _fail_;
@@ -842,7 +841,7 @@ static int sdio_clear_int_ext(u32 val)
 						cmd.address = 0xf8;
 						cmd.data = BIT(i);
 
-						ret = g_sdio.sdio_cmd52(&cmd);
+						ret = linux_sdio_cmd52(&cmd);
 						if (!ret) {
 							g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0xf8 data (%d) ...\n", __LINE__);
 							goto _fail_;
@@ -886,7 +885,7 @@ static int sdio_clear_int_ext(u32 val)
 				cmd.raw = 0;
 				cmd.address = 0xf6;
 				cmd.data = vmm_ctl;
-				ret = g_sdio.sdio_cmd52(&cmd);
+				ret = linux_sdio_cmd52(&cmd);
 				if (!ret) {
 					g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0xf6 data (%d) ...\n", __LINE__);
 					goto _fail_;
-- 
1.9.1

