Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:60468 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbaCGCUh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2014 21:20:37 -0500
Received: by mail-pd0-f176.google.com with SMTP id r10so3360657pdi.21
        for <linux-wireless@vger.kernel.org>; Thu, 06 Mar 2014 18:20:37 -0800 (PST)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 3/4] mac80211: refactor recalculate channel context functions (3)
Date: Fri,  7 Mar 2014 10:17:29 +0800
Message-Id: <fc80be6b356a629ff283b967e51aa3ab537a51f6.1394158459.git.gamerh2o@gmail.com> (sfid-20140307_032040_389751_295AF383)
In-Reply-To: <8966cabb0cf4c83da8fd37e4a5ec1df8727e9dbe.1394158459.git.gamerh2o@gmail.com>
References: <8966cabb0cf4c83da8fd37e4a5ec1df8727e9dbe.1394158459.git.gamerh2o@gmail.com>
In-Reply-To: <8966cabb0cf4c83da8fd37e4a5ec1df8727e9dbe.1394158459.git.gamerh2o@gmail.com>
References: <8966cabb0cf4c83da8fd37e4a5ec1df8727e9dbe.1394158459.git.gamerh2o@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change some functions' position in the file. This is a preparation for
a wrapper function ieee80211_recalc_chanctx().

Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 net/mac80211/chan.c | 252 ++++++++++++++++++++++++++--------------------------
 1 file changed, 126 insertions(+), 126 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 543beba..ebcc0e7 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -204,6 +204,132 @@ static void ieee80211_recalc_chanctx_chantype(struct ieee80211_local *local,
 	_ieee80211_recalc_chanctx_chantype(local, ctx, compat);
 }
 
+static bool ieee80211_is_radar_required(struct ieee80211_local *local)
+{
+	struct ieee80211_sub_if_data *sdata;
+
+	lockdep_assert_held(&local->mtx);
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		if (sdata->radar_required) {
+			rcu_read_unlock();
+			return true;
+		}
+	}
+	rcu_read_unlock();
+
+	return false;
+}
+
+static void ieee80211_recalc_radar_chanctx(struct ieee80211_local *local,
+					   struct ieee80211_chanctx *chanctx)
+{
+	bool radar_enabled;
+
+	lockdep_assert_held(&local->chanctx_mtx);
+	/* for setting local->radar_detect_enabled */
+	lockdep_assert_held(&local->mtx);
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
+void ieee80211_recalc_smps_chanctx(struct ieee80211_local *local,
+				   struct ieee80211_chanctx *chanctx)
+{
+	struct ieee80211_sub_if_data *sdata;
+	u8 rx_chains_static, rx_chains_dynamic;
+
+	lockdep_assert_held(&local->chanctx_mtx);
+
+	rx_chains_static = 1;
+	rx_chains_dynamic = 1;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		u8 needed_static, needed_dynamic;
+
+		if (!ieee80211_sdata_running(sdata))
+			continue;
+
+		if (rcu_access_pointer(sdata->vif.chanctx_conf) !=
+						&chanctx->conf)
+			continue;
+
+		switch (sdata->vif.type) {
+		case NL80211_IFTYPE_P2P_DEVICE:
+			continue;
+		case NL80211_IFTYPE_STATION:
+			if (!sdata->u.mgd.associated)
+				continue;
+			break;
+		case NL80211_IFTYPE_AP_VLAN:
+			continue;
+		case NL80211_IFTYPE_AP:
+		case NL80211_IFTYPE_ADHOC:
+		case NL80211_IFTYPE_WDS:
+		case NL80211_IFTYPE_MESH_POINT:
+			break;
+		default:
+			WARN_ON_ONCE(1);
+		}
+
+		switch (sdata->smps_mode) {
+		default:
+			WARN_ONCE(1, "Invalid SMPS mode %d\n",
+				  sdata->smps_mode);
+			/* fall through */
+		case IEEE80211_SMPS_OFF:
+			needed_static = sdata->needed_rx_chains;
+			needed_dynamic = sdata->needed_rx_chains;
+			break;
+		case IEEE80211_SMPS_DYNAMIC:
+			needed_static = 1;
+			needed_dynamic = sdata->needed_rx_chains;
+			break;
+		case IEEE80211_SMPS_STATIC:
+			needed_static = 1;
+			needed_dynamic = 1;
+			break;
+		}
+
+		rx_chains_static = max(rx_chains_static, needed_static);
+		rx_chains_dynamic = max(rx_chains_dynamic, needed_dynamic);
+	}
+	rcu_read_unlock();
+
+	if (!local->use_chanctx) {
+		if (rx_chains_static > 1)
+			local->smps_mode = IEEE80211_SMPS_OFF;
+		else if (rx_chains_dynamic > 1)
+			local->smps_mode = IEEE80211_SMPS_DYNAMIC;
+		else
+			local->smps_mode = IEEE80211_SMPS_STATIC;
+		ieee80211_hw_config(local, 0);
+	}
+
+	if (rx_chains_static == chanctx->conf.rx_chains_static &&
+	    rx_chains_dynamic == chanctx->conf.rx_chains_dynamic)
+		return;
+
+	chanctx->conf.rx_chains_static = rx_chains_static;
+	chanctx->conf.rx_chains_dynamic = rx_chains_dynamic;
+	drv_change_chanctx(local, chanctx, IEEE80211_CHANCTX_CHANGE_RX_CHAINS);
+}
+
 static struct ieee80211_chanctx *
 ieee80211_find_chanctx(struct ieee80211_local *local,
 		       const struct cfg80211_chan_def *chandef,
@@ -234,24 +360,6 @@ ieee80211_find_chanctx(struct ieee80211_local *local,
 	return NULL;
 }
 
-static bool ieee80211_is_radar_required(struct ieee80211_local *local)
-{
-	struct ieee80211_sub_if_data *sdata;
-
-	lockdep_assert_held(&local->mtx);
-
-	rcu_read_lock();
-	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-		if (sdata->radar_required) {
-			rcu_read_unlock();
-			return true;
-		}
-	}
-	rcu_read_unlock();
-
-	return false;
-}
-
 static struct ieee80211_chanctx *
 ieee80211_new_chanctx(struct ieee80211_local *local,
 		      const struct cfg80211_chan_def *chandef,
@@ -362,31 +470,6 @@ static int ieee80211_assign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
-static void ieee80211_recalc_radar_chanctx(struct ieee80211_local *local,
-					   struct ieee80211_chanctx *chanctx)
-{
-	bool radar_enabled;
-
-	lockdep_assert_held(&local->chanctx_mtx);
-	/* for setting local->radar_detect_enabled */
-	lockdep_assert_held(&local->mtx);
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
 static void ieee80211_unassign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
 					   struct ieee80211_chanctx *ctx)
 {
@@ -433,89 +516,6 @@ static void __ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata)
 		ieee80211_free_chanctx(local, ctx);
 }
 
