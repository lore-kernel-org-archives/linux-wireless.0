Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54787 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379AbZGMLXo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2009 07:23:44 -0400
Subject: [PATCH] mac80211: cancel the connection monitor timers/work
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 13 Jul 2009 13:23:39 +0200
Message-Id: <1247484220.4166.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In "mac80211: monitor the connection" I forgot to
add code to cancel the new timers & work when the
interface is brought down, which isn't a problem
if you just bring it down, but _is_ a problem when
you destroy the interface. Correct this lapse.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Fixes http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=2044

 net/mac80211/iface.c |    8 +++++---
 net/mac80211/mlme.c  |    3 +++
 2 files changed, 8 insertions(+), 3 deletions(-)

--- wireless-testing.orig/net/mac80211/iface.c	2009-07-13 13:02:51.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2009-07-13 13:02:53.000000000 +0200
@@ -451,16 +451,18 @@ static int ieee80211_stop(struct net_dev
 	case NL80211_IFTYPE_STATION:
 		del_timer_sync(&sdata->u.mgd.chswitch_timer);
 		del_timer_sync(&sdata->u.mgd.timer);
+		del_timer_sync(&sdata->u.mgd.conn_mon_timer);
+		del_timer_sync(&sdata->u.mgd.bcn_mon_timer);
 		/*
-		 * If the timer fired while we waited for it, it will have
-		 * requeued the work. Now the work will be running again
+		 * If any of the timers fired while we waited for it, it will
+		 * have queued its work. Now the work will be running again
 		 * but will not rearm the timer again because it checks
 		 * whether the interface is running, which, at this point,
 		 * it no longer is.
 		 */
 		cancel_work_sync(&sdata->u.mgd.work);
 		cancel_work_sync(&sdata->u.mgd.chswitch_work);
-
+		cancel_work_sync(&sdata->u.mgd.monitor_work);
 		cancel_work_sync(&sdata->u.mgd.beacon_loss_work);
 
 		/*
--- wireless-testing.orig/net/mac80211/mlme.c	2009-07-13 13:02:51.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-07-13 13:02:53.000000000 +0200
@@ -1163,6 +1163,9 @@ static void ieee80211_mgd_probe_ap(struc
 	const u8 *ssid;
 	bool already = false;
 
+	if (!netif_running(sdata->dev))
+		return;
+
 	mutex_lock(&ifmgd->mtx);
 
 	if (!ifmgd->associated)


