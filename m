Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60801 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933353AbaDINgA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 09:36:00 -0400
Received: by mail-ee0-f46.google.com with SMTP id t10so1866926eei.5
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2014 06:35:59 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, luca@coelho.fi,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v4 08/13] mac80211: improve chanctx reservation lookup
Date: Wed,  9 Apr 2014 15:29:29 +0200
Message-Id: <1397050174-26121-9-git-send-email-michal.kazior@tieto.com> (sfid-20140409_153656_822079_98231353)
In-Reply-To: <1397050174-26121-1-git-send-email-michal.kazior@tieto.com>
References: <1396262371-6466-1-git-send-email-michal.kazior@tieto.com>
 <1397050174-26121-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use a separate function to look for reservation
chanctx. For multi-interface/channel reservation
search sematics differ slightly.

The new routine allows reservations to be merged
with chanctx that are already reserved by other
interface(s).

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/chan.c | 90 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 88 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 0dfb04a..7303edd 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -51,6 +51,93 @@ ieee80211_chanctx_reserved_chandef(struct ieee80211_local *local,
 	return compat;
 }
 
+static const struct cfg80211_chan_def *
+ieee80211_chanctx_non_reserved_chandef(struct ieee80211_local *local,
+				       struct ieee80211_chanctx *ctx,
+				       const struct cfg80211_chan_def *compat)
+{
+	struct ieee80211_sub_if_data *sdata;
+
+	lockdep_assert_held(&local->chanctx_mtx);
+
+	list_for_each_entry(sdata, &ctx->assigned_vifs,
+			    assigned_chanctx_list) {
+		if (sdata->reserved_chanctx != NULL)
+			continue;
+
+		if (!compat)
+			compat = &sdata->vif.bss_conf.chandef;
+
+		compat = cfg80211_chandef_compatible(
+				&sdata->vif.bss_conf.chandef, compat);
+		if (!compat)
+			break;
+	}
+
+	return compat;
+}
+
+static const struct cfg80211_chan_def *
+ieee80211_chanctx_combined_chandef(struct ieee80211_local *local,
+				   struct ieee80211_chanctx *ctx,
+				   const struct cfg80211_chan_def *compat)
+{
+	lockdep_assert_held(&local->chanctx_mtx);
+
+	compat = ieee80211_chanctx_reserved_chandef(local, ctx, compat);
+	if (!compat)
+		return NULL;
+
+	compat = ieee80211_chanctx_non_reserved_chandef(local, ctx, compat);
+	if (!compat)
+		return NULL;
+
+	return compat;
+}
+
+static bool
+ieee80211_chanctx_can_reserve_chandef(struct ieee80211_local *local,
+				      struct ieee80211_chanctx *ctx,
+				      const struct cfg80211_chan_def *def)
+{
+	lockdep_assert_held(&local->chanctx_mtx);
+
+	if (ieee80211_chanctx_combined_chandef(local, ctx, def))
+		return true;
+
+	if (!list_empty(&ctx->reserved_vifs) &&
+	    ieee80211_chanctx_reserved_chandef(local, ctx, def))
+		return true;
+
+	return false;
+}
+
+static struct ieee80211_chanctx *
+ieee80211_find_reservation_chanctx(struct ieee80211_local *local,
+				   const struct cfg80211_chan_def *chandef,
+				   enum ieee80211_chanctx_mode mode)
+{
+	struct ieee80211_chanctx *ctx;
+
+	lockdep_assert_held(&local->chanctx_mtx);
+
+	if (mode == IEEE80211_CHANCTX_EXCLUSIVE)
+		return NULL;
+
+	list_for_each_entry(ctx, &local->chanctx_list, list) {
+		if (ctx->mode == IEEE80211_CHANCTX_EXCLUSIVE)
+			continue;
+
+		if (!ieee80211_chanctx_can_reserve_chandef(local, ctx,
+							   chandef))
+			continue;
+
+		return ctx;
+	}
+
+	return NULL;
+}
+
 static enum nl80211_chan_width ieee80211_get_sta_bw(struct ieee80211_sta *sta)
 {
 	switch (sta->bandwidth) {
@@ -771,8 +858,7 @@ int ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
 
 	curr_ctx = container_of(conf, struct ieee80211_chanctx, conf);
 
-	/* try to find another context with the chandef we want */
-	new_ctx = ieee80211_find_chanctx(local, chandef, mode);
+	new_ctx = ieee80211_find_reservation_chanctx(local, chandef, mode);
 	if (!new_ctx) {
 		if (curr_ctx->refcount == 1 &&
 		    (local->hw.flags & IEEE80211_HW_CHANGE_RUNNING_CHANCTX)) {
-- 
1.8.5.3

