Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:4082 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbXJ0LYz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Oct 2007 07:24:55 -0400
Received: by nf-out-0910.google.com with SMTP id g13so973044nfb
        for <linux-wireless@vger.kernel.org>; Sat, 27 Oct 2007 04:24:54 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3/21] rt2x00: Correctly translate mac80211 antenna setup to rt2x00
Date: Sat, 27 Oct 2007 13:36:26 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200710271334.34192.IvDoorn@gmail.com>
In-Reply-To: <200710271334.34192.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200710271336.26508.IvDoorn@gmail.com> (sfid-20071027_122504_461106_09443FB6)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 has 3 values for the antenna setup:
 0 - default
 1 - use antenna 1
 2 - use antenna 2

This means that rt2x00 should store the default value
from the EEPROM somwhere and use that when mac80211 indicates
that the antenna setup is 0.
This also implies that rt2x00 should no longer write the
hw->config.antenna_sel_* values based on the EEPROM input.

This also adds the basis in rt2x00lib for correct software
diversity handling. By default rt2x00lib will now configure
antenna B instead of hardware diversity.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c    |   25 +++++++++----
 drivers/net/wireless/rt2x00/rt2500pci.c    |   14 +++----
 drivers/net/wireless/rt2x00/rt2500usb.c    |   25 +++++++++----
 drivers/net/wireless/rt2x00/rt2x00.h       |   25 +++++++++++++-
 drivers/net/wireless/rt2x00/rt2x00config.c |   51 ++++++++++++++++++++++++++-
 drivers/net/wireless/rt2x00/rt2x00dev.c    |    1 +
 drivers/net/wireless/rt2x00/rt61pci.c      |   32 +++++++----------
 drivers/net/wireless/rt2x00/rt73usb.c      |   23 +++++-------
 8 files changed, 137 insertions(+), 59 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 31bbb44..2284cb3 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -397,7 +397,7 @@ static void rt2400pci_config_txpower(struct rt2x00_dev *rt2x00dev, int txpower)
 }
 
 static void rt2400pci_config_antenna(struct rt2x00_dev *rt2x00dev,
-				     int antenna_tx, int antenna_rx)
+				     struct antenna_setup *ant)
 {
 	u8 r1;
 	u8 r4;
@@ -408,7 +408,7 @@ static void rt2400pci_config_antenna(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Configure the TX antenna.
 	 */
-	switch (antenna_tx) {
+	switch (ant->tx) {
 	case ANTENNA_SW_DIVERSITY:
 	case ANTENNA_HW_DIVERSITY:
 		rt2x00_set_field8(&r1, BBP_R1_TX_ANTENNA, 1);
@@ -424,7 +424,7 @@ static void rt2400pci_config_antenna(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Configure the RX antenna.
 	 */
-	switch (antenna_rx) {
+	switch (ant->rx) {
 	case ANTENNA_SW_DIVERSITY:
 	case ANTENNA_HW_DIVERSITY:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 1);
@@ -485,9 +485,7 @@ static void rt2400pci_config(struct rt2x00_dev *rt2x00dev,
 		rt2400pci_config_txpower(rt2x00dev,
 					 libconf->conf->power_level);
 	if (flags & CONFIG_UPDATE_ANTENNA)
-		rt2400pci_config_antenna(rt2x00dev,
-					 libconf->conf->antenna_sel_tx,
-					 libconf->conf->antenna_sel_rx);
+		rt2400pci_config_antenna(rt2x00dev, &libconf->ant);
 	if (flags & (CONFIG_UPDATE_SLOT_TIME | CONFIG_UPDATE_BEACON_INT))
 		rt2400pci_config_duration(rt2x00dev, libconf);
 }
@@ -1316,12 +1314,23 @@ static int rt2400pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Identify default antenna configuration.
 	 */
-	rt2x00dev->hw->conf.antenna_sel_tx =
+	rt2x00dev->default_ant.tx =
 	    rt2x00_get_field16(eeprom, EEPROM_ANTENNA_TX_DEFAULT);
-	rt2x00dev->hw->conf.antenna_sel_rx =
+	rt2x00dev->default_ant.rx =
 	    rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RX_DEFAULT);
 
 	/*
+	 * When the eeprom indicates SW_DIVERSITY use HW_DIVERSITY instead.
+	 * I am not 100% sure about this, but the legacy drivers do not
+	 * indicate antenna swapping in software is required when
+	 * diversity is enabled.
+	 */
+	if (rt2x00dev->default_ant.tx == ANTENNA_SW_DIVERSITY)
+		rt2x00dev->default_ant.tx = ANTENNA_HW_DIVERSITY;
+	if (rt2x00dev->default_ant.rx == ANTENNA_SW_DIVERSITY)
+		rt2x00dev->default_ant.rx = ANTENNA_HW_DIVERSITY;
+
+	/*
 	 * Store led mode, for correct led behaviour.
 	 */
 	rt2x00dev->led_mode =
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 5ecce34..a004cd9 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -424,7 +424,7 @@ static void rt2500pci_config_txpower(struct rt2x00_dev *rt2x00dev,
 }
 
 static void rt2500pci_config_antenna(struct rt2x00_dev *rt2x00dev,
-				     const int antenna_tx, const int antenna_rx)
+				     struct antenna_setup *ant)
 {
 	u32 reg;
 	u8 r14;
@@ -437,7 +437,7 @@ static void rt2500pci_config_antenna(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Configure the TX antenna.
 	 */
-	switch (antenna_tx) {
+	switch (ant->tx) {
 	case ANTENNA_SW_DIVERSITY:
 	case ANTENNA_HW_DIVERSITY:
 		rt2x00_set_field8(&r2, BBP_R2_TX_ANTENNA, 2);
@@ -459,7 +459,7 @@ static void rt2500pci_config_antenna(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Configure the RX antenna.
 	 */
-	switch (antenna_rx) {
+	switch (ant->rx) {
 	case ANTENNA_SW_DIVERSITY:
 	case ANTENNA_HW_DIVERSITY:
 		rt2x00_set_field8(&r14, BBP_R14_RX_ANTENNA, 2);
@@ -541,9 +541,7 @@ static void rt2500pci_config(struct rt2x00_dev *rt2x00dev,
 		rt2500pci_config_txpower(rt2x00dev,
 					 libconf->conf->power_level);
 	if (flags & CONFIG_UPDATE_ANTENNA)
-		rt2500pci_config_antenna(rt2x00dev,
-					 libconf->conf->antenna_sel_tx,
-					 libconf->conf->antenna_sel_rx);
+		rt2500pci_config_antenna(rt2x00dev, &libconf->ant);
 	if (flags & (CONFIG_UPDATE_SLOT_TIME | CONFIG_UPDATE_BEACON_INT))
 		rt2500pci_config_duration(rt2x00dev, libconf);
 }
@@ -1485,9 +1483,9 @@ static int rt2500pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Identify default antenna configuration.
 	 */
-	rt2x00dev->hw->conf.antenna_sel_tx =
+	rt2x00dev->default_ant.tx =
 	    rt2x00_get_field16(eeprom, EEPROM_ANTENNA_TX_DEFAULT);
-	rt2x00dev->hw->conf.antenna_sel_rx =
+	rt2x00dev->default_ant.rx =
 	    rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RX_DEFAULT);
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 487d89e..4b92f10 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -385,7 +385,7 @@ static void rt2500usb_config_txpower(struct rt2x00_dev *rt2x00dev,
 }
 
 static void rt2500usb_config_antenna(struct rt2x00_dev *rt2x00dev,
-				     const int antenna_tx, const int antenna_rx)
+				     struct antenna_setup *ant)
 {
 	u8 r2;
 	u8 r14;
@@ -400,7 +400,7 @@ static void rt2500usb_config_antenna(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Configure the TX antenna.
 	 */
-	switch (antenna_tx) {
+	switch (ant->tx) {
 	case ANTENNA_SW_DIVERSITY:
 	case ANTENNA_HW_DIVERSITY:
 		rt2x00_set_field8(&r2, BBP_R2_TX_ANTENNA, 1);
@@ -422,7 +422,7 @@ static void rt2500usb_config_antenna(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Configure the RX antenna.
 	 */
-	switch (antenna_rx) {
+	switch (ant->rx) {
 	case ANTENNA_SW_DIVERSITY:
 	case ANTENNA_HW_DIVERSITY:
 		rt2x00_set_field8(&r14, BBP_R14_RX_ANTENNA, 1);
@@ -487,9 +487,7 @@ static void rt2500usb_config(struct rt2x00_dev *rt2x00dev,
 		rt2500usb_config_txpower(rt2x00dev,
 					 libconf->conf->power_level);
 	if (flags & CONFIG_UPDATE_ANTENNA)
-		rt2500usb_config_antenna(rt2x00dev,
-					 libconf->conf->antenna_sel_tx,
-					 libconf->conf->antenna_sel_rx);
+		rt2500usb_config_antenna(rt2x00dev, &libconf->ant);
 	if (flags & (CONFIG_UPDATE_SLOT_TIME | CONFIG_UPDATE_BEACON_INT))
 		rt2500usb_config_duration(rt2x00dev, libconf);
 }
@@ -1278,12 +1276,23 @@ static int rt2500usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Identify default antenna configuration.
 	 */
-	rt2x00dev->hw->conf.antenna_sel_tx =
+	rt2x00dev->default_ant.tx =
 	    rt2x00_get_field16(eeprom, EEPROM_ANTENNA_TX_DEFAULT);
-	rt2x00dev->hw->conf.antenna_sel_rx =
+	rt2x00dev->default_ant.rx =
 	    rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RX_DEFAULT);
 
 	/*
+	 * When the eeprom indicates SW_DIVERSITY use HW_DIVERSITY instead.
+	 * I am not 100% sure about this, but the legacy drivers do not
+	 * indicate antenna swapping in software is required when
+	 * diversity is enabled.
+	 */
+	if (rt2x00dev->default_ant.tx == ANTENNA_SW_DIVERSITY)
+		rt2x00dev->default_ant.tx = ANTENNA_HW_DIVERSITY;
+	if (rt2x00dev->default_ant.rx == ANTENNA_SW_DIVERSITY)
+		rt2x00dev->default_ant.rx = ANTENNA_HW_DIVERSITY;
+
+	/*
 	 * Store led mode, for correct led behaviour.
 	 */
 	rt2x00dev->led_mode =
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 046c95e..dcf7fd7 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -180,6 +180,14 @@ struct rf_channel {
 };
 
 /*
+ * Antenna setup values.
+ */
+struct antenna_setup {
+	enum antenna rx;
+	enum antenna tx;
+};
+
+/*
  * Quality statistics about the currently active link.
  */
 struct link_qual {
@@ -251,6 +259,13 @@ struct link {
 	struct link_qual qual;
 
 	/*
+	 * Currently active TX/RX antenna setup.
+	 * When software diversity is used, this will indicate
+	 * which antenna is actually used at this time.
+	 */
+	struct antenna_setup active_ant;
+
+	/*
 	 * Active VGC level
 	 */
 	int vgc_level;
@@ -272,7 +287,6 @@ static inline void rt2x00_clear_link(struct link *link)
 	link->qual.tx_percentage = 50;
 }
 
-
 /*
  * Update the rssi using the walking average approach.
  */
@@ -378,6 +392,8 @@ struct rt2x00lib_conf {
 	struct ieee80211_conf *conf;
 	struct rf_channel rf;
 
+	struct antenna_setup ant;
+
 	int phymode;
 
 	int basic_rates;
@@ -583,6 +599,13 @@ struct rt2x00_dev {
 	struct hw_mode_spec spec;
 
 	/*
+	 * This is the default TX/RX antenna setup as indicated
+	 * by the device's EEPROM. When mac80211 sets its
+	 * antenna value to 0 we should be using these values.
+	 */
+	struct antenna_setup default_ant;
+
+	/*
 	 * Register pointers
 	 * csr_addr: Base register address. (PCI)
 	 * csr_cache: CSR cache for usb_control_msg. (USB)
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index 12914cf..04518b0 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -100,6 +100,8 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
 	struct rt2x00lib_conf libconf;
 	struct ieee80211_hw_mode *mode;
 	struct ieee80211_rate *rate;
+	struct antenna_setup *default_ant = &rt2x00dev->default_ant;
+	struct antenna_setup *active_ant = &rt2x00dev->link.active_ant;
 	int flags = 0;
 	int short_slot_time;
 
@@ -122,7 +124,35 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
 		flags |= CONFIG_UPDATE_CHANNEL;
 	if (rt2x00dev->tx_power != conf->power_level)
 		flags |= CONFIG_UPDATE_TXPOWER;
-	if (rt2x00dev->rx_status.antenna == conf->antenna_sel_rx)
+
+	/*
+	 * Determining changes in the antenna setups request several checks:
+	 * antenna_sel_{r,t}x = 0
+	 *    -> Does active_{r,t}x match default_{r,t}x
+	 *    -> Is default_{r,t}x SW_DIVERSITY
+	 * antenna_sel_{r,t}x = 1/2
+	 *    -> Does active_{r,t}x match antenna_sel_{r,t}x
+	 * The reason for not updating the antenna while SW diversity
+	 * should be used is simple: Software diversity means that
+	 * we should switch between the antenna's based on the
+	 * quality. This means that the current antenna is good enough
+	 * to work with untill the link tuner decides that an antenna
+	 * switch should be performed.
+	 */
+	if (!conf->antenna_sel_rx &&
+	    default_ant->rx != ANTENNA_SW_DIVERSITY &&
+	    default_ant->rx != active_ant->rx)
+		flags |= CONFIG_UPDATE_ANTENNA;
+	else if (conf->antenna_sel_rx &&
+		 conf->antenna_sel_rx != active_ant->rx)
+		flags |= CONFIG_UPDATE_ANTENNA;
+
+	if (!conf->antenna_sel_tx &&
+	    default_ant->tx != ANTENNA_SW_DIVERSITY &&
+	    default_ant->tx != active_ant->tx)
+		flags |= CONFIG_UPDATE_ANTENNA;
+	else if (conf->antenna_sel_tx &&
+		 conf->antenna_sel_tx != active_ant->tx)
 		flags |= CONFIG_UPDATE_ANTENNA;
 
 	/*
@@ -171,6 +201,22 @@ config:
 		       sizeof(libconf.rf));
 	}
 
+	if (flags & CONFIG_UPDATE_ANTENNA) {
+		if (conf->antenna_sel_rx)
+			libconf.ant.rx = conf->antenna_sel_rx;
+		else if (default_ant->rx != ANTENNA_SW_DIVERSITY)
+			libconf.ant.rx = default_ant->rx;
+		else if (active_ant->rx == ANTENNA_SW_DIVERSITY)
+			libconf.ant.rx = ANTENNA_B;
+
+		if (conf->antenna_sel_tx)
+			libconf.ant.tx = conf->antenna_sel_tx;
+		else if (default_ant->tx != ANTENNA_SW_DIVERSITY)
+			libconf.ant.tx = default_ant->tx;
+		else if (active_ant->tx == ANTENNA_SW_DIVERSITY)
+			libconf.ant.tx = ANTENNA_B;
+	}
+
 	if (flags & CONFIG_UPDATE_SLOT_TIME) {
 		short_slot_time = conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME;
 
@@ -201,5 +247,6 @@ config:
 	rt2x00dev->rx_status.freq = conf->freq;
 	rt2x00dev->rx_status.channel = conf->channel;
 	rt2x00dev->tx_power = conf->power_level;
-	rt2x00dev->rx_status.antenna = conf->antenna_sel_rx;
+	rt2x00dev->link.active_ant.rx = libconf.ant.rx;
+	rt2x00dev->link.active_ant.tx = libconf.ant.tx;
 }
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 5d32e09..b2016f4 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -419,6 +419,7 @@ void rt2x00lib_rxdone(struct data_entry *entry, struct sk_buff *skb,
 	    rt2x00lib_calculate_link_signal(rt2x00dev, desc->rssi);
 	rx_status->ssi = desc->rssi;
 	rx_status->flag = desc->flags;
+	rx_status->antenna = rt2x00dev->link.active_ant.rx;
 
 	/*
 	 * Send frame to mac80211
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index b8c3da7..f96a77c 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -411,8 +411,7 @@ static void rt61pci_config_txpower(struct rt2x00_dev *rt2x00dev,
 }
 
 static void rt61pci_config_antenna_5x(struct rt2x00_dev *rt2x00dev,
-				      const int antenna_tx,
-				      const int antenna_rx)
+				      struct antenna_setup *ant)
 {
 	u8 r3;
 	u8 r4;
@@ -425,7 +424,7 @@ static void rt61pci_config_antenna_5x(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field8(&r3, BBP_R3_SMART_MODE,
 			  !rt2x00_rf(&rt2x00dev->chip, RF5225));
 
-	switch (antenna_rx) {
+	switch (ant->rx) {
 	case ANTENNA_SW_DIVERSITY:
 	case ANTENNA_HW_DIVERSITY:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 2);
@@ -458,8 +457,7 @@ static void rt61pci_config_antenna_5x(struct rt2x00_dev *rt2x00dev,
 }
 
 static void rt61pci_config_antenna_2x(struct rt2x00_dev *rt2x00dev,
-				      const int antenna_tx,
-				      const int antenna_rx)
+				      struct antenna_setup *ant)
 {
 	u8 r3;
 	u8 r4;
@@ -474,7 +472,7 @@ static void rt61pci_config_antenna_2x(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END,
 			  !test_bit(CONFIG_FRAME_TYPE, &rt2x00dev->flags));
 
-	switch (antenna_rx) {
+	switch (ant->rx) {
 	case ANTENNA_SW_DIVERSITY:
 	case ANTENNA_HW_DIVERSITY:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 2);
@@ -514,8 +512,7 @@ static void rt61pci_config_antenna_2529_rx(struct rt2x00_dev *rt2x00dev,
 }
 
 static void rt61pci_config_antenna_2529(struct rt2x00_dev *rt2x00dev,
-					const int antenna_tx,
-					const int antenna_rx)
+					struct antenna_setup *ant)
 {
 	u16 eeprom;
 	u8 r3;
@@ -625,7 +622,7 @@ static const struct antenna_sel antenna_sel_bg[] = {
 };
 
 static void rt61pci_config_antenna(struct rt2x00_dev *rt2x00dev,
-				   const int antenna_tx, const int antenna_rx)
+				   struct antenna_setup *ant)
 {
 	const struct antenna_sel *sel;
 	unsigned int lna;
@@ -655,16 +652,14 @@ static void rt61pci_config_antenna(struct rt2x00_dev *rt2x00dev,
 
 	if (rt2x00_rf(&rt2x00dev->chip, RF5225) ||
 	    rt2x00_rf(&rt2x00dev->chip, RF5325))
-		rt61pci_config_antenna_5x(rt2x00dev, antenna_tx, antenna_rx);
+		rt61pci_config_antenna_5x(rt2x00dev, ant);
 	else if (rt2x00_rf(&rt2x00dev->chip, RF2527))
-		rt61pci_config_antenna_2x(rt2x00dev, antenna_tx, antenna_rx);
+		rt61pci_config_antenna_2x(rt2x00dev, ant);
 	else if (rt2x00_rf(&rt2x00dev->chip, RF2529)) {
 		if (test_bit(CONFIG_DOUBLE_ANTENNA, &rt2x00dev->flags))
-			rt61pci_config_antenna_2x(rt2x00dev, antenna_tx,
-						  antenna_rx);
+			rt61pci_config_antenna_2x(rt2x00dev, ant);
 		else
-			rt61pci_config_antenna_2529(rt2x00dev, antenna_tx,
-						    antenna_rx);
+			rt61pci_config_antenna_2529(rt2x00dev, ant);
 	}
 }
 
@@ -709,8 +704,7 @@ static void rt61pci_config(struct rt2x00_dev *rt2x00dev,
 	if ((flags & CONFIG_UPDATE_TXPOWER) && !(flags & CONFIG_UPDATE_CHANNEL))
 		rt61pci_config_txpower(rt2x00dev, libconf->conf->power_level);
 	if (flags & CONFIG_UPDATE_ANTENNA)
-		rt61pci_config_antenna(rt2x00dev, libconf->conf->antenna_sel_tx,
-				       libconf->conf->antenna_sel_rx);
+		rt61pci_config_antenna(rt2x00dev, &libconf->ant);
 	if (flags & (CONFIG_UPDATE_SLOT_TIME | CONFIG_UPDATE_BEACON_INT))
 		rt61pci_config_duration(rt2x00dev, libconf);
 }
@@ -2017,9 +2011,9 @@ static int rt61pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Identify default antenna configuration.
 	 */
-	rt2x00dev->hw->conf.antenna_sel_tx =
+	rt2x00dev->default_ant.tx =
 	    rt2x00_get_field16(eeprom, EEPROM_ANTENNA_TX_DEFAULT);
-	rt2x00dev->hw->conf.antenna_sel_rx =
+	rt2x00dev->default_ant.rx =
 	    rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RX_DEFAULT);
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 6297677..a1d915f 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -396,8 +396,7 @@ static void rt73usb_config_txpower(struct rt2x00_dev *rt2x00dev,
 }
 
 static void rt73usb_config_antenna_5x(struct rt2x00_dev *rt2x00dev,
-				      const int antenna_tx,
-				      const int antenna_rx)
+				      struct antenna_setup *ant)
 {
 	u8 r3;
 	u8 r4;
@@ -409,7 +408,7 @@ static void rt73usb_config_antenna_5x(struct rt2x00_dev *rt2x00dev,
 
 	rt2x00_set_field8(&r3, BBP_R3_SMART_MODE, 0);
 
-	switch (antenna_rx) {
+	switch (ant->rx) {
 	case ANTENNA_SW_DIVERSITY:
 	case ANTENNA_HW_DIVERSITY:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 2);
@@ -442,8 +441,7 @@ static void rt73usb_config_antenna_5x(struct rt2x00_dev *rt2x00dev,
 }
 
 static void rt73usb_config_antenna_2x(struct rt2x00_dev *rt2x00dev,
-				      const int antenna_tx,
-				      const int antenna_rx)
+				      struct antenna_setup *ant)
 {
 	u8 r3;
 	u8 r4;
@@ -457,7 +455,7 @@ static void rt73usb_config_antenna_2x(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END,
 			  !test_bit(CONFIG_FRAME_TYPE, &rt2x00dev->flags));
 
-	switch (antenna_rx) {
+	switch (ant->rx) {
 	case ANTENNA_SW_DIVERSITY:
 	case ANTENNA_HW_DIVERSITY:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA, 2);
@@ -509,7 +507,7 @@ static const struct antenna_sel antenna_sel_bg[] = {
 };
 
 static void rt73usb_config_antenna(struct rt2x00_dev *rt2x00dev,
-				   const int antenna_tx, const int antenna_rx)
+				   struct antenna_setup *ant)
 {
 	const struct antenna_sel *sel;
 	unsigned int lna;
@@ -539,10 +537,10 @@ static void rt73usb_config_antenna(struct rt2x00_dev *rt2x00dev,
 
 	if (rt2x00_rf(&rt2x00dev->chip, RF5226) ||
 	    rt2x00_rf(&rt2x00dev->chip, RF5225))
-		rt73usb_config_antenna_5x(rt2x00dev, antenna_tx, antenna_rx);
+		rt73usb_config_antenna_5x(rt2x00dev, ant);
 	else if (rt2x00_rf(&rt2x00dev->chip, RF2528) ||
 		 rt2x00_rf(&rt2x00dev->chip, RF2527))
-		rt73usb_config_antenna_2x(rt2x00dev, antenna_tx, antenna_rx);
+		rt73usb_config_antenna_2x(rt2x00dev, ant);
 }
 
 static void rt73usb_config_duration(struct rt2x00_dev *rt2x00dev,
@@ -586,8 +584,7 @@ static void rt73usb_config(struct rt2x00_dev *rt2x00dev,
 	if ((flags & CONFIG_UPDATE_TXPOWER) && !(flags & CONFIG_UPDATE_CHANNEL))
 		rt73usb_config_txpower(rt2x00dev, libconf->conf->power_level);
 	if (flags & CONFIG_UPDATE_ANTENNA)
-		rt73usb_config_antenna(rt2x00dev, libconf->conf->antenna_sel_tx,
-				       libconf->conf->antenna_sel_rx);
+		rt73usb_config_antenna(rt2x00dev, &libconf->ant);
 	if (flags & (CONFIG_UPDATE_SLOT_TIME | CONFIG_UPDATE_BEACON_INT))
 		rt73usb_config_duration(rt2x00dev, libconf);
 }
@@ -1503,9 +1500,9 @@ static int rt73usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Identify default antenna configuration.
 	 */
-	rt2x00dev->hw->conf.antenna_sel_tx =
+	rt2x00dev->default_ant.tx =
 	    rt2x00_get_field16(eeprom, EEPROM_ANTENNA_TX_DEFAULT);
-	rt2x00dev->hw->conf.antenna_sel_rx =
+	rt2x00dev->default_ant.rx =
 	    rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RX_DEFAULT);
 
 	/*
-- 
1.5.3.4

