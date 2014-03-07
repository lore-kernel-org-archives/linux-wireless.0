Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:46026 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbaCGCUj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2014 21:20:39 -0500
Received: by mail-pd0-f176.google.com with SMTP id r10so3384189pdi.35
        for <linux-wireless@vger.kernel.org>; Thu, 06 Mar 2014 18:20:39 -0800 (PST)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 4/4] mac80211: refactor recalculate channel context functions (4)
Date: Fri,  7 Mar 2014 10:17:30 +0800
Message-Id: <dd22fa6b029030dc0e5af61cd6df1c824dc0bc4c.1394158459.git.gamerh2o@gmail.com> (sfid-20140307_032042_529711_E61F7C58)
In-Reply-To: <8966cabb0cf4c83da8fd37e4a5ec1df8727e9dbe.1394158459.git.gamerh2o@gmail.com>
References: <8966cabb0cf4c83da8fd37e4a5ec1df8727e9dbe.1394158459.git.gamerh2o@gmail.com>
In-Reply-To: <8966cabb0cf4c83da8fd37e4a5ec1df8727e9dbe.1394158459.git.gamerh2o@gmail.com>
References: <8966cabb0cf4c83da8fd37e4a5ec1df8727e9dbe.1394158459.git.gamerh2o@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change function name ieee80211_recalc_{radar, smps}_chanctx to
ieee80211_recalc_chanctx_{radar, smps} to be consistent with other
ieee80211_recalc_chanctx_* functions.

Add a wrapper function ieee80211_recalc_chanctx() to reduce code
duplication.

Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 net/mac80211/chan.c        | 30 ++++++++++++++++--------------
 net/mac80211/ieee80211_i.h |  2 +-
 net/mac80211/util.c        |  2 +-
 3 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index ebcc0e7..207b224 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -222,7 +222,7 @@ static bool ieee80211_is_radar_required(struct ieee80211_local *local)
 	return false;
 }
 
-static void ieee80211_recalc_radar_chanctx(struct ieee80211_local *local,
+static void ieee80211_recalc_chanctx_radar(struct ieee80211_local *local,
 					   struct ieee80211_chanctx *chanctx)
 {
 	bool radar_enabled;
@@ -247,7 +247,7 @@ static void ieee80211_recalc_radar_chanctx(struct ieee80211_local *local,
 	drv_change_chanctx(local, chanctx, IEEE80211_CHANCTX_CHANGE_RADAR);
 }
 
-void ieee80211_recalc_smps_chanctx(struct ieee80211_local *local,
+void ieee80211_recalc_chanctx_smps(struct ieee80211_local *local,
 				   struct ieee80211_chanctx *chanctx)
 {
 	struct ieee80211_sub_if_data *sdata;
@@ -330,6 +330,15 @@ void ieee80211_recalc_smps_chanctx(struct ieee80211_local *local,
 	drv_change_chanctx(local, chanctx, IEEE80211_CHANCTX_CHANGE_RX_CHAINS);
 }
 
+static void ieee80211_recalc_chanctx(struct ieee80211_local *local,
+				     struct ieee80211_chanctx *ctx)
+{
+	ieee80211_recalc_chanctx_chantype(local, ctx);
+	ieee80211_recalc_chanctx_smps(local, ctx);
+	ieee80211_recalc_chanctx_radar(local, ctx);
+	ieee80211_recalc_chanctx_min_def(local, ctx);
+}
+
 static struct ieee80211_chanctx *
 ieee80211_find_chanctx(struct ieee80211_local *local,
 		       const struct cfg80211_chan_def *chandef,
@@ -488,12 +497,8 @@ static void ieee80211_unassign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
 
 	drv_unassign_vif_chanctx(local, sdata, ctx);
 
-	if (ctx->refcount > 0) {
-		ieee80211_recalc_chanctx_chantype(sdata->local, ctx);
-		ieee80211_recalc_smps_chanctx(local, ctx);
-		ieee80211_recalc_radar_chanctx(local, ctx);
-		ieee80211_recalc_chanctx_min_def(local, ctx);
-	}
+	if (ctx->refcount > 0)
+		ieee80211_recalc_chanctx(local, ctx);
 }
 
 static void __ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata)
@@ -549,8 +554,8 @@ int ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
 		goto out;
 	}
 
-	ieee80211_recalc_smps_chanctx(local, ctx);
-	ieee80211_recalc_radar_chanctx(local, ctx);
+	ieee80211_recalc_chanctx_smps(local, ctx);
+	ieee80211_recalc_chanctx_radar(local, ctx);
  out:
 	mutex_unlock(&local->chanctx_mtx);
 	return ret;
@@ -601,10 +606,7 @@ int ieee80211_vif_change_channel(struct ieee80211_sub_if_data *sdata,
 	chanctx_changed |= IEEE80211_CHANCTX_CHANGE_CHANNEL;
 	drv_change_chanctx(local, ctx, chanctx_changed);
 
-	ieee80211_recalc_chanctx_chantype(local, ctx);
-	ieee80211_recalc_smps_chanctx(local, ctx);
-	ieee80211_recalc_radar_chanctx(local, ctx);
-	ieee80211_recalc_chanctx_min_def(local, ctx);
+	ieee80211_recalc_chanctx(local, ctx);
 
 	ret = 0;
  out:
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 8603dfb..ca1c636 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1788,7 +1788,7 @@ void ieee80211_vif_vlan_copy_chanctx(struct ieee80211_sub_if_data *sdata);
 void ieee80211_vif_copy_chanctx_to_vlans(struct ieee80211_sub_if_data *sdata,
 					 bool clear);
 
-void ieee80211_recalc_smps_chanctx(struct ieee80211_local *local,
+void ieee80211_recalc_chanctx_smps(struct ieee80211_local *local,
 				   struct ieee80211_chanctx *chanctx);
 void ieee80211_recalc_chanctx_min_def(struct ieee80211_local *local,
 				      struct ieee80211_chanctx *ctx);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index d842af5..013b5fd 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1859,7 +1859,7 @@ void ieee80211_recalc_smps(struct ieee80211_sub_if_data *sdata)
 		goto unlock;
 
 	chanctx = container_of(chanctx_conf, struct ieee80211_chanctx, conf);
-	ieee80211_recalc_smps_chanctx(local, chanctx);
+	ieee80211_recalc_chanctx_smps(local, chanctx);
  unlock:
 	mutex_unlock(&local->chanctx_mtx);
 }
-- 
1.8.5.3

