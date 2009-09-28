Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:30311 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbZI1LVm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2009 07:21:42 -0400
From: Holger Schurig <h.schurig@mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: [RFC] libertas: first stab at cfg80211 support
Date: Mon, 28 Sep 2009 13:21:21 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200909281321.21600.h.schurig@mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

---

This patch currently just create a wdev, so you can do "iw list".

I'd like to get comments if the position where I create/destroy
the wdev makes sense.

Index: linux-wl/drivers/net/wireless/Kconfig
===================================================================
--- linux-wl.orig/drivers/net/wireless/Kconfig	2009-09-28 12:06:02.000000000 +0200
+++ linux-wl/drivers/net/wireless/Kconfig	2009-09-28 12:06:30.000000000 +0200
@@ -138,6 +138,7 @@ config LIBERTAS
 	depends on WLAN_80211
 	select WIRELESS_EXT
 	select LIB80211
+	select CFG80211
 	select FW_LOADER
 	---help---
 	  A library for Marvell Libertas 8xxx devices.
Index: linux-wl/drivers/net/wireless/libertas/Makefile
===================================================================
--- linux-wl.orig/drivers/net/wireless/libertas/Makefile	2009-09-28 12:06:02.000000000 +0200
+++ linux-wl/drivers/net/wireless/libertas/Makefile	2009-09-28 12:06:30.000000000 +0200
@@ -1,5 +1,5 @@
 libertas-objs := main.o wext.o rx.o tx.o cmd.o cmdresp.o scan.o 11d.o	\
-		 debugfs.o persistcfg.o ethtool.o assoc.o
+		 debugfs.o persistcfg.o ethtool.o assoc.o cfg.o
 
 usb8xxx-objs += if_usb.o
 libertas_cs-objs += if_cs.o
