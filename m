Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54440 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab1HIJOC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 05:14:02 -0400
Received: by mail-wy0-f174.google.com with SMTP id 24so210739wyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 02:14:01 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 16/40] wl12xx: add system_hlid
Date: Tue,  9 Aug 2011 12:13:29 +0300
Message-Id: <1312881233-9366-17-git-send-email-eliad@wizery.com> (sfid-20110809_111410_290419_C803118F)
In-Reply-To: <1312881233-9366-1-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

system_hlid is a const hlid (always 0), used by the fw and driver
for packets which are not bound to specific role (e.g. dynamic
memory packets).
indicate it as always allocated.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |   11 ++++++++++-
 drivers/net/wireless/wl12xx/tx.c     |   13 +++++++++----
 drivers/net/wireless/wl12xx/tx.h     |    2 +-
 drivers/net/wireless/wl12xx/wl12xx.h |    2 ++
 4 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 153189b..11909bb 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1482,13 +1482,13 @@ static void wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	u8 hlid = 0;
 
 	mapping = skb_get_queue_mapping(skb);
 	q = wl1271_tx_get_queue(mapping);
 
 	if (wl->bss_type == BSS_TYPE_AP_BSS)
-		hlid = wl1271_tx_get_hlid(skb);
+		hlid = wl1271_tx_get_hlid(wl, skb);
 
 	spin_lock_irqsave(&wl->wl_lock, flags);
 
 	wl->tx_queue_count[q]++;
 
 	/*
@@ -2047,12 +2047,15 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 	wl->sched_scanning = false;
 	wl->role_id = WL1271_INVALID_ROLE_ID;
 	wl->dev_role_id = WL1271_INVALID_ROLE_ID;
 	memset(wl->roles_map, 0, sizeof(wl->roles_map));
 	memset(wl->links_map, 0, sizeof(wl->links_map));
 
+	/* The system link is always allocated */
+	__set_bit(WL1271_SYSTEM_HLID, wl->links_map);
+
 	/*
 	 * this is performed after the cancel_work calls and the associated
 	 * mutex_lock, so that wl1271_op_add_interface does not accidentally
 	 * get executed before all these vars have been reset.
 	 */
 	wl->flags = 0;
@@ -4385,20 +4388,26 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->quirks = 0;
 	wl->platform_quirks = 0;
 	wl->sched_scanning = false;
 	wl->tx_security_seq = 0;
 	wl->tx_security_last_seq_lsb = 0;
 	wl->role_id = WL1271_INVALID_ROLE_ID;
+	wl->system_hlid = WL1271_SYSTEM_HLID;
 	wl->sta_hlid = WL1271_INVALID_LINK_ID;
 	wl->dev_role_id = WL1271_INVALID_ROLE_ID;
 	wl->dev_hlid = WL1271_INVALID_LINK_ID;
 	setup_timer(&wl->rx_streaming_timer, wl1271_rx_streaming_timer,
 		    (unsigned long) wl);
 	wl->fwlog_size = 0;
 	init_waitqueue_head(&wl->fwlog_waitq);
 
+	memset(wl->links_map, 0, sizeof(wl->links_map));
+
+	/* The system link is always allocated */
+	__set_bit(WL1271_SYSTEM_HLID, wl->links_map);
+
 	memset(wl->tx_frames_map, 0, sizeof(wl->tx_frames_map));
 	for (i = 0; i < ACX_TX_DESCRIPTORS; i++)
 		wl->tx_frames[i] = NULL;
 
 	spin_lock_init(&wl->wl_lock);
 
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 2b17692..6a9be77 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -129,25 +129,28 @@ static void wl1271_tx_regulate_link(struct wl1271 *wl, u8 hlid)
 	 */
 	if (fw_ps && tx_blks >= WL1271_PS_STA_MAX_BLOCKS)
 		wl1271_ps_link_start(wl, hlid, true);
 }
 #endif
 
-u8 wl1271_tx_get_hlid(struct sk_buff *skb)
+u8 wl1271_tx_get_hlid(struct wl1271 *wl, struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *control = IEEE80211_SKB_CB(skb);
 
 	if (control->control.sta) {
 		struct wl1271_station *wl_sta;
 
 		wl_sta = (struct wl1271_station *)
 				control->control.sta->drv_priv;
 		return wl_sta->hlid;
 	} else {
 		struct ieee80211_hdr *hdr;
 
+		if (!test_bit(WL1271_FLAG_AP_STARTED, &wl->flags))
+			return wl->system_hlid;
+
 		hdr = (struct ieee80211_hdr *)skb->data;
 		if (ieee80211_is_mgmt(hdr->frame_control))
 			return WL1271_AP_GLOBAL_HLID;
 		else
 			return WL1271_AP_BROADCAST_HLID;
 	}
@@ -368,14 +371,16 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct sk_buff *skb,
 			if (ret < 0)
 				return ret;
 			wl->default_key = idx;
 		}
 	}
 
