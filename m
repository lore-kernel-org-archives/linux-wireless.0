Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35863 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab1HIJOH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 05:14:07 -0400
Received: by mail-ww0-f44.google.com with SMTP id 5so2430702wwf.1
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 02:14:07 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 19/40] wl12xx: handle dummy packet event also in ap mode
Date: Tue,  9 Aug 2011 12:13:32 +0300
Message-Id: <1312881233-9366-20-git-send-email-eliad@wizery.com> (sfid-20110809_111417_714447_38C66C3D)
In-Reply-To: <1312881233-9366-1-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Allow handling of DUMMY_PACKET_EVENT_ID also in ap mode.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/event.c |    2 +-
 drivers/net/wireless/wl12xx/tx.c    |   12 ++++++++----
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index 431ceae..0bd7b02 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -288,13 +288,13 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 			     "ba_allowed = 0x%x", mbox->rx_ba_allowed);
 
 		if (wl->vif)
 			wl1271_stop_ba_event(wl, mbox->rx_ba_allowed);
 	}
 
-	if ((vector & DUMMY_PACKET_EVENT_ID) && !is_ap) {
+	if ((vector & DUMMY_PACKET_EVENT_ID)) {
 		wl1271_debug(DEBUG_EVENT, "DUMMY_PACKET_ID_EVENT_ID");
 		if (wl->vif)
 			wl1271_tx_dummy_packet(wl);
 	}
 
 	/*
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index ea05caf..4e1c655 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -826,16 +826,20 @@ void wl1271_tx_reset_link_queues(struct wl1271 *wl, u8 hlid)
 	int total[NUM_TX_QUEUES];
 
 	for (i = 0; i < NUM_TX_QUEUES; i++) {
 		total[i] = 0;
 		while ((skb = skb_dequeue(&wl->links[hlid].tx_queue[i]))) {
 			wl1271_debug(DEBUG_TX, "link freeing skb 0x%p", skb);
-			info = IEEE80211_SKB_CB(skb);
-			info->status.rates[0].idx = -1;
-			info->status.rates[0].count = 0;
-			ieee80211_tx_status_ni(wl->hw, skb);
+
+			if (!wl12xx_is_dummy_packet(wl, skb)) {
+				info = IEEE80211_SKB_CB(skb);
+				info->status.rates[0].idx = -1;
+				info->status.rates[0].count = 0;
+				ieee80211_tx_status_ni(wl->hw, skb);
+			}
+
 			total[i]++;
 		}
 	}
 
 	spin_lock_irqsave(&wl->wl_lock, flags);
 	for (i = 0; i < NUM_TX_QUEUES; i++)
-- 
1.7.6.401.g6a319

