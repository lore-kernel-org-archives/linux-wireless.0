Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:33056 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbaIJKni (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 06:43:38 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3/4] cfg80211: clear wext keys when freeing and removing them
Date: Wed, 10 Sep 2014 13:39:56 +0300
Message-Id: <1410345597-28565-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140910_124342_150312_5952662F)
In-Reply-To: <1410345597-28565-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1410345597-28565-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When freeing the keys stored for wireless extensions, clear the memory
to avoid having the key material stick around in memory "forever".
Similarly, when userspace overwrites a key, actually clear it instead
of just setting the key length to zero.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/wireless/core.c        | 2 +-
 net/wireless/wext-compat.c | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 6030ecc..052870f 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1036,7 +1036,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 			rdev->devlist_generation++;
 			cfg80211_mlme_purge_registrations(wdev);
 #ifdef CPTCFG_CFG80211_WEXT
-			kfree(wdev->wext.keys);
+			kzfree(wdev->wext.keys);
 #endif
 		}
 		/*
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 11120bb..f067e64 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -496,6 +496,8 @@ static int __cfg80211_set_encryption(struct cfg80211_registered_device *rdev,
 			err = 0;
 		if (!err) {
 			if (!addr) {
+				memset(wext->wext.keys->params[idx].data, 0,
+				       sizeof(wext->wext.keys->params[idx].data));
 				wdev->wext.keys->params[idx].key_len = 0;
 				wdev->wext.keys->params[idx].cipher = 0;
 			}
-- 
1.9.1

