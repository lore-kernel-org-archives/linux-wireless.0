Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:45108 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543Ab3EKAvH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 May 2013 20:51:07 -0400
Received: by mail-pb0-f45.google.com with SMTP id mc8so1226407pbc.18
        for <linux-wireless@vger.kernel.org>; Fri, 10 May 2013 17:51:07 -0700 (PDT)
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	devel@lists.open80211s.org, ashok@cozybit.com
Subject: [PATCH 3/3] {nl,mac,cfg}80211: Allow user to configure basic rates for mesh
Date: Fri, 10 May 2013 17:50:53 -0700
Message-Id: <1368233453-10581-3-git-send-email-ashok@cozybit.com> (sfid-20130511_025123_758170_87DB29B4)
In-Reply-To: <1368233453-10581-1-git-send-email-ashok@cozybit.com>
References: <1368233453-10581-1-git-send-email-ashok@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently mesh uses mandatory rates as the default basic rates. Allow basic
rates to be configured during mesh join.

Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
---
 include/net/cfg80211.h |    2 ++
 net/mac80211/cfg.c     |    2 ++
 net/mac80211/mesh.c    |    4 ----
 net/wireless/mesh.c    |   11 +++++++++++
 net/wireless/nl80211.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 58 insertions(+), 4 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index fcb7764..06780d1 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1155,6 +1155,7 @@ struct mesh_config {
  * @dtim_period: DTIM period to use
  * @beacon_interval: beacon interval to use
  * @mcast_rate: multicat rate for Mesh Node [6Mbps is the default for 802.11a]
+ * @basic_rates: per-band bitmap of basic rates to use when creating the mesh
  *
  * These parameters are fixed when the mesh is created.
  */
@@ -1173,6 +1174,7 @@ struct mesh_setup {
 	u8 dtim_period;
 	u16 beacon_interval;
 	int mcast_rate[IEEE80211_NUM_BANDS];
+	u32 basic_rates[IEEE80211_NUM_BANDS];
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 1a89c80..2d4131f 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1744,6 +1744,8 @@ static int copy_mesh_setup(struct ieee80211_if_mesh *ifmsh,
 	/* mcast rate setting in Mesh Node */
 	memcpy(sdata->vif.bss_conf.mcast_rate, setup->mcast_rate,
 						sizeof(setup->mcast_rate));
+	sdata->vif.bss_conf.basic_rates =
+				setup->basic_rates[setup->chandef.chan->band];
 
 	sdata->vif.bss_conf.beacon_int = setup->beacon_interval;
 	sdata->vif.bss_conf.dtim_period = setup->dtim_period;
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 5a37f95..7e4fce9 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -740,9 +740,6 @@ int ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 		      BSS_CHANGED_HT |
 		      BSS_CHANGED_BASIC_RATES |
 		      BSS_CHANGED_BEACON_INT;
-	enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
-	struct ieee80211_supported_band *sband =
-					sdata->local->hw.wiphy->bands[band];
 
 	local->fif_other_bss++;
 	/* mesh ifaces must set allmulti to forward mcast traffic */
@@ -761,7 +758,6 @@ int ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 	sdata->vif.bss_conf.ht_operation_mode =
 				ifmsh->mshcfg.ht_opmode;
 	sdata->vif.bss_conf.enable_beacon = true;
-	sdata->vif.bss_conf.basic_rates = ieee80211_mandatory_rates(sband);
 
 	changed |= ieee80211_mps_local_status_update(sdata);
 
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 0bb93f3..9133942 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -159,6 +159,17 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 		setup->chandef.center_freq1 = setup->chandef.chan->center_freq;
 	}
 
+	/*
+	 * we now know the operating band, so check if basic rates are
+	 * available for this band otherwise use mandatory rates as basic rates
+	 */
+	if (!setup->basic_rates[setup->chandef.chan->band]) {
+		enum ieee80211_band band = setup->chandef.chan->band;
+		struct ieee80211_supported_band *sband =
+							rdev->wiphy.bands[band];
+		setup->basic_rates[band] = ieee80211_mandatory_rates(sband);
+	}
+
 	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &setup->chandef))
 		return -EINVAL;
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index afa2838..65a1e95 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6232,6 +6232,33 @@ nl80211_parse_mcast_rate(struct cfg80211_registered_device *rdev,
 	return found;
 }
 
+static int nl80211_parse_basic_rates(struct cfg80211_registered_device *rdev,
+				     const u8 *rates, unsigned int n_rates,
+				     u32 mask[IEEE80211_NUM_BANDS])
+{
+	struct wiphy *wiphy = &rdev->wiphy;
+	bool found = false;
+	int band, err;
+	struct ieee80211_supported_band *sband;
+
+	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+		err = 0;
+		sband = wiphy->bands[band];
+
+		if (!sband)
+			continue;
+
+		err = ieee80211_get_ratemask(sband, rates, n_rates,
+					     &mask[band]);
+		if (!err)
+			found = true;
+	}
+
+	if (!found)
+		return -EINVAL;
+	return 0;
+}
+
 static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
@@ -7460,6 +7487,22 @@ static int nl80211_join_mesh(struct sk_buff *skb, struct genl_info *info)
 			    nla_get_u32(info->attrs[NL80211_ATTR_MCAST_RATE])))
 			return -EINVAL;
 
+	if (info->attrs[NL80211_ATTR_BSS_BASIC_RATES]) {
+		u8 *rates = nla_data(info->attrs[NL80211_ATTR_BSS_BASIC_RATES]);
+		int n_rates =
+			     nla_len(info->attrs[NL80211_ATTR_BSS_BASIC_RATES]);
+
+		/*
+		 * since we may or may not have an operating band yet, verify
+		 * given basic rates are supported for all available bands
+		 */
+
+		err = nl80211_parse_basic_rates(rdev, rates, n_rates,
+						setup.basic_rates);
+		if (err)
+			return err;
+	}
+
 	if (info->attrs[NL80211_ATTR_BEACON_INTERVAL]) {
 		setup.beacon_interval =
 			nla_get_u32(info->attrs[NL80211_ATTR_BEACON_INTERVAL]);
-- 
1.7.5.4

