Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:63983 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbaCGCUc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2014 21:20:32 -0500
Received: by mail-pa0-f47.google.com with SMTP id lj1so3488628pab.34
        for <linux-wireless@vger.kernel.org>; Thu, 06 Mar 2014 18:20:32 -0800 (PST)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 1/4] mac80211: refactor recalculate channel context functions (1)
Date: Fri,  7 Mar 2014 10:17:27 +0800
Message-Id: <8966cabb0cf4c83da8fd37e4a5ec1df8727e9dbe.1394158459.git.gamerh2o@gmail.com> (sfid-20140307_032036_488237_6D3C473A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Function ieee80211_change_chanctx() updates struct
ieee80211_chanctx_conf's def and min_def members, in a somewhat mixed
way. Since there are other members can be updated, this function's
name is a bit inaccurate.

Rename ieee80211_change_chanctx() to ieee80211_recalc_chanctx_def()
and only update def member in this function. Add a wrapper function
_ieee80211_recalc_chanctx_chantype() to do ieee80211_change_chanctx()'s
work.

Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 net/mac80211/chan.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 42c6592..49fa37e 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -143,9 +143,10 @@ void ieee80211_recalc_chanctx_min_def(struct ieee80211_local *local,
 	drv_change_chanctx(local, ctx, IEEE80211_CHANCTX_CHANGE_MIN_WIDTH);
 }
 
-static void ieee80211_change_chanctx(struct ieee80211_local *local,
-				     struct ieee80211_chanctx *ctx,
-				     const struct cfg80211_chan_def *chandef)
+static void
+ieee80211_recalc_chanctx_def(struct ieee80211_local *local,
+			     struct ieee80211_chanctx *ctx,
+			     const struct cfg80211_chan_def *chandef)
 {
 	if (cfg80211_chandef_identical(&ctx->conf.def, chandef))
 		return;
@@ -154,7 +155,6 @@ static void ieee80211_change_chanctx(struct ieee80211_local *local,
 
 	ctx->conf.def = *chandef;
 	drv_change_chanctx(local, ctx, IEEE80211_CHANCTX_CHANGE_WIDTH);
-	ieee80211_recalc_chanctx_min_def(local, ctx);
 
 	if (!local->use_chanctx) {
 		local->_oper_chandef = *chandef;
@@ -162,6 +162,15 @@ static void ieee80211_change_chanctx(struct ieee80211_local *local,
 	}
 }
 
+static void
+_ieee80211_recalc_chanctx_chantype(struct ieee80211_local *local,
+				   struct ieee80211_chanctx *ctx,
+				   const struct cfg80211_chan_def *chandef)
+{
+	ieee80211_recalc_chanctx_def(local, ctx, chandef);
+	ieee80211_recalc_chanctx_min_def(local, ctx);
+}
+
 static struct ieee80211_chanctx *
 ieee80211_find_chanctx(struct ieee80211_local *local,
 		       const struct cfg80211_chan_def *chandef,
@@ -184,7 +193,7 @@ ieee80211_find_chanctx(struct ieee80211_local *local,
 		if (!compat)
 			continue;
 
-		ieee80211_change_chanctx(local, ctx, compat);
+		_ieee80211_recalc_chanctx_chantype(local, ctx, compat);
 
 		return ctx;
 	}
@@ -350,7 +359,7 @@ static void ieee80211_recalc_chanctx_chantype(struct ieee80211_local *local,
 	if (WARN_ON_ONCE(!compat))
 		return;
 
-	ieee80211_change_chanctx(local, ctx, compat);
+	_ieee80211_recalc_chanctx_chantype(local, ctx, compat);
 }
 
 static void ieee80211_recalc_radar_chanctx(struct ieee80211_local *local,
-- 
1.8.5.3

