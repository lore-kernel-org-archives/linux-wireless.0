Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59651 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab2CSKHj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 06:07:39 -0400
Received: by wibhq7 with SMTP id hq7so3594159wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 19 Mar 2012 03:07:37 -0700 (PDT)
From: Eyal Shapira <eyal@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/4] wl12xx: adaptive sched scan dwell times
Date: Mon, 19 Mar 2012 12:06:28 +0200
Message-Id: <1332151589-27272-4-git-send-email-eyal@wizery.com> (sfid-20120319_110742_378979_DE263CB7)
In-Reply-To: <1332151589-27272-1-git-send-email-eyal@wizery.com>
References: <1332151589-27272-1-git-send-email-eyal@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set the dwell times for sched scan according to the number
of probe requests which are going to be transmitted.
This should fix the too short dwell time problem which
prevented some of the probe requests from being transmitted
in cases of high number of SSIDs (10+) to be actively sched scanned.
However, in the common case of having up to 1-2 SSIDs that
require active scan, the dwell time would be kept to a minimum
which should conserve power. This is important as sched scan
also runs periodically while the host is suspended and there's
great importance to keep power consumption as low as possible.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
---
 drivers/net/wireless/wl12xx/conf.h |   28 ++++++++++++++++++++++------
 drivers/net/wireless/wl12xx/main.c |   23 +++++++++++++++--------
 drivers/net/wireless/wl12xx/scan.c |   29 +++++++++++++++++++++++++----
 3 files changed, 62 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index 3e581e1..7028f10 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -1096,16 +1096,32 @@ struct conf_scan_settings {
 };
 
 struct conf_sched_scan_settings {
-	/* minimum time to wait on the channel for active scans (in TUs) */
-	u16 min_dwell_time_active;
+	/*
+	 * The base time to wait on the channel for active scans (in TU/1000).
+	 * The minimum dwell time is calculated according to this:
+	 * min_dwell_time = base + num_of_probes_to_be_sent * delta_per_probe
+	 * The maximum dwell time is calculated according to this:
+	 * max_dwell_time = min_dwell_time + max_dwell_time_delta
+	 */
+	u32 base_dwell_time;
+
+	/*
+	 * The delta between the min dwell time and max dwell time for
+	 * active scans (in TU/1000s). The max dwell time is used by the FW once
+	 * traffic is detected on the channel.
+	 */
+	u32 max_dwell_time_delta;
+
+	/* Delta added to min dwell time per each probe in 2.4 GHz (TU/1000) */
+	u32 dwell_time_delta_per_probe;
 
-	/* maximum time to wait on the channel for active scans (in TUs) */
-	u16 max_dwell_time_active;
+	/* Delta added to min dwell time per each probe in 5 GHz (TU/1000) */
+	u32 dwell_time_delta_per_probe_5;
 
-	/* time to wait on the channel for passive scans (in TUs) */
+	/* time to wait on the channel for passive scans (in TU/1000) */
 	u32 dwell_time_passive;
 
-	/* time to wait on the channel for DFS scans (in TUs) */
+	/* time to wait on the channel for DFS scans (in TU/1000) */
 	u32 dwell_time_dfs;
 
 	/* number of probe requests to send on each channel in active scans */
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 55a0191..6db7796 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -276,14 +276,21 @@ static struct conf_drv_settings default_conf = {
 		.split_scan_timeout           = 50000,
 	},
 	.sched_scan = {
-		/* sched_scan requires dwell times in TU instead of TU/1000 */
-		.min_dwell_time_active = 30,
-		.max_dwell_time_active = 60,
-		.dwell_time_passive    = 100,
-		.dwell_time_dfs        = 150,
-		.num_probe_reqs        = 2,
-		.rssi_threshold        = -90,
-		.snr_threshold         = 0,
+		/*
+		 * Values are in TU/1000 but since sched scan FW command
+		 * params are in TUs rounding up may occur.
+		 */
+		.base_dwell_time              = 7500,
+		.max_dwell_time_delta         = 22500,
+		/* based on 250bits per probe @1Mbps */
+		.dwell_time_delta_per_probe   = 2000,
+		/* based on 250bits per probe @6Mbps (plus a bit more) */
+		.dwell_time_delta_per_probe_5 = 350,
+		.dwell_time_passive           = 100000,
+		.dwell_time_dfs               = 150000,
+		.num_probe_reqs               = 2,
+		.rssi_threshold               = -90,
+		.snr_threshold                = 0,
 	},
 	.rf = {
 		.tx_per_channel_power_compensation_2 = {
diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index fcba055..801ea53 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -417,6 +417,23 @@ wl1271_scan_get_sched_scan_channels(struct wl1271 *wl,
 	int i, j;
 	u32 flags;
 	bool force_passive = !req->n_ssids;
+	u32 min_dwell_time_active, max_dwell_time_active, delta_per_probe;
+	u32 dwell_time_passive, dwell_time_dfs;
+
+	if (band == IEEE80211_BAND_5GHZ)
+		delta_per_probe = c->dwell_time_delta_per_probe_5;
+	else
+		delta_per_probe = c->dwell_time_delta_per_probe;
+
+	min_dwell_time_active = c->base_dwell_time +
+		 req->n_ssids * c->num_probe_reqs * delta_per_probe;
+
+	max_dwell_time_active = min_dwell_time_active + c->max_dwell_time_delta;
+
+	min_dwell_time_active = DIV_ROUND_UP(min_dwell_time_active, 1000);
+	max_dwell_time_active = DIV_ROUND_UP(max_dwell_time_active, 1000);
+	dwell_time_passive = DIV_ROUND_UP(c->dwell_time_passive, 1000);
+	dwell_time_dfs = DIV_ROUND_UP(c->dwell_time_dfs, 1000);
 
 	for (i = 0, j = start;
 	     i < req->n_channels && j < max_channels;
@@ -440,21 +457,25 @@ wl1271_scan_get_sched_scan_channels(struct wl1271 *wl,
 				     req->channels[i]->flags);
 			wl1271_debug(DEBUG_SCAN, "max_power %d",
 				     req->channels[i]->max_power);
+			wl1271_debug(DEBUG_SCAN, "min_dwell_time %d"
+				     "max dwell time %d",
+				     min_dwell_time_active,
+				     max_dwell_time_active);
 
 			if (flags & IEEE80211_CHAN_RADAR) {
 				channels[j].flags |= SCAN_CHANNEL_FLAGS_DFS;
 
 				channels[j].passive_duration =
-					cpu_to_le16(c->dwell_time_dfs);
+					cpu_to_le16(dwell_time_dfs);
 			} else {
 				channels[j].passive_duration =
-					cpu_to_le16(c->dwell_time_passive);
+					cpu_to_le16(dwell_time_passive);
 			}
 
 			channels[j].min_duration =
-				cpu_to_le16(c->min_dwell_time_active);
+				cpu_to_le16(min_dwell_time_active);
 			channels[j].max_duration =
-				cpu_to_le16(c->max_dwell_time_active);
+				cpu_to_le16(max_dwell_time_active);
 
 			channels[j].tx_power_att = req->channels[i]->max_power;
 			channels[j].channel = req->channels[i]->hw_value;
-- 
1.7.4.1

