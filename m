Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:61620 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaAOMJb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 07:09:31 -0500
Received: by mail-ee0-f43.google.com with SMTP id c41so816428eek.16
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jan 2014 04:09:29 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 6/9] mac80211: track CSA globally
Date: Wed, 15 Jan 2014 13:04:51 +0100
Message-Id: <1389787494-7361-7-git-send-email-michal.kazior@tieto.com> (sfid-20140115_130945_742614_622B9AAF)
In-Reply-To: <1389787494-7361-1-git-send-email-michal.kazior@tieto.com>
References: <1389787494-7361-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For CSA to be safe it needs to be treated the same
way as radar detection, scanning and remain on
channel - all of those (including CSA) must be
mutually exclusive.

This prepares for multi-interface CSA.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/cfg.c         | 34 ++++++++++++++++++++++------------
 net/mac80211/ibss.c        | 22 +++++++++++++++-------
 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/iface.c       |  7 +++++--
 net/mac80211/mesh.c        |  3 +++
 net/mac80211/mlme.c        |  6 ++++++
 net/mac80211/scan.c        |  5 +++++
 net/mac80211/util.c        | 18 ++++++++++++++++++
 8 files changed, 75 insertions(+), 21 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 9a2421d..13d1624 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -973,8 +973,12 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 
 	mutex_lock(&local->mtx);
 	sdata->radar_required = params->radar_required;
-	err = ieee80211_vif_use_channel(sdata, &params->chandef,
-					IEEE80211_CHANCTX_SHARED);
+
+	if (ieee80211_is_csa_active(local))
+		err = -EBUSY;
+	else
+		err = ieee80211_vif_use_channel(sdata, &params->chandef,
+						IEEE80211_CHANCTX_SHARED);
 	mutex_unlock(&local->mtx);
 	if (err)
 		return err;
