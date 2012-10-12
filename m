Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:38578 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750744Ab2JLEEi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2012 00:04:38 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Sam Leffler <sleffler@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v4 3/5] cfg80211: code rearrangement to avoid forward declarations
Date: Thu, 11 Oct 2012 21:03:33 -0700
Message-Id: <1350014615-14762-4-git-send-email-bzhao@marvell.com> (sfid-20121012_060441_989629_8D7EC199)
In-Reply-To: <1350014615-14762-1-git-send-email-bzhao@marvell.com>
References: <1350014615-14762-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

bss_release() and __cfg80211_unlink_bss() function definitions
are moved at the begining of the file. They are used in next
patch in this series.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
v4: rebase to latest mac80211-next tree
v3: avoid static forward declaration (Johannes Berg)

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

