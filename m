Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44216 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932306Ab1JXPZ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Oct 2011 11:25:29 -0400
Received: by yxl42 with SMTP id 42so3279910yxl.19
        for <linux-wireless@vger.kernel.org>; Mon, 24 Oct 2011 08:25:29 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] wl12xx: keep beacon-filtering enabled during STA operation
Date: Mon, 24 Oct 2011 17:25:20 +0200
Message-Id: <1319469920-5173-1-git-send-email-arik@wizery.com> (sfid-20111024_172533_301795_FA2A5643)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable beacon filtering on STA init, and don't disable it when entering
active mode. Otherwise dynamic-PS supports means we receive beacons from
the current AP during any Tx/Rx performed by the driver.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/event.c |    5 -----
 drivers/net/wireless/wl12xx/init.c  |   12 ++++++------
 drivers/net/wireless/wl12xx/ps.c    |    5 -----
 3 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index e22df6c..00ce794 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -137,11 +137,6 @@ static int wl1271_event_ps_report(struct wl1271 *wl,
 	case EVENT_ENTER_POWER_SAVE_SUCCESS:
 		wlvif->psm_entry_retry = 0;
 
-		/* enable beacon filtering */
-		ret = wl1271_acx_beacon_filter_opt(wl, wlvif, true);
-		if (ret < 0)
-			break;
-
 		/*
 		 * BET has only a minor effect in 5GHz and masks
 		 * channel switch IEs, so we only enable BET on 2.4GHz
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index c6084f8..14ff01e 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -254,17 +254,17 @@ static int wl12xx_init_phy_vif_config(struct wl1271 *wl,
 	return 0;
 }
 
-static int wl1271_init_beacon_filter(struct wl1271 *wl,
-				     struct wl12xx_vif *wlvif)
+static int wl1271_init_sta_beacon_filter(struct wl1271 *wl,
+					 struct wl12xx_vif *wlvif)
 {
 	int ret;
 
-	/* disable beacon filtering at this stage */
-	ret = wl1271_acx_beacon_filter_opt(wl, wlvif, false);
+	ret = wl1271_acx_beacon_filter_table(wl, wlvif);
 	if (ret < 0)
 		return ret;
 
-	ret = wl1271_acx_beacon_filter_table(wl, wlvif);
+	/* enable beacon filtering */
+	ret = wl1271_acx_beacon_filter_opt(wl, wlvif, true);
 	if (ret < 0)
 		return ret;
 
@@ -529,7 +529,7 @@ static int wl12xx_init_sta_role(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 		return ret;
 
 	/* Beacon filtering */
-	ret = wl1271_init_beacon_filter(wl, wlvif);
+	ret = wl1271_init_sta_beacon_filter(wl, wlvif);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/net/wireless/wl12xx/ps.c b/drivers/net/wireless/wl12xx/ps.c
index 9f4e8c0..a7a1108 100644
--- a/drivers/net/wireless/wl12xx/ps.c
+++ b/drivers/net/wireless/wl12xx/ps.c
@@ -185,11 +185,6 @@ int wl1271_ps_set_mode(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 				return ret;
 		}
 
-		/* disable beacon filtering */
-		ret = wl1271_acx_beacon_filter_opt(wl, wlvif, false);
-		if (ret < 0)
-			return ret;
-
 		ret = wl1271_cmd_ps_mode(wl, wlvif, STATION_ACTIVE_MODE);
 		if (ret < 0)
 			return ret;
-- 
1.7.5.4

