Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56700 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab2LNL7K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2012 06:59:10 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/3] mac80211: fix channel context iteration
Date: Fri, 14 Dec 2012 12:59:28 +0100
Message-Id: <1355486368-14563-4-git-send-email-johannes@sipsolutions.net> (sfid-20121214_125918_427726_0C5B62EE)
In-Reply-To: <1355486368-14563-1-git-send-email-johannes@sipsolutions.net>
References: <1355486368-14563-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

During suspend/resume channel contexts might be
iterated even if they haven't been re-added to
the driver, keep track of this and skip them in
iteration. Also use the new status for sanity
checks.

Change-Id: Ibac29191dcc24578d56565c36a543d7a9733be10
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/chan.c        |  3 ++-
 net/mac80211/driver-ops.h  | 15 ++++++++++++---
 net/mac80211/ieee80211_i.h |  1 +
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 80e5552..1bfe0a8 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -381,7 +381,8 @@ void ieee80211_iter_chan_contexts_atomic(
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(ctx, &local->chanctx_list, list)
-		iter(hw, &ctx->conf, iter_data);
+		if (ctx->driver_present)
+			iter(hw, &ctx->conf, iter_data);
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(ieee80211_iter_chan_contexts_atomic);
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index c6560cc..70dcc42 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -913,6 +913,8 @@ static inline int drv_add_chanctx(struct ieee80211_local *local,
 	if (local->ops->add_chanctx)
 		ret = local->ops->add_chanctx(&local->hw, &ctx->conf);
 	trace_drv_return_int(local, ret);
+	if (!ret)
+		ctx->driver_present = true;
 
 	return ret;
 }
@@ -924,6 +926,7 @@ static inline void drv_remove_chanctx(struct ieee80211_local *local,
 	if (local->ops->remove_chanctx)
 		local->ops->remove_chanctx(&local->hw, &ctx->conf);
 	trace_drv_return_void(local);
+	ctx->driver_present = false;
 }
 
 static inline void drv_change_chanctx(struct ieee80211_local *local,
@@ -931,8 +934,10 @@ static inline void drv_change_chanctx(struct ieee80211_local *local,
 				      u32 changed)
 {
 	trace_drv_change_chanctx(local, ctx, changed);
-	if (local->ops->change_chanctx)
+	if (local->ops->change_chanctx) {
+		WARN_ON_ONCE(!ctx->driver_present);
 		local->ops->change_chanctx(&local->hw, &ctx->conf, changed);
+	}
 	trace_drv_return_void(local);
 }
 
@@ -945,10 +950,12 @@ static inline int drv_assign_vif_chanctx(struct ieee80211_local *local,
 	check_sdata_in_driver(sdata);
 
 	trace_drv_assign_vif_chanctx(local, sdata, ctx);
-	if (local->ops->assign_vif_chanctx)
+	if (local->ops->assign_vif_chanctx) {
+		WARN_ON_ONCE(!ctx->driver_present);
 		ret = local->ops->assign_vif_chanctx(&local->hw,
 						     &sdata->vif,
 						     &ctx->conf);
+	}
 	trace_drv_return_int(local, ret);
 
 	return ret;
@@ -961,10 +968,12 @@ static inline void drv_unassign_vif_chanctx(struct ieee80211_local *local,
 	check_sdata_in_driver(sdata);
 
 	trace_drv_unassign_vif_chanctx(local, sdata, ctx);
-	if (local->ops->unassign_vif_chanctx)
+	if (local->ops->unassign_vif_chanctx) {
+		WARN_ON_ONCE(!ctx->driver_present);
 		local->ops->unassign_vif_chanctx(&local->hw,
 						 &sdata->vif,
 						 &ctx->conf);
+	}
 	trace_drv_return_void(local);
 }
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 0360b74..2bb0c98 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -687,6 +687,7 @@ struct ieee80211_chanctx {
 
 	enum ieee80211_chanctx_mode mode;
 	int refcount;
+	bool driver_present;
 
 	struct ieee80211_chanctx_conf conf;
 };
-- 
1.8.0

