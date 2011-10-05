Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41414 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934241Ab1JEJ4K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 05:56:10 -0400
Received: by mail-bw0-f46.google.com with SMTP id zt4so1903568bkb.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2011 02:56:10 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 16/29] wl12xx: move sta_hlid into wlvif
Date: Wed,  5 Oct 2011 11:55:53 +0200
Message-Id: <1317808566-18857-17-git-send-email-eliad@wizery.com> (sfid-20111005_115614_214961_8A3784DC)
In-Reply-To: <1317808566-18857-1-git-send-email-eliad@wizery.com>
References: <1317808566-18857-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

move sta_hlid into the per-interface data, rather than
being global.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c    |   28 +++++++++++++++-------------
 drivers/net/wireless/wl12xx/cmd.h    |    3 ++-
 drivers/net/wireless/wl12xx/main.c   |   18 +++++++++---------
 drivers/net/wireless/wl12xx/tx.c     |    4 ++--
 drivers/net/wireless/wl12xx/wl12xx.h |    7 ++++++-
 5 files changed, 34 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 5b7b37a..67ee9e3 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -581,12 +581,12 @@ int wl12xx_cmd_role_start_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	memcpy(cmd->sta.bssid, vif->bss_conf.bssid, ETH_ALEN);
 	cmd->sta.local_rates = cpu_to_le32(wlvif->rate_set);
 
-	if (wl->sta_hlid == WL12XX_INVALID_LINK_ID) {
-		ret = wl12xx_allocate_link(wl, &wl->sta_hlid);
+	if (wlvif->sta.hlid == WL12XX_INVALID_LINK_ID) {
+		ret = wl12xx_allocate_link(wl, &wlvif->sta.hlid);
 		if (ret)
 			goto out_free;
 	}
-	cmd->sta.hlid = wl->sta_hlid;
+	cmd->sta.hlid = wlvif->sta.hlid;
 	cmd->sta.session = wl12xx_get_new_session_id(wl);
 	cmd->sta.remote_rates = cpu_to_le32(wlvif->rate_set);
 
@@ -605,7 +605,7 @@ int wl12xx_cmd_role_start_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 
 err_hlid:
 	/* clear links on error. */
-	wl12xx_free_link(wl, &wl->sta_hlid);
+	wl12xx_free_link(wl, &wlvif->sta.hlid);
 
 out_free:
 	kfree(cmd);
@@ -620,7 +620,7 @@ int wl12xx_cmd_role_stop_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	struct wl12xx_cmd_role_stop *cmd;
 	int ret;
 
-	if (WARN_ON(wl->sta_hlid == WL12XX_INVALID_LINK_ID))
+	if (WARN_ON(wlvif->sta.hlid == WL12XX_INVALID_LINK_ID))
 		return -EINVAL;
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
@@ -641,7 +641,7 @@ int wl12xx_cmd_role_stop_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 		goto out_free;
 	}
 
-	wl12xx_free_link(wl, &wl->sta_hlid);
+	wl12xx_free_link(wl, &wlvif->sta.hlid);
 
 out_free:
 	kfree(cmd);
