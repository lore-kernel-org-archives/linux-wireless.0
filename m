Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:49705 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512Ab3ICOe3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 10:34:29 -0400
Received: by mail-we0-f175.google.com with SMTP id m46so4875371wev.6
        for <linux-wireless@vger.kernel.org>; Tue, 03 Sep 2013 07:34:28 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <luca@coelho.fi>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 07/12] wlcore: cleanup scan debug prints
Date: Tue,  3 Sep 2013 17:34:03 +0300
Message-Id: <1378218848-7853-7-git-send-email-eliad@wizery.com> (sfid-20130903_163444_349767_4DBFE04E)
In-Reply-To: <1378218848-7853-1-git-send-email-eliad@wizery.com>
References: <1378218848-7853-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Victor Goldenshtein <victorg@ti.com>

Remove scan debug dumps which are rarely used.
Make scan debug prints more clear and short.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/cmd.c  |  6 +++---
 drivers/net/wireless/ti/wlcore/scan.c | 28 ++++++++++++++--------------
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index c9e0607..e3ae425 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -1126,6 +1126,8 @@ int wl12xx_cmd_build_probe_req(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	u16 template_id_2_4 = wl->scan_templ_id_2_4;
 	u16 template_id_5 = wl->scan_templ_id_5;
 
+	wl1271_debug(DEBUG_SCAN, "build probe request band %d", band);
+
 	skb = ieee80211_probereq_get(wl->hw, vif, ssid, ssid_len,
 				     ie_len);
 	if (!skb) {
@@ -1135,8 +1137,6 @@ int wl12xx_cmd_build_probe_req(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	if (ie_len)
 		memcpy(skb_put(skb, ie_len), ie, ie_len);
 
-	wl1271_dump(DEBUG_SCAN, "PROBE REQ: ", skb->data, skb->len);
-
 	if (sched_scan &&
 	    (wl->quirks & WLCORE_QUIRK_DUAL_PROBE_TMPL)) {
 		template_id_2_4 = wl->sched_scan_templ_id_2_4;
@@ -1172,7 +1172,7 @@ struct sk_buff *wl1271_cmd_build_ap_probe_req(struct wl1271 *wl,
 	if (!skb)
 		goto out;
 
-	wl1271_dump(DEBUG_SCAN, "AP PROBE REQ: ", skb->data, skb->len);
+	wl1271_debug(DEBUG_SCAN, "set ap probe request template");
 
 	rate = wl1271_tx_min_rate_get(wl, wlvif->bitrate_masks[wlvif->band]);
 	if (wlvif->band == IEEE80211_BAND_2GHZ)
diff --git a/drivers/net/wireless/ti/wlcore/scan.c b/drivers/net/wireless/ti/wlcore/scan.c
index f407101..bbe0bc4 100644
--- a/drivers/net/wireless/ti/wlcore/scan.c
+++ b/drivers/net/wireless/ti/wlcore/scan.c
@@ -174,17 +174,7 @@ wlcore_scan_get_channels(struct wl1271 *wl,
 		    /* if radar is set, we ignore the passive flag */
 		    (radar ||
 		     !!(flags & IEEE80211_CHAN_PASSIVE_SCAN) == passive)) {
-			wl1271_debug(DEBUG_SCAN, "band %d, center_freq %d ",
-				     req_channels[i]->band,
-				     req_channels[i]->center_freq);
-			wl1271_debug(DEBUG_SCAN, "hw_value %d, flags %X",
-				     req_channels[i]->hw_value,
-				     req_channels[i]->flags);
-			wl1271_debug(DEBUG_SCAN, "max_power %d",
-				     req_channels[i]->max_power);
-			wl1271_debug(DEBUG_SCAN, "min_dwell_time %d max dwell time %d",
-				     min_dwell_time_active,
-				     max_dwell_time_active);
+
 
 			if (flags & IEEE80211_CHAN_RADAR) {
 				channels[j].flags |= SCAN_CHANNEL_FLAGS_DFS;
@@ -222,6 +212,18 @@ wlcore_scan_get_channels(struct wl1271 *wl,
 					     *n_pactive_ch);
 			}
 
+			wl1271_debug(DEBUG_SCAN, "freq %04d, ch. %03d, flags 0x%02X, power %02d, min/max_dwell %02d/%02d%s%s",
+				     req_channels[i]->center_freq,
+				     req_channels[i]->hw_value,
+				     req_channels[i]->flags,
+				     req_channels[i]->max_power,
+				     min_dwell_time_active,
+				     max_dwell_time_active,
+				     flags & IEEE80211_CHAN_RADAR ?
+					", DFS" : "",
+				     flags & IEEE80211_CHAN_PASSIVE_SCAN ?
+					", PASSIVE" : "");
+
 			j++;
 		}
 	}
@@ -364,7 +366,7 @@ wlcore_scan_sched_scan_ssid_list(struct wl1271 *wl,
 	struct cfg80211_ssid *ssids = req->ssids;
 	int ret = 0, type, i, j, n_match_ssids = 0;
 
-	wl1271_debug(DEBUG_CMD, "cmd sched scan ssid list");
+	wl1271_debug((DEBUG_CMD | DEBUG_SCAN), "cmd sched scan ssid list");
 
 	/* count the match sets that contain SSIDs */
 	for (i = 0; i < req->n_match_sets; i++)
@@ -442,8 +444,6 @@ wlcore_scan_sched_scan_ssid_list(struct wl1271 *wl,
 		}
 	}
 
-	wl1271_dump(DEBUG_SCAN, "SSID_LIST: ", cmd, sizeof(*cmd));
-
 	ret = wl1271_cmd_send(wl, CMD_CONNECTION_SCAN_SSID_CFG, cmd,
 			      sizeof(*cmd), 0);
 	if (ret < 0) {
-- 
1.8.3.rc1.35.g9b79519

