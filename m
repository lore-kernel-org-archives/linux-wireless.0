Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:20575 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391AbbKRGIv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2015 01:08:51 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 05/16] staging: wilc1000: pass wilc to all function pointers of wilc_hif_func
Date: Wed, 18 Nov 2015 15:11:26 +0900
Message-ID: <1447827097-9436-6-git-send-email-glen.lee@atmel.com> (sfid-20151118_070854_777015_74F86625)
In-Reply-To: <1447827097-9436-1-git-send-email-glen.lee@atmel.com>
References: <1447827097-9436-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds new function parameter struct wilc to all function pointers
of struct wilc_hif_func, and all functions of wilc_sdio.c and wilc_spi.c
need to be changed as it's function pointer is changed.
Pass wilc in all the functions call as well.

The wilc will be passed to functions in linux_wlan_sdio.c and linux_wlan_spi.c
to replace with global variable wilc_dev in the next patch.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_sdio.c |  84 +++++++++---------
 drivers/staging/wilc1000/wilc_spi.c  | 113 +++++++++++++-----------
 drivers/staging/wilc1000/wilc_wlan.c | 167 +++++++++++++++++++----------------
 drivers/staging/wilc1000/wilc_wlan.h |  26 +++---
 4 files changed, 208 insertions(+), 182 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 398c7f5..a920e76 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -26,8 +26,8 @@ typedef struct {
 
 static wilc_sdio_t g_sdio;
 
-static int sdio_write_reg(u32 addr, u32 data);
-static int sdio_read_reg(u32 addr, u32 *data);
+static int sdio_write_reg(struct wilc *wilc, u32 addr, u32 data);
+static int sdio_read_reg(struct wilc *wilc, u32 addr, u32 *data);
 
 /********************************************
  *
@@ -35,7 +35,7 @@ static int sdio_read_reg(u32 addr, u32 *data);
  *
  ********************************************/
 
-static int sdio_set_func0_csa_address(u32 adr)
+static int sdio_set_func0_csa_address(struct wilc *wilc, u32 adr)
 {
 	sdio_cmd52_t cmd;
 
@@ -71,7 +71,7 @@ _fail_:
 	return 0;
 }
 
-static int sdio_set_func0_block_size(u32 block_size)
+static int sdio_set_func0_block_size(struct wilc *wilc, u32 block_size)
 {
 	sdio_cmd52_t cmd;
 
@@ -103,7 +103,7 @@ _fail_:
  *
  ********************************************/
 
-static int sdio_set_func1_block_size(u32 block_size)
+static int sdio_set_func1_block_size(struct wilc *wilc, u32 block_size)
 {
 	sdio_cmd52_t cmd;
 
@@ -128,7 +128,7 @@ _fail_:
 	return 0;
 }
 
-static int sdio_clear_int(void)
+static int sdio_clear_int(struct wilc *wilc)
 {
 	if (!g_sdio.irq_gpio) {
 		/* u32 sts; */
@@ -145,12 +145,12 @@ static int sdio_clear_int(void)
 	} else {
 		u32 reg;
 
-		if (!sdio_read_reg(WILC_HOST_RX_CTRL_0, &reg)) {
+		if (!sdio_read_reg(wilc, WILC_HOST_RX_CTRL_0, &reg)) {
 			g_sdio.dPrint(N_ERR, "[wilc spi]: Failed read reg (%08x)...\n", WILC_HOST_RX_CTRL_0);
 			return 0;
 		}
 		reg &= ~0x1;
-		sdio_write_reg(WILC_HOST_RX_CTRL_0, reg);
+		sdio_write_reg(wilc, WILC_HOST_RX_CTRL_0, reg);
 		return 1;
 	}
 
@@ -161,7 +161,7 @@ static int sdio_clear_int(void)
  *      Sdio interfaces
  *
  ********************************************/
-static int sdio_write_reg(u32 addr, u32 data)
+static int sdio_write_reg(struct wilc *wilc, u32 addr, u32 data)
 {
 #ifdef BIG_ENDIAN
 	data = BYTE_SWAP(data);
@@ -185,7 +185,7 @@ static int sdio_write_reg(u32 addr, u32 data)
 		/**
 		 *      set the AHB address
 		 **/
-		if (!sdio_set_func0_csa_address(addr))
+		if (!sdio_set_func0_csa_address(wilc, addr))
 			goto _fail_;
 
 		cmd.read_write = 1;
@@ -210,7 +210,7 @@ _fail_:
 	return 0;
 }
 
-static int sdio_write(u32 addr, u8 *buf, u32 size)
+static int sdio_write(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 {
 	u32 block_size = g_sdio.block_size;
 	sdio_cmd53_t cmd;
@@ -257,7 +257,7 @@ static int sdio_write(u32 addr, u8 *buf, u32 size)
 		cmd.buffer = buf;
 		cmd.block_size = block_size;
 		if (addr > 0) {
-			if (!sdio_set_func0_csa_address(addr))
+			if (!sdio_set_func0_csa_address(wilc, addr))
 				goto _fail_;
 		}
 		if (!wilc_sdio_cmd53(&cmd)) {
@@ -278,7 +278,7 @@ static int sdio_write(u32 addr, u8 *buf, u32 size)
 		cmd.block_size = block_size; /* johnny : prevent it from setting unexpected value */
 
 		if (addr > 0) {
-			if (!sdio_set_func0_csa_address(addr))
+			if (!sdio_set_func0_csa_address(wilc, addr))
 				goto _fail_;
 		}
 		if (!wilc_sdio_cmd53(&cmd)) {
@@ -294,7 +294,7 @@ _fail_:
 	return 0;
 }
 
-static int sdio_read_reg(u32 addr, u32 *data)
+static int sdio_read_reg(struct wilc *wilc, u32 addr, u32 *data)
 {
 	if ((addr >= 0xf0) && (addr <= 0xff)) {
 		sdio_cmd52_t cmd;
@@ -311,7 +311,7 @@ static int sdio_read_reg(u32 addr, u32 *data)
 	} else {
 		sdio_cmd53_t cmd;
 
-		if (!sdio_set_func0_csa_address(addr))
+		if (!sdio_set_func0_csa_address(wilc, addr))
 			goto _fail_;
 
 		cmd.read_write = 0;
@@ -341,7 +341,7 @@ _fail_:
 	return 0;
 }
 
-static int sdio_read(u32 addr, u8 *buf, u32 size)
+static int sdio_read(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 {
 	u32 block_size = g_sdio.block_size;
 	sdio_cmd53_t cmd;
@@ -388,7 +388,7 @@ static int sdio_read(u32 addr, u8 *buf, u32 size)
 		cmd.buffer = buf;
 		cmd.block_size = block_size;
 		if (addr > 0) {
-			if (!sdio_set_func0_csa_address(addr))
+			if (!sdio_set_func0_csa_address(wilc, addr))
 				goto _fail_;
 		}
 		if (!wilc_sdio_cmd53(&cmd)) {
@@ -409,7 +409,7 @@ static int sdio_read(u32 addr, u8 *buf, u32 size)
 		cmd.block_size = block_size; /* johnny : prevent it from setting unexpected value */
 
 		if (addr > 0) {
-			if (!sdio_set_func0_csa_address(addr))
+			if (!sdio_set_func0_csa_address(wilc, addr))
 				goto _fail_;
 		}
 		if (!wilc_sdio_cmd53(&cmd)) {
@@ -431,25 +431,25 @@ _fail_:
  *
  ********************************************/
 
-static int sdio_deinit(void *pv)
+static int sdio_deinit(struct wilc *wilc)
 {
 	return 1;
 }
 
-static int sdio_sync(void)
+static int sdio_sync(struct wilc *wilc)
 {
 	u32 reg;
 
 	/**
 	 *      Disable power sequencer
 	 **/
-	if (!sdio_read_reg(WILC_MISC, &reg)) {
+	if (!sdio_read_reg(wilc, WILC_MISC, &reg)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed read misc reg...\n");
 		return 0;
 	}
 
 	reg &= ~BIT(8);
-	if (!sdio_write_reg(WILC_MISC, reg)) {
+	if (!sdio_write_reg(wilc, WILC_MISC, reg)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed write misc reg...\n");
 		return 0;
 	}
@@ -461,13 +461,13 @@ static int sdio_sync(void)
 		/**
 		 *      interrupt pin mux select
 		 **/
-		ret = sdio_read_reg(WILC_PIN_MUX_0, &reg);
+		ret = sdio_read_reg(wilc, WILC_PIN_MUX_0, &reg);
 		if (!ret) {
 			g_sdio.dPrint(N_ERR, "[wilc spi]: Failed read reg (%08x)...\n", WILC_PIN_MUX_0);
 			return 0;
 		}
 		reg |= BIT(8);
-		ret = sdio_write_reg(WILC_PIN_MUX_0, reg);
+		ret = sdio_write_reg(wilc, WILC_PIN_MUX_0, reg);
 		if (!ret) {
 			g_sdio.dPrint(N_ERR, "[wilc spi]: Failed write reg (%08x)...\n", WILC_PIN_MUX_0);
 			return 0;
@@ -476,13 +476,13 @@ static int sdio_sync(void)
 		/**
 		 *      interrupt enable
 		 **/
-		ret = sdio_read_reg(WILC_INTR_ENABLE, &reg);
+		ret = sdio_read_reg(wilc, WILC_INTR_ENABLE, &reg);
 		if (!ret) {
 			g_sdio.dPrint(N_ERR, "[wilc spi]: Failed read reg (%08x)...\n", WILC_INTR_ENABLE);
 			return 0;
 		}
 		reg |= BIT(16);
-		ret = sdio_write_reg(WILC_INTR_ENABLE, reg);
+		ret = sdio_write_reg(wilc, WILC_INTR_ENABLE, reg);
 		if (!ret) {
 			g_sdio.dPrint(N_ERR, "[wilc spi]: Failed write reg (%08x)...\n", WILC_INTR_ENABLE);
 			return 0;
@@ -524,7 +524,7 @@ static int sdio_init(struct wilc *wilc, wilc_debug_func func)
 	/**
 	 *      function 0 block size
 	 **/
-	if (!sdio_set_func0_block_size(WILC_SDIO_BLOCK_SIZE)) {
+	if (!sdio_set_func0_block_size(wilc, WILC_SDIO_BLOCK_SIZE)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Fail cmd 52, set func 0 block size...\n");
 		goto _fail_;
 	}
@@ -569,7 +569,7 @@ static int sdio_init(struct wilc *wilc, wilc_debug_func func)
 	/**
 	 *      func 1 is ready, set func 1 block size
 	 **/
-	if (!sdio_set_func1_block_size(WILC_SDIO_BLOCK_SIZE)) {
+	if (!sdio_set_func1_block_size(wilc, WILC_SDIO_BLOCK_SIZE)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Fail set func 1 block size...\n");
 		goto _fail_;
 	}
@@ -590,7 +590,7 @@ static int sdio_init(struct wilc *wilc, wilc_debug_func func)
 	/**
 	 *      make sure can read back chip id correctly
 	 **/
-	if (!sdio_read_reg(0x1000, &chipid)) {
+	if (!sdio_read_reg(wilc, 0x1000, &chipid)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Fail cmd read chip id...\n");
 		goto _fail_;
 	}
@@ -608,7 +608,7 @@ _fail_:
 	return 0;
 }
 
-static int sdio_read_size(u32 *size)
+static int sdio_read_size(struct wilc *wilc, u32 *size)
 {
 
 	u32 tmp;
@@ -637,13 +637,13 @@ static int sdio_read_size(u32 *size)
 	return 1;
 }
 
-static int sdio_read_int(u32 *int_status)
+static int sdio_read_int(struct wilc *wilc, u32 *int_status)
 {
 
 	u32 tmp;
 	sdio_cmd52_t cmd;
 
-	sdio_read_size(&tmp);
+	sdio_read_size(wilc, &tmp);
 
 	/**
 	 *      Read IRQ flags
@@ -692,7 +692,7 @@ static int sdio_read_int(u32 *int_status)
 	return 1;
 }
 
-static int sdio_clear_int_ext(u32 val)
+static int sdio_clear_int_ext(struct wilc *wilc, u32 val)
 {
 	int ret;
 
@@ -810,7 +810,7 @@ _fail_:
 	return 0;
 }
 
-static int sdio_sync_ext(int nint /*  how mant interrupts to enable. */)
+static int sdio_sync_ext(struct wilc *wilc, int nint)
 {
 	u32 reg;
 
@@ -828,13 +828,13 @@ static int sdio_sync_ext(int nint /*  how mant interrupts to enable. */)
 	/**
 	 *      Disable power sequencer
 	 **/
-	if (!sdio_read_reg(WILC_MISC, &reg)) {
+	if (!sdio_read_reg(wilc, WILC_MISC, &reg)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed read misc reg...\n");
 		return 0;
 	}
 
 	reg &= ~BIT(8);
-	if (!sdio_write_reg(WILC_MISC, reg)) {
+	if (!sdio_write_reg(wilc, WILC_MISC, reg)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed write misc reg...\n");
 		return 0;
 	}
@@ -846,13 +846,13 @@ static int sdio_sync_ext(int nint /*  how mant interrupts to enable. */)
 		/**
 		 *      interrupt pin mux select
 		 **/
-		ret = sdio_read_reg(WILC_PIN_MUX_0, &reg);
+		ret = sdio_read_reg(wilc, WILC_PIN_MUX_0, &reg);
 		if (!ret) {
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed read reg (%08x)...\n", WILC_PIN_MUX_0);
 			return 0;
 		}
 		reg |= BIT(8);
-		ret = sdio_write_reg(WILC_PIN_MUX_0, reg);
+		ret = sdio_write_reg(wilc, WILC_PIN_MUX_0, reg);
 		if (!ret) {
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed write reg (%08x)...\n", WILC_PIN_MUX_0);
 			return 0;
@@ -861,7 +861,7 @@ static int sdio_sync_ext(int nint /*  how mant interrupts to enable. */)
 		/**
 		 *      interrupt enable
 		 **/
-		ret = sdio_read_reg(WILC_INTR_ENABLE, &reg);
+		ret = sdio_read_reg(wilc, WILC_INTR_ENABLE, &reg);
 		if (!ret) {
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed read reg (%08x)...\n", WILC_INTR_ENABLE);
 			return 0;
@@ -869,13 +869,13 @@ static int sdio_sync_ext(int nint /*  how mant interrupts to enable. */)
 
 		for (i = 0; (i < 5) && (nint > 0); i++, nint--)
 			reg |= BIT((27 + i));
-		ret = sdio_write_reg(WILC_INTR_ENABLE, reg);
+		ret = sdio_write_reg(wilc, WILC_INTR_ENABLE, reg);
 		if (!ret) {
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed write reg (%08x)...\n", WILC_INTR_ENABLE);
 			return 0;
 		}
 		if (nint) {
-			ret = sdio_read_reg(WILC_INTR2_ENABLE, &reg);
+			ret = sdio_read_reg(wilc, WILC_INTR2_ENABLE, &reg);
 			if (!ret) {
 				g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed read reg (%08x)...\n", WILC_INTR2_ENABLE);
 				return 0;
@@ -884,7 +884,7 @@ static int sdio_sync_ext(int nint /*  how mant interrupts to enable. */)
 			for (i = 0; (i < 3) && (nint > 0); i++, nint--)
 				reg |= BIT(i);
 
-			ret = sdio_read_reg(WILC_INTR2_ENABLE, &reg);
+			ret = sdio_read_reg(wilc, WILC_INTR2_ENABLE, &reg);
 			if (!ret) {
 				g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed write reg (%08x)...\n", WILC_INTR2_ENABLE);
 				return 0;
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index bd150a5..7a96004 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -22,8 +22,8 @@ typedef struct {
 
 static wilc_spi_t g_spi;
 
-static int _wilc_spi_read(u32, u8 *, u32);
-static int _wilc_spi_write(u32, u8 *, u32);
+static int _wilc_spi_read(struct wilc *wilc, u32, u8 *, u32);
+static int _wilc_spi_write(struct wilc *wilc, u32, u8 *, u32);
 
 /********************************************
  *
@@ -108,7 +108,8 @@ static u8 crc7(u8 crc, const u8 *buffer, u32 len)
 #define DATA_PKT_SZ_8K				(8 * 1024)
 #define DATA_PKT_SZ					DATA_PKT_SZ_8K
 
-static int spi_cmd_complete(u8 cmd, u32 adr, u8 *b, u32 sz, u8 clockless)
+static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
+			    u8 clockless)
 {
 	u8 wb[32], rb[32];
 	u8 wix, rix;
@@ -447,7 +448,7 @@ _error_:
 	return result;
 }
 
-static int spi_data_write(u8 *b, u32 sz)
+static int spi_data_write(struct wilc *wilc, u8 *b, u32 sz)
 {
 	int ix, nbytes;
 	int result = 1;
@@ -524,14 +525,15 @@ static int spi_data_write(u8 *b, u32 sz)
  *
  ********************************************/
 
-static int spi_internal_write(u32 adr, u32 dat)
+static int spi_internal_write(struct wilc *wilc, u32 adr, u32 dat)
 {
 	int result;
 
 #ifdef BIG_ENDIAN
 	dat = BYTE_SWAP(dat);
 #endif
-	result = spi_cmd_complete(CMD_INTERNAL_WRITE, adr, (u8 *)&dat, 4, 0);
+	result = spi_cmd_complete(wilc, CMD_INTERNAL_WRITE, adr, (u8 *)&dat, 4,
+				  0);
 	if (result != N_OK) {
 		PRINT_ER("[wilc spi]: Failed internal write cmd...\n");
 	}
@@ -539,11 +541,12 @@ static int spi_internal_write(u32 adr, u32 dat)
 	return result;
 }
 
-static int spi_internal_read(u32 adr, u32 *data)
+static int spi_internal_read(struct wilc *wilc, u32 adr, u32 *data)
 {
 	int result;
 
-	result = spi_cmd_complete(CMD_INTERNAL_READ, adr, (u8 *)data, 4, 0);
+	result = spi_cmd_complete(wilc, CMD_INTERNAL_READ, adr, (u8 *)data, 4,
+				  0);
 	if (result != N_OK) {
 		PRINT_ER("[wilc spi]: Failed internal read cmd...\n");
 		return 0;
@@ -562,7 +565,7 @@ static int spi_internal_read(u32 adr, u32 *data)
  *
  ********************************************/
 
-static int wilc_spi_write_reg(u32 addr, u32 data)
+static int wilc_spi_write_reg(struct wilc *wilc, u32 addr, u32 data)
 {
 	int result = N_OK;
 	u8 cmd = CMD_SINGLE_WRITE;
@@ -577,7 +580,7 @@ static int wilc_spi_write_reg(u32 addr, u32 data)
 		clockless = 1;
 	}
 
-	result = spi_cmd_complete(cmd, addr, (u8 *)&data, 4, clockless);
+	result = spi_cmd_complete(wilc, cmd, addr, (u8 *)&data, 4, clockless);
 	if (result != N_OK) {
 		PRINT_ER("[wilc spi]: Failed cmd, write reg (%08x)...\n", addr);
 	}
@@ -585,7 +588,7 @@ static int wilc_spi_write_reg(u32 addr, u32 data)
 	return result;
 }
 
-static int _wilc_spi_write(u32 addr, u8 *buf, u32 size)
+static int _wilc_spi_write(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 {
 	int result;
 	u8 cmd = CMD_DMA_EXT_WRITE;
@@ -596,7 +599,7 @@ static int _wilc_spi_write(u32 addr, u8 *buf, u32 size)
 	if (size <= 4)
 		return 0;
 
-	result = spi_cmd_complete(cmd, addr, NULL, size, 0);
+	result = spi_cmd_complete(wilc, cmd, addr, NULL, size, 0);
 	if (result != N_OK) {
 		PRINT_ER("[wilc spi]: Failed cmd, write block (%08x)...\n", addr);
 		return 0;
@@ -605,7 +608,7 @@ static int _wilc_spi_write(u32 addr, u8 *buf, u32 size)
 	/**
 	 *      Data
 	 **/
-	result = spi_data_write(buf, size);
+	result = spi_data_write(wilc, buf, size);
 	if (result != N_OK) {
 		PRINT_ER("[wilc spi]: Failed block data write...\n");
 	}
@@ -613,7 +616,7 @@ static int _wilc_spi_write(u32 addr, u8 *buf, u32 size)
 	return 1;
 }
 
-static int wilc_spi_read_reg(u32 addr, u32 *data)
+static int wilc_spi_read_reg(struct wilc *wilc, u32 addr, u32 *data)
 {
 	int result = N_OK;
 	u8 cmd = CMD_SINGLE_READ;
@@ -626,7 +629,7 @@ static int wilc_spi_read_reg(u32 addr, u32 *data)
 		clockless = 1;
 	}
 
-	result = spi_cmd_complete(cmd, addr, (u8 *)data, 4, clockless);
+	result = spi_cmd_complete(wilc, cmd, addr, (u8 *)data, 4, clockless);
 	if (result != N_OK) {
 		PRINT_ER("[wilc spi]: Failed cmd, read reg (%08x)...\n", addr);
 		return 0;
@@ -639,7 +642,7 @@ static int wilc_spi_read_reg(u32 addr, u32 *data)
 	return 1;
 }
 
-static int _wilc_spi_read(u32 addr, u8 *buf, u32 size)
+static int _wilc_spi_read(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 {
 	u8 cmd = CMD_DMA_EXT_READ;
 	int result;
@@ -647,7 +650,7 @@ static int _wilc_spi_read(u32 addr, u8 *buf, u32 size)
 	if (size <= 4)
 		return 0;
 
-	result = spi_cmd_complete(cmd, addr, buf, size, 0);
+	result = spi_cmd_complete(wilc, cmd, addr, buf, size, 0);
 	if (result != N_OK) {
 		PRINT_ER("[wilc spi]: Failed cmd, read block (%08x)...\n", addr);
 		return 0;
@@ -662,20 +665,20 @@ static int _wilc_spi_read(u32 addr, u8 *buf, u32 size)
  *
  ********************************************/
 
-static int wilc_spi_clear_int(void)
+static int wilc_spi_clear_int(struct wilc *wilc)
 {
 	u32 reg;
 
-	if (!wilc_spi_read_reg(WILC_HOST_RX_CTRL_0, &reg)) {
+	if (!wilc_spi_read_reg(wilc, WILC_HOST_RX_CTRL_0, &reg)) {
 		PRINT_ER("[wilc spi]: Failed read reg (%08x)...\n", WILC_HOST_RX_CTRL_0);
 		return 0;
 	}
 	reg &= ~0x1;
-	wilc_spi_write_reg(WILC_HOST_RX_CTRL_0, reg);
+	wilc_spi_write_reg(wilc, WILC_HOST_RX_CTRL_0, reg);
 	return 1;
 }
 
-static int _wilc_spi_deinit(void *pv)
+static int _wilc_spi_deinit(struct wilc *wilc)
 {
 	/**
 	 *      TODO:
@@ -683,7 +686,7 @@ static int _wilc_spi_deinit(void *pv)
 	return 1;
 }
 
-static int wilc_spi_sync(void)
+static int wilc_spi_sync(struct wilc *wilc)
 {
 	u32 reg;
 	int ret;
@@ -691,13 +694,13 @@ static int wilc_spi_sync(void)
 	/**
 	 *      interrupt pin mux select
 	 **/
-	ret = wilc_spi_read_reg(WILC_PIN_MUX_0, &reg);
+	ret = wilc_spi_read_reg(wilc, WILC_PIN_MUX_0, &reg);
 	if (!ret) {
 		PRINT_ER("[wilc spi]: Failed read reg (%08x)...\n", WILC_PIN_MUX_0);
 		return 0;
 	}
 	reg |= BIT(8);
-	ret = wilc_spi_write_reg(WILC_PIN_MUX_0, reg);
+	ret = wilc_spi_write_reg(wilc, WILC_PIN_MUX_0, reg);
 	if (!ret) {
 		PRINT_ER("[wilc spi]: Failed write reg (%08x)...\n", WILC_PIN_MUX_0);
 		return 0;
@@ -706,13 +709,13 @@ static int wilc_spi_sync(void)
 	/**
 	 *      interrupt enable
 	 **/
-	ret = wilc_spi_read_reg(WILC_INTR_ENABLE, &reg);
+	ret = wilc_spi_read_reg(wilc, WILC_INTR_ENABLE, &reg);
 	if (!ret) {
 		PRINT_ER("[wilc spi]: Failed read reg (%08x)...\n", WILC_INTR_ENABLE);
 		return 0;
 	}
 	reg |= BIT(16);
-	ret = wilc_spi_write_reg(WILC_INTR_ENABLE, reg);
+	ret = wilc_spi_write_reg(wilc, WILC_INTR_ENABLE, reg);
 	if (!ret) {
 		PRINT_ER("[wilc spi]: Failed write reg (%08x)...\n", WILC_INTR_ENABLE);
 		return 0;
@@ -730,7 +733,7 @@ static int _wilc_spi_init(struct wilc *wilc, wilc_debug_func func)
 
 	if (isinit) {
 
-		if (!wilc_spi_read_reg(0x1000, &chipid)) {
+		if (!wilc_spi_read_reg(wilc, 0x1000, &chipid)) {
 			PRINT_ER("[wilc spi]: Fail cmd read chip id...\n");
 			return 0;
 		}
@@ -752,12 +755,12 @@ static int _wilc_spi_init(struct wilc *wilc, wilc_debug_func func)
 
 	/* TODO: We can remove the CRC trials if there is a definite way to reset */
 	/* the SPI to it's initial value. */
-	if (!spi_internal_read(WILC_SPI_PROTOCOL_OFFSET, &reg)) {
+	if (!spi_internal_read(wilc, WILC_SPI_PROTOCOL_OFFSET, &reg)) {
 		/* Read failed. Try with CRC off. This might happen when module
 		 * is removed but chip isn't reset*/
 		g_spi.crc_off = 1;
 		PRINT_ER("[wilc spi]: Failed internal read protocol with CRC on, retyring with CRC off...\n");
-		if (!spi_internal_read(WILC_SPI_PROTOCOL_OFFSET, &reg)) {
+		if (!spi_internal_read(wilc, WILC_SPI_PROTOCOL_OFFSET, &reg)) {
 			/* Reaad failed with both CRC on and off, something went bad */
 			PRINT_ER("[wilc spi]: Failed internal read protocol...\n");
 			return 0;
@@ -767,7 +770,7 @@ static int _wilc_spi_init(struct wilc *wilc, wilc_debug_func func)
 		reg &= ~0xc;    /* disable crc checking */
 		reg &= ~0x70;
 		reg |= (0x5 << 4);
-		if (!spi_internal_write(WILC_SPI_PROTOCOL_OFFSET, reg)) {
+		if (!spi_internal_write(wilc, WILC_SPI_PROTOCOL_OFFSET, reg)) {
 			PRINT_ER("[wilc spi %d]: Failed internal write protocol reg...\n", __LINE__);
 			return 0;
 		}
@@ -778,7 +781,7 @@ static int _wilc_spi_init(struct wilc *wilc, wilc_debug_func func)
 	/**
 	 *      make sure can read back chip id correctly
 	 **/
-	if (!wilc_spi_read_reg(0x1000, &chipid)) {
+	if (!wilc_spi_read_reg(wilc, 0x1000, &chipid)) {
 		PRINT_ER("[wilc spi]: Fail cmd read chip id...\n");
 		return 0;
 	}
@@ -791,18 +794,20 @@ static int _wilc_spi_init(struct wilc *wilc, wilc_debug_func func)
 	return 1;
 }
 
-static int wilc_spi_read_size(u32 *size)
+static int wilc_spi_read_size(struct wilc *wilc, u32 *size)
 {
 	int ret;
 
 	if (g_spi.has_thrpt_enh) {
-		ret = spi_internal_read(0xe840 - WILC_SPI_REG_BASE, size);
+		ret = spi_internal_read(wilc, 0xe840 - WILC_SPI_REG_BASE,
+					size);
 		*size = *size  & IRQ_DMA_WD_CNT_MASK;
 	} else {
 		u32 tmp;
 		u32 byte_cnt;
 
-		ret = wilc_spi_read_reg(WILC_VMM_TO_HOST_SIZE, &byte_cnt);
+		ret = wilc_spi_read_reg(wilc, WILC_VMM_TO_HOST_SIZE,
+					&byte_cnt);
 		if (!ret) {
 			PRINT_ER("[wilc spi]: Failed read WILC_VMM_TO_HOST_SIZE ...\n");
 			goto _fail_;
@@ -819,17 +824,19 @@ _fail_:
 
 
 
-static int wilc_spi_read_int(u32 *int_status)
+static int wilc_spi_read_int(struct wilc *wilc, u32 *int_status)
 {
 	int ret;
 
 	if (g_spi.has_thrpt_enh) {
-		ret = spi_internal_read(0xe840 - WILC_SPI_REG_BASE, int_status);
+		ret = spi_internal_read(wilc, 0xe840 - WILC_SPI_REG_BASE,
+					int_status);
 	} else {
 		u32 tmp;
 		u32 byte_cnt;
 
-		ret = wilc_spi_read_reg(WILC_VMM_TO_HOST_SIZE, &byte_cnt);
+		ret = wilc_spi_read_reg(wilc, WILC_VMM_TO_HOST_SIZE,
+					&byte_cnt);
 		if (!ret) {
 			PRINT_ER("[wilc spi]: Failed read WILC_VMM_TO_HOST_SIZE ...\n");
 			goto _fail_;
@@ -845,11 +852,12 @@ static int wilc_spi_read_int(u32 *int_status)
 
 				happended = 0;
 
-				wilc_spi_read_reg(0x1a90, &irq_flags);
+				wilc_spi_read_reg(wilc, 0x1a90, &irq_flags);
 				tmp |= ((irq_flags >> 27) << IRG_FLAGS_OFFSET);
 
 				if (g_spi.nint > 5) {
-					wilc_spi_read_reg(0x1a94, &irq_flags);
+					wilc_spi_read_reg(wilc, 0x1a94,
+							  &irq_flags);
 					tmp |= (((irq_flags >> 0) & 0x7) << (IRG_FLAGS_OFFSET + 5));
 				}
 
@@ -875,12 +883,13 @@ _fail_:
 	return ret;
 }
 
-static int wilc_spi_clear_int_ext(u32 val)
+static int wilc_spi_clear_int_ext(struct wilc *wilc, u32 val)
 {
 	int ret;
 
 	if (g_spi.has_thrpt_enh) {
-		ret = spi_internal_write(0xe844 - WILC_SPI_REG_BASE, val);
+		ret = spi_internal_write(wilc, 0xe844 - WILC_SPI_REG_BASE,
+					 val);
 	} else {
 		u32 flags;
 
@@ -892,7 +901,7 @@ static int wilc_spi_clear_int_ext(u32 val)
 			for (i = 0; i < g_spi.nint; i++) {
 				/* No matter what you write 1 or 0, it will clear interrupt. */
 				if (flags & 1)
-					ret = wilc_spi_write_reg(0x10c8 + i * 4, 1);
+					ret = wilc_spi_write_reg(wilc, 0x10c8 + i * 4, 1);
 				if (!ret)
 					break;
 				flags >>= 1;
@@ -919,7 +928,8 @@ static int wilc_spi_clear_int_ext(u32 val)
 			if ((val & SEL_VMM_TBL1) == SEL_VMM_TBL1)
 				tbl_ctl |= BIT(1);
 
-			ret = wilc_spi_write_reg(WILC_VMM_TBL_CTL, tbl_ctl);
+			ret = wilc_spi_write_reg(wilc, WILC_VMM_TBL_CTL,
+						 tbl_ctl);
 			if (!ret) {
 				PRINT_ER("[wilc spi]: fail write reg vmm_tbl_ctl...\n");
 				goto _fail_;
@@ -929,7 +939,8 @@ static int wilc_spi_clear_int_ext(u32 val)
 				/**
 				 *      enable vmm transfer.
 				 **/
-				ret = wilc_spi_write_reg(WILC_VMM_CORE_CTL, 1);
+				ret = wilc_spi_write_reg(wilc,
+							 WILC_VMM_CORE_CTL, 1);
 				if (!ret) {
 					PRINT_ER("[wilc spi]: fail write reg vmm_core_ctl...\n");
 					goto _fail_;
@@ -941,7 +952,7 @@ _fail_:
 	return ret;
 }
 
-static int wilc_spi_sync_ext(int nint /*  how mant interrupts to enable. */)
+static int wilc_spi_sync_ext(struct wilc *wilc, int nint)
 {
 	u32 reg;
 	int ret, i;
@@ -956,13 +967,13 @@ static int wilc_spi_sync_ext(int nint /*  how mant interrupts to enable. */)
 	/**
 	 *      interrupt pin mux select
 	 **/
-	ret = wilc_spi_read_reg(WILC_PIN_MUX_0, &reg);
+	ret = wilc_spi_read_reg(wilc, WILC_PIN_MUX_0, &reg);
 	if (!ret) {
 		PRINT_ER("[wilc spi]: Failed read reg (%08x)...\n", WILC_PIN_MUX_0);
 		return 0;
 	}
 	reg |= BIT(8);
-	ret = wilc_spi_write_reg(WILC_PIN_MUX_0, reg);
+	ret = wilc_spi_write_reg(wilc, WILC_PIN_MUX_0, reg);
 	if (!ret) {
 		PRINT_ER("[wilc spi]: Failed write reg (%08x)...\n", WILC_PIN_MUX_0);
 		return 0;
@@ -971,7 +982,7 @@ static int wilc_spi_sync_ext(int nint /*  how mant interrupts to enable. */)
 	/**
 	 *      interrupt enable
 	 **/
-	ret = wilc_spi_read_reg(WILC_INTR_ENABLE, &reg);
+	ret = wilc_spi_read_reg(wilc, WILC_INTR_ENABLE, &reg);
 	if (!ret) {
 		PRINT_ER("[wilc spi]: Failed read reg (%08x)...\n", WILC_INTR_ENABLE);
 		return 0;
@@ -980,13 +991,13 @@ static int wilc_spi_sync_ext(int nint /*  how mant interrupts to enable. */)
 	for (i = 0; (i < 5) && (nint > 0); i++, nint--) {
 		reg |= (BIT((27 + i)));
 	}
-	ret = wilc_spi_write_reg(WILC_INTR_ENABLE, reg);
+	ret = wilc_spi_write_reg(wilc, WILC_INTR_ENABLE, reg);
 	if (!ret) {
 		PRINT_ER("[wilc spi]: Failed write reg (%08x)...\n", WILC_INTR_ENABLE);
 		return 0;
 	}
 	if (nint) {
-		ret = wilc_spi_read_reg(WILC_INTR2_ENABLE, &reg);
+		ret = wilc_spi_read_reg(wilc, WILC_INTR2_ENABLE, &reg);
 		if (!ret) {
 			PRINT_ER("[wilc spi]: Failed read reg (%08x)...\n", WILC_INTR2_ENABLE);
 			return 0;
@@ -996,7 +1007,7 @@ static int wilc_spi_sync_ext(int nint /*  how mant interrupts to enable. */)
 			reg |= BIT(i);
 		}
 
-		ret = wilc_spi_read_reg(WILC_INTR2_ENABLE, &reg);
+		ret = wilc_spi_read_reg(wilc, WILC_INTR2_ENABLE, &reg);
 		if (!ret) {
 			PRINT_ER("[wilc spi]: Failed write reg (%08x)...\n", WILC_INTR2_ENABLE);
 			return 0;
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index e30a34d..9ac6ad7 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -566,9 +566,9 @@ static inline void chip_allow_sleep(struct wilc *wilc)
 {
 	u32 reg = 0;
 
-	g_wlan.hif_func.hif_read_reg(0xf0, &reg);
+	g_wlan.hif_func.hif_read_reg(wilc, 0xf0, &reg);
 
-	g_wlan.hif_func.hif_write_reg(0xf0, reg & ~BIT(0));
+	g_wlan.hif_func.hif_write_reg(wilc, 0xf0, reg & ~BIT(0));
 }
 
 static inline void chip_wakeup(struct wilc *wilc)
@@ -578,9 +578,9 @@ static inline void chip_wakeup(struct wilc *wilc)
 
 	if ((g_wlan.io_type & 0x1) == HIF_SPI) {
 		do {
-			g_wlan.hif_func.hif_read_reg(1, &reg);
-			g_wlan.hif_func.hif_write_reg(1, reg | BIT(1));
-			g_wlan.hif_func.hif_write_reg(1, reg & ~BIT(1));
+			g_wlan.hif_func.hif_read_reg(wilc, 1, &reg);
+			g_wlan.hif_func.hif_write_reg(wilc, 1, reg | BIT(1));
+			g_wlan.hif_func.hif_write_reg(wilc, 1, reg & ~BIT(1));
 
 			do {
 				usleep_range(2 * 1000, 2 * 1000);
@@ -591,41 +591,44 @@ static inline void chip_wakeup(struct wilc *wilc)
 
 		} while (wilc_get_chipid(wilc, true) == 0);
 	} else if ((g_wlan.io_type & 0x1) == HIF_SDIO)	 {
-		g_wlan.hif_func.hif_read_reg(0xf0, &reg);
+		g_wlan.hif_func.hif_read_reg(wilc, 0xf0, &reg);
 		do {
-			g_wlan.hif_func.hif_write_reg(0xf0, reg | BIT(0));
-			g_wlan.hif_func.hif_read_reg(0xf1, &clk_status_reg);
+			g_wlan.hif_func.hif_write_reg(wilc, 0xf0,
+						      reg | BIT(0));
+			g_wlan.hif_func.hif_read_reg(wilc, 0xf1,
+						     &clk_status_reg);
 
 			while (((clk_status_reg & 0x1) == 0) && (((++trials) % 3) == 0)) {
 				usleep_range(2 * 1000, 2 * 1000);
 
-				g_wlan.hif_func.hif_read_reg(0xf1, &clk_status_reg);
+				g_wlan.hif_func.hif_read_reg(wilc, 0xf1,
+							     &clk_status_reg);
 
 				if ((clk_status_reg & 0x1) == 0)
 					wilc_debug(N_ERR, "clocks still OFF. Wake up failed\n");
 			}
 			if ((clk_status_reg & 0x1) == 0) {
-				g_wlan.hif_func.hif_write_reg(0xf0, reg &
-							      (~BIT(0)));
+				g_wlan.hif_func.hif_write_reg(wilc, 0xf0,
+							      reg & (~BIT(0)));
 			}
 		} while ((clk_status_reg & 0x1) == 0);
 	}
 
 	if (chip_ps_state == CHIP_SLEEPING_MANUAL) {
-		g_wlan.hif_func.hif_read_reg(0x1C0C, &reg);
+		g_wlan.hif_func.hif_read_reg(wilc, 0x1C0C, &reg);
 		reg &= ~BIT(0);
-		g_wlan.hif_func.hif_write_reg(0x1C0C, reg);
+		g_wlan.hif_func.hif_write_reg(wilc, 0x1C0C, reg);
 
 		if (wilc_get_chipid(wilc, false) >= 0x1002b0) {
 			u32 val32;
 
-			g_wlan.hif_func.hif_read_reg(0x1e1c, &val32);
+			g_wlan.hif_func.hif_read_reg(wilc, 0x1e1c, &val32);
 			val32 |= BIT(6);
-			g_wlan.hif_func.hif_write_reg(0x1e1c, val32);
+			g_wlan.hif_func.hif_write_reg(wilc, 0x1e1c, val32);
 
-			g_wlan.hif_func.hif_read_reg(0x1e9c, &val32);
+			g_wlan.hif_func.hif_read_reg(wilc, 0x1e9c, &val32);
 			val32 |= BIT(6);
-			g_wlan.hif_func.hif_write_reg(0x1e9c, val32);
+			g_wlan.hif_func.hif_write_reg(wilc, 0x1e9c, val32);
 		}
 	}
 	chip_ps_state = CHIP_WAKEDUP;
@@ -637,15 +640,18 @@ static inline void chip_wakeup(struct wilc *wilc)
 
 	do {
 		if ((g_wlan.io_type & 0x1) == HIF_SPI) {
-			g_wlan.hif_func.hif_read_reg(1, &reg);
-			g_wlan.hif_func.hif_write_reg(1, reg & ~BIT(1));
-			g_wlan.hif_func.hif_write_reg(1, reg | BIT(1));
-			g_wlan.hif_func.hif_write_reg(1, reg  & ~BIT(1));
+			g_wlan.hif_func.hif_read_reg(wilc, 1, &reg);
+			g_wlan.hif_func.hif_write_reg(wilc, 1, reg & ~BIT(1));
+			g_wlan.hif_func.hif_write_reg(wilc, 1, reg | BIT(1));
+			g_wlan.hif_func.hif_write_reg(wilc, 1, reg  & ~BIT(1));
 		} else if ((g_wlan.io_type & 0x1) == HIF_SDIO)	 {
-			g_wlan.hif_func.hif_read_reg(0xf0, &reg);
-			g_wlan.hif_func.hif_write_reg(0xf0, reg & ~BIT(0));
-			g_wlan.hif_func.hif_write_reg(0xf0, reg | BIT(0));
-			g_wlan.hif_func.hif_write_reg(0xf0, reg  & ~BIT(0));
+			g_wlan.hif_func.hif_read_reg(wilc, 0xf0, &reg);
+			g_wlan.hif_func.hif_write_reg(wilc, 0xf0,
+						      reg & ~BIT(0));
+			g_wlan.hif_func.hif_write_reg(wilc, 0xf0,
+						      reg | BIT(0));
+			g_wlan.hif_func.hif_write_reg(wilc, 0xf0,
+						      reg  & ~BIT(0));
 		}
 
 		do {
@@ -659,20 +665,20 @@ static inline void chip_wakeup(struct wilc *wilc)
 	} while (wilc_get_chipid(wilc, true) == 0);
 
 	if (chip_ps_state == CHIP_SLEEPING_MANUAL) {
-		g_wlan.hif_func.hif_read_reg(0x1C0C, &reg);
+		g_wlan.hif_func.hif_read_reg(wilc, 0x1C0C, &reg);
 		reg &= ~BIT(0);
-		g_wlan.hif_func.hif_write_reg(0x1C0C, reg);
+		g_wlan.hif_func.hif_write_reg(wilc, 0x1C0C, reg);
 
 		if (wilc_get_chipid(wilc, false) >= 0x1002b0) {
 			u32 val32;
 
-			g_wlan.hif_func.hif_read_reg(0x1e1c, &val32);
+			g_wlan.hif_func.hif_read_reg(wilc, 0x1e1c, &val32);
 			val32 |= BIT(6);
-			g_wlan.hif_func.hif_write_reg(0x1e1c, val32);
+			g_wlan.hif_func.hif_write_reg(wilc, 0x1e1c, val32);
 
-			g_wlan.hif_func.hif_read_reg(0x1e9c, &val32);
+			g_wlan.hif_func.hif_read_reg(wilc, 0x1e9c, &val32);
 			val32 |= BIT(6);
-			g_wlan.hif_func.hif_write_reg(0x1e9c, val32);
+			g_wlan.hif_func.hif_write_reg(wilc, 0x1e9c, val32);
 		}
 	}
 	chip_ps_state = CHIP_WAKEDUP;
@@ -687,7 +693,7 @@ void wilc_chip_sleep_manually(struct wilc *wilc)
 #ifdef WILC_OPTIMIZE_SLEEP_INT
 	chip_allow_sleep(wilc);
 #endif
-	g_wlan.hif_func.hif_write_reg(0x10a8, 1);
+	g_wlan.hif_func.hif_write_reg(wilc, 0x10a8, 1);
 
 	chip_ps_state = CHIP_SLEEPING_MANUAL;
 	release_bus(wilc, RELEASE_ONLY);
@@ -778,7 +784,8 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 		acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
 		counter = 0;
 		do {
-			ret = p->hif_func.hif_read_reg(WILC_HOST_TX_CTRL, &reg);
+			ret = p->hif_func.hif_read_reg(wilc, WILC_HOST_TX_CTRL,
+						       &reg);
 			if (!ret) {
 				wilc_debug(N_ERR, "[wilc txq]: fail can't read reg vmm_tbl_entry..\n");
 				break;
@@ -792,7 +799,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 				if (counter > 200) {
 					counter = 0;
 					PRINT_D(TX_DBG, "Looping in tx ctrl , forcce quit\n");
-					ret = p->hif_func.hif_write_reg(WILC_HOST_TX_CTRL, 0);
+					ret = p->hif_func.hif_write_reg(wilc, WILC_HOST_TX_CTRL, 0);
 					break;
 				}
 				PRINT_WRN(GENERIC_DBG, "[wilc txq]: warn, vmm table not clear yet, wait...\n");
@@ -807,20 +814,21 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 
 		timeout = 200;
 		do {
-			ret = p->hif_func.hif_block_tx(WILC_VMM_TBL_RX_SHADOW_BASE, (u8 *)vmm_table, ((i + 1) * 4));
+			ret = p->hif_func.hif_block_tx(wilc, WILC_VMM_TBL_RX_SHADOW_BASE, (u8 *)vmm_table, ((i + 1) * 4));
 			if (!ret) {
 				wilc_debug(N_ERR, "ERR block TX of VMM table.\n");
 				break;
 			}
 
-			ret = p->hif_func.hif_write_reg(WILC_HOST_VMM_CTL, 0x2);
+			ret = p->hif_func.hif_write_reg(wilc, WILC_HOST_VMM_CTL,
+							0x2);
 			if (!ret) {
 				wilc_debug(N_ERR, "[wilc txq]: fail can't write reg host_vmm_ctl..\n");
 				break;
 			}
 
 			do {
-				ret = p->hif_func.hif_read_reg(WILC_HOST_VMM_CTL, &reg);
+				ret = p->hif_func.hif_read_reg(wilc, WILC_HOST_VMM_CTL, &reg);
 				if (!ret) {
 					wilc_debug(N_ERR, "[wilc txq]: fail can't read reg host_vmm_ctl..\n");
 					break;
@@ -836,7 +844,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 				}
 			} while (--timeout);
 			if (timeout <= 0) {
-				ret = p->hif_func.hif_write_reg(WILC_HOST_VMM_CTL, 0x0);
+				ret = p->hif_func.hif_write_reg(wilc, WILC_HOST_VMM_CTL, 0x0);
 				break;
 			}
 
@@ -846,13 +854,13 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 			if (entries == 0) {
 				PRINT_WRN(GENERIC_DBG, "[wilc txq]: no more buffer in the chip (reg: %08x), retry later [[ %d, %x ]]\n", reg, i, vmm_table[i - 1]);
 
-				ret = p->hif_func.hif_read_reg(WILC_HOST_TX_CTRL, &reg);
+				ret = p->hif_func.hif_read_reg(wilc, WILC_HOST_TX_CTRL, &reg);
 				if (!ret) {
 					wilc_debug(N_ERR, "[wilc txq]: fail can't read reg WILC_HOST_TX_CTRL..\n");
 					break;
 				}
 				reg &= ~BIT(0);
-				ret = p->hif_func.hif_write_reg(WILC_HOST_TX_CTRL, reg);
+				ret = p->hif_func.hif_write_reg(wilc, WILC_HOST_TX_CTRL, reg);
 				if (!ret) {
 					wilc_debug(N_ERR, "[wilc txq]: fail can't write reg WILC_HOST_TX_CTRL..\n");
 					break;
@@ -928,13 +936,13 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 
 		acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
 
-		ret = p->hif_func.hif_clear_int_ext(ENABLE_TX_VMM);
+		ret = p->hif_func.hif_clear_int_ext(wilc, ENABLE_TX_VMM);
 		if (!ret) {
 			wilc_debug(N_ERR, "[wilc txq]: fail can't start tx VMM ...\n");
 			goto _end_;
 		}
 
-		ret = p->hif_func.hif_block_tx_ext(0, txb, offset);
+		ret = p->hif_func.hif_block_tx_ext(wilc, 0, txb, offset);
 		if (!ret) {
 			wilc_debug(N_ERR, "[wilc txq]: fail can't block tx ext...\n");
 			goto _end_;
@@ -1058,14 +1066,14 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 
 static void wilc_unknown_isr_ext(struct wilc *wilc)
 {
-	g_wlan.hif_func.hif_clear_int_ext(0);
+	g_wlan.hif_func.hif_clear_int_ext(wilc, 0);
 }
 
 static void wilc_pllupdate_isr_ext(struct wilc *wilc, u32 int_stats)
 {
 	int trials = 10;
 
-	g_wlan.hif_func.hif_clear_int_ext(PLL_INT_CLR);
+	g_wlan.hif_func.hif_clear_int_ext(wilc, PLL_INT_CLR);
 
 	if (g_wlan.io_type == HIF_SDIO)
 		mdelay(WILC_PLL_TO_SDIO);
@@ -1080,7 +1088,7 @@ static void wilc_pllupdate_isr_ext(struct wilc *wilc, u32 int_stats)
 
 static void wilc_sleeptimer_isr_ext(struct wilc *wilc, u32 int_stats1)
 {
-	g_wlan.hif_func.hif_clear_int_ext(SLEEP_INT_CLR);
+	g_wlan.hif_func.hif_clear_int_ext(wilc, SLEEP_INT_CLR);
 #ifndef WILC_OPTIMIZE_SLEEP_INT
 	chip_ps_state = CHIP_SLEEPING_AUTO;
 #endif
@@ -1104,7 +1112,7 @@ static void wilc_wlan_handle_isr_ext(struct wilc *wilc, u32 int_status)
 		u32 time = 0;
 
 		wilc_debug(N_ERR, "RX Size equal zero ... Trying to read it again for %d time\n", time++);
-		p->hif_func.hif_read_size(&size);
+		p->hif_func.hif_read_size(wilc, &size);
 		size = ((size & 0x7fff) << 2);
 		retries++;
 	}
@@ -1128,8 +1136,9 @@ static void wilc_wlan_handle_isr_ext(struct wilc *wilc, u32 int_status)
 			goto _end_;
 		}
 #endif
-		p->hif_func.hif_clear_int_ext(DATA_INT_CLR | ENABLE_RX_VMM);
-		ret = p->hif_func.hif_block_rx_ext(0, buffer, size);
+		p->hif_func.hif_clear_int_ext(wilc,
+					      DATA_INT_CLR | ENABLE_RX_VMM);
+		ret = p->hif_func.hif_block_rx_ext(wilc, 0, buffer, size);
 
 		if (!ret) {
 			wilc_debug(N_ERR, "[wilc isr]: fail block rx...\n");
@@ -1162,7 +1171,7 @@ void wilc_handle_isr(struct wilc *wilc)
 	u32 int_status;
 
 	acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
-	g_wlan.hif_func.hif_read_int(&int_status);
+	g_wlan.hif_func.hif_read_int(wilc, &int_status);
 
 	if (int_status & PLL_INT_EXT)
 		wilc_pllupdate_isr_ext(wilc, int_status);
@@ -1219,7 +1228,8 @@ int wilc_wlan_firmware_download(struct wilc *wilc, const u8 *buffer, u32 buffer_
 				size2 = blksz;
 
 			memcpy(dma_buffer, &buffer[offset], size2);
-			ret = p->hif_func.hif_block_tx(addr, dma_buffer, size2);
+			ret = p->hif_func.hif_block_tx(wilc, addr, dma_buffer,
+						       size2);
 			if (!ret)
 				break;
 
@@ -1260,7 +1270,7 @@ int wilc_wlan_start(struct wilc *wilc)
 		reg = 1;
 	}
 	acquire_bus(wilc, ACQUIRE_ONLY);
-	ret = p->hif_func.hif_write_reg(WILC_VMM_CORE_CFG, reg);
+	ret = p->hif_func.hif_write_reg(wilc, WILC_VMM_CORE_CFG, reg);
 	if (!ret) {
 		wilc_debug(N_ERR, "[wilc start]: fail write reg vmm_core_cfg...\n");
 		release_bus(wilc, RELEASE_ONLY);
@@ -1294,7 +1304,7 @@ int wilc_wlan_start(struct wilc *wilc)
 	reg |= WILC_HAVE_DISABLE_WILC_UART;
 #endif
 
-	ret = p->hif_func.hif_write_reg(WILC_GP_REG_1, reg);
+	ret = p->hif_func.hif_write_reg(wilc, WILC_GP_REG_1, reg);
 	if (!ret) {
 		wilc_debug(N_ERR, "[wilc start]: fail write WILC_GP_REG_1 ...\n");
 		release_bus(wilc, RELEASE_ONLY);
@@ -1302,9 +1312,9 @@ int wilc_wlan_start(struct wilc *wilc)
 		return ret;
 	}
 
-	p->hif_func.hif_sync_ext(NUM_INT_EXT);
+	p->hif_func.hif_sync_ext(wilc, NUM_INT_EXT);
 
-	ret = p->hif_func.hif_read_reg(0x1000, &chipid);
+	ret = p->hif_func.hif_read_reg(wilc, 0x1000, &chipid);
 	if (!ret) {
 		wilc_debug(N_ERR, "[wilc start]: fail read reg 0x1000 ...\n");
 		release_bus(wilc, RELEASE_ONLY);
@@ -1312,16 +1322,16 @@ int wilc_wlan_start(struct wilc *wilc)
 		return ret;
 	}
 
-	p->hif_func.hif_read_reg(WILC_GLB_RESET_0, &reg);
+	p->hif_func.hif_read_reg(wilc, WILC_GLB_RESET_0, &reg);
 	if ((reg & BIT(10)) == BIT(10)) {
 		reg &= ~BIT(10);
-		p->hif_func.hif_write_reg(WILC_GLB_RESET_0, reg);
-		p->hif_func.hif_read_reg(WILC_GLB_RESET_0, &reg);
+		p->hif_func.hif_write_reg(wilc, WILC_GLB_RESET_0, reg);
+		p->hif_func.hif_read_reg(wilc, WILC_GLB_RESET_0, &reg);
 	}
 
 	reg |= BIT(10);
-	ret = p->hif_func.hif_write_reg(WILC_GLB_RESET_0, reg);
-	p->hif_func.hif_read_reg(WILC_GLB_RESET_0, &reg);
+	ret = p->hif_func.hif_write_reg(wilc, WILC_GLB_RESET_0, reg);
+	p->hif_func.hif_read_reg(wilc, WILC_GLB_RESET_0, &reg);
 	release_bus(wilc, RELEASE_ONLY);
 
 	return (ret < 0) ? ret : 0;
@@ -1333,7 +1343,7 @@ void wilc_wlan_global_reset(struct wilc *wilc)
 	wilc_wlan_dev_t *p = &g_wlan;
 
 	acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
-	p->hif_func.hif_write_reg(WILC_GLB_RESET_0, 0x0);
+	p->hif_func.hif_write_reg(wilc, WILC_GLB_RESET_0, 0x0);
 	release_bus(wilc, RELEASE_ONLY);
 }
 int wilc_wlan_stop(struct wilc *wilc)
@@ -1344,7 +1354,7 @@ int wilc_wlan_stop(struct wilc *wilc)
 	u8 timeout = 10;
 	acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
 
-	ret = p->hif_func.hif_read_reg(WILC_GLB_RESET_0, &reg);
+	ret = p->hif_func.hif_read_reg(wilc, WILC_GLB_RESET_0, &reg);
 	if (!ret) {
 		PRINT_ER("Error while reading reg\n");
 		release_bus(wilc, RELEASE_ALLOW_SLEEP);
@@ -1352,7 +1362,7 @@ int wilc_wlan_stop(struct wilc *wilc)
 	}
 
 	reg &= ~BIT(10);
-	ret = p->hif_func.hif_write_reg(WILC_GLB_RESET_0, reg);
+	ret = p->hif_func.hif_write_reg(wilc, WILC_GLB_RESET_0, reg);
 	if (!ret) {
 		PRINT_ER("Error while writing reg\n");
 		release_bus(wilc, RELEASE_ALLOW_SLEEP);
@@ -1360,7 +1370,7 @@ int wilc_wlan_stop(struct wilc *wilc)
 	}
 
 	do {
-		ret = p->hif_func.hif_read_reg(WILC_GLB_RESET_0, &reg);
+		ret = p->hif_func.hif_read_reg(wilc, WILC_GLB_RESET_0, &reg);
 		if (!ret) {
 			PRINT_ER("Error while reading reg\n");
 			release_bus(wilc, RELEASE_ALLOW_SLEEP);
@@ -1373,12 +1383,14 @@ int wilc_wlan_stop(struct wilc *wilc)
 			PRINT_D(GENERIC_DBG, "Bit 10 not reset : Retry %d\n",
 				timeout);
 			reg &= ~BIT(10);
-			ret = p->hif_func.hif_write_reg(WILC_GLB_RESET_0, reg);
+			ret = p->hif_func.hif_write_reg(wilc, WILC_GLB_RESET_0,
+							reg);
 			timeout--;
 		} else {
 			PRINT_D(GENERIC_DBG, "Bit 10 reset after : Retry %d\n",
 				timeout);
-			ret = p->hif_func.hif_read_reg(WILC_GLB_RESET_0, &reg);
+			ret = p->hif_func.hif_read_reg(wilc, WILC_GLB_RESET_0,
+						       &reg);
 			if (!ret) {
 				PRINT_ER("Error while reading reg\n");
 				release_bus(wilc, RELEASE_ALLOW_SLEEP);
@@ -1393,10 +1405,10 @@ int wilc_wlan_stop(struct wilc *wilc)
 	reg = (BIT(0) | BIT(1) | BIT(2) | BIT(3) | BIT(8) | BIT(9) | BIT(26) |
 	       BIT(29) | BIT(30) | BIT(31));
 
-	p->hif_func.hif_write_reg(WILC_GLB_RESET_0, reg);
+	p->hif_func.hif_write_reg(wilc, WILC_GLB_RESET_0, reg);
 	reg = (u32)~BIT(10);
 
-	ret = p->hif_func.hif_write_reg(WILC_GLB_RESET_0, reg);
+	ret = p->hif_func.hif_write_reg(wilc, WILC_GLB_RESET_0, reg);
 
 	release_bus(wilc, RELEASE_ALLOW_SLEEP);
 
@@ -1444,13 +1456,14 @@ void wilc_wlan_cleanup(struct net_device *dev)
 
 	acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
 
-	ret = p->hif_func.hif_read_reg(WILC_GP_REG_0, &reg);
+	ret = p->hif_func.hif_read_reg(wilc, WILC_GP_REG_0, &reg);
 	if (!ret) {
 		PRINT_ER("Error while reading reg\n");
 		release_bus(wilc, RELEASE_ALLOW_SLEEP);
 	}
 	PRINT_ER("Writing ABORT reg\n");
-	ret = p->hif_func.hif_write_reg(WILC_GP_REG_0, (reg | ABORT_INT));
+	ret = p->hif_func.hif_write_reg(wilc, WILC_GP_REG_0,
+					(reg | ABORT_INT));
 	if (!ret) {
 		PRINT_ER("Error while writing reg\n");
 		release_bus(wilc, RELEASE_ALLOW_SLEEP);
@@ -1590,18 +1603,18 @@ static u32 init_chip(struct net_device *dev)
 	chipid = wilc_get_chipid(wilc, true);
 
 	if ((chipid & 0xfff) != 0xa0) {
-		ret = g_wlan.hif_func.hif_read_reg(0x1118, &reg);
+		ret = g_wlan.hif_func.hif_read_reg(wilc, 0x1118, &reg);
 		if (!ret) {
 			wilc_debug(N_ERR, "[wilc start]: fail read reg 0x1118 ...\n");
 			return ret;
 		}
 		reg |= BIT(0);
-		ret = g_wlan.hif_func.hif_write_reg(0x1118, reg);
+		ret = g_wlan.hif_func.hif_write_reg(wilc, 0x1118, reg);
 		if (!ret) {
 			wilc_debug(N_ERR, "[wilc start]: fail write reg 0x1118 ...\n");
 			return ret;
 		}
-		ret = g_wlan.hif_func.hif_write_reg(0xc0000, 0x71);
+		ret = g_wlan.hif_func.hif_write_reg(wilc, 0xc0000, 0x71);
 		if (!ret) {
 			wilc_debug(N_ERR, "[wilc start]: fail write reg 0xc0000 ...\n");
 			return ret;
@@ -1620,8 +1633,8 @@ u32 wilc_get_chipid(struct wilc *wilc, u8 update)
 	u32 rfrevid;
 
 	if (chipid == 0 || update != 0) {
-		g_wlan.hif_func.hif_read_reg(0x1000, &tempchipid);
-		g_wlan.hif_func.hif_read_reg(0x13f4, &rfrevid);
+		g_wlan.hif_func.hif_read_reg(wilc, 0x1000, &tempchipid);
+		g_wlan.hif_func.hif_read_reg(wilc, 0x13f4, &rfrevid);
 		if (!ISWILC1000(tempchipid)) {
 			chipid = 0;
 			goto _fail_;
@@ -1723,7 +1736,8 @@ u16 wilc_set_machw_change_vir_if(struct net_device *dev, bool value)
 	wilc = nic->wilc;
 
 	mutex_lock(&wilc->hif_cs);
-	ret = (&g_wlan)->hif_func.hif_read_reg(WILC_CHANGING_VIR_IF, &reg);
+	ret = (&g_wlan)->hif_func.hif_read_reg(wilc, WILC_CHANGING_VIR_IF,
+					       &reg);
 	if (!ret)
 		PRINT_ER("Error while Reading reg WILC_CHANGING_VIR_IF\n");
 
@@ -1732,7 +1746,8 @@ u16 wilc_set_machw_change_vir_if(struct net_device *dev, bool value)
 	else
 		reg &= ~BIT(31);
 
-	ret = (&g_wlan)->hif_func.hif_write_reg(WILC_CHANGING_VIR_IF, reg);
+	ret = (&g_wlan)->hif_func.hif_write_reg(wilc, WILC_CHANGING_VIR_IF,
+						reg);
 
 	if (!ret)
 		PRINT_ER("Error while writing reg WILC_CHANGING_VIR_IF\n");
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 334abafe..c3f13aa 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -238,19 +238,19 @@ struct rxq_entry_t {
 struct wilc;
 struct wilc_hif_func {
 	int (*hif_init)(struct wilc *, wilc_debug_func);
-	int (*hif_deinit)(void *);
-	int (*hif_read_reg)(u32, u32 *);
-	int (*hif_write_reg)(u32, u32);
-	int (*hif_block_rx)(u32, u8 *, u32);
-	int (*hif_block_tx)(u32, u8 *, u32);
-	int (*hif_sync)(void);
-	int (*hif_clear_int)(void);
-	int (*hif_read_int)(u32 *);
-	int (*hif_clear_int_ext)(u32);
-	int (*hif_read_size)(u32 *);
-	int (*hif_block_tx_ext)(u32, u8 *, u32);
-	int (*hif_block_rx_ext)(u32, u8 *, u32);
-	int (*hif_sync_ext)(int);
+	int (*hif_deinit)(struct wilc *);
+	int (*hif_read_reg)(struct wilc *, u32, u32 *);
+	int (*hif_write_reg)(struct wilc *, u32, u32);
+	int (*hif_block_rx)(struct wilc *, u32, u8 *, u32);
+	int (*hif_block_tx)(struct wilc *, u32, u8 *, u32);
+	int (*hif_sync)(struct wilc *);
+	int (*hif_clear_int)(struct wilc *);
+	int (*hif_read_int)(struct wilc *, u32 *);
+	int (*hif_clear_int_ext)(struct wilc *, u32);
+	int (*hif_read_size)(struct wilc *, u32 *);
+	int (*hif_block_tx_ext)(struct wilc *, u32, u8 *, u32);
+	int (*hif_block_rx_ext)(struct wilc *, u32, u8 *, u32);
+	int (*hif_sync_ext)(struct wilc *, int);
 	int (*enable_interrupt)(struct wilc *nic);
 	void (*disable_interrupt)(struct wilc *nic);
 };
-- 
1.9.1

