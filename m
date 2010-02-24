Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34031 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756982Ab0BXNT2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2010 08:19:28 -0500
From: Helmut Schaa <Helmut.Schaa@gmx.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] mac80211: Improve software scan timing
Date: Wed, 24 Feb 2010 14:19:21 +0100
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201002241419.22109.Helmut.Schaa@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current software scan implemenation in mac80211 returns to the operating
channel after each scanned channel. However, in some situations (e.g. no
traffic) it would be nicer to scan a few channels in a row to speed up
the scan itself.

Hence, after scanning a channel, check if we have queued up any tx frames and
return to the operating channel in that case.

Unfortunately we don't know if the AP has buffered any frames for us. Hence,
scan only as many channels in a row as the pm_qos latency and the negotiated
listen interval allows us to.


Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/scan.c        |   71 ++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 66 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 241533e..b841264 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -745,6 +745,7 @@ struct ieee80211_local {
 	int scan_channel_idx;
 	int scan_ies_len;
 
+	unsigned long leave_oper_channel_time;
 	enum mac80211_scan_state next_scan_state;
 	struct delayed_work scan_work;
 	struct ieee80211_sub_if_data *scan_sdata;
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index b822dce..75a8597 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -14,6 +14,8 @@
 
 #include <linux/if_arp.h>
 #include <linux/rtnetlink.h>
+#include <linux/pm_qos_params.h>
+#include <net/sch_generic.h>
 #include <net/mac80211.h>
 
 #include "ieee80211_i.h"
@@ -321,6 +323,7 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local)
 
 	ieee80211_offchannel_stop_beaconing(local);
 
+	local->leave_oper_channel_time = 0;
 	local->next_scan_state = SCAN_DECISION;
 	local->scan_channel_idx = 0;
 
@@ -425,11 +428,28 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 	return rc;
 }
 
+static unsigned long
+ieee80211_scan_get_channel_time(struct ieee80211_channel *chan)
+{
+	/*
+	 * TODO: channel switching also consumes quite some time,
+	 * add that delay as well to get a better estimation
+	 */
+	if (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN)
+		return IEEE80211_PASSIVE_CHANNEL_TIME;
+	return IEEE80211_PROBE_DELAY + IEEE80211_CHANNEL_TIME;
+}
+
 static int ieee80211_scan_state_decision(struct ieee80211_local *local,
 					 unsigned long *next_delay)
 {
 	bool associated = false;
+	bool tx_empty = true;
+	bool bad_latency;
+	bool listen_int_exceeded;
+	unsigned long min_beacon_int = 0;
 	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_channel *next_chan;
 
 	/* if no more bands/channels left, complete scan and advance to the idle state */
 	if (local->scan_channel_idx >= local->scan_req->n_channels) {
@@ -437,7 +457,11 @@ static int ieee80211_scan_state_decision(struct ieee80211_local *local,
 		return 1;
 	}
 
-	/* check if at least one STA interface is associated */
+	/*
+	 * check if at least one STA interface is associated,
+	 * check if at least one STA interface has pending tx frames
+	 * and grab the lowest used beacon interval
+	 */
 	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		if (!ieee80211_sdata_running(sdata))
@@ -446,7 +470,16 @@ static int ieee80211_scan_state_decision(struct ieee80211_local *local,
 		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 			if (sdata->u.mgd.associated) {
 				associated = true;
-				break;
+
+				if (sdata->vif.bss_conf.beacon_int <
+				    min_beacon_int || min_beacon_int == 0)
+					min_beacon_int =
+						sdata->vif.bss_conf.beacon_int;
+
+				if (!qdisc_all_tx_empty(sdata->dev)) {
+					tx_empty = false;
+					break;
+				}
 			}
 		}
 	}
@@ -455,11 +488,34 @@ static int ieee80211_scan_state_decision(struct ieee80211_local *local,
 	if (local->scan_channel) {
 		/*
 		 * we're currently scanning a different channel, let's
-		 * switch back to the operating channel now if at least
-		 * one interface is associated. Otherwise just scan the
-		 * next channel
+		 * see if we can scan another channel without interfering
+		 * with the current traffic situation.
+		 *
+		 * Since we don't know if the AP has pending frames for us
+		 * we can only check for our tx queues and use the current
+		 * pm_qos requirements for rx. Hence, if no tx traffic occurs
+		 * at all we will scan as many channels in a row as the pm_qos
+		 * latency allows us to. Additionally we also check for the
+		 * currently negotiated listen interval to prevent losing
+		 * frames unnecessarily.
+		 *
+		 * Otherwise switch back to the operating channel.
 		 */
-		if (associated)
+		next_chan = local->scan_req->channels[local->scan_channel_idx];
+
+		bad_latency = time_after(jiffies +
+				ieee80211_scan_get_channel_time(next_chan),
+				local->leave_oper_channel_time +
+				usecs_to_jiffies(pm_qos_requirement(PM_QOS_NETWORK_LATENCY)));
+
+		listen_int_exceeded = time_after(jiffies +
+				ieee80211_scan_get_channel_time(next_chan),
+				local->leave_oper_channel_time +
+				usecs_to_jiffies(min_beacon_int * 1024) *
+				local->hw.conf.listen_interval);
+
+		if (associated && ( !tx_empty || bad_latency ||
+		    listen_int_exceeded))
 			local->next_scan_state = SCAN_ENTER_OPER_CHANNEL;
 		else
 			local->next_scan_state = SCAN_SET_CHANNEL;
@@ -491,6 +547,9 @@ static void ieee80211_scan_state_leave_oper_channel(struct ieee80211_local *loca
 	else
 		*next_delay = HZ / 10;
 
+	/* remember when we left the operating channel */
+	local->leave_oper_channel_time = jiffies;
+
 	/* advance to the next channel to be scanned */
 	local->next_scan_state = SCAN_SET_CHANNEL;
 }
-- 
1.6.0.2

