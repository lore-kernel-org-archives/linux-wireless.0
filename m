Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:50691 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757659AbZCTTYG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2009 15:24:06 -0400
Message-Id: <20090320192357.566055522@atheros.com> (sfid-20090320_202414_776400_81FE83C9)
References: <20090320192115.448175935@atheros.com>
Date: Fri, 20 Mar 2009 21:21:18 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 3/4] nl80211: Check that netif_runnin is true in cfg80211 code
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We do not want to require all the drivers using cfg80211 to need to do
this or to be prepared to handle these commands when the interface is
down.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 net/mac80211/cfg.c     |   25 -------------------------
 net/wireless/nl80211.c |   40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 25 deletions(-)

--- uml.orig/net/mac80211/cfg.c	2009-03-20 18:03:53.000000000 +0200
+++ uml/net/mac80211/cfg.c	2009-03-20 18:03:59.000000000 +0200
@@ -728,10 +728,6 @@ static int ieee80211_add_station(struct 
 	int err;
 	int layer2_update;
 
-	/* Prevent a race with changing the rate control algorithm */
-	if (!netif_running(dev))
-		return -ENETDOWN;
-
 	if (params->vlan) {
 		sdata = IEEE80211_DEV_TO_SUB_IF(params->vlan);
 
@@ -860,9 +856,6 @@ static int ieee80211_add_mpath(struct wi
 	struct sta_info *sta;
 	int err;
 
-	if (!netif_running(dev))
-		return -ENETDOWN;
-
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	if (sdata->vif.type != NL80211_IFTYPE_MESH_POINT)
@@ -913,9 +906,6 @@ static int ieee80211_change_mpath(struct
 	struct mesh_path *mpath;
 	struct sta_info *sta;
 
-	if (!netif_running(dev))
-		return -ENETDOWN;
-
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	if (sdata->vif.type != NL80211_IFTYPE_MESH_POINT)
@@ -1202,9 +1192,6 @@ static int ieee80211_scan(struct wiphy *
 {
 	struct ieee80211_sub_if_data *sdata;
 
-	if (!netif_running(dev))
-		return -ENETDOWN;
-
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	if (sdata->vif.type != NL80211_IFTYPE_STATION &&
@@ -1220,9 +1207,6 @@ static int ieee80211_auth(struct wiphy *
 {
 	struct ieee80211_sub_if_data *sdata;
 
-	if (!netif_running(dev))
-		return -ENETDOWN;
-
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	if (sdata->vif.type != NL80211_IFTYPE_STATION)
@@ -1282,9 +1266,6 @@ static int ieee80211_assoc(struct wiphy 
 	struct ieee80211_sub_if_data *sdata;
 	int ret;
 
-	if (!netif_running(dev))
-		return -ENETDOWN;
-
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	if (sdata->vif.type != NL80211_IFTYPE_STATION)
@@ -1323,9 +1304,6 @@ static int ieee80211_deauth(struct wiphy
 {
 	struct ieee80211_sub_if_data *sdata;
 
-	if (!netif_running(dev))
-		return -ENETDOWN;
-
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	if (sdata->vif.type != NL80211_IFTYPE_STATION)
 		return -EOPNOTSUPP;
@@ -1339,9 +1317,6 @@ static int ieee80211_disassoc(struct wip
 {
 	struct ieee80211_sub_if_data *sdata;
 
-	if (!netif_running(dev))
-		return -ENETDOWN;
-
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	if (sdata->vif.type != NL80211_IFTYPE_STATION)
--- uml.orig/net/wireless/nl80211.c	2009-03-20 18:03:57.000000000 +0200
+++ uml/net/wireless/nl80211.c	2009-03-20 18:03:59.000000000 +0200
@@ -1556,6 +1556,11 @@ static int nl80211_new_station(struct sk
 		goto out;
 	}
 
+	if (!netif_running(dev)) {
+		err = -ENETDOWN;
+		goto out;
+	}
+
 	err = drv->ops->add_station(&drv->wiphy, dev, mac_addr, &params);
 
  out:
@@ -1808,6 +1813,11 @@ static int nl80211_set_mpath(struct sk_b
 		goto out;
 	}
 
+	if (!netif_running(dev)) {
+		err = -ENETDOWN;
+		goto out;
+	}
+
 	err = drv->ops->change_mpath(&drv->wiphy, dev, dst, next_hop);
 
  out:
@@ -1846,6 +1856,11 @@ static int nl80211_new_mpath(struct sk_b
 		goto out;
 	}
 
+	if (!netif_running(dev)) {
+		err = -ENETDOWN;
+		goto out;
+	}
+
 	err = drv->ops->add_mpath(&drv->wiphy, dev, dst, next_hop);
 
  out:
@@ -2380,6 +2395,11 @@ static int nl80211_trigger_scan(struct s
 		goto out;
 	}
 
+	if (!netif_running(dev)) {
+		err = -ENETDOWN;
+		goto out;
+	}
+
 	if (drv->scan_req) {
 		err = -EBUSY;
 		goto out;
@@ -2641,6 +2661,11 @@ static int nl80211_authenticate(struct s
 		goto out;
 	}
 
+	if (!netif_running(dev)) {
+		err = -ENETDOWN;
+		goto out;
+	}
+
 	if (!info->attrs[NL80211_ATTR_MAC]) {
 		err = -EINVAL;
 		goto out;
@@ -2709,6 +2734,11 @@ static int nl80211_associate(struct sk_b
 		goto out;
 	}
 
+	if (!netif_running(dev)) {
+		err = -ENETDOWN;
+		goto out;
+	}
+
 	if (!info->attrs[NL80211_ATTR_MAC] ||
 	    !info->attrs[NL80211_ATTR_SSID]) {
 		err = -EINVAL;
@@ -2767,6 +2797,11 @@ static int nl80211_deauthenticate(struct
 		goto out;
 	}
 
+	if (!netif_running(dev)) {
+		err = -ENETDOWN;
+		goto out;
+	}
+
 	if (!info->attrs[NL80211_ATTR_MAC]) {
 		err = -EINVAL;
 		goto out;
@@ -2821,6 +2856,11 @@ static int nl80211_disassociate(struct s
 		goto out;
 	}
 
+	if (!netif_running(dev)) {
+		err = -ENETDOWN;
+		goto out;
+	}
+
 	if (!info->attrs[NL80211_ATTR_MAC]) {
 		err = -EINVAL;
 		goto out;

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
