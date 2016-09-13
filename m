Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38043 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752439AbcIMSRM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Sep 2016 14:17:12 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: allow connect keys only with default (TX) key
Date: Tue, 13 Sep 2016 20:17:08 +0200
Message-Id: <1473790628-27165-1-git-send-email-johannes@sipsolutions.net> (sfid-20160913_201716_161170_188FCF3F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no point in allowing connect keys when one of them
isn't also configured as the TX key, it would just confuse
drivers and probably cause them to pick something for TX.
Disallow this confusing and erroneous configuration.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/ibss.c     | 5 ++++-
 net/wireless/nl80211.c  | 5 +++++
 net/wireless/sme.c      | 3 +++
 net/wireless/wext-sme.c | 2 +-
 4 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index 896cbb20b6e1..eafdfa5798ae 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -114,6 +114,9 @@ static int __cfg80211_join_ibss(struct cfg80211_registered_device *rdev,
 		}
 	}
 
+	if (WARN_ON(connkeys && connkeys->def < 0))
+		return -EINVAL;
+
 	if (WARN_ON(wdev->connect_keys))
 		kzfree(wdev->connect_keys);
 	wdev->connect_keys = connkeys;
@@ -289,7 +292,7 @@ int cfg80211_ibss_wext_join(struct cfg80211_registered_device *rdev,
 
 	wdev->wext.ibss.privacy = wdev->wext.default_key != -1;
 
-	if (wdev->wext.keys) {
+	if (wdev->wext.keys && wdev->wext.keys->def != -1) {
 		ck = kmemdup(wdev->wext.keys, sizeof(*ck), GFP_KERNEL);
 		if (!ck)
 			return -ENOMEM;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8c6cbaac7d89..2036a47915d1 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -895,6 +895,11 @@ nl80211_parse_connkeys(struct cfg80211_registered_device *rdev,
 			*no_ht = true;
 	}
 
+	if (result->def < 0) {
+		err = -EINVAL;
+		goto error;
+	}
+
 	return result;
  error:
 	kfree(result);
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index add6824c44fd..c08a3b57dca1 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -1043,6 +1043,9 @@ int cfg80211_connect(struct cfg80211_registered_device *rdev,
 				connect->crypto.ciphers_pairwise[0] = cipher;
 			}
 		}
+	} else {
+		if (WARN_ON(connkeys))
+			return -EINVAL;
 	}
 
 	wdev->connect_keys = connkeys;
diff --git a/net/wireless/wext-sme.c b/net/wireless/wext-sme.c
index f6523a4387cc..88f1f6931ab8 100644
--- a/net/wireless/wext-sme.c
+++ b/net/wireless/wext-sme.c
@@ -42,7 +42,7 @@ int cfg80211_mgd_wext_connect(struct cfg80211_registered_device *rdev,
 	if (!wdev->wext.connect.ssid_len)
 		return 0;
 
-	if (wdev->wext.keys) {
+	if (wdev->wext.keys && wdev->wext.keys->def != -1) {
 		ck = kmemdup(wdev->wext.keys, sizeof(*ck), GFP_KERNEL);
 		if (!ck)
 			return -ENOMEM;
-- 
2.8.1
