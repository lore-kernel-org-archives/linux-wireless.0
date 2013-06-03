Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:39432 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab3FCRdq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 13:33:46 -0400
Received: by mail-pd0-f174.google.com with SMTP id 3so5977590pdj.33
        for <linux-wireless@vger.kernel.org>; Mon, 03 Jun 2013 10:33:46 -0700 (PDT)
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	devel@lists.open80211s.org, javier@cozybit.com, ashok@cozybit.com
Subject: [PATCH v2] {nl,mac,cfg}80211: Allow user to configure basic rates for mesh
Date: Mon,  3 Jun 2013 10:33:36 -0700
Message-Id: <1370280816-9799-1-git-send-email-ashok@cozybit.com> (sfid-20130603_193350_384436_D1D531BB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently mesh uses mandatory rates as the default basic rates. Allow basic
rates to be configured during mesh join. Basic rates are applied only if
channel is also provided with mesh join command.

Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
---
v2:
	apply basic_rates only if frequency is also specified (Johannes)

 include/net/cfg80211.h |    2 ++
 net/mac80211/cfg.c     |    2 ++
 net/mac80211/mesh.c    |    4 ----
 net/wireless/mesh.c    |   10 ++++++++++
 net/wireless/nl80211.c |   15 +++++++++++++++
 5 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index b3b076a..84b1368 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1170,6 +1170,7 @@ struct mesh_config {
  * @dtim_period: DTIM period to use
  * @beacon_interval: beacon interval to use
  * @mcast_rate: multicat rate for Mesh Node [6Mbps is the default for 802.11a]
+ * @basic_rates: basic rates to use when creating the mesh
  *
  * These parameters are fixed when the mesh is created.
  */
@@ -1189,6 +1190,7 @@ struct mesh_setup {
 	u8 dtim_period;
 	u16 beacon_interval;
 	int mcast_rate[IEEE80211_NUM_BANDS];
+	u32 basic_rates;
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 232edf7..7dc74b5 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1756,6 +1756,8 @@ static int copy_mesh_setup(struct ieee80211_if_mesh *ifmsh,
 	/* mcast rate setting in Mesh Node */
 	memcpy(sdata->vif.bss_conf.mcast_rate, setup->mcast_rate,
 						sizeof(setup->mcast_rate));
+	sdata->vif.bss_conf.basic_rates =
+				setup->basic_rates;
 
 	sdata->vif.bss_conf.beacon_int = setup->beacon_interval;
 	sdata->vif.bss_conf.dtim_period = setup->dtim_period;
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index b3d1fdd..606964f 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -741,9 +741,6 @@ int ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
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
index 5dfb289..9cd0492 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -160,6 +160,16 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 		setup->chandef.center_freq1 = setup->chandef.chan->center_freq;
 	}
 
+	/*
+	 * check if basic rates are available otherwise use mandatory rates as
+	 * basic rates
+	 */
+	if (!setup->basic_rates) {
+		struct ieee80211_supported_band *sband =
+				rdev->wiphy.bands[setup->chandef.chan->band];
+		setup->basic_rates = ieee80211_mandatory_rates(sband);
+	}
+
 	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &setup->chandef))
 		return -EINVAL;
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index fb6abcb..77f4675 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7469,6 +7469,21 @@ static int nl80211_join_mesh(struct sk_buff *skb, struct genl_info *info)
 		err = nl80211_parse_chandef(rdev, info, &setup.chandef);
 		if (err)
 			return err;
+
+		if (info->attrs[NL80211_ATTR_BSS_BASIC_RATES]) {
+			u8 *rates =
+			    nla_data(info->attrs[NL80211_ATTR_BSS_BASIC_RATES]);
+			int n_rates =
+			     nla_len(info->attrs[NL80211_ATTR_BSS_BASIC_RATES]);
+			struct ieee80211_supported_band *sband =
+				rdev->wiphy.bands[setup.chandef.chan->band];
+
+			err = ieee80211_get_ratemask(sband, rates, n_rates,
+						     &setup.basic_rates);
+			if (err)
+				return err;
+		}
+
 	} else {
 		/* cfg80211_join_mesh() will sort it out */
 		setup.chandef.chan = NULL;
-- 
1.7.5.4

