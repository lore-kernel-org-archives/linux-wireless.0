Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:51212 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab2KZQF6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 11:05:58 -0500
Received: by mail-wg0-f42.google.com with SMTP id dr1so2144136wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2012 08:05:57 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Eliad Peller <eliad@wizery.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 01/11] wlcore: configure dwell times according to scan type
Date: Mon, 26 Nov 2012 18:05:40 +0200
Message-Id: <1353945950-3899-2-git-send-email-arik@wizery.com> (sfid-20121126_170613_397882_71F02588)
In-Reply-To: <1353945950-3899-1-git-send-email-arik@wizery.com>
References: <1353945950-3899-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Allow configuring different dwell times to the different
scan types (regular and scheduled).

Add new configuration entry (dwell_time_dfs) to
conf_scan_settings, in order to allow setting
different values for normal scan and scheduled scan.

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl12xx/main.c |    4 +--
 drivers/net/wireless/ti/wl12xx/scan.c |    7 ++--
 drivers/net/wireless/ti/wl18xx/main.c |    4 +--
 drivers/net/wireless/ti/wl18xx/scan.c |    6 ++--
 drivers/net/wireless/ti/wl18xx/scan.h |    7 ----
 drivers/net/wireless/ti/wlcore/conf.h |   18 +++--------
 drivers/net/wireless/ti/wlcore/scan.c |   57 ++++++++++++++++++++++-----------
 drivers/net/wireless/ti/wlcore/scan.h |    9 +++++-
 8 files changed, 64 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 7138fe4..17ee0fd 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -267,8 +267,8 @@ static struct wlcore_conf wl12xx_conf = {
 	.scan = {
 		.min_dwell_time_active        = 7500,
 		.max_dwell_time_active        = 30000,
-		.min_dwell_time_passive       = 100000,
-		.max_dwell_time_passive       = 100000,
+		.dwell_time_passive           = 100000,
+		.dwell_time_dfs               = 150000,
 		.num_probe_reqs               = 2,
 		.split_scan_timeout           = 50000,
 	},
diff --git a/drivers/net/wireless/ti/wl12xx/scan.c b/drivers/net/wireless/ti/wl12xx/scan.c
index a99e876..affdb3e 100644
--- a/drivers/net/wireless/ti/wl12xx/scan.c
+++ b/drivers/net/wireless/ti/wl12xx/scan.c
@@ -68,9 +68,9 @@ static int wl1271_get_scan_channels(struct wl1271 *wl,
 					cpu_to_le32(c->max_dwell_time_active);
 			} else {
 				channels[j].min_duration =
-					cpu_to_le32(c->min_dwell_time_passive);
+					cpu_to_le32(c->dwell_time_passive);
 				channels[j].max_duration =
-					cpu_to_le32(c->max_dwell_time_passive);
+					cpu_to_le32(c->dwell_time_passive);
 			}
 			channels[j].early_termination = 0;
 			channels[j].tx_power_att = req->channels[i]->max_power;
@@ -364,7 +364,8 @@ int wl1271_scan_sched_scan_config(struct wl1271 *wl,
 	}
 
 	if (!wlcore_set_scan_chan_params(wl, cfg_channels, req->channels,
-					 req->n_channels, req->n_ssids)) {
+					 req->n_channels, req->n_ssids,
+					 SCAN_TYPE_PERIODIC)) {
 		wl1271_error("scan channel list is empty");
 		ret = -EINVAL;
 		goto out;
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index bb67d70..c015231 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -394,8 +394,8 @@ static struct wlcore_conf wl18xx_conf = {
 	.scan = {
 		.min_dwell_time_active        = 7500,
 		.max_dwell_time_active        = 30000,
-		.min_dwell_time_passive       = 100000,
-		.max_dwell_time_passive       = 100000,
+		.dwell_time_passive           = 100000,
+		.dwell_time_dfs               = 150000,
 		.num_probe_reqs               = 2,
 		.split_scan_timeout           = 50000,
 	},
diff --git a/drivers/net/wireless/ti/wl18xx/scan.c b/drivers/net/wireless/ti/wl18xx/scan.c
index f31d0d4..daaebad 100644
--- a/drivers/net/wireless/ti/wl18xx/scan.c
+++ b/drivers/net/wireless/ti/wl18xx/scan.c
@@ -84,7 +84,8 @@ static int wl18xx_scan_send(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	}
 
 	wlcore_set_scan_chan_params(wl, cmd_channels, req->channels,
-				    req->n_channels, req->n_ssids);
+				    req->n_channels, req->n_ssids,
+				    SCAN_TYPE_SEARCH);
 	wl18xx_adjust_channels(cmd, cmd_channels);
 
 	/*
@@ -214,7 +215,8 @@ int wl18xx_scan_sched_scan_config(struct wl1271 *wl,
 
 	/* configure channels */
 	wlcore_set_scan_chan_params(wl, cmd_channels, req->channels,
-				    req->n_channels, req->n_ssids);
+				    req->n_channels, req->n_ssids,
+				    SCAN_TYPE_PERIODIC);
 	wl18xx_adjust_channels(cmd, cmd_channels);
 
 	cmd->short_cycles_sec = 0;
