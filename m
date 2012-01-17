Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42916 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab2AQJdb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 04:33:31 -0500
Subject: [PATCH] mac80211: clean up rate control code
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Jan 2012 10:33:29 +0100
Message-ID: <1326792809.3342.8.camel@jlt3.sipsolutions.net> (sfid-20120117_103335_775416_776E828F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

It seems exceedingly unlikely that we'll ever
support swapping rate control algorithms at
runtime, so remove the unused refcounting code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rate.c     |   27 ++++-----------------------
 net/mac80211/rate.h     |    4 ----
 net/mac80211/sta_info.c |   10 +++-------
 3 files changed, 7 insertions(+), 34 deletions(-)

--- a/net/mac80211/rate.c	2012-01-17 10:32:36.000000000 +0100
+++ b/net/mac80211/rate.c	2012-01-17 10:32:41.000000000 +0100
@@ -159,7 +159,6 @@ static struct rate_control_ref *rate_con
 	ref = kmalloc(sizeof(struct rate_control_ref), GFP_KERNEL);
 	if (!ref)
 		goto fail_ref;
-	kref_init(&ref->kref);
 	ref->local = local;
 	ref->ops = ieee80211_rate_control_ops_get(name);
 	if (!ref->ops)
@@ -184,11 +183,8 @@ fail_ref:
 	return NULL;
 }
 
-static void rate_control_release(struct kref *kref)
+static void rate_control_free(struct rate_control_ref *ctrl_ref)
 {
-	struct rate_control_ref *ctrl_ref;
-
-	ctrl_ref = container_of(kref, struct rate_control_ref, kref);
 	ctrl_ref->ops->free(ctrl_ref->priv);
 
 #ifdef CONFIG_MAC80211_DEBUGFS
@@ -383,21 +379,10 @@ void rate_control_get_rate(struct ieee80
 	BUG_ON(info->control.rates[0].idx < 0);
 }
 
-struct rate_control_ref *rate_control_get(struct rate_control_ref *ref)
-{
-	kref_get(&ref->kref);
-	return ref;
-}
-
-void rate_control_put(struct rate_control_ref *ref)
-{
-	kref_put(&ref->kref, rate_control_release);
-}
-
 int ieee80211_init_rate_ctrl_alg(struct ieee80211_local *local,
 				 const char *name)
 {
-	struct rate_control_ref *ref, *old;
+	struct rate_control_ref *ref;
 
 	ASSERT_RTNL();
 
@@ -417,12 +402,8 @@ int ieee80211_init_rate_ctrl_alg(struct
 		return -ENOENT;
 	}
 
-	old = local->rate_ctrl;
+	WARN_ON(local->rate_ctrl);
 	local->rate_ctrl = ref;
-	if (old) {
-		rate_control_put(old);
-		sta_info_flush(local, NULL);
-	}
 
 	wiphy_debug(local->hw.wiphy, "Selected rate control algorithm '%s'\n",
 		    ref->ops->name);
@@ -440,6 +421,6 @@ void rate_control_deinitialize(struct ie
 		return;
 
 	local->rate_ctrl = NULL;
-	rate_control_put(ref);
+	rate_control_free(ref);
 }
 
--- a/net/mac80211/rate.h	2012-01-17 10:32:36.000000000 +0100
+++ b/net/mac80211/rate.h	2012-01-17 10:32:41.000000000 +0100
@@ -14,7 +14,6 @@
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
 #include <linux/types.h>
-#include <linux/kref.h>
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
 #include "sta_info.h"
@@ -23,14 +22,11 @@ struct rate_control_ref {
 	struct ieee80211_local *local;
 	struct rate_control_ops *ops;
 	void *priv;
-	struct kref kref;
 };
 
 void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
 			   struct sta_info *sta,
 			   struct ieee80211_tx_rate_control *txrc);
-struct rate_control_ref *rate_control_get(struct rate_control_ref *ref);
-void rate_control_put(struct rate_control_ref *ref);
 
 static inline void rate_control_tx_status(struct ieee80211_local *local,
 					  struct ieee80211_supported_band *sband,
--- a/net/mac80211/sta_info.c	2012-01-17 10:32:37.000000000 +0100
+++ b/net/mac80211/sta_info.c	2012-01-17 10:32:41.000000000 +0100
@@ -208,10 +208,8 @@ struct sta_info *sta_info_get_by_idx(str
  */
 void sta_info_free(struct ieee80211_local *local, struct sta_info *sta)
 {
-	if (sta->rate_ctrl) {
+	if (sta->rate_ctrl)
 		rate_control_free_sta(sta);
-		rate_control_put(sta->rate_ctrl);
-	}
 
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 	wiphy_debug(local->hw.wiphy, "Destroyed STA %pM\n", sta->sta.addr);
@@ -262,13 +260,11 @@ static int sta_prepare_rate_control(stru
 	if (local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL)
 		return 0;
 
-	sta->rate_ctrl = rate_control_get(local->rate_ctrl);
+	sta->rate_ctrl = local->rate_ctrl;
 	sta->rate_ctrl_priv = rate_control_alloc_sta(sta->rate_ctrl,
 						     &sta->sta, gfp);
-	if (!sta->rate_ctrl_priv) {
-		rate_control_put(sta->rate_ctrl);
+	if (!sta->rate_ctrl_priv)
 		return -ENOMEM;
-	}
 
 	return 0;
 }