@@ -796,12 +796,12 @@ int wl12xx_cmd_role_start_ibss(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	memcpy(cmd->ibss.bssid, vif->bss_conf.bssid, ETH_ALEN);
 	cmd->sta.local_rates = cpu_to_le32(wlvif->rate_set);
 
-	if (wl->sta_hlid == WL12XX_INVALID_LINK_ID) {
-		ret = wl12xx_allocate_link(wl, &wl->sta_hlid);
+	if (wlvif->sta.hlid == WL12XX_INVALID_LINK_ID) {
+		ret = wl12xx_allocate_link(wl, &wlvif->sta.hlid);
 		if (ret)
 			goto out_free;
 	}
-	cmd->ibss.hlid = wl->sta_hlid;
+	cmd->ibss.hlid = wlvif->sta.hlid;
 	cmd->ibss.remote_rates = cpu_to_le32(wlvif->rate_set);
 
 	wl1271_debug(DEBUG_CMD, "role start: roleid=%d, hlid=%d, session=%d "
@@ -822,7 +822,7 @@ int wl12xx_cmd_role_start_ibss(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 
 err_hlid:
 	/* clear links on error. */
-	wl12xx_free_link(wl, &wl->sta_hlid);
+	wl12xx_free_link(wl, &wlvif->sta.hlid);
 
 out_free:
 	kfree(cmd);
@@ -1264,15 +1264,17 @@ out:
 	return ret;
 }
 
-int wl1271_cmd_set_sta_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
+int wl1271_cmd_set_sta_key(struct wl1271 *wl, struct ieee80211_vif *vif,
+		       u16 action, u8 id, u8 key_type,
 		       u8 key_size, const u8 *key, const u8 *addr,
 		       u32 tx_seq_32, u16 tx_seq_16)
 {
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	struct wl1271_cmd_set_keys *cmd;
 	int ret = 0;
 
 	/* hlid might have already been deleted */
-	if (wl->sta_hlid == WL12XX_INVALID_LINK_ID)
+	if (wlvif->sta.hlid == WL12XX_INVALID_LINK_ID)
 		return 0;
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
@@ -1281,7 +1283,7 @@ int wl1271_cmd_set_sta_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
 		goto out;
 	}
 
-	cmd->hlid = wl->sta_hlid;
+	cmd->hlid = wlvif->sta.hlid;
 
 	if (key_type == KEY_WEP)
 		cmd->lid_key_type = WEP_DEFAULT_LID_TYPE;
diff --git a/drivers/net/wireless/wl12xx/cmd.h b/drivers/net/wireless/wl12xx/cmd.h
index f7c74dc..62904c5 100644
--- a/drivers/net/wireless/wl12xx/cmd.h
+++ b/drivers/net/wireless/wl12xx/cmd.h
@@ -70,7 +70,8 @@ int wl1271_build_qos_null_data(struct wl1271 *wl, struct ieee80211_vif *vif);
 int wl12xx_cmd_build_klv_null_data(struct wl1271 *wl,
 				   struct wl12xx_vif *wlvif);
 int wl12xx_cmd_set_default_wep_key(struct wl1271 *wl, u8 id, u8 hlid);
-int wl1271_cmd_set_sta_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
+int wl1271_cmd_set_sta_key(struct wl1271 *wl, struct ieee80211_vif *vif,
+			   u16 action, u8 id, u8 key_type,
 			   u8 key_size, const u8 *key, const u8 *addr,
 			   u32 tx_seq_32, u16 tx_seq_16);
 int wl1271_cmd_set_ap_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 9a7c94f..6ecb372 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -412,7 +412,7 @@ static int wl1271_check_operstate(struct wl1271 *wl, unsigned char operstate)
 	if (test_and_set_bit(WL1271_FLAG_STA_STATE_SENT, &wl->flags))
 		return 0;
 
-	ret = wl12xx_cmd_set_peer_state(wl, wl->sta_hlid);
+	ret = wl12xx_cmd_set_peer_state(wl, wlvif->sta.hlid);
 	if (ret < 0)
 		return ret;
 
@@ -1858,6 +1858,7 @@ static void wl12xx_init_vif_data(struct wl12xx_vif *wlvif)
 	wlvif->bss_type = MAX_BSS_TYPE;
 	wlvif->role_id = WL12XX_INVALID_ROLE_ID;
 	wlvif->dev_role_id = WL12XX_INVALID_ROLE_ID;
+	wlvif->sta.hlid = WL12XX_INVALID_LINK_ID;
 	wlvif->basic_rate_set = CONF_TX_RATE_MASK_BASIC;
 	wlvif->basic_rate = CONF_TX_RATE_MASK_BASIC;
 	wlvif->rate_set = CONF_TX_RATE_MASK_BASIC;
@@ -2081,7 +2082,7 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 	}
 deinit:
 	/* clear all hlids (except system_hlid) */
-	wl->sta_hlid = WL12XX_INVALID_LINK_ID;
+	wlvif->sta.hlid = WL12XX_INVALID_LINK_ID;
 	wl->dev_hlid = WL12XX_INVALID_LINK_ID;
 	wl->ap_bcast_hlid = WL12XX_INVALID_LINK_ID;
 	wl->ap_global_hlid = WL12XX_INVALID_LINK_ID;
@@ -2760,10 +2761,10 @@ static int wl1271_set_key(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 
 		/* don't remove key if hlid was already deleted */
 		if (action == KEY_REMOVE &&
-		    wl->sta_hlid == WL12XX_INVALID_LINK_ID)
+		    wlvif->sta.hlid == WL12XX_INVALID_LINK_ID)
 			return 0;
 
-		ret = wl1271_cmd_set_sta_key(wl, action,
+		ret = wl1271_cmd_set_sta_key(wl, vif, action,
 					     id, key_type, key_size,
 					     key, addr, tx_seq_32,
 					     tx_seq_16);
@@ -2774,7 +2775,7 @@ static int wl1271_set_key(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		if (key_type == KEY_WEP) {
 			ret = wl12xx_cmd_set_default_wep_key(wl,
 							     wl->default_key,
-							     wl->sta_hlid);
+							     wlvif->sta.hlid);
 			if (ret < 0)
 				return ret;
 		}
@@ -3726,7 +3727,7 @@ sta_not_found:
 			ret = wl1271_acx_set_ht_capabilities(wl,
 							     &sta_ht_cap,
 							     true,
-							     wl->sta_hlid);
+							     wlvif->sta.hlid);
 			if (ret < 0) {
 				wl1271_warning("Set ht cap true failed %d",
 					       ret);
@@ -3738,7 +3739,7 @@ sta_not_found:
 			ret = wl1271_acx_set_ht_capabilities(wl,
 							     &sta_ht_cap,
 							     false,
-							     wl->sta_hlid);
+							     wlvif->sta.hlid);
 			if (ret < 0) {
 				wl1271_warning("Set ht cap false failed %d",
 					       ret);
@@ -4074,7 +4075,7 @@ static int wl1271_op_ampdu_action(struct ieee80211_hw *hw,
 	}
 
 	if (wlvif->bss_type == BSS_TYPE_STA_BSS) {
-		hlid = wl->sta_hlid;
+		hlid = wlvif->sta.hlid;
 		ba_bitmap = &wl->ba_rx_bitmap;
 	} else if (wlvif->bss_type == BSS_TYPE_AP_BSS) {
 		struct wl1271_station *wl_sta;
@@ -4847,7 +4848,6 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->tx_security_last_seq_lsb = 0;
 	wl->tx_spare_blocks = TX_HW_BLOCK_SPARE_DEFAULT;
 	wl->system_hlid = WL12XX_SYSTEM_HLID;
-	wl->sta_hlid = WL12XX_INVALID_LINK_ID;
 	wl->dev_hlid = WL12XX_INVALID_LINK_ID;
 	wl->session_counter = 0;
 	wl->ap_bcast_hlid = WL12XX_INVALID_LINK_ID;
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 538d861..db55767 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -42,7 +42,7 @@ static int wl1271_set_default_wep_key(struct wl1271 *wl,
 		ret = wl12xx_cmd_set_default_wep_key(wl, id,
 						     wl->ap_bcast_hlid);
 	else
-		ret = wl12xx_cmd_set_default_wep_key(wl, id, wl->sta_hlid);
+		ret = wl12xx_cmd_set_default_wep_key(wl, id, wlvif->sta.hlid);
 
 	if (ret < 0)
 		return ret;
@@ -199,7 +199,7 @@ static u8 wl1271_tx_get_hlid(struct wl1271 *wl, struct ieee80211_vif *vif,
 	     test_bit(WL1271_FLAG_IBSS_JOINED, &wl->flags)) &&
 	    !ieee80211_is_auth(hdr->frame_control) &&
 	    !ieee80211_is_assoc_req(hdr->frame_control))
-		return wl->sta_hlid;
+		return wlvif->sta.hlid;
 	else
 		return wl->dev_hlid;
 }
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 32fecae..a07b55f 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -401,7 +401,6 @@ struct wl1271 {
 	u8 mac_addr[ETH_ALEN];
 	int channel;
 	u8 system_hlid;
-	u8 sta_hlid;
 	u8 dev_hlid;
 	u8 ap_global_hlid;
 	u8 ap_bcast_hlid;
@@ -623,6 +622,12 @@ struct wl12xx_vif {
 	/* sta/ibss specific */
 	u8 dev_role_id;
 
+	union {
+		struct {
+			u8 hlid;
+		} sta;
+	};
+
 	u8 ssid[IEEE80211_MAX_SSID_LEN + 1];
 	u8 ssid_len;
 
-- 
1.7.6.401.g6a319

