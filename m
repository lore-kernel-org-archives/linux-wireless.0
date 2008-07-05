Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52537 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756310AbYGEXvW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jul 2008 19:51:22 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1KFHXF-0003Jl-DL
	for linux-wireless@vger.kernel.org; Sun, 06 Jul 2008 01:51:21 +0200
Message-Id: <20080705235014.191243000@sipsolutions.net> (sfid-20080706_015142_608755_311966E0)
References: <20080705234735.210585000@sipsolutions.net>
Date: Sun, 06 Jul 2008 01:47:38 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFT 3/4] mac80211: push interface checks down
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch pushes the "netif_running()" and "same type as before"
checks down into ieee80211_if_change_type() to centralise the
logic instead of duplicating it for cfg80211 and wext.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/cfg.c         |    8 ++++----
 net/mac80211/ieee80211_i.h |    4 ++--
 net/mac80211/iface.c       |   20 ++++++++++++++++++--
 net/mac80211/wext.c        |    9 +--------
 4 files changed, 25 insertions(+), 16 deletions(-)

--- everything.orig/net/mac80211/cfg.c	2008-07-05 23:33:16.000000000 +0200
+++ everything/net/mac80211/cfg.c	2008-07-05 23:33:18.000000000 +0200
@@ -84,22 +84,22 @@ static int ieee80211_change_iface(struct
 	struct net_device *dev;
 	enum ieee80211_if_types itype;
 	struct ieee80211_sub_if_data *sdata;
+	int ret;
 
 	/* we're under RTNL */
 	dev = __dev_get_by_index(&init_net, ifindex);
 	if (!dev)
 		return -ENODEV;
 
-	if (netif_running(dev))
-		return -EBUSY;
-
 	itype = nl80211_type_to_mac80211_type(type);
 	if (itype == IEEE80211_IF_TYPE_INVALID)
 		return -EINVAL;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	ieee80211_if_change_type(sdata, itype);
+	ret = ieee80211_if_change_type(sdata, itype);
+	if (ret)
+		return ret;
 
 	if (ieee80211_vif_is_mesh(&sdata->vif) && params->mesh_id_len)
 		ieee80211_if_sta_set_mesh_id(&sdata->u.sta,
--- everything.orig/net/mac80211/ieee80211_i.h	2008-07-05 23:33:16.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-07-05 23:33:18.000000000 +0200
@@ -929,8 +929,8 @@ void ieee80211_if_setup(struct net_devic
 int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 		     struct net_device **new_dev, enum ieee80211_if_types type,
 		     struct vif_params *params);
-void ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
-			      enum ieee80211_if_types type);
+int ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
+			     enum ieee80211_if_types type);
 void ieee80211_if_remove(struct net_device *dev);
 void ieee80211_remove_interfaces(struct ieee80211_local *local);
 
--- everything.orig/net/mac80211/iface.c	2008-07-05 23:33:16.000000000 +0200
+++ everything/net/mac80211/iface.c	2008-07-05 23:33:18.000000000 +0200
@@ -138,9 +138,23 @@ static void ieee80211_setup_sdata(struct
 	ieee80211_debugfs_add_netdev(sdata);
 }
 
-void ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
-			      enum ieee80211_if_types type)
+int ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
+			     enum ieee80211_if_types type)
 {
+	ASSERT_RTNL();
+
+	if (type == sdata->vif.type)
+		return 0;
+
+	/*
+	 * We could, here, on changes between IBSS/STA/MESH modes,
+	 * invoke an MLME function instead that disassociates etc.
+	 * and goes into the requested mode.
+	 */
+
+	if (netif_running(sdata->dev))
+		return -EBUSY;
+
 	/* Purge and reset type-dependent state. */
 	ieee80211_teardown_sdata(sdata->dev);
 	ieee80211_setup_sdata(sdata, type);
@@ -149,6 +163,8 @@ void ieee80211_if_change_type(struct iee
 	sdata->basic_rates = 0;
 	sdata->drop_unencrypted = 0;
 	sdata->sequence = 0;
+
+	return 0;
 }
 
 int ieee80211_if_add(struct ieee80211_local *local, const char *name,
--- everything.orig/net/mac80211/wext.c	2008-07-05 23:33:16.000000000 +0200
+++ everything/net/mac80211/wext.c	2008-07-05 23:33:18.000000000 +0200
@@ -296,14 +296,7 @@ static int ieee80211_ioctl_siwmode(struc
 		return -EINVAL;
 	}
 
-	if (type == sdata->vif.type)
-		return 0;
-	if (netif_running(dev))
-		return -EBUSY;
-
-	ieee80211_if_change_type(sdata, type);
-
-	return 0;
+	return ieee80211_if_change_type(sdata, type);
 }
 
 

-- 

