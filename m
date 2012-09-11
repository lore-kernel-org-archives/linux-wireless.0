Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40291 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab2IKNZr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2012 09:25:47 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC v2 03/12] mac80211: use channel context notifications
Date: Tue, 11 Sep 2012 15:26:14 +0200
Message-Id: <1347369983-12459-4-git-send-email-johannes@sipsolutions.net> (sfid-20120911_152552_439877_46813640)
In-Reply-To: <1347369983-12459-1-git-send-email-johannes@sipsolutions.net>
References: <1347369983-12459-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Kazior <michal.kazior@tieto.com>

Channel context pointer will be accessible on
both assign and unassign events.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/chan.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 9674968..d8580ec 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -5,6 +5,7 @@
 #include <linux/nl80211.h>
 #include <net/cfg80211.h>
 #include "ieee80211_i.h"
+#include "driver-ops.h"
 
 static enum ieee80211_chan_mode
 __ieee80211_get_channel_mode(struct ieee80211_local *local,
@@ -218,6 +219,8 @@ ieee80211_new_chanctx(struct ieee80211_local *local,
 
 	list_add(&ctx->list, &local->chanctx_list);
 
+	drv_add_chanctx(local, ctx);
+
 	return ctx;
 }
 
@@ -228,6 +231,8 @@ static void ieee80211_free_chanctx(struct ieee80211_local *local,
 
 	WARN_ON_ONCE(ctx->refcount != 0);
 
+	drv_remove_chanctx(local, ctx);
+
 	list_del(&ctx->list);
 	kfree_rcu(ctx, rcu_head);
 }
@@ -235,10 +240,12 @@ static void ieee80211_free_chanctx(struct ieee80211_local *local,
 static void ieee80211_assign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
 					 struct ieee80211_chanctx *ctx)
 {
-	struct ieee80211_local *local __maybe_unused = sdata->local;
+	struct ieee80211_local *local = sdata->local;
 
 	lockdep_assert_held(&local->chanctx_mtx);
 
+	drv_assign_vif_chanctx(local, sdata, ctx);
+
 	rcu_assign_pointer(sdata->vif.chanctx_conf, &ctx->conf);
 	ctx->refcount++;
 }
@@ -246,12 +253,14 @@ static void ieee80211_assign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
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

