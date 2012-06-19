Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52378 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab2FSOvU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 10:51:20 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 11/17] cfg80211: use wireless_dev for interface management
Date: Tue, 19 Jun 2012 16:50:50 +0200
Message-Id: <1340117456-10154-12-git-send-email-johannes@sipsolutions.net> (sfid-20120619_165145_132436_AD0C6474)
In-Reply-To: <1340117456-10154-1-git-send-email-johannes@sipsolutions.net>
References: <1340117456-10154-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In order to be able to create P2P Device wdevs, move
the virtual interface management over to wireless_dev
structures.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   30 ++++++++++++++--------------
 drivers/net/wireless/ath/ath6kl/cfg80211.h |    6 +++---
 drivers/net/wireless/ath/ath6kl/core.c     |    8 ++++----
 drivers/net/wireless/mwifiex/cfg80211.c    |   24 +++++++++++-----------
 drivers/net/wireless/mwifiex/main.c        |    4 ++--
 drivers/net/wireless/mwifiex/main.h        |   10 ++++++----
 include/net/cfg80211.h                     |   19 +++++++++---------
 net/mac80211/cfg.c                         |   20 +++++++++----------
 net/mac80211/ieee80211_i.h                 |    2 +-
 net/mac80211/iface.c                       |    6 +++---
 net/wireless/nl80211.c                     |   16 +++++++--------
 11 files changed, 73 insertions(+), 72 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index cb8b06d..404e87c 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1429,14 +1429,14 @@ static int ath6kl_cfg80211_set_power_mgmt(struct wiphy *wiphy,
 	return 0;
 }
 
-static struct net_device *ath6kl_cfg80211_add_iface(struct wiphy *wiphy,
-						    char *name,
-						    enum nl80211_iftype type,
-						    u32 *flags,
-						    struct vif_params *params)
+static struct wireless_dev *ath6kl_cfg80211_add_iface(struct wiphy *wiphy,
+						      char *name,
+						      enum nl80211_iftype type,
+						      u32 *flags,
+						      struct vif_params *params)
 {
 	struct ath6kl *ar = wiphy_priv(wiphy);
-	struct net_device *ndev;
+	struct wireless_dev *wdev;
 	u8 if_idx, nw_type;
 
 	if (ar->num_vif == ar->vif_max) {
@@ -1449,20 +1449,20 @@ static struct net_device *ath6kl_cfg80211_add_iface(struct wiphy *wiphy,
 		return ERR_PTR(-EINVAL);
 	}
 
-	ndev = ath6kl_interface_add(ar, name, type, if_idx, nw_type);
-	if (!ndev)
+	wdev = ath6kl_interface_add(ar, name, type, if_idx, nw_type);
+	if (!wdev)
 		return ERR_PTR(-ENOMEM);
 
 	ar->num_vif++;
 
-	return ndev;
+	return wdev;
 }
 
 static int ath6kl_cfg80211_del_iface(struct wiphy *wiphy,
-				     struct net_device *ndev)
+				     struct wireless_dev *wdev)
 {
 	struct ath6kl *ar = wiphy_priv(wiphy);
-	struct ath6kl_vif *vif = netdev_priv(ndev);
+	struct ath6kl_vif *vif = netdev_priv(wdev->netdev);
 
 	spin_lock_bh(&ar->list_lock);
 	list_del(&vif->list);
@@ -3355,9 +3355,9 @@ void ath6kl_cfg80211_vif_cleanup(struct ath6kl_vif *vif)
 	ar->num_vif--;
 }
 
