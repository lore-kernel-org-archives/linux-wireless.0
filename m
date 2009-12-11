Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:61318 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757339AbZLKNlW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 08:41:22 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 05/31] wl1271: use join command with dummy BSSID
Date: Fri, 11 Dec 2009 15:40:44 +0200
Message-Id: <1260538870-32297-6-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1260538870-32297-1-git-send-email-luciano.coelho@nokia.com>
References: <1260538870-32297-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we need to change the channel before association, we have to send a join
command with a valid BSSID.  With this patch we use 0baddeadbeef as the
BSSID.  There are ongoing discussions with TI to get this done in a cleaner
way.

When we go back to idle, we issue a CMD_DISCONNECT to make sure the firmware
stops listening to the channel and cleans things up internally.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |   75 +++++++++++++++++++++++++----
 1 files changed, 65 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index f1cb7cb..f6d42e6 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1130,6 +1130,47 @@ out:
 }
 #endif
 
+static int wl1271_join_channel(struct wl1271 *wl, int channel)
+{
+	int ret;
+	/* we need to use a dummy BSSID for now */
+	static const u8 dummy_bssid[ETH_ALEN] = { 0x0b, 0xad, 0xde,
+						  0xad, 0xbe, 0xef };
+
+	/* disable mac filter, so we hear everything */
+	wl->rx_config &= ~CFG_BSSID_FILTER_EN;
+
+	wl->channel = channel;
+	memcpy(wl->bssid, dummy_bssid, ETH_ALEN);
+
+	ret = wl1271_cmd_join(wl);
+	if (ret < 0)
+		goto out;
+
+	wl->joined = true;
+
+out:
+	return ret;
+}
+
+static int wl1271_unjoin_channel(struct wl1271 *wl)
+{
+	int ret;
+
+	/* to stop listening to a channel, we disconnect */
+	ret = wl1271_cmd_disconnect(wl);
+	if (ret < 0)
+		goto out;
+
+	wl->joined = false;
+	wl->channel = 0;
+	memset(wl->bssid, 0, ETH_ALEN);
+	wl->rx_config = WL1271_DEFAULT_RX_CONFIG;
+
+out:
+	return ret;
+}
+
 static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct wl1271 *wl = hw->priv;
@@ -1138,10 +1179,11 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 
 	channel = ieee80211_frequency_to_channel(conf->channel->center_freq);
 
-	wl1271_debug(DEBUG_MAC80211, "mac80211 config ch %d psm %s power %d",
+	wl1271_debug(DEBUG_MAC80211, "mac80211 config ch %d psm %s power %d %s",
 		     channel,
 		     conf->flags & IEEE80211_CONF_PS ? "on" : "off",
-		     conf->power_level);
+		     conf->power_level,
+		     conf->flags & IEEE80211_CONF_IDLE ? "idle" : "in use");
 
 	mutex_lock(&wl->mutex);
 
@@ -1151,16 +1193,17 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 	if (ret < 0)
 		goto out;
 
-	if (channel != wl->channel) {
-		/*
-		 * We assume that the stack will configure the right channel
-		 * before associating, so we don't need to send a join
-		 * command here.  We will join the right channel when the
-		 * BSSID changes
-		 */
-		wl->channel = channel;
+	if (changed & IEEE80211_CONF_CHANGE_IDLE) {
+		if (conf->flags & IEEE80211_CONF_IDLE && wl->joined)
+			wl1271_unjoin_channel(wl);
+		else
+			wl1271_join_channel(wl, channel);
 	}
 
+	/* if the channel changes while joined, join again */
+	if (channel != wl->channel && wl->joined)
+		wl1271_join_channel(wl, channel);
+
 	if (conf->flags & IEEE80211_CONF_PS && !wl->psm_requested) {
 		wl1271_info("psm enabled");
 
@@ -1494,6 +1537,18 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 	if (ret < 0)
 		goto out;
 
+	if ((changed & BSS_CHANGED_BSSID) &&
+	    /*
+	     * Now we know the correct bssid, so we send a new join command
+	     * and enable the BSSID filter
+	     */
+	    memcmp(wl->bssid, bss_conf->bssid, ETH_ALEN)) {
+			wl->rx_config |= CFG_BSSID_FILTER_EN;
+			memcpy(wl->bssid, bss_conf->bssid, ETH_ALEN);
+			wl1271_cmd_join(wl);
+			wl->joined = true;
+	}
+
 	if (changed & BSS_CHANGED_ASSOC) {
 		if (bss_conf->assoc) {
 			wl->aid = bss_conf->aid;
-- 
1.6.3.3

