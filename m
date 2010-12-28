Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53087 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277Ab0L1RhI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 12:37:08 -0500
Received: by mail-ey0-f174.google.com with SMTP id 27so4306524eye.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Dec 2010 09:37:08 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v3 04/18] wl1271: AP-mode high level commands
Date: Tue, 28 Dec 2010 19:36:34 +0200
Message-Id: <1293557808-27068-5-git-send-email-arik@wizery.com>
In-Reply-To: <1293557808-27068-1-git-send-email-arik@wizery.com>
References: <1293557808-27068-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add commands to start/stop BSS, add/remove STA and configure encryption
keys. Split the encryption commands "set key" and "set default key" into
AP and STA specific versions.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c    |  276 +++++++++++++++++++++++++++++++++-
 drivers/net/wireless/wl12xx/cmd.h    |  139 ++++++++++++++++-
 drivers/net/wireless/wl12xx/init.c   |    2 +-
 drivers/net/wireless/wl12xx/main.c   |    6 +-
 drivers/net/wireless/wl12xx/tx.c     |    2 +-
 drivers/net/wireless/wl12xx/wl12xx.h |    8 +
 6 files changed, 419 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 15f4077..eb723f0 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -36,6 +36,7 @@
 #include "wl12xx_80211.h"
 #include "cmd.h"
 #include "event.h"
+#include "tx.h"
 
 #define WL1271_CMD_FAST_POLL_COUNT       50
 
@@ -702,9 +703,9 @@ int wl1271_build_qos_null_data(struct wl1271 *wl)
 				       wl->basic_rate);
 }
 
-int wl1271_cmd_set_default_wep_key(struct wl1271 *wl, u8 id)
+int wl1271_cmd_set_sta_default_wep_key(struct wl1271 *wl, u8 id)
 {
-	struct wl1271_cmd_set_keys *cmd;
+	struct wl1271_cmd_set_sta_keys *cmd;
 	int ret = 0;
 
 	wl1271_debug(DEBUG_CMD, "cmd set_default_wep_key %d", id);
@@ -731,11 +732,42 @@ out:
 	return ret;
 }
 
-int wl1271_cmd_set_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
+int wl1271_cmd_set_ap_default_wep_key(struct wl1271 *wl, u8 id)
+{
+	struct wl1271_cmd_set_ap_keys *cmd;
+	int ret = 0;
+
+	wl1271_debug(DEBUG_CMD, "cmd set_ap_default_wep_key %d", id);
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	cmd->hlid = WL1271_AP_BROADCAST_HLID;
+	cmd->key_id = id;
+	cmd->lid_key_type = WEP_DEFAULT_LID_TYPE;
+	cmd->key_action = cpu_to_le16(KEY_SET_ID);
+	cmd->key_type = KEY_WEP;
+
+	ret = wl1271_cmd_send(wl, CMD_SET_KEYS, cmd, sizeof(*cmd), 0);
+	if (ret < 0) {
+		wl1271_warning("cmd set_ap_default_wep_key failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(cmd);
+
+	return ret;
+}
+
+int wl1271_cmd_set_sta_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
 		       u8 key_size, const u8 *key, const u8 *addr,
 		       u32 tx_seq_32, u16 tx_seq_16)
 {
-	struct wl1271_cmd_set_keys *cmd;
+	struct wl1271_cmd_set_sta_keys *cmd;
 	int ret = 0;
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
@@ -788,6 +820,67 @@ out:
 	return ret;
 }
 
+int wl1271_cmd_set_ap_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
+			u8 key_size, const u8 *key, u8 hlid, u32 tx_seq_32,
+			u16 tx_seq_16)
+{
+	struct wl1271_cmd_set_ap_keys *cmd;
+	int ret = 0;
+	u8 lid_type;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
+
+	if (hlid == WL1271_AP_BROADCAST_HLID) {
+		if (key_type == KEY_WEP)
+			lid_type = WEP_DEFAULT_LID_TYPE;
+		else
+			lid_type = BROADCAST_LID_TYPE;
+	} else {
+		lid_type = UNICAST_LID_TYPE;
+	}
+
+	wl1271_debug(DEBUG_CRYPT, "ap key action: %d id: %d lid: %d type: %d"
+		     " hlid: %d", (int)action, (int)id, (int)lid_type,
+		     (int)key_type, (int)hlid);
+
+	cmd->lid_key_type = lid_type;
+	cmd->hlid = hlid;
+	cmd->key_action = cpu_to_le16(action);
+	cmd->key_size = key_size;
+	cmd->key_type = key_type;
+	cmd->key_id = id;
+	cmd->ac_seq_num16[0] = cpu_to_le16(tx_seq_16);
+	cmd->ac_seq_num32[0] = cpu_to_le32(tx_seq_32);
+
+	if (key_type == KEY_TKIP) {
+		/*
+		 * We get the key in the following form:
+		 * TKIP (16 bytes) - TX MIC (8 bytes) - RX MIC (8 bytes)
+		 * but the target is expecting:
+		 * TKIP - RX MIC - TX MIC
+		 */
+		memcpy(cmd->key, key, 16);
+		memcpy(cmd->key + 16, key + 24, 8);
+		memcpy(cmd->key + 24, key + 16, 8);
+	} else {
+		memcpy(cmd->key, key, key_size);
+	}
+
+	wl1271_dump(DEBUG_CRYPT, "TARGET AP KEY: ", cmd, sizeof(*cmd));
+
+	ret = wl1271_cmd_send(wl, CMD_SET_KEYS, cmd, sizeof(*cmd), 0);
+	if (ret < 0) {
+		wl1271_warning("could not set ap keys");
+		goto out;
+	}
+
+out:
+	kfree(cmd);
+	return ret;
+}
+
 int wl1271_cmd_disconnect(struct wl1271 *wl)
 {
 	struct wl1271_cmd_disconnect *cmd;
@@ -850,3 +943,178 @@ out_free:
 out:
 	return ret;
 }
