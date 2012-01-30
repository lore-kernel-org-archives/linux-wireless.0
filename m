Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:35943 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab2A3L57 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 06:57:59 -0500
Received: by mail-we0-f174.google.com with SMTP id b13so3350590wer.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jan 2012 03:57:58 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 12/12] wl12xx: change WLVIF_FLAG_PSM name and remove WLVIF_FLAG_PSM_REQUESTED
Date: Mon, 30 Jan 2012 14:00:57 +0200
Message-Id: <1327924857-1250-13-git-send-email-eliad@wizery.com> (sfid-20120130_125832_577073_65700E0D)
In-Reply-To: <1327924857-1250-1-git-send-email-eliad@wizery.com>
References: <1327924857-1250-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

WLVIF_FLAG_PSM turned to WLVIF_FLAG_IN_AUTO_PS which
marks that this vif is in AUTO PS.

WLVIF_FLAG_PSM_REQUESTED is not required as mac80211
calls op_config with CONF_PS after association.

wl12xx_config_vif() handling of CONF_PS was simplified
and cleaned up.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/debugfs.c |    2 +-
 drivers/net/wireless/wl12xx/main.c    |   42 ++++++++++++--------------------
 drivers/net/wireless/wl12xx/ps.c      |    8 +++---
 drivers/net/wireless/wl12xx/wl12xx.h  |    3 +-
 4 files changed, 22 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index 4436851..4dcb3f7 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -358,7 +358,7 @@ static ssize_t dynamic_ps_timeout_write(struct file *file,
 	 */
 
 	wl12xx_for_each_wlvif_sta(wl, wlvif) {
-		if (test_bit(WLVIF_FLAG_PSM, &wlvif->flags))
+		if (test_bit(WLVIF_FLAG_IN_AUTO_PS, &wlvif->flags))
 			wl1271_ps_set_mode(wl, wlvif, STATION_AUTO_PS_MODE);
 	}
 
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 21841d4..2bb1c24 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2432,29 +2432,29 @@ static int wl12xx_config_vif(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		}
 	}
 
-	if (conf->flags & IEEE80211_CONF_PS &&
-	    !test_bit(WLVIF_FLAG_PSM_REQUESTED, &wlvif->flags)) {
-		set_bit(WLVIF_FLAG_PSM_REQUESTED, &wlvif->flags);
+	if ((changed & IEEE80211_CONF_CHANGE_PS) && !is_ap) {
+
+		if ((conf->flags & IEEE80211_CONF_PS) &&
+		    test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags) &&
+		    !test_bit(WLVIF_FLAG_IN_AUTO_PS, &wlvif->flags)) {
+
+			wl1271_debug(DEBUG_PSM, "auto ps enabled");
 
-		/*
-		 * We enter PSM only if we're already associated.
-		 * If we're not, we'll enter it when joining an SSID,
-		 * through the bss_info_changed() hook.
-		 */
-		if (test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags)) {
-			wl1271_debug(DEBUG_PSM, "psm enabled");
 			ret = wl1271_ps_set_mode(wl, wlvif,
 						 STATION_AUTO_PS_MODE);
-		}
-	} else if (!(conf->flags & IEEE80211_CONF_PS) &&
-		   test_bit(WLVIF_FLAG_PSM_REQUESTED, &wlvif->flags)) {
-		wl1271_debug(DEBUG_PSM, "psm disabled");
+			if (ret < 0)
+				wl1271_warning("enter auto ps failed %d", ret);
 
-		clear_bit(WLVIF_FLAG_PSM_REQUESTED, &wlvif->flags);
+		} else if (!(conf->flags & IEEE80211_CONF_PS) &&
+			   test_bit(WLVIF_FLAG_IN_AUTO_PS, &wlvif->flags)) {
+
+			wl1271_debug(DEBUG_PSM, "auto ps disabled");
 
-		if (test_bit(WLVIF_FLAG_PSM, &wlvif->flags))
 			ret = wl1271_ps_set_mode(wl, wlvif,
 						 STATION_ACTIVE_MODE);
+			if (ret < 0)
+				wl1271_warning("exit auto ps failed %d", ret);
+		}
 	}
 
 	if (conf->power_level != wlvif->power_level) {
@@ -3788,16 +3788,6 @@ sta_not_found:
 			if (ret < 0)
 				goto out;
 		}
-
-		/* If we want to go in PSM but we're not there yet */
-		if (test_bit(WLVIF_FLAG_PSM_REQUESTED, &wlvif->flags) &&
-		    !test_bit(WLVIF_FLAG_PSM, &wlvif->flags)) {
-
-			ret = wl1271_ps_set_mode(wl, wlvif,
-						 STATION_AUTO_PS_MODE);
-			if (ret < 0)
-				goto out;
-		}
 	}
 
 	/* Handle new association with HT. Do this after join. */
diff --git a/drivers/net/wireless/wl12xx/ps.c b/drivers/net/wireless/wl12xx/ps.c
index d7a91d3..e209e29 100644
--- a/drivers/net/wireless/wl12xx/ps.c
+++ b/drivers/net/wireless/wl12xx/ps.c
@@ -56,7 +56,7 @@ void wl1271_elp_work(struct work_struct *work)
 		if (wlvif->bss_type == BSS_TYPE_AP_BSS)
 			goto out;
 
-		if (!test_bit(WLVIF_FLAG_PSM, &wlvif->flags) &&
+		if (!test_bit(WLVIF_FLAG_IN_AUTO_PS, &wlvif->flags) &&
 		    test_bit(WLVIF_FLAG_IN_USE, &wlvif->flags))
 			goto out;
 	}
@@ -84,7 +84,7 @@ void wl1271_ps_elp_sleep(struct wl1271 *wl)
 		if (wlvif->bss_type == BSS_TYPE_AP_BSS)
 			return;
 
-		if (!test_bit(WLVIF_FLAG_PSM, &wlvif->flags) &&
+		if (!test_bit(WLVIF_FLAG_IN_AUTO_PS, &wlvif->flags) &&
 		    test_bit(WLVIF_FLAG_IN_USE, &wlvif->flags))
 			return;
 	}
@@ -180,7 +180,7 @@ int wl1271_ps_set_mode(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		if (ret < 0)
 			return ret;
 
-		set_bit(WLVIF_FLAG_PSM, &wlvif->flags);
+		set_bit(WLVIF_FLAG_IN_AUTO_PS, &wlvif->flags);
 
 		/* enable beacon early termination. Not relevant for 5GHz */
 		if (wlvif->band == IEEE80211_BAND_2GHZ) {
@@ -203,7 +203,7 @@ int wl1271_ps_set_mode(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		if (ret < 0)
 			return ret;
 
-		clear_bit(WLVIF_FLAG_PSM, &wlvif->flags);
+		clear_bit(WLVIF_FLAG_IN_AUTO_PS, &wlvif->flags);
 		break;
 	case STATION_POWER_SAVE_MODE:
 	default:
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index af1cedc..9cc7051 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -254,8 +254,7 @@ enum wl12xx_vif_flags {
 	WLVIF_FLAG_STA_ASSOCIATED,
 	WLVIF_FLAG_IBSS_JOINED,
 	WLVIF_FLAG_AP_STARTED,
-	WLVIF_FLAG_PSM,
-	WLVIF_FLAG_PSM_REQUESTED,
+	WLVIF_FLAG_IN_AUTO_PS,
 	WLVIF_FLAG_STA_STATE_SENT,
 	WLVIF_FLAG_RX_STREAMING_STARTED,
 	WLVIF_FLAG_PSPOLL_FAILURE,
-- 
1.7.6.401.g6a319

