Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s1.neomailbox.net ([5.148.176.57]:25215 "EHLO s1.neomailbox.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbbKNBaV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2015 20:30:21 -0500
From: Antonio Quartulli <antonio@meshcoding.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@meshcoding.com>,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [PATCH v2 2/2] mac80211: passively scan DFS channels if requested
Date: Sat, 14 Nov 2015 09:29:20 +0800
Message-Id: <1447464560-28104-2-git-send-email-antonio@meshcoding.com> (sfid-20151114_023053_025035_B15CD4B8)
In-Reply-To: <1447464560-28104-1-git-send-email-antonio@meshcoding.com>
References: <1447464560-28104-1-git-send-email-antonio@meshcoding.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

if the NL80211_SCAN_FLAG_PASSIVE_RADAR flag was specified upon
sw scan start, passively scan any channel marked as DFS.

Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---

v2: fix variable names and add scan_req argument to
    ieee80211_scan_get_channel_time()

 net/mac80211/scan.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 4aeca4b..e369d61 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -599,7 +599,9 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 
 		if ((req->channels[0]->flags &
 		     IEEE80211_CHAN_NO_IR) ||
-		    !req->n_ssids) {
+		    !req->n_ssids ||
+		    ((req->channels[0]->flags & IEEE80211_CHAN_RADAR) &&
+		     (req->flags & NL80211_SCAN_FLAG_PASSIVE_RADAR))) {
 			next_delay = IEEE80211_PASSIVE_CHANNEL_TIME;
 		} else {
 			ieee80211_scan_state_send_probe(local, &next_delay);
@@ -639,13 +641,16 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 }
 
 static unsigned long
-ieee80211_scan_get_channel_time(struct ieee80211_channel *chan)
+ieee80211_scan_get_channel_time(struct ieee80211_channel *chan,
+				struct cfg80211_scan_request *scan_req)
 {
 	/*
 	 * TODO: channel switching also consumes quite some time,
 	 * add that delay as well to get a better estimation
 	 */
-	if (chan->flags & IEEE80211_CHAN_NO_IR)
+	if ((chan->flags & IEEE80211_CHAN_NO_IR) ||
+	    ((chan->flags & IEEE80211_CHAN_RADAR) &&
+	     (scan_req->flags & NL80211_SCAN_FLAG_PASSIVE_RADAR)))
 		return IEEE80211_PASSIVE_CHANNEL_TIME;
 	return IEEE80211_PROBE_DELAY + IEEE80211_CHANNEL_TIME;
 }
@@ -698,7 +703,8 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
 	 */
 
 	bad_latency = time_after(jiffies +
-				 ieee80211_scan_get_channel_time(next_chan),
+				 ieee80211_scan_get_channel_time(next_chan,
+								 scan_req),
 				 local->leave_oper_channel_time + HZ / 8);
 
 	if (associated && !tx_empty) {
@@ -777,7 +783,9 @@ static void ieee80211_scan_state_set_channel(struct ieee80211_local *local,
 	 *
 	 * In any case, it is not necessary for a passive scan.
 	 */
-	if (chan->flags & IEEE80211_CHAN_NO_IR || !scan_req->n_ssids) {
+	if (chan->flags & IEEE80211_CHAN_NO_IR || !scan_req->n_ssids ||
+	    ((chan->flags & IEEE80211_CHAN_RADAR) &&
+	     (scan_req->flags & NL80211_SCAN_FLAG_PASSIVE_RADAR))) {
 		*next_delay = IEEE80211_PASSIVE_CHANNEL_TIME;
 		local->next_scan_state = SCAN_DECISION;
 		return;
-- 
2.6.3

