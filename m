Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50372 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab1B0WQY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Feb 2011 17:16:24 -0500
Received: by wyg36 with SMTP id 36so3120195wyg.19
        for <linux-wireless@vger.kernel.org>; Sun, 27 Feb 2011 14:16:22 -0800 (PST)
From: Ido Yariv <ido@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org, Ido Yariv <ido@wizery.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] wl12xx: Remove private headers in wl1271_tx_reset
Date: Mon, 28 Feb 2011 00:16:13 +0200
Message-Id: <1298844973-11949-1-git-send-email-ido@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Frames in the tx_frames array include extra private headers, which must
be removed before passing the skbs to ieee80211_tx_status.

Fix this by removing any private headers in wl1271_tx_reset, similar to
how this is done in wl1271_tx_complete_packet.

Signed-off-by: Ido Yariv <ido@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/tx.c |   32 +++++++++++++++++++++++---------
 1 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index ac60d57..37d354d 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -687,16 +687,30 @@ void wl1271_tx_reset(struct wl1271 *wl)
 	 */
 	wl1271_handle_tx_low_watermark(wl);
 
-	for (i = 0; i < ACX_TX_DESCRIPTORS; i++)
-		if (wl->tx_frames[i] != NULL) {
-			skb = wl->tx_frames[i];
-			wl1271_free_tx_id(wl, i);
-			wl1271_debug(DEBUG_TX, "freeing skb 0x%p", skb);
-			info = IEEE80211_SKB_CB(skb);
-			info->status.rates[0].idx = -1;
-			info->status.rates[0].count = 0;
-			ieee80211_tx_status(wl->hw, skb);
+	for (i = 0; i < ACX_TX_DESCRIPTORS; i++) {
+		if (wl->tx_frames[i] == NULL)
+			continue;
+
+		skb = wl->tx_frames[i];
+		wl1271_free_tx_id(wl, i);
+		wl1271_debug(DEBUG_TX, "freeing skb 0x%p", skb);
+
+		/* Remove private headers before passing the skb to mac80211 */
+		info = IEEE80211_SKB_CB(skb);
+		skb_pull(skb, sizeof(struct wl1271_tx_hw_descr));
+		if (info->control.hw_key &&
+		    info->control.hw_key->cipher == WLAN_CIPHER_SUITE_TKIP) {
+			int hdrlen = ieee80211_get_hdrlen_from_skb(skb);
+			memmove(skb->data + WL1271_TKIP_IV_SPACE, skb->data,
+				hdrlen);
+			skb_pull(skb, WL1271_TKIP_IV_SPACE);
 		}
+
+		info->status.rates[0].idx = -1;
+		info->status.rates[0].count = 0;
+
+		ieee80211_tx_status(wl->hw, skb);
+	}
 }
 
 #define WL1271_TX_FLUSH_TIMEOUT 500000
-- 
1.7.1

