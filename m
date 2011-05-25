Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:36004 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755353Ab1EYQQ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 May 2011 12:16:56 -0400
Received: by mail-ew0-f41.google.com with SMTP id 9so2613973ewy.28
        for <linux-wireless@vger.kernel.org>; Wed, 25 May 2011 09:16:55 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: coelho@ti.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2.6.40] wl12xx: fix oops in sched_scan when forcing a passive scan
Date: Wed, 25 May 2011 19:16:45 +0300
Message-Id: <1306340205-30758-1-git-send-email-coelho@ti.com> (sfid-20110525_181700_100890_F8B3E7ED)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix kernel oops when trying to use passive scheduled scans.  The
reason was that in passive scans there are no SSIDs, so there was a
NULL pointer dereference.

To solve the problem, we now check the number of SSIDs provided in the
sched_scan request and only access the list if there's one or more
(ie. passive scan is not forced).  We also move the channels from
active to passive if passive scanning is forced.  For this to work,
it's necessary to set both active and passive dwell times for all
channels.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/scan.c |   31 +++++++++++++++++++------------
 1 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index f37e5a3..d379aac 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -350,15 +350,12 @@ wl1271_scan_get_sched_scan_channels(struct wl1271 *wl,
 			wl1271_debug(DEBUG_SCAN, "max_power %d",
 				     req->channels[i]->max_power);
 
-			if (flags & IEEE80211_CHAN_PASSIVE_SCAN) {
-				channels[j].passive_duration =
-					cpu_to_le16(c->dwell_time_passive);
-			} else {
-				channels[j].min_duration =
-					cpu_to_le16(c->min_dwell_time_active);
-				channels[j].max_duration =
-					cpu_to_le16(c->max_dwell_time_active);
-			}
+			channels[j].passive_duration =
+				cpu_to_le16(c->dwell_time_passive);
+			channels[j].min_duration =
+				cpu_to_le16(c->min_dwell_time_active);
+			channels[j].max_duration =
+				cpu_to_le16(c->max_dwell_time_active);
 			channels[j].tx_power_att = req->channels[j]->max_power;
 			channels[j].channel = req->channels[i]->hw_value;
 
@@ -375,6 +372,7 @@ wl1271_scan_sched_scan_channels(struct wl1271 *wl,
 				struct wl1271_cmd_sched_scan_config *cfg)
 {
 	int idx = 0;
+	bool force_passive = !req->n_ssids;
 
 	cfg->passive[0] =
 		wl1271_scan_get_sched_scan_channels(wl, req, cfg->channels,
@@ -400,6 +398,14 @@ wl1271_scan_sched_scan_channels(struct wl1271 *wl,
 						    false, false, 14);
 	idx += cfg->active[1];
 
+	if (force_passive) {
+		/* move active channels to passive lists */
+		cfg->passive[0] += cfg->active[0] - 1;
+		cfg->active[0] = 1;
+		cfg->passive[1] += cfg->active[1];
+		cfg->active[1] = 0;
+	}
+
 	cfg->dfs =
 		wl1271_scan_get_sched_scan_channels(wl, req, cfg->channels,
 						    IEEE80211_BAND_5GHZ,
@@ -421,6 +427,7 @@ int wl1271_scan_sched_scan_config(struct wl1271 *wl,
 	struct wl1271_cmd_sched_scan_config *cfg = NULL;
 	struct conf_sched_scan_settings *c = &wl->conf.sched_scan;
 	int i, total_channels, ret;
+	bool force_passive = !req->n_ssids;
 
 	wl1271_debug(DEBUG_CMD, "cmd sched_scan scan config");
 
@@ -444,7 +451,7 @@ int wl1271_scan_sched_scan_config(struct wl1271 *wl,
 	for (i = 0; i < SCAN_MAX_CYCLE_INTERVALS; i++)
 		cfg->intervals[i] = cpu_to_le32(req->interval);
 
-	if (req->ssids[0].ssid_len && req->ssids[0].ssid) {
+	if (!force_passive && req->ssids[0].ssid_len && req->ssids[0].ssid) {
 		cfg->filter_type = SCAN_SSID_FILTER_SPECIFIC;
 		cfg->ssid_len = req->ssids[0].ssid_len;
 		memcpy(cfg->ssid, req->ssids[0].ssid,
@@ -461,7 +468,7 @@ int wl1271_scan_sched_scan_config(struct wl1271 *wl,
 		goto out;
 	}
 
-	if (cfg->active[0]) {
+	if (!force_passive && cfg->active[0]) {
 		ret = wl1271_cmd_build_probe_req(wl, req->ssids[0].ssid,
 						 req->ssids[0].ssid_len,
 						 ies->ie[IEEE80211_BAND_2GHZ],
@@ -473,7 +480,7 @@ int wl1271_scan_sched_scan_config(struct wl1271 *wl,
 		}
 	}
 
-	if (cfg->active[1]) {
+	if (!force_passive && cfg->active[1]) {
 		ret = wl1271_cmd_build_probe_req(wl,  req->ssids[0].ssid,
 						 req->ssids[0].ssid_len,
 						 ies->ie[IEEE80211_BAND_5GHZ],
-- 
1.7.1

