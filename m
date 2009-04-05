Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1614 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756183AbZDECLI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Apr 2009 22:11:08 -0400
From: Bob Copeland <me@bobcopeland.com>
To: kalle.valo@nokia.com
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 2/6] wl12xx: remove ssid parameters from driver private struct
Date: Sat,  4 Apr 2009 22:10:24 -0400
Message-Id: <1238897428-19639-3-git-send-email-me@bobcopeland.com> (sfid-20090405_041123_227672_2FA986DD)
In-Reply-To: <1238897428-19639-1-git-send-email-me@bobcopeland.com>
References: <1238897428-19639-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since 2.6.29, mac80211 no longer passes ssid to the drivers and
wl12xx doesn't need it anyway, so remove all references.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/wl12xx/cmd.c    |    4 +---
 drivers/net/wireless/wl12xx/main.c   |    8 --------
 drivers/net/wireless/wl12xx/wl12xx.h |    2 --
 3 files changed, 1 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 85b94ae..93eb843 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -216,7 +216,7 @@ int wl12xx_cmd_join(struct wl12xx *wl, u8 bss_type, u8 dtim_interval,
 		    u16 beacon_interval, u8 wait)
 {
 	unsigned long timeout;
-	struct cmd_join join;
+	struct cmd_join join = {};
 	int ret, i;
 	u8 *bssid;
 
@@ -245,8 +245,6 @@ int wl12xx_cmd_join(struct wl12xx *wl, u8 bss_type, u8 dtim_interval,
 	join.dtim_interval = dtim_interval;
 	join.bss_type = bss_type;
 	join.channel = wl->channel;
-	join.ssid_len = wl->ssid_len;
-	memcpy(join.ssid, wl->ssid, wl->ssid_len);
 	join.ctrl = JOIN_CMD_CTRL_TX_FLUSH;
 
 	ret = wl12xx_cmd_send(wl, CMD_START_JOIN, &join, sizeof(join));
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 27f4f15..9de45c7 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -534,8 +534,6 @@ static void wl12xx_op_stop(struct ieee80211_hw *hw)
 	wl12xx_power_off(wl);
 
 	memset(wl->bssid, 0, ETH_ALEN);
-	memset(wl->ssid, 0, IW_ESSID_MAX_SIZE + 1);
-	wl->ssid_len = 0;
 	wl->listen_int = 1;
 	wl->joined = false;
 	wl->bss_type = MAX_BSS_TYPE;
@@ -643,8 +641,6 @@ static int wl12xx_op_config_interface(struct ieee80211_hw *hw,
 
 	wl12xx_debug(DEBUG_MAC80211, "mac80211 config_interface bssid %s",
 		     print_mac(mac, conf->bssid));
-	wl12xx_dump_ascii(DEBUG_MAC80211, "ssid: ", conf->ssid,
-			  conf->ssid_len);
 
 	mutex_lock(&wl->mutex);
 
@@ -654,10 +650,6 @@ static int wl12xx_op_config_interface(struct ieee80211_hw *hw,
 	if (ret < 0)
 		goto out;
 
-	wl->ssid_len = conf->ssid_len;
-	if (wl->ssid_len)
-		memcpy(wl->ssid, conf->ssid, wl->ssid_len);
-
 	if (wl->bss_type != BSS_TYPE_IBSS) {
 		ret = wl12xx_cmd_join(wl, wl->bss_type, 5, 100, 1);
 		if (ret < 0)
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 4a5a009..1856b07 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -199,8 +199,6 @@ struct wl12xx {
 	u8 bssid[ETH_ALEN];
 	u8 mac_addr[ETH_ALEN];
 	u8 bss_type;
-	u8 ssid[IW_ESSID_MAX_SIZE + 1];
-	u8 ssid_len;
 	u8 listen_int;
 	int channel;
 
-- 
1.6.0.6


