Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:37108 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751452Ab1GUTn2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 15:43:28 -0400
From: Daniel Drake <dsd@laptop.org>
To: linville@tuxdriver.com
To: dcbw@redhat.com
Cc: linux-wireless@vger.kernel.org
Cc: libertas-dev@lists.infradead.org
Cc: kvalo@adurom.com
Subject: [PATCH] libertas: link mesh device to wiphy
Message-Id: <20110721194318.2FA099D401C@zog.reactivated.net> (sfid-20110721_214332_238161_89950D1F)
Date: Thu, 21 Jul 2011 20:43:17 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mesh device is now exposed as an interface of the wiphy.
This exposes the mesh device to the cfg80211 interface, allowing
mesh channel selection to be reimplemented, and available to
NetworkManager as it was before.

Some header tweaking was needed in order to implement lbs_mesh_activated().

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/net/wireless/libertas/cfg.c     |   36 +++++++++++++++-
 drivers/net/wireless/libertas/dev.h     |   12 +++++-
 drivers/net/wireless/libertas/ethtool.c |    1 +
 drivers/net/wireless/libertas/main.c    |   14 ++++--
 drivers/net/wireless/libertas/mesh.c    |   68 ++++++++++++++++++++++---------
 drivers/net/wireless/libertas/mesh.h    |   27 +++++-------
 drivers/net/wireless/libertas/rx.c      |    1 +
 drivers/net/wireless/libertas/tx.c      |    1 +
 8 files changed, 117 insertions(+), 43 deletions(-)

Replaces previous patch "libertas: reimplement mesh channel selection"

diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index b456a53..63009c7 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -19,6 +19,7 @@
 #include "decl.h"
 #include "cfg.h"
 #include "cmd.h"
+#include "mesh.h"
 
 
 #define CHAN2G(_channel, _freq, _flags) {        \
