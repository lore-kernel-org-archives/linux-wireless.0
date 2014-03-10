Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:54077 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753809AbaCJVcC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Mar 2014 17:32:02 -0400
From: Luciano Coelho <luciano.coelho@intel.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, michal.kazior@tieto.com,
	sw@simonwunderlich.de, andrei.otcheretianski@intel.com
Subject: [PATCH v9 3/5] cfg80211/mac80211: move interface counting for combination check to mac80211
Date: Mon, 10 Mar 2014 23:31:41 +0200
Message-Id: <1394487103-13027-4-git-send-email-luciano.coelho@intel.com> (sfid-20140310_223215_533021_7DB2CF16)
In-Reply-To: <1394487103-13027-1-git-send-email-luciano.coelho@intel.com>
References: <1394487103-13027-1-git-send-email-luciano.coelho@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move the counting part of the interface combination check from
cfg80211 to mac80211.

This is needed to simplify locking when the driver has to perform a
combination check by itself (eg. with channel-switch).

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
In v3:

   * pass the mode argument instead of IEEE80211_CHANCTX_SHARED to
     ieee80211_check_combinations() in ieee80211_vif_use_channel();

In v4:

   * rebased on top of slightly modified applied patches;
   * removed WARN_ON in ieee80211_start_radar_detection();
   * removed unnecessary TODOs in ieee80211_mgd_auth() and
     ieee80211_mgd_assoc();
   * use local and sdata instead of wiphy and wdev in
     ieee80211_check_combinations();
   * check if the vif has a chanctx instead of checking the type and
     if it is running in the interfaces iterator in
     ieee80211_check_combinations();
   * combined the "continue" cases in the iteration into a single if;
   * removed cfg80211_can_use_chan() since libertas mesh, the only
     remaining caller, doesn't really need it.

In v5:

   * use the radar detection widths from all existing contexts,
     regardless of whether we can share an existing context or if the
     context is exclusive.

In v6:

   * fix typo in the interface counting code
     s/sdata-vif.chanctx_conf/sdata_iter-vif.chanctx_conf/

In v7:

   * use new version of cfg80211_check_combinations()
   * remove unnecessary TODO from the documentation
   * remove the local argument in ieee80211_check_combinations, since
     it can be dereferenced from sdata anyway;

In v8:

   * fix radar_detect_width before calling
     ieee80211_check_combinations() -- rebase bug;

In v9:

   * pass sdata->wdev.iftype instead of sdata->vif.type when calling
     cfg80211_chandef_dfs_required();
