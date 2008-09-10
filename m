Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40697 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016AbYIJWTU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 18:19:20 -0400
Message-Id: <20080910220413.187494000@sipsolutions.net> (sfid-20080911_001939_805755_E17C6492)
References: <20080910220145.707263000@sipsolutions.net>
Date: Thu, 11 Sep 2008 00:01:50 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 05/18] mac80211: fix work race
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we stop an interface, the work on it may still be pending
or running. We do cancel the timer, but we do not currently
protect against the work struct. The race is very unlikely to
hit -- it'll happen only when the driver is using mac80211's
workqueue to run long-running tasks and the sta/mesh works are
delayed for quite a bit.

This patch fixes it by cancelling the work explicitly.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/main.c |    8 ++++++++
 net/mac80211/mesh.c |    9 +++++++++
 2 files changed, 17 insertions(+)

--- everything.orig/net/mac80211/main.c	2008-09-10 23:57:55.000000000 +0200
+++ everything/net/mac80211/main.c	2008-09-10 23:57:57.000000000 +0200
@@ -548,6 +548,14 @@ static int ieee80211_stop(struct net_dev
 		memset(sdata->u.sta.bssid, 0, ETH_ALEN);
 		del_timer_sync(&sdata->u.sta.timer);
 		/*
+		 * If the timer fired while we waited for it, it will have
+		 * requeued the work. Now the work will be running again
+		 * but will not rearm the timer again because it checks
+		 * whether the interface is running, which, at this point,
+		 * it no longer is.
+		 */
+		cancel_work_sync(&sdata->u.sta.work);
+		/*
 		 * When we get here, the interface is marked down.
 		 * Call synchronize_rcu() to wait for the RX path
 		 * should it be using the interface and enqueuing
--- everything.orig/net/mac80211/mesh.c	2008-09-10 23:57:55.000000000 +0200
+++ everything/net/mac80211/mesh.c	2008-09-10 23:57:57.000000000 +0200
@@ -449,6 +449,15 @@ void ieee80211_stop_mesh(struct ieee8021
 {
 	del_timer_sync(&sdata->u.mesh.housekeeping_timer);
 	/*
+	 * If the timer fired while we waited for it, it will have
+	 * requeued the work. Now the work will be running again
+	 * but will not rearm the timer again because it checks
+	 * whether the interface is running, which, at this point,
+	 * it no longer is.
+	 */
+	cancel_work_sync(&sdata->u.mesh.work);
+
+	/*
 	 * When we get here, the interface is marked down.
 	 * Call synchronize_rcu() to wait for the RX path
 	 * should it be using the interface and enqueuing

-- 

