Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:35701 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab2K2Wrg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2012 17:47:36 -0500
Received: by mail-we0-f174.google.com with SMTP id d7so5137232wer.19
        for <linux-wireless@vger.kernel.org>; Thu, 29 Nov 2012 14:47:35 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Eyal Shapira <eyal@wizery.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2] wlcore: increase scan dwell times if no activity
Date: Fri, 30 Nov 2012 00:47:31 +0200
Message-Id: <1354229251-7879-1-git-send-email-arik@wizery.com> (sfid-20121129_234739_328349_B4ACA0DF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

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
v2: move to new vif iterator API

 drivers/net/wireless/ti/wl12xx/main.c |    6 ++++--
 drivers/net/wireless/ti/wl18xx/main.c |    6 ++++--
 drivers/net/wireless/ti/wlcore/conf.h |   20 +++++++++++++++++++-
 drivers/net/wireless/ti/wlcore/scan.c |   29 +++++++++++++++++++++++++++--
 4 files changed, 54 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 1494cda..3285f99 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -267,8 +267,10 @@ static struct wlcore_conf wl12xx_conf = {
 		.avg_weight_snr_data          = 10,
 	},
 	.scan = {
-		.min_dwell_time_active        = 7500,
-		.max_dwell_time_active        = 30000,
+		.min_dwell_time_active_conc   = 7500,
+		.max_dwell_time_active_conc   = 30000,
+		.min_dwell_time_active        = 25000,
+		.max_dwell_time_active        = 50000,
 		.dwell_time_passive           = 100000,
 		.dwell_time_dfs               = 150000,
 		.num_probe_reqs               = 2,
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 29a0313..be6cf28 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -394,8 +394,10 @@ static struct wlcore_conf wl18xx_conf = {
 		.avg_weight_snr_data          = 10,
 	},
 	.scan = {
-		.min_dwell_time_active        = 7500,
-		.max_dwell_time_active        = 30000,
+		.min_dwell_time_active_conc   = 7500,
+		.max_dwell_time_active_conc   = 30000,
+		.min_dwell_time_active        = 25000,
+		.max_dwell_time_active        = 50000,
 		.dwell_time_passive           = 100000,
 		.dwell_time_dfs               = 150000,
 		.num_probe_reqs               = 2,
diff --git a/drivers/net/wireless/ti/wlcore/conf.h b/drivers/net/wireless/ti/wlcore/conf.h
index ad15cae..a4eb14c 100644
--- a/drivers/net/wireless/ti/wlcore/conf.h
+++ b/drivers/net/wireless/ti/wlcore/conf.h
@@ -1097,6 +1097,24 @@ struct conf_scan_settings {
 	 */
 	u32 max_dwell_time_active;
 
+	/*
+	 * The minimum time to wait on each channel for active scans
+	 * when there's a concurrent active interface. This should
+	 * lower than min_dwell_time_active usually in order to avoid
+	 * interfering with possible voip traffic on another interface.
+	 *
+	 * Range: u32 tu/1000
+	 */
+	u32 min_dwell_time_active_conc;
+
+	/*
+	 * The maximum time to wait on each channel for active scans
+	 * See explanation about min_dwell_time_active_conc
+	 *
+	 * Range: u32 tu/1000
+	 */
+	u32 max_dwell_time_active_conc;
+
 	/* time to wait on the channel for passive scans (in TU/1000) */
 	u32 dwell_time_passive;
 
@@ -1322,7 +1340,7 @@ struct conf_recovery_settings {
  * version, the two LSB are the lower driver's private conf
  * version.
  */
-#define WLCORE_CONF_VERSION	(0x0005 << 16)
+#define WLCORE_CONF_VERSION	(0x0006 << 16)
 #define WLCORE_CONF_MASK	0xffff0000
 #define WLCORE_CONF_SIZE	(sizeof(struct wlcore_conf_header) +	\
 				 sizeof(struct wlcore_conf))
diff --git a/drivers/net/wireless/ti/wlcore/scan.c b/drivers/net/wireless/ti/wlcore/scan.c
index 7f42f8a..5c0331d 100644
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
@@ -109,9 +128,15 @@ wlcore_scan_get_channels(struct wl1271 *wl,
 	/* configure dwell times according to scan type */
 	if (scan_type == SCAN_TYPE_SEARCH) {
 		struct conf_scan_settings *c = &wl->conf.scan;
+		bool active_vif_exists = !!wlcore_count_started_vifs(wl);
+
+		min_dwell_time_active = active_vif_exists ?
+			c->min_dwell_time_active_conc :
+			c->min_dwell_time_active;
+		max_dwell_time_active = active_vif_exists ?
+			c->max_dwell_time_active_conc :
+			c->max_dwell_time_active;
 
-		min_dwell_time_active = c->min_dwell_time_active;
-		max_dwell_time_active = c->max_dwell_time_active;
 		dwell_time_passive = c->dwell_time_passive;
 		dwell_time_dfs = c->dwell_time_dfs;
 	} else {
-- 
1.7.9.5

