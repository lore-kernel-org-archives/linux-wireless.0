Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51435 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab2G0LRC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 07:17:02 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 05/20] mac80211: use channel context notifications
Date: Fri, 27 Jul 2012 13:16:41 +0200
Message-Id: <1343387816-9414-6-git-send-email-johannes@sipsolutions.net> (sfid-20120727_131736_126778_2A4BAC6F)
In-Reply-To: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
References: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
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
index 184b8bd..8d77ad13 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -5,6 +5,7 @@
 #include <linux/nl80211.h>
 #include <net/cfg80211.h>
 #include "ieee80211_i.h"
+#include "driver-ops.h"
 
 static enum ieee80211_chan_mode
 __ieee80211_get_channel_mode(struct ieee80211_local *local,
@@ -190,6 +191,8 @@ ieee80211_new_chanctx(struct ieee80211_local *local,
 
 	list_add(&ctx->list, &local->chanctx_list);
 
+	drv_add_chanctx(local, ctx);
+
 	return ctx;
 }
 
@@ -200,6 +203,8 @@ static void ieee80211_free_chanctx(struct ieee80211_local *local,
 
 	WARN_ON_ONCE(ctx->refcount != 0);
 
+	drv_remove_chanctx(ctx->local, ctx);
+
 	list_del(&ctx->list);
 	kfree(ctx);
 }
@@ -207,21 +212,25 @@ static void ieee80211_free_chanctx(struct ieee80211_local *local,
 static void ieee80211_assign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
 					 struct ieee80211_chanctx *ctx)
 {
-	struct ieee80211_local *local __maybe_unused = sdata->local;
+	struct ieee80211_local *local = sdata->local;
 
 	lockdep_assert_held(&local->chanctx_mtx);
 
 	sdata->vif.chanctx_conf = &ctx->conf;
 	ctx->refcount++;
+
+	drv_assign_vif_chanctx(local, sdata, ctx);
 }
 
 static void ieee80211_unassign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
 					   struct ieee80211_chanctx *ctx)
 {
-	struct ieee80211_local *local __maybe_unused = sdata->local;
+	struct ieee80211_local *local = sdata->local;
 
 	lockdep_assert_held(&local->chanctx_mtx);
 
+	drv_unassign_vif_chanctx(local, sdata, ctx);
+
 	ctx->refcount--;
 	sdata->vif.chanctx_conf = NULL;
 }
-- 
1.7.10.4

