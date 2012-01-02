Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40674 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab2ABMaH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jan 2012 07:30:07 -0500
Subject: [PATCH] nl80211: fix old station flags compatibility
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Thomas Hilber <ath9k-dev@toh.cx>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Jan 2012 13:30:03 +0100
Message-ID: <1325507403.3643.10.camel@jlt3.sipsolutions.net> (sfid-20120102_133100_053035_137C82C3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

My patch to validate station flags broke compatibility
with the old station flags setting where all flags are
always set at once since it always set the mask as all
possible flags which ended up being rejected later in
the station add/modify code.

Fix by parsing only the current flags in the old flags
attribute -- new applications and new flags should use
(and will now require) the new flags attribute where
the mask is given by the application.

Reported-and-tested-by: Thomas Hilber <ath9k-dev@toh.cx>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c |   34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

--- a/net/wireless/nl80211.c	2011-12-20 13:14:08.000000000 +0100
+++ b/net/wireless/nl80211.c	2012-01-02 11:18:43.000000000 +0100
@@ -2250,6 +2250,7 @@ static const struct nla_policy sta_flags
 };
 
 static int parse_station_flags(struct genl_info *info,
+			       enum nl80211_iftype iftype,
 			       struct station_parameters *params)
 {
 	struct nlattr *flags[NL80211_STA_FLAG_MAX + 1];
@@ -2283,8 +2284,33 @@ static int parse_station_flags(struct ge
 			     nla, sta_flags_policy))
 		return -EINVAL;
 
-	params->sta_flags_mask = (1 << __NL80211_STA_FLAG_AFTER_LAST) - 1;
-	params->sta_flags_mask &= ~1;
+	/*
+	 * Only allow certain flags for interface types so that
+	 * other attributes are silently ignored. Remember that
+	 * this is backward compatibility code with old userspace
+	 * and shouldn't be hit in other cases anyway.
+	 */
+	switch (iftype) {
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_AP_VLAN:
+	case NL80211_IFTYPE_P2P_GO:
+		params->sta_flags_mask = BIT(NL80211_STA_FLAG_AUTHORIZED) |
+					 BIT(NL80211_STA_FLAG_SHORT_PREAMBLE) |
+					 BIT(NL80211_STA_FLAG_WME) |
+					 BIT(NL80211_STA_FLAG_MFP);
+		break;
+	case NL80211_IFTYPE_P2P_CLIENT:
+	case NL80211_IFTYPE_STATION:
+		params->sta_flags_mask = BIT(NL80211_STA_FLAG_AUTHORIZED) |
+					 BIT(NL80211_STA_FLAG_TDLS_PEER);
+		break;
+	case NL80211_IFTYPE_MESH_POINT:
+		params->sta_flags_mask = BIT(NL80211_STA_FLAG_AUTHENTICATED) |
+					 BIT(NL80211_STA_FLAG_MFP) |
+					 BIT(NL80211_STA_FLAG_AUTHORIZED);
+	default:
+		return -EINVAL;
+	}
 
 	for (flag = 1; flag <= NL80211_STA_FLAG_MAX; flag++)
 		if (flags[flag])
@@ -2585,7 +2611,7 @@ static int nl80211_set_station(struct sk
 	if (!rdev->ops->change_station)
 		return -EOPNOTSUPP;
 
-	if (parse_station_flags(info, &params))
+	if (parse_station_flags(info, dev->ieee80211_ptr->iftype, &params))
 		return -EINVAL;
 
 	if (info->attrs[NL80211_ATTR_STA_PLINK_ACTION])
@@ -2731,7 +2757,7 @@ static int nl80211_new_station(struct sk
 	if (!rdev->ops->add_station)
 		return -EOPNOTSUPP;
 
-	if (parse_station_flags(info, &params))
+	if (parse_station_flags(info, dev->ieee80211_ptr->iftype, &params))
 		return -EINVAL;
 
 	switch (dev->ieee80211_ptr->iftype) {


