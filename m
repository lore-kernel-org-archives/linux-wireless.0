Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:63733 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586AbaCRN7P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 09:59:15 -0400
Received: by mail-ee0-f50.google.com with SMTP id c13so5499008eek.9
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 06:59:14 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 07/21] mac80211: improve find_chanctx() for reservations
Date: Tue, 18 Mar 2014 14:53:10 +0100
Message-Id: <1395150804-24090-8-git-send-email-michal.kazior@tieto.com> (sfid-20140318_150215_867190_C173F080)
In-Reply-To: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Relax ieee80211_find_chanctx(). If chanctx
reservation chandef is compatible with
current-future assigned interfaces chandef then
allow it to be used by new interfaces.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/chan.c | 56 +++++++++++++++++++++++++++--------------------------
 1 file changed, 29 insertions(+), 27 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 525739b..08c7653 100644
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
@@ -187,27 +210,6 @@ static void ieee80211_change_chanctx(struct ieee80211_local *local,
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
@@ -223,18 +225,18 @@ ieee80211_find_chanctx(struct ieee80211_local *local,
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

