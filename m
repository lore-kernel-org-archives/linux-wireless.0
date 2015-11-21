Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s1.neomailbox.net ([5.148.176.57]:21769 "EHLO s1.neomailbox.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759817AbbKUKOk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Nov 2015 05:14:40 -0500
From: Antonio Quartulli <antonio@meshcoding.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@meshcoding.com>,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [PATCH v3] mac80211: do not actively scan DFS channels
Date: Sat, 21 Nov 2015 18:13:40 +0800
Message-Id: <1448100820-22567-1-git-send-email-antonio@meshcoding.com> (sfid-20151121_111447_083890_6ACD7408)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

DFS channels should not be actively scanned as we can't be sure
if we are allowed or not.

If the current channel is in the DFS band, active scan might be
performed after CSA, but we have no guarantee about other channels,
therefore it is safer to prevent active scanning at all.

Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---

v3: remove scan_req argument in ieee80211_scan_get_channel_time() invocation

 net/mac80211/scan.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 4aeca4b..7e66e20 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -599,7 +599,8 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 
 		if ((req->channels[0]->flags &
 		     IEEE80211_CHAN_NO_IR) ||
-		    !req->n_ssids) {
+		    !req->n_ssids ||
+		    (req->channels[0]->flags & IEEE80211_CHAN_RADAR)) {
 			next_delay = IEEE80211_PASSIVE_CHANNEL_TIME;
 		} else {
 			ieee80211_scan_state_send_probe(local, &next_delay);
@@ -645,7 +646,8 @@ ieee80211_scan_get_channel_time(struct ieee80211_channel *chan)
 	 * TODO: channel switching also consumes quite some time,
 	 * add that delay as well to get a better estimation
 	 */
-	if (chan->flags & IEEE80211_CHAN_NO_IR)
+	if ((chan->flags & IEEE80211_CHAN_NO_IR) ||
+	    (chan->flags & IEEE80211_CHAN_RADAR))
 		return IEEE80211_PASSIVE_CHANNEL_TIME;
 	return IEEE80211_PROBE_DELAY + IEEE80211_CHANNEL_TIME;
 }
@@ -777,7 +779,8 @@ static void ieee80211_scan_state_set_channel(struct ieee80211_local *local,
 	 *
 	 * In any case, it is not necessary for a passive scan.
 	 */
-	if (chan->flags & IEEE80211_CHAN_NO_IR || !scan_req->n_ssids) {
+	if (chan->flags & IEEE80211_CHAN_NO_IR || !scan_req->n_ssids ||
+	    (chan->flags & IEEE80211_CHAN_RADAR)) {
 		*next_delay = IEEE80211_PASSIVE_CHANNEL_TIME;
 		local->next_scan_state = SCAN_DECISION;
 		return;
-- 
2.6.3

