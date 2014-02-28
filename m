Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:55536 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbaB1PET (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 10:04:19 -0500
Received: by mail-ee0-f52.google.com with SMTP id c41so2293714eek.25
        for <linux-wireless@vger.kernel.org>; Fri, 28 Feb 2014 07:04:17 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] mac80211: refactor channel switch function
Date: Fri, 28 Feb 2014 15:59:06 +0100
Message-Id: <1393599546-28023-1-git-send-email-michal.kazior@tieto.com> (sfid-20140228_160423_755954_919C94E2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function was quite big. This splits out beacon
updating into a separate function for improved
maintenance and extension.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/cfg.c | 109 ++++++++++++++++++++++++++++++-----------------------
 1 file changed, 61 insertions(+), 48 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 80534f5..776bdc8 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3089,52 +3089,12 @@ unlock:
 	sdata_unlock(sdata);
 }
 
-int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
-			     struct cfg80211_csa_settings *params)
+int ieee80211_set_csa_beacon(struct ieee80211_sub_if_data *sdata,
+			     struct cfg80211_csa_settings *params,
+			     u32 *changed)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_chanctx_conf *chanctx_conf;
-	struct ieee80211_chanctx *chanctx;
-	struct ieee80211_if_mesh __maybe_unused *ifmsh;
-	int err, num_chanctx, changed = 0;
-
-	sdata_assert_lock(sdata);
-
-	if (!list_empty(&local->roc_list) || local->scanning)
-		return -EBUSY;
-
-	if (sdata->wdev.cac_started)
-		return -EBUSY;
-
-	if (cfg80211_chandef_identical(&params->chandef,
-				       &sdata->vif.bss_conf.chandef))
-		return -EINVAL;
-
-	rcu_read_lock();
-	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
-	if (!chanctx_conf) {
-		rcu_read_unlock();
-		return -EBUSY;
-	}
-
-	/* don't handle for multi-VIF cases */
-	chanctx = container_of(chanctx_conf, struct ieee80211_chanctx, conf);
-	if (chanctx->refcount > 1) {
-		rcu_read_unlock();
-		return -EBUSY;
-	}
-	num_chanctx = 0;
-	list_for_each_entry_rcu(chanctx, &local->chanctx_list, list)
-		num_chanctx++;
-	rcu_read_unlock();
-
-	if (num_chanctx > 1)
-		return -EBUSY;
-
-	/* don't allow another channel switch if one is already active. */
-	if (sdata->vif.csa_active)
-		return -EBUSY;
+	struct ieee80211_if_mesh *ifmsh;
+	int err;
 
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_AP:
@@ -3170,7 +3130,7 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 			kfree(sdata->u.ap.next_beacon);
 			return err;
 		}
-		changed |= err;
+		*changed |= err;
 
 		break;
 	case NL80211_IFTYPE_ADHOC:
@@ -3204,7 +3164,7 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 			err = ieee80211_ibss_csa_beacon(sdata, params);
 			if (err < 0)
 				return err;
-			changed |= err;
+			*changed |= err;
 		}
 
 		ieee80211_send_action_csa(sdata, params);
@@ -3237,7 +3197,7 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 				ifmsh->csa_role = IEEE80211_MESH_CSA_ROLE_NONE;
 				return err;
 			}
-			changed |= err;
+			*changed |= err;
 		}
 
 		if (ifmsh->csa_role == IEEE80211_MESH_CSA_ROLE_INIT)
@@ -3249,6 +3209,59 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 		return -EOPNOTSUPP;
 	}
 
+	return 0;
+}
+
+int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
+			     struct cfg80211_csa_settings *params)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_chanctx_conf *chanctx_conf;
+	struct ieee80211_chanctx *chanctx;
+	int err, num_chanctx, changed = 0;
+
+	sdata_assert_lock(sdata);
+
+	if (!list_empty(&local->roc_list) || local->scanning)
+		return -EBUSY;
+
+	if (sdata->wdev.cac_started)
+		return -EBUSY;
+
+	if (cfg80211_chandef_identical(&params->chandef,
+				       &sdata->vif.bss_conf.chandef))
+		return -EINVAL;
+
+	rcu_read_lock();
+	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+	if (!chanctx_conf) {
+		rcu_read_unlock();
+		return -EBUSY;
+	}
+
+	/* don't handle for multi-VIF cases */
+	chanctx = container_of(chanctx_conf, struct ieee80211_chanctx, conf);
+	if (chanctx->refcount > 1) {
+		rcu_read_unlock();
+		return -EBUSY;
+	}
+	num_chanctx = 0;
+	list_for_each_entry_rcu(chanctx, &local->chanctx_list, list)
+		num_chanctx++;
+	rcu_read_unlock();
+
+	if (num_chanctx > 1)
+		return -EBUSY;
+
+	/* don't allow another channel switch if one is already active. */
+	if (sdata->vif.csa_active)
+		return -EBUSY;
+
+	err = ieee80211_set_csa_beacon(sdata, params, &changed);
+	if (err)
+		return err;
+
 	sdata->csa_radar_required = params->radar_required;
 
 	if (params->block_tx)
-- 
1.8.5.3

