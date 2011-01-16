Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36091 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab1APFmb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Jan 2011 00:42:31 -0500
Received: by wyb28 with SMTP id 28so4134866wyb.19
        for <linux-wireless@vger.kernel.org>; Sat, 15 Jan 2011 21:42:30 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 05/10] wl12xx: report invalid TX rate when returning non-TX-ed skbs
Date: Sun, 16 Jan 2011 07:42:09 +0200
Message-Id: <1295156534-4178-6-git-send-email-arik@wizery.com>
In-Reply-To: <1295156534-4178-1-git-send-email-arik@wizery.com>
References: <1295156534-4178-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Report a TX rate idx of -1 when returning untransmitted skbs to mac80211
using ieee80211_tx_status(). Otherwise mac80211 tries to use the
returned (essentially garbage) status.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/tx.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index b7fd840..d43193e 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -628,10 +628,13 @@ void wl1271_tx_reset_link_queues(struct wl1271 *wl, u8 hlid)
 	struct sk_buff *skb;
 	int i, total = 0;
 	unsigned long flags;
+	struct ieee80211_tx_info *info;
 
 	for (i = 0; i < NUM_TX_QUEUES; i++) {
 		while ((skb = skb_dequeue(&wl->links[hlid].tx_queue[i]))) {
 			wl1271_debug(DEBUG_TX, "link freeing skb 0x%p", skb);
+			info = IEEE80211_SKB_CB(skb);
+			info->status.rates[0].idx = -1;
 			ieee80211_tx_status(wl->hw, skb);
 			total++;
 		}
@@ -649,6 +652,7 @@ void wl1271_tx_reset(struct wl1271 *wl)
 {
 	int i;
 	struct sk_buff *skb;
+	struct ieee80211_tx_info *info;
 
 	/* TX failure */
 	if (wl->bss_type == BSS_TYPE_AP_BSS) {
@@ -661,6 +665,8 @@ void wl1271_tx_reset(struct wl1271 *wl)
 			while ((skb = skb_dequeue(&wl->tx_queue[i]))) {
 				wl1271_debug(DEBUG_TX, "freeing skb 0x%p",
 					     skb);
+				info = IEEE80211_SKB_CB(skb);
+				info->status.rates[0].idx = -1;
 				ieee80211_tx_status(wl->hw, skb);
 			}
 		}
@@ -679,6 +685,8 @@ void wl1271_tx_reset(struct wl1271 *wl)
 			skb = wl->tx_frames[i];
 			wl1271_free_tx_id(wl, i);
 			wl1271_debug(DEBUG_TX, "freeing skb 0x%p", skb);
+			info = IEEE80211_SKB_CB(skb);
+			info->status.rates[0].idx = -1;
 			ieee80211_tx_status(wl->hw, skb);
 		}
 }
-- 
1.7.1

