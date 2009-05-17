Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:35735 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239AbZEQXCu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 May 2009 19:02:50 -0400
Received: by mail-ew0-f176.google.com with SMTP id 24so3710589ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 17 May 2009 16:02:52 -0700 (PDT)
From: Max Filippov <jcmvbkbc@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Christian Lamparter <chunkeey@web.de>,
	Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 4/5] p54spi: always call p54spi_sleep in p54spi_tx_frame if p54spi_wakeup succeeded
Date: Mon, 18 May 2009 03:02:34 +0400
Message-Id: <1242601355-3178-5-git-send-email-jcmvbkbc@gmail.com>
In-Reply-To: <1242601355-3178-4-git-send-email-jcmvbkbc@gmail.com>
References: <0001-p54spi-fix-incorrect-access-sequence-to-DMA_WRITE_C.patch>
 <1242601355-3178-1-git-send-email-jcmvbkbc@gmail.com>
 <1242601355-3178-2-git-send-email-jcmvbkbc@gmail.com>
 <1242601355-3178-3-git-send-email-jcmvbkbc@gmail.com>
 <1242601355-3178-4-git-send-email-jcmvbkbc@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Put chip into sleep state, once it's been awaken.
Also, propagate error code to the caller.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 drivers/net/wireless/p54/p54spi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
index 13566b1..9e0c1a2 100644
--- a/drivers/net/wireless/p54/p54spi.c
+++ b/drivers/net/wireless/p54/p54spi.c
@@ -420,16 +420,16 @@ static int p54spi_tx_frame(struct p54s_priv *priv, struct sk_buff *skb)
 	if (!p54spi_wait_bit(priv, SPI_ADRS_HOST_INTERRUPTS,
 			     cpu_to_le32(SPI_HOST_INT_WR_READY))) {
 		dev_err(&priv->spi->dev, "WR_READY timeout\n");
-		ret = -1;
+		ret = -EAGAIN;
 		goto out;
 	}
 
 	p54spi_int_ack(priv, SPI_HOST_INT_WR_READY);
-	p54spi_sleep(priv);
 
 	if (FREE_AFTER_TX(skb))
 		p54_free_skb(priv->hw, skb);
 out:
+	p54spi_sleep(priv);
 	return ret;
 }
 
-- 
1.6.0.6

