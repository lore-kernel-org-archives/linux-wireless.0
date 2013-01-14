Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756221Ab3ANO4F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2013 09:56:05 -0500
Date: Mon, 14 Jan 2013 15:55:59 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Seth Forshee <seth.forshee@canonical.com>,
	Sam Leffler <sleffler@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [RFC] mac80211: soft scan vs latency
Message-ID: <20130114145558.GA24250@redhat.com> (sfid-20130114_155611_158723_BB04C488)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm trying to improve latency while scanning for voice and video
applications.

Patch remove latency requirement based on PM_QOS_NETWORK_LATENCY,
this value is default 2000 seconds (i.e. approximately 0.5 hour !?!).

Also remove listen interval requirement, which based on beaconing and
depending on BSS parameters. It can make we stay off-channel for a
second or more.

Instead try to offer the best latency that we could, i.e. be off-channel
no longer than PASSIVE channel scan time: 125 ms. That mean we will
scan two ACTIVE channels and go back to on-channel, and one PASSIVE
channel, and go back to on-channel.

Patch also decrease PASSIVE channel scan time to about 110 ms.

As drawback patch increase overall scan time. Here, when scanning both
2GHz and 5GHz bands, from 5 seconds up to 10 seconds. Since that
increase happen only when we are associated I think it could be
acceptable. But perhaps when RSSI is low, and we need to make
decision about roaming, scan should be fast. I suppose we can add
scanning parameters/flags that will change off and on-channel times
depending on requirement - use different parameters for background
scan with low RSSI and high RSSI.

I thought that new NL80211_SCAN_FLAG_LOW_PRIORITY flag could solve
the problem, but it does not work well. If host do not transmit
data, RX will wait. Additionally, it prevent to perform successful
scan, if we do any (possibly small) transmission while scanning.

Except latency, patch perhaps also improve throughput, since we spend
more time on-channel while scanning. But I'm not quite sure, since
overall scanning time is bigger. I did not test influence of the patch
on throughput.

I tested patch by doing:

while true; do iw dev wlan0 scan; sleep 3; done > /dev/null

and

ping -i0.2 -c 1000 HOST

on remote and local machine, results are as below:

* Ping from local periodically scanning machine to AP:
Unpatched: rtt min/avg/max/mdev = 0.928/24.946/182.135/36.873 ms
Patched:   rtt min/avg/max/mdev = 0.928/19.678/150.845/33.130 ms

* Ping from remote machine to periodically scanning machine:
Unpatched: rtt min/avg/max/mdev = 1.637/120.683/709.139/164.337 ms
Patched:   rtt min/avg/max/mdev = 1.807/26.893/201.435/40.284 ms

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/scan.c |   32 +++++---------------------------
 1 files changed, 5 insertions(+), 27 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 06cbe26..505699b 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -27,7 +27,7 @@
 
 #define IEEE80211_PROBE_DELAY (HZ / 33)
 #define IEEE80211_CHANNEL_TIME (HZ / 33)
-#define IEEE80211_PASSIVE_CHANNEL_TIME (HZ / 8)
+#define IEEE80211_PASSIVE_CHANNEL_TIME (HZ / 9)
 
 static void ieee80211_rx_bss_free(struct cfg80211_bss *cbss)
 {
@@ -546,8 +546,6 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
 	bool associated = false;
 	bool tx_empty = true;
 	bool bad_latency;
-	bool listen_int_exceeded;
-	unsigned long min_beacon_int = 0;
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_channel *next_chan;
 	enum mac80211_scan_state next_scan_state;
@@ -566,11 +564,6 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
 			if (sdata->u.mgd.associated) {
 				associated = true;
 
-				if (sdata->vif.bss_conf.beacon_int <
-				    min_beacon_int || min_beacon_int == 0)
-					min_beacon_int =
-						sdata->vif.bss_conf.beacon_int;
-
 				if (!qdisc_all_tx_empty(sdata->dev)) {
 					tx_empty = false;
 					break;
@@ -587,34 +580,19 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
 	 * see if we can scan another channel without interfering
 	 * with the current traffic situation.
 	 *
-	 * Since we don't know if the AP has pending frames for us
-	 * we can only check for our tx queues and use the current
-	 * pm_qos requirements for rx. Hence, if no tx traffic occurs
-	 * at all we will scan as many channels in a row as the pm_qos
-	 * latency allows us to. Additionally we also check for the
-	 * currently negotiated listen interval to prevent losing
-	 * frames unnecessarily.
-	 *
-	 * Otherwise switch back to the operating channel.
+	 * Keep good latency, do not stay off-channel more than 125 ms.
 	 */
 
 	bad_latency = time_after(jiffies +
-			ieee80211_scan_get_channel_time(next_chan),
-			local->leave_oper_channel_time +
-			usecs_to_jiffies(pm_qos_request(PM_QOS_NETWORK_LATENCY)));
-
-	listen_int_exceeded = time_after(jiffies +
-			ieee80211_scan_get_channel_time(next_chan),
-			local->leave_oper_channel_time +
-			usecs_to_jiffies(min_beacon_int * 1024) *
-			local->hw.conf.listen_interval);
+				 ieee80211_scan_get_channel_time(next_chan),
+				 local->leave_oper_channel_time + HZ / 8);
 
 	if (associated && !tx_empty) {
 		if (local->scan_req->flags & NL80211_SCAN_FLAG_LOW_PRIORITY)
 			next_scan_state = SCAN_ABORT;
 		else
 			next_scan_state = SCAN_SUSPEND;
-	} else if (associated && (bad_latency || listen_int_exceeded)) {
+	} else if (associated && bad_latency) {
 		next_scan_state = SCAN_SUSPEND;
 	} else {
 		next_scan_state = SCAN_SET_CHANNEL;
-- 
1.7.1

