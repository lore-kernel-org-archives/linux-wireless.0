Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:33723 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728194AbeISLnH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 07:43:07 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 22/29] staging: wilc1000: avoid use of 'g_spi' static variable
Date: Wed, 19 Sep 2018 11:35:12 +0530
Message-ID: <1537337119-14952-23-git-send-email-ajay.kathat@microchip.com> (sfid-20180919_080650_175575_76CA45BB)
In-Reply-To: <1537337119-14952-1-git-send-email-ajay.kathat@microchip.com>
References: <1537337119-14952-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of using static variable 'g_spi' move it as part of 'wilc'
struct. Also allocating the memory in the probe function and
free is taken care in wilc_netdev_cleanup().

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_spi.c | 58 +++++++++++++++++++++++--------------
 1 file changed, 36 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 5517477..2559cf0 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -14,7 +14,6 @@ struct wilc_spi {
 	int has_thrpt_enh;
 };
 
-static struct wilc_spi g_spi;
 static const struct wilc_hif_func wilc_hif_spi;
 
 /********************************************
@@ -107,6 +106,11 @@ static int wilc_bus_probe(struct spi_device *spi)
 	int ret;
 	struct wilc *wilc;
 	struct gpio_desc *gpio;
+	struct wilc_spi *spi_priv;
+
+	spi_priv = kzalloc(sizeof(*spi_priv), GFP_KERNEL);
+	if (!spi_priv)
+		return -ENOMEM;
 
 	gpio = gpiod_get(&spi->dev, "irq", GPIOD_IN);
 	if (IS_ERR(gpio)) {
@@ -117,11 +121,14 @@ static int wilc_bus_probe(struct spi_device *spi)
 	}
 
 	ret = wilc_netdev_init(&wilc, NULL, HIF_SPI, &wilc_hif_spi);
-	if (ret)
+	if (ret) {
+		kfree(spi_priv);
 		return ret;
+	}
 
 	spi_set_drvdata(spi, wilc);
 	wilc->dev = &spi->dev;
+	wilc->bus_data = spi_priv;
 	wilc->gpio_irq = gpio;
 
 	return 0;
@@ -275,6 +282,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 			    u8 clockless)
 {
 	struct spi_device *spi = to_spi_device(wilc->dev);
+	struct wilc_spi *spi_priv = wilc->bus_data;
 	u8 wb[32], rb[32];
 	u8 wix, rix;
 	u32 len2;
@@ -375,7 +383,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 	if (result != N_OK)
 		return result;
 
-	if (!g_spi.crc_off)
+	if (!spi_priv->crc_off)
 		wb[len - 1] = (crc7(0x7f, (const u8 *)&wb[0], len - 1)) << 1;
 	else
 		len -= 1;
@@ -393,7 +401,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 	} else if (cmd == CMD_INTERNAL_READ || cmd == CMD_SINGLE_READ) {
 		int tmp = NUM_RSP_BYTES + NUM_DATA_HDR_BYTES + NUM_DATA_BYTES
 			+ NUM_DUMMY_BYTES;
-		if (!g_spi.crc_off)
+		if (!spi_priv->crc_off)
 			len2 = len + tmp + NUM_CRC_BYTES;
 		else
 			len2 = len + tmp;
@@ -485,7 +493,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 			return N_FAIL;
 		}
 
-		if (!g_spi.crc_off) {
+		if (!spi_priv->crc_off) {
 			/*
 			 * Read Crc
 			 */
@@ -527,7 +535,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 			/*
 			 * Read Crc
 			 */
