Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:35833 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753688Ab1E0MfC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 May 2011 08:35:02 -0400
Received: by mail-ew0-f48.google.com with SMTP id 22so927419ewy.35
        for <linux-wireless@vger.kernel.org>; Fri, 27 May 2011 05:35:00 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, eliad@wizery.com
Subject: [PATCH 2.6.40 2/4] wl12xx: fix DFS channels handling in scheduled scan
Date: Fri, 27 May 2011 15:34:46 +0300
Message-Id: <1306499688-26603-3-git-send-email-coelho@ti.com> (sfid-20110527_143510_315035_B96682A1)
In-Reply-To: <1306499688-26603-1-git-send-email-coelho@ti.com>
References: <1306499688-26603-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

DFS channels were never getting included in the scheduled scans,
because they always contain the passive flag as well and the call was
asking for DFS and active channels.

Fix this by ignoring the passive flag when collecting DFS channels.
Also, move the DFS channels in the channel list before the 5GHz active
channels (this was implemented in the FW differently than specified).

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/scan.c |   31 ++++++++++++++++++++-----------
 drivers/net/wireless/wl12xx/scan.h |    3 +++
 2 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index f223e0e..8ccbb91 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -337,10 +337,12 @@ wl1271_scan_get_sched_scan_channels(struct wl1271 *wl,
 	     i++) {
 		flags = req->channels[i]->flags;
 
-		if (!(flags & IEEE80211_CHAN_DISABLED) &&
-		    (!!(flags & IEEE80211_CHAN_PASSIVE_SCAN) == passive) &&
+		if ((req->channels[i]->band == band) &&
+		    !(flags & IEEE80211_CHAN_DISABLED) &&
 		    (!!(flags & IEEE80211_CHAN_RADAR) == radar) &&
-		    (req->channels[i]->band == band)) {
+		    /* if radar is set, we ignore the passive flag */
+		    (radar ||
+		     !!(flags & IEEE80211_CHAN_PASSIVE_SCAN) == passive)) {
 			wl1271_debug(DEBUG_SCAN, "band %d, center_freq %d ",
 				     req->channels[i]->band,
 				     req->channels[i]->center_freq);
@@ -350,6 +352,8 @@ wl1271_scan_get_sched_scan_channels(struct wl1271 *wl,
 			wl1271_debug(DEBUG_SCAN, "max_power %d",
 				     req->channels[i]->max_power);
 
+			if (flags & IEEE80211_CHAN_RADAR)
+				channels[j].flags |= SCAN_CHANNEL_FLAGS_DFS;
 			if (flags & IEEE80211_CHAN_PASSIVE_SCAN) {
 				channels[j].passive_duration =
 					cpu_to_le16(c->dwell_time_passive);
@@ -359,7 +363,7 @@ wl1271_scan_get_sched_scan_channels(struct wl1271 *wl,
 				channels[j].max_duration =
 					cpu_to_le16(c->max_dwell_time_active);
 			}
-			channels[j].tx_power_att = req->channels[j]->max_power;
+			channels[j].tx_power_att = req->channels[i]->max_power;
 			channels[j].channel = req->channels[i]->hw_value;
 
 			j++;
@@ -386,7 +390,11 @@ wl1271_scan_sched_scan_channels(struct wl1271 *wl,
 		wl1271_scan_get_sched_scan_channels(wl, req, cfg->channels,
 						    IEEE80211_BAND_2GHZ,
 						    false, false, idx);
-	idx += cfg->active[0];
+	/*
+	 * 5GHz channels always start at position 14, not immediately
+	 * after the last 2.4GHz channel
+	 */
+	idx = 14;
 
 	cfg->passive[1] =
 		wl1271_scan_get_sched_scan_channels(wl, req, cfg->channels,
@@ -394,22 +402,23 @@ wl1271_scan_sched_scan_channels(struct wl1271 *wl,
 						    false, true, idx);
 	idx += cfg->passive[1];
 
-	cfg->active[1] =
+	cfg->dfs =
 		wl1271_scan_get_sched_scan_channels(wl, req, cfg->channels,
 						    IEEE80211_BAND_5GHZ,
-						    false, false, 14);
-	idx += cfg->active[1];
+						    true, true, idx);
+	idx += cfg->dfs;
 
-	cfg->dfs =
+	cfg->active[1] =
 		wl1271_scan_get_sched_scan_channels(wl, req, cfg->channels,
 						    IEEE80211_BAND_5GHZ,
-						    true, false, idx);
-	idx += cfg->dfs;
+						    false, false, idx);
+	idx += cfg->active[1];
 
 	wl1271_debug(DEBUG_SCAN, "    2.4GHz: active %d passive %d",
 		     cfg->active[0], cfg->passive[0]);
 	wl1271_debug(DEBUG_SCAN, "    5GHz: active %d passive %d",
 		     cfg->active[1], cfg->passive[1]);
+	wl1271_debug(DEBUG_SCAN, "    DFS: %d", cfg->dfs);
 
 	return idx;
 }
diff --git a/drivers/net/wireless/wl12xx/scan.h b/drivers/net/wireless/wl12xx/scan.h
index c833195..a0b6c5d 100644
--- a/drivers/net/wireless/wl12xx/scan.h
+++ b/drivers/net/wireless/wl12xx/scan.h
@@ -137,6 +137,9 @@ enum {
 	SCAN_BSS_TYPE_ANY,
 };
 
+#define SCAN_CHANNEL_FLAGS_DFS		BIT(0)
+#define SCAN_CHANNEL_FLAGS_DFS_ENABLED	BIT(1)
+
 struct conn_scan_ch_params {
 	__le16 min_duration;
 	__le16 max_duration;
-- 
1.7.1

