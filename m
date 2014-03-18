Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:52526 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640AbaCRN7S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 09:59:18 -0400
Received: by mail-ee0-f41.google.com with SMTP id t10so5448614eei.0
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 06:59:17 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 09/21] mac80211: split ieee80211_new_chanctx()
Date: Tue, 18 Mar 2014 14:53:12 +0100
Message-Id: <1395150804-24090-10-git-send-email-michal.kazior@tieto.com> (sfid-20140318_145934_321683_92969B09)
In-Reply-To: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function did a little too much. Split it up so
the code can be easily reused in the future.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/chan.c | 56 ++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 43 insertions(+), 13 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index f6d8610..1982e33 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -353,19 +353,17 @@ static bool ieee80211_is_radar_required(struct ieee80211_local *local)
 }
 
 static struct ieee80211_chanctx *
-ieee80211_new_chanctx(struct ieee80211_local *local,
-		      const struct cfg80211_chan_def *chandef,
-		      enum ieee80211_chanctx_mode mode)
+ieee80211_alloc_chanctx(struct ieee80211_local *local,
+			const struct cfg80211_chan_def *chandef,
+			enum ieee80211_chanctx_mode mode)
 {
 	struct ieee80211_chanctx *ctx;
-	u32 changed;
-	int err;
 
 	lockdep_assert_held(&local->chanctx_mtx);
 
 	ctx = kzalloc(sizeof(*ctx) + local->hw.chanctx_data_size, GFP_KERNEL);
 	if (!ctx)
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 
 	INIT_LIST_HEAD(&ctx->assigned_vifs);
 	INIT_LIST_HEAD(&ctx->reserved_vifs);
@@ -375,31 +373,63 @@ ieee80211_new_chanctx(struct ieee80211_local *local,
 	ctx->mode = mode;
 	ctx->conf.radar_enabled = ieee80211_is_radar_required(local);
 	ieee80211_recalc_chanctx_min_def(local, ctx);
+
+	return ctx;
+}
+
+static int ieee80211_add_chanctx(struct ieee80211_local *local,
+				 struct ieee80211_chanctx *ctx)
+{
+	u32 changed;
+	int err;
+
+	lockdep_assert_held(&local->mtx);
+	lockdep_assert_held(&local->chanctx_mtx);
+
 	if (!local->use_chanctx)
 		local->hw.conf.radar_enabled = ctx->conf.radar_enabled;
 
-	/* we hold the mutex to prevent idle from changing */
-	lockdep_assert_held(&local->mtx);
 	/* turn idle off *before* setting channel -- some drivers need that */
 	changed = ieee80211_idle_off(local);
 	if (changed)
 		ieee80211_hw_config(local, changed);
 
 	if (!local->use_chanctx) {
-		local->_oper_chandef = *chandef;
+		local->_oper_chandef = ctx->conf.def;
 		ieee80211_hw_config(local, 0);
 	} else {
 		err = drv_add_chanctx(local, ctx);
 		if (err) {
-			kfree(ctx);
 			ieee80211_recalc_idle(local);
-			return ERR_PTR(err);
+			return err;
 		}
 	}
 
-	/* and keep the mutex held until the new chanctx is on the list */
-	list_add_rcu(&ctx->list, &local->chanctx_list);
+	return 0;
+}
+
+static struct ieee80211_chanctx *
+ieee80211_new_chanctx(struct ieee80211_local *local,
+		      const struct cfg80211_chan_def *chandef,
+		      enum ieee80211_chanctx_mode mode)
+{
+	struct ieee80211_chanctx *ctx;
+	int err;
+
+	lockdep_assert_held(&local->mtx);
+	lockdep_assert_held(&local->chanctx_mtx);
+
+	ctx = ieee80211_alloc_chanctx(local, chandef, mode);
+	if (!ctx)
+		return ERR_PTR(-ENOMEM);
 
+	err = ieee80211_add_chanctx(local, ctx);
+	if (err) {
+		kfree(ctx);
+		return ERR_PTR(err);
+	}
+
+	list_add_rcu(&ctx->list, &local->chanctx_list);
 	return ctx;
 }
 
-- 
1.8.5.3

