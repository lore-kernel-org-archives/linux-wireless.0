Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39290 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbZFRPYP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 11:24:15 -0400
Subject: [PATCH 2.6.31] cfg80211: validate station settings
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 18 Jun 2009 17:23:43 +0200
Message-Id: <1245338623.13790.81.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When I disallowed interfering with stations on non-AP interfaces,
I not only forget mesh but also managed interfaces which need
this for the authorized flag. Let's actually validate everything
properly.

This fixes an nl80211 regression introduced by the interfering,
under which wpa_supplicant -Dnl80211 could not properly connect.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/nl80211.c |   94 ++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 78 insertions(+), 16 deletions(-)

--- wireless-testing.orig/net/wireless/nl80211.c	2009-06-18 17:21:46.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-06-18 17:22:38.000000000 +0200
@@ -1685,14 +1685,52 @@ static int nl80211_set_station(struct sk
 	if (err)
 		goto out_rtnl;
 
-	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
-	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP_VLAN &&
-	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT) {
-		err = -EINVAL;
+	err = get_vlan(info->attrs[NL80211_ATTR_STA_VLAN], drv, &params.vlan);
+	if (err)
 		goto out;
+
+	/* validate settings */
+	err = 0;
+
+	switch (dev->ieee80211_ptr->iftype) {
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_AP_VLAN:
+		/* disallow mesh-specific things */
+		if (params.plink_action)
+			err = -EINVAL;
+		break;
+	case NL80211_IFTYPE_STATION:
+		/* disallow everything but AUTHORIZED flag */
+		if (params.plink_action)
+			err = -EINVAL;
+		if (params.vlan)
+			err = -EINVAL;
+		if (params.supported_rates)
+			err = -EINVAL;
+		if (params.ht_capa)
+			err = -EINVAL;
+		if (params.listen_interval >= 0)
+			err = -EINVAL;
+		if (params.sta_flags_mask & ~BIT(NL80211_STA_FLAG_AUTHORIZED))
+			err = -EINVAL;
+		break;
+	case NL80211_IFTYPE_MESH_POINT:
+		/* disallow things mesh doesn't support */
+		if (params.vlan)
+			err = -EINVAL;
+		if (params.ht_capa)
+			err = -EINVAL;
+		if (params.listen_interval >= 0)
+			err = -EINVAL;
+		if (params.supported_rates)
+			err = -EINVAL;
+		if (params.sta_flags_mask)
+			err = -EINVAL;
+		break;
+	default:
+		err = -EINVAL;
 	}
 
-	err = get_vlan(info->attrs[NL80211_ATTR_STA_VLAN], drv, &params.vlan);
 	if (err)
 		goto out;
 
@@ -1727,9 +1765,6 @@ static int nl80211_new_station(struct sk
 	if (!info->attrs[NL80211_ATTR_MAC])
 		return -EINVAL;
 
-	if (!info->attrs[NL80211_ATTR_STA_AID])
-		return -EINVAL;
-
 	if (!info->attrs[NL80211_ATTR_STA_LISTEN_INTERVAL])
 		return -EINVAL;
 
@@ -1744,9 +1779,11 @@ static int nl80211_new_station(struct sk
 	params.listen_interval =
 		nla_get_u16(info->attrs[NL80211_ATTR_STA_LISTEN_INTERVAL]);
 
-	params.aid = nla_get_u16(info->attrs[NL80211_ATTR_STA_AID]);
-	if (!params.aid || params.aid > IEEE80211_MAX_AID)
-		return -EINVAL;
+	if (info->attrs[NL80211_ATTR_STA_AID]) {
+		params.aid = nla_get_u16(info->attrs[NL80211_ATTR_STA_AID]);
+		if (!params.aid || params.aid > IEEE80211_MAX_AID)
+			return -EINVAL;
+	}
 
 	if (info->attrs[NL80211_ATTR_HT_CAPABILITY])
 		params.ht_capa =
@@ -1761,14 +1798,39 @@ static int nl80211_new_station(struct sk
 	if (err)
 		goto out_rtnl;
 
-	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
-	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP_VLAN &&
-	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT) {
-		err = -EINVAL;
+	err = get_vlan(info->attrs[NL80211_ATTR_STA_VLAN], drv, &params.vlan);
+	if (err)
 		goto out;
+
+	/* validate settings */
+	err = 0;
+
+	switch (dev->ieee80211_ptr->iftype) {
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_AP_VLAN:
+		/* all ok but must have AID */
+		if (!params.aid)
+			err = -EINVAL;
+		break;
+	case NL80211_IFTYPE_MESH_POINT:
+		/* disallow things mesh doesn't support */
+		if (params.vlan)
+			err = -EINVAL;
+		if (params.aid)
+			err = -EINVAL;
+		if (params.ht_capa)
+			err = -EINVAL;
+		if (params.listen_interval >= 0)
+			err = -EINVAL;
+		if (params.supported_rates)
+			err = -EINVAL;
+		if (params.sta_flags_mask)
+			err = -EINVAL;
+		break;
+	default:
+		err = -EINVAL;
 	}
 
-	err = get_vlan(info->attrs[NL80211_ATTR_STA_VLAN], drv, &params.vlan);
 	if (err)
 		goto out;
 


