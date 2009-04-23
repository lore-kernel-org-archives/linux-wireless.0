Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56639 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbZDWIdM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2009 04:33:12 -0400
Subject: [PATCH] mac80211: rename max_sleep_interval to max_sleep_period
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Kalle Valo <kalle.valo@iki.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 23 Apr 2009 10:32:36 +0200
Message-Id: <1240475556.30082.172.camel@johannes.local> (sfid-20090423_103317_372659_22EC0A8F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle points out that max_sleep_interval is somewhat confusing
because the value is measured in beacon intervals, and not in
TU. Rename it to max_sleep_period to be consistent with things
like DTIM period that are also measured in beacon intervals.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Not sure I like wakeup interval, it seems, although unlikely, that
a driver could wake up quicker than this, and often need to due to
the DTIM interval.

 include/net/mac80211.h |    4 ++--
 net/mac80211/mlme.c    |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2009-04-23 10:26:57.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2009-04-23 10:30:29.000000000 +0200
@@ -559,7 +559,7 @@ enum ieee80211_conf_changed {
  * @beacon_int: beacon interval (TODO make interface config)
  *
  * @listen_interval: listen interval in units of beacon interval
- * @max_sleep_interval: the maximum number of beacon intervals to sleep for
+ * @max_sleep_period: the maximum number of beacon intervals to sleep for
  *	before checking the beacon for a TIM bit (managed mode only); this
  *	value will be only achievable between DTIM frames, the hardware
  *	needs to check for the multicast traffic bit in DTIM beacons.
@@ -584,7 +584,7 @@ struct ieee80211_conf {
 	int beacon_int;
 	u32 flags;
 	int power_level, dynamic_ps_timeout;
-	int max_sleep_interval;
+	int max_sleep_period;
 
 	u16 listen_interval;
 	bool radio_enabled;
--- wireless-testing.orig/net/mac80211/mlme.c	2009-04-23 10:27:14.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-04-23 10:27:23.000000000 +0200
@@ -555,7 +555,7 @@ void ieee80211_recalc_ps(struct ieee8021
 				maxslp = min_t(int, dtimper,
 						    latency / beaconint_us);
 
-			local->hw.conf.max_sleep_interval = maxslp;
+			local->hw.conf.max_sleep_period = maxslp;
 			local->ps_sdata = found;
 		}
 	} else {


