Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:55796 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbbJWIUL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 04:20:11 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Ayala Beker <ayala.beker@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] cfg80211: Enable update of properties for unassociated station.
Date: Fri, 23 Oct 2015 11:20:06 +0300
Message-Id: <1445588406-13416-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151023_102017_579048_9C73073E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ayala Beker <ayala.beker@intel.com>

Currently, cfg80211 rejects updates of AID and listen interval parameters
for existing entries. This information is known only at association stage,
and as a result it's impossible to update entries that were added
unassociated.
Fix this by allowing updates of these properies for stations that the
driver (or mac80211) assigned unassociated state.

Signed-off-by: Ayala Beker <ayala.beker@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/wireless/nl80211.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 205b659..aebb724 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3968,10 +3968,13 @@ int cfg80211_check_station_change(struct wiphy *wiphy,
 				  struct station_parameters *params,
 				  enum cfg80211_station_type statype)
 {
-	if (params->listen_interval != -1)
+	if (params->listen_interval != -1 &&
+	    statype != CFG80211_STA_AP_CLIENT_UNASSOC)
 		return -EINVAL;
+
 	if (params->aid &&
-	    !(params->sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER)))
+	    !(params->sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER)) &&
+	    statype != CFG80211_STA_AP_CLIENT_UNASSOC)
 		return -EINVAL;
 
 	/* When you run into this, adjust the code below for the new flag */
@@ -4245,13 +4248,22 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 
 	memset(&params, 0, sizeof(params));
 
-	params.listen_interval = -1;
-
 	if (!rdev->ops->change_station)
 		return -EOPNOTSUPP;
 
-	if (info->attrs[NL80211_ATTR_STA_AID])
-		return -EINVAL;
+	/*
+	 * AID and listen_interval properties can be set only for unassociated
+	 * station. Include these parameters here and will check them in
+	 * cfg80211_check_station_change().
+	 */
+	if (info->attrs[NL80211_ATTR_PEER_AID])
+		params.aid = nla_get_u16(info->attrs[NL80211_ATTR_PEER_AID]);
+
+	if (info->attrs[NL80211_ATTR_STA_LISTEN_INTERVAL])
+		params.listen_interval =
+		     nla_get_u16(info->attrs[NL80211_ATTR_STA_LISTEN_INTERVAL]);
+	else
+		params.listen_interval = -1;
 
 	if (!info->attrs[NL80211_ATTR_MAC])
 		return -EINVAL;
@@ -4278,9 +4290,6 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 			nla_len(info->attrs[NL80211_ATTR_STA_EXT_CAPABILITY]);
 	}
 
-	if (info->attrs[NL80211_ATTR_STA_LISTEN_INTERVAL])
-		return -EINVAL;
-
 	if (parse_station_flags(info, dev->ieee80211_ptr->iftype, &params))
 		return -EINVAL;
 
-- 
2.1.4

