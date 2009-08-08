Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38036 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280AbZHHJEI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Aug 2009 05:04:08 -0400
Subject: [PATCH] cfg80211: fix locking for SIWFREQ
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 08 Aug 2009 11:03:58 +0200
Message-Id: <1249722238.31670.17.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"cfg80211: validate channel settings across interfaces"
contained a locking bug -- in the managed-mode SIWFREQ
call it would end up running into a lock recursion.

This fixes it by not checking that particular interface
for a channel that it needs to stay on, which is as it
should be as that's the interface we're setting the
channel for.

Reported-by: Reinette Chatre <reinette.chatre@intel.com>
Reported-by: Kalle Valo <kalle.valo@iki.fi>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/chan.c        |    3 ++-
 net/wireless/core.h        |    1 +
 net/wireless/nl80211.c     |    2 +-
 net/wireless/wext-compat.c |    2 +-
 net/wireless/wext-sme.c    |    2 +-
 5 files changed, 6 insertions(+), 4 deletions(-)

--- wireless-testing.orig/net/wireless/chan.c	2009-08-08 10:53:52.000000000 +0200
+++ wireless-testing/net/wireless/chan.c	2009-08-08 10:54:10.000000000 +0200
@@ -42,13 +42,14 @@ rdev_fixed_channel(struct cfg80211_regis
 }
 
 int rdev_set_freq(struct cfg80211_registered_device *rdev,
+		  struct wireless_dev *for_wdev,
 		  int freq, enum nl80211_channel_type channel_type)
 {
 	struct ieee80211_channel *chan;
 	struct ieee80211_sta_ht_cap *ht_cap;
 	int result;
 
-	if (rdev_fixed_channel(rdev, NULL))
+	if (rdev_fixed_channel(rdev, for_wdev))
 		return -EBUSY;
 
 	if (!rdev->ops->set_channel)
--- wireless-testing.orig/net/wireless/core.h	2009-08-08 10:54:29.000000000 +0200
+++ wireless-testing/net/wireless/core.h	2009-08-08 10:54:37.000000000 +0200
@@ -374,6 +374,7 @@ struct ieee80211_channel *
 rdev_fixed_channel(struct cfg80211_registered_device *rdev,
 		   struct wireless_dev *for_wdev);
 int rdev_set_freq(struct cfg80211_registered_device *rdev,
+		  struct wireless_dev *for_wdev,
 		  int freq, enum nl80211_channel_type channel_type);
 
 #endif /* __NET_WIRELESS_CORE_H */
--- wireless-testing.orig/net/wireless/nl80211.c	2009-08-08 10:54:51.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-08-08 10:54:58.000000000 +0200
@@ -721,7 +721,7 @@ static int nl80211_set_wiphy(struct sk_b
 		freq = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]);
 
 		mutex_lock(&rdev->devlist_mtx);
-		result = rdev_set_freq(rdev, freq, channel_type);
+		result = rdev_set_freq(rdev, NULL, freq, channel_type);
 		mutex_unlock(&rdev->devlist_mtx);
 		if (result)
 			goto bad_res;
--- wireless-testing.orig/net/wireless/wext-compat.c	2009-08-08 10:54:52.000000000 +0200
+++ wireless-testing/net/wireless/wext-compat.c	2009-08-08 10:55:04.000000000 +0200
@@ -766,7 +766,7 @@ int cfg80211_wext_siwfreq(struct net_dev
 		if (freq == 0)
 			return -EINVAL;
 		mutex_lock(&rdev->devlist_mtx);
-		err = rdev_set_freq(rdev, freq, NL80211_CHAN_NO_HT);
+		err = rdev_set_freq(rdev, NULL, freq, NL80211_CHAN_NO_HT);
 		mutex_unlock(&rdev->devlist_mtx);
 		return err;
 	}
--- wireless-testing.orig/net/wireless/wext-sme.c	2009-08-08 10:54:52.000000000 +0200
+++ wireless-testing/net/wireless/wext-sme.c	2009-08-08 10:55:08.000000000 +0200
@@ -106,7 +106,7 @@ int cfg80211_mgd_wext_siwfreq(struct net
 
 	/* SSID is not set, we just want to switch channel */
 	if (chan && !wdev->wext.connect.ssid_len) {
-		err = rdev_set_freq(rdev, freq, NL80211_CHAN_NO_HT);
+		err = rdev_set_freq(rdev, wdev, freq, NL80211_CHAN_NO_HT);
 		goto out;
 	}
 


