Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56903 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922Ab3BAAim (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 19:38:42 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: wrap BSS kref
Date: Fri,  1 Feb 2013 01:39:03 +0100
Message-Id: <1359679143-4810-1-git-send-email-johannes@sipsolutions.net> (sfid-20130201_013845_786545_97B08B0C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add inline wrappers for the BSS struct krefs
to be able to extend them easily later.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/scan.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 1ed160d..c962737 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -41,6 +41,16 @@ static void bss_release(struct kref *ref)
 	kfree(bss);
 }
 
+static inline void bss_ref_get(struct cfg80211_internal_bss *bss)
+{
+	kref_get(&bss->ref);
+}
+
+static inline void bss_ref_put(struct cfg80211_internal_bss *bss)
+{
+	kref_put(&bss->ref, bss_release);
+}
+
 static void __cfg80211_unlink_bss(struct cfg80211_registered_device *dev,
 				  struct cfg80211_internal_bss *bss)
 {
@@ -48,7 +58,7 @@ static void __cfg80211_unlink_bss(struct cfg80211_registered_device *dev,
 
 	list_del_init(&bss->list);
 	rb_erase(&bss->rbn, &dev->bss_tree);
-	kref_put(&bss->ref, bss_release);
+	bss_ref_put(bss);
 }
 
 static void __cfg80211_bss_expire(struct cfg80211_registered_device *dev,
@@ -435,7 +445,7 @@ struct cfg80211_bss *cfg80211_get_bss(struct wiphy *wiphy,
 			continue;
 		if (is_bss(&bss->pub, bssid, ssid, ssid_len)) {
 			res = bss;
-			kref_get(&res->ref);
+			bss_ref_get(res);
 			break;
 		}
 	}
@@ -623,7 +633,7 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
 	dev->bss_generation++;
 	spin_unlock_bh(&dev->bss_lock);
 
-	kref_get(&found->ref);
+	bss_ref_get(found);
 	return found;
 }
 
@@ -790,7 +800,7 @@ void cfg80211_ref_bss(struct cfg80211_bss *pub)
 		return;
 
 	bss = container_of(pub, struct cfg80211_internal_bss, pub);
-	kref_get(&bss->ref);
+	bss_ref_get(bss);
 }
 EXPORT_SYMBOL(cfg80211_ref_bss);
 
@@ -802,7 +812,7 @@ void cfg80211_put_bss(struct cfg80211_bss *pub)
 		return;
 
 	bss = container_of(pub, struct cfg80211_internal_bss, pub);
-	kref_put(&bss->ref, bss_release);
+	bss_ref_put(bss);
 }
 EXPORT_SYMBOL(cfg80211_put_bss);
 
-- 
1.8.0