-	if (wl->bss_type == BSS_TYPE_AP_BSS)
-		hlid = wl1271_tx_get_hlid(skb);
+	if (wl12xx_is_dummy_packet(wl, skb))
+		hlid = wl->system_hlid;
+	else if (wl->bss_type == BSS_TYPE_AP_BSS)
+		hlid = wl1271_tx_get_hlid(wl, skb);
 	else
 		if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags))
 			hlid = wl->sta_hlid;
 		else
 			hlid = wl->dev_hlid;
 
@@ -561,13 +566,13 @@ static void wl1271_skb_queue_head(struct wl1271 *wl, struct sk_buff *skb)
 	unsigned long flags;
 	int q = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
 
 	if (wl12xx_is_dummy_packet(wl, skb)) {
 		set_bit(WL1271_FLAG_DUMMY_PACKET_PENDING, &wl->flags);
 	} else if (wl->bss_type == BSS_TYPE_AP_BSS) {
-		u8 hlid = wl1271_tx_get_hlid(skb);
+		u8 hlid = wl1271_tx_get_hlid(wl, skb);
 		skb_queue_head(&wl->links[hlid].tx_queue[q], skb);
 
 		/* make sure we dequeue the same packet next time */
 		wl->last_tx_hlid = (hlid + AP_MAX_LINKS - 1) % AP_MAX_LINKS;
 	} else {
 		skb_queue_head(&wl->tx_queue[q], skb);
diff --git a/drivers/net/wireless/wl12xx/tx.h b/drivers/net/wireless/wl12xx/tx.h
index b712d7b..62f55f6 100644
--- a/drivers/net/wireless/wl12xx/tx.h
+++ b/drivers/net/wireless/wl12xx/tx.h
@@ -207,11 +207,11 @@ void wl1271_tx_work_locked(struct wl1271 *wl);
 void wl1271_tx_complete(struct wl1271 *wl);
 void wl1271_tx_reset(struct wl1271 *wl, bool reset_tx_queues);
 void wl1271_tx_flush(struct wl1271 *wl);
 u8 wl1271_rate_to_idx(int rate, enum ieee80211_band band);
 u32 wl1271_tx_enabled_rates_get(struct wl1271 *wl, u32 rate_set);
 u32 wl1271_tx_min_rate_get(struct wl1271 *wl);
-u8 wl1271_tx_get_hlid(struct sk_buff *skb);
+u8 wl1271_tx_get_hlid(struct wl1271 *wl, struct sk_buff *skb);
 void wl1271_tx_reset_link_queues(struct wl1271 *wl, u8 hlid);
 void wl1271_handle_tx_low_watermark(struct wl1271 *wl);
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index a732932..9c5daae 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -138,12 +138,13 @@ extern u32 wl12xx_debug_level;
 #define WL1271_DEFAULT_DTIM_PERIOD 1
 
 #define WL1271_MAX_ROLES           4
 #define WL1271_MAX_LINKS           8
 #define WL1271_INVALID_ROLE_ID     0xff
 #define WL1271_INVALID_LINK_ID     0xff
+#define WL1271_SYSTEM_HLID         0
 #define WL1271_AP_GLOBAL_HLID      0
 #define WL1271_AP_BROADCAST_HLID   1
 #define WL1271_AP_STA_HLID_START   2
 
 /*
  * When in AP-mode, we allow (at least) this number of mem-blocks
@@ -392,12 +393,13 @@ struct wl1271 {
 	u8 set_bss_type;
 	u8 ssid[IW_ESSID_MAX_SIZE + 1];
 	u8 ssid_len;
 	int channel;
 	u8 role_id;
 	u8 dev_role_id;
+	u8 system_hlid;
 	u8 sta_hlid;
 	u8 dev_hlid;
 
 	unsigned long links_map[BITS_TO_LONGS(WL1271_MAX_LINKS)];
 	unsigned long roles_map[BITS_TO_LONGS(WL1271_MAX_ROLES)];
 
-- 
1.7.6.401.g6a319

