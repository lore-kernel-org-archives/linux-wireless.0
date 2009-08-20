Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36313 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146AbZHTSCW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2009 14:02:22 -0400
Subject: [PATCH v2] mac80211: fix configure_filter invocation after stop
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1250790381.9307.5.camel@johannes.local>
References: <1250790381.9307.5.camel@johannes.local>
Content-Type: text/plain
Date: Thu, 20 Aug 2009 20:02:20 +0200
Message-Id: <1250791340.9307.6.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since configure_filter can sleep now, any multicast
configuration needed to be postponed to a work struct.
This, however, lead to a problem that we could queue
the work, stop the device and then afterwards invoke
configure_filter which may lead to driver hangs and is
a bug. To fix this, we can just cancel the filter work
since it's unnecessary to do after stopping the hw.

Since there are various places that call drv_stop, and
two of them do very similar things, the code for them
can be put into a shared function at the same time.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Reported-by: Lennert Buytenhek <buytenh@wantstofly.org>
---
messed up with quilt in v1

 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/iface.c       |    6 +-----
 net/mac80211/pm.c          |   13 ++-----------
 net/mac80211/util.c        |   10 ++++++++++
 4 files changed, 14 insertions(+), 16 deletions(-)

--- wireless-testing.orig/net/mac80211/pm.c	2009-08-20 20:01:01.000000000 +0200
+++ wireless-testing/net/mac80211/pm.c	2009-08-20 20:01:14.000000000 +0200
@@ -107,17 +107,8 @@ int __ieee80211_suspend(struct ieee80211
 	}
 
 	/* stop hardware - this must stop RX */
-	if (local->open_count) {
-		ieee80211_led_radio(local, false);
-		drv_stop(local);
-	}
-
-	/*
-	 * flush again, in case driver queued work -- it
-	 * shouldn't be doing (or cancel everything in the
-	 * stop callback) that but better safe than sorry.
-	 */
-	flush_workqueue(local->workqueue);
+	if (local->open_count)
+		ieee80211_stop_device(local);
 
 	local->suspended = true;
 	/* need suspended to be visible before quiescing is false */
--- wireless-testing.orig/net/mac80211/iface.c	2009-08-20 20:00:35.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2009-08-20 20:01:14.000000000 +0200
@@ -552,11 +552,7 @@ static int ieee80211_stop(struct net_dev
 	ieee80211_recalc_ps(local, -1);
 
 	if (local->open_count == 0) {
-		drv_stop(local);
-
-		ieee80211_led_radio(local, false);
-
-		flush_workqueue(local->workqueue);
+		ieee80211_stop_device(local);
 
 		tasklet_disable(&local->tx_pending_tasklet);
 		tasklet_disable(&local->tasklet);
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-08-20 20:00:35.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-08-20 20:01:14.000000000 +0200
@@ -1078,6 +1078,7 @@ void ieee80211_process_measurement_req(s
 
 /* Suspend/resume and hw reconfiguration */
 int ieee80211_reconfig(struct ieee80211_local *local);
+void ieee80211_stop_device(struct ieee80211_local *local);
 
 #ifdef CONFIG_PM
 int __ieee80211_suspend(struct ieee80211_hw *hw);
--- wireless-testing.orig/net/mac80211/util.c	2009-08-20 20:00:35.000000000 +0200
+++ wireless-testing/net/mac80211/util.c	2009-08-20 20:01:14.000000000 +0200
@@ -1007,6 +1007,16 @@ u32 ieee80211_sta_get_rates(struct ieee8
 	return supp_rates;
 }
 
+void ieee80211_stop_device(struct ieee80211_local *local)
+{
+	ieee80211_led_radio(local, false);
+
+	cancel_work_sync(&local->reconfig_filter);
+	drv_stop(local);
+
+	flush_workqueue(local->workqueue);
+}
+
 int ieee80211_reconfig(struct ieee80211_local *local)
 {
 	struct ieee80211_hw *hw = &local->hw;


