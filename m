Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:11165 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763374AbZE3Rhv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 May 2009 13:37:51 -0400
Received: by ey-out-2122.google.com with SMTP id 22so243532eye.37
        for <linux-wireless@vger.kernel.org>; Sat, 30 May 2009 10:37:52 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [RFC v2 14/23] orinoco: initiate cfg80211 conversion
Date: Sat, 30 May 2009 18:36:48 +0100
Message-Id: <1243705017-8784-15-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1243705017-8784-1-git-send-email-kilroyd@googlemail.com>
References: <1243705017-8784-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initialise and register a wiphy.

Store the orinoco_private structure in the new wiphy, and use the
net_device private area to store the wireless_dev. This results in a
change to the way we navigate from a net_device to the driver private
orinoco_private, which we encapsulate in the inline function ndev_priv.
Most of the remaining calls to netdev_priv are thus replaced by
ndev_priv.

We can immediately rely on cfg80211 to handle SIOCGIWNAME, so
orinoco_ioctl_getname is removed.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/Kconfig   |    1 +
 drivers/net/wireless/orinoco/Makefile  |    2 +-
 drivers/net/wireless/orinoco/cfg.c     |   98 ++++++++++++++++++++++++++++
 drivers/net/wireless/orinoco/cfg.h     |   15 ++++
 drivers/net/wireless/orinoco/main.c    |  108 ++++++++++++++++++++++++-------
 drivers/net/wireless/orinoco/orinoco.h |   11 +++
 drivers/net/wireless/orinoco/wext.c    |  110 +++++++++++++------------------
 7 files changed, 256 insertions(+), 89 deletions(-)
 create mode 100644 drivers/net/wireless/orinoco/cfg.c
 create mode 100644 drivers/net/wireless/orinoco/cfg.h

diff --git a/drivers/net/wireless/orinoco/Kconfig b/drivers/net/wireless/orinoco/Kconfig
index 44411eb..9f8e96e 100644
--- a/drivers/net/wireless/orinoco/Kconfig
+++ b/drivers/net/wireless/orinoco/Kconfig
@@ -5,6 +5,7 @@ config HERMES
 	select FW_LOADER
 	select CRYPTO
 	select CRYPTO_MICHAEL_MIC
+	select CFG80211
 	---help---
 	  A driver for 802.11b wireless cards based on the "Hermes" or
 	  Intersil HFA384x (Prism 2) MAC controller.  This includes the vast
diff --git a/drivers/net/wireless/orinoco/Makefile b/drivers/net/wireless/orinoco/Makefile
index 1fc7409..9abd632 100644
--- a/drivers/net/wireless/orinoco/Makefile
+++ b/drivers/net/wireless/orinoco/Makefile
@@ -1,7 +1,7 @@
 #
 # Makefile for the orinoco wireless device drivers.
 #
-orinoco-objs := main.o fw.o hw.o mic.o scan.o wext.o hermes_dld.o hermes.o
+orinoco-objs := main.o fw.o hw.o mic.o scan.o wext.o hermes_dld.o hermes.o cfg.o
 
 obj-$(CONFIG_HERMES)		+= orinoco.o
 obj-$(CONFIG_PCMCIA_HERMES)	+= orinoco_cs.o
