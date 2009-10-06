Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:12904 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932696AbZJFOdS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 10:33:18 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] libertas: first stab at cfg80211 support
Date: Tue, 6 Oct 2009 16:31:54 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200910061631.54859.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: linux-wl/drivers/net/wireless/libertas/defs.h
===================================================================
--- linux-wl.orig/drivers/net/wireless/libertas/defs.h	2009-10-06 11:07:46.000000000 +0200
+++ linux-wl/drivers/net/wireless/libertas/defs.h	2009-10-06 11:08:43.000000000 +0200
@@ -42,6 +42,7 @@
 #define LBS_DEB_SDIO	0x00400000
 #define LBS_DEB_SYSFS	0x00800000
 #define LBS_DEB_SPI	0x01000000
+#define LBS_DEB_CFG80211 0x02000000
 
 extern unsigned int lbs_debug;
 
@@ -86,6 +87,7 @@ do { if ((lbs_debug & (grp)) == (grp)) \
 #define lbs_deb_sdio(fmt, args...)      LBS_DEB_LL(LBS_DEB_SDIO, " sdio", fmt, ##args)
 #define lbs_deb_sysfs(fmt, args...)     LBS_DEB_LL(LBS_DEB_SYSFS, " sysfs", fmt, ##args)
 #define lbs_deb_spi(fmt, args...)       LBS_DEB_LL(LBS_DEB_SPI, " spi", fmt, ##args)
+#define lbs_deb_cfg80211(fmt, args...)  LBS_DEB_LL(LBS_DEB_CFG80211, " cfg80211", fmt, ##args)
 
 #define lbs_pr_info(format, args...) \
 	printk(KERN_INFO DRV_NAME": " format, ## args)
Index: linux-wl/drivers/net/wireless/libertas/dev.h
===================================================================
--- linux-wl.orig/drivers/net/wireless/libertas/dev.h	2009-10-06 11:08:25.000000000 +0200
+++ linux-wl/drivers/net/wireless/libertas/dev.h	2009-10-06 15:22:40.000000000 +0200
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
+++ linux-wl/drivers/net/wireless/libertas/cfg.h	2009-10-06 13:56:57.000000000 +0200
@@ -0,0 +1,16 @@
+#ifndef __LBS_CFG80211_H__
+#define __LBS_CFG80211_H__
+
+#include "dev.h"
+
+struct wireless_dev *lbs_cfg_alloc(struct device *dev);
+int lbs_cfg_register(struct lbs_private *priv);
+void lbs_cfg_free(struct lbs_private *priv);
+
+int lbs_send_specific_ssid_scan(struct lbs_private *priv, u8 *ssid,
+	u8 ssid_len);
+int lbs_scan_networks(struct lbs_private *priv, int full_scan);
+void lbs_cfg_scan_worker(struct work_struct *work);
+
+
+#endif
Index: linux-wl/drivers/net/wireless/libertas/cfg.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-wl/drivers/net/wireless/libertas/cfg.c	2009-10-06 15:23:34.000000000 +0200
@@ -0,0 +1,198 @@
+/*
+ * Implement cfg80211 ("iw") support.
+ *
+ * Copyright (C) 2009 M&N Solutions GmbH, 61191 Rosbach, Germany
+ * Holger Schurig <hs4233@mail.mn-solutions.de>
+ *
+ */
+
+#include <net/cfg80211.h>
+
+#include "cfg.h"
+#include "cmd.h"
+
+
+#define CHAN2G(_channel, _freq, _flags) {        \
+	.band             = IEEE80211_BAND_2GHZ, \
+	.center_freq      = (_freq),             \
+	.hw_value         = (_channel),          \
+	.flags            = (_flags),            \
+	.max_antenna_gain = 0,                   \
+	.max_power        = 30,                  \
+}
+
+static struct ieee80211_channel lbs_2ghz_channels[] = {
+	CHAN2G(1,  2412, 0),
+	CHAN2G(2,  2417, 0),
+	CHAN2G(3,  2422, 0),
+	CHAN2G(4,  2427, 0),
+	CHAN2G(5,  2432, 0),
+	CHAN2G(6,  2437, 0),
+	CHAN2G(7,  2442, 0),
+	CHAN2G(8,  2447, 0),
+	CHAN2G(9,  2452, 0),
+	CHAN2G(10, 2457, 0),
+	CHAN2G(11, 2462, 0),
+	CHAN2G(12, 2467, 0),
+	CHAN2G(13, 2472, 0),
+	CHAN2G(14, 2484, 0),
+};
+
+#define RATETAB_ENT(_rate, _rateid, _flags) { \
+	.bitrate  = (_rate),                  \
+	.hw_value = (_rateid),                \
+	.flags    = (_flags),                 \
+}
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
+static int lbs_cfg_set_channel(struct wiphy *wiphy,
+	struct ieee80211_channel *chan,
+	enum nl80211_channel_type channel_type)
+{
+	struct lbs_private *priv = wiphy_priv(wiphy);
+	int ret = -ENOTSUPP;
+
+	lbs_deb_enter_args(LBS_DEB_CFG80211, "freq %d, type %d", chan->center_freq, channel_type);
+
+	if (channel_type != NL80211_CHAN_NO_HT)
+		goto out;
+
+	ret = lbs_set_channel(priv, chan->hw_value);
+
+ out:
+	lbs_deb_leave_args(LBS_DEB_CFG80211, "ret %d", ret);
+	return ret;
+}
+
+
+
+
+static struct cfg80211_ops lbs_cfg80211_ops = {
+	.set_channel = lbs_cfg_set_channel,
+};
+
+
+/*
+ * At this time lbs_private *priv doesn't even exist, so we just allocate
+ * memory and don't initialize the wiphy further. This is postponed until we
+ * can talk to the firmware and happens at registration time in
+ * lbs_cfg_wiphy_register().
+ */
+struct wireless_dev *lbs_cfg_alloc(struct device *dev)
+{
+	int ret = 0;
+	struct wireless_dev *wdev;
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	wdev = kzalloc(sizeof(struct wireless_dev), GFP_KERNEL);
+	if (!wdev) {
+		dev_err(dev, "cannot allocate wireless device\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	wdev->wiphy = wiphy_new(&lbs_cfg80211_ops, sizeof(struct lbs_private));
+	if (!wdev->wiphy) {
+		dev_err(dev, "cannot allocate wiphy\n");
+		ret = -ENOMEM;
+		goto err_wiphy_new;
+	}
+
+	lbs_deb_leave(LBS_DEB_CFG80211);
+	return wdev;
+
+ err_wiphy_new:
+	kfree(wdev);
+	lbs_deb_leave_args(LBS_DEB_CFG80211, "ret %d", ret);
+	return ERR_PTR(ret);
+}
+
+
+/*
+ * This function get's called after lbs_setup_firmware() determined the
+ * firmware capabities. So we can setup the wiphy according to our
+ * hardware/firmware.
+ */
+int lbs_cfg_register(struct lbs_private *priv)
+{
+	struct wireless_dev *wdev = priv->wdev;
+	int ret;
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	wdev->wiphy->max_scan_ssids = 1;
+	wdev->wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
+
+	/* TODO: BIT(NL80211_IFTYPE_ADHOC); */
+	wdev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
+
+	/* TODO: honor priv->regioncode */
+	wdev->wiphy->bands[IEEE80211_BAND_2GHZ] = &lbs_band_2ghz;
+
+	/*
+	 * We could check priv->fwcapinfo && FW_CAPINFO_WPA, but I have
+	 * never seen a firmware without WPA
+	 */
+	wdev->wiphy->cipher_suites = cipher_suites;
+	wdev->wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
+
+	ret = wiphy_register(wdev->wiphy);
+	if (ret < 0)
+		lbs_pr_err("cannot register wiphy device\n");
+
+	ret = register_netdev(priv->dev);
+	if (ret)
+		lbs_pr_err("cannot register network device\n");
+
+	lbs_deb_leave_args(LBS_DEB_CFG80211, "ret %d", ret);
+	return ret;
+}
+
+
+void lbs_cfg_free(struct lbs_private *priv)
+{
+	struct wireless_dev *wdev = priv->wdev;
+
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	if (!wdev)
+		return;
+
+	if (wdev->wiphy) {
+		wiphy_unregister(wdev->wiphy);
+		wiphy_free(wdev->wiphy);
+	}
+	kfree(wdev);
+}
Index: linux-wl/drivers/net/wireless/libertas/main.c
===================================================================
--- linux-wl.orig/drivers/net/wireless/libertas/main.c	2009-10-06 11:08:25.000000000 +0200
+++ linux-wl/drivers/net/wireless/libertas/main.c	2009-10-06 15:22:40.000000000 +0200
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
@@ -1245,31 +1247,42 @@ static const struct net_device_ops lbs_n
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
-		lbs_pr_err("init wlanX device failed\n");
+	wdev = lbs_cfg_alloc(dmdev);
+	if (IS_ERR(wdev)) {
+		lbs_pr_err("cfg80211 init failed\n");
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
 	}
 
+	//TODO? dev = alloc_netdev_mq(0, "wlan%d", ether_setup, IWM_TX_QUEUES);
+	dev = alloc_netdev(0, "wlan%d", ether_setup);
+	if (!dev) {
+		dev_err(dmdev, "no memory for network device instance\n");
+		goto err_adapter;
+	}
+
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
@@ -1278,7 +1291,14 @@ struct lbs_private *lbs_add_card(void *c
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
@@ -1288,7 +1308,7 @@ struct lbs_private *lbs_add_card(void *c
 	priv->main_thread = kthread_run(lbs_thread, dev, "lbs_main");
 	if (IS_ERR(priv->main_thread)) {
 		lbs_deb_thread("Error creating main thread.\n");
-		goto err_init_adapter;
+		goto err_ndev;
 	}
 
 	priv->work_thread = create_singlethread_workqueue("lbs_worker");
@@ -1305,9 +1325,15 @@ struct lbs_private *lbs_add_card(void *c
 
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
+	lbs_cfg_free(priv);
+
 	priv = NULL;
 
 done:
@@ -1359,6 +1385,7 @@ void lbs_remove_card(struct lbs_private 
 	kthread_stop(priv->main_thread);
 
 	lbs_free_adapter(priv);
+	lbs_cfg_free(priv);
 
 	priv->dev = NULL;
 	free_netdev(dev);
@@ -1383,8 +1410,8 @@ int lbs_start_card(struct lbs_private *p
 	/* init 802.11d */
 	lbs_init_11d(priv);
 
-	if (register_netdev(dev)) {
-		lbs_pr_err("cannot register ethX device\n");
+	if (lbs_cfg_register(priv)) {
+		lbs_pr_err("cannot register device\n");
 		goto done;
 	}
 
Index: linux-wl/drivers/net/wireless/libertas/Makefile
===================================================================
--- linux-wl.orig/drivers/net/wireless/libertas/Makefile	2009-10-06 11:08:43.000000000 +0200
+++ linux-wl/drivers/net/wireless/libertas/Makefile	2009-10-06 15:22:40.000000000 +0200
@@ -1,5 +1,6 @@
 libertas-y += 11d.o
 libertas-y += assoc.o
+libertas-y += cfg.o
 libertas-y += cmd.o
 libertas-y += cmdresp.o
 libertas-y += debugfs.o

-- 
http://www.holgerschurig.de
