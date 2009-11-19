Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42701 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbZKSLqJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2009 06:46:09 -0500
Subject: [PATCH] mac80211: avoid spurious deauth frames/messages
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Nov 2009 12:45:42 +0100
Message-ID: <1258631142.7094.6.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With WEXT, it happens frequently that the SME
requests an authentication but then deauthenticates
right away because some new parameters came along.
Every time this happens we print a deauth message
and send a deauth frame, but both of that is rather
confusing. Avoid it by aborting the authentication
process silently, and telling cfg80211 about that.

The patch looks larger than it really is:
__cfg80211_auth_remove() is split out from
cfg80211_send_auth_timeout(), there's no new code
except __cfg80211_auth_canceled() (a one-liner) and
the mac80211 bits (7 new lines of code).

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/cfg80211.h |   12 ++++++++++++
 net/mac80211/mlme.c    |   17 +++++++++++++++++
 net/wireless/mlme.c    |   36 +++++++++++++++++++++++++-----------
 3 files changed, 54 insertions(+), 11 deletions(-)

--- wireless-testing.orig/include/net/cfg80211.h	2009-11-19 12:24:42.000000000 +0100
+++ wireless-testing/include/net/cfg80211.h	2009-11-19 12:26:13.000000000 +0100
@@ -1839,6 +1839,18 @@ void cfg80211_send_rx_auth(struct net_de
 void cfg80211_send_auth_timeout(struct net_device *dev, const u8 *addr);
 
 /**
+ * __cfg80211_auth_canceled - notify cfg80211 that authentication was canceled
+ * @dev: network device
+ * @addr: The MAC address of the device with which the authentication timed out
+ *
+ * When a pending authentication had no action yet, the driver may decide
+ * to not send a deauth frame, but in that case must calls this function
+ * to tell cfg80211 about this decision. It is only valid to call this
+ * function within the deauth() callback.
+ */
+void __cfg80211_auth_canceled(struct net_device *dev, const u8 *addr);
+
+/**
  * cfg80211_send_rx_assoc - notification of processed association
  * @dev: network device
  * @buf: (re)association response frame (header + body)
--- wireless-testing.orig/net/mac80211/mlme.c	2009-11-19 12:08:36.000000000 +0100
+++ wireless-testing/net/mac80211/mlme.c	2009-11-19 12:36:14.000000000 +0100
@@ -2508,6 +2508,7 @@ int ieee80211_mgd_deauth(struct ieee8021
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_mgd_work *wk;
 	const u8 *bssid = NULL;
+	bool not_auth_yet = false;
 
 	mutex_lock(&ifmgd->mtx);
 
@@ -2517,6 +2518,8 @@ int ieee80211_mgd_deauth(struct ieee8021
 	} else list_for_each_entry(wk, &ifmgd->work_list, list) {
 		if (&wk->bss->cbss == req->bss) {
 			bssid = req->bss->bssid;
+			if (wk->state == IEEE80211_MGD_STATE_PROBE)
+				not_auth_yet = true;
 			list_del(&wk->list);
 			kfree(wk);
 			break;
@@ -2524,6 +2527,20 @@ int ieee80211_mgd_deauth(struct ieee8021
 	}
 
 	/*
+	 * If somebody requests authentication and we haven't
+	 * sent out an auth frame yet there's no need to send
+	 * out a deauth frame either. If the state was PROBE,
+	 * then this is the case. If it's AUTH we have sent a
+	 * frame, and if it's IDLE we have completed the auth
+	 * process already.
+	 */
+	if (not_auth_yet) {
+		mutex_unlock(&ifmgd->mtx);
+		__cfg80211_auth_canceled(sdata->dev, bssid);
+		return 0;
+	}
+
+	/*
 	 * cfg80211 should catch this ... but it's racy since
 	 * we can receive a deauth frame, process it, hand it
 	 * to cfg80211 while that's in a locked section already
--- wireless-testing.orig/net/wireless/mlme.c	2009-11-19 12:22:36.000000000 +0100
+++ wireless-testing/net/wireless/mlme.c	2009-11-19 12:24:29.000000000 +0100
@@ -243,21 +243,12 @@ void cfg80211_send_disassoc(struct net_d
 }
 EXPORT_SYMBOL(cfg80211_send_disassoc);
 
-void cfg80211_send_auth_timeout(struct net_device *dev, const u8 *addr)
+static void __cfg80211_auth_remove(struct wireless_dev *wdev, const u8 *addr)
 {
-	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct wiphy *wiphy = wdev->wiphy;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 	int i;
 	bool done = false;
 
-	wdev_lock(wdev);
-
-	nl80211_send_auth_timeout(rdev, dev, addr, GFP_KERNEL);
-	if (wdev->sme_state == CFG80211_SME_CONNECTING)
-		__cfg80211_connect_result(dev, addr, NULL, 0, NULL, 0,
-					  WLAN_STATUS_UNSPECIFIED_FAILURE,
-					  false, NULL);
+	ASSERT_WDEV_LOCK(wdev);
 
 	for (i = 0; addr && i < MAX_AUTH_BSSES; i++) {
 		if (wdev->authtry_bsses[i] &&
@@ -272,6 +263,29 @@ void cfg80211_send_auth_timeout(struct n
 	}
 
 	WARN_ON(!done);
+}
+
+void __cfg80211_auth_canceled(struct net_device *dev, const u8 *addr)
+{
+	__cfg80211_auth_remove(dev->ieee80211_ptr, addr);
+}
+EXPORT_SYMBOL(__cfg80211_auth_canceled);
+
+void cfg80211_send_auth_timeout(struct net_device *dev, const u8 *addr)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+
+	wdev_lock(wdev);
+
+	nl80211_send_auth_timeout(rdev, dev, addr, GFP_KERNEL);
+	if (wdev->sme_state == CFG80211_SME_CONNECTING)
+		__cfg80211_connect_result(dev, addr, NULL, 0, NULL, 0,
+					  WLAN_STATUS_UNSPECIFIED_FAILURE,
+					  false, NULL);
+
+	__cfg80211_auth_remove(wdev, addr);
 
 	wdev_unlock(wdev);
 }


