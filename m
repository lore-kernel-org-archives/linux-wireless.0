Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:60661 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbYLMQHW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Dec 2008 11:07:22 -0500
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] p54: update ACK failure statistic counter in real-time
Date: Sat, 13 Dec 2008 16:45:38 +0100
Cc: John W Linville <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200812131645.38861.chunkeey@web.de> (sfid-20081213_170727_900815_D4485C24)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-12-13 13:36:02.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2008-12-13 16:18:18.000000000 +0100
@@ -721,6 +721,7 @@ static void p54_rx_frame_sent(struct iee
 		entry_hdr = (struct p54_hdr *) entry->data;
 		entry_data = (struct p54_tx_data *) entry_hdr->data;
 		priv->tx_stats[entry_data->hw_queue].len--;
+		priv->stats.dot11ACKFailureCount += payload->tries - 1;
 
 		if (unlikely(entry == priv->cached_beacon)) {
 			kfree_skb(entry);
