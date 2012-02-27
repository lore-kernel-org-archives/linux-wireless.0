Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:53042 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812Ab2B0Wlp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 17:41:45 -0500
Received: by mail-wi0-f174.google.com with SMTP id hm11so1607155wib.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Feb 2012 14:41:44 -0800 (PST)
MIME-Version: 1.0
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 3/7] wl12xx: reset link Tx queues when freeing it
Date: Tue, 28 Feb 2012 00:41:30 +0200
Message-Id: <1330382494-31148-3-git-send-email-arik@wizery.com> (sfid-20120227_234149_013737_CB64F601)
In-Reply-To: <1330382494-31148-1-git-send-email-arik@wizery.com>
References: <1330382494-31148-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Before, the link was first freed (invalidating it in the map), and later
on vif removal, all valid wlvif-related links were reset. Since these
links were already invalid, we failed to reset them.
The bug was made worse by op_stop, which set the tx_queue_count to 0
arbitrarily. This resulted in a negative tx_queue_count in some scenarios.

Fix this by resetting the Tx-queues of a link when freeing it. Add a
WARN_ON and reset all link Tx-queues in op_stop, to avoid a negative
tx_queue_count.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c  |    7 +++++++
 drivers/net/wireless/wl12xx/main.c |    1 -
 drivers/net/wireless/wl12xx/tx.c   |   13 ++++++++++---
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index ef994da..ae1f3d7 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -485,6 +485,13 @@ void wl12xx_free_link(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 *hlid)
 	__clear_bit(*hlid, wl->links_map);
 	__clear_bit(*hlid, wlvif->links_map);
 	spin_unlock_irqrestore(&wl->wl_lock, flags);
+
+	/*
+	 * At this point op_tx() will not add more packets to the queues. We
+	 * can purge them.
+	 */
+	wl1271_tx_reset_link_queues(wl, *hlid);
+
 	*hlid = WL12XX_INVALID_LINK_ID;
 }
 
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index adf9bbc..712e385 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -4228,7 +4228,6 @@ void wl1271_free_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 hlid)
 	clear_bit(hlid, wlvif->ap.sta_hlid_map);
 	memset(wl->links[hlid].addr, 0, ETH_ALEN);
 	wl->links[hlid].ba_bitmap = 0;
-	wl1271_tx_reset_link_queues(wl, hlid);
 	__clear_bit(hlid, &wl->ap_ps_map);
 	__clear_bit(hlid, (unsigned long *)&wl->ap_fw_ps_map);
 	wl12xx_free_link(wl, wlvif, &hlid);
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 6446e4d..311b5a2 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -527,6 +527,7 @@ static struct sk_buff *wl12xx_lnk_skb_dequeue(struct wl1271 *wl,
 	if (skb) {
 		int q = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
 		spin_lock_irqsave(&wl->wl_lock, flags);
+		WARN_ON(wl->tx_queue_count[q] <= 0);
 		wl->tx_queue_count[q]--;
 		spin_unlock_irqrestore(&wl->wl_lock, flags);
 	}
@@ -602,6 +603,7 @@ static struct sk_buff *wl1271_skb_dequeue(struct wl1271 *wl)
 		skb = wl->dummy_packet;
 		q = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
 		spin_lock_irqsave(&wl->wl_lock, flags);
+		WARN_ON(wl->tx_queue_count[q] <= 0);
 		wl->tx_queue_count[q]--;
 		spin_unlock_irqrestore(&wl->wl_lock, flags);
 	}
@@ -959,7 +961,6 @@ void wl12xx_tx_reset_wlvif(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 		else
 			wlvif->sta.ba_rx_bitmap = 0;
 
-		wl1271_tx_reset_link_queues(wl, i);
 		wl->links[i].allocated_pkts = 0;
 		wl->links[i].prev_freed_pkts = 0;
 	}
@@ -973,8 +974,14 @@ void wl12xx_tx_reset(struct wl1271 *wl, bool reset_tx_queues)
 	struct sk_buff *skb;
 	struct ieee80211_tx_info *info;
 
-	for (i = 0; i < NUM_TX_QUEUES; i++)
-		wl->tx_queue_count[i] = 0;
+	/* only reset the queues if something bad happened */
+	if (WARN_ON(wl1271_tx_total_queue_count(wl) != 0)) {
+		for (i = 0; i < WL12XX_MAX_LINKS; i++)
+			wl1271_tx_reset_link_queues(wl, i);
+
+		for (i = 0; i < NUM_TX_QUEUES; i++)
+			wl->tx_queue_count[i] = 0;
+	}
 
 	wl->stopped_queues_map = 0;
 
-- 
1.7.5.4

