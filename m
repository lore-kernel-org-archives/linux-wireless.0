Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39665 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207AbXFVImj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2007 04:42:39 -0400
Message-Id: <20070621221800.482300000@sipsolutions.net>
References: <20070621221603.778432000@sipsolutions.net>
Date: Fri, 22 Jun 2007 00:16:15 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
Subject: [PATCH 12/14] mac80211: move some rate control functions out of  ieee80211.c
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I think these can go with rate control just as well and it makes
ieee80211.c more readable.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/ieee80211.c      |   41 -----------------------------------------
 net/mac80211/ieee80211_i.h    |    2 --
 net/mac80211/ieee80211_rate.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/ieee80211_rate.h |    6 ++++++
 4 files changed, 48 insertions(+), 43 deletions(-)

--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-06-21 23:41:18.698638003 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-06-21 23:41:34.598638003 +0200
@@ -1546,47 +1546,6 @@ void ieee80211_if_mgmt_setup(struct net_
 	dev->destructor = ieee80211_if_free;
 }
 
-int ieee80211_init_rate_ctrl_alg(struct ieee80211_local *local,
-				 const char *name)
-{
-	struct rate_control_ref *ref, *old;
-
-	ASSERT_RTNL();
-	if (local->open_count || netif_running(local->mdev) ||
-	    (local->apdev && netif_running(local->apdev)))
-		return -EBUSY;
-
-	ref = rate_control_alloc(name, local);
-	if (!ref) {
-		printk(KERN_WARNING "%s: Failed to select rate control "
-		       "algorithm\n", local->mdev->name);
-		return -ENOENT;
-	}
-
-	old = local->rate_ctrl;
-	local->rate_ctrl = ref;
-	if (old) {
-		rate_control_put(old);
-		sta_info_flush(local, NULL);
-	}
-
-	printk(KERN_DEBUG "%s: Selected rate control "
-	       "algorithm '%s'\n", local->mdev->name,
-	       ref->ops->name);
-
-
-	return 0;
-}
-
-static void rate_control_deinitialize(struct ieee80211_local *local)
-{
-	struct rate_control_ref *ref;
-
-	ref = local->rate_ctrl;
-	local->rate_ctrl = NULL;
-	rate_control_put(ref);
-}
-
 
 struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 					const struct ieee80211_ops *ops)
--- wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-06-21 23:42:31.898638003 +0200
+++ wireless-dev/net/mac80211/ieee80211_i.h	2007-06-21 23:43:44.138638003 +0200
@@ -803,8 +803,6 @@ void ieee80211_tx_set_iswep(struct ieee8
 int ieee80211_if_update_wds(struct net_device *dev, u8 *remote_addr);
 void ieee80211_if_setup(struct net_device *dev);
 void ieee80211_if_mgmt_setup(struct net_device *dev);
-int ieee80211_init_rate_ctrl_alg(struct ieee80211_local *local,
-				 const char *name);
 struct net_device_stats *ieee80211_dev_stats(struct net_device *dev);
 struct ieee80211_rate *ieee80211_get_rate(struct ieee80211_local *local,
 					  int phymode, int hwrate);
--- wireless-dev.orig/net/mac80211/ieee80211_rate.c	2007-06-21 23:41:37.238638003 +0200
+++ wireless-dev/net/mac80211/ieee80211_rate.c	2007-06-21 23:44:56.968638003 +0200
@@ -9,6 +9,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/rtnetlink.h>
 #include "ieee80211_rate.h"
 #include "ieee80211_i.h"
 
@@ -138,3 +139,44 @@ void rate_control_put(struct rate_contro
 {
 	kref_put(&ref->kref, rate_control_release);
 }
+
+int ieee80211_init_rate_ctrl_alg(struct ieee80211_local *local,
+				 const char *name)
+{
+	struct rate_control_ref *ref, *old;
+
+	ASSERT_RTNL();
+	if (local->open_count || netif_running(local->mdev) ||
+	    (local->apdev && netif_running(local->apdev)))
+		return -EBUSY;
+
+	ref = rate_control_alloc(name, local);
+	if (!ref) {
+		printk(KERN_WARNING "%s: Failed to select rate control "
+		       "algorithm\n", local->mdev->name);
+		return -ENOENT;
+	}
+
+	old = local->rate_ctrl;
+	local->rate_ctrl = ref;
+	if (old) {
+		rate_control_put(old);
+		sta_info_flush(local, NULL);
+	}
+
+	printk(KERN_DEBUG "%s: Selected rate control "
+	       "algorithm '%s'\n", local->mdev->name,
+	       ref->ops->name);
+
+
+	return 0;
+}
+
+void rate_control_deinitialize(struct ieee80211_local *local)
+{
+	struct rate_control_ref *ref;
+
+	ref = local->rate_ctrl;
+	local->rate_ctrl = NULL;
+	rate_control_put(ref);
+}
--- wireless-dev.orig/net/mac80211/ieee80211_rate.h	2007-06-21 23:42:58.208638003 +0200
+++ wireless-dev/net/mac80211/ieee80211_rate.h	2007-06-21 23:43:54.298638003 +0200
@@ -141,4 +141,10 @@ static inline void rate_control_remove_s
 #endif
 }
 
+
+/* functions for rate control related to a device */
+int ieee80211_init_rate_ctrl_alg(struct ieee80211_local *local,
+				 const char *name);
+void rate_control_deinitialize(struct ieee80211_local *local);
+
 #endif /* IEEE80211_RATE_H */

-- 

