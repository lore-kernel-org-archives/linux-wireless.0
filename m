Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35975 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934289Ab1JEJ4M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 05:56:12 -0400
Received: by mail-ey0-f174.google.com with SMTP id 28so1405752eya.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2011 02:56:11 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 17/29] wl12xx: move ap_global_hlid and ap_bcast_hlid into wlvif
Date: Wed,  5 Oct 2011 11:55:54 +0200
Message-Id: <1317808566-18857-18-git-send-email-eliad@wizery.com> (sfid-20111005_115616_803678_1B580188)
In-Reply-To: <1317808566-18857-1-git-send-email-eliad@wizery.com>
References: <1317808566-18857-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

move ap_global_hlid and ap_bcast_hlid into the per-interface
data, rather than being global.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c    |   28 ++++++++++++++--------------
 drivers/net/wireless/wl12xx/cmd.h    |    5 +++--
 drivers/net/wireless/wl12xx/main.c   |   34 +++++++++++++++++++---------------
 drivers/net/wireless/wl12xx/tx.c     |   15 ++++++++-------
 drivers/net/wireless/wl12xx/tx.h     |    3 ++-
 drivers/net/wireless/wl12xx/wl12xx.h |    6 ++++--
 6 files changed, 50 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 67ee9e3..e6e3717 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -671,19 +671,19 @@ int wl12xx_cmd_role_start_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 		goto out;
 	}
 
-	ret = wl12xx_allocate_link(wl, &wl->ap_global_hlid);
+	ret = wl12xx_allocate_link(wl, &wlvif->ap.global_hlid);
 	if (ret < 0)
 		goto out_free;
 
-	ret = wl12xx_allocate_link(wl, &wl->ap_bcast_hlid);
+	ret = wl12xx_allocate_link(wl, &wlvif->ap.bcast_hlid);
 	if (ret < 0)
 		goto out_free_global;
 
 	cmd->role_id = wlvif->role_id;
 	cmd->ap.aging_period = cpu_to_le16(wl->conf.tx.ap_aging_period);
 	cmd->ap.bss_index = WL1271_AP_BSS_INDEX;
-	cmd->ap.global_hlid = wl->ap_global_hlid;
-	cmd->ap.broadcast_hlid = wl->ap_bcast_hlid;
+	cmd->ap.global_hlid = wlvif->ap.global_hlid;
+	cmd->ap.broadcast_hlid = wlvif->ap.bcast_hlid;
 	cmd->ap.basic_rate_set = cpu_to_le32(wlvif->basic_rate_set);
 	cmd->ap.beacon_interval = cpu_to_le16(wl->beacon_int);
 	cmd->ap.dtim_interval = bss_conf->dtim_period;
@@ -725,10 +725,10 @@ int wl12xx_cmd_role_start_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	goto out_free;
 
 out_free_bcast:
-	wl12xx_free_link(wl, &wl->ap_bcast_hlid);
+	wl12xx_free_link(wl, &wlvif->ap.bcast_hlid);
 
 out_free_global:
-	wl12xx_free_link(wl, &wl->ap_global_hlid);
+	wl12xx_free_link(wl, &wlvif->ap.global_hlid);
 
 out_free:
 	kfree(cmd);
@@ -758,8 +758,8 @@ int wl12xx_cmd_role_stop_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 		goto out_free;
 	}
 
-	wl12xx_free_link(wl, &wl->ap_bcast_hlid);
-	wl12xx_free_link(wl, &wl->ap_global_hlid);
+	wl12xx_free_link(wl, &wlvif->ap.bcast_hlid);
+	wl12xx_free_link(wl, &wlvif->ap.global_hlid);
 
 out_free:
 	kfree(cmd);
@@ -1264,12 +1264,11 @@ out:
 	return ret;
 }
 
