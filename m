Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35979 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbZBGPKK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Feb 2009 10:10:10 -0500
Message-Id: <20090207150934.929731048@sipsolutions.net> (sfid-20090207_161018_333141_DD89A122)
References: <20090207150846.951229208@sipsolutions.net>
Date: Sat, 07 Feb 2009 16:08:48 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/4] cfg80211: free_priv for BSS info
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When cfg80211 users have their own allocated data in the per-BSS
private data, they will need to free this when the BSS struct is
destroyed. Add a free_priv method and fix one place where the BSS
was kfree'd rather than released properly.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/cfg80211.h |    2 ++
 net/wireless/core.c    |    2 +-
 net/wireless/scan.c    |    2 ++
 3 files changed, 5 insertions(+), 1 deletion(-)

--- wireless-testing.orig/include/net/cfg80211.h	2009-02-07 15:42:02.000000000 +0100
+++ wireless-testing/include/net/cfg80211.h	2009-02-07 15:42:12.000000000 +0100
@@ -567,6 +567,7 @@ enum cfg80211_signal_type {
  * @len_information_elements: total length of the information elements
  * @signal: signal strength value
  * @signal_type: signal type
+ * @free_priv: function pointer to free private data
  * @priv: private area for driver use, has at least wiphy->bss_priv_size bytes
  */
 struct cfg80211_bss {
@@ -582,6 +583,7 @@ struct cfg80211_bss {
 	s32 signal;
 	enum cfg80211_signal_type signal_type;
 
+	void (*free_priv)(struct cfg80211_bss *bss);
 	u8 priv[0] __attribute__((__aligned__(sizeof(void *))));
 };
 
--- wireless-testing.orig/net/wireless/scan.c	2009-02-07 15:42:02.000000000 +0100
+++ wireless-testing/net/wireless/scan.c	2009-02-07 15:42:12.000000000 +0100
@@ -56,6 +56,8 @@ static void bss_release(struct kref *ref
 	struct cfg80211_internal_bss *bss;
 
 	bss = container_of(ref, struct cfg80211_internal_bss, ref);
+	if (bss->pub.free_priv)
+		bss->pub.free_priv(&bss->pub);
 	kfree(bss);
 }
 
--- wireless-testing.orig/net/wireless/core.c	2009-02-07 15:42:02.000000000 +0100
+++ wireless-testing/net/wireless/core.c	2009-02-07 15:42:12.000000000 +0100
@@ -376,7 +376,7 @@ void cfg80211_dev_free(struct cfg80211_r
 	mutex_destroy(&drv->mtx);
 	mutex_destroy(&drv->devlist_mtx);
 	list_for_each_entry_safe(scan, tmp, &drv->bss_list, list)
-		kfree(scan);
+		cfg80211_put_bss(&scan->pub);
 	kfree(drv);
 }
 

-- 

