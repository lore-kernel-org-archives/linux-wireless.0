Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA6C377AB1
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 19:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790020381; cv=none; b=auoxabuSQg+rWqcOM3iXRN1g18ZyUZblcg/fAjg5Cdmns9/vhWJBgTF9ec9crHVjYRIElF1xqYaoZscdZcIpj+btaX6GGYwdWdPaBZ4IIpe8r+9mxfWsBe4XGcA+FJWpwa/hZsKVfXR2NprcU6d57FTs0OxHXGDD+qsXHH4bJQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790020381; c=relaxed/simple;
	bh=q9oYBZ7/ZbNHga+edB56hMtIQnfeeRiEb36dt4JKJOI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=WzYc42wN30utPAD5tf1z/UPnTuTPSkmlCYaAfEdNqG6ALydurzgnKuHHr1BamYS7IlOUPFaPcwcrYK0PpSWNOXLzcUgoT62Bc/vMTHBXId4JA2qxZUdTXLG/Ill/ikhVdiHAozvZoiTVaLJjSdNqO0U+4XHQjtsLPxCrFYzrVzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GNMlofYU; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GNMlofYU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790020378; x=1821556378;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=q9oYBZ7/ZbNHga+edB56hMtIQnfeeRiEb36dt4JKJOI=;
  b=GNMlofYUM8svCun4Y0IAI8uyLelq469F29FfnoU6EwejyvU8G/3FpXrC
   JlwOCRfNB+m35pTK6W3AURFFK102kcjklUEurmKfwyNQvaMl1I0OQIp43
   CoEmnyeB+A9/rvw+9Sjku5rlVjtbJZb2A2BUDBMHFx8IlAJI7WoQD8b6j
   tyCgDE/BaJzHge1S3XDs0571GTwIq7GewXls6DxIaDEWWJhVBqkIY/cPp
   6v1B+eK4Z10PAkvILgsmFSNyYRl6IdTEBC0sUaU7TL1BLo7ctOAhOME46
   QQ/DnMJmSq9WtqpmF4rtVKceqJgoxT9rW322nUz7hwKZv5P1XKojAm097
   g==;
X-CSE-ConnectionGUID: E39hhdnjTdm7P51Ci3tmAg==
X-CSE-MsgGUID: iMDuTH6PQxu4da44ziCSXQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="90435083"
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="90435083"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 12:52:57 -0700
X-CSE-ConnectionGUID: HHXzT6fTQGecUFDOozy3SQ==
X-CSE-MsgGUID: 7ds2r+jYQ5aXaFLrSSA4dw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="3891570"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 12:52:57 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 1/2] wifi: nl80211: defer AP beacon regulatory check to start_ap
Date: Mon, 21 Sep 2026 22:54:54 +0300
Message-Id: <20260921224731.67fbc8a28a2c.I5633284cb4c82ffb4e4e32e6f2dcc9a71fd5b06a@changeid>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>

Defer the cfg80211_reg_can_beacon_relax() check
from __nl80211_set_channel() for AP and P2P-GO.

At __nl80211_set_channel() stage AP type is not fully known
before start_ap, so this early check incorrectly rejects valid
VLP AP bring-up. start_ap has the required AP context and already
performs the regulatory validation, so start checking after start_ap.

This way, VLP APs can be brought up. Also handle the CSA scenario by
running regulatory beaconing validation during channel switch and
preserving/updating AP reg_power across CSA completion.

