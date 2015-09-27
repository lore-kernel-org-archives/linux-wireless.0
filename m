Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:34300 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642AbbI0ISS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Sep 2015 04:18:18 -0400
Received: by wicfx3 with SMTP id fx3so67890538wic.1
        for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2015 01:18:16 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/6] staging: vt6655: don't stop TX queue unless buffer full.
Date: Sun, 27 Sep 2015 09:17:39 +0100
Message-Id: <1443341864-2756-1-git-send-email-tvboxspy@gmail.com> (sfid-20150927_101849_107909_CAA72EC3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Presently the TX buffer stops while filling the buffer.

However, this does not make use of the available buffer
space, it also lags the speed of the TX troughtput.

Only stop the queue when the buffer becomes full. The
Interupt handler will start the queue again when a
buffer is available.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 326bce3..07ebdea 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1105,6 +1105,7 @@ static int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 
 	if (AVAIL_TD(priv, dma_idx) < 1) {
 		spin_unlock_irqrestore(&priv->lock, flags);
+		ieee80211_stop_queues(priv->hw);
 		return -ENOMEM;
 	}
 
@@ -1156,13 +1157,8 @@ static void vnt_tx_80211(struct ieee80211_hw *hw,
 {
 	struct vnt_private *priv = hw->priv;
 
-	ieee80211_stop_queues(hw);
-
-	if (vnt_tx_packet(priv, skb)) {
+	if (vnt_tx_packet(priv, skb))
 		ieee80211_free_txskb(hw, skb);
-
-		ieee80211_wake_queues(hw);
-	}
 }
 
 static int vnt_start(struct ieee80211_hw *hw)
-- 
2.5.0