-void ieee80211_recalc_smps_chanctx(struct ieee80211_local *local,
-				   struct ieee80211_chanctx *chanctx)
-{
-	struct ieee80211_sub_if_data *sdata;
-	u8 rx_chains_static, rx_chains_dynamic;
-
-	lockdep_assert_held(&local->chanctx_mtx);
-
-	rx_chains_static = 1;
-	rx_chains_dynamic = 1;
-
-	rcu_read_lock();
-	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-		u8 needed_static, needed_dynamic;
-
-		if (!ieee80211_sdata_running(sdata))
-			continue;
-
-		if (rcu_access_pointer(sdata->vif.chanctx_conf) !=
-						&chanctx->conf)
-			continue;
-
-		switch (sdata->vif.type) {
-		case NL80211_IFTYPE_P2P_DEVICE:
-			continue;
-		case NL80211_IFTYPE_STATION:
-			if (!sdata->u.mgd.associated)
-				continue;
-			break;
-		case NL80211_IFTYPE_AP_VLAN:
-			continue;
-		case NL80211_IFTYPE_AP:
-		case NL80211_IFTYPE_ADHOC:
-		case NL80211_IFTYPE_WDS:
-		case NL80211_IFTYPE_MESH_POINT:
-			break;
-		default:
-			WARN_ON_ONCE(1);
-		}
-
-		switch (sdata->smps_mode) {
-		default:
-			WARN_ONCE(1, "Invalid SMPS mode %d\n",
-				  sdata->smps_mode);
-			/* fall through */
-		case IEEE80211_SMPS_OFF:
-			needed_static = sdata->needed_rx_chains;
-			needed_dynamic = sdata->needed_rx_chains;
-			break;
-		case IEEE80211_SMPS_DYNAMIC:
-			needed_static = 1;
-			needed_dynamic = sdata->needed_rx_chains;
-			break;
-		case IEEE80211_SMPS_STATIC:
-			needed_static = 1;
-			needed_dynamic = 1;
-			break;
-		}
-
-		rx_chains_static = max(rx_chains_static, needed_static);
-		rx_chains_dynamic = max(rx_chains_dynamic, needed_dynamic);
-	}
-	rcu_read_unlock();
-
-	if (!local->use_chanctx) {
-		if (rx_chains_static > 1)
-			local->smps_mode = IEEE80211_SMPS_OFF;
-		else if (rx_chains_dynamic > 1)
-			local->smps_mode = IEEE80211_SMPS_DYNAMIC;
-		else
-			local->smps_mode = IEEE80211_SMPS_STATIC;
-		ieee80211_hw_config(local, 0);
-	}
-
-	if (rx_chains_static == chanctx->conf.rx_chains_static &&
-	    rx_chains_dynamic == chanctx->conf.rx_chains_dynamic)
-		return;
-
-	chanctx->conf.rx_chains_static = rx_chains_static;
-	chanctx->conf.rx_chains_dynamic = rx_chains_dynamic;
-	drv_change_chanctx(local, chanctx, IEEE80211_CHANCTX_CHANGE_RX_CHAINS);
-}
-
 int ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
 			      const struct cfg80211_chan_def *chandef,
 			      enum ieee80211_chanctx_mode mode)
-- 
1.8.5.3