diff --git a/drivers/net/wireless/orinoco/cfg.c b/drivers/net/wireless/orinoco/cfg.c
new file mode 100644
index 0000000..9a616dd
--- /dev/null
+++ b/drivers/net/wireless/orinoco/cfg.c
@@ -0,0 +1,98 @@
+/* cfg80211 support
+ *
+ * See copyright notice in main.c
+ */
+#include <linux/ieee80211.h>
+#include <net/cfg80211.h>
+#include "hw.h"
+#include "main.h"
+#include "orinoco.h"
+
+#include "cfg.h"
+
+/* Supported bitrates. Must agree with hw.c */
+static struct ieee80211_rate orinoco_rates[] = {
+	{ .bitrate = 10 },
+	{ .bitrate = 20 },
+	{ .bitrate = 55 },
+	{ .bitrate = 110 },
+};
+
+static const void * const orinoco_wiphy_privid = &orinoco_wiphy_privid;
+
+/* Called after orinoco_private is allocated. */
+void orinoco_wiphy_init(struct wiphy *wiphy)
+{
+	struct orinoco_private *priv = wiphy_priv(wiphy);
+
+	wiphy->privid = orinoco_wiphy_privid;
+
+	set_wiphy_dev(wiphy, priv->dev);
+}
+
+/* Called after firmware is initialised */
+int orinoco_wiphy_register(struct wiphy *wiphy)
+{
+	struct orinoco_private *priv = wiphy_priv(wiphy);
+	int i, channels = 0;
+
+	if (priv->firmware_type == FIRMWARE_TYPE_AGERE)
+		wiphy->max_scan_ssids = 1;
+	else
+		wiphy->max_scan_ssids = 0;
+
+	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
+
+	/* TODO: should we set if we only have demo ad-hoc?
+	 *       (priv->has_port3)
+	 */
+	if (priv->has_ibss)
+		wiphy->interface_modes |= BIT(NL80211_IFTYPE_ADHOC);
+
+	if (!priv->broken_monitor || force_monitor)
+		wiphy->interface_modes |= BIT(NL80211_IFTYPE_MONITOR);
+
+	priv->band.bitrates = orinoco_rates;
+	priv->band.n_bitrates = ARRAY_SIZE(orinoco_rates);
+
+	/* Only support channels allowed by the card EEPROM */
+	for (i = 0; i < NUM_CHANNELS; i++) {
+		if (priv->channel_mask & (1 << i)) {
+			priv->channels[i].center_freq =
+				ieee80211_dsss_chan_to_freq(i+1);
+			channels++;
+		}
+	}
+	priv->band.channels = priv->channels;
+	priv->band.n_channels = channels;
+
+	wiphy->bands[IEEE80211_BAND_2GHZ] = &priv->band;
+	wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
+
+	i = 0;
+	if (priv->has_wep) {
+		priv->cipher_suites[i] = WLAN_CIPHER_SUITE_WEP40;
+		i++;
+
+		if (priv->has_big_wep) {
+			priv->cipher_suites[i] = WLAN_CIPHER_SUITE_WEP104;
+			i++;
+		}
+	}
+	if (priv->has_wpa) {
+		priv->cipher_suites[i] = WLAN_CIPHER_SUITE_TKIP;
+		i++;
+	}
+	wiphy->cipher_suites = priv->cipher_suites;
+	wiphy->n_cipher_suites = i;
+
+	wiphy->rts_threshold = priv->rts_thresh;
+	if (!priv->has_mwo)
+		wiphy->frag_threshold = priv->frag_thresh;
+
+	return wiphy_register(wiphy);
+}
+
+const struct cfg80211_ops orinoco_cfg_ops = {
+
+};
diff --git a/drivers/net/wireless/orinoco/cfg.h b/drivers/net/wireless/orinoco/cfg.h
new file mode 100644
index 0000000..3ddc96a
--- /dev/null
+++ b/drivers/net/wireless/orinoco/cfg.h
@@ -0,0 +1,15 @@
+/* cfg80211 support.
+ *
+ * See copyright notice in main.c
+ */
+#ifndef ORINOCO_CFG_H
+#define ORINOCO_CFG_H
+
+#include <net/cfg80211.h>
+
+extern const struct cfg80211_ops orinoco_cfg_ops;
+
+void orinoco_wiphy_init(struct wiphy *wiphy);
+int orinoco_wiphy_register(struct wiphy *wiphy);
+
+#endif /* ORINOCO_CFG_H */
diff --git a/drivers/net/wireless/orinoco/main.c b/drivers/net/wireless/orinoco/main.c
index ff869a2..5c1cf64 100644
--- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -89,6 +89,7 @@
 #include <linux/wireless.h>
 #include <linux/ieee80211.h>
 #include <net/iw_handler.h>
+#include <net/cfg80211.h>
 
 #include "hermes_rid.h"
 #include "hermes_dld.h"
@@ -97,6 +98,7 @@
 #include "mic.h"
 #include "fw.h"
 #include "wext.h"
+#include "cfg.h"
 #include "main.h"
 
 #include "orinoco.h"
@@ -246,7 +248,7 @@ void set_port_type(struct orinoco_private *priv)
 
 static int orinoco_open(struct net_device *dev)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	unsigned long flags;
 	int err;
 
