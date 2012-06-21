Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:39373 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755046Ab2FUONa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 10:13:30 -0400
Received: by eaak11 with SMTP id k11so255480eaa.33
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jun 2012 07:13:24 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 04/12] wlcore: reconfigure sleep_auth when removing interfaces
Date: Thu, 21 Jun 2012 17:13:03 +0300
Message-Id: <1340287991-15241-5-git-send-email-coelho@ti.com> (sfid-20120621_161543_482768_A3DF9845)
In-Reply-To: <1340287991-15241-1-git-send-email-coelho@ti.com>
References: <1340287991-15241-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

The sleep_auth value of the last interface to be set up prevailed when
an interface was removed. Take care of this by correctly configuring the
value according to the remaining STA/AP interfaces.

Take this opportunity to refactor the sleep_auth setting code for better
readability.

[Small style fix. -- Luca]

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/acx.c  |    5 +++-
 drivers/net/wireless/ti/wlcore/init.c |   49 ++++++++++++++-------------------
 drivers/net/wireless/ti/wlcore/main.c |   21 ++++++++++++--
 3 files changed, 43 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/acx.c b/drivers/net/wireless/ti/wlcore/acx.c
index 3384bc1..ce108a7 100644
--- a/drivers/net/wireless/ti/wlcore/acx.c
+++ b/drivers/net/wireless/ti/wlcore/acx.c
@@ -81,8 +81,11 @@ int wl1271_acx_sleep_auth(struct wl1271 *wl, u8 sleep_auth)
 	auth->sleep_auth = sleep_auth;
 
 	ret = wl1271_cmd_configure(wl, ACX_SLEEP_AUTH, auth, sizeof(*auth));
-	if (ret < 0)
+	if (ret < 0) {
+		wl1271_error("could not configure sleep_auth to %d: %d",
+			     sleep_auth, ret);
 		goto out;
+	}
 
 	wl->sleep_auth = sleep_auth;
 out:
diff --git a/drivers/net/wireless/ti/wlcore/init.c b/drivers/net/wireless/ti/wlcore/init.c
index 3fb9352..8a8a897 100644
--- a/drivers/net/wireless/ti/wlcore/init.c
+++ b/drivers/net/wireless/ti/wlcore/init.c
@@ -554,35 +554,28 @@ int wl1271_init_vif_specific(struct wl1271 *wl, struct ieee80211_vif *vif)
 	bool is_ap = (wlvif->bss_type == BSS_TYPE_AP_BSS);
 	int ret, i;
 
-	/*
-	 * consider all existing roles before configuring psm.
-	 * TODO: reconfigure on interface removal.
-	 */
-	if (!wl->ap_count) {
-		if (is_ap) {
-			/* Configure for power always on */
+	/* consider all existing roles before configuring psm. */
+
+	if (wl->ap_count == 0 && is_ap) { /* first AP */
+		/* Configure for power always on */
+		ret = wl1271_acx_sleep_auth(wl, WL1271_PSM_CAM);
+		if (ret < 0)
+			return ret;
+	/* first STA, no APs */
+	} else if (wl->sta_count == 0 && wl->ap_count == 0 && !is_ap) {
+		u8 sta_auth = wl->conf.conn.sta_sleep_auth;
+		/* Configure for power according to debugfs */
+		if (sta_auth != WL1271_PSM_ILLEGAL)
+			ret = wl1271_acx_sleep_auth(wl, sta_auth);
+		/* Configure for power always on */
+		else if (wl->quirks & WLCORE_QUIRK_NO_ELP)
 			ret = wl1271_acx_sleep_auth(wl, WL1271_PSM_CAM);
-			if (ret < 0)
-				return ret;
-		} else if (!wl->sta_count) {
-			u8 sta_auth = wl->conf.conn.sta_sleep_auth;
-			if (sta_auth != WL1271_PSM_ILLEGAL) {
-				/* Configure for power according to debugfs */
-				ret = wl1271_acx_sleep_auth(wl, sta_auth);
-				if (ret < 0)
-					return ret;
-			} else if (wl->quirks & WLCORE_QUIRK_NO_ELP) {
-				/* Configure for power always on */
-				ret = wl1271_acx_sleep_auth(wl, WL1271_PSM_CAM);
-				if (ret < 0)
-					return ret;
-			} else {
-				/* Configure for ELP power saving */
-				ret = wl1271_acx_sleep_auth(wl, WL1271_PSM_ELP);
-				if (ret < 0)
-					return ret;
-			}
-		}
+		/* Configure for ELP power saving */
+		else
+			ret = wl1271_acx_sleep_auth(wl, WL1271_PSM_ELP);
+
+		if (ret < 0)
+			return ret;
 	}
 
 	/* Mode specific init */
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 69643d1..3279a94 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1082,7 +1082,7 @@ int wl1271_plt_stop(struct wl1271 *wl)
 	mutex_lock(&wl->mutex);
 	wl1271_power_off(wl);
 	wl->flags = 0;
-	wl->sleep_auth = WL1271_PSM_CAM;
+	wl->sleep_auth = WL1271_PSM_ILLEGAL;
 	wl->state = WL1271_STATE_OFF;
 	wl->plt = false;
 	wl->rx_counter = 0;
@@ -1741,7 +1741,7 @@ static void wl1271_op_stop(struct ieee80211_hw *hw)
 	wl->ap_fw_ps_map = 0;
 	wl->ap_ps_map = 0;
 	wl->sched_scanning = false;
-	wl->sleep_auth = WL1271_PSM_CAM;
+	wl->sleep_auth = WL1271_PSM_ILLEGAL;
 	memset(wl->roles_map, 0, sizeof(wl->roles_map));
 	memset(wl->links_map, 0, sizeof(wl->links_map));
 	memset(wl->roc_map, 0, sizeof(wl->roc_map));
@@ -2148,6 +2148,7 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 {
 	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	int i, ret;
+	bool is_ap = (wlvif->bss_type == BSS_TYPE_AP_BSS);
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 remove interface");
 
@@ -2228,11 +2229,25 @@ deinit:
 	wlvif->role_id = WL12XX_INVALID_ROLE_ID;
 	wlvif->dev_role_id = WL12XX_INVALID_ROLE_ID;
 
-	if (wlvif->bss_type == BSS_TYPE_AP_BSS)
+	if (is_ap)
 		wl->ap_count--;
 	else
 		wl->sta_count--;
 
+	/* Last AP, have more stations. Configure according to STA. */
+	if (wl->ap_count == 0 && is_ap && wl->sta_count) {
+		u8 sta_auth = wl->conf.conn.sta_sleep_auth;
+		/* Configure for power according to debugfs */
+		if (sta_auth != WL1271_PSM_ILLEGAL)
+			wl1271_acx_sleep_auth(wl, sta_auth);
+		/* Configure for power always on */
+		else if (wl->quirks & WLCORE_QUIRK_NO_ELP)
+			wl1271_acx_sleep_auth(wl, WL1271_PSM_CAM);
+		/* Configure for ELP power saving */
+		else
+			wl1271_acx_sleep_auth(wl, WL1271_PSM_ELP);
+	}
+
 	mutex_unlock(&wl->mutex);
 
 	del_timer_sync(&wlvif->rx_streaming_timer);
-- 
1.7.10

