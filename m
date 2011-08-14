Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36108 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab1HNKRV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 06:17:21 -0400
Received: by mail-ww0-f44.google.com with SMTP id 5so4060970wwf.1
        for <linux-wireless@vger.kernel.org>; Sun, 14 Aug 2011 03:17:20 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 08/40] wl12xx: update commands & events
Date: Sun, 14 Aug 2011 13:17:07 +0300
Message-Id: <1313317059-16567-9-git-send-email-eliad@wizery.com> (sfid-20110814_121726_099452_CC1FB5F9)
In-Reply-To: <1313317059-16567-1-git-send-email-eliad@wizery.com>
References: <1313317059-16567-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change the commands and events according to the new fw api
(fw >= 6/7.3.0.0.75).

The main change is the replacement of JOIN/DISCONNECT commands,
with ROLE_START/ROLE_STOP commands.

The use of these commands should be preceded by the ROLE_ENABLE
command (allocating role resources), and followed by the
ROLE_DISABLE command (freeing role resources).

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v2: unify event_mask, s/wl1271/wl12xx, improve debug prints
and ret values, etc.

 drivers/net/wireless/wl12xx/boot.c   |   17 +-
 drivers/net/wireless/wl12xx/cmd.c    |  515 ++++++++++++++++++++--------------
 drivers/net/wireless/wl12xx/cmd.h    |  314 +++++++++++----------
 drivers/net/wireless/wl12xx/event.c  |    4 +-
 drivers/net/wireless/wl12xx/event.h  |   80 ++----
 drivers/net/wireless/wl12xx/init.c   |    6 -
 drivers/net/wireless/wl12xx/main.c   |   26 +-
 drivers/net/wireless/wl12xx/tx.c     |    5 +-
 drivers/net/wireless/wl12xx/wl12xx.h |    5 +
 9 files changed, 527 insertions(+), 445 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index 41791ff..cc70422 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -491,27 +491,24 @@ static int wl1271_boot_run_firmware(struct wl1271 *wl)
 	 */
 
 	/* unmask required mbox events  */
 	wl->event_mask = BSS_LOSE_EVENT_ID |
 		SCAN_COMPLETE_EVENT_ID |
 		PS_REPORT_EVENT_ID |
-		JOIN_EVENT_COMPLETE_ID |
 		DISCONNECT_EVENT_COMPLETE_ID |
 		RSSI_SNR_TRIGGER_0_EVENT_ID |
 		PSPOLL_DELIVERY_FAILURE_EVENT_ID |
 		SOFT_GEMINI_SENSE_EVENT_ID |
 		PERIODIC_SCAN_REPORT_EVENT_ID |
-		PERIODIC_SCAN_COMPLETE_EVENT_ID;
-
-	if (wl->bss_type == BSS_TYPE_AP_BSS)
-		wl->event_mask |= STA_REMOVE_COMPLETE_EVENT_ID |
-				  INACTIVE_STA_EVENT_ID |
-				  MAX_TX_RETRY_EVENT_ID;
-	else
-		wl->event_mask |= DUMMY_PACKET_EVENT_ID |
-			BA_SESSION_RX_CONSTRAINT_EVENT_ID;
+		PERIODIC_SCAN_COMPLETE_EVENT_ID |
+		DUMMY_PACKET_EVENT_ID |
+		PEER_REMOVE_COMPLETE_EVENT_ID |
+		BA_SESSION_RX_CONSTRAINT_EVENT_ID |
+		REMAIN_ON_CHANNEL_COMPLETE_EVENT_ID |
+		INACTIVE_STA_EVENT_ID |
+		MAX_TX_RETRY_EVENT_ID;
 
 	ret = wl1271_event_unmask(wl);
 	if (ret < 0) {
 		wl1271_error("EVENT mask setting failed");
 		return ret;
 	}
diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index b6ef65a..b13eed1 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -360,67 +360,300 @@ static int wl1271_cmd_wait_for_event(struct wl1271 *wl, u32 mask)
 		return ret;
 	}
 
 	return 0;
 }
 
-int wl1271_cmd_join(struct wl1271 *wl, u8 bss_type)
+int wl12xx_cmd_role_enable(struct wl1271 *wl, u8 role_type, u8 *role_id)
 {
-	struct wl1271_cmd_join *join;
-	int ret, i;
-	u8 *bssid;
+	struct wl12xx_cmd_role_enable *cmd;
+	int ret;
+
+	wl1271_debug(DEBUG_CMD, "cmd role enable");
+
+	if (WARN_ON(*role_id != WL12XX_INVALID_ROLE_ID))
+		return -EBUSY;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* get role id */
+	cmd->role_id = find_first_zero_bit(wl->roles_map, WL12XX_MAX_ROLES);
+	if (cmd->role_id >= WL12XX_MAX_ROLES) {
+		ret = -EBUSY;
+		goto out_free;
+	}
+
+	memcpy(cmd->mac_address, wl->mac_addr, ETH_ALEN);
+	cmd->role_type = role_type;
+
+	ret = wl1271_cmd_send(wl, CMD_ROLE_ENABLE, cmd, sizeof(*cmd), 0);
+	if (ret < 0) {
+		wl1271_error("failed to initiate cmd role enable");
+		goto out_free;
+	}
+
+	__set_bit(cmd->role_id, wl->roles_map);
+	*role_id = cmd->role_id;
 
-	join = kzalloc(sizeof(*join), GFP_KERNEL);
-	if (!join) {
+out_free:
+	kfree(cmd);
+
+out:
+	return ret;
+}
+
+int wl12xx_cmd_role_disable(struct wl1271 *wl, u8 *role_id)
+{
+	struct wl12xx_cmd_role_disable *cmd;
+	int ret;
+
+	wl1271_debug(DEBUG_CMD, "cmd role disable");
+
+	if (WARN_ON(*role_id == WL12XX_INVALID_ROLE_ID))
+		return -ENOENT;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
 		ret = -ENOMEM;
 		goto out;
 	}
+	cmd->role_id = *role_id;
+
+	ret = wl1271_cmd_send(wl, CMD_ROLE_DISABLE, cmd, sizeof(*cmd), 0);
+	if (ret < 0) {
+		wl1271_error("failed to initiate cmd role disable");
+		goto out_free;
+	}
 
-	wl1271_debug(DEBUG_CMD, "cmd join");
+	__clear_bit(*role_id, wl->roles_map);
+	*role_id = WL12XX_INVALID_ROLE_ID;
 
-	/* Reverse order BSSID */
-	bssid = (u8 *) &join->bssid_lsb;
-	for (i = 0; i < ETH_ALEN; i++)
-		bssid[i] = wl->bssid[ETH_ALEN - i - 1];
+out_free:
+	kfree(cmd);
+
+out:
+	return ret;
+}
+
+static int wl12xx_allocate_link(struct wl1271 *wl, u8 *hlid)
+{
+	u8 link = find_first_zero_bit(wl->links_map, WL12XX_MAX_LINKS);
+	if (link >= WL12XX_MAX_LINKS)
+		return -EBUSY;
+
+	__set_bit(link, wl->links_map);
+	*hlid = link;
+	return 0;
+}
+
+static void wl12xx_free_link(struct wl1271 *wl, u8 *hlid)
+{
+	if (*hlid == WL12XX_INVALID_LINK_ID)
+		return;
+
+	__clear_bit(*hlid, wl->links_map);
+	*hlid = WL12XX_INVALID_LINK_ID;
+}
+
+int wl12xx_cmd_role_start_sta(struct wl1271 *wl)
+{
+	struct wl12xx_cmd_role_start *cmd;
+	int ret;
 
-	join->bss_type = bss_type;
-	join->basic_rate_set = cpu_to_le32(wl->basic_rate_set);
-	join->supported_rate_set = cpu_to_le32(wl->rate_set);
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
+	wl1271_debug(DEBUG_CMD, "cmd role start sta %d", wl->role_id);
+
+	cmd->role_id = wl->role_id;
 	if (wl->band == IEEE80211_BAND_5GHZ)
-		join->bss_type |= WL1271_JOIN_CMD_BSS_TYPE_5GHZ;
+		cmd->band = WL12XX_BAND_5GHZ;
+	cmd->channel = wl->channel;
+	cmd->sta.basic_rate_set = cpu_to_le32(wl->basic_rate_set);
+	cmd->sta.beacon_interval = cpu_to_le16(wl->beacon_int);
+	cmd->sta.ssid_type = WL12XX_SSID_TYPE_ANY;
+	cmd->sta.ssid_len = wl->ssid_len;
+	memcpy(cmd->sta.ssid, wl->ssid, wl->ssid_len);
+	memcpy(cmd->sta.bssid, wl->bssid, ETH_ALEN);
+	cmd->sta.local_rates = cpu_to_le32(wl->rate_set);
+
+	if (wl->sta_hlid == WL12XX_INVALID_LINK_ID) {
+		ret = wl12xx_allocate_link(wl, &wl->sta_hlid);
+		if (ret)
+			goto out_free;
+	}
+	cmd->sta.hlid = wl->sta_hlid;
+	cmd->sta.session = wl->session_counter;
+	cmd->sta.remote_rates = cpu_to_le32(wl->rate_set);
+
+	wl1271_debug(DEBUG_CMD, "role start: roleid=%d, hlid=%d, session=%d "
+		     "basic_rate_set: 0x%x, remote_rates: 0x%x",
+		     wl->role_id, cmd->sta.hlid, cmd->sta.session,
+		     wl->basic_rate_set, wl->rate_set);
+
+	ret = wl1271_cmd_send(wl, CMD_ROLE_START, cmd, sizeof(*cmd), 0);
+	if (ret < 0) {
+		wl1271_error("failed to initiate cmd role start sta");
+		goto err_hlid;
+	}
+
+	goto out_free;
+
+err_hlid:
+	/* clear links on error. */
+	wl12xx_free_link(wl, &wl->sta_hlid);
+
+out_free:
+	kfree(cmd);
+
+out:
+	return ret;
+}
 
