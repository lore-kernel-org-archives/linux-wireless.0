Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:37607 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753989Ab1E0MfD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 May 2011 08:35:03 -0400
Received: by mail-ey0-f172.google.com with SMTP id 13so961136eye.17
        for <linux-wireless@vger.kernel.org>; Fri, 27 May 2011 05:35:02 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, eliad@wizery.com
Subject: [PATCH 2.6.40 3/4] wl12xx: add separate config value for DFS dwell time on sched scan
Date: Fri, 27 May 2011 15:34:47 +0300
Message-Id: <1306499688-26603-4-git-send-email-coelho@ti.com> (sfid-20110527_143509_234668_4470984F)
In-Reply-To: <1306499688-26603-1-git-send-email-coelho@ti.com>
References: <1306499688-26603-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use a different value for DFS dwell time when performing a scheduled
scan.  Previously we were using the same value as for normal passive
scans.  This adds some flexibility between these two different types
of passive scan.

For now we use 150 TUs for DFS channel dwell time.  This may need to
be fine-tuned in the future.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/conf.h |    3 +++
 drivers/net/wireless/wl12xx/main.c |    1 +
 drivers/net/wireless/wl12xx/scan.c |    7 +++++--
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index 510c2f7..aa79b43 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -1157,6 +1157,9 @@ struct conf_sched_scan_settings {
 	/* time to wait on the channel for passive scans (in TUs) */
 	u32 dwell_time_passive;
 
+	/* time to wait on the channel for DFS scans (in TUs) */
+	u32 dwell_time_dfs;
+
 	/* number of probe requests to send on each channel in active scans */
 	u8 num_probe_reqs;
 
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index fb0f764..a4cbf7b 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -311,6 +311,7 @@ static struct conf_drv_settings default_conf = {
 		.min_dwell_time_active = 8,
 		.max_dwell_time_active = 30,
 		.dwell_time_passive    = 100,
+		.dwell_time_dfs        = 150,
 		.num_probe_reqs        = 2,
 		.rssi_threshold        = -90,
 		.snr_threshold         = 0,
diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index 8ccbb91..28ec0ad 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -352,9 +352,12 @@ wl1271_scan_get_sched_scan_channels(struct wl1271 *wl,
 			wl1271_debug(DEBUG_SCAN, "max_power %d",
 				     req->channels[i]->max_power);
 
-			if (flags & IEEE80211_CHAN_RADAR)
+			if (flags & IEEE80211_CHAN_RADAR) {
 				channels[j].flags |= SCAN_CHANNEL_FLAGS_DFS;
-			if (flags & IEEE80211_CHAN_PASSIVE_SCAN) {
+				channels[j].passive_duration =
+					cpu_to_le16(c->dwell_time_dfs);
+			}
+			else if (flags & IEEE80211_CHAN_PASSIVE_SCAN) {
 				channels[j].passive_duration =
 					cpu_to_le16(c->dwell_time_passive);
 			} else {
-- 
1.7.1

