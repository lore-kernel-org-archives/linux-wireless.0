Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40232 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758896AbZFBLM6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 07:12:58 -0400
Message-Id: <20090602110150.663053598@sipsolutions.net>
References: <20090602110136.631660156@sipsolutions.net>
Date: Tue, 02 Jun 2009 13:01:41 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 5/6 v3] cfg80211: add rfkill support
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To be easier on drivers and users, have cfg80211 register an
rfkill structure that drivers can access. When soft-killed,
simply take down all interfaces; when hard-killed the driver
needs to notify us and we will take down the interfaces
after the fact. While rfkilled, interfaces cannot be set UP.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
v2: -ERFKILL
v3: rework polling with start/stop

 include/asm-generic/errno.h |    2 
 include/net/cfg80211.h      |   29 +++++++++++--
 include/net/mac80211.h      |   20 +++++++--
 net/mac80211/cfg.c          |   20 +++------
 net/mac80211/driver-ops.h   |    7 +++
 net/mac80211/iface.c        |    4 -
 net/mac80211/util.c         |    2 
 net/wireless/Kconfig        |    3 -
 net/wireless/core.c         |   97 ++++++++++++++++++++++++++++++++++++++++++--
 net/wireless/core.h         |    7 +++
 net/wireless/wext-compat.c  |   11 +++-
 11 files changed, 172 insertions(+), 30 deletions(-)

--- wireless-testing.orig/net/wireless/core.c	2009-06-02 12:55:01.000000000 +0200
+++ wireless-testing/net/wireless/core.c	2009-06-02 12:55:20.000000000 +0200
@@ -12,6 +12,7 @@
 #include <linux/debugfs.h>
 #include <linux/notifier.h>
 #include <linux/device.h>
+#include <linux/rtnetlink.h>
 #include <net/genetlink.h>
 #include <net/cfg80211.h>
 #include "nl80211.h"
@@ -227,6 +228,41 @@ int cfg80211_dev_rename(struct cfg80211_
 	return 0;
 }
 
+static void cfg80211_rfkill_poll(struct rfkill *rfkill, void *data)
+{
+	struct cfg80211_registered_device *drv = data;
+
+	drv->ops->rfkill_poll(&drv->wiphy);
+}
+
+static int cfg80211_rfkill_set_block(void *data, bool blocked)
+{
+	struct cfg80211_registered_device *drv = data;
+	struct wireless_dev *wdev;
+
+	if (!blocked)
+		return 0;
+
+	rtnl_lock();
+	mutex_lock(&drv->devlist_mtx);
+
+	list_for_each_entry(wdev, &drv->netdev_list, list)
+		dev_close(wdev->netdev);
+
+	mutex_unlock(&drv->devlist_mtx);
+	rtnl_unlock();
+
+	return 0;
+}
+
+static void cfg80211_rfkill_sync_work(struct work_struct *work)
+{
+	struct cfg80211_registered_device *drv;
+
+	drv = container_of(work, struct cfg80211_registered_device, rfkill_sync);
+	cfg80211_rfkill_set_block(drv, rfkill_blocked(drv->rfkill));
+}
+
 /* exported functions */
 
 struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
@@ -274,6 +310,18 @@ struct wiphy *wiphy_new(const struct cfg
 	drv->wiphy.dev.class = &ieee80211_class;
 	drv->wiphy.dev.platform_data = drv;
 
+	drv->rfkill_ops.set_block = cfg80211_rfkill_set_block;
+	drv->rfkill = rfkill_alloc(dev_name(&drv->wiphy.dev),
+				   &drv->wiphy.dev, RFKILL_TYPE_WLAN,
+				   &drv->rfkill_ops, drv);
+
+	if (!drv->rfkill) {
+		kfree(drv);
+		return NULL;
+	}
+
+	INIT_WORK(&drv->rfkill_sync, cfg80211_rfkill_sync_work);
+
 	/*
 	 * Initialize wiphy parameters to IEEE 802.11 MIB default values.
 	 * Fragmentation and RTS threshold are disabled by default with the
@@ -356,6 +404,10 @@ int wiphy_register(struct wiphy *wiphy)
 	if (res)
 		goto out_unlock;
 
+	res = rfkill_register(drv->rfkill);
+	if (res)
+		goto out_rm_dev;
+
 	list_add(&drv->list, &cfg80211_drv_list);
 
 	/* add to debugfs */
@@ -379,16 +431,41 @@ int wiphy_register(struct wiphy *wiphy)
 	cfg80211_debugfs_drv_add(drv);
 
 	res = 0;
-out_unlock:
+	goto out_unlock;
+
+ out_rm_dev:
+	device_del(&drv->wiphy.dev);
+ out_unlock:
 	mutex_unlock(&cfg80211_mutex);
 	return res;
 }
 EXPORT_SYMBOL(wiphy_register);
 
