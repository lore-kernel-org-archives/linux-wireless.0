Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:22071 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756700AbZLKLmJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 06:42:09 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 25/31] wl1271: Add rudimentary ad-hoc support
Date: Fri, 11 Dec 2009 13:41:16 +0200
Message-Id: <1260531682-4695-26-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1260531682-4695-1-git-send-email-luciano.coelho@nokia.com>
References: <1260531682-4695-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

This patch adds rudimentary a-hoc support for the driver. It will allow
setting up ad-hoc, and for other devices to scan and join. The beacon and probe
response template setting is slightly dirty, and need to be properly
implemented with support from mac80211. Also, the SSID is not configured to the
firmware - the FW will not be able to respond to probe requests autonomously.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |   45 +++++++++++++++++++++++++++-
 1 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 446fb26..8d090e4 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1139,11 +1139,15 @@ out:
 
 static int wl1271_join_channel(struct wl1271 *wl, int channel)
 {
-	int ret;
+	int ret = 0;
 	/* we need to use a dummy BSSID for now */
 	static const u8 dummy_bssid[ETH_ALEN] = { 0x0b, 0xad, 0xde,
 						  0xad, 0xbe, 0xef };
 
+	/* the dummy join is not required for ad-hoc */
+	if (wl->bss_type == BSS_TYPE_IBSS)
+		goto out;
+
 	/* disable mac filter, so we hear everything */
 	wl->rx_config &= ~CFG_BSSID_FILTER_EN;
 
@@ -1572,6 +1576,42 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 			wl->joined = true;
 	}
 
+	if (wl->bss_type == BSS_TYPE_IBSS) {
+		/* FIXME: This implements rudimentary ad-hoc support -
+		   proper templates are on the wish list and notification
+		   on when they change. This patch will update the templates
+		   on every call to this function. Also, the firmware will not
+		   answer to probe-requests as it does not have the proper
+		   SSID set in the JOIN command. The probe-response template
+		   is set nevertheless, as the FW will ASSERT without it */
+		struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
+
+		if (beacon) {
+			struct ieee80211_hdr *hdr;
+			ret = wl1271_cmd_template_set(wl, CMD_TEMPL_BEACON,
+						      beacon->data,
+						      beacon->len);
+
+			if (ret < 0) {
+				dev_kfree_skb(beacon);
+				goto out_sleep;
+			}
+
+			hdr = (struct ieee80211_hdr *) beacon->data;
+			hdr->frame_control = cpu_to_le16(
+				IEEE80211_FTYPE_MGMT |
+				IEEE80211_STYPE_PROBE_RESP);
+
+			ret = wl1271_cmd_template_set(wl,
+						      CMD_TEMPL_PROBE_RESPONSE,
+						      beacon->data,
+						      beacon->len);
+			dev_kfree_skb(beacon);
+			if (ret < 0)
+				goto out_sleep;
+		}
+	}
+
 	if (changed & BSS_CHANGED_ASSOC) {
 		if (bss_conf->assoc) {
 			wl->aid = bss_conf->aid;
@@ -1857,7 +1897,8 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
 		IEEE80211_HW_BEACON_FILTER |
 		IEEE80211_HW_SUPPORTS_PS;
 
-	wl->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
+	wl->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
+		BIT(NL80211_IFTYPE_ADHOC);
 	wl->hw->wiphy->max_scan_ssids = 1;
 	wl->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &wl1271_band_2ghz;
 
-- 
1.6.3.3

