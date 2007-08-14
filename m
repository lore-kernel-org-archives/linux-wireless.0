Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60850 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbXHOKm6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 06:42:58 -0400
Subject: [PATCH] mac80211: remove reset callback
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain
Date: Wed, 15 Aug 2007 01:13:29 +0200
Message-Id: <1187133209.31200.30.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somebody (I think it was Uli) recently complained about this callback so
when I just remembered that I went and looked where it is used. Guess
what: nowhere. I think it was at one point used in the tx timeout
handler but that should probably do something else anyway.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 drivers/net/wireless/adm8211.c   |   38 --------------------------------------
 drivers/net/wireless/b43/main.c  |   16 ----------------
 drivers/net/wireless/rt2400pci.c |    1 -
 drivers/net/wireless/rt2500pci.c |    1 -
 drivers/net/wireless/rt2500usb.c |    1 -
 drivers/net/wireless/rt2x00mac.c |    1 -
 drivers/net/wireless/rt61pci.c   |    1 -
 drivers/net/wireless/rt73usb.c   |    1 -
 include/net/mac80211.h           |    3 ---
 9 files changed, 63 deletions(-)

--- wireless-dev.orig/include/net/mac80211.h	2007-08-15 01:02:15.440200043 +0200
+++ wireless-dev/include/net/mac80211.h	2007-08-15 01:02:20.420200043 +0200
@@ -564,9 +564,6 @@ struct ieee80211_ops {
 	int (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb,
 		  struct ieee80211_tx_control *control);
 
-	/* Handler for performing hardware reset. */
-	int (*reset)(struct ieee80211_hw *hw);
-
 	/*
 	 * Called before the first netdevice attached to the hardware
 	 * is enabled. This should turn on the hardware and must turn on
--- wireless-dev.orig/drivers/net/wireless/adm8211.c	2007-08-15 01:03:30.840200043 +0200
+++ wireless-dev/drivers/net/wireless/adm8211.c	2007-08-15 01:03:46.450200043 +0200
@@ -1648,43 +1648,6 @@ static void adm8211_stop(struct ieee8021
 	adm8211_free_rings(dev);
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
@@ -1883,7 +1846,6 @@ static int adm8211_alloc_rings(struct ie
 
 static const struct ieee80211_ops adm8211_ops = {
 	.tx			= adm8211_tx,
-	.reset			= adm8211_reset,
 	.start			= adm8211_start,
 	.stop			= adm8211_stop,
 	.add_interface		= adm8211_add_interface,
--- wireless-dev.orig/drivers/net/wireless/b43/main.c	2007-08-15 01:03:31.340200043 +0200
+++ wireless-dev/drivers/net/wireless/b43/main.c	2007-08-15 01:04:28.440200043 +0200
@@ -2515,21 +2515,6 @@ static int b43_get_stats(struct ieee8021
 	return 0;
 }
 
-static int b43_dev_reset(struct ieee80211_hw *hw)
-{
-	struct b43_wl *wl = hw_to_b43_wl(hw);
-	struct b43_wldev *dev = wl->current_dev;
-	unsigned long flags;
-
-	if (!dev)
-		return -ENODEV;
-	spin_lock_irqsave(&wl->irq_lock, flags);
-	b43_controller_restart(dev, "Reset by ieee80211 subsystem");
-	spin_unlock_irqrestore(&wl->irq_lock, flags);
-
-	return 0;
-}
-
 static const char *phymode_to_string(unsigned int phymode)
 {
 	switch (phymode) {
@@ -3498,7 +3483,6 @@ static const struct ieee80211_ops b43_hw
 	.conf_tx = b43_conf_tx,
 	.add_interface = b43_add_interface,
 	.remove_interface = b43_remove_interface,
-	.reset = b43_dev_reset,
 	.config = b43_dev_config,
 	.config_interface = b43_config_interface,
 	.change_filter_flags = b43_change_filter_flags,
--- wireless-dev.orig/drivers/net/wireless/rt2400pci.c	2007-08-15 01:03:31.450200043 +0200
+++ wireless-dev/drivers/net/wireless/rt2400pci.c	2007-08-15 01:04:34.190200043 +0200
@@ -1589,7 +1589,6 @@ static int rt2400pci_tx_last_beacon(stru
 
 static const struct ieee80211_ops rt2400pci_mac80211_ops = {
 	.tx			= rt2x00mac_tx,
-	.reset			= rt2x00mac_reset,
 	.add_interface		= rt2x00mac_add_interface,
 	.remove_interface	= rt2x00mac_remove_interface,
 	.config			= rt2x00mac_config,
--- wireless-dev.orig/drivers/net/wireless/rt2500pci.c	2007-08-15 01:03:31.780200043 +0200
+++ wireless-dev/drivers/net/wireless/rt2500pci.c	2007-08-15 01:04:52.770200043 +0200
@@ -1824,7 +1824,6 @@ static int rt2500pci_tx_last_beacon(stru
 
 static const struct ieee80211_ops rt2500pci_mac80211_ops = {
 	.tx			= rt2x00mac_tx,
-	.reset			= rt2x00mac_reset,
 	.add_interface		= rt2x00mac_add_interface,
 	.remove_interface	= rt2x00mac_remove_interface,
 	.config			= rt2x00mac_config,
--- wireless-dev.orig/drivers/net/wireless/rt2500usb.c	2007-08-15 01:03:31.890200043 +0200
+++ wireless-dev/drivers/net/wireless/rt2500usb.c	2007-08-15 01:04:57.060200043 +0200
@@ -1512,7 +1512,6 @@ static int rt2500usb_probe_hw(struct rt2
  */
 static const struct ieee80211_ops rt2500usb_mac80211_ops = {
 	.tx			= rt2x00mac_tx,
-	.reset			= rt2x00mac_reset,
 	.add_interface		= rt2x00mac_add_interface,
 	.remove_interface	= rt2x00mac_remove_interface,
 	.config			= rt2x00mac_config,
--- wireless-dev.orig/drivers/net/wireless/rt2x00mac.c	2007-08-15 01:06:13.540200043 +0200
+++ wireless-dev/drivers/net/wireless/rt2x00mac.c	2007-08-15 01:06:19.730200043 +0200
@@ -166,7 +166,6 @@ exit:
 
 	return retval;
 }
-EXPORT_SYMBOL_GPL(rt2x00mac_reset);
 
 int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 			    struct ieee80211_if_init_conf *conf)
