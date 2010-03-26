Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:24419 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338Ab0CZKyR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Mar 2010 06:54:17 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 15/24] wl1271: Fix ad-hoc mode handling
Date: Fri, 26 Mar 2010 12:53:24 +0200
Message-Id: <1269600813-32145-16-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1269600813-32145-1-git-send-email-luciano.coelho@nokia.com>
References: <1269600813-32145-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Fix the driver to better reflect the ad-hoc related configuration from the
mac80211.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    2 +
 drivers/net/wireless/wl12xx/wl1271_main.c |   33 +++++++++++++++++++---------
 2 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index c939680..37ad5cd 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -55,6 +55,7 @@ enum {
 	DEBUG_ACX	= BIT(13),
 	DEBUG_SDIO	= BIT(14),
 	DEBUG_FILTERS   = BIT(15),
+	DEBUG_ADHOC     = BIT(16),
 	DEBUG_ALL	= ~0,
 };
 
@@ -389,6 +390,7 @@ struct wl1271 {
 	u8 bssid[ETH_ALEN];
 	u8 mac_addr[ETH_ALEN];
 	u8 bss_type;
+	u8 set_bss_type;
 	u8 ssid[IW_ESSID_MAX_SIZE + 1];
 	u8 ssid_len;
 	int channel;
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 00e856c..49f37b0 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -958,9 +958,11 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
 		wl->bss_type = BSS_TYPE_STA_BSS;
+		wl->set_bss_type = BSS_TYPE_STA_BSS;
 		break;
 	case NL80211_IFTYPE_ADHOC:
 		wl->bss_type = BSS_TYPE_IBSS;
+		wl->set_bss_type = BSS_TYPE_STA_BSS;
 		break;
 	default:
 		ret = -EOPNOTSUPP;
@@ -1065,6 +1067,7 @@ static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
 	memset(wl->ssid, 0, IW_ESSID_MAX_SIZE + 1);
 	wl->ssid_len = 0;
 	wl->bss_type = MAX_BSS_TYPE;
+	wl->set_bss_type = MAX_BSS_TYPE;
 	wl->band = IEEE80211_BAND_2GHZ;
 
 	wl->rx_counter = 0;
@@ -1137,10 +1140,7 @@ static int wl1271_join_channel(struct wl1271 *wl, int channel)
 	/* pass through frames from all BSS */
 	wl1271_configure_filters(wl, FIF_OTHER_BSS);
 
-	/* the dummy join is performed always with STATION BSS type to allow
-	   also ad-hoc mode to listen to the surroundings without sending any
-	   beacons yet. */
-	ret = wl1271_cmd_join(wl, BSS_TYPE_STA_BSS);
+	ret = wl1271_cmd_join(wl, wl->set_bss_type);
 	if (ret < 0)
 		goto out;
 
@@ -1211,7 +1211,7 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 	    test_bit(WL1271_FLAG_JOINED, &wl->flags)) {
 		wl->channel = channel;
 		/* FIXME: maybe use CMD_CHANNEL_SWITCH for this? */
-		ret = wl1271_cmd_join(wl, wl->bss_type);
+		ret = wl1271_cmd_join(wl, wl->set_bss_type);
 		if (ret < 0)
 			wl1271_warning("cmd join to update channel failed %d",
 				       ret);
@@ -1575,13 +1575,12 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 	if (ret < 0)
 		goto out;
 
-	if (wl->bss_type == BSS_TYPE_IBSS) {
-		/* FIXME: This implements rudimentary ad-hoc support -
-		   proper templates are on the wish list and notification
-		   on when they change. This patch will update the templates
-		   on every call to this function. */
+	if ((changed && BSS_CHANGED_BEACON) &&
+	    (wl->bss_type == BSS_TYPE_IBSS)) {
 		struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
 
+		wl1271_debug(DEBUG_ADHOC, "ad-hoc beacon updated");
+
 		if (beacon) {
 			struct ieee80211_hdr *hdr;
 
@@ -1613,6 +1612,18 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 		}
 	}
 
+	if ((changed & BSS_CHANGED_BEACON_ENABLED) &&
+	    (wl->bss_type == BSS_TYPE_IBSS)) {
+		wl1271_debug(DEBUG_ADHOC, "ad-hoc beaconing: %s",
+			     bss_conf->enable_beacon ? "enabled" : "disabled");
+
+		if (bss_conf->enable_beacon)
+			wl->set_bss_type = BSS_TYPE_IBSS;
+		else
+			wl->set_bss_type = BSS_TYPE_STA_BSS;
+		do_join = true;
+	}
+
 	if ((changed & BSS_CHANGED_BSSID) &&
 	    /*
 	     * Now we know the correct bssid, so we send a new join command
@@ -1707,7 +1718,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (do_join) {
-		ret = wl1271_cmd_join(wl, wl->bss_type);
+		ret = wl1271_cmd_join(wl, wl->set_bss_type);
 		if (ret < 0) {
 			wl1271_warning("cmd join failed %d", ret);
 			goto out_sleep;
-- 
1.6.3.3

