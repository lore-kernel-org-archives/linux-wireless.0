Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42913 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012AbYBWOWM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Feb 2008 09:22:12 -0500
Message-Id: <20080223142016.559382000@sipsolutions.net> (sfid-20080223_142217_660205_43F5BDBC)
References: <20080223141703.194775000@sipsolutions.net>
Date: Sat, 23 Feb 2008 15:17:18 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Luis Carlos Cobo <luisca@cozybit.com>
Subject: [PATCH 15/18] mac80211: complete the mesh (interface handling) code
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis Carlos Cobo <luisca@cozybit.com>

This completes the mesh interface handling code and a few other
bits about the mac80211 module.

Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211.c |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

--- everything.orig/net/mac80211/ieee80211.c	2008-02-23 14:53:02.000000000 +0100
+++ everything/net/mac80211/ieee80211.c	2008-02-23 14:53:32.000000000 +0100
@@ -26,6 +26,9 @@
 
 #include "ieee80211_i.h"
 #include "ieee80211_rate.h"
+#ifdef CONFIG_MAC80211_MESH
+#include "mesh.h"
+#endif
 #include "wep.h"
 #include "wme.h"
 #include "aes_ccm.h"
@@ -138,9 +141,15 @@ static void ieee80211_master_set_multica
 
 static int ieee80211_change_mtu(struct net_device *dev, int new_mtu)
 {
+	int meshhdrlen;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	meshhdrlen = (sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT) ? 5 : 0;
+
 	/* FIX: what would be proper limits for MTU?
 	 * This interface uses 802.3 frames. */
-	if (new_mtu < 256 || new_mtu > IEEE80211_MAX_DATA_LEN - 24 - 6) {
+	if (new_mtu < 256 ||
+		new_mtu > IEEE80211_MAX_DATA_LEN - 24 - 6 - meshhdrlen) {
 		printk(KERN_WARNING "%s: invalid MTU %d\n",
 		       dev->name, new_mtu);
 		return -EINVAL;
@@ -441,6 +450,9 @@ static int ieee80211_stop(struct net_dev
 		ieee80211_configure_filter(local);
 		netif_tx_unlock_bh(local->mdev);
 		break;
+	case IEEE80211_IF_TYPE_MESH_POINT:
+		sta_info_flush(local, dev);
+		/* fall through */
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS:
 		sdata->u.sta.state = IEEE80211_DISABLED;
@@ -926,6 +938,11 @@ static int __ieee80211_if_config(struct 
 		conf.bssid = sdata->u.sta.bssid;
 		conf.ssid = sdata->u.sta.ssid;
 		conf.ssid_len = sdata->u.sta.ssid_len;
+#ifdef CONFIG_MAC80211_MESH
+	} else if (sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT) {
+		conf.beacon = beacon;
+		ieee80211_start_mesh(dev);
+#endif
 	} else if (sdata->vif.type == IEEE80211_IF_TYPE_AP) {
 		conf.ssid = sdata->u.ap.ssid;
 		conf.ssid_len = sdata->u.ap.ssid_len;
@@ -938,6 +955,11 @@ static int __ieee80211_if_config(struct 
 
 int ieee80211_if_config(struct net_device *dev)
 {
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	if (sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT &&
+	    (local->hw.flags & IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE))
+		return ieee80211_if_config_beacon(dev);
 	return __ieee80211_if_config(dev, NULL, NULL);
 }
 
@@ -1802,6 +1824,10 @@ static void __exit ieee80211_exit(void)
 	rc80211_simple_exit();
 	rc80211_pid_exit();
 
+#ifdef CONFIG_MAC80211_MESH
+	if (mesh_allocated)
+		ieee80211s_stop();
+#endif
 	ieee80211_wme_unregister();
 	ieee80211_debugfs_netdev_exit();
 }

-- 

