Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:28767 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008Ab1C1Lcp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Mar 2011 07:32:45 -0400
From: juuso.oikarinen@nokia.com
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCHv2] cfg80211: fix BSS double-unlinking (continued)
Date: Mon, 28 Mar 2011 14:32:32 +0300
Message-Id: <1301311952-27659-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

This patch adds to the fix "fix BSS double-unlinking"
(commit 3207390a8b58bfc1335750f91cf6783c48ca19ca) by Johannes Berg.

It turns out, that the double-unlinking scenario can also occur if expired
BSS elements are removed whilst an interface is performing association.

To work around that, replace list_del with list_del_init also in the
"cfg80211_bss_expire" function, so that the check for whether the BSS still is
in the list works correctly in cfg80211_unlink_bss.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
v2: Small correction in patch title, separate function for the actual
    unlinking of the bss

 net/wireless/scan.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index ea427f4..0be7b46 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -124,6 +124,15 @@ void cfg80211_bss_age(struct cfg80211_registered_device *dev,
 }
 
 /* must hold dev->bss_lock! */
+static void __cfg80211_unlink_bss(struct cfg80211_registered_device *dev,
+				  struct cfg80211_internal_bss *bss)
+{
+	list_del_init(&bss->list);
+	rb_erase(&bss->rbn, &dev->bss_tree);
+	kref_put(&bss->ref, bss_release);
+}
+
+/* must hold dev->bss_lock! */
 void cfg80211_bss_expire(struct cfg80211_registered_device *dev)
 {
 	struct cfg80211_internal_bss *bss, *tmp;
@@ -134,9 +143,7 @@ void cfg80211_bss_expire(struct cfg80211_registered_device *dev)
 			continue;
 		if (!time_after(jiffies, bss->ts + IEEE80211_SCAN_RESULT_EXPIRE))
 			continue;
-		list_del(&bss->list);
-		rb_erase(&bss->rbn, &dev->bss_tree);
-		kref_put(&bss->ref, bss_release);
+		__cfg80211_unlink_bss(dev, bss);
 		expired = true;
 	}
 
@@ -662,11 +669,8 @@ void cfg80211_unlink_bss(struct wiphy *wiphy, struct cfg80211_bss *pub)
 
 	spin_lock_bh(&dev->bss_lock);
 	if (!list_empty(&bss->list)) {
-		list_del_init(&bss->list);
+		__cfg80211_unlink_bss(dev, bss);
 		dev->bss_generation++;
-		rb_erase(&bss->rbn, &dev->bss_tree);
-
-		kref_put(&bss->ref, bss_release);
 	}
 	spin_unlock_bh(&dev->bss_lock);
 }
-- 
1.7.1

