Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43171 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158Ab0LAVDQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 16:03:16 -0500
Message-Id: <20101201210226.159495600@sipsolutions.net>
Date: Wed, 01 Dec 2010 21:59:44 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>,
	Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org
Subject: [RFC 5/5] cfg80211/mac80211: add mesh join/leave commands
References: <20101201205939.009530439@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of tying mesh activity to interface up,
add join and leave commands for mesh. Since we
must be backward compatible, let cfg80211 handle
joining a mesh if a mesh ID was pre-configured
when the device goes up.

Note that this therefore must modify mac80211 as
well since mac80211 needs to lose the logic to
start the mesh on interface up.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/nl80211.h    |    7 ++
 include/net/cfg80211.h     |    9 +--
 net/mac80211/cfg.c         |   31 ++++++++--
 net/mac80211/ieee80211_i.h |   13 ----
 net/mac80211/iface.c       |   14 ----
 net/mac80211/mesh.c        |   20 ------
 net/mac80211/mesh.h        |   23 -------
 net/wireless/Makefile      |    2 
 net/wireless/core.c        |   14 ++++
 net/wireless/core.h        |   13 ++++
 net/wireless/mesh.c        |  133 +++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.c     |   84 +++++++++++++++++++++++++---
 12 files changed, 273 insertions(+), 90 deletions(-)

--- wireless-testing.orig/include/linux/nl80211.h	2010-12-01 21:36:33.000000000 +0100
+++ wireless-testing/include/linux/nl80211.h	2010-12-01 21:40:18.000000000 +0100
@@ -394,6 +394,10 @@
  *
  * @NL80211_CMD_SET_WDS_PEER: Set the MAC address of the peer on a WDS interface.
  *