---
 include/net/cfg80211.h     |  2 --
 net/mac80211/cfg.c         |  2 --
 net/mac80211/chan.c        | 17 +++++++++++
 net/mac80211/ieee80211_i.h |  4 +++
 net/mac80211/util.c        | 72 ++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/core.h        | 13 ++-------
 net/wireless/ibss.c        |  4 +++
 net/wireless/mesh.c        | 28 ------------------
 net/wireless/mlme.c        | 14 +--------
 net/wireless/nl80211.c     | 29 +++----------------
 net/wireless/util.c        |  5 ++++
 11 files changed, 110 insertions(+), 80 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 51f278a..23a72e2 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -657,7 +657,6 @@ struct cfg80211_acl_data {
  * @p2p_opp_ps: P2P opportunistic PS
  * @acl: ACL configuration used by the drivers which has support for
  *	MAC address based access control
- * @radar_required: set if radar detection is required
  */
 struct cfg80211_ap_settings {
 	struct cfg80211_chan_def chandef;
@@ -675,7 +674,6 @@ struct cfg80211_ap_settings {
 	u8 p2p_ctwindow;
 	bool p2p_opp_ps;
 	const struct cfg80211_acl_data *acl;
-	bool radar_required;
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index aaa59d7..9b555e0 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -972,7 +972,6 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	sdata->needed_rx_chains = sdata->local->rx_chains;
 
 	mutex_lock(&local->mtx);
-	sdata->radar_required = params->radar_required;
 	err = ieee80211_vif_use_channel(sdata, &params->chandef,
 					IEEE80211_CHANCTX_SHARED);
 	mutex_unlock(&local->mtx);
@@ -2930,7 +2929,6 @@ static int ieee80211_start_radar_detection(struct wiphy *wiphy,
 	/* whatever, but channel contexts should not complain about that one */
 	sdata->smps_mode = IEEE80211_SMPS_OFF;
 	sdata->needed_rx_chains = local->rx_chains;
-	sdata->radar_required = true;
 
 	err = ieee80211_vif_use_channel(sdata, chandef,
 					IEEE80211_CHANCTX_SHARED);
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 42c6592..384f3c7 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -513,6 +513,7 @@ int ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_chanctx *ctx;
+	u8 radar_detect_width = 0;
 	int ret;
 
 	lockdep_assert_held(&local->mtx);
@@ -520,6 +521,22 @@ int ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
 	WARN_ON(sdata->dev && netif_carrier_ok(sdata->dev));
 
 	mutex_lock(&local->chanctx_mtx);
+
+	ret = cfg80211_chandef_dfs_required(local->hw.wiphy,
+					    chandef,
+					    sdata->wdev.iftype);
+	if (ret < 0)
+		goto out;
+	if (ret > 0)
+		radar_detect_width = BIT(chandef->width);
+
+	sdata->radar_required = ret;
+
+	ret = ieee80211_check_combinations(sdata, chandef, mode,
+					   radar_detect_width);
+	if (ret < 0)
+		goto out;
+
 	__ieee80211_vif_release_channel(sdata);
 
 	ctx = ieee80211_find_chanctx(local, chandef, mode);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 8603dfb..d3ebe7f 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1810,6 +1810,10 @@ int ieee80211_cs_headroom(struct ieee80211_local *local,
 			  enum nl80211_iftype iftype);
 void ieee80211_recalc_dtim(struct ieee80211_local *local,
 			   struct ieee80211_sub_if_data *sdata);
+int ieee80211_check_combinations(struct ieee80211_sub_if_data *sdata,
+				 const struct cfg80211_chan_def *chandef,
+				 enum ieee80211_chanctx_mode chanmode,
+				 u8 radar_detect);
 
 #ifdef CONFIG_MAC80211_NOINLINE
 #define debug_noinline noinline
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index d842af5..3972b64 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2801,3 +2801,75 @@ void ieee80211_recalc_dtim(struct ieee80211_local *local,
 
 	ps->dtim_count = dtim_count;
 }
+
+int ieee80211_check_combinations(struct ieee80211_sub_if_data *sdata,
+				 const struct cfg80211_chan_def *chandef,
+				 enum ieee80211_chanctx_mode chanmode,
+				 u8 radar_detect)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_sub_if_data *sdata_iter;
+	enum nl80211_iftype iftype = sdata->wdev.iftype;
+	int num[NUM_NL80211_IFTYPES];
+	struct ieee80211_chanctx *ctx;
+	int num_different_channels = 1;
+	int total = 1;
+
+	lockdep_assert_held(&local->chanctx_mtx);
+
+	if (WARN_ON(hweight32(radar_detect) > 1))
+		return -EINVAL;
+
+	if (WARN_ON(chanmode == IEEE80211_CHANCTX_SHARED && !chandef->chan))
+		return -EINVAL;
+
+	if (WARN_ON(iftype >= NUM_NL80211_IFTYPES))
+		return -EINVAL;
+
+	/* Always allow software iftypes */
+	if (local->hw.wiphy->software_iftypes & BIT(iftype)) {
+		if (radar_detect)
+			return -EINVAL;
+		return 0;
+	}
+
+	memset(num, 0, sizeof(num));
+
+	if (iftype != NL80211_IFTYPE_UNSPECIFIED)
+		num[iftype] = 1;
+
+	list_for_each_entry(ctx, &local->chanctx_list, list) {
+		if (ctx->conf.radar_enabled)
+			radar_detect |= BIT(ctx->conf.def.width);
+		if (ctx->mode == IEEE80211_CHANCTX_EXCLUSIVE) {
+			num_different_channels++;
+			continue;
+		}
+		if ((chanmode == IEEE80211_CHANCTX_SHARED) &&
+		    cfg80211_chandef_compatible(chandef,
+						&ctx->conf.def))
+			continue;
+		num_different_channels++;
+	}
+
+	list_for_each_entry_rcu(sdata_iter, &local->interfaces, list) {
+		struct wireless_dev *wdev_iter;
+
+		wdev_iter = &sdata_iter->wdev;
+
+		if (sdata_iter == sdata ||
+		    rcu_access_pointer(sdata_iter->vif.chanctx_conf) == NULL ||
+		    local->hw.wiphy->software_iftypes & BIT(wdev_iter->iftype))
+			continue;
+
+		num[wdev_iter->iftype]++;
+		total++;
+	}
+
+	if (total == 1 && !radar_detect)
+		return 0;
+
+	return cfg80211_check_combinations(local->hw.wiphy,
+					   num_different_channels,
+					   radar_detect, num);
+}
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 3975ffa..4a930ef 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -411,6 +411,9 @@ cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
 			      struct wireless_dev *wdev,
 			      enum nl80211_iftype iftype)
 {
+	/* TODO: For this function, we'll probably need to keep some
+	 * kind of interface combination check in cfg80211...
+	 */
 	return cfg80211_can_use_iftype_chan(rdev, wdev, iftype, NULL,
 					    CHAN_MODE_UNDEFINED, 0);
 }
@@ -425,16 +428,6 @@ cfg80211_can_add_interface(struct cfg80211_registered_device *rdev,
 	return cfg80211_can_change_interface(rdev, NULL, iftype);
 }
 
-static inline int
-cfg80211_can_use_chan(struct cfg80211_registered_device *rdev,
-		      struct wireless_dev *wdev,
-		      struct ieee80211_channel *chan,
-		      enum cfg80211_chan_mode chanmode)
-{
-	return cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
-					    chan, chanmode, 0);
-}
-
 static inline unsigned int elapsed_jiffies_msecs(unsigned long start)
 {
 	unsigned long end = jiffies;
diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index 349db9d..d81cb68 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -135,6 +135,10 @@ int __cfg80211_join_ibss(struct cfg80211_registered_device *rdev,
 		radar_detect_width = BIT(params->chandef.width);
 	}
 
+	/* TODO: We need to check the combinations at this point, we
+	 * probably must move this call down to join_ibss() in
+	 * mac80211.
+	 */
 	err = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
 					   check_chan,
 					   (params->channel_fixed &&
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index a95212b..b8a7a35 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -99,7 +99,6 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 			 const struct mesh_config *conf)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	u8 radar_detect_width = 0;
 	int err;
 
 	BUILD_BUG_ON(IEEE80211_MAX_SSID_LEN != IEEE80211_MAX_MESH_ID_LEN);
@@ -178,22 +177,6 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &setup->chandef))
 		return -EINVAL;
 