@@ -265,7 +267,7 @@ static int orinoco_open(struct net_device *dev)
 
 static int orinoco_stop(struct net_device *dev)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	int err = 0;
 
 	/* We mustn't use orinoco_lock() here, because we need to be
@@ -284,14 +286,14 @@ static int orinoco_stop(struct net_device *dev)
 
 static struct net_device_stats *orinoco_get_stats(struct net_device *dev)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 
 	return &priv->stats;
 }
 
 static void orinoco_set_multicast_list(struct net_device *dev)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	unsigned long flags;
 
 	if (orinoco_lock(priv, &flags) != 0) {
@@ -306,7 +308,7 @@ static void orinoco_set_multicast_list(struct net_device *dev)
 
 static int orinoco_change_mtu(struct net_device *dev, int new_mtu)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 
 	if ((new_mtu < ORINOCO_MIN_MTU) || (new_mtu > ORINOCO_MAX_MTU))
 		return -EINVAL;
@@ -327,7 +329,7 @@ static int orinoco_change_mtu(struct net_device *dev, int new_mtu)
 
 static int orinoco_xmit(struct sk_buff *skb, struct net_device *dev)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	struct net_device_stats *stats = &priv->stats;
 	hermes_t *hw = &priv->hw;
 	int err = 0;
@@ -517,7 +519,7 @@ static int orinoco_xmit(struct sk_buff *skb, struct net_device *dev)
 
 static void __orinoco_ev_alloc(struct net_device *dev, hermes_t *hw)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	u16 fid = hermes_read_regn(hw, ALLOCFID);
 
 	if (fid != priv->txfid) {
@@ -532,7 +534,7 @@ static void __orinoco_ev_alloc(struct net_device *dev, hermes_t *hw)
 
 static void __orinoco_ev_tx(struct net_device *dev, hermes_t *hw)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	struct net_device_stats *stats = &priv->stats;
 
 	stats->tx_packets++;
@@ -544,7 +546,7 @@ static void __orinoco_ev_tx(struct net_device *dev, hermes_t *hw)
 
 static void __orinoco_ev_txexc(struct net_device *dev, hermes_t *hw)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	struct net_device_stats *stats = &priv->stats;
 	u16 fid = hermes_read_regn(hw, TXCOMPLFID);
 	u16 status;
@@ -600,7 +602,7 @@ static void __orinoco_ev_txexc(struct net_device *dev, hermes_t *hw)
 
 static void orinoco_tx_timeout(struct net_device *dev)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	struct net_device_stats *stats = &priv->stats;
 	struct hermes *hw = &priv->hw;
 
@@ -649,7 +651,7 @@ static void orinoco_stat_gather(struct net_device *dev,
 				struct sk_buff *skb,
 				struct hermes_rx_descriptor *desc)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 
 	/* Using spy support with lots of Rx packets, like in an
 	 * infrastructure (AP), will really slow down everything, because
@@ -686,7 +688,7 @@ static void orinoco_rx_monitor(struct net_device *dev, u16 rxfid,
 	int err;
 	int len;
 	struct sk_buff *skb;
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	struct net_device_stats *stats = &priv->stats;
 	hermes_t *hw = &priv->hw;
 
@@ -777,7 +779,7 @@ static void orinoco_rx_monitor(struct net_device *dev, u16 rxfid,
 
 static void __orinoco_ev_rx(struct net_device *dev, hermes_t *hw)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	struct net_device_stats *stats = &priv->stats;
 	struct iw_statistics *wstats = &priv->wstats;
 	struct sk_buff *skb = NULL;
@@ -901,7 +903,7 @@ static void orinoco_rx(struct net_device *dev,
 		       struct hermes_rx_descriptor *desc,
 		       struct sk_buff *skb)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	struct net_device_stats *stats = &priv->stats;
 	u16 status, fc;
 	int length;
@@ -1016,7 +1018,7 @@ static void orinoco_rx(struct net_device *dev,
 static void orinoco_rx_isr_tasklet(unsigned long data)
 {
 	struct net_device *dev = (struct net_device *) data;
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	struct orinoco_rx_data *rx_data, *temp;
 	struct hermes_rx_descriptor *desc;
 	struct sk_buff *skb;
@@ -1261,7 +1263,7 @@ static void orinoco_send_wevents(struct work_struct *work)
 
 static void __orinoco_ev_info(struct net_device *dev, hermes_t *hw)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	u16 infofid;
 	struct {
 		__le16 len;
@@ -1594,7 +1596,7 @@ EXPORT_SYMBOL(orinoco_reinit_firmware);
 
 int __orinoco_program_rids(struct net_device *dev)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	hermes_t *hw = &priv->hw;
 	int err;
 	struct hermes_idstring idbuf;
@@ -1825,7 +1827,7 @@ int __orinoco_program_rids(struct net_device *dev)
 static void
 __orinoco_set_multicast_list(struct net_device *dev)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	int err = 0;
 	int promisc, mc_count;
 
@@ -2077,6 +2079,7 @@ static void orinoco_unregister_pm_notifier(struct orinoco_private *priv)
 int orinoco_init(struct orinoco_private *priv)
 {
 	struct device *dev = priv->dev;
+	struct wiphy *wiphy = priv_to_wiphy(priv);
 	hermes_t *hw = &priv->hw;
 	int err = 0;
 
@@ -2137,10 +2140,10 @@ int orinoco_init(struct orinoco_private *priv)
 		goto out;
 	orinoco_bss_data_init(priv);
 
-	/* Netdev has not initialised, but we have allocated the buffer. */
-	err = orinoco_hw_read_card_settings(priv, priv->ndev->dev_addr);
+	err = orinoco_hw_read_card_settings(priv, wiphy->perm_addr);
 	if (err)
 		goto out;
