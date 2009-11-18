Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52947 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbZKRMEN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 07:04:13 -0500
Subject: [PATCH] cfg80211: re-join IBSS when privacy changes
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: hong zhang <henryzhang62@yahoo.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Nov 2009 13:03:43 +0100
Message-ID: <1258545823.30511.10.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When going from/to a WEP protected IBSS, we need to
leave this one and join a new one to take care of
the changed capability.

Cc: Hong Zhang <henryzhang62@yahoo.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/core.h        |    2 +
 net/wireless/ibss.c        |    4 +--
 net/wireless/wext-compat.c |   49 ++++++++++++++++++++++++++++++++++++---------
 3 files changed, 44 insertions(+), 11 deletions(-)

--- wireless-testing.orig/net/wireless/ibss.c	2009-11-18 11:42:49.000000000 +0100
+++ wireless-testing/net/wireless/ibss.c	2009-11-18 11:47:35.000000000 +0100
@@ -169,8 +169,8 @@ void cfg80211_clear_ibss(struct net_devi
 	wdev_unlock(wdev);
 }
 
-static int __cfg80211_leave_ibss(struct cfg80211_registered_device *rdev,
-				 struct net_device *dev, bool nowext)
+int __cfg80211_leave_ibss(struct cfg80211_registered_device *rdev,
+			  struct net_device *dev, bool nowext)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	int err;
--- wireless-testing.orig/net/wireless/wext-compat.c	2009-11-18 11:42:49.000000000 +0100
+++ wireless-testing/net/wireless/wext-compat.c	2009-11-18 12:52:45.000000000 +0100
@@ -437,6 +437,7 @@ static int __cfg80211_set_encryption(str
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	int err, i;
+	bool rejoin = false;
 
 	if (!wdev->wext.keys) {
 		wdev->wext.keys = kzalloc(sizeof(*wdev->wext.keys),
@@ -466,8 +467,24 @@ static int __cfg80211_set_encryption(str
 
 	if (remove) {
 		err = 0;
-		if (wdev->current_bss)
+		if (wdev->current_bss) {
+			/*
+			 * If removing the current TX key, we will need to
+			 * join a new IBSS without the privacy bit clear.
+			 */
+			if (idx == wdev->wext.default_key &&
+			    wdev->iftype == NL80211_IFTYPE_ADHOC) {
+				__cfg80211_leave_ibss(rdev, wdev->netdev, true);
+				rejoin = true;
+			}
 			err = rdev->ops->del_key(&rdev->wiphy, dev, idx, addr);
+		}
+		/*
+		 * Applications using wireless extensions expect to be
+		 * able to delete keys that don't exist, so allow that.
+		 */
+		if (err == -ENOENT)
+			err = 0;
 		if (!err) {
 			if (!addr) {
 				wdev->wext.keys->params[idx].key_len = 0;
@@ -478,12 +495,9 @@ static int __cfg80211_set_encryption(str
 			else if (idx == wdev->wext.default_mgmt_key)
 				wdev->wext.default_mgmt_key = -1;
 		}
-		/*
-		 * Applications using wireless extensions expect to be
-		 * able to delete keys that don't exist, so allow that.
-		 */
-		if (err == -ENOENT)
-			return 0;
+
+		if (!err && rejoin)
+			err = cfg80211_ibss_wext_join(rdev, wdev);
 
 		return err;
 	}
@@ -511,11 +525,25 @@ static int __cfg80211_set_encryption(str
 	if ((params->cipher == WLAN_CIPHER_SUITE_WEP40 ||
 	     params->cipher == WLAN_CIPHER_SUITE_WEP104) &&
 	    (tx_key || (!addr && wdev->wext.default_key == -1))) {
-		if (wdev->current_bss)
+		if (wdev->current_bss) {
+			/*
+			 * If we are getting a new TX key from not having
+			 * had one before we need to join a new IBSS with
+			 * the privacy bit set.
+			 */
+			if (wdev->iftype == NL80211_IFTYPE_ADHOC &&
+			    wdev->wext.default_key == -1) {
+				__cfg80211_leave_ibss(rdev, wdev->netdev, true);
+				rejoin = true;
+			}
 			err = rdev->ops->set_default_key(&rdev->wiphy,
 							 dev, idx);
-		if (!err)
+		}
+		if (!err) {
 			wdev->wext.default_key = idx;
+			if (rejoin)
+				err = cfg80211_ibss_wext_join(rdev, wdev);
+		}
 		return err;
 	}
 
@@ -539,10 +567,13 @@ static int cfg80211_set_encryption(struc
 {
 	int err;
 
+	/* devlist mutex needed for possible IBSS re-join */
+	mutex_lock(&rdev->devlist_mtx);
 	wdev_lock(dev->ieee80211_ptr);
 	err = __cfg80211_set_encryption(rdev, dev, addr, remove,
 					tx_key, idx, params);
 	wdev_unlock(dev->ieee80211_ptr);
+	mutex_unlock(&rdev->devlist_mtx);
 
 	return err;
 }
--- wireless-testing.orig/net/wireless/core.h	2009-11-18 11:42:49.000000000 +0100
+++ wireless-testing/net/wireless/core.h	2009-11-18 11:47:35.000000000 +0100
@@ -273,6 +273,8 @@ int cfg80211_join_ibss(struct cfg80211_r
 		       struct cfg80211_ibss_params *params,
 		       struct cfg80211_cached_keys *connkeys);
 void cfg80211_clear_ibss(struct net_device *dev, bool nowext);
+int __cfg80211_leave_ibss(struct cfg80211_registered_device *rdev,
+			  struct net_device *dev, bool nowext);
 int cfg80211_leave_ibss(struct cfg80211_registered_device *rdev,
 			struct net_device *dev, bool nowext);
 void __cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid);