-	err = cfg80211_chandef_dfs_required(wdev->wiphy,
-					    &setup->chandef,
-					    NL80211_IFTYPE_MESH_POINT);
-	if (err < 0)
-		return err;
-
-	if (err > 0)
-		radar_detect_width = BIT(setup->chandef.width);
-
-	err = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
-					   setup->chandef.chan,
-					   CHAN_MODE_SHARED,
-					   radar_detect_width);
-	if (err)
-		return err;
-
 	err = rdev_join_mesh(rdev, dev, conf, setup);
 	if (!err) {
 		memcpy(wdev->ssid, setup->mesh_id, setup->mesh_id_len);
@@ -239,17 +222,6 @@ int cfg80211_set_mesh_channel(struct cfg80211_registered_device *rdev,
 		if (!netif_running(wdev->netdev))
 			return -ENETDOWN;
 
-		/* cfg80211_can_use_chan() calls
-		 * cfg80211_can_use_iftype_chan() with no radar
-		 * detection, so if we're trying to use a radar
-		 * channel here, something is wrong.
-		 */
-		WARN_ON_ONCE(chandef->chan->flags & IEEE80211_CHAN_RADAR);
-		err = cfg80211_can_use_chan(rdev, wdev, chandef->chan,
-					    CHAN_MODE_SHARED);
-		if (err)
-			return err;
-
 		err = rdev_libertas_set_mesh_channel(rdev, wdev->netdev,
 						     chandef->chan);
 		if (!err)
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index c52ff59..4b4ba70 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -233,14 +233,8 @@ int cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
 	if (!req.bss)
 		return -ENOENT;
 
-	err = cfg80211_can_use_chan(rdev, wdev, req.bss->channel,
-				    CHAN_MODE_SHARED);
-	if (err)
-		goto out;
-
 	err = rdev_auth(rdev, dev, &req);
 
-out:
 	cfg80211_put_bss(&rdev->wiphy, req.bss);
 	return err;
 }
@@ -306,16 +300,10 @@ int cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 	if (!req->bss)
 		return -ENOENT;
 
-	err = cfg80211_can_use_chan(rdev, wdev, chan, CHAN_MODE_SHARED);
-	if (err)
-		goto out;
-
 	err = rdev_assoc(rdev, dev, req);
 	if (!err)
 		cfg80211_hold_bss(bss_from_pub(req->bss));
-
-out:
-	if (err)
+	else
 		cfg80211_put_bss(&rdev->wiphy, req->bss);
 
 	return err;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9fe7746..07253bf 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3142,7 +3142,6 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_ap_settings params;
 	int err;
-	u8 radar_detect_width = 0;
 
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
@@ -3261,24 +3260,6 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &params.chandef))
 		return -EINVAL;
 
