Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:32949 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977Ab2KVSrL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2012 13:47:11 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so3312830eaa.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Nov 2012 10:47:09 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 02/14] wlcore: make scan scan configuration functions more generic
Date: Thu, 22 Nov 2012 18:06:12 +0200
Message-Id: <1353600384-32462-3-git-send-email-eliad@wizery.com> (sfid-20121122_194727_846024_DD9FD833)
In-Reply-To: <1353600384-32462-1-git-send-email-eliad@wizery.com>
References: <1353600384-32462-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

18xx and 12xx have different scan APIs. In 18xx,
the scan and the sched scan use the same struct.

Prepare the scan configuration functions to it, by taking
more generic params (e.g. ieee80211_channel) instead of
specific structs/requests.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/scan.c |  129 ++++++++++++++++++++-------------
 1 files changed, 78 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/scan.c b/drivers/net/wireless/ti/wlcore/scan.c
index d005014..22dd7e9 100644
--- a/drivers/net/wireless/ti/wlcore/scan.c
+++ b/drivers/net/wireless/ti/wlcore/scan.c
@@ -403,17 +403,19 @@ out:
 }
 
 static int
-wl1271_scan_get_sched_scan_channels(struct wl1271 *wl,
-				    struct cfg80211_sched_scan_request *req,
-				    struct conn_scan_ch_params *channels,
-				    u32 band, bool radar, bool passive,
-				    int start, int max_channels,
-				    u8 *n_pactive_ch)
+wlcore_scan_get_channels(struct wl1271 *wl,
+			 struct ieee80211_channel *req_channels[],
+			 u32 n_channels,
+			 u32 n_ssids,
+			 struct conn_scan_ch_params *channels,
+			 u32 band, bool radar, bool passive,
+			 int start, int max_channels,
+			 u8 *n_pactive_ch)
 {
 	struct conf_sched_scan_settings *c = &wl->conf.sched_scan;
 	int i, j;
 	u32 flags;
-	bool force_passive = !req->n_ssids;
+	bool force_passive = !n_ssids;
 	u32 min_dwell_time_active, max_dwell_time_active, delta_per_probe;
 	u32 dwell_time_passive, dwell_time_dfs;
 
@@ -423,7 +425,7 @@ wl1271_scan_get_sched_scan_channels(struct wl1271 *wl,
 		delta_per_probe = c->dwell_time_delta_per_probe;
 
 	min_dwell_time_active = c->base_dwell_time +
-		 req->n_ssids * c->num_probe_reqs * delta_per_probe;
+		 n_ssids * c->num_probe_reqs * delta_per_probe;
 
 	max_dwell_time_active = min_dwell_time_active + c->max_dwell_time_delta;
 
@@ -433,27 +435,27 @@ wl1271_scan_get_sched_scan_channels(struct wl1271 *wl,
 	dwell_time_dfs = DIV_ROUND_UP(c->dwell_time_dfs, 1000);
 
 	for (i = 0, j = start;
-	     i < req->n_channels && j < max_channels;
+	     i < n_channels && j < max_channels;
 	     i++) {
-		flags = req->channels[i]->flags;
+		flags = req_channels[i]->flags;
 
 		if (force_passive)
 			flags |= IEEE80211_CHAN_PASSIVE_SCAN;
 
-		if ((req->channels[i]->band == band) &&
+		if ((req_channels[i]->band == band) &&
 		    !(flags & IEEE80211_CHAN_DISABLED) &&
 		    (!!(flags & IEEE80211_CHAN_RADAR) == radar) &&
 		    /* if radar is set, we ignore the passive flag */
 		    (radar ||
 		     !!(flags & IEEE80211_CHAN_PASSIVE_SCAN) == passive)) {
 			wl1271_debug(DEBUG_SCAN, "band %d, center_freq %d ",
-				     req->channels[i]->band,
-				     req->channels[i]->center_freq);
+				     req_channels[i]->band,
+				     req_channels[i]->center_freq);
 			wl1271_debug(DEBUG_SCAN, "hw_value %d, flags %X",
-				     req->channels[i]->hw_value,
-				     req->channels[i]->flags);
+				     req_channels[i]->hw_value,
+				     req_channels[i]->flags);
 			wl1271_debug(DEBUG_SCAN, "max_power %d",
-				     req->channels[i]->max_power);
+				     req_channels[i]->max_power);
 			wl1271_debug(DEBUG_SCAN, "min_dwell_time %d max dwell time %d",
 				     min_dwell_time_active,
 				     max_dwell_time_active);
@@ -473,10 +475,11 @@ wl1271_scan_get_sched_scan_channels(struct wl1271 *wl,
 			channels[j].max_duration =
 				cpu_to_le16(max_dwell_time_active);
 
-			channels[j].tx_power_att = req->channels[i]->max_power;
-			channels[j].channel = req->channels[i]->hw_value;
+			channels[j].tx_power_att = req_channels[i]->max_power;
+			channels[j].channel = req_channels[i]->hw_value;
 
-			if ((band == IEEE80211_BAND_2GHZ) &&
+			if (n_pactive_ch &&
+			    (band == IEEE80211_BAND_2GHZ) &&
 			    (channels[j].channel >= 12) &&
 			    (channels[j].channel <= 14) &&
 			    (flags & IEEE80211_CHAN_PASSIVE_SCAN) &&
@@ -501,45 +504,68 @@ wl1271_scan_get_sched_scan_channels(struct wl1271 *wl,
 }
 
 static bool
-wl1271_scan_sched_scan_channels(struct wl1271 *wl,
-				struct cfg80211_sched_scan_request *req,
-				struct wl1271_cmd_sched_scan_config *cfg)
+wlcore_set_scan_chan_params(struct wl1271 *wl,
+			    struct wl1271_cmd_sched_scan_config *cfg,
+			    struct ieee80211_channel *channels[],
+			    u32 n_channels,
+			    u32 n_ssids)
 {
 	u8 n_pactive_ch = 0;
 
 	cfg->passive[0] =
-		wl1271_scan_get_sched_scan_channels(wl, req, cfg->channels_2,
-						    IEEE80211_BAND_2GHZ,
-						    false, true, 0,
-						    MAX_CHANNELS_2GHZ,
-						    &n_pactive_ch);
+		wlcore_scan_get_channels(wl,
+					 channels,
+					 n_channels,
+					 n_ssids,
+					 cfg->channels_2,
+					 IEEE80211_BAND_2GHZ,
+					 false, true, 0,
+					 MAX_CHANNELS_2GHZ,
+					 &n_pactive_ch);
 	cfg->active[0] =
-		wl1271_scan_get_sched_scan_channels(wl, req, cfg->channels_2,
-						    IEEE80211_BAND_2GHZ,
-						    false, false,
-						    cfg->passive[0],
-						    MAX_CHANNELS_2GHZ,
-						    &n_pactive_ch);
+		wlcore_scan_get_channels(wl,
+					 channels,
+					 n_channels,
+					 n_ssids,
+					 cfg->channels_2,
+					 IEEE80211_BAND_2GHZ,
+					 false, false,
+					 cfg->passive[0],
+					 MAX_CHANNELS_2GHZ,
+					 &n_pactive_ch);
 	cfg->passive[1] =
-		wl1271_scan_get_sched_scan_channels(wl, req, cfg->channels_5,
-						    IEEE80211_BAND_5GHZ,
-						    false, true, 0,
-						    MAX_CHANNELS_5GHZ,
-						    &n_pactive_ch);
+		wlcore_scan_get_channels(wl,
+					 channels,
+					 n_channels,
+					 n_ssids,
+					 cfg->channels_5,
+					 IEEE80211_BAND_5GHZ,
+					 false, true, 0,
+					 MAX_CHANNELS_5GHZ,
+					 &n_pactive_ch);
 	cfg->dfs =
-		wl1271_scan_get_sched_scan_channels(wl, req, cfg->channels_5,
-						    IEEE80211_BAND_5GHZ,
-						    true, true,
-						    cfg->passive[1],
-						    MAX_CHANNELS_5GHZ,
-						    &n_pactive_ch);
+		wlcore_scan_get_channels(wl,
+					 channels,
+					 n_channels,
+					 n_ssids,
+					 cfg->channels_5,
+					 IEEE80211_BAND_5GHZ,
+					 true, true,
+					 cfg->passive[1],
+					 MAX_CHANNELS_5GHZ,
+					 &n_pactive_ch);
 	cfg->active[1] =
-		wl1271_scan_get_sched_scan_channels(wl, req, cfg->channels_5,
-						    IEEE80211_BAND_5GHZ,
-						    false, false,
-						    cfg->passive[1] + cfg->dfs,
-						    MAX_CHANNELS_5GHZ,
-						    &n_pactive_ch);
+		wlcore_scan_get_channels(wl,
+					 channels,
+					 n_channels,
+					 n_ssids,
+					 cfg->channels_5,
+					 IEEE80211_BAND_5GHZ,
+					 false, false,
+					 cfg->passive[1] + cfg->dfs,
+					 MAX_CHANNELS_5GHZ,
+					 &n_pactive_ch);
+
 	/* 802.11j channels are not supported yet */
 	cfg->passive[2] = 0;
 	cfg->active[2] = 0;
@@ -705,7 +731,8 @@ int wl1271_scan_sched_scan_config(struct wl1271 *wl,
 
 	wl1271_debug(DEBUG_SCAN, "filter_type = %d", cfg->filter_type);
 
-	if (!wl1271_scan_sched_scan_channels(wl, req, cfg)) {
+	if (!wlcore_set_scan_chan_params(wl, cfg, req->channels,
+					 req->n_channels, req->n_ssids)) {
 		wl1271_error("scan channel list is empty");
 		ret = -EINVAL;
 		goto out;
-- 
1.7.6.401.g6a319

