Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65029 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab1HNKRq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 06:17:46 -0400
Received: by mail-wy0-f174.google.com with SMTP id 24so2967085wyg.19
        for <linux-wireless@vger.kernel.org>; Sun, 14 Aug 2011 03:17:45 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 22/40] wl12xx: use dynamic hlids for AP-mode
Date: Sun, 14 Aug 2011 13:17:21 +0300
Message-Id: <1313317059-16567-23-git-send-email-eliad@wizery.com> (sfid-20110814_121750_189261_E100296C)
In-Reply-To: <1313317059-16567-1-git-send-email-eliad@wizery.com>
References: <1313317059-16567-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Using hlid=0 in AP mode is a bug. Dynamically allocate HLIDs.

Set the "first sta hlid" as 3. This will have to be changed
when multiple vifs will be supported.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v2: remove whitespace

 drivers/net/wireless/wl12xx/cmd.c    |   27 +++++++++++++++++++++++----
 drivers/net/wireless/wl12xx/main.c   |    9 +++++++--
 drivers/net/wireless/wl12xx/tx.c     |   17 ++++++-----------
 drivers/net/wireless/wl12xx/wl12xx.h |   13 ++++++++++---
 4 files changed, 46 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 7c5d738..025fb14 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -679,17 +679,25 @@ int wl12xx_cmd_role_start_ap(struct wl1271 *wl)
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (!cmd) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
+	ret = wl12xx_allocate_link(wl, &wl->ap_global_hlid);
+	if (ret < 0)
+		goto out_free;
+
+	ret = wl12xx_allocate_link(wl, &wl->ap_bcast_hlid);
+	if (ret < 0)
+		goto out_free_global;
+
 	cmd->role_id = wl->role_id;
 	cmd->ap.aging_period = cpu_to_le16(wl->conf.tx.ap_aging_period);
 	cmd->ap.bss_index = WL1271_AP_BSS_INDEX;
-	cmd->ap.global_hlid = WL1271_AP_GLOBAL_HLID;
-	cmd->ap.broadcast_hlid = WL1271_AP_BROADCAST_HLID;
+	cmd->ap.global_hlid = wl->ap_global_hlid;
+	cmd->ap.broadcast_hlid = wl->ap_bcast_hlid;
 	cmd->ap.basic_rate_set = cpu_to_le32(wl->basic_rate_set);
 	cmd->ap.beacon_interval = cpu_to_le16(wl->beacon_int);
 	cmd->ap.dtim_interval = bss_conf->dtim_period;
 	cmd->ap.beacon_expiry = WL1271_AP_DEF_BEACON_EXP;
 	cmd->channel = wl->channel;
 	cmd->ap.ssid_len = wl->ssid_len;
@@ -710,15 +718,23 @@ int wl12xx_cmd_role_start_ap(struct wl1271 *wl)
 		break;
 	}
 
 	ret = wl1271_cmd_send(wl, CMD_ROLE_START, cmd, sizeof(*cmd), 0);
 	if (ret < 0) {
 		wl1271_error("failed to initiate cmd role start ap");
-		goto out_free;
+		goto out_free_bcast;
 	}
 
+	goto out_free;
+
+out_free_bcast:
+	wl12xx_free_link(wl, &wl->ap_bcast_hlid);
+
+out_free_global:
+	wl12xx_free_link(wl, &wl->ap_global_hlid);
+
 out_free:
 	kfree(cmd);
 
 out:
 	return ret;
 }
@@ -741,12 +757,15 @@ int wl12xx_cmd_role_stop_ap(struct wl1271 *wl)
 	ret = wl1271_cmd_send(wl, CMD_ROLE_STOP, cmd, sizeof(*cmd), 0);
 	if (ret < 0) {
 		wl1271_error("failed to initiate cmd role stop ap");
 		goto out_free;
 	}
 
