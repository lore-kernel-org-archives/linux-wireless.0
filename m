Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55381 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab1HNKSQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 06:18:16 -0400
Received: by mail-ww0-f44.google.com with SMTP id 5so4061056wwf.1
        for <linux-wireless@vger.kernel.org>; Sun, 14 Aug 2011 03:18:16 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 39/40] wl12xx: AP-mode - prevent Tx to stale/invalid stations
Date: Sun, 14 Aug 2011 13:17:38 +0300
Message-Id: <1313317059-16567-40-git-send-email-eliad@wizery.com> (sfid-20110814_121825_276688_4036AF60)
In-Reply-To: <1313317059-16567-1-git-send-email-eliad@wizery.com>
References: <1313317059-16567-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Don't pollute the queues with Tx directed to invalid stations. This
can happen during recovery.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |   20 +++++++++++++++++---
 1 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index cf5835b..6c56bef 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -776,13 +776,19 @@ static void wl12xx_irq_ps_regulate_link(struct wl1271 *wl, u8 hlid, u8 tx_pkts)
 	else if (fw_ps && tx_pkts >= WL1271_PS_STA_MAX_PACKETS)
 		wl1271_ps_link_start(wl, hlid, true);
 }
 
 bool wl1271_is_active_sta(struct wl1271 *wl, u8 hlid)
 {
-	int id = hlid - WL1271_AP_STA_HLID_START;
+	int id;
+
+	/* global/broadcast "stations" are always active */
+	if (hlid < WL1271_AP_STA_HLID_START)
+		return true;
+
+	id = hlid - WL1271_AP_STA_HLID_START;
 	return test_bit(id, wl->ap_hlid_map);
 }
 
 static void wl12xx_irq_update_links_status(struct wl1271 *wl,
 					   struct wl12xx_fw_status *status)
 {
@@ -1490,12 +1496,19 @@ static void wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		ieee80211_stop_queue(wl->hw, mapping);
 		set_bit(q, &wl->stopped_queues_map);
 	}
 
 	/* queue the packet */
 	if (wl->bss_type == BSS_TYPE_AP_BSS) {
+		if (!wl1271_is_active_sta(wl, hlid)) {
+			wl1271_debug(DEBUG_TX, "DROP skb hlid %d q %d",
+				     hlid, q);
+			dev_kfree_skb(skb);
+			goto out;
+		}
+
 		wl1271_debug(DEBUG_TX, "queue skb hlid %d q %d", hlid, q);
 		skb_queue_tail(&wl->links[hlid].tx_queue[q], skb);
 	} else {
 		skb_queue_tail(&wl->tx_queue[q], skb);
 	}
 
@@ -1505,12 +1518,13 @@ static void wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	 */
 
 	if (!test_bit(WL1271_FLAG_FW_TX_BUSY, &wl->flags) &&
 	    !test_bit(WL1271_FLAG_TX_PENDING, &wl->flags))
 		ieee80211_queue_work(wl->hw, &wl->tx_work);
 
+out:
 	spin_unlock_irqrestore(&wl->wl_lock, flags);
 }
 
 int wl1271_tx_dummy_packet(struct wl1271 *wl)
 {
 	unsigned long flags;
@@ -3692,13 +3706,13 @@ static int wl1271_allocate_sta(struct wl1271 *wl,
 	if (id >= AP_MAX_STATIONS) {
 		wl1271_warning("could not allocate HLID - too much stations");
 		return -EBUSY;
 	}
 
 	wl_sta = (struct wl1271_station *)sta->drv_priv;
-	__set_bit(id, wl->ap_hlid_map);
+	set_bit(id, wl->ap_hlid_map);
 	wl_sta->hlid = WL1271_AP_STA_HLID_START + id;
 	*hlid = wl_sta->hlid;
 	memcpy(wl->links[wl_sta->hlid].addr, sta->addr, ETH_ALEN);
 	return 0;
 }
 
@@ -3706,13 +3720,13 @@ static void wl1271_free_sta(struct wl1271 *wl, u8 hlid)
 {
 	int id = hlid - WL1271_AP_STA_HLID_START;
 
 	if (WARN_ON(!test_bit(id, wl->ap_hlid_map)))
 		return;
 
-	__clear_bit(id, wl->ap_hlid_map);
+	clear_bit(id, wl->ap_hlid_map);
 	memset(wl->links[hlid].addr, 0, ETH_ALEN);
 	wl->links[hlid].ba_bitmap = 0;
 	wl1271_tx_reset_link_queues(wl, hlid);
 	__clear_bit(hlid, &wl->ap_ps_map);
 	__clear_bit(hlid, (unsigned long *)&wl->ap_fw_ps_map);
 }
-- 
1.7.6.401.g6a319

