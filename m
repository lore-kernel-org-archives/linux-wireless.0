Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63738 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230Ab1LTKEL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 05:04:11 -0500
Received: by wgbdr13 with SMTP id dr13so12218259wgb.1
        for <linux-wireless@vger.kernel.org>; Tue, 20 Dec 2011 02:04:10 -0800 (PST)
From: Eyal Shapira <eyal@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: fix sched scan of DFS channels
Date: Tue, 20 Dec 2011 12:04:01 +0200
Message-Id: <1324375441-2053-1-git-send-email-eyal@wizery.com> (sfid-20111220_110416_047884_DB5523C9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

DFS channels weren't scanned properly because
min/max_duration weren't set for these channels
even though they're required by the FW.
The change sets passive_duration and min/max_duration
for all channels as the FW uses the correct parameters
according to the channel type.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
---
 drivers/net/wireless/wl12xx/scan.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index 8599dab..260986b 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -437,18 +437,19 @@ wl1271_scan_get_sched_scan_channels(struct wl1271 *wl,
 
 			if (flags & IEEE80211_CHAN_RADAR) {
 				channels[j].flags |= SCAN_CHANNEL_FLAGS_DFS;
+
 				channels[j].passive_duration =
 					cpu_to_le16(c->dwell_time_dfs);
-			}
-			else if (flags & IEEE80211_CHAN_PASSIVE_SCAN) {
+			} else {
 				channels[j].passive_duration =
 					cpu_to_le16(c->dwell_time_passive);
-			} else {
-				channels[j].min_duration =
-					cpu_to_le16(c->min_dwell_time_active);
-				channels[j].max_duration =
-					cpu_to_le16(c->max_dwell_time_active);
 			}
+
+			channels[j].min_duration =
+				cpu_to_le16(c->min_dwell_time_active);
+			channels[j].max_duration =
+				cpu_to_le16(c->max_dwell_time_active);
+
 			channels[j].tx_power_att = req->channels[i]->max_power;
 			channels[j].channel = req->channels[i]->hw_value;
 
-- 
1.7.4.1

