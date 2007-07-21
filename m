Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:20213 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761672AbXGUVmL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jul 2007 17:42:11 -0400
From: Daniel Drake <dsd@gentoo.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Cc: kune@deine-taler.de
Subject: [PATCH] zd1211rw: monitor all packets
Message-Id: <20070721214213.550497B409F@zog.reactivated.net>
Date: Sat, 21 Jul 2007 22:42:13 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ulrich Kunitz <kune@deine-taler.de>

While in monitor mode the zd1211rw received only a limited
set of packets. This patch forwards now all packets the device
receives. Notify that while monitoring no FCS checks are done; so
strange packets might appear in the network sniffer of your
choice.

ATTENTION: Support for multiple interfaces on a single ZD1211
device is currently broken. So this code works only on the first
interface.

Here is an example to put the device in monitor mode.

iwconfig wlan0 mode monitor
ifconfig wlan0 up
iwconfig wlan0 channel 10

[dsd@gentoo.org: backport to mainline]
Signed-off-by: Ulrich Kunitz <kune@deine-taler.de>
Signed-off-by: Daniel Drake <dsd@gentoo.org>
---
 zd_chip.h |    5 -----
 zd_mac.c  |   44 ++++++++++++++++++++++++++++++++++++++------
 2 files changed, 38 insertions(+), 11 deletions(-)

Index: linux/drivers/net/wireless/zd1211rw/zd_chip.h
===================================================================
--- linux.orig/drivers/net/wireless/zd1211rw/zd_chip.h
+++ linux/drivers/net/wireless/zd1211rw/zd_chip.h
@@ -871,11 +871,6 @@ static inline int zd_chip_set_basic_rate
 	return r;
 }
 
-static inline int zd_chip_set_rx_filter(struct zd_chip *chip, u32 filter)
-{
-	return zd_iowrite32(chip, CR_RX_FILTER, filter);
-}
-
 int zd_chip_lock_phy_regs(struct zd_chip *chip);
 int zd_chip_unlock_phy_regs(struct zd_chip *chip);
 
Index: linux/drivers/net/wireless/zd1211rw/zd_mac.c
===================================================================
--- linux.orig/drivers/net/wireless/zd1211rw/zd_mac.c
+++ linux/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -161,13 +161,33 @@ void zd_mac_clear(struct zd_mac *mac)
 	ZD_MEMCLEAR(mac, sizeof(struct zd_mac));
 }
 
-static int reset_mode(struct zd_mac *mac)
+static int set_rx_filter(struct zd_mac *mac)
 {
 	struct ieee80211_device *ieee = zd_mac_to_ieee80211(mac);
 	u32 filter = (ieee->iw_mode == IW_MODE_MONITOR) ? ~0 : STA_RX_FILTER;
 	return zd_iowrite32(&mac->chip, CR_RX_FILTER, filter);
 }
 
+static int set_sniffer(struct zd_mac *mac)
+{
+	struct ieee80211_device *ieee = zd_mac_to_ieee80211(mac);
+	return zd_iowrite32(&mac->chip, CR_SNIFFER_ON,
+		ieee->iw_mode == IW_MODE_MONITOR ? 1 : 0);
+	return 0;
+}
+
+static int set_mc_hash(struct zd_mac *mac)
+{
+	struct zd_mc_hash hash;
+	struct ieee80211_device *ieee = zd_mac_to_ieee80211(mac);
+
+	zd_mc_clear(&hash);
+	if (ieee->iw_mode == IW_MODE_MONITOR)
+		zd_mc_add_all(&hash);
+
+	return zd_chip_set_multicast_hash(&mac->chip, &hash);
+}
+
 int zd_mac_open(struct net_device *netdev)
 {
 	struct zd_mac *mac = zd_netdev_mac(netdev);
@@ -194,7 +214,13 @@ int zd_mac_open(struct net_device *netde
 	r = zd_chip_set_basic_rates(chip, CR_RATES_80211B | CR_RATES_80211G);
 	if (r < 0)
 		goto disable_int;
-	r = reset_mode(mac);
+	r = set_rx_filter(mac);
+	if (r)
+		goto disable_int;
+	r = set_sniffer(mac);
+	if (r)
+		goto disable_int;
+	r = set_mc_hash(mac);
 	if (r)
 		goto disable_int;
 	r = zd_chip_switch_radio_on(chip);
@@ -298,12 +324,14 @@ static void set_multicast_hash_handler(s
 
 void zd_mac_set_multicast_list(struct net_device *dev)
 {
-	struct zd_mc_hash hash;
 	struct zd_mac *mac = zd_netdev_mac(dev);
+	struct ieee80211_device *ieee = zd_mac_to_ieee80211(mac);
+	struct zd_mc_hash hash;
 	struct dev_mc_list *mc;
 	unsigned long flags;
 
-	if (dev->flags & (IFF_PROMISC|IFF_ALLMULTI)) {
+	if (dev->flags & (IFF_PROMISC|IFF_ALLMULTI) ||
+			ieee->iw_mode == IW_MODE_MONITOR) {
 		zd_mc_add_all(&hash);
 	} else {
 		zd_mc_clear(&hash);
@@ -628,8 +656,12 @@ int zd_mac_set_mode(struct zd_mac *mac, 
 	ieee->iw_mode = mode;
 	spin_unlock_irq(&ieee->lock);
 
-	if (netif_running(mac->netdev))
-		return reset_mode(mac);
+	if (netif_running(mac->netdev)) {
+		int r = set_rx_filter(mac);
+		if (r)
+			return r;
+		return set_sniffer(mac);
+	}
 
 	return 0;
 }
