Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:53281 "HELO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751979Ab1I0DiN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 23:38:13 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 4/4] mwifiex: add cfg80211 handlers add/del_virtual_intf
Date: Mon, 26 Sep 2011 20:37:26 -0700
Message-Id: <1317094646-7718-4-git-send-email-bzhao@marvell.com> (sfid-20110927_053817_348855_E3103803)
In-Reply-To: <1317094646-7718-1-git-send-email-bzhao@marvell.com>
References: <1317094646-7718-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

Making adding and deleting virtual interfaces dynamic. Adding
handlers for creating and deleting virtual interface with
given name and dev respectively.

Also, creating default interface of type station on insmod of
the driver.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |  156 +++++++++++++++++--
 drivers/net/wireless/mwifiex/cfg80211.h |    3 +-
 drivers/net/wireless/mwifiex/decl.h     |    8 -
 drivers/net/wireless/mwifiex/init.c     |    2 +-
 drivers/net/wireless/mwifiex/main.c     |  263 ++++++------------------------
 drivers/net/wireless/mwifiex/main.h     |   18 +--
 6 files changed, 207 insertions(+), 243 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index c429661..3b6c329 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1160,8 +1160,150 @@ mwifiex_setup_ht_caps(struct ieee80211_sta_ht_cap *ht_info,
 	ht_info->mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
 }
 