@@ -1957,8 +1961,11 @@ static int ieee80211_join_mesh(struct wiphy *wiphy, struct net_device *dev,
 	sdata->needed_rx_chains = sdata->local->rx_chains;
 
 	mutex_lock(&sdata->local->mtx);
-	err = ieee80211_vif_use_channel(sdata, &setup->chandef,
-					IEEE80211_CHANCTX_SHARED);
+	if (ieee80211_is_csa_active(sdata->local))
+		err = -EBUSY;
+	else
+		err = ieee80211_vif_use_channel(sdata, &setup->chandef,
+						IEEE80211_CHANCTX_SHARED);
 	mutex_unlock(&sdata->local->mtx);
 	if (err)
 		return err;
@@ -2644,7 +2651,8 @@ static int ieee80211_start_roc_work(struct ieee80211_local *local,
 
 	/* if there's one pending or we're scanning, queue this one */
 	if (!list_empty(&local->roc_list) ||
-	    local->scanning || local->radar_detect_enabled)
+	    local->scanning || local->radar_detect_enabled ||
+	    ieee80211_is_csa_active(local))
 		goto out_check_combine;
 
 	/* if not HW assist, just queue & schedule work */
@@ -2912,7 +2920,8 @@ static int ieee80211_start_radar_detection(struct wiphy *wiphy,
 	int err;
 
 	mutex_lock(&local->mtx);
-	if (!list_empty(&local->roc_list) || local->scanning) {
+	if (!list_empty(&local->roc_list) || local->scanning ||
+	    ieee80211_is_csa_active(local)) {
 		err = -EBUSY;
 		goto out_unlock;
 	}
@@ -3087,7 +3096,8 @@ int __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 	sdata_assert_lock(sdata);
 	lockdep_assert_held(&local->mtx);
 
-	if (!list_empty(&local->roc_list) || local->scanning)
+	if (!list_empty(&local->roc_list) || local->scanning ||
+	    ieee80211_is_csa_active(local))
 		return -EBUSY;
 
 	if (sdata->wdev.cac_started)
@@ -3097,23 +3107,23 @@ int __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 				       &sdata->vif.bss_conf.chandef))
 		return -EINVAL;
 
-	rcu_read_lock();
+	mutex_lock(&local->chanctx_mtx);
 	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 	if (!chanctx_conf) {
-		rcu_read_unlock();
+		mutex_unlock(&local->chanctx_mtx);
 		return -EBUSY;
 	}
 
 	/* don't handle for multi-VIF cases */
 	chanctx = container_of(chanctx_conf, struct ieee80211_chanctx, conf);
 	if (chanctx->refcount > 1) {
-		rcu_read_unlock();
+		mutex_unlock(&local->chanctx_mtx);
 		return -EBUSY;
 	}
 	num_chanctx = 0;
-	list_for_each_entry_rcu(chanctx, &local->chanctx_list, list)
+	list_for_each_entry(chanctx, &local->chanctx_list, list)
 		num_chanctx++;
-	rcu_read_unlock();
+	mutex_unlock(&local->chanctx_mtx);
 
 	if (num_chanctx > 1)
 		return -EBUSY;
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 706b666..12c6019 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -295,16 +295,21 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 
 	mutex_lock(&local->mtx);
 	ieee80211_vif_release_channel(sdata);
-	if (ieee80211_vif_use_channel(sdata, &chandef,
-				      ifibss->fixed_channel ?
-					IEEE80211_CHANCTX_SHARED :
-					IEEE80211_CHANCTX_EXCLUSIVE)) {
+	if (ieee80211_is_csa_active(local))
+		err = -EBUSY;
+	else
+		err = ieee80211_vif_use_channel(sdata, &chandef,
+						ifibss->fixed_channel ?
+						IEEE80211_CHANCTX_SHARED :
+						IEEE80211_CHANCTX_EXCLUSIVE);
+
+	sdata->radar_required = radar_required;
+	mutex_unlock(&local->mtx);
+
+	if (err) {
 		sdata_info(sdata, "Failed to join IBSS, no channel context\n");
-		mutex_unlock(&local->mtx);
 		return;
 	}
-	sdata->radar_required = radar_required;
-	mutex_unlock(&local->mtx);
 
 	memcpy(ifibss->bssid, bssid, ETH_ALEN);
 
@@ -808,6 +813,9 @@ ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	if (sdata->vif.csa_active)
 		return true;
 
+	if (ieee80211_is_csa_active(sdata->local))
+		return false;
+
 	sta_flags = IEEE80211_STA_DISABLE_VHT;
 	switch (ifibss->chandef.width) {
 	case NL80211_CHAN_WIDTH_5:
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index e3bab2f..e523429 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1462,6 +1462,7 @@ int __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 int ieee80211_channel_switch(struct wiphy *wiphy,
 			     struct cfg80211_csa_settings *params,
 			     int num_params);
+bool ieee80211_is_csa_active(struct ieee80211_local *local);
 
 /* interface handling */
 int ieee80211_iface_init(void);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index a339334..58cc061 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -438,8 +438,11 @@ int ieee80211_add_virtual_monitor(struct ieee80211_local *local)
 	}
 
 	mutex_lock(&local->mtx);
-	ret = ieee80211_vif_use_channel(sdata, &local->monitor_chandef,
-					IEEE80211_CHANCTX_EXCLUSIVE);
+	if (ieee80211_is_csa_active(local))
+		ret = -EBUSY;
+	else
+		ret = ieee80211_vif_use_channel(sdata, &local->monitor_chandef,
+						IEEE80211_CHANCTX_EXCLUSIVE);
 	mutex_unlock(&local->mtx);
 	if (ret) {
 		drv_remove_interface(local, sdata);
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index fa758dc..8a48e0e 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -871,6 +871,9 @@ ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
 	if (sdata->vif.csa_active)
 		return true;
 
+	if (ieee80211_is_csa_active(sdata->local))
+		return false;
+
 	if (!ifmsh->mesh_id)
 		return false;
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index d898dc9..b3fa66a 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3691,6 +3691,12 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 	sdata->smps_mode = IEEE80211_SMPS_OFF;
 
 	mutex_lock(&local->mtx);
+
+	if (ieee80211_is_csa_active(local)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
 	/*
 	 * If this fails (possibly due to channel context sharing
 	 * on incompatible channels, e.g. 80+80 and 160 sharing the
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 88c8161..6c0a765 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -389,9 +389,14 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local)
 static bool ieee80211_can_scan(struct ieee80211_local *local,
 			       struct ieee80211_sub_if_data *sdata)
 {
+	lockdep_assert_held(&local->mtx);
+
 	if (local->radar_detect_enabled)
 		return false;
 
+	if (ieee80211_is_csa_active(local))
+		return false;
+
 	if (!list_empty(&local->roc_list))
 		return false;
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index df00f19..c8b3f15 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2734,3 +2734,21 @@ int ieee80211_parse_p2p_noa(const struct ieee80211_p2p_noa_attr *attr,
 	return ret;
 }
 EXPORT_SYMBOL(ieee80211_parse_p2p_noa);
+
+bool ieee80211_is_csa_active(struct ieee80211_local *local)
+{
+	struct ieee80211_sub_if_data *sdata;
+
+	lockdep_assert_held(&local->mtx);
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		if (sdata->vif.csa_active) {
+			rcu_read_unlock();
+			return true;
+		}
+	}
+	rcu_read_unlock();
+
+	return false;
+}
-- 
1.8.4.rc3

