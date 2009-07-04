Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:56438 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbZGDPt4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jul 2009 11:49:56 -0400
From: Christian Lamparter <chunkeey@web.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH] p54spi: remove dead code and definitions
Date: Sat, 4 Jul 2009 17:49:59 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Max Filippov <jcmvbkbc@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <200907041749.59388.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes some dead code: 
p54spi.c:115: warning: ‘p54spi_read16’ defined but not used

and while we're at it, p54spi_registers_array is purged as well.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
index 9b347ce..d5f181a 100644
--- a/drivers/net/wireless/p54/p54spi.c
+++ b/drivers/net/wireless/p54/p54spi.c
@@ -111,15 +111,6 @@ static void p54spi_spi_write(struct p54s_priv *priv, u8 address,
 	spi_sync(priv->spi, &m);
 }
 
-static u16 p54spi_read16(struct p54s_priv *priv, u8 addr)
-{
-	__le16 val;
-
-	p54spi_spi_read(priv, addr, &val, sizeof(val));
-
-	return le16_to_cpu(val);
-}
-
 static u32 p54spi_read32(struct p54s_priv *priv, u8 addr)
 {
 	__le32 val;
@@ -139,31 +130,6 @@ static inline void p54spi_write32(struct p54s_priv *priv, u8 addr, __le32 val)
 	p54spi_spi_write(priv, addr, &val, sizeof(val));
 }
 
-struct p54spi_spi_reg {
-	u16 address;		/* __le16 ? */
-	u16 length;
-	char *name;
-};
-
-static const struct p54spi_spi_reg p54spi_registers_array[] =
-{
-	{ SPI_ADRS_ARM_INTERRUPTS,	32, "ARM_INT     " },
-	{ SPI_ADRS_ARM_INT_EN,		32, "ARM_INT_ENA " },
-	{ SPI_ADRS_HOST_INTERRUPTS,	32, "HOST_INT    " },
-	{ SPI_ADRS_HOST_INT_EN,		32, "HOST_INT_ENA" },
-	{ SPI_ADRS_HOST_INT_ACK,	32, "HOST_INT_ACK" },
-	{ SPI_ADRS_GEN_PURP_1,		32, "GP1_COMM    " },
-	{ SPI_ADRS_GEN_PURP_2,		32, "GP2_COMM    " },
-	{ SPI_ADRS_DEV_CTRL_STAT,	32, "DEV_CTRL_STA" },
-	{ SPI_ADRS_DMA_DATA,		16, "DMA_DATA    " },
-	{ SPI_ADRS_DMA_WRITE_CTRL,	16, "DMA_WR_CTRL " },
-	{ SPI_ADRS_DMA_WRITE_LEN,	16, "DMA_WR_LEN  " },
-	{ SPI_ADRS_DMA_WRITE_BASE,	32, "DMA_WR_BASE " },
-	{ SPI_ADRS_DMA_READ_CTRL,	16, "DMA_RD_CTRL " },
-	{ SPI_ADRS_DMA_READ_LEN,	16, "DMA_RD_LEN  " },
-	{ SPI_ADRS_DMA_WRITE_BASE,	32, "DMA_RD_BASE " }
-};
-
 static int p54spi_wait_bit(struct p54s_priv *priv, u16 reg, u32 bits)
 {
 	int i;
