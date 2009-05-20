Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f123.google.com ([209.85.216.123]:39005 "EHLO
	mail-px0-f123.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035AbZETAUN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 20:20:13 -0400
Received: by pxi29 with SMTP id 29so89321pxi.33
        for <linux-wireless@vger.kernel.org>; Tue, 19 May 2009 17:20:14 -0700 (PDT)
Message-ID: <4a134cbd.1ebc720a.4cee.ffffc1c3@mx.google.com>
Date: Tue, 19 May 2009 17:20:13 -0700 (PDT)
From: andrey@cozybit.com
To: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Cc: dcbw@redhat.com
Subject: libertas: fix GSPI card event handling
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The GPSI interface driver does not re-enable the Card Event Interrupt, which
causes problems after a card event (for example: link-loss) comes in.  This
can lead, for example, to the card failing to re-associate.  This patch 
ensures that we re-enable the Card Event Interrupt when we handle card events.

Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
index dccd01f..5fa55fe 100644
--- a/drivers/net/wireless/libertas/if_spi.c
+++ b/drivers/net/wireless/libertas/if_spi.c
@@ -814,6 +814,13 @@ static void if_spi_e2h(struct if_spi_card *card)
 	if (err)
 		goto out;
 
+	/* re-enable the card event interrupt */
+	spu_write_u16(card, IF_SPI_HOST_INT_STATUS_REG,
+			~IF_SPI_HICU_CARD_EVENT);
+
+	/* generate a card interrupt */
+	spu_write_u16(card, IF_SPI_CARD_INT_CAUSE_REG, IF_SPI_CIC_HOST_EVENT);
+
 	spin_lock_irqsave(&priv->driver_lock, flags);
 	lbs_queue_event(priv, cause & 0xff);
 	spin_unlock_irqrestore(&priv->driver_lock, flags);


