Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48765 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab3LRJLQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Dec 2013 04:11:16 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: make ieee80211_recalc_radar_chanctx static
Date: Wed, 18 Dec 2013 10:11:12 +0100
Message-Id: <1387357872-19268-1-git-send-email-johannes@sipsolutions.net> (sfid-20131218_101128_937456_21AFF512)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The function is only used in one file, so move it up a
bit to avoid forward declarations and make it static.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/chan.c        | 46 +++++++++++++++++++++++-----------------------
 net/mac80211/ieee80211_i.h |  2 --
 2 files changed, 23 insertions(+), 25 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index a57d5d9..f20a98a 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -358,6 +358,29 @@ static void ieee80211_recalc_chanctx_chantype(struct ieee80211_local *local,
 	ieee80211_change_chanctx(local, ctx, compat);
 }
 
+static void ieee80211_recalc_radar_chanctx(struct ieee80211_local *local,
+					   struct ieee80211_chanctx *chanctx)
+{
+	bool radar_enabled;
+
+	lockdep_assert_held(&local->chanctx_mtx);
+
+	radar_enabled = ieee80211_is_radar_required(local);
+
+	if (radar_enabled == chanctx->conf.radar_enabled)
+		return;
+
+	chanctx->conf.radar_enabled = radar_enabled;
+	local->radar_detect_enabled = chanctx->conf.radar_enabled;
+
+	if (!local->use_chanctx) {
+		local->hw.conf.radar_enabled = chanctx->conf.radar_enabled;
+		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
+	}
+
+	drv_change_chanctx(local, chanctx, IEEE80211_CHANCTX_CHANGE_RADAR);
+}
+
 static void ieee80211_unassign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
 					   struct ieee80211_chanctx *ctx)
 {
@@ -404,29 +427,6 @@ static void __ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata)
 		ieee80211_free_chanctx(local, ctx);
 }
 
-void ieee80211_recalc_radar_chanctx(struct ieee80211_local *local,
-				    struct ieee80211_chanctx *chanctx)
-{
-	bool radar_enabled;
-
-	lockdep_assert_held(&local->chanctx_mtx);
-
-	radar_enabled = ieee80211_is_radar_required(local);
-
-	if (radar_enabled == chanctx->conf.radar_enabled)
-		return;
-
-	chanctx->conf.radar_enabled = radar_enabled;
-	local->radar_detect_enabled = chanctx->conf.radar_enabled;
-
-	if (!local->use_chanctx) {
-		local->hw.conf.radar_enabled = chanctx->conf.radar_enabled;
-		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
-	}
-
-	drv_change_chanctx(local, chanctx, IEEE80211_CHANCTX_CHANGE_RADAR);
-}
-
 void ieee80211_recalc_smps_chanctx(struct ieee80211_local *local,
 				   struct ieee80211_chanctx *chanctx)
 {
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index fb5dbcb..c56009c 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1775,8 +1775,6 @@ void ieee80211_vif_copy_chanctx_to_vlans(struct ieee80211_sub_if_data *sdata,
 
 void ieee80211_recalc_smps_chanctx(struct ieee80211_local *local,
 				   struct ieee80211_chanctx *chanctx);
-void ieee80211_recalc_radar_chanctx(struct ieee80211_local *local,
-				    struct ieee80211_chanctx *chanctx);
 void ieee80211_recalc_chanctx_min_def(struct ieee80211_local *local,
 				      struct ieee80211_chanctx *ctx);
 
-- 
1.8.5.1