+	memcpy(priv->ndev->dev_addr, wiphy->perm_addr, ETH_ALEN);
 
 	err = orinoco_hw_allocate_fid(priv);
 	if (err) {
@@ -2164,6 +2167,11 @@ int orinoco_init(struct orinoco_private *priv)
 	priv->wpa_ie_len = 0;
 	priv->wpa_ie = NULL;
 
+	if (orinoco_wiphy_register(wiphy)) {
+		err = -ENODEV;
+		goto out;
+	}
+
 	/* Make the hardware available, as long as it hasn't been
 	 * removed elsewhere (e.g. by PCMCIA hot unplug) */
 	spin_lock_irq(&priv->lock);
@@ -2187,6 +2195,31 @@ static const struct net_device_ops orinoco_netdev_ops = {
 	.ndo_get_stats		= orinoco_get_stats,
 };
 
+/* Allocate private data.
+ *
+ * This driver has a number of structures associated with it
+ *  netdev - Net device structure for each network interface
+ *  wiphy - structure associated with wireless phy
+ *  wireless_dev (wdev) - structure for each wireless interface
+ *  hw - structure for hermes chip info
+ *  card - card specific structure for use by the card driver
+ *         (airport, orinoco_cs)
+ *  priv - orinoco private data
+ *  device - generic linux device structure
+ *
+ *  +---------+    +---------+
+ *  |  wiphy  |    | netdev  |
+ *  | +-------+    | +-------+
+ *  | | priv  |    | | wdev  |
+ *  | | +-----+    +-+-------+
+ *  | | | hw  |
+ *  | +-+-----+
+ *  | | card  |
+ *  +-+-------+
+ *
+ * priv has a link to netdev and device
+ * wdev has a link to wiphy
+ */
 struct orinoco_private
 *alloc_orinocodev(int sizeof_card,
 		  struct device *device,
@@ -2195,12 +2228,27 @@ struct orinoco_private
 {
 	struct net_device *dev;
 	struct orinoco_private *priv;
+	struct wireless_dev *wdev;
+	struct wiphy *wiphy;
+
+	/* allocate wiphy
+	 * NOTE: We only support a single virtual interface
+	 *       but this may change when monitor mode is added
+	 */
+	wiphy = wiphy_new(&orinoco_cfg_ops,
+			  sizeof(struct orinoco_private) + sizeof_card);
+	if (!wiphy)
+		return NULL;
 
-	dev = alloc_etherdev(sizeof(struct orinoco_private) + sizeof_card);
-	if (!dev)
+	dev = alloc_etherdev(sizeof(struct wireless_dev));
+	if (!dev) {
+		wiphy_free(wiphy);
 		return NULL;
-	priv = netdev_priv(dev);
+	}
+
+	priv = wiphy_priv(wiphy);
 	priv->ndev = dev;
+
 	if (sizeof_card)
 		priv->card = (void *)((unsigned long)priv
 				      + sizeof(struct orinoco_private));
@@ -2208,7 +2256,15 @@ struct orinoco_private
 		priv->card = NULL;
 	priv->dev = device;
 
+	orinoco_wiphy_init(wiphy);
+
+	/* Initialise wireless_dev */
+	wdev = netdev_priv(dev);
+	wdev->wiphy = wiphy;
+	wdev->iftype = NL80211_IFTYPE_STATION;
+
 	/* Setup / override net_device fields */
+	dev->ieee80211_ptr = wdev;
 	dev->netdev_ops = &orinoco_netdev_ops;
 	dev->watchdog_timeo = HZ; /* 1 second timeout */
 	dev->ethtool_ops = &orinoco_ethtool_ops;
@@ -2257,8 +2313,11 @@ EXPORT_SYMBOL(alloc_orinocodev);
 void free_orinocodev(struct orinoco_private *priv)
 {
 	struct net_device *dev = priv->ndev;
+	struct wiphy *wiphy = priv_to_wiphy(priv);
 	struct orinoco_rx_data *rx_data, *temp;
 
+	wiphy_unregister(wiphy);
+
 	/* If the tasklet is scheduled when we call tasklet_kill it
 	 * will run one final time. However the tasklet will only
 	 * drain priv->rx_list if the hw is still available. */
@@ -2281,13 +2340,14 @@ void free_orinocodev(struct orinoco_private *priv)
 	orinoco_mic_free(priv);
 	orinoco_bss_data_free(priv);
 	free_netdev(dev);
+	wiphy_free(wiphy);
 }
 EXPORT_SYMBOL(free_orinocodev);
 
 static void orinoco_get_drvinfo(struct net_device *dev,
 				struct ethtool_drvinfo *info)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 
 	strncpy(info->driver, DRIVER_NAME, sizeof(info->driver) - 1);
 	strncpy(info->version, DRIVER_VERSION, sizeof(info->version) - 1);
diff --git a/drivers/net/wireless/orinoco/orinoco.h b/drivers/net/wireless/orinoco/orinoco.h
index 2e9d33f..608cc5e 100644
--- a/drivers/net/wireless/orinoco/orinoco.h
+++ b/drivers/net/wireless/orinoco/orinoco.h
@@ -14,6 +14,7 @@
 #include <linux/netdevice.h>
 #include <linux/wireless.h>
 #include <net/iw_handler.h>
+#include <net/cfg80211.h>
 
 #include "hermes.h"
 
@@ -67,6 +68,10 @@ struct orinoco_private {
 	int (*hard_reset)(struct orinoco_private *);
 	int (*stop_fw)(struct orinoco_private *, int);
 
+	struct ieee80211_supported_band band;
+	struct ieee80211_channel channels[14];
+	u32 cipher_suites[3];
+
 	/* Synchronisation stuff */
 	spinlock_t lock;
 	int hw_unavailable;
@@ -216,4 +221,10 @@ static inline void orinoco_unlock(struct orinoco_private *priv,
 	spin_unlock_irqrestore(&priv->lock, *flags);
 }
 
+/*** Navigate from net_device to orinoco_private ***/
+static inline struct orinoco_private *ndev_priv(struct net_device *dev)
+{
+	struct wireless_dev *wdev = netdev_priv(dev);
+	return wdev_priv(wdev);
+}
 #endif /* _ORINOCO_H */
diff --git a/drivers/net/wireless/orinoco/wext.c b/drivers/net/wireless/orinoco/wext.c
index 74fdfce..74892e1 100644
--- a/drivers/net/wireless/orinoco/wext.c
+++ b/drivers/net/wireless/orinoco/wext.c
@@ -7,6 +7,7 @@
 #include <linux/wireless.h>
 #include <linux/ieee80211.h>
 #include <net/iw_handler.h>
+#include <net/cfg80211.h>
 
 #include "hermes.h"
 #include "hermes_rid.h"
@@ -23,7 +24,7 @@
 
 static struct iw_statistics *orinoco_get_wireless_stats(struct net_device *dev)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	hermes_t *hw = &priv->hw;
 	struct iw_statistics *wstats = &priv->wstats;
 	int err;
@@ -87,31 +88,12 @@ static struct iw_statistics *orinoco_get_wireless_stats(struct net_device *dev)
 /* Wireless extensions                                              */
 /********************************************************************/
 
-static int orinoco_ioctl_getname(struct net_device *dev,
-				 struct iw_request_info *info,
-				 char *name,
-				 char *extra)
-{
-	struct orinoco_private *priv = netdev_priv(dev);
-	int numrates;
-	int err;
-
-	err = orinoco_hw_get_bitratelist(priv, &numrates, NULL, 0);
-
-	if (!err && (numrates > 2))
-		strcpy(name, "IEEE 802.11b");
-	else
-		strcpy(name, "IEEE 802.11-DS");
-
-	return 0;
-}
-
 static int orinoco_ioctl_setwap(struct net_device *dev,
 				struct iw_request_info *info,
 				struct sockaddr *ap_addr,
 				char *extra)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	int err = -EINPROGRESS;		/* Call commit handler */
 	unsigned long flags;
 	static const u8 off_addr[] = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
@@ -172,7 +154,7 @@ static int orinoco_ioctl_getwap(struct net_device *dev,
 				struct sockaddr *ap_addr,
 				char *extra)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 
 	hermes_t *hw = &priv->hw;
 	int err = 0;
@@ -195,7 +177,7 @@ static int orinoco_ioctl_setmode(struct net_device *dev,
 				 u32 *mode,
 				 char *extra)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	int err = -EINPROGRESS;		/* Call commit handler */
 	unsigned long flags;
 
@@ -243,7 +225,7 @@ static int orinoco_ioctl_getmode(struct net_device *dev,
 				 u32 *mode,
 				 char *extra)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 
 	*mode = priv->iw_mode;
 	return 0;
@@ -254,7 +236,7 @@ static int orinoco_ioctl_getiwrange(struct net_device *dev,
 				    struct iw_point *rrq,
 				    char *extra)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	int err = 0;
 	struct iw_range *range = (struct iw_range *) extra;
 	int numrates;
@@ -367,7 +349,7 @@ static int orinoco_ioctl_setiwencode(struct net_device *dev,
 				     struct iw_point *erq,
 				     char *keybuf)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	int index = (erq->flags & IW_ENCODE_INDEX) - 1;
 	int setindex = priv->tx_key;
 	int encode_alg = priv->encode_alg;
@@ -469,7 +451,7 @@ static int orinoco_ioctl_getiwencode(struct net_device *dev,
 				     struct iw_point *erq,
 				     char *keybuf)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	int index = (erq->flags & IW_ENCODE_INDEX) - 1;
 	u16 xlen = 0;
 	unsigned long flags;
@@ -508,7 +490,7 @@ static int orinoco_ioctl_setessid(struct net_device *dev,
 				  struct iw_point *erq,
 				  char *essidbuf)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	unsigned long flags;
 
 	/* Note : ESSID is ignored in Ad-Hoc demo mode, but we can set it
@@ -539,7 +521,7 @@ static int orinoco_ioctl_getessid(struct net_device *dev,
 				  struct iw_point *erq,
 				  char *essidbuf)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	int active;
 	int err = 0;
 	unsigned long flags;
@@ -567,7 +549,7 @@ static int orinoco_ioctl_setnick(struct net_device *dev,
 				 struct iw_point *nrq,
 				 char *nickbuf)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	unsigned long flags;
 
 	if (nrq->length > IW_ESSID_MAX_SIZE)
@@ -589,7 +571,7 @@ static int orinoco_ioctl_getnick(struct net_device *dev,
 				 struct iw_point *nrq,
 				 char *nickbuf)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	unsigned long flags;
 
 	if (orinoco_lock(priv, &flags) != 0)
@@ -608,7 +590,7 @@ static int orinoco_ioctl_setfreq(struct net_device *dev,
 				 struct iw_freq *frq,
 				 char *extra)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	int chan = -1;
 	unsigned long flags;
 	int err = -EINPROGRESS;		/* Call commit handler */
@@ -657,7 +639,7 @@ static int orinoco_ioctl_getfreq(struct net_device *dev,
 				 struct iw_freq *frq,
 				 char *extra)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	int tmp;
 
 	/* Locking done in there */
@@ -676,7 +658,7 @@ static int orinoco_ioctl_getsens(struct net_device *dev,
 				 struct iw_param *srq,
 				 char *extra)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	hermes_t *hw = &priv->hw;
 	u16 val;
 	int err;
@@ -705,7 +687,7 @@ static int orinoco_ioctl_setsens(struct net_device *dev,
 				 struct iw_param *srq,
 				 char *extra)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	int val = srq->value;
 	unsigned long flags;
 
@@ -728,7 +710,7 @@ static int orinoco_ioctl_setrts(struct net_device *dev,
 				struct iw_param *rrq,
 				char *extra)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	int val = rrq->value;
 	unsigned long flags;
 
@@ -752,7 +734,7 @@ static int orinoco_ioctl_getrts(struct net_device *dev,
 				struct iw_param *rrq,
 				char *extra)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 
 	rrq->value = priv->rts_thresh;
 	rrq->disabled = (rrq->value == 2347);
@@ -766,7 +748,7 @@ static int orinoco_ioctl_setfrag(struct net_device *dev,
 				 struct iw_param *frq,
 				 char *extra)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	int err = -EINPROGRESS;		/* Call commit handler */
 	unsigned long flags;
 
@@ -806,7 +788,7 @@ static int orinoco_ioctl_getfrag(struct net_device *dev,
 				 struct iw_param *frq,
 				 char *extra)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	hermes_t *hw = &priv->hw;
 	int err;
 	u16 val;
@@ -847,7 +829,7 @@ static int orinoco_ioctl_setrate(struct net_device *dev,
 				 struct iw_param *rrq,
 				 char *extra)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	int ratemode;
 	int bitrate; /* 100s of kilobits */
 	unsigned long flags;
@@ -881,7 +863,7 @@ static int orinoco_ioctl_getrate(struct net_device *dev,
 				 struct iw_param *rrq,
 				 char *extra)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	int err = 0;
 	int bitrate, automatic;
 	unsigned long flags;
@@ -910,7 +892,7 @@ static int orinoco_ioctl_setpower(struct net_device *dev,
 				  struct iw_param *prq,
 				  char *extra)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	int err = -EINPROGRESS;		/* Call commit handler */
 	unsigned long flags;
 
@@ -964,7 +946,7 @@ static int orinoco_ioctl_getpower(struct net_device *dev,
 				  struct iw_param *prq,
 				  char *extra)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	hermes_t *hw = &priv->hw;
 	int err = 0;
 	u16 enable, period, timeout, mcast;
@@ -1018,7 +1000,7 @@ static int orinoco_ioctl_set_encodeext(struct net_device *dev,
 				       union iwreq_data *wrqu,
 				       char *extra)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	struct iw_point *encoding = &wrqu->encoding;
 	struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
 	int idx, alg = ext->alg, set_key = 1;
@@ -1119,7 +1101,7 @@ static int orinoco_ioctl_get_encodeext(struct net_device *dev,
 				       union iwreq_data *wrqu,
 				       char *extra)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	struct iw_point *encoding = &wrqu->encoding;
 	struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
 	int idx, max_key_len;
@@ -1176,7 +1158,7 @@ static int orinoco_ioctl_set_auth(struct net_device *dev,
 				  struct iw_request_info *info,
 				  union iwreq_data *wrqu, char *extra)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	hermes_t *hw = &priv->hw;
 	struct iw_param *param = &wrqu->param;
 	unsigned long flags;
@@ -1254,7 +1236,7 @@ static int orinoco_ioctl_get_auth(struct net_device *dev,
 				  struct iw_request_info *info,
 				  union iwreq_data *wrqu, char *extra)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	struct iw_param *param = &wrqu->param;
 	unsigned long flags;
 	int ret = 0;
@@ -1294,7 +1276,7 @@ static int orinoco_ioctl_set_genie(struct net_device *dev,
 				   struct iw_request_info *info,
 				   union iwreq_data *wrqu, char *extra)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	u8 *buf;
 	unsigned long flags;
 
@@ -1337,7 +1319,7 @@ static int orinoco_ioctl_get_genie(struct net_device *dev,
 				   struct iw_request_info *info,
 				   union iwreq_data *wrqu, char *extra)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	unsigned long flags;
 	int err = 0;
 
@@ -1366,7 +1348,7 @@ static int orinoco_ioctl_set_mlme(struct net_device *dev,
 				  struct iw_request_info *info,
 				  union iwreq_data *wrqu, char *extra)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	hermes_t *hw = &priv->hw;
 	struct iw_mlme *mlme = (struct iw_mlme *)extra;
 	unsigned long flags;
@@ -1407,7 +1389,7 @@ static int orinoco_ioctl_getretry(struct net_device *dev,
 				  struct iw_param *rrq,
 				  char *extra)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	hermes_t *hw = &priv->hw;
 	int err = 0;
 	u16 short_limit, long_limit, lifetime;
@@ -1461,7 +1443,7 @@ static int orinoco_ioctl_reset(struct net_device *dev,
 			       void *wrqu,
 			       char *extra)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
@@ -1486,7 +1468,7 @@ static int orinoco_ioctl_setibssport(struct net_device *dev,
 				     char *extra)
 
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	int val = *((int *) extra);
 	unsigned long flags;
 
@@ -1507,7 +1489,7 @@ static int orinoco_ioctl_getibssport(struct net_device *dev,
 				     void *wrqu,
 				     char *extra)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	int *val = (int *) extra;
 
 	*val = priv->ibss_port;
@@ -1519,7 +1501,7 @@ static int orinoco_ioctl_setport3(struct net_device *dev,
 				  void *wrqu,
 				  char *extra)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	int val = *((int *) extra);
 	int err = 0;
 	unsigned long flags;
@@ -1565,7 +1547,7 @@ static int orinoco_ioctl_getport3(struct net_device *dev,
 				  void *wrqu,
 				  char *extra)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	int *val = (int *) extra;
 
 	*val = priv->prefer_port3;
@@ -1577,7 +1559,7 @@ static int orinoco_ioctl_setpreamble(struct net_device *dev,
 				     void *wrqu,
 				     char *extra)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	unsigned long flags;
 	int val;
 
@@ -1609,7 +1591,7 @@ static int orinoco_ioctl_getpreamble(struct net_device *dev,
 				     void *wrqu,
 				     char *extra)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	int *val = (int *) extra;
 
 	if (!priv->has_preamble)
@@ -1629,7 +1611,7 @@ static int orinoco_ioctl_getrid(struct net_device *dev,
 				struct iw_point *data,
 				char *extra)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	hermes_t *hw = &priv->hw;
 	int rid = data->flags;
 	u16 length;
@@ -1666,7 +1648,7 @@ static int orinoco_ioctl_setscan(struct net_device *dev,
 				 struct iw_point *srq,
 				 char *extra)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	hermes_t *hw = &priv->hw;
 	struct iw_scan_req *si = (struct iw_scan_req *) extra;
 	int err = 0;
@@ -1791,7 +1773,7 @@ static inline char *orinoco_translate_scan(struct net_device *dev,
 					   union hermes_scan_info *bss,
 					   unsigned long last_scanned)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	u16			capabilities;
 	u16			channel;
 	struct iw_event		iwe;		/* Temporary buffer */
@@ -2102,7 +2084,7 @@ static int orinoco_ioctl_getscan(struct net_device *dev,
 				 struct iw_point *srq,
 				 char *extra)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	int err = 0;
 	unsigned long flags;
 	char *current_ev = extra;
@@ -2180,7 +2162,7 @@ static int orinoco_ioctl_commit(struct net_device *dev,
 				void *wrqu,
 				char *extra)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_private *priv = ndev_priv(dev);
 	struct hermes *hw = &priv->hw;
 	unsigned long flags;
 	int err = 0;
@@ -2257,7 +2239,7 @@ static const struct iw_priv_args orinoco_privtab[] = {
 	[IW_IOCTL_IDX(id)] = (iw_handler) func
 static const iw_handler	orinoco_handler[] = {
 	STD_IW_HANDLER(SIOCSIWCOMMIT,	orinoco_ioctl_commit),
-	STD_IW_HANDLER(SIOCGIWNAME,	orinoco_ioctl_getname),
+	STD_IW_HANDLER(SIOCGIWNAME,	cfg80211_wext_giwname),
 	STD_IW_HANDLER(SIOCSIWFREQ,	orinoco_ioctl_setfreq),
 	STD_IW_HANDLER(SIOCGIWFREQ,	orinoco_ioctl_getfreq),
 	STD_IW_HANDLER(SIOCSIWMODE,	orinoco_ioctl_setmode),
-- 
1.6.0.6

