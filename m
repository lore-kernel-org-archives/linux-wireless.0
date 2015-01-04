Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:49388 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbbADKN3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Jan 2015 05:13:29 -0500
Received: by mail-wg0-f53.google.com with SMTP id x13so8237483wgg.40
        for <linux-wireless@vger.kernel.org>; Sun, 04 Jan 2015 02:13:27 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/3] mac80211: consider only relevant vifs for radar_required calculation
Date: Sun,  4 Jan 2015 12:13:17 +0200
Message-Id: <1420366399-31535-1-git-send-email-eliad@wizery.com> (sfid-20150104_111344_209380_1E37E735)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

no need to consider all the vifs, but only the ones
that have this context assigned.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
This patch was already sent previously as part of a different patchset
(in which the other patch was later dropped).
However, i don't see it in patchwork, so resend it.

 net/mac80211/chan.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 5d6dae9..7f83451 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -388,22 +388,31 @@ ieee80211_find_chanctx(struct ieee80211_local *local,
 	return NULL;
 }
 
-static bool ieee80211_is_radar_required(struct ieee80211_local *local)
+static bool ieee80211_is_radar_required(struct ieee80211_local *local,
+					struct ieee80211_chanctx *ctx)
 {
+	struct ieee80211_chanctx_conf *conf = &ctx->conf;
 	struct ieee80211_sub_if_data *sdata;
+	bool required = false;
 
+	lockdep_assert_held(&local->chanctx_mtx);
 	lockdep_assert_held(&local->mtx);
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-		if (sdata->radar_required) {
-			rcu_read_unlock();
-			return true;
-		}
+		if (!ieee80211_sdata_running(sdata))
+			continue;
+		if (rcu_access_pointer(sdata->vif.chanctx_conf) != conf)
+			continue;
+		if (!sdata->radar_required)
+			continue;
+
+		required = true;
+		break;
 	}
 	rcu_read_unlock();
 
-	return false;
+	return required;
 }
 
 static struct ieee80211_chanctx *
@@ -425,7 +434,7 @@ ieee80211_alloc_chanctx(struct ieee80211_local *local,
 	ctx->conf.rx_chains_static = 1;
 	ctx->conf.rx_chains_dynamic = 1;
 	ctx->mode = mode;
-	ctx->conf.radar_enabled = ieee80211_is_radar_required(local);
+	ctx->conf.radar_enabled = ieee80211_is_radar_required(local, ctx);
 	ieee80211_recalc_chanctx_min_def(local, ctx);
 
 	return ctx;
@@ -570,7 +579,7 @@ static void ieee80211_recalc_radar_chanctx(struct ieee80211_local *local,
 	/* for setting local->radar_detect_enabled */
 	lockdep_assert_held(&local->mtx);
 
-	radar_enabled = ieee80211_is_radar_required(local);
+	radar_enabled = ieee80211_is_radar_required(local, chanctx);
 
 	if (radar_enabled == chanctx->conf.radar_enabled)
 		return;
-- 
1.8.5.2.229.g4448466.dirty