@@ -442,13 +443,16 @@ static int lbs_cfg_set_channel(struct wiphy *wiphy,
 	struct lbs_private *priv = wiphy_priv(wiphy);
 	int ret = -ENOTSUPP;
 
-	lbs_deb_enter_args(LBS_DEB_CFG80211, "freq %d, type %d",
-			   channel->center_freq, channel_type);
+	lbs_deb_enter_args(LBS_DEB_CFG80211, "iface %s freq %d, type %d",
+			   netdev_name(netdev), channel->center_freq, channel_type);
 
 	if (channel_type != NL80211_CHAN_NO_HT)
 		goto out;
 
-	ret = lbs_set_channel(priv, channel->hw_value);
+	if (netdev == priv->mesh_dev)
+		ret = lbs_mesh_set_channel(priv, channel->hw_value);
+	else
+		ret = lbs_set_channel(priv, channel->hw_value);
 
  out:
 	lbs_deb_leave_args(LBS_DEB_CFG80211, "ret %d", ret);
@@ -1292,6 +1296,9 @@ static int lbs_cfg_connect(struct wiphy *wiphy, struct net_device *dev,
 	int ret = 0;
 	u8 preamble = RADIO_PREAMBLE_SHORT;
 
+	if (dev == priv->mesh_dev)
+		return -EOPNOTSUPP;
+
 	lbs_deb_enter(LBS_DEB_CFG80211);
 
 	if (!sme->bssid) {
@@ -1408,6 +1415,9 @@ static int lbs_cfg_disconnect(struct wiphy *wiphy, struct net_device *dev,
 	struct lbs_private *priv = wiphy_priv(wiphy);
 	struct cmd_ds_802_11_deauthenticate cmd;
 
+	if (dev == priv->mesh_dev)
+		return -EOPNOTSUPP;
+
 	lbs_deb_enter_args(LBS_DEB_CFG80211, "reason_code %d", reason_code);
 
 	/* store for lbs_cfg_ret_disconnect() */
@@ -1439,6 +1449,9 @@ static int lbs_cfg_set_default_key(struct wiphy *wiphy,
 {
 	struct lbs_private *priv = wiphy_priv(wiphy);
 
+	if (netdev == priv->mesh_dev)
+		return -EOPNOTSUPP;
+
 	lbs_deb_enter(LBS_DEB_CFG80211);
 
 	if (key_index != priv->wep_tx_key) {
@@ -1460,6 +1473,9 @@ static int lbs_cfg_add_key(struct wiphy *wiphy, struct net_device *netdev,
 	u16 key_type;
 	int ret = 0;
 
+	if (netdev == priv->mesh_dev)
+		return -EOPNOTSUPP;
+
 	lbs_deb_enter(LBS_DEB_CFG80211);
 
 	lbs_deb_assoc("add_key: cipher 0x%x, mac_addr %pM\n",
@@ -1603,6 +1619,9 @@ static int lbs_get_survey(struct wiphy *wiphy, struct net_device *dev,
 	s8 signal, noise;
 	int ret;
 
+	if (dev == priv->mesh_dev)
+		return -EOPNOTSUPP;
+
 	if (idx != 0)
 		ret = -ENOENT;
 
@@ -1636,6 +1655,9 @@ static int lbs_change_intf(struct wiphy *wiphy, struct net_device *dev,
 	struct lbs_private *priv = wiphy_priv(wiphy);
 	int ret = 0;
 
+	if (dev == priv->mesh_dev)
+		return -EOPNOTSUPP;
+
 	lbs_deb_enter(LBS_DEB_CFG80211);
 
 	switch (type) {
@@ -1959,6 +1981,9 @@ static int lbs_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 	struct cfg80211_bss *bss;
 	DECLARE_SSID_BUF(ssid_buf);
 
+	if (dev == priv->mesh_dev)
+		return -EOPNOTSUPP;
+
 	lbs_deb_enter(LBS_DEB_CFG80211);
 
 	if (!params->channel) {
@@ -1995,6 +2020,9 @@ static int lbs_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
 	struct cmd_ds_802_11_ad_hoc_stop cmd;
 	int ret = 0;
 
+	if (dev == priv->mesh_dev)
+		return -EOPNOTSUPP;
+
 	lbs_deb_enter(LBS_DEB_CFG80211);
 
 	memset(&cmd, 0, sizeof(cmd));
@@ -2117,6 +2145,8 @@ int lbs_cfg_register(struct lbs_private *priv)
 			BIT(NL80211_IFTYPE_ADHOC);
 	if (lbs_rtap_supported(priv))
 		wdev->wiphy->interface_modes |= BIT(NL80211_IFTYPE_MONITOR);
+	if (lbs_mesh_activated(priv))
+		wdev->wiphy->interface_modes |= BIT(NL80211_IFTYPE_MESH_POINT);
 
 	wdev->wiphy->bands[IEEE80211_BAND_2GHZ] = &lbs_band_2ghz;
 
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index adb3490..133ff1c 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -6,7 +6,6 @@
 #ifndef _LBS_DEV_H_
 #define _LBS_DEV_H_
 
-#include "mesh.h"
 #include "defs.h"
 #include "host.h"
 
@@ -22,6 +21,17 @@ struct sleep_params {
 	uint16_t sp_reserved;
 };
 
+/* Mesh statistics */
+struct lbs_mesh_stats {
+	u32	fwd_bcast_cnt;		/* Fwd: Broadcast counter */
+	u32	fwd_unicast_cnt;	/* Fwd: Unicast counter */
+	u32	fwd_drop_ttl;		/* Fwd: TTL zero */
+	u32	fwd_drop_rbt;		/* Fwd: Recently Broadcasted */
+	u32	fwd_drop_noroute; 	/* Fwd: No route to Destination */
+	u32	fwd_drop_nobuf;		/* Fwd: Run out of internal buffers */
+	u32	drop_blind;		/* Rx:  Dropped by blinding table */
+	u32	tx_failed_cnt;		/* Tx:  Failed transmissions */
+};
 
 /* Private structure for the MV device */
 struct lbs_private {
diff --git a/drivers/net/wireless/libertas/ethtool.c b/drivers/net/wireless/libertas/ethtool.c
index 4dfb3bf..885ddc1 100644
--- a/drivers/net/wireless/libertas/ethtool.c
+++ b/drivers/net/wireless/libertas/ethtool.c
@@ -5,6 +5,7 @@
 
 #include "decl.h"
 #include "cmd.h"
+#include "mesh.h"
 
 
 static void lbs_ethtool_get_drvinfo(struct net_device *dev,
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 94652c5..ee28ae5 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -23,6 +23,7 @@
 #include "cfg.h"
 #include "debugfs.h"
 #include "cmd.h"
+#include "mesh.h"
 
 #define DRIVER_RELEASE_VERSION "323.p0"
 const char lbs_driver_version[] = "COMM-USB8388-" DRIVER_RELEASE_VERSION
@@ -950,17 +951,20 @@ int lbs_start_card(struct lbs_private *priv)
 	if (ret)
 		goto done;
 
+	if (!lbs_disablemesh)
+		lbs_init_mesh(priv);
+	else
+		pr_info("%s: mesh disabled\n", dev->name);
+
 	if (lbs_cfg_register(priv)) {
 		pr_err("cannot register device\n");
 		goto done;
 	}
 
-	lbs_update_channel(priv);
+	if (lbs_mesh_activated(priv))
+		lbs_start_mesh(priv);
 
-	if (!lbs_disablemesh)
-		lbs_init_mesh(priv);
-	else
-		pr_info("%s: mesh disabled\n", dev->name);
+	lbs_update_channel(priv);
 
 	lbs_debugfs_init_one(priv, dev);
 
diff --git a/drivers/net/wireless/libertas/mesh.c b/drivers/net/wireless/libertas/mesh.c
index be72c08..2a635d2 100644
--- a/drivers/net/wireless/libertas/mesh.c
+++ b/drivers/net/wireless/libertas/mesh.c
@@ -129,6 +129,19 @@ static int lbs_mesh_config(struct lbs_private *priv, uint16_t action,
 	return __lbs_mesh_config_send(priv, &cmd, action, priv->mesh_tlv);
 }
 
+int lbs_mesh_set_channel(struct lbs_private *priv, u8 channel)
+{
+	return lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START, channel);
+}
+
+static uint16_t lbs_mesh_get_channel(struct lbs_private *priv)
+{
+	struct wireless_dev *mesh_wdev = priv->mesh_dev->ieee80211_ptr;
+	if (mesh_wdev->channel)
+		return mesh_wdev->channel->hw_value;
+	else
+		return 1;
+}
 
 /***************************************************************************
  * Mesh sysfs support
@@ -812,7 +825,6 @@ static void lbs_persist_config_remove(struct net_device *dev)
  */
 int lbs_init_mesh(struct lbs_private *priv)
 {
-	struct net_device *dev = priv->dev;
 	int ret = 0;
 
 	lbs_deb_enter(LBS_DEB_MESH);
@@ -837,11 +849,9 @@ int lbs_init_mesh(struct lbs_private *priv)
 		   useful */
 
 		priv->mesh_tlv = TLV_TYPE_OLD_MESH_ID;
-		if (lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START,
-				    priv->channel)) {
+		if (lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START, 1)) {
 			priv->mesh_tlv = TLV_TYPE_MESH_ID;
-			if (lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START,
-					    priv->channel))
+			if (lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START, 1))
 				priv->mesh_tlv = 0;
 		}
 	} else
@@ -851,23 +861,16 @@ int lbs_init_mesh(struct lbs_private *priv)
 		 * 0x100+37; Do not invoke command with old TLV.
 		 */
 		priv->mesh_tlv = TLV_TYPE_MESH_ID;
-		if (lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START,
-				    priv->channel))
+		if (lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START, 1))
 			priv->mesh_tlv = 0;
 	}
 
 	/* Stop meshing until interface is brought up */
-	lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_STOP, priv->channel);
+	lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_STOP, 1);
 
 	if (priv->mesh_tlv) {
 		sprintf(priv->mesh_ssid, "mesh");
 		priv->mesh_ssid_len = 4;
-
-		lbs_add_mesh(priv);
-
-		if (device_create_file(&dev->dev, &dev_attr_lbs_mesh))
-			netdev_err(dev, "cannot register lbs_mesh attribute\n");
-
 		ret = 1;
 	}
 
@@ -875,6 +878,13 @@ int lbs_init_mesh(struct lbs_private *priv)
 	return ret;
 }
 
+void lbs_start_mesh(struct lbs_private *priv)
+{
+	lbs_add_mesh(priv);
+
+	if (device_create_file(&priv->dev->dev, &dev_attr_lbs_mesh))
+		netdev_err(priv->dev, "cannot register lbs_mesh attribute\n");
+}
 
 int lbs_deinit_mesh(struct lbs_private *priv)
 {
@@ -904,7 +914,8 @@ static int lbs_mesh_stop(struct net_device *dev)
 	struct lbs_private *priv = dev->ml_priv;
 
 	lbs_deb_enter(LBS_DEB_MESH);
-	lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_STOP, priv->channel);
+	lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_STOP,
+		lbs_mesh_get_channel(priv));
 
 	spin_lock_irq(&priv->driver_lock);
 
@@ -947,7 +958,8 @@ static int lbs_mesh_dev_open(struct net_device *dev)
 
 	spin_unlock_irq(&priv->driver_lock);
 
-	ret = lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START, priv->channel);
+	ret = lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START,
+		lbs_mesh_get_channel(priv));
 
 out:
 	lbs_deb_leave_args(LBS_DEB_NET, "ret %d", ret);
@@ -971,18 +983,32 @@ static const struct net_device_ops mesh_netdev_ops = {
 static int lbs_add_mesh(struct lbs_private *priv)
 {
 	struct net_device *mesh_dev = NULL;
+	struct wireless_dev *mesh_wdev;
 	int ret = 0;
 
 	lbs_deb_enter(LBS_DEB_MESH);
 
 	/* Allocate a virtual mesh device */
+	mesh_wdev = kzalloc(sizeof(struct wireless_dev), GFP_KERNEL);
+	if (!mesh_wdev) {
+		lbs_deb_mesh("init mshX wireless device failed\n");
+		ret = -ENOMEM;
+		goto done;
+	}
+
 	mesh_dev = alloc_netdev(0, "msh%d", ether_setup);
 	if (!mesh_dev) {
 		lbs_deb_mesh("init mshX device failed\n");
 		ret = -ENOMEM;
-		goto done;
+		goto err_free_wdev;
 	}
+
+	mesh_wdev->iftype = NL80211_IFTYPE_MESH_POINT;
+	mesh_wdev->wiphy = priv->wdev->wiphy;
+	mesh_wdev->netdev = mesh_dev;
+
 	mesh_dev->ml_priv = priv;
+	mesh_dev->ieee80211_ptr = mesh_wdev;
 	priv->mesh_dev = mesh_dev;
 
 	mesh_dev->netdev_ops = &mesh_netdev_ops;
@@ -996,7 +1022,7 @@ static int lbs_add_mesh(struct lbs_private *priv)
 	ret = register_netdev(mesh_dev);
 	if (ret) {
 		pr_err("cannot register mshX virtual interface\n");
-		goto err_free;
+		goto err_free_netdev;
 	}
 
 	ret = sysfs_create_group(&(mesh_dev->dev.kobj), &lbs_mesh_attr_group);
@@ -1012,9 +1038,12 @@ static int lbs_add_mesh(struct lbs_private *priv)
 err_unregister:
 	unregister_netdev(mesh_dev);
 
-err_free:
+err_free_netdev:
 	free_netdev(mesh_dev);
 
+err_free_wdev:
+	kfree(mesh_wdev);
+
 done:
 	lbs_deb_leave_args(LBS_DEB_MESH, "ret %d", ret);
 	return ret;
@@ -1035,6 +1064,7 @@ void lbs_remove_mesh(struct lbs_private *priv)
 	lbs_persist_config_remove(mesh_dev);
 	unregister_netdev(mesh_dev);
 	priv->mesh_dev = NULL;
+	kfree(mesh_dev->ieee80211_ptr);
 	free_netdev(mesh_dev);
 	lbs_deb_leave(LBS_DEB_MESH);
 }
diff --git a/drivers/net/wireless/libertas/mesh.h b/drivers/net/wireless/libertas/mesh.h
index 5014491..6603f34 100644
--- a/drivers/net/wireless/libertas/mesh.h
+++ b/drivers/net/wireless/libertas/mesh.h
@@ -9,30 +9,25 @@
 #include <net/lib80211.h>
 
 #include "host.h"
+#include "dev.h"
 
 #ifdef CONFIG_LIBERTAS_MESH
 
-/* Mesh statistics */
-struct lbs_mesh_stats {
-	u32	fwd_bcast_cnt;		/* Fwd: Broadcast counter */
-	u32	fwd_unicast_cnt;	/* Fwd: Unicast counter */
-	u32	fwd_drop_ttl;		/* Fwd: TTL zero */
-	u32	fwd_drop_rbt;		/* Fwd: Recently Broadcasted */
-	u32	fwd_drop_noroute; 	/* Fwd: No route to Destination */
-	u32	fwd_drop_nobuf;		/* Fwd: Run out of internal buffers */
-	u32	drop_blind;		/* Rx:  Dropped by blinding table */
-	u32	tx_failed_cnt;		/* Tx:  Failed transmissions */
-};
-
-
 struct net_device;
-struct lbs_private;
 
 int lbs_init_mesh(struct lbs_private *priv);
+void lbs_start_mesh(struct lbs_private *priv);
 int lbs_deinit_mesh(struct lbs_private *priv);
 
 void lbs_remove_mesh(struct lbs_private *priv);
 
+static inline bool lbs_mesh_activated(struct lbs_private *priv)
+{
+	/* Mesh SSID is only programmed after successful init */
+	return priv->mesh_ssid_len != 0;
+}
+
+int lbs_mesh_set_channel(struct lbs_private *priv, u8 channel);
 
 /* Sending / Receiving */
 
@@ -67,11 +62,13 @@ void lbs_mesh_ethtool_get_strings(struct net_device *dev,
 
 #define lbs_init_mesh(priv)
 #define lbs_deinit_mesh(priv)
+#define lbs_start_mesh(priv)
 #define lbs_add_mesh(priv)
 #define lbs_remove_mesh(priv)
 #define lbs_mesh_set_dev(priv, dev, rxpd) (dev)
 #define lbs_mesh_set_txpd(priv, dev, txpd)
-#define lbs_mesh_config(priv, enable, chan)
+#define lbs_mesh_set_channel(priv, channel) (0)
+#define lbs_mesh_activated(priv) (false)
 
 #endif
 
diff --git a/drivers/net/wireless/libertas/rx.c b/drivers/net/wireless/libertas/rx.c
index bfb8898..62e10ee 100644
--- a/drivers/net/wireless/libertas/rx.c
+++ b/drivers/net/wireless/libertas/rx.c
@@ -15,6 +15,7 @@
 #include "radiotap.h"
 #include "decl.h"
 #include "dev.h"
+#include "mesh.h"
 
 struct eth803hdr {
 	u8 dest_addr[6];
diff --git a/drivers/net/wireless/libertas/tx.c b/drivers/net/wireless/libertas/tx.c
index a6e8513..8f12752 100644
--- a/drivers/net/wireless/libertas/tx.c
+++ b/drivers/net/wireless/libertas/tx.c
@@ -12,6 +12,7 @@
 #include "decl.h"
 #include "defs.h"
 #include "dev.h"
+#include "mesh.h"
 
 /**
  * convert_radiotap_rate_to_mv - converts Tx/Rx rates from IEEE80211_RADIOTAP_RATE
-- 
1.7.6

