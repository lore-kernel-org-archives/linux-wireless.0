Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46313 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819Ab1HYJnX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 05:43:23 -0400
Received: by wyg24 with SMTP id 24so1509667wyg.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 02:43:22 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 1/6] wl12xx: don't indicate up PS-filtered dummy packets
Date: Thu, 25 Aug 2011 12:43:12 +0300
Message-Id: <1314265397-19873-1-git-send-email-arik@wizery.com> (sfid-20110825_114327_232899_AC949543)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dummy packets are currently only sent on the system_hlid link. The
system_hlid link should never be filtered for PS (as it is not
a STA link). Even so, for correctness, don't indicate dummy packets up.
The skb does not belong to mac80211 and as such does not contain a
correct skb->cb.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/ps.c |    8 ++++++--
 drivers/net/wireless/wl12xx/tx.c |    2 +-
 drivers/net/wireless/wl12xx/tx.h |    1 +
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/ps.c b/drivers/net/wireless/wl12xx/ps.c
index 4b720b1..c15ebf2 100644
--- a/drivers/net/wireless/wl12xx/ps.c
+++ b/drivers/net/wireless/wl12xx/ps.c
@@ -199,15 +199,19 @@ static void wl1271_ps_filter_frames(struct wl1271 *wl, u8 hlid)
 	unsigned long flags;
 	int filtered[NUM_TX_QUEUES];
 
-	/* filter all frames currently the low level queus for this hlid */
+	/* filter all frames currently in the low level queues for this hlid */
 	for (i = 0; i < NUM_TX_QUEUES; i++) {
 		filtered[i] = 0;
 		while ((skb = skb_dequeue(&wl->links[hlid].tx_queue[i]))) {
+			filtered[i]++;
+
+			if (WARN_ON(wl12xx_is_dummy_packet(wl, skb)))
+				continue;
+
 			info = IEEE80211_SKB_CB(skb);
 			info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
 			info->status.rates[0].idx = -1;
 			ieee80211_tx_status_ni(wl->hw, skb);
-			filtered[i]++;
 		}
 	}
 
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 0f15785..eb98832 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -143,7 +143,7 @@ static void wl1271_tx_regulate_link(struct wl1271 *wl, u8 hlid)
 		wl1271_ps_link_start(wl, hlid, true);
 }
 
-static bool wl12xx_is_dummy_packet(struct wl1271 *wl, struct sk_buff *skb)
+bool wl12xx_is_dummy_packet(struct wl1271 *wl, struct sk_buff *skb)
 {
 	return wl->dummy_packet == skb;
 }
diff --git a/drivers/net/wireless/wl12xx/tx.h b/drivers/net/wireless/wl12xx/tx.h
index 7da35c0..1515f4a 100644
--- a/drivers/net/wireless/wl12xx/tx.h
+++ b/drivers/net/wireless/wl12xx/tx.h
@@ -213,5 +213,6 @@ u32 wl1271_tx_min_rate_get(struct wl1271 *wl);
 u8 wl12xx_tx_get_hlid_ap(struct wl1271 *wl, struct sk_buff *skb);
 void wl1271_tx_reset_link_queues(struct wl1271 *wl, u8 hlid);
 void wl1271_handle_tx_low_watermark(struct wl1271 *wl);
+bool wl12xx_is_dummy_packet(struct wl1271 *wl, struct sk_buff *skb);
 
 #endif
-- 
1.7.4.1

