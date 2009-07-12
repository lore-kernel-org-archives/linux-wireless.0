Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:37606 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666AbZGLL0S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jul 2009 07:26:18 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] [compat-2.6] Fixes kernel panic with kernel 2.6.28 while scanning.
Date: Sun, 12 Jul 2009 13:26:06 +0200
Message-Id: <1247397966-1374-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1247397966-1374-1-git-send-email-hauke@hauke-m.de>
References: <1247397966-1374-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This Problem was introduced with 50334349aa7f6fba1002739bf08481fcf1fb0761
The Patch is based on http://osdir.com/ml/linux-wireless/2009-04/msg01085.html

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat.diff |   72 +++++++++------------------------------------------
 1 files changed, 13 insertions(+), 59 deletions(-)

diff --git a/compat/compat.diff b/compat/compat.diff
index 6214f4a..9b73788 100644
--- a/compat/compat.diff
+++ b/compat/compat.diff
@@ -817,66 +817,20 @@
  #include <linux/workqueue.h>
  #include <net/genetlink.h>
  #include <net/cfg80211.h>
-@@ -113,7 +117,9 @@
- 	unsigned long ts;
- 	struct kref ref;
- 	atomic_t hold;
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
- 	bool ies_allocated;
-+#endif
- 
- 	/* must be last because of priv member */
- 	struct cfg80211_bss pub;
---- a/net/wireless/scan.c	2009-07-07 13:34:00.746682337 -0700
-+++ b/net/wireless/scan.c	2009-07-07 13:34:01.727705768 -0700
-@@ -88,10 +88,12 @@
- 	bss = container_of(ref, struct cfg80211_internal_bss, ref);
- 	if (bss->pub.free_priv)
- 		bss->pub.free_priv(&bss->pub);
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
- 
- 	if (bss->ies_allocated)
- 		kfree(bss->pub.information_elements);
- 
-+#endif
- 	BUG_ON(atomic_read(&bss->hold));
- 
- 	kfree(bss);
-@@ -397,12 +399,25 @@
- 
- 	found = rb_find_bss(dev, res);
- 
--	if (found) {
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
-+        if (found) {
-+#else 
-+        if (found && overwrite) {
-+                list_replace(&found->list, &res->list);
-+                rb_replace_node(&found->rbn, &res->rbn,
-+                                &dev->bss_tree);
-+                /* XXX: workaround */
-+                res->hold = found->hold;
-+                kref_put(&found->ref, bss_release);
-+                found = res;
-+        } else if (found) {
-+#endif
- 		found->pub.beacon_interval = res->pub.beacon_interval;
- 		found->pub.tsf = res->pub.tsf;
- 		found->pub.signal = res->pub.signal;
- 		found->pub.capability = res->pub.capability;
- 		found->ts = res->ts;
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
- 
- 		/* overwrite IEs */
- 		if (overwrite) {
-@@ -430,6 +445,7 @@
- 			}
- 		}
- 
+--- a/net/wireless/scan.c
++++ b/net/wireless/scan.c
+@@ -409,7 +409,11 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
+ 			size_t used = dev->wiphy.bss_priv_size + sizeof(*res);
+ 			size_t ielen = res->pub.len_information_elements;
+ 
++#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,28)
++			if (0) {
++#else
+ 			if (!found->ies_allocated && ksize(found) >= used + ielen) {
 +#endif
- 		kref_put(&res->ref, bss_release);
- 	} else {
- 		/* this "consumes" the reference */
+ 				memcpy(found->pub.information_elements,
+ 				       res->pub.information_elements, ielen);
+ 				found->pub.len_information_elements = ielen;
 --- a/drivers/net/wireless/Makefile	2009-07-06 12:53:07.479194884 -0700
 +++ b/drivers/net/wireless/Makefile	2009-07-06 12:54:42.026195576 -0700
 @@ -5,43 +5,16 @@
-- 
1.6.2.1

