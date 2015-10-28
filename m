Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:6103 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944AbbJ1Hqn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:46:43 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 12/12] staging: wilc1000: add argument wilc and use it instead of g_linux_wlan
Date: Wed, 28 Oct 2015 16:48:28 +0900
Message-ID: <1446018508-17889-12-git-send-email-glen.lee@atmel.com> (sfid-20151028_084646_152933_AA0D11EB)
In-Reply-To: <1446018508-17889-1-git-send-email-glen.lee@atmel.com>
References: <1446018508-17889-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds new argument wilc to linux_sdio_cmd53 and linux_sdio_cmd52
, and use it instead of g_linux_wlan. Pass wilc to the functions as well.
The void type wilc will be changed with struct wilc when SDIO and SPI
modules are reworked.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan_sdio.c |  8 ++--
 drivers/staging/wilc1000/linux_wlan_sdio.h |  4 +-
 drivers/staging/wilc1000/wilc_sdio.c       | 66 +++++++++++++++---------------
 drivers/staging/wilc1000/wilc_wlan_if.h    |  4 +-
 4 files changed, 41 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index bf05e22..8150d6f 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -53,9 +53,9 @@ static void wilc_sdio_interrupt(struct sdio_func *func)
 }
 
 
-int linux_sdio_cmd52(sdio_cmd52_t *cmd)
+int linux_sdio_cmd52(void *wilc, sdio_cmd52_t *cmd)
 {
-	struct sdio_func *func = g_linux_wlan->wilc_sdio_func;
+	struct sdio_func *func = ((struct wilc*)wilc)->wilc_sdio_func;
 	int ret;
 	u8 data;
 
@@ -85,9 +85,9 @@ int linux_sdio_cmd52(sdio_cmd52_t *cmd)
 }
 
 
