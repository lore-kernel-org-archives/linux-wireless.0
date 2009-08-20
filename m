Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39486 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbZHTTgR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2009 15:36:17 -0400
Subject: [PATCH v2] cfg80211: check lost scans later, fix bug
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
In-Reply-To: <1250794011.9307.8.camel@johannes.local>
References: <1250794011.9307.8.camel@johannes.local>
Content-Type: text/plain
Date: Thu, 20 Aug 2009 21:36:16 +0200
Message-Id: <1250796976.11138.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we lose a scan, cfg80211 tries to clean up after
the driver. However, it currently does this too early,
it does this in GOING_DOWN already instead of DOWN, so
it may happen with mac80211. Besides fixing this, also
make it more robust by leaking the scan request so if
the driver later actually finishes the scan, it won't
crash. Also check in ___cfg80211_scan_done whether a
scan request is still pending and exit if not.

Reported-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Tested-by: Felix Fietkau <nbd@openwrt.org>
---
 net/wireless/core.c |    4 +++-
 net/wireless/core.h |    2 +-
 net/wireless/scan.c |   21 ++++++++++++++++++---
 3 files changed, 22 insertions(+), 5 deletions(-)

--- wireless-testing.orig/net/wireless/core.c	2009-08-20 20:29:10.000000000 +0200
+++ wireless-testing/net/wireless/core.c	2009-08-20 20:29:12.000000000 +0200
@@ -662,7 +662,7 @@ static void wdev_cleanup_work(struct wor
 
 	if (WARN_ON(rdev->scan_req && rdev->scan_req->dev == wdev->netdev)) {
 		rdev->scan_req->aborted = true;
-		___cfg80211_scan_done(rdev);
+		___cfg80211_scan_done(rdev, true);
 	}
 
 	cfg80211_unlock_rdev(rdev);
@@ -753,6 +753,8 @@ static int cfg80211_netdev_notifier_call
 		default:
 			break;
 		}
+		break;
+	case NETDEV_DOWN:
 		dev_hold(dev);
 		schedule_work(&wdev->cleanup_work);
 		break;
--- wireless-testing.orig/net/wireless/core.h	2009-08-20 20:29:10.000000000 +0200
+++ wireless-testing/net/wireless/core.h	2009-08-20 20:29:12.000000000 +0200
@@ -370,7 +370,7 @@ void cfg80211_sme_scan_done(struct net_d
 void cfg80211_sme_rx_auth(struct net_device *dev, const u8 *buf, size_t len);
 void cfg80211_sme_disassoc(struct net_device *dev, int idx);
 void __cfg80211_scan_done(struct work_struct *wk);
-void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev);
+void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak);
 void cfg80211_upload_connect_keys(struct wireless_dev *wdev);
 
 struct ieee80211_channel *
--- wireless-testing.orig/net/wireless/scan.c	2009-08-20 20:29:10.000000000 +0200
+++ wireless-testing/net/wireless/scan.c	2009-08-20 21:34:56.000000000 +0200
@@ -18,7 +18,7 @@
 
 #define IEEE80211_SCAN_RESULT_EXPIRE	(15 * HZ)
 
-void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev)
+void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak)
 {
 	struct cfg80211_scan_request *request;
 	struct net_device *dev;
@@ -26,8 +26,13 @@ void ___cfg80211_scan_done(struct cfg802
 	union iwreq_data wrqu;
 #endif
 
+	ASSERT_RDEV_LOCK(rdev);
+
 	request = rdev->scan_req;
 
+	if (!request)
+		return;
+
 	dev = request->dev;
 
 	/*
@@ -53,7 +58,17 @@ void ___cfg80211_scan_done(struct cfg802
 	dev_put(dev);
 
 	rdev->scan_req = NULL;
-	kfree(request);
+
+	/*
+	 * OK. If this is invoked with "leak" then we can't
+	 * free this ... but we've cleaned it up anyway. The
+	 * driver failed to call the scan_done callback, so
+	 * all bets are off, it might still be trying to use
+	 * the scan request or not ... if it accesses the dev
+	 * in there (it shouldn't anyway) then it may crash.
+	 */
+	if (!leak)
+		kfree(request);
 }
 
 void __cfg80211_scan_done(struct work_struct *wk)
@@ -64,7 +79,7 @@ void __cfg80211_scan_done(struct work_st
 			    scan_done_wk);
 
 	cfg80211_lock_rdev(rdev);
-	___cfg80211_scan_done(rdev);
+	___cfg80211_scan_done(rdev, false);
 	cfg80211_unlock_rdev(rdev);
 }
 


