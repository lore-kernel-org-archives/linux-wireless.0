Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:35690 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbaBTOgf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 09:36:35 -0500
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, michal.kazior@tieto.com,
	sw@simonwunderlich.de, bzhao@marvell.com, arend@broadcom.com
Subject: [PATCH v3 6/7] cfg80211/mac80211: move interface counting for combination check to mac80211
Date: Thu, 20 Feb 2014 16:36:25 +0200
Message-Id: <1392906986-12275-7-git-send-email-luca@coelho.fi> (sfid-20140220_153700_703434_E557ED1C)
In-Reply-To: <1392906986-12275-1-git-send-email-luca@coelho.fi>
References: <1392906986-12275-1-git-send-email-luca@coelho.fi>
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
---
 include/net/cfg80211.h     |  4 +--
 net/mac80211/cfg.c         |  7 ++--
 net/mac80211/chan.c        | 17 +++++++++
 net/mac80211/ieee80211_i.h |  5 +++
 net/mac80211/mlme.c        | 14 ++++++++
 net/mac80211/util.c        | 88 ++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/core.h        |  7 ++++
 net/wireless/ibss.c        |  4 +++
 net/wireless/mesh.c        | 19 +++-------
 net/wireless/mlme.c        | 14 +-------
 net/wireless/nl80211.c     | 26 +++-----------
 net/wireless/util.c        |  5 +++
 12 files changed, 156 insertions(+), 54 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index a1ce7cd..35b5eeb 100644
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
index 7f01f2ae..ea7da53 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -972,7 +972,6 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	sdata->needed_rx_chains = sdata->local->rx_chains;
 
 	mutex_lock(&local->mtx);
-	sdata->radar_required = params->radar_required;
 	err = ieee80211_vif_use_channel(sdata, &params->chandef,
 					IEEE80211_CHANCTX_SHARED);
 	mutex_unlock(&local->mtx);
@@ -2928,13 +2927,17 @@ static int ieee80211_start_radar_detection(struct wiphy *wiphy,
 	/* whatever, but channel contexts should not complain about that one */
 	sdata->smps_mode = IEEE80211_SMPS_OFF;
 	sdata->needed_rx_chains = local->rx_chains;
-	sdata->radar_required = true;
 
 	err = ieee80211_vif_use_channel(sdata, chandef,
 					IEEE80211_CHANCTX_SHARED);
 	if (err)
 		goto out_unlock;
 
+	/* Something is wrong if cfg80211 asked us to start radar
+	 * detection but we don't think we need to.
+	 */
+	WARN_ON(!sdata->radar_required);
+
 	timeout = msecs_to_jiffies(IEEE80211_DFS_MIN_CAC_TIME_MS);
 	ieee80211_queue_delayed_work(&sdata->local->hw,
 				     &sdata->dfs_cac_timer_work, timeout);
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 42c6592..39cfccb 100644
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
+	sdata->radar_required = !!(radar_detect_width);
+
+	ret = ieee80211_check_combinations(local->hw.wiphy, &sdata->wdev,
+					   chandef, mode, radar_detect_width);
+	if (ret < 0)
+		goto out;
+
 	__ieee80211_vif_release_channel(sdata);
 
 	ctx = ieee80211_find_chanctx(local, chandef, mode);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 8603dfb..3c5d293 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1810,6 +1810,11 @@ int ieee80211_cs_headroom(struct ieee80211_local *local,
 			  enum nl80211_iftype iftype);
 void ieee80211_recalc_dtim(struct ieee80211_local *local,
 			   struct ieee80211_sub_if_data *sdata);
+int ieee80211_check_combinations(struct wiphy *wiphy,
+				 struct wireless_dev *wdev,
+				 const struct cfg80211_chan_def *chandef,
+				 enum ieee80211_chanctx_mode chanmode,
+				 u8 radar_detect);
 
 #ifdef CONFIG_MAC80211_NOINLINE
 #define debug_noinline noinline
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 46b62bb..4bdf49a 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3949,6 +3949,13 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 	u16 auth_alg;
 	int err;
 
+	/* TODO: in cfg80211_mlme_auth() we used to check if the
+	 * channel can be used *before* this function was called.  Do
+	 * we still need to do it or can we rely on the combinations
+	 * check that will happen later, in
+	 * ieee80211_vif_use_channel()?
+	 */
+
 	/* prepare auth data structure */
 
 	switch (req->auth_type) {
@@ -4103,6 +4110,13 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	const u8 *ssidie, *ht_ie, *vht_ie;
 	int i, err;
 
+	/* TODO: in cfg80211_mlme_assoc() we used to check if the
+	 * channel can be used *before* this function was called.  Do
+	 * we still need to do it or can we rely on the combinations
+	 * check that will happen later, in
+	 * ieee80211_vif_use_channel()?
+	 */
+
 	assoc_data = kzalloc(sizeof(*assoc_data) + req->ie_len, GFP_KERNEL);
 	if (!assoc_data)
 		return -ENOMEM;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index d842af5..172457d 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2801,3 +2801,91 @@ void ieee80211_recalc_dtim(struct ieee80211_local *local,
 
 	ps->dtim_count = dtim_count;
 }
+
+int ieee80211_check_combinations(struct wiphy *wiphy,
+				 struct wireless_dev *wdev,
+				 const struct cfg80211_chan_def *chandef,
+				 enum ieee80211_chanctx_mode chanmode,
+				 u8 radar_detect)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata;
+	struct wireless_dev *wdev_iter;
+	enum nl80211_iftype iftype = NL80211_IFTYPE_UNSPECIFIED;
+	u32 used_iftypes = 0;
+	int num[NUM_NL80211_IFTYPES];
+	struct ieee80211_chanctx *ctx;
+	int num_different_channels = 1;
+	int total = 1;
+
+	lockdep_assert_held(&local->chanctx_mtx);
+
+	if (wdev)
+		iftype = wdev->iftype;
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
+	if (wiphy->software_iftypes & BIT(iftype)) {
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
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		wdev_iter = &sdata->wdev;
+		if (wdev_iter == wdev)
+			continue;
+		if (wdev_iter->iftype == NL80211_IFTYPE_P2P_DEVICE) {
+			if (!wdev_iter->p2p_started)
+				continue;
+		} else if (wdev_iter->netdev) {
+			if (!netif_running(wdev_iter->netdev))
+				continue;
+		} else {
+			WARN_ON(1);
+		}
+
+		if (wiphy->software_iftypes & BIT(wdev_iter->iftype))
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
+	return cfg80211_check_combinations(wiphy, num_different_channels,
+					   total, used_iftypes,
+					   radar_detect, num);
+}
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 9895ab1..4b1a6a0 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -406,6 +406,9 @@ cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
 			      struct wireless_dev *wdev,
 			      enum nl80211_iftype iftype)
 {
+	/* TODO: For this function, we'll probably need to keep some
+	 * kind of interface combination check in cfg80211...
+	 */
 	return cfg80211_can_use_iftype_chan(rdev, wdev, iftype, NULL,
 					    CHAN_MODE_UNDEFINED, 0);
 }
@@ -426,6 +429,10 @@ cfg80211_can_use_chan(struct cfg80211_registered_device *rdev,
 		      struct ieee80211_channel *chan,
 		      enum cfg80211_chan_mode chanmode)
 {
+	/* TODO: for libertas, we probably need to move the
+	 * combination check into that driver if we get rid of the
+	 * cfg80211_can_use_chan() function.
+	 */
 	return cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
 					    chan, chanmode, 0);
 }
diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index c66c524..6e98e49 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -134,6 +134,10 @@ int __cfg80211_join_ibss(struct cfg80211_registered_device *rdev,
 		 */
 		radar_detect_width = BIT(params->chandef.width);
 
+	/* TODO: We need to check the combinations at this point, we
+	 * probably must move this call down to join_ibss() in
+	 * mac80211.
+	 */
 	err = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
 					   check_chan,
 					   (params->channel_fixed &&
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index c9458f2..cacf79e 100644
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
@@ -243,6 +228,10 @@ int cfg80211_set_mesh_channel(struct cfg80211_registered_device *rdev,
 		 * channel here, something is wrong.
 		 */
 		WARN_ON_ONCE(chandef->chan->flags & IEEE80211_CHAN_RADAR);
+
+		/* TODO: We probably need to move this into the
+		 * libertas driver?
+		 */
 		err = cfg80211_can_use_chan(rdev, wdev, chandef->chan,
 					    CHAN_MODE_SHARED);
 		if (err)
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
index 09ef2e1..2712d2a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3136,7 +3136,6 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_ap_settings params;
 	int err;
-	u8 radar_detect_width = 0;
 
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
@@ -3255,21 +3254,6 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &params.chandef))
 		return -EINVAL;
 
-	radar_detect_width = cfg80211_chandef_dfs_required(wdev->wiphy,
-							   &params.chandef,
-							   NL80211_IFTYPE_AP);
-	if (radar_detect_width < 0)
-		return radar_detect_width;
-
-	params.radar_required = !!(err);
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
@@ -5795,12 +5779,6 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
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
@@ -5919,6 +5897,10 @@ skip_beacons:
 
 	params.radar_required = !!(radar_detect_width);
 
+	/* TODO: I left this here for now.  With channel switch, the
+	 * verification is a bit more complicated, because we only do
+	 * it later when the channel switch really happens.
+	 */
 	err = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
 					   params.chandef.chan,
 					   CHAN_MODE_SHARED,
diff --git a/net/wireless/util.c b/net/wireless/util.c
index fbc2f8a..9d08596 100644
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

