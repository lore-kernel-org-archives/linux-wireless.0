Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:20588 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391AbbKRGI5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2015 01:08:57 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 06/16] staging: wilc1000: wilc_sdio_cmd52: pass struct wilc
Date: Wed, 18 Nov 2015 15:11:27 +0900
Message-ID: <1447827097-9436-7-git-send-email-glen.lee@atmel.com> (sfid-20151118_070900_483896_CAACE203)
In-Reply-To: <1447827097-9436-1-git-send-email-glen.lee@atmel.com>
References: <1447827097-9436-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds new function parameter struct wilc and use it instead of
wilc_dev. Pass wilc to the function as well.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan_sdio.c |  4 +--
 drivers/staging/wilc1000/linux_wlan_sdio.h |  2 +-
 drivers/staging/wilc1000/wilc_sdio.c       | 42 +++++++++++++++---------------
 3 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index 761cb3d..6a38876 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -29,9 +29,9 @@ static void wilc_sdio_interrupt(struct sdio_func *func)
 	sdio_claim_host(func);
 }
 
-int wilc_sdio_cmd52(sdio_cmd52_t *cmd)
+int wilc_sdio_cmd52(struct wilc *wilc, sdio_cmd52_t *cmd)
 {
-	struct sdio_func *func = container_of(wilc_dev->dev, struct sdio_func, dev);
+	struct sdio_func *func = container_of(wilc->dev, struct sdio_func, dev);
 	int ret;
 	u8 data;
 
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.h b/drivers/staging/wilc1000/linux_wlan_sdio.h
index dbe911a..d966bb9 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.h
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.h
@@ -1,7 +1,7 @@
 #include <linux/mmc/sdio_func.h>
 
 int wilc_sdio_init(void);
-int wilc_sdio_cmd52(sdio_cmd52_t *cmd);
+int wilc_sdio_cmd52(struct wilc *wilc, sdio_cmd52_t *cmd);
 int wilc_sdio_cmd53(sdio_cmd53_t *cmd);
 
 int wilc_sdio_enable_interrupt(struct wilc *);
diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index a920e76..4d0ee69 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -47,21 +47,21 @@ static int sdio_set_func0_csa_address(struct wilc *wilc, u32 adr)
 	cmd.raw = 0;
 	cmd.address = 0x10c;
 	cmd.data = (u8)adr;
-	if (!wilc_sdio_cmd52(&cmd)) {
+	if (!wilc_sdio_cmd52(wilc, &cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0x10c data...\n");
 		goto _fail_;
 	}
 
 	cmd.address = 0x10d;
 	cmd.data = (u8)(adr >> 8);
-	if (!wilc_sdio_cmd52(&cmd)) {
+	if (!wilc_sdio_cmd52(wilc, &cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0x10d data...\n");
 		goto _fail_;
 	}
 
 	cmd.address = 0x10e;
 	cmd.data = (u8)(adr >> 16);
-	if (!wilc_sdio_cmd52(&cmd)) {
+	if (!wilc_sdio_cmd52(wilc, &cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0x10e data...\n");
 		goto _fail_;
 	}
@@ -80,14 +80,14 @@ static int sdio_set_func0_block_size(struct wilc *wilc, u32 block_size)
 	cmd.raw = 0;
 	cmd.address = 0x10;
 	cmd.data = (u8)block_size;
-	if (!wilc_sdio_cmd52(&cmd)) {
+	if (!wilc_sdio_cmd52(wilc, &cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0x10 data...\n");
 		goto _fail_;
 	}
 
 	cmd.address = 0x11;
 	cmd.data = (u8)(block_size >> 8);
-	if (!wilc_sdio_cmd52(&cmd)) {
+	if (!wilc_sdio_cmd52(wilc, &cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0x11 data...\n");
 		goto _fail_;
 	}
@@ -112,13 +112,13 @@ static int sdio_set_func1_block_size(struct wilc *wilc, u32 block_size)
 	cmd.raw = 0;
 	cmd.address = 0x110;
 	cmd.data = (u8)block_size;
-	if (!wilc_sdio_cmd52(&cmd)) {
+	if (!wilc_sdio_cmd52(wilc, &cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0x110 data...\n");
 		goto _fail_;
 	}
 	cmd.address = 0x111;
 	cmd.data = (u8)(block_size >> 8);
-	if (!wilc_sdio_cmd52(&cmd)) {
+	if (!wilc_sdio_cmd52(wilc, &cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0x111 data...\n");
 		goto _fail_;
 	}
@@ -139,7 +139,7 @@ static int sdio_clear_int(struct wilc *wilc)
 		cmd.raw = 0;
 		cmd.address = 0x4;
 		cmd.data = 0;
-		wilc_sdio_cmd52(&cmd);
+		wilc_sdio_cmd52(wilc, &cmd);
 
 		return cmd.data;
 	} else {
@@ -175,7 +175,7 @@ static int sdio_write_reg(struct wilc *wilc, u32 addr, u32 data)
 		cmd.raw = 0;
 		cmd.address = addr;
 		cmd.data = data;
-		if (!wilc_sdio_cmd52(&cmd)) {
+		if (!wilc_sdio_cmd52(wilc, &cmd)) {
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd 52, read reg (%08x) ...\n", addr);
 			goto _fail_;
 		}
@@ -303,7 +303,7 @@ static int sdio_read_reg(struct wilc *wilc, u32 addr, u32 *data)
 		cmd.function = 0;
 		cmd.raw = 0;
 		cmd.address = addr;
-		if (!wilc_sdio_cmd52(&cmd)) {
+		if (!wilc_sdio_cmd52(wilc, &cmd)) {
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd 52, read reg (%08x) ...\n", addr);
 			goto _fail_;
 		}
@@ -516,7 +516,7 @@ static int sdio_init(struct wilc *wilc, wilc_debug_func func)
 	cmd.raw = 1;
 	cmd.address = 0x100;
 	cmd.data = 0x80;
-	if (!wilc_sdio_cmd52(&cmd)) {
+	if (!wilc_sdio_cmd52(wilc, &cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Fail cmd 52, enable csa...\n");
 		goto _fail_;
 	}
@@ -538,7 +538,7 @@ static int sdio_init(struct wilc *wilc, wilc_debug_func func)
 	cmd.raw = 1;
 	cmd.address = 0x2;
 	cmd.data = 0x2;
-	if (!wilc_sdio_cmd52(&cmd)) {
+	if (!wilc_sdio_cmd52(wilc, &cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio] Fail cmd 52, set IOE register...\n");
 		goto _fail_;
 	}
@@ -553,7 +553,7 @@ static int sdio_init(struct wilc *wilc, wilc_debug_func func)
 	loop = 3;
 	do {
 		cmd.data = 0;
-		if (!wilc_sdio_cmd52(&cmd)) {
+		if (!wilc_sdio_cmd52(wilc, &cmd)) {
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Fail cmd 52, get IOR register...\n");
 			goto _fail_;
 		}
@@ -582,7 +582,7 @@ static int sdio_init(struct wilc *wilc, wilc_debug_func func)
 	cmd.raw = 1;
 	cmd.address = 0x4;
 	cmd.data = 0x3;
-	if (!wilc_sdio_cmd52(&cmd)) {
+	if (!wilc_sdio_cmd52(wilc, &cmd)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Fail cmd 52, set IEN register...\n");
 		goto _fail_;
 	}
@@ -622,7 +622,7 @@ static int sdio_read_size(struct wilc *wilc, u32 *size)
 	cmd.raw = 0;
 	cmd.address = 0xf2;
 	cmd.data = 0;
-	wilc_sdio_cmd52(&cmd);
+	wilc_sdio_cmd52(wilc, &cmd);
 	tmp = cmd.data;
 
 	/* cmd.read_write = 0; */
@@ -630,7 +630,7 @@ static int sdio_read_size(struct wilc *wilc, u32 *size)
 	/* cmd.raw = 0; */
 	cmd.address = 0xf3;
 	cmd.data = 0;
-	wilc_sdio_cmd52(&cmd);
+	wilc_sdio_cmd52(wilc, &cmd);
 	tmp |= (cmd.data << 8);
 
 	*size = tmp;
@@ -654,7 +654,7 @@ static int sdio_read_int(struct wilc *wilc, u32 *int_status)
 		cmd.function = 1;
 		cmd.address = 0x04;
 		cmd.data = 0;
-		wilc_sdio_cmd52(&cmd);
+		wilc_sdio_cmd52(wilc, &cmd);
 
 		if (cmd.data & BIT(0))
 			tmp |= INT_0;
@@ -682,7 +682,7 @@ static int sdio_read_int(struct wilc *wilc, u32 *int_status)
 		cmd.raw = 0;
 		cmd.address = 0xf7;
 		cmd.data = 0;
-		wilc_sdio_cmd52(&cmd);
+		wilc_sdio_cmd52(wilc, &cmd);
 		irq_flags = cmd.data & 0x1f;
 		tmp |= ((irq_flags >> 0) << IRG_FLAGS_OFFSET);
 	}
@@ -725,7 +725,7 @@ static int sdio_clear_int_ext(struct wilc *wilc, u32 val)
 			cmd.address = 0xf8;
 			cmd.data = reg;
 
-			ret = wilc_sdio_cmd52(&cmd);
+			ret = wilc_sdio_cmd52(wilc, &cmd);
 			if (!ret) {
 				g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0xf8 data (%d) ...\n", __LINE__);
 				goto _fail_;
@@ -753,7 +753,7 @@ static int sdio_clear_int_ext(struct wilc *wilc, u32 val)
 						cmd.address = 0xf8;
 						cmd.data = BIT(i);
 
-						ret = wilc_sdio_cmd52(&cmd);
+						ret = wilc_sdio_cmd52(wilc, &cmd);
 						if (!ret) {
 							g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0xf8 data (%d) ...\n", __LINE__);
 							goto _fail_;
@@ -796,7 +796,7 @@ static int sdio_clear_int_ext(struct wilc *wilc, u32 val)
 				cmd.raw = 0;
 				cmd.address = 0xf6;
 				cmd.data = vmm_ctl;
-				ret = wilc_sdio_cmd52(&cmd);
+				ret = wilc_sdio_cmd52(wilc, &cmd);
 				if (!ret) {
 					g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0xf6 data (%d) ...\n", __LINE__);
 					goto _fail_;
-- 
1.9.1

