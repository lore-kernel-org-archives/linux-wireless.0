Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s1.neomailbox.net ([5.148.176.57]:39549 "EHLO s1.neomailbox.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932744AbbKMSjX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2015 13:39:23 -0500
From: Antonio Quartulli <antonio@meshcoding.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@meshcoding.com>,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [PATCH 2/2] mac80211: passively scan DFS channels if requested
Date: Sat, 14 Nov 2015 01:56:02 +0800
Message-Id: <1447437362-32647-2-git-send-email-antonio@meshcoding.com> (sfid-20151113_193927_571963_24509380)
In-Reply-To: <1447437362-32647-1-git-send-email-antonio@meshcoding.com>
References: <1447437362-32647-1-git-send-email-antonio@meshcoding.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

if the NL80211_SCAN_FLAG_PASSIVE_RADAR flag was specified upon
sw scan start, passively scan any channel marked as DFS.

Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---
 net/mac80211/scan.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 4aeca4b..d8f7b4a 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -599,7 +599,9 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 
 		if ((req->channels[0]->flags &
 		     IEEE80211_CHAN_NO_IR) ||
-		    !req->n_ssids) {
+		    !req->n_ssids ||
+		    ((chan->flags & IEEE80211_CHAN_RADAR) &&
+		     (scan_req->flags & NL80211_SCAN_FLAG_PASSIVE_RADAR))) {
 			next_delay = IEEE80211_PASSIVE_CHANNEL_TIME;
 		} else {
 			ieee80211_scan_state_send_probe(local, &next_delay);
@@ -645,7 +647,9 @@ ieee80211_scan_get_channel_time(struct ieee80211_channel *chan)
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
@@ -777,7 +781,9 @@ static void ieee80211_scan_state_set_channel(struct ieee80211_local *local,
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

