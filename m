Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51439 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab2G0LRD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 07:17:03 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 07/20] mac80211: reuse channels for channel contexts
Date: Fri, 27 Jul 2012 13:16:43 +0200
Message-Id: <1343387816-9414-8-git-send-email-johannes@sipsolutions.net> (sfid-20120727_131729_523363_783728AF)
In-Reply-To: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
References: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Kazior <michal.kazior@tieto.com>

Reuse channels with compatible channel types. Some
channel types are compatible and can be used
concurrently.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/chan.c |   58 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 57 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 90fef15..40e707c 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -167,7 +167,17 @@ bool ieee80211_set_channel_type(struct ieee80211_local *local,
 		sdata->vif.bss_conf.channel_type = chantype;
 
 	return true;
+}
+
+static void ieee80211_change_chantype(struct ieee80211_local *local,
+				      struct ieee80211_chanctx *ctx,
+				      enum nl80211_channel_type chantype)
+{
+	if (chantype == ctx->conf.channel_type)
+		return;
 
+	ctx->conf.channel_type = chantype;
+	drv_change_chantype(local, ctx);
 }
 
 static struct ieee80211_chanctx *
@@ -177,6 +187,7 @@ ieee80211_find_chanctx(struct ieee80211_local *local,
 		       enum ieee80211_chanctx_mode mode)
 {
 	struct ieee80211_chanctx *ctx;
+	enum nl80211_channel_type compat_type;
 
 	lockdep_assert_held(&local->chanctx_mtx);
 
@@ -186,13 +197,19 @@ ieee80211_find_chanctx(struct ieee80211_local *local,
 		return NULL;
 
 	list_for_each_entry(ctx, &local->chanctx_list, list) {
+		compat_type = ctx->conf.channel_type;
+
 		if (ctx->mode == IEEE80211_CHANCTX_EXCLUSIVE)
 			continue;
 		if (ctx->conf.channel != channel)
 			continue;
-		if (ctx->conf.channel_type != channel_type)
+		if (!ieee80211_channel_types_are_compatible(ctx->conf.channel_type,
+							    channel_type,
+							    &compat_type))
 			continue;
 
+		ieee80211_change_chantype(local, ctx, compat_type);
+
 		return ctx;
 	}
 
@@ -251,6 +268,43 @@ static void ieee80211_assign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
 	drv_assign_vif_chanctx(local, sdata, ctx);
 }
 
+static enum nl80211_channel_type
+ieee80211_calc_chantype(struct ieee80211_local *local,
+			struct ieee80211_chanctx *ctx)
+{
+	struct ieee80211_chanctx_conf *conf = &ctx->conf;
+	struct ieee80211_sub_if_data *sdata;
+	enum nl80211_channel_type result = NL80211_CHAN_NO_HT;
+
+	lockdep_assert_held(&local->chanctx_mtx);
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		if (!ieee80211_sdata_running(sdata))
+			continue;
+		if (sdata->vif.chanctx_conf != conf)
+			continue;
+
+		WARN_ON_ONCE(!ieee80211_channel_types_are_compatible(
+					sdata->vif.bss_conf.channel_type,
+					result, &result));
+	}
+	rcu_read_unlock();
+
+	return result;
+}
+
+static void ieee80211_recalc_chanctx_chantype(struct ieee80211_local *local,
+					      struct ieee80211_chanctx *ctx)
+{
+	enum nl80211_channel_type chantype;
+
+	lockdep_assert_held(&local->chanctx_mtx);
+
+	chantype = ieee80211_calc_chantype(local, ctx);
+	ieee80211_change_chantype(local, ctx, chantype);
+}
+
 static void ieee80211_unassign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
 					   struct ieee80211_chanctx *ctx)
 {
@@ -262,6 +316,8 @@ static void ieee80211_unassign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
 
 	ctx->refcount--;
 	sdata->vif.chanctx_conf = NULL;
+
+	ieee80211_recalc_chanctx_chantype(sdata->local, ctx);
 }
 
 static void __ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata)
-- 
1.7.10.4

