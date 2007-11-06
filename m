Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:38100 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213AbXKFTQG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2007 14:16:06 -0500
Date: Tue, 06 Nov 2007 13:16:05 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [RFC 5 of 6] b43legacy: Convert to use of the new SPROM structure
Message-ID: <4730bd75.jwiBAv3atOVcVl2f%Larry.Finger@lwfinger.net> (sfid-20071106_191609_335426_246CCE8A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch 5 of 6.

The b43legacy driver is modified to use the new SPROM structure.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-2.6/drivers/net/wireless/b43legacy/leds.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/leds.c
+++ wireless-2.6/drivers/net/wireless/b43legacy/leds.c
@@ -189,10 +189,10 @@ void b43legacy_leds_init(struct b43legac
 	enum b43legacy_led_behaviour behaviour;
 	bool activelow;
 
-	sprom[0] = bus->sprom.r1.gpio0;
-	sprom[1] = bus->sprom.r1.gpio1;
-	sprom[2] = bus->sprom.r1.gpio2;
-	sprom[3] = bus->sprom.r1.gpio3;
+	sprom[0] = bus->sprom.data.gpio0;
+	sprom[1] = bus->sprom.data.gpio1;
+	sprom[2] = bus->sprom.data.gpio2;
+	sprom[3] = bus->sprom.data.gpio3;
 
 	for (i = 0; i < 4; i++) {
 		if (sprom[i] == 0xFF) {
Index: wireless-2.6/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/main.c
+++ wireless-2.6/drivers/net/wireless/b43legacy/main.c
@@ -1753,7 +1753,7 @@ static int b43legacy_gpio_init(struct b4
 		mask |= 0x0060;
 		set |= 0x0060;
 	}
-	if (dev->dev->bus->sprom.r1.boardflags_lo & B43legacy_BFL_PACTRL) {
+	if (dev->dev->bus->sprom.data.boardflags_lo & B43legacy_BFL_PACTRL) {
 		b43legacy_write16(dev, B43legacy_MMIO_GPIO_MASK,
 				  b43legacy_read16(dev,
 				  B43legacy_MMIO_GPIO_MASK)
@@ -2130,7 +2130,7 @@ static void b43legacy_periodic_every120s
 static void b43legacy_periodic_every60sec(struct b43legacy_wldev *dev)
 {
 	b43legacy_phy_lo_mark_all_unused(dev);
-	if (dev->dev->bus->sprom.r1.boardflags_lo & B43legacy_BFL_RSSI) {
+	if (dev->dev->bus->sprom.data.boardflags_lo & B43legacy_BFL_RSSI) {
 		b43legacy_mac_suspend(dev);
 		b43legacy_calc_nrssi_slope(dev);
 		b43legacy_mac_enable(dev);
@@ -3055,7 +3055,7 @@ static int b43legacy_wireless_core_init(
 		hf |= B43legacy_HF_SYMW;
 		if (phy->rev == 1)
 			hf |= B43legacy_HF_GDCW;
-		if (sprom->r1.boardflags_lo & B43legacy_BFL_PACTRL)
+		if (sprom->data.boardflags_lo & B43legacy_BFL_PACTRL)
 			hf |= B43legacy_HF_OFDMPABOOST;
 	} else if (phy->type == B43legacy_PHYTYPE_B) {
 		hf |= B43legacy_HF_SYMW;
@@ -3534,12 +3534,12 @@ static void b43legacy_sprom_fixup(struct
 	if (bus->boardinfo.vendor == PCI_VENDOR_ID_APPLE &&
 	    bus->boardinfo.type == 0x4E &&
 	    bus->boardinfo.rev > 0x40)
-		bus->sprom.r1.boardflags_lo |= B43legacy_BFL_PACTRL;
+		bus->sprom.data.boardflags_lo |= B43legacy_BFL_PACTRL;
 
 	/* Convert Antennagain values to Q5.2 */
-	if (bus->sprom.r1.antenna_gain_bg == 0xFF)
-		bus->sprom.r1.antenna_gain_bg = 2; /* if unset, use 2 dBm */
-	bus->sprom.r1.antenna_gain_bg <<= 2;
+	if (bus->sprom.data.antenna_gain_bg == 0xFF)
+		bus->sprom.data.antenna_gain_bg = 2; /* if unset, use 2 dBm */
+	bus->sprom.data.antenna_gain_bg <<= 2;
 }
 
 static void b43legacy_wireless_exit(struct ssb_device *dev,
@@ -3574,10 +3574,10 @@ static int b43legacy_wireless_init(struc
 	hw->max_noise = -110;
 	hw->queues = 1; /* FIXME: hardware has more queues */
 	SET_IEEE80211_DEV(hw, dev->dev);
-	if (is_valid_ether_addr(sprom->r1.et1mac))
-		SET_IEEE80211_PERM_ADDR(hw, sprom->r1.et1mac);
+	if (is_valid_ether_addr(sprom->data.et1mac))
+		SET_IEEE80211_PERM_ADDR(hw, sprom->data.et1mac);
 	else
-		SET_IEEE80211_PERM_ADDR(hw, sprom->r1.il0mac);
+		SET_IEEE80211_PERM_ADDR(hw, sprom->data.il0mac);
 
 	/* Get and initialize struct b43legacy_wl */
 	wl = hw_to_b43legacy_wl(hw);
Index: wireless-2.6/drivers/net/wireless/b43legacy/phy.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/phy.c
+++ wireless-2.6/drivers/net/wireless/b43legacy/phy.c
@@ -441,7 +441,7 @@ static void b43legacy_phy_inita(struct b
 	might_sleep();
 
 	b43legacy_phy_setupg(dev);
-	if (dev->dev->bus->sprom.r1.boardflags_lo & B43legacy_BFL_PACTRL)
+	if (dev->dev->bus->sprom.data.boardflags_lo & B43legacy_BFL_PACTRL)
 		b43legacy_phy_write(dev, 0x046E, 0x03CF);
 }
 
@@ -543,7 +543,7 @@ static void b43legacy_phy_initb4(struct 
 	if (phy->radio_ver == 0x2050)
 		b43legacy_phy_write(dev, 0x002A, 0x88C2);
 	b43legacy_radio_set_txpower_bg(dev, 0xFFFF, 0xFFFF, 0xFFFF);
-	if (dev->dev->bus->sprom.r1.boardflags_lo & B43legacy_BFL_RSSI) {
+	if (dev->dev->bus->sprom.data.boardflags_lo & B43legacy_BFL_RSSI) {
 		b43legacy_calc_nrssi_slope(dev);
 		b43legacy_calc_nrssi_threshold(dev);
 	}
@@ -699,7 +699,7 @@ static void b43legacy_phy_initb6(struct 
 		b43legacy_radio_write16(dev, 0x005A, 0x0088);
 		b43legacy_radio_write16(dev, 0x005B, 0x006B);
 		b43legacy_radio_write16(dev, 0x005C, 0x000F);
-		if (dev->dev->bus->sprom.r1.boardflags_lo & 0x8000) {
+		if (dev->dev->bus->sprom.data.boardflags_lo & 0x8000) {
 			b43legacy_radio_write16(dev, 0x005D, 0x00FA);
 			b43legacy_radio_write16(dev, 0x005E, 0x00D8);
 		} else {
@@ -797,7 +797,7 @@ static void b43legacy_phy_initb6(struct 
 		b43legacy_phy_write(dev, 0x0062, 0x0007);
 		b43legacy_radio_init2050(dev);
 		b43legacy_phy_lo_g_measure(dev);
-		if (dev->dev->bus->sprom.r1.boardflags_lo &
+		if (dev->dev->bus->sprom.data.boardflags_lo &
 		    B43legacy_BFL_RSSI) {
 			b43legacy_calc_nrssi_slope(dev);
 			b43legacy_calc_nrssi_threshold(dev);
@@ -921,7 +921,7 @@ static void b43legacy_calc_loopback_gain
 			    b43legacy_phy_read(dev, 0x0811) | 0x0100);
 	b43legacy_phy_write(dev, 0x0812,
 			    b43legacy_phy_read(dev, 0x0812) & 0xCFFF);
-	if (dev->dev->bus->sprom.r1.boardflags_lo & B43legacy_BFL_EXTLNA) {
+	if (dev->dev->bus->sprom.data.boardflags_lo & B43legacy_BFL_EXTLNA) {
 		if (phy->rev >= 7) {
 			b43legacy_phy_write(dev, 0x0811,
 					    b43legacy_phy_read(dev, 0x0811)
@@ -1072,7 +1072,7 @@ static void b43legacy_phy_initg(struct b
 			b43legacy_phy_write(dev, 0x0036,
 					    (b43legacy_phy_read(dev, 0x0036)
 					     & 0x0FFF) | (phy->txctl2 << 12));
-		if (dev->dev->bus->sprom.r1.boardflags_lo &
+		if (dev->dev->bus->sprom.data.boardflags_lo &
 		    B43legacy_BFL_PACTRL)
 			b43legacy_phy_write(dev, 0x002E, 0x8075);
 		else
@@ -1087,7 +1087,7 @@ static void b43legacy_phy_initg(struct b
 		b43legacy_phy_write(dev, 0x080F, 0x8078);
 	}
 
-	if (!(dev->dev->bus->sprom.r1.boardflags_lo & B43legacy_BFL_RSSI)) {
+	if (!(dev->dev->bus->sprom.data.boardflags_lo & B43legacy_BFL_RSSI)) {
 		/* The specs state to update the NRSSI LT with
 		 * the value 0x7FFFFFFF here. I think that is some weird
 		 * compiler optimization in the original driver.
@@ -1838,9 +1838,9 @@ void b43legacy_phy_xmitpower(struct b43l
 
 	estimated_pwr = b43legacy_phy_estimate_power_out(dev, average);
 
-	max_pwr = dev->dev->bus->sprom.r1.maxpwr_bg;
+	max_pwr = dev->dev->bus->sprom.data.maxpwr_bg;
 
-	if ((dev->dev->bus->sprom.r1.boardflags_lo
+	if ((dev->dev->bus->sprom.data.boardflags_lo
 	     & B43legacy_BFL_PACTRL) &&
 	    (phy->type == B43legacy_PHYTYPE_G))
 		max_pwr -= 0x3;
@@ -1848,7 +1848,7 @@ void b43legacy_phy_xmitpower(struct b43l
 		b43legacywarn(dev->wl, "Invalid max-TX-power value in SPROM."
 			"\n");
 		max_pwr = 74; /* fake it */
-		dev->dev->bus->sprom.r1.maxpwr_bg = max_pwr;
+		dev->dev->bus->sprom.data.maxpwr_bg = max_pwr;
 	}
 
 	/* Use regulatory information to get the maximum power.
@@ -1858,7 +1858,8 @@ void b43legacy_phy_xmitpower(struct b43l
 	 * and 1.5 dBm (a safety factor??). The result is in Q5.2 format
 	 * which accounts for the factor of 4 */
 #define REG_MAX_PWR 20
-	max_pwr = min(REG_MAX_PWR * 4 - dev->dev->bus->sprom.r1.antenna_gain_bg
+	max_pwr = min(REG_MAX_PWR * 4
+		      - dev->dev->bus->sprom.data.antenna_gain_bg
 		      - 0x6, max_pwr);
 
 	/* find the desired power in Q5.2 - power_level is in dBm
@@ -1918,7 +1919,7 @@ void b43legacy_phy_xmitpower(struct b43l
 				txpower = 3;
 				radio_attenuation += 2;
 				baseband_attenuation += 2;
-			} else if (dev->dev->bus->sprom.r1.boardflags_lo
+			} else if (dev->dev->bus->sprom.data.boardflags_lo
 				   & B43legacy_BFL_PACTRL) {
 				baseband_attenuation += 4 *
 						     (radio_attenuation - 2);
@@ -2000,9 +2001,9 @@ int b43legacy_phy_init_tssi2dbm_table(st
 
 	B43legacy_WARN_ON(!(phy->type == B43legacy_PHYTYPE_B ||
 			  phy->type == B43legacy_PHYTYPE_G));
-	pab0 = (s16)(dev->dev->bus->sprom.r1.pa0b0);
-	pab1 = (s16)(dev->dev->bus->sprom.r1.pa0b1);
-	pab2 = (s16)(dev->dev->bus->sprom.r1.pa0b2);
+	pab0 = (s16)(dev->dev->bus->sprom.data.pa0b0);
+	pab1 = (s16)(dev->dev->bus->sprom.data.pa0b1);
+	pab2 = (s16)(dev->dev->bus->sprom.data.pa0b2);
 
 	if ((dev->dev->bus->chip_id == 0x4301) && (phy->radio_ver != 0x2050)) {
 		phy->idle_tssi = 0x34;
@@ -2013,9 +2014,10 @@ int b43legacy_phy_init_tssi2dbm_table(st
 	if (pab0 != 0 && pab1 != 0 && pab2 != 0 &&
 	    pab0 != -1 && pab1 != -1 && pab2 != -1) {
 		/* The pabX values are set in SPROM. Use them. */
-		if ((s8)dev->dev->bus->sprom.r1.itssi_bg != 0 &&
-		    (s8)dev->dev->bus->sprom.r1.itssi_bg != -1)
-			phy->idle_tssi = (s8)(dev->dev->bus->sprom.r1.itssi_bg);
+		if ((s8)dev->dev->bus->sprom.data.itssi_bg != 0 &&
+		    (s8)dev->dev->bus->sprom.data.itssi_bg != -1)
+			phy->idle_tssi = (s8)(dev->dev->bus->sprom.data.
+					  itssi_bg);
 		else
 			phy->idle_tssi = 62;
 		dyn_tssi2dbm = kmalloc(64, GFP_KERNEL);
Index: wireless-2.6/drivers/net/wireless/b43legacy/radio.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/radio.c
+++ wireless-2.6/drivers/net/wireless/b43legacy/radio.c
@@ -827,7 +827,7 @@ void b43legacy_calc_nrssi_threshold(stru
 	case B43legacy_PHYTYPE_B: {
 		if (phy->radio_ver != 0x2050)
 			return;
-		if (!(dev->dev->bus->sprom.r1.boardflags_lo &
+		if (!(dev->dev->bus->sprom.data.boardflags_lo &
 		    B43legacy_BFL_RSSI))
 			return;
 
@@ -857,7 +857,7 @@ void b43legacy_calc_nrssi_threshold(stru
 	}
 	case B43legacy_PHYTYPE_G:
 		if (!phy->gmode ||
-		    !(dev->dev->bus->sprom.r1.boardflags_lo &
+		    !(dev->dev->bus->sprom.data.boardflags_lo &
 		    B43legacy_BFL_RSSI)) {
 			tmp16 = b43legacy_nrssi_hw_read(dev, 0x20);
 			if (tmp16 >= 0x20)
@@ -1406,7 +1406,7 @@ static u16 b43legacy_get_812_value(struc
 	if (!phy->gmode)
 		return 0;
 	if (!has_loopback_gain(phy)) {
-		if (phy->rev < 7 || !(dev->dev->bus->sprom.r1.boardflags_lo
+		if (phy->rev < 7 || !(dev->dev->bus->sprom.data.boardflags_lo
 		    & B43legacy_BFL_EXTLNA)) {
 			switch (lpd) {
 			case LPD(0, 1, 1):
@@ -1459,7 +1459,7 @@ static u16 b43legacy_get_812_value(struc
 		}
 
 		loop_or = (loop << 8) | extern_lna_control;
-		if (phy->rev >= 7 && dev->dev->bus->sprom.r1.boardflags_lo
+		if (phy->rev >= 7 && dev->dev->bus->sprom.data.boardflags_lo
 		    & B43legacy_BFL_EXTLNA) {
 			if (extern_lna_control)
 				loop_or |= 0x8000;
@@ -1550,7 +1550,7 @@ u16 b43legacy_radio_init2050(struct b43l
 					    b43legacy_get_812_value(dev,
 					    LPD(0, 1, 1)));
 			if (phy->rev < 7 ||
-			    !(dev->dev->bus->sprom.r1.boardflags_lo
+			    !(dev->dev->bus->sprom.data.boardflags_lo
 			    & B43legacy_BFL_EXTLNA))
 				b43legacy_phy_write(dev, 0x0811, 0x01B3);
 			else
@@ -1786,7 +1786,7 @@ int b43legacy_radio_selectchannel(struct
 			  channel2freq_bg(channel));
 
 	if (channel == 14) {
-		if (dev->dev->bus->sprom.r1.country_code == 5)   /* JAPAN) */
+		if (dev->dev->bus->sprom.data.country_code == 5)   /* JAPAN) */
 			b43legacy_shm_write32(dev, B43legacy_SHM_SHARED,
 					      B43legacy_UCODEFLAGS_OFFSET,
 					      b43legacy_shm_read32(dev,
Index: wireless-2.6/drivers/net/wireless/b43legacy/xmit.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/xmit.c
+++ wireless-2.6/drivers/net/wireless/b43legacy/xmit.c
@@ -378,7 +378,7 @@ static s8 b43legacy_rssi_postprocess(str
 			else
 				tmp -= 3;
 		} else {
-			if (dev->dev->bus->sprom.r1.boardflags_lo
+			if (dev->dev->bus->sprom.data.boardflags_lo
 			    & B43legacy_BFL_RSSI) {
 				if (in_rssi > 63)
 					in_rssi = 63;
