Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:48030 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933360AbaDINgD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 09:36:03 -0400
Received: by mail-ee0-f44.google.com with SMTP id e49so1900054eek.31
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2014 06:36:02 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, luca@coelho.fi,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v4 10/13] mac80211: split ieee80211_free_chanctx()
Date: Wed,  9 Apr 2014 15:29:31 +0200
Message-Id: <1397050174-26121-11-git-send-email-michal.kazior@tieto.com> (sfid-20140409_153629_189842_6F973092)
In-Reply-To: <1397050174-26121-1-git-send-email-michal.kazior@tieto.com>
References: <1396262371-6466-1-git-send-email-michal.kazior@tieto.com>
 <1397050174-26121-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function did a little too much. Split it up so
the code can be easily reused in the future.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/chan.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 247133f..e4166b3 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -431,14 +431,11 @@ ieee80211_new_chanctx(struct ieee80211_local *local,
 	return ctx;
 }
 
-static void ieee80211_free_chanctx(struct ieee80211_local *local,
-				   struct ieee80211_chanctx *ctx)
+static void ieee80211_del_chanctx(struct ieee80211_local *local,
+				  struct ieee80211_chanctx *ctx)
 {
-	bool check_single_channel = false;
 	lockdep_assert_held(&local->chanctx_mtx);
 
-	WARN_ON_ONCE(ctx->refcount != 0);
-
 	if (!local->use_chanctx) {
 		struct cfg80211_chan_def *chandef = &local->_oper_chandef;
 		chandef->width = NL80211_CHAN_WIDTH_20_NOHT;
@@ -448,8 +445,9 @@ static void ieee80211_free_chanctx(struct ieee80211_local *local,
 		/* NOTE: Disabling radar is only valid here for
 		 * single channel context. To be sure, check it ...
 		 */
-		if (local->hw.conf.radar_enabled)
-			check_single_channel = true;
+		WARN_ON(local->hw.conf.radar_enabled &&
+			!list_empty(&local->chanctx_list));
+
 		local->hw.conf.radar_enabled = false;
 
 		ieee80211_hw_config(local, 0);
@@ -457,13 +455,19 @@ static void ieee80211_free_chanctx(struct ieee80211_local *local,
 		drv_remove_chanctx(local, ctx);
 	}
 
-	list_del_rcu(&ctx->list);
-	kfree_rcu(ctx, rcu_head);
+	ieee80211_recalc_idle(local);
+}
 
-	/* throw a warning if this wasn't the only channel context. */
-	WARN_ON(check_single_channel && !list_empty(&local->chanctx_list));
+static void ieee80211_free_chanctx(struct ieee80211_local *local,
+				   struct ieee80211_chanctx *ctx)
+{
+	lockdep_assert_held(&local->chanctx_mtx);
 
-	ieee80211_recalc_idle(local);
+	WARN_ON_ONCE(ctx->refcount != 0);
+
+	list_del_rcu(&ctx->list);
+	ieee80211_del_chanctx(local, ctx);
+	kfree_rcu(ctx, rcu_head);
 }
 
 static void ieee80211_recalc_chanctx_chantype(struct ieee80211_local *local,
-- 
1.8.5.3

