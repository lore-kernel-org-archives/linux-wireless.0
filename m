Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:40358 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755592AbaEEJsv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2014 05:48:51 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH v2] cfg80211: allow restricting supported dfs regions
Date: Mon,  5 May 2014 11:48:40 +0200
Message-Id: <1399283320-66468-1-git-send-email-nbd@openwrt.org> (sfid-20140505_114854_617418_6C67DD94)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

At the moment, the ath9k/ath10k DFS module only supports detecting ETSI
radar patterns.
Add a bitmap in the interface combinations, indicating which DFS regions
are supported by the detector. If unset, support for all regions is
assumed.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/net/cfg80211.h       |  2 ++
 include/uapi/linux/nl80211.h |  3 +++
 net/wireless/nl80211.c       |  6 ++++--
 net/wireless/util.c          | 14 ++++++++++++++
 4 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 7eae46c..28e3a15 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2638,6 +2638,7 @@ struct ieee80211_iface_limit {
  *	between infrastructure and AP types must match. This is required
  *	only in special cases.
  * @radar_detect_widths: bitmap of channel widths supported for radar detection
+ * @radar_detect_regions: bitmap of regions supported for radar detection
  *
  * With this structure the driver can describe which interface
  * combinations it supports concurrently.
@@ -2695,6 +2696,7 @@ struct ieee80211_iface_combination {
 	u8 n_limits;
 	bool beacon_int_infra_match;
 	u8 radar_detect_widths;
+	u8 radar_detect_regions;
 };
 
 struct ieee80211_txrx_stypes {
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 406010d..b65095a 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3688,6 +3688,8 @@ enum nl80211_iface_limit_attrs {
  *	different channels may be used within this group.
  * @NL80211_IFACE_COMB_RADAR_DETECT_WIDTHS: u32 attribute containing the bitmap
  *	of supported channel widths for radar detection.
+ * @NL80211_IFACE_COMB_RADAR_DETECT_REGIONS: u32 attribute containing the bitmap
+ *	of supported regulatory regions for radar detection.
  * @NUM_NL80211_IFACE_COMB: number of attributes
  * @MAX_NL80211_IFACE_COMB: highest attribute number
  *
@@ -3721,6 +3723,7 @@ enum nl80211_if_combination_attrs {
 	NL80211_IFACE_COMB_STA_AP_BI_MATCH,
 	NL80211_IFACE_COMB_NUM_CHANNELS,
 	NL80211_IFACE_COMB_RADAR_DETECT_WIDTHS,
+	NL80211_IFACE_COMB_RADAR_DETECT_REGIONS,
 
 	/* keep last */
 	NUM_NL80211_IFACE_COMB,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 0f1b18f2..c083383 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -970,8 +970,10 @@ static int nl80211_put_iface_combinations(struct wiphy *wiphy,
 				c->max_interfaces))
 			goto nla_put_failure;
 		if (large &&
-		    nla_put_u32(msg, NL80211_IFACE_COMB_RADAR_DETECT_WIDTHS,
-				c->radar_detect_widths))
+		    (nla_put_u32(msg, NL80211_IFACE_COMB_RADAR_DETECT_WIDTHS,
+				c->radar_detect_widths) ||
+		     nla_put_u32(msg, NL80211_IFACE_COMB_RADAR_DETECT_REGIONS,
+				c->radar_detect_regions)))
 			goto nla_put_failure;
 
 		nla_nest_end(msg, nl_combi);
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 7c47fa0..301598f 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1271,10 +1271,20 @@ int cfg80211_iter_combinations(struct wiphy *wiphy,
 					    void *data),
 			       void *data)
 {
+	const struct ieee80211_regdomain *regdom;
+	enum nl80211_dfs_regions region = 0;
 	int i, j, iftype;
 	int num_interfaces = 0;
 	u32 used_iftypes = 0;
 
+	if (radar_detect) {
+		rcu_read_lock();
+		regdom = rcu_dereference(cfg80211_regdomain);
+		if (regdom)
+			region = regdom->dfs_region;
+		rcu_read_unlock();
+	}
+
 	for (iftype = 0; iftype < NUM_NL80211_IFTYPES; iftype++) {
 		num_interfaces += iftype_num[iftype];
 		if (iftype_num[iftype] > 0 &&
@@ -1315,6 +1325,10 @@ int cfg80211_iter_combinations(struct wiphy *wiphy,
 		if (radar_detect != (c->radar_detect_widths & radar_detect))
 			goto cont;
 
+		if (radar_detect && c->radar_detect_regions &&
+		    !(c->radar_detect_regions & BIT(region)))
+			goto cont;
+
 		/* Finally check that all iftypes that we're currently
 		 * using are actually part of this combination. If they
 		 * aren't then we can't use this combination and have
-- 
1.8.5.2 (Apple Git-48)

