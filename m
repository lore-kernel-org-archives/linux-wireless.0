Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:52000 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbaBXUyi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Feb 2014 15:54:38 -0500
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, michal.kazior@tieto.com,
	sw@simonwunderlich.de, bzhao@marvell.com, arend@broadcom.com
Subject: [PATCH v4 3/4] cfg80211/mac80211: move interface counting for combination check to mac80211
Date: Mon, 24 Feb 2014 22:54:29 +0200
Message-Id: <1393275270-7255-4-git-send-email-luca@coelho.fi> (sfid-20140224_215446_986988_625314FE)
In-Reply-To: <1393275270-7255-1-git-send-email-luca@coelho.fi>
References: <1393275270-7255-1-git-send-email-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

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
---
 include/net/cfg80211.h     |  4 +--
 net/mac80211/cfg.c         |  2 --
 net/mac80211/chan.c        | 17 +++++++++++
 net/mac80211/ieee80211_i.h |  5 +++
 net/mac80211/util.c        | 76 ++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/core.h        | 13 ++------
 net/wireless/ibss.c        |  4 +++
 net/wireless/mesh.c        | 26 ----------------
 net/wireless/mlme.c        | 14 +--------
 net/wireless/nl80211.c     | 26 +++-------------
 net/wireless/util.c        |  5 +++
 11 files changed, 117 insertions(+), 75 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index a874ec5..ee2f4c4 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -656,7 +656,6 @@ struct cfg80211_acl_data {
  * @p2p_opp_ps: P2P opportunistic PS
  * @acl: ACL configuration used by the drivers which has support for
  *	MAC address based access control
- * @radar_required: set if radar detection is required
  */
 struct cfg80211_ap_settings {
 	struct cfg80211_chan_def chandef;
@@ -674,7 +673,6 @@ struct cfg80211_ap_settings {
 	u8 p2p_ctwindow;
 	bool p2p_opp_ps;
 	const struct cfg80211_acl_data *acl;
-	bool radar_required;
 };
 
 /**
@@ -687,6 +685,8 @@ struct cfg80211_ap_settings {
  * @counter_offset_beacon: offset for the counter within the beacon (tail)
  * @counter_offset_presp: offset for the counter within the probe response
  * @beacon_after: beacon data to be used on the new channel
+ * TODO: we can probably get rid of radar_required, since mac80211
+ * should check for it now
  * @radar_required: whether radar detection is required on the new channel
  * @block_tx: whether transmissions should be blocked while changing
  * @count: number of beacons until switch
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 1acb291..aafaa34 100644
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
index 42c6592..f6a8d68 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -513,6 +513,7 @@ int ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_chanctx *ctx;
+	u8 radar_detect_width;
 	int ret;
 
 	lockdep_assert_held(&local->mtx);
@@ -520,6 +521,22 @@ int ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
 	WARN_ON(sdata->dev && netif_carrier_ok(sdata->dev));
 
 	mutex_lock(&local->chanctx_mtx);
+
+	radar_detect_width = cfg80211_chandef_dfs_required(local->hw.wiphy,
+							   chandef,
+							   sdata->vif.type);
+	if (radar_detect_width < 0) {
+		ret = radar_detect_width;
+		goto out;
+	}
+
+	sdata->radar_required = radar_detect_width;
+
+	ret = ieee80211_check_combinations(local, sdata, chandef, mode,
+					   radar_detect_width);
+	if (ret < 0)
+		goto out;
+
 	__ieee80211_vif_release_channel(sdata);
 
 	ctx = ieee80211_find_chanctx(local, chandef, mode);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 8603dfb..3d8c2d8 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1810,6 +1810,11 @@ int ieee80211_cs_headroom(struct ieee80211_local *local,
 			  enum nl80211_iftype iftype);
 void ieee80211_recalc_dtim(struct ieee80211_local *local,
 			   struct ieee80211_sub_if_data *sdata);
+int ieee80211_check_combinations(struct ieee80211_local *local,
+				 struct ieee80211_sub_if_data *sdata,
+				 const struct cfg80211_chan_def *chandef,
+				 enum ieee80211_chanctx_mode chanmode,
+				 u8 radar_detect);
 
 #ifdef CONFIG_MAC80211_NOINLINE
 #define debug_noinline noinline
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index d842af5..0ea096c 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2801,3 +2801,79 @@ void ieee80211_recalc_dtim(struct ieee80211_local *local,
 
 	ps->dtim_count = dtim_count;
 }
+
+int ieee80211_check_combinations(struct ieee80211_local *local,
+				 struct ieee80211_sub_if_data *sdata,
+				 const struct cfg80211_chan_def *chandef,
+				 enum ieee80211_chanctx_mode chanmode,
+				 u8 radar_detect)
+{
+	struct ieee80211_sub_if_data *sdata_iter;
+	enum nl80211_iftype iftype = sdata->wdev.iftype;
+	u32 used_iftypes = 0;
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
+	if (iftype != NL80211_IFTYPE_UNSPECIFIED) {
+		used_iftypes = BIT(iftype);
+		num[iftype] = 1;
+	}
+
+	list_for_each_entry(ctx, &local->chanctx_list, list) {
+		if (ctx->mode == IEEE80211_CHANCTX_EXCLUSIVE) {
+			num_different_channels++;
+			continue;
+		}
+		if ((chanmode == IEEE80211_CHANCTX_SHARED) &&
+		    cfg80211_chandef_compatible(chandef,
+						&ctx->conf.def))
+			continue;
+		num_different_channels++;
+		if (ctx->conf.radar_enabled)
+			radar_detect |= BIT(ctx->conf.def.width);
+	}
+
+	list_for_each_entry_rcu(sdata_iter, &local->interfaces, list) {
+		struct wireless_dev *wdev_iter;
+
+		wdev_iter = &sdata_iter->wdev;
+
+		if (sdata_iter == sdata ||
+		    rcu_access_pointer(sdata->vif.chanctx_conf) == NULL ||
+		    local->hw.wiphy->software_iftypes & BIT(wdev_iter->iftype))
+			continue;
+
+		num[wdev_iter->iftype]++;
+		total++;
+		used_iftypes |= BIT(wdev_iter->iftype);
+	}
+
+	if (total == 1 && !radar_detect)
+		return 0;
+
+	return cfg80211_check_combinations(local->hw.wiphy,
+					   num_different_channels, total,
+					   used_iftypes, radar_detect, num);
+}
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 4068300..f1a7363 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -408,6 +408,9 @@ cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
 			      struct wireless_dev *wdev,
 			      enum nl80211_iftype iftype)
 {
+	/* TODO: For this function, we'll probably need to keep some
+	 * kind of interface combination check in cfg80211...
+	 */
 	return cfg80211_can_use_iftype_chan(rdev, wdev, iftype, NULL,
 					    CHAN_MODE_UNDEFINED, 0);
 }
@@ -422,16 +425,6 @@ cfg80211_can_add_interface(struct cfg80211_registered_device *rdev,
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
index c9458f2..b8a7a35 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -99,7 +99,6 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 			 const struct mesh_config *conf)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	u8 radar_detect_width;
 	int err;
 
 	BUILD_BUG_ON(IEEE80211_MAX_SSID_LEN != IEEE80211_MAX_MESH_ID_LEN);
@@ -178,20 +177,6 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &setup->chandef))
 		return -EINVAL;
 
