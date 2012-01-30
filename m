Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:47536 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab2A3L5z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 06:57:55 -0500
Received: by mail-wi0-f174.google.com with SMTP id s10so3321396wic.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jan 2012 03:57:54 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 10/12] wl12xx: remove 2 unused parameters in wl1271_ps_set_mode()
Date: Mon, 30 Jan 2012 14:00:55 +0200
Message-Id: <1327924857-1250-11-git-send-email-eliad@wizery.com> (sfid-20120130_125831_461057_C4386D3D)
In-Reply-To: <1327924857-1250-1-git-send-email-eliad@wizery.com>
References: <1327924857-1250-1-git-send-email-eliad@wizery.com>
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
index 2b6dda5..21841d4 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2444,8 +2444,7 @@ static int wl12xx_config_vif(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		if (test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags)) {
 			wl1271_debug(DEBUG_PSM, "psm enabled");
 			ret = wl1271_ps_set_mode(wl, wlvif,
-						 STATION_POWER_SAVE_MODE,
-						 wlvif->basic_rate, true);
+						 STATION_AUTO_PS_MODE);
 		}
 	} else if (!(conf->flags & IEEE80211_CONF_PS) &&
 		   test_bit(WLVIF_FLAG_PSM_REQUESTED, &wlvif->flags)) {
@@ -2455,8 +2454,7 @@ static int wl12xx_config_vif(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 
 		if (test_bit(WLVIF_FLAG_PSM, &wlvif->flags))
 			ret = wl1271_ps_set_mode(wl, wlvif,
-						 STATION_ACTIVE_MODE,
-						 wlvif->basic_rate, true);
+						 STATION_ACTIVE_MODE);
 	}
 
 	if (conf->power_level != wlvif->power_level) {
@@ -3796,9 +3794,7 @@ sta_not_found:
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

