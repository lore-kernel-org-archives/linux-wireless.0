Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:43430 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933821AbZJMJuR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 05:50:17 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Subject: [PATCH 12/22] wl1271: Scan only enabled channels
Date: Tue, 13 Oct 2009 12:47:49 +0300
Message-Id: <1255427279-1224-13-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255427279-1224-1-git-send-email-luciano.coelho@nokia.com>
References: <1255427279-1224-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>

Added checking of whether channel is enabled or disabled by mac80211
stack to scan. Disabled channels are not scanned.

Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_cmd.c |   33 +++++++++++++++++++----------
 1 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index f38e3e0..204e872 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -515,12 +515,16 @@ int wl1271_cmd_scan(struct wl1271 *wl, u8 *ssid, size_t len,
 
 	struct wl1271_cmd_trigger_scan_to *trigger = NULL;
 	struct wl1271_cmd_scan *params = NULL;
-	int i, ret;
+	struct ieee80211_channel *channels;
+	int i, j, n_ch, ret;
 	u16 scan_options = 0;
 
 	if (wl->scanning)
 		return -EINVAL;
 
+	channels = wl->hw->wiphy->bands[IEEE80211_BAND_2GHZ]->channels;
+	n_ch = wl->hw->wiphy->bands[IEEE80211_BAND_2GHZ]->n_channels;
+
 	params = kzalloc(sizeof(*params), GFP_KERNEL);
 	if (!params)
 		return -ENOMEM;
@@ -535,24 +539,29 @@ int wl1271_cmd_scan(struct wl1271 *wl, u8 *ssid, size_t len,
 		scan_options |= WL1271_SCAN_OPT_PRIORITY_HIGH;
 	params->params.scan_options = scan_options;
 
-	params->params.num_channels = num_channels;
 	params->params.num_probe_requests = probe_requests;
 	params->params.tx_rate = cpu_to_le32(CONF_HW_BIT_RATE_2MBPS);
 	params->params.tid_trigger = 0;
 	params->params.scan_tag = WL1271_SCAN_DEFAULT_TAG;
 
-	for (i = 0; i < num_channels; i++) {
-		params->channels[i].min_duration =
-			cpu_to_le32(WL1271_SCAN_CHAN_MIN_DURATION);
-		params->channels[i].max_duration =
-			cpu_to_le32(WL1271_SCAN_CHAN_MAX_DURATION);
-		memset(&params->channels[i].bssid_lsb, 0xff, 4);
-		memset(&params->channels[i].bssid_msb, 0xff, 2);
-		params->channels[i].early_termination = 0;
-		params->channels[i].tx_power_att = WL1271_SCAN_CURRENT_TX_PWR;
-		params->channels[i].channel = i + 1;
+	for (i = 0, j = 0; i < n_ch && i < WL1271_SCAN_MAX_CHANNELS; i++) {
+		if (!(channels[i].flags & IEEE80211_CHAN_DISABLED)) {
+			params->channels[j].min_duration =
+				cpu_to_le32(WL1271_SCAN_CHAN_MIN_DURATION);
+			params->channels[j].max_duration =
+				cpu_to_le32(WL1271_SCAN_CHAN_MAX_DURATION);
+			memset(&params->channels[j].bssid_lsb, 0xff, 4);
+			memset(&params->channels[j].bssid_msb, 0xff, 2);
+			params->channels[j].early_termination = 0;
+			params->channels[j].tx_power_att =
+				WL1271_SCAN_CURRENT_TX_PWR;
+			params->channels[j].channel = channels[i].hw_value;
+			j++;
+		}
 	}
 
+	params->params.num_channels = j;
+
 	if (len && ssid) {
 		params->params.ssid_len = len;
 		memcpy(params->params.ssid, ssid, len);
-- 
1.5.6.5

