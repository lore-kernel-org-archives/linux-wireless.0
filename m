Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59806 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753637AbcJUKTw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Oct 2016 06:19:52 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: don't export cfg80211_iter_combinations()
Date: Fri, 21 Oct 2016 12:19:48 +0200
Message-Id: <1477045188-13733-1-git-send-email-johannes@sipsolutions.net> (sfid-20161021_121956_012094_24E20B00)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Nothing uses it outside of cfg80211, and since only
cfg80211_check_combinations() uses it in the same file
it can even be static - do that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h | 18 ------------------
 net/wireless/util.c    | 12 ++++++------
 2 files changed, 6 insertions(+), 24 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ec39f891b7a3..db3d020d7349 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5628,24 +5628,6 @@ unsigned int ieee80211_get_num_supported_channels(struct wiphy *wiphy);
 int cfg80211_check_combinations(struct wiphy *wiphy,
 				struct iface_combination_params *params);
 
-/**
- * cfg80211_iter_combinations - iterate over matching combinations
- *
- * @wiphy: the wiphy
- * @params: the interface combinations parameter
- * @iter: function to call for each matching combination
- * @data: pointer to pass to iter function
- *
- * This function can be called by the driver to check what possible
- * combinations it fits in at a given moment, e.g. for channel switching
- * purposes.
- */
-int cfg80211_iter_combinations(struct wiphy *wiphy,
-			       struct iface_combination_params *params,
-			       void (*iter)(const struct ieee80211_iface_combination *c,
-					    void *data),
-			       void *data);
-
 /*
  * cfg80211_stop_iface - trigger interface disconnection
  *
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 78bf53705466..8a244fb769e6 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1601,11 +1601,12 @@ int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
 	return cfg80211_check_combinations(&rdev->wiphy, &params);
 }
 
-int cfg80211_iter_combinations(struct wiphy *wiphy,
-			       struct iface_combination_params *params,
-			       void (*iter)(const struct ieee80211_iface_combination *c,
-					    void *data),
-			       void *data)
+static int
+cfg80211_iter_combinations(struct wiphy *wiphy,
+			   struct iface_combination_params *params,
+			   void (*iter)(const struct ieee80211_iface_combination *c,
+					void *data),
+			   void *data)
 {
 	const struct ieee80211_regdomain *regdom;
 	enum nl80211_dfs_regions region = 0;
@@ -1694,7 +1695,6 @@ int cfg80211_iter_combinations(struct wiphy *wiphy,
 
 	return 0;
 }
-EXPORT_SYMBOL(cfg80211_iter_combinations);
 
 static void
 cfg80211_iter_sum_ifcombs(const struct ieee80211_iface_combination *c,
-- 
2.8.1
