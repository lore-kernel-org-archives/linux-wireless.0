Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33688 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175AbYA2L2X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2008 06:28:23 -0500
Subject: [PATCH] mac80211: fix scan band off-by-one error
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Bas Hulsken <bhulsken@zonnet.nl>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Stefano Brivio <stefano.brivio@polimi.it>
Content-Type: text/plain
Date: Mon, 28 Jan 2008 17:08:56 +0100
Message-Id: <1201536536.9397.12.camel@johannes.berg> (sfid-20080129_112827_401515_76E8ECEA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When checking for the next band to advance to, there
was an off-by-one error that could lead to an access
to an invalid array index. Additionally, the later
check for scan_band >= IEEE80211_NUM_BANDS is not
required since that will never be true.

This also improves the comments related to that code.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
This should fix the problem with the sband pointer access
crashing later. The next item right after the bands[]
array is a spinlock in "struct device" which happens to
be unlocked and hence, on powerpc, initialised to zero
which meant sband was NULL for me, while it's *one* on
x86 so sband is non-NULL leading to the crash.

Sorry about the mess.

 net/mac80211/ieee80211_sta.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

--- everything.orig/net/mac80211/ieee80211_sta.c	2008-01-28 16:42:03.754363986 +0100
+++ everything/net/mac80211/ieee80211_sta.c	2008-01-28 17:04:57.654297255 +0100
@@ -3223,22 +3223,28 @@ void ieee80211_sta_scan_work(struct work
 
 	switch (local->scan_state) {
 	case SCAN_SET_CHANNEL:
-		/* get current scan band */
+		/*
+		 * Get current scan band. scan_band may be IEEE80211_NUM_BANDS
+		 * after we successfully scanned the last channel of the last
+		 * band (and the last band is supported by the hw)
+		 */
 		if (local->scan_band < IEEE80211_NUM_BANDS)
 			sband = local->hw.wiphy->bands[local->scan_band];
 		else
 			sband = NULL;
 
-		/* if we started at an unsupported one, advance */
-		while (!sband && local->scan_band < IEEE80211_NUM_BANDS) {
+		/*
+		 * If we are at an unsupported band and have more bands
+		 * left to scan, advance to the next supported one.
+		 */
+		while (!sband && local->scan_band < IEEE80211_NUM_BANDS - 1) {
 			local->scan_band++;
 			sband = local->hw.wiphy->bands[local->scan_band];
 			local->scan_channel_idx = 0;
 		}
 
-		if (!sband ||
-		    (local->scan_channel_idx >= sband->n_channels &&
-		     local->scan_band >= IEEE80211_NUM_BANDS)) {
+		/* if no more bands/channels left, complete scan */
+		if (!sband || local->scan_channel_idx >= sband->n_channels) {
 			ieee80211_scan_completed(local_to_hw(local));
 			return;
 		}
@@ -3260,8 +3266,14 @@ void ieee80211_sta_scan_work(struct work
 			}
 		}
 
+		/* advance state machine to next channel/band */
 		local->scan_channel_idx++;
 		if (local->scan_channel_idx >= sband->n_channels) {
+			/*
+			 * scan_band may end up == IEEE80211_NUM_BANDS, but
+			 * we'll catch that case above and complete the scan
+			 * if that is the case.
+			 */
 			local->scan_band++;
 			local->scan_channel_idx = 0;
 		}


