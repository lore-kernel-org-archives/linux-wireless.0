Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:47372 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356AbZEPMKB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 May 2009 08:10:01 -0400
Received: by mail-ew0-f176.google.com with SMTP id 24so3051294ewy.37
        for <linux-wireless@vger.kernel.org>; Sat, 16 May 2009 05:10:01 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [RFC 3/3] orinoco: initiate cfg80211 conversion
Date: Sat, 16 May 2009 13:22:57 +0100
Message-Id: <1242476577-26320-4-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1242476577-26320-1-git-send-email-kilroyd@googlemail.com>
References: <1242476577-26320-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initialise and register a wiphy. We can immediately rely on cfg80211 to
handle SIOCGIWNAME.

Signed-off by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/Kconfig   |    1 +
 drivers/net/wireless/orinoco/Makefile  |    2 +-
 drivers/net/wireless/orinoco/cfg.c     |   82 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/orinoco/cfg.h     |   18 +++++++
 drivers/net/wireless/orinoco/main.c    |   28 ++++++++++-
 drivers/net/wireless/orinoco/orinoco.h |    7 +++
 drivers/net/wireless/orinoco/wext.c    |   22 +--------
 7 files changed, 138 insertions(+), 22 deletions(-)
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
index 0000000..9cb426a
--- /dev/null
+++ b/drivers/net/wireless/orinoco/cfg.c
@@ -0,0 +1,82 @@
+/* cfg80211 support
+ *
+ * See copyright notice in main.c
+ */
+#include <linux/ieee80211.h>
+#include <net/cfg80211.h>
+#include "orinoco.h"
+
+#include "cfg.h"
+
+/* Get a pointer to orinoco private data from the wiphy */
+#define ophy_priv(wiphy) (*((struct orinoco_private **) wiphy_priv(wiphy)))
+
+/* Supported bitrates. Must agree with hw.c
+ * TODO: are the flags correct? */
+static const struct ieee80211_rate orinoco_rates[] = {
+	{ .bitrate = 10 },
+	{ .bitrate = 20, .flags = IEEE80211_RATE_SHORT_PREAMBLE },
+	{ .bitrate = 55, .flags = IEEE80211_RATE_SHORT_PREAMBLE },
+	{ .bitrate = 110, .flags = IEEE80211_RATE_SHORT_PREAMBLE },
+};
+
+static const void * const orinoco_wiphy_privid = &orinoco_wiphy_privid;
+
+/* Called after orinoco_private is allocated.
+ * Which must we do now? Which do we put off until we have firmware?
+ */
+void orinoco_wiphy_init(struct wiphy *wiphy, struct orinoco_private *priv)
+{
+	/* Setup so that we can recover orinoco_private from wiphy */
+	ophy_priv(wiphy) = priv;
+
+	wiphy->privid = orinoco_wiphy_privid;
+
+	priv->wdev.wiphy = wiphy;
+	priv->wdev.iftype = NL80211_IFTYPE_STATION;
+
+	set_wiphy_dev(wiphy, priv->dev);
+}
+
+/* Called after firmware is initialised */
+int orinoco_wiphy_register(struct wiphy *wiphy)
+{
+	struct orinoco_private *priv = ophy_priv(wiphy);
+	int i, channels = 0;
+
+	memcpy(wiphy->perm_addr, priv->ndev->dev_addr, ETH_ALEN);
+
+	wiphy->max_scan_ssids = 1;
+
+	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
+
+	/* TODO: should we set if we only have demo ad-hoc?
+	 *       (priv->has_port3)
+	 */
+	if (priv->has_ibss)
+		wiphy->interface_modes |= BIT(NL80211_IFTYPE_ADHOC);
+
+	memcpy(priv->rates, orinoco_rates, sizeof(orinoco_rates));
+	priv->band.bitrates = priv->rates;
+	priv->band.n_bitrates = ARRAY_SIZE(orinoco_rates);
+
+	/* Only support channels allowed by the card EEPROM */
+	for (i = 0; i < 14; i++) {
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
+	return wiphy_register(wiphy);
+}
+
+const struct cfg80211_ops orinoco_cfg_ops = {
+
+};
diff --git a/drivers/net/wireless/orinoco/cfg.h b/drivers/net/wireless/orinoco/cfg.h
new file mode 100644
index 0000000..6bd3071
--- /dev/null
+++ b/drivers/net/wireless/orinoco/cfg.h
@@ -0,0 +1,18 @@
+/* cfg80211 support.
+ *
+ * See copyright notice in main.c
+ */
+#ifndef ORINOCO_CFG_H
+#define ORINOCO_CFG_H
+
+#include <net/cfg80211.h>
+
+/* Forward declaration */
+struct orinoco_private;
+
+extern const struct cfg80211_ops orinoco_cfg_ops;
+
+void orinoco_wiphy_init(struct wiphy *wiphy, struct orinoco_private *priv);
+int orinoco_wiphy_register(struct wiphy *wiphy);
+
+#endif /* ORINOCO_CFG_H */
diff --git a/drivers/net/wireless/orinoco/main.c b/drivers/net/wireless/orinoco/main.c
index 345593c..d062307 100644
--- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -88,6 +88,7 @@
 #include <linux/wireless.h>
 #include <linux/ieee80211.h>
 #include <net/iw_handler.h>
+#include <net/cfg80211.h>
 
 #include "hermes_rid.h"
 #include "hermes_dld.h"
@@ -96,6 +97,7 @@
 #include "mic.h"
 #include "fw.h"
 #include "wext.h"
+#include "cfg.h"
 #include "main.h"
 
 #include "orinoco.h"
@@ -2502,6 +2504,11 @@ static int orinoco_init(struct net_device *dev)
 	priv->wpa_ie_len = 0;
 	priv->wpa_ie = NULL;
 
+	if (orinoco_wiphy_register(priv->wdev.wiphy)) {
+		err = -ENODEV;
+		goto out;
+	}
+
 	/* Make the hardware available, as long as it hasn't been
 	 * removed elsewhere (e.g. by PCMCIA hot unplug) */
 	spin_lock_irq(&priv->lock);
@@ -2533,12 +2540,26 @@ struct net_device
 {
 	struct net_device *dev;
 	struct orinoco_private *priv;
+	struct wiphy *wiphy;
+
+	/* allocate wiphy
+	 * NOTE: We only support a single virtual interface, so wiphy
+	 * and wireless_dev are somewhat synonymous for this device.
+	 */
+	wiphy = wiphy_new(&orinoco_cfg_ops,
+			  sizeof(struct orinoco_private *));
+	if (!wiphy)
+		return NULL;
 
 	dev = alloc_etherdev(sizeof(struct orinoco_private) + sizeof_card);
-	if (!dev)
+	if (!dev) {
+		wiphy_free(wiphy);
 		return NULL;
+	}
+
 	priv = netdev_priv(dev);
 	priv->ndev = dev;
+
 	if (sizeof_card)
 		priv->card = (void *)((unsigned long)priv
 				      + sizeof(struct orinoco_private));
@@ -2547,6 +2568,7 @@ struct net_device
 	priv->dev = device;
 
 	/* Setup / override net_device fields */
+	dev->ieee80211_ptr = &priv->wdev;
 	dev->netdev_ops = &orinoco_netdev_ops;
 	dev->watchdog_timeo = HZ; /* 1 second timeout */
 	dev->ethtool_ops = &orinoco_ethtool_ops;
@@ -2588,6 +2610,8 @@ struct net_device
 	/* Register PM notifiers */
 	orinoco_register_pm_notifier(priv);
 
+	orinoco_wiphy_init(wiphy, priv);
+
 	return dev;
 }
 EXPORT_SYMBOL(alloc_orinocodev);
@@ -2618,7 +2642,9 @@ void free_orinocodev(struct net_device *dev)
 	kfree(priv->wpa_ie);
 	orinoco_mic_free(priv);
 	orinoco_bss_data_free(priv);
+	wiphy_unregister(priv->wdev.wiphy);
 	free_netdev(dev);
+	wiphy_free(priv->wdev.wiphy);
 }
 EXPORT_SYMBOL(free_orinocodev);
 