+	wl12xx_free_link(wl, &wl->ap_bcast_hlid);
+	wl12xx_free_link(wl, &wl->ap_global_hlid);
+
 out_free:
 	kfree(cmd);
 
 out:
 	return ret;
 }
@@ -1250,13 +1269,13 @@ int wl1271_cmd_set_ap_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
 	u8 lid_type;
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (!cmd)
 		return -ENOMEM;
 
-	if (hlid == WL1271_AP_BROADCAST_HLID) {
+	if (hlid == wl->ap_bcast_hlid) {
 		if (key_type == KEY_WEP)
 			lid_type = WEP_DEFAULT_LID_TYPE;
 		else
 			lid_type = BROADCAST_LID_TYPE;
 	} else {
 		lid_type = UNICAST_LID_TYPE;
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 157c462..ea150b5 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1969,14 +1969,17 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 		if (ret < 0)
 			goto deinit;
 
 		wl1271_ps_elp_sleep(wl);
 	}
 deinit:
+	/* clear all hlids (except system_hlid) */
 	wl->sta_hlid = WL12XX_INVALID_LINK_ID;
 	wl->dev_hlid = WL12XX_INVALID_LINK_ID;
+	wl->ap_bcast_hlid = WL12XX_INVALID_LINK_ID;
+	wl->ap_global_hlid = WL12XX_INVALID_LINK_ID;
 
 	/*
 	 * this must be before the cancel_work calls below, so that the work
 	 * functions don't perform further work.
 	 */
 	wl->state = WL1271_STATE_OFF;
@@ -2535,13 +2538,13 @@ static int wl1271_ap_init_hwenc(struct wl1271 *wl)
 		if (key->key_type == KEY_WEP)
 			wep_key_added = true;
 	}
 
 	if (wep_key_added) {
 		ret = wl12xx_cmd_set_default_wep_key(wl, wl->default_key,
-						     WL1271_AP_BROADCAST_HLID);
+						     wl->ap_bcast_hlid);
 		if (ret < 0)
 			goto out;
 	}
 
 out:
 	wl1271_free_ap_keys(wl);