+void wiphy_rfkill_start_polling(struct wiphy *wiphy)
+{
+	struct cfg80211_registered_device *drv = wiphy_to_dev(wiphy);
+
+	if (!drv->ops->rfkill_poll)
+		return;
+	drv->rfkill_ops.poll = cfg80211_rfkill_poll;
+	rfkill_resume_polling(drv->rfkill);
+}
+EXPORT_SYMBOL(wiphy_rfkill_start_polling);
+
+void wiphy_rfkill_stop_polling(struct wiphy *wiphy)
+{
+	struct cfg80211_registered_device *drv = wiphy_to_dev(wiphy);
+
+	rfkill_pause_polling(drv->rfkill);
+}
+EXPORT_SYMBOL(wiphy_rfkill_stop_polling);
+
 void wiphy_unregister(struct wiphy *wiphy)
 {
 	struct cfg80211_registered_device *drv = wiphy_to_dev(wiphy);
 
+	rfkill_unregister(drv->rfkill);
+
 	/* protect the device list */
 	mutex_lock(&cfg80211_mutex);
 
@@ -425,6 +502,7 @@ EXPORT_SYMBOL(wiphy_unregister);
 void cfg80211_dev_free(struct cfg80211_registered_device *drv)
 {
 	struct cfg80211_internal_bss *scan, *tmp;
+	rfkill_destroy(drv->rfkill);
 	mutex_destroy(&drv->mtx);
 	mutex_destroy(&drv->devlist_mtx);
 	list_for_each_entry_safe(scan, tmp, &drv->bss_list, list)
@@ -438,6 +516,15 @@ void wiphy_free(struct wiphy *wiphy)
 }
 EXPORT_SYMBOL(wiphy_free);
 
+void wiphy_rfkill_set_hw_state(struct wiphy *wiphy, bool blocked)
+{
+	struct cfg80211_registered_device *drv = wiphy_to_dev(wiphy);
+
+	if (rfkill_set_hw_state(drv->rfkill, blocked))
+		schedule_work(&drv->rfkill_sync);
+}
+EXPORT_SYMBOL(wiphy_rfkill_set_hw_state);
+
 static int cfg80211_netdev_notifier_call(struct notifier_block * nb,
 					 unsigned long state,
 					 void *ndev)
@@ -446,7 +533,7 @@ static int cfg80211_netdev_notifier_call
 	struct cfg80211_registered_device *rdev;
 
 	if (!dev->ieee80211_ptr)
-		return 0;
+		return NOTIFY_DONE;
 
 	rdev = wiphy_to_dev(dev->ieee80211_ptr->wiphy);
 
@@ -492,9 +579,13 @@ static int cfg80211_netdev_notifier_call
 		}
 		mutex_unlock(&rdev->devlist_mtx);
 		break;
+	case NETDEV_PRE_UP:
+		if (rfkill_blocked(rdev->rfkill))
+			return notifier_from_errno(-ERFKILL);
+		break;
 	}
 
