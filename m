Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50075 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab2L0Qex (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Dec 2012 11:34:53 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: disallow more station changes
Date: Thu, 27 Dec 2012 17:35:13 +0100
Message-Id: <1356626113-22698-1-git-send-email-johannes@sipsolutions.net> (sfid-20121227_173523_486460_2DBF2FDA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The following changes are invalid and should be
disallowed when a station already exists:
 * supported rates changes, except for TDLS peers
 * listen interval changes
 * HT capability changes

Disallow them and also update a mac80211 comment
explaining how they would be racy.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c     |  9 +++++----
 net/wireless/nl80211.c | 22 ++++++++--------------
 2 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index ff2ccc3..3c69c02 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1185,10 +1185,11 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 		sta->sta.aid = params->aid;
 
 	/*
-	 * FIXME: updating the following information is racy when this
-	 *	  function is called from ieee80211_change_station().
-	 *	  However, all this information should be static so
-	 *	  maybe we should just reject attemps to change it.
+	 * Some of the following updates would be racy if called on an
+	 * existing station, via ieee80211_change_station(). However,
+	 * all such changes are rejected by cfg80211 except for updates
+	 * changing the supported rates on an existing but not yet used
+	 * TDLS peer.
 	 */
 
 	if (params->listen_interval >= 0)
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b3cf7cc..a877e27 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3188,13 +3188,9 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 			nla_len(info->attrs[NL80211_ATTR_STA_SUPPORTED_RATES]);
 	}
 
-	if (info->attrs[NL80211_ATTR_STA_LISTEN_INTERVAL])
-		params.listen_interval =
-		    nla_get_u16(info->attrs[NL80211_ATTR_STA_LISTEN_INTERVAL]);
-
-	if (info->attrs[NL80211_ATTR_HT_CAPABILITY])
-		params.ht_capa =
-			nla_data(info->attrs[NL80211_ATTR_HT_CAPABILITY]);
+	if (info->attrs[NL80211_ATTR_STA_LISTEN_INTERVAL] ||
+	    info->attrs[NL80211_ATTR_HT_CAPABILITY])
+		return -EINVAL;
 
 	if (!rdev->ops->change_station)
 		return -EOPNOTSUPP;
@@ -3236,6 +3232,10 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 				  BIT(NL80211_STA_FLAG_MFP)))
 			return -EINVAL;
 
+		/* reject other things that can't change */
+		if (params.supported_rates)
+			return -EINVAL;
+
 		/* must be last in here for error handling */
 		params.vlan = get_vlan(info, rdev);
 		if (IS_ERR(params.vlan))
@@ -3255,10 +3255,6 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 		/* disallow things sta doesn't support */
 		if (params.plink_action)
 			return -EINVAL;
-		if (params.ht_capa)
-			return -EINVAL;
-		if (params.listen_interval >= 0)
-			return -EINVAL;
 		/* reject any changes other than AUTHORIZED */
 		if (params.sta_flags_mask & ~BIT(NL80211_STA_FLAG_AUTHORIZED))
 			return -EINVAL;
@@ -3267,9 +3263,7 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 		/* disallow things mesh doesn't support */
 		if (params.vlan)
 			return -EINVAL;
-		if (params.ht_capa)
-			return -EINVAL;
-		if (params.listen_interval >= 0)
+		if (params.supported_rates)
 			return -EINVAL;
 		/*
 		 * No special handling for TDLS here -- the userspace
-- 
1.8.0

