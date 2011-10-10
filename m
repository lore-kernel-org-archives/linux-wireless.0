Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62854 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab1JJINO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 04:13:14 -0400
Received: by mail-ww0-f44.google.com with SMTP id 22so8786663wwf.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 01:13:13 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 22/29] wl12xx: add channel field to wlvif
Date: Mon, 10 Oct 2011 10:13:10 +0200
Message-Id: <1318234397-21081-23-git-send-email-eliad@wizery.com> (sfid-20111010_101320_908163_0EF5C7CA)
In-Reply-To: <1318234397-21081-1-git-send-email-eliad@wizery.com>
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

add channel into the per-interface data.

mac80211 configures some values (e.g. band, channel)
globally, while we configure them per-interface.

In order to make it easier to keep track of the
configured value for each value while keeping sync
with mac80211, save these values both globally
and per-vif.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c    |   12 ++++++------
 drivers/net/wireless/wl12xx/main.c   |    6 ++++--
 drivers/net/wireless/wl12xx/wl12xx.h |    1 +
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 6cf8cdc..4c5c518 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -483,7 +483,7 @@ int wl12xx_cmd_role_start_dev(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	cmd->role_id = wlvif->dev_role_id;
 	if (wlvif->band == IEEE80211_BAND_5GHZ)
 		cmd->band = WL12XX_BAND_5GHZ;
-	cmd->channel = wl->channel;
+	cmd->channel = wlvif->channel;
 
 	if (wlvif->dev_hlid == WL12XX_INVALID_LINK_ID) {
 		ret = wl12xx_allocate_link(wl, wlvif, &wlvif->dev_hlid);
@@ -573,7 +573,7 @@ int wl12xx_cmd_role_start_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	cmd->role_id = wlvif->role_id;
 	if (wlvif->band == IEEE80211_BAND_5GHZ)
 		cmd->band = WL12XX_BAND_5GHZ;
-	cmd->channel = wl->channel;
+	cmd->channel = wlvif->channel;
 	cmd->sta.basic_rate_set = cpu_to_le32(wlvif->basic_rate_set);
 	cmd->sta.beacon_interval = cpu_to_le16(wlvif->beacon_int);
 	cmd->sta.ssid_type = WL12XX_SSID_TYPE_ANY;
@@ -689,7 +689,7 @@ int wl12xx_cmd_role_start_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	cmd->ap.beacon_interval = cpu_to_le16(wlvif->beacon_int);
 	cmd->ap.dtim_interval = bss_conf->dtim_period;
 	cmd->ap.beacon_expiry = WL1271_AP_DEF_BEACON_EXP;
-	cmd->channel = wl->channel;
+	cmd->channel = wlvif->channel;
 
 	if (!bss_conf->hidden_ssid) {
 		/* take the SSID from the beacon for backward compatibility */
@@ -787,7 +787,7 @@ int wl12xx_cmd_role_start_ibss(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	cmd->role_id = wlvif->role_id;
 	if (wlvif->band == IEEE80211_BAND_5GHZ)
 		cmd->band = WL12XX_BAND_5GHZ;
-	cmd->channel = wl->channel;
+	cmd->channel = wlvif->channel;
 	cmd->ibss.basic_rate_set = cpu_to_le32(wlvif->basic_rate_set);
 	cmd->ibss.beacon_interval = cpu_to_le16(wlvif->beacon_int);
 	cmd->ibss.dtim_interval = bss_conf->dtim_period;
@@ -1608,7 +1608,7 @@ static int wl12xx_cmd_roc(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	struct wl12xx_cmd_roc *cmd;
 	int ret = 0;
 
-	wl1271_debug(DEBUG_CMD, "cmd roc %d (%d)", wl->channel, role_id);
+	wl1271_debug(DEBUG_CMD, "cmd roc %d (%d)", wlvif->channel, role_id);
 
 	if (WARN_ON(role_id == WL12XX_INVALID_ROLE_ID))
 		return -EINVAL;
@@ -1620,7 +1620,7 @@ static int wl12xx_cmd_roc(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	}
 
 	cmd->role_id = role_id;
-	cmd->channel = wl->channel;
+	cmd->channel = wlvif->channel;
 	switch (wlvif->band) {
 	case IEEE80211_BAND_2GHZ:
 		cmd->band = RADIO_BAND_2_4GHZ;
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 0974ed6..0536808 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1973,6 +1973,7 @@ static int wl12xx_init_vif_data(struct wl1271 *wl, struct ieee80211_vif *vif)
 	 * per-interface. thus, on init, we have to copy them from wl
 	 */
 	wlvif->band = wl->band;
+	wlvif->channel = wl->channel;
 
 	INIT_WORK(&wlvif->rx_streaming_enable_work,
 		  wl1271_rx_streaming_enable_work);
@@ -2448,12 +2449,13 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 	/* if the channel changes while joined, join again */
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL &&
 	    ((wlvif->band != conf->channel->band) ||
-	     (wl->channel != channel))) {
+	     (wlvif->channel != channel))) {
 		/* send all pending packets */
 		wl1271_tx_work_locked(wl);
 		wl->band = conf->channel->band;
-		wlvif->band = conf->channel->band;
 		wl->channel = channel;
+		wlvif->band = conf->channel->band;
+		wlvif->channel = channel;
 
 		if (!is_ap) {
 			/*
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 20188ea..16e1022 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -591,6 +591,7 @@ struct wl12xx_vif {
 
 	/* The current band */
 	enum ieee80211_band band;
+	int channel;
 
 	u32 bitrate_masks[IEEE80211_NUM_BANDS];
 	u32 basic_rate_set;
-- 
1.7.6.401.g6a319

