Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47541 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab2A3L5s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 06:57:48 -0500
Received: by wgbed3 with SMTP id ed3so4506776wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jan 2012 03:57:46 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 06/12] wl12xx: Driver-FW API changes
Date: Mon, 30 Jan 2012 14:00:51 +0200
Message-Id: <1327924857-1250-7-git-send-email-eliad@wizery.com> (sfid-20120130_125753_277041_7C6EFA2A)
In-Reply-To: <1327924857-1250-1-git-send-email-eliad@wizery.com>
References: <1327924857-1250-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

- New ACX enum
- Added DFS commands
- Changes to channel switch command/event
- Added reset_tsf to ap role start command
- Added ACX for PROTECTION configuration

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c  |   10 ++++++++--
 drivers/net/wireless/wl12xx/cmd.h  |   17 ++++++++++++-----
 drivers/net/wireless/wl12xx/main.c |    2 +-
 3 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index c4990da..88e94c5 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -715,6 +715,8 @@ int wl12xx_cmd_role_start_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	cmd->ap.beacon_interval = cpu_to_le16(wlvif->beacon_int);
 	cmd->ap.dtim_interval = bss_conf->dtim_period;
 	cmd->ap.beacon_expiry = WL1271_AP_DEF_BEACON_EXP;
+	/* FIXME: Change when adding DFS */
+	cmd->ap.reset_tsf = 1;  /* By default reset AP TSF */
 	cmd->channel = wlvif->channel;
 
 	if (!bss_conf->hidden_ssid) {
@@ -1756,6 +1758,7 @@ out:
 }
 
 int wl12xx_cmd_channel_switch(struct wl1271 *wl,
+			      struct wl12xx_vif *wlvif,
 			      struct ieee80211_channel_switch *ch_switch)
 {
 	struct wl12xx_cmd_channel_switch *cmd;
@@ -1769,10 +1772,13 @@ int wl12xx_cmd_channel_switch(struct wl1271 *wl,
 		goto out;
 	}
 
+	cmd->role_id = wlvif->role_id;
 	cmd->channel = ch_switch->channel->hw_value;
 	cmd->switch_time = ch_switch->count;
-	cmd->tx_suspend = ch_switch->block_tx;
-	cmd->flush = 0; /* this value is ignored by the FW */
+	cmd->stop_tx = ch_switch->block_tx;
+
+	/* FIXME: control from mac80211 in the future */
+	cmd->post_switch_tx_disable = 0;  /* Enable TX on the target channel */
 
 	ret = wl1271_cmd_send(wl, CMD_CHANNEL_SWITCH, cmd, sizeof(*cmd), 0);
 	if (ret < 0) {
diff --git a/drivers/net/wireless/wl12xx/cmd.h b/drivers/net/wireless/wl12xx/cmd.h
index faf046b..edd240d 100644
--- a/drivers/net/wireless/wl12xx/cmd.h
+++ b/drivers/net/wireless/wl12xx/cmd.h
@@ -91,6 +91,7 @@ int wl12xx_cmd_config_fwlog(struct wl1271 *wl);
 int wl12xx_cmd_start_fwlog(struct wl1271 *wl);
 int wl12xx_cmd_stop_fwlog(struct wl1271 *wl);
 int wl12xx_cmd_channel_switch(struct wl1271 *wl,
+			      struct wl12xx_vif *wlvif,
 			      struct ieee80211_channel_switch *ch_switch);
 int wl12xx_cmd_stop_channel_switch(struct wl1271 *wl);
 int wl12xx_allocate_link(struct wl1271 *wl, struct wl12xx_vif *wlvif,
@@ -344,7 +345,9 @@ struct wl12xx_cmd_role_start {
 			u8 ssid_len;
 			u8 ssid[IEEE80211_MAX_SSID_LEN];
 
-			u8 padding_1[5];
+			u8 reset_tsf;
+
+			u8 padding_1[4];
 		} __packed ap;
 	};
 } __packed;
@@ -704,14 +707,18 @@ struct wl12xx_cmd_stop_fwlog {
 struct wl12xx_cmd_channel_switch {
 	struct wl1271_cmd_header header;
 
+	u8 role_id;
+
 	/* The new serving channel */
 	u8 channel;
 	/* Relative time of the serving channel switch in TBTT units */
 	u8 switch_time;
-	/* 1: Suspend TX till switch time; 0: Do not suspend TX */
-	u8 tx_suspend;
-	/* 1: Flush TX at switch time; 0: Do not flush */
-	u8 flush;
+	/* Stop the role TX, should expect it after radar detection */
+	u8 stop_tx;
+	/* The target channel tx status 1-stopped 0-open*/
+	u8 post_switch_tx_disable;
+
+	u8 padding[3];
 } __packed;
 
 struct wl12xx_cmd_stop_channel_switch {
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 1c73c01..eac5d52 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -4381,7 +4381,7 @@ static void wl12xx_op_channel_switch(struct ieee80211_hw *hw,
 
 	/* TODO: change mac80211 to pass vif as param */
 	wl12xx_for_each_wlvif_sta(wl, wlvif) {
-		ret = wl12xx_cmd_channel_switch(wl, ch_switch);
+		ret = wl12xx_cmd_channel_switch(wl, wlvif, ch_switch);
 
 		if (!ret)
 			set_bit(WLVIF_FLAG_CS_PROGRESS, &wlvif->flags);
-- 
1.7.6.401.g6a319

