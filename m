Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:41118 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab2AaJyP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 04:54:15 -0500
Received: by mail-we0-f174.google.com with SMTP id b13so172570wer.19
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jan 2012 01:54:14 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 08/10] wl12xx: remove 2 unused parameters in wl1271_ps_set_mode()
Date: Tue, 31 Jan 2012 11:57:23 +0200
Message-Id: <1328003845-3926-9-git-send-email-eliad@wizery.com> (sfid-20120131_105430_756508_CE5ADE05)
In-Reply-To: <1328003845-3926-1-git-send-email-eliad@wizery.com>
References: <1328003845-3926-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

cleanup 2 unused parameters of wl1271_ps_set_mode

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/debugfs.c |    4 +---
 drivers/net/wireless/wl12xx/main.c    |   10 +++-------
 drivers/net/wireless/wl12xx/ps.c      |    2 +-
 drivers/net/wireless/wl12xx/ps.h      |    2 +-
 4 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index 156a774..4436851 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -359,9 +359,7 @@ static ssize_t dynamic_ps_timeout_write(struct file *file,
 
 	wl12xx_for_each_wlvif_sta(wl, wlvif) {
 		if (test_bit(WLVIF_FLAG_PSM, &wlvif->flags))
-			wl1271_ps_set_mode(wl, wlvif, STATION_AUTO_PS_MODE,
-					   wlvif->basic_rate, true);
-
+			wl1271_ps_set_mode(wl, wlvif, STATION_AUTO_PS_MODE);
 	}
 
 	wl1271_ps_elp_sleep(wl);
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 247e32d..d90b5bd 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2446,8 +2446,7 @@ static int wl12xx_config_vif(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		if (test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags)) {
 			wl1271_debug(DEBUG_PSM, "psm enabled");
 			ret = wl1271_ps_set_mode(wl, wlvif,
-						 STATION_POWER_SAVE_MODE,
-						 wlvif->basic_rate, true);
+						 STATION_AUTO_PS_MODE);
 		}
 	} else if (!(conf->flags & IEEE80211_CONF_PS) &&
 		   test_bit(WLVIF_FLAG_PSM_REQUESTED, &wlvif->flags)) {
@@ -2457,8 +2456,7 @@ static int wl12xx_config_vif(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 
 		if (test_bit(WLVIF_FLAG_PSM, &wlvif->flags))
 			ret = wl1271_ps_set_mode(wl, wlvif,
-						 STATION_ACTIVE_MODE,
-						 wlvif->basic_rate, true);
+						 STATION_ACTIVE_MODE);
 	}
 
 	if (conf->power_level != wlvif->power_level) {
@@ -3798,9 +3796,7 @@ sta_not_found:
 		    !test_bit(WLVIF_FLAG_PSM, &wlvif->flags)) {
 
 			ret = wl1271_ps_set_mode(wl, wlvif,
-						 STATION_AUTO_PS_MODE,
-						 wlvif->basic_rate,
-						 true);
+						 STATION_AUTO_PS_MODE);
 			if (ret < 0)
 				goto out;
 		}
diff --git a/drivers/net/wireless/wl12xx/ps.c b/drivers/net/wireless/wl12xx/ps.c
index 60f03c4..5074c2a 100644
--- a/drivers/net/wireless/wl12xx/ps.c
+++ b/drivers/net/wireless/wl12xx/ps.c
@@ -160,7 +160,7 @@ out:
 }
 
 int wl1271_ps_set_mode(struct wl1271 *wl, struct wl12xx_vif *wlvif,
-		       enum wl1271_cmd_ps_mode mode, u32 rates, bool send)
+		       enum wl1271_cmd_ps_mode mode)
 {
 	int ret;
 	u16 timeout = wl->conf.conn.dynamic_ps_timeout;
diff --git a/drivers/net/wireless/wl12xx/ps.h b/drivers/net/wireless/wl12xx/ps.h
index a12052f..5f19d4f 100644
--- a/drivers/net/wireless/wl12xx/ps.h
+++ b/drivers/net/wireless/wl12xx/ps.h
@@ -28,7 +28,7 @@
 #include "acx.h"
 
 int wl1271_ps_set_mode(struct wl1271 *wl, struct wl12xx_vif *wlvif,
-		       enum wl1271_cmd_ps_mode mode, u32 rates, bool send);
+		       enum wl1271_cmd_ps_mode mode);
 void wl1271_ps_elp_sleep(struct wl1271 *wl);
 int wl1271_ps_elp_wakeup(struct wl1271 *wl);
 void wl1271_elp_work(struct work_struct *work);
-- 
1.7.6.401.g6a319