@@ -2560,13 +2563,13 @@ static int wl1271_set_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
 		u8 hlid;
 
 		if (sta) {
 			wl_sta = (struct wl1271_station *)sta->drv_priv;
 			hlid = wl_sta->hlid;
 		} else {
-			hlid = WL1271_AP_BROADCAST_HLID;
+			hlid = wl->ap_bcast_hlid;
 		}
 
 		if (!test_bit(WL1271_FLAG_AP_STARTED, &wl->flags)) {
 			/*
 			 * We do not support removing keys after AP shutdown.
 			 * Pretend we do to make mac80211 happy.
@@ -4446,12 +4449,14 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->role_id = WL12XX_INVALID_ROLE_ID;
 	wl->system_hlid = WL12XX_SYSTEM_HLID;
 	wl->sta_hlid = WL12XX_INVALID_LINK_ID;
 	wl->dev_role_id = WL12XX_INVALID_ROLE_ID;
 	wl->dev_hlid = WL12XX_INVALID_LINK_ID;
 	wl->session_counter = 0;
+	wl->ap_bcast_hlid = WL12XX_INVALID_LINK_ID;
+	wl->ap_global_hlid = WL12XX_INVALID_LINK_ID;
 	setup_timer(&wl->rx_streaming_timer, wl1271_rx_streaming_timer,
 		    (unsigned long) wl);
 	wl->fwlog_size = 0;
 	init_waitqueue_head(&wl->fwlog_waitq);
 
 	/* The system link is always allocated */
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 057db6f..1240f40 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -35,13 +35,13 @@ static int wl1271_set_default_wep_key(struct wl1271 *wl, u8 id)
 {
 	int ret;
 	bool is_ap = (wl->bss_type == BSS_TYPE_AP_BSS);
 
 	if (is_ap)
 		ret = wl12xx_cmd_set_default_wep_key(wl, id,
-						     WL1271_AP_BROADCAST_HLID);
+						     wl->ap_bcast_hlid);
 	else
 		ret = wl12xx_cmd_set_default_wep_key(wl, id, wl->sta_hlid);
 
 	if (ret < 0)
 		return ret;
 
@@ -165,15 +165,15 @@ u8 wl12xx_tx_get_hlid_ap(struct wl1271 *wl, struct sk_buff *skb)
 
 		if (!test_bit(WL1271_FLAG_AP_STARTED, &wl->flags))
 			return wl->system_hlid;
 
 		hdr = (struct ieee80211_hdr *)skb->data;
 		if (ieee80211_is_mgmt(hdr->frame_control))
-			return WL1271_AP_GLOBAL_HLID;
+			return wl->ap_global_hlid;
 		else
-			return WL1271_AP_BROADCAST_HLID;
+			return wl->ap_bcast_hlid;
 	}
 }
 
 static u8 wl1271_tx_get_hlid(struct wl1271 *wl, struct sk_buff *skb)
 {
 	if (wl12xx_is_dummy_packet(wl, skb))
@@ -314,23 +314,18 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct sk_buff *skb,
 		   basic rates */
 		if (control->control.sta)
 			rate_idx = ACX_TX_AP_FULL_RATE;
 		else
 			rate_idx = ACX_TX_BASIC_RATE;
 	} else {
-		switch (hlid) {
-		case WL1271_AP_GLOBAL_HLID:
+		if (hlid == wl->ap_global_hlid)
 			rate_idx = ACX_TX_AP_MODE_MGMT_RATE;
-			break;
-		case WL1271_AP_BROADCAST_HLID:
+		else if (hlid == wl->ap_bcast_hlid)
 			rate_idx = ACX_TX_AP_MODE_BCST_RATE;
-			break;
-		default:
+		else
 			rate_idx = ac;
-			break;
-		}
 	}
 
 	tx_attr |= rate_idx << TX_HW_ATTR_OFST_RATE_POLICY;
 	desc->reserved = 0;
 
 	aligned_len = wl12xx_calc_packet_alignment(wl, skb->len);
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index a136795..1313dc5 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -138,16 +138,21 @@ extern u32 wl12xx_debug_level;
 #define WL1271_DEFAULT_DTIM_PERIOD 1
 
 #define WL12XX_MAX_ROLES           4
 #define WL12XX_MAX_LINKS           8
 #define WL12XX_INVALID_ROLE_ID     0xff
 #define WL12XX_INVALID_LINK_ID     0xff
+
+/* Defined by FW as 0. Will not be freed or allocated. */
 #define WL12XX_SYSTEM_HLID         0
-#define WL1271_AP_GLOBAL_HLID      0
-#define WL1271_AP_BROADCAST_HLID   1
-#define WL1271_AP_STA_HLID_START   2
+
+/*
+ * TODO: we currently don't support multirole. remove
+ * this constant from the code when we do.
+ */
+#define WL1271_AP_STA_HLID_START   3
 
 /*
  * When in AP-mode, we allow (at least) this number of mem-blocks
  * to be transmitted to FW for a STA in PS-mode. Only when packets are
  * present in the FW buffers it will wake the sleeping STA. We want to put
  * enough packets for the driver to transmit all of its buffered data before
@@ -395,12 +400,14 @@ struct wl1271 {
 	int channel;
 	u8 role_id;
 	u8 dev_role_id;
 	u8 system_hlid;
 	u8 sta_hlid;
 	u8 dev_hlid;
+	u8 ap_global_hlid;
+	u8 ap_bcast_hlid;
 
 	unsigned long links_map[BITS_TO_LONGS(WL12XX_MAX_LINKS)];
 	unsigned long roles_map[BITS_TO_LONGS(WL12XX_MAX_ROLES)];
 	unsigned long roc_map[BITS_TO_LONGS(WL12XX_MAX_ROLES)];
 
 	struct wl1271_acx_mem_map *target_mem_map;
-- 
1.7.6.401.g6a319

