Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:22542 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816Ab0BVGla (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2010 01:41:30 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 12/22] wl1271: Fix ad-hoc mode neighborhood detection
Date: Mon, 22 Feb 2010 08:38:32 +0200
Message-Id: <1266820722-20202-13-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a bug in ad-hoc mode preventing mac80211 from properly
detecting other ad-hoc networks with the same SSID.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Kalle Valo <kalle.valo@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_cmd.c  |    4 ++--
 drivers/net/wireless/wl12xx/wl1271_cmd.h  |    2 +-
 drivers/net/wireless/wl12xx/wl1271_main.c |   15 +++++++--------
 3 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index 6759aa1..e029bf0 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -247,7 +247,7 @@ int wl1271_cmd_radio_parms(struct wl1271 *wl)
 	return ret;
 }
 
-int wl1271_cmd_join(struct wl1271 *wl)
+int wl1271_cmd_join(struct wl1271 *wl, u8 bss_type)
 {
 	static bool do_cal = true;
 	struct wl1271_cmd_join *join;
@@ -278,7 +278,7 @@ int wl1271_cmd_join(struct wl1271 *wl)
 
 	join->rx_config_options = cpu_to_le32(wl->rx_config);
 	join->rx_filter_options = cpu_to_le32(wl->rx_filter);
-	join->bss_type = wl->bss_type;
+	join->bss_type = bss_type;
 
 	/*
 	 * FIXME: disable temporarily all filters because after commit
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.h b/drivers/net/wireless/wl12xx/wl1271_cmd.h
index 2dc06c7..4297205 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.h
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.h
@@ -33,7 +33,7 @@ int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len,
 		    size_t res_len);
 int wl1271_cmd_general_parms(struct wl1271 *wl);
 int wl1271_cmd_radio_parms(struct wl1271 *wl);
-int wl1271_cmd_join(struct wl1271 *wl);
+int wl1271_cmd_join(struct wl1271 *wl, u8 bss_type);
 int wl1271_cmd_test(struct wl1271 *wl, void *buf, size_t buf_len, u8 answer);
 int wl1271_cmd_interrogate(struct wl1271 *wl, u16 id, void *buf, size_t len);
 int wl1271_cmd_configure(struct wl1271 *wl, u16 id, void *buf, size_t len);
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 5cc778f..81fb02e 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1093,7 +1093,7 @@ static int wl1271_op_config_interface(struct ieee80211_hw *hw,
 
 		memcpy(wl->bssid, conf->bssid, ETH_ALEN);
 
-		ret = wl1271_cmd_join(wl);
+		ret = wl1271_cmd_join(wl, wl->bss_type);
 		if (ret < 0)
 			goto out_sleep;
 
@@ -1142,17 +1142,16 @@ static int wl1271_join_channel(struct wl1271 *wl, int channel)
 	static const u8 dummy_bssid[ETH_ALEN] = { 0x0b, 0xad, 0xde,
 						  0xad, 0xbe, 0xef };
 
-	/* the dummy join is not required for ad-hoc */
-	if (wl->bss_type == BSS_TYPE_IBSS)
-		goto out;
-
 	/* disable mac filter, so we hear everything */
 	wl->rx_config &= ~CFG_BSSID_FILTER_EN;
 
 	wl->channel = channel;
 	memcpy(wl->bssid, dummy_bssid, ETH_ALEN);
 
-	ret = wl1271_cmd_join(wl);
+	/* the dummy join is performed always with STATION BSS type to allow
+	   also ad-hoc mode to listen to the surroundings without sending any
+	   beacons yet. */
+	ret = wl1271_cmd_join(wl, BSS_TYPE_STA_BSS);
 	if (ret < 0)
 		goto out;
 
@@ -1221,7 +1220,7 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 	    test_bit(WL1271_FLAG_JOINED, &wl->flags)) {
 		wl->channel = channel;
 		/* FIXME: maybe use CMD_CHANNEL_SWITCH for this? */
-		ret = wl1271_cmd_join(wl);
+		ret = wl1271_cmd_join(wl, wl->bss_type);
 		if (ret < 0)
 			wl1271_warning("cmd join to update channel failed %d",
 				       ret);
@@ -1704,7 +1703,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (do_join) {
-		ret = wl1271_cmd_join(wl);
+		ret = wl1271_cmd_join(wl, wl->bss_type);
 		if (ret < 0) {
 			wl1271_warning("cmd join failed %d", ret);
 			goto out_sleep;
-- 
1.6.3.3