Signed-off-by: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 include/net/cfg80211.h |  2 ++
 net/wireless/ap.c      |  7 +++----
 net/wireless/nl80211.c | 33 +++++++++++++++++++++++++++------
 net/wireless/reg.c     |  9 +++++++--
 4 files changed, 39 insertions(+), 12 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9aa7d2d4a184..9d3e0aaacd92 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -7334,6 +7334,8 @@ struct wireless_dev {
 		union {
 			struct {
 				unsigned int beacon_interval;
+				enum ieee80211_ap_reg_power reg_power;
+				enum ieee80211_ap_reg_power csa_reg_power;
 				struct cfg80211_chan_def chandef;
 			} ap;
 			struct {
diff --git a/net/wireless/ap.c b/net/wireless/ap.c
index 9a9a870806f5..fa5441987a90 100644
--- a/net/wireless/ap.c
+++ b/net/wireless/ap.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  * Parts of this file are
- * Copyright (C) 2022-2023 Intel Corporation
+ * Copyright (C) 2022-2023, 2026 Intel Corporation
  */
 #include <linux/ieee80211.h>
 #include <linux/export.h>
@@ -33,9 +33,8 @@ static int ___cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
 	err = rdev_stop_ap(rdev, dev, link_id);
 	if (!err) {
 		wdev->conn_owner_nlportid = 0;
-		wdev->links[link_id].ap.beacon_interval = 0;
-		memset(&wdev->links[link_id].ap.chandef, 0,
-		       sizeof(wdev->links[link_id].ap.chandef));
+		memset(&wdev->links[link_id].ap, 0,
+		       sizeof(wdev->links[link_id].ap));
 		wdev->u.ap.ssid_len = 0;
 		rdev_set_qos_map(rdev, dev, NULL);
 		if (notify)
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ab5a14f5fe28..0323b9c383b7 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4142,12 +4142,17 @@ static int __nl80211_set_channel(struct cfg80211_registered_device *rdev,
 	switch (iftype) {
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_P2P_GO:
-		if (!cfg80211_reg_can_beacon_relax(&rdev->wiphy, &chandef,
-						   iftype))
-			return -EINVAL;
 		if (wdev->links[link_id].ap.beacon_interval) {
 			struct ieee80211_channel *cur_chan;
-
+			struct cfg80211_beaconing_check_config config = {
+				.iftype = iftype,
+				.reg_power = wdev->links[link_id].ap.reg_power,
+				.relax = true,
+			};
+
+			if (!cfg80211_reg_check_beaconing(&rdev->wiphy,
+							  &chandef, &config))
+				return -EINVAL;
 			if (!dev || !rdev->ops->set_ap_chanwidth ||
 			    !(rdev->wiphy.features &
 			      NL80211_FEATURE_AP_MODE_CHAN_WIDTH_CHANGE))
@@ -7378,6 +7383,7 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 					     params->beacon.tail_len, 0);
 	if (!cfg80211_reg_check_beaconing(&rdev->wiphy, &params->chandef,
 					  &beacon_check)) {
+		GENL_SET_ERR_MSG(info, "Channel rejected by regulatory");
 		err = -EINVAL;
 		goto out;
 	}
@@ -7492,6 +7498,7 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	err = rdev_start_ap(rdev, dev, params);
 	if (!err) {
 		wdev->links[link_id].ap.beacon_interval = params->beacon_interval;
+		wdev->links[link_id].ap.reg_power = beacon_check.reg_power;
 		wdev->links[link_id].ap.chandef = params->chandef;
 		wdev->u.ap.ssid_len = params->ssid_len;
 		memcpy(wdev->u.ap.ssid, params->ssid,
@@ -7584,6 +7591,8 @@ static int nl80211_set_beacon(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	err = rdev_change_beacon(rdev, dev, params);
+	if (!err)
+		wdev->links[link_id].ap.reg_power = beacon_check.reg_power;
 
 out:
 	kfree(params->beacon.mbssid_ies);
@@ -12240,6 +12249,7 @@ static int nl80211_parse_counter_offsets(struct cfg80211_registered_device *rdev
 static int nl80211_channel_switch(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct cfg80211_beaconing_check_config beacon_check = {};
 	unsigned int link_id = nl80211_link_id(info->attrs);
 	struct net_device *dev = info->user_ptr[1];
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
@@ -12364,8 +12374,13 @@ static int nl80211_channel_switch(struct sk_buff *skb, struct genl_info *info)
 		goto free;
 
 skip_beacons:
-	if (!cfg80211_reg_can_beacon_relax(&rdev->wiphy, &params.chandef,
-					   wdev->iftype)) {
+	beacon_check.iftype = wdev->iftype;
+	beacon_check.relax = true;
+	beacon_check.reg_power =
+		cfg80211_get_6ghz_power_type(params.beacon_after.tail,
+					     params.beacon_after.tail_len, 0);
+	if (!cfg80211_reg_check_beaconing(&rdev->wiphy, &params.chandef,
+					  &beacon_check)) {
 		err = -EINVAL;
 		goto free;
 	}
@@ -12401,6 +12416,10 @@ static int nl80211_channel_switch(struct sk_buff *skb, struct genl_info *info)
 	params.link_id = link_id;
 	err = rdev_channel_switch(rdev, dev, &params);
 
+	if (!err && (wdev->iftype == NL80211_IFTYPE_AP ||
+		     wdev->iftype == NL80211_IFTYPE_P2P_GO))
+		wdev->links[link_id].ap.csa_reg_power = beacon_check.reg_power;
+
 free:
 	kfree(params.beacon_after.mbssid_ies);
 	kfree(params.beacon_csa.mbssid_ies);
@@ -22583,6 +22602,8 @@ void cfg80211_ch_switch_notify(struct net_device *dev,
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_P2P_GO:
 		wdev->links[link_id].ap.chandef = *chandef;
+		wdev->links[link_id].ap.reg_power =
+			wdev->links[link_id].ap.csa_reg_power;
 		break;
 	case NL80211_IFTYPE_ADHOC:
 		wdev->u.ibss.chandef = *chandef;
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index a8336baf85dc..38a0ae63bc96 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2361,6 +2361,10 @@ static bool reg_wdev_chan_valid(struct wiphy *wiphy, struct wireless_dev *wdev)
 	}
 
 	for (link = 0; link < ARRAY_SIZE(wdev->links); link++) {
+		struct cfg80211_beaconing_check_config config = {
+			.iftype = iftype,
+			.relax = true,
+		};
 		struct ieee80211_channel *chan;
 
 		if (!wdev->valid_links && link > 0)
@@ -2373,6 +2377,7 @@ static bool reg_wdev_chan_valid(struct wiphy *wiphy, struct wireless_dev *wdev)
 			if (!wdev->links[link].ap.beacon_interval)
 				continue;
 			chandef = wdev->links[link].ap.chandef;
+			config.reg_power = wdev->links[link].ap.reg_power;
 			break;
 		case NL80211_IFTYPE_MESH_POINT:
 			if (!wdev->u.mesh.beacon_interval)
@@ -2426,8 +2431,8 @@ static bool reg_wdev_chan_valid(struct wiphy *wiphy, struct wireless_dev *wdev)
 		case NL80211_IFTYPE_P2P_GO:
 		case NL80211_IFTYPE_ADHOC:
 		case NL80211_IFTYPE_MESH_POINT:
-			ret = cfg80211_reg_can_beacon_relax(wiphy, &chandef,
-							    iftype);
+			ret = cfg80211_reg_check_beaconing(wiphy, &chandef,
+							   &config);
 			if (!ret)
 				return ret;
 			break;
-- 
2.34.1

