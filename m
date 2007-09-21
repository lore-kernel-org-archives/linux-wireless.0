Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43610 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757313AbXIUTgB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2007 15:36:01 -0400
Date: Fri, 21 Sep 2007 14:36:34 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] b43legacy: Fix for configure_filters API change
Message-ID: <46f41d42.uzjp/RiAuxR7MBNi%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch modifies b43legacy for the config_filters API change in
mac80211.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Michael,

With this patch, the b43legacy driver works with both WEP and WPA. The patch
is made against the latest net-2.6.24 tree plus all of your patches from
<http://aluminum.sourmilk.net/pending-mac80211.tar.bz2>. Thanks for sending
me the copy of Johannes's b43 patch. It was very helpful.

Larry
---

 drivers/net/wireless/b43legacy/b43legacy.h |   20 --
 drivers/net/wireless/b43legacy/main.c      |  245 +++++++++++++++--------------
 2 files changed, 139 insertions(+), 126 deletions(-)
finger@larrylap:/home/finger/net-2.6.24>

Index: net-2.6.24/drivers/net/wireless/b43legacy/b43legacy.h
===================================================================
--- net-2.6.24.orig/drivers/net/wireless/b43legacy/b43legacy.h
+++ net-2.6.24/drivers/net/wireless/b43legacy/b43legacy.h
@@ -179,6 +179,7 @@
 #define B43legacy_MACCTL_IHR_ENABLED	0x00000400 /* IHR Region Enabled */
 #define B43legacy_MACCTL_INFRA		0x00020000 /* Infrastructure mode */
 #define B43legacy_MACCTL_AP		0x00040000 /* AccessPoint mode */
+#define B43legacy_MACCTL_BEACPROMISC	0x00100000 /* Beacon Promiscuous */
 #define B43legacy_MACCTL_KEEP_BADPLCP	0x00200000 /* Keep bad PLCP frames */
 #define B43legacy_MACCTL_KEEP_CTL	0x00400000 /* Keep control frames */
 #define B43legacy_MACCTL_KEEP_BAD	0x00800000 /* Keep bad frames (FCS) */
@@ -561,25 +562,20 @@ struct b43legacy_wl {
 	 * at a time. General information about this interface follows.
 	 */
 
-	/* Opaque ID of the operating interface (!= monitor
-	 * interface) from the ieee80211 subsystem.
-	 * Do not modify.
+	/* Opaque ID of the operating interface from the ieee80211
+	 * subsystem. Do not modify.
 	 */
 	int if_id;
 	/* MAC address (can be NULL). */
-	const u8 *mac_addr;
+	u8 mac_addr[ETH_ALEN];
 	/* Current BSSID (can be NULL). */
-	const u8 *bssid;
+	u8 bssid[ETH_ALEN];
 	/* Interface type. (IEEE80211_IF_TYPE_XXX) */
 	int if_type;
-	/* Counter of active monitor interfaces. */
-	int monitor;
 	/* Is the card operating in AP, STA or IBSS mode? */
 	bool operating;
-	/* Promisc mode active?
-	 * Note that (monitor != 0) implies promisc.
-	 */
-	bool promisc;
+	/* filter flags */
+	unsigned int filter_flags;
 	/* Stats about the wireless interface */
 	struct ieee80211_low_level_stats ieee_stats;
 
@@ -744,8 +740,6 @@ struct b43legacy_wldev *dev_to_b43legacy
 static inline
 int b43legacy_is_mode(struct b43legacy_wl *wl, int type)
 {
-	if (type == IEEE80211_IF_TYPE_MNTR)
-		return !!(wl->monitor);
 	return (wl->operating &&
 		wl->if_type == type);
 }
Index: net-2.6.24/drivers/net/wireless/b43legacy/main.c
===================================================================
--- net-2.6.24.orig/drivers/net/wireless/b43legacy/main.c
+++ net-2.6.24/drivers/net/wireless/b43legacy/main.c
@@ -91,14 +91,6 @@ static char modparam_fwpostfix[16];
 module_param_string(fwpostfix, modparam_fwpostfix, 16, 0444);
 MODULE_PARM_DESC(fwpostfix, "Postfix for the firmware files to load.");
 
-static int modparam_mon_keep_bad;
-module_param_named(mon_keep_bad, modparam_mon_keep_bad, int, 0444);
-MODULE_PARM_DESC(mon_keep_bad, "Keep bad frames in monitor mode");
-
-static int modparam_mon_keep_badplcp;
-module_param_named(mon_keep_badplcp, modparam_mon_keep_bad, int, 0444);
-MODULE_PARM_DESC(mon_keep_badplcp, "Keep frames with bad PLCP in monitor mode");
-
 /* The following table supports BCM4301, BCM4303 and BCM4306/2 devices. */
 static const struct ssb_device_id b43legacy_ssb_tbl[] = {
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 2),
@@ -567,12 +559,11 @@ static void b43legacy_write_mac_bssid_te
 	}
 }
 
