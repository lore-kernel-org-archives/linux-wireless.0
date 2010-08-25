Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36061 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab0HYU6Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Aug 2010 16:58:24 -0400
Message-Id: <20100825205727.117658880@sipsolutions.net>
Date: Wed, 25 Aug 2010 22:56:24 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 5/6] mac80211: support runtime interface type changes
References: <20100825205619.152295081@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add support to mac80211 for changing the interface
type even when the interface is UP, if the driver
supports it.

To achieve this
 * add a new driver callback for switching,
 * split some of the interface up/down code out
   into new functions (do_open/do_stop), and
 * maintain an own __SDATA_RUNNING bit that will
   not be set during interface type, so that any
   other code doesn't use the interface.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h     |    9 ++
 net/mac80211/cfg.c         |    3 
 net/mac80211/ieee80211_i.h |    6 +
 net/mac80211/iface.c       |  146 ++++++++++++++++++++++++++++++++++-----------
 4 files changed, 127 insertions(+), 37 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2010-08-25 22:38:19.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2010-08-25 22:40:04.000000000 +0200
@@ -1537,6 +1537,12 @@ enum ieee80211_ampdu_mlme_action {
  *	negative error code (which will be seen in userspace.)
  *	Must be implemented and can sleep.
  *
+ * @change_interface: Called when a netdevice changes type. This callback
+ *	is optional, but only if it is supported can interface types be
+ *	switched while the interface is UP. The callback may sleep.
+ *	Note that while an interface is being switched, it will not be
+ *	found by the interface iteration callbacks.
+ *
  * @remove_interface: Notifies a driver that an interface is going down.
  *	The @stop callback is called after this if it is the last interface
  *	and no monitor interfaces are present.
@@ -1693,6 +1699,9 @@ struct ieee80211_ops {
 	void (*stop)(struct ieee80211_hw *hw);
 	int (*add_interface)(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif);
+	int (*change_interface)(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				enum nl80211_iftype new_type);
 	void (*remove_interface)(struct ieee80211_hw *hw,
 				 struct ieee80211_vif *vif);
 	int (*config)(struct ieee80211_hw *hw, u32 changed);
--- wireless-testing.orig/net/mac80211/iface.c	2010-08-25 22:38:19.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2010-08-25 22:51:54.000000000 +0200
@@ -148,7 +148,12 @@ static int ieee80211_check_concurrent_if
 	return 0;
 }
 
-static int ieee80211_open(struct net_device *dev)
+/*
+ * NOTE: Be very careful when changing this function, it must NOT return
+ * an error on interface type changes that have been pre-checked, so most
+ * checks should be in ieee80211_check_concurrent_iface.
+ */
+static int ieee80211_do_open(struct net_device *dev, bool coming_up)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
@@ -157,15 +162,6 @@ static int ieee80211_open(struct net_dev
 	int res;
 	u32 hw_reconf_flags = 0;
 
-	/* fail early if user set an invalid address */
-	if (!is_zero_ether_addr(dev->dev_addr) &&
-	    !is_valid_ether_addr(dev->dev_addr))
-		return -EADDRNOTAVAIL;
-
-	res = ieee80211_check_concurrent_iface(sdata, sdata->vif.type);
-	if (res)
-		return res;
-
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_WDS:
 		if (!is_valid_ether_addr(sdata->u.wds.remote_addr))
@@ -258,9 +254,11 @@ static int ieee80211_open(struct net_dev
 		netif_carrier_on(dev);
 		break;
 	default:
-		res = drv_add_interface(local, &sdata->vif);
-		if (res)
-			goto err_stop;
+		if (coming_up) {
+			res = drv_add_interface(local, &sdata->vif);
+			if (res)
+				goto err_stop;
+		}
 
 		if (ieee80211_vif_is_mesh(&sdata->vif)) {
 			local->fif_other_bss++;
@@ -316,7 +314,9 @@ static int ieee80211_open(struct net_dev
 	hw_reconf_flags |= __ieee80211_recalc_idle(local);
 	mutex_unlock(&local->mtx);
 
-	local->open_count++;
+	if (coming_up)
+		local->open_count++;
+
 	if (hw_reconf_flags) {
 		ieee80211_hw_config(local, hw_reconf_flags);
 		/*
@@ -331,6 +331,8 @@ static int ieee80211_open(struct net_dev
 
 	netif_tx_start_all_queues(dev);
 
+	set_bit(__SDATA_RUNNING, &sdata->state);
+
 	return 0;
  err_del_interface:
 	drv_remove_interface(local, &sdata->vif);
@@ -344,19 +346,38 @@ static int ieee80211_open(struct net_dev
 	return res;
 }
 
-static int ieee80211_stop(struct net_device *dev)
+static int ieee80211_open(struct net_device *dev)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	int err;
+
+	/* fail early if user set an invalid address */
+	if (!is_zero_ether_addr(dev->dev_addr) &&
+	    !is_valid_ether_addr(dev->dev_addr))
+		return -EADDRNOTAVAIL;
+
+	err = ieee80211_check_concurrent_iface(sdata, sdata->vif.type);
+	if (err)
+		return err;
+
+	return ieee80211_do_open(dev, true);
+}
+
+static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
+			      bool going_down)
+{
 	struct ieee80211_local *local = sdata->local;
 	unsigned long flags;
 	struct sk_buff *skb, *tmp;
 	u32 hw_reconf_flags = 0;
 	int i;
 
+	clear_bit(__SDATA_RUNNING, &sdata->state);
+
 	/*
 	 * Stop TX on this interface first.
 	 */
-	netif_tx_stop_all_queues(dev);
+	netif_tx_stop_all_queues(sdata->dev);
 
 	/*
 	 * Purge work for this interface.
@@ -394,11 +415,12 @@ static int ieee80211_stop(struct net_dev
 	if (sdata->vif.type == NL80211_IFTYPE_AP)
 		local->fif_pspoll--;
 
-	netif_addr_lock_bh(dev);
+	netif_addr_lock_bh(sdata->dev);
 	spin_lock_bh(&local->filter_lock);
-	__hw_addr_unsync(&local->mc_list, &dev->mc, dev->addr_len);
+	__hw_addr_unsync(&local->mc_list, &sdata->dev->mc,
+			 sdata->dev->addr_len);
 	spin_unlock_bh(&local->filter_lock);
-	netif_addr_unlock_bh(dev);
+	netif_addr_unlock_bh(sdata->dev);
 
 	ieee80211_configure_filter(local);
 
@@ -432,7 +454,8 @@ static int ieee80211_stop(struct net_dev
 		WARN_ON(!list_empty(&sdata->u.ap.vlans));
 	}
 
-	local->open_count--;
+	if (going_down)
+		local->open_count--;
 
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_AP_VLAN:
@@ -504,7 +527,8 @@ static int ieee80211_stop(struct net_dev
 		 */
 		ieee80211_free_keys(sdata);
 
-		drv_remove_interface(local, &sdata->vif);
+		if (going_down)
+			drv_remove_interface(local, &sdata->vif);
 	}
 
 	sdata->bss = NULL;
@@ -540,6 +564,13 @@ static int ieee80211_stop(struct net_dev
 		}
 	}
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
+}
+
+static int ieee80211_stop(struct net_device *dev)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	ieee80211_do_stop(sdata, true);
 
 	return 0;
 }
@@ -854,9 +885,61 @@ static void ieee80211_setup_sdata(struct
 	ieee80211_debugfs_add_netdev(sdata);
 }
 
+static int ieee80211_runtime_change_iftype(struct ieee80211_sub_if_data *sdata,
+					   enum nl80211_iftype type)
+{
+	struct ieee80211_local *local = sdata->local;
+	int ret;
+
+	ASSERT_RTNL();
+
+	if (!local->ops->change_interface)
+		return -EBUSY;
+
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_ADHOC:
+		/* cfg80211 has already disconnected us */
+		break;
+	default:
+		return -EBUSY;
+	}
+
+	switch (type) {
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_ADHOC:
+		break;
+	default:
+		return -EBUSY;
+	}
+
+	ret = ieee80211_check_concurrent_iface(sdata, type);
+	if (ret)
+		return ret;
+
+	ieee80211_do_stop(sdata, false);
+
+	ieee80211_teardown_sdata(sdata->dev);
+
+	ret = local->ops->change_interface(&local->hw, &sdata->vif, type);
+	if (ret)
+		type = sdata->vif.type;
+
+	ieee80211_setup_sdata(sdata, type);
+
+	ret = ieee80211_do_open(sdata->dev, false);
+	WARN_ON(ret);
+
+	return ret;
+}
+
 int ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
 			     enum nl80211_iftype type)
 {
+	int ret;
+
 	ASSERT_RTNL();
 
 	if (type == sdata->vif.type)
@@ -867,18 +950,15 @@ int ieee80211_if_change_type(struct ieee
 	    type == NL80211_IFTYPE_ADHOC)
 		return -EOPNOTSUPP;
 
-	/*
-	 * We could, here, on changes between IBSS/STA/MESH modes,
-	 * invoke an MLME function instead that disassociates etc.
-	 * and goes into the requested mode.
-	 */
-
-	if (ieee80211_sdata_running(sdata))
-		return -EBUSY;
-
-	/* Purge and reset type-dependent state. */
-	ieee80211_teardown_sdata(sdata->dev);
-	ieee80211_setup_sdata(sdata, type);
+	if (ieee80211_sdata_running(sdata)) {
+		ret = ieee80211_runtime_change_iftype(sdata, type);
+		if (ret)
+			return ret;
+	} else {
+		/* Purge and reset type-dependent state. */
+		ieee80211_teardown_sdata(sdata->dev);
+		ieee80211_setup_sdata(sdata, type);
+	}
 
 	/* reset some values that shouldn't be kept across type changes */
 	sdata->vif.bss_conf.basic_rates =
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-08-25 22:38:19.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-08-25 22:40:04.000000000 +0200
@@ -478,6 +478,8 @@ enum ieee80211_sub_if_data_flags {
 	IEEE80211_SDATA_DONT_BRIDGE_PACKETS	= BIT(3),
 };
 
+#define __SDATA_RUNNING		0
+
 struct ieee80211_sub_if_data {
 	struct list_head list;
 
@@ -491,6 +493,8 @@ struct ieee80211_sub_if_data {
 
 	unsigned int flags;
 
+	unsigned long state;
+
 	int drop_unencrypted;
 
 	char name[IFNAMSIZ];
@@ -1083,7 +1087,7 @@ void ieee80211_recalc_idle(struct ieee80
 
 static inline bool ieee80211_sdata_running(struct ieee80211_sub_if_data *sdata)
 {
-	return netif_running(sdata->dev);
+	return test_bit(__SDATA_RUNNING, &sdata->state);
 }
 
 /* tx handling */
--- wireless-testing.orig/net/mac80211/cfg.c	2010-08-25 22:49:56.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2010-08-25 22:49:58.000000000 +0200
@@ -52,9 +52,6 @@ static int ieee80211_change_iface(struct
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	int ret;
 
-	if (ieee80211_sdata_running(sdata))
-		return -EBUSY;
-
 	ret = ieee80211_if_change_type(sdata, type);
 	if (ret)
 		return ret;


