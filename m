Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:35735 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182AbZEQXCr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 May 2009 19:02:47 -0400
Received: by mail-ew0-f176.google.com with SMTP id 24so3710589ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 17 May 2009 16:02:49 -0700 (PDT)
From: Max Filippov <jcmvbkbc@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Christian Lamparter <chunkeey@web.de>,
	Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 3/5] p54spi: return status of p54spi_wakeup
Date: Mon, 18 May 2009 03:02:33 +0400
Message-Id: <1242601355-3178-4-git-send-email-jcmvbkbc@gmail.com>
In-Reply-To: <1242601355-3178-3-git-send-email-jcmvbkbc@gmail.com>
References: <0001-p54spi-fix-incorrect-access-sequence-to-DMA_WRITE_C.patch>
 <1242601355-3178-1-git-send-email-jcmvbkbc@gmail.com>
 <1242601355-3178-2-git-send-email-jcmvbkbc@gmail.com>
 <1242601355-3178-3-git-send-email-jcmvbkbc@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Return whether wakeup operation succeeded.
Make use of this return value.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 drivers/net/wireless/p54/p54spi.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
index 3991977..13566b1 100644
--- a/drivers/net/wireless/p54/p54spi.c
+++ b/drivers/net/wireless/p54/p54spi.c
@@ -311,7 +311,7 @@ static inline void p54spi_int_ack(struct p54s_priv *priv, u32 val)
 	p54spi_write32(priv, SPI_ADRS_HOST_INT_ACK, cpu_to_le32(val));
 }
 
-static void p54spi_wakeup(struct p54s_priv *priv)
+static int p54spi_wakeup(struct p54s_priv *priv)
 {
 	/* wake the chip */
 	p54spi_write32(priv, SPI_ADRS_ARM_INTERRUPTS,
@@ -321,13 +321,11 @@ static void p54spi_wakeup(struct p54s_priv *priv)
 	if (!p54spi_wait_bit(priv, SPI_ADRS_HOST_INTERRUPTS,
 			     cpu_to_le32(SPI_HOST_INT_READY))) {
 		dev_err(&priv->spi->dev, "INT_READY timeout\n");
-		goto out;
+		return -EBUSY;
 	}
 
 	p54spi_int_ack(priv, SPI_HOST_INT_READY);
-
-out:
-	return;
+	return 0;
 }
 
 static inline void p54spi_sleep(struct p54s_priv *priv)
@@ -360,7 +358,8 @@ static int p54spi_rx(struct p54s_priv *priv)
 	struct sk_buff *skb;
 	u16 len;
 
-	p54spi_wakeup(priv);
+	if (p54spi_wakeup(priv) < 0)
+		return -EBUSY;
 
 	/* dummy read to flush SPI DMA controller bug */
 	p54spi_read16(priv, SPI_ADRS_GEN_PURP_1);
@@ -411,7 +410,8 @@ static int p54spi_tx_frame(struct p54s_priv *priv, struct sk_buff *skb)
 	struct p54_hdr *hdr = (struct p54_hdr *) skb->data;
 	int ret = 0;
 
-	p54spi_wakeup(priv);
+	if (p54spi_wakeup(priv) < 0)
+		return -EBUSY;
 
 	ret = p54spi_spi_write_dma(priv, hdr->req_id, skb->data, skb->len);
 	if (ret < 0)
-- 
1.6.0.6

