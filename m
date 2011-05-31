Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:45364 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750966Ab1EaNep (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 09:34:45 -0400
Received: by mail-ey0-f170.google.com with SMTP id 5so1592648eyf.29
        for <linux-wireless@vger.kernel.org>; Tue, 31 May 2011 06:34:43 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: coelho@ti.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] wl12xx: split channel array per band in sched_scan
Date: Tue, 31 May 2011 16:34:36 +0300
Message-Id: <1306848876-21296-1-git-send-email-coelho@ti.com> (sfid-20110531_153449_443261_C90F2B1C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware, in practice, treats the channels in three separate
blocks, one for each band (bg, a and j).  Instead of using a single
array and doing some magic with indices, split the array in 3 to make
it more readable.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/scan.c |   61 +++++++++++++++++-------------------
 drivers/net/wireless/wl12xx/scan.h |   17 ++++------
 net/mac80211/rx.c                  |    7 +++-
 3 files changed, 41 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index 56f76ab..48b4c04 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -326,7 +326,7 @@ wl1271_scan_get_sched_scan_channels(struct wl1271 *wl,
 				    struct cfg80211_sched_scan_request *req,
 				    struct conn_scan_ch_params *channels,
 				    u32 band, bool radar, bool passive,
-				    int start)
+				    int start, int max_channels)
 {
 	struct conf_sched_scan_settings *c = &wl->conf.sched_scan;
 	int i, j;
@@ -334,7 +334,7 @@ wl1271_scan_get_sched_scan_channels(struct wl1271 *wl,
 	bool force_passive = !req->n_ssids;
 
 	for (i = 0, j = start;
-	     i < req->n_channels && j < MAX_CHANNELS_ALL_BANDS;
+	     i < req->n_channels && j < max_channels;
 	     i++) {
 		flags = req->channels[i]->flags;
 
@@ -380,46 +380,42 @@ wl1271_scan_get_sched_scan_channels(struct wl1271 *wl,
 	return j - start;
 }
 
-static int
+static bool
 wl1271_scan_sched_scan_channels(struct wl1271 *wl,
 				struct cfg80211_sched_scan_request *req,
 				struct wl1271_cmd_sched_scan_config *cfg)
 {
-	int idx = 0;
-
 	cfg->passive[0] =
-		wl1271_scan_get_sched_scan_channels(wl, req, cfg->channels,
+		wl1271_scan_get_sched_scan_channels(wl, req, cfg->channels_2,
 						    IEEE80211_BAND_2GHZ,
-						    false, true, idx);
-	idx += cfg->passive[0];
-
+						    false, true, 0,
+						    MAX_CHANNELS_2GHZ);
 	cfg->active[0] =
-		wl1271_scan_get_sched_scan_channels(wl, req, cfg->channels,
+		wl1271_scan_get_sched_scan_channels(wl, req, cfg->channels_2,
 						    IEEE80211_BAND_2GHZ,
-						    false, false, idx);
-	/*
-	 * 5GHz channels always start at position 14, not immediately
-	 * after the last 2.4GHz channel
-	 */
-	idx = 14;
-
+						    false, false,
+						    cfg->passive[0],
+						    MAX_CHANNELS_2GHZ);
 	cfg->passive[1] =
-		wl1271_scan_get_sched_scan_channels(wl, req, cfg->channels,
+		wl1271_scan_get_sched_scan_channels(wl, req, cfg->channels_5,
 						    IEEE80211_BAND_5GHZ,
-						    false, true, idx);
-	idx += cfg->passive[1];
-
+						    false, true, 0,
+						    MAX_CHANNELS_5GHZ);
 	cfg->dfs =
-		wl1271_scan_get_sched_scan_channels(wl, req, cfg->channels,
+		wl1271_scan_get_sched_scan_channels(wl, req, cfg->channels_5,
 						    IEEE80211_BAND_5GHZ,
-						    true, true, idx);
-	idx += cfg->dfs;
-
+						    true, true,
+						    cfg->passive[1],
+						    MAX_CHANNELS_5GHZ);
 	cfg->active[1] =
-		wl1271_scan_get_sched_scan_channels(wl, req, cfg->channels,
+		wl1271_scan_get_sched_scan_channels(wl, req, cfg->channels_5,
 						    IEEE80211_BAND_5GHZ,
-						    false, false, idx);
-	idx += cfg->active[1];
+						    false, false,
+						    cfg->passive[1] + cfg->dfs,
+						    MAX_CHANNELS_5GHZ);
+	/* 802.11j channels are not supported yet */
+	cfg->passive[2] = 0;
+	cfg->active[2] = 0;
 
 	wl1271_debug(DEBUG_SCAN, "    2.4GHz: active %d passive %d",
 		     cfg->active[0], cfg->passive[0]);
@@ -427,7 +423,9 @@ wl1271_scan_sched_scan_channels(struct wl1271 *wl,
 		     cfg->active[1], cfg->passive[1]);
 	wl1271_debug(DEBUG_SCAN, "    DFS: %d", cfg->dfs);
 
-	return idx;
+	return  (cfg->passive[0] || cfg->active[0] ||
+		 cfg->passive[1] || cfg->active[1] || cfg->dfs ||
+		 cfg->passive[2] || cfg->active[2]);
 }
 
 int wl1271_scan_sched_scan_config(struct wl1271 *wl,
@@ -436,7 +434,7 @@ int wl1271_scan_sched_scan_config(struct wl1271 *wl,
 {
 	struct wl1271_cmd_sched_scan_config *cfg = NULL;
 	struct conf_sched_scan_settings *c = &wl->conf.sched_scan;
-	int i, total_channels, ret;
+	int i, ret;
 	bool force_passive = !req->n_ssids;
 
 	wl1271_debug(DEBUG_CMD, "cmd sched_scan scan config");
@@ -471,8 +469,7 @@ int wl1271_scan_sched_scan_config(struct wl1271 *wl,
 		cfg->ssid_len = 0;
 	}
 
-	total_channels = wl1271_scan_sched_scan_channels(wl, req, cfg);
-	if (total_channels == 0) {
+	if (!wl1271_scan_sched_scan_channels(wl, req, cfg)) {
 		wl1271_error("scan channel list is empty");
 		ret = -EINVAL;
 		goto out;
diff --git a/drivers/net/wireless/wl12xx/scan.h b/drivers/net/wireless/wl12xx/scan.h
index a0b6c5d..ca81de2 100644
--- a/drivers/net/wireless/wl12xx/scan.h
+++ b/drivers/net/wireless/wl12xx/scan.h
@@ -112,19 +112,14 @@ struct wl1271_cmd_trigger_scan_to {
 	__le32 timeout;
 } __packed;
 
-#define MAX_CHANNELS_ALL_BANDS 41
+#define MAX_CHANNELS_2GHZ	14
+#define MAX_CHANNELS_5GHZ	23
+#define MAX_CHANNELS_4GHZ	4
+
 #define SCAN_MAX_CYCLE_INTERVALS 16
 #define SCAN_MAX_BANDS 3
 
 enum {
-	SCAN_CHANNEL_TYPE_2GHZ_PASSIVE,
-	SCAN_CHANNEL_TYPE_2GHZ_ACTIVE,
-	SCAN_CHANNEL_TYPE_5GHZ_PASSIVE,
-	SCAN_CHANNEL_TYPE_5GHZ_ACTIVE,
-	SCAN_CHANNEL_TYPE_5GHZ_DFS,
-};
-
-enum {
 	SCAN_SSID_FILTER_ANY      = 0,
 	SCAN_SSID_FILTER_SPECIFIC = 1,
 	SCAN_SSID_FILTER_LIST     = 2,
@@ -182,7 +177,9 @@ struct wl1271_cmd_sched_scan_config {
 
 	u8 padding[3];
 
-	struct conn_scan_ch_params channels[MAX_CHANNELS_ALL_BANDS];
+	struct conn_scan_ch_params channels_2[MAX_CHANNELS_2GHZ];
+	struct conn_scan_ch_params channels_5[MAX_CHANNELS_5GHZ];
+	struct conn_scan_ch_params channels_4[MAX_CHANNELS_4GHZ];
 } __packed;
 
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 7fa8c6b..a71e05c 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1968,8 +1968,11 @@ ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 		    ((struct ethhdr *)rx->skb->data)->h_dest) &&
 	    (!local->scanning &&
 	     !test_bit(SDATA_STATE_OFFCHANNEL, &sdata->state))) {
-			mod_timer(&local->dynamic_ps_timer, jiffies +
-			 msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
+		ieee80211_queue_work(&local->hw,
+				     &local->dynamic_ps_disable_work);
+
+		mod_timer(&local->dynamic_ps_timer, jiffies +
+			  msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
 	}
 
 	ieee80211_deliver_skb(rx);
-- 
1.7.1

