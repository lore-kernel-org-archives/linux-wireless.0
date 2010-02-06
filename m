Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:53889 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755668Ab0BFNUi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Feb 2010 08:20:38 -0500
Received: by ewy28 with SMTP id 28so944897ewy.28
        for <linux-wireless@vger.kernel.org>; Sat, 06 Feb 2010 05:20:37 -0800 (PST)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: holgerschurig@gmail.com, sameo@linux.intel.com, dcbw@redhat.com,
	David Kilroy <kilroyd@googlemail.com>
Subject: [RFC 1/2] cfg80211: generic trigger scan and callback on completion
Date: Sat,  6 Feb 2010 13:20:15 +0000
Message-Id: <1265462416-7547-2-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1265462416-7547-1-git-send-email-kilroyd@googlemail.com>
References: <1265462416-7547-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cfg80211 SME already has a hook for it's own callback, so we hook this
into the new mechanism.

We could maintain a list of functions to call, but this isn't necessary
for the moment. Just maintain the single function pointer to be called
on scan completion.

Note that we allow the caller to set the callback even when a scan is
already in progress. This allows cfg80211 SME to scan again
when the existing scan completes.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 net/wireless/core.h |    6 ++++++
 net/wireless/scan.c |   36 +++++++++++++++++++++++++++++++++++-
 net/wireless/sme.c  |   20 +++++---------------
 3 files changed, 46 insertions(+), 16 deletions(-)

diff --git a/net/wireless/core.h b/net/wireless/core.h
index c326a66..7e0112f 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -63,6 +63,8 @@ struct cfg80211_registered_device {
 	unsigned long suspend_at;
 	struct work_struct scan_done_wk;
 
+	void (*async_scan_cb)(struct net_device *);
+
 #ifdef CONFIG_NL80211_TESTMODE
 	struct genl_info *testmode_info;
 #endif
@@ -372,6 +374,10 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 			  struct net_device *dev, enum nl80211_iftype ntype,
 			  u32 *flags, struct vif_params *params);
 void cfg80211_process_rdev_events(struct cfg80211_registered_device *rdev);
+int cfg80211_async_scan(struct wireless_dev *wdev,
+			struct cfg80211_scan_request *request,
+			bool set_cb_on_busy,
+			void (*cb)(struct net_device *));
 
 struct ieee80211_channel *
 rdev_fixed_channel(struct cfg80211_registered_device *rdev,
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 978cac3..e3d0957 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -40,7 +40,10 @@ void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak)
 	 * Otherwise, wpa_supplicant gets completely confused with
 	 * wext events.
 	 */
-	cfg80211_sme_scan_done(dev);
+	if (rdev->async_scan_cb) {
+		rdev->async_scan_cb(dev);
+		rdev->async_scan_cb = NULL;
+	}
 
 	if (request->aborted)
 		nl80211_send_scan_aborted(rdev, dev);
@@ -655,6 +658,37 @@ void cfg80211_unlink_bss(struct wiphy *wiphy, struct cfg80211_bss *pub)
 }
 EXPORT_SYMBOL(cfg80211_unlink_bss);
 
+/* Do a scan, and schedule a callback to be run on completion. */
+int cfg80211_async_scan(struct wireless_dev *wdev,
+			struct cfg80211_scan_request *request,
+			bool set_cb_on_busy,
+			void (*cb)(struct net_device *))
+{
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	int err;
+
+	ASSERT_RDEV_LOCK(rdev);
+
+	if (rdev->scan_req) {
+		if (set_cb_on_busy)
+			rdev->async_scan_cb = cb;
+		return -EBUSY;
+	}
+
+	rdev->scan_req = request;
+	rdev->async_scan_cb = cb;
+
+	err = rdev->ops->scan(wdev->wiphy, wdev->netdev, request);
+	if (!err) {
+		nl80211_send_scan_start(rdev, wdev->netdev);
+		dev_hold(wdev->netdev);
+	} else {
+		rdev->scan_req = NULL;
+	}
+
+	return err;
+}
+
 #ifdef CONFIG_CFG80211_WEXT
 int cfg80211_wext_siwscan(struct net_device *dev,
 			  struct iw_request_info *info,
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 17fde0d..2ef83b7 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -75,17 +75,12 @@ static DECLARE_WORK(cfg80211_disconnect_work, disconnect_work);
 
 static int cfg80211_conn_scan(struct wireless_dev *wdev)
 {
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
 	struct cfg80211_scan_request *request;
 	int n_channels, err;
 
 	ASSERT_RTNL();
-	ASSERT_RDEV_LOCK(rdev);
 	ASSERT_WDEV_LOCK(wdev);
 
-	if (rdev->scan_req)
-		return -EBUSY;
-
 	if (wdev->conn->params.channel) {
 		n_channels = 1;
 	} else {
@@ -128,19 +123,14 @@ static int cfg80211_conn_scan(struct wireless_dev *wdev)
 	request->ssids[0].ssid_len = wdev->conn->params.ssid_len;
 
 	request->dev = wdev->netdev;
-	request->wiphy = &rdev->wiphy;
-
-	rdev->scan_req = request;
+	request->wiphy = wdev->wiphy;
 
-	err = rdev->ops->scan(wdev->wiphy, wdev->netdev, request);
-	if (!err) {
+	err = cfg80211_async_scan(wdev, request, true, cfg80211_sme_scan_done);
+	if (!err)
 		wdev->conn->state = CFG80211_CONN_SCANNING;
-		nl80211_send_scan_start(rdev, wdev->netdev);
-		dev_hold(wdev->netdev);
-	} else {
-		rdev->scan_req = NULL;
+	else
 		kfree(request);
-	}
+
 	return err;
 }
 
-- 
1.6.4.4