+
+int wl1271_cmd_start_bss(struct wl1271 *wl)
+{
+	struct wl1271_cmd_bss_start *cmd;
+	struct ieee80211_bss_conf *bss_conf = &wl->vif->bss_conf;
+	int ret;
+
+	wl1271_debug(DEBUG_CMD, "cmd start bss");
+
+	/*
+	 * FIXME: We currently do not support hidden SSID. The real SSID
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
+	memcpy(cmd->bssid, bss_conf->bssid, ETH_ALEN);
+
+	cmd->aging_period = WL1271_AP_DEF_INACTIV_SEC;
+	cmd->bss_index = WL1271_AP_BSS_INDEX;
+	cmd->global_hlid = WL1271_AP_GLOBAL_HLID;
+	cmd->broadcast_hlid = WL1271_AP_BROADCAST_HLID;
+	cmd->basic_rate_set = cpu_to_le32(wl->basic_rate_set);
+	cmd->beacon_interval = cpu_to_le16(wl->beacon_int);
+	cmd->dtim_interval = bss_conf->dtim_period;
+	cmd->beacon_expiry = WL1271_AP_DEF_BEACON_EXP;
+	cmd->channel = wl->channel;
+	cmd->ssid_len = wl->ssid_len;
+	cmd->ssid_type = SSID_TYPE_PUBLIC;
+	memcpy(cmd->ssid, wl->ssid, wl->ssid_len);
+
+	switch (wl->band) {
+	case IEEE80211_BAND_2GHZ:
+		cmd->band = RADIO_BAND_2_4GHZ;
+		break;
+	case IEEE80211_BAND_5GHZ:
+		cmd->band = RADIO_BAND_5GHZ;
+		break;
+	default:
+		wl1271_warning("bss start - unknown band: %d", (int)wl->band);
+		cmd->band = RADIO_BAND_2_4GHZ;
+		break;
+	}
+
+	ret = wl1271_cmd_send(wl, CMD_BSS_START, cmd, sizeof(*cmd), 0);
+	if (ret < 0) {
+		wl1271_error("failed to initiate cmd start bss");
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
+int wl1271_cmd_stop_bss(struct wl1271 *wl)
+{
+	struct wl1271_cmd_bss_start *cmd;
+	int ret;
+
+	wl1271_debug(DEBUG_CMD, "cmd stop bss");
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	cmd->bss_index = WL1271_AP_BSS_INDEX;
+
+	ret = wl1271_cmd_send(wl, CMD_BSS_STOP, cmd, sizeof(*cmd), 0);
+	if (ret < 0) {
+		wl1271_error("failed to initiate cmd stop bss");
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
+int wl1271_cmd_add_sta(struct wl1271 *wl, struct ieee80211_sta *sta, u8 hlid)
+{
+	struct wl1271_cmd_add_sta *cmd;
+	int ret;
+
+	wl1271_debug(DEBUG_CMD, "cmd add sta %d", (int)hlid);
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* currently we don't support UAPSD */
+	cmd->sp_len = 0;
+
+	memcpy(cmd->addr, sta->addr, ETH_ALEN);
+	cmd->bss_index = WL1271_AP_BSS_INDEX;
+	cmd->aid = sta->aid;
+	cmd->hlid = hlid;
+
+	/*
+	 * FIXME: Does STA support QOS? We need to propagate this info from
+	 * hostapd. Currently not that important since this is only used for
+	 * sending the correct flavor of null-data packet in response to a
+	 * trigger.
+	 */
+	cmd->wmm = 0;
+
+	cmd->supported_rates = cpu_to_le32(wl1271_tx_enabled_rates_get(wl,
+						sta->supp_rates[wl->band]));
+
+	wl1271_debug(DEBUG_CMD, "new sta rates: 0x%x", cmd->supported_rates);
+
+	ret = wl1271_cmd_send(wl, CMD_ADD_STA, cmd, sizeof(*cmd), 0);
+	if (ret < 0) {
+		wl1271_error("failed to initiate cmd add sta");
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
+int wl1271_cmd_remove_sta(struct wl1271 *wl, u8 hlid)
+{
+	struct wl1271_cmd_remove_sta *cmd;
+	int ret;
+
+	wl1271_debug(DEBUG_CMD, "cmd remove sta %d", (int)hlid);
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	cmd->hlid = hlid;
+	/* We never send a deauth, mac80211 is in charge of this */
+	cmd->reason_opcode = 0;
+	cmd->send_deauth_flag = 0;
+
+	ret = wl1271_cmd_send(wl, CMD_REMOVE_STA, cmd, sizeof(*cmd), 0);
+	if (ret < 0) {
+		wl1271_error("failed to initiate cmd remove sta");
+		goto out_free;
+	}
+
+	ret = wl1271_cmd_wait_for_event(wl, STA_REMOVE_COMPLETE_EVENT_ID);
+	if (ret < 0)
+		wl1271_error("cmd remove sta event completion error");
+
+out_free:
+	kfree(cmd);
+
+out:
+	return ret;
+}
diff --git a/drivers/net/wireless/wl12xx/cmd.h b/drivers/net/wireless/wl12xx/cmd.h
index 2a1d9db..072bf3c 100644
--- a/drivers/net/wireless/wl12xx/cmd.h
+++ b/drivers/net/wireless/wl12xx/cmd.h
@@ -54,12 +54,20 @@ struct sk_buff *wl1271_cmd_build_ap_probe_req(struct wl1271 *wl,
 int wl1271_cmd_build_arp_rsp(struct wl1271 *wl, __be32 ip_addr);
 int wl1271_build_qos_null_data(struct wl1271 *wl);
 int wl1271_cmd_build_klv_null_data(struct wl1271 *wl);
-int wl1271_cmd_set_default_wep_key(struct wl1271 *wl, u8 id);
-int wl1271_cmd_set_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
-		       u8 key_size, const u8 *key, const u8 *addr,
-		       u32 tx_seq_32, u16 tx_seq_16);
+int wl1271_cmd_set_sta_default_wep_key(struct wl1271 *wl, u8 id);
+int wl1271_cmd_set_ap_default_wep_key(struct wl1271 *wl, u8 id);
+int wl1271_cmd_set_sta_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
+			   u8 key_size, const u8 *key, const u8 *addr,
+			   u32 tx_seq_32, u16 tx_seq_16);
+int wl1271_cmd_set_ap_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
+			  u8 key_size, const u8 *key, u8 hlid, u32 tx_seq_32,
+			  u16 tx_seq_16);
 int wl1271_cmd_disconnect(struct wl1271 *wl);
 int wl1271_cmd_set_sta_state(struct wl1271 *wl);
