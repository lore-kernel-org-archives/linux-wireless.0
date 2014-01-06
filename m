Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from li674-96.members.linode.com ([212.71.239.96]:43890 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751218AbaAFH6W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 02:58:22 -0500
Date: Mon, 6 Jan 2014 09:52:10 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC 3/3] mac80211: Allow channel time for scans to be modified
Message-ID: <20140106075210.GA31061@w1.fi> (sfid-20140106_085826_148612_B57AF4C0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This uses the MaxChannelTime value, if specified, from the scan request
to control how long the mac80211 sw_scan spends on the channels.

Signed-off-by: Jouni Malinen <j@w1.fi>
---
 net/mac80211/scan.c |   38 +++++++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 88c8161..53252a5 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -29,6 +29,27 @@
 #define IEEE80211_CHANNEL_TIME (HZ / 33)
 #define IEEE80211_PASSIVE_CHANNEL_TIME (HZ / 9)
 
+static unsigned long ieee80211_scan_active_time(struct ieee80211_local *local)
+{
+	/*
+	 * Note: Could use min_chan_time to speed scans if we supported
+	 * PHY-CCA.indication detection or maybe an emulation of that based on
+	 * frame RX.
+	 */
+	if (!local->scan_req->max_chan_time)
+		return IEEE80211_CHANNEL_TIME;
+	return max_t(unsigned long,
+		     TU_TO_JIFFIES(local->scan_req->max_chan_time), 1);
+}
+
+static unsigned long ieee80211_scan_passive_time(struct ieee80211_local *local)
+{
+	if (!local->scan_req->max_chan_time)
+		return IEEE80211_PASSIVE_CHANNEL_TIME;
+	return max_t(unsigned long,
+		     TU_TO_JIFFIES(local->scan_req->max_chan_time), 1);
+}
+
 void ieee80211_rx_bss_put(struct ieee80211_local *local,
 			  struct ieee80211_bss *bss)
 {
@@ -447,7 +468,7 @@ static void ieee80211_scan_state_send_probe(struct ieee80211_local *local,
 	 * After sending probe requests, wait for probe responses
 	 * on the channel.
 	 */
-	*next_delay = IEEE80211_CHANNEL_TIME;
+	*next_delay = ieee80211_scan_active_time(local);
 	local->next_scan_state = SCAN_DECISION;
 }
 
@@ -489,6 +510,8 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 			req->n_channels * sizeof(req->channels[0]);
 		local->hw_scan_req->ie = ies;
 		local->hw_scan_req->flags = req->flags;
+		local->hw_scan_req->min_chan_time = req->min_chan_time;
+		local->hw_scan_req->max_chan_time = req->max_chan_time;
 
 		local->hw_scan_band = 0;
 
@@ -527,14 +550,11 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 		/* We need to ensure power level is at max for scanning. */
 		ieee80211_hw_config(local, 0);
 
-		if ((req->channels[0]->flags &
-		     IEEE80211_CHAN_NO_IR) ||
-		    !local->scan_req->n_ssids) {
-			next_delay = IEEE80211_PASSIVE_CHANNEL_TIME;
-		} else {
+		if ((req->channels[0]->flags & IEEE80211_CHAN_NO_IR) ||
+		    !local->scan_req->n_ssids)
+			next_delay = ieee80211_scan_passive_time(local);
+		else
 			ieee80211_scan_state_send_probe(local, &next_delay);
-			next_delay = IEEE80211_CHANNEL_TIME;
-		}
 
 		/* Now, just wait a bit and we are all done! */
 		ieee80211_queue_delayed_work(&local->hw, &local->scan_work,
@@ -700,7 +720,7 @@ static void ieee80211_scan_state_set_channel(struct ieee80211_local *local,
 	 */
 	if (chan->flags & IEEE80211_CHAN_NO_IR ||
 	    !local->scan_req->n_ssids) {
-		*next_delay = IEEE80211_PASSIVE_CHANNEL_TIME;
+		*next_delay = ieee80211_scan_passive_time(local);
 		local->next_scan_state = SCAN_DECISION;
 		return;
 	}
-- 
1.7.9.5


-- 
Jouni Malinen                                            PGP id EFC895FA
