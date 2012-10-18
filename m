Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:34054 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751457Ab2JRGfv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Oct 2012 02:35:51 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Sam Leffler <sleffler@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v6 2/6] cfg80211: code rearrangement to avoid forward declarations
Date: Wed, 17 Oct 2012 23:34:27 -0700
Message-Id: <1350542071-26498-3-git-send-email-bzhao@marvell.com> (sfid-20121018_083553_649763_09A15B72)
In-Reply-To: <1350542071-26498-1-git-send-email-bzhao@marvell.com>
References: <1350542071-26498-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

bss_release() and __cfg80211_unlink_bss() function definitions
are moved at the begining of the file. They are used in next
patch in this series.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/scan.c |   54 +++++++++++++++++++++++++-------------------------
 1 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 9730c98..2005096 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -20,6 +20,33 @@
 
 #define IEEE80211_SCAN_RESULT_EXPIRE	(30 * HZ)
 
+static void bss_release(struct kref *ref)
+{
+	struct cfg80211_internal_bss *bss;
+
+	bss = container_of(ref, struct cfg80211_internal_bss, ref);
+	if (bss->pub.free_priv)
+		bss->pub.free_priv(&bss->pub);
+
+	if (bss->beacon_ies_allocated)
+		kfree(bss->pub.beacon_ies);
+	if (bss->proberesp_ies_allocated)
+		kfree(bss->pub.proberesp_ies);
+
+	BUG_ON(atomic_read(&bss->hold));
+
+	kfree(bss);
+}
+
+/* must hold dev->bss_lock! */
+static void __cfg80211_unlink_bss(struct cfg80211_registered_device *dev,
+				  struct cfg80211_internal_bss *bss)
+{
+	list_del_init(&bss->list);
+	rb_erase(&bss->rbn, &dev->bss_tree);
+	kref_put(&bss->ref, bss_release);
+}
+
 void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak)
 {
 	struct cfg80211_scan_request *request;
@@ -158,24 +185,6 @@ int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
 	return 0;
 }
 
-static void bss_release(struct kref *ref)
-{
-	struct cfg80211_internal_bss *bss;
-
-	bss = container_of(ref, struct cfg80211_internal_bss, ref);
-	if (bss->pub.free_priv)
-		bss->pub.free_priv(&bss->pub);
-
-	if (bss->beacon_ies_allocated)
-		kfree(bss->pub.beacon_ies);
-	if (bss->proberesp_ies_allocated)
-		kfree(bss->pub.proberesp_ies);
-
-	BUG_ON(atomic_read(&bss->hold));
-
-	kfree(bss);
-}
-
 /* must hold dev->bss_lock! */
 void cfg80211_bss_age(struct cfg80211_registered_device *dev,
                       unsigned long age_secs)
@@ -189,15 +198,6 @@ void cfg80211_bss_age(struct cfg80211_registered_device *dev,
 }
 
 /* must hold dev->bss_lock! */
-static void __cfg80211_unlink_bss(struct cfg80211_registered_device *dev,
-				  struct cfg80211_internal_bss *bss)
-{
-	list_del_init(&bss->list);
-	rb_erase(&bss->rbn, &dev->bss_tree);
-	kref_put(&bss->ref, bss_release);
-}
-
-/* must hold dev->bss_lock! */
 void cfg80211_bss_expire(struct cfg80211_registered_device *dev)
 {
 	struct cfg80211_internal_bss *bss, *tmp;
-- 
1.7.0.4

