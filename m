Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36860 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751473AbcIMOpz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Sep 2016 10:45:55 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6/6] cfg80211: reduce connect key caching struct size
Date: Tue, 13 Sep 2016 16:44:28 +0200
Message-Id: <1473777868-32429-6-git-send-email-johannes@sipsolutions.net> (sfid-20160913_164743_738087_BFCA41BC)
In-Reply-To: <1473777868-32429-1-git-send-email-johannes@sipsolutions.net>
References: <1473777868-32429-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

After the previous patches, connect keys can only (correctly)
be used for storing static WEP keys. Therefore, remove all the
data for dealing with key index 4/5 and reduce the size of the
key material to the maximum for WEP keys.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.h        | 6 +++---
 net/wireless/ibss.c        | 6 ++----
 net/wireless/nl80211.c     | 1 -
 net/wireless/util.c        | 5 +----
 net/wireless/wext-compat.c | 6 +++---
 net/wireless/wext-sme.c    | 3 +--
 6 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/net/wireless/core.h b/net/wireless/core.h
index eee91443924d..5555e3c13ae9 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -249,9 +249,9 @@ struct cfg80211_event {
 };
 
 struct cfg80211_cached_keys {
-	struct key_params params[6];
-	u8 data[6][WLAN_MAX_KEY_LEN];
-	int def, defmgmt;
+	struct key_params params[4];
+	u8 data[4][WLAN_KEY_LEN_WEP104];
+	int def;
 };
 
 enum cfg80211_chan_mode {
diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index 4a4dda53bdf1..896cbb20b6e1 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -284,10 +284,8 @@ int cfg80211_ibss_wext_join(struct cfg80211_registered_device *rdev,
 	if (!netif_running(wdev->netdev))
 		return 0;
 
-	if (wdev->wext.keys) {
+	if (wdev->wext.keys)
 		wdev->wext.keys->def = wdev->wext.default_key;
-		wdev->wext.keys->defmgmt = wdev->wext.default_mgmt_key;
-	}
 
 	wdev->wext.ibss.privacy = wdev->wext.default_key != -1;
 
@@ -295,7 +293,7 @@ int cfg80211_ibss_wext_join(struct cfg80211_registered_device *rdev,
 		ck = kmemdup(wdev->wext.keys, sizeof(*ck), GFP_KERNEL);
 		if (!ck)
 			return -ENOMEM;
-		for (i = 0; i < 6; i++)
+		for (i = 0; i < 4; i++)
 			ck->params[i].key = ck->data[i];
 	}
 	err = __cfg80211_join_ibss(rdev, wdev->netdev,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 739d0a780d83..8c6cbaac7d89 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -854,7 +854,6 @@ nl80211_parse_connkeys(struct cfg80211_registered_device *rdev,
 		return ERR_PTR(-ENOMEM);
 
 	result->def = -1;
-	result->defmgmt = -1;
 
 	nla_for_each_nested(key, keys, rem) {
 		memset(&parse, 0, sizeof(parse));
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 81fa16b36d30..dea2398329c4 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -912,7 +912,7 @@ void cfg80211_upload_connect_keys(struct wireless_dev *wdev)
 	if (!wdev->connect_keys)
 		return;
 
-	for (i = 0; i < 6; i++) {
+	for (i = 0; i < 4; i++) {
 		if (!wdev->connect_keys->params[i].cipher)
 			continue;
 		if (rdev_add_key(rdev, dev, i, false, NULL,
@@ -925,9 +925,6 @@ void cfg80211_upload_connect_keys(struct wireless_dev *wdev)
 				netdev_err(dev, "failed to set defkey %d\n", i);
 				continue;
 			}
-		if (wdev->connect_keys->defmgmt == i)
-			if (rdev_set_default_mgmt_key(rdev, dev, i))
-				netdev_err(dev, "failed to set mgtdef %d\n", i);
 	}
 
 	kzfree(wdev->connect_keys);
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index e45a76449b43..7b97d43b27e1 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -408,10 +408,10 @@ static int __cfg80211_set_encryption(struct cfg80211_registered_device *rdev,
 
 	if (!wdev->wext.keys) {
 		wdev->wext.keys = kzalloc(sizeof(*wdev->wext.keys),
-					      GFP_KERNEL);
+					  GFP_KERNEL);
 		if (!wdev->wext.keys)
 			return -ENOMEM;
-		for (i = 0; i < 6; i++)
+		for (i = 0; i < 4; i++)
 			wdev->wext.keys->params[i].key =
 				wdev->wext.keys->data[i];
 	}
@@ -460,7 +460,7 @@ static int __cfg80211_set_encryption(struct cfg80211_registered_device *rdev,
 		if (err == -ENOENT)
 			err = 0;
 		if (!err) {
-			if (!addr) {
+			if (!addr && idx < 4) {
 				memset(wdev->wext.keys->data[idx], 0,
 				       sizeof(wdev->wext.keys->data[idx]));
 				wdev->wext.keys->params[idx].key_len = 0;
diff --git a/net/wireless/wext-sme.c b/net/wireless/wext-sme.c
index a4e8af3321d2..f6523a4387cc 100644
--- a/net/wireless/wext-sme.c
+++ b/net/wireless/wext-sme.c
@@ -35,7 +35,6 @@ int cfg80211_mgd_wext_connect(struct cfg80211_registered_device *rdev,
 
 	if (wdev->wext.keys) {
 		wdev->wext.keys->def = wdev->wext.default_key;
-		wdev->wext.keys->defmgmt = wdev->wext.default_mgmt_key;
 		if (wdev->wext.default_key != -1)
 			wdev->wext.connect.privacy = true;
 	}
@@ -47,7 +46,7 @@ int cfg80211_mgd_wext_connect(struct cfg80211_registered_device *rdev,
 		ck = kmemdup(wdev->wext.keys, sizeof(*ck), GFP_KERNEL);
 		if (!ck)
 			return -ENOMEM;
-		for (i = 0; i < 6; i++)
+		for (i = 0; i < 4; i++)
 			ck->params[i].key = ck->data[i];
 	}
 
-- 
2.8.1