--- wireless-dev.orig/drivers/net/wireless/rt61pci.c	2007-08-15 01:03:31.060200043 +0200
+++ wireless-dev/drivers/net/wireless/rt61pci.c	2007-08-15 01:04:17.350200043 +0200
@@ -2340,7 +2340,6 @@ static void rt61pci_reset_tsf(struct iee
 
 static const struct ieee80211_ops rt61pci_mac80211_ops = {
 	.tx			= rt2x00mac_tx,
-	.reset			= rt2x00mac_reset,
 	.add_interface		= rt2x00mac_add_interface,
 	.remove_interface	= rt2x00mac_remove_interface,
 	.config			= rt2x00mac_config,
--- wireless-dev.orig/drivers/net/wireless/rt73usb.c	2007-08-15 01:03:30.950200043 +0200
+++ wireless-dev/drivers/net/wireless/rt73usb.c	2007-08-15 01:04:08.010200043 +0200
@@ -1813,7 +1813,6 @@ static void rt73usb_reset_tsf(struct iee
 
 static const struct ieee80211_ops rt73usb_mac80211_ops = {
 	.tx			= rt2x00mac_tx,
-	.reset			= rt2x00mac_reset,
 	.add_interface		= rt2x00mac_add_interface,
 	.remove_interface	= rt2x00mac_remove_interface,
 	.config			= rt2x00mac_config,


