Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56842 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab3BAAOW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 19:14:22 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: use lockdep to assert lock is held
Date: Fri,  1 Feb 2013 01:14:44 +0100
Message-Id: <1359677685-23827-1-git-send-email-johannes@sipsolutions.net> (sfid-20130201_011424_988506_7DCE7B9A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of annotating with a comment, add a lockdep
annotation which also serves as documentation.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/scan.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 05dbc5b..0ab71af 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -41,22 +41,24 @@ static void bss_release(struct kref *ref)
 	kfree(bss);
 }
 
-/* must hold dev->bss_lock! */
 static void __cfg80211_unlink_bss(struct cfg80211_registered_device *dev,
 				  struct cfg80211_internal_bss *bss)
 {
+	lockdep_assert_held(&dev->bss_lock);
+
 	list_del_init(&bss->list);
 	rb_erase(&bss->rbn, &dev->bss_tree);
 	kref_put(&bss->ref, bss_release);
 }
 
-/* must hold dev->bss_lock! */
 static void __cfg80211_bss_expire(struct cfg80211_registered_device *dev,
 				  unsigned long expire_time)
 {
 	struct cfg80211_internal_bss *bss, *tmp;
 	bool expired = false;
 
+	lockdep_assert_held(&dev->bss_lock);
+
 	list_for_each_entry_safe(bss, tmp, &dev->bss_list, list) {
 		if (atomic_read(&bss->hold))
 			continue;
-- 
1.8.0