-static void b43legacy_upload_card_macaddress(struct b43legacy_wldev *dev,
-					     const u8 *mac_addr)
+static void b43legacy_upload_card_macaddress(struct b43legacy_wldev *dev)
 {
-	dev->wl->mac_addr = mac_addr;
 	b43legacy_write_mac_bssid_templates(dev);
-	b43legacy_macfilter_set(dev, B43legacy_MACFILTER_SELF, mac_addr);
+	b43legacy_macfilter_set(dev, B43legacy_MACFILTER_SELF,
+				dev->wl->mac_addr);
 }
 
 static void b43legacy_set_slot_time(struct b43legacy_wldev *dev,
@@ -1875,34 +1866,25 @@ static void b43legacy_adjust_opmode(stru
 	ctl &= ~B43legacy_MACCTL_KEEP_BADPLCP;
 	ctl &= ~B43legacy_MACCTL_KEEP_BAD;
 	ctl &= ~B43legacy_MACCTL_PROMISC;
+	ctl &= ~B43legacy_MACCTL_BEACPROMISC;
 	ctl |= B43legacy_MACCTL_INFRA;
 
-	if (wl->operating) {
-		switch (wl->if_type) {
-		case IEEE80211_IF_TYPE_AP:
-			ctl |= B43legacy_MACCTL_AP;
-			break;
-		case IEEE80211_IF_TYPE_IBSS:
-			ctl &= ~B43legacy_MACCTL_INFRA;
-			break;
-		case IEEE80211_IF_TYPE_STA:
-		case IEEE80211_IF_TYPE_MNTR:
-		case IEEE80211_IF_TYPE_WDS:
-			break;
-		default:
-			b43legacyerr(wl, "Improper value of %d for"
-				     " wl->if_type\n", wl->if_type);
-		}
-	}
-	if (wl->monitor) {
+	if (b43legacy_is_mode(wl, IEEE80211_IF_TYPE_AP))
+		ctl |= B43legacy_MACCTL_AP;
+	else if (b43legacy_is_mode(wl, IEEE80211_IF_TYPE_IBSS))
+		ctl &= ~B43legacy_MACCTL_INFRA;
+
+	if (wl->filter_flags & FIF_CONTROL)
 		ctl |= B43legacy_MACCTL_KEEP_CTL;
-		if (modparam_mon_keep_bad)
-			ctl |= B43legacy_MACCTL_KEEP_BAD;
-		if (modparam_mon_keep_badplcp)
-			ctl |= B43legacy_MACCTL_KEEP_BADPLCP;
-	}
-	if (wl->promisc)
+	if (wl->filter_flags & FIF_FCSFAIL)
+		ctl |= B43legacy_MACCTL_KEEP_BAD;
+	if (wl->filter_flags & FIF_PLCPFAIL)
+		ctl |= B43legacy_MACCTL_KEEP_BADPLCP;
+	if (wl->filter_flags & FIF_PROMISC_IN_BSS)
 		ctl |= B43legacy_MACCTL_PROMISC;
+	if (wl->filter_flags & FIF_BCN_PRBRESP_PROMISC)
+		ctl |= B43legacy_MACCTL_BEACPROMISC;
+
 	/* Workaround: On old hardware the HW-MAC-address-filter
 	 * doesn't work properly, so always run promisc in filter
 	 * it in software. */
@@ -2080,10 +2062,6 @@ static int b43legacy_chip_init(struct b4
 	value32 |= B43legacy_SBF_MODE_NOTADHOC;
 	b43legacy_write32(dev, B43legacy_MMIO_STATUS_BITFIELD, value32);
 
-	value32 = b43legacy_read32(dev, B43legacy_MMIO_STATUS_BITFIELD);
-	value32 |= 0x100000;
-	b43legacy_write32(dev, B43legacy_MMIO_STATUS_BITFIELD, value32);
-
 	if (b43legacy_using_pio(dev)) {
 		b43legacy_write32(dev, 0x0210, 0x00000100);
 		b43legacy_write32(dev, 0x0230, 0x00000100);
@@ -2672,7 +2650,7 @@ out_unlock_mutex:
 }
 
 static int b43legacy_dev_set_key(struct ieee80211_hw *hw,
-				 set_key_cmd cmd,
+				 enum set_key_cmd cmd,
 				 const u8 *local_addr, const u8 *addr,
 				 struct ieee80211_key_conf *key)
 {
@@ -2697,22 +2675,42 @@ static int b43legacy_dev_set_key(struct 
 	return err;
 }
 
-static void b43legacy_set_multicast_list(struct ieee80211_hw *hw,
-					 unsigned short netflags,
-					 int mc_count)
+static void b43legacy_configure_filter(struct ieee80211_hw *hw,
+				       unsigned int changed,
+				       unsigned int *fflags,
+				       int mc_count,
+				       struct dev_addr_list *mc_list)
 {
 	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
 	struct b43legacy_wldev *dev = wl->current_dev;
 	unsigned long flags;
 
-	if (!dev)
+	if (!dev) {
+		*fflags = 0;
 		return;
-	spin_lock_irqsave(&wl->irq_lock, flags);
-	if (wl->promisc != !!(netflags & IFF_PROMISC)) {
-		wl->promisc = !!(netflags & IFF_PROMISC);
-		if (b43legacy_status(dev) >= B43legacy_STAT_INITIALIZED)
-			b43legacy_adjust_opmode(dev);
 	}
+
+	spin_lock_irqsave(&wl->irq_lock, flags);
+	*fflags &= FIF_PROMISC_IN_BSS |
+		  FIF_ALLMULTI |
+		  FIF_FCSFAIL |
+		  FIF_PLCPFAIL |
+		  FIF_CONTROL |
+		  FIF_OTHER_BSS |
+		  FIF_BCN_PRBRESP_PROMISC;
+
+	changed &= FIF_PROMISC_IN_BSS |
+		   FIF_ALLMULTI |
+		   FIF_FCSFAIL |
+		   FIF_PLCPFAIL |
+		   FIF_CONTROL |
+		   FIF_OTHER_BSS |
+		   FIF_BCN_PRBRESP_PROMISC;
+
+	wl->filter_flags = *fflags;
+
+	if (changed && b43legacy_status(dev) >= B43legacy_STAT_INITIALIZED)
+		b43legacy_adjust_opmode(dev);
 	spin_unlock_irqrestore(&wl->irq_lock, flags);
 }
 
@@ -2728,21 +2726,19 @@ static int b43legacy_config_interface(st
 		return -ENODEV;
 	mutex_lock(&wl->mutex);
 	spin_lock_irqsave(&wl->irq_lock, flags);
-	if (conf->type != IEEE80211_IF_TYPE_MNTR) {
-		B43legacy_WARN_ON(wl->if_id != if_id);
-		wl->bssid = conf->bssid;
-		if (b43legacy_status(dev) >= B43legacy_STAT_INITIALIZED) {
-			if (b43legacy_is_mode(wl, IEEE80211_IF_TYPE_AP)) {
-				B43legacy_WARN_ON(conf->type !=
-						  IEEE80211_IF_TYPE_AP);
-				b43legacy_set_ssid(dev, conf->ssid,
-						   conf->ssid_len);
-				if (conf->beacon)
-					b43legacy_refresh_templates(dev,
-								 conf->beacon);
-			}
-			b43legacy_write_mac_bssid_templates(dev);
+	B43legacy_WARN_ON(wl->if_id != if_id);
+	if (conf->bssid)
+		memcpy(wl->bssid, conf->bssid, ETH_ALEN);
+	else
+		memset(wl->bssid, 0, ETH_ALEN);
+	if (b43legacy_status(dev) >= B43legacy_STAT_INITIALIZED) {
+		if (b43legacy_is_mode(wl, IEEE80211_IF_TYPE_AP)) {
+			B43legacy_WARN_ON(conf->type != IEEE80211_IF_TYPE_AP);
+			b43legacy_set_ssid(dev, conf->ssid, conf->ssid_len);
+			if (conf->beacon)
+				b43legacy_refresh_templates(dev, conf->beacon);
 		}
+		b43legacy_write_mac_bssid_templates(dev);
 	}
 	spin_unlock_irqrestore(&wl->irq_lock, flags);
 	mutex_unlock(&wl->mutex);
@@ -3186,8 +3182,9 @@ static int b43legacy_wireless_core_init(
 	b43legacy_shm_write16(dev, B43legacy_SHM_SHARED, 0x0414, 0x01F4);
 
 	ssb_bus_powerup(bus, 1); /* Enable dynamic PCTL */
-	wl->bssid = NULL;
-	b43legacy_upload_card_macaddress(dev, NULL);
+	memset(wl->bssid, 0, ETH_ALEN);
+	memset(wl->mac_addr, 0, ETH_ALEN);
+	b43legacy_upload_card_macaddress(dev);
 	b43legacy_security_init(dev);
 	b43legacy_rng_init(wl);
 
@@ -3216,22 +3213,80 @@ static int b43legacy_add_interface(struc
 	struct b43legacy_wldev *dev;
 	unsigned long flags;
 	int err = -EOPNOTSUPP;
-	int did_init = 0;
+
+	/* TODO: allow WDS/AP devices to coexist */
+
+	if (conf->type != IEEE80211_IF_TYPE_AP &&
+	    conf->type != IEEE80211_IF_TYPE_STA &&
+	    conf->type != IEEE80211_IF_TYPE_WDS &&
+	    conf->type != IEEE80211_IF_TYPE_IBSS)
+		return -EOPNOTSUPP;
 
 	mutex_lock(&wl->mutex);
-	if ((conf->type != IEEE80211_IF_TYPE_MNTR) &&
-	    wl->operating)
+	if (wl->operating)
 		goto out_mutex_unlock;
 
 	b43legacydbg(wl, "Adding Interface type %d\n", conf->type);
 
 	dev = wl->current_dev;
+	wl->operating = 1;
+	wl->if_id = conf->if_id;
+	wl->if_type = conf->type;
+	memcpy(wl->mac_addr, conf->mac_addr, ETH_ALEN);
+
+	spin_lock_irqsave(&wl->irq_lock, flags);
+	b43legacy_adjust_opmode(dev);
+	b43legacy_upload_card_macaddress(dev);
+	spin_unlock_irqrestore(&wl->irq_lock, flags);
+
+	err = 0;
+ out_mutex_unlock:
+	mutex_unlock(&wl->mutex);
+
+	return err;
+}
+
+static void b43legacy_remove_interface(struct ieee80211_hw *hw,
+				       struct ieee80211_if_init_conf *conf)
+{
+	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
+	struct b43legacy_wldev *dev = wl->current_dev;
+	unsigned long flags;
+
+	b43legacydbg(wl, "Removing Interface type %d\n", conf->type);
+
+	mutex_lock(&wl->mutex);
+
+	B43legacy_WARN_ON(!wl->operating);
+	B43legacy_WARN_ON(wl->if_id != conf->if_id);
+
+	wl->operating = 0;
+
+	spin_lock_irqsave(&wl->irq_lock, flags);
+	b43legacy_adjust_opmode(dev);
+	memset(wl->mac_addr, 0, ETH_ALEN);
+	b43legacy_upload_card_macaddress(dev);
+	spin_unlock_irqrestore(&wl->irq_lock, flags);
+
+	mutex_unlock(&wl->mutex);
+}
+
+static int b43legacy_start(struct ieee80211_hw *hw)
+{
+	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
+	struct b43legacy_wldev *dev = wl->current_dev;
+	int did_init = 0;
+	int err;
+
+	mutex_lock(&wl->mutex);
+
 	if (b43legacy_status(dev) < B43legacy_STAT_INITIALIZED) {
 		err = b43legacy_wireless_core_init(dev);
 		if (err)
 			goto out_mutex_unlock;
 		did_init = 1;
 	}
+
 	if (b43legacy_status(dev) < B43legacy_STAT_STARTED) {
 		err = b43legacy_wireless_core_start(dev);
 		if (err) {
@@ -3241,59 +3296,21 @@ static int b43legacy_add_interface(struc
 		}
 	}
 
-	spin_lock_irqsave(&wl->irq_lock, flags);
-	switch (conf->type) {
-	case IEEE80211_IF_TYPE_MNTR:
-		wl->monitor++;
-		break;
-	default:
-		wl->operating = 1;
-		wl->if_id = conf->if_id;
-		wl->if_type = conf->type;
-		b43legacy_upload_card_macaddress(dev, conf->mac_addr);
-	}
-	b43legacy_adjust_opmode(dev);
-	spin_unlock_irqrestore(&wl->irq_lock, flags);
-
-	err = 0;
 out_mutex_unlock:
 	mutex_unlock(&wl->mutex);
 
 	return err;
 }
 
-static void b43legacy_remove_interface(struct ieee80211_hw *hw,
-				       struct ieee80211_if_init_conf *conf)
+void b43legacy_stop(struct ieee80211_hw *hw)
 {
 	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
-	struct b43legacy_wldev *dev;
-	unsigned long flags;
-
-	b43legacydbg(wl, "Removing Interface type %d\n", conf->type);
+	struct b43legacy_wldev *dev = wl->current_dev;
 
 	mutex_lock(&wl->mutex);
-	if (conf->type == IEEE80211_IF_TYPE_MNTR) {
-		wl->monitor--;
-		B43legacy_WARN_ON(wl->monitor < 0);
-	} else {
-		B43legacy_WARN_ON(!wl->operating);
-		wl->operating = 0;
-	}
-
-	dev = wl->current_dev;
-	if (!wl->operating && wl->monitor == 0) {
-		/* No interface left. */
-		if (b43legacy_status(dev) >= B43legacy_STAT_STARTED)
-			b43legacy_wireless_core_stop(dev);
-		b43legacy_wireless_core_exit(dev);
-	} else {
-		/* Just monitor interfaces left. */
-		spin_lock_irqsave(&wl->irq_lock, flags);
-		b43legacy_adjust_opmode(dev);
-		if (!wl->operating)
-			b43legacy_upload_card_macaddress(dev, NULL);
-		spin_unlock_irqrestore(&wl->irq_lock, flags);
-	}
+	if (b43legacy_status(dev) >= B43legacy_STAT_STARTED)
+		b43legacy_wireless_core_stop(dev);
+	b43legacy_wireless_core_exit(dev);
 	mutex_unlock(&wl->mutex);
 }
 
@@ -3306,9 +3323,11 @@ static const struct ieee80211_ops b43leg
 	.config = b43legacy_dev_config,
 	.config_interface = b43legacy_config_interface,
 	.set_key = b43legacy_dev_set_key,
-	.set_multicast_list = b43legacy_set_multicast_list,
+	.configure_filter = b43legacy_configure_filter,
 	.get_stats = b43legacy_get_stats,
 	.get_tx_stats = b43legacy_get_tx_stats,
+	.start = b43legacy_start,
+	.stop = b43legacy_stop,
 };
 
 /* Hard-reset the chip. Do not call this directly.