+int wl1271_cmd_start_bss(struct wl1271 *wl);
+int wl1271_cmd_stop_bss(struct wl1271 *wl);
+int wl1271_cmd_add_sta(struct wl1271 *wl, struct ieee80211_sta *sta, u8 hlid);
+int wl1271_cmd_remove_sta(struct wl1271 *wl, u8 hlid);
 
 enum wl1271_commands {
 	CMD_INTERROGATE     = 1,    /*use this to read information elements*/
@@ -98,6 +106,12 @@ enum wl1271_commands {
 	CMD_STOP_PERIODIC_SCAN       = 51,
 	CMD_SET_STA_STATE            = 52,
 
+	/* AP mode commands */
+	CMD_BSS_START                = 60,
+	CMD_BSS_STOP                 = 61,
+	CMD_ADD_STA                  = 62,
+	CMD_REMOVE_STA               = 63,
+
 	NUM_COMMANDS,
 	MAX_COMMAND_ID = 0xFFFF,
 };
@@ -289,7 +303,7 @@ enum wl1271_cmd_key_type {
 
 /* FIXME: Add description for key-types */
 
-struct wl1271_cmd_set_keys {
+struct wl1271_cmd_set_sta_keys {
 	struct wl1271_cmd_header header;
 
 	/* Ignored for default WEP key */
@@ -318,6 +332,57 @@ struct wl1271_cmd_set_keys {
 	__le32 ac_seq_num32[NUM_ACCESS_CATEGORIES_COPY];
 } __packed;
 
+enum wl1271_cmd_lid_key_type {
+	UNICAST_LID_TYPE     = 0,
+	BROADCAST_LID_TYPE   = 1,
+	WEP_DEFAULT_LID_TYPE = 2
+};
+
+struct wl1271_cmd_set_ap_keys {
+	struct wl1271_cmd_header header;
+
+	/*
+	 * Indicates whether the HLID is a unicast key set
+	 * or broadcast key set. A special value 0xFF is
+	 * used to indicate that the HLID is on WEP-default
+	 * (multi-hlids). of type wl1271_cmd_lid_key_type.
+	 */
+	u8 hlid;
+
+	/*
+	 * In WEP-default network (hlid == 0xFF) used to
+	 * indicate which network STA/IBSS/AP role should be
+	 * changed
+	 */
+	u8 lid_key_type;
+
+	/*
+	 * Key ID - For TKIP and AES key types, this field
+	 * indicates the value that should be inserted into
+	 * the KeyID field of frames transmitted using this
+	 * key entry. For broadcast keys the index use as a
+	 * marker for TX/RX key.
+	 * For WEP default network (HLID=0xFF), this field
+	 * indicates the ID of the key to add or remove.
+	 */
+	u8 key_id;
+	u8 reserved_1;
+
+	/* key_action_e */
+	__le16 key_action;
+
+	/* key size in bytes */
+	u8 key_size;
+
+	/* key_type_e */
+	u8 key_type;
+
+	/* This field holds the security key data to add to the STA table */
+	u8 key[MAX_KEY_SIZE];
+	__le16 ac_seq_num16[NUM_ACCESS_CATEGORIES_COPY];
+	__le32 ac_seq_num32[NUM_ACCESS_CATEGORIES_COPY];
+} __packed;
+
 struct wl1271_cmd_test_header {
 	u8 id;
 	u8 padding[3];
@@ -412,4 +477,68 @@ struct wl1271_cmd_set_sta_state {
 	u8 padding[3];
 } __packed;
 
+enum wl1271_ssid_type {
+	SSID_TYPE_PUBLIC = 0,
+	SSID_TYPE_HIDDEN = 1
+};
+
+struct wl1271_cmd_bss_start {
+	struct wl1271_cmd_header header;
+
+	/* wl1271_ssid_type */
+	u8 ssid_type;
+	u8 ssid_len;
+	u8 ssid[IW_ESSID_MAX_SIZE];
+	u8 padding_1[2];
+
+	/* Basic rate set */
+	__le32 basic_rate_set;
+	/* Aging period in seconds*/
+	__le16 aging_period;
+
+	/*
+	 * This field specifies the time between target beacon
+	 * transmission times (TBTTs), in time units (TUs).
+	 * Valid values are 1 to 1024.
+	 */
+	__le16 beacon_interval;
+	u8 bssid[ETH_ALEN];
+	u8 bss_index;
+	/* Radio band */
+	u8 band;
+	u8 channel;
+	/* The host link id for the AP's global queue */
+	u8 global_hlid;
+	/* The host link id for the AP's broadcast queue */
+	u8 broadcast_hlid;
+	/* DTIM count */
+	u8 dtim_interval;
+	/* Beacon expiry time in ms */
+	u8 beacon_expiry;
+	u8 padding_2[3];
+} __packed;
+
+struct wl1271_cmd_add_sta {
+	struct wl1271_cmd_header header;
+
+	u8 addr[ETH_ALEN];
+	u8 hlid;
+	u8 aid;
+	u8 psd_type[NUM_ACCESS_CATEGORIES_COPY];
+	__le32 supported_rates;
+	u8 bss_index;
+	u8 sp_len;
+	u8 wmm;
+	u8 padding1;
+} __packed;
+
+struct wl1271_cmd_remove_sta {
+	struct wl1271_cmd_header header;
+
+	u8 hlid;
+	u8 reason_opcode;
+	u8 send_deauth_flag;
+	u8 padding1;
+} __packed;
+
 #endif /* __WL1271_CMD_H__ */
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index f468d71..799c369 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -41,7 +41,7 @@ static int wl1271_init_hwenc_config(struct wl1271 *wl)
 		return ret;
 	}
 
-	ret = wl1271_cmd_set_default_wep_key(wl, wl->default_key);
+	ret = wl1271_cmd_set_sta_default_wep_key(wl, wl->default_key);
 	if (ret < 0) {
 		wl1271_warning("couldn't set default key");
 		return ret;
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index b40568e..9785b4c 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1712,7 +1712,7 @@ static int wl1271_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	switch (cmd) {
 	case SET_KEY:
-		ret = wl1271_cmd_set_key(wl, KEY_ADD_OR_REPLACE,
+		ret = wl1271_cmd_set_sta_key(wl, KEY_ADD_OR_REPLACE,
 					 key_conf->keyidx, key_type,
 					 key_conf->keylen, key_conf->key,
 					 addr, tx_seq_32, tx_seq_16);
@@ -1723,7 +1723,7 @@ static int wl1271_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 		/* the default WEP key needs to be configured at least once */
 		if (key_type == KEY_WEP) {
-			ret = wl1271_cmd_set_default_wep_key(wl,
+			ret = wl1271_cmd_set_sta_default_wep_key(wl,
 							     wl->default_key);
 			if (ret < 0)
 				goto out_sleep;
@@ -1738,7 +1738,7 @@ static int wl1271_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		if (!is_broadcast_ether_addr(addr))
 			break;
 
-		ret = wl1271_cmd_set_key(wl, KEY_REMOVE,
+		ret = wl1271_cmd_set_sta_key(wl, KEY_REMOVE,
 					 key_conf->keyidx, key_type,
 					 key_conf->keylen, key_conf->key,
 					 addr, 0, 0);
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 0cf210d..442a7bd 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -170,7 +170,7 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct sk_buff *skb,
 
 		/* FIXME: do we have to do this if we're not using WEP? */
 		if (unlikely(wl->default_key != idx)) {
-			ret = wl1271_cmd_set_default_wep_key(wl, idx);
+			ret = wl1271_cmd_set_sta_default_wep_key(wl, idx);
 			if (ret < 0)
 				return ret;
 			wl->default_key = idx;
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 01711fe..aba8f47 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -129,6 +129,14 @@ extern u32 wl12xx_debug_level;
 #define WL1271_DEFAULT_BEACON_INT  100
 #define WL1271_DEFAULT_DTIM_PERIOD 1
 
+#define WL1271_AP_GLOBAL_HLID      0
+#define WL1271_AP_BROADCAST_HLID   1
+#define WL1271_AP_STA_HLID_START   2
+
+#define WL1271_AP_BSS_INDEX        0
+#define WL1271_AP_DEF_INACTIV_SEC  300
+#define WL1271_AP_DEF_BEACON_EXP   20
+
 #define ACX_TX_DESCRIPTORS         32
 
 #define WL1271_AGGR_BUFFER_SIZE (4 * PAGE_SIZE)
-- 
1.7.1