+/*
+ *  create a new virtual interface with the given name
+ */
+struct net_device *mwifiex_add_virtual_intf(struct wiphy *wiphy,
+						char *name,
+						enum nl80211_iftype type,
+						u32 *flags,
+						struct vif_params *params)
+{
+	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
+	struct mwifiex_adapter *adapter;
+	struct net_device *dev;
+	void *mdev_priv;
+
+	if (!priv)
+		return NULL;
+
+	adapter = priv->adapter;
+	if (!adapter)
+		return NULL;
+
+	switch (type) {
+	case NL80211_IFTYPE_UNSPECIFIED:
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_ADHOC:
+		if (priv->bss_mode) {
+			wiphy_err(wiphy, "cannot create multiple"
+					" station/adhoc interfaces\n");
+			return NULL;
+		}
+
+		if (type == NL80211_IFTYPE_UNSPECIFIED)
+			priv->bss_mode = NL80211_IFTYPE_STATION;
+		else
+			priv->bss_mode = type;
+
+		priv->bss_type = MWIFIEX_BSS_TYPE_STA;
+		priv->frame_type = MWIFIEX_DATA_FRAME_TYPE_ETH_II;
+		priv->bss_priority = 0;
+		priv->bss_role = MWIFIEX_BSS_ROLE_STA;
+		priv->bss_index = 0;
+		priv->bss_num = 0;
+
+		break;
+	default:
+		wiphy_err(wiphy, "type not supported\n");
+		return NULL;
+	}
+
+	dev = alloc_netdev_mq(sizeof(struct mwifiex_private *), name,
+			      ether_setup, 1);
+	if (!dev) {
+		wiphy_err(wiphy, "no memory available for netdevice\n");
+		goto error;
+	}
+
+	dev_net_set(dev, wiphy_net(wiphy));
+	dev->ieee80211_ptr = priv->wdev;
+	dev->ieee80211_ptr->iftype = priv->bss_mode;
+	memcpy(dev->dev_addr, wiphy->perm_addr, ETH_ALEN);
+	memcpy(dev->perm_addr, wiphy->perm_addr, ETH_ALEN);
+	SET_NETDEV_DEV(dev, wiphy_dev(wiphy));
+
+	dev->flags |= IFF_BROADCAST | IFF_MULTICAST;
+	dev->watchdog_timeo = MWIFIEX_DEFAULT_WATCHDOG_TIMEOUT;
+	dev->hard_header_len += MWIFIEX_MIN_DATA_HEADER_LEN;
+
+	mdev_priv = netdev_priv(dev);
+	*((unsigned long *) mdev_priv) = (unsigned long) priv;
+
+	priv->netdev = dev;
+	mwifiex_init_priv_params(priv, dev);
+
+	SET_NETDEV_DEV(dev, adapter->dev);
+
+	/* Register network device */
+	if (register_netdevice(dev)) {
+		wiphy_err(wiphy, "cannot register virtual network device\n");
+		goto error;
+	}
+
+	sema_init(&priv->async_sem, 1);
+	priv->scan_pending_on_block = false;
+
+	dev_dbg(adapter->dev, "info: %s: Marvell 802.11 Adapter\n", dev->name);
+
+#ifdef CONFIG_DEBUG_FS
+	mwifiex_dev_debugfs_init(priv);
+#endif
+	return dev;
+error:
+	if (dev && (dev->reg_state == NETREG_UNREGISTERED))
+		free_netdev(dev);
+	priv->bss_mode = NL80211_IFTYPE_UNSPECIFIED;
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(mwifiex_add_virtual_intf);
+
+/*
+ * del_virtual_intf: remove the virtual interface determined by dev
+ */
+int mwifiex_del_virtual_intf(struct wiphy *wiphy, struct net_device *dev)
+{
+	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
+
+	if (!priv || !dev)
+		return 0;
+
+#ifdef CONFIG_DEBUG_FS
+	mwifiex_dev_debugfs_remove(priv);
+#endif
+
+	if (!netif_queue_stopped(priv->netdev))
+		netif_stop_queue(priv->netdev);
+
+	if (netif_carrier_ok(priv->netdev))
+		netif_carrier_off(priv->netdev);
+
+	if (dev->reg_state == NETREG_REGISTERED)
+		unregister_netdevice(dev);
+
+	if (dev->reg_state == NETREG_UNREGISTERED)
+		free_netdev(dev);
+
+	/* Clear the priv in adapter */
+	priv->netdev = NULL;
+
+	priv->media_connected = false;
+
+	cancel_work_sync(&priv->cfg_workqueue);
+	flush_workqueue(priv->workqueue);
+	destroy_workqueue(priv->workqueue);
+
+	priv->bss_mode = NL80211_IFTYPE_UNSPECIFIED;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mwifiex_del_virtual_intf);
+
 /* station cfg80211 operations */
 static struct cfg80211_ops mwifiex_cfg80211_ops = {
+	.add_virtual_intf = mwifiex_add_virtual_intf,
+	.del_virtual_intf = mwifiex_del_virtual_intf,
 	.change_virtual_intf = mwifiex_cfg80211_change_virtual_intf,
 	.scan = mwifiex_cfg80211_scan,
 	.connect = mwifiex_cfg80211_connect,
@@ -1186,8 +1328,7 @@ static struct cfg80211_ops mwifiex_cfg80211_ops = {
  * default parameters and handler function pointers, and finally
  * registers the device.
  */
-int mwifiex_register_cfg80211(struct net_device *dev, u8 *mac,
-			      struct mwifiex_private *priv)
+int mwifiex_register_cfg80211(struct mwifiex_private *priv)
 {
 	int ret;
 	void *wdev_priv;
@@ -1227,7 +1368,7 @@ int mwifiex_register_cfg80211(struct net_device *dev, u8 *mac,
 	wdev->wiphy->cipher_suites = mwifiex_cipher_suites;
 	wdev->wiphy->n_cipher_suites = ARRAY_SIZE(mwifiex_cipher_suites);
 
-	memcpy(wdev->wiphy->perm_addr, mac, 6);
+	memcpy(wdev->wiphy->perm_addr, priv->curr_addr, ETH_ALEN);
 	wdev->wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
 
 	/* We are using custom domains */
@@ -1254,17 +1395,8 @@ int mwifiex_register_cfg80211(struct net_device *dev, u8 *mac,
 				"info: successfully registered wiphy device\n");
 	}
 
-	dev_net_set(dev, wiphy_net(wdev->wiphy));
-	dev->ieee80211_ptr = wdev;
-	memcpy(dev->dev_addr, wdev->wiphy->perm_addr, 6);
-	memcpy(dev->perm_addr, wdev->wiphy->perm_addr, 6);
-	SET_NETDEV_DEV(dev, wiphy_dev(wdev->wiphy));
 	priv->wdev = wdev;
 
-	dev->flags |= IFF_BROADCAST | IFF_MULTICAST;
-	dev->watchdog_timeo = MWIFIEX_DEFAULT_WATCHDOG_TIMEOUT;
-	dev->hard_header_len += MWIFIEX_MIN_DATA_HEADER_LEN;
-
 	return ret;
 }
 
diff --git a/drivers/net/wireless/mwifiex/cfg80211.h b/drivers/net/wireless/mwifiex/cfg80211.h
index c4db8f3..8d010f2 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.h
+++ b/drivers/net/wireless/mwifiex/cfg80211.h
@@ -24,8 +24,7 @@
 
 #include "main.h"
 
-int mwifiex_register_cfg80211(struct net_device *, u8 *,
-				struct mwifiex_private *);
+int mwifiex_register_cfg80211(struct mwifiex_private *);
 
 void mwifiex_cfg80211_results(struct work_struct *work);
 #endif
diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index 94ddc90..6ca62c8 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -114,14 +114,6 @@ struct mwifiex_txinfo {
 	u8 bss_index;
 };
 
-struct mwifiex_bss_attr {
-	u8 bss_type;
-	u8 frame_type;
-	u8 active;
-	u8 bss_priority;
-	u8 bss_num;
-};
-
 enum mwifiex_wmm_ac_e {
 	WMM_AC_BK,
 	WMM_AC_BE,
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 26e685a..e1076b4 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -76,7 +76,7 @@ static int mwifiex_init_priv(struct mwifiex_private *priv)
 	memset(priv->curr_addr, 0xff, ETH_ALEN);
 
 	priv->pkt_tx_ctrl = 0;
-	priv->bss_mode = NL80211_IFTYPE_STATION;
+	priv->bss_mode = NL80211_IFTYPE_UNSPECIFIED;
 	priv->data_rate = 0;	/* Initially indicate the rate as auto */
 	priv->is_data_rate_auto = true;
 	priv->bcn_avg_factor = DEFAULT_BCN_AVG_FACTOR;
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 53579ad..8b05b4f 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -26,21 +26,6 @@
 
 const char driver_version[] = "mwifiex " VERSION " (%s) ";
 
-static struct mwifiex_bss_attr mwifiex_bss_sta[] = {
-	{MWIFIEX_BSS_TYPE_STA, MWIFIEX_DATA_FRAME_TYPE_ETH_II, true, 0, 0},
-};
-
-static int drv_mode = DRV_MODE_STA;
-
-/* Supported drv_mode table */
-static struct mwifiex_drv_mode mwifiex_drv_mode_tbl[] = {
-	{
-		.drv_mode = DRV_MODE_STA,
-		.intf_num = ARRAY_SIZE(mwifiex_bss_sta),
-		.bss_attr = mwifiex_bss_sta,
-	},
-};
-
 /*
  * This function registers the device and performs all the necessary
  * initializations.
@@ -57,7 +42,6 @@ static struct mwifiex_drv_mode mwifiex_drv_mode_tbl[] = {
  * proper cleanup before exiting.
  */
 static int mwifiex_register(void *card, struct mwifiex_if_ops *if_ops,
-			    struct mwifiex_drv_mode *drv_mode_ptr,
 			    void **padapter)
 {
 	struct mwifiex_adapter *adapter;
@@ -78,42 +62,19 @@ static int mwifiex_register(void *card, struct mwifiex_if_ops *if_ops,
 		goto error;
 
 	adapter->priv_num = 0;
-	for (i = 0; i < drv_mode_ptr->intf_num; i++) {
-		adapter->priv[i] = NULL;
-
-		if (!drv_mode_ptr->bss_attr[i].active)
-			continue;
-
-		/* Allocate memory for private structure */
-		adapter->priv[i] = kzalloc(sizeof(struct mwifiex_private),
-				GFP_KERNEL);
-		if (!adapter->priv[i]) {
-			dev_err(adapter->dev, "%s: failed to alloc priv[%d]\n",
-			       __func__, i);
-			goto error;
-		}
 
-		adapter->priv_num++;
-		adapter->priv[i]->adapter = adapter;
-		/* Save bss_type, frame_type & bss_priority */
-		adapter->priv[i]->bss_type = drv_mode_ptr->bss_attr[i].bss_type;
-		adapter->priv[i]->frame_type =
-					drv_mode_ptr->bss_attr[i].frame_type;
-		adapter->priv[i]->bss_priority =
-					drv_mode_ptr->bss_attr[i].bss_priority;
-
-		if (drv_mode_ptr->bss_attr[i].bss_type == MWIFIEX_BSS_TYPE_STA)
-			adapter->priv[i]->bss_role = MWIFIEX_BSS_ROLE_STA;
-		else if (drv_mode_ptr->bss_attr[i].bss_type ==
-							MWIFIEX_BSS_TYPE_UAP)
-			adapter->priv[i]->bss_role = MWIFIEX_BSS_ROLE_UAP;
-
-		/* Save bss_index & bss_num */
-		adapter->priv[i]->bss_index = i;
-		adapter->priv[i]->bss_num = drv_mode_ptr->bss_attr[i].bss_num;
+	/* Allocate memory for private structure */
+	adapter->priv[0] = kzalloc(sizeof(struct mwifiex_private),
+			GFP_KERNEL);
+	if (!adapter->priv[0]) {
+		dev_err(adapter->dev, "%s: failed to alloc priv[0]\n",
+		       __func__);
+		goto error;
 	}
-	adapter->drv_mode = drv_mode_ptr;
 
+	adapter->priv_num++;
+
+	adapter->priv[0]->adapter = adapter;
 	if (mwifiex_init_lock_list(adapter))
 		goto error;
 
@@ -127,8 +88,10 @@ error:
 	dev_dbg(adapter->dev, "info: leave mwifiex_register with error\n");
 
 	mwifiex_free_lock_list(adapter);
-	for (i = 0; i < drv_mode_ptr->intf_num; i++)
+
+	for (i = 0; i < adapter->priv_num; i++)
 		kfree(adapter->priv[i]);
+
 	kfree(adapter);
 
 	return -1;
@@ -316,38 +279,6 @@ exit_main_proc:
 }
 
 /*
- * This function initializes the software.
- *
- * The main work includes allocating and initializing the adapter structure
- * and initializing the private structures.
- */
-static int
-mwifiex_init_sw(void *card, struct mwifiex_if_ops *if_ops, void **padapter)
-{
-	int i;
-	struct mwifiex_drv_mode *drv_mode_ptr;
-
-	/* find mwifiex_drv_mode entry from mwifiex_drv_mode_tbl */
-	drv_mode_ptr = NULL;
-	for (i = 0; i < ARRAY_SIZE(mwifiex_drv_mode_tbl); i++) {
-		if (mwifiex_drv_mode_tbl[i].drv_mode == drv_mode) {
-			drv_mode_ptr = &mwifiex_drv_mode_tbl[i];
-			break;
-		}
-	}
-
-	if (!drv_mode_ptr) {
-		pr_err("invalid drv_mode=%d\n", drv_mode);
-		return -1;
-	}
-
-	if (mwifiex_register(card, if_ops, drv_mode_ptr, padapter))
-		return -1;
-
-	return 0;
-}
-
-/*
  * This function frees the adapter structure.
  *
  * Additionally, this closes the netlink socket, frees the timers
@@ -649,8 +580,8 @@ static const struct net_device_ops mwifiex_netdev_ops = {
  *
  * In addition, the CFG80211 work queue is also created.
  */
-static void
-mwifiex_init_priv_params(struct mwifiex_private *priv, struct net_device *dev)
+void mwifiex_init_priv_params(struct mwifiex_private *priv,
+						struct net_device *dev)
 {
 	dev->netdev_ops = &mwifiex_netdev_ops;
 	/* Initialize private structure */
@@ -664,118 +595,6 @@ mwifiex_init_priv_params(struct mwifiex_private *priv, struct net_device *dev)
 }
 
 /*
- * This function adds a new logical interface.
- *
- * It allocates, initializes and registers the interface by performing
- * the following opearations -
- *      - Allocate a new net device structure
- *      - Assign device name
- *      - Register the new device with CFG80211 subsystem
- *      - Initialize semaphore and private structure
- *      - Register the new device with kernel
- *      - Create the complete debug FS structure if configured
- */
-static struct mwifiex_private *mwifiex_add_interface(
-			struct mwifiex_adapter *adapter,
-			u8 bss_index, u8 bss_type)
-{
-	struct net_device *dev;
-	struct mwifiex_private *priv;
-	void *mdev_priv;
-
-	dev = alloc_netdev_mq(sizeof(struct mwifiex_private *), "mlan%d",
-			      ether_setup, 1);
-	if (!dev) {
-		dev_err(adapter->dev, "no memory available for netdevice\n");
-		goto error;
-	}
-
-	if (mwifiex_register_cfg80211(dev, adapter->priv[bss_index]->curr_addr,
-				      adapter->priv[bss_index]) != 0) {
-		dev_err(adapter->dev, "cannot register netdevice with cfg80211\n");
-		goto error;
-	}
-	/* Save the priv pointer in netdev */
-	priv = adapter->priv[bss_index];
-	mdev_priv = netdev_priv(dev);
-	*((unsigned long *) mdev_priv) = (unsigned long) priv;
-
-	priv->netdev = dev;
-
-	sema_init(&priv->async_sem, 1);
-	priv->scan_pending_on_block = false;
-
-	mwifiex_init_priv_params(priv, dev);
-
-	SET_NETDEV_DEV(dev, adapter->dev);
-
-	/* Register network device */
-	if (register_netdev(dev)) {
-		dev_err(adapter->dev, "cannot register virtual network device\n");
-		goto error;
-	}
-
-	dev_dbg(adapter->dev, "info: %s: Marvell 802.11 Adapter\n", dev->name);
-#ifdef CONFIG_DEBUG_FS
-	mwifiex_dev_debugfs_init(priv);
-#endif
-	return priv;
-error:
-	if (dev)
-		free_netdev(dev);
-	return NULL;
-}
-
-/*
- * This function removes a logical interface.
- *
- * It deregisters, resets and frees the interface by performing
- * the following operations -
- *      - Disconnect the device if connected, send wireless event to
- *        notify applications.
- *      - Remove the debug FS structure if configured
- *      - Unregister the device from kernel
- *      - Free the net device structure
- *      - Cancel all works and destroy work queue
- *      - Unregister and free the wireless device from CFG80211 subsystem
- */
-static void
-mwifiex_remove_interface(struct mwifiex_adapter *adapter, u8 bss_index)
-{
-	struct net_device *dev;
-	struct mwifiex_private *priv = adapter->priv[bss_index];
-
-	if (!priv)
-		return;
-	dev = priv->netdev;
-
-	if (priv->media_connected)
-		priv->media_connected = false;
-
-#ifdef CONFIG_DEBUG_FS
-	mwifiex_dev_debugfs_remove(priv);
-#endif
-	/* Last reference is our one */
-	dev_dbg(adapter->dev, "info: %s: refcnt = %d\n",
-				dev->name, netdev_refcnt_read(dev));
-
-	if (dev->reg_state == NETREG_REGISTERED)
-		unregister_netdev(dev);
-
-	/* Clear the priv in adapter */
-	priv->netdev = NULL;
-	if (dev)
-		free_netdev(dev);
-
-	cancel_work_sync(&priv->cfg_workqueue);
-	flush_workqueue(priv->workqueue);
-	destroy_workqueue(priv->workqueue);
-	wiphy_unregister(priv->wdev->wiphy);
-	wiphy_free(priv->wdev->wiphy);
-	kfree(priv->wdev);
-}
-
-/*
  * This function check if command is pending.
  */
 int is_command_pending(struct mwifiex_adapter *adapter)
@@ -847,14 +666,14 @@ int
 mwifiex_add_card(void *card, struct semaphore *sem,
 		 struct mwifiex_if_ops *if_ops)
 {
-	int i;
 	struct mwifiex_adapter *adapter;
 	char fmt[64];
+	struct mwifiex_private *priv;
 
 	if (down_interruptible(sem))
 		goto exit_sem_err;
 
-	if (mwifiex_init_sw(card, if_ops, (void **)&adapter)) {
+	if (mwifiex_register(card, if_ops, (void **)&adapter)) {
 		pr_err("%s: software init failed\n", __func__);
 		goto err_init_sw;
 	}
@@ -888,14 +707,26 @@ mwifiex_add_card(void *card, struct semaphore *sem,
 		goto err_init_fw;
 	}
 
-	/* Add interfaces */
-	for (i = 0; i < adapter->drv_mode->intf_num; i++) {
-		if (!mwifiex_add_interface(adapter, i,
-				adapter->drv_mode->bss_attr[i].bss_type)) {
-			goto err_add_intf;
-		}
+	priv = adapter->priv[0];
+
+	if (mwifiex_register_cfg80211(priv) != 0) {
+		dev_err(adapter->dev, "cannot register netdevice"
+			       " with cfg80211\n");
+			goto err_init_fw;
+	}
+
+	rtnl_lock();
+	/* Create station interface by default */
+	if (!mwifiex_add_virtual_intf(priv->wdev->wiphy, "mlan%d",
+				NL80211_IFTYPE_STATION, NULL, NULL)) {
+		rtnl_unlock();
+		dev_err(adapter->dev, "cannot create default station"
+				" interface\n");
+		goto err_add_intf;
 	}
 
+	rtnl_unlock();
+
 	up(sem);
 
 	mwifiex_drv_get_driver_version(adapter, fmt, sizeof(fmt) - 1);
@@ -904,8 +735,9 @@ mwifiex_add_card(void *card, struct semaphore *sem,
 	return 0;
 
 err_add_intf:
-	for (i = 0; i < adapter->priv_num; i++)
-		mwifiex_remove_interface(adapter, i);
+	rtnl_lock();
+	mwifiex_del_virtual_intf(priv->wdev->wiphy, priv->netdev);
+	rtnl_unlock();
 err_init_fw:
 	pr_debug("info: %s: unregister device\n", __func__);
 	adapter->if_ops.unregister_dev(adapter);
@@ -960,7 +792,7 @@ int mwifiex_remove_card(struct mwifiex_adapter *adapter, struct semaphore *sem)
 	/* Stop data */
 	for (i = 0; i < adapter->priv_num; i++) {
 		priv = adapter->priv[i];
-		if (priv) {
+		if (priv && priv->netdev) {
 			if (!netif_queue_stopped(priv->netdev))
 				netif_stop_queue(priv->netdev);
 			if (netif_carrier_ok(priv->netdev))
@@ -985,9 +817,20 @@ int mwifiex_remove_card(struct mwifiex_adapter *adapter, struct semaphore *sem)
 		       atomic_read(&adapter->cmd_pending));
 	}
 
-	/* Remove interface */
-	for (i = 0; i < adapter->priv_num; i++)
-		mwifiex_remove_interface(adapter, i);
+	for (i = 0; i < adapter->priv_num; i++) {
+		priv = adapter->priv[i];
+
+		if (!priv)
+			continue;
+
+		rtnl_lock();
+		mwifiex_del_virtual_intf(priv->wdev->wiphy, priv->netdev);
+		rtnl_unlock();
+	}
+
+	wiphy_unregister(priv->wdev->wiphy);
+	wiphy_free(priv->wdev->wiphy);
+	kfree(priv->wdev);
 
 	mwifiex_terminate_workqueue(adapter);
 
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index e6b6c0c..94f09a4 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -45,15 +45,6 @@ enum {
 	MWIFIEX_SYNC_CMD
 };
 
-#define DRV_MODE_STA       0x1
-
-struct mwifiex_drv_mode {
-	u16 drv_mode;
-	u16 intf_num;
-	struct mwifiex_bss_attr *bss_attr;
-};
-
-
 #define MWIFIEX_MAX_AP				64
 
 #define MWIFIEX_DEFAULT_WATCHDOG_TIMEOUT	(5 * HZ)
@@ -546,7 +537,6 @@ struct mwifiex_if_ops {
 struct mwifiex_adapter {
 	struct mwifiex_private *priv[MWIFIEX_MAX_BSS_NUM];
 	u8 priv_num;
-	struct mwifiex_drv_mode *drv_mode;
 	const struct firmware *firmware;
 	char fw_name[32];
 	struct device *dev;
@@ -792,6 +782,8 @@ int mwifiex_cmd_get_hw_spec(struct mwifiex_private *priv,
 int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
 			    struct host_cmd_ds_command *resp);
 int is_command_pending(struct mwifiex_adapter *adapter);
+void mwifiex_init_priv_params(struct mwifiex_private *priv,
+						struct net_device *dev);
 
 /*
  * This function checks if the queuing is RA based or not.
@@ -966,6 +958,12 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 int mwifiex_check_network_compatibility(struct mwifiex_private *priv,
 					struct mwifiex_bssdescriptor *bss_desc);
 
+struct net_device *mwifiex_add_virtual_intf(struct wiphy *wiphy,
+					char *name, enum nl80211_iftype type,
+					u32 *flags, struct vif_params *params);
+int mwifiex_del_virtual_intf(struct wiphy *wiphy, struct net_device *dev);
+
+
 #ifdef CONFIG_DEBUG_FS
 void mwifiex_debugfs_init(void);
 void mwifiex_debugfs_remove(void);
-- 
1.7.0.2