diff --git a/drivers/net/wireless/ti/wl18xx/scan.h b/drivers/net/wireless/ti/wl18xx/scan.h
index 0e026ec..5eb8c7f 100644
--- a/drivers/net/wireless/ti/wl18xx/scan.h
+++ b/drivers/net/wireless/ti/wl18xx/scan.h
@@ -35,13 +35,6 @@ struct tracking_ch_params {
 	u8 padding[2];
 } __packed;
 
-enum
-{
-	SCAN_TYPE_SEARCH	= 0,
-	SCAN_TYPE_PERIODIC	= 1,
-	SCAN_TYPE_TRACKING	= 2,
-};
-
 /* probe request rate */
 enum
 {
diff --git a/drivers/net/wireless/ti/wlcore/conf.h b/drivers/net/wireless/ti/wlcore/conf.h
index a5d1908..c9de4d5 100644
--- a/drivers/net/wireless/ti/wlcore/conf.h
+++ b/drivers/net/wireless/ti/wlcore/conf.h
@@ -1059,19 +1059,11 @@ struct conf_scan_settings {
 	 */
 	u32 max_dwell_time_active;
 
-	/*
-	 * The minimum time to wait on each channel for passive scans
-	 *
-	 * Range: u32 tu/1000
-	 */
-	u32 min_dwell_time_passive;
+	/* time to wait on the channel for passive scans (in TU/1000) */
+	u32 dwell_time_passive;
 
-	/*
-	 * The maximum time to wait on each channel for passive scans
-	 *
-	 * Range: u32 tu/1000
-	 */
-	u32 max_dwell_time_passive;
+	/* time to wait on the channel for DFS scans (in TU/1000) */
+	u32 dwell_time_dfs;
 
 	/*
 	 * Number of probe requests to transmit on each active scan channel
@@ -1281,7 +1273,7 @@ struct conf_hangover_settings {
  * version, the two LSB are the lower driver's private conf
  * version.
  */
-#define WLCORE_CONF_VERSION	(0x0002 << 16)
+#define WLCORE_CONF_VERSION	(0x0003 << 16)
 #define WLCORE_CONF_MASK	0xffff0000
 #define WLCORE_CONF_SIZE	(sizeof(struct wlcore_conf_header) +	\
 				 sizeof(struct wlcore_conf))
diff --git a/drivers/net/wireless/ti/wlcore/scan.c b/drivers/net/wireless/ti/wlcore/scan.c
index c913700..7f42f8a 100644
--- a/drivers/net/wireless/ti/wlcore/scan.c
+++ b/drivers/net/wireless/ti/wlcore/scan.c
@@ -97,29 +97,44 @@ wlcore_scan_get_channels(struct wl1271 *wl,
 			 struct conn_scan_ch_params *channels,
 			 u32 band, bool radar, bool passive,
 			 int start, int max_channels,
-			 u8 *n_pactive_ch)
+			 u8 *n_pactive_ch,
+			 int scan_type)
 {
-	struct conf_sched_scan_settings *c = &wl->conf.sched_scan;
 	int i, j;
 	u32 flags;
 	bool force_passive = !n_ssids;
-	u32 min_dwell_time_active, max_dwell_time_active, delta_per_probe;
+	u32 min_dwell_time_active, max_dwell_time_active;
 	u32 dwell_time_passive, dwell_time_dfs;
 
-	if (band == IEEE80211_BAND_5GHZ)
-		delta_per_probe = c->dwell_time_delta_per_probe_5;
-	else
-		delta_per_probe = c->dwell_time_delta_per_probe;
+	/* configure dwell times according to scan type */
+	if (scan_type == SCAN_TYPE_SEARCH) {
+		struct conf_scan_settings *c = &wl->conf.scan;
 
-	min_dwell_time_active = c->base_dwell_time +
-		 n_ssids * c->num_probe_reqs * delta_per_probe;
+		min_dwell_time_active = c->min_dwell_time_active;
+		max_dwell_time_active = c->max_dwell_time_active;
+		dwell_time_passive = c->dwell_time_passive;
+		dwell_time_dfs = c->dwell_time_dfs;
+	} else {
+		struct conf_sched_scan_settings *c = &wl->conf.sched_scan;
+		u32 delta_per_probe;
+
+		if (band == IEEE80211_BAND_5GHZ)
+			delta_per_probe = c->dwell_time_delta_per_probe_5;
+		else
+			delta_per_probe = c->dwell_time_delta_per_probe;
 
-	max_dwell_time_active = min_dwell_time_active + c->max_dwell_time_delta;
+		min_dwell_time_active = c->base_dwell_time +
+			 n_ssids * c->num_probe_reqs * delta_per_probe;
 
+		max_dwell_time_active = min_dwell_time_active +
+					c->max_dwell_time_delta;
+		dwell_time_passive = c->dwell_time_passive;
+		dwell_time_dfs = c->dwell_time_dfs;
+	}
 	min_dwell_time_active = DIV_ROUND_UP(min_dwell_time_active, 1000);
 	max_dwell_time_active = DIV_ROUND_UP(max_dwell_time_active, 1000);
-	dwell_time_passive = DIV_ROUND_UP(c->dwell_time_passive, 1000);
-	dwell_time_dfs = DIV_ROUND_UP(c->dwell_time_dfs, 1000);
+	dwell_time_passive = DIV_ROUND_UP(dwell_time_passive, 1000);
+	dwell_time_dfs = DIV_ROUND_UP(dwell_time_dfs, 1000);
 
 	for (i = 0, j = start;
 	     i < n_channels && j < max_channels;
@@ -195,7 +210,8 @@ wlcore_set_scan_chan_params(struct wl1271 *wl,
 			    struct wlcore_scan_channels *cfg,
 			    struct ieee80211_channel *channels[],
 			    u32 n_channels,
-			    u32 n_ssids)
+			    u32 n_ssids,
+			    int scan_type)
 {
 	u8 n_pactive_ch = 0;
 
@@ -208,7 +224,8 @@ wlcore_set_scan_chan_params(struct wl1271 *wl,
 					 IEEE80211_BAND_2GHZ,
 					 false, true, 0,
 					 MAX_CHANNELS_2GHZ,
-					 &n_pactive_ch);
+					 &n_pactive_ch,
+					 scan_type);
 	cfg->active[0] =
 		wlcore_scan_get_channels(wl,
 					 channels,
@@ -219,7 +236,8 @@ wlcore_set_scan_chan_params(struct wl1271 *wl,
 					 false, false,
 					 cfg->passive[0],
 					 MAX_CHANNELS_2GHZ,
-					 &n_pactive_ch);
+					 &n_pactive_ch,
+					 scan_type);
 	cfg->passive[1] =
 		wlcore_scan_get_channels(wl,
 					 channels,
@@ -229,7 +247,8 @@ wlcore_set_scan_chan_params(struct wl1271 *wl,
 					 IEEE80211_BAND_5GHZ,
 					 false, true, 0,
 					 wl->max_channels_5,
-					 &n_pactive_ch);
+					 &n_pactive_ch,
+					 scan_type);
 	cfg->dfs =
 		wlcore_scan_get_channels(wl,
 					 channels,
@@ -240,7 +259,8 @@ wlcore_set_scan_chan_params(struct wl1271 *wl,
 					 true, true,
 					 cfg->passive[1],
 					 wl->max_channels_5,
-					 &n_pactive_ch);
+					 &n_pactive_ch,
+					 scan_type);
 	cfg->active[1] =
 		wlcore_scan_get_channels(wl,
 					 channels,
@@ -251,7 +271,8 @@ wlcore_set_scan_chan_params(struct wl1271 *wl,
 					 false, false,
 					 cfg->passive[1] + cfg->dfs,
 					 wl->max_channels_5,
-					 &n_pactive_ch);
+					 &n_pactive_ch,
+					 scan_type);
 
 	/* 802.11j channels are not supported yet */
 	cfg->passive[2] = 0;
diff --git a/drivers/net/wireless/ti/wlcore/scan.h b/drivers/net/wireless/ti/wlcore/scan.h
index 8465f35..9ae6065 100644
--- a/drivers/net/wireless/ti/wlcore/scan.h
+++ b/drivers/net/wireless/ti/wlcore/scan.h
@@ -150,12 +150,19 @@ struct wlcore_scan_channels {
 	struct conn_scan_ch_params channels_4[MAX_CHANNELS_4GHZ];
 };
 
+enum {
+	SCAN_TYPE_SEARCH	= 0,
+	SCAN_TYPE_PERIODIC	= 1,
+	SCAN_TYPE_TRACKING	= 2,
+};
+
 bool
 wlcore_set_scan_chan_params(struct wl1271 *wl,
 			    struct wlcore_scan_channels *cfg,
 			    struct ieee80211_channel *channels[],
 			    u32 n_channels,
-			    u32 n_ssids);
+			    u32 n_ssids,
+			    int scan_type);
 
 int
 wlcore_scan_sched_scan_ssid_list(struct wl1271 *wl,
-- 
1.7.9.5

