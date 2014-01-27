Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:12225 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753095AbaA0KU1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jan 2014 05:20:27 -0500
From: Ilan Peer <ilan.peer@intel.com>
To: linux-wireless@vger.kernel.org
Cc: wireless-regdb@lists.infradead.org, Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH v3 6/6] mac80211: Enable initiating radiation on indoor channels
Date: Mon, 27 Jan 2014 12:21:58 +0200
Message-Id: <1390818118-27261-7-git-send-email-ilan.peer@intel.com> (sfid-20140127_112045_011046_98DEA116)
In-Reply-To: <1390818118-27261-1-git-send-email-ilan.peer@intel.com>
References: <1390818118-27261-1-git-send-email-ilan.peer@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow active scanning and frame injection on channels marked with
IEEE80211_CHAN_NO_IR iff the channel is also marked with
IEEE80211_CHAN_INDOOR_ONLY and the wireless core thinks that it
operates in an indoor environment.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
---
 net/mac80211/scan.c |   15 +++++++++------
 net/mac80211/tx.c   |    3 ++-
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 88c8161..e78aa29 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -527,8 +527,8 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 		/* We need to ensure power level is at max for scanning. */
 		ieee80211_hw_config(local, 0);
 
-		if ((req->channels[0]->flags &
-		     IEEE80211_CHAN_NO_IR) ||
+		if (!regulatory_ir_allowed(local->hw.wiphy,
+					   req->channels[0]) ||
 		    !local->scan_req->n_ssids) {
 			next_delay = IEEE80211_PASSIVE_CHANNEL_TIME;
 		} else {
@@ -568,13 +568,14 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 }
 
 static unsigned long
-ieee80211_scan_get_channel_time(struct ieee80211_channel *chan)
+ieee80211_scan_get_channel_time(struct wiphy *wiphy,
+				struct ieee80211_channel *chan)
 {
 	/*
 	 * TODO: channel switching also consumes quite some time,
 	 * add that delay as well to get a better estimation
 	 */
-	if (chan->flags & IEEE80211_CHAN_NO_IR)
+	if (!regulatory_ir_allowed(wiphy, chan))
 		return IEEE80211_PASSIVE_CHANNEL_TIME;
 	return IEEE80211_PROBE_DELAY + IEEE80211_CHANNEL_TIME;
 }
@@ -588,6 +589,7 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_channel *next_chan;
 	enum mac80211_scan_state next_scan_state;
+	struct wiphy *wiphy = local->hw.wiphy;
 
 	/*
 	 * check if at least one STA interface is associated,
@@ -623,7 +625,8 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
 	 */
 
 	bad_latency = time_after(jiffies +
-				 ieee80211_scan_get_channel_time(next_chan),
+				 ieee80211_scan_get_channel_time(wiphy,
+								 next_chan),
 				 local->leave_oper_channel_time + HZ / 8);
 
 	if (associated && !tx_empty) {
@@ -698,7 +701,7 @@ static void ieee80211_scan_state_set_channel(struct ieee80211_local *local,
 	 *
 	 * In any case, it is not necessary for a passive scan.
 	 */
-	if (chan->flags & IEEE80211_CHAN_NO_IR ||
+	if (!regulatory_ir_allowed(local->hw.wiphy, chan) ||
 	    !local->scan_req->n_ssids) {
 		*next_delay = IEEE80211_PASSIVE_CHANNEL_TIME;
 		local->next_scan_state = SCAN_DECISION;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 27c990b..171d0c5 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1732,7 +1732,8 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 	 * radar detection by itself. We can do that later by adding a
 	 * monitor flag interfaces used for AP support.
 	 */
-	if ((chan->flags & (IEEE80211_CHAN_NO_IR | IEEE80211_CHAN_RADAR)))
+	if (!regulatory_ir_allowed(local->hw.wiphy, chan) ||
+	    chan->flags & IEEE80211_CHAN_RADAR)
 		goto fail_rcu;
 
 	ieee80211_xmit(sdata, skb, chan->band);
-- 
1.7.10.4