-	radar_detect_width =
-		cfg80211_chandef_dfs_required(wdev->wiphy,
-					      &setup->chandef,
-					      NL80211_IFTYPE_MESH_POINT);
-	if (radar_detect_width < 0)
-		return radar_detect_width;
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
@@ -237,17 +222,6 @@ int cfg80211_set_mesh_channel(struct cfg80211_registered_device *rdev,
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
index d47c9d1..7420196 100644
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
index 53c627c..401ba56 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3138,7 +3138,6 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_ap_settings params;
 	int err;
-	u8 radar_detect_width = 0;
 
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
@@ -3257,21 +3256,6 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &params.chandef))
 		return -EINVAL;
 
-	radar_detect_width = cfg80211_chandef_dfs_required(wdev->wiphy,
-							   &params.chandef,
-							   NL80211_IFTYPE_AP);
-	if (radar_detect_width < 0)
-		return radar_detect_width;
-
-	params.radar_required = err;
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
@@ -5798,12 +5782,6 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	if (!rdev->ops->start_radar_detection)
 		return -EOPNOTSUPP;
 
-	err = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
-					   chandef.chan, CHAN_MODE_SHARED,
-					   BIT(chandef.width));
-	if (err)
-		return err;
-
 	err = rdev->ops->start_radar_detection(&rdev->wiphy, dev, &chandef);
 	if (!err) {
 		wdev->chandef = chandef;
@@ -5922,6 +5900,10 @@ skip_beacons:
 
 	params.radar_required = radar_detect_width;
 
+	/* TODO: I left this here for now.  With channel switch, the
+	 * verification is a bit more complicated, because we only do
+	 * it later when the channel switch really happens.
+	 */
 	err = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
 					   params.chandef.chan,
 					   CHAN_MODE_SHARED,
diff --git a/net/wireless/util.c b/net/wireless/util.c
index d562dd6..be6ebf7 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1354,6 +1354,11 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 
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
1.8.5.3

