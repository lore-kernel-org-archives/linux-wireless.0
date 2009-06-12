Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:64789 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbZFLLQd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 07:16:33 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 14/33] wl12xx: pass the wake up condition when configuring the
	wake up event
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Jun 2009 14:15:46 +0300
Message-ID: <20090612111546.8877.3108.stgit@tikku>
In-Reply-To: <20090612110225.8877.92418.stgit@tikku>
References: <20090612110225.8877.92418.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@nokia.com>

Changed the function wl12xx_acx_wake_up_conditions() so that it receives an
argument with the actual wake up condition, instead of having
WAKE_UP_EVENT_DTIM_BITMAP hardcoded.  This is needed because we have to use
different conditions in 1271.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/acx.c |    5 +++--
 drivers/net/wireless/wl12xx/acx.h |    3 ++-
 drivers/net/wireless/wl12xx/cmd.c |    3 ++-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index d0daf69..a6b8945 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -96,7 +96,8 @@ out:
 	return ret;
 }
 
-int wl12xx_acx_wake_up_conditions(struct wl12xx *wl, u8 listen_interval)
+int wl12xx_acx_wake_up_conditions(struct wl12xx *wl, u8 wake_up_event,
+				  u8 listen_interval)
 {
 	struct acx_wake_up_condition *wake_up;
 	int ret;
@@ -109,7 +110,7 @@ int wl12xx_acx_wake_up_conditions(struct wl12xx *wl, u8 listen_interval)
 		goto out;
 	}
 
-	wake_up->wake_up_event = WAKE_UP_EVENT_DTIM_BITMAP;
+	wake_up->wake_up_event = wake_up_event;
 	wake_up->listen_interval = listen_interval;
 
 	ret = wl12xx_cmd_configure(wl, ACX_WAKE_UP_CONDITIONS,
diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
index 549e537..92e7248 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -1112,7 +1112,8 @@ int wl12xx_acx_frame_rates(struct wl12xx *wl, u8 ctrl_rate, u8 ctrl_mod,
 			   u8 mgt_rate, u8 mgt_mod);
 int wl12xx_acx_station_id(struct wl12xx *wl);
 int wl12xx_acx_default_key(struct wl12xx *wl, u8 key_id);
-int wl12xx_acx_wake_up_conditions(struct wl12xx *wl, u8 listen_interval);
+int wl12xx_acx_wake_up_conditions(struct wl12xx *wl, u8 wake_up_event,
+				  u8 listen_interval);
 int wl12xx_acx_sleep_auth(struct wl12xx *wl, u8 sleep_auth);
 int wl12xx_acx_fw_version(struct wl12xx *wl, char *buf, size_t len);
 int wl12xx_acx_tx_power(struct wl12xx *wl, int power);
diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 0a02cdd..d98941a 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -346,7 +346,8 @@ int wl12xx_cmd_ps_mode(struct wl12xx *wl, u8 ps_mode)
 	int ret = 0;
 
 	/* FIXME: this should be in ps.c */
-	ret = wl12xx_acx_wake_up_conditions(wl, wl->listen_int);
+	ret = wl12xx_acx_wake_up_conditions(wl, WAKE_UP_EVENT_DTIM_BITMAP,
+					    wl->listen_int);
 	if (ret < 0) {
 		wl12xx_error("couldn't set wake up conditions");
 		goto out;

