Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:46030 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764910AbXHOO7Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 10:59:16 -0400
Message-Id: <20070815145049.384297000@sipsolutions.net>
References: <20070815144920.135826000@sipsolutions.net>
Date: Wed, 15 Aug 2007 16:49:38 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 18/20] mac80211, drivers: remove reset callback
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The callback isn't used so remove it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 drivers/net/wireless/adm8211.c   |   38 --------------------------------------
 drivers/net/wireless/b43/main.c  |   18 ------------------
 drivers/net/wireless/rt2400pci.c |    1 -
 drivers/net/wireless/rt2500pci.c |    1 -
 drivers/net/wireless/rt2500usb.c |    1 -
 drivers/net/wireless/rt2x00mac.c |    1 -
 drivers/net/wireless/rt61pci.c   |    1 -
 drivers/net/wireless/rt73usb.c   |    1 -
 include/net/mac80211.h           |    3 ---
 9 files changed, 65 deletions(-)

--- wireless-dev.orig/include/net/mac80211.h	2007-08-15 14:19:48.856516958 +0200
+++ wireless-dev/include/net/mac80211.h	2007-08-15 14:26:51.666516958 +0200
@@ -551,9 +551,6 @@ struct ieee80211_ops {
 	int (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb,
 		  struct ieee80211_tx_control *control);
 
-	/* Handler for performing hardware reset. */
-	int (*reset)(struct ieee80211_hw *hw);
-
 	/* Handler that is called when any netdevice attached to the hardware
 	 * device is set UP for the first time. This can be used, e.g., to
 	 * enable interrupts and beacon sending. */
--- wireless-dev.orig/drivers/net/wireless/adm8211.c	2007-08-15 14:04:47.026516958 +0200
+++ wireless-dev/drivers/net/wireless/adm8211.c	2007-08-15 14:26:51.696516958 +0200
@@ -1643,43 +1643,6 @@ static int adm8211_stop(struct ieee80211
 	return 0;
 }
 
-static int adm8211_reset(struct ieee80211_hw *dev)
-{
-	struct adm8211_priv *priv = dev->priv;
-	int retval = 0;
-
-	priv->nar = 0;
-	ADM8211_CSR_WRITE(NAR, 0);
-	ADM8211_CSR_WRITE(IER, 0);
-	ADM8211_CSR_READ(NAR);
-
-	adm8211_free_rings(dev);
-
-	retval = adm8211_hw_reset(dev);
-	if (retval) {
-		printk(KERN_ERR "%s: hardware reset failed\n",
-		       wiphy_name(dev->wiphy));
-		goto fail;
-	}
-
-	retval = adm8211_init_rings(dev);
-	if (retval) {
-		printk(KERN_ERR "%s: failed to initialize rings\n",
-		       wiphy_name(dev->wiphy));
-		goto fail;
-	}
-
-	adm8211_hw_init(dev);
-	adm8211_rf_set_channel(dev, priv->channel);
-
-	ADM8211_CSR_WRITE(IER, ADM8211_INTMASK);
-	adm8211_update_mode(dev);
-	ADM8211_CSR_WRITE(RDR, 0);
-
-fail:
-	return retval;
-}
-
 static void adm8211_calc_durations(int *dur, int *plcp, size_t payload_len, int len,
 				   int plcp_signal, int short_preamble)
 {
@@ -1878,7 +1841,6 @@ static int adm8211_alloc_rings(struct ie
 
 static const struct ieee80211_ops adm8211_ops = {
 	.tx			= adm8211_tx,
-	.reset			= adm8211_reset,
 	.open			= adm8211_open,
 	.stop			= adm8211_stop,
 	.add_interface		= adm8211_add_interface,
--- wireless-dev.orig/drivers/net/wireless/b43/main.c	2007-08-15 14:04:42.366516958 +0200
+++ wireless-dev/drivers/net/wireless/b43/main.c	2007-08-15 14:26:51.706516958 +0200
@@ -2536,23 +2536,6 @@ static int b43_get_stats(struct ieee8021
 	return 0;
 }
 
-static int b43_dev_reset(struct ieee80211_hw *hw)
-{
-	struct b43_wl *wl = hw_to_b43_wl(hw);
-	struct b43_wldev *dev;
-	int err = -ENODEV;
-
-	mutex_lock(&wl->mutex);
-	dev = wl->current_dev;
-	if (dev) {
-		b43_controller_restart(dev, "Reset by ieee80211 subsystem");
-		err = 0;
-	}
-	mutex_unlock(&wl->mutex);
-
-	return 0;
-}
-
 static const char *phymode_to_string(unsigned int phymode)
 {
 	switch (phymode) {
@@ -3485,7 +3468,6 @@ static const struct ieee80211_ops b43_hw
 	.conf_tx = b43_conf_tx,
 	.add_interface = b43_add_interface,
 	.remove_interface = b43_remove_interface,
-	.reset = b43_dev_reset,
 	.config = b43_dev_config,
 	.config_interface = b43_config_interface,
 	.set_multicast_list = b43_set_multicast_list,
--- wireless-dev.orig/drivers/net/wireless/rt2400pci.c	2007-08-15 14:04:41.066516958 +0200
+++ wireless-dev/drivers/net/wireless/rt2400pci.c	2007-08-15 14:26:51.706516958 +0200
@@ -1589,7 +1589,6 @@ static int rt2400pci_tx_last_beacon(stru
 
 static const struct ieee80211_ops rt2400pci_mac80211_ops = {
 	.tx			= rt2x00mac_tx,
-	.reset			= rt2x00mac_reset,
 	.add_interface		= rt2x00mac_add_interface,
 	.remove_interface	= rt2x00mac_remove_interface,
 	.config			= rt2x00mac_config,
--- wireless-dev.orig/drivers/net/wireless/rt2500pci.c	2007-08-15 14:04:41.126516958 +0200
+++ wireless-dev/drivers/net/wireless/rt2500pci.c	2007-08-15 14:26:51.706516958 +0200
@@ -1824,7 +1824,6 @@ static int rt2500pci_tx_last_beacon(stru
 
 static const struct ieee80211_ops rt2500pci_mac80211_ops = {
 	.tx			= rt2x00mac_tx,
-	.reset			= rt2x00mac_reset,
 	.add_interface		= rt2x00mac_add_interface,
 	.remove_interface	= rt2x00mac_remove_interface,
 	.config			= rt2x00mac_config,
--- wireless-dev.orig/drivers/net/wireless/rt2500usb.c	2007-08-15 14:04:41.156516958 +0200
+++ wireless-dev/drivers/net/wireless/rt2500usb.c	2007-08-15 14:26:51.726516958 +0200
@@ -1512,7 +1512,6 @@ static int rt2500usb_probe_hw(struct rt2
  */
 static const struct ieee80211_ops rt2500usb_mac80211_ops = {
 	.tx			= rt2x00mac_tx,
-	.reset			= rt2x00mac_reset,
 	.add_interface		= rt2x00mac_add_interface,
 	.remove_interface	= rt2x00mac_remove_interface,
 	.config			= rt2x00mac_config,
--- wireless-dev.orig/drivers/net/wireless/rt2x00mac.c	2007-08-15 14:04:41.176516958 +0200
+++ wireless-dev/drivers/net/wireless/rt2x00mac.c	2007-08-15 14:26:51.726516958 +0200
@@ -166,7 +166,6 @@ exit:
 
 	return retval;
 }
-EXPORT_SYMBOL_GPL(rt2x00mac_reset);
 
 int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 			    struct ieee80211_if_init_conf *conf)
--- wireless-dev.orig/drivers/net/wireless/rt61pci.c	2007-08-15 14:04:41.246516958 +0200
+++ wireless-dev/drivers/net/wireless/rt61pci.c	2007-08-15 14:26:51.726516958 +0200
@@ -2340,7 +2340,6 @@ static void rt61pci_reset_tsf(struct iee
 
 static const struct ieee80211_ops rt61pci_mac80211_ops = {
 	.tx			= rt2x00mac_tx,
-	.reset			= rt2x00mac_reset,
 	.add_interface		= rt2x00mac_add_interface,
 	.remove_interface	= rt2x00mac_remove_interface,
 	.config			= rt2x00mac_config,
--- wireless-dev.orig/drivers/net/wireless/rt73usb.c	2007-08-15 14:04:41.296516958 +0200
+++ wireless-dev/drivers/net/wireless/rt73usb.c	2007-08-15 14:26:51.736516958 +0200
@@ -1813,7 +1813,6 @@ static void rt73usb_reset_tsf(struct iee
 
 static const struct ieee80211_ops rt73usb_mac80211_ops = {
 	.tx			= rt2x00mac_tx,
-	.reset			= rt2x00mac_reset,
 	.add_interface		= rt2x00mac_add_interface,
 	.remove_interface	= rt2x00mac_remove_interface,
 	.config			= rt2x00mac_config,

-- 