-int wl1271_cmd_set_sta_key(struct wl1271 *wl, struct ieee80211_vif *vif,
+int wl1271_cmd_set_sta_key(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		       u16 action, u8 id, u8 key_type,
 		       u8 key_size, const u8 *key, const u8 *addr,
 		       u32 tx_seq_32, u16 tx_seq_16)
 {
-	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	struct wl1271_cmd_set_keys *cmd;
 	int ret = 0;
 
@@ -1334,9 +1333,10 @@ out:
  * TODO: merge with sta/ibss into 1 set_key function.
  * note there are slight diffs
  */
-int wl1271_cmd_set_ap_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
-			u8 key_size, const u8 *key, u8 hlid, u32 tx_seq_32,
-			u16 tx_seq_16)
+int wl1271_cmd_set_ap_key(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			  u16 action, u8 id, u8 key_type,
+			  u8 key_size, const u8 *key, u8 hlid, u32 tx_seq_32,
+			  u16 tx_seq_16)
 {
 	struct wl1271_cmd_set_keys *cmd;
 	int ret = 0;
@@ -1346,7 +1346,7 @@ int wl1271_cmd_set_ap_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
 	if (!cmd)
 		return -ENOMEM;
 
-	if (hlid == wl->ap_bcast_hlid) {
+	if (hlid == wlvif->ap.bcast_hlid) {
 		if (key_type == KEY_WEP)
 			lid_type = WEP_DEFAULT_LID_TYPE;
 		else
diff --git a/drivers/net/wireless/wl12xx/cmd.h b/drivers/net/wireless/wl12xx/cmd.h
index 62904c5..d1a88c4 100644
--- a/drivers/net/wireless/wl12xx/cmd.h
+++ b/drivers/net/wireless/wl12xx/cmd.h
@@ -70,11 +70,12 @@ int wl1271_build_qos_null_data(struct wl1271 *wl, struct ieee80211_vif *vif);
 int wl12xx_cmd_build_klv_null_data(struct wl1271 *wl,
 				   struct wl12xx_vif *wlvif);
 int wl12xx_cmd_set_default_wep_key(struct wl1271 *wl, u8 id, u8 hlid);
-int wl1271_cmd_set_sta_key(struct wl1271 *wl, struct ieee80211_vif *vif,
+int wl1271_cmd_set_sta_key(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			   u16 action, u8 id, u8 key_type,
 			   u8 key_size, const u8 *key, const u8 *addr,
 			   u32 tx_seq_32, u16 tx_seq_16);
-int wl1271_cmd_set_ap_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
+int wl1271_cmd_set_ap_key(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			  u16 action, u8 id, u8 key_type,
 			  u8 key_size, const u8 *key, u8 hlid, u32 tx_seq_32,
 			  u16 tx_seq_16);
 int wl12xx_cmd_set_peer_state(struct wl1271 *wl, u8 hlid);
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 6ecb372..f1358b3 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1488,8 +1488,9 @@ int wl1271_plt_stop(struct wl1271 *wl)
 static void wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct wl1271 *wl = hw->priv;
-	struct ieee80211_tx_info *control = IEEE80211_SKB_CB(skb);
-	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(control->control.vif);
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_vif *vif = info->control.vif;
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	unsigned long flags;
 	int q, mapping;
 	u8 hlid = 0;
@@ -1498,7 +1499,7 @@ static void wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	q = wl1271_tx_get_queue(mapping);
 
 	if (wlvif->bss_type == BSS_TYPE_AP_BSS)
-		hlid = wl12xx_tx_get_hlid_ap(wl, skb);
+		hlid = wl12xx_tx_get_hlid_ap(wl, wlvif, skb);
 
 	spin_lock_irqsave(&wl->wl_lock, flags);
 
@@ -1858,7 +1859,12 @@ static void wl12xx_init_vif_data(struct wl12xx_vif *wlvif)
 	wlvif->bss_type = MAX_BSS_TYPE;
 	wlvif->role_id = WL12XX_INVALID_ROLE_ID;
 	wlvif->dev_role_id = WL12XX_INVALID_ROLE_ID;
+
+	/* TODO: init union by type */
 	wlvif->sta.hlid = WL12XX_INVALID_LINK_ID;
+	wlvif->ap.bcast_hlid = WL12XX_INVALID_LINK_ID;
+	wlvif->ap.global_hlid = WL12XX_INVALID_LINK_ID;
+
 	wlvif->basic_rate_set = CONF_TX_RATE_MASK_BASIC;
 	wlvif->basic_rate = CONF_TX_RATE_MASK_BASIC;
 	wlvif->rate_set = CONF_TX_RATE_MASK_BASIC;
@@ -2084,8 +2090,8 @@ deinit:
 	/* clear all hlids (except system_hlid) */
 	wlvif->sta.hlid = WL12XX_INVALID_LINK_ID;
 	wl->dev_hlid = WL12XX_INVALID_LINK_ID;
-	wl->ap_bcast_hlid = WL12XX_INVALID_LINK_ID;
-	wl->ap_global_hlid = WL12XX_INVALID_LINK_ID;
+	wlvif->ap.bcast_hlid = WL12XX_INVALID_LINK_ID;
+	wlvif->ap.global_hlid = WL12XX_INVALID_LINK_ID;
 
 	/*
 	 * this must be before the cancel_work calls below, so that the work
@@ -2648,7 +2654,7 @@ static void wl1271_free_ap_keys(struct wl1271 *wl)
 	}
 }
 
-static int wl1271_ap_init_hwenc(struct wl1271 *wl)
+static int wl1271_ap_init_hwenc(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	int i, ret = 0;
 	struct wl1271_ap_key *key;
@@ -2662,9 +2668,9 @@ static int wl1271_ap_init_hwenc(struct wl1271 *wl)
 		key = wl->recorded_ap_keys[i];
 		hlid = key->hlid;
 		if (hlid == WL12XX_INVALID_LINK_ID)
-			hlid = wl->ap_bcast_hlid;
+			hlid = wlvif->ap.bcast_hlid;
 
-		ret = wl1271_cmd_set_ap_key(wl, KEY_ADD_OR_REPLACE,
+		ret = wl1271_cmd_set_ap_key(wl, wlvif, KEY_ADD_OR_REPLACE,
 					    key->id, key->key_type,
 					    key->key_size, key->key,
 					    hlid, key->tx_seq_32,
@@ -2678,7 +2684,7 @@ static int wl1271_ap_init_hwenc(struct wl1271 *wl)
 
 	if (wep_key_added) {
 		ret = wl12xx_cmd_set_default_wep_key(wl, wl->default_key,
-						     wl->ap_bcast_hlid);
+						     wlvif->ap.bcast_hlid);
 		if (ret < 0)
 			goto out;
 	}
@@ -2704,7 +2710,7 @@ static int wl1271_set_key(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			wl_sta = (struct wl1271_station *)sta->drv_priv;
 			hlid = wl_sta->hlid;
 		} else {
-			hlid = wl->ap_bcast_hlid;
+			hlid = wlvif->ap.bcast_hlid;
 		}
 
 		if (!test_bit(WL1271_FLAG_AP_STARTED, &wl->flags)) {
@@ -2720,7 +2726,7 @@ static int wl1271_set_key(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 					     key, hlid, tx_seq_32,
 					     tx_seq_16);
 		} else {
-			ret = wl1271_cmd_set_ap_key(wl, action,
+			ret = wl1271_cmd_set_ap_key(wl, wlvif, action,
 					     id, key_type, key_size,
 					     key, hlid, tx_seq_32,
 					     tx_seq_16);
@@ -2764,7 +2770,7 @@ static int wl1271_set_key(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		    wlvif->sta.hlid == WL12XX_INVALID_LINK_ID)
 			return 0;
 
-		ret = wl1271_cmd_set_sta_key(wl, vif, action,
+		ret = wl1271_cmd_set_sta_key(wl, wlvif, action,
 					     id, key_type, key_size,
 					     key, addr, tx_seq_32,
 					     tx_seq_16);
@@ -3370,7 +3376,7 @@ static void wl1271_bss_info_changed_ap(struct wl1271 *wl,
 				if (ret < 0)
 					goto out;
 
-				ret = wl1271_ap_init_hwenc(wl);
+				ret = wl1271_ap_init_hwenc(wl, wlvif);
 				if (ret < 0)
 					goto out;
 
@@ -4850,8 +4856,6 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->system_hlid = WL12XX_SYSTEM_HLID;
 	wl->dev_hlid = WL12XX_INVALID_LINK_ID;
 	wl->session_counter = 0;
-	wl->ap_bcast_hlid = WL12XX_INVALID_LINK_ID;
-	wl->ap_global_hlid = WL12XX_INVALID_LINK_ID;
 	wl->active_sta_count = 0;
 	setup_timer(&wl->rx_streaming_timer, wl1271_rx_streaming_timer,
 		    (unsigned long) wl);
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index db55767..53c6451 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -40,7 +40,7 @@ static int wl1271_set_default_wep_key(struct wl1271 *wl,
 
 	if (is_ap)
 		ret = wl12xx_cmd_set_default_wep_key(wl, id,
-						     wl->ap_bcast_hlid);
+						     wlvif->ap.bcast_hlid);
 	else
 		ret = wl12xx_cmd_set_default_wep_key(wl, id, wlvif->sta.hlid);
 
@@ -156,7 +156,8 @@ bool wl12xx_is_dummy_packet(struct wl1271 *wl, struct sk_buff *skb)
 	return wl->dummy_packet == skb;
 }
 
-u8 wl12xx_tx_get_hlid_ap(struct wl1271 *wl, struct sk_buff *skb)
+u8 wl12xx_tx_get_hlid_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			 struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *control = IEEE80211_SKB_CB(skb);
 
@@ -174,9 +175,9 @@ u8 wl12xx_tx_get_hlid_ap(struct wl1271 *wl, struct sk_buff *skb)
 
 		hdr = (struct ieee80211_hdr *)skb->data;
 		if (ieee80211_is_mgmt(hdr->frame_control))
-			return wl->ap_global_hlid;
+			return wlvif->ap.global_hlid;
 		else
-			return wl->ap_bcast_hlid;
+			return wlvif->ap.bcast_hlid;
 	}
 }
 
@@ -191,7 +192,7 @@ static u8 wl1271_tx_get_hlid(struct wl1271 *wl, struct ieee80211_vif *vif,
 		return wl->system_hlid;
 
 	if (wlvif->bss_type == BSS_TYPE_AP_BSS)
-		return wl12xx_tx_get_hlid_ap(wl, skb);
+		return wl12xx_tx_get_hlid_ap(wl, wlvif, skb);
 
 	wl1271_tx_update_filters(wl, wlvif, skb);
 
@@ -341,9 +342,9 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct ieee80211_vif *vif,
 		else
 			rate_idx = ACX_TX_BASIC_RATE;
 	} else {
-		if (hlid == wl->ap_global_hlid)
+		if (hlid == wlvif->ap.global_hlid)
 			rate_idx = ACX_TX_AP_MODE_MGMT_RATE;
-		else if (hlid == wl->ap_bcast_hlid)
+		else if (hlid == wlvif->ap.bcast_hlid)
 			rate_idx = ACX_TX_AP_MODE_BCST_RATE;
 		else
 			rate_idx = ac;
diff --git a/drivers/net/wireless/wl12xx/tx.h b/drivers/net/wireless/wl12xx/tx.h
index ba9403a..0964c93 100644
--- a/drivers/net/wireless/wl12xx/tx.h
+++ b/drivers/net/wireless/wl12xx/tx.h
@@ -212,7 +212,8 @@ u8 wl1271_rate_to_idx(int rate, enum ieee80211_band band);
 u32 wl1271_tx_enabled_rates_get(struct wl1271 *wl, u32 rate_set,
 				enum ieee80211_band rate_band);
 u32 wl1271_tx_min_rate_get(struct wl1271 *wl, u32 rate_set);
-u8 wl12xx_tx_get_hlid_ap(struct wl1271 *wl, struct sk_buff *skb);
+u8 wl12xx_tx_get_hlid_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			 struct sk_buff *skb);
 void wl1271_tx_reset_link_queues(struct wl1271 *wl, u8 hlid);
 void wl1271_handle_tx_low_watermark(struct wl1271 *wl);
 bool wl12xx_is_dummy_packet(struct wl1271 *wl, struct sk_buff *skb);
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index a07b55f..91d666f 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -402,8 +402,6 @@ struct wl1271 {
 	int channel;
 	u8 system_hlid;
 	u8 dev_hlid;
-	u8 ap_global_hlid;
-	u8 ap_bcast_hlid;
 
 	unsigned long links_map[BITS_TO_LONGS(WL12XX_MAX_LINKS)];
 	unsigned long roles_map[BITS_TO_LONGS(WL12XX_MAX_ROLES)];
@@ -626,6 +624,10 @@ struct wl12xx_vif {
 		struct {
 			u8 hlid;
 		} sta;
+		struct {
+			u8 global_hlid;
+			u8 bcast_hlid;
+		} ap;
 	};
 
 	u8 ssid[IEEE80211_MAX_SSID_LEN + 1];
-- 
1.7.6.401.g6a319