-	join->beacon_interval = cpu_to_le16(wl->beacon_int);
-	join->dtim_interval = WL1271_DEFAULT_DTIM_PERIOD;
+int wl12xx_cmd_role_stop_sta(struct wl1271 *wl)
+{
+	struct wl12xx_cmd_role_stop *cmd;
+	int ret;
+
+	if (WARN_ON(wl->sta_hlid == WL12XX_INVALID_LINK_ID))
+		return -EINVAL;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
-	join->channel = wl->channel;
-	join->ssid_len = wl->ssid_len;
-	memcpy(join->ssid, wl->ssid, wl->ssid_len);
+	wl1271_debug(DEBUG_CMD, "cmd role stop sta %d", wl->role_id);
 
-	join->ctrl |= wl->session_counter << WL1271_JOIN_CMD_TX_SESSION_OFFSET;
+	cmd->role_id = wl->role_id;
+	cmd->disc_type = DISCONNECT_IMMEDIATE;
+	cmd->reason = cpu_to_le16(WLAN_REASON_UNSPECIFIED);
 
-	wl1271_debug(DEBUG_CMD, "cmd join: basic_rate_set=0x%x, rate_set=0x%x",
-		join->basic_rate_set, join->supported_rate_set);
+	ret = wl1271_cmd_send(wl, CMD_ROLE_STOP, cmd, sizeof(*cmd), 0);
+	if (ret < 0) {
+		wl1271_error("failed to initiate cmd role stop sta");
+		goto out_free;
+	}
 
-	ret = wl1271_cmd_send(wl, CMD_START_JOIN, join, sizeof(*join), 0);
+	ret = wl1271_cmd_wait_for_event(wl, DISCONNECT_EVENT_COMPLETE_ID);
 	if (ret < 0) {
-		wl1271_error("failed to initiate cmd join");
+		wl1271_error("cmd role stop sta event completion error");
 		goto out_free;
 	}
 
-	ret = wl1271_cmd_wait_for_event(wl, JOIN_EVENT_COMPLETE_ID);
-	if (ret < 0)
-		wl1271_error("cmd join event completion error");
+	wl12xx_free_link(wl, &wl->sta_hlid);
+
+out_free:
+	kfree(cmd);
+
+out:
+	return ret;
+}
+
+int wl12xx_cmd_role_start_ap(struct wl1271 *wl)
+{
+	struct wl12xx_cmd_role_start *cmd;
+	struct ieee80211_bss_conf *bss_conf = &wl->vif->bss_conf;
+	int ret;
+
+	wl1271_debug(DEBUG_CMD, "cmd role start ap %d", wl->role_id);
+
+	/*
+	 * We currently do not support hidden SSID. The real SSID
+	 * should be fetched from mac80211 first.
+	 */
+	if (wl->ssid_len == 0) {
+		wl1271_warning("Hidden SSID currently not supported for AP");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	cmd->role_id = wl->role_id;
+	cmd->ap.aging_period = cpu_to_le16(wl->conf.tx.ap_aging_period);
+	cmd->ap.bss_index = WL1271_AP_BSS_INDEX;
+	cmd->ap.global_hlid = WL1271_AP_GLOBAL_HLID;
+	cmd->ap.broadcast_hlid = WL1271_AP_BROADCAST_HLID;
+	cmd->ap.basic_rate_set = cpu_to_le32(wl->basic_rate_set);
+	cmd->ap.beacon_interval = cpu_to_le16(wl->beacon_int);
+	cmd->ap.dtim_interval = bss_conf->dtim_period;
+	cmd->ap.beacon_expiry = WL1271_AP_DEF_BEACON_EXP;
+	cmd->channel = wl->channel;
+	cmd->ap.ssid_len = wl->ssid_len;
+	cmd->ap.ssid_type = WL12XX_SSID_TYPE_PUBLIC;
+	memcpy(cmd->ap.ssid, wl->ssid, wl->ssid_len);
+	cmd->ap.local_rates = cpu_to_le32(0xffffffff);
+
+	switch (wl->band) {
+	case IEEE80211_BAND_2GHZ:
+		cmd->band = RADIO_BAND_2_4GHZ;
+		break;
+	case IEEE80211_BAND_5GHZ:
+		cmd->band = RADIO_BAND_5GHZ;
+		break;
+	default:
+		wl1271_warning("ap start - unknown band: %d", (int)wl->band);
+		cmd->band = RADIO_BAND_2_4GHZ;
+		break;
+	}
+
+	ret = wl1271_cmd_send(wl, CMD_ROLE_START, cmd, sizeof(*cmd), 0);
+	if (ret < 0) {
+		wl1271_error("failed to initiate cmd role start ap");
+		goto out_free;
+	}
 
 out_free:
-	kfree(join);
+	kfree(cmd);
 
 out:
 	return ret;
 }
 
+int wl12xx_cmd_role_stop_ap(struct wl1271 *wl)
+{
+	struct wl12xx_cmd_role_stop *cmd;
+	int ret;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	wl1271_debug(DEBUG_CMD, "cmd role stop ap %d", wl->role_id);
+
+	cmd->role_id = wl->role_id;
+
+	ret = wl1271_cmd_send(wl, CMD_ROLE_STOP, cmd, sizeof(*cmd), 0);
+	if (ret < 0) {
+		wl1271_error("failed to initiate cmd role stop ap");
+		goto out_free;
+	}
+
+out_free:
+	kfree(cmd);
+
+out:
+	return ret;
+}
+
+
 /**
  * send test command to firmware
  *
  * @wl: wl struct
  * @buf: buffer containing the command, with all headers, must work with dma
  * @len: length of the buffer
@@ -562,12 +795,13 @@ int wl1271_cmd_ps_mode(struct wl1271 *wl, u8 ps_mode)
 	ps_params = kzalloc(sizeof(*ps_params), GFP_KERNEL);
 	if (!ps_params) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
+	ps_params->role_id = wl->role_id;
 	ps_params->ps_mode = ps_mode;
 
 	ret = wl1271_cmd_send(wl, CMD_SET_PS_MODE, ps_params,
 			      sizeof(*ps_params), 0);
 	if (ret < 0) {
 		wl1271_error("cmd set_ps_mode failed");
@@ -808,63 +1042,34 @@ int wl1271_build_qos_null_data(struct wl1271 *wl)
 
 	return wl1271_cmd_template_set(wl, CMD_TEMPL_QOS_NULL_DATA, &template,
 				       sizeof(template), 0,
 				       wl->basic_rate);
 }
 
-int wl1271_cmd_set_sta_default_wep_key(struct wl1271 *wl, u8 id)
+int wl12xx_cmd_set_default_wep_key(struct wl1271 *wl, u8 id, u8 hlid)
 {
-	struct wl1271_cmd_set_sta_keys *cmd;
+	struct wl1271_cmd_set_keys *cmd;
 	int ret = 0;
 
 	wl1271_debug(DEBUG_CMD, "cmd set_default_wep_key %d", id);
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (!cmd) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
-	cmd->id = id;
-	cmd->key_action = cpu_to_le16(KEY_SET_ID);
-	cmd->key_type = KEY_WEP;
-
-	ret = wl1271_cmd_send(wl, CMD_SET_KEYS, cmd, sizeof(*cmd), 0);
-	if (ret < 0) {
-		wl1271_warning("cmd set_default_wep_key failed: %d", ret);
-		goto out;
-	}
-
-out:
-	kfree(cmd);
-
-	return ret;
-}
-
-int wl1271_cmd_set_ap_default_wep_key(struct wl1271 *wl, u8 id)
-{
-	struct wl1271_cmd_set_ap_keys *cmd;
-	int ret = 0;
-
-	wl1271_debug(DEBUG_CMD, "cmd set_ap_default_wep_key %d", id);
-
-	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
-	if (!cmd) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	cmd->hlid = WL1271_AP_BROADCAST_HLID;
+	cmd->hlid = hlid;
 	cmd->key_id = id;
 	cmd->lid_key_type = WEP_DEFAULT_LID_TYPE;
 	cmd->key_action = cpu_to_le16(KEY_SET_ID);
 	cmd->key_type = KEY_WEP;
 
 	ret = wl1271_cmd_send(wl, CMD_SET_KEYS, cmd, sizeof(*cmd), 0);
 	if (ret < 0) {
-		wl1271_warning("cmd set_ap_default_wep_key failed: %d", ret);
+		wl1271_warning("cmd set_default_wep_key failed: %d", ret);
 		goto out;
 	}
 
 out:
 	kfree(cmd);
 
@@ -872,35 +1077,38 @@ out:
 }
 
 int wl1271_cmd_set_sta_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
 		       u8 key_size, const u8 *key, const u8 *addr,
 		       u32 tx_seq_32, u16 tx_seq_16)
 {
-	struct wl1271_cmd_set_sta_keys *cmd;
+	struct wl1271_cmd_set_keys *cmd;
 	int ret = 0;
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (!cmd) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
-	if (key_type != KEY_WEP)
-		memcpy(cmd->addr, addr, ETH_ALEN);
+	cmd->hlid = wl->sta_hlid;
+
+	if (key_type == KEY_WEP)
+		cmd->lid_key_type = WEP_DEFAULT_LID_TYPE;
+	else if (is_broadcast_ether_addr(addr))
+		cmd->lid_key_type = BROADCAST_LID_TYPE;
+	else
+		cmd->lid_key_type = UNICAST_LID_TYPE;
 
 	cmd->key_action = cpu_to_le16(action);
 	cmd->key_size = key_size;
 	cmd->key_type = key_type;
 
 	cmd->ac_seq_num16[0] = cpu_to_le16(tx_seq_16);
 	cmd->ac_seq_num32[0] = cpu_to_le32(tx_seq_32);
 
-	/* we have only one SSID profile */
-	cmd->ssid_profile = 0;
-
-	cmd->id = id;
+	cmd->key_id = id;
 
 	if (key_type == KEY_TKIP) {
 		/*
 		 * We get the key in the following form:
 		 * TKIP (16 bytes) - TX MIC (8 bytes) - RX MIC (8 bytes)
 		 * but the target is expecting:
@@ -925,17 +1133,21 @@ int wl1271_cmd_set_sta_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
 out:
 	kfree(cmd);
 
 	return ret;
 }
 
+/*
+ * TODO: merge with sta/ibss into 1 set_key function.
+ * note there are slight diffs
+ */
 int wl1271_cmd_set_ap_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
 			u8 key_size, const u8 *key, u8 hlid, u32 tx_seq_32,
 			u16 tx_seq_16)
 {
-	struct wl1271_cmd_set_ap_keys *cmd;
+	struct wl1271_cmd_set_keys *cmd;
 	int ret = 0;
 	u8 lid_type;
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (!cmd)
 		return -ENOMEM;
@@ -986,172 +1198,46 @@ int wl1271_cmd_set_ap_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
 
 out:
 	kfree(cmd);
 	return ret;
 }
 
-int wl1271_cmd_disconnect(struct wl1271 *wl)
-{
-	struct wl1271_cmd_disconnect *cmd;
-	int ret = 0;
-
-	wl1271_debug(DEBUG_CMD, "cmd disconnect");
-
-	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
-	if (!cmd) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	/* disconnect reason is not used in immediate disconnections */
-	cmd->type = DISCONNECT_IMMEDIATE;
-
-	ret = wl1271_cmd_send(wl, CMD_DISCONNECT, cmd, sizeof(*cmd), 0);
-	if (ret < 0) {
-		wl1271_error("failed to send disconnect command");
-		goto out_free;
-	}
-
-	ret = wl1271_cmd_wait_for_event(wl, DISCONNECT_EVENT_COMPLETE_ID);
-	if (ret < 0)
-		wl1271_error("cmd disconnect event completion error");
-
-out_free:
-	kfree(cmd);
-
-out:
-	return ret;
-}
-
-int wl1271_cmd_set_sta_state(struct wl1271 *wl)
+int wl12xx_cmd_set_peer_state(struct wl1271 *wl)
 {
-	struct wl1271_cmd_set_sta_state *cmd;
+	struct wl12xx_cmd_set_peer_state *cmd;
 	int ret = 0;
 
-	wl1271_debug(DEBUG_CMD, "cmd set sta state");
+	wl1271_debug(DEBUG_CMD, "cmd set peer state (hlid=%d)", wl->sta_hlid);
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (!cmd) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
+	cmd->hlid = wl->sta_hlid;
 	cmd->state = WL1271_CMD_STA_STATE_CONNECTED;
 
-	ret = wl1271_cmd_send(wl, CMD_SET_STA_STATE, cmd, sizeof(*cmd), 0);
+	ret = wl1271_cmd_send(wl, CMD_SET_PEER_STATE, cmd, sizeof(*cmd), 0);
 	if (ret < 0) {
-		wl1271_error("failed to send set STA state command");
+		wl1271_error("failed to send set peer state command");
 		goto out_free;
 	}
 
 out_free:
 	kfree(cmd);
 
 out:
 	return ret;
 }
-
-int wl1271_cmd_start_bss(struct wl1271 *wl)
-{
-	struct wl1271_cmd_bss_start *cmd;
-	struct ieee80211_bss_conf *bss_conf = &wl->vif->bss_conf;
-	int ret;
-
-	wl1271_debug(DEBUG_CMD, "cmd start bss");
-
-	/*
-	 * FIXME: We currently do not support hidden SSID. The real SSID
-	 * should be fetched from mac80211 first.
-	 */
-	if (wl->ssid_len == 0) {
-		wl1271_warning("Hidden SSID currently not supported for AP");
-		ret = -EINVAL;
-		goto out;
-	}
-
-	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
-	if (!cmd) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	memcpy(cmd->bssid, bss_conf->bssid, ETH_ALEN);
-
-	cmd->aging_period = cpu_to_le16(wl->conf.tx.ap_aging_period);
-	cmd->bss_index = WL1271_AP_BSS_INDEX;
-	cmd->global_hlid = WL1271_AP_GLOBAL_HLID;
-	cmd->broadcast_hlid = WL1271_AP_BROADCAST_HLID;
-	cmd->basic_rate_set = cpu_to_le32(wl->basic_rate_set);
-	cmd->beacon_interval = cpu_to_le16(wl->beacon_int);
-	cmd->dtim_interval = bss_conf->dtim_period;
-	cmd->beacon_expiry = WL1271_AP_DEF_BEACON_EXP;
-	cmd->channel = wl->channel;
-	cmd->ssid_len = wl->ssid_len;
-	cmd->ssid_type = SSID_TYPE_PUBLIC;
-	memcpy(cmd->ssid, wl->ssid, wl->ssid_len);
-
-	switch (wl->band) {
-	case IEEE80211_BAND_2GHZ:
-		cmd->band = RADIO_BAND_2_4GHZ;
-		break;
-	case IEEE80211_BAND_5GHZ:
-		cmd->band = RADIO_BAND_5GHZ;
-		break;
-	default:
-		wl1271_warning("bss start - unknown band: %d", (int)wl->band);
-		cmd->band = RADIO_BAND_2_4GHZ;
-		break;
-	}
-
-	ret = wl1271_cmd_send(wl, CMD_BSS_START, cmd, sizeof(*cmd), 0);
-	if (ret < 0) {
-		wl1271_error("failed to initiate cmd start bss");
-		goto out_free;
-	}
-
-out_free:
-	kfree(cmd);
-
-out:
-	return ret;
-}
-
-int wl1271_cmd_stop_bss(struct wl1271 *wl)
-{
-	struct wl1271_cmd_bss_start *cmd;
-	int ret;
-
-	wl1271_debug(DEBUG_CMD, "cmd stop bss");
-
-	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
-	if (!cmd) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	cmd->bss_index = WL1271_AP_BSS_INDEX;
-
-	ret = wl1271_cmd_send(wl, CMD_BSS_STOP, cmd, sizeof(*cmd), 0);
-	if (ret < 0) {
-		wl1271_error("failed to initiate cmd stop bss");
-		goto out_free;
-	}
-
-out_free:
-	kfree(cmd);
-
-out:
-	return ret;
-}
-
-int wl1271_cmd_add_sta(struct wl1271 *wl, struct ieee80211_sta *sta, u8 hlid)
+int wl12xx_cmd_add_peer(struct wl1271 *wl, struct ieee80211_sta *sta, u8 hlid)
 {
-	struct wl1271_cmd_add_sta *cmd;
+	struct wl12xx_cmd_add_peer *cmd;
 	int ret;
 
-	wl1271_debug(DEBUG_CMD, "cmd add sta %d", (int)hlid);
+	wl1271_debug(DEBUG_CMD, "cmd add peer %d", (int)hlid);
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (!cmd) {
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -1165,56 +1251,57 @@ int wl1271_cmd_add_sta(struct wl1271 *wl, struct ieee80211_sta *sta, u8 hlid)
 	cmd->hlid = hlid;
 	cmd->wmm = sta->wme ? 1 : 0;
 
 	cmd->supported_rates = cpu_to_le32(wl1271_tx_enabled_rates_get(wl,
 						sta->supp_rates[wl->band]));
 
-	wl1271_debug(DEBUG_CMD, "new sta rates: 0x%x", cmd->supported_rates);
+	wl1271_debug(DEBUG_CMD, "new peer rates: 0x%x", cmd->supported_rates);
 
-	ret = wl1271_cmd_send(wl, CMD_ADD_STA, cmd, sizeof(*cmd), 0);
+	ret = wl1271_cmd_send(wl, CMD_ADD_PEER, cmd, sizeof(*cmd), 0);
 	if (ret < 0) {
-		wl1271_error("failed to initiate cmd add sta");
+		wl1271_error("failed to initiate cmd add peer");
 		goto out_free;
 	}
 
 out_free:
 	kfree(cmd);
 
 out:
 	return ret;
 }
 
-int wl1271_cmd_remove_sta(struct wl1271 *wl, u8 hlid)
+int wl12xx_cmd_remove_peer(struct wl1271 *wl, u8 hlid)
 {
-	struct wl1271_cmd_remove_sta *cmd;
+	struct wl12xx_cmd_remove_peer *cmd;
 	int ret;
 
-	wl1271_debug(DEBUG_CMD, "cmd remove sta %d", (int)hlid);
+	wl1271_debug(DEBUG_CMD, "cmd remove peer %d", (int)hlid);
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (!cmd) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
 	cmd->hlid = hlid;
 	/* We never send a deauth, mac80211 is in charge of this */
 	cmd->reason_opcode = 0;
 	cmd->send_deauth_flag = 0;
 
-	ret = wl1271_cmd_send(wl, CMD_REMOVE_STA, cmd, sizeof(*cmd), 0);
+	ret = wl1271_cmd_send(wl, CMD_REMOVE_PEER, cmd, sizeof(*cmd), 0);
 	if (ret < 0) {
-		wl1271_error("failed to initiate cmd remove sta");
+		wl1271_error("failed to initiate cmd remove peer");
 		goto out_free;
 	}
 
 	/*
 	 * We are ok with a timeout here. The event is sometimes not sent
 	 * due to a firmware bug.
 	 */
-	wl1271_cmd_wait_for_event_or_timeout(wl, STA_REMOVE_COMPLETE_EVENT_ID);
+	wl1271_cmd_wait_for_event_or_timeout(wl,
+					     PEER_REMOVE_COMPLETE_EVENT_ID);
 
 out_free:
 	kfree(cmd);
 
 out:
 	return ret;
diff --git a/drivers/net/wireless/wl12xx/cmd.h b/drivers/net/wireless/wl12xx/cmd.h
index bba077e..16e0a87 100644
--- a/drivers/net/wireless/wl12xx/cmd.h
+++ b/drivers/net/wireless/wl12xx/cmd.h
@@ -33,13 +33,20 @@ int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len,
 		    size_t res_len);
 int wl1271_cmd_general_parms(struct wl1271 *wl);
 int wl128x_cmd_general_parms(struct wl1271 *wl);
 int wl1271_cmd_radio_parms(struct wl1271 *wl);
 int wl128x_cmd_radio_parms(struct wl1271 *wl);
 int wl1271_cmd_ext_radio_parms(struct wl1271 *wl);
-int wl1271_cmd_join(struct wl1271 *wl, u8 bss_type);
+int wl12xx_cmd_role_enable(struct wl1271 *wl, u8 role_type, u8 *role_id);
+int wl12xx_cmd_role_disable(struct wl1271 *wl, u8 *role_id);
+int wl12xx_cmd_role_start_dev(struct wl1271 *wl);
+int wl12xx_cmd_role_stop_dev(struct wl1271 *wl);
+int wl12xx_cmd_role_start_sta(struct wl1271 *wl);
+int wl12xx_cmd_role_stop_sta(struct wl1271 *wl);
+int wl12xx_cmd_role_start_ap(struct wl1271 *wl);
+int wl12xx_cmd_role_stop_ap(struct wl1271 *wl);
 int wl1271_cmd_test(struct wl1271 *wl, void *buf, size_t buf_len, u8 answer);
 int wl1271_cmd_interrogate(struct wl1271 *wl, u16 id, void *buf, size_t len);
 int wl1271_cmd_configure(struct wl1271 *wl, u16 id, void *buf, size_t len);
 int wl1271_cmd_data_path(struct wl1271 *wl, bool enable);
 int wl1271_cmd_ps_mode(struct wl1271 *wl, u8 ps_mode);
 int wl1271_cmd_read_memory(struct wl1271 *wl, u32 addr, void *answer,
@@ -53,26 +60,22 @@ int wl1271_cmd_build_probe_req(struct wl1271 *wl,
 			       const u8 *ie, size_t ie_len, u8 band);
 struct sk_buff *wl1271_cmd_build_ap_probe_req(struct wl1271 *wl,
 					      struct sk_buff *skb);
 int wl1271_cmd_build_arp_rsp(struct wl1271 *wl, __be32 ip_addr);
 int wl1271_build_qos_null_data(struct wl1271 *wl);
 int wl1271_cmd_build_klv_null_data(struct wl1271 *wl);
-int wl1271_cmd_set_sta_default_wep_key(struct wl1271 *wl, u8 id);
-int wl1271_cmd_set_ap_default_wep_key(struct wl1271 *wl, u8 id);
+int wl12xx_cmd_set_default_wep_key(struct wl1271 *wl, u8 id, u8 hlid);
 int wl1271_cmd_set_sta_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
 			   u8 key_size, const u8 *key, const u8 *addr,
 			   u32 tx_seq_32, u16 tx_seq_16);
 int wl1271_cmd_set_ap_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
 			  u8 key_size, const u8 *key, u8 hlid, u32 tx_seq_32,
 			  u16 tx_seq_16);
-int wl1271_cmd_disconnect(struct wl1271 *wl);
-int wl1271_cmd_set_sta_state(struct wl1271 *wl);
-int wl1271_cmd_start_bss(struct wl1271 *wl);
-int wl1271_cmd_stop_bss(struct wl1271 *wl);
-int wl1271_cmd_add_sta(struct wl1271 *wl, struct ieee80211_sta *sta, u8 hlid);
-int wl1271_cmd_remove_sta(struct wl1271 *wl, u8 hlid);
+int wl12xx_cmd_set_peer_state(struct wl1271 *wl);
+int wl12xx_cmd_add_peer(struct wl1271 *wl, struct ieee80211_sta *sta, u8 hlid);
+int wl12xx_cmd_remove_peer(struct wl1271 *wl, u8 hlid);
 int wl12xx_cmd_config_fwlog(struct wl1271 *wl);
 int wl12xx_cmd_start_fwlog(struct wl1271 *wl);
 int wl12xx_cmd_stop_fwlog(struct wl1271 *wl);
 
 enum wl1271_commands {
 	CMD_INTERROGATE     = 1,    /*use this to read information elements*/
@@ -80,48 +83,58 @@ enum wl1271_commands {
 	CMD_ENABLE_RX       = 3,
 	CMD_ENABLE_TX       = 4,
 	CMD_DISABLE_RX      = 5,
 	CMD_DISABLE_TX      = 6,
 	CMD_SCAN            = 8,
 	CMD_STOP_SCAN       = 9,
-	CMD_START_JOIN      = 11,
 	CMD_SET_KEYS        = 12,
 	CMD_READ_MEMORY     = 13,
 	CMD_WRITE_MEMORY    = 14,
 	CMD_SET_TEMPLATE    = 19,
 	CMD_TEST            = 23,
 	CMD_NOISE_HIST      = 28,
-	CMD_LNA_CONTROL     = 32,
+	CMD_QUIET_ELEMENT_SET_STATE  = 29,
 	CMD_SET_BCN_MODE    = 33,
 	CMD_MEASUREMENT      = 34,
 	CMD_STOP_MEASUREMENT = 35,
-	CMD_DISCONNECT       = 36,
 	CMD_SET_PS_MODE      = 37,
 	CMD_CHANNEL_SWITCH   = 38,
 	CMD_STOP_CHANNEL_SWICTH = 39,
 	CMD_AP_DISCOVERY     = 40,
 	CMD_STOP_AP_DISCOVERY = 41,
-	CMD_SPS_SCAN = 42,
-	CMD_STOP_SPS_SCAN = 43,
 	CMD_HEALTH_CHECK     = 45,
 	CMD_DEBUG            = 46,
 	CMD_TRIGGER_SCAN_TO  = 47,
 	CMD_CONNECTION_SCAN_CFG      = 48,
 	CMD_CONNECTION_SCAN_SSID_CFG = 49,
 	CMD_START_PERIODIC_SCAN      = 50,
 	CMD_STOP_PERIODIC_SCAN       = 51,
-	CMD_SET_STA_STATE            = 52,
-	CMD_CONFIG_FWLOGGER          = 53,
-	CMD_START_FWLOGGER           = 54,
-	CMD_STOP_FWLOGGER            = 55,
+	CMD_SET_PEER_STATE           = 52,
+	CMD_REMAIN_ON_CHANNEL        = 53,
+	CMD_CANCEL_REMAIN_ON_CHANNEL = 54,
 
-	/* AP mode commands */
-	CMD_BSS_START                = 60,
-	CMD_BSS_STOP                 = 61,
-	CMD_ADD_STA                  = 62,
-	CMD_REMOVE_STA               = 63,
+	CMD_CONFIG_FWLOGGER          = 55,
+	CMD_START_FWLOGGER           = 56,
+	CMD_STOP_FWLOGGER            = 57,
+
+	/* AP commands */
+	CMD_ADD_PEER                 = 62,
+	CMD_REMOVE_PEER              = 63,
+
+	/* Role API */
+	CMD_ROLE_ENABLE              = 70,
+	CMD_ROLE_DISABLE             = 71,
+	CMD_ROLE_START               = 72,
+	CMD_ROLE_STOP                = 73,
+
+	/* WIFI Direct */
+	CMD_WFD_START_DISCOVERY      = 80,
+	CMD_WFD_STOP_DISCOVERY	     = 81,
+	CMD_WFD_ATTRIBUTE_CONFIG     = 82,
+
+	CMD_NOP                      = 100,
 
 	NUM_COMMANDS,
 	MAX_COMMAND_ID = 0xFFFF,
 };
 
 #define MAX_CMD_PARAMS 572
@@ -144,20 +157,18 @@ enum cmd_templ {
 	CMD_TEMPL_PROBE_REQ_2_4, /* for firmware internal use only */
 	CMD_TEMPL_PROBE_REQ_5,   /* for firmware internal use only */
 	CMD_TEMPL_BAR,           /* for firmware internal use only */
 	CMD_TEMPL_CTS,           /*
 				  * For CTS-to-self (FastCTS) mechanism
 				  * for BT/WLAN coexistence (SoftGemini). */
-	CMD_TEMPL_ARP_RSP,
-	CMD_TEMPL_LINK_MEASUREMENT_REPORT,
-
-	/* AP-mode specific */
-	CMD_TEMPL_AP_BEACON = 13,
+	CMD_TEMPL_AP_BEACON,
 	CMD_TEMPL_AP_PROBE_RESPONSE,
-	CMD_TEMPL_AP_ARP_RSP,
+	CMD_TEMPL_ARP_RSP,
 	CMD_TEMPL_DEAUTH_AP,
+	CMD_TEMPL_TEMPORARY,
+	CMD_TEMPL_LINK_MEASUREMENT_REPORT,
 
 	CMD_TEMPL_MAX = 0xff
 };
 
 /* unit ms */
 #define WL1271_COMMAND_TIMEOUT     2000
@@ -190,12 +201,13 @@ enum {
 	CMD_STATUS_OUT_OF_MEMORY		= 16,
 	CMD_STATUS_STA_TABLE_FULL		= 17,
 	CMD_STATUS_RADIO_ERROR		= 18,
 	CMD_STATUS_WRONG_NESTING		= 19,
 	CMD_STATUS_TIMEOUT		= 21, /* Driver internal use.*/
 	CMD_STATUS_FW_RESET		= 22, /* Driver internal use.*/
+	CMD_STATUS_TEMPLATE_OOM		= 23,
 	MAX_COMMAND_STATUS		= 0xff
 };
 
 #define CMDMBOX_HEADER_LEN 4
 #define CMDMBOX_INFO_ELEM_HEADER_LEN 4
 
@@ -207,44 +219,120 @@ enum {
 };
 
 #define WL1271_JOIN_CMD_CTRL_TX_FLUSH     0x80 /* Firmware flushes all Tx */
 #define WL1271_JOIN_CMD_TX_SESSION_OFFSET 1
 #define WL1271_JOIN_CMD_BSS_TYPE_5GHZ 0x10
 
-struct wl1271_cmd_join {
+struct wl12xx_cmd_role_enable {
 	struct wl1271_cmd_header header;
 
-	__le32 bssid_lsb;
-	__le16 bssid_msb;
-	__le16 beacon_interval; /* in TBTTs */
-	__le32 rx_config_options;
-	__le32 rx_filter_options;
+	u8 role_id;
+	u8 role_type;
+	u8 mac_address[ETH_ALEN];
+} __packed;
 
-	/*
-	 * The target uses this field to determine the rate at
-	 * which to transmit control frame responses (such as
-	 * ACK or CTS frames).
-	 */
-	__le32 basic_rate_set;
-	__le32 supported_rate_set;
-	u8 dtim_interval;
-	/*
-	 * bits 0-2: This bitwise field specifies the type
-	 * of BSS to start or join (BSS_TYPE_*).
-	 * bit 4: Band - The radio band in which to join
-	 * or start.
-	 *  0 - 2.4GHz band
-	 *  1 - 5GHz band
-	 * bits 3, 5-7: Reserved
-	 */
-	u8 bss_type;
+struct wl12xx_cmd_role_disable {
+	struct wl1271_cmd_header header;
+
+	u8 role_id;
+	u8 padding[3];
+} __packed;
+
+enum wl12xx_band {
+	WL12XX_BAND_2_4GHZ		= 0,
+	WL12XX_BAND_5GHZ		= 1,
+	WL12XX_BAND_JAPAN_4_9_GHZ	= 2,
+	WL12XX_BAND_DEFAULT		= WL12XX_BAND_2_4GHZ,
+	WL12XX_BAND_INVALID		= 0x7E,
+	WL12XX_BAND_MAX_RADIO		= 0x7F,
+};
+
+struct wl12xx_cmd_role_start {
+	struct wl1271_cmd_header header;
+
+	u8 role_id;
+	u8 band;
 	u8 channel;
-	u8 ssid_len;
-	u8 ssid[IEEE80211_MAX_SSID_LEN];
-	u8 ctrl; /* JOIN_CMD_CTRL_* */
-	u8 reserved[3];
+	u8 padding;
+
+	union {
+		struct {
+			u8 hlid;
+			u8 session;
+			u8 padding_1[54];
+		} __packed device;
+		/* sta & p2p_cli use the same struct */
+		struct {
+			u8 bssid[ETH_ALEN];
+			u8 hlid; /* data hlid */
+			u8 session;
+			__le32 remote_rates; /* remote supported rates */
+
+			/*
+			 * The target uses this field to determine the rate at
+			 * which to transmit control frame responses (such as
+			 * ACK or CTS frames).
+			 */
+			__le32 basic_rate_set;
+			__le32 local_rates; /* local supported rates */
+
+			u8 ssid_type;
+			u8 ssid_len;
+			u8 ssid[IEEE80211_MAX_SSID_LEN];
+
+			__le16 beacon_interval; /* in TBTTs */
+		} __packed sta;
+		struct {
+			u8 bssid[ETH_ALEN];
+			u8 hlid; /* data hlid */
+			u8 dtim_interval;
+			__le32 remote_rates; /* remote supported rates */
+
+			__le32 basic_rate_set;
+			__le32 local_rates; /* local supported rates */
+
+			u8 ssid_type;
+			u8 ssid_len;
+			u8 ssid[IEEE80211_MAX_SSID_LEN];
+
+			__le16 beacon_interval; /* in TBTTs */
+
+			u8 padding_1[4];
+		} __packed ibss;
+		/* ap & p2p_go use the same struct */
+		struct {
+			__le16 aging_period; /* in secs */
+			u8 beacon_expiry; /* in ms */
+			u8 bss_index;
+			/* The host link id for the AP's global queue */
+			u8 global_hlid;
+			/* The host link id for the AP's broadcast queue */
+			u8 broadcast_hlid;
+
+			__le16 beacon_interval; /* in TBTTs */
+
+			__le32 basic_rate_set;
+			__le32 local_rates; /* local supported rates */
+
+			u8 dtim_interval;
+
+			u8 ssid_type;
+			u8 ssid_len;
+			u8 ssid[IEEE80211_MAX_SSID_LEN];
+
+			u8 padding_1[5];
+		} __packed ap;
+	};
+} __packed;
+
+struct wl12xx_cmd_role_stop {
+	struct wl1271_cmd_header header;
+
+	u8 role_id;
+	u8 disc_type; /* only STA and P2P_CLI */
+	__le16 reason; /* only STA and P2P_CLI */
 } __packed;
 
 struct cmd_enabledisable_path {
 	struct wl1271_cmd_header header;
 
 	u8 channel;
@@ -284,72 +372,42 @@ enum wl1271_cmd_ps_mode {
 	STATION_POWER_SAVE_MODE
 };
 
 struct wl1271_cmd_ps_params {
 	struct wl1271_cmd_header header;
 
+	u8 role_id;
 	u8 ps_mode; /* STATION_* */
-	u8 padding[3];
+	u8 padding[2];
 } __packed;
 
 /* HW encryption keys */
 #define NUM_ACCESS_CATEGORIES_COPY 4
 
 enum wl1271_cmd_key_action {
 	KEY_ADD_OR_REPLACE = 1,
 	KEY_REMOVE         = 2,
 	KEY_SET_ID         = 3,
 	MAX_KEY_ACTION     = 0xffff,
 };
 
+enum wl1271_cmd_lid_key_type {
+	UNICAST_LID_TYPE     = 0,
+	BROADCAST_LID_TYPE   = 1,
+	WEP_DEFAULT_LID_TYPE = 2
+};
+
 enum wl1271_cmd_key_type {
 	KEY_NONE = 0,
 	KEY_WEP  = 1,
 	KEY_TKIP = 2,
 	KEY_AES  = 3,
 	KEY_GEM  = 4,
 };
 
-/* FIXME: Add description for key-types */
-
-struct wl1271_cmd_set_sta_keys {
-	struct wl1271_cmd_header header;
-
-	/* Ignored for default WEP key */
-	u8 addr[ETH_ALEN];
-
-	/* key_action_e */
-	__le16 key_action;
-
-	__le16 reserved_1;
-
-	/* key size in bytes */
-	u8 key_size;
-
-	/* key_type_e */
-	u8 key_type;
-	u8 ssid_profile;
-
-	/*
-	 * TKIP, AES: frame's key id field.
-	 * For WEP default key: key id;
-	 */
-	u8 id;
-	u8 reserved_2[6];
-	u8 key[MAX_KEY_SIZE];
-	__le16 ac_seq_num16[NUM_ACCESS_CATEGORIES_COPY];
-	__le32 ac_seq_num32[NUM_ACCESS_CATEGORIES_COPY];
-} __packed;
-
-enum wl1271_cmd_lid_key_type {
-	UNICAST_LID_TYPE     = 0,
-	BROADCAST_LID_TYPE   = 1,
-	WEP_DEFAULT_LID_TYPE = 2
-};
-
-struct wl1271_cmd_set_ap_keys {
+struct wl1271_cmd_set_keys {
 	struct wl1271_cmd_header header;
 
 	/*
 	 * Indicates whether the HLID is a unicast key set
 	 * or broadcast key set. A special value 0xFF is
 	 * used to indicate that the HLID is on WEP-default
@@ -493,75 +551,29 @@ struct wl1271_ext_radio_parms_cmd {
 enum wl1271_disconnect_type {
 	DISCONNECT_IMMEDIATE,
 	DISCONNECT_DEAUTH,
 	DISCONNECT_DISASSOC
 };
 
-struct wl1271_cmd_disconnect {
-	struct wl1271_cmd_header header;
-
-	__le32 rx_config_options;
-	__le32 rx_filter_options;
-
-	__le16 reason;
-	u8  type;
-
-	u8  padding;
-} __packed;
-
 #define WL1271_CMD_STA_STATE_CONNECTED  1
 
-struct wl1271_cmd_set_sta_state {
+struct wl12xx_cmd_set_peer_state {
 	struct wl1271_cmd_header header;
 
+	u8 hlid;
 	u8 state;
-	u8 padding[3];
+	u8 padding[2];
 } __packed;
 
-enum wl1271_ssid_type {
-	SSID_TYPE_PUBLIC = 0,
-	SSID_TYPE_HIDDEN = 1
+enum wl12xx_ssid_type {
+	WL12XX_SSID_TYPE_PUBLIC = 0,
+	WL12XX_SSID_TYPE_HIDDEN = 1,
+	WL12XX_SSID_TYPE_ANY = 2,
 };
 
-struct wl1271_cmd_bss_start {
-	struct wl1271_cmd_header header;
-
-	/* wl1271_ssid_type */
-	u8 ssid_type;
-	u8 ssid_len;
-	u8 ssid[IEEE80211_MAX_SSID_LEN];
-	u8 padding_1[2];
-
-	/* Basic rate set */
-	__le32 basic_rate_set;
-	/* Aging period in seconds*/
-	__le16 aging_period;
-
-	/*
-	 * This field specifies the time between target beacon
-	 * transmission times (TBTTs), in time units (TUs).
-	 * Valid values are 1 to 1024.
-	 */
-	__le16 beacon_interval;
-	u8 bssid[ETH_ALEN];
-	u8 bss_index;
-	/* Radio band */
-	u8 band;
-	u8 channel;
-	/* The host link id for the AP's global queue */
-	u8 global_hlid;
-	/* The host link id for the AP's broadcast queue */
-	u8 broadcast_hlid;
-	/* DTIM count */
-	u8 dtim_interval;
-	/* Beacon expiry time in ms */
-	u8 beacon_expiry;
-	u8 padding_2[3];
-} __packed;
-
-struct wl1271_cmd_add_sta {
+struct wl12xx_cmd_add_peer {
 	struct wl1271_cmd_header header;
 
 	u8 addr[ETH_ALEN];
 	u8 hlid;
 	u8 aid;
 	u8 psd_type[NUM_ACCESS_CATEGORIES_COPY];
@@ -569,13 +581,13 @@ struct wl1271_cmd_add_sta {
 	u8 bss_index;
 	u8 sp_len;
 	u8 wmm;
 	u8 padding1;
 } __packed;
 
-struct wl1271_cmd_remove_sta {
+struct wl12xx_cmd_remove_peer {
 	struct wl1271_cmd_header header;
 
 	u8 hlid;
 	u8 reason_opcode;
 	u8 send_deauth_flag;
 	u8 padding1;
diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index 304aaa2..431ceae 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -282,16 +282,16 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 		if (wl->vif)
 			wl1271_event_rssi_trigger(wl, mbox);
 	}
 
 	if ((vector & BA_SESSION_RX_CONSTRAINT_EVENT_ID) && !is_ap) {
 		wl1271_debug(DEBUG_EVENT, "BA_SESSION_RX_CONSTRAINT_EVENT_ID. "
-			     "ba_allowed = 0x%x", mbox->ba_allowed);
+			     "ba_allowed = 0x%x", mbox->rx_ba_allowed);
 
 		if (wl->vif)
-			wl1271_stop_ba_event(wl, mbox->ba_allowed);
+			wl1271_stop_ba_event(wl, mbox->rx_ba_allowed);
 	}
 
 	if ((vector & DUMMY_PACKET_EVENT_ID) && !is_ap) {
 		wl1271_debug(DEBUG_EVENT, "DUMMY_PACKET_ID_EVENT_ID");
 		if (wl->vif)
 			wl1271_tx_dummy_packet(wl);
diff --git a/drivers/net/wireless/wl12xx/event.h b/drivers/net/wireless/wl12xx/event.h
index e524ad6..49c1a0e 100644
--- a/drivers/net/wireless/wl12xx/event.h
+++ b/drivers/net/wireless/wl12xx/event.h
@@ -46,106 +46,88 @@ enum {
 	RSSI_SNR_TRIGGER_5_EVENT_ID              = BIT(5),
 	RSSI_SNR_TRIGGER_6_EVENT_ID              = BIT(6),
 	RSSI_SNR_TRIGGER_7_EVENT_ID              = BIT(7),
 	MEASUREMENT_START_EVENT_ID		 = BIT(8),
 	MEASUREMENT_COMPLETE_EVENT_ID		 = BIT(9),
 	SCAN_COMPLETE_EVENT_ID			 = BIT(10),
-	SCHEDULED_SCAN_COMPLETE_EVENT_ID	 = BIT(11),
+	WFD_DISCOVERY_COMPLETE_EVENT_ID		 = BIT(11),
 	AP_DISCOVERY_COMPLETE_EVENT_ID		 = BIT(12),
 	PS_REPORT_EVENT_ID			 = BIT(13),
 	PSPOLL_DELIVERY_FAILURE_EVENT_ID	 = BIT(14),
 	DISCONNECT_EVENT_COMPLETE_ID		 = BIT(15),
-	JOIN_EVENT_COMPLETE_ID			 = BIT(16),
+	/* BIT(16) is reserved */
 	CHANNEL_SWITCH_COMPLETE_EVENT_ID	 = BIT(17),
 	BSS_LOSE_EVENT_ID			 = BIT(18),
 	REGAINED_BSS_EVENT_ID			 = BIT(19),
 	MAX_TX_RETRY_EVENT_ID			 = BIT(20),
-	/* STA: dummy paket for dynamic mem blocks */
-	DUMMY_PACKET_EVENT_ID                    = BIT(21),
-	/* AP: STA remove complete */
-	STA_REMOVE_COMPLETE_EVENT_ID             = BIT(21),
+	DUMMY_PACKET_EVENT_ID			 = BIT(21),
 	SOFT_GEMINI_SENSE_EVENT_ID		 = BIT(22),
-	/* STA: SG prediction */
-	SOFT_GEMINI_PREDICTION_EVENT_ID		 = BIT(23),
-	/* AP: Inactive STA */
-	INACTIVE_STA_EVENT_ID			 = BIT(23),
+	CHANGE_AUTO_MODE_TIMEOUT_EVENT_ID	 = BIT(23),
 	SOFT_GEMINI_AVALANCHE_EVENT_ID		 = BIT(24),
 	PLT_RX_CALIBRATION_COMPLETE_EVENT_ID	 = BIT(25),
-	DBG_EVENT_ID				 = BIT(26),
-	HEALTH_CHECK_REPLY_EVENT_ID		 = BIT(27),
+	INACTIVE_STA_EVENT_ID			 = BIT(26),
+	PEER_REMOVE_COMPLETE_EVENT_ID		 = BIT(27),
 	PERIODIC_SCAN_COMPLETE_EVENT_ID		 = BIT(28),
 	PERIODIC_SCAN_REPORT_EVENT_ID		 = BIT(29),
 	BA_SESSION_RX_CONSTRAINT_EVENT_ID	 = BIT(30),
+	REMAIN_ON_CHANNEL_COMPLETE_EVENT_ID	 = BIT(31),
 	EVENT_MBOX_ALL_EVENT_ID			 = 0x7fffffff,
 };
 
 enum {
 	EVENT_ENTER_POWER_SAVE_FAIL = 0,
 	EVENT_ENTER_POWER_SAVE_SUCCESS,
 };
 
-struct event_debug_report {
-	u8 debug_event_id;
-	u8 num_params;
-	__le16 pad;
-	__le32 report_1;
-	__le32 report_2;
-	__le32 report_3;
-} __packed;
-
 #define NUM_OF_RSSI_SNR_TRIGGERS 8
 
 struct event_mailbox {
 	__le32 events_vector;
 	__le32 events_mask;
 	__le32 reserved_1;
 	__le32 reserved_2;
 
-	u8 dbg_event_id;
-	u8 num_relevant_params;
-	__le16 reserved_3;
-	__le32 event_report_p1;
-	__le32 event_report_p2;
-	__le32 event_report_p3;
-
 	u8 number_of_scan_results;
 	u8 scan_tag;
-	u8 reserved_4[2];
-	__le32 compl_scheduled_scan_status;
+	u8 completed_scan_status;
+	u8 reserved_3;
 
-	__le16 scheduled_scan_attended_channels;
 	u8 soft_gemini_sense_info;
 	u8 soft_gemini_protective_info;
 	s8 rssi_snr_trigger_metric[NUM_OF_RSSI_SNR_TRIGGERS];
 	u8 channel_switch_status;
 	u8 scheduled_scan_status;
 	u8 ps_status;
+	/* tuned channel (roc) */
+	u8 roc_channel;
 
-	/* AP FW only */
-	u8 hlid_removed;
+	__le16 hlid_removed_bitmap;
 
-	/* a bitmap of hlids for stations that have been inactive too long */
+	/* bitmap of aged stations (by HLID) */
 	__le16 sta_aging_status;
 
-	/* a bitmap of hlids for stations which didn't respond to TX */
+	/* bitmap of stations (by HLID) which exceeded max tx retries */
 	__le16 sta_tx_retry_exceeded;
 
-	/*
-	 * Bitmap, Each bit set represents the Role ID for which this constraint
-	 * is set. Range: 0 - FF, FF means ANY role
-	 */
-	u8 ba_role_id;
-	/*
-	 * Bitmap, Each bit set represents the Link ID for which this constraint
-	 * is set. Not applicable if ba_role_id is set to ANY role (FF).
-	 * Range: 0 - FFFF, FFFF means ANY link in that role
-	 */
-	u8 ba_link_id;
-	u8 ba_allowed;
-
-	u8 reserved_5[21];
+	/* discovery completed results */
+	u8 discovery_tag;
+	u8 number_of_preq_results;
+	u8 number_of_prsp_results;
+	u8 reserved_5;
+
+	/* rx ba constraint */
+	u8 role_id; /* 0xFF means any role. */
+	u8 rx_ba_allowed;
+	u8 reserved_6[2];
+
+	u8 ps_poll_delivery_failure_role_ids;
+	u8 stopped_role_ids;
+	u8 started_role_ids;
+	u8 change_auto_mode_timeout;
+
+	u8 reserved_7[12];
 } __packed;
 
 int wl1271_event_unmask(struct wl1271 *wl);
 void wl1271_event_mbox_config(struct wl1271 *wl);
 int wl1271_event_handle(struct wl1271 *wl, u8 mbox);
 void wl1271_pspoll_work(struct work_struct *work);
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index 5a33257..76e6f37 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -401,18 +401,12 @@ static int wl1271_sta_hw_init(struct wl1271 *wl)
 }
 
 static int wl1271_sta_hw_init_post_mem(struct wl1271 *wl)
 {
 	int ret, i;
 
-	ret = wl1271_cmd_set_sta_default_wep_key(wl, wl->default_key);
-	if (ret < 0) {
-		wl1271_warning("couldn't set default key");
-		return ret;
-	}
-
 	/* disable all keep-alive templates */
 	for (i = 0; i < CMD_TEMPL_KLV_IDX_MAX; i++) {
 		ret = wl1271_acx_keep_alive_config(wl, i,
 						   ACX_KEEP_ALIVE_TPL_INVALID);
 		if (ret < 0)
 			return ret;
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 07d50b7..4689d0b 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -412,13 +412,13 @@ static int wl1271_check_operstate(struct wl1271 *wl, unsigned char operstate)
 	if (operstate != IF_OPER_UP)
 		return 0;
 
 	if (test_and_set_bit(WL1271_FLAG_STA_STATE_SENT, &wl->flags))
 		return 0;
 
-	ret = wl1271_cmd_set_sta_state(wl);
+	ret = wl12xx_cmd_set_peer_state(wl);
 	if (ret < 0)
 		return ret;
 
 	wl1271_info("Association completed.");
 	return 0;
 }
@@ -1979,12 +1979,14 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 	wl1271_free_ap_keys(wl);
 	memset(wl->ap_hlid_map, 0, sizeof(wl->ap_hlid_map));
 	wl->ap_fw_ps_map = 0;
 	wl->ap_ps_map = 0;
 	wl->sched_scanning = false;
 	wl->role_id = WL12XX_INVALID_ROLE_ID;
+	memset(wl->roles_map, 0, sizeof(wl->roles_map));
+	memset(wl->links_map, 0, sizeof(wl->links_map));
 
 	/*
 	 * this is performed after the cancel_work calls and the associated
 	 * mutex_lock, so that wl1271_op_add_interface does not accidentally
 	 * get executed before all these vars have been reset.
 	 */
@@ -2027,13 +2029,13 @@ static int wl1271_dummy_join(struct wl1271 *wl)
 	/* we need to use a dummy BSSID for now */
 	static const u8 dummy_bssid[ETH_ALEN] = { 0x0b, 0xad, 0xde,
 						  0xad, 0xbe, 0xef };
 
 	memcpy(wl->bssid, dummy_bssid, ETH_ALEN);
 
-	ret = wl1271_cmd_join(wl, wl->set_bss_type);
+	ret = wl12xx_cmd_role_start_sta(wl);
 	if (ret < 0)
 		goto out;
 
 	set_bit(WL1271_FLAG_JOINED, &wl->flags);
 
 out:
@@ -2056,13 +2058,13 @@ static int wl1271_join(struct wl1271 *wl, bool set_assoc)
 	if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags))
 		wl1271_info("JOIN while associated.");
 
 	if (set_assoc)
 		set_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags);
 
-	ret = wl1271_cmd_join(wl, wl->set_bss_type);
+	ret = wl12xx_cmd_role_start_sta(wl);
 	if (ret < 0)
 		goto out;
 
 	set_bit(WL1271_FLAG_JOINED, &wl->flags);
 
 	if (!test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags))
@@ -2097,13 +2099,13 @@ out:
 
 static int wl1271_unjoin(struct wl1271 *wl)
 {
 	int ret;
 
 	/* to stop listening to a channel, we disconnect */
-	ret = wl1271_cmd_disconnect(wl);
+	ret = wl12xx_cmd_role_stop_sta(wl);
 	if (ret < 0)
 		goto out;
 
 	clear_bit(WL1271_FLAG_JOINED, &wl->flags);
 	memset(wl->bssid, 0, ETH_ALEN);
 
@@ -2469,13 +2471,14 @@ static int wl1271_ap_init_hwenc(struct wl1271 *wl)
 
 		if (key->key_type == KEY_WEP)
 			wep_key_added = true;
 	}
 
 	if (wep_key_added) {
-		ret = wl1271_cmd_set_ap_default_wep_key(wl, wl->default_key);
+		ret = wl12xx_cmd_set_default_wep_key(wl, wl->default_key,
+						     WL1271_AP_BROADCAST_HLID);
 		if (ret < 0)
 			goto out;
 	}
 
 out:
 	wl1271_free_ap_keys(wl);
@@ -2547,14 +2550,15 @@ static int wl1271_set_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
 					     tx_seq_16);
 		if (ret < 0)
 			return ret;
 
 		/* the default WEP key needs to be configured at least once */
 		if (key_type == KEY_WEP) {
-			ret = wl1271_cmd_set_sta_default_wep_key(wl,
-							wl->default_key);
+			ret = wl12xx_cmd_set_default_wep_key(wl,
+							     wl->default_key,
+							     wl->sta_hlid);
 			if (ret < 0)
 				return ret;
 		}
 	}
 
 	return 0;
@@ -3005,26 +3009,26 @@ static void wl1271_bss_info_changed_ap(struct wl1271 *wl,
 	if (ret < 0)
 		goto out;
 
 	if ((changed & BSS_CHANGED_BEACON_ENABLED)) {
 		if (bss_conf->enable_beacon) {
 			if (!test_bit(WL1271_FLAG_AP_STARTED, &wl->flags)) {
-				ret = wl1271_cmd_start_bss(wl);
+				ret = wl12xx_cmd_role_start_ap(wl);
 				if (ret < 0)
 					goto out;
 
 				set_bit(WL1271_FLAG_AP_STARTED, &wl->flags);
 				wl1271_debug(DEBUG_AP, "started AP");
 
 				ret = wl1271_ap_init_hwenc(wl);
 				if (ret < 0)
 					goto out;
 			}
 		} else {
 			if (test_bit(WL1271_FLAG_AP_STARTED, &wl->flags)) {
-				ret = wl1271_cmd_stop_bss(wl);
+				ret = wl12xx_cmd_role_stop_ap(wl);
 				if (ret < 0)
 					goto out;
 
 				clear_bit(WL1271_FLAG_AP_STARTED, &wl->flags);
 				wl1271_debug(DEBUG_AP, "stopped AP");
 			}
@@ -3529,13 +3533,13 @@ static int wl1271_op_sta_add(struct ieee80211_hw *hw,
 		goto out;
 
 	ret = wl1271_ps_elp_wakeup(wl);
 	if (ret < 0)
 		goto out_free_sta;
 
-	ret = wl1271_cmd_add_sta(wl, sta, hlid);
+	ret = wl12xx_cmd_add_peer(wl, sta, hlid);
 	if (ret < 0)
 		goto out_sleep;
 
 out_sleep:
 	wl1271_ps_elp_sleep(wl);
 
@@ -3572,13 +3576,13 @@ static int wl1271_op_sta_remove(struct ieee80211_hw *hw,
 		goto out;
 
 	ret = wl1271_ps_elp_wakeup(wl);
 	if (ret < 0)
 		goto out;
 
-	ret = wl1271_cmd_remove_sta(wl, wl_sta->hlid);
+	ret = wl12xx_cmd_remove_peer(wl, wl_sta->hlid);
 	if (ret < 0)
 		goto out_sleep;
 
 	wl1271_free_sta(wl, wl_sta->hlid);
 
 out_sleep:
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 8a745fb..f497336 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -34,15 +34,16 @@
 static int wl1271_set_default_wep_key(struct wl1271 *wl, u8 id)
 {
 	int ret;
 	bool is_ap = (wl->bss_type == BSS_TYPE_AP_BSS);
 
 	if (is_ap)
-		ret = wl1271_cmd_set_ap_default_wep_key(wl, id);
+		ret = wl12xx_cmd_set_default_wep_key(wl, id,
+						     WL1271_AP_BROADCAST_HLID);
 	else
-		ret = wl1271_cmd_set_sta_default_wep_key(wl, id);
+		ret = wl12xx_cmd_set_default_wep_key(wl, id, wl->sta_hlid);
 
 	if (ret < 0)
 		return ret;
 
 	wl1271_debug(DEBUG_CRYPT, "default wep key idx: %d", (int)id);
 	return 0;
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 9f71dc7..3d43875 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -134,12 +134,13 @@ extern u32 wl12xx_debug_level;
 #define WL1271_ELP_HW_STATE_ASLEEP 0
 #define WL1271_ELP_HW_STATE_IRQ    1
 
 #define WL1271_DEFAULT_BEACON_INT  100
 #define WL1271_DEFAULT_DTIM_PERIOD 1
 
+#define WL12XX_MAX_ROLES           4
 #define WL12XX_MAX_LINKS           8
 #define WL12XX_INVALID_ROLE_ID     0xff
 #define WL12XX_INVALID_LINK_ID     0xff
 #define WL1271_AP_GLOBAL_HLID      0
 #define WL1271_AP_BROADCAST_HLID   1
 #define WL1271_AP_STA_HLID_START   2
@@ -391,12 +392,16 @@ struct wl1271 {
 	u8 set_bss_type;
 	u8 ssid[IEEE80211_MAX_SSID_LEN + 1];
 	u8 ssid_len;
 	int channel;
 	u8 role_id;
 	u8 sta_hlid;
+	u8 dev_hlid;
+
+	unsigned long links_map[BITS_TO_LONGS(WL12XX_MAX_LINKS)];
+	unsigned long roles_map[BITS_TO_LONGS(WL12XX_MAX_ROLES)];
 
 	struct wl1271_acx_mem_map *target_mem_map;
 
 	/* Accounting for allocated / available TX blocks on HW */
 	u32 tx_blocks_freed;
 	u32 tx_blocks_available;
-- 
1.7.6.401.g6a319

