Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:56032 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932844Ab0I0IiY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 04:38:24 -0400
Received: from vaebh106.NOE.Nokia.com (vaebh106.europe.nokia.com [10.160.244.32])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o8R8bvwf023998
	for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 11:38:22 +0300
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 09/25] wl1271: Move setting of wake-up conditions to ps.c from cmd.c
Date: Mon, 27 Sep 2010 11:37:33 +0300
Message-Id: <1285576669-8070-10-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
References: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

This removes a fixme. Also, it removes a redundant setting of the wake-up
conditions when exiting power save mode, which should improve performance.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_cmd.c |    7 -------
 drivers/net/wireless/wl12xx/wl1271_ps.c  |    6 ++++++
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index a338b1c..a516035 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -395,13 +395,6 @@ int wl1271_cmd_ps_mode(struct wl1271 *wl, u8 ps_mode, bool send)
 	struct wl1271_cmd_ps_params *ps_params = NULL;
 	int ret = 0;
 
-	/* FIXME: this should be in ps.c */
-	ret = wl1271_acx_wake_up_conditions(wl);
-	if (ret < 0) {
-		wl1271_error("couldn't set wake up conditions");
-		goto out;
-	}
-
 	wl1271_debug(DEBUG_CMD, "cmd set ps mode");
 
 	ps_params = kzalloc(sizeof(*ps_params), GFP_KERNEL);
diff --git a/drivers/net/wireless/wl12xx/wl1271_ps.c b/drivers/net/wireless/wl12xx/wl1271_ps.c
index a5e60e0..52a6095 100644
--- a/drivers/net/wireless/wl12xx/wl1271_ps.c
+++ b/drivers/net/wireless/wl12xx/wl1271_ps.c
@@ -129,6 +129,12 @@ int wl1271_ps_set_mode(struct wl1271 *wl, enum wl1271_cmd_ps_mode mode,
 	case STATION_POWER_SAVE_MODE:
 		wl1271_debug(DEBUG_PSM, "entering psm");
 
+		ret = wl1271_acx_wake_up_conditions(wl);
+		if (ret < 0) {
+			wl1271_error("couldn't set wake up conditions");
+			return ret;
+		}
+
 		ret = wl1271_cmd_ps_mode(wl, STATION_POWER_SAVE_MODE, send);
 		if (ret < 0)
 			return ret;
-- 
1.6.3.3

