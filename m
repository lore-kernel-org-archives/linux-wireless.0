Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:35735 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbZEQXCn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 May 2009 19:02:43 -0400
Received: by ewy24 with SMTP id 24so3710589ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 17 May 2009 16:02:43 -0700 (PDT)
From: Max Filippov <jcmvbkbc@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Christian Lamparter <chunkeey@web.de>,
	Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 1/5] p54spi: fix incorrect access sequence to DMA_WRITE_CTRL in p54spi_spi_write_dma
Date: Mon, 18 May 2009 03:02:31 +0400
Message-Id: <1242601355-3178-2-git-send-email-jcmvbkbc@gmail.com>
In-Reply-To: <1242601355-3178-1-git-send-email-jcmvbkbc@gmail.com>
References: <0001-p54spi-fix-incorrect-access-sequence-to-DMA_WRITE_C.patch>
 <1242601355-3178-1-git-send-email-jcmvbkbc@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Host is not allowed to modify DMA_WRITE_CTRL register
if bit HOST_ALLOWED in it is not set. Wait for HOST_ALLOWED first.

Also get rid of timeout in p54spi_wait_bit as it's been playing
a role of workaround for such an incorrect register access.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 drivers/net/wireless/p54/p54spi.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
index e4e708e..ff92bc3 100644
--- a/drivers/net/wireless/p54/p54spi.c
+++ b/drivers/net/wireless/p54/p54spi.c
@@ -158,8 +158,6 @@ static int p54spi_wait_bit(struct p54s_priv *priv, u16 reg, __le32 bits)
 		__le32 buffer = p54spi_read32(priv, reg);
 		if ((buffer & bits) == bits)
 			return 1;
-
-		msleep(0);
 	}
 	return 0;
 }
@@ -167,9 +165,6 @@ static int p54spi_wait_bit(struct p54s_priv *priv, u16 reg, __le32 bits)
 static int p54spi_spi_write_dma(struct p54s_priv *priv, __le32 base,
 				const void *buf, size_t len)
 {
-	p54spi_write16(priv, SPI_ADRS_DMA_WRITE_CTRL,
-		       cpu_to_le16(SPI_DMA_WRITE_CTRL_ENABLE));
-
 	if (!p54spi_wait_bit(priv, SPI_ADRS_DMA_WRITE_CTRL,
 			     cpu_to_le32(HOST_ALLOWED))) {
 		dev_err(&priv->spi->dev, "spi_write_dma not allowed "
@@ -177,6 +172,9 @@ static int p54spi_spi_write_dma(struct p54s_priv *priv, __le32 base,
 		return -EAGAIN;
 	}
 
+	p54spi_write16(priv, SPI_ADRS_DMA_WRITE_CTRL,
+		       cpu_to_le16(SPI_DMA_WRITE_CTRL_ENABLE));
+
 	p54spi_write16(priv, SPI_ADRS_DMA_WRITE_LEN, cpu_to_le16(len));
 	p54spi_write32(priv, SPI_ADRS_DMA_WRITE_BASE, base);
 	p54spi_spi_write(priv, SPI_ADRS_DMA_DATA, buf, len);
-- 
1.6.0.6

