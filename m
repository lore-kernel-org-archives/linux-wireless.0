Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:33056 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbaIJKnf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 06:43:35 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/4] cfg80211: clear connect keys when freeing them
Date: Wed, 10 Sep 2014 13:39:54 +0300
Message-Id: <1410345597-28565-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140910_124338_902642_EE0008B6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When freeing the connect keys, clear the memory to avoid
having the key material stick around in memory "forever".

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/wireless/ibss.c     | 4 ++--
 net/wireless/nl80211.c  | 8 ++++----
 net/wireless/sme.c      | 6 +++---
 net/wireless/util.c     | 2 +-
 net/wireless/wext-sme.c | 2 +-
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index 7b87843..49a70c9 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -115,7 +115,7 @@ static int __cfg80211_join_ibss(struct cfg80211_registered_device *rdev,
 	}
 
 	if (WARN_ON(wdev->connect_keys))
-		kfree(wdev->connect_keys);
+		kzfree(wdev->connect_keys);
 	wdev->connect_keys = connkeys;
 
 	wdev->ibss_fixed = params->channel_fixed;
@@ -161,7 +161,7 @@ static void __cfg80211_clear_ibss(struct net_device *dev, bool nowext)
 
 	ASSERT_WDEV_LOCK(wdev);
 
-	kfree(wdev->connect_keys);
+	kzfree(wdev->connect_keys);
 	wdev->connect_keys = NULL;
 
 	rdev_set_qos_map(rdev, dev, NULL);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f87e335..f4194af 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6938,7 +6938,7 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 
 	err = cfg80211_join_ibss(rdev, dev, &ibss, connkeys);
 	if (err)
-		kfree(connkeys);
+		kzfree(connkeys);
 	return err;
 }
 
@@ -7310,7 +7310,7 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 
 	if (info->attrs[NL80211_ATTR_HT_CAPABILITY]) {
 		if (!info->attrs[NL80211_ATTR_HT_CAPABILITY_MASK]) {
-			kfree(connkeys);
+			kzfree(connkeys);
 			return -EINVAL;
 		}
 		memcpy(&connect.ht_capa,
@@ -7328,7 +7328,7 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 
 	if (info->attrs[NL80211_ATTR_VHT_CAPABILITY]) {
 		if (!info->attrs[NL80211_ATTR_VHT_CAPABILITY_MASK]) {
-			kfree(connkeys);
+			kzfree(connkeys);
 			return -EINVAL;
 		}
 		memcpy(&connect.vht_capa,
@@ -7348,7 +7348,7 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 	err = cfg80211_connect(rdev, dev, &connect, connkeys, NULL);
 	wdev_unlock(dev->ieee80211_ptr);
 	if (err)
-		kfree(connkeys);
+		kzfree(connkeys);
 	return err;
 }
 
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 7fb5063..f365a0c 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -641,7 +641,7 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 	}
 
 	if (status != WLAN_STATUS_SUCCESS) {
-		kfree(wdev->connect_keys);
+		kzfree(wdev->connect_keys);
 		wdev->connect_keys = NULL;
 		wdev->ssid_len = 0;
 		if (bss) {
@@ -918,7 +918,7 @@ int cfg80211_connect(struct cfg80211_registered_device *rdev,
 	ASSERT_WDEV_LOCK(wdev);
 
 	if (WARN_ON(wdev->connect_keys)) {
-		kfree(wdev->connect_keys);
+		kzfree(wdev->connect_keys);
 		wdev->connect_keys = NULL;
 	}
 
@@ -978,7 +978,7 @@ int cfg80211_disconnect(struct cfg80211_registered_device *rdev,
 
 	ASSERT_WDEV_LOCK(wdev);
 
-	kfree(wdev->connect_keys);
+	kzfree(wdev->connect_keys);
 	wdev->connect_keys = NULL;
 
 	if (wdev->conn)
diff --git a/net/wireless/util.c b/net/wireless/util.c
index a8b2816..5e233a5 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -797,7 +797,7 @@ void cfg80211_upload_connect_keys(struct wireless_dev *wdev)
 				netdev_err(dev, "failed to set mgtdef %d\n", i);
 	}
 
-	kfree(wdev->connect_keys);
+	kzfree(wdev->connect_keys);
 	wdev->connect_keys = NULL;
 }
 
diff --git a/net/wireless/wext-sme.c b/net/wireless/wext-sme.c
index c7e5c8e..368611c 100644
--- a/net/wireless/wext-sme.c
+++ b/net/wireless/wext-sme.c
@@ -57,7 +57,7 @@ int cfg80211_mgd_wext_connect(struct cfg80211_registered_device *rdev,
 	err = cfg80211_connect(rdev, wdev->netdev,
 			       &wdev->wext.connect, ck, prev_bssid);
 	if (err)
-		kfree(ck);
+		kzfree(ck);
 
 	return err;
 }
-- 
1.9.1

