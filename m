Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39180 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab1JKLvi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 07:51:38 -0400
Received: by gyg10 with SMTP id 10so6397011gyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2011 04:51:37 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: handle injected packets
Date: Tue, 11 Oct 2011 13:52:25 +0200
Message-Id: <1318333945-27839-1-git-send-email-eliad@wizery.com> (sfid-20111011_135140_564437_1105BA91)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Injected packets are sent with no vif, causing the wl12xx
to NULL-dereference in multiple places.

Furthermore, injected packets are currently not sent at all,
as system_hlid doesn't belong to any specific role, so
wl1271_skb_dequeue() never return its packets.

Handle both these problems.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
thanks Johannes for providing a testing app

 drivers/net/wireless/wl12xx/main.c |    7 +++++--
 drivers/net/wireless/wl12xx/tx.c   |   27 +++++++++++++--------------
 2 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 692a275..fc652c4 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1517,11 +1517,14 @@ static void wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	struct wl1271 *wl = hw->priv;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_vif *vif = info->control.vif;
-	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
+	struct wl12xx_vif *wlvif = NULL;
 	unsigned long flags;
 	int q, mapping;
 	u8 hlid;
 
+	if (vif)
+		wlvif = wl12xx_vif_to_data(vif);
+
 	mapping = skb_get_queue_mapping(skb);
 	q = wl1271_tx_get_queue(mapping);
 
@@ -1531,7 +1534,7 @@ static void wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	/* queue the packet */
 	if (hlid == WL12XX_INVALID_LINK_ID ||
-	    !test_bit(hlid, wlvif->links_map)) {
+	    (wlvif && !test_bit(hlid, wlvif->links_map))) {
 		wl1271_debug(DEBUG_TX, "DROP skb hlid %d q %d", hlid, q);
 		dev_kfree_skb(skb);
 		goto out;
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 02d606f..33b800d 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -180,7 +180,7 @@ u8 wl12xx_tx_get_hlid(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 
-	if (wl12xx_is_dummy_packet(wl, skb))
+	if (!wlvif || wl12xx_is_dummy_packet(wl, skb))
 		return wl->system_hlid;
 
 	if (wlvif->bss_type == BSS_TYPE_AP_BSS)
@@ -259,7 +259,8 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		ac = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
 		wl->tx_allocated_pkts[ac]++;
 
-		if (!is_dummy && wlvif->bss_type == BSS_TYPE_AP_BSS &&
+		if (!is_dummy && wlvif &&
+		    wlvif->bss_type == BSS_TYPE_AP_BSS &&
 		    test_bit(hlid, wlvif->ap.sta_hlid_map))
 			wl->links[hlid].allocated_pkts++;
 
@@ -302,7 +303,7 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	desc->start_time = cpu_to_le32(hosttime - wl->time_offset);
 
 	is_dummy = wl12xx_is_dummy_packet(wl, skb);
-	if (is_dummy || wlvif->bss_type != BSS_TYPE_AP_BSS)
+	if (is_dummy || !wlvif || wlvif->bss_type != BSS_TYPE_AP_BSS)
 		desc->life_time = cpu_to_le16(TX_HW_MGMT_PKT_LIFETIME_TU);
 	else
 		desc->life_time = cpu_to_le16(TX_HW_AP_MODE_PKT_LIFETIME_TU);
@@ -321,14 +322,14 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			   TX_HW_ATTR_SESSION_COUNTER;
 
 		tx_attr |= TX_HW_ATTR_TX_DUMMY_REQ;
-	} else {
+	} else if (wlvif) {
 		/* configure the tx attributes */
 		tx_attr = wlvif->session_counter <<
 			  TX_HW_ATTR_OFST_SESSION_COUNTER;
 	}
 
 	desc->hlid = hlid;
-	if (is_dummy)
+	if (is_dummy || !wlvif)
 		rate_idx = 0;
 	else if (wlvif->bss_type != BSS_TYPE_AP_BSS) {
 		/* if the packets are destined for AP (have a STA entry)
@@ -433,7 +434,7 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 
 	wl1271_tx_fill_hdr(wl, wlvif, skb, extra, info, hlid);
 
-	if (!is_dummy && wlvif->bss_type == BSS_TYPE_AP_BSS) {
+	if (!is_dummy && wlvif && wlvif->bss_type == BSS_TYPE_AP_BSS) {
 		wl1271_tx_ap_update_inconnection_sta(wl, skb);
 		wl1271_tx_regulate_link(wl, wlvif, hlid);
 	}
@@ -610,6 +611,9 @@ static struct sk_buff *wl1271_skb_dequeue(struct wl1271 *wl)
 		}
 	}
 
+	if (!skb)
+		skb = wl12xx_lnk_skb_dequeue(wl, &wl->links[wl->system_hlid]);
+
 	if (!skb &&
 	    test_and_clear_bit(WL1271_FLAG_DUMMY_PACKET_PENDING, &wl->flags)) {
 		int q;
@@ -703,19 +707,14 @@ void wl1271_tx_work_locked(struct wl1271 *wl)
 		return;
 
 	while ((skb = wl1271_skb_dequeue(wl))) {
+		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 		bool has_data = false;
 
 		wlvif = NULL;
-		if (!wl12xx_is_dummy_packet(wl, skb)) {
-			struct ieee80211_tx_info *info;
-			struct ieee80211_vif *vif;
+		if (!wl12xx_is_dummy_packet(wl, skb) && info->control.vif)
+			wlvif = wl12xx_vif_to_data(info->control.vif);
 
-			info = IEEE80211_SKB_CB(skb);
-			vif = info->control.vif;
-			wlvif = wl12xx_vif_to_data(vif);
-		}
 		has_data = wlvif && wl1271_tx_is_data_present(skb);
-
 		ret = wl1271_prepare_tx_frame(wl, wlvif, skb, buf_offset);
 		if (ret == -EAGAIN) {
 			/*
-- 
1.7.6.401.g6a319

