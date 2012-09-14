Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52615 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab2INMgj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2012 08:36:39 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 03/10] mac80211: use channel context notifications
Date: Fri, 14 Sep 2012 14:37:06 +0200
Message-Id: <1347626233-21916-4-git-send-email-johannes@sipsolutions.net> (sfid-20120914_143645_815344_61A3B180)
In-Reply-To: <1347626233-21916-1-git-send-email-johannes@sipsolutions.net>
References: <1347626233-21916-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Kazior <michal.kazior@tieto.com>

Channel context pointer will be accessible on
both assign and unassign events.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/chan.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index d3181cd..d4b8876 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -5,6 +5,7 @@
 #include <linux/nl80211.h>
 #include <net/cfg80211.h>
 #include "ieee80211_i.h"
+#include "driver-ops.h"
 
 static enum ieee80211_chan_mode
 __ieee80211_get_channel_mode(struct ieee80211_local *local,
@@ -205,6 +206,7 @@ ieee80211_new_chanctx(struct ieee80211_local *local,
 		      enum ieee80211_chanctx_mode mode)
 {
 	struct ieee80211_chanctx *ctx;
+	int err;
 
 	lockdep_assert_held(&local->chanctx_mtx);
 
@@ -216,6 +218,12 @@ ieee80211_new_chanctx(struct ieee80211_local *local,
 	ctx->conf.channel_type = channel_type;
 	ctx->mode = mode;
 
+	err = drv_add_chanctx(local, ctx);
+	if (err) {
+		kfree(ctx);
+		return ERR_PTR(err);
+	}
+
 	list_add(&ctx->list, &local->chanctx_list);
 
 	return ctx;
@@ -228,6 +236,8 @@ static void ieee80211_free_chanctx(struct ieee80211_local *local,
 
 	WARN_ON_ONCE(ctx->refcount != 0);
 
+	drv_remove_chanctx(local, ctx);
+
 	list_del(&ctx->list);
 	kfree_rcu(ctx, rcu_head);
 }
@@ -235,10 +245,15 @@ static void ieee80211_free_chanctx(struct ieee80211_local *local,
 static int ieee80211_assign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
 					struct ieee80211_chanctx *ctx)
 {
-	struct ieee80211_local *local __maybe_unused = sdata->local;
+	struct ieee80211_local *local = sdata->local;
+	int ret;
 
 	lockdep_assert_held(&local->chanctx_mtx);
 
+	ret = drv_assign_vif_chanctx(local, sdata, ctx);
+	if (ret)
+		return ret;
+
 	rcu_assign_pointer(sdata->vif.chanctx_conf, &ctx->conf);
 	ctx->refcount++;
 
@@ -248,12 +263,14 @@ static int ieee80211_assign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
 static void ieee80211_unassign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
 					   struct ieee80211_chanctx *ctx)
 {
-	struct ieee80211_local *local __maybe_unused = sdata->local;
+	struct ieee80211_local *local = sdata->local;
 
 	lockdep_assert_held(&local->chanctx_mtx);
 
 	ctx->refcount--;
 	rcu_assign_pointer(sdata->vif.chanctx_conf, NULL);
+
+	drv_unassign_vif_chanctx(local, sdata, ctx);
 }
 
 static void __ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata)
-- 
1.7.10.4

