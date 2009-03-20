Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:50696 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757834AbZCTTYL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2009 15:24:11 -0400
Message-Id: <20090320192402.149900539@atheros.com> (sfid-20090320_202415_437969_7E7FBF52)
References: <20090320192115.448175935@atheros.com>
Date: Fri, 20 Mar 2009 21:21:19 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 4/4] nl80211: Check iftype in cfg80211 code
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We do not want to require all the drivers using cfg80211 to need to do
this. In addition, make the error values consistent by using
EOPNOTSUPP instead of semi-random assortment of errno values.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 net/mac80211/cfg.c     |   40 ----------------------------
 net/wireless/nl80211.c |   68 +++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 66 insertions(+), 42 deletions(-)

--- uml.orig/net/mac80211/cfg.c	2009-03-20 18:03:59.000000000 +0200
+++ uml/net/mac80211/cfg.c	2009-03-20 18:04:01.000000000 +0200
@@ -540,9 +540,6 @@ static int ieee80211_add_beacon(struct w
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (sdata->vif.type != NL80211_IFTYPE_AP)
-		return -EINVAL;
-
 	old = sdata->u.ap.beacon;
 
 	if (old)
@@ -559,9 +556,6 @@ static int ieee80211_set_beacon(struct w
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (sdata->vif.type != NL80211_IFTYPE_AP)
-		return -EINVAL;
-
 	old = sdata->u.ap.beacon;
 
 	if (!old)
@@ -577,9 +571,6 @@ static int ieee80211_del_beacon(struct w
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (sdata->vif.type != NL80211_IFTYPE_AP)
-		return -EINVAL;
-
 	old = sdata->u.ap.beacon;
 
 	if (!old)
@@ -858,9 +849,6 @@ static int ieee80211_add_mpath(struct wi
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (sdata->vif.type != NL80211_IFTYPE_MESH_POINT)
-		return -ENOTSUPP;
-
 	rcu_read_lock();
 	sta = sta_info_get(local, next_hop);
 	if (!sta) {
@@ -908,9 +896,6 @@ static int ieee80211_change_mpath(struct
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (sdata->vif.type != NL80211_IFTYPE_MESH_POINT)
-		return -ENOTSUPP;
-
 	rcu_read_lock();
 
 	sta = sta_info_get(local, next_hop);
@@ -979,9 +964,6 @@ static int ieee80211_get_mpath(struct wi
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (sdata->vif.type != NL80211_IFTYPE_MESH_POINT)
-		return -ENOTSUPP;
-
 	rcu_read_lock();
 	mpath = mesh_path_lookup(dst, sdata);
 	if (!mpath) {
@@ -1003,9 +985,6 @@ static int ieee80211_dump_mpath(struct w
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (sdata->vif.type != NL80211_IFTYPE_MESH_POINT)
-		return -ENOTSUPP;
-
 	rcu_read_lock();
 	mpath = mesh_path_lookup_by_idx(idx, sdata);
 	if (!mpath) {
@@ -1025,8 +1004,6 @@ static int ieee80211_get_mesh_params(str
 	struct ieee80211_sub_if_data *sdata;
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (sdata->vif.type != NL80211_IFTYPE_MESH_POINT)
-		return -ENOTSUPP;
 	memcpy(conf, &(sdata->u.mesh.mshcfg), sizeof(struct mesh_config));
 	return 0;
 }
@@ -1044,9 +1021,6 @@ static int ieee80211_set_mesh_params(str
 	struct ieee80211_sub_if_data *sdata;
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (sdata->vif.type != NL80211_IFTYPE_MESH_POINT)
-		return -ENOTSUPP;
-
 	/* Set the config options which we are interested in setting */
 	conf = &(sdata->u.mesh.mshcfg);
 	if (_chg_mesh_attr(NL80211_MESHCONF_RETRY_TIMEOUT, mask))
@@ -1094,9 +1068,6 @@ static int ieee80211_change_bss(struct w
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (sdata->vif.type != NL80211_IFTYPE_AP)
-		return -EINVAL;
-
 	if (params->use_cts_prot >= 0) {
 		sdata->vif.bss_conf.use_cts_prot = params->use_cts_prot;
 		changed |= BSS_CHANGED_ERP_CTS_PROT;
@@ -1209,9 +1180,6 @@ static int ieee80211_auth(struct wiphy *
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (sdata->vif.type != NL80211_IFTYPE_STATION)
-		return -EOPNOTSUPP;
-
 	switch (req->auth_type) {
 	case NL80211_AUTHTYPE_OPEN_SYSTEM:
 		sdata->u.mgd.auth_algs = IEEE80211_AUTH_ALG_OPEN;
@@ -1268,9 +1236,6 @@ static int ieee80211_assoc(struct wiphy 
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (sdata->vif.type != NL80211_IFTYPE_STATION)
-		return -EOPNOTSUPP;
-
 	if (memcmp(sdata->u.mgd.bssid, req->peer_addr, ETH_ALEN) != 0 ||
 	    !(sdata->u.mgd.flags & IEEE80211_STA_AUTHENTICATED))
 		return -ENOLINK; /* not authenticated */
@@ -1305,8 +1270,6 @@ static int ieee80211_deauth(struct wiphy
 	struct ieee80211_sub_if_data *sdata;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	if (sdata->vif.type != NL80211_IFTYPE_STATION)
-		return -EOPNOTSUPP;
 
 	/* TODO: req->ie */
 	return ieee80211_sta_deauthenticate(sdata, req->reason_code);
@@ -1319,9 +1282,6 @@ static int ieee80211_disassoc(struct wip
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (sdata->vif.type != NL80211_IFTYPE_STATION)
-		return -EOPNOTSUPP;
-
 	/* TODO: req->ie */
 	return ieee80211_sta_disassociate(sdata, req->reason_code);
 }
--- uml.orig/net/wireless/nl80211.c	2009-03-20 18:03:59.000000000 +0200
+++ uml/net/wireless/nl80211.c	2009-03-20 21:16:18.000000000 +0200
@@ -1049,6 +1049,11 @@ static int nl80211_addset_beacon(struct 
 	if (err)
 		goto unlock_rtnl;
 
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
 	switch (info->genlhdr->cmd) {
 	case NL80211_CMD_NEW_BEACON:
 		/* these are required for NEW_BEACON */
@@ -1136,6 +1141,10 @@ static int nl80211_del_beacon(struct sk_
 		goto out;
 	}
 
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
 	err = drv->ops->del_beacon(&drv->wiphy, dev);
 
  out:
@@ -1324,7 +1333,7 @@ static int nl80211_dump_station(struct s
 	}
 
 	if (!dev->ops->dump_station) {
-		err = -ENOSYS;
+		err = -EOPNOTSUPP;
 		goto out_err;
 	}
 
@@ -1698,10 +1707,15 @@ static int nl80211_dump_mpath(struct sk_
 	}
 
 	if (!dev->ops->dump_mpath) {
-		err = -ENOSYS;
+		err = -EOPNOTSUPP;
 		goto out_err;
 	}
 
+	if (netdev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
 	while (1) {
 		err = dev->ops->dump_mpath(&dev->wiphy, netdev, path_idx,
 					   dst, next_hop, &pinfo);
@@ -1759,6 +1773,11 @@ static int nl80211_get_mpath(struct sk_b
 		goto out;
 	}
 
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
 	err = drv->ops->get_mpath(&drv->wiphy, dev, dst, next_hop, &pinfo);
 	if (err)
 		goto out;
@@ -1813,6 +1832,11 @@ static int nl80211_set_mpath(struct sk_b
 		goto out;
 	}
 
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
 	if (!netif_running(dev)) {
 		err = -ENETDOWN;
 		goto out;
@@ -1856,6 +1880,11 @@ static int nl80211_new_mpath(struct sk_b
 		goto out;
 	}
 
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
 	if (!netif_running(dev)) {
 		err = -ENETDOWN;
 		goto out;
@@ -1944,6 +1973,11 @@ static int nl80211_set_bss(struct sk_buf
 		goto out;
 	}
 
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
 	err = drv->ops->change_bss(&drv->wiphy, dev, &params);
 
  out:
@@ -2058,6 +2092,11 @@ static int nl80211_get_mesh_params(struc
 		goto out;
 	}
 
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
 	/* Get the mesh params */
 	err = drv->ops->get_mesh_params(&drv->wiphy, dev, &cur_params);
 	if (err)
@@ -2175,6 +2214,11 @@ static int nl80211_set_mesh_params(struc
 		goto out;
 	}
 
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
 	/* This makes sure that there aren't more than 32 mesh config
 	 * parameters (otherwise our bitfield scheme would not work.) */
 	BUILD_BUG_ON(NL80211_MESHCONF_ATTR_MAX > 32);
@@ -2661,6 +2705,11 @@ static int nl80211_authenticate(struct s
 		goto out;
 	}
 
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
 	if (!netif_running(dev)) {
 		err = -ENETDOWN;
 		goto out;
@@ -2734,6 +2783,11 @@ static int nl80211_associate(struct sk_b
 		goto out;
 	}
 
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
 	if (!netif_running(dev)) {
 		err = -ENETDOWN;
 		goto out;
@@ -2797,6 +2851,11 @@ static int nl80211_deauthenticate(struct
 		goto out;
 	}
 
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
 	if (!netif_running(dev)) {
 		err = -ENETDOWN;
 		goto out;
@@ -2856,6 +2915,11 @@ static int nl80211_disassociate(struct s
 		goto out;
 	}
 
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
 	if (!netif_running(dev)) {
 		err = -ENETDOWN;
 		goto out;

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