-	return 0;
+	return NOTIFY_DONE;
 }
 
 static struct notifier_block cfg80211_netdev_notifier = {
--- wireless-testing.orig/net/wireless/core.h	2009-06-02 12:55:01.000000000 +0200
+++ wireless-testing/net/wireless/core.h	2009-06-02 12:55:20.000000000 +0200
@@ -11,6 +11,8 @@
 #include <linux/kref.h>
 #include <linux/rbtree.h>
 #include <linux/debugfs.h>
+#include <linux/rfkill.h>
+#include <linux/workqueue.h>
 #include <net/genetlink.h>
 #include <net/cfg80211.h>
 #include "reg.h"
@@ -24,6 +26,11 @@ struct cfg80211_registered_device {
 	 * any call is in progress */
 	struct mutex mtx;
 
+	/* rfkill support */
+	struct rfkill_ops rfkill_ops;
+	struct rfkill *rfkill;
+	struct work_struct rfkill_sync;
+
 	/* ISO / IEC 3166 alpha2 for which this device is receiving
 	 * country IEs on, this can help disregard country IEs from APs
 	 * on the same alpha2 quickly. The alpha2 may differ from
--- wireless-testing.orig/include/net/cfg80211.h	2009-06-02 12:55:01.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2009-06-02 12:55:20.000000000 +0200
@@ -757,13 +757,11 @@ enum wiphy_params_flags {
  * @TX_POWER_AUTOMATIC: the dbm parameter is ignored
  * @TX_POWER_LIMITED: limit TX power by the dbm parameter
  * @TX_POWER_FIXED: fix TX power to the dbm parameter
- * @TX_POWER_OFF: turn off completely (will go away)
  */
 enum tx_power_setting {
 	TX_POWER_AUTOMATIC,
 	TX_POWER_LIMITED,
 	TX_POWER_FIXED,
-	TX_POWER_OFF,
 };
 
 /**
@@ -855,8 +853,10 @@ enum tx_power_setting {
  *
  * @set_tx_power: set the transmit power according to the parameters
  * @get_tx_power: store the current TX power into the dbm variable;
- *	return 0 if successful; or -ENETDOWN if successful but power
- *	is disabled (this will go away)
+ *	return 0 if successful
+ *
+ * @rfkill_poll: polls the hw rfkill line, use cfg80211 reporting
+ *	functions to adjust rfkill hw state
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy);
@@ -952,6 +952,8 @@ struct cfg80211_ops {
 	int	(*set_tx_power)(struct wiphy *wiphy,
 				enum tx_power_setting type, int dbm);
 	int	(*get_tx_power)(struct wiphy *wiphy, int *dbm);
+
+	void	(*rfkill_poll)(struct wiphy *wiphy);
 };
 
 /*
@@ -1666,4 +1668,23 @@ void cfg80211_michael_mic_failure(struct
  */
 void cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid, gfp_t gfp);
 
+/**
+ * wiphy_rfkill_set_hw_state - notify cfg80211 about hw block state
+ * @wiphy: the wiphy
+ * @blocked: block status
+ */
+void wiphy_rfkill_set_hw_state(struct wiphy *wiphy, bool blocked);
+
+/**
+ * wiphy_rfkill_start_polling - start polling rfkill
+ * @wiphy: the wiphy
+ */
+void wiphy_rfkill_start_polling(struct wiphy *wiphy);
+
+/**
+ * wiphy_rfkill_stop_polling - stop polling rfkill
+ * @wiphy: the wiphy
+ */
+void wiphy_rfkill_stop_polling(struct wiphy *wiphy);
+
 #endif /* __NET_CFG80211_H */
--- wireless-testing.orig/net/wireless/Kconfig	2009-06-02 12:55:01.000000000 +0200
+++ wireless-testing/net/wireless/Kconfig	2009-06-02 12:55:20.000000000 +0200
@@ -1,5 +1,6 @@
 config CFG80211
-        tristate "Improved wireless configuration API"
+	tristate "Improved wireless configuration API"
+	depends on RFKILL || !RFKILL
 
 config CFG80211_REG_DEBUG
 	bool "cfg80211 regulatory debugging"
--- wireless-testing.orig/net/wireless/wext-compat.c	2009-06-02 12:55:01.000000000 +0200
+++ wireless-testing/net/wireless/wext-compat.c	2009-06-02 12:55:20.000000000 +0200
@@ -764,6 +764,8 @@ int cfg80211_wext_siwtxpower(struct net_
 
 	/* only change when not disabling */
 	if (!data->txpower.disabled) {
+		rfkill_set_sw_state(rdev->rfkill, false);
+
 		if (data->txpower.fixed) {
 			/*
 			 * wext doesn't support negative values, see
@@ -787,7 +789,9 @@ int cfg80211_wext_siwtxpower(struct net_
 			}
 		}
 	} else {
-		type = TX_POWER_OFF;
+		rfkill_set_sw_state(rdev->rfkill, true);
+		schedule_work(&rdev->rfkill_sync);
+		return 0;
 	}
 
 	return rdev->ops->set_tx_power(wdev->wiphy, type, dbm);;
@@ -811,13 +815,12 @@ int cfg80211_wext_giwtxpower(struct net_
 		return -EOPNOTSUPP;
 
 	err = rdev->ops->get_tx_power(wdev->wiphy, &val);
-	/* HACK!!! */
-	if (err && err != -ENETDOWN)
+	if (err)
 		return err;
 
 	/* well... oh well */
 	data->txpower.fixed = 1;
-	data->txpower.disabled = err == -ENETDOWN;
+	data->txpower.disabled = rfkill_blocked(rdev->rfkill);
 	data->txpower.value = val;
 	data->txpower.flags = IW_TXPOW_DBM;
 
--- wireless-testing.orig/net/mac80211/cfg.c	2009-06-02 12:55:01.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2009-06-02 12:55:20.000000000 +0200
@@ -1340,7 +1340,6 @@ static int ieee80211_set_tx_power(struct
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_channel *chan = local->hw.conf.channel;
 	u32 changes = 0;
-	bool radio_enabled = true;
 
 	switch (type) {
 	case TX_POWER_AUTOMATIC:
@@ -1359,14 +1358,6 @@ static int ieee80211_set_tx_power(struct
 			return -EINVAL;
 		local->user_power_level = dbm;
 		break;
-	case TX_POWER_OFF:
-		radio_enabled = false;
-		break;
-	}
-
-	if (radio_enabled != local->hw.conf.radio_enabled) {
-		changes |= IEEE80211_CONF_CHANGE_RADIO_ENABLED;
-		local->hw.conf.radio_enabled = radio_enabled;
 	}
 
 	ieee80211_hw_config(local, changes);
@@ -1380,12 +1371,16 @@ static int ieee80211_get_tx_power(struct
 
 	*dbm = local->hw.conf.power_level;
 
-	if (!local->hw.conf.radio_enabled)
-		return -ENETDOWN;
-
 	return 0;
 }
 
+static void ieee80211_rfkill_poll(struct wiphy *wiphy)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+
+	drv_rfkill_poll(local);
+}
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -1427,4 +1422,5 @@ struct cfg80211_ops mac80211_config_ops 
 	.set_wiphy_params = ieee80211_set_wiphy_params,
 	.set_tx_power = ieee80211_set_tx_power,
 	.get_tx_power = ieee80211_get_tx_power,
+	.rfkill_poll = ieee80211_rfkill_poll,
 };
--- wireless-testing.orig/net/mac80211/iface.c	2009-06-02 12:55:01.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2009-06-02 12:55:20.000000000 +0200
@@ -170,7 +170,7 @@ static int ieee80211_open(struct net_dev
 			goto err_del_bss;
 		/* we're brought up, everything changes */
 		hw_reconf_flags = ~0;
-		ieee80211_led_radio(local, local->hw.conf.radio_enabled);
+		ieee80211_led_radio(local, true);
 	}
 
 	/*
@@ -560,7 +560,7 @@ static int ieee80211_stop(struct net_dev
 
 		drv_stop(local);
 
-		ieee80211_led_radio(local, 0);
+		ieee80211_led_radio(local, false);
 
 		flush_workqueue(local->hw.workqueue);
 
--- wireless-testing.orig/net/mac80211/util.c	2009-06-02 12:55:01.000000000 +0200
+++ wireless-testing/net/mac80211/util.c	2009-06-02 12:55:20.000000000 +0200
@@ -973,7 +973,7 @@ int ieee80211_reconfig(struct ieee80211_
 	if (local->open_count) {
 		res = drv_start(local);
 
-		ieee80211_led_radio(local, hw->conf.radio_enabled);
+		ieee80211_led_radio(local, true);
 	}
 
 	/* add interfaces */
--- wireless-testing.orig/include/net/mac80211.h	2009-06-02 12:55:01.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2009-06-02 12:55:20.000000000 +0200
@@ -526,7 +526,7 @@ enum ieee80211_conf_flags {
 /**
  * enum ieee80211_conf_changed - denotes which configuration changed
  *
- * @IEEE80211_CONF_CHANGE_RADIO_ENABLED: the value of radio_enabled changed
+ * @_IEEE80211_CONF_CHANGE_RADIO_ENABLED: DEPRECATED
  * @IEEE80211_CONF_CHANGE_LISTEN_INTERVAL: the listen interval changed
  * @IEEE80211_CONF_CHANGE_RADIOTAP: the radiotap flag changed
  * @IEEE80211_CONF_CHANGE_PS: the PS flag or dynamic PS timeout changed
@@ -536,7 +536,7 @@ enum ieee80211_conf_flags {
  * @IEEE80211_CONF_CHANGE_IDLE: Idle flag changed
  */
 enum ieee80211_conf_changed {
-	IEEE80211_CONF_CHANGE_RADIO_ENABLED	= BIT(0),
+	_IEEE80211_CONF_CHANGE_RADIO_ENABLED	= BIT(0),
 	IEEE80211_CONF_CHANGE_LISTEN_INTERVAL	= BIT(2),
 	IEEE80211_CONF_CHANGE_RADIOTAP		= BIT(3),
 	IEEE80211_CONF_CHANGE_PS		= BIT(4),
@@ -546,6 +546,14 @@ enum ieee80211_conf_changed {
 	IEEE80211_CONF_CHANGE_IDLE		= BIT(8),
 };
 
+static inline __deprecated enum ieee80211_conf_changed
+__IEEE80211_CONF_CHANGE_RADIO_ENABLED(void)
+{
+	return _IEEE80211_CONF_CHANGE_RADIO_ENABLED;
+}
+#define IEEE80211_CONF_CHANGE_RADIO_ENABLED \
+	__IEEE80211_CONF_CHANGE_RADIO_ENABLED()
+
 /**
  * struct ieee80211_conf - configuration of the device
  *
@@ -585,7 +593,7 @@ struct ieee80211_conf {
 	int max_sleep_period;
 
 	u16 listen_interval;
-	bool radio_enabled;
+	bool __deprecated radio_enabled;
 
 	u8 long_frame_max_tx_count, short_frame_max_tx_count;
 
@@ -1396,6 +1404,10 @@ enum ieee80211_ampdu_mlme_action {
  * 	is the first frame we expect to perform the action on. Notice
  * 	that TX/RX_STOP can pass NULL for this parameter.
  *	Returns a negative error code on failure.
+ *
+ * @rfkill_poll: Poll rfkill hardware state. If you need this, you also
+ *	need to set wiphy->rfkill_poll to %true before registration,
+ *	and need to call wiphy_rfkill_set_hw_state() in the callback.
  */
 struct ieee80211_ops {
 	int (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);
@@ -1444,6 +1456,8 @@ struct ieee80211_ops {
 	int (*ampdu_action)(struct ieee80211_hw *hw,
 			    enum ieee80211_ampdu_mlme_action action,
 			    struct ieee80211_sta *sta, u16 tid, u16 *ssn);
+
+	void (*rfkill_poll)(struct ieee80211_hw *hw);
 };
 
 /**
--- wireless-testing.orig/net/mac80211/driver-ops.h	2009-06-02 12:55:01.000000000 +0200
+++ wireless-testing/net/mac80211/driver-ops.h	2009-06-02 12:55:20.000000000 +0200
@@ -181,4 +181,11 @@ static inline int drv_ampdu_action(struc
 						sta, tid, ssn);
 	return -EOPNOTSUPP;
 }
+
+
+static inline void drv_rfkill_poll(struct ieee80211_local *local)
+{
+	if (local->ops->rfkill_poll)
+		local->ops->rfkill_poll(&local->hw);
+}
 #endif /* __MAC80211_DRIVER_OPS */
--- wireless-testing.orig/include/asm-generic/errno.h	2009-06-02 12:55:01.000000000 +0200
+++ wireless-testing/include/asm-generic/errno.h	2009-06-02 12:55:20.000000000 +0200
@@ -106,4 +106,6 @@
 #define	EOWNERDEAD	130	/* Owner died */
 #define	ENOTRECOVERABLE	131	/* State not recoverable */
 
+#define ERFKILL		132	/* Operation not possible due to RF-kill */
+
 #endif

-- 

