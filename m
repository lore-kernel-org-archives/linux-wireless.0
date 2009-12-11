Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:22080 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760929AbZLKLmK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 06:42:10 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 21/31] wl1271: prevent power save entry while not associated
Date: Fri, 11 Dec 2009 13:41:12 +0200
Message-Id: <1260531682-4695-22-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1260531682-4695-1-git-send-email-luciano.coelho@nokia.com>
References: <1260531682-4695-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

The mac80211 sometimes requests power save entry while not associated - this
will cause problems, so prevent it if not associated. Go to powersave once
association is complete.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    1 +
 drivers/net/wireless/wl12xx/wl1271_main.c |   11 ++++++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 4b5ddba..81e1c95 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -416,6 +416,7 @@ struct wl1271 {
 
 	/* PSM mode requested */
 	bool psm_requested;
+	bool associated;
 
 	/* retry counter for PSM entries */
 	u8 psm_entry_retry;
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 5a5e564..47f6e17 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -978,6 +978,7 @@ static void wl1271_op_stop(struct ieee80211_hw *hw)
 	wl->elp = false;
 	wl->psm = 0;
 	wl->psm_entry_retry = 0;
+	wl->associated = false;
 	wl->tx_queue_stopped = false;
 	wl->power_level = WL1271_DEFAULT_POWER_LEVEL;
 	wl->tx_blocks_available = 0;
@@ -1191,8 +1192,6 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 		wl1271_join_channel(wl, channel);
 
 	if (conf->flags & IEEE80211_CONF_PS && !wl->psm_requested) {
-		wl1271_info("psm enabled");
-
 		wl->psm_requested = true;
 
 		/*
@@ -1200,7 +1199,10 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 		 * If we're not, we'll enter it when joining an SSID,
 		 * through the bss_info_changed() hook.
 		 */
-		ret = wl1271_ps_set_mode(wl, STATION_POWER_SAVE_MODE);
+		if (wl->associated) {
+			wl1271_info("psm enabled");
+			ret = wl1271_ps_set_mode(wl, STATION_POWER_SAVE_MODE);
+		}
 	} else if (!(conf->flags & IEEE80211_CONF_PS) &&
 		   wl->psm_requested) {
 		wl1271_info("psm disabled");
@@ -1548,6 +1550,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 	if (changed & BSS_CHANGED_ASSOC) {
 		if (bss_conf->assoc) {
 			wl->aid = bss_conf->aid;
+			wl->associated = true;
 
 			/*
 			 * with wl1271, we don't need to update the
@@ -1572,6 +1575,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 			}
 		} else {
 			/* use defaults when not associated */
+			wl->associated = false;
 			wl->aid = 0;
 		}
 
@@ -1898,6 +1902,7 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 	wl->psm = 0;
 	wl->psm_requested = false;
 	wl->psm_entry_retry = 0;
+	wl->associated = false;
 	wl->tx_queue_stopped = false;
 	wl->power_level = WL1271_DEFAULT_POWER_LEVEL;
 	wl->basic_rate_set = CONF_TX_RATE_MASK_BASIC;
-- 
1.6.3.3

