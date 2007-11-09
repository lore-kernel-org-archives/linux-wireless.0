Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64375 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756254AbXKIW5U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 17:57:20 -0500
Date: Fri, 09 Nov 2007 16:57:18 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: [PATCH 4/6] b43: Convert to use of the new SPROM structure
Message-ID: <4734e5ce.d7a1RTXjEeuuQ7XG%Larry.Finger@lwfinger.net> (sfid-20071109_225722_586460_B8D1E797)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch 4 of 6.

The b43 driver is modified to use the new SPROM structure.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-2.6/drivers/net/wireless/b43/leds.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/leds.c
+++ wireless-2.6/drivers/net/wireless/b43/leds.c
@@ -187,10 +187,10 @@ void b43_leds_init(struct b43_wldev *dev
 	enum b43_led_behaviour behaviour;
 	bool activelow;
 
-	sprom[0] = bus->sprom.r1.gpio0;
-	sprom[1] = bus->sprom.r1.gpio1;
-	sprom[2] = bus->sprom.r1.gpio2;
-	sprom[3] = bus->sprom.r1.gpio3;
+	sprom[0] = bus->sprom.gpio0;
+	sprom[1] = bus->sprom.gpio1;
+	sprom[2] = bus->sprom.gpio2;
+	sprom[3] = bus->sprom.gpio3;
 
 	for (i = 0; i < 4; i++) {
 		if (sprom[i] == 0xFF) {
Index: wireless-2.6/drivers/net/wireless/b43/lo.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/lo.c
+++ wireless-2.6/drivers/net/wireless/b43/lo.c
@@ -264,8 +264,8 @@ static u16 lo_measure_feedthrough(struct
 		rfover |= pga;
 		rfover |= lna;
 		rfover |= trsw_rx;
-		if ((dev->dev->bus->sprom.r1.boardflags_lo & B43_BFL_EXTLNA) &&
-		    phy->rev > 6)
+		if ((dev->dev->bus->sprom.boardflags_lo & B43_BFL_EXTLNA)
+		    && phy->rev > 6)
 			rfover |= B43_PHY_RFOVERVAL_EXTLNA;
 
 		b43_phy_write(dev, B43_PHY_PGACTL, 0xE300);
@@ -634,7 +634,7 @@ static void lo_measure_setup(struct b43_
 			      & 0xFFFC);
 		if (phy->type == B43_PHYTYPE_G) {
 			if ((phy->rev >= 7) &&
-			    (sprom->r1.boardflags_lo & B43_BFL_EXTLNA)) {
+			    (sprom->boardflags_lo & B43_BFL_EXTLNA)) {
 				b43_phy_write(dev, B43_PHY_RFOVER, 0x933);
 			} else {
 				b43_phy_write(dev, B43_PHY_RFOVER, 0x133);
Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c
+++ wireless-2.6/drivers/net/wireless/b43/main.c
@@ -1924,7 +1924,7 @@ static int b43_gpio_init(struct b43_wlde
 		mask |= 0x0180;
 		set |= 0x0180;
 	}
-	if (dev->dev->bus->sprom.r1.boardflags_lo & B43_BFL_PACTRL) {
+	if (dev->dev->bus->sprom.boardflags_lo & B43_BFL_PACTRL) {
 		b43_write16(dev, B43_MMIO_GPIO_MASK,
 			    b43_read16(dev, B43_MMIO_GPIO_MASK)
 			    | 0x0200);
@@ -2289,7 +2289,7 @@ static void b43_periodic_every60sec(stru
 
 	if (!b43_has_hardware_pctl(phy))
 		b43_lo_g_ctl_mark_all_unused(dev);
-	if (dev->dev->bus->sprom.r1.boardflags_lo & B43_BFL_RSSI) {
+	if (dev->dev->bus->sprom.boardflags_lo & B43_BFL_RSSI) {
 		b43_mac_suspend(dev);
 		b43_calc_nrssi_slope(dev);
 		if ((phy->radio_ver == 0x2050) && (phy->radio_rev == 8)) {
@@ -3208,13 +3208,13 @@ static void b43_bluetooth_coext_enable(s
 	struct ssb_sprom *sprom = &dev->dev->bus->sprom;
 	u32 hf;
 
-	if (!(sprom->r1.boardflags_lo & B43_BFL_BTCOEXIST))
+	if (!(sprom->boardflags_lo & B43_BFL_BTCOEXIST))
 		return;
 	if (dev->phy.type != B43_PHYTYPE_B && !dev->phy.gmode)
 		return;
 
 	hf = b43_hf_read(dev);
-	if (sprom->r1.boardflags_lo & B43_BFL_BTCMOD)
+	if (sprom->boardflags_lo & B43_BFL_BTCMOD)
 		hf |= B43_HF_BTCOEXALT;
 	else
 		hf |= B43_HF_BTCOEX;
@@ -3348,7 +3348,7 @@ static int b43_wireless_core_init(struct
 		hf |= B43_HF_SYMW;
 		if (phy->rev == 1)
 			hf |= B43_HF_GDCW;
-		if (sprom->r1.boardflags_lo & B43_BFL_PACTRL)
+		if (sprom->boardflags_lo & B43_BFL_PACTRL)
 			hf |= B43_HF_OFDMPABOOST;
 	} else if (phy->type == B43_PHYTYPE_B) {
 		hf |= B43_HF_SYMW;
@@ -3859,20 +3859,20 @@ static void b43_sprom_fixup(struct ssb_b
 	/* boardflags workarounds */
 	if (bus->boardinfo.vendor == SSB_BOARDVENDOR_DELL &&
 	    bus->chip_id == 0x4301 && bus->boardinfo.rev == 0x74)
-		bus->sprom.r1.boardflags_lo |= B43_BFL_BTCOEXIST;
+		bus->sprom.boardflags_lo |= B43_BFL_BTCOEXIST;
 	if (bus->boardinfo.vendor == PCI_VENDOR_ID_APPLE &&
 	    bus->boardinfo.type == 0x4E && bus->boardinfo.rev > 0x40)
-		bus->sprom.r1.boardflags_lo |= B43_BFL_PACTRL;
+		bus->sprom.boardflags_lo |= B43_BFL_PACTRL;
 
 	/* Handle case when gain is not set in sprom */
-	if (bus->sprom.r1.antenna_gain_a == 0xFF)
-		bus->sprom.r1.antenna_gain_a = 2;
-	if (bus->sprom.r1.antenna_gain_bg == 0xFF)
-		bus->sprom.r1.antenna_gain_bg = 2;
+	if (bus->sprom.antenna_gain_a == 0xFF)
+		bus->sprom.antenna_gain_a = 2;
+	if (bus->sprom.antenna_gain_bg == 0xFF)
+		bus->sprom.antenna_gain_bg = 2;
 
 	/* Convert Antennagain values to Q5.2 */
-	bus->sprom.r1.antenna_gain_a <<= 2;
-	bus->sprom.r1.antenna_gain_bg <<= 2;
+	bus->sprom.antenna_gain_a <<= 2;
+	bus->sprom.antenna_gain_bg <<= 2;
 }
 
 static void b43_wireless_exit(struct ssb_device *dev, struct b43_wl *wl)
@@ -3905,10 +3905,10 @@ static int b43_wireless_init(struct ssb_
 	hw->max_noise = -110;
 	hw->queues = 1;		/* FIXME: hardware has more queues */
 	SET_IEEE80211_DEV(hw, dev->dev);
-	if (is_valid_ether_addr(sprom->r1.et1mac))
-		SET_IEEE80211_PERM_ADDR(hw, sprom->r1.et1mac);
+	if (is_valid_ether_addr(sprom->et1mac))
+		SET_IEEE80211_PERM_ADDR(hw, sprom->et1mac);
 	else
-		SET_IEEE80211_PERM_ADDR(hw, sprom->r1.il0mac);
+		SET_IEEE80211_PERM_ADDR(hw, sprom->il0mac);
 
 	/* Get and initialize struct b43_wl */
 	wl = hw_to_b43_wl(hw);
Index: wireless-2.6/drivers/net/wireless/b43/phy.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/phy.c
+++ wireless-2.6/drivers/net/wireless/b43/phy.c
@@ -1139,7 +1139,7 @@ static void b43_phy_inita(struct b43_wld
 	} else {
 		b43_phy_setupg(dev);
 		if (phy->gmode &&
-		    (dev->dev->bus->sprom.r1.boardflags_lo & B43_BFL_PACTRL))
+		    (dev->dev->bus->sprom.boardflags_lo & B43_BFL_PACTRL))
 			b43_phy_write(dev, 0x046E, 0x03CF);
 		return;
 	}
@@ -1286,7 +1286,7 @@ static void b43_phy_initb4(struct b43_wl
 	if (phy->radio_ver == 0x2050)
 		b43_phy_write(dev, 0x002A, 0x88C2);
 	b43_set_txpower_g(dev, &phy->bbatt, &phy->rfatt, phy->tx_control);
-	if (dev->dev->bus->sprom.r1.boardflags_lo & B43_BFL_RSSI) {
+	if (dev->dev->bus->sprom.boardflags_lo & B43_BFL_RSSI) {
 		b43_calc_nrssi_slope(dev);
 		b43_calc_nrssi_threshold(dev);
 	}
@@ -1433,7 +1433,7 @@ static void b43_phy_initb6(struct b43_wl
 		b43_radio_write16(dev, 0x5A, 0x88);
 		b43_radio_write16(dev, 0x5B, 0x6B);
 		b43_radio_write16(dev, 0x5C, 0x0F);
-		if (dev->dev->bus->sprom.r1.boardflags_lo & B43_BFL_ALTIQ) {
+		if (dev->dev->bus->sprom.boardflags_lo & B43_BFL_ALTIQ) {
 			b43_radio_write16(dev, 0x5D, 0xFA);
 			b43_radio_write16(dev, 0x5E, 0xD8);
 		} else {
@@ -1525,7 +1525,7 @@ static void b43_phy_initb6(struct b43_wl
 		b43_phy_write(dev, 0x0062, 0x0007);
 		b43_radio_init2050(dev);
 		b43_lo_g_measure(dev);
-		if (dev->dev->bus->sprom.r1.boardflags_lo & B43_BFL_RSSI) {
+		if (dev->dev->bus->sprom.boardflags_lo & B43_BFL_RSSI) {
 			b43_calc_nrssi_slope(dev);
 			b43_calc_nrssi_threshold(dev);
 		}
@@ -1645,7 +1645,7 @@ static void b43_calc_loopback_gain(struc
 	b43_phy_write(dev, B43_PHY_RFOVERVAL,
 		      b43_phy_read(dev, B43_PHY_RFOVERVAL) & 0xCFFF);
 
-	if (dev->dev->bus->sprom.r1.boardflags_lo & B43_BFL_EXTLNA) {
+	if (dev->dev->bus->sprom.boardflags_lo & B43_BFL_EXTLNA) {
 		if (phy->rev >= 7) {
 			b43_phy_write(dev, B43_PHY_RFOVER,
 				      b43_phy_read(dev, B43_PHY_RFOVER)
@@ -1812,7 +1812,7 @@ static void b43_phy_initg(struct b43_wld
 				       & 0x0FFF) | (phy->lo_control->
 						    tx_bias << 12));
 		}
-		if (dev->dev->bus->sprom.r1.boardflags_lo & B43_BFL_PACTRL)
+		if (dev->dev->bus->sprom.boardflags_lo & B43_BFL_PACTRL)
 			b43_phy_write(dev, B43_PHY_BASE(0x2E), 0x8075);
 		else
 			b43_phy_write(dev, B43_PHY_BASE(0x2E), 0x807F);
@@ -1826,7 +1826,7 @@ static void b43_phy_initg(struct b43_wld
 		b43_phy_write(dev, B43_PHY_LO_MASK, 0x8078);
 	}
 
-	if (!(dev->dev->bus->sprom.r1.boardflags_lo & B43_BFL_RSSI)) {
+	if (!(dev->dev->bus->sprom.boardflags_lo & B43_BFL_RSSI)) {
 		/* The specs state to update the NRSSI LT with
 		 * the value 0x7FFFFFFF here. I think that is some weird
 		 * compiler optimization in the original driver.
@@ -2036,16 +2036,15 @@ void b43_phy_xmitpower(struct b43_wldev 
 			estimated_pwr =
 			    b43_phy_estimate_power_out(dev, average);
 
-			max_pwr = dev->dev->bus->sprom.r1.maxpwr_bg;
-			if ((dev->dev->bus->sprom.r1.
-			     boardflags_lo & B43_BFL_PACTRL)
-			    && (phy->type == B43_PHYTYPE_G))
+			max_pwr = dev->dev->bus->sprom.maxpwr_bg;
+			if ((dev->dev->bus->sprom.boardflags_lo
+			    & B43_BFL_PACTRL) && (phy->type == B43_PHYTYPE_G))
 				max_pwr -= 0x3;
 			if (unlikely(max_pwr <= 0)) {
 				b43warn(dev->wl,
 					"Invalid max-TX-power value in SPROM.\n");
 				max_pwr = 60;	/* fake it */
-				dev->dev->bus->sprom.r1.maxpwr_bg = max_pwr;
+				dev->dev->bus->sprom.maxpwr_bg = max_pwr;
 			}
 
 			/*TODO:
@@ -2103,7 +2102,7 @@ void b43_phy_xmitpower(struct b43_wldev 
 						    B43_TXCTL_TXMIX;
 						rfatt += 2;
 						bbatt += 2;
-					} else if (dev->dev->bus->sprom.r1.
+					} else if (dev->dev->bus->sprom.
 						   boardflags_lo &
 						   B43_BFL_PACTRL) {
 						bbatt += 4 * (rfatt - 2);
@@ -2179,13 +2178,13 @@ int b43_phy_init_tssi2dbm_table(struct b
 	s8 *dyn_tssi2dbm;
 
 	if (phy->type == B43_PHYTYPE_A) {
-		pab0 = (s16) (dev->dev->bus->sprom.r1.pa1b0);
-		pab1 = (s16) (dev->dev->bus->sprom.r1.pa1b1);
-		pab2 = (s16) (dev->dev->bus->sprom.r1.pa1b2);
+		pab0 = (s16) (dev->dev->bus->sprom.pa1b0);
+		pab1 = (s16) (dev->dev->bus->sprom.pa1b1);
+		pab2 = (s16) (dev->dev->bus->sprom.pa1b2);
 	} else {
-		pab0 = (s16) (dev->dev->bus->sprom.r1.pa0b0);
-		pab1 = (s16) (dev->dev->bus->sprom.r1.pa0b1);
-		pab2 = (s16) (dev->dev->bus->sprom.r1.pa0b2);
+		pab0 = (s16) (dev->dev->bus->sprom.pa0b0);
+		pab1 = (s16) (dev->dev->bus->sprom.pa0b1);
+		pab2 = (s16) (dev->dev->bus->sprom.pa0b2);
 	}
 
 	if ((dev->dev->bus->chip_id == 0x4301) && (phy->radio_ver != 0x2050)) {
@@ -2198,17 +2197,17 @@ int b43_phy_init_tssi2dbm_table(struct b
 	    pab0 != -1 && pab1 != -1 && pab2 != -1) {
 		/* The pabX values are set in SPROM. Use them. */
 		if (phy->type == B43_PHYTYPE_A) {
-			if ((s8) dev->dev->bus->sprom.r1.itssi_a != 0 &&
-			    (s8) dev->dev->bus->sprom.r1.itssi_a != -1)
+			if ((s8) dev->dev->bus->sprom.itssi_a != 0 &&
+			    (s8) dev->dev->bus->sprom.itssi_a != -1)
 				phy->tgt_idle_tssi =
-				    (s8) (dev->dev->bus->sprom.r1.itssi_a);
+				    (s8) (dev->dev->bus->sprom.itssi_a);
 			else
 				phy->tgt_idle_tssi = 62;
 		} else {
-			if ((s8) dev->dev->bus->sprom.r1.itssi_bg != 0 &&
-			    (s8) dev->dev->bus->sprom.r1.itssi_bg != -1)
+			if ((s8) dev->dev->bus->sprom.itssi_bg != 0 &&
+			    (s8) dev->dev->bus->sprom.itssi_bg != -1)
 				phy->tgt_idle_tssi =
-				    (s8) (dev->dev->bus->sprom.r1.itssi_bg);
+				    (s8) (dev->dev->bus->sprom.itssi_bg);
 			else
 				phy->tgt_idle_tssi = 62;
 		}
@@ -3114,7 +3113,7 @@ void b43_calc_nrssi_threshold(struct b43
 			if (phy->radio_ver != 0x2050)
 				return;
 			if (!
-			    (dev->dev->bus->sprom.r1.
+			    (dev->dev->bus->sprom.
 			     boardflags_lo & B43_BFL_RSSI))
 				return;
 
@@ -3145,7 +3144,7 @@ void b43_calc_nrssi_threshold(struct b43
 		}
 	case B43_PHYTYPE_G:
 		if (!phy->gmode ||
-		    !(dev->dev->bus->sprom.r1.boardflags_lo & B43_BFL_RSSI)) {
+		    !(dev->dev->bus->sprom.boardflags_lo & B43_BFL_RSSI)) {
 			tmp16 = b43_nrssi_hw_read(dev, 0x20);
 			if (tmp16 >= 0x20)
 				tmp16 -= 0x40;
@@ -3667,7 +3666,7 @@ static u16 radio2050_rfover_val(struct b
 		}
 
 		if ((phy->rev < 7) ||
-		    !(sprom->r1.boardflags_lo & B43_BFL_EXTLNA)) {
+		    !(sprom->boardflags_lo & B43_BFL_EXTLNA)) {
 			if (phy_register == B43_PHY_RFOVER) {
 				return 0x1B3;
 			} else if (phy_register == B43_PHY_RFOVERVAL) {
@@ -3707,7 +3706,7 @@ static u16 radio2050_rfover_val(struct b
 		}
 	} else {
 		if ((phy->rev < 7) ||
-		    !(sprom->r1.boardflags_lo & B43_BFL_EXTLNA)) {
+		    !(sprom->boardflags_lo & B43_BFL_EXTLNA)) {
 			if (phy_register == B43_PHY_RFOVER) {
 				return 0x1B3;
 			} else if (phy_register == B43_PHY_RFOVERVAL) {
@@ -4186,7 +4185,7 @@ int b43_radio_selectchannel(struct b43_w
 		b43_write16(dev, B43_MMIO_CHANNEL, channel2freq_bg(channel));
 
 		if (channel == 14) {
-			if (dev->dev->bus->sprom.r1.country_code ==
+			if (dev->dev->bus->sprom.country_code ==
 			    SSB_SPROM1CCODE_JAPAN)
 				b43_hf_write(dev,
 					     b43_hf_read(dev) & ~B43_HF_ACPR);
Index: wireless-2.6/drivers/net/wireless/b43/xmit.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/xmit.c
+++ wireless-2.6/drivers/net/wireless/b43/xmit.c
@@ -385,7 +385,7 @@ static s8 b43_rssi_postprocess(struct b4
 			else
 				tmp -= 3;
 		} else {
-			if (dev->dev->bus->sprom.r1.
+			if (dev->dev->bus->sprom.
 			    boardflags_lo & B43_BFL_RSSI) {
 				if (in_rssi > 63)
 					in_rssi = 63;
