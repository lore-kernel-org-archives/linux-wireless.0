Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38739 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbZDTQoX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 12:44:23 -0400
Subject: [PATCH] cfg80211: clear WEXT SSID when clearing IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 20 Apr 2009 18:43:46 +0200
Message-Id: <1240245826.4632.5.camel@johannes.local> (sfid-20090420_184427_223841_F8988642)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we leave an IBSS, we should clear the SSID and not just the
BSSID, but since WEXT allows configuring while the interface is
down we must not clear it when leaving due to taking the iface
down, so some complications are needed.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/core.c    |    2 +-
 net/wireless/core.h    |    4 ++--
 net/wireless/ibss.c    |   21 ++++++++++++++-------
 net/wireless/nl80211.c |    4 ++--
 4 files changed, 19 insertions(+), 12 deletions(-)

--- wireless-testing.orig/net/wireless/ibss.c	2009-04-20 18:37:39.000000000 +0200
+++ wireless-testing/net/wireless/ibss.c	2009-04-20 18:42:44.000000000 +0200
@@ -76,7 +76,7 @@ int cfg80211_join_ibss(struct cfg80211_r
 	return 0;
 }
 
-void cfg80211_clear_ibss(struct net_device *dev)
+void cfg80211_clear_ibss(struct net_device *dev, bool nowext)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 
@@ -88,10 +88,14 @@ void cfg80211_clear_ibss(struct net_devi
 	wdev->current_bss = NULL;
 	wdev->ssid_len = 0;
 	memset(wdev->bssid, 0, ETH_ALEN);
+#ifdef CONFIG_WIRELESS_EXT
+	if (!nowext)
+		wdev->wext.ssid_len = 0;
+#endif
 }
 
 int cfg80211_leave_ibss(struct cfg80211_registered_device *rdev,
-			struct net_device *dev)
+			struct net_device *dev, bool nowext)
 {
 	int err;
 
@@ -100,7 +104,7 @@ int cfg80211_leave_ibss(struct cfg80211_
 	if (err)
 		return err;
 
-	cfg80211_clear_ibss(dev);
+	cfg80211_clear_ibss(dev, nowext);
 
 	return 0;
 }
@@ -179,7 +183,8 @@ int cfg80211_ibss_wext_siwfreq(struct ne
 		return 0;
 
 	if (wdev->ssid_len) {
-		err = cfg80211_leave_ibss(wiphy_to_dev(wdev->wiphy), dev);
+		err = cfg80211_leave_ibss(wiphy_to_dev(wdev->wiphy),
+					  dev, true);
 		if (err)
 			return err;
 	}
@@ -241,7 +246,8 @@ int cfg80211_ibss_wext_siwessid(struct n
 		return -EOPNOTSUPP;
 
 	if (wdev->ssid_len) {
-		err = cfg80211_leave_ibss(wiphy_to_dev(wdev->wiphy), dev);
+		err = cfg80211_leave_ibss(wiphy_to_dev(wdev->wiphy),
+					  dev, true);
 		if (err)
 			return err;
 	}
@@ -275,7 +281,7 @@ int cfg80211_ibss_wext_giwessid(struct n
 		data->flags = 1;
 		data->length = wdev->ssid_len;
 		memcpy(ssid, wdev->ssid, data->length);
-	} else if (wdev->wext.ssid) {
+	} else if (wdev->wext.ssid && wdev->wext.ssid_len) {
 		data->flags = 1;
 		data->length = wdev->wext.ssid_len;
 		memcpy(ssid, wdev->wext.ssid, data->length);
@@ -318,7 +324,8 @@ int cfg80211_ibss_wext_siwap(struct net_
 		return 0;
 
 	if (wdev->ssid_len) {
-		err = cfg80211_leave_ibss(wiphy_to_dev(wdev->wiphy), dev);
+		err = cfg80211_leave_ibss(wiphy_to_dev(wdev->wiphy),
+					  dev, true);
 		if (err)
 			return err;
 	}
--- wireless-testing.orig/net/wireless/core.c	2009-04-20 18:37:39.000000000 +0200
+++ wireless-testing/net/wireless/core.c	2009-04-20 18:39:11.000000000 +0200
@@ -464,7 +464,7 @@ static int cfg80211_netdev_notifier_call
 			break;
 		if (!dev->ieee80211_ptr->ssid_len)
 			break;
-		cfg80211_leave_ibss(rdev, dev);
+		cfg80211_leave_ibss(rdev, dev, true);
 		break;
 	case NETDEV_UP:
 #ifdef CONFIG_WIRELESS_EXT
--- wireless-testing.orig/net/wireless/core.h	2009-04-20 18:37:39.000000000 +0200
+++ wireless-testing/net/wireless/core.h	2009-04-20 18:41:58.000000000 +0200
@@ -147,8 +147,8 @@ void cfg80211_bss_age(struct cfg80211_re
 int cfg80211_join_ibss(struct cfg80211_registered_device *rdev,
 		       struct net_device *dev,
 		       struct cfg80211_ibss_params *params);
-void cfg80211_clear_ibss(struct net_device *dev);
+void cfg80211_clear_ibss(struct net_device *dev, bool nowext);
 int cfg80211_leave_ibss(struct cfg80211_registered_device *rdev,
-			struct net_device *dev);
+			struct net_device *dev, bool nowext);
 
 #endif /* __NET_WIRELESS_CORE_H */
--- wireless-testing.orig/net/wireless/nl80211.c	2009-04-20 18:37:39.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-04-20 18:39:11.000000000 +0200
@@ -833,7 +833,7 @@ static int nl80211_set_interface(struct 
 
 	if (dev && !err && (ntype != otype)) {
 		if (otype == NL80211_IFTYPE_ADHOC)
-			cfg80211_clear_ibss(dev);
+			cfg80211_clear_ibss(dev, false);
 	}
 
  unlock:
@@ -3249,7 +3249,7 @@ static int nl80211_leave_ibss(struct sk_
 		goto out;
 	}
 
-	err = cfg80211_leave_ibss(drv, dev);
+	err = cfg80211_leave_ibss(drv, dev, false);
 
 out:
 	cfg80211_put_dev(drv);


