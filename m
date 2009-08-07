Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:45929 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757435AbZHGKfd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 06:35:33 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 18/23] wl1251: move wl1251_acx_wake_up_conditions() to
	wl1251_ps_set_mode()
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Fri, 07 Aug 2009 13:34:56 +0300
Message-ID: <20090807103456.31717.92185.stgit@tikku>
In-Reply-To: <20090807102732.31717.84006.stgit@tikku>
References: <20090807102732.31717.84006.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

It should not be hidden inside wl1251_cmd_ps_mode().

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
Reviewed-by: Vidhya Govindan <vidhya.govindan@nokia.com>
---

 drivers/net/wireless/wl12xx/wl1251_cmd.c |    8 --------
 drivers/net/wireless/wl12xx/wl1251_ps.c  |   13 +++++++++++++
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_cmd.c b/drivers/net/wireless/wl12xx/wl1251_cmd.c
index d7800a3..74ea1fd 100644
--- a/drivers/net/wireless/wl12xx/wl1251_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1251_cmd.c
@@ -301,14 +301,6 @@ int wl1251_cmd_ps_mode(struct wl1251 *wl, u8 ps_mode)
 	struct wl1251_cmd_ps_params *ps_params = NULL;
 	int ret = 0;
 
-	/* FIXME: this should be in ps.c */
-	ret = wl1251_acx_wake_up_conditions(wl, WAKE_UP_EVENT_DTIM_BITMAP,
-					    wl->listen_int);
-	if (ret < 0) {
-		wl1251_error("couldn't set wake up conditions");
-		goto out;
-	}
-
 	wl1251_debug(DEBUG_CMD, "cmd set ps mode");
 
 	ps_params = kzalloc(sizeof(*ps_params), GFP_KERNEL);
diff --git a/drivers/net/wireless/wl12xx/wl1251_ps.c b/drivers/net/wireless/wl12xx/wl1251_ps.c
index 0581677..36acde0 100644
--- a/drivers/net/wireless/wl12xx/wl1251_ps.c
+++ b/drivers/net/wireless/wl12xx/wl1251_ps.c
@@ -118,6 +118,13 @@ int wl1251_ps_set_mode(struct wl1251 *wl, enum wl1251_cmd_ps_mode mode)
 	switch (mode) {
 	case STATION_POWER_SAVE_MODE:
 		wl1251_debug(DEBUG_PSM, "entering psm");
+
+		ret = wl1251_acx_wake_up_conditions(wl,
+						    WAKE_UP_EVENT_DTIM_BITMAP,
+						    wl->listen_int);
+		if (ret < 0)
+			return ret;
+
 		ret = wl1251_cmd_ps_mode(wl, STATION_POWER_SAVE_MODE);
 		if (ret < 0)
 			return ret;
@@ -135,6 +142,12 @@ int wl1251_ps_set_mode(struct wl1251 *wl, enum wl1251_cmd_ps_mode mode)
 		if (ret < 0)
 			return ret;
 
+		ret = wl1251_acx_wake_up_conditions(wl,
+						    WAKE_UP_EVENT_DTIM_BITMAP,
+						    wl->listen_int);
+		if (ret < 0)
+			return ret;
+
 		ret = wl1251_cmd_ps_mode(wl, STATION_ACTIVE_MODE);
 		if (ret < 0)
 			return ret;

