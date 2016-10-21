Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60800 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932279AbcJUMZZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Oct 2016 08:25:25 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>,
        jouni@qca.qualcomm.com, usdutt@qti.qualcomm.com,
        amarnath@qca.qualcomm.com, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4/4] mac80211: validate new interface's beacon intervals
Date: Fri, 21 Oct 2016 14:25:14 +0200
Message-Id: <1477052714-11223-4-git-send-email-johannes@sipsolutions.net> (sfid-20161021_142531_714387_DBF77FD6)
In-Reply-To: <1477052714-11223-1-git-send-email-johannes@sipsolutions.net>
References: <1477052714-11223-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

As part of interface combination checking, verify any new
interface's beacon intervals. In fact, just always add the
beacon interval since that's harmless.

With this patch, mac80211 is prepared for drivers that set
the min_beacon_int_gcd parameter in interface combinations.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c  |  3 ++-
 net/mac80211/util.c | 10 ++++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index eb68add4393c..e91e503bf992 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -864,6 +864,8 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	}
 	sdata->needed_rx_chains = sdata->local->rx_chains;
 
+	sdata->vif.bss_conf.beacon_int = params->beacon_interval;
+
 	mutex_lock(&local->mtx);
 	err = ieee80211_vif_use_channel(sdata, &params->chandef,
 					IEEE80211_CHANCTX_SHARED);
@@ -894,7 +896,6 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 					      vlan->vif.type);
 	}
 
-	sdata->vif.bss_conf.beacon_int = params->beacon_interval;
 	sdata->vif.bss_conf.dtim_period = params->dtim_period;
 	sdata->vif.bss_conf.enable_beacon = true;
 	sdata->vif.bss_conf.allow_p2p_go_ps = sdata->vif.p2p;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 7f24bdc68f71..ac59fbd280df 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -3326,6 +3326,16 @@ int ieee80211_check_combinations(struct ieee80211_sub_if_data *sdata,
 	if (WARN_ON(iftype >= NUM_NL80211_IFTYPES))
 		return -EINVAL;
 
+	if (sdata->vif.type == NL80211_IFTYPE_AP ||
+	    sdata->vif.type == NL80211_IFTYPE_MESH_POINT) {
+		/*
+		 * always passing this is harmless, since it'll be the
+		 * same value that cfg80211 finds if it finds the same
+		 * interface ... and that's always allowed
+		 */
+		params.new_beacon_int = sdata->vif.bss_conf.beacon_int;
+	}
+
 	/* Always allow software iftypes */
 	if (local->hw.wiphy->software_iftypes & BIT(iftype)) {
 		if (radar_detect)
-- 
2.8.1
