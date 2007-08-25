Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:50603
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764382AbXHYACu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2007 20:02:50 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: b43: Copy MAC address to local struct
Date: Sat, 25 Aug 2007 02:00:51 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200708250200.52650.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We must copy the MAC addresses to a local struct, as we
don't own the original pointer from mac80211 and don't
know how mac80211 might mess with it while we are using it.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <larry.finger@lwfinger.net>

Index: wireless-dev-new/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-dev-new.orig/drivers/net/wireless/b43/b43.h	2007-08-25 01:55:33.000000000 +0200
+++ wireless-dev-new/drivers/net/wireless/b43/b43.h	2007-08-25 01:57:30.000000000 +0200
@@ -600,10 +600,10 @@ struct b43_wl {
 	 * Do not modify.
 	 */
 	int if_id;
-	/* MAC address (can be NULL). */
-	const u8 *mac_addr;
-	/* Current BSSID (can be NULL). */
-	const u8 *bssid;
+	/* The MAC address of the operating interface. */
+	u8 mac_addr[ETH_ALEN];
+	/* Current BSSID */
+	u8 bssid[ETH_ALEN];
 	/* Interface type. (IEEE80211_IF_TYPE_XXX) */
 	int if_type;
 	/* Counter of active monitor interfaces. */
Index: wireless-dev-new/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-dev-new.orig/drivers/net/wireless/b43/main.c	2007-08-25 01:56:13.000000000 +0200
+++ wireless-dev-new/drivers/net/wireless/b43/main.c	2007-08-25 01:57:30.000000000 +0200
@@ -537,7 +537,6 @@ void b43_macfilter_set(struct b43_wldev 
 
 static void b43_write_mac_bssid_templates(struct b43_wldev *dev)
 {
-	static const u8 zero_addr[ETH_ALEN] = { 0 };
 	const u8 *mac;
 	const u8 *bssid;
 	u8 mac_bssid[ETH_ALEN * 2];
@@ -545,11 +544,7 @@ static void b43_write_mac_bssid_template
 	u32 tmp;
 
 	bssid = dev->wl->bssid;
-	if (!bssid)
-		bssid = zero_addr;
 	mac = dev->wl->mac_addr;
-	if (!mac)
-		mac = zero_addr;
 
 	b43_macfilter_set(dev, B43_MACFILTER_BSSID, bssid);
 
@@ -569,7 +564,10 @@ static void b43_write_mac_bssid_template
 static void b43_upload_card_macaddress(struct b43_wldev *dev,
 				       const u8 * mac_addr)
 {
-	dev->wl->mac_addr = mac_addr;
+	if (mac_addr)
+		memcpy(dev->wl->mac_addr, mac_addr, ETH_ALEN);
+	else
+		memset(dev->wl->mac_addr, 0, ETH_ALEN);
 	b43_write_mac_bssid_templates(dev);
 	b43_macfilter_set(dev, B43_MACFILTER_SELF, mac_addr);
 }
@@ -3026,7 +3024,10 @@ static int b43_config_interface(struct i
 	spin_lock_irqsave(&wl->irq_lock, flags);
 	if (conf->type != IEEE80211_IF_TYPE_MNTR) {
 		B43_WARN_ON(wl->if_id != if_id);
-		wl->bssid = conf->bssid;
+		if (conf->bssid)
+			memcpy(wl->bssid, conf->bssid, ETH_ALEN);
+		else
+			memset(wl->bssid, 0, ETH_ALEN);
 		if (b43_status(dev) >= B43_STAT_INITIALIZED) {
 			if (b43_is_mode(wl, IEEE80211_IF_TYPE_AP)) {
 				B43_WARN_ON(conf->type != IEEE80211_IF_TYPE_AP);
@@ -3454,7 +3455,7 @@ static int b43_wireless_core_init(struct
 	b43_bluetooth_coext_enable(dev);
 
 	ssb_bus_powerup(bus, 1);	/* Enable dynamic PCTL */
-	wl->bssid = NULL;
+	memset(wl->bssid, 0, ETH_ALEN);
 	b43_upload_card_macaddress(dev, NULL);
 	b43_security_init(dev);
 	b43_rng_init(wl);