Index: linux-wl/drivers/net/wireless/libertas/dev.h
===================================================================
--- linux-wl.orig/drivers/net/wireless/libertas/dev.h	2009-09-28 12:06:02.000000000 +0200
+++ linux-wl/drivers/net/wireless/libertas/dev.h	2009-09-28 12:06:30.000000000 +0200
@@ -100,6 +100,7 @@ struct lbs_mesh_stats {
 
 /** Private structure for the MV device */
 struct lbs_private {
+	struct wireless_dev *wdev;
 	int mesh_open;
 	int mesh_fw_ver;
 	int infra_open;
Index: linux-wl/drivers/net/wireless/libertas/cfg.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-wl/drivers/net/wireless/libertas/cfg.h	2009-09-28 12:07:23.000000000 +0200
@@ -0,0 +1,9 @@
+#ifndef __LBS_CFG80211_H__
+#define __LBS_CFG80211_H__
+
+#include "dev.h"
+
+struct wireless_dev *lbs_wdev_alloc(int sizeof_priv, struct device *dev);
+void lbs_wdev_free(struct lbs_private *lbs);
+
+#endif
Index: linux-wl/drivers/net/wireless/libertas/cfg.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-wl/drivers/net/wireless/libertas/cfg.c	2009-09-28 12:09:06.000000000 +0200
@@ -0,0 +1,160 @@
+/*
+ * Implement cfg80211 ("iw") support.
+ *
+ * Copyright (C) 2009 M&N Solutions GmbH, 61191 Rosbach, Germany
+ * Holger Schurig <hs4233@mail.mn-solutions.de>
+ *
+ * Based on cfg80211.h:
+ *   Copyright (C) 2009 Intel Corporation <ilw@linux.intel.com>
+ *   Samuel Ortiz <samuel.ortiz@intel.com>
+ *   Zhu Yi <yi.zhu@intel.com>
+ */
+
+#include <net/cfg80211.h>
+
+#include "cfg.h"
+
+
+#define CHAN2G(_channel, _freq, _flags) {                       \
+	.band                   = IEEE80211_BAND_2GHZ,          \
+	.center_freq            = (_freq),                      \
+	.hw_value               = (_channel),                   \
+	.flags                  = (_flags),                     \
+	.max_antenna_gain       = 0,                            \
+	.max_power              = 30,                           \
+}
+
+static struct ieee80211_channel lbs_2ghz_channels[] = {
+	CHAN2G(1, 2412, 0),
+	CHAN2G(2, 2417, 0),
+	CHAN2G(3, 2422, 0),
+	CHAN2G(4, 2427, 0),
+	CHAN2G(5, 2432, 0),
+	CHAN2G(6, 2437, 0),
+	CHAN2G(7, 2442, 0),
+	CHAN2G(8, 2447, 0),
+	CHAN2G(9, 2452, 0),
+	CHAN2G(10, 2457, 0),
+	CHAN2G(11, 2462, 0),
+	CHAN2G(12, 2467, 0),
+	CHAN2G(13, 2472, 0),
+	CHAN2G(14, 2484, 0),
+};
+
+#define RATETAB_ENT(_rate, _rateid, _flags) \
+	{                                                               \
+		.bitrate        = (_rate),                              \
+		.hw_value       = (_rateid),                            \
+		.flags          = (_flags),                             \
+	}
+
+
+static struct ieee80211_rate lbs_rates[] = {
+	RATETAB_ENT(10,  0x1,   0),
+	RATETAB_ENT(20,  0x2,   0),
+	RATETAB_ENT(55,  0x4,   0),
+	RATETAB_ENT(110, 0x8,   0),
+	RATETAB_ENT(60,  0x10,  0),
+	RATETAB_ENT(90,  0x20,  0),
+	RATETAB_ENT(120, 0x40,  0),
+	RATETAB_ENT(180, 0x80,  0),
+	RATETAB_ENT(240, 0x100, 0),
+	RATETAB_ENT(360, 0x200, 0),
+	RATETAB_ENT(480, 0x400, 0),
+	RATETAB_ENT(540, 0x800, 0),
+};
+
+static struct ieee80211_supported_band lbs_band_2ghz = {
+	.channels = lbs_2ghz_channels,
+	.n_channels = ARRAY_SIZE(lbs_2ghz_channels),
+	.bitrates = lbs_rates,
+	.n_bitrates = ARRAY_SIZE(lbs_rates),
+};
+
+
+static const u32 cipher_suites[] = {
+	WLAN_CIPHER_SUITE_WEP40,
+	WLAN_CIPHER_SUITE_WEP104,
+	WLAN_CIPHER_SUITE_TKIP,
+	WLAN_CIPHER_SUITE_CCMP,
+};
+
+
+
+static struct cfg80211_ops lbs_cfg80211_ops = {
+/* TODO
+	.change_virtual_intf = iwm_cfg80211_change_iface,
+	.add_key = iwm_cfg80211_add_key,
+	.get_key = iwm_cfg80211_get_key,
+	.del_key = iwm_cfg80211_del_key,
+	.set_default_key = iwm_cfg80211_set_default_key,
+	.get_station = iwm_cfg80211_get_station,
+	.scan = iwm_cfg80211_scan,
+	.set_wiphy_params = iwm_cfg80211_set_wiphy_params,
+	.connect = iwm_cfg80211_connect,
+	.disconnect = iwm_cfg80211_disconnect,
+	.join_ibss = iwm_cfg80211_join_ibss,
+	.leave_ibss = iwm_cfg80211_leave_ibss,
+	.set_tx_power = iwm_cfg80211_set_txpower,
+	.get_tx_power = iwm_cfg80211_get_txpower,
+	.set_power_mgmt = iwm_cfg80211_set_power_mgmt,
+*/
+};
+
+struct wireless_dev *lbs_wdev_alloc(int sizeof_priv, struct device *dev)
+{
+	int ret = 0;
+	struct wireless_dev *wdev;
+
+	wdev = kzalloc(sizeof(struct wireless_dev), GFP_KERNEL);
+	if (!wdev) {
+		dev_err(dev, "Couldn't allocate wireless device\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	wdev->wiphy = wiphy_new(&lbs_cfg80211_ops,
+		sizeof(struct lbs_private) + sizeof_priv);
+	if (!wdev->wiphy) {
+		dev_err(dev, "Couldn't allocate wiphy device\n");
+		ret = -ENOMEM;
+		goto out_err_new;
+	}
+
+	set_wiphy_dev(wdev->wiphy, dev);
+	wdev->wiphy->max_scan_ssids = 1; /* TODO */
+	wdev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
+		BIT(NL80211_IFTYPE_ADHOC);
+	wdev->wiphy->bands[IEEE80211_BAND_2GHZ] = &lbs_band_2ghz;
+	wdev->wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
+	wdev->wiphy->cipher_suites = cipher_suites;
+	wdev->wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
+
+	ret = wiphy_register(wdev->wiphy);
+	if (ret < 0) {
+		dev_err(dev, "Couldn't register wiphy device\n");
+		goto out_err_register;
+	}
+
+	return wdev;
+
+ out_err_register:
+	wiphy_free(wdev->wiphy);
+
+ out_err_new:
+	kfree(wdev);
+
+	return ERR_PTR(ret);
+}
+
+
+void lbs_wdev_free(struct lbs_private *lbs)
+{
+	struct wireless_dev *wdev = lbs->wdev;
+
+	if (!wdev)
+		return;
+
+	wiphy_unregister(wdev->wiphy);
+	wiphy_free(wdev->wiphy);
+	kfree(wdev);
+}
Index: linux-wl/drivers/net/wireless/libertas/main.c
===================================================================
--- linux-wl.orig/drivers/net/wireless/libertas/main.c	2009-09-28 12:06:02.000000000 +0200
+++ linux-wl/drivers/net/wireless/libertas/main.c	2009-09-28 12:11:22.000000000 +0200
@@ -14,11 +14,13 @@
 #include <linux/stddef.h>
 #include <linux/ieee80211.h>
 #include <net/iw_handler.h>
+#include <net/cfg80211.h>
 
 #include "host.h"
 #include "decl.h"
 #include "dev.h"
 #include "wext.h"
+#include "cfg.h"
 #include "debugfs.h"
 #include "scan.h"
 #include "assoc.h"
@@ -1168,31 +1170,42 @@ static const struct net_device_ops lbs_n
  */
 struct lbs_private *lbs_add_card(void *card, struct device *dmdev)
 {
-	struct net_device *dev = NULL;
+	struct net_device *dev;
+	struct wireless_dev *wdev;
 	struct lbs_private *priv = NULL;
 
 	lbs_deb_enter(LBS_DEB_MAIN);
 
 	/* Allocate an Ethernet device and register it */
-	dev = alloc_etherdev(sizeof(struct lbs_private));
-	if (!dev) {
+	wdev = lbs_wdev_alloc(sizeof(struct lbs_private), dmdev);
+	if (IS_ERR(wdev)) {
 		lbs_pr_err("init wlanX device failed\n");
 		goto done;
 	}
-	priv = netdev_priv(dev);
-	dev->ml_priv = priv;
+	/* TODO? */
+	wdev->iftype = NL80211_IFTYPE_STATION;
+	priv = wdev_priv(wdev);
+	priv->wdev = wdev;
 
 	if (lbs_init_adapter(priv)) {
 		lbs_pr_err("failed to initialize adapter structure.\n");
-		goto err_init_adapter;
+		goto err_wdev;
+	}
+
+	//TODO? dev = alloc_netdev_mq(0, "wlan%d", ether_setup, IWM_TX_QUEUES);
+	dev = alloc_netdev(0, "wlan%d", ether_setup);
+	if (!dev) {
+		dev_err(dmdev, "no memory for network device instance\n");
+		goto err_adapter;
 	}
 
+	dev->netdev_ops = &lbs_netdev_ops;
+	dev->ieee80211_ptr = wdev;
+	dev->ml_priv = priv;
+	SET_NETDEV_DEV(dev, dmdev);
+	wdev->netdev = dev;
 	priv->dev = dev;
-	priv->card = card;
-	priv->mesh_open = 0;
-	priv->infra_open = 0;
 
-	/* Setup the OS Interface to our functions */
  	dev->netdev_ops = &lbs_netdev_ops;
 	dev->watchdog_timeo = 5 * HZ;
 	dev->ethtool_ops = &lbs_ethtool_ops;
@@ -1201,7 +1214,14 @@ struct lbs_private *lbs_add_card(void *c
 #endif
 	dev->flags |= IFF_BROADCAST | IFF_MULTICAST;
 
-	SET_NETDEV_DEV(dev, dmdev);
+
+	// TODO: kzalloc + iwm_init_default_profile(iwm, iwm->umac_profile); ??
+
+
+	priv->card = card;
+	priv->mesh_open = 0;
+	priv->infra_open = 0;
+
 
 	priv->rtap_net_dev = NULL;
 	strcpy(dev->name, "wlan%d");
@@ -1211,7 +1231,7 @@ struct lbs_private *lbs_add_card(void *c
 	priv->main_thread = kthread_run(lbs_thread, dev, "lbs_main");
 	if (IS_ERR(priv->main_thread)) {
 		lbs_deb_thread("Error creating main thread.\n");
-		goto err_init_adapter;
+		goto err_ndev;
 	}
 
 	priv->work_thread = create_singlethread_workqueue("lbs_worker");
@@ -1228,9 +1248,15 @@ struct lbs_private *lbs_add_card(void *c
 
 	goto done;
 
-err_init_adapter:
-	lbs_free_adapter(priv);
+ err_ndev:
 	free_netdev(dev);
+
+ err_adapter:
+	lbs_free_adapter(priv);
+
+ err_wdev:
+	lbs_wdev_free(priv);
+
 	priv = NULL;
 
 done:
@@ -1277,6 +1303,7 @@ void lbs_remove_card(struct lbs_private 
 	kthread_stop(priv->main_thread);
 
 	lbs_free_adapter(priv);
+	lbs_wdev_free(priv);
 
 	priv->dev = NULL;
 	free_netdev(dev);

-- 
M&N Solutions GmbH          Ein Unternehmen der Datagroup AG
Holger Schurig
Raiffeisenstr. 10
61191 Rosbach
Tel: 06003/9141-15          Fax 06003/9141-49
http://www.mn-solutions.de/

Handelsregister Friedberg, HRB 5903
Geschäftsführer: P.Schrittenlocher
