Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50161 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbYIJWJZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 18:09:25 -0400
Message-Id: <20080910220414.322392000@sipsolutions.net> (sfid-20080911_000927_715472_C90291FE)
References: <20080910220145.707263000@sipsolutions.net>
Date: Thu, 11 Sep 2008 00:01:51 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 06/18] mac80211: fix scan vs. interface removal race
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we remove an interface, we can currently end up having
a pointer to it left in local->scan_sdata after it has been
set down, and then with a hardware scan the scan completion
can try to access it which is a bug. Alternatively, a scan
that started as a hardware scan may terminate as though it
was a software scan, if the timing is just right.

On SMP systems, software scan also has a similar problem,
just canceling the delayed work and setting a flag isn't
enough since it may be running concurrently; in this case
we would also never restore state of other interfaces.

This patch hopefully fixes the problems by always invoking
ieee80211_scan_completed or requiring it to be invoked by
the driver, I suspect the drivers that have ->hw_scan() are
buggy. The bug will not manifest itself unless you remove
the interface while hw-scanning which will also turn off
the hw, and then add a new interface which will be unusable
until you scan once.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h |    4 +++-
 net/mac80211/main.c    |   33 +++++++++++++++++++++++++--------
 net/mac80211/mlme.c    |    2 +-
 net/mac80211/scan.c    |   38 +++++++++++++++++++++++++++-----------
 4 files changed, 56 insertions(+), 21 deletions(-)

--- everything.orig/net/mac80211/main.c	2008-09-10 23:57:57.000000000 +0200
+++ everything/net/mac80211/main.c	2008-09-10 23:57:58.000000000 +0200
@@ -564,14 +564,6 @@ static int ieee80211_stop(struct net_dev
 		synchronize_rcu();
 		skb_queue_purge(&sdata->u.sta.skb_queue);
 
-		if (local->scan_sdata == sdata) {
-			if (!local->ops->hw_scan) {
-				local->sta_sw_scanning = 0;
-				cancel_delayed_work(&local->scan_work);
-			} else
-				local->sta_hw_scanning = 0;
-		}
-
 		sdata->u.sta.flags &= ~IEEE80211_STA_PRIVACY_INVOKED;
 		kfree(sdata->u.sta.extra_ie);
 		sdata->u.sta.extra_ie = NULL;
@@ -585,6 +577,31 @@ static int ieee80211_stop(struct net_dev
 		}
 		/* fall through */
 	default:
+		if (local->scan_sdata == sdata) {
+			if (!local->ops->hw_scan)
+				cancel_delayed_work_sync(&local->scan_work);
+			/*
+			 * The software scan can no longer run now, so we can
+			 * clear out the scan_sdata reference. However, the
+			 * hardware scan may still be running. The complete
+			 * function must be prepared to handle a NULL value.
+			 */
+			local->scan_sdata = NULL;
+			/*
+			 * The memory barrier guarantees that another CPU
+			 * that is hardware-scanning will now see the fact
+			 * that this interface is gone.
+			 */
+			smp_mb();
+			/*
+			 * If software scanning, complete the scan but since
+			 * the scan_sdata is NULL already don't send out a
+			 * scan event to userspace -- the scan is incomplete.
+			 */
+			if (local->sta_sw_scanning)
+				ieee80211_scan_completed(&local->hw);
+		}
+
 		conf.vif = &sdata->vif;
 		conf.type = sdata->vif.type;
 		conf.mac_addr = dev->dev_addr;
--- everything.orig/net/mac80211/mlme.c	2008-09-10 23:57:55.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-09-10 23:57:58.000000000 +0200
@@ -2561,7 +2561,7 @@ void ieee80211_mlme_notify_scan_complete
 	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
 	struct ieee80211_if_sta *ifsta;
 
-	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
+	if (sdata && sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
 		ifsta = &sdata->u.sta;
 		if (!(ifsta->flags & IEEE80211_STA_BSSID_SET) ||
 		    (!(ifsta->state == IEEE80211_STA_MLME_IBSS_JOINED) &&
--- everything.orig/net/mac80211/scan.c	2008-09-10 23:57:55.000000000 +0200
+++ everything/net/mac80211/scan.c	2008-09-10 23:57:58.000000000 +0200
@@ -430,9 +430,20 @@ void ieee80211_scan_completed(struct iee
 	struct ieee80211_sub_if_data *sdata;
 	union iwreq_data wrqu;
 
+	if (WARN_ON(!local->sta_hw_scanning && !local->sta_sw_scanning))
+		return;
+
 	local->last_scan_completed = jiffies;
 	memset(&wrqu, 0, sizeof(wrqu));
-	wireless_send_event(local->scan_sdata->dev, SIOCGIWSCAN, &wrqu, NULL);
+
+	/*
+	 * local->scan_sdata could have been NULLed by the interface
+	 * down code in case we were scanning on an interface that is
+	 * being taken down.
+	 */
+	sdata = local->scan_sdata;
+	if (sdata)
+		wireless_send_event(sdata->dev, SIOCGIWSCAN, &wrqu, NULL);
 
 	if (local->sta_hw_scanning) {
 		local->sta_hw_scanning = 0;
@@ -491,7 +502,10 @@ void ieee80211_sta_scan_work(struct work
 	int skip;
 	unsigned long next_delay = 0;
 
-	if (!local->sta_sw_scanning)
+	/*
+	 * Avoid re-scheduling when the sdata is going away.
+	 */
+	if (!netif_running(sdata->dev))
 		return;
 
 	switch (local->scan_state) {
@@ -570,9 +584,8 @@ void ieee80211_sta_scan_work(struct work
 		break;
 	}
 
-	if (local->sta_sw_scanning)
-		queue_delayed_work(local->hw.workqueue, &local->scan_work,
-				   next_delay);
+	queue_delayed_work(local->hw.workqueue, &local->scan_work,
+			   next_delay);
 }
 
 
@@ -609,13 +622,16 @@ int ieee80211_sta_start_scan(struct ieee
 	}
 
 	if (local->ops->hw_scan) {
-		int rc = local->ops->hw_scan(local_to_hw(local),
-					     ssid, ssid_len);
-		if (!rc) {
-			local->sta_hw_scanning = 1;
-			local->scan_sdata = scan_sdata;
+		int rc;
+
+		local->sta_hw_scanning = 1;
+		rc = local->ops->hw_scan(local_to_hw(local), ssid, ssid_len);
+		if (rc) {
+			local->sta_hw_scanning = 0;
+			return rc;
 		}
-		return rc;
+		local->scan_sdata = scan_sdata;
+		return 0;
 	}
 
 	local->sta_sw_scanning = 1;
--- everything.orig/include/net/mac80211.h	2008-09-10 23:50:28.000000000 +0200
+++ everything/include/net/mac80211.h	2008-09-10 23:57:58.000000000 +0200
@@ -1122,7 +1122,9 @@ enum ieee80211_ampdu_mlme_action {
  * @hw_scan: Ask the hardware to service the scan request, no need to start
  *	the scan state machine in stack. The scan must honour the channel
  *	configuration done by the regulatory agent in the wiphy's registered
- *	bands.
+ *	bands. When the scan finishes, ieee80211_scan_completed() must be
+ *	called; note that it also must be called when the scan cannot finish
+ *	because the hardware is turned off! Anything else is a bug!
  *
  * @get_stats: return low-level statistics
  *

-- 

