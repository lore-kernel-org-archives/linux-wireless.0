Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58369 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855AbZHLUVx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 16:21:53 -0400
Subject: [PATCH] cfg80211: check for and abort dangling scan requests
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Wey-Yi W Guy <wey-yi.w.guy@intel.com>
Content-Type: text/plain
Date: Wed, 12 Aug 2009 22:21:21 +0200
Message-Id: <1250108481.26464.9.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If you trigger a scan request on an interface and then
take it down, or rmmod the module or unplug the device
the driver might "forget" to cancel the scan request.
That is a bug in the driver, but the current behaviour
is that we just hang endlessly waiting for the netdev
refcount to become 0 which it never will. To improve
robustness, check for this situation in cfg80211, warn
about it and clean up behind the driver. I don't just
clean up silently because it's likely that the driver
also has some internal state it has now leaked.

Additionally, this fixes a locking bug, clearing the
scan_req pointer should be done under the rdev lock.

Finally, we also need to _wait_ for the scan work and
not just abort it since it might be pending and wanting
to do a cleanup.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
This currently triggers if you rmmod iwlwifi while scanning, which is
how we found it. I'll look at iwlwifi next to see why it's doing this.

 net/wireless/core.c |   10 +++++++++-
 net/wireless/core.h |    1 +
 net/wireless/scan.c |   26 ++++++++++++++++----------
 3 files changed, 26 insertions(+), 11 deletions(-)

--- wireless-testing.orig/net/wireless/core.c	2009-08-12 21:56:24.000000000 +0200
+++ wireless-testing/net/wireless/core.c	2009-08-12 22:19:52.000000000 +0200
@@ -601,8 +601,8 @@ void wiphy_unregister(struct wiphy *wiph
 
 	mutex_unlock(&cfg80211_mutex);
 
+	flush_work(&rdev->scan_done_wk);
 	cancel_work_sync(&rdev->conn_work);
-	cancel_work_sync(&rdev->scan_done_wk);
 	kfree(rdev->scan_req);
 	flush_work(&rdev->event_work);
 }
@@ -728,6 +728,13 @@ static int cfg80211_netdev_notifier_call
 #endif
 		break;
 	case NETDEV_UNREGISTER:
+		cfg80211_lock_rdev(rdev);
+
+		if (WARN_ON(rdev->scan_req && rdev->scan_req->dev == dev)) {
+			rdev->scan_req->aborted = true;
+			___cfg80211_scan_done(rdev);
+		}
+
 		mutex_lock(&rdev->devlist_mtx);
 		/*
 		 * It is possible to get NETDEV_UNREGISTER
@@ -746,6 +753,7 @@ static int cfg80211_netdev_notifier_call
 #endif
 		}
 		mutex_unlock(&rdev->devlist_mtx);
+		cfg80211_unlock_rdev(rdev);
 		break;
 	case NETDEV_PRE_UP:
 		if (!(wdev->wiphy->interface_modes & BIT(wdev->iftype)))
--- wireless-testing.orig/net/wireless/scan.c	2009-08-12 21:55:09.000000000 +0200
+++ wireless-testing/net/wireless/scan.c	2009-08-12 22:08:48.000000000 +0200
@@ -18,19 +18,14 @@
 
 #define IEEE80211_SCAN_RESULT_EXPIRE	(15 * HZ)
 
-void __cfg80211_scan_done(struct work_struct *wk)
+void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev)
 {
-	struct cfg80211_registered_device *rdev;
 	struct cfg80211_scan_request *request;
 	struct net_device *dev;
 #ifdef CONFIG_WIRELESS_EXT
 	union iwreq_data wrqu;
 #endif
 
-	rdev = container_of(wk, struct cfg80211_registered_device,
-			    scan_done_wk);
-
-	mutex_lock(&rdev->mtx);
 	request = rdev->scan_req;
 
 	dev = request->dev;
@@ -43,9 +38,9 @@ void __cfg80211_scan_done(struct work_st
 	cfg80211_sme_scan_done(dev);
 
 	if (request->aborted)
-		nl80211_send_scan_aborted(wiphy_to_dev(request->wiphy), dev);
+		nl80211_send_scan_aborted(rdev, dev);
 	else
-		nl80211_send_scan_done(wiphy_to_dev(request->wiphy), dev);
+		nl80211_send_scan_done(rdev, dev);
 
 #ifdef CONFIG_WIRELESS_EXT
 	if (!request->aborted) {
@@ -57,11 +52,22 @@ void __cfg80211_scan_done(struct work_st
 
 	dev_put(dev);
 
-	cfg80211_unlock_rdev(rdev);
-	wiphy_to_dev(request->wiphy)->scan_req = NULL;
+	rdev->scan_req = NULL;
 	kfree(request);
 }
 
+void __cfg80211_scan_done(struct work_struct *wk)
+{
+	struct cfg80211_registered_device *rdev;
+
+	rdev = container_of(wk, struct cfg80211_registered_device,
+			    scan_done_wk);
+
+	cfg80211_lock_rdev(rdev);
+	___cfg80211_scan_done(rdev);
+	cfg80211_unlock_rdev(rdev);
+}
+
 void cfg80211_scan_done(struct cfg80211_scan_request *request, bool aborted)
 {
 	WARN_ON(request != wiphy_to_dev(request->wiphy)->scan_req);
--- wireless-testing.orig/net/wireless/core.h	2009-08-12 22:00:57.000000000 +0200
+++ wireless-testing/net/wireless/core.h	2009-08-12 22:01:19.000000000 +0200
@@ -368,6 +368,7 @@ void cfg80211_sme_scan_done(struct net_d
 void cfg80211_sme_rx_auth(struct net_device *dev, const u8 *buf, size_t len);
 void cfg80211_sme_disassoc(struct net_device *dev, int idx);
 void __cfg80211_scan_done(struct work_struct *wk);
+void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev);
 void cfg80211_upload_connect_keys(struct wireless_dev *wdev);
 
 struct ieee80211_channel *