diff --git a/drivers/net/wireless/orinoco/orinoco.h b/drivers/net/wireless/orinoco/orinoco.h
index 8e5a72c..afc0f6b 100644
--- a/drivers/net/wireless/orinoco/orinoco.h
+++ b/drivers/net/wireless/orinoco/orinoco.h
@@ -14,6 +14,7 @@
 #include <linux/netdevice.h>
 #include <linux/wireless.h>
 #include <net/iw_handler.h>
+#include <net/cfg80211.h>
 
 #include "hermes.h"
 
@@ -64,9 +65,15 @@ struct firmware;
 struct orinoco_private {
 	void *card;	/* Pointer to card dependent structure */
 	struct device *dev;
+	struct wireless_dev wdev;
 	int (*hard_reset)(struct orinoco_private *);
 	int (*stop_fw)(struct orinoco_private *, int);
 
+	/* cfg80211 */
+	struct ieee80211_supported_band band;
+	struct ieee80211_channel channels[14];
+	struct ieee80211_rate rates[4];
+
 	/* Synchronisation stuff */
 	spinlock_t lock;
 	int hw_unavailable;
diff --git a/drivers/net/wireless/orinoco/wext.c b/drivers/net/wireless/orinoco/wext.c
index 3f08142..7ce471a 100644
--- a/drivers/net/wireless/orinoco/wext.c
+++ b/drivers/net/wireless/orinoco/wext.c
@@ -7,6 +7,7 @@
 #include <linux/wireless.h>
 #include <linux/ieee80211.h>
 #include <net/iw_handler.h>
+#include <net/cfg80211.h>
 
 #include "hermes.h"
 #include "hermes_rid.h"
@@ -87,25 +88,6 @@ static struct iw_statistics *orinoco_get_wireless_stats(struct net_device *dev)
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
@@ -2258,7 +2240,7 @@ static const struct iw_priv_args orinoco_privtab[] = {
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

