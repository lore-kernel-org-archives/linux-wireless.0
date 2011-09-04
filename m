Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:50059 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751658Ab1IDN3H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Sep 2011 09:29:07 -0400
Received: by wyg19 with SMTP id 19so3779660wyg.37
        for <linux-wireless@vger.kernel.org>; Sun, 04 Sep 2011 06:29:03 -0700 (PDT)
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Shahar Levi <shahar_levi@ti.com>
Subject: [PATCH] wl12xx: Set the correct min&max dwell time setting on passive scan
Date: Sun,  4 Sep 2011 16:28:58 +0300
Message-Id: <1315142938-26665-1-git-send-email-shahar_levi@ti.com> (sfid-20110904_152917_873036_9EE6C205)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case of forced passive scan (n_ssids = 0), active permission
channels have been set with active min&max dwell time and
selected for passive scan.

That patch includes the following fixes:
1) Skip scan in case of active scan request and forced passive
   scan (n_ssids = 0) indication
2) all channels that not selected before in active scan should
   be selected in passive scan (including active channels)
3) Improve scan SM by calling only passive states in case of
   forced passive scan (n_ssids = 0)

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---
 drivers/net/wireless/wl12xx/scan.c |   61 ++++++++++++++++++++++++++---------
 drivers/net/wireless/wl12xx/scan.h |    2 +-
 2 files changed, 46 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index af4ad23..cb12409 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -94,17 +94,26 @@ static int wl1271_get_scan_channels(struct wl1271 *wl,
 	struct conf_scan_settings *c = &wl->conf.scan;
 	int i, j;
 	u32 flags;
+	bool passive_channel;
 
 	for (i = 0, j = 0;
 	     i < req->n_channels && j < WL1271_SCAN_MAX_CHANNELS;
 	     i++) {
 
 		flags = req->channels[i]->flags;
+		passive_channel = !!(flags & IEEE80211_CHAN_PASSIVE_SCAN);
 
 		if (!test_bit(i, wl->scan.scanned_ch) &&
 		    !(flags & IEEE80211_CHAN_DISABLED) &&
-		    ((!!(flags & IEEE80211_CHAN_PASSIVE_SCAN)) == passive) &&
-		    (req->channels[i]->band == band)) {
+		    (req->channels[i]->band == band) &&
+		    /*
+		     * In case of passive scan, all channels that not selected
+		     * before in active scan should be selected(including active
+		     * channels)
+		     * In case of active scan validate the channel scan
+		     * permission
+		     */
+		    (passive || (passive_channel == false))) {
 
 			wl1271_debug(DEBUG_SCAN, "band %d, center_freq %d ",
 				     req->channels[i]->band,
@@ -157,6 +166,9 @@ static int wl1271_scan_send(struct wl1271 *wl, enum ieee80211_band band,
 	int ret;
 	u16 scan_options = 0;
 
+	wl1271_debug(DEBUG_SCAN, "scan send: band %d, passive %d",
+		     band, passive);
+
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	trigger = kzalloc(sizeof(*trigger), GFP_KERNEL);
 	if (!cmd || !trigger) {
@@ -167,9 +179,16 @@ static int wl1271_scan_send(struct wl1271 *wl, enum ieee80211_band band,
 	/* We always use high priority scans */
 	scan_options = WL1271_SCAN_OPT_PRIORITY_HIGH;
 
-	/* No SSIDs means that we have a forced passive scan */
-	if (passive || wl->scan.req->n_ssids == 0)
+	if (passive) {
 		scan_options |= WL1271_SCAN_OPT_PASSIVE;
+	} else if (wl->scan.req->n_ssids == 0) {
+			/*
+			 * no SSIDs means that we have a forced passive scan.
+			 * in case active scan req skip scan
+			 */
+			ret = WL1271_NOTHING_TO_SCAN;
+			goto out;
+	}
 
 	if (WARN_ON(wl->role_id == WL12XX_INVALID_ROLE_ID)) {
 		ret = -EINVAL;
@@ -247,6 +266,19 @@ void wl1271_scan_stm(struct wl1271 *wl)
 		ret = wl1271_scan_send(wl, IEEE80211_BAND_2GHZ, false,
 				       wl->conf.tx.basic_rate);
 		if (ret == WL1271_NOTHING_TO_SCAN) {
+			if (wl->enable_11a)
+				wl->scan.state = WL1271_SCAN_STATE_5GHZ_ACTIVE;
+			else
+				wl->scan.state = WL1271_SCAN_STATE_2GHZ_PASSIVE;
+			wl1271_scan_stm(wl);
+		}
+
+		break;
+
+	case WL1271_SCAN_STATE_5GHZ_ACTIVE:
+		ret = wl1271_scan_send(wl, IEEE80211_BAND_5GHZ, false,
+				       wl->conf.tx.basic_rate_5);
+		if (ret == WL1271_NOTHING_TO_SCAN) {
 			wl->scan.state = WL1271_SCAN_STATE_2GHZ_PASSIVE;
 			wl1271_scan_stm(wl);
 		}
@@ -258,7 +290,7 @@ void wl1271_scan_stm(struct wl1271 *wl)
 				       wl->conf.tx.basic_rate);
 		if (ret == WL1271_NOTHING_TO_SCAN) {
 			if (wl->enable_11a)
-				wl->scan.state = WL1271_SCAN_STATE_5GHZ_ACTIVE;
+				wl->scan.state = WL1271_SCAN_STATE_5GHZ_PASSIVE;
 			else
 				wl->scan.state = WL1271_SCAN_STATE_DONE;
 			wl1271_scan_stm(wl);
@@ -266,16 +298,6 @@ void wl1271_scan_stm(struct wl1271 *wl)
 
 		break;
 
-	case WL1271_SCAN_STATE_5GHZ_ACTIVE:
-		ret = wl1271_scan_send(wl, IEEE80211_BAND_5GHZ, false,
-				       wl->conf.tx.basic_rate_5);
-		if (ret == WL1271_NOTHING_TO_SCAN) {
-			wl->scan.state = WL1271_SCAN_STATE_5GHZ_PASSIVE;
-			wl1271_scan_stm(wl);
-		}
-
-		break;
-
 	case WL1271_SCAN_STATE_5GHZ_PASSIVE:
 		ret = wl1271_scan_send(wl, IEEE80211_BAND_5GHZ, true,
 				       wl->conf.tx.basic_rate_5);
@@ -317,7 +339,14 @@ int wl1271_scan(struct wl1271 *wl, const u8 *ssid, size_t ssid_len,
 	if (wl->scan.state != WL1271_SCAN_STATE_IDLE)
 		return -EBUSY;
 
-	wl->scan.state = WL1271_SCAN_STATE_2GHZ_ACTIVE;
+	if (req->n_ssids == 0)
+		/*
+		 * no SSIDs means that we have a forced passive scan.
+		 * in that case skip active scan states
+		 */
+		wl->scan.state = WL1271_SCAN_STATE_2GHZ_PASSIVE;
+	else
+		wl->scan.state = WL1271_SCAN_STATE_2GHZ_ACTIVE;
 
 	if (ssid_len && ssid) {
 		wl->scan.ssid_len = ssid_len;
diff --git a/drivers/net/wireless/wl12xx/scan.h b/drivers/net/wireless/wl12xx/scan.h
index 9211515..69e31d5 100644
--- a/drivers/net/wireless/wl12xx/scan.h
+++ b/drivers/net/wireless/wl12xx/scan.h
@@ -58,8 +58,8 @@ void wl1271_scan_sched_scan_results(struct wl1271 *wl);
 enum {
 	WL1271_SCAN_STATE_IDLE,
 	WL1271_SCAN_STATE_2GHZ_ACTIVE,
-	WL1271_SCAN_STATE_2GHZ_PASSIVE,
 	WL1271_SCAN_STATE_5GHZ_ACTIVE,
+	WL1271_SCAN_STATE_2GHZ_PASSIVE,
 	WL1271_SCAN_STATE_5GHZ_PASSIVE,
 	WL1271_SCAN_STATE_DONE
 };
-- 
1.7.1

