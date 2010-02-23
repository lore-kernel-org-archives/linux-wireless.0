Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:62608 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab0BWPUE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2010 10:20:04 -0500
Received: by fxm19 with SMTP id 19so3918664fxm.21
        for <linux-wireless@vger.kernel.org>; Tue, 23 Feb 2010 07:20:01 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC] Improve software scan timing
Date: Tue, 23 Feb 2010 16:19:55 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Kalle Valo <kalle.valo@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201002231619.55189.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current software scan implemenation in mac80211 returns to the operating
channel after each scanned channel. However, in some situations (e.g. no
traffic) it would be nicer to scan a few channels in a row to speed up
the scan itself.

Hence, after scanning a channel, check if we have queued up any tx frames and
return to the operating channel in that case.

Unfortunately we don't know if the AP has buffered any frames for us. Hence,
scan only as many channels in a row as the pm_qos latency allows us to.

However I've got a few open questions:

Does anybody know if pm_qos is already used by any applications? At least
on my system it seems that nothing sets any latency requirements.

Should we also consider the current listen_interval for deciding how long
we could stay away from the operating channel? That should prevent us
from losing too many frames but since most drivers don't register a
max_listen_interval we usually end up with a listen_interval of
1 which is quite short (which means only scanning one channel in a row).

Kalle, Johannes, how is the listen_interval handled in the powersave code?
Are we only sleeping for one beacon interval or are we ignoring the
listen_interval currently.

Thanks,
Helmut

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/scan.c        |   53 +++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 48 insertions(+), 6 deletions(-)

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
index b822dce..f5694b9 100644
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
 
@@ -425,11 +428,26 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
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
 	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_channel *next_chan;
 
 	/* if no more bands/channels left, complete scan and advance to the idle state */
 	if (local->scan_channel_idx >= local->scan_req->n_channels) {
@@ -437,7 +455,10 @@ static int ieee80211_scan_state_decision(struct ieee80211_local *local,
 		return 1;
 	}
 
-	/* check if at least one STA interface is associated */
+	/*
+	 * check if at least one STA interface is associated
+	 * and if it has pending tx frames
+	 */
 	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		if (!ieee80211_sdata_running(sdata))
@@ -446,7 +467,10 @@ static int ieee80211_scan_state_decision(struct ieee80211_local *local,
 		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 			if (sdata->u.mgd.associated) {
 				associated = true;
-				break;
+				if (!qdisc_all_tx_empty(sdata->dev)) {
+					tx_empty = false;
+					break;
+				}
 			}
 		}
 	}
@@ -455,11 +479,24 @@ static int ieee80211_scan_state_decision(struct ieee80211_local *local,
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
+		 * latency allows us to.
+		 *
+		 * Otherwise switch back to the operating channel.
 		 */
-		if (associated)
+		next_chan = local->scan_req->channels[local->scan_channel_idx];
+		bad_latency = time_after(jiffies +
+				ieee80211_scan_get_channel_time(next_chan),
+				local->leave_oper_channel_time +
+				usecs_to_jiffies(pm_qos_requirement(PM_QOS_NETWORK_LATENCY)));
+
+		if (associated && ( !tx_empty || bad_latency))
 			local->next_scan_state = SCAN_ENTER_OPER_CHANNEL;
 		else
 			local->next_scan_state = SCAN_SET_CHANNEL;
@@ -491,6 +528,9 @@ static void ieee80211_scan_state_leave_oper_channel(struct ieee80211_local *loca
 	else
 		*next_delay = HZ / 10;
 
+	/* remember when we left the operating channel */
+	local->leave_oper_channel_time = jiffies;
+
 	/* advance to the next channel to be scanned */
 	local->next_scan_state = SCAN_SET_CHANNEL;
 }
@@ -510,6 +550,7 @@ static void ieee80211_scan_state_enter_oper_channel(struct ieee80211_local *loca
 
 	__clear_bit(SCAN_OFF_CHANNEL, &local->scanning);
 
+	local->leave_oper_channel_time = jiffies;
 	*next_delay = HZ / 5;
 	local->next_scan_state = SCAN_DECISION;
 }
-- 
1.6.0.2

