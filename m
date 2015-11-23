Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:48640 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbbKWJop (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2015 04:44:45 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 01/10] staging: wilc1000: sdio/spi: use device print api instead of custom one
Date: Mon, 23 Nov 2015 18:47:59 +0900
Message-ID: <1448272088-13973-1-git-send-email-glen.lee@atmel.com> (sfid-20151123_104450_912975_CBC55B8D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch use device print api instead of driver defined print. Remove
varialbe dPrint as well. String "[wilc sdio]" and "[wilc spi]" are also removed
from all the print statment if exist because it shows which device the message
is related to.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan_sdio.c |  18 ++--
 drivers/staging/wilc1000/linux_wlan_spi.c  |  24 +++--
 drivers/staging/wilc1000/wilc_sdio.c       | 151 +++++++++++++++++++----------
 drivers/staging/wilc1000/wilc_spi.c        | 142 +++++++++++++++++----------
 4 files changed, 213 insertions(+), 122 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index ae31f7d..66cdca2 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -52,7 +52,7 @@ int wilc_sdio_cmd52(struct wilc *wilc, sdio_cmd52_t *cmd)
 	sdio_release_host(func);
 
 	if (ret < 0) {
-		PRINT_ER("wilc_sdio_cmd52..failed, err(%d)\n", ret);
+		dev_err(&func->dev, "wilc_sdio_cmd52..failed, err(%d)\n", ret);
 		return 0;
 	}
 	return 1;
@@ -83,7 +83,7 @@ int wilc_sdio_cmd53(struct wilc *wilc, sdio_cmd53_t *cmd)
 
 
 	if (ret < 0) {
-		PRINT_ER("wilc_sdio_cmd53..failed, err(%d)\n", ret);
+		dev_err(&func->dev, "wilc_sdio_cmd53..failed, err(%d)\n", ret);
 		return 0;
 	}
 
@@ -102,16 +102,16 @@ static int linux_sdio_probe(struct sdio_func *func, const struct sdio_device_id
 			gpio = GPIO_NUM;
 	}
 
-	PRINT_D(INIT_DBG, "Initializing netdev\n");
+	dev_dbg(&func->dev, "Initializing netdev\n");
 	if (wilc_netdev_init(&wilc, &func->dev, HIF_SDIO, gpio,
 			     &wilc_hif_sdio)) {
-		PRINT_ER("Couldn't initialize netdev\n");
+		dev_err(&func->dev, "Couldn't initialize netdev\n");
 		return -1;
 	}
 	sdio_set_drvdata(func, wilc);
 	wilc->dev = &func->dev;
 
-	printk("Driver Initializing success\n");
+	dev_info(&func->dev, "Driver Initializing success\n");
 	return 0;
 }
 
@@ -139,7 +139,7 @@ int wilc_sdio_enable_interrupt(struct wilc *dev)
 	sdio_release_host(func);
 
 	if (ret < 0) {
-		PRINT_ER("can't claim sdio_irq, err(%d)\n", ret);
+		dev_err(&func->dev, "can't claim sdio_irq, err(%d)\n", ret);
 		ret = -EIO;
 	}
 	return ret;
@@ -150,16 +150,16 @@ void wilc_sdio_disable_interrupt(struct wilc *dev)
 	struct sdio_func *func = container_of(dev->dev, struct sdio_func, dev);
 	int ret;
 
-	PRINT_D(INIT_DBG, "wilc_sdio_disable_interrupt IN\n");
+	dev_dbg(&func->dev, "wilc_sdio_disable_interrupt IN\n");
 
 	sdio_claim_host(func);
 	ret = sdio_release_irq(func);
 	if (ret < 0) {
-		PRINT_ER("can't release sdio_irq, err(%d)\n", ret);
+		dev_err(&func->dev, "can't release sdio_irq, err(%d)\n", ret);
 	}
 	sdio_release_host(func);
 
-	PRINT_D(INIT_DBG, "wilc_sdio_disable_interrupt OUT\n");
+	dev_info(&func->dev, "wilc_sdio_disable_interrupt OUT\n");
 }
 
 int wilc_sdio_init(void)
diff --git a/drivers/staging/wilc1000/linux_wlan_spi.c b/drivers/staging/wilc1000/linux_wlan_spi.c
index f3ffc9e..01fa6fa 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.c
+++ b/drivers/staging/wilc1000/linux_wlan_spi.c
@@ -83,7 +83,7 @@ int wilc_spi_write(struct wilc *wilc, u8 *b, u32 len)
 			return -ENOMEM;
 
 		tr.rx_buf = r_buffer;
-		PRINT_D(BUS_DBG, "Request writing %d bytes\n", len);
+		dev_dbg(&spi->dev, "Request writing %d bytes\n", len);
 
 		memset(&msg, 0, sizeof(msg));
 		spi_message_init(&msg);
@@ -95,13 +95,17 @@ int wilc_spi_write(struct wilc *wilc, u8 *b, u32 len)
 
 		ret = spi_sync(spi, &msg);
 		if (ret < 0) {
-			PRINT_ER("SPI transaction failed\n");
+			dev_err(&spi->dev, "SPI transaction failed\n");
 		}
 
 		kfree(r_buffer);
 	} else {
-		PRINT_ER("can't write data with the following length: %d\n", len);
-		PRINT_ER("FAILED due to NULL buffer or ZERO length check the following length: %d\n", len);
+		dev_err(&spi->dev,
+			"can't write data with the following length: %d\n",
+			len);
+		dev_err(&spi->dev,
+			"FAILED due to NULL buffer or ZERO length check the following length: %d\n",
+			len);
 		ret = -1;
 	}
 
@@ -141,11 +145,13 @@ int wilc_spi_read(struct wilc *wilc, u8 *rb, u32 rlen)
 
 		ret = spi_sync(spi, &msg);
 		if (ret < 0) {
-			PRINT_ER("SPI transaction failed\n");
+			dev_err(&spi->dev, "SPI transaction failed\n");
 		}
 		kfree(t_buffer);
 	} else {
-		PRINT_ER("can't read data with the following length: %u\n", rlen);
+		dev_err(&spi->dev,
+			"can't read data with the following length: %u\n",
+			rlen);
 		ret = -1;
 	}
 	/* change return value to match WILC interface */
@@ -178,10 +184,12 @@ int wilc_spi_write_read(struct wilc *wilc, u8 *wb, u8 *rb, u32 rlen)
 		spi_message_add_tail(&tr, &msg);
 		ret = spi_sync(spi, &msg);
 		if (ret < 0) {
-			PRINT_ER("SPI transaction failed\n");
+			dev_err(&spi->dev, "SPI transaction failed\n");
 		}
 	} else {
-		PRINT_ER("can't read data with the following length: %u\n", rlen);
+		dev_err(&spi->dev,
+			"can't read data with the following length: %u\n",
+			rlen);
 		ret = -1;
 	}
 	/* change return value to match WILC interface */
diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 6eae08e..30dd7f9 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -18,7 +18,6 @@
 typedef struct {
 	bool irq_gpio;
 	u32 block_size;
-	wilc_debug_func dPrint;
 	int nint;
 #define MAX_NUN_INT_THRPT_ENH2 (5) /* Max num interrupts allowed in registers 0xf7, 0xf8 */
 	int has_thrpt_enh3;
@@ -37,6 +36,7 @@ static int sdio_read_reg(struct wilc *wilc, u32 addr, u32 *data);
 
 static int sdio_set_func0_csa_address(struct wilc *wilc, u32 adr)
 {
+	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
 	sdio_cmd52_t cmd;
 
 	/**
@@ -48,21 +48,21 @@ static int sdio_set_func0_csa_address(struct wilc *wilc, u32 adr)
 	cmd.address = 0x10c;
 	cmd.data = (u8)adr;
 	if (!wilc_sdio_cmd52(wilc, &cmd)) {
-		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0x10c data...\n");
+		dev_err(&func->dev, "Failed cmd52, set 0x10c data...\n");
 		goto _fail_;
 	}
 
 	cmd.address = 0x10d;
 	cmd.data = (u8)(adr >> 8);
 	if (!wilc_sdio_cmd52(wilc, &cmd)) {
-		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0x10d data...\n");
+		dev_err(&func->dev, "Failed cmd52, set 0x10d data...\n");
 		goto _fail_;
 	}
 
 	cmd.address = 0x10e;
 	cmd.data = (u8)(adr >> 16);
 	if (!wilc_sdio_cmd52(wilc, &cmd)) {
-		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0x10e data...\n");
+		dev_err(&func->dev, "Failed cmd52, set 0x10e data...\n");
 		goto _fail_;
 	}
 
@@ -73,6 +73,7 @@ _fail_:
 
 static int sdio_set_func0_block_size(struct wilc *wilc, u32 block_size)
 {
+	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
 	sdio_cmd52_t cmd;
 
 	cmd.read_write = 1;
@@ -81,14 +82,14 @@ static int sdio_set_func0_block_size(struct wilc *wilc, u32 block_size)
 	cmd.address = 0x10;
 	cmd.data = (u8)block_size;
 	if (!wilc_sdio_cmd52(wilc, &cmd)) {
-		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0x10 data...\n");
+		dev_err(&func->dev, "Failed cmd52, set 0x10 data...\n");
 		goto _fail_;
 	}
 
 	cmd.address = 0x11;
 	cmd.data = (u8)(block_size >> 8);
 	if (!wilc_sdio_cmd52(wilc, &cmd)) {
-		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0x11 data...\n");
+		dev_err(&func->dev, "Failed cmd52, set 0x11 data...\n");
 		goto _fail_;
 	}
 
@@ -105,6 +106,7 @@ _fail_:
 
 static int sdio_set_func1_block_size(struct wilc *wilc, u32 block_size)
 {
+	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
 	sdio_cmd52_t cmd;
 
 	cmd.read_write = 1;
@@ -113,13 +115,13 @@ static int sdio_set_func1_block_size(struct wilc *wilc, u32 block_size)
 	cmd.address = 0x110;
 	cmd.data = (u8)block_size;
 	if (!wilc_sdio_cmd52(wilc, &cmd)) {
-		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0x110 data...\n");
+		dev_err(&func->dev, "Failed cmd52, set 0x110 data...\n");
 		goto _fail_;
 	}
 	cmd.address = 0x111;
 	cmd.data = (u8)(block_size >> 8);
 	if (!wilc_sdio_cmd52(wilc, &cmd)) {
-		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0x111 data...\n");
+		dev_err(&func->dev, "Failed cmd52, set 0x111 data...\n");
 		goto _fail_;
 	}
 
@@ -130,6 +132,8 @@ _fail_:
 
 static int sdio_clear_int(struct wilc *wilc)
 {
+	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
+
 	if (!g_sdio.irq_gpio) {
 		/* u32 sts; */
 		sdio_cmd52_t cmd;
@@ -146,7 +150,8 @@ static int sdio_clear_int(struct wilc *wilc)
 		u32 reg;
 
 		if (!sdio_read_reg(wilc, WILC_HOST_RX_CTRL_0, &reg)) {
-			g_sdio.dPrint(N_ERR, "[wilc spi]: Failed read reg (%08x)...\n", WILC_HOST_RX_CTRL_0);
+			dev_err(&func->dev, "Failed read reg (%08x)...\n",
+				WILC_HOST_RX_CTRL_0);
 			return 0;
 		}
 		reg &= ~0x1;
@@ -163,6 +168,8 @@ static int sdio_clear_int(struct wilc *wilc)
  ********************************************/
 static int sdio_write_reg(struct wilc *wilc, u32 addr, u32 data)
 {
+	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
+
 	data = cpu_to_le32(data);
 
 	if ((addr >= 0xf0) && (addr <= 0xff)) {
@@ -174,7 +181,8 @@ static int sdio_write_reg(struct wilc *wilc, u32 addr, u32 data)
 		cmd.address = addr;
 		cmd.data = data;
 		if (!wilc_sdio_cmd52(wilc, &cmd)) {
-			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd 52, read reg (%08x) ...\n", addr);
+			dev_err(&func->dev,
+				"Failed cmd 52, read reg (%08x) ...\n", addr);
 			goto _fail_;
 		}
 	} else {
@@ -196,7 +204,8 @@ static int sdio_write_reg(struct wilc *wilc, u32 addr, u32 data)
 		cmd.block_size = g_sdio.block_size; /* johnny : prevent it from setting unexpected value */
 
 		if (!wilc_sdio_cmd53(wilc, &cmd)) {
-			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd53, write reg (%08x)...\n", addr);
+			dev_err(&func->dev,
+				"Failed cmd53, write reg (%08x)...\n", addr);
 			goto _fail_;
 		}
 	}
@@ -210,6 +219,7 @@ _fail_:
 
 static int sdio_write(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 {
+	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
 	u32 block_size = g_sdio.block_size;
 	sdio_cmd53_t cmd;
 	int nblk, nleft;
@@ -259,7 +269,8 @@ static int sdio_write(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 				goto _fail_;
 		}
 		if (!wilc_sdio_cmd53(wilc, &cmd)) {
-			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd53 [%x], block send...\n", addr);
+			dev_err(&func->dev,
+				"Failed cmd53 [%x], block send...\n", addr);
 			goto _fail_;
 		}
 		if (addr > 0)
@@ -280,7 +291,8 @@ static int sdio_write(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 				goto _fail_;
 		}
 		if (!wilc_sdio_cmd53(wilc, &cmd)) {
-			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd53 [%x], bytes send...\n", addr);
+			dev_err(&func->dev,
+				"Failed cmd53 [%x], bytes send...\n", addr);
 			goto _fail_;
 		}
 	}
@@ -294,6 +306,8 @@ _fail_:
 
 static int sdio_read_reg(struct wilc *wilc, u32 addr, u32 *data)
 {
+	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
+
 	if ((addr >= 0xf0) && (addr <= 0xff)) {
 		sdio_cmd52_t cmd;
 
@@ -302,7 +316,8 @@ static int sdio_read_reg(struct wilc *wilc, u32 addr, u32 *data)
 		cmd.raw = 0;
 		cmd.address = addr;
 		if (!wilc_sdio_cmd52(wilc, &cmd)) {
-			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd 52, read reg (%08x) ...\n", addr);
+			dev_err(&func->dev,
+				"Failed cmd 52, read reg (%08x) ...\n", addr);
 			goto _fail_;
 		}
 		*data = cmd.data;
@@ -323,7 +338,8 @@ static int sdio_read_reg(struct wilc *wilc, u32 addr, u32 *data)
 		cmd.block_size = g_sdio.block_size; /* johnny : prevent it from setting unexpected value */
 
 		if (!wilc_sdio_cmd53(wilc, &cmd)) {
-			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd53, read reg (%08x)...\n", addr);
+			dev_err(&func->dev,
+				"Failed cmd53, read reg (%08x)...\n", addr);
 			goto _fail_;
 		}
 	}
@@ -339,6 +355,7 @@ _fail_:
 
 static int sdio_read(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 {
+	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
 	u32 block_size = g_sdio.block_size;
 	sdio_cmd53_t cmd;
 	int nblk, nleft;
@@ -388,7 +405,8 @@ static int sdio_read(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 				goto _fail_;
 		}
 		if (!wilc_sdio_cmd53(wilc, &cmd)) {
-			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd53 [%x], block read...\n", addr);
+			dev_err(&func->dev,
+				"Failed cmd53 [%x], block read...\n", addr);
 			goto _fail_;
 		}
 		if (addr > 0)
@@ -409,7 +427,8 @@ static int sdio_read(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 				goto _fail_;
 		}
 		if (!wilc_sdio_cmd53(wilc, &cmd)) {
-			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd53 [%x], bytes read...\n", addr);
+			dev_err(&func->dev,
+				"Failed cmd53 [%x], bytes read...\n", addr);
 			goto _fail_;
 		}
 	}
@@ -434,19 +453,20 @@ static int sdio_deinit(struct wilc *wilc)
 
 static int sdio_sync(struct wilc *wilc)
 {
+	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
 	u32 reg;
 
 	/**
 	 *      Disable power sequencer
 	 **/
 	if (!sdio_read_reg(wilc, WILC_MISC, &reg)) {
-		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed read misc reg...\n");
+		dev_err(&func->dev, "Failed read misc reg...\n");
 		return 0;
 	}
 
 	reg &= ~BIT(8);
 	if (!sdio_write_reg(wilc, WILC_MISC, reg)) {
-		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed write misc reg...\n");
+		dev_err(&func->dev, "Failed write misc reg...\n");
 		return 0;
 	}
 
@@ -459,13 +479,15 @@ static int sdio_sync(struct wilc *wilc)
 		 **/
 		ret = sdio_read_reg(wilc, WILC_PIN_MUX_0, &reg);
 		if (!ret) {
-			g_sdio.dPrint(N_ERR, "[wilc spi]: Failed read reg (%08x)...\n", WILC_PIN_MUX_0);
+			dev_err(&func->dev, "Failed read reg (%08x)...\n",
+				WILC_PIN_MUX_0);
 			return 0;
 		}
 		reg |= BIT(8);
 		ret = sdio_write_reg(wilc, WILC_PIN_MUX_0, reg);
 		if (!ret) {
-			g_sdio.dPrint(N_ERR, "[wilc spi]: Failed write reg (%08x)...\n", WILC_PIN_MUX_0);
+			dev_err(&func->dev, "Failed write reg (%08x)...\n",
+				WILC_PIN_MUX_0);
 			return 0;
 		}
 
@@ -474,13 +496,15 @@ static int sdio_sync(struct wilc *wilc)
 		 **/
 		ret = sdio_read_reg(wilc, WILC_INTR_ENABLE, &reg);
 		if (!ret) {
-			g_sdio.dPrint(N_ERR, "[wilc spi]: Failed read reg (%08x)...\n", WILC_INTR_ENABLE);
+			dev_err(&func->dev, "Failed read reg (%08x)...\n",
+				WILC_INTR_ENABLE);
 			return 0;
 		}
 		reg |= BIT(16);
 		ret = sdio_write_reg(wilc, WILC_INTR_ENABLE, reg);
 		if (!ret) {
-			g_sdio.dPrint(N_ERR, "[wilc spi]: Failed write reg (%08x)...\n", WILC_INTR_ENABLE);
+			dev_err(&func->dev, "Failed write reg (%08x)...\n",
+				WILC_INTR_ENABLE);
 			return 0;
 		}
 	}
@@ -488,19 +512,19 @@ static int sdio_sync(struct wilc *wilc)
 	return 1;
 }
 
-static int sdio_init(struct wilc *wilc, wilc_debug_func func)
+static int sdio_init(struct wilc *wilc, wilc_debug_func debug_func)
 {
+	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
 	sdio_cmd52_t cmd;
 	int loop;
 	u32 chipid;
 
 	memset(&g_sdio, 0, sizeof(wilc_sdio_t));
 
-	g_sdio.dPrint = func;
 	g_sdio.irq_gpio = (wilc->dev_irq_num);
 
 	if (!wilc_sdio_init()) {
-		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed io init bus...\n");
+		dev_err(&func->dev, "Failed io init bus...\n");
 		return 0;
 	}
 
@@ -513,7 +537,7 @@ static int sdio_init(struct wilc *wilc, wilc_debug_func func)
 	cmd.address = 0x100;
 	cmd.data = 0x80;
 	if (!wilc_sdio_cmd52(wilc, &cmd)) {
-		g_sdio.dPrint(N_ERR, "[wilc sdio]: Fail cmd 52, enable csa...\n");
+		dev_err(&func->dev, "Fail cmd 52, enable csa...\n");
 		goto _fail_;
 	}
 
@@ -521,7 +545,7 @@ static int sdio_init(struct wilc *wilc, wilc_debug_func func)
 	 *      function 0 block size
 	 **/
 	if (!sdio_set_func0_block_size(wilc, WILC_SDIO_BLOCK_SIZE)) {
-		g_sdio.dPrint(N_ERR, "[wilc sdio]: Fail cmd 52, set func 0 block size...\n");
+		dev_err(&func->dev, "Fail cmd 52, set func 0 block size...\n");
 		goto _fail_;
 	}
 	g_sdio.block_size = WILC_SDIO_BLOCK_SIZE;
@@ -535,7 +559,8 @@ static int sdio_init(struct wilc *wilc, wilc_debug_func func)
 	cmd.address = 0x2;
 	cmd.data = 0x2;
 	if (!wilc_sdio_cmd52(wilc, &cmd)) {
-		g_sdio.dPrint(N_ERR, "[wilc sdio] Fail cmd 52, set IOE register...\n");
+		dev_err(&func->dev,
+			"Fail cmd 52, set IOE register...\n");
 		goto _fail_;
 	}
 
@@ -550,7 +575,8 @@ static int sdio_init(struct wilc *wilc, wilc_debug_func func)
 	do {
 		cmd.data = 0;
 		if (!wilc_sdio_cmd52(wilc, &cmd)) {
-			g_sdio.dPrint(N_ERR, "[wilc sdio]: Fail cmd 52, get IOR register...\n");
+			dev_err(&func->dev,
+				"Fail cmd 52, get IOR register...\n");
 			goto _fail_;
 		}
 		if (cmd.data == 0x2)
@@ -558,7 +584,7 @@ static int sdio_init(struct wilc *wilc, wilc_debug_func func)
 	} while (loop--);
 
 	if (loop <= 0) {
-		g_sdio.dPrint(N_ERR, "[wilc sdio]: Fail func 1 is not ready...\n");
+		dev_err(&func->dev, "Fail func 1 is not ready...\n");
 		goto _fail_;
 	}
 
@@ -566,7 +592,7 @@ static int sdio_init(struct wilc *wilc, wilc_debug_func func)
 	 *      func 1 is ready, set func 1 block size
 	 **/
 	if (!sdio_set_func1_block_size(wilc, WILC_SDIO_BLOCK_SIZE)) {
-		g_sdio.dPrint(N_ERR, "[wilc sdio]: Fail set func 1 block size...\n");
+		dev_err(&func->dev, "Fail set func 1 block size...\n");
 		goto _fail_;
 	}
 
@@ -579,7 +605,7 @@ static int sdio_init(struct wilc *wilc, wilc_debug_func func)
 	cmd.address = 0x4;
 	cmd.data = 0x3;
 	if (!wilc_sdio_cmd52(wilc, &cmd)) {
-		g_sdio.dPrint(N_ERR, "[wilc sdio]: Fail cmd 52, set IEN register...\n");
+		dev_err(&func->dev, "Fail cmd 52, set IEN register...\n");
 		goto _fail_;
 	}
 
@@ -587,15 +613,15 @@ static int sdio_init(struct wilc *wilc, wilc_debug_func func)
 	 *      make sure can read back chip id correctly
 	 **/
 	if (!sdio_read_reg(wilc, 0x1000, &chipid)) {
-		g_sdio.dPrint(N_ERR, "[wilc sdio]: Fail cmd read chip id...\n");
+		dev_err(&func->dev, "Fail cmd read chip id...\n");
 		goto _fail_;
 	}
-	g_sdio.dPrint(N_ERR, "[wilc sdio]: chipid (%08x)\n", chipid);
+	dev_err(&func->dev, "chipid (%08x)\n", chipid);
 	if ((chipid & 0xfff) > 0x2a0)
 		g_sdio.has_thrpt_enh3 = 1;
 	else
 		g_sdio.has_thrpt_enh3 = 0;
-	g_sdio.dPrint(N_ERR, "[wilc sdio]: has_thrpt_enh3 = %d...\n", g_sdio.has_thrpt_enh3);
+	dev_info(&func->dev, "has_thrpt_enh3 = %d...\n", g_sdio.has_thrpt_enh3);
 
 	return 1;
 
@@ -635,7 +661,7 @@ static int sdio_read_size(struct wilc *wilc, u32 *size)
 
 static int sdio_read_int(struct wilc *wilc, u32 *int_status)
 {
-
+	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
 	u32 tmp;
 	sdio_cmd52_t cmd;
 
@@ -666,7 +692,9 @@ static int sdio_read_int(struct wilc *wilc, u32 *int_status)
 			tmp |= INT_5;
 		for (i = g_sdio.nint; i < MAX_NUM_INT; i++) {
 			if ((tmp >> (IRG_FLAGS_OFFSET + i)) & 0x1) {
-				g_sdio.dPrint(N_ERR, "[wilc sdio]: Unexpected interrupt (1) : tmp=%x, data=%x\n", tmp, cmd.data);
+				dev_err(&func->dev,
+					"Unexpected interrupt (1) : tmp=%x, data=%x\n",
+					tmp, cmd.data);
 				break;
 			}
 		}
@@ -690,6 +718,7 @@ static int sdio_read_int(struct wilc *wilc, u32 *int_status)
 
 static int sdio_clear_int_ext(struct wilc *wilc, u32 val)
 {
+	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
 	int ret;
 
 	if (g_sdio.has_thrpt_enh3) {
@@ -723,7 +752,9 @@ static int sdio_clear_int_ext(struct wilc *wilc, u32 val)
 
 			ret = wilc_sdio_cmd52(wilc, &cmd);
 			if (!ret) {
-				g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0xf8 data (%d) ...\n", __LINE__);
+				dev_err(&func->dev,
+					"Failed cmd52, set 0xf8 data (%d) ...\n",
+					__LINE__);
 				goto _fail_;
 			}
 
@@ -751,7 +782,9 @@ static int sdio_clear_int_ext(struct wilc *wilc, u32 val)
 
 						ret = wilc_sdio_cmd52(wilc, &cmd);
 						if (!ret) {
-							g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0xf8 data (%d) ...\n", __LINE__);
+							dev_err(&func->dev,
+								"Failed cmd52, set 0xf8 data (%d) ...\n",
+								__LINE__);
 							goto _fail_;
 						}
 
@@ -764,7 +797,9 @@ static int sdio_clear_int_ext(struct wilc *wilc, u32 val)
 					goto _fail_;
 				for (i = g_sdio.nint; i < MAX_NUM_INT; i++) {
 					if (flags & 1)
-						g_sdio.dPrint(N_ERR, "[wilc sdio]: Unexpected interrupt cleared %d...\n", i);
+						dev_err(&func->dev,
+							"Unexpected interrupt cleared %d...\n",
+							i);
 					flags >>= 1;
 				}
 			}
@@ -794,7 +829,9 @@ static int sdio_clear_int_ext(struct wilc *wilc, u32 val)
 				cmd.data = vmm_ctl;
 				ret = wilc_sdio_cmd52(wilc, &cmd);
 				if (!ret) {
-					g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0xf6 data (%d) ...\n", __LINE__);
+					dev_err(&func->dev,
+						"Failed cmd52, set 0xf6 data (%d) ...\n",
+						__LINE__);
 					goto _fail_;
 				}
 			}
@@ -808,14 +845,16 @@ _fail_:
 
 static int sdio_sync_ext(struct wilc *wilc, int nint)
 {
+	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
 	u32 reg;
 
 	if (nint > MAX_NUM_INT) {
-		g_sdio.dPrint(N_ERR, "[wilc sdio]: Too many interupts (%d)...\n", nint);
+		dev_err(&func->dev, "Too many interupts (%d)...\n", nint);
 		return 0;
 	}
 	if (nint > MAX_NUN_INT_THRPT_ENH2) {
-		g_sdio.dPrint(N_ERR, "[wilc sdio]: Error: Cannot support more than 5 interrupts when has_thrpt_enh2=1.\n");
+		dev_err(&func->dev,
+			"Cannot support more than 5 interrupts when has_thrpt_enh2=1.\n");
 		return 0;
 	}
 
@@ -825,13 +864,13 @@ static int sdio_sync_ext(struct wilc *wilc, int nint)
 	 *      Disable power sequencer
 	 **/
 	if (!sdio_read_reg(wilc, WILC_MISC, &reg)) {
-		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed read misc reg...\n");
+		dev_err(&func->dev, "Failed read misc reg...\n");
 		return 0;
 	}
 
 	reg &= ~BIT(8);
 	if (!sdio_write_reg(wilc, WILC_MISC, reg)) {
-		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed write misc reg...\n");
+		dev_err(&func->dev, "Failed write misc reg...\n");
 		return 0;
 	}
 
@@ -844,13 +883,15 @@ static int sdio_sync_ext(struct wilc *wilc, int nint)
 		 **/
 		ret = sdio_read_reg(wilc, WILC_PIN_MUX_0, &reg);
 		if (!ret) {
-			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed read reg (%08x)...\n", WILC_PIN_MUX_0);
+			dev_err(&func->dev, "Failed read reg (%08x)...\n",
+				WILC_PIN_MUX_0);
 			return 0;
 		}
 		reg |= BIT(8);
 		ret = sdio_write_reg(wilc, WILC_PIN_MUX_0, reg);
 		if (!ret) {
-			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed write reg (%08x)...\n", WILC_PIN_MUX_0);
+			dev_err(&func->dev, "Failed write reg (%08x)...\n",
+				WILC_PIN_MUX_0);
 			return 0;
 		}
 
@@ -859,7 +900,8 @@ static int sdio_sync_ext(struct wilc *wilc, int nint)
 		 **/
 		ret = sdio_read_reg(wilc, WILC_INTR_ENABLE, &reg);
 		if (!ret) {
-			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed read reg (%08x)...\n", WILC_INTR_ENABLE);
+			dev_err(&func->dev, "Failed read reg (%08x)...\n",
+				WILC_INTR_ENABLE);
 			return 0;
 		}
 
@@ -867,13 +909,16 @@ static int sdio_sync_ext(struct wilc *wilc, int nint)
 			reg |= BIT((27 + i));
 		ret = sdio_write_reg(wilc, WILC_INTR_ENABLE, reg);
 		if (!ret) {
-			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed write reg (%08x)...\n", WILC_INTR_ENABLE);
+			dev_err(&func->dev, "Failed write reg (%08x)...\n",
+				WILC_INTR_ENABLE);
 			return 0;
 		}
 		if (nint) {
 			ret = sdio_read_reg(wilc, WILC_INTR2_ENABLE, &reg);
 			if (!ret) {
-				g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed read reg (%08x)...\n", WILC_INTR2_ENABLE);
+				dev_err(&func->dev,
+					"Failed read reg (%08x)...\n",
+					WILC_INTR2_ENABLE);
 				return 0;
 			}
 
@@ -882,7 +927,9 @@ static int sdio_sync_ext(struct wilc *wilc, int nint)
 
 			ret = sdio_read_reg(wilc, WILC_INTR2_ENABLE, &reg);
 			if (!ret) {
-				g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed write reg (%08x)...\n", WILC_INTR2_ENABLE);
+				dev_err(&func->dev,
+					"Failed write reg (%08x)...\n",
+					WILC_INTR2_ENABLE);
 				return 0;
 			}
 		}
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 20e2532..2d51748 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -14,7 +14,6 @@
 #include "wilc_wfi_netdevice.h"
 
 typedef struct {
-	wilc_debug_func dPrint;
 	int crc_off;
 	int nint;
 	int has_thrpt_enh;
@@ -111,6 +110,7 @@ static u8 crc7(u8 crc, const u8 *buffer, u32 len)
 static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 			    u8 clockless)
 {
+	struct spi_device *spi = to_spi_device(wilc->dev);
 	u8 wb[32], rb[32];
 	u8 wix, rix;
 	u32 len2;
@@ -239,7 +239,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 #undef NUM_DUMMY_BYTES
 
 	if (len2 > ARRAY_SIZE(wb)) {
-		PRINT_ER("[wilc spi]: spi buffer size too small (%d) (%zu)\n",
+		dev_err(&spi->dev, "spi buffer size too small (%d) (%zu)\n",
 			 len2, ARRAY_SIZE(wb));
 		result = N_FAIL;
 		return result;
@@ -251,7 +251,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 	rix = len;
 
 	if (!wilc_spi_write_read(wilc, wb, rb, len2)) {
-		PRINT_ER("[wilc spi]: Failed cmd write, bus error...\n");
+		dev_err(&spi->dev, "Failed cmd write, bus error...\n");
 		result = N_FAIL;
 		return result;
 	}
@@ -271,7 +271,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 	/* } while(&rptr[1] <= &rb[len2]); */
 
 	if (rsp != cmd) {
-		PRINT_ER("[wilc spi]: Failed cmd response, cmd (%02x)"
+		dev_err(&spi->dev, "Failed cmd response, cmd (%02x)"
 			 ", resp (%02x)\n", cmd, rsp);
 		result = N_FAIL;
 		return result;
@@ -282,8 +282,8 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 	 **/
 	rsp = rb[rix++];
 	if (rsp != 0x00) {
-		PRINT_ER("[wilc spi]: Failed cmd state response "
-			 "state (%02x)\n", rsp);
+		dev_err(&spi->dev, "Failed cmd state response state (%02x)\n",
+			rsp);
 		result = N_FAIL;
 		return result;
 	}
@@ -310,8 +310,8 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 		} while (retry--);
 
 		if (retry <= 0) {
-			PRINT_ER("[wilc spi]: Error, data read "
-				 "response (%02x)\n", rsp);
+			dev_err(&spi->dev,
+				"Error, data read response (%02x)\n", rsp);
 			result = N_RESET;
 			return result;
 		}
@@ -326,7 +326,8 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 				b[2] = rb[rix++];
 				b[3] = rb[rix++];
 			} else {
-				PRINT_ER("[wilc spi]: buffer overrun when reading data.\n");
+				dev_err(&spi->dev,
+					"buffer overrun when reading data.\n");
 				result = N_FAIL;
 				return result;
 			}
@@ -339,7 +340,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 					crc[0] = rb[rix++];
 					crc[1] = rb[rix++];
 				} else {
-					PRINT_ER("[wilc spi]: buffer overrun when reading crc.\n");
+					dev_err(&spi->dev,"buffer overrun when reading crc.\n");
 					result = N_FAIL;
 					return result;
 				}
@@ -366,7 +367,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 				 * Read bytes
 				 **/
 				if (!wilc_spi_read(wilc, &b[ix], nbytes)) {
-					PRINT_ER("[wilc spi]: Failed data block read, bus error...\n");
+					dev_err(&spi->dev, "Failed data block read, bus error...\n");
 					result = N_FAIL;
 					goto _error_;
 				}
@@ -376,7 +377,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 				 **/
 				if (!g_spi.crc_off) {
 					if (!wilc_spi_read(wilc, crc, 2)) {
-						PRINT_ER("[wilc spi]: Failed data block crc read, bus error...\n");
+						dev_err(&spi->dev, "Failed data block crc read, bus error...\n");
 						result = N_FAIL;
 						goto _error_;
 					}
@@ -407,7 +408,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 				retry = 10;
 				do {
 					if (!wilc_spi_read(wilc, &rsp, 1)) {
-						PRINT_ER("[wilc spi]: Failed data response read, bus error...\n");
+						dev_err(&spi->dev, "Failed data response read, bus error...\n");
 						result = N_FAIL;
 						break;
 					}
@@ -423,7 +424,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 				 * Read bytes
 				 **/
 				if (!wilc_spi_read(wilc, &b[ix], nbytes)) {
-					PRINT_ER("[wilc spi]: Failed data block read, bus error...\n");
+					dev_err(&spi->dev, "Failed data block read, bus error...\n");
 					result = N_FAIL;
 					break;
 				}
@@ -433,7 +434,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 				 **/
 				if (!g_spi.crc_off) {
 					if (!wilc_spi_read(wilc, crc, 2)) {
-						PRINT_ER("[wilc spi]: Failed data block crc read, bus error...\n");
+						dev_err(&spi->dev, "Failed data block crc read, bus error...\n");
 						result = N_FAIL;
 						break;
 					}
@@ -450,6 +451,7 @@ _error_:
 
 static int spi_data_write(struct wilc *wilc, u8 *b, u32 sz)
 {
+	struct spi_device *spi = to_spi_device(wilc->dev);
 	int ix, nbytes;
 	int result = 1;
 	u8 cmd, order, crc[2] = {0};
@@ -483,7 +485,8 @@ static int spi_data_write(struct wilc *wilc, u8 *b, u32 sz)
 		}
 		cmd |= order;
 		if (!wilc_spi_write(wilc, &cmd, 1)) {
-			PRINT_ER("[wilc spi]: Failed data block cmd write, bus error...\n");
+			dev_err(&spi->dev,
+				"Failed data block cmd write, bus error...\n");
 			result = N_FAIL;
 			break;
 		}
@@ -492,7 +495,8 @@ static int spi_data_write(struct wilc *wilc, u8 *b, u32 sz)
 		 *      Write data
 		 **/
 		if (!wilc_spi_write(wilc, &b[ix], nbytes)) {
-			PRINT_ER("[wilc spi]: Failed data block write, bus error...\n");
+			dev_err(&spi->dev,
+				"Failed data block write, bus error...\n");
 			result = N_FAIL;
 			break;
 		}
@@ -502,7 +506,7 @@ static int spi_data_write(struct wilc *wilc, u8 *b, u32 sz)
 		 **/
 		if (!g_spi.crc_off) {
 			if (!wilc_spi_write(wilc, crc, 2)) {
-				PRINT_ER("[wilc spi]: Failed data block crc write, bus error...\n");
+				dev_err(&spi->dev,"Failed data block crc write, bus error...\n");
 				result = N_FAIL;
 				break;
 			}
@@ -527,13 +531,14 @@ static int spi_data_write(struct wilc *wilc, u8 *b, u32 sz)
 
 static int spi_internal_write(struct wilc *wilc, u32 adr, u32 dat)
 {
+	struct spi_device *spi = to_spi_device(wilc->dev);
 	int result;
 
 	dat = cpu_to_le32(dat);
 	result = spi_cmd_complete(wilc, CMD_INTERNAL_WRITE, adr, (u8 *)&dat, 4,
 				  0);
 	if (result != N_OK) {
-		PRINT_ER("[wilc spi]: Failed internal write cmd...\n");
+		dev_err(&spi->dev, "Failed internal write cmd...\n");
 	}
 
 	return result;
@@ -541,12 +546,13 @@ static int spi_internal_write(struct wilc *wilc, u32 adr, u32 dat)
 
 static int spi_internal_read(struct wilc *wilc, u32 adr, u32 *data)
 {
+	struct spi_device *spi = to_spi_device(wilc->dev);
 	int result;
 
 	result = spi_cmd_complete(wilc, CMD_INTERNAL_READ, adr, (u8 *)data, 4,
 				  0);
 	if (result != N_OK) {
-		PRINT_ER("[wilc spi]: Failed internal read cmd...\n");
+		dev_err(&spi->dev, "Failed internal read cmd...\n");
 		return 0;
 	}
 
@@ -563,6 +569,7 @@ static int spi_internal_read(struct wilc *wilc, u32 adr, u32 *data)
 
 static int wilc_spi_write_reg(struct wilc *wilc, u32 addr, u32 data)
 {
+	struct spi_device *spi = to_spi_device(wilc->dev);
 	int result = N_OK;
 	u8 cmd = CMD_SINGLE_WRITE;
 	u8 clockless = 0;
@@ -576,7 +583,7 @@ static int wilc_spi_write_reg(struct wilc *wilc, u32 addr, u32 data)
 
 	result = spi_cmd_complete(wilc, cmd, addr, (u8 *)&data, 4, clockless);
 	if (result != N_OK) {
-		PRINT_ER("[wilc spi]: Failed cmd, write reg (%08x)...\n", addr);
+		dev_err(&spi->dev, "Failed cmd, write reg (%08x)...\n", addr);
 	}
 
 	return result;
@@ -584,6 +591,7 @@ static int wilc_spi_write_reg(struct wilc *wilc, u32 addr, u32 data)
 
 static int _wilc_spi_write(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 {
+	struct spi_device *spi = to_spi_device(wilc->dev);
 	int result;
 	u8 cmd = CMD_DMA_EXT_WRITE;
 
@@ -595,7 +603,8 @@ static int _wilc_spi_write(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 
 	result = spi_cmd_complete(wilc, cmd, addr, NULL, size, 0);
 	if (result != N_OK) {
-		PRINT_ER("[wilc spi]: Failed cmd, write block (%08x)...\n", addr);
+		dev_err(&spi->dev,
+			"Failed cmd, write block (%08x)...\n", addr);
 		return 0;
 	}
 
@@ -604,7 +613,7 @@ static int _wilc_spi_write(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 	 **/
 	result = spi_data_write(wilc, buf, size);
 	if (result != N_OK) {
-		PRINT_ER("[wilc spi]: Failed block data write...\n");
+		dev_err(&spi->dev, "Failed block data write...\n");
 	}
 
 	return 1;
@@ -612,12 +621,13 @@ static int _wilc_spi_write(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 
 static int wilc_spi_read_reg(struct wilc *wilc, u32 addr, u32 *data)
 {
+	struct spi_device *spi = to_spi_device(wilc->dev);
 	int result = N_OK;
 	u8 cmd = CMD_SINGLE_READ;
 	u8 clockless = 0;
 
 	if (addr < 0x30) {
-		/* PRINT_ER("***** read addr %d\n\n", addr); */
+		/* dev_err(&spi->dev, "***** read addr %d\n\n", addr); */
 		/* Clockless register*/
 		cmd = CMD_INTERNAL_READ;
 		clockless = 1;
@@ -625,7 +635,7 @@ static int wilc_spi_read_reg(struct wilc *wilc, u32 addr, u32 *data)
 
 	result = spi_cmd_complete(wilc, cmd, addr, (u8 *)data, 4, clockless);
 	if (result != N_OK) {
-		PRINT_ER("[wilc spi]: Failed cmd, read reg (%08x)...\n", addr);
+		dev_err(&spi->dev, "Failed cmd, read reg (%08x)...\n", addr);
 		return 0;
 	}
 
@@ -636,6 +646,7 @@ static int wilc_spi_read_reg(struct wilc *wilc, u32 addr, u32 *data)
 
 static int _wilc_spi_read(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 {
+	struct spi_device *spi = to_spi_device(wilc->dev);
 	u8 cmd = CMD_DMA_EXT_READ;
 	int result;
 
@@ -644,7 +655,7 @@ static int _wilc_spi_read(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 
 	result = spi_cmd_complete(wilc, cmd, addr, buf, size, 0);
 	if (result != N_OK) {
-		PRINT_ER("[wilc spi]: Failed cmd, read block (%08x)...\n", addr);
+		dev_err(&spi->dev, "Failed cmd, read block (%08x)...\n", addr);
 		return 0;
 	}
 
@@ -659,10 +670,12 @@ static int _wilc_spi_read(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 
 static int wilc_spi_clear_int(struct wilc *wilc)
 {
+	struct spi_device *spi = to_spi_device(wilc->dev);
 	u32 reg;
 
 	if (!wilc_spi_read_reg(wilc, WILC_HOST_RX_CTRL_0, &reg)) {
-		PRINT_ER("[wilc spi]: Failed read reg (%08x)...\n", WILC_HOST_RX_CTRL_0);
+		dev_err(&spi->dev, "Failed read reg (%08x)...\n",
+			WILC_HOST_RX_CTRL_0);
 		return 0;
 	}
 	reg &= ~0x1;
@@ -680,6 +693,7 @@ static int _wilc_spi_deinit(struct wilc *wilc)
 
 static int wilc_spi_sync(struct wilc *wilc)
 {
+	struct spi_device *spi = to_spi_device(wilc->dev);
 	u32 reg;
 	int ret;
 
@@ -688,13 +702,15 @@ static int wilc_spi_sync(struct wilc *wilc)
 	 **/
 	ret = wilc_spi_read_reg(wilc, WILC_PIN_MUX_0, &reg);
 	if (!ret) {
-		PRINT_ER("[wilc spi]: Failed read reg (%08x)...\n", WILC_PIN_MUX_0);
+		dev_err(&spi->dev,"Failed read reg (%08x)...\n",
+			WILC_PIN_MUX_0);
 		return 0;
 	}
 	reg |= BIT(8);
 	ret = wilc_spi_write_reg(wilc, WILC_PIN_MUX_0, reg);
 	if (!ret) {
-		PRINT_ER("[wilc spi]: Failed write reg (%08x)...\n", WILC_PIN_MUX_0);
+		dev_err(&spi->dev, "Failed write reg (%08x)...\n",
+			WILC_PIN_MUX_0);
 		return 0;
 	}
 
@@ -703,13 +719,15 @@ static int wilc_spi_sync(struct wilc *wilc)
 	 **/
 	ret = wilc_spi_read_reg(wilc, WILC_INTR_ENABLE, &reg);
 	if (!ret) {
-		PRINT_ER("[wilc spi]: Failed read reg (%08x)...\n", WILC_INTR_ENABLE);
+		dev_err(&spi->dev, "Failed read reg (%08x)...\n",
+			WILC_INTR_ENABLE);
 		return 0;
 	}
 	reg |= BIT(16);
 	ret = wilc_spi_write_reg(wilc, WILC_INTR_ENABLE, reg);
 	if (!ret) {
-		PRINT_ER("[wilc spi]: Failed write reg (%08x)...\n", WILC_INTR_ENABLE);
+		dev_err(&spi->dev, "Failed write reg (%08x)...\n",
+			WILC_INTR_ENABLE);
 		return 0;
 	}
 
@@ -718,6 +736,7 @@ static int wilc_spi_sync(struct wilc *wilc)
 
 static int _wilc_spi_init(struct wilc *wilc, wilc_debug_func func)
 {
+	struct spi_device *spi = to_spi_device(wilc->dev);
 	u32 reg;
 	u32 chipid;
 
@@ -726,7 +745,7 @@ static int _wilc_spi_init(struct wilc *wilc, wilc_debug_func func)
 	if (isinit) {
 
 		if (!wilc_spi_read_reg(wilc, 0x1000, &chipid)) {
-			PRINT_ER("[wilc spi]: Fail cmd read chip id...\n");
+			dev_err(&spi->dev, "Fail cmd read chip id...\n");
 			return 0;
 		}
 		return 1;
@@ -734,9 +753,8 @@ static int _wilc_spi_init(struct wilc *wilc, wilc_debug_func func)
 
 	memset(&g_spi, 0, sizeof(wilc_spi_t));
 
-	g_spi.dPrint = func;
 	if (!wilc_spi_init()) {
-		PRINT_ER("[wilc spi]: Failed io init bus...\n");
+		dev_err(&spi->dev, "Failed io init bus...\n");
 		return 0;
 	}
 
@@ -751,10 +769,11 @@ static int _wilc_spi_init(struct wilc *wilc, wilc_debug_func func)
 		/* Read failed. Try with CRC off. This might happen when module
 		 * is removed but chip isn't reset*/
 		g_spi.crc_off = 1;
-		PRINT_ER("[wilc spi]: Failed internal read protocol with CRC on, retyring with CRC off...\n");
+		dev_err(&spi->dev, "Failed internal read protocol with CRC on, retyring with CRC off...\n");
 		if (!spi_internal_read(wilc, WILC_SPI_PROTOCOL_OFFSET, &reg)) {
 			/* Reaad failed with both CRC on and off, something went bad */
-			PRINT_ER("[wilc spi]: Failed internal read protocol...\n");
+			dev_err(&spi->dev,
+				"Failed internal read protocol...\n");
 			return 0;
 		}
 	}
@@ -763,7 +782,7 @@ static int _wilc_spi_init(struct wilc *wilc, wilc_debug_func func)
 		reg &= ~0x70;
 		reg |= (0x5 << 4);
 		if (!spi_internal_write(wilc, WILC_SPI_PROTOCOL_OFFSET, reg)) {
-			PRINT_ER("[wilc spi %d]: Failed internal write protocol reg...\n", __LINE__);
+			dev_err(&spi->dev, "[wilc spi %d]: Failed internal write protocol reg...\n", __LINE__);
 			return 0;
 		}
 		g_spi.crc_off = 1;
@@ -774,10 +793,10 @@ static int _wilc_spi_init(struct wilc *wilc, wilc_debug_func func)
 	 *      make sure can read back chip id correctly
 	 **/
 	if (!wilc_spi_read_reg(wilc, 0x1000, &chipid)) {
-		PRINT_ER("[wilc spi]: Fail cmd read chip id...\n");
+		dev_err(&spi->dev, "Fail cmd read chip id...\n");
 		return 0;
 	}
-	/* PRINT_ER("[wilc spi]: chipid (%08x)\n", chipid); */
+	/* dev_err(&spi->dev, "chipid (%08x)\n", chipid); */
 
 	g_spi.has_thrpt_enh = 1;
 
@@ -788,6 +807,7 @@ static int _wilc_spi_init(struct wilc *wilc, wilc_debug_func func)
 
 static int wilc_spi_read_size(struct wilc *wilc, u32 *size)
 {
+	struct spi_device *spi = to_spi_device(wilc->dev);
 	int ret;
 
 	if (g_spi.has_thrpt_enh) {
@@ -801,7 +821,8 @@ static int wilc_spi_read_size(struct wilc *wilc, u32 *size)
 		ret = wilc_spi_read_reg(wilc, WILC_VMM_TO_HOST_SIZE,
 					&byte_cnt);
 		if (!ret) {
-			PRINT_ER("[wilc spi]: Failed read WILC_VMM_TO_HOST_SIZE ...\n");
+			dev_err(&spi->dev,
+				"Failed read WILC_VMM_TO_HOST_SIZE ...\n");
 			goto _fail_;
 		}
 		tmp = (byte_cnt >> 2) & IRQ_DMA_WD_CNT_MASK;
@@ -818,6 +839,7 @@ _fail_:
 
 static int wilc_spi_read_int(struct wilc *wilc, u32 *int_status)
 {
+	struct spi_device *spi = to_spi_device(wilc->dev);
 	int ret;
 
 	if (g_spi.has_thrpt_enh) {
@@ -830,7 +852,8 @@ static int wilc_spi_read_int(struct wilc *wilc, u32 *int_status)
 		ret = wilc_spi_read_reg(wilc, WILC_VMM_TO_HOST_SIZE,
 					&byte_cnt);
 		if (!ret) {
-			PRINT_ER("[wilc spi]: Failed read WILC_VMM_TO_HOST_SIZE ...\n");
+			dev_err(&spi->dev,
+				"Failed read WILC_VMM_TO_HOST_SIZE ...\n");
 			goto _fail_;
 		}
 		tmp = (byte_cnt >> 2) & IRQ_DMA_WD_CNT_MASK;
@@ -859,7 +882,7 @@ static int wilc_spi_read_int(struct wilc *wilc, u32 *int_status)
 					unkmown_mask = ~((1ul << g_spi.nint) - 1);
 
 					if ((tmp >> IRG_FLAGS_OFFSET) & unkmown_mask) {
-						PRINT_ER("[wilc spi]: Unexpected interrupt (2): j=%d, tmp=%x, mask=%x\n", j, tmp, unkmown_mask);
+						dev_err(&spi->dev, "Unexpected interrupt (2): j=%d, tmp=%x, mask=%x\n", j, tmp, unkmown_mask);
 						happended = 1;
 					}
 				}
@@ -877,6 +900,7 @@ _fail_:
 
 static int wilc_spi_clear_int_ext(struct wilc *wilc, u32 val)
 {
+	struct spi_device *spi = to_spi_device(wilc->dev);
 	int ret;
 
 	if (g_spi.has_thrpt_enh) {
@@ -899,12 +923,16 @@ static int wilc_spi_clear_int_ext(struct wilc *wilc, u32 val)
 				flags >>= 1;
 			}
 			if (!ret) {
-				PRINT_ER("[wilc spi]: Failed wilc_spi_write_reg, set reg %x ...\n", 0x10c8 + i * 4);
+				dev_err(&spi->dev,
+					"Failed wilc_spi_write_reg, set reg %x ...\n",
+					0x10c8 + i * 4);
 				goto _fail_;
 			}
 			for (i = g_spi.nint; i < MAX_NUM_INT; i++) {
 				if (flags & 1)
-					PRINT_ER("[wilc spi]: Unexpected interrupt cleared %d...\n", i);
+					dev_err(&spi->dev,
+						"Unexpected interrupt cleared %d...\n",
+						i);
 				flags >>= 1;
 			}
 		}
@@ -923,7 +951,8 @@ static int wilc_spi_clear_int_ext(struct wilc *wilc, u32 val)
 			ret = wilc_spi_write_reg(wilc, WILC_VMM_TBL_CTL,
 						 tbl_ctl);
 			if (!ret) {
-				PRINT_ER("[wilc spi]: fail write reg vmm_tbl_ctl...\n");
+				dev_err(&spi->dev,
+					"fail write reg vmm_tbl_ctl...\n");
 				goto _fail_;
 			}
 
@@ -934,7 +963,7 @@ static int wilc_spi_clear_int_ext(struct wilc *wilc, u32 val)
 				ret = wilc_spi_write_reg(wilc,
 							 WILC_VMM_CORE_CTL, 1);
 				if (!ret) {
-					PRINT_ER("[wilc spi]: fail write reg vmm_core_ctl...\n");
+					dev_err(&spi->dev,"fail write reg vmm_core_ctl...\n");
 					goto _fail_;
 				}
 			}
@@ -946,11 +975,12 @@ _fail_:
 
 static int wilc_spi_sync_ext(struct wilc *wilc, int nint)
 {
+	struct spi_device *spi = to_spi_device(wilc->dev);
 	u32 reg;
 	int ret, i;
 
 	if (nint > MAX_NUM_INT) {
-		PRINT_ER("[wilc spi]: Too many interupts (%d)...\n", nint);
+		dev_err(&spi->dev, "Too many interupts (%d)...\n", nint);
 		return 0;
 	}
 
@@ -961,13 +991,15 @@ static int wilc_spi_sync_ext(struct wilc *wilc, int nint)
 	 **/
 	ret = wilc_spi_read_reg(wilc, WILC_PIN_MUX_0, &reg);
 	if (!ret) {
-		PRINT_ER("[wilc spi]: Failed read reg (%08x)...\n", WILC_PIN_MUX_0);
+		dev_err(&spi->dev, "Failed read reg (%08x)...\n",
+			WILC_PIN_MUX_0);
 		return 0;
 	}
 	reg |= BIT(8);
 	ret = wilc_spi_write_reg(wilc, WILC_PIN_MUX_0, reg);
 	if (!ret) {
-		PRINT_ER("[wilc spi]: Failed write reg (%08x)...\n", WILC_PIN_MUX_0);
+		dev_err(&spi->dev, "Failed write reg (%08x)...\n",
+			WILC_PIN_MUX_0);
 		return 0;
 	}
 
@@ -976,7 +1008,8 @@ static int wilc_spi_sync_ext(struct wilc *wilc, int nint)
 	 **/
 	ret = wilc_spi_read_reg(wilc, WILC_INTR_ENABLE, &reg);
 	if (!ret) {
-		PRINT_ER("[wilc spi]: Failed read reg (%08x)...\n", WILC_INTR_ENABLE);
+		dev_err(&spi->dev, "Failed read reg (%08x)...\n",
+			WILC_INTR_ENABLE);
 		return 0;
 	}
 
@@ -985,13 +1018,15 @@ static int wilc_spi_sync_ext(struct wilc *wilc, int nint)
 	}
 	ret = wilc_spi_write_reg(wilc, WILC_INTR_ENABLE, reg);
 	if (!ret) {
-		PRINT_ER("[wilc spi]: Failed write reg (%08x)...\n", WILC_INTR_ENABLE);
+		dev_err(&spi->dev, "Failed write reg (%08x)...\n",
+			WILC_INTR_ENABLE);
 		return 0;
 	}
 	if (nint) {
 		ret = wilc_spi_read_reg(wilc, WILC_INTR2_ENABLE, &reg);
 		if (!ret) {
-			PRINT_ER("[wilc spi]: Failed read reg (%08x)...\n", WILC_INTR2_ENABLE);
+			dev_err(&spi->dev, "Failed read reg (%08x)...\n",
+				WILC_INTR2_ENABLE);
 			return 0;
 		}
 
@@ -1001,7 +1036,8 @@ static int wilc_spi_sync_ext(struct wilc *wilc, int nint)
 
 		ret = wilc_spi_read_reg(wilc, WILC_INTR2_ENABLE, &reg);
 		if (!ret) {
-			PRINT_ER("[wilc spi]: Failed write reg (%08x)...\n", WILC_INTR2_ENABLE);
+			dev_err(&spi->dev, "Failed write reg (%08x)...\n",
+				WILC_INTR2_ENABLE);
 			return 0;
 		}
 	}
-- 
1.9.1

