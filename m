Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:30708 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486Ab0CZKyK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Mar 2010 06:54:10 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 18/24] wl1271: Fix memory leak in firmware crash scenario
Date: Fri, 26 Mar 2010 12:53:27 +0200
Message-Id: <1269600813-32145-19-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1269600813-32145-1-git-send-email-luciano.coelho@nokia.com>
References: <1269600813-32145-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

The driver tx-queue flush operation leaks broadcast-frames. This leak occurs
if the driver is shut down while there are frames in TX buffers (such as in
a firmware crash scenario.) Fix the leak.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_tx.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.c b/drivers/net/wireless/wl12xx/wl1271_tx.c
index 5712489..66b48b7 100644
--- a/drivers/net/wireless/wl12xx/wl1271_tx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.c
@@ -426,8 +426,10 @@ void wl1271_tx_flush(struct wl1271 *wl)
 
 		wl1271_debug(DEBUG_TX, "flushing skb 0x%p", skb);
 
-		if (!(info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS))
-				continue;
+		if (!(info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS)) {
+			kfree_skb(skb);
+			continue;
+		}
 
 		ieee80211_tx_status(wl->hw, skb);
 	}
@@ -437,8 +439,10 @@ void wl1271_tx_flush(struct wl1271 *wl)
 			skb = wl->tx_frames[i];
 			info = IEEE80211_SKB_CB(skb);
 
-			if (!(info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS))
+			if (!(info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS)) {
+				kfree_skb(skb);
 				continue;
+			}
 
 			ieee80211_tx_status(wl->hw, skb);
 			wl->tx_frames[i] = NULL;
-- 
1.6.3.3

