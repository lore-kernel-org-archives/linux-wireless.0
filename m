Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51550 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab0D1XST (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Apr 2010 19:18:19 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rtl8180: fix tx status reporting
Date: Wed, 28 Apr 2010 19:14:42 -0400
Message-Id: <1272496482-12687-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When reporting Tx status, indicate that only one rate was used.
Otherwise, the rate is frozen at rate index 0 (i.e. 1Mb/s).

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/rtl818x/rtl8180_dev.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180_dev.c b/drivers/net/wireless/rtl818x/rtl8180_dev.c
index d84ad05..8487327 100644
--- a/drivers/net/wireless/rtl818x/rtl8180_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180_dev.c
@@ -188,6 +188,7 @@ static void rtl8180_handle_tx(struct ieee80211_hw *dev, unsigned int prio)
 			info->flags |= IEEE80211_TX_STAT_ACK;
 
 		info->status.rates[0].count = (flags & 0xFF) + 1;
+		info->status.rates[1].idx = -1;
 
 		ieee80211_tx_status_irqsafe(dev, skb);
 		if (ring->entries - skb_queue_len(&ring->queue) == 2)
-- 
1.6.6.1