-int linux_sdio_cmd53(sdio_cmd53_t *cmd)
+int linux_sdio_cmd53(void *wilc, sdio_cmd53_t *cmd)
 {
-	struct sdio_func *func = g_linux_wlan->wilc_sdio_func;
+	struct sdio_func *func = ((struct wilc*)wilc)->wilc_sdio_func;
 	int size, ret;
 
 	sdio_claim_host(func);
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.h b/drivers/staging/wilc1000/linux_wlan_sdio.h
index 4b515f5..d4b3d12 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.h
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.h
@@ -5,8 +5,8 @@ extern struct sdio_driver wilc_bus;
 
 int linux_sdio_init(void *);
 void linux_sdio_deinit(void *);
-int linux_sdio_cmd52(sdio_cmd52_t *cmd);
-int linux_sdio_cmd53(sdio_cmd53_t *cmd);
+int linux_sdio_cmd52(void *wilc, sdio_cmd52_t *cmd);
+int linux_sdio_cmd53(void *wilc, sdio_cmd53_t *cmd);
 int enable_sdio_interrupt(void);
 void disable_sdio_interrupt(void);
 int linux_sdio_set_max_speed(void);
diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 82f68eb..b9ca142 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -16,8 +16,8 @@
 typedef struct {
 	void *wilc;
 	u32 block_size;
-	int (*sdio_cmd52)(sdio_cmd52_t *);
-	int (*sdio_cmd53)(sdio_cmd53_t *);
+	int (*sdio_cmd52)(void *, sdio_cmd52_t *);
+	int (*sdio_cmd53)(void *, sdio_cmd53_t *);
 	int (*sdio_set_max_speed)(void);
 	int (*sdio_set_default_speed)(void);
 	wilc_debug_func dPrint;
@@ -51,21 +51,21 @@ static int sdio_set_func0_csa_address(u32 adr)
 	cmd.raw = 0;
 	cmd.address = 0x10c;
 	cmd.data = (u8)adr;
-	if (!g_sdio.sdio_cmd52(&cmd)) {
+	if (!g_sdio.sdio_cmd52(g_sdio.wilc, &cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0x10c data...\n");
 		goto _fail_;
 	}
 
 	cmd.address = 0x10d;
 	cmd.data = (u8)(adr >> 8);
-	if (!g_sdio.sdio_cmd52(&cmd)) {
+	if (!g_sdio.sdio_cmd52(g_sdio.wilc, &cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0x10d data...\n");
 		goto _fail_;
 	}
 
 	cmd.address = 0x10e;
 	cmd.data = (u8)(adr >> 16);
-	if (!g_sdio.sdio_cmd52(&cmd)) {
+	if (!g_sdio.sdio_cmd52(g_sdio.wilc, &cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0x10e data...\n");
 		goto _fail_;
 	}
@@ -84,14 +84,14 @@ static int sdio_set_func0_block_size(u32 block_size)
 	cmd.raw = 0;
 	cmd.address = 0x10;
 	cmd.data = (u8)block_size;
-	if (!g_sdio.sdio_cmd52(&cmd)) {
+	if (!g_sdio.sdio_cmd52(g_sdio.wilc, &cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0x10 data...\n");
 		goto _fail_;
 	}
 
 	cmd.address = 0x11;
 	cmd.data = (u8)(block_size >> 8);
-	if (!g_sdio.sdio_cmd52(&cmd)) {
+	if (!g_sdio.sdio_cmd52(g_sdio.wilc, &cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0x11 data...\n");
 		goto _fail_;
 	}
@@ -116,13 +116,13 @@ static int sdio_set_func1_block_size(u32 block_size)
 	cmd.raw = 0;
 	cmd.address = 0x110;
 	cmd.data = (u8)block_size;
-	if (!g_sdio.sdio_cmd52(&cmd)) {
+	if (!g_sdio.sdio_cmd52(g_sdio.wilc, &cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0x110 data...\n");
 		goto _fail_;
 	}
 	cmd.address = 0x111;
 	cmd.data = (u8)(block_size >> 8);
-	if (!g_sdio.sdio_cmd52(&cmd)) {
+	if (!g_sdio.sdio_cmd52(g_sdio.wilc, &cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0x111 data...\n");
 		goto _fail_;
 	}
@@ -143,7 +143,7 @@ static int sdio_clear_int(void)
 	cmd.raw = 0;
 	cmd.address = 0x4;
 	cmd.data = 0;
-	g_sdio.sdio_cmd52(&cmd);
+	g_sdio.sdio_cmd52(g_sdio.wilc, &cmd);
 
 	return cmd.data;
 #else
@@ -170,7 +170,7 @@ u32 sdio_xfer_cnt(void)
 	cmd.raw = 0;
 	cmd.address = 0x1C;
 	cmd.data = 0;
-	g_sdio.sdio_cmd52(&cmd);
+	g_sdio.sdio_cmd52(g_sdio.wilc, &cmd);
 	cnt = cmd.data;
 
 	cmd.read_write = 0;
@@ -178,7 +178,7 @@ u32 sdio_xfer_cnt(void)
 	cmd.raw = 0;
 	cmd.address = 0x1D;
 	cmd.data = 0;
-	g_sdio.sdio_cmd52(&cmd);
+	g_sdio.sdio_cmd52(g_sdio.wilc, &cmd);
 	cnt |= (cmd.data << 8);
 
 	cmd.read_write = 0;
@@ -186,7 +186,7 @@ u32 sdio_xfer_cnt(void)
 	cmd.raw = 0;
 	cmd.address = 0x1E;
 	cmd.data = 0;
-	g_sdio.sdio_cmd52(&cmd);
+	g_sdio.sdio_cmd52(g_sdio.wilc, &cmd);
 	cnt |= (cmd.data << 16);
 
 	return cnt;
@@ -209,7 +209,7 @@ int sdio_check_bs(void)
 	cmd.raw = 0;
 	cmd.address = 0xc;
 	cmd.data = 0;
-	if (!g_sdio.sdio_cmd52(&cmd)) {
+	if (!g_sdio.sdio_cmd52(g_sdio.wilc, &cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Fail cmd 52, get BS register...\n");
 		goto _fail_;
 	}
@@ -235,7 +235,7 @@ static int sdio_write_reg(u32 addr, u32 data)
 		cmd.raw = 0;
 		cmd.address = addr;
 		cmd.data = data;
-		if (!g_sdio.sdio_cmd52(&cmd)) {
+		if (!g_sdio.sdio_cmd52(g_sdio.wilc, &cmd)) {
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd 52, read reg (%08x) ...\n", addr);
 			goto _fail_;
 		}
@@ -257,7 +257,7 @@ static int sdio_write_reg(u32 addr, u32 data)
 		cmd.buffer = (u8 *)&data;
 		cmd.block_size = g_sdio.block_size; /* johnny : prevent it from setting unexpected value */
 
-		if (!g_sdio.sdio_cmd53(&cmd)) {
+		if (!g_sdio.sdio_cmd53(g_sdio.wilc, &cmd)) {
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd53, write reg (%08x)...\n", addr);
 			goto _fail_;
 		}
@@ -320,7 +320,7 @@ static int sdio_write(u32 addr, u8 *buf, u32 size)
 			if (!sdio_set_func0_csa_address(addr))
 				goto _fail_;
 		}
-		if (!g_sdio.sdio_cmd53(&cmd)) {
+		if (!g_sdio.sdio_cmd53(g_sdio.wilc, &cmd)) {
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd53 [%x], block send...\n", addr);
 			goto _fail_;
 		}
@@ -341,7 +341,7 @@ static int sdio_write(u32 addr, u8 *buf, u32 size)
 			if (!sdio_set_func0_csa_address(addr))
 				goto _fail_;
 		}
-		if (!g_sdio.sdio_cmd53(&cmd)) {
+		if (!g_sdio.sdio_cmd53(g_sdio.wilc, &cmd)) {
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd53 [%x], bytes send...\n", addr);
 			goto _fail_;
 		}
@@ -363,7 +363,7 @@ static int sdio_read_reg(u32 addr, u32 *data)
 		cmd.function = 0;
 		cmd.raw = 0;
 		cmd.address = addr;
-		if (!g_sdio.sdio_cmd52(&cmd)) {
+		if (!g_sdio.sdio_cmd52(g_sdio.wilc, &cmd)) {
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd 52, read reg (%08x) ...\n", addr);
 			goto _fail_;
 		}
@@ -384,7 +384,7 @@ static int sdio_read_reg(u32 addr, u32 *data)
 
 		cmd.block_size = g_sdio.block_size; /* johnny : prevent it from setting unexpected value */
 
-		if (!g_sdio.sdio_cmd53(&cmd)) {
+		if (!g_sdio.sdio_cmd53(g_sdio.wilc, &cmd)) {
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd53, read reg (%08x)...\n", addr);
 			goto _fail_;
 		}
@@ -451,7 +451,7 @@ static int sdio_read(u32 addr, u8 *buf, u32 size)
 			if (!sdio_set_func0_csa_address(addr))
 				goto _fail_;
 		}
-		if (!g_sdio.sdio_cmd53(&cmd)) {
+		if (!g_sdio.sdio_cmd53(g_sdio.wilc, &cmd)) {
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd53 [%x], block read...\n", addr);
 			goto _fail_;
 		}
@@ -472,7 +472,7 @@ static int sdio_read(u32 addr, u8 *buf, u32 size)
 			if (!sdio_set_func0_csa_address(addr))
 				goto _fail_;
 		}
-		if (!g_sdio.sdio_cmd53(&cmd)) {
+		if (!g_sdio.sdio_cmd53(g_sdio.wilc, &cmd)) {
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd53 [%x], bytes read...\n", addr);
 			goto _fail_;
 		}
@@ -587,7 +587,7 @@ static int sdio_init(wilc_wlan_inp_t *inp, wilc_debug_func func)
 	cmd.raw = 1;
 	cmd.address = 0x100;
 	cmd.data = 0x80;
-	if (!g_sdio.sdio_cmd52(&cmd)) {
+	if (!g_sdio.sdio_cmd52(g_sdio.wilc, &cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Fail cmd 52, enable csa...\n");
 		goto _fail_;
 	}
@@ -609,7 +609,7 @@ static int sdio_init(wilc_wlan_inp_t *inp, wilc_debug_func func)
 	cmd.raw = 1;
 	cmd.address = 0x2;
 	cmd.data = 0x2;
-	if (!g_sdio.sdio_cmd52(&cmd)) {
+	if (!g_sdio.sdio_cmd52(g_sdio.wilc, &cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio] Fail cmd 52, set IOE register...\n");
 		goto _fail_;
 	}
@@ -624,7 +624,7 @@ static int sdio_init(wilc_wlan_inp_t *inp, wilc_debug_func func)
 	loop = 3;
 	do {
 		cmd.data = 0;
-		if (!g_sdio.sdio_cmd52(&cmd)) {
+		if (!g_sdio.sdio_cmd52(g_sdio.wilc, &cmd)) {
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Fail cmd 52, get IOR register...\n");
 			goto _fail_;
 		}
@@ -653,7 +653,7 @@ static int sdio_init(wilc_wlan_inp_t *inp, wilc_debug_func func)
 	cmd.raw = 1;
 	cmd.address = 0x4;
 	cmd.data = 0x3;
-	if (!g_sdio.sdio_cmd52(&cmd)) {
+	if (!g_sdio.sdio_cmd52(g_sdio.wilc, &cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Fail cmd 52, set IEN register...\n");
 		goto _fail_;
 	}
@@ -703,7 +703,7 @@ static int sdio_read_size(u32 *size)
 	cmd.raw = 0;
 	cmd.address = 0xf2;
 	cmd.data = 0;
-	g_sdio.sdio_cmd52(&cmd);
+	g_sdio.sdio_cmd52(g_sdio.wilc, &cmd);
 	tmp = cmd.data;
 
 	/* cmd.read_write = 0; */
@@ -711,7 +711,7 @@ static int sdio_read_size(u32 *size)
 	/* cmd.raw = 0; */
 	cmd.address = 0xf3;
 	cmd.data = 0;
-	g_sdio.sdio_cmd52(&cmd);
+	g_sdio.sdio_cmd52(g_sdio.wilc, &cmd);
 	tmp |= (cmd.data << 8);
 
 	*size = tmp;
@@ -733,7 +733,7 @@ static int sdio_read_int(u32 *int_status)
 	cmd.function = 1;
 	cmd.address = 0x04;
 	cmd.data = 0;
-	g_sdio.sdio_cmd52(&cmd);
+	g_sdio.sdio_cmd52(g_sdio.wilc, &cmd);
 
 	if (cmd.data & BIT(0))
 		tmp |= INT_0;
@@ -766,7 +766,7 @@ static int sdio_read_int(u32 *int_status)
 		cmd.raw = 0;
 		cmd.address = 0xf7;
 		cmd.data = 0;
-		g_sdio.sdio_cmd52(&cmd);
+		g_sdio.sdio_cmd52(g_sdio.wilc, &cmd);
 		irq_flags = cmd.data & 0x1f;
 		tmp |= ((irq_flags >> 0) << IRG_FLAGS_OFFSET);
 	}
@@ -813,7 +813,7 @@ static int sdio_clear_int_ext(u32 val)
 			cmd.address = 0xf8;
 			cmd.data = reg;
 
-			ret = g_sdio.sdio_cmd52(&cmd);
+			ret = g_sdio.sdio_cmd52(g_sdio.wilc, &cmd);
 			if (!ret) {
 				g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0xf8 data (%d) ...\n", __LINE__);
 				goto _fail_;
@@ -842,7 +842,7 @@ static int sdio_clear_int_ext(u32 val)
 						cmd.address = 0xf8;
 						cmd.data = BIT(i);
 
-						ret = g_sdio.sdio_cmd52(&cmd);
+						ret = g_sdio.sdio_cmd52(g_sdio.wilc, &cmd);
 						if (!ret) {
 							g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0xf8 data (%d) ...\n", __LINE__);
 							goto _fail_;
@@ -886,7 +886,7 @@ static int sdio_clear_int_ext(u32 val)
 				cmd.raw = 0;
 				cmd.address = 0xf6;
 				cmd.data = vmm_ctl;
-				ret = g_sdio.sdio_cmd52(&cmd);
+				ret = g_sdio.sdio_cmd52(g_sdio.wilc, &cmd);
 				if (!ret) {
 					g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0xf6 data (%d) ...\n", __LINE__);
 					goto _fail_;
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index a6bf969..89d2d65 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -77,8 +77,8 @@ typedef struct {
 	void (*io_deinit)(void *);
 	union {
 		struct {
-			int (*sdio_cmd52)(sdio_cmd52_t *);
-			int (*sdio_cmd53)(sdio_cmd53_t *);
+			int (*sdio_cmd52)(void *, sdio_cmd52_t *);
+			int (*sdio_cmd53)(void *, sdio_cmd53_t *);
 			int (*sdio_set_max_speed)(void);
 			int (*sdio_set_default_speed)(void);
 		} sdio;
-- 
1.9.1

