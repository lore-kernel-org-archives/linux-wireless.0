Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40762 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760077Ab2FHCVh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 22:21:37 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so1891876pbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 19:21:36 -0700 (PDT)
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	javier@cozybit.com, devel@lists.open80211s.org,
	Ashok Nagarajan <ashok@cozybit.com>
Subject: [PATCH 3/3] [nl,cfg,mac]80211: Allow user to configure basic rates when joining
Date: Thu,  7 Jun 2012 19:21:26 -0700
Message-Id: <1339122086-23190-3-git-send-email-ashok@cozybit.com> (sfid-20120608_042141_660950_DD36B621)
In-Reply-To: <1339122086-23190-1-git-send-email-ashok@cozybit.com>
References: <1339122086-23190-1-git-send-email-ashok@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently mesh uses mandatory rates as default basic rates. This patch
introduces basic rates to be configured at the time of joining mesh.

Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
---
 include/net/cfg80211.h |    1 +
 net/mac80211/cfg.c     |    2 ++
 net/mac80211/mesh.c    |    6 +++---
 net/wireless/nl80211.c |   17 +++++++++++++++++
 4 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 7319f25..4b65b1f 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -859,6 +859,7 @@ struct mesh_setup {
 	bool is_authenticated;
 	bool is_secure;
 	int mcast_rate[IEEE80211_NUM_BANDS];
+	u32 basic_rates;
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 498c94e..6348a6c 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1499,6 +1499,8 @@ static int copy_mesh_setup(struct ieee80211_if_mesh *ifmsh,
 	/* mcast rate setting in Mesh Node */
 	memcpy(sdata->vif.bss_conf.mcast_rate, setup->mcast_rate,
 						sizeof(setup->mcast_rate));
+	if (setup->basic_rates)
+		sdata->vif.bss_conf.basic_rates = setup->basic_rates;
 
 	return 0;
 }
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 2b814d5..f72c67d 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -612,9 +612,9 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 	sdata->vif.bss_conf.ht_operation_mode =
 				ifmsh->mshcfg.ht_opmode;
 	sdata->vif.bss_conf.beacon_int = MESH_DEFAULT_BEACON_INTERVAL;
-	sdata->vif.bss_conf.basic_rates =
-		ieee80211_mandatory_rates(sdata->local,
-					  sdata->local->hw.conf.channel->band);
+	if (!sdata->vif.bss_conf.basic_rates)
+		sdata->vif.bss_conf.basic_rates =
+			ieee80211_mandatory_rates(sdata, band);
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON |
 						BSS_CHANGED_BEACON_ENABLED |
 						BSS_CHANGED_HT |
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 7ae54b8..29d3723 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6063,6 +6063,9 @@ static int nl80211_join_mesh(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = &rdev->wiphy;
+	struct ieee80211_supported_band *sband;
 	struct mesh_config cfg;
 	struct mesh_setup setup;
 	int err;
@@ -6085,6 +6088,20 @@ static int nl80211_join_mesh(struct sk_buff *skb, struct genl_info *info)
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

