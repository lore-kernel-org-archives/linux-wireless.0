Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47902 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab1CFRXp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 12:23:45 -0500
Received: by mail-wy0-f174.google.com with SMTP id 36so3553649wyg.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2011 09:23:45 -0800 (PST)
From: Grazvydas Ignotas <notasas@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Kalle Valo <kvalo@adurom.com>, linux-wireless@vger.kernel.org,
	David Gnedt <david.gnedt@davizone.at>,
	Grazvydas Ignotas <notasas@gmail.com>
Subject: [PATCH 1/2] wl1251: remove wl1251_ps_set_elp function
Date: Sun,  6 Mar 2011 19:23:36 +0200
Message-Id: <1299432217-32139-2-git-send-email-notasas@gmail.com>
In-Reply-To: <1299432217-32139-1-git-send-email-notasas@gmail.com>
References: <1299432217-32139-1-git-send-email-notasas@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wl1251_ps_set_elp() only does acx_sleep_auth call and takes the chip
from/to ELP, however all callers of wl1251_ps_set_mode() have already
taken the chip out of ELP and puts it back to ELP when they finish.
This makes ELP calls (and register writes they result in) superfluous.

So remove wl1251_ps_set_elp function and call acx_sleep_auth directly.

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
---
 drivers/net/wireless/wl1251/ps.c |   37 +++----------------------------------
 1 files changed, 3 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/wl1251/ps.c b/drivers/net/wireless/wl1251/ps.c
index 9ba23ed..842155e 100644
--- a/drivers/net/wireless/wl1251/ps.c
+++ b/drivers/net/wireless/wl1251/ps.c
@@ -102,38 +102,6 @@ int wl1251_ps_elp_wakeup(struct wl1251 *wl)
 	return 0;
 }
 
-static int wl1251_ps_set_elp(struct wl1251 *wl, bool enable)
-{
-	int ret;
-
-	if (enable) {
-		wl1251_debug(DEBUG_PSM, "sleep auth psm/elp");
-
-		ret = wl1251_acx_sleep_auth(wl, WL1251_PSM_ELP);
-		if (ret < 0)
-			return ret;
-
-		wl1251_ps_elp_sleep(wl);
-	} else {
-		wl1251_debug(DEBUG_PSM, "sleep auth cam");
-
-		/*
-		 * When the target is in ELP, we can only
-		 * access the ELP control register. Thus,
-		 * we have to wake the target up before
-		 * changing the power authorization.
-		 */
-
-		wl1251_ps_elp_wakeup(wl);
-
-		ret = wl1251_acx_sleep_auth(wl, WL1251_PSM_CAM);
-		if (ret < 0)
-			return ret;
-	}
-
-	return 0;
-}
-
 int wl1251_ps_set_mode(struct wl1251 *wl, enum wl1251_cmd_ps_mode mode)
 {
 	int ret;
@@ -162,7 +130,7 @@ int wl1251_ps_set_mode(struct wl1251 *wl, enum wl1251_cmd_ps_mode mode)
 		if (ret < 0)
 			return ret;
 
-		ret = wl1251_ps_set_elp(wl, true);
+		ret = wl1251_acx_sleep_auth(wl, WL1251_PSM_ELP);
 		if (ret < 0)
 			return ret;
 
@@ -171,7 +139,8 @@ int wl1251_ps_set_mode(struct wl1251 *wl, enum wl1251_cmd_ps_mode mode)
 	case STATION_ACTIVE_MODE:
 	default:
 		wl1251_debug(DEBUG_PSM, "leaving psm");
-		ret = wl1251_ps_set_elp(wl, false);
+
+		ret = wl1251_acx_sleep_auth(wl, WL1251_PSM_CAM);
 		if (ret < 0)
 			return ret;
 
-- 
1.6.3.3

