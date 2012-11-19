Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:65056 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767Ab2KSQju (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 11:39:50 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so1209576eek.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Nov 2012 08:39:50 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 10/15] wlcore: initiate ROC/CROC on sta state updates
Date: Mon, 19 Nov 2012 18:39:25 +0200
Message-Id: <1353343170-26516-11-git-send-email-eliad@wizery.com> (sfid-20121119_173957_547954_8316FF85)
In-Reply-To: <1353343170-26516-1-git-send-email-eliad@wizery.com>
References: <1353343170-26516-1-git-send-email-eliad@wizery.com>
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
 drivers/net/wireless/ti/wlcore/main.c |   43 ++++++++++++++++++++------------
 1 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index fcdf381..e1f0606 100644
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
@@ -3944,14 +3942,6 @@ sta_not_found:
 			wl1271_warning("cmd join failed %d", ret);
 			goto out;
 		}
-
-		/* ROC until connected (after EAPOL exchange) */
-		if (!is_ibss) {
-			ret = wl12xx_roc(wl, wlvif, wlvif->role_id,
-					 wlvif->channel);
-			if (ret < 0)
-				goto out;
-		}
 	}
 
 	if (set_assoc) {
@@ -4355,8 +4345,11 @@ static int wl12xx_update_sta_state(struct wl1271 *wl,
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
@@ -4364,7 +4357,6 @@ static int wl12xx_update_sta_state(struct wl1271 *wl,
 	    new_state == IEEE80211_STA_NOTEXIST) {
 		/* must not fail */
 		wl12xx_sta_remove(wl, wlvif, sta);
-		return 0;
 	}
 
 	/* Authorize station (AP mode) */
@@ -4376,14 +4368,17 @@ static int wl12xx_update_sta_state(struct wl1271 *wl,
 
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
@@ -4391,9 +4386,25 @@ static int wl12xx_update_sta_state(struct wl1271 *wl,
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
+			wl12xx_roc(wl, wlvif, wlvif->role_id, wlvif->channel);
+		}
+	}
 	return 0;
 }
 
-- 
1.7.6.401.g6a319

