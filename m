Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:38209 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903Ab2KSQjy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 11:39:54 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so2051752eaa.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Nov 2012 08:39:54 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 12/15] wlcore: specify correct supported_rates
Date: Mon, 19 Nov 2012 18:39:27 +0200
Message-Id: <1353343170-26516-13-git-send-email-eliad@wizery.com> (sfid-20121119_174526_079130_CBB7FFE9)
In-Reply-To: <1353343170-26516-1-git-send-email-eliad@wizery.com>
References: <1353343170-26516-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The supported_rates field should contain all our supported
rates, even if the remote peer doesn't support them.

(use CONF_TX_AP_ENABLED_RATES for bg rates, as the possible
rates are the same for ap and sta)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/cmd.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 28a235f..4c2ed25 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -441,6 +441,7 @@ int wl12xx_cmd_role_start_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
 	struct wl12xx_cmd_role_start *cmd;
+	u32 supported_rates;
 	int ret;
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
@@ -461,7 +462,14 @@ int wl12xx_cmd_role_start_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	cmd->sta.ssid_len = wlvif->ssid_len;
 	memcpy(cmd->sta.ssid, wlvif->ssid, wlvif->ssid_len);
 	memcpy(cmd->sta.bssid, vif->bss_conf.bssid, ETH_ALEN);
-	cmd->sta.local_rates = cpu_to_le32(wlvif->rate_set);
+
+	supported_rates = CONF_TX_AP_ENABLED_RATES | CONF_TX_MCS_RATES |
+			  wlcore_hw_sta_get_ap_rate_mask(wl, wlvif);
+	if (wlvif->p2p)
+		supported_rates &= ~CONF_TX_CCK_RATES;
+
+	cmd->sta.local_rates = cpu_to_le32(supported_rates);
+
 	cmd->channel_type = wlcore_get_native_channel_type(wlvif->channel_type);
 
 	if (wlvif->sta.hlid == WL12XX_INVALID_LINK_ID) {
-- 
1.7.6.401.g6a319

