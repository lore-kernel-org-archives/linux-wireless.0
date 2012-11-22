Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64728 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087Ab2KVStX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2012 13:49:23 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so3043119eek.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Nov 2012 10:49:21 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 09/13] wlcore: pass wmm configuration to the fw
Date: Thu, 22 Nov 2012 14:05:24 +0200
Message-Id: <1353585928-28666-10-git-send-email-eliad@wizery.com> (sfid-20121122_195016_720105_CC639B1E)
In-Reply-To: <1353585928-28666-1-git-send-email-eliad@wizery.com>
References: <1353585928-28666-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

New fields were added to start_role(ap) and
set_peer_state commands, so the fw will be
able to know whether the sta/ap supports
wmm (the fw uses it in order to choose the
AC for some of its internally-generated frames)

For sta, take this value right from bss_conf->qos.

For ap, check for wmm support by looking for the
WMM IE in the configured beacon.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/cmd.c      |    8 +++++++-
 drivers/net/wireless/ti/wlcore/cmd.h      |   20 +++++++++++++++++---
 drivers/net/wireless/ti/wlcore/main.c     |   11 +++++++++--
 drivers/net/wireless/ti/wlcore/wlcore_i.h |    2 ++
 4 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 63102f2..b2ebe39 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -570,6 +570,7 @@ int wl12xx_cmd_role_start_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	cmd->ap.beacon_expiry = WL1271_AP_DEF_BEACON_EXP;
 	/* FIXME: Change when adding DFS */
 	cmd->ap.reset_tsf = 1;  /* By default reset AP TSF */
+	cmd->ap.wmm = wlvif->wmm_enabled;
 	cmd->channel = wlvif->channel;
 	cmd->channel_type = wlcore_get_native_channel_type(wlvif->channel_type);
 
@@ -1363,7 +1364,8 @@ out:
 	return ret;
 }
 
-int wl12xx_cmd_set_peer_state(struct wl1271 *wl, u8 hlid)
+int wl12xx_cmd_set_peer_state(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			      u8 hlid)
 {
 	struct wl12xx_cmd_set_peer_state *cmd;
 	int ret = 0;
@@ -1379,6 +1381,10 @@ int wl12xx_cmd_set_peer_state(struct wl1271 *wl, u8 hlid)
 	cmd->hlid = hlid;
 	cmd->state = WL1271_CMD_STA_STATE_CONNECTED;
 
+	/* wmm param is valid only for station role */
+	if (wlvif->bss_type == BSS_TYPE_STA_BSS)
+		cmd->wmm = wlvif->wmm_enabled;
+
 	ret = wl1271_cmd_send(wl, CMD_SET_PEER_STATE, cmd, sizeof(*cmd), 0);
 	if (ret < 0) {
 		wl1271_error("failed to send set peer state command");
diff --git a/drivers/net/wireless/ti/wlcore/cmd.h b/drivers/net/wireless/ti/wlcore/cmd.h
index 46513da..2070a10 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.h
+++ b/drivers/net/wireless/ti/wlcore/cmd.h
@@ -76,7 +76,8 @@ int wl1271_cmd_set_ap_key(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			  u16 action, u8 id, u8 key_type,
 			  u8 key_size, const u8 *key, u8 hlid, u32 tx_seq_32,
 			  u16 tx_seq_16);
-int wl12xx_cmd_set_peer_state(struct wl1271 *wl, u8 hlid);
+int wl12xx_cmd_set_peer_state(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			      u8 hlid);
 int wl12xx_roc(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 role_id,
 	       enum ieee80211_band band, u8 channel);
 int wl12xx_croc(struct wl1271 *wl, u8 role_id);
@@ -355,7 +356,13 @@ struct wl12xx_cmd_role_start {
 
 			u8 reset_tsf;
 
-			u8 padding_1[4];
+			/*
+			 * ap supports wmm (note that there is additional
+			 * per-sta wmm configuration)
+			 */
+			u8 wmm;
+
+			u8 padding_1[3];
 		} __packed ap;
 	};
 } __packed;
@@ -525,7 +532,14 @@ struct wl12xx_cmd_set_peer_state {
 
 	u8 hlid;
 	u8 state;
-	u8 padding[2];
+
+	/*
+	 * wmm is relevant for sta role only.
+	 * ap role configures the per-sta wmm params in
+	 * the add_peer command.
+	 */
+	u8 wmm;
+	u8 padding[1];
 } __packed;
 
 struct wl12xx_cmd_roc {
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 7b43c6c..5924309 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -79,7 +79,7 @@ static int wl12xx_set_authorized(struct wl1271 *wl,
 	if (test_and_set_bit(WLVIF_FLAG_STA_STATE_SENT, &wlvif->flags))
 		return 0;
 
-	ret = wl12xx_cmd_set_peer_state(wl, wlvif->sta.hlid);
+	ret = wl12xx_cmd_set_peer_state(wl, wlvif, wlvif->sta.hlid);
 	if (ret < 0)
 		return ret;
 
@@ -2630,6 +2630,7 @@ static int wlcore_set_assoc(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	wlvif->aid = bss_conf->aid;
 	wlvif->channel_type = bss_conf->channel_type;
 	wlvif->beacon_int = bss_conf->beacon_int;
+	wlvif->wmm_enabled = bss_conf->qos;
 
 	set_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags);
 
@@ -3692,6 +3693,12 @@ static int wlcore_set_beacon_template(struct wl1271 *wl,
 		goto out;
 	}
 
+	wlvif->wmm_enabled =
+		cfg80211_find_vendor_ie(WLAN_OUI_MICROSOFT,
+					WLAN_OUI_TYPE_MICROSOFT_WMM,
+					beacon->data + ieoffset,
+					beacon->len - ieoffset);
+
 	/*
 	 * In case we already have a probe-resp beacon set explicitly
 	 * by usermode, don't use the beacon data.
@@ -4478,7 +4485,7 @@ static int wl12xx_update_sta_state(struct wl1271 *wl,
 	/* Authorize station (AP mode) */
 	if (is_ap &&
 	    new_state == IEEE80211_STA_AUTHORIZED) {
-		ret = wl12xx_cmd_set_peer_state(wl, hlid);
+		ret = wl12xx_cmd_set_peer_state(wl, wlvif, hlid);
 		if (ret < 0)
 			return ret;
 
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index bc3b5f4..8478bbc 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -416,6 +416,8 @@ struct wl12xx_vif {
 	bool ba_support;
 	bool ba_allowed;
 
+	bool wmm_enabled;
+
 	/* Rx Streaming */
 	struct work_struct rx_streaming_enable_work;
 	struct work_struct rx_streaming_disable_work;
-- 
1.7.6.401.g6a319

