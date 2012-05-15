Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:33781 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755969Ab2EOOHX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 10:07:23 -0400
Received: by ggnc4 with SMTP id c4so2319355ggn.3
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2012 07:07:11 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <coelho@ti.com>, <arik@wizery.com>
Subject: [PATCH] wlcore: set channels 12-14 as pactive for sched scan
Date: Tue, 15 May 2012 17:04:40 +0300
Message-Id: <1337090680-24733-1-git-send-email-victorg@ti.com> (sfid-20120515_160728_376309_4CF29D56)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce “pactive” scan mode – which instructs the fw to
perform a passive scan until an activity/energy is detected
on these channels, once energy detected the channel becomes
active.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---
 drivers/net/wireless/ti/wlcore/scan.c |   39 +++++++++++++++++++++++++++-----
 drivers/net/wireless/ti/wlcore/scan.h |    8 +++++-
 2 files changed, 39 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/scan.c b/drivers/net/wireless/ti/wlcore/scan.c
index ade21a0..97022f4 100644
--- a/drivers/net/wireless/ti/wlcore/scan.c
+++ b/drivers/net/wireless/ti/wlcore/scan.c
@@ -411,7 +411,8 @@ wl1271_scan_get_sched_scan_channels(struct wl1271 *wl,
 				    struct cfg80211_sched_scan_request *req,
 				    struct conn_scan_ch_params *channels,
 				    u32 band, bool radar, bool passive,
-				    int start, int max_channels)
+				    int start, int max_channels,
+				    u8 *n_pactive_ch)
 {
 	struct conf_sched_scan_settings *c = &wl->conf.sched_scan;
 	int i, j;
@@ -479,6 +480,23 @@ wl1271_scan_get_sched_scan_channels(struct wl1271 *wl,
 			channels[j].tx_power_att = req->channels[i]->max_power;
 			channels[j].channel = req->channels[i]->hw_value;
 
+			if ((band == IEEE80211_BAND_2GHZ) &&
+			    (channels[j].channel >= 12) &&
+			    (channels[j].channel <= 14) &&
+			    (flags & IEEE80211_CHAN_PASSIVE_SCAN) &&
+			    !force_passive) {
+				/* pactive channels treated as DFS */
+				channels[j].flags = SCAN_CHANNEL_FLAGS_DFS;
+
+				/*
+				 * n_pactive_ch is counted down from the end of
+				 * the passive channel list
+				 */
+				(*n_pactive_ch)++;
+				wl1271_debug(DEBUG_SCAN, "n_pactive_ch = %d",
+					     *n_pactive_ch);
+			}
+
 			j++;
 		}
 	}
@@ -491,38 +509,47 @@ wl1271_scan_sched_scan_channels(struct wl1271 *wl,
 				struct cfg80211_sched_scan_request *req,
 				struct wl1271_cmd_sched_scan_config *cfg)
 {
+	u8 n_pactive_ch = 0;
+
 	cfg->passive[0] =
 		wl1271_scan_get_sched_scan_channels(wl, req, cfg->channels_2,
 						    IEEE80211_BAND_2GHZ,
 						    false, true, 0,
-						    MAX_CHANNELS_2GHZ);
+						    MAX_CHANNELS_2GHZ,
+						    &n_pactive_ch);
 	cfg->active[0] =
 		wl1271_scan_get_sched_scan_channels(wl, req, cfg->channels_2,
 						    IEEE80211_BAND_2GHZ,
 						    false, false,
 						    cfg->passive[0],
-						    MAX_CHANNELS_2GHZ);
+						    MAX_CHANNELS_2GHZ,
+						    &n_pactive_ch);
 	cfg->passive[1] =
 		wl1271_scan_get_sched_scan_channels(wl, req, cfg->channels_5,
 						    IEEE80211_BAND_5GHZ,
 						    false, true, 0,
-						    MAX_CHANNELS_5GHZ);
+						    MAX_CHANNELS_5GHZ,
+						    &n_pactive_ch);
 	cfg->dfs =
 		wl1271_scan_get_sched_scan_channels(wl, req, cfg->channels_5,
 						    IEEE80211_BAND_5GHZ,
 						    true, true,
 						    cfg->passive[1],
-						    MAX_CHANNELS_5GHZ);
+						    MAX_CHANNELS_5GHZ,
+						    &n_pactive_ch);
 	cfg->active[1] =
 		wl1271_scan_get_sched_scan_channels(wl, req, cfg->channels_5,
 						    IEEE80211_BAND_5GHZ,
 						    false, false,
 						    cfg->passive[1] + cfg->dfs,
-						    MAX_CHANNELS_5GHZ);
+						    MAX_CHANNELS_5GHZ,
+						    &n_pactive_ch);
 	/* 802.11j channels are not supported yet */
 	cfg->passive[2] = 0;
 	cfg->active[2] = 0;
 
+	cfg->n_pactive_ch = n_pactive_ch;
+
 	wl1271_debug(DEBUG_SCAN, "    2.4GHz: active %d passive %d",
 		     cfg->active[0], cfg->passive[0]);
 	wl1271_debug(DEBUG_SCAN, "    5GHz: active %d passive %d",
diff --git a/drivers/net/wireless/ti/wlcore/scan.h b/drivers/net/wireless/ti/wlcore/scan.h
index 81ee36a..ea53223 100644
--- a/drivers/net/wireless/ti/wlcore/scan.h
+++ b/drivers/net/wireless/ti/wlcore/scan.h
@@ -142,7 +142,8 @@ enum {
 	SCAN_BSS_TYPE_ANY,
 };
 
-#define SCAN_CHANNEL_FLAGS_DFS		BIT(0)
+#define SCAN_CHANNEL_FLAGS_DFS		BIT(0) /* channel is passive until an
+						  activity is detected on it */
 #define SCAN_CHANNEL_FLAGS_DFS_ENABLED	BIT(1)
 
 struct conn_scan_ch_params {
@@ -185,7 +186,10 @@ struct wl1271_cmd_sched_scan_config {
 
 	u8 dfs;
 
-	u8 padding[3];
+	u8 n_pactive_ch; /* number of pactive (passive until fw detects energy)
+			    channels in BG band */
+
+	u8 padding[2];
 
 	struct conn_scan_ch_params channels_2[MAX_CHANNELS_2GHZ];
 	struct conn_scan_ch_params channels_5[MAX_CHANNELS_5GHZ];
-- 
1.7.5.4

