Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54826 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756812Ab1JFUFl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 16:05:41 -0400
Subject: [PATCH] compat-wireless: add struct padding to fix wext issue
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Oct 2011 22:05:39 +0200
Message-ID: <1317931539.3945.9.camel@jlt3.sipsolutions.net> (sfid-20111006_220545_302520_2DC78A23)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

See description in the patch :-)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 patches/09-cfg80211-wext-padding.patch |   62 ++++++++++++++++++++++++++++++++
 1 files changed, 62 insertions(+), 0 deletions(-)
 create mode 100644 patches/09-cfg80211-wext-padding.patch

diff --git a/patches/09-cfg80211-wext-padding.patch b/patches/09-cfg80211-wext-padding.patch
new file mode 100644
index 0000000..36b4e70
--- /dev/null
+++ b/patches/09-cfg80211-wext-padding.patch
@@ -0,0 +1,62 @@
+This is a tricky one.
+
+Consider a kernel that has this code in net/wireless/wext-core.c:
+
+#ifdef CONFIG_CFG80211_WEXT
+        if (dev->ieee80211_ptr && dev->ieee80211_ptr->wiphy)
+                handlers = dev->ieee80211_ptr->wiphy->wext;
+#endif
+#ifdef CONFIG_WIRELESS_EXT
+        if (dev->wireless_handlers)
+                handlers = dev->wireless_handlers;
+#endif
+
+If a kernel is compiled without CONFIG_WIRELESS_EXT then
+compat-wireless can't do wireless extensions against it.
+However, if the kernel is compiled with CONFIG_CFG80211_WEXT
+then it will try to get the wext handlers from struct wiphy.
+
+Now, struct wiphy in the base kernel and struct wiphy in
+compat-wireless don't match, so the kernel crashes!!
+
+To fix this, add lots of padding to compat-wireless's
+struct wiphy so that the "wext" pointer is guaranteed
+to be NULL.
+
+Make sure the padding is larger than the struct so we
+don't ever run into this again because the wext pointer
+moved due to struct enlargements.
+
+
+--- a/include/net/cfg80211.h	2011-10-04 10:49:07.000000000 +0200
++++ b/include/net/cfg80211.h	2011-10-06 21:50:47.000000000 +0200
+@@ -1904,6 +1904,9 @@ struct wiphy_wowlan_support {
+ struct wiphy {
+ 	/* assign these fields before you register the wiphy */
+ 
++#define WIPHY_COMPAT_PAD_SIZE	2048
++	u8 padding[WIPHY_COMPAT_PAD_SIZE];
++
+ 	/* permanent MAC address(es) */
+ 	u8 perm_addr[ETH_ALEN];
+ 	u8 addr_mask[ETH_ALEN];
+--- a/net/wireless/core.c	2011-09-23 10:34:28.000000000 +0200
++++ b/net/wireless/core.c	2011-10-06 21:52:02.000000000 +0200
+@@ -330,6 +330,17 @@ struct wiphy *wiphy_new(const struct cfg
+ 	struct cfg80211_registered_device *rdev;
+ 	int alloc_size;
+ 
++	/*
++	 * Make sure the padding is >= the rest of the struct so that we
++	 * always keep it large enough to pad out the entire original
++	 * kernel's struct. We really only need to make sure it's larger
++	 * than the kernel compat is compiled against, but since it'll
++	 * only increase in size make sure it's larger than the current
++	 * version of it. Subtract since it's included.
++	 */
++	BUILD_BUG_ON(WIPHY_COMPAT_PAD_SIZE <
++		     sizeof(struct wiphy) - WIPHY_COMPAT_PAD_SIZE);
++
+ 	WARN_ON(ops->add_key && (!ops->del_key || !ops->set_default_key));
+ 	WARN_ON(ops->auth && (!ops->assoc || !ops->deauth || !ops->disassoc));
+ 	WARN_ON(ops->connect && !ops->disconnect);
-- 
1.7.6.3



