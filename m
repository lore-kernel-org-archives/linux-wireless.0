Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:52617 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754698Ab2EXSze (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 May 2012 14:55:34 -0400
Received: by yhjj63 with SMTP id j63so171250yhj.37
        for <linux-wireless@vger.kernel.org>; Thu, 24 May 2012 11:55:33 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <johannes@sipsolutions.net>
Subject: [PATCH 2/2] mac80211: handle channel times in scan command
Date: Thu, 24 May 2012 21:52:49 +0300
Message-Id: <1337885569-32711-2-git-send-email-victorg@ti.com> (sfid-20120524_205538_771713_60F90059)
In-Reply-To: <1337885569-32711-1-git-send-email-victorg@ti.com>
References: <1337885569-32711-1-git-send-email-victorg@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the user scan times if those were set, otherwise
use the default values.

This patch handles both hw_scan and non-offload scan.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---
 net/mac80211/scan.c |   34 +++++++++++++++++++++++++---------
 1 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 8282284..0757551 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -421,7 +421,7 @@ static void ieee80211_scan_state_send_probe(struct ieee80211_local *local,
 	 * After sending probe requests, wait for probe responses
 	 * on the channel.
 	 */
-	*next_delay = IEEE80211_CHANNEL_TIME;
+	*next_delay = local->scan_req->min_ch_time;
 	local->next_scan_state = SCAN_DECISION;
 }
 
@@ -456,6 +456,13 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 
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
@@ -475,6 +482,12 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 	local->scan_req = req;
 	local->scan_sdata = sdata;
 
+	if (!local->scan_req->min_passive_ch_time)
+		local->scan_req->min_passive_ch_time =
+			IEEE80211_PASSIVE_CHANNEL_TIME;
+	if (!local->scan_req->min_ch_time)
+		local->scan_req->min_ch_time = IEEE80211_CHANNEL_TIME;
+
 	if (local->ops->hw_scan) {
 		__set_bit(SCAN_HW_SCANNING, &local->scanning);
 	} else if ((req->n_channels == 1) &&
@@ -502,10 +515,10 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 		if ((req->channels[0]->flags &
 		     IEEE80211_CHAN_PASSIVE_SCAN) ||
 		    !local->scan_req->n_ssids) {
-			next_delay = IEEE80211_PASSIVE_CHANNEL_TIME;
+			next_delay = local->scan_req->min_passive_ch_time;
 		} else {
 			ieee80211_scan_state_send_probe(local, &next_delay);
-			next_delay = IEEE80211_CHANNEL_TIME;
+			next_delay = local->scan_req->min_ch_time;
 		}
 
 		/* Now, just wait a bit and we are all done! */
@@ -540,15 +553,16 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
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
+		return scan_req->min_passive_ch_time;
+	return IEEE80211_PROBE_DELAY + scan_req->min_ch_time;
 }
 
 static void ieee80211_scan_state_decision(struct ieee80211_local *local,
@@ -609,12 +623,14 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
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
@@ -662,7 +678,7 @@ static void ieee80211_scan_state_set_channel(struct ieee80211_local *local,
 	 */
 	if (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN ||
 	    !local->scan_req->n_ssids) {
-		*next_delay = IEEE80211_PASSIVE_CHANNEL_TIME;
+		*next_delay = local->scan_req->min_passive_ch_time;
 		local->next_scan_state = SCAN_DECISION;
 		return;
 	}
-- 
1.7.5.4

