Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:32950 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbYAEXKO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jan 2008 18:10:14 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH v2] b43: Fix any N-PHY related WARN_ON() in the attach stage.
Date: Sun, 6 Jan 2008 00:09:46 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200801060009.46260.mb@bu3sch.de> (sfid-20080105_231019_650083_80D39633)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes all WARN_ON()s in the attach stage.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

This is stuff for 2.6.25
This is patch version 2. Sorry for the inconvenience.

Index: wireless-2.6/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/b43.h	2008-01-04 15:01:42.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/b43.h	2008-01-04 17:28:03.000000000 +0100
@@ -332,17 +332,22 @@ enum {
 #define B43_MACCMD_CCA			0x00000008	/* Clear channel assessment */
 #define B43_MACCMD_BGNOISE		0x00000010	/* Background noise */
 
-/* 802.11 core specific TM State Low flags */
+/* 802.11 core specific TM State Low (SSB_TMSLOW) flags */
 #define B43_TMSLOW_GMODE		0x20000000	/* G Mode Enable */
-#define B43_TMSLOW_PLLREFSEL		0x00200000	/* PLL Frequency Reference Select */
+#define B43_TMSLOW_PHYCLKSPEED		0x00C00000	/* PHY clock speed mask (N-PHY only) */
+#define  B43_TMSLOW_PHYCLKSPEED_40MHZ	0x00000000	/* 40 MHz PHY */
+#define  B43_TMSLOW_PHYCLKSPEED_80MHZ	0x00400000	/* 80 MHz PHY */
+#define  B43_TMSLOW_PHYCLKSPEED_160MHZ	0x00800000	/* 160 MHz PHY */
+#define B43_TMSLOW_PLLREFSEL		0x00200000	/* PLL Frequency Reference Select (rev >= 5) */
 #define B43_TMSLOW_MACPHYCLKEN		0x00100000	/* MAC PHY Clock Control Enable (rev >= 5) */
 #define B43_TMSLOW_PHYRESET		0x00080000	/* PHY Reset */
 #define B43_TMSLOW_PHYCLKEN		0x00040000	/* PHY Clock Enable */
 
-/* 802.11 core specific TM State High flags */
+/* 802.11 core specific TM State High (SSB_TMSHIGH) flags */
+#define B43_TMSHIGH_DUALBAND_PHY	0x00080000	/* Dualband PHY available */
 #define B43_TMSHIGH_FCLOCK		0x00040000	/* Fast Clock Available (rev >= 5) */
-#define B43_TMSHIGH_APHY		0x00020000	/* A-PHY available (rev >= 5) */
-#define B43_TMSHIGH_GPHY		0x00010000	/* G-PHY available (rev >= 5) */
+#define B43_TMSHIGH_HAVE_5GHZ_PHY	0x00020000	/* 5 GHz PHY available (rev >= 5) */
+#define B43_TMSHIGH_HAVE_2GHZ_PHY	0x00010000	/* 2.4 GHz PHY available (rev >= 5) */
 
 /* Generic-Interrupt reasons. */
 #define B43_IRQ_MAC_SUSPENDED		0x00000001
Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c	2008-01-04 16:57:24.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/main.c	2008-01-06 00:05:04.000000000 +0100
@@ -132,7 +132,7 @@ static struct ieee80211_rate __b43_ratet
 		.power_level	= 0xFF,				\
 		.antenna_max	= 0xFF,				\
 	}
