Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:12699 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161325AbXBUQDa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Feb 2007 11:03:30 -0500
Received: by nf-out-0910.google.com with SMTP id o25so242969nfa
        for <linux-wireless@vger.kernel.org>; Wed, 21 Feb 2007 08:03:28 -0800 (PST)
To: Jiri Benc <jbenc@suse.cz>,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Subject: [PATCH 3/3] d80211: Split antenna selection into TX and RX antenna
Date: Wed, 21 Feb 2007 17:02:47 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200702211702.48001.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the split antenna selection rt2x00 can now read the default
value for both selections from the EEPROM and can now configure
the card correctly based on the individual RX and TX antenna selections.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/drivers/net/wireless/d80211/rt2x00/rt2400pci.c b/drivers/net/wireless/d80211/rt2x00/rt2400pci.c
index 2e3a514..a64a5a9 100644
--- a/drivers/net/wireless/d80211/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/d80211/rt2x00/rt2400pci.c
@@ -460,7 +460,8 @@ static void rt2400pci_config_txpower(struct rt2x00_dev *rt2x00dev, int txpower)
 	rt2x00dev->tx_power = txpower;
 }
 
-static void rt2400pci_config_antenna(struct rt2x00_dev *rt2x00dev, int antenna)
+static void rt2400pci_config_antenna(struct rt2x00_dev *rt2x00dev,
+	int antenna_tx, int antenna_rx)
 {
 	u8 reg_rx;
 	u8 reg_tx;
@@ -468,7 +469,7 @@ static void rt2400pci_config_antenna(struct rt2x00_dev *rt2x00dev, int antenna)
 	/*
 	 * Only continue when there is something to be done.
 	 */
-	if (rt2x00dev->rx_params.antenna == antenna)
+	if (rt2x00dev->rx_status.antenna == antenna_rx)
 		return;
 
 	rt2x00_bbp_read(rt2x00dev, 4, &reg_rx);
@@ -481,25 +482,24 @@ static void rt2400pci_config_antenna(struct rt2x00_dev *rt2x00dev, int antenna)
 	reg_tx &= ~0x03;
 
 	/*
-	 * Ralink devices have have antenna options for both TX as RX.
-	 * The ieee80211 stack currently only provide the user to set
-	 * 1 antenna, by default this is considered to be the TX antenna.
+	 * Configure the TX antenna.
 	 */
-	if (antenna == 0) {
-		/* Diversity. */
-		reg_rx |= 0x02;
+	if (antenna_tx == 0)		/* Diversity. */
 		reg_tx |= 0x01;
-	} else if (antenna == 1) {
-		/* RX: Antenna B */
-		reg_rx |= 0x04;
-		/* TX: Antenna A */
+	else if (antenna_tx == 1)	/* TX: Antenna A */
 		reg_tx |= 0x00;
-	} else if (antenna == 2) {
-		/* RX: Antenna A */
-		reg_rx |= 0x00;
-		/* TX: Antenna B */
+	else if (antenna_tx == 2)	/* TX: Antenna B */
 		reg_tx |= 0x02;
-	}
+
+	/*
+	 * Configure the RX antenna.
+	 */
+	if (antenna_rx == 0)		/* Diversity. */
+		reg_rx |= 0x02;
+	else if (antenna_rx == 1)	/* RX: Antenna A */
+		reg_rx |= 0x00;
+	else if (antenna_rx == 2)	/* RX: Antenna B */
+		reg_rx |= 0x04;
 
 	rt2x00_bbp_write(rt2x00dev, 4, reg_rx);
 	rt2x00_bbp_write(rt2x00dev, 1, reg_tx);
@@ -507,7 +507,7 @@ static void rt2400pci_config_antenna(struct rt2x00_dev *rt2x00dev, int antenna)
 	/*
 	 * Update active info for RX.
 	 */
-	rt2x00dev->rx_params.antenna = antenna;
+	rt2x00dev->rx_status.antenna = antenna_rx;
 }
 
 static void rt2400pci_config_cw(struct rt2x00_dev *rt2x00dev,
@@ -1972,7 +1972,8 @@ static int rt2400pci_config(struct ieee80211_hw *hw,
 	rt2400pci_config_channel(rt2x00dev,
 		conf->channel_val, conf->channel, conf->freq);
 	rt2400pci_config_txpower(rt2x00dev, conf->power_level);
-	rt2400pci_config_antenna(rt2x00dev, conf->antenna_sel);
+	rt2400pci_config_antenna(rt2x00dev,
+		conf->antenna_sel_tx, conf->antenna_sel_rx);
 	rt2400pci_config_duration(rt2x00dev,
 		(conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME));
 	rt2400pci_config_phymode(rt2x00dev, conf->phymode);
@@ -2444,12 +2445,11 @@ static int rt2400pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 
 	/*
 	 * Identify default antenna configuration.
-	 * Ralink devices have have antenna options for both TX as RX.
-	 * The ieee80211 stack currently only provide the user to set
-	 * 1 antenna, by default this is considered to be the TX antenna.
 	 */
-	rt2x00dev->hw->conf.antenna_sel = rt2x00_get_field16(eeprom,
+	rt2x00dev->hw->conf.antenna_sel_tx = rt2x00_get_field16(eeprom,
 		EEPROM_ANTENNA_TX_DEFAULT);
+	rt2x00dev->hw->conf.antenna_sel_rx = rt2x00_get_field16(eeprom,
+		EEPROM_ANTENNA_RX_DEFAULT);
 
 	/*
 	 * Store led mode, for correct led behaviour.
diff --git a/drivers/net/wireless/d80211/rt2x00/rt2500pci.c b/drivers/net/wireless/d80211/rt2x00/rt2500pci.c
index 305cff6..aee6233 100644
--- a/drivers/net/wireless/d80211/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/d80211/rt2x00/rt2500pci.c
@@ -509,7 +509,8 @@ static void rt2500pci_config_txpower(struct rt2x00_dev *rt2x00dev, int txpower)
 	rt2x00dev->tx_power = txpower;
 }
 
-static void rt2500pci_config_antenna(struct rt2x00_dev *rt2x00dev, int antenna)
+static void rt2500pci_config_antenna(struct rt2x00_dev *rt2x00dev,
+	int antenna_tx, int antenna_rx)
 {
 	u32 reg;
 	u8 reg_rx;
@@ -518,7 +519,7 @@ static void rt2500pci_config_antenna(struct rt2x00_dev *rt2x00dev, int antenna)
 	/*
 	 * Only continue when there is something to be done.
 	 */
-	if (rt2x00dev->rx_params.antenna == antenna)
+	if (rt2x00dev->rx_status.antenna == antenna_rx)
 		return;
 
 	rt2x00_register_read(rt2x00dev, BBPCSR1, &reg);
@@ -532,33 +533,33 @@ static void rt2500pci_config_antenna(struct rt2x00_dev *rt2x00dev, int antenna)
 	reg_tx &= ~0x03;
 
 	/*
-	 * Ralink devices have have antenna options for both TX as RX.
-	 * The ieee80211 stack currently only provide the user to set
-	 * 1 antenna, by default this is considered to be the TX antenna.
+	 * Configure the TX antenna.
 	 */
-	if (antenna == 0) {
-		/* Diversity. */
-		reg_rx |= 0x02;
+	if (antenna_tx == 0) {		/* Diversity. */
 		reg_tx |= 0x02;
 		rt2x00_set_field32(&reg, BBPCSR1_CCK, 2);
 		rt2x00_set_field32(&reg, BBPCSR1_OFDM, 2);
-	} else if (antenna == 1) {
-		/* RX: Antenna B */
-		reg_rx |= 0x02;
-		/* TX: Antenna A */
+	} else if (antenna_tx == 1) {	/* TX: Antenna A */
 		reg_tx |= 0x00;
 		rt2x00_set_field32(&reg, BBPCSR1_CCK, 0);
 		rt2x00_set_field32(&reg, BBPCSR1_OFDM, 0);
-	} else if (antenna == 2) {
-		/* RX: Antenna A */
-		reg_rx |= 0x00;
-		/* TX: Antenna B */
+	} else if (antenna_tx == 2) {	/* TX: Antenna B */
 		reg_tx |= 0x02;
 		rt2x00_set_field32(&reg, BBPCSR1_CCK, 2);
 		rt2x00_set_field32(&reg, BBPCSR1_OFDM, 2);
 	}
 
 	/*
+	 * Configure the RX antenna.
+	 */
+	if (antenna_rx == 0)		/* Diversity. */
+		reg_rx |= 0x02;
+	else if (antenna_rx == 1)	/* RX: Antenna A */
+		reg_rx |= 0x00;
+	else if (antenna_rx == 2)	/* RX: Antenna B */
+		reg_rx |= 0x02;
+
+	/*
 	 * RT2525E and RT5222 need to flip TX I/Q
 	 */
 	if (rt2x00_rf(&rt2x00dev->chip, RF2525E) ||
@@ -584,7 +585,7 @@ static void rt2500pci_config_antenna(struct rt2x00_dev *rt2x00dev, int antenna)
 	/*
 	 * Update active info for RX.
 	 */
-	rt2x00dev->rx_params.antenna = antenna;
+	rt2x00dev->rx_status.antenna = antenna_rx;
 }
 
 static void rt2500pci_config_duration(struct rt2x00_dev *rt2x00dev,
@@ -2137,7 +2138,8 @@ static int rt2500pci_config(struct ieee80211_hw *hw,
 		conf->channel_val, conf->channel, conf->freq,
 		conf->power_level);
 	rt2500pci_config_txpower(rt2x00dev, conf->power_level);
-	rt2500pci_config_antenna(rt2x00dev, conf->antenna_sel);
+	rt2500pci_config_antenna(rt2x00dev,
+		conf->antenna_sel_tx, conf->antenna_sel_rx);
 	rt2500pci_config_duration(rt2x00dev,
 		(conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME));
 	rt2500pci_config_phymode(rt2x00dev, conf->phymode);
@@ -2605,12 +2607,11 @@ static int rt2500pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 
 	/*
 	 * Identify default antenna configuration.
-	 * Ralink devices have have antenna options for both TX as RX.
-	 * The ieee80211 stack currently only provide the user to set
-	 * 1 antenna, by default this is considered to be the TX antenna.
 	 */
-	rt2x00dev->hw->conf.antenna_sel = rt2x00_get_field16(eeprom,
+	rt2x00dev->hw->conf.antenna_sel_tx = rt2x00_get_field16(eeprom,
 		EEPROM_ANTENNA_TX_DEFAULT);
+	rt2x00dev->hw->conf.antenna_sel_rx = rt2x00_get_field16(eeprom,
+		EEPROM_ANTENNA_RX_DEFAULT);
 
 	/*
 	 * Store led mode, for correct led behaviour.
diff --git a/drivers/net/wireless/d80211/rt2x00/rt2500usb.c b/drivers/net/wireless/d80211/rt2x00/rt2500usb.c
index 0976c98..8caaadd 100644
--- a/drivers/net/wireless/d80211/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/d80211/rt2x00/rt2500usb.c
@@ -559,7 +559,8 @@ static void rt2500usb_config_txpower(struct rt2x00_dev *rt2x00dev, int txpower)
 	rt2x00dev->tx_power = txpower;
 }
 
-static void rt2500usb_config_antenna(struct rt2x00_dev *rt2x00dev, int antenna)
+static void rt2500usb_config_antenna(struct rt2x00_dev *rt2x00dev,
+	int antenna_tx, int antenna_rx)
 {
 	u8 reg_rx;
 	u8 reg_tx;
@@ -569,7 +570,7 @@ static void rt2500usb_config_antenna(struct rt2x00_dev *rt2x00dev, int antenna)
 	/*
 	 * Only continue when there is something to be done.
 	 */
-	if (rt2x00dev->rx_params.antenna == antenna)
+	if (rt2x00dev->rx_status.antenna == antenna_rx)
 		return;
 
 	rt2x00_bbp_read(rt2x00dev, 2, &reg_tx);
@@ -584,33 +585,33 @@ static void rt2500usb_config_antenna(struct rt2x00_dev *rt2x00dev, int antenna)
 	reg_rx &= ~0x03;
 
 	/*
-	 * Ralink devices have have antenna options for both TX as RX.
-	 * The ieee80211 stack currently only provide the user to set
-	 * 1 antenna, by default this is considered to be the TX antenna.
+	 * Configure the TX antenna.
 	 */
-	if (antenna == 0) {
-		/* Diversity. */
-		reg_rx |= 0x01;
+	if (antenna_tx == 0) {		/* Diversity. */
 		reg_tx |= 0x01;
 		rt2x00_set_field16(&csr5_reg, PHY_CSR5_CCK, 1);
 		rt2x00_set_field16(&csr6_reg, PHY_CSR6_OFDM, 1);
-	} else if (antenna == 1) {
-		/* RX: Antenna B */
-		reg_rx |= 0x02;
-		/* TX: Antenna A */
+	} else if (antenna_tx == 1) {	/* TX: Antenna A */
 		reg_tx |= 0x00;
 		rt2x00_set_field16(&csr5_reg, PHY_CSR5_CCK, 0);
 		rt2x00_set_field16(&csr6_reg, PHY_CSR6_OFDM, 0);
-	} else if (antenna == 2) {
-		/* RX: Antenna A */
-		reg_rx |= 0x00;
-		/* TX: Antenna B */
+	} else if (antenna_tx == 2) {	/* TX: Antenna B */
 		reg_tx |= 0x02;
 		rt2x00_set_field16(&csr5_reg, PHY_CSR5_CCK, 2);
 		rt2x00_set_field16(&csr6_reg, PHY_CSR6_OFDM, 2);
 	}
 
 	/*
+	 * Configure the RX antenna.
+	 */
+	if (antenna_rx == 0)		/* Diversity. */
+		reg_rx |= 0x01;
+	else if (antenna_rx == 1)	/* RX: Antenna A */
+		reg_rx |= 0x00;
+	else if (antenna_rx == 2)	/* RX: Antenna B */
+		reg_rx |= 0x02;
+
+	/*
 	 * RT2525E and RT5222 need to flip TX I/Q
 	 */
 	if (rt2x00_rf(&rt2x00dev->chip, RF2525E) ||
@@ -637,7 +638,7 @@ static void rt2500usb_config_antenna(struct rt2x00_dev *rt2x00dev, int antenna)
 	/*
 	 * Update active info for RX.
 	 */
-	rt2x00dev->rx_params.antenna = antenna;
+	rt2x00dev->rx_status.antenna = antenna_rx;
 }
 
 static void rt2500usb_config_duration(struct rt2x00_dev *rt2x00dev,
@@ -2073,7 +2074,8 @@ static int rt2500usb_config(struct ieee80211_hw *hw,
 		conf->channel_val, conf->channel, conf->freq,
 		conf->power_level);
 	rt2500usb_config_txpower(rt2x00dev, conf->power_level);
-	rt2500usb_config_antenna(rt2x00dev, conf->antenna_sel);
+	rt2500usb_config_antenna(rt2x00dev,
+		conf->antenna_sel_tx, conf->antenna_sel_rx);
 	rt2500usb_config_duration(rt2x00dev,
 		(conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME));
 	rt2500usb_config_phymode(rt2x00dev, conf->phymode);
@@ -2455,12 +2457,11 @@ static int rt2500usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 
 	/*
 	 * Identify default antenna configuration.
-	 * Ralink devices have have antenna options for both TX as RX.
-	 * The ieee80211 stack currently only provide the user to set
-	 * 1 antenna, by default this is considered to be the TX antenna.
 	 */
-	rt2x00dev->hw->conf.antenna_sel = rt2x00_get_field16(eeprom,
+	rt2x00dev->hw->conf.antenna_sel_tx = rt2x00_get_field16(eeprom,
 		EEPROM_ANTENNA_TX_DEFAULT);
+	rt2x00dev->hw->conf.antenna_sel_rx = rt2x00_get_field16(eeprom,
+		EEPROM_ANTENNA_RX_DEFAULT);
 
 	/*
 	 * Store led mode, for correct led behaviour.
diff --git a/drivers/net/wireless/d80211/rt2x00/rt61pci.c b/drivers/net/wireless/d80211/rt2x00/rt61pci.c
index 547c660..51ada44 100644
--- a/drivers/net/wireless/d80211/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/d80211/rt2x00/rt61pci.c
@@ -677,7 +677,7 @@ static void rt61pci_config_txpower(struct rt2x00_dev *rt2x00dev, int txpower)
 }
 
 static void rt61pci_config_antenna(struct rt2x00_dev *rt2x00dev,
-	int antenna, int phymode)
+	int antenna_tx, int antenna_rx, int phymode)
 {
 	u32 reg;
 	u8 reg_r3;
@@ -688,7 +688,7 @@ static void rt61pci_config_antenna(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Only continue when there is something to be done.
 	 */
-	if (rt2x00dev->rx_params.antenna == antenna)
+	if (rt2x00dev->rx_status.antenna == antenna_rx)
 		return;
 
 	rt2x00_register_read(rt2x00dev, PHY_CSR0, &reg);
@@ -753,50 +753,40 @@ static void rt61pci_config_antenna(struct rt2x00_dev *rt2x00dev,
 
 	if (rt2x00_rf(&rt2x00dev->chip, RF5225) ||
 	    rt2x00_rf(&rt2x00dev->chip, RF5325)) {
-		if (antenna == 0) {
-			/* Diversity. */
+		if (antenna_rx == 0) {		/* Diversity. */
 			reg_r4 |= 0x02;
 			if (phymode != MODE_IEEE80211A)
 				reg_r4 |= 0x20;
-		} else if (antenna == 1) {
-			/* RX: Antenna B */
-			/* TX: Antenna A */
+		} else if (antenna_rx == 1) {	/* RX: Antenna A */
 			reg_r4 |= 0x01;
 			if (phymode == MODE_IEEE80211A)
-				reg_r77 |= 0x03;
-			else
 				reg_r77 &= ~0x03;
+			else
+				reg_r77 |= 0x03;
 			rt2x00_bbp_write(rt2x00dev, 77, reg_r77);
-		} else if (antenna == 2) {
-			/* RX: Antenna A */
-			/* TX: Antenna B */
+		} else if (antenna_rx == 2) {	/* RX: Antenna B */
 			reg_r4 |= 0x01;
 			if (phymode == MODE_IEEE80211A)
-				reg_r77 &= ~0x03;
-			else
 				reg_r77 |= 0x03;
+			else
+				reg_r77 &= ~0x03;
 			rt2x00_bbp_write(rt2x00dev, 77, reg_r77);
 		}
 	} else if (rt2x00_rf(&rt2x00dev->chip, RF2527) ||
 		   (rt2x00_rf(&rt2x00dev->chip, RF2529) &&
 		    GET_FLAG(rt2x00dev, CONFIG_DOUBLE_ANTENNA))) {
-		if (antenna == 0) {
-			/* Diversity. */
+		if (antenna_rx == 0) {		/* Diversity. */
 			reg_r4 |= 0x22;
 			reg_r4 &= frame_type;
-		} else if (antenna == 1) {
-			/* RX: Antenna B */
-			/* TX: Antenna A */
+		} else if (antenna_rx == 1) {	/* RX: Antenna A */
 			reg_r4 |= 0x21;
 			reg_r4 &= frame_type;
-			reg_r77 &= ~0x03;
+			reg_r77 |= 0x03;
 			rt2x00_bbp_write(rt2x00dev, 77, reg_r77);
-		} else if (antenna == 2) {
-			/* RX: Antenna A */
-			/* TX: Antenna B */
+		} else if (antenna_rx == 2) {	/* RX: Antenna B */
 			reg_r4 |= 0x21;
 			reg_r4 &= frame_type;
-			reg_r77 |= 0x03;
+			reg_r77 &= ~0x03;
 			rt2x00_bbp_write(rt2x00dev, 77, reg_r77);
 		}
 	}
@@ -813,7 +803,7 @@ static void rt61pci_config_antenna(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Update active info for RX.
 	 */
-	rt2x00dev->rx_params.antenna = antenna;
+	rt2x00dev->rx_status.antenna = antenna_rx;
 }
 
 static void rt61pci_config_duration(struct rt2x00_dev *rt2x00dev,
@@ -2632,7 +2622,8 @@ static int rt61pci_config(struct ieee80211_hw *hw,
 		conf->channel_val, conf->channel, conf->freq,
 		conf->power_level);
 	rt61pci_config_txpower(rt2x00dev, conf->power_level);
-	rt61pci_config_antenna(rt2x00dev, conf->antenna_sel, conf->phymode);
+	rt61pci_config_antenna(rt2x00dev,
+		conf->antenna_sel_tx, conf->antenna_sel_rx, conf->phymode);
 	rt61pci_config_duration(rt2x00dev,
 		(conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME));
 	rt61pci_config_phymode(rt2x00dev, conf->phymode);
@@ -3095,12 +3086,11 @@ static int rt61pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 
 	/*
 	 * Identify default antenna configuration.
-	 * Ralink devices have have antenna options for both TX as RX.
-	 * The ieee80211 stack currently only provide the user to set
-	 * 1 antenna, by default this is considered to be the TX antenna.
 	 */
-	rt2x00dev->hw->conf.antenna_sel = rt2x00_get_field16(eeprom,
+	rt2x00dev->hw->conf.antenna_sel_tx = rt2x00_get_field16(eeprom,
 		EEPROM_ANTENNA_TX_DEFAULT);
+	rt2x00dev->hw->conf.antenna_sel_rx = rt2x00_get_field16(eeprom,
+		EEPROM_ANTENNA_RX_DEFAULT);
 
 	/*
 	 * Read the Frame type.
diff --git a/drivers/net/wireless/d80211/rt2x00/rt73usb.c b/drivers/net/wireless/d80211/rt2x00/rt73usb.c
index be66e2f..922b6f0 100644
--- a/drivers/net/wireless/d80211/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/d80211/rt2x00/rt73usb.c
@@ -586,7 +586,7 @@ static void rt73usb_config_txpower(struct rt2x00_dev *rt2x00dev, int txpower)
 }
 
 static void rt73usb_config_antenna(struct rt2x00_dev *rt2x00dev,
-	int antenna, int phymode)
+	int antenna_tx, int antenna_rx, int phymode)
 {
 	u32 reg;
 	u8 reg_r3;
@@ -597,7 +597,7 @@ static void rt73usb_config_antenna(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Only continue when there is something to be done.
 	 */
-	if (rt2x00dev->rx_params.antenna == antenna)
+	if (rt2x00dev->rx_status.antenna == antenna_rx)
 		return;
 
 	rt2x00_register_read(rt2x00dev, PHY_CSR0, &reg);
@@ -660,52 +660,42 @@ static void rt73usb_config_antenna(struct rt2x00_dev *rt2x00dev,
 
 	if (rt2x00_rf(&rt2x00dev->chip, RF5226) ||
 	    rt2x00_rf(&rt2x00dev->chip, RF5225)) {
-		if (antenna == 0) {
-			/* Diversity. */
+		if (antenna_rx == 0) {		/* Diversity. */
 			reg_r4 |= 0x02;
 			if (phymode != MODE_IEEE80211A)
 				reg_r4 |= 0x20;
 			reg_r4 &= frame_type;
-		} else if (antenna == 1) {
-			/* RX: Antenna B */
-			/* TX: Antenna A */
+		} else if (antenna_rx == 1) {	/* RX: Antenna A */
 			reg_r4 |= 0x01;
 			reg_r4 &= frame_type;
 			if (phymode == MODE_IEEE80211A)
-				reg_r77 |= 0x03;
-			else
 				reg_r77 &= ~0x03;
+			else
+				reg_r77 |= 0x03;
 			rt2x00_bbp_write(rt2x00dev, 77, reg_r77);
-		} else if (antenna == 2) {
-			/* RX: Antenna A */
-			/* TX: Antenna B */
+		} else if (antenna_rx == 2) {	/* RX: Antenna B */
 			reg_r4 |= 0x01;
 			reg_r4 &= frame_type;
 			if (phymode == MODE_IEEE80211A)
-				reg_r77 &= ~0x03;
-			else
 				reg_r77 |= 0x03;
+			else
+				reg_r77 &= ~0x03;
 			rt2x00_bbp_write(rt2x00dev, 77, reg_r77);
 		}
 	} else if (rt2x00_rf(&rt2x00dev->chip, RF2528) ||
 		   rt2x00_rf(&rt2x00dev->chip, RF2527)) {
-		if (antenna == 0) {
-			/* Diversity. */
+		if (antenna_rx == 0) {		/* Diversity. */
 			reg_r4 |= 0x22;
 			reg_r4 &= frame_type;
-		} else if (antenna == 1) {
-			/* RX: Antenna B */
-			/* TX: Antenna A */
+		} else if (antenna_rx == 1) {	/* RX: Antenna A */
 			reg_r4 |= 0x21;
 			reg_r4 &= frame_type;
-			reg_r77 &= ~0x03;
+			reg_r77 |= 0x03;
 			rt2x00_bbp_write(rt2x00dev, 77, reg_r77);
-		} else if (antenna == 2) {
-			/* RX: Antenna A */
-			/* TX: Antenna B */
+		} else if (antenna_rx == 2) {	/* RX: Antenna B */
 			reg_r4 |= 0x21;
 			reg_r4 &= frame_type;
-			reg_r77 |= 0x03;
+			reg_r77 &= ~0x03;
 			rt2x00_bbp_write(rt2x00dev, 77, reg_r77);
 		}
 	}
@@ -716,7 +706,7 @@ static void rt73usb_config_antenna(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Update active info for RX.
 	 */
-	rt2x00dev->rx_params.antenna = antenna;
+	rt2x00dev->rx_status.antenna = antenna_rx;
 }
 
 static void rt73usb_config_duration(struct rt2x00_dev *rt2x00dev,
@@ -2344,7 +2334,8 @@ static int rt73usb_config(struct ieee80211_hw *hw,
 		conf->channel_val, conf->channel, conf->freq,
 		conf->power_level);
 	rt73usb_config_txpower(rt2x00dev, conf->power_level);
-	rt73usb_config_antenna(rt2x00dev, conf->antenna_sel, conf->phymode);
+	rt73usb_config_antenna(rt2x00dev,
+		conf->antenna_sel_tx, conf->antenna_sel_rx, conf->phymode);
 	rt73usb_config_duration(rt2x00dev,
 		(conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME));
 	rt73usb_config_phymode(rt2x00dev, conf->phymode);
@@ -2770,12 +2761,11 @@ static int rt73usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 
 	/*
 	 * Identify default antenna configuration.
-	 * Ralink devices have have antenna options for both TX as RX.
-	 * The ieee80211 stack currently only provide the user to set
-	 * 1 antenna, by default this is considered to be the TX antenna.
 	 */
-	rt2x00dev->hw->conf.antenna_sel = rt2x00_get_field16(eeprom,
+	rt2x00dev->hw->conf.antenna_sel_tx = rt2x00_get_field16(eeprom,
 		EEPROM_ANTENNA_TX_DEFAULT);
+	rt2x00dev->hw->conf.antenna_sel_rx = rt2x00_get_field16(eeprom,
+		EEPROM_ANTENNA_RX_DEFAULT);
 
 	/*
 	 * Read the Frame type.
