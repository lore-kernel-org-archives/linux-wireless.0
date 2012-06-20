Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:38080 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754739Ab2FTHhL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 03:37:11 -0400
Received: by obbeh20 with SMTP id eh20so8368134obb.10
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jun 2012 00:37:10 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <johannes@sipsolutions.net>, <eliad@wizery.com>
Subject: [PATCH v3 2/2] mac80211: handle channel times in scan command
Date: Wed, 20 Jun 2012 10:33:54 +0300
Message-Id: <1340177634-24568-2-git-send-email-victorg@ti.com> (sfid-20120620_093716_299644_7A0A5DC6)
In-Reply-To: <1340177634-24568-1-git-send-email-victorg@ti.com>
References: <1340177634-24568-1-git-send-email-victorg@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the user scan times if those were set, otherwise
use the default values.

This patch handles both hw_scan and non-offload scan.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---
 net/mac80211/scan.c |   31 ++++++++++++++++++++-----------
 1 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 169da07..548b564 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -26,8 +26,6 @@
 #include "mesh.h"
 
 #define IEEE80211_PROBE_DELAY (HZ / 33)
-#define IEEE80211_CHANNEL_TIME (HZ / 33)
-#define IEEE80211_PASSIVE_CHANNEL_TIME (HZ / 8)
 
 static void ieee80211_rx_bss_free(struct cfg80211_bss *cbss)
 {
@@ -421,7 +419,7 @@ static void ieee80211_scan_state_send_probe(struct ieee80211_local *local,
 	 * After sending probe requests, wait for probe responses
 	 * on the channel.
 	 */
-	*next_delay = IEEE80211_CHANNEL_TIME;
+	*next_delay = TU_TO_JIFFIES(local->scan_req->min_ch_time);
 	local->next_scan_state = SCAN_DECISION;
 }
 
@@ -456,6 +454,13 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 
 		local->hw_scan_req->ssids = req->ssids;
 		local->hw_scan_req->n_ssids = req->n_ssids;
+		local->hw_scan_req->max_ch_time = req->max_ch_time;
+		local->hw_scan_req->min_ch_time = req->min_ch_time;
+		local->hw_scan_req->max_passive_ch_time =
+			req->max_passive_ch_time;
+		local->hw_scan_req->min_passive_ch_time =
+			req->min_passive_ch_time;
+
 		ies = (u8 *)local->hw_scan_req +
 			sizeof(*local->hw_scan_req) +
 			req->n_channels * sizeof(req->channels[0]);
@@ -502,10 +507,10 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 		if ((req->channels[0]->flags &
 		     IEEE80211_CHAN_PASSIVE_SCAN) ||
 		    !local->scan_req->n_ssids) {
-			next_delay = IEEE80211_PASSIVE_CHANNEL_TIME;
+			next_delay = TU_TO_JIFFIES(req->min_passive_ch_time);
 		} else {
 			ieee80211_scan_state_send_probe(local, &next_delay);
-			next_delay = IEEE80211_CHANNEL_TIME;
+			next_delay = TU_TO_JIFFIES(req->min_ch_time);
 		}
 
 		/* Now, just wait a bit and we are all done! */
@@ -540,15 +545,16 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 }
 
 static unsigned long
-ieee80211_scan_get_channel_time(struct ieee80211_channel *chan)
+ieee80211_scan_get_channel_time(struct cfg80211_scan_request *scan_req,
+				struct ieee80211_channel *chan)
 {
 	/*
 	 * TODO: channel switching also consumes quite some time,
 	 * add that delay as well to get a better estimation
 	 */
 	if (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN)
-		return IEEE80211_PASSIVE_CHANNEL_TIME;
-	return IEEE80211_PROBE_DELAY + IEEE80211_CHANNEL_TIME;
+		return TU_TO_JIFFIES(scan_req->min_passive_ch_time);
+	return IEEE80211_PROBE_DELAY + TU_TO_JIFFIES(scan_req->min_ch_time);
 }
 
 static void ieee80211_scan_state_decision(struct ieee80211_local *local,
@@ -609,12 +615,14 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
 	 */
 
 	bad_latency = time_after(jiffies +
-			ieee80211_scan_get_channel_time(next_chan),
+			ieee80211_scan_get_channel_time(local->scan_req,
+							next_chan),
 			local->leave_oper_channel_time +
 			usecs_to_jiffies(pm_qos_request(PM_QOS_NETWORK_LATENCY)));
 
 	listen_int_exceeded = time_after(jiffies +
-			ieee80211_scan_get_channel_time(next_chan),
+			ieee80211_scan_get_channel_time(local->scan_req,
+							next_chan),
 			local->leave_oper_channel_time +
 			usecs_to_jiffies(min_beacon_int * 1024) *
 			local->hw.conf.listen_interval);
@@ -662,7 +670,8 @@ static void ieee80211_scan_state_set_channel(struct ieee80211_local *local,
 	 */
 	if (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN ||
 	    !local->scan_req->n_ssids) {
-		*next_delay = IEEE80211_PASSIVE_CHANNEL_TIME;
+		*next_delay =
+			TU_TO_JIFFIES(local->scan_req->min_passive_ch_time);
 		local->next_scan_state = SCAN_DECISION;
 		return;
 	}
-- 
1.7.5.4

