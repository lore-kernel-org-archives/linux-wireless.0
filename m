Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35893 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab1LRSY7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Dec 2011 13:24:59 -0500
Received: by mail-ww0-f44.google.com with SMTP id dr13so9434272wgb.1
        for <linux-wireless@vger.kernel.org>; Sun, 18 Dec 2011 10:24:58 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 5/7] wl12xx: fix checking of started dev role
Date: Sun, 18 Dec 2011 20:25:43 +0200
Message-Id: <1324232745-22928-6-git-send-email-eliad@wizery.com> (sfid-20111218_192501_551198_552EDB09)
In-Reply-To: <1324232745-22928-1-git-send-email-eliad@wizery.com>
References: <1324232745-22928-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

dev_role_id only indicates whether the dev role
is enabled, not started (e.g. on IBSS merge,
the device role is enabled, but not started).

Checking for any role in ROC (in order to determine
whether dev role was started) is wrong as well,
especially in multi-vif env.

Check for started dev role only by checking the dev_hlid.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |   41 +++++++++++++++--------------------
 1 files changed, 18 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 3a8fd33..7a2ed34 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2036,6 +2036,11 @@ out:
 	return booted;
 }
 
+static bool wl12xx_dev_role_started(struct wl12xx_vif *wlvif)
+{
+	return wlvif->dev_hlid != WL12XX_INVALID_LINK_ID;
+}
+
 static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif)
 {
@@ -2368,17 +2373,6 @@ static void wl1271_set_band_rate(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	wlvif->rate_set = wlvif->basic_rate_set;
 }
 
-static bool wl12xx_is_roc(struct wl1271 *wl)
-{
-	u8 role_id;
-
-	role_id = find_first_bit(wl->roc_map, WL12XX_MAX_ROLES);
-	if (role_id >= WL12XX_MAX_ROLES)
-		return false;
-
-	return true;
-}
-
 static int wl1271_sta_handle_idle(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 				  bool idle)
 {
@@ -2390,7 +2384,7 @@ static int wl1271_sta_handle_idle(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 
 	if (idle) {
 		/* no need to croc if we weren't busy (e.g. during boot) */
-		if (wl12xx_is_roc(wl)) {
+		if (wl12xx_dev_role_started(wlvif)) {
 			ret = wl12xx_stop_dev(wl, wlvif);
 			if (ret < 0)
 				goto out;
@@ -2460,7 +2454,7 @@ static int wl12xx_config_vif(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 
 			if (test_bit(WLVIF_FLAG_STA_ASSOCIATED,
 				     &wlvif->flags)) {
-				if (wl12xx_is_roc(wl)) {
+				if (wl12xx_dev_role_started(wlvif)) {
 					/* roaming */
 					ret = wl12xx_croc(wl,
 							  wlvif->dev_role_id);
@@ -2477,7 +2471,7 @@ static int wl12xx_config_vif(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 				 * not idle. otherwise, CROC will be called
 				 * anyway.
 				 */
-				if (wl12xx_is_roc(wl) &&
+				if (wl12xx_dev_role_started(wlvif) &&
 				    !(conf->flags & IEEE80211_CONF_IDLE)) {
 					ret = wl12xx_stop_dev(wl, wlvif);
 					if (ret < 0)
@@ -3024,15 +3018,16 @@ static int wl1271_op_hw_scan(struct ieee80211_hw *hw,
 	if (ret < 0)
 		goto out;
 
+	if (test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags) &&
+	    test_bit(wlvif->role_id, wl->roc_map)) {
+		/* don't allow scanning right now */
+		ret = -EBUSY;
+		goto out_sleep;
+	}
+
 	/* cancel ROC before scanning */
-	if (wl12xx_is_roc(wl)) {
-		if (test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags)) {
-			/* don't allow scanning right now */
-			ret = -EBUSY;
-			goto out_sleep;
-		}
+	if (wl12xx_dev_role_started(wlvif))
 		wl12xx_stop_dev(wl, wlvif);
-	}
 
 	ret = wl1271_scan(hw->priv, vif, ssid, len, req);
 out_sleep:
@@ -3843,9 +3838,9 @@ sta_not_found:
 		}
 		/*
 		 * stop device role if started (we might already be in
-		 * STA role). TODO: make it better.
+		 * STA/IBSS role).
 		 */
-		if (wlvif->dev_role_id != WL12XX_INVALID_ROLE_ID) {
+		if (wl12xx_dev_role_started(wlvif)) {
 			ret = wl12xx_stop_dev(wl, wlvif);
 			if (ret < 0)
 				goto out;
-- 
1.7.6.401.g6a319