-struct net_device *ath6kl_interface_add(struct ath6kl *ar, char *name,
-					enum nl80211_iftype type, u8 fw_vif_idx,
-					u8 nw_type)
+struct wireless_dev *ath6kl_interface_add(struct ath6kl *ar, char *name,
+					  enum nl80211_iftype type,
+					  u8 fw_vif_idx, u8 nw_type)
 {
 	struct net_device *ndev;
 	struct ath6kl_vif *vif;
@@ -3410,7 +3410,7 @@ struct net_device *ath6kl_interface_add(struct ath6kl *ar, char *name,
 	list_add_tail(&vif->list, &ar->vif_list);
 	spin_unlock_bh(&ar->list_lock);
 
-	return ndev;
+	return &vif->wdev;
 
 err:
 	aggr_module_destroy(vif->aggr_cntxt);
diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.h b/drivers/net/wireless/ath/ath6kl/cfg80211.h
index 5ea8cbb..88d1b35 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.h
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.h
@@ -25,9 +25,9 @@ enum ath6kl_cfg_suspend_mode {
 	ATH6KL_CFG_SUSPEND_SCHED_SCAN,
 };
 
-struct net_device *ath6kl_interface_add(struct ath6kl *ar, char *name,
-					enum nl80211_iftype type,
-					u8 fw_vif_idx, u8 nw_type);
+struct wireless_dev *ath6kl_interface_add(struct ath6kl *ar, char *name,
+					  enum nl80211_iftype type,
+					  u8 fw_vif_idx, u8 nw_type);
 void ath6kl_cfg80211_ch_switch_notify(struct ath6kl_vif *vif, int freq,
 				      enum wmi_phy_mode mode);
 void ath6kl_cfg80211_scan_complete_event(struct ath6kl_vif *vif, bool aborted);
diff --git a/drivers/net/wireless/ath/ath6kl/core.c b/drivers/net/wireless/ath/ath6kl/core.c
index fdb3b1d..82c4dd2 100644
--- a/drivers/net/wireless/ath/ath6kl/core.c
+++ b/drivers/net/wireless/ath/ath6kl/core.c
@@ -56,7 +56,7 @@ EXPORT_SYMBOL(ath6kl_core_rx_complete);
 int ath6kl_core_init(struct ath6kl *ar, enum ath6kl_htc_type htc_type)
 {
 	struct ath6kl_bmi_target_info targ_info;
-	struct net_device *ndev;
+	struct wireless_dev *wdev;
 	int ret = 0, i;
 
 	switch (htc_type) {
@@ -187,12 +187,12 @@ int ath6kl_core_init(struct ath6kl *ar, enum ath6kl_htc_type htc_type)
 	rtnl_lock();
 
 	/* Add an initial station interface */
-	ndev = ath6kl_interface_add(ar, "wlan%d", NL80211_IFTYPE_STATION, 0,
+	wdev = ath6kl_interface_add(ar, "wlan%d", NL80211_IFTYPE_STATION, 0,
 				    INFRA_NETWORK);
 
 	rtnl_unlock();
 
-	if (!ndev) {
+	if (!wdev) {
 		ath6kl_err("Failed to instantiate a network device\n");
 		ret = -ENOMEM;
 		wiphy_unregister(ar->wiphy);
@@ -200,7 +200,7 @@ int ath6kl_core_init(struct ath6kl *ar, enum ath6kl_htc_type htc_type)
 	}
 
 	ath6kl_dbg(ATH6KL_DBG_TRC, "%s: name=%s dev=0x%p, ar=0x%p\n",
-		   __func__, ndev->name, ndev, ar);
+		   __func__, wdev->netdev->name, wdev->netdev, ar);
 
 	return ret;
 
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 015fec3..ecf68ab 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1471,11 +1471,11 @@ mwifiex_setup_ht_caps(struct ieee80211_sta_ht_cap *ht_info,
 /*
  *  create a new virtual interface with the given name
  */
-struct net_device *mwifiex_add_virtual_intf(struct wiphy *wiphy,
-					    char *name,
-					    enum nl80211_iftype type,
-					    u32 *flags,
-					    struct vif_params *params)
+struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
+					      char *name,
+					      enum nl80211_iftype type,
+					      u32 *flags,
+					      struct vif_params *params)
 {
 	struct mwifiex_adapter *adapter = mwifiex_cfg80211_get_adapter(wiphy);
 	struct mwifiex_private *priv;
@@ -1593,7 +1593,7 @@ struct net_device *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 #ifdef CONFIG_DEBUG_FS
 	mwifiex_dev_debugfs_init(priv);
 #endif
-	return dev;
+	return wdev;
 error:
 	if (dev && (dev->reg_state == NETREG_UNREGISTERED))
 		free_netdev(dev);
@@ -1606,9 +1606,9 @@ EXPORT_SYMBOL_GPL(mwifiex_add_virtual_intf);
 /*
  * del_virtual_intf: remove the virtual interface determined by dev
  */
-int mwifiex_del_virtual_intf(struct wiphy *wiphy, struct net_device *dev)
+int mwifiex_del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
 {
-	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(wdev->netdev);
 
 #ifdef CONFIG_DEBUG_FS
 	mwifiex_dev_debugfs_remove(priv);
@@ -1620,11 +1620,11 @@ int mwifiex_del_virtual_intf(struct wiphy *wiphy, struct net_device *dev)
 	if (netif_carrier_ok(priv->netdev))
 		netif_carrier_off(priv->netdev);
 
-	if (dev->reg_state == NETREG_REGISTERED)
-		unregister_netdevice(dev);
+	if (wdev->netdev->reg_state == NETREG_REGISTERED)
+		unregister_netdevice(wdev->netdev);
 
-	if (dev->reg_state == NETREG_UNREGISTERED)
-		free_netdev(dev);
+	if (wdev->netdev->reg_state == NETREG_UNREGISTERED)
+		free_netdev(wdev->netdev);
 
 	/* Clear the priv in adapter */
 	priv->netdev = NULL;
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 3192855..42bd73a 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -376,7 +376,7 @@ static void mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 	goto done;
 
 err_add_intf:
-	mwifiex_del_virtual_intf(adapter->wiphy, priv->netdev);
+	mwifiex_del_virtual_intf(adapter->wiphy, priv->wdev);
 	rtnl_unlock();
 err_init_fw:
 	pr_debug("info: %s: unregister device\n", __func__);
@@ -843,7 +843,7 @@ int mwifiex_remove_card(struct mwifiex_adapter *adapter, struct semaphore *sem)
 
 		rtnl_lock();
 		if (priv->wdev && priv->netdev)
-			mwifiex_del_virtual_intf(adapter->wiphy, priv->netdev);
+			mwifiex_del_virtual_intf(adapter->wiphy, priv->wdev);
 		rtnl_unlock();
 	}
 
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index bd3b0bf..af3e44a 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -998,10 +998,12 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 int mwifiex_check_network_compatibility(struct mwifiex_private *priv,
 					struct mwifiex_bssdescriptor *bss_desc);
 
-struct net_device *mwifiex_add_virtual_intf(struct wiphy *wiphy,
-					char *name, enum nl80211_iftype type,
-					u32 *flags, struct vif_params *params);
-int mwifiex_del_virtual_intf(struct wiphy *wiphy, struct net_device *dev);
+struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
+					      char *name,
+					      enum nl80211_iftype type,
+					      u32 *flags,
+					      struct vif_params *params);
+int mwifiex_del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev);
 
 void mwifiex_set_sys_config_invalid_data(struct mwifiex_uap_bss_param *config);
 
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 2e2c042..4c1e5d3 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1412,10 +1412,10 @@ struct cfg80211_gtk_rekey_data {
  *
  * @add_virtual_intf: create a new virtual interface with the given name,
  *	must set the struct wireless_dev's iftype. Beware: You must create
- *	the new netdev in the wiphy's network namespace! Returns the netdev,
- *	or an ERR_PTR.
+ *	the new netdev in the wiphy's network namespace! Returns the struct
+ *	wireless_dev, or an ERR_PTR.
  *
- * @del_virtual_intf: remove the virtual interface determined by ifindex.
+ * @del_virtual_intf: remove the virtual interface
  *
  * @change_virtual_intf: change type/configuration of virtual interface,
  *	keep the struct wireless_dev's iftype updated.
@@ -1595,12 +1595,13 @@ struct cfg80211_ops {
 	int	(*resume)(struct wiphy *wiphy);
 	void	(*set_wakeup)(struct wiphy *wiphy, bool enabled);
 
-	struct net_device * (*add_virtual_intf)(struct wiphy *wiphy,
-						char *name,
-						enum nl80211_iftype type,
-						u32 *flags,
-						struct vif_params *params);
-	int	(*del_virtual_intf)(struct wiphy *wiphy, struct net_device *dev);
+	struct wireless_dev * (*add_virtual_intf)(struct wiphy *wiphy,
+						  char *name,
+						  enum nl80211_iftype type,
+						  u32 *flags,
+						  struct vif_params *params);
+	int	(*del_virtual_intf)(struct wiphy *wiphy,
+				    struct wireless_dev *wdev);
 	int	(*change_virtual_intf)(struct wiphy *wiphy,
 				       struct net_device *dev,
 				       enum nl80211_iftype type, u32 *flags,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 5bea92e..72987dc 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -20,31 +20,31 @@
 #include "rate.h"
 #include "mesh.h"
 
-static struct net_device *ieee80211_add_iface(struct wiphy *wiphy, char *name,
-					      enum nl80211_iftype type,
-					      u32 *flags,
-					      struct vif_params *params)
+static struct wireless_dev *ieee80211_add_iface(struct wiphy *wiphy, char *name,
+						enum nl80211_iftype type,
+						u32 *flags,
+						struct vif_params *params)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
-	struct net_device *dev;
+	struct wireless_dev *wdev;
 	struct ieee80211_sub_if_data *sdata;
 	int err;
 
-	err = ieee80211_if_add(local, name, &dev, type, params);
+	err = ieee80211_if_add(local, name, &wdev, type, params);
 	if (err)
 		return ERR_PTR(err);
 
 	if (type == NL80211_IFTYPE_MONITOR && flags) {
-		sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+		sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
 		sdata->u.mntr_flags = *flags;
 	}
 
-	return dev;
+	return wdev;
 }
 
-static int ieee80211_del_iface(struct wiphy *wiphy, struct net_device *dev)
+static int ieee80211_del_iface(struct wiphy *wiphy, struct wireless_dev *wdev)
 {
-	ieee80211_if_remove(IEEE80211_DEV_TO_SUB_IF(dev));
+	ieee80211_if_remove(IEEE80211_WDEV_TO_SUB_IF(wdev));
 
 	return 0;
 }
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 72654c0..2d2da44 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1280,7 +1280,7 @@ void ieee80211_handle_roc_started(struct ieee80211_roc_work *roc);
 int ieee80211_iface_init(void);
 void ieee80211_iface_exit(void);
 int ieee80211_if_add(struct ieee80211_local *local, const char *name,
-		     struct net_device **new_dev, enum nl80211_iftype type,
+		     struct wireless_dev **new_wdev, enum nl80211_iftype type,
 		     struct vif_params *params);
 int ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
 			     enum nl80211_iftype type);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 87aeb4f..0fa224d 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1269,7 +1269,7 @@ static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
 }
 
 int ieee80211_if_add(struct ieee80211_local *local, const char *name,
-		     struct net_device **new_dev, enum nl80211_iftype type,
+		     struct wireless_dev **new_wdev, enum nl80211_iftype type,
 		     struct vif_params *params)
 {
 	struct net_device *ndev;
@@ -1359,8 +1359,8 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 	list_add_tail_rcu(&sdata->list, &local->interfaces);
 	mutex_unlock(&local->iflist_mtx);
 
-	if (new_dev)
-		*new_dev = ndev;
+	if (new_wdev)
+		*new_wdev = &sdata->wdev;
 
 	return 0;
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9a61c86..9f5e796 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1961,7 +1961,7 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct vif_params params;
-	struct net_device *dev;
+	struct wireless_dev *wdev;
 	int err;
 	enum nl80211_iftype type = NL80211_IFTYPE_UNSPECIFIED;
 	u32 flags;
@@ -1991,16 +1991,14 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 	err = parse_monitor_flags(type == NL80211_IFTYPE_MONITOR ?
 				  info->attrs[NL80211_ATTR_MNTR_FLAGS] : NULL,
 				  &flags);
-	dev = rdev->ops->add_virtual_intf(&rdev->wiphy,
+	wdev = rdev->ops->add_virtual_intf(&rdev->wiphy,
 		nla_data(info->attrs[NL80211_ATTR_IFNAME]),
 		type, err ? NULL : &flags, &params);
-	if (IS_ERR(dev))
-		return PTR_ERR(dev);
+	if (IS_ERR(wdev))
+		return PTR_ERR(wdev);
 
 	if (type == NL80211_IFTYPE_MESH_POINT &&
 	    info->attrs[NL80211_ATTR_MESH_ID]) {
-		struct wireless_dev *wdev = dev->ieee80211_ptr;
-
 		wdev_lock(wdev);
 		BUILD_BUG_ON(IEEE80211_MAX_SSID_LEN !=
 			     IEEE80211_MAX_MESH_ID_LEN);
@@ -2017,12 +2015,12 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 static int nl80211_del_interface(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
-	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = info->user_ptr[1];
 
 	if (!rdev->ops->del_virtual_intf)
 		return -EOPNOTSUPP;
 
-	return rdev->ops->del_virtual_intf(&rdev->wiphy, dev);
+	return rdev->ops->del_virtual_intf(&rdev->wiphy, wdev);
 }
 
 static int nl80211_set_noack_map(struct sk_buff *skb, struct genl_info *info)
@@ -6827,7 +6825,7 @@ static struct genl_ops nl80211_ops[] = {
 		.doit = nl80211_del_interface,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = NL80211_FLAG_NEED_NETDEV |
+		.internal_flags = NL80211_FLAG_NEED_WDEV |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
-- 
1.7.10

