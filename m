Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:45830 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754104AbeFUBaC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Jun 2018 21:30:02 -0400
Received: by mail-pl0-f65.google.com with SMTP id o18-v6so29851pll.12
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jun 2018 18:30:02 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Brian Norris <briannorris@chromium.org>
Subject: [PATCH] cfg80211: use IDA to allocate wiphy indeces
Date: Wed, 20 Jun 2018 18:29:45 -0700
Message-Id: <20180621012945.185705-1-briannorris@chromium.org> (sfid-20180621_033040_107853_357A6F78)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's annoying to see the phy index increase arbitrarily, just because a
device got removed and re-probed (e.g., during a device reset, or due to
probe testing). We can use the in-kernel index allocator for this,
instead of just an increasing counter.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 net/wireless/core.c | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index c0fd8a85e7f7..80c108c3ca38 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -8,6 +8,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/idr.h>
 #include <linux/if.h>
 #include <linux/module.h>
 #include <linux/err.h>
@@ -380,11 +381,11 @@ static void cfg80211_propagate_cac_done_wk(struct work_struct *work)
 
 /* exported functions */
 
+static DEFINE_IDA(wiphy_ida);
+
 struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int sizeof_priv,
 			   const char *requested_name)
 {
-	static atomic_t wiphy_counter = ATOMIC_INIT(0);
-
 	struct cfg80211_registered_device *rdev;
 	int alloc_size;
 
@@ -413,18 +414,12 @@ struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int sizeof_priv,
 
 	rdev->ops = ops;
 
-	rdev->wiphy_idx = atomic_inc_return(&wiphy_counter);
-
+	rdev->wiphy_idx = ida_simple_get(&wiphy_ida, 0, 0, GFP_KERNEL);
 	if (unlikely(rdev->wiphy_idx < 0)) {
-		/* ugh, wrapped! */
-		atomic_dec(&wiphy_counter);
 		kfree(rdev);
 		return NULL;
 	}
 
-	/* atomic_inc_return makes it start at 1, make it start at 0 */
-	rdev->wiphy_idx--;
-
 	/* give it a proper name */
 	if (requested_name && requested_name[0]) {
 		int rv;
@@ -452,10 +447,8 @@ struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int sizeof_priv,
 		 * value, and use a different name if this one exists?
 		 */
 		rv = dev_set_name(&rdev->wiphy.dev, PHY_NAME "%d", rdev->wiphy_idx);
-		if (rv < 0) {
-			kfree(rdev);
-			return NULL;
-		}
+		if (rv < 0)
+			goto err;
 	}
 
 	INIT_LIST_HEAD(&rdev->wiphy.wdev_list);
@@ -497,10 +490,8 @@ struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int sizeof_priv,
 				   &rdev->wiphy.dev, RFKILL_TYPE_WLAN,
 				   &rdev->rfkill_ops, rdev);
 
-	if (!rdev->rfkill) {
-		kfree(rdev);
-		return NULL;
-	}
+	if (!rdev->rfkill)
+		goto err;
 
 	INIT_WORK(&rdev->rfkill_sync, cfg80211_rfkill_sync_work);
 	INIT_WORK(&rdev->conn_work, cfg80211_conn_work);
@@ -525,6 +516,11 @@ struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int sizeof_priv,
 	rdev->wiphy.max_sched_scan_plan_interval = U32_MAX;
 
 	return &rdev->wiphy;
+
+err:
+	ida_simple_remove(&wiphy_ida, rdev->wiphy_idx);
+	kfree(rdev);
+	return NULL;
 }
 EXPORT_SYMBOL(wiphy_new_nm);
 
@@ -972,6 +968,7 @@ void cfg80211_dev_free(struct cfg80211_registered_device *rdev)
 	}
 	list_for_each_entry_safe(scan, tmp, &rdev->bss_list, list)
 		cfg80211_put_bss(&rdev->wiphy, &scan->pub);
+	ida_simple_remove(&wiphy_ida, rdev->wiphy_idx);
 	kfree(rdev);
 }
 
-- 
2.18.0.rc1.244.gcf134e6275-goog