-	err = cfg80211_chandef_dfs_required(wdev->wiphy,
-					    &params.chandef,
-					    NL80211_IFTYPE_AP);
-	if (err < 0)
-		return err;
-
-	if (err > 0) {
-		params.radar_required = true;
-		radar_detect_width = BIT(params.chandef.width);
-	}
-
-	err = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
-					   params.chandef.chan,
-					   CHAN_MODE_SHARED,
-					   radar_detect_width);
-	if (err)
-		return err;
-
 	if (info->attrs[NL80211_ATTR_ACL_POLICY]) {
 		params.acl = parse_acl_data(&rdev->wiphy, info);
 		if (IS_ERR(params.acl))
@@ -5813,12 +5794,6 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	if (!rdev->ops->start_radar_detection)
 		return -EOPNOTSUPP;
 
-	err = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
-					   chandef.chan, CHAN_MODE_SHARED,
-					   BIT(chandef.width));
-	if (err)
-		return err;
-
 	cac_time_ms = cfg80211_chandef_dfs_cac_time(&rdev->wiphy, &chandef);
 	if (WARN_ON(!cac_time_ms))
 		cac_time_ms = IEEE80211_DFS_MIN_CAC_TIME_MS;
@@ -5946,6 +5921,10 @@ skip_beacons:
 		params.radar_required = true;
 	}
 
+	/* TODO: I left this here for now.  With channel switch, the
+	 * verification is a bit more complicated, because we only do
+	 * it later when the channel switch really happens.
+	 */
 	err = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
 					   params.chandef.chan,
 					   CHAN_MODE_SHARED,
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 7ecc0ef..b2498e3 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1359,6 +1359,11 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 
 	num[iftype] = 1;
 
+	/* TODO: We'll probably not need this anymore, since this
+	 * should only be called with CHAN_MODE_UNDEFINED. There are
+	 * still a couple of pending calls where other chanmodes are
+	 * used, but we should get rid of them.
+	 */
 	switch (chanmode) {
 	case CHAN_MODE_UNDEFINED:
 		break;
-- 
1.9.0

