Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:39368 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476AbZCZDqT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 23:46:19 -0400
Received: by bwz17 with SMTP id 17so344569bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 25 Mar 2009 20:46:16 -0700 (PDT)
From: Max Filippov <jcmvbkbc@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Christian Lamparter <chunkeey@web.de>,
	Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH] p54spi: fix p54spi_tx_frame DMA transfer initiation and skb cleanup
Date: Thu, 26 Mar 2009 06:38:25 +0300
Message-Id: <1238038705-4742-1-git-send-email-jcmvbkbc@gmail.com> (sfid-20090326_044622_468617_D7EBD377)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

p54spi_tx_frame wasn't waiting for HOST_ALLOWED in SPI_ADRS_DMA_WRITE_CTRL.
This resulted in frequent 'WR_READY timeout' on beacon resubmission.

Also don't free skb on error path, as it gets freed on p54spi_wq_tx.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 drivers/net/wireless/p54/p54spi.c |   56 ++++++++++++++++++------------------
 1 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
index 4ebd244..5e8011c 100644
--- a/drivers/net/wireless/p54/p54spi.c
+++ b/drivers/net/wireless/p54/p54spi.c
@@ -165,6 +165,25 @@ static int p54spi_wait_bit(struct p54s_priv *priv, u16 reg, __le32 bits)
 	return 0;
 }
 
+static int p54spi_spi_write_dma(struct p54s_priv *priv, __le32 base,
+				const void *buf, size_t len)
+{
+	p54spi_write16(priv, SPI_ADRS_DMA_WRITE_CTRL,
+		       cpu_to_le16(SPI_DMA_WRITE_CTRL_ENABLE));
+
+	if (p54spi_wait_bit(priv, SPI_ADRS_DMA_WRITE_CTRL,
+			    cpu_to_le32(HOST_ALLOWED)) == 0) {
+		dev_err(&priv->spi->dev, "spi_write_dma not allowed "
+			"to DMA write.");
+		return -EAGAIN;
+	}
+
+	p54spi_write16(priv, SPI_ADRS_DMA_WRITE_LEN, cpu_to_le16(len));
+	p54spi_write32(priv, SPI_ADRS_DMA_WRITE_BASE, base);
+	p54spi_spi_write(priv, SPI_ADRS_DMA_DATA, buf, len);
+	return 0;
+}
+
 static int p54spi_request_firmware(struct ieee80211_hw *dev)
 {
 	struct p54s_priv *priv = dev->priv;
@@ -240,24 +259,11 @@ static int p54spi_upload_firmware(struct ieee80211_hw *dev)
 	while (fw_len > 0) {
 		_fw_len = min_t(long, fw_len, SPI_MAX_PACKET_SIZE);
 
-		p54spi_write16(priv, SPI_ADRS_DMA_WRITE_CTRL,
-			       cpu_to_le16(SPI_DMA_WRITE_CTRL_ENABLE));
-
-		if (p54spi_wait_bit(priv, SPI_ADRS_DMA_WRITE_CTRL,
-				    cpu_to_le32(HOST_ALLOWED)) == 0) {
-			dev_err(&priv->spi->dev, "fw_upload not allowed "
-				"to DMA write.");
-			err = -EAGAIN;
+		err = p54spi_spi_write_dma(priv, cpu_to_le32(
+					   ISL38XX_DEV_FIRMWARE_ADDR + offset),
+					   (fw + offset), _fw_len);
+		if (err < 0)
 			goto out;
-		}
-
-		p54spi_write16(priv, SPI_ADRS_DMA_WRITE_LEN,
-			       cpu_to_le16(_fw_len));
-		p54spi_write32(priv, SPI_ADRS_DMA_WRITE_BASE, cpu_to_le32(
-				ISL38XX_DEV_FIRMWARE_ADDR + offset));
-
-		p54spi_spi_write(priv, SPI_ADRS_DMA_DATA,
-				 (fw + offset), _fw_len);
 
 		fw_len -= _fw_len;
 		offset += _fw_len;
@@ -404,27 +410,21 @@ static irqreturn_t p54spi_interrupt(int irq, void *config)
 static int p54spi_tx_frame(struct p54s_priv *priv, struct sk_buff *skb)
 {
 	struct p54_hdr *hdr = (struct p54_hdr *) skb->data;
-	struct p54s_dma_regs dma_regs;
 	unsigned long timeout;
 	int ret = 0;
 	u32 ints;
 
 	p54spi_wakeup(priv);
 
-	dma_regs.cmd = cpu_to_le16(SPI_DMA_WRITE_CTRL_ENABLE);
-	dma_regs.len = cpu_to_le16(skb->len);
-	dma_regs.addr = hdr->req_id;
-
-	p54spi_spi_write(priv, SPI_ADRS_DMA_WRITE_CTRL, &dma_regs,
-			   sizeof(dma_regs));
-
-	p54spi_spi_write(priv, SPI_ADRS_DMA_DATA, skb->data, skb->len);
+	ret = p54spi_spi_write_dma(priv, hdr->req_id, skb->data, skb->len);
+	if (ret < 0)
+		goto out;
 
 	timeout = jiffies + 2 * HZ;
 	ints = p54spi_read32(priv, SPI_ADRS_HOST_INTERRUPTS);
 	while (!(ints & SPI_HOST_INT_WR_READY)) {
 		if (time_after(jiffies, timeout)) {
-			dev_err(&priv->spi->dev, "WR_READY timeout");
+			dev_err(&priv->spi->dev, "WR_READY timeout\n");
 			ret = -1;
 			goto out;
 		}
@@ -434,9 +434,9 @@ static int p54spi_tx_frame(struct p54s_priv *priv, struct sk_buff *skb)
 	p54spi_int_ack(priv, SPI_HOST_INT_WR_READY);
 	p54spi_sleep(priv);
 
-out:
 	if (FREE_AFTER_TX(skb))
 		p54_free_skb(priv->hw, skb);
+out:
 	return ret;
 }
 
-- 
1.5.4.3

