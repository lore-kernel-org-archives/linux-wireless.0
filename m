Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33441 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab1AaUc5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 15:32:57 -0500
Received: by mail-ww0-f44.google.com with SMTP id 36so6228533wwa.1
        for <linux-wireless@vger.kernel.org>; Mon, 31 Jan 2011 12:32:56 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 4/8] wl12xx: report invalid TX rate when returning non-TX-ed skbs
Date: Mon, 31 Jan 2011 22:32:27 +0200
Message-Id: <1296505951-29644-5-git-send-email-arik@wizery.com>
In-Reply-To: <1296505951-29644-1-git-send-email-arik@wizery.com>
References: <1296505951-29644-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Report a TX rate idx of -1 and count 0 when returning untransmitted
skbs to mac80211 using ieee80211_tx_status(). Otherwise mac80211
tries to use the returned (essentially garbage) status.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/tx.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index c658821..71d964c 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -628,10 +628,14 @@ void wl1271_tx_reset_link_queues(struct wl1271 *wl, u8 hlid)
 	struct sk_buff *skb;
 	int i, total = 0;
 	unsigned long flags;
+	struct ieee80211_tx_info *info;
 
 	for (i = 0; i < NUM_TX_QUEUES; i++) {
 		while ((skb = skb_dequeue(&wl->links[hlid].tx_queue[i]))) {
 			wl1271_debug(DEBUG_TX, "link freeing skb 0x%p", skb);
+			info = IEEE80211_SKB_CB(skb);
+			info->status.rates[0].idx = -1;
+			info->status.rates[0].count = 0;
 			ieee80211_tx_status(wl->hw, skb);
 			total++;
 		}
@@ -649,6 +653,7 @@ void wl1271_tx_reset(struct wl1271 *wl)
 {
 	int i;
 	struct sk_buff *skb;
+	struct ieee80211_tx_info *info;
 
 	/* TX failure */
 	if (wl->bss_type == BSS_TYPE_AP_BSS) {
@@ -661,6 +666,9 @@ void wl1271_tx_reset(struct wl1271 *wl)
 			while ((skb = skb_dequeue(&wl->tx_queue[i]))) {
 				wl1271_debug(DEBUG_TX, "freeing skb 0x%p",
 					     skb);
+				info = IEEE80211_SKB_CB(skb);
+				info->status.rates[0].idx = -1;
+				info->status.rates[0].count = 0;
 				ieee80211_tx_status(wl->hw, skb);
 			}
 		}
@@ -679,6 +687,9 @@ void wl1271_tx_reset(struct wl1271 *wl)
 			skb = wl->tx_frames[i];
 			wl1271_free_tx_id(wl, i);
 			wl1271_debug(DEBUG_TX, "freeing skb 0x%p", skb);
+			info = IEEE80211_SKB_CB(skb);
+			info->status.rates[0].idx = -1;
+			info->status.rates[0].count = 0;
 			ieee80211_tx_status(wl->hw, skb);
 		}
 }
-- 
1.7.1

