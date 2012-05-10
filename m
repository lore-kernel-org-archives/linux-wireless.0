Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61669 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758061Ab2EJJP1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:15:27 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so1110716wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:15:27 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 26/78] wl18xx: send channel type to FW on role start
Date: Thu, 10 May 2012 12:13:31 +0300
Message-Id: <1336641263-5761-27-git-send-email-arik@wizery.com> (sfid-20120510_112253_492885_B9DDF159)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Translate the NL80211 channel type to a FW-specific channel type and send
it to the FW as part of the role-start command. For wl12xx this has no
effect - this element is treated as padding.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/cmd.c |   19 +++++++++++++++++++
 drivers/net/wireless/ti/wlcore/cmd.h |   11 ++++++++++-
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 5b128a9..8450f0e 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -291,6 +291,23 @@ static int wl12xx_get_new_session_id(struct wl1271 *wl,
 	return wlvif->session_counter;
 }
 
+static u8 wlcore_get_native_channel_type(u8 nl_channel_type)
+{
+	switch (nl_channel_type) {
+	case NL80211_CHAN_NO_HT:
+		return WLCORE_CHAN_NO_HT;
+	case NL80211_CHAN_HT20:
+		return WLCORE_CHAN_HT20;
+	case NL80211_CHAN_HT40MINUS:
+		return WLCORE_CHAN_HT40MINUS;
+	case NL80211_CHAN_HT40PLUS:
+		return WLCORE_CHAN_HT40PLUS;
+	default:
+		WARN_ON(1);
+		return WLCORE_CHAN_NO_HT;
+	}
+}
+
 static int wl12xx_cmd_role_start_dev(struct wl1271 *wl,
 				     struct wl12xx_vif *wlvif)
 {
@@ -407,6 +424,7 @@ int wl12xx_cmd_role_start_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	memcpy(cmd->sta.ssid, wlvif->ssid, wlvif->ssid_len);
 	memcpy(cmd->sta.bssid, vif->bss_conf.bssid, ETH_ALEN);
 	cmd->sta.local_rates = cpu_to_le32(wlvif->rate_set);
+	cmd->channel_type = wlcore_get_native_channel_type(wlvif->channel_type);
 
 	if (wlvif->sta.hlid == WL12XX_INVALID_LINK_ID) {
 		ret = wl12xx_allocate_link(wl, wlvif, &wlvif->sta.hlid);
@@ -519,6 +537,7 @@ int wl12xx_cmd_role_start_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	/* FIXME: Change when adding DFS */
 	cmd->ap.reset_tsf = 1;  /* By default reset AP TSF */
 	cmd->channel = wlvif->channel;
+	cmd->channel_type = wlcore_get_native_channel_type(wlvif->channel_type);
 
 	if (!bss_conf->hidden_ssid) {
 		/* take the SSID from the beacon for backward compatibility */
diff --git a/drivers/net/wireless/ti/wlcore/cmd.h b/drivers/net/wireless/ti/wlcore/cmd.h
index a46ae07..2aafe3d 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.h
+++ b/drivers/net/wireless/ti/wlcore/cmd.h
@@ -266,13 +266,22 @@ enum wlcore_band {
 	WLCORE_BAND_MAX_RADIO		= 0x7F,
 };
 
+enum wlcore_channel_type {
+	WLCORE_CHAN_NO_HT,
+	WLCORE_CHAN_HT20,
+	WLCORE_CHAN_HT40MINUS,
+	WLCORE_CHAN_HT40PLUS
+};
+
 struct wl12xx_cmd_role_start {
 	struct wl1271_cmd_header header;
 
 	u8 role_id;
 	u8 band;
 	u8 channel;
-	u8 padding;
+
+	/* enum wlcore_channel_type */
+	u8 channel_type;
 
 	union {
 		struct {
-- 
1.7.9.5

