Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:58676 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759949AbYDRTIT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2008 15:08:19 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Fix HostFlags data types
Date: Fri, 18 Apr 2008 21:06:37 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200804182106.37314.mb@bu3sch.de> (sfid-20080418_200823_587695_BECDD861)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The HostFlags are a bitmask of 48bit. So we must use an u64 datatype
to hold all bits.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, this is for 2.6.26.
There is no need to backport this to 2.6.25-stable, as the devices supported
by 2.6.25 don't use the high 16 bits of the HostFlags.


Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-04-18 20:51:13.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2008-04-18 21:00:58.000000000 +0200
@@ -3707,13 +3707,13 @@ static void setup_struct_wldev_for_init(
 	memset(&dev->noisecalc, 0, sizeof(dev->noisecalc));
 }
 
 static void b43_bluetooth_coext_enable(struct b43_wldev *dev)
 {
 	struct ssb_sprom *sprom = &dev->dev->bus->sprom;
-	u32 hf;
+	u64 hf;
 
 	if (!modparam_btcoex)
 		return;
 	if (!(sprom->boardflags_lo & B43_BFL_BTCOEXIST))
 		return;
 	if (dev->phy.type != B43_PHYTYPE_B && !dev->phy.gmode)
@@ -3857,13 +3857,14 @@ static int b43_wireless_core_init(struct
 {
 	struct b43_wl *wl = dev->wl;
 	struct ssb_bus *bus = dev->dev->bus;
 	struct ssb_sprom *sprom = &bus->sprom;
 	struct b43_phy *phy = &dev->phy;
 	int err;
-	u32 hf, tmp;
+	u64 hf;
+	u32 tmp;
 
 	B43_WARN_ON(b43_status(dev) != B43_STAT_UNINIT);
 
 	err = ssb_bus_powerup(bus, 0);
 	if (err)
 		goto out;
Index: wireless-testing/drivers/net/wireless/b43/phy.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy.c	2008-04-18 18:55:14.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/phy.c	2008-04-18 20:59:29.000000000 +0200
@@ -2040,13 +2040,13 @@ int b43_phy_init(struct b43_wldev *dev)
 	return err;
 }
 
 void b43_set_rx_antenna(struct b43_wldev *dev, int antenna)
 {
 	struct b43_phy *phy = &dev->phy;
-	u32 hf;
+	u64 hf;
 	u16 tmp;
 	int autodiv = 0;
 
 	if (antenna == B43_ANTENNA_AUTO0 || antenna == B43_ANTENNA_AUTO1)
 		autodiv = 1;
 
