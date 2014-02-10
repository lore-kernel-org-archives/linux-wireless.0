Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:49108 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbaBJLsK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Feb 2014 06:48:10 -0500
Received: by mail-we0-f182.google.com with SMTP id u57so4174205wes.13
        for <linux-wireless@vger.kernel.org>; Mon, 10 Feb 2014 03:48:09 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 17/18] wlcore: enable beacon filtering only after receiving a beacon
Date: Mon, 10 Feb 2014 13:47:33 +0200
Message-Id: <1392032854-28126-18-git-send-email-eliad@wizery.com> (sfid-20140210_130006_789411_017343AD)
In-Reply-To: <1392032854-28126-1-git-send-email-eliad@wizery.com>
References: <1392032854-28126-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enabling beacon filtering before receving a beacon
might result in not having a beacon at all for the
current connected AP, which prevents the station
from entering power-save.

Replace the current approach (of starting beacon
filtering on init) and configure beacon filering
only after bss_conf->dtimper is set (which means
mac80211 already parsed a beacon).

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/acx.c  |  3 ++-
 drivers/net/wireless/ti/wlcore/init.c |  4 ++--
 drivers/net/wireless/ti/wlcore/main.c | 12 ++++++++++++
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/acx.c b/drivers/net/wireless/ti/wlcore/acx.c
index 71b244b..b924cea 100644
--- a/drivers/net/wireless/ti/wlcore/acx.c
+++ b/drivers/net/wireless/ti/wlcore/acx.c
@@ -358,7 +358,8 @@ int wl1271_acx_beacon_filter_opt(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	struct acx_beacon_filter_option *beacon_filter = NULL;
 	int ret = 0;
 
-	wl1271_debug(DEBUG_ACX, "acx beacon filter opt");
+	wl1271_debug(DEBUG_ACX, "acx beacon filter opt enable=%d",
+		     enable_filter);
 
 	if (enable_filter &&
 	    wl->conf.conn.bcn_filt_mode == CONF_BCN_FILT_MODE_DISABLED)
diff --git a/drivers/net/wireless/ti/wlcore/init.c b/drivers/net/wireless/ti/wlcore/init.c
index b376c99..199e941 100644
--- a/drivers/net/wireless/ti/wlcore/init.c
+++ b/drivers/net/wireless/ti/wlcore/init.c
@@ -287,8 +287,8 @@ static int wl1271_init_sta_beacon_filter(struct wl1271 *wl,
 	if (ret < 0)
 		return ret;
 
-	/* enable beacon filtering */
-	ret = wl1271_acx_beacon_filter_opt(wl, wlvif, true);
+	/* disable beacon filtering until we get the first beacon */
+	ret = wl1271_acx_beacon_filter_opt(wl, wlvif, false);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index a2348b9..82d5461 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -2941,6 +2941,11 @@ static int wlcore_unset_assoc(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 		ret = wl1271_acx_keep_alive_mode(wl, wlvif, false);
 		if (ret < 0)
 			return ret;
+
+		/* disable beacon filtering */
+		ret = wl1271_acx_beacon_filter_opt(wl, wlvif, false);
+		if (ret < 0)
+			return ret;
 	}
 
 	if (test_and_clear_bit(WLVIF_FLAG_CS_PROGRESS, &wlvif->flags)) {
@@ -4312,6 +4317,13 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 		}
 	}
 
+	if ((changed & BSS_CHANGED_BEACON_INFO) && bss_conf->dtim_period) {
+		/* enable beacon filtering */
+		ret = wl1271_acx_beacon_filter_opt(wl, wlvif, true);
+		if (ret < 0)
+			goto out;
+	}
+
 	ret = wl1271_bss_erp_info_changed(wl, vif, bss_conf, changed);
 	if (ret < 0)
 		goto out;
-- 
1.8.5.2.229.g4448466.dirty