-			if (!g_spi.crc_off && wilc_spi_rx(wilc, crc, 2)) {
+			if (!spi_priv->crc_off && wilc_spi_rx(wilc, crc, 2)) {
 				dev_err(&spi->dev,
 					"Failed block crc read, bus err\n");
 				return N_FAIL;
@@ -585,7 +593,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 			/*
 			 * Read Crc
 			 */
-			if (!g_spi.crc_off && wilc_spi_rx(wilc, crc, 2)) {
+			if (!spi_priv->crc_off && wilc_spi_rx(wilc, crc, 2)) {
 				dev_err(&spi->dev,
 					"Failed block crc read, bus err\n");
 				result = N_FAIL;
@@ -602,6 +610,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,
 static int spi_data_write(struct wilc *wilc, u8 *b, u32 sz)
 {
 	struct spi_device *spi = to_spi_device(wilc->dev);
+	struct wilc_spi *spi_priv = wilc->bus_data;
 	int ix, nbytes;
 	int result = 1;
 	u8 cmd, order, crc[2] = {0};
@@ -648,7 +657,7 @@ static int spi_data_write(struct wilc *wilc, u8 *b, u32 sz)
 		/*
 		 * Write Crc
 		 */
-		if (!g_spi.crc_off) {
+		if (!spi_priv->crc_off) {
 			if (wilc_spi_tx(wilc, crc, 2)) {
 				dev_err(&spi->dev, "Failed data block crc write, bus error...\n");
 				result = N_FAIL;
@@ -816,6 +825,7 @@ static int _wilc_spi_deinit(struct wilc *wilc)
 static int wilc_spi_init(struct wilc *wilc, bool resume)
 {
 	struct spi_device *spi = to_spi_device(wilc->dev);
+	struct wilc_spi *spi_priv = wilc->bus_data;
 	u32 reg;
 	u32 chipid;
 	static int isinit;
@@ -828,12 +838,12 @@ static int wilc_spi_init(struct wilc *wilc, bool resume)
 		return 1;
 	}
 
-	memset(&g_spi, 0, sizeof(struct wilc_spi));
+	memset(spi_priv, 0, sizeof(struct wilc_spi));
 
 	/*
 	 * configure protocol
 	 */
-	g_spi.crc_off = 0;
+	spi_priv->crc_off = 0;
 
 	/*
 	 * TODO: We can remove the CRC trials if there is a definite
@@ -845,7 +855,7 @@ static int wilc_spi_init(struct wilc *wilc, bool resume)
 		 * Read failed. Try with CRC off. This might happen when module
 		 * is removed but chip isn't reset
 		 */
-		g_spi.crc_off = 1;
+		spi_priv->crc_off = 1;
 		dev_err(&spi->dev,
 			"Failed read with CRC on, retrying with CRC off\n");
 		if (!spi_internal_read(wilc, WILC_SPI_PROTOCOL_OFFSET, &reg)) {
@@ -857,7 +867,7 @@ static int wilc_spi_init(struct wilc *wilc, bool resume)
 			return 0;
 		}
 	}
-	if (g_spi.crc_off == 0) {
+	if (spi_priv->crc_off == 0) {
 		reg &= ~0xc; /* disable crc checking */
 		reg &= ~0x70;
 		reg |= (0x5 << 4);
@@ -867,7 +877,7 @@ static int wilc_spi_init(struct wilc *wilc, bool resume)
 				__LINE__);
 			return 0;
 		}
-		g_spi.crc_off = 1;
+		spi_priv->crc_off = 1;
 	}
 
 	/*
@@ -878,7 +888,7 @@ static int wilc_spi_init(struct wilc *wilc, bool resume)
 		return 0;
 	}
 
-	g_spi.has_thrpt_enh = 1;
+	spi_priv->has_thrpt_enh = 1;
 
 	isinit = 1;
 
@@ -888,9 +898,10 @@ static int wilc_spi_init(struct wilc *wilc, bool resume)
 static int wilc_spi_read_size(struct wilc *wilc, u32 *size)
 {
 	struct spi_device *spi = to_spi_device(wilc->dev);
+	struct wilc_spi *spi_priv = wilc->bus_data;
 	int ret;
 
-	if (g_spi.has_thrpt_enh) {
+	if (spi_priv->has_thrpt_enh) {
 		ret = spi_internal_read(wilc, 0xe840 - WILC_SPI_REG_BASE,
 					size);
 		*size = *size  & IRQ_DMA_WD_CNT_MASK;
@@ -915,6 +926,7 @@ static int wilc_spi_read_size(struct wilc *wilc, u32 *size)
 static int wilc_spi_read_int(struct wilc *wilc, u32 *int_status)
 {
 	struct spi_device *spi = to_spi_device(wilc->dev);
+	struct wilc_spi *spi_priv = wilc->bus_data;
 	int ret;
 	u32 tmp;
 	u32 byte_cnt;
@@ -923,7 +935,7 @@ static int wilc_spi_read_int(struct wilc *wilc, u32 *int_status)
 	u32 irq_flags;
 	int k = IRG_FLAGS_OFFSET + 5;
 
-	if (g_spi.has_thrpt_enh) {
+	if (spi_priv->has_thrpt_enh) {
 		ret = spi_internal_read(wilc, 0xe840 - WILC_SPI_REG_BASE,
 					int_status);
 		return ret;
@@ -943,12 +955,12 @@ static int wilc_spi_read_int(struct wilc *wilc, u32 *int_status)
 		wilc_spi_read_reg(wilc, 0x1a90, &irq_flags);
 		tmp |= ((irq_flags >> 27) << IRG_FLAGS_OFFSET);
 
-		if (g_spi.nint > 5) {
+		if (spi_priv->nint > 5) {
 			wilc_spi_read_reg(wilc, 0x1a94, &irq_flags);
 			tmp |= (((irq_flags >> 0) & 0x7) << k);
 		}
 
-		unknown_mask = ~((1ul << g_spi.nint) - 1);
+		unknown_mask = ~((1ul << spi_priv->nint) - 1);
 
 		if ((tmp >> IRG_FLAGS_OFFSET) & unknown_mask) {
 			dev_err(&spi->dev,
@@ -968,11 +980,12 @@ static int wilc_spi_read_int(struct wilc *wilc, u32 *int_status)
 static int wilc_spi_clear_int_ext(struct wilc *wilc, u32 val)
 {
 	struct spi_device *spi = to_spi_device(wilc->dev);
+	struct wilc_spi *spi_priv = wilc->bus_data;
 	int ret;
 	u32 flags;
 	u32 tbl_ctl;
 
-	if (g_spi.has_thrpt_enh) {
+	if (spi_priv->has_thrpt_enh) {
 		ret = spi_internal_write(wilc, 0xe844 - WILC_SPI_REG_BASE,
 					 val);
 		return ret;
@@ -983,7 +996,7 @@ static int wilc_spi_clear_int_ext(struct wilc *wilc, u32 val)
 		int i;
 
 		ret = 1;
-		for (i = 0; i < g_spi.nint; i++) {
+		for (i = 0; i < spi_priv->nint; i++) {
 			/*
 			 * No matter what you write 1 or 0,
 			 * it will clear interrupt.
@@ -1001,7 +1014,7 @@ static int wilc_spi_clear_int_ext(struct wilc *wilc, u32 val)
 				0x10c8 + i * 4);
 			return ret;
 		}
-		for (i = g_spi.nint; i < MAX_NUM_INT; i++) {
+		for (i = spi_priv->nint; i < MAX_NUM_INT; i++) {
 			if (flags & 1)
 				dev_err(&spi->dev,
 					"Unexpected interrupt cleared %d...\n",
@@ -1041,6 +1054,7 @@ static int wilc_spi_clear_int_ext(struct wilc *wilc, u32 val)
 static int wilc_spi_sync_ext(struct wilc *wilc, int nint)
 {
 	struct spi_device *spi = to_spi_device(wilc->dev);
+	struct wilc_spi *spi_priv = wilc->bus_data;
 	u32 reg;
 	int ret, i;
 
@@ -1049,7 +1063,7 @@ static int wilc_spi_sync_ext(struct wilc *wilc, int nint)
 		return 0;
 	}
 
-	g_spi.nint = nint;
+	spi_priv->nint = nint;
 
 	/*
 	 * interrupt pin mux select
-- 
2.7.4
