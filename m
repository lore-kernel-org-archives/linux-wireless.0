Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:37064 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071AbZDUUoH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2009 16:44:07 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] [compat-2.6] Symbol ksize is not exported in kernel older than 2.6.29.
Date: Tue, 21 Apr 2009 22:43:58 +0200
Message-Id: <1240346638-18755-2-git-send-email-hauke@hauke-m.de> (sfid-20090421_224410_016474_E580CAF6)
In-Reply-To: <1240346638-18755-1-git-send-email-hauke@hauke-m.de>
References: <1240346638-18755-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit ad80a7a983e36c6d8f4ae57e4c472deb9cf1391c from wireless-testing on older kernel versions.
Thanks Mathijs de Bruin for reporting.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat.diff |   64 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 64 insertions(+), 0 deletions(-)

diff --git a/compat/compat.diff b/compat/compat.diff
index e265090..5d35d27 100644
--- a/compat/compat.diff
+++ b/compat/compat.diff
@@ -669,3 +669,67 @@
  cfg80211-$(CONFIG_WIRELESS_EXT) += wext-compat.o
  
  ccflags-y += -D__CHECK_ENDIAN__
+--- a/net/wireless/core.h
++++ b/net/wireless/core.h
+@@ -85,7 +85,11 @@ struct cfg80211_internal_bss {
+ 	struct rb_node rbn;
+ 	unsigned long ts;
+ 	struct kref ref;
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ 	bool hold, ies_allocated;
++#else
++	bool hold;
++#endif
+ 
+ 	/* must be last because of priv member */
+ 	struct cfg80211_bss pub;
+--- a/net/wireless/scan.c
++++ b/net/wireless/scan.c
+@@ -58,10 +58,12 @@ static void bss_release(struct kref *ref)
+ 	bss = container_of(ref, struct cfg80211_internal_bss, ref);
+ 	if (bss->pub.free_priv)
+ 		bss->pub.free_priv(&bss->pub);
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ 
+ 	if (bss->ies_allocated)
+ 		kfree(bss->pub.information_elements);
+ 
++#endif
+ 	kfree(bss);
+ }
+ 
+@@ -364,13 +366,26 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
+ 
+ 	found = rb_find_bss(dev, res);
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ 	if (found) {
++#else
++	if (found && overwrite) {
++		list_replace(&found->list, &res->list);
++		rb_replace_node(&found->rbn, &res->rbn,
++				&dev->bss_tree);
++		/* XXX: workaround */
++		res->hold = found->hold;
++		kref_put(&found->ref, bss_release);
++		found = res;
++	} else if (found) {
++#endif
+ 		kref_get(&found->ref);
+ 		found->pub.beacon_interval = res->pub.beacon_interval;
+ 		found->pub.tsf = res->pub.tsf;
+ 		found->pub.signal = res->pub.signal;
+ 		found->pub.capability = res->pub.capability;
+ 		found->ts = res->ts;
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+ 
+ 		/* overwrite IEs */
+ 		if (overwrite) {
+@@ -399,6 +414,7 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
+ 			}
+ 		}
+ 
++#endif
+ 		kref_put(&res->ref, bss_release);
+ 	} else {
+ 		/* this "consumes" the reference */
-- 
1.6.2.1

