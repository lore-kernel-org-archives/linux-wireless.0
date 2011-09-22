Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:52874 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752299Ab1IVHbY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 03:31:24 -0400
Received: by bkbzs8 with SMTP id zs8so2893193bkb.13
        for <linux-wireless@vger.kernel.org>; Thu, 22 Sep 2011 00:31:19 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: coelho@ti.com
Cc: yoni.divinsky@ti.com, linux-wireless@vger.kernel.org
Subject: [PATCH] wl12xx: fix forced passive scans
Date: Thu, 22 Sep 2011 10:30:53 +0300
Message-Id: <1316676653-1758-1-git-send-email-coelho@ti.com> (sfid-20110922_093127_702276_7D194465)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We were using incorrect max and min dwell times during forced passive
scans because we were still using the active scan states to scan
(passively) the channels that were not marked as passive.

Instead of doing passive scans in active states, we now skip active
states and scan for all channels in passive states.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
This replaces Shahar Levi's "Set the correct min&max dwell time
setting on passive scan".

Also thanks to Yoni Divinsky who also proposed a similar fix.

 drivers/net/wireless/wl12xx/scan.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index eeccc9f..08f7e82 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -99,14 +99,18 @@ static int wl1271_get_scan_channels(struct wl1271 *wl,
 	for (i = 0, j = 0;
 	     i < req->n_channels && j < WL1271_SCAN_MAX_CHANNELS;
 	     i++) {
-
 		flags = req->channels[i]->flags;
 
 		if (!test_bit(i, wl->scan.scanned_ch) &&
 		    !(flags & IEEE80211_CHAN_DISABLED) &&
-		    ((!!(flags & IEEE80211_CHAN_PASSIVE_SCAN)) == passive) &&
-		    (req->channels[i]->band == band)) {
-
+		    (req->channels[i]->band == band) &&
+		    /*
+		     * In passive scans, we scan all remaining
+		     * channels, even if not marked as such.
+		     * In active scans, we only scan channels not
+		     * marked as passive.
+		     */
+		    (passive || !(flags & IEEE80211_CHAN_PASSIVE_SCAN))) {
 			wl1271_debug(DEBUG_SCAN, "band %d, center_freq %d ",
 				     req->channels[i]->band,
 				     req->channels[i]->center_freq);
@@ -158,6 +162,10 @@ static int wl1271_scan_send(struct wl1271 *wl, enum ieee80211_band band,
 	int ret;
 	u16 scan_options = 0;
 
+	/* skip active scans if we don't have SSIDs */
+	if (!passive && wl->scan.req->n_ssids == 0)
+		return WL1271_NOTHING_TO_SCAN;
+
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	trigger = kzalloc(sizeof(*trigger), GFP_KERNEL);
 	if (!cmd || !trigger) {
@@ -165,8 +173,7 @@ static int wl1271_scan_send(struct wl1271 *wl, enum ieee80211_band band,
 		goto out;
 	}
 
-	/* No SSIDs means that we have a forced passive scan */
-	if (passive || wl->scan.req->n_ssids == 0)
+	if (passive)
 		scan_options |= WL1271_SCAN_OPT_PASSIVE;
 
 	if (WARN_ON(wl->role_id == WL12XX_INVALID_ROLE_ID)) {
-- 
1.7.1

