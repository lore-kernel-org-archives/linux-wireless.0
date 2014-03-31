Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:45432 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbaCaLnU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2014 07:43:20 -0400
Received: by mail-wi0-f179.google.com with SMTP id z2so1365294wiv.0
        for <linux-wireless@vger.kernel.org>; Mon, 31 Mar 2014 04:43:19 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v3 07/13] mac80211: improve find_chanctx() for reservations
Date: Mon, 31 Mar 2014 12:39:25 +0200
Message-Id: <1396262371-6466-8-git-send-email-michal.kazior@tieto.com> (sfid-20140331_134326_606990_9DA32193)
In-Reply-To: <1396262371-6466-1-git-send-email-michal.kazior@tieto.com>
References: <1395409651-26120-1-git-send-email-michal.kazior@tieto.com>
 <1396262371-6466-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows new vifs to be assigned to a chanctx
as long as chanctx's reservation chandefs (if any)
and chanctx's current chandef (implied by assigned
vifs at the time, if any) and the new vif chandef
are all compatible.

This implies it is impossible to assign a new vif
to an in-place reservation chanctx.

This gives no advantages for single-channel
hardware. It makes sense for multi-channel
hardware only.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
v2:
 * remove redundant calls to _chandef() [Eliad]
 * dont use rcu_access_pointer() [Eliad]

v3:
 * fix commit message so it makes more sense [Johannes]

 net/mac80211/chan.c | 56 +++++++++++++++++++++++++++--------------------------
 1 file changed, 29 insertions(+), 27 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index ad29e6e..e14d756 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -28,6 +28,29 @@ static bool ieee80211_can_create_new_chanctx(struct ieee80211_local *local)
 	return ieee80211_num_chanctx(local) < ieee80211_max_num_channels(local);
 }
 
+static const struct cfg80211_chan_def *
+ieee80211_chanctx_reserved_chandef(struct ieee80211_local *local,
+				   struct ieee80211_chanctx *ctx,
+				   const struct cfg80211_chan_def *compat)
+{
+	struct ieee80211_sub_if_data *sdata;
+
+	lockdep_assert_held(&local->chanctx_mtx);
+
+	list_for_each_entry(sdata, &ctx->reserved_vifs,
+			    reserved_chanctx_list) {
+		if (!compat)
+			compat = &sdata->reserved_chandef;
+
+		compat = cfg80211_chandef_compatible(&sdata->reserved_chandef,
+						     compat);
+		if (!compat)
+			break;
+	}
+
+	return compat;
+}
+
 static enum nl80211_chan_width ieee80211_get_sta_bw(struct ieee80211_sta *sta)
 {
 	switch (sta->bandwidth) {
@@ -181,27 +204,6 @@ static void ieee80211_change_chanctx(struct ieee80211_local *local,
 	}
 }
 
-static bool ieee80211_chanctx_is_reserved(struct ieee80211_local *local,
-					  struct ieee80211_chanctx *ctx)
-{
-	struct ieee80211_sub_if_data *sdata;
-	bool ret = false;
-
-	lockdep_assert_held(&local->chanctx_mtx);
-	rcu_read_lock();
-	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-		if (!ieee80211_sdata_running(sdata))
-			continue;
-		if (sdata->reserved_chanctx == ctx) {
-			ret = true;
-			break;
-		}
-	}
-
-	rcu_read_unlock();
-	return ret;
-}
-
 static struct ieee80211_chanctx *
 ieee80211_find_chanctx(struct ieee80211_local *local,
 		       const struct cfg80211_chan_def *chandef,
@@ -217,18 +219,18 @@ ieee80211_find_chanctx(struct ieee80211_local *local,
 	list_for_each_entry(ctx, &local->chanctx_list, list) {
 		const struct cfg80211_chan_def *compat;
 
-		/* We don't support chanctx reservation for multiple
-		 * vifs yet, so don't allow reserved chanctxs to be
-		 * reused.
-		 */
-		if ((ctx->mode == IEEE80211_CHANCTX_EXCLUSIVE) ||
-		    ieee80211_chanctx_is_reserved(local, ctx))
+		if (ctx->mode == IEEE80211_CHANCTX_EXCLUSIVE)
 			continue;
 
 		compat = cfg80211_chandef_compatible(&ctx->conf.def, chandef);
 		if (!compat)
 			continue;
 
+		compat = ieee80211_chanctx_reserved_chandef(local, ctx,
+							    compat);
+		if (!compat)
+			continue;
+
 		ieee80211_change_chanctx(local, ctx, compat);
 
 		return ctx;
-- 
1.8.5.3

