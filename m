Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38880 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab2GREm6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 00:42:58 -0400
Received: by obbuo13 with SMTP id uo13so1580402obb.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 Jul 2012 21:42:57 -0700 (PDT)
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	javier@cozybit.com, thomas@cozybit.com, devel@lists.open80211s.org,
	Ashok Nagarajan <ashok@cozybit.com>
Subject: [PATCH V2 2/2] {nl,cfg,mac}80211: Allow user to configure basic rates when joining
Date: Tue, 17 Jul 2012 21:42:50 -0700
Message-Id: <1342586570-522-2-git-send-email-ashok@cozybit.com> (sfid-20120718_064411_771374_012909F7)
In-Reply-To: <1342586570-522-1-git-send-email-ashok@cozybit.com>
References: <1342586570-522-1-git-send-email-ashok@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently mesh uses mandatory rates as default basic rates. This patch
introduces basic rates to be configured at the time of joining mesh.

Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
Reviewed-by: Thomas Pedersen <thomas@cozybit.com>
---
v2:
	move up default basic rates calculation to cfg80211 (Johannes)

 include/net/cfg80211.h |    2 ++
 net/mac80211/cfg.c     |    1 +
 net/mac80211/mesh.c    |    5 -----
 net/wireless/mesh.c    |    7 +++++++
 net/wireless/nl80211.c |   17 +++++++++++++++++
 5 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 5b15ef7..27044ea 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -916,6 +916,7 @@ struct mesh_config {
  * @is_authenticated: this mesh requires authentication
  * @is_secure: this mesh uses security
  * @mcast_rate: multicat rate for Mesh Node [6Mbps is the default for 802.11a]
+ * @basic_rates: bitmap of basic rates to use when creating the mesh
  *
  * These parameters are fixed when the mesh is created.
  */
@@ -932,6 +933,7 @@ struct mesh_setup {
 	bool is_authenticated;
 	bool is_secure;
 	int mcast_rate[IEEE80211_NUM_BANDS];
+	u32 basic_rates;
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index efbbdc8..f3bf925 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1505,6 +1505,7 @@ static int copy_mesh_setup(struct ieee80211_if_mesh *ifmsh,
 	/* mcast rate setting in Mesh Node */
 	memcpy(sdata->vif.bss_conf.mcast_rate, setup->mcast_rate,
 						sizeof(setup->mcast_rate));
+	sdata->vif.bss_conf.basic_rates = setup->basic_rates;
 
 	return 0;
 }
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 66a718c..17b5ff5 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -583,9 +583,6 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct ieee80211_local *local = sdata->local;
-	int band = sdata->local->hw.conf.channel->band;
-	struct ieee80211_supported_band *sband =
-					sdata->local->hw.wiphy->bands[band];
 
 	local->fif_other_bss++;
 	/* mesh ifaces must set allmulti to forward mcast traffic */
@@ -604,8 +601,6 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 	sdata->vif.bss_conf.ht_operation_mode =
 				ifmsh->mshcfg.ht_opmode;
 	sdata->vif.bss_conf.beacon_int = MESH_DEFAULT_BEACON_INTERVAL;
-	sdata->vif.bss_conf.basic_rates =
-					ieee80211_mandatory_rates(sband, band);
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON |
 						BSS_CHANGED_BEACON_ENABLED |
 						BSS_CHANGED_HT |
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index c384e77..14f9101 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -151,6 +151,13 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 		setup->channel_type = NL80211_CHAN_NO_HT;
 	}
 
+	if (!setup->basic_rates) {
+		setup->basic_rates = ieee80211_mandatory_rates(
+					rdev->wiphy.bands[setup->channel->band],
+					setup->channel->band);
+
+	}
+
 	if (!cfg80211_can_beacon_sec_chan(&rdev->wiphy, setup->channel,
 					  setup->channel_type))
 		return -EINVAL;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 50b1a0e..c09572f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6383,6 +6383,9 @@ static int nl80211_join_mesh(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = &rdev->wiphy;
+	struct ieee80211_supported_band *sband;
 	struct mesh_config cfg;
 	struct mesh_setup setup;
 	int err;
@@ -6405,6 +6408,20 @@ static int nl80211_join_mesh(struct sk_buff *skb, struct genl_info *info)
 	setup.mesh_id = nla_data(info->attrs[NL80211_ATTR_MESH_ID]);
 	setup.mesh_id_len = nla_len(info->attrs[NL80211_ATTR_MESH_ID]);
 
+	if (info->attrs[NL80211_ATTR_BSS_BASIC_RATES] &&
+	    !WARN_ON(!wdev->preset_chan)) {
+		u8 *rates =
+			nla_data(info->attrs[NL80211_ATTR_BSS_BASIC_RATES]);
+		int n_rates =
+			nla_len(info->attrs[NL80211_ATTR_BSS_BASIC_RATES]);
+		sband = wiphy->bands[wdev->preset_chan->band];
+
+		err = ieee80211_get_ratemask(sband, rates, n_rates,
+					     &setup.basic_rates);
+		if (err)
+			return err;
+	}
+
 	if (info->attrs[NL80211_ATTR_MCAST_RATE] &&
 	    !nl80211_parse_mcast_rate(rdev, setup.mcast_rate,
 			    nla_get_u32(info->attrs[NL80211_ATTR_MCAST_RATE])))
-- 
1.7.5.4

