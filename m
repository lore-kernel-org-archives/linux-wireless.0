Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:54348 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799AbZGCTBO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jul 2009 15:01:14 -0400
From: Christian Lamparter <chunkeey@web.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH] p54: two endian fixes
Date: Fri, 3 Jul 2009 21:01:15 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Max Filippov <jcmvbkbc@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <200907032101.15855.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes all CHECK_ENDIAN complains:

1. p54/fwio.c:296:6: warning: restricted __le32 degrades to integer
    p54/fwio.c:296:6: warning: restricted __le32 degrades to integer

2. p54/p54spi.c:172:32: warning: incorrect type in initializer
   p54spi.c:172:32:    expected restricted __le32 [usertype] buffer
   p54/p54spi.c:172:32:    got unsigned int

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
Max,

drivers/net/wireless/p54/p54spi.c:115: warning: ‘p54spi_read16’ defined but not used

looks like this function can be nuked, or do you have plans with it?
---
diff --git a/drivers/net/wireless/p54/fwio.c b/drivers/net/wireless/p54/fwio.c
index 9bff43d..349375f 100644
--- a/drivers/net/wireless/p54/fwio.c
+++ b/drivers/net/wireless/p54/fwio.c
@@ -292,8 +292,9 @@ int p54_tx_cancel(struct p54_common *priv, __le32 req_id)
 {
 	struct sk_buff *skb;
 	struct p54_txcancel *cancel;
+	u32 _req_id = le32_to_cpu(req_id);
 
-	if (unlikely(req_id < priv->rx_start || req_id > priv->rx_end))
+	if (unlikely(_req_id < priv->rx_start || _req_id > priv->rx_end))
 		return -EINVAL;
 
 	skb = p54_alloc_skb(priv, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*cancel),
diff --git a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
index 7ef191a..9b347ce 100644
--- a/drivers/net/wireless/p54/p54spi.c
+++ b/drivers/net/wireless/p54/p54spi.c
@@ -164,12 +164,12 @@ static const struct p54spi_spi_reg p54spi_registers_array[] =
 	{ SPI_ADRS_DMA_WRITE_BASE,	32, "DMA_RD_BASE " }
 };
 
-static int p54spi_wait_bit(struct p54s_priv *priv, u16 reg, __le32 bits)
+static int p54spi_wait_bit(struct p54s_priv *priv, u16 reg, u32 bits)
 {
 	int i;
 
 	for (i = 0; i < 2000; i++) {
-		__le32 buffer = p54spi_read32(priv, reg);
+		u32 buffer = p54spi_read32(priv, reg);
 		if ((buffer & bits) == bits)
 			return 1;
 	}
@@ -179,8 +179,7 @@ static int p54spi_wait_bit(struct p54s_priv *priv, u16 reg, __le32 bits)
 static int p54spi_spi_write_dma(struct p54s_priv *priv, __le32 base,
 				const void *buf, size_t len)
 {
-	if (!p54spi_wait_bit(priv, SPI_ADRS_DMA_WRITE_CTRL,
-			     cpu_to_le32(HOST_ALLOWED))) {
+	if (!p54spi_wait_bit(priv, SPI_ADRS_DMA_WRITE_CTRL, HOST_ALLOWED)) {
 		dev_err(&priv->spi->dev, "spi_write_dma not allowed "
 			"to DMA write.\n");
 		return -EAGAIN;
@@ -333,7 +332,7 @@ static int p54spi_wakeup(struct p54s_priv *priv)
 
 	/* And wait for the READY interrupt */
 	if (!p54spi_wait_bit(priv, SPI_ADRS_HOST_INTERRUPTS,
-			     cpu_to_le32(SPI_HOST_INT_READY))) {
+			     SPI_HOST_INT_READY)) {
 		dev_err(&priv->spi->dev, "INT_READY timeout\n");
 		return -EBUSY;
 	}
@@ -444,7 +443,7 @@ static int p54spi_tx_frame(struct p54s_priv *priv, struct sk_buff *skb)
 		goto out;
 
 	if (!p54spi_wait_bit(priv, SPI_ADRS_HOST_INTERRUPTS,
-			     cpu_to_le32(SPI_HOST_INT_WR_READY))) {
+			     SPI_HOST_INT_WR_READY)) {
 		dev_err(&priv->spi->dev, "WR_READY timeout\n");
 		ret = -EAGAIN;
 		goto out;
