Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:32932 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573Ab2A3OzZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 09:55:25 -0500
Received: by werb13 with SMTP id b13so3523805wer.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jan 2012 06:55:24 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/7] wl12xx: Set different wake up conditions in case of suspend
Date: Mon, 30 Jan 2012 16:58:39 +0200
Message-Id: <1327935525-24361-2-git-send-email-eliad@wizery.com> (sfid-20120130_155530_927611_9097203D)
In-Reply-To: <1327935525-24361-1-git-send-email-eliad@wizery.com>
References: <1327935525-24361-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Added ability to set different wake up conditions for suspend/resume.
Set default values to wake up every 3 DTIMs while suspended
and every 1 DTIM while resumed

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/acx.c  |   10 ++++---
 drivers/net/wireless/wl12xx/acx.h  |    3 +-
 drivers/net/wireless/wl12xx/conf.h |   13 +++++++++
 drivers/net/wireless/wl12xx/main.c |   51 +++++++++++++++++++++++++++++++++--
 drivers/net/wireless/wl12xx/ps.c   |    4 ++-
 5 files changed, 72 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index af2c312..bc96db0 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -34,12 +34,14 @@
 #include "reg.h"
 #include "ps.h"
 
-int wl1271_acx_wake_up_conditions(struct wl1271 *wl, struct wl12xx_vif *wlvif)
+int wl1271_acx_wake_up_conditions(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+				  u8 wake_up_event, u8 listen_interval)
 {
 	struct acx_wake_up_condition *wake_up;
 	int ret;
 
-	wl1271_debug(DEBUG_ACX, "acx wake up conditions");
+	wl1271_debug(DEBUG_ACX, "acx wake up conditions (wake_up_event %d listen_interval %d)",
+		     wake_up_event, listen_interval);
 
 	wake_up = kzalloc(sizeof(*wake_up), GFP_KERNEL);
 	if (!wake_up) {
@@ -48,8 +50,8 @@ int wl1271_acx_wake_up_conditions(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	}
 
 	wake_up->role_id = wlvif->role_id;
-	wake_up->wake_up_event = wl->conf.conn.wake_up_event;
-	wake_up->listen_interval = wl->conf.conn.listen_interval;
+	wake_up->wake_up_event = wake_up_event;
+	wake_up->listen_interval = listen_interval;
 
 	ret = wl1271_cmd_configure(wl, ACX_WAKE_UP_CONDITIONS,
 				   wake_up, sizeof(*wake_up));
diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
index 0749df5..a28fc04 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -1226,7 +1226,8 @@ enum {
 
 
 int wl1271_acx_wake_up_conditions(struct wl1271 *wl,
-				  struct wl12xx_vif *wlvif);
+				  struct wl12xx_vif *wlvif,
+				  u8 wake_up_event, u8 listen_interval);
 int wl1271_acx_sleep_auth(struct wl1271 *wl, u8 sleep_auth);
 int wl1271_acx_tx_power(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			int power);
diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index 10e5e3d..d97aad6 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -810,6 +810,19 @@ struct conf_conn_settings {
 	u8 listen_interval;
 
 	/*
+	 * Firmware wakeup conditions during suspend
+	 * Range: CONF_WAKE_UP_EVENT_*
+	 */
+	u8 suspend_wake_up_event;
+
+	/*
+	 * Listen interval during suspend.
+	 * Currently will be in DTIMs (1-10)
+	 *
+	 */
+	u8 suspend_listen_interval;
+
+	/*
 	 * Enable or disable the beacon filtering.
 	 *
 	 * Range: CONF_BCN_FILT_MODE_*
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 2bb1c24..29a00fc 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -218,6 +218,8 @@ static struct conf_drv_settings default_conf = {
 	.conn = {
 		.wake_up_event               = CONF_WAKE_UP_EVENT_DTIM,
 		.listen_interval             = 1,
+		.suspend_wake_up_event       = CONF_WAKE_UP_EVENT_N_DTIM,
+		.suspend_listen_interval     = 3,
 		.bcn_filt_mode               = CONF_BCN_FILT_MODE_ENABLED,
 		.bcn_filt_ie_count           = 2,
 		.bcn_filt_ie = {
@@ -1561,6 +1563,35 @@ static struct notifier_block wl1271_dev_notifier = {
 };
 
 #ifdef CONFIG_PM
+static int wl1271_configure_suspend_sta(struct wl1271 *wl,
+					struct wl12xx_vif *wlvif)
+{
+	int ret = 0;
+
+	mutex_lock(&wl->mutex);
+
+	if (!test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags))
+		goto out_unlock;
+
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out_unlock;
+
+	ret = wl1271_acx_wake_up_conditions(wl, wlvif,
+				    wl->conf.conn.suspend_wake_up_event,
+				    wl->conf.conn.suspend_listen_interval);
+
+	if (ret < 0)
+		wl1271_error("suspend: set wake up conditions failed: %d", ret);
+
+
+	wl1271_ps_elp_sleep(wl);
+
+out_unlock:
+	mutex_unlock(&wl->mutex);
+	return ret;
+
+}
 
 static int wl1271_configure_suspend_ap(struct wl1271 *wl,
 				       struct wl12xx_vif *wlvif)
@@ -1588,6 +1619,8 @@ out_unlock:
 static int wl1271_configure_suspend(struct wl1271 *wl,
 				    struct wl12xx_vif *wlvif)
 {
+	if (wlvif->bss_type == BSS_TYPE_STA_BSS)
+		return wl1271_configure_suspend_sta(wl, wlvif);
 	if (wlvif->bss_type == BSS_TYPE_AP_BSS)
 		return wl1271_configure_suspend_ap(wl, wlvif);
 	return 0;
@@ -1596,10 +1629,11 @@ static int wl1271_configure_suspend(struct wl1271 *wl,
 static void wl1271_configure_resume(struct wl1271 *wl,
 				    struct wl12xx_vif *wlvif)
 {
-	int ret;
+	int ret = 0;
 	bool is_ap = wlvif->bss_type == BSS_TYPE_AP_BSS;
+	bool is_sta = wlvif->bss_type == BSS_TYPE_STA_BSS;
 
-	if (!is_ap)
+	if ((!is_ap) && (!is_sta))
 		return;
 
 	mutex_lock(&wl->mutex);
@@ -1607,7 +1641,18 @@ static void wl1271_configure_resume(struct wl1271 *wl,
 	if (ret < 0)
 		goto out;
 
-	wl1271_acx_beacon_filter_opt(wl, wlvif, false);
+	if (is_sta) {
+		ret = wl1271_acx_wake_up_conditions(wl, wlvif,
+				    wl->conf.conn.wake_up_event,
+				    wl->conf.conn.listen_interval);
+
+		if (ret < 0)
+			wl1271_error("resume: wake up conditions failed: %d",
+				     ret);
+
+	} else if (is_ap) {
+		ret = wl1271_acx_beacon_filter_opt(wl, wlvif, false);
+	}
 
 	wl1271_ps_elp_sleep(wl);
 out:
diff --git a/drivers/net/wireless/wl12xx/ps.c b/drivers/net/wireless/wl12xx/ps.c
index e209e29..d197922 100644
--- a/drivers/net/wireless/wl12xx/ps.c
+++ b/drivers/net/wireless/wl12xx/ps.c
@@ -170,7 +170,9 @@ int wl1271_ps_set_mode(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		wl1271_debug(DEBUG_PSM, "entering psm (mode=%d,timeout=%u)",
 			     mode, timeout);
 
-		ret = wl1271_acx_wake_up_conditions(wl, wlvif);
+		ret = wl1271_acx_wake_up_conditions(wl, wlvif,
+					    wl->conf.conn.wake_up_event,
+					    wl->conf.conn.listen_interval);
 		if (ret < 0) {
 			wl1271_error("couldn't set wake up conditions");
 			return ret;
-- 
1.7.6.401.g6a319

