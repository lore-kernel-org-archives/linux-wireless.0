Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52591 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757335Ab2LHA6i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 19:58:38 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so603931eek.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Dec 2012 16:58:36 -0800 (PST)
From: Eyal Shapira <eyal@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v3] wlcore: increase scan dwell times if no activity
Date: Sat,  8 Dec 2012 02:58:23 +0200
Message-Id: <1354928303-13438-1-git-send-email-eyal@wizery.com> (sfid-20121208_015842_588455_30EE076C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's a limit on scan dwell times of max 30ms in order
to avoid degrading voip traffic which could be going on
while scanning. However these dwell times increase the
chance of missing out on nearby APs leading to partial
scan results. Allow configuration of longer dwell times
in case there no active interface (i.e. no STA associated
or AP up).

[Arik - count started vifs using an in-driver function]

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
v3: change semantics of new conf values to long dwell time (Thanks Luca)

This applies on top of Luca's current master (WLCORE_CONF_VERSION changes
to 5 instead of 6 in v2)

 drivers/net/wireless/ti/wl12xx/main.c |    2 ++
 drivers/net/wireless/ti/wl18xx/main.c |    2 ++
 drivers/net/wireless/ti/wlcore/conf.h |   26 +++++++++++++++++++++++++-
 drivers/net/wireless/ti/wlcore/scan.c |   30 +++++++++++++++++++++++++++---
 4 files changed, 56 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 64a5e81..e703ae7 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -267,6 +267,8 @@ static struct wlcore_conf wl12xx_conf = {
 	.scan = {
 		.min_dwell_time_active        = 7500,
 		.max_dwell_time_active        = 30000,
+		.min_dwell_time_active_long   = 25000,
+		.max_dwell_time_active_long   = 50000,
 		.dwell_time_passive           = 100000,
 		.dwell_time_dfs               = 150000,
 		.num_probe_reqs               = 2,
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index e6f64a4..e23dff8 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -394,6 +394,8 @@ static struct wlcore_conf wl18xx_conf = {
 	.scan = {
 		.min_dwell_time_active        = 7500,
 		.max_dwell_time_active        = 30000,
+		.min_dwell_time_active_long   = 25000,
+		.max_dwell_time_active_long   = 50000,
 		.dwell_time_passive           = 100000,
 		.dwell_time_dfs               = 150000,
 		.num_probe_reqs               = 2,
diff --git a/drivers/net/wireless/ti/wlcore/conf.h b/drivers/net/wireless/ti/wlcore/conf.h
index b64d6b5..b3c2dac 100644
--- a/drivers/net/wireless/ti/wlcore/conf.h
+++ b/drivers/net/wireless/ti/wlcore/conf.h
@@ -1044,6 +1044,7 @@ struct conf_roam_trigger_settings {
 struct conf_scan_settings {
 	/*
 	 * The minimum time to wait on each channel for active scans
+	 * This value will be used whenever there's a connected interface.
 	 *
 	 * Range: u32 tu/1000
 	 */
@@ -1051,11 +1052,34 @@ struct conf_scan_settings {
 
 	/*
 	 * The maximum time to wait on each channel for active scans
+	 * This value will be currently used whenever there's a
+	 * connected interface. It shouldn't exceed 30000 (~30ms) to avoid
+	 * possible interference of voip traffic going on while scanning.
 	 *
 	 * Range: u32 tu/1000
 	 */
 	u32 max_dwell_time_active;
 
+	/*
+	 * The minimum time to wait on each channel for active scans
+	 * when it's possible to have longer scan dwell times.
+	 * Currently this is used whenever we're idle on all interfaces.
+	 * Longer dwell times improve detection of networks within a
+	 * single scan.
+	 *
+	 * Range: u32 tu/1000
+	 */
+	u32 min_dwell_time_active_long;
+
+	/*
+	 * The maximum time to wait on each channel for active scans
+	 * when it's possible to have longer scan dwell times.
+	 * See min_dwell_time_active_long
+	 *
+	 * Range: u32 tu/1000
+	 */
+	u32 max_dwell_time_active_long;
+
 	/* time to wait on the channel for passive scans (in TU/1000) */
 	u32 dwell_time_passive;
 
@@ -1278,7 +1302,7 @@ struct conf_recovery_settings {
  * version, the two LSB are the lower driver's private conf
  * version.
  */
-#define WLCORE_CONF_VERSION	(0x0004 << 16)
+#define WLCORE_CONF_VERSION	(0x0005 << 16)
 #define WLCORE_CONF_MASK	0xffff0000
 #define WLCORE_CONF_SIZE	(sizeof(struct wlcore_conf_header) +	\
 				 sizeof(struct wlcore_conf))
diff --git a/drivers/net/wireless/ti/wlcore/scan.c b/drivers/net/wireless/ti/wlcore/scan.c
index 7f42f8a..6cfdeae 100644
--- a/drivers/net/wireless/ti/wlcore/scan.c
+++ b/drivers/net/wireless/ti/wlcore/scan.c
@@ -89,6 +89,25 @@ out:
 
 }
 
+static void wlcore_started_vifs_iter(void *data, u8 *mac,
+				     struct ieee80211_vif *vif)
+{
+	int *count = (int *)data;
+
+	if (!vif->bss_conf.idle)
+		(*count)++;
+}
+
+static int wlcore_count_started_vifs(struct wl1271 *wl)
+{
+	int count = 0;
+
+	ieee80211_iterate_active_interfaces_atomic(wl->hw,
+					IEEE80211_IFACE_ITER_RESUME_ALL,
+					wlcore_started_vifs_iter, &count);
+	return count;
+}
+
 static int
 wlcore_scan_get_channels(struct wl1271 *wl,
 			 struct ieee80211_channel *req_channels[],
@@ -109,9 +128,14 @@ wlcore_scan_get_channels(struct wl1271 *wl,
 	/* configure dwell times according to scan type */
 	if (scan_type == SCAN_TYPE_SEARCH) {
 		struct conf_scan_settings *c = &wl->conf.scan;
-
-		min_dwell_time_active = c->min_dwell_time_active;
-		max_dwell_time_active = c->max_dwell_time_active;
+		bool active_vif_exists = !!wlcore_count_started_vifs(wl);
+
+		min_dwell_time_active = active_vif_exists ?
+			c->min_dwell_time_active :
+			c->min_dwell_time_active_long;
+		max_dwell_time_active = active_vif_exists ?
+			c->max_dwell_time_active :
+			c->max_dwell_time_active_long;
 		dwell_time_passive = c->dwell_time_passive;
 		dwell_time_dfs = c->dwell_time_dfs;
 	} else {
-- 
1.7.9.5