-static struct ieee80211_channel b43_bg_chantable[] = {
+static struct ieee80211_channel b43_2ghz_chantable[] = {
 	CHANTAB_ENT(1, 2412),
 	CHANTAB_ENT(2, 2417),
 	CHANTAB_ENT(3, 2422),
@@ -148,9 +148,10 @@ static struct ieee80211_channel b43_bg_c
 	CHANTAB_ENT(13, 2472),
 	CHANTAB_ENT(14, 2484),
 };
+#define b43_2ghz_chantable_size	ARRAY_SIZE(b43_2ghz_chantable)
 
-#define b43_bg_chantable_size	ARRAY_SIZE(b43_bg_chantable)
-static struct ieee80211_channel b43_a_chantable[] = {
+#if 0
+static struct ieee80211_channel b43_5ghz_chantable[] = {
 	CHANTAB_ENT(36, 5180),
 	CHANTAB_ENT(40, 5200),
 	CHANTAB_ENT(44, 5220),
@@ -165,8 +166,8 @@ static struct ieee80211_channel b43_a_ch
 	CHANTAB_ENT(161, 5805),
 	CHANTAB_ENT(165, 5825),
 };
-
-#define b43_a_chantable_size	ARRAY_SIZE(b43_a_chantable)
+#define b43_5ghz_chantable_size	ARRAY_SIZE(b43_5ghz_chantable)
+#endif
 
 static void b43_wireless_core_exit(struct b43_wldev *dev);
 static int b43_wireless_core_init(struct b43_wldev *dev);
@@ -1658,7 +1659,7 @@ static int b43_request_firmware(struct b
 		switch (dev->phy.type) {
 		case B43_PHYTYPE_A:
 			if ((rev >= 5) && (rev <= 10)) {
-				if (tmshigh & B43_TMSHIGH_GPHY)
+				if (tmshigh & B43_TMSHIGH_HAVE_2GHZ_PHY)
 					filename = "a0g1initvals5";
 				else
 					filename = "a0g0initvals5";
@@ -1684,7 +1685,7 @@ static int b43_request_firmware(struct b
 		switch (dev->phy.type) {
 		case B43_PHYTYPE_A:
 			if ((rev >= 5) && (rev <= 10)) {
-				if (tmshigh & B43_TMSHIGH_GPHY)
+				if (tmshigh & B43_TMSHIGH_HAVE_2GHZ_PHY)
 					filename = "a0g1bsinitvals5";
 				else
 					filename = "a0g0bsinitvals5";
@@ -3134,6 +3135,8 @@ static int b43_phy_versioning(struct b43
 	radio_manuf = (tmp & 0x00000FFF);
 	radio_ver = (tmp & 0x0FFFF000) >> 12;
 	radio_rev = (tmp & 0xF0000000) >> 28;
+	if (radio_manuf != 0x17F /* Broadcom */)
+		unsupported = 1;
 	switch (phy_type) {
 	case B43_PHYTYPE_A:
 		if (radio_ver != 0x2060)
@@ -3151,6 +3154,10 @@ static int b43_phy_versioning(struct b43
 		if (radio_ver != 0x2050)
 			unsupported = 1;
 		break;
+	case B43_PHYTYPE_N:
+		if (radio_ver != 5)
+			unsupported = 1;
+		break;
 	default:
 		B43_WARN_ON(1);
 	}
@@ -3695,72 +3702,30 @@ static void b43_chip_reset(struct work_s
 }
 
 static int b43_setup_modes(struct b43_wldev *dev,
-			   int have_aphy, int have_bphy, int have_gphy)
+			   bool have_2ghz_phy, bool have_5ghz_phy)
 {
 	struct ieee80211_hw *hw = dev->wl->hw;
 	struct ieee80211_hw_mode *mode;
 	struct b43_phy *phy = &dev->phy;
-	int cnt = 0;
 	int err;
 
-/*FIXME: Don't tell ieee80211 about an A-PHY, because we currently don't support A-PHY. */
-	have_aphy = 0;
-
-	phy->possible_phymodes = 0;
-	for (; 1; cnt++) {
-		if (have_aphy) {
-			B43_WARN_ON(cnt >= B43_MAX_PHYHWMODES);
-			mode = &phy->hwmodes[cnt];
-
-			mode->mode = MODE_IEEE80211A;
-			mode->num_channels = b43_a_chantable_size;
-			mode->channels = b43_a_chantable;
-			mode->num_rates = b43_a_ratetable_size;
-			mode->rates = b43_a_ratetable;
-			err = ieee80211_register_hwmode(hw, mode);
-			if (err)
-				return err;
-
-			phy->possible_phymodes |= B43_PHYMODE_A;
-			have_aphy = 0;
-			continue;
-		}
-		if (have_bphy) {
-			B43_WARN_ON(cnt >= B43_MAX_PHYHWMODES);
-			mode = &phy->hwmodes[cnt];
-
-			mode->mode = MODE_IEEE80211B;
-			mode->num_channels = b43_bg_chantable_size;
-			mode->channels = b43_bg_chantable;
-			mode->num_rates = b43_b_ratetable_size;
-			mode->rates = b43_b_ratetable;
-			err = ieee80211_register_hwmode(hw, mode);
-			if (err)
-				return err;
-
-			phy->possible_phymodes |= B43_PHYMODE_B;
-			have_bphy = 0;
-			continue;
-		}
-		if (have_gphy) {
-			B43_WARN_ON(cnt >= B43_MAX_PHYHWMODES);
-			mode = &phy->hwmodes[cnt];
-
-			mode->mode = MODE_IEEE80211G;
-			mode->num_channels = b43_bg_chantable_size;
-			mode->channels = b43_bg_chantable;
-			mode->num_rates = b43_g_ratetable_size;
-			mode->rates = b43_g_ratetable;
-			err = ieee80211_register_hwmode(hw, mode);
-			if (err)
-				return err;
-
-			phy->possible_phymodes |= B43_PHYMODE_G;
-			have_gphy = 0;
-			continue;
-		}
-		break;
-	}
+	/* XXX: This function will go away soon, when mac80211
+	 *      band stuff is rewritten. So this is just a hack.
+	 *      For now we always claim GPHY mode, as there is no
+	 *      support for NPHY and APHY in the device, yet.
+	 *      This assumption is OK, as any B, N or A PHY will already
+	 *      have died a horrible sanity check death earlier. */
+
+	mode = &phy->hwmodes[0];
+	mode->mode = MODE_IEEE80211G;
+	mode->num_channels = b43_2ghz_chantable_size;
+	mode->channels = b43_2ghz_chantable;
+	mode->num_rates = b43_g_ratetable_size;
+	mode->rates = b43_g_ratetable;
+	err = ieee80211_register_hwmode(hw, mode);
+	if (err)
+		return err;
+	phy->possible_phymodes |= B43_PHYMODE_G;
 
 	return 0;
 }
@@ -3778,7 +3743,7 @@ static int b43_wireless_core_attach(stru
 	struct ssb_bus *bus = dev->dev->bus;
 	struct pci_dev *pdev = bus->host_pci;
 	int err;
-	int have_aphy = 0, have_bphy = 0, have_gphy = 0;
+	bool have_2ghz_phy = 0, have_5ghz_phy = 0;
 	u32 tmp;
 
 	/* Do NOT do any device initialization here.
@@ -3798,17 +3763,12 @@ static int b43_wireless_core_attach(stru
 		u32 tmshigh;
 
 		tmshigh = ssb_read32(dev->dev, SSB_TMSHIGH);
-		have_aphy = !!(tmshigh & B43_TMSHIGH_APHY);
-		have_gphy = !!(tmshigh & B43_TMSHIGH_GPHY);
-		if (!have_aphy && !have_gphy)
-			have_bphy = 1;
-	} else if (dev->dev->id.revision == 4) {
-		have_gphy = 1;
-		have_aphy = 1;
+		have_2ghz_phy = !!(tmshigh & B43_TMSHIGH_HAVE_2GHZ_PHY);
+		have_5ghz_phy = !!(tmshigh & B43_TMSHIGH_HAVE_5GHZ_PHY);
 	} else
-		have_bphy = 1;
+		B43_WARN_ON(1);
 
-	dev->phy.gmode = (have_gphy || have_bphy);
+	dev->phy.gmode = have_2ghz_phy;
 	tmp = dev->phy.gmode ? B43_TMSLOW_GMODE : 0;
 	b43_wireless_core_reset(dev, tmp);
 
@@ -3820,31 +3780,34 @@ static int b43_wireless_core_attach(stru
 	    (pdev->device != 0x4312 &&
 	     pdev->device != 0x4319 && pdev->device != 0x4324)) {
 		/* No multiband support. */
-		have_aphy = 0;
-		have_bphy = 0;
-		have_gphy = 0;
+		have_2ghz_phy = 0;
+		have_5ghz_phy = 0;
 		switch (dev->phy.type) {
 		case B43_PHYTYPE_A:
-			have_aphy = 1;
-			break;
-		case B43_PHYTYPE_B:
-			have_bphy = 1;
+			have_5ghz_phy = 1;
 			break;
 		case B43_PHYTYPE_G:
-			have_gphy = 1;
+		case B43_PHYTYPE_N:
+			have_2ghz_phy = 1;
 			break;
 		default:
 			B43_WARN_ON(1);
 		}
 	}
-	dev->phy.gmode = (have_gphy || have_bphy);
+	if (dev->phy.type == B43_PHYTYPE_A) {
+		/* FIXME */
+		b43err(wl, "IEEE 802.11a devices are unsupported\n");
+		err = -EOPNOTSUPP;
+		goto err_powerdown;
+	}
+	dev->phy.gmode = have_2ghz_phy;
 	tmp = dev->phy.gmode ? B43_TMSLOW_GMODE : 0;
 	b43_wireless_core_reset(dev, tmp);
 
 	err = b43_validate_chipaccess(dev);
 	if (err)
 		goto err_powerdown;
-	err = b43_setup_modes(dev, have_aphy, have_bphy, have_gphy);
+	err = b43_setup_modes(dev, have_2ghz_phy, have_5ghz_phy);
 	if (err)
 		goto err_powerdown;
 
