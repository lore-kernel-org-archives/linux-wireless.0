Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:57069 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755723AbZB0Wd7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 17:33:59 -0500
Date: Fri, 27 Feb 2009 16:33:55 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Fix quality reporting for wireless stats
Message-ID: <49a86a53.3+PnF81exQpFCL0K%Larry.Finger@lwfinger.net> (sfid-20090227_233402_535445_19EC40B9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

Since commit 708c57cf1709fb95 "mac80211/cfg80211: move iwrange handler to 
cfg80211", the results for link quality from "iwlist scan" and "iwconfig"
commands have been very different. The results are now consistent.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Reported- and tested-by: Larry Finger <larry.finger@lwfinger.net>
---

John,

This is 2.6.30 material.

Larry
---

 net/mac80211/wext.c |   58 ++++++++++++++++++++++++++++++++++------------------
 1 file changed, 39 insertions(+), 19 deletions(-)

--- wireless-testing.orig/net/mac80211/wext.c	2009-02-27 18:28:24.000000000 +0100
+++ wireless-testing/net/mac80211/wext.c	2009-02-27 18:45:17.000000000 +0100
@@ -886,21 +886,6 @@ static int ieee80211_ioctl_siwauth(struc
 	return ret;
 }
 
-static u8 ieee80211_get_wstats_flags(struct ieee80211_local *local)
-{
-	u8 wstats_flags = 0;
-
-	wstats_flags |= local->hw.flags & (IEEE80211_HW_SIGNAL_UNSPEC |
-					   IEEE80211_HW_SIGNAL_DBM) ?
-				IW_QUAL_QUAL_UPDATED : IW_QUAL_QUAL_INVALID;
-	wstats_flags |= local->hw.flags & IEEE80211_HW_NOISE_DBM ?
-				IW_QUAL_NOISE_UPDATED : IW_QUAL_NOISE_INVALID;
-	if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
-		wstats_flags |= IW_QUAL_DBM;
-
-	return wstats_flags;
-}
-
 /* Get wireless statistics.  Called by /proc/net/wireless and by SIOCGIWSTATS */
 static struct iw_statistics *ieee80211_get_wireless_stats(struct net_device *dev)
 {
@@ -922,10 +907,45 @@ static struct iw_statistics *ieee80211_g
 		wstats->qual.noise = 0;
 		wstats->qual.updated = IW_QUAL_ALL_INVALID;
 	} else {
-		wstats->qual.level = sta->last_signal;
-		wstats->qual.qual = sta->last_qual;
-		wstats->qual.noise = sta->last_noise;
-		wstats->qual.updated = ieee80211_get_wstats_flags(local);
+		wstats->qual.updated = 0;
+		/*
+		 * mirror what cfg80211 does for iwrange/scan results,
+		 * otherwise userspace gets confused.
+		 */
+		if (local->hw.flags & (IEEE80211_HW_SIGNAL_UNSPEC |
+				       IEEE80211_HW_SIGNAL_DBM)) {
+			wstats->qual.updated |= IW_QUAL_LEVEL_UPDATED;
+			wstats->qual.updated |= IW_QUAL_QUAL_UPDATED;
+		} else {
+			wstats->qual.updated |= IW_QUAL_LEVEL_INVALID;
+			wstats->qual.updated |= IW_QUAL_QUAL_INVALID;
+		}
+
+		if (local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC) {
+			wstats->qual.level = sta->last_signal;
+			wstats->qual.qual = sta->last_signal;
+		} else if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM) {
+			int sig = sta->last_signal;
+
+			wstats->qual.updated |= IW_QUAL_DBM;
+			wstats->qual.level = sig;
+			if (sig < -110)
+				sig = -110;
+			else if (sig > -40)
+				sig = -40;
+			wstats->qual.qual = sig + 110;
+		}
+
+		if (local->hw.flags & IEEE80211_HW_NOISE_DBM) {
+			/*
+			 * This assumes that if driver reports noise, it also
+			 * reports signal in dBm.
+			 */
+			wstats->qual.noise = sta->last_noise;
+			wstats->qual.updated |= IW_QUAL_NOISE_UPDATED;
+		} else {
+			wstats->qual.updated |= IW_QUAL_NOISE_INVALID;
+		}
 	}
 
 	rcu_read_unlock();



