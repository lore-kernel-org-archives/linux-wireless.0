Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:41952
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304AbXHGPfN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Aug 2007 11:35:13 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] bcm43xx-mac80211: Make hwpctl optional (disabled by default)
Date: Tue, 7 Aug 2007 17:33:11 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200708071733.11986.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch makes hardware power control optional through
a module parameter, which is disabled by default.
Hardware power control is broken, so we will drive with software
based power control.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

--

John, please apply to wireless-dev.
With this patch we come into the region where we might consider
going into production with bcm43xx-mac80211.
The mac80211 rc algorithm is able to auto-scale up to 54M on
my 4306 and the 4318(!).
So the major TX problems seem mostly gone with this.

I am going to do more small patches that optimize software
power adjustment and so on later. But the major stuff should
be fixed.

Index: wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx.h
===================================================================
--- wireless-dev.orig/drivers/net/wireless/bcm43xx-mac80211/bcm43xx.h	2007-08-06 23:58:17.000000000 +0200
+++ wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx.h	2007-08-07 00:06:42.000000000 +0200
@@ -537,6 +537,8 @@ struct bcm43xx_phy {
 #ifdef CONFIG_BCM43XX_MAC80211_DEBUG
 	bool manual_txpower_control; /* Manual TX-power control enabled? */
 #endif
+	/* Hardware Power Control enabled? */
+	bool hardware_power_control;
 
 	/* Current Interference Mitigation mode */
 	int interfmode;
Index: wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_lo.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_lo.c	2007-08-06 23:58:17.000000000 +0200
+++ wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_lo.c	2007-08-07 00:06:42.000000000 +0200
@@ -589,7 +589,7 @@ static void lo_measure_setup(struct bcm4
 	struct bcm43xx_txpower_lo_control *lo = phy->lo_control;
 	u16 tmp;
 
-	if (has_hardware_pctl(phy)) {
+	if (bcm43xx_has_hardware_pctl(phy)) {
 		sav->phy_lo_mask = bcm43xx_phy_read(dev, BCM43xx_PHY_LO_MASK);
 		sav->phy_extg_01 = bcm43xx_phy_read(dev, BCM43xx_PHY_EXTG(0x01));
 		sav->phy_dacctl_hwpctl = bcm43xx_phy_read(dev, BCM43xx_PHY_DACCTL);
@@ -615,7 +615,7 @@ static void lo_measure_setup(struct bcm4
 		bcm43xx_phy_write(dev, BCM43xx_PHY_BASE(0x16), 0x410);
 		bcm43xx_phy_write(dev, BCM43xx_PHY_BASE(0x17), 0x820);
 	}
-	if (!lo->rebuild && has_hardware_pctl(phy))
+	if (!lo->rebuild && bcm43xx_has_hardware_pctl(phy))
 		lo_read_power_vector(dev);
 	if (phy->rev >= 2) {
 		sav->phy_analogover = bcm43xx_phy_read(dev, BCM43xx_PHY_ANALOGOVER);
@@ -730,7 +730,7 @@ static void lo_measure_restore(struct bc
 		tmp = (phy->pga_gain | 0xEFA0);
 		bcm43xx_phy_write(dev, BCM43xx_PHY_PGACTL, tmp);
 	}
-	if (has_hardware_pctl(phy)) {
+	if (bcm43xx_has_hardware_pctl(phy)) {
 		bcm43xx_gphy_dc_lt_init(dev);
 	} else {
 		if (lo->rebuild)
@@ -777,7 +777,7 @@ static void lo_measure_restore(struct bc
 		bcm43xx_phy_write(dev, BCM43xx_PHY_BASE(0x3E), sav->phy_base_3E);
 		bcm43xx_phy_write(dev, BCM43xx_PHY_CRS0, sav->phy_crs0);
 	}
-	if (has_hardware_pctl(phy)) {
+	if (bcm43xx_has_hardware_pctl(phy)) {
 		tmp = (sav->phy_lo_mask & 0xBFFF);
 		bcm43xx_phy_write(dev, BCM43xx_PHY_LO_MASK, tmp);
 		bcm43xx_phy_write(dev, BCM43xx_PHY_EXTG(0x01), sav->phy_extg_01);
Index: wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c	2007-08-07 00:04:46.000000000 +0200
+++ wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c	2007-08-07 00:06:42.000000000 +0200
@@ -102,6 +102,10 @@ static int modparam_mon_keep_badplcp;
 module_param_named(mon_keep_badplcp, modparam_mon_keep_bad, int, 0444);
 MODULE_PARM_DESC(mon_keep_badplcp, "Keep frames with bad PLCP in monitor mode");
 
+static int modparam_hwpctl;
+module_param_named(hwpctl, modparam_hwpctl, int, 0444);
+MODULE_PARM_DESC(hwpctl, "Enable hardware-side power control (default off)");
+
 
 static const struct ssb_device_id bcm43xx_ssb_tbl[] = {
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, SSB_ANY_REV),
@@ -3170,6 +3174,8 @@ static void setup_struct_phy_for_init(st
 	spin_lock_init(&phy->lock);
 	phy->interfmode = BCM43xx_INTERFMODE_NONE;
 	phy->channel = 0xFF;
+
+	phy->hardware_power_control = !!modparam_hwpctl;
 }
 
 static void setup_struct_wldev_for_init(struct bcm43xx_wldev *dev)
Index: wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_phy.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_phy.c	2007-08-06 23:58:17.000000000 +0200
+++ wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_phy.c	2007-08-07 00:06:42.000000000 +0200
@@ -189,6 +189,25 @@ static void generate_bbatt_list(struct b
 	list->max_val = 8;
 }
 
+bool bcm43xx_has_hardware_pctl(struct bcm43xx_phy *phy)
+{
+	if (!phy->hardware_power_control)
+		return 0;
+	switch (phy->type) {
+	case BCM43xx_PHYTYPE_A:
+		if (phy->rev >= 5)
+			return 1;
+		break;
+	case BCM43xx_PHYTYPE_G:
+		if (phy->rev >= 6)
+			return 1;
+		break;
+	default:
+		assert(0);
+	}
+	return 0;
+}
+
 static void bcm43xx_shm_clear_tssi(struct bcm43xx_wldev *dev)
 {
 	struct bcm43xx_phy *phy = &dev->phy;
@@ -614,31 +633,38 @@ static void hardware_pctl_init_gphy(stru
 	bcm43xx_gphy_dc_lt_init(dev);
 }
 
-/* HardwarePowerControl for A and G PHY.
- * This does nothing, if the card does not have HW PCTL
- */
+/* HardwarePowerControl init for A and G PHY */
 static void bcm43xx_hardware_pctl_init(struct bcm43xx_wldev *dev)
 {
 	struct bcm43xx_phy *phy = &dev->phy;
 
-	if (!has_hardware_pctl(phy))
-		return;
-	if (phy->type == BCM43xx_PHYTYPE_A) {
-		hardware_pctl_init_aphy(dev);
+	if (!bcm43xx_has_hardware_pctl(phy)) {
+		/* No hardware power control */
+		bcm43xx_hf_write(dev, bcm43xx_hf_read(dev) &
+				 ~BCM43xx_HF_HWPCTL);
 		return;
 	}
-	if (phy->type == BCM43xx_PHYTYPE_G) {
+	/* Init the hwpctl related hardware */
+	switch (phy->type) {
+	case BCM43xx_PHYTYPE_A:
+		hardware_pctl_init_aphy(dev);
+		break;
+	case BCM43xx_PHYTYPE_G:
 		hardware_pctl_init_gphy(dev);
-		return;
+		break;
+	default:
+		assert(0);
 	}
-	assert(0);
+	/* Enable hardware pctl in firmware. */
+	bcm43xx_hf_write(dev, bcm43xx_hf_read(dev) |
+			 BCM43xx_HF_HWPCTL);
 }
 
 static void bcm43xx_hardware_pctl_early_init(struct bcm43xx_wldev *dev)
 {
 	struct bcm43xx_phy *phy = &dev->phy;
 
-	if (!has_hardware_pctl(phy)) {
+	if (!bcm43xx_has_hardware_pctl(phy)) {
 		bcm43xx_phy_write(dev, 0x047A, 0xC111);
 		return;
 	}
Index: wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_phy.h
===================================================================
--- wireless-dev.orig/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_phy.h	2007-08-06 23:58:17.000000000 +0200
+++ wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_phy.h	2007-08-07 00:06:42.000000000 +0200
@@ -4,6 +4,7 @@
 #include <linux/types.h>
 
 struct bcm43xx_wldev;
+struct bcm43xx_phy;
 
 
 /*** PHY Registers ***/
@@ -218,9 +219,7 @@ void bcm43xx_phy_xmitpower(struct bcm43x
 void bcm43xx_gphy_dc_lt_init(struct bcm43xx_wldev *dev);
 
 /* Returns the boolean whether the board has HardwarePowerControl */
-#define has_hardware_pctl(phy) \
-	(((phy)->type == BCM43xx_PHYTYPE_A && (phy)->rev >= 5) ||	\
-	 ((phy)->type == BCM43xx_PHYTYPE_G && (phy)->rev >= 6))
+bool bcm43xx_has_hardware_pctl(struct bcm43xx_phy *phy);
 /* Returns the boolean whether "TX Magnification" is enabled. */
 #define has_tx_magnification(phy) \
 	(((phy)->rev >= 2) &&			\

-- 
Greetings Michael.
