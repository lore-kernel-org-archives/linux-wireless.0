Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:35735 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277AbZEQXCy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 May 2009 19:02:54 -0400
Received: by mail-ew0-f176.google.com with SMTP id 24so3710589ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 17 May 2009 16:02:55 -0700 (PDT)
From: Max Filippov <jcmvbkbc@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Christian Lamparter <chunkeey@web.de>,
	Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 5/5] p54spi: use firmware/DMA bug workaround that work under hight load in p54spi_rx
Date: Mon, 18 May 2009 03:02:35 +0400
Message-Id: <1242601355-3178-6-git-send-email-jcmvbkbc@gmail.com>
In-Reply-To: <1242601355-3178-5-git-send-email-jcmvbkbc@gmail.com>
References: <0001-p54spi-fix-incorrect-access-sequence-to-DMA_WRITE_C.patch>
 <1242601355-3178-1-git-send-email-jcmvbkbc@gmail.com>
 <1242601355-3178-2-git-send-email-jcmvbkbc@gmail.com>
 <1242601355-3178-3-git-send-email-jcmvbkbc@gmail.com>
 <1242601355-3178-4-git-send-email-jcmvbkbc@gmail.com>
 <1242601355-3178-5-git-send-email-jcmvbkbc@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Under high load first data word, read after available data size
is sometimes lost in p54spi_rx. It seems to depend on frequency
of interrupts and latency of data read request relatively to
'data available' interrupt. The worst consequence of this bug
is loss of packet transmission acknowledgement, which in turn
causes overflow of tx queues and permanent link loss.

Read data size and first data word in one SPI transaction.
No packets from LMAC should have length less than 1 word,
so this shouldn't interfere with the next read transaction.

Also call p54spi_sleep if p54spi_wake succeeded.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 drivers/net/wireless/p54/p54spi.c |   28 ++++++++++++++++++++--------
 1 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
index 9e0c1a2..fe90f88 100644
--- a/drivers/net/wireless/p54/p54spi.c
+++ b/drivers/net/wireless/p54/p54spi.c
@@ -357,32 +357,44 @@ static int p54spi_rx(struct p54s_priv *priv)
 {
 	struct sk_buff *skb;
 	u16 len;
+	u16 rx_head[2];
+#define READAHEAD_SZ (sizeof(rx_head)-sizeof(u16))
 
 	if (p54spi_wakeup(priv) < 0)
 		return -EBUSY;
 
-	/* dummy read to flush SPI DMA controller bug */
-	p54spi_read16(priv, SPI_ADRS_GEN_PURP_1);
-
-	len = p54spi_read16(priv, SPI_ADRS_DMA_DATA);
+	/* Read data size and first data word in one SPI transaction
+	 * This is workaround for firmware/DMA bug,
+	 * when first data word gets lost under high load.
+	 */
+	p54spi_spi_read(priv, SPI_ADRS_DMA_DATA, rx_head, sizeof(rx_head));
+	len = rx_head[0];
 
 	if (len == 0) {
-		dev_err(&priv->spi->dev, "rx request of zero bytes");
+		p54spi_sleep(priv);
+		dev_err(&priv->spi->dev, "rx request of zero bytes\n");
 		return 0;
 	}
 
-
 	/* Firmware may insert up to 4 padding bytes after the lmac header,
 	 * but it does not amend the size of SPI data transfer.
 	 * Such packets has correct data size in header, thus referencing
 	 * past the end of allocated skb. Reserve extra 4 bytes for this case */
 	skb = dev_alloc_skb(len + 4);
 	if (!skb) {
+		p54spi_sleep(priv);
 		dev_err(&priv->spi->dev, "could not alloc skb");
-		return 0;
+		return -ENOMEM;
 	}
 
-	p54spi_spi_read(priv, SPI_ADRS_DMA_DATA, skb_put(skb, len), len);
+	if (len <= READAHEAD_SZ) {
+		memcpy(skb_put(skb, len), rx_head + 1, len);
+	} else {
+		memcpy(skb_put(skb, READAHEAD_SZ), rx_head + 1, READAHEAD_SZ);
+		p54spi_spi_read(priv, SPI_ADRS_DMA_DATA,
+				skb_put(skb, len - READAHEAD_SZ),
+				len - READAHEAD_SZ);
+	}
 	p54spi_sleep(priv);
 	/* Put additional bytes to compensate for the possible
 	 * alignment-caused truncation */
-- 
1.6.0.6