+ * @NL80211_CMD_JOIN_MESH: Join a mesh  ...
+ * @NL80211_CMD_LEAVE_MESH: Leave the mesh network -- no special arguments, the
+ *	network is determined by the network interface.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -500,6 +504,9 @@ enum nl80211_commands {
 
 	NL80211_CMD_FRAME_WAIT_CANCEL,
 
+	NL80211_CMD_JOIN_MESH,
+	NL80211_CMD_LEAVE_MESH,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
--- wireless-testing.orig/include/net/cfg80211.h	2010-12-01 21:36:33.000000000 +0100
+++ wireless-testing/include/net/cfg80211.h	2010-12-01 21:40:18.000000000 +0100
@@ -258,13 +258,9 @@ struct ieee80211_supported_band {
 
 /**
  * struct vif_params - describes virtual interface parameters
- * @mesh_id: mesh ID to use
- * @mesh_id_len: length of the mesh ID
  * @use_4addr: use 4-address frames
  */
 struct vif_params {
-       u8 *mesh_id;
-       int mesh_id_len;
        int use_4addr;
 };
 
@@ -1223,6 +1219,11 @@ struct cfg80211_ops {
 	int	(*set_mesh_params)(struct wiphy *wiphy,
 				struct net_device *dev,
 				const struct mesh_config *nconf, u32 mask);
+	int	(*join_mesh)(struct wiphy *wiphy, struct net_device *dev,
+			     const u8 *mesh_id, size_t mesh_id_len,
+			     const struct mesh_config *conf);
+	int	(*leave_mesh)(struct wiphy *wiphy, struct net_device *dev);
+
 	int	(*change_bss)(struct wiphy *wiphy, struct net_device *dev,
 			      struct bss_parameters *params);
 
--- wireless-testing.orig/net/wireless/Makefile	2010-12-01 21:36:33.000000000 +0100
+++ wireless-testing/net/wireless/Makefile	2010-12-01 21:40:18.000000000 +0100
@@ -10,7 +10,7 @@ obj-$(CONFIG_WEXT_SPY) += wext-spy.o
 obj-$(CONFIG_WEXT_PRIV) += wext-priv.o
 
 cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o scan.o nl80211.o
-cfg80211-y += mlme.o ibss.o sme.o chan.o ethtool.o
+cfg80211-y += mlme.o ibss.o sme.o chan.o ethtool.o mesh.o
 cfg80211-$(CONFIG_CFG80211_DEBUGFS) += debugfs.o
 cfg80211-$(CONFIG_CFG80211_WEXT) += wext-compat.o wext-sme.o
 cfg80211-$(CONFIG_CFG80211_INTERNAL_REGDB) += regdb.o
--- wireless-testing.orig/net/wireless/core.h	2010-12-01 21:36:33.000000000 +0100
+++ wireless-testing/net/wireless/core.h	2010-12-01 21:45:44.000000000 +0100
@@ -285,6 +285,19 @@ void __cfg80211_ibss_joined(struct net_d
 int cfg80211_ibss_wext_join(struct cfg80211_registered_device *rdev,
 			    struct wireless_dev *wdev);
 
+/* mesh */
+extern const struct mesh_config default_mesh_config;
+int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
+			 struct net_device *dev,
+			 const u8 *mesh_id, size_t mesh_id_len,
+			 const struct mesh_config *conf);
+int cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
+		       struct net_device *dev,
+		       const u8 *mesh_id, size_t mesh_id_len,
+		       const struct mesh_config *conf);
+int cfg80211_leave_mesh(struct cfg80211_registered_device *rdev,
+			struct net_device *dev);
+
 /* MLME */
 int __cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
 			 struct net_device *dev,
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-testing/net/wireless/mesh.c	2010-12-01 21:45:49.000000000 +0100
@@ -0,0 +1,133 @@
+#include <linux/ieee80211.h>
+#include <net/cfg80211.h>
+#include "core.h"
+
+/* Default values, timeouts in ms */
+#define MESH_TTL 		31
+#define MESH_MAX_RETR	 	3
+#define MESH_RET_T 		100
+#define MESH_CONF_T 		100
+#define MESH_HOLD_T 		100
+
+#define MESH_PATH_TIMEOUT	5000
+/* Minimum interval between two consecutive PREQs originated by the same
+ * interface
+ */
+#define MESH_PREQ_MIN_INT	10
+#define MESH_DIAM_TRAVERSAL_TIME 50
+/* A path will be refreshed if it is used PATH_REFRESH_TIME milliseconds before
+ * timing out.  This way it will remain ACTIVE and no data frames will be
+ * unnecesarily held in the pending queue.
+ */
+#define MESH_PATH_REFRESH_TIME			1000
+#define MESH_MIN_DISCOVERY_TIMEOUT (2 * MESH_DIAM_TRAVERSAL_TIME)
+
+/* Default maximum number of established plinks per interface */
+#define MESH_MAX_ESTAB_PLINKS	32
+
+#define MESH_MAX_PREQ_RETRIES 4
+
+
+const struct mesh_config default_mesh_config = {
+	.dot11MeshRetryTimeout = MESH_RET_T,
+	.dot11MeshConfirmTimeout = MESH_CONF_T,
+	.dot11MeshHoldingTimeout = MESH_HOLD_T,
+	.dot11MeshMaxRetries = MESH_MAX_RETR,
+	.dot11MeshTTL = MESH_TTL,
+	.auto_open_plinks = true,
+	.dot11MeshMaxPeerLinks = MESH_MAX_ESTAB_PLINKS,
+	.dot11MeshHWMPactivePathTimeout = MESH_PATH_TIMEOUT,
+	.dot11MeshHWMPpreqMinInterval = MESH_PREQ_MIN_INT,
+	.dot11MeshHWMPnetDiameterTraversalTime = MESH_DIAM_TRAVERSAL_TIME,
+	.dot11MeshHWMPmaxPREQretries = MESH_MAX_PREQ_RETRIES,
+	.path_refresh_time = MESH_PATH_REFRESH_TIME,
+	.min_discovery_timeout = MESH_MIN_DISCOVERY_TIMEOUT,
+};
+
+int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
+			 struct net_device *dev,
+			 const u8 *mesh_id, size_t mesh_id_len,
+			 const struct mesh_config *conf)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	int err;
+
+	BUILD_BUG_ON(IEEE80211_MAX_SSID_LEN != IEEE80211_MAX_MESH_ID_LEN);
+
+	ASSERT_WDEV_LOCK(wdev);
+
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT)
+		return -EOPNOTSUPP;
+
+	if (wdev->ssid_len)
+		return -EALREADY;
+
+	if (!mesh_id_len)
+		return -EINVAL;
+
+	if (!rdev->ops->join_mesh)
+		return -EOPNOTSUPP;
+
+	if (!conf)
+		conf = &default_mesh_config;
+
+	err = rdev->ops->join_mesh(&rdev->wiphy, dev, mesh_id, mesh_id_len,
+				   conf);
+	if (!err) {
+		memcpy(wdev->ssid, mesh_id, mesh_id_len);
+		wdev->ssid_len = mesh_id_len;
+	}
+
+	return err;
+}
+
+int cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
+		       struct net_device *dev,
+		       const u8 *mesh_id, size_t mesh_id_len,
+		       const struct mesh_config *conf)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	int err;
+
+	wdev_lock(wdev);
+	err = __cfg80211_join_mesh(rdev, dev, mesh_id, mesh_id_len, conf);
+	wdev_unlock(wdev);
+
+	return err;
+}
+
+static int __cfg80211_leave_mesh(struct cfg80211_registered_device *rdev,
+				 struct net_device *dev)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	int err;
+
+	ASSERT_WDEV_LOCK(wdev);
+
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT)
+		return -EOPNOTSUPP;
+
+	if (!rdev->ops->leave_mesh)
+		return -EOPNOTSUPP;
+
+	if (!wdev->ssid_len)
+		return -ENOTCONN;
+
+	err = rdev->ops->leave_mesh(&rdev->wiphy, dev);
+	if (!err)
+		wdev->ssid_len = 0;
+	return err;
+}
+
+int cfg80211_leave_mesh(struct cfg80211_registered_device *rdev,
+			struct net_device *dev)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	int err;
+
+	wdev_lock(wdev);
+	err = __cfg80211_leave_mesh(rdev, dev);
+	wdev_unlock(wdev);
+
+	return err;
+}
--- wireless-testing.orig/net/wireless/nl80211.c	2010-12-01 21:39:52.000000000 +0100
+++ wireless-testing/net/wireless/nl80211.c	2010-12-01 21:43:32.000000000 +0100
@@ -668,6 +668,7 @@ static int nl80211_send_wiphy(struct sk_
 	CMD(deauth, DEAUTHENTICATE);
 	CMD(disassoc, DISASSOCIATE);
 	CMD(join_ibss, JOIN_IBSS);
+	CMD(join_mesh, JOIN_MESH);
 	CMD(set_pmksa, SET_PMKSA);
 	CMD(del_pmksa, DEL_PMKSA);
 	CMD(flush_pmksa, FLUSH_PMKSA);
@@ -1324,11 +1325,20 @@ static int nl80211_set_interface(struct
 	}
 
 	if (info->attrs[NL80211_ATTR_MESH_ID]) {
+		struct wireless_dev *wdev = dev->ieee80211_ptr;
+
 		if (ntype != NL80211_IFTYPE_MESH_POINT)
 			return -EINVAL;
-		params.mesh_id = nla_data(info->attrs[NL80211_ATTR_MESH_ID]);
-		params.mesh_id_len = nla_len(info->attrs[NL80211_ATTR_MESH_ID]);
-		change = true;
+		if (netif_running(dev))
+			return -EBUSY;
+
+		wdev_lock(wdev);
+		BUILD_BUG_ON(IEEE80211_MAX_SSID_LEN !=
+			     IEEE80211_MAX_MESH_ID_LEN);
+		wdev->ssid_len = nla_len(info->attrs[NL80211_ATTR_MESH_ID]);
+		memcpy(wdev->ssid, nla_data(info->attrs[NL80211_ATTR_MESH_ID]),
+		       wdev->ssid_len);
+		wdev_unlock(wdev);
 	}
 
 	if (info->attrs[NL80211_ATTR_4ADDR]) {
@@ -1388,12 +1398,6 @@ static int nl80211_new_interface(struct
 	    !(rdev->wiphy.interface_modes & (1 << type)))
 		return -EOPNOTSUPP;
 
-	if (type == NL80211_IFTYPE_MESH_POINT &&
-	    info->attrs[NL80211_ATTR_MESH_ID]) {
-		params.mesh_id = nla_data(info->attrs[NL80211_ATTR_MESH_ID]);
-		params.mesh_id_len = nla_len(info->attrs[NL80211_ATTR_MESH_ID]);
-	}
-
 	if (info->attrs[NL80211_ATTR_4ADDR]) {
 		params.use_4addr = !!nla_get_u8(info->attrs[NL80211_ATTR_4ADDR]);
 		err = nl80211_valid_4addr(rdev, NULL, params.use_4addr, type);
@@ -1410,6 +1414,19 @@ static int nl80211_new_interface(struct
 	if (IS_ERR(dev))
 		return PTR_ERR(dev);
 
+	if (type == NL80211_IFTYPE_MESH_POINT &&
+	    info->attrs[NL80211_ATTR_MESH_ID]) {
+		struct wireless_dev *wdev = dev->ieee80211_ptr;
+
+		wdev_lock(wdev);
+		BUILD_BUG_ON(IEEE80211_MAX_SSID_LEN !=
+			     IEEE80211_MAX_MESH_ID_LEN);
+		wdev->ssid_len = nla_len(info->attrs[NL80211_ATTR_MESH_ID]);
+		memcpy(wdev->ssid, nla_data(info->attrs[NL80211_ATTR_MESH_ID]),
+		       wdev->ssid_len);
+		wdev_unlock(wdev);
+	}
+
 	return 0;
 }
 
@@ -4499,6 +4516,39 @@ out:
 	return err;
 }
 
+static int nl80211_join_mesh(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct mesh_config cfg;
+	int err;
+
+	/* start with default */
+	memcpy(&cfg, &default_mesh_config, sizeof(cfg));
+
+	/* and parse other given info */
+	err = nl80211_parse_mesh_params(info, &cfg, NULL);
+	if (err)
+		return err;
+
+	if (!info->attrs[NL80211_ATTR_MESH_ID] ||
+	    !nla_len(info->attrs[NL80211_ATTR_MESH_ID]))
+		return -EINVAL;
+
+	return cfg80211_join_mesh(rdev, dev,
+				  nla_data(info->attrs[NL80211_ATTR_MESH_ID]),
+				  nla_len(info->attrs[NL80211_ATTR_MESH_ID]),
+				  &cfg);
+}
+
+static int nl80211_leave_mesh(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+
+	return cfg80211_leave_mesh(rdev, dev);
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -4981,6 +5031,22 @@ static struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_NETDEV |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_JOIN_MESH,
+		.doit = nl80211_join_mesh,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
+	{
+		.cmd = NL80211_CMD_LEAVE_MESH,
+		.doit = nl80211_leave_mesh,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
--- wireless-testing.orig/net/wireless/core.c	2010-12-01 21:36:33.000000000 +0100
+++ wireless-testing/net/wireless/core.c	2010-12-01 21:45:22.000000000 +0100
@@ -332,6 +332,7 @@ struct wiphy *wiphy_new(const struct cfg
 	WARN_ON(ops->add_virtual_intf && !ops->del_virtual_intf);
 	WARN_ON(ops->add_station && !ops->del_station);
 	WARN_ON(ops->add_mpath && !ops->del_mpath);
+	WARN_ON(ops->join_mesh && !ops->leave_mesh);
 
 	alloc_size = sizeof(*rdev) + sizeof_priv;
 
@@ -752,6 +753,9 @@ static int cfg80211_netdev_notifier_call
 			cfg80211_mlme_down(rdev, dev);
 			wdev_unlock(wdev);
 			break;
+		case NL80211_IFTYPE_MESH_POINT:
+			cfg80211_leave_mesh(rdev, dev);
+			break;
 		default:
 			break;
 		}
@@ -775,20 +779,26 @@ static int cfg80211_netdev_notifier_call
 		}
 		cfg80211_lock_rdev(rdev);
 		mutex_lock(&rdev->devlist_mtx);
-#ifdef CONFIG_CFG80211_WEXT
 		wdev_lock(wdev);
 		switch (wdev->iftype) {
+#ifdef CONFIG_CFG80211_WEXT
 		case NL80211_IFTYPE_ADHOC:
 			cfg80211_ibss_wext_join(rdev, wdev);
 			break;
 		case NL80211_IFTYPE_STATION:
 			cfg80211_mgd_wext_connect(rdev, wdev);
 			break;
+#endif
+		case NL80211_IFTYPE_MESH_POINT:
+			/* backward compat code ... */
+			if (wdev->ssid_len)
+				__cfg80211_join_mesh(rdev, dev, wdev->ssid,
+						     wdev->ssid_len, NULL);
+			break;
 		default:
 			break;
 		}
 		wdev_unlock(wdev);
-#endif
 		rdev->opencount++;
 		mutex_unlock(&rdev->devlist_mtx);
 		cfg80211_unlock_rdev(rdev);
--- wireless-testing.orig/net/mac80211/cfg.c	2010-12-01 21:36:33.000000000 +0100
+++ wireless-testing/net/mac80211/cfg.c	2010-12-01 21:40:18.000000000 +0100
@@ -60,11 +60,6 @@ static int ieee80211_change_iface(struct
 	if (ret)
 		return ret;
 
-	if (ieee80211_vif_is_mesh(&sdata->vif) && params->mesh_id_len)
-		ieee80211_sdata_set_mesh_id(sdata,
-					    params->mesh_id_len,
-					    params->mesh_id);
-
 	if (type == NL80211_IFTYPE_AP_VLAN &&
 	    params && params->use_4addr == 0)
 		rcu_assign_pointer(sdata->u.vlan.sta, NULL);
@@ -1054,6 +1049,30 @@ static int ieee80211_set_mesh_params(str
 	return 0;
 }
 
+static int ieee80211_join_mesh(struct wiphy *wiphy, struct net_device *dev,
+			       const u8 *mesh_id, size_t mesh_id_len,
+			       const struct mesh_config *conf)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+
+	memcpy(&sdata->u.mesh.mshcfg, conf, sizeof(struct mesh_config));
+	ifmsh->mesh_id_len = mesh_id_len;
+	memcpy(ifmsh->mesh_id, mesh_id, mesh_id_len);
+
+	ieee80211_start_mesh(sdata);
+
+	return 0;
+}
+
+static int ieee80211_leave_mesh(struct wiphy *wiphy, struct net_device *dev)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	ieee80211_stop_mesh(sdata);
+
+	return 0;
+}
 #endif
 
 static int ieee80211_change_bss(struct wiphy *wiphy,
@@ -1760,6 +1779,8 @@ struct cfg80211_ops mac80211_config_ops
 	.dump_mpath = ieee80211_dump_mpath,
 	.set_mesh_params = ieee80211_set_mesh_params,
 	.get_mesh_params = ieee80211_get_mesh_params,
+	.join_mesh = ieee80211_join_mesh,
+	.leave_mesh = ieee80211_leave_mesh,
 #endif
 	.change_bss = ieee80211_change_bss,
 	.set_txq_params = ieee80211_set_txq_params,
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-12-01 21:36:33.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-12-01 21:40:18.000000000 +0100
@@ -608,19 +608,6 @@ struct ieee80211_sub_if_data *vif_to_sda
 	return container_of(p, struct ieee80211_sub_if_data, vif);
 }
 
-static inline void
-ieee80211_sdata_set_mesh_id(struct ieee80211_sub_if_data *sdata,
-			    u8 mesh_id_len, u8 *mesh_id)
-{
-#ifdef CONFIG_MAC80211_MESH
-	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
-	ifmsh->mesh_id_len = mesh_id_len;
-	memcpy(ifmsh->mesh_id, mesh_id, mesh_id_len);
-#else
-	WARN_ON(1);
-#endif
-}
-
 enum sdata_queue_type {
 	IEEE80211_SDATA_QUEUE_TYPE_FRAME	= 0,
 	IEEE80211_SDATA_QUEUE_AGG_START		= 1,
--- wireless-testing.orig/net/mac80211/iface.c	2010-12-01 21:36:33.000000000 +0100
+++ wireless-testing/net/mac80211/iface.c	2010-12-01 21:40:18.000000000 +0100
@@ -268,9 +268,7 @@ static int ieee80211_do_open(struct net_
 				goto err_stop;
 		}
 
-		if (ieee80211_vif_is_mesh(&sdata->vif)) {
-			ieee80211_start_mesh(sdata);
-		} else if (sdata->vif.type == NL80211_IFTYPE_AP) {
+		if (sdata->vif.type == NL80211_IFTYPE_AP) {
 			local->fif_pspoll++;
 			local->fif_probe_req++;
 
@@ -495,10 +493,6 @@ static void ieee80211_do_stop(struct iee
 		ieee80211_adjust_monitor_flags(sdata, -1);
 		ieee80211_configure_filter(local);
 		break;
-	case NL80211_IFTYPE_MESH_POINT:
-		if (ieee80211_vif_is_mesh(&sdata->vif))
-			ieee80211_stop_mesh(sdata);
-		/* fall through */
 	default:
 		flush_work(&sdata->work);
 		/*
@@ -1188,12 +1182,6 @@ int ieee80211_if_add(struct ieee80211_lo
 	if (ret)
 		goto fail;
 
-	if (ieee80211_vif_is_mesh(&sdata->vif) &&
-	    params && params->mesh_id_len)
-		ieee80211_sdata_set_mesh_id(sdata,
-					    params->mesh_id_len,
-					    params->mesh_id);
-
 	mutex_lock(&local->iflist_mtx);
 	list_add_tail_rcu(&sdata->list, &local->interfaces);
 	mutex_unlock(&local->iflist_mtx);
--- wireless-testing.orig/net/mac80211/mesh.c	2010-12-01 21:36:33.000000000 +0100
+++ wireless-testing/net/mac80211/mesh.c	2010-12-01 21:40:18.000000000 +0100
@@ -674,26 +674,6 @@ void ieee80211_mesh_init_sdata(struct ie
 		    ieee80211_mesh_housekeeping_timer,
 		    (unsigned long) sdata);
 
-	ifmsh->mshcfg.dot11MeshRetryTimeout = MESH_RET_T;
-	ifmsh->mshcfg.dot11MeshConfirmTimeout = MESH_CONF_T;
-	ifmsh->mshcfg.dot11MeshHoldingTimeout = MESH_HOLD_T;
-	ifmsh->mshcfg.dot11MeshMaxRetries = MESH_MAX_RETR;
-	ifmsh->mshcfg.dot11MeshTTL = MESH_TTL;
-	ifmsh->mshcfg.auto_open_plinks = true;
-	ifmsh->mshcfg.dot11MeshMaxPeerLinks =
-		MESH_MAX_ESTAB_PLINKS;
-	ifmsh->mshcfg.dot11MeshHWMPactivePathTimeout =
-		MESH_PATH_TIMEOUT;
-	ifmsh->mshcfg.dot11MeshHWMPpreqMinInterval =
-		MESH_PREQ_MIN_INT;
-	ifmsh->mshcfg.dot11MeshHWMPnetDiameterTraversalTime =
-		MESH_DIAM_TRAVERSAL_TIME;
-	ifmsh->mshcfg.dot11MeshHWMPmaxPREQretries =
-		MESH_MAX_PREQ_RETRIES;
-	ifmsh->mshcfg.path_refresh_time =
-		MESH_PATH_REFRESH_TIME;
-	ifmsh->mshcfg.min_discovery_timeout =
-		MESH_MIN_DISCOVERY_TIMEOUT;
 	ifmsh->accepting_plinks = true;
 	ifmsh->preq_id = 0;
 	ifmsh->sn = 0;
--- wireless-testing.orig/net/mac80211/mesh.h	2010-12-01 21:36:33.000000000 +0100
+++ wireless-testing/net/mac80211/mesh.h	2010-12-01 21:40:18.000000000 +0100
@@ -175,33 +175,10 @@ struct mesh_rmc {
  */
 #define MESH_CFG_CMP_LEN 	(IEEE80211_MESH_CONFIG_LEN - 2)
 
-/* Default values, timeouts in ms */
-#define MESH_TTL 		31
-#define MESH_MAX_RETR	 	3
-#define MESH_RET_T 		100
-#define MESH_CONF_T 		100
-#define MESH_HOLD_T 		100
-
-#define MESH_PATH_TIMEOUT	5000
-/* Minimum interval between two consecutive PREQs originated by the same
- * interface
- */
-#define MESH_PREQ_MIN_INT	10
-#define MESH_DIAM_TRAVERSAL_TIME 50
-/* A path will be refreshed if it is used PATH_REFRESH_TIME milliseconds before
- * timing out.  This way it will remain ACTIVE and no data frames will be
- * unnecesarily held in the pending queue.
- */
-#define MESH_PATH_REFRESH_TIME			1000
-#define MESH_MIN_DISCOVERY_TIMEOUT (2 * MESH_DIAM_TRAVERSAL_TIME)
 #define MESH_DEFAULT_BEACON_INTERVAL		1000 	/* in 1024 us units */
 
-#define MESH_MAX_PREQ_RETRIES 4
 #define MESH_PATH_EXPIRE (600 * HZ)
 
-/* Default maximum number of established plinks per interface */
-#define MESH_MAX_ESTAB_PLINKS	32
-
 /* Default maximum number of plinks per interface */
 #define MESH_MAX_PLINKS		256
 


