Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:50287 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754540Ab1E0MfE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 May 2011 08:35:04 -0400
Received: by mail-ey0-f169.google.com with SMTP id 9so736922eyd.0
        for <linux-wireless@vger.kernel.org>; Fri, 27 May 2011 05:35:03 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, eliad@wizery.com
Subject: [PATCH 2.6.40 4/4] wl12xx: fix oops in sched_scan when forcing a passive scan
Date: Fri, 27 May 2011 15:34:48 +0300
Message-Id: <1306499688-26603-5-git-send-email-coelho@ti.com> (sfid-20110527_143509_772435_79EEC5AB)
In-Reply-To: <1306499688-26603-1-git-send-email-coelho@ti.com>
References: <1306499688-26603-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix kernel oops when trying to use passive scheduled scans.  The
reason was that in passive scans there are no SSIDs, so there was a
NULL pointer dereference.

To solve the problem, we now check the number of SSIDs provided in the
sched_scan request and only access the list if there's one or more
(ie. passive scan is not forced).  We also force all the channels to
be passive by adding the IEEE80211_CHAN_PASSIVE_SCAN flag locally
before the checks in the wl1271_scan_get_sched_scan_channels()
function.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/scan.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index 28ec0ad..56f76ab 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -331,12 +331,16 @@ wl1271_scan_get_sched_scan_channels(struct wl1271 *wl,
 	struct conf_sched_scan_settings *c = &wl->conf.sched_scan;
 	int i, j;
 	u32 flags;
+	bool force_passive = !req->n_ssids;
 
 	for (i = 0, j = start;
 	     i < req->n_channels && j < MAX_CHANNELS_ALL_BANDS;
 	     i++) {
 		flags = req->channels[i]->flags;
 
+		if (force_passive)
+			flags |= IEEE80211_CHAN_PASSIVE_SCAN;
+
 		if ((req->channels[i]->band == band) &&
 		    !(flags & IEEE80211_CHAN_DISABLED) &&
 		    (!!(flags & IEEE80211_CHAN_RADAR) == radar) &&
@@ -433,6 +437,7 @@ int wl1271_scan_sched_scan_config(struct wl1271 *wl,
 	struct wl1271_cmd_sched_scan_config *cfg = NULL;
 	struct conf_sched_scan_settings *c = &wl->conf.sched_scan;
 	int i, total_channels, ret;
+	bool force_passive = !req->n_ssids;
 
 	wl1271_debug(DEBUG_CMD, "cmd sched_scan scan config");
 
@@ -456,7 +461,7 @@ int wl1271_scan_sched_scan_config(struct wl1271 *wl,
 	for (i = 0; i < SCAN_MAX_CYCLE_INTERVALS; i++)
 		cfg->intervals[i] = cpu_to_le32(req->interval);
 
-	if (req->ssids[0].ssid_len && req->ssids[0].ssid) {
+	if (!force_passive && req->ssids[0].ssid_len && req->ssids[0].ssid) {
 		cfg->filter_type = SCAN_SSID_FILTER_SPECIFIC;
 		cfg->ssid_len = req->ssids[0].ssid_len;
 		memcpy(cfg->ssid, req->ssids[0].ssid,
@@ -473,7 +478,7 @@ int wl1271_scan_sched_scan_config(struct wl1271 *wl,
 		goto out;
 	}
 
-	if (cfg->active[0]) {
+	if (!force_passive && cfg->active[0]) {
 		ret = wl1271_cmd_build_probe_req(wl, req->ssids[0].ssid,
 						 req->ssids[0].ssid_len,
 						 ies->ie[IEEE80211_BAND_2GHZ],
@@ -485,7 +490,7 @@ int wl1271_scan_sched_scan_config(struct wl1271 *wl,
 		}
 	}
 
-	if (cfg->active[1]) {
+	if (!force_passive && cfg->active[1]) {
 		ret = wl1271_cmd_build_probe_req(wl,  req->ssids[0].ssid,
 						 req->ssids[0].ssid_len,
 						 ies->ie[IEEE80211_BAND_5GHZ],
-- 
1.7.1

