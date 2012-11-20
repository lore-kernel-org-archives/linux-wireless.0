Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57714 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab2KTLUV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 06:20:21 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so1625946eek.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2012 03:20:20 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 06/11] wlcore: initiate ROC/CROC on sta state updates
Date: Tue, 20 Nov 2012 13:20:06 +0200
Message-Id: <1353410411-18833-7-git-send-email-eliad@wizery.com> (sfid-20121120_122027_930266_DCC4D2B8)
In-Reply-To: <1353410411-18833-1-git-send-email-eliad@wizery.com>
References: <1353410411-18833-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the sta_state notifications to ROC when a station
is about to connect, and CROC respectively on
authorization (success) / deletion (failure).

Change the wl12xx_update_sta_state() flow to bail out
only on error, so multiple code blocks could refer
to the same state.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c |   44 +++++++++++++++++++++------------
 1 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 450ff49..55dce4a 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -83,8 +83,6 @@ static int wl12xx_set_authorized(struct wl1271 *wl,
 	if (ret < 0)
 		return ret;
 
-	wl12xx_croc(wl, wlvif->role_id);
-
 	wl1271_info("Association completed.");
 	return 0;
 }
@@ -3974,14 +3972,6 @@ sta_not_found:
 			wl1271_warning("cmd join failed %d", ret);
 			goto out;
 		}
-
-		/* ROC until connected (after EAPOL exchange) */
-		if (!is_ibss) {
-			ret = wl12xx_roc(wl, wlvif, wlvif->role_id,
-					 wlvif->band, wlvif->channel);
-			if (ret < 0)
-				goto out;
-		}
 	}
 
 	if (changed & BSS_CHANGED_ASSOC) {
@@ -4398,8 +4388,11 @@ static int wl12xx_update_sta_state(struct wl1271 *wl,
 	/* Add station (AP mode) */
 	if (is_ap &&
 	    old_state == IEEE80211_STA_NOTEXIST &&
-	    new_state == IEEE80211_STA_NONE)
-		return wl12xx_sta_add(wl, wlvif, sta);
+	    new_state == IEEE80211_STA_NONE) {
+		ret = wl12xx_sta_add(wl, wlvif, sta);
+		if (ret)
+			return ret;
+	}
 
 	/* Remove station (AP mode) */
 	if (is_ap &&
@@ -4407,7 +4400,6 @@ static int wl12xx_update_sta_state(struct wl1271 *wl,
 	    new_state == IEEE80211_STA_NOTEXIST) {
 		/* must not fail */
 		wl12xx_sta_remove(wl, wlvif, sta);
-		return 0;
 	}
 
 	/* Authorize station (AP mode) */
@@ -4419,14 +4411,17 @@ static int wl12xx_update_sta_state(struct wl1271 *wl,
 
 		ret = wl1271_acx_set_ht_capabilities(wl, &sta->ht_cap, true,
 						     hlid);
-		return ret;
+		if (ret)
+			return ret;
 	}
 
 	/* Authorize station */
 	if (is_sta &&
 	    new_state == IEEE80211_STA_AUTHORIZED) {
 		set_bit(WLVIF_FLAG_STA_AUTHORIZED, &wlvif->flags);
-		return wl12xx_set_authorized(wl, wlvif);
+		ret = wl12xx_set_authorized(wl, wlvif);
+		if (ret)
+			return ret;
 	}
 
 	if (is_sta &&
@@ -4434,9 +4429,26 @@ static int wl12xx_update_sta_state(struct wl1271 *wl,
 	    new_state == IEEE80211_STA_ASSOC) {
 		clear_bit(WLVIF_FLAG_STA_AUTHORIZED, &wlvif->flags);
 		clear_bit(WLVIF_FLAG_STA_STATE_SENT, &wlvif->flags);
-		return 0;
 	}
 
+	/* clear ROCs on failure or authorization */
+	if (is_sta &&
+	    (new_state == IEEE80211_STA_AUTHORIZED ||
+	     new_state == IEEE80211_STA_NOTEXIST)) {
+		if (test_bit(wlvif->role_id, wl->roc_map))
+			wl12xx_croc(wl, wlvif->role_id);
+	}
+
+	if (is_sta &&
+	    old_state == IEEE80211_STA_NOTEXIST &&
+	    new_state == IEEE80211_STA_NONE) {
+		if (find_first_bit(wl->roc_map,
+				   WL12XX_MAX_ROLES) >= WL12XX_MAX_ROLES) {
+			WARN_ON(wlvif->role_id == WL12XX_INVALID_ROLE_ID);
+			wl12xx_roc(wl, wlvif, wlvif->role_id,
+				   wlvif->band, wlvif->channel);
+		}
+	}
 	return 0;
 }
 
-- 
1.7.6.401.g6a319

