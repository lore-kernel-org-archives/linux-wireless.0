Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:49198 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbaECU4D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 May 2014 16:56:03 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 3.15] cfg80211: allow restricting supported dfs regions
Date: Sat,  3 May 2014 22:55:55 +0200
Message-Id: <1399150555-36041-1-git-send-email-nbd@openwrt.org> (sfid-20140503_225608_008935_7171835B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

At the moment, the ath9k/ath10k DFS module only supports detecting ETSI
radar patterns.
Add a bitmap in the interface combinations, indicating which DFS regions
are supported by the detector. If unset, support for all regions is
assumed.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/net/cfg80211.h |  2 ++
 net/wireless/util.c    | 14 ++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f3539a1..96975fb 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2618,6 +2618,7 @@ struct ieee80211_iface_limit {
  *	between infrastructure and AP types must match. This is required
  *	only in special cases.
  * @radar_detect_widths: bitmap of channel widths supported for radar detection
+ * @radar_detect_regions: bitmap of regions supported for radar detection
  *
  * With this structure the driver can describe which interface
  * combinations it supports concurrently.
@@ -2675,6 +2676,7 @@ struct ieee80211_iface_combination {
 	u8 n_limits;
 	bool beacon_int_infra_match;
 	u8 radar_detect_widths;
+	u8 radar_detect_regions;
 };
 
 struct ieee80211_txrx_stypes {
diff --git a/net/wireless/util.c b/net/wireless/util.c
index e5872ff..b2fb12a 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1275,6 +1275,7 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 				 enum cfg80211_chan_mode chanmode,
 				 u8 radar_detect)
 {
+	const struct ieee80211_regdomain *regdom;
 	struct wireless_dev *wdev_iter;
 	u32 used_iftypes = BIT(iftype);
 	int num[NUM_NL80211_IFTYPES];
@@ -1283,6 +1284,7 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 	struct ieee80211_channel *ch;
 	enum cfg80211_chan_mode chmode;
 	int num_different_channels = 0;
+	enum nl80211_dfs_regions region = 0;
 	int total = 1;
 	int i, j;
 
@@ -1301,6 +1303,14 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 		return 0;
 	}
 
+	if (radar_detect) {
+		rcu_read_lock();
+		regdom = rcu_dereference(cfg80211_regdomain);
+		if (regdom)
+			region = regdom->dfs_region;
+		rcu_read_unlock();
+	}
+
 	memset(num, 0, sizeof(num));
 	memset(used_channels, 0, sizeof(used_channels));
 
@@ -1408,6 +1418,10 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 		if (radar_detect && !(c->radar_detect_widths & radar_detect))
 			goto cont;
 
+		if (radar_detect && c->radar_detect_regions &&
+		    !(c->radar_detect_regions & BIT(region)))
+			goto cont;
+
 		/*
 		 * Finally check that all iftypes that we're currently
 		 * using are actually part of this combination. If they
-- 
1.8.5.2 (Apple Git-48)

