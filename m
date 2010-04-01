Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:44438 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab0DAIjD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Apr 2010 04:39:03 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 8/8] wl1271: Fix tx queue flushing
Date: Thu,  1 Apr 2010 11:38:24 +0300
Message-Id: <1270111104-29549-9-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1270111104-29549-1-git-send-email-luciano.coelho@nokia.com>
References: <1270111104-29549-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

This patch modifies tx-queue flushing to correspond with tx-path - i.e.
also frames for which no ack was requested are forwarded to the mac80211
for disposal.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_tx.c |   18 +-----------------
 1 files changed, 1 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.c b/drivers/net/wireless/wl12xx/wl1271_tx.c
index 0b8cdb4..62db795 100644
--- a/drivers/net/wireless/wl12xx/wl1271_tx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.c
@@ -416,35 +416,19 @@ void wl1271_tx_flush(struct wl1271 *wl)
 {
 	int i;
 	struct sk_buff *skb;
-	struct ieee80211_tx_info *info;
 
 	/* TX failure */
 /* 	control->flags = 0; FIXME */
 
 	while ((skb = skb_dequeue(&wl->tx_queue))) {
-		info = IEEE80211_SKB_CB(skb);
-
 		wl1271_debug(DEBUG_TX, "flushing skb 0x%p", skb);
-
-		if (!(info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS)) {
-			kfree_skb(skb);
-			continue;
-		}
-
 		ieee80211_tx_status(wl->hw, skb);
 	}
 
 	for (i = 0; i < ACX_TX_DESCRIPTORS; i++)
 		if (wl->tx_frames[i] != NULL) {
 			skb = wl->tx_frames[i];
-			info = IEEE80211_SKB_CB(skb);
-
-			if (!(info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS)) {
-				kfree_skb(skb);
-				continue;
-			}
-
-			ieee80211_tx_status(wl->hw, skb);
 			wl->tx_frames[i] = NULL;
+			ieee80211_tx_status(wl->hw, skb);
 		}
 }
-- 
1.6.3.3

