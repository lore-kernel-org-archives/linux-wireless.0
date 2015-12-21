Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:11332 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbbLUFQL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 00:16:11 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 11/46] staging: wilc1000: remove unused functions
Date: Mon, 21 Dec 2015 14:18:15 +0900
Message-ID: <1450675130-17866-12-git-send-email-glen.lee@atmel.com> (sfid-20151221_063107_331487_A7342A4C)
In-Reply-To: <1450675130-17866-1-git-send-email-glen.lee@atmel.com>
References: <1450675130-17866-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unused function pointer hif_sync and hif_clear_int, and
removes it's related functions sdio_clear_int, sdio_sync, wilc_spi_clear_int
and wilc_spi_sync.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_sdio.c | 94 ------------------------------------
 drivers/staging/wilc1000/wilc_spi.c  | 60 -----------------------
 drivers/staging/wilc1000/wilc_wlan.h |  2 -
 3 files changed, 156 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index efa3379..325e274 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -130,37 +130,6 @@ _fail_:
 	return 0;
 }
 
-static int sdio_clear_int(struct wilc *wilc)
-{
-	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
-
-	if (!g_sdio.irq_gpio) {
-		/* u32 sts; */
-		sdio_cmd52_t cmd;
-
-		cmd.read_write = 0;
-		cmd.function = 1;
-		cmd.raw = 0;
-		cmd.address = 0x4;
-		cmd.data = 0;
-		wilc_sdio_cmd52(wilc, &cmd);
-
-		return cmd.data;
-	} else {
-		u32 reg;
-
-		if (!sdio_read_reg(wilc, WILC_HOST_RX_CTRL_0, &reg)) {
-			dev_err(&func->dev, "Failed read reg (%08x)...\n",
-				WILC_HOST_RX_CTRL_0);
-			return 0;
-		}
-		reg &= ~0x1;
-		sdio_write_reg(wilc, WILC_HOST_RX_CTRL_0, reg);
-		return 1;
-	}
-
-}
-
 /********************************************
  *
  *      Sdio interfaces
@@ -451,67 +420,6 @@ static int sdio_deinit(struct wilc *wilc)
 	return 1;
 }
 
-static int sdio_sync(struct wilc *wilc)
-{
-	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
-	u32 reg;
-
-	/**
-	 *      Disable power sequencer
-	 **/
-	if (!sdio_read_reg(wilc, WILC_MISC, &reg)) {
-		dev_err(&func->dev, "Failed read misc reg...\n");
-		return 0;
-	}
-
-	reg &= ~BIT(8);
-	if (!sdio_write_reg(wilc, WILC_MISC, reg)) {
-		dev_err(&func->dev, "Failed write misc reg...\n");
-		return 0;
-	}
-
-	if (g_sdio.irq_gpio) {
-		u32 reg;
-		int ret;
-
-		/**
-		 *      interrupt pin mux select
-		 **/
-		ret = sdio_read_reg(wilc, WILC_PIN_MUX_0, &reg);
-		if (!ret) {
-			dev_err(&func->dev, "Failed read reg (%08x)...\n",
-				WILC_PIN_MUX_0);
-			return 0;
-		}
-		reg |= BIT(8);
-		ret = sdio_write_reg(wilc, WILC_PIN_MUX_0, reg);
-		if (!ret) {
-			dev_err(&func->dev, "Failed write reg (%08x)...\n",
-				WILC_PIN_MUX_0);
-			return 0;
-		}
-
-		/**
-		 *      interrupt enable
-		 **/
-		ret = sdio_read_reg(wilc, WILC_INTR_ENABLE, &reg);
-		if (!ret) {
-			dev_err(&func->dev, "Failed read reg (%08x)...\n",
-				WILC_INTR_ENABLE);
-			return 0;
-		}
-		reg |= BIT(16);
-		ret = sdio_write_reg(wilc, WILC_INTR_ENABLE, reg);
-		if (!ret) {
-			dev_err(&func->dev, "Failed write reg (%08x)...\n",
-				WILC_INTR_ENABLE);
-			return 0;
-		}
-	}
-
-	return 1;
-}
-
 static int sdio_init(struct wilc *wilc)
 {
 	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
@@ -952,8 +860,6 @@ const struct wilc_hif_func wilc_hif_sdio = {
 	.hif_write_reg = sdio_write_reg,
 	.hif_block_rx = sdio_read,
 	.hif_block_tx = sdio_write,
-	.hif_sync = sdio_sync,
-	.hif_clear_int = sdio_clear_int,
 	.hif_read_int = sdio_read_int,
 	.hif_clear_int_ext = sdio_clear_int_ext,
 	.hif_read_size = sdio_read_size,
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 478a356..faaeaf7 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -668,21 +668,6 @@ static int _wilc_spi_read(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
  *
  ********************************************/
 
-static int wilc_spi_clear_int(struct wilc *wilc)
-{
-	struct spi_device *spi = to_spi_device(wilc->dev);
-	u32 reg;
-
-	if (!wilc_spi_read_reg(wilc, WILC_HOST_RX_CTRL_0, &reg)) {
-		dev_err(&spi->dev, "Failed read reg (%08x)...\n",
-			WILC_HOST_RX_CTRL_0);
-		return 0;
-	}
-	reg &= ~0x1;
-	wilc_spi_write_reg(wilc, WILC_HOST_RX_CTRL_0, reg);
-	return 1;
-}
-
 static int _wilc_spi_deinit(struct wilc *wilc)
 {
 	/**
@@ -691,49 +676,6 @@ static int _wilc_spi_deinit(struct wilc *wilc)
 	return 1;
 }
 
-static int wilc_spi_sync(struct wilc *wilc)
-{
-	struct spi_device *spi = to_spi_device(wilc->dev);
-	u32 reg;
-	int ret;
-
-	/**
-	 *      interrupt pin mux select
-	 **/
-	ret = wilc_spi_read_reg(wilc, WILC_PIN_MUX_0, &reg);
-	if (!ret) {
-		dev_err(&spi->dev,"Failed read reg (%08x)...\n",
-			WILC_PIN_MUX_0);
-		return 0;
-	}
-	reg |= BIT(8);
-	ret = wilc_spi_write_reg(wilc, WILC_PIN_MUX_0, reg);
-	if (!ret) {
-		dev_err(&spi->dev, "Failed write reg (%08x)...\n",
-			WILC_PIN_MUX_0);
-		return 0;
-	}
-
-	/**
-	 *      interrupt enable
-	 **/
-	ret = wilc_spi_read_reg(wilc, WILC_INTR_ENABLE, &reg);
-	if (!ret) {
-		dev_err(&spi->dev, "Failed read reg (%08x)...\n",
-			WILC_INTR_ENABLE);
-		return 0;
-	}
-	reg |= BIT(16);
-	ret = wilc_spi_write_reg(wilc, WILC_INTR_ENABLE, reg);
-	if (!ret) {
-		dev_err(&spi->dev, "Failed write reg (%08x)...\n",
-			WILC_INTR_ENABLE);
-		return 0;
-	}
-
-	return 1;
-}
-
 static int _wilc_spi_init(struct wilc *wilc)
 {
 	struct spi_device *spi = to_spi_device(wilc->dev);
@@ -1058,8 +1000,6 @@ const struct wilc_hif_func wilc_hif_spi = {
 	.hif_write_reg = wilc_spi_write_reg,
 	.hif_block_rx = _wilc_spi_read,
 	.hif_block_tx = _wilc_spi_write,
-	.hif_sync = wilc_spi_sync,
-	.hif_clear_int = wilc_spi_clear_int,
 	.hif_read_int = wilc_spi_read_int,
 	.hif_clear_int_ext = wilc_spi_clear_int_ext,
 	.hif_read_size = wilc_spi_read_size,
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 580e1d6..2edd744 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -232,8 +232,6 @@ struct wilc_hif_func {
 	int (*hif_write_reg)(struct wilc *, u32, u32);
 	int (*hif_block_rx)(struct wilc *, u32, u8 *, u32);
 	int (*hif_block_tx)(struct wilc *, u32, u8 *, u32);
-	int (*hif_sync)(struct wilc *);
-	int (*hif_clear_int)(struct wilc *);
 	int (*hif_read_int)(struct wilc *, u32 *);
 	int (*hif_clear_int_ext)(struct wilc *, u32);
 	int (*hif_read_size)(struct wilc *, u32 *);
-- 
1.9.1

