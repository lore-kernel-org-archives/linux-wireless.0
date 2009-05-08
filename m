Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37033 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589AbZEHMMY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2009 08:12:24 -0400
Subject: [PATCH] mac80211: improve scan timing
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1241781207.4495.5.camel@johannes.local>
References: <1241781207.4495.5.camel@johannes.local>
Content-Type: text/plain
Date: Fri, 08 May 2009 14:12:21 +0200
Message-Id: <1241784741.4495.15.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The call to ieee80211_hw_config() is supposed to apply changes
synchronously, so once it returns the parameters are applied to
the hardware. Thus, there really is no need to delay the probing
by the channel switch time again since the channel switch has
already happened once we get to this code.

Additionally, there is no need to wait for a NAV update (probe
delay) when the channel is passively scanned. Remove that extra
time too.

This cuts scanning time from over 7 seconds to under 4 on ar9170,
which is due to the number of channels scanned and ar9170's switch
time being advertised as 135ms (my test now indicates it is about
77ms with the current driver, but the difference might also be due
to using a different machine with different USB controllers).

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
John, this replaces "mac80211: don't wait for channel switch that has happened"

 net/mac80211/scan.c |   31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

--- wireless-testing.orig/net/mac80211/scan.c	2009-05-08 13:19:45.000000000 +0200
+++ wireless-testing/net/mac80211/scan.c	2009-05-08 14:11:19.000000000 +0200
@@ -559,24 +559,39 @@ void ieee80211_scan_work(struct work_str
 		if (skip)
 			break;
 
-		next_delay = IEEE80211_PROBE_DELAY +
-			     usecs_to_jiffies(local->hw.channel_change_time);
+		/*
+		 * Probe delay is used to update the NAV, cf. 11.1.3.2.2
+		 * (which unfortunately doesn't say _why_ step a) is done,
+		 * but it waits for the probe delay or until a frame is
+		 * received - and the received frame would update the NAV).
+		 * For now, we do not support waiting until a frame is
+		 * received.
+		 *
+		 * In any case, it is not necessary for a passive scan.
+		 */
+		if (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN ||
+		    !local->scan_req->n_ssids) {
+			next_delay = IEEE80211_PASSIVE_CHANNEL_TIME;
+			break;
+		}
+
+		next_delay = IEEE80211_PROBE_DELAY;
 		local->scan_state = SCAN_SEND_PROBE;
 		break;
 	case SCAN_SEND_PROBE:
-		next_delay = IEEE80211_PASSIVE_CHANNEL_TIME;
-		local->scan_state = SCAN_SET_CHANNEL;
-
-		if (local->scan_channel->flags & IEEE80211_CHAN_PASSIVE_SCAN ||
-		    !local->scan_req->n_ssids)
-			break;
 		for (i = 0; i < local->scan_req->n_ssids; i++)
 			ieee80211_send_probe_req(
 				sdata, NULL,
 				local->scan_req->ssids[i].ssid,
 				local->scan_req->ssids[i].ssid_len,
 				local->scan_req->ie, local->scan_req->ie_len);
+
+		/*
+		 * After sending probe requests, wait for probe responses
+		 * on the channel.
+		 */
 		next_delay = IEEE80211_CHANNEL_TIME;
+		local->scan_state = SCAN_SET_CHANNEL;
 		break;
 	}
 


