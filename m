Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50394 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbZHYOe3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2009 10:34:29 -0400
Subject: [PATCH] mac80211: fix scan cancel on ifdown
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 25 Aug 2009 16:33:47 +0200
Message-Id: <1251210827.10667.6.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When an interface is taken down while a scan is
pending -- i.e. a scan request was accepted but
not yet acted upon due to other work being in
progress -- we currently do not properly cancel
that scan and end up getting stuck. Fix this by
doing better checks when an interface is taken
down.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/iface.c |   26 ++------------------------
 net/mac80211/scan.c  |    9 ++++++---
 2 files changed, 8 insertions(+), 27 deletions(-)

--- wireless-testing.orig/net/mac80211/iface.c	2009-08-25 14:39:06.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2009-08-25 14:39:42.000000000 +0200
@@ -497,30 +497,8 @@ static int ieee80211_stop(struct net_dev
 		}
 		/* fall through */
 	default:
-		if (local->scan_sdata == sdata) {
-			if (!local->ops->hw_scan)
-				cancel_delayed_work_sync(&local->scan_work);
-			/*
-			 * The software scan can no longer run now, so we can
-			 * clear out the scan_sdata reference. However, the
-			 * hardware scan may still be running. The complete
-			 * function must be prepared to handle a NULL value.
-			 */
-			local->scan_sdata = NULL;
-			/*
-			 * The memory barrier guarantees that another CPU
-			 * that is hardware-scanning will now see the fact
-			 * that this interface is gone.
-			 */
-			smp_mb();
-			/*
-			 * If software scanning, complete the scan but since
-			 * the scan_sdata is NULL already don't send out a
-			 * scan event to userspace -- the scan is incomplete.
-			 */
-			if (test_bit(SCAN_SW_SCANNING, &local->scanning))
-				ieee80211_scan_completed(&local->hw, true);
-		}
+		if (local->scan_sdata == sdata)
+			ieee80211_scan_cancel(local);
 
 		/*
 		 * Disable beaconing for AP and mesh, IBSS can't
--- wireless-testing.orig/net/mac80211/scan.c	2009-08-25 14:37:44.000000000 +0200
+++ wireless-testing/net/mac80211/scan.c	2009-08-25 15:50:07.000000000 +0200
@@ -280,6 +280,7 @@ void ieee80211_scan_completed(struct iee
 	if (local->scan_req != local->int_scan_req)
 		cfg80211_scan_done(local->scan_req, aborted);
 	local->scan_req = NULL;
+	local->scan_sdata = NULL;
 
 	was_hw_scan = test_bit(SCAN_HW_SCANNING, &local->scanning);
 	local->scanning = 0;
@@ -660,6 +661,7 @@ void ieee80211_scan_work(struct work_str
 		int rc;
 
 		local->scan_req = NULL;
+		local->scan_sdata = NULL;
 
 		rc = __ieee80211_start_scan(sdata, req);
 		mutex_unlock(&local->scan_mtx);
@@ -742,7 +744,7 @@ int ieee80211_request_internal_scan(stru
 
 void ieee80211_scan_cancel(struct ieee80211_local *local)
 {
-	bool swscan;
+	bool abortscan;
 
 	cancel_delayed_work_sync(&local->scan_work);
 
@@ -751,9 +753,10 @@ void ieee80211_scan_cancel(struct ieee80
 	 * queued -- mostly at suspend under RTNL.
 	 */
 	mutex_lock(&local->scan_mtx);
-	swscan = test_bit(SCAN_SW_SCANNING, &local->scanning);
+	abortscan = test_bit(SCAN_SW_SCANNING, &local->scanning) ||
+		    (!local->scanning && local->scan_req);
 	mutex_unlock(&local->scan_mtx);
 
-	if (swscan)
+	if (abortscan)
 		ieee80211_scan_completed(&local->hw, true);
 }


