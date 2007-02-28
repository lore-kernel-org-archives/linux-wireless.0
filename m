Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:49045 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932454AbXB1OHV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 09:07:21 -0500
Received: by nf-out-0910.google.com with SMTP id o25so562557nfa
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 06:07:21 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 15/28] rt2x00: Initialize the rt2x00lib_ops structure
Date: Wed, 28 Feb 2007 15:07:10 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200702281507.11083.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initialize the rt2x00lib_ops structure, and change functions that don't
follow the definition in that structure.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
index 06d8f2c..30f9bf3 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
@@ -444,7 +444,7 @@ static void rt2400pci_config_type(struct rt2x00_dev *rt2x00dev, int type)
 }
 
 static void rt2400pci_config_channel(struct rt2x00_dev *rt2x00dev,
-	int rf2, int channel, int freq)
+	int rf2, int channel, int freq, int txpower)
 {
 	u32 rf1 = rt2x00dev->rf1;
 	u32 rf3 = rt2x00dev->rf3;
@@ -669,8 +669,7 @@ static void rt2400pci_config_phymode(struct rt2x00_dev *rt2x00dev,
 	rt2x00dev->rx_status.phymode = phymode;
 }
 
-static void rt2400pci_config_mac_address(struct rt2x00_dev *rt2x00dev,
-	void *addr)
+static void rt2400pci_config_mac_addr(struct rt2x00_dev *rt2x00dev, u8 *addr)
 {
 	/*
 	 * The MAC address is passed to us as an array of bytes,
@@ -1210,7 +1209,8 @@ static int rt2400pci_init_channel_time(struct rt2x00_dev *rt2x00dev)
 	rt2400pci_config_channel(rt2x00dev,
 		rt2x00dev->hwmodes[0].channels[0].val,
 		rt2x00dev->hwmodes[0].channels[0].chan,
-		rt2x00dev->hwmodes[0].channels[0].freq);
+		rt2x00dev->hwmodes[0].channels[0].freq,
+		0);
 	jiffies_end = jiffies;
 
 	rt2x00dev->hw->channel_change_time =
@@ -1941,7 +1941,7 @@ static int rt2400pci_add_interface(struct ieee80211_hw *hw,
 		 * Before doing anything else, the MAC address
 		 * of this device should be initialized correctly.
 		 */
-		rt2400pci_config_mac_address(rt2x00dev, conf->mac_addr);
+		rt2400pci_config_mac_addr(rt2x00dev, conf->mac_addr);
 
 		/*
 		 * Initialize the device.
@@ -2044,7 +2044,7 @@ static int rt2400pci_config(struct ieee80211_hw *hw,
 	}
 
 	rt2400pci_config_channel(rt2x00dev,
-		conf->channel_val, conf->channel, conf->freq);
+		conf->channel_val, conf->channel, conf->freq, 0);
 	rt2400pci_config_txpower(rt2x00dev, conf->power_level);
 	rt2400pci_config_antenna(rt2x00dev,
 		conf->antenna_sel_tx, conf->antenna_sel_rx);
@@ -2149,7 +2149,8 @@ static void rt2400pci_scan(struct work_struct *work)
 		rt2400pci_config_channel(rt2x00dev,
 			scan->conf.scan_channel_val,
 			scan->conf.scan_channel,
-			scan->conf.scan_freq);
+			scan->conf.scan_freq,
+			0);
 
 		rt2400pci_config_txpower(rt2x00dev,
 			scan->conf.scan_power_level);
@@ -2160,7 +2161,8 @@ static void rt2400pci_scan(struct work_struct *work)
 		rt2400pci_config_channel(rt2x00dev,
 			scan->conf.running_channel_val,
 			scan->conf.running_channel,
-			scan->conf.running_freq);
+			scan->conf.running_freq,
+			0);
 
 		rt2400pci_config_txpower(rt2x00dev,
 			scan->conf.running_power_level);
@@ -2397,6 +2399,25 @@ static struct ieee80211_ops rt2400pci_mac80211_ops = {
 	.tx_last_beacon		= rt2400pci_tx_last_beacon,
 };
 
+static const struct rt2x00lib_ops rt2400pci_rt2x00_ops = {
+	.initialize		= rt2400pci_initialize,
+	.uninitialize		= rt2400pci_uninitialize,
+	.enable_radio		= rt2400pci_enable_radio,
+	.disable_radio		= rt2400pci_disable_radio,
+	.toggle_rx		= rt2400pci_toggle_rx,
+	.write_tx_data		= rt2400pci_write_tx_data,
+	.kick_tx_queue		= rt2400pci_kick_tx_queue,
+	.config_type		= rt2400pci_config_type,
+	.config_phymode		= rt2400pci_config_phymode,
+	.config_channel		= rt2400pci_config_channel,
+	.config_mac_addr	= rt2400pci_config_mac_addr,
+	.config_bssid		= rt2400pci_config_bssid,
+	.config_promisc		= rt2400pci_config_promisc,
+	.config_txpower		= rt2400pci_config_txpower,
+	.config_antenna		= rt2400pci_config_antenna,
+	.config_duration	= rt2400pci_config_duration,
+};
+
 /*
  * Device initialization functions.
  */
@@ -2564,7 +2585,7 @@ static int rt2400pci_init_hw_mac(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Write MAC address to register.
 	 */
-	rt2400pci_config_mac_address(rt2x00dev, addr);
+	rt2400pci_config_mac_addr(rt2x00dev, addr);
 
 	/*
 	 * Copy MAC address to the hw structure.
@@ -2785,6 +2806,8 @@ static int rt2400pci_alloc_dev(struct pci_dev *pci_dev,
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 
 	rt2x00dev->dev = pci_dev;
+	rt2x00dev->lib_ops = &rt2400pci_rt2x00_ops;
+	rt2x00dev->hw_ops = &rt2400pci_mac80211_ops;
 	rt2x00dev->hw = hw;
 
 	/*
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
index 3c388d3..feb2f9c 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
@@ -744,8 +744,7 @@ static void rt2500pci_config_phymode(struct rt2x00_dev *rt2x00dev,
 	rt2x00dev->rx_status.phymode = phymode;
 }
 
-static void rt2500pci_config_mac_address(struct rt2x00_dev *rt2x00dev,
-	void *addr)
+static void rt2500pci_config_mac_addr(struct rt2x00_dev *rt2x00dev, u8 *addr)
 {
 	/*
 	 * The MAC address is passed to us as an array of bytes,
@@ -2107,7 +2106,7 @@ static int rt2500pci_add_interface(struct ieee80211_hw *hw,
 		 * Before doing anything else, the MAC address
 		 * of this device should be initialized correctly.
 		 */
-		rt2500pci_config_mac_address(rt2x00dev, conf->mac_addr);
+		rt2500pci_config_mac_addr(rt2x00dev, conf->mac_addr);
 
 		/*
 		 * Initialize the device.
@@ -2555,6 +2554,25 @@ static struct ieee80211_ops rt2500pci_mac80211_ops = {
 	.tx_last_beacon		= rt2500pci_tx_last_beacon,
 };
 
+static const struct rt2x00lib_ops rt2500pci_rt2x00_ops = {
+	.initialize		= rt2500pci_initialize,
+	.uninitialize		= rt2500pci_uninitialize,
+	.enable_radio		= rt2500pci_enable_radio,
+	.disable_radio		= rt2500pci_disable_radio,
+	.toggle_rx		= rt2500pci_toggle_rx,
+	.write_tx_data		= rt2500pci_write_tx_data,
+	.kick_tx_queue		= rt2500pci_kick_tx_queue,
+	.config_type		= rt2500pci_config_type,
+	.config_phymode		= rt2500pci_config_phymode,
+	.config_channel		= rt2500pci_config_channel,
+	.config_mac_addr	= rt2500pci_config_mac_addr,
+	.config_bssid		= rt2500pci_config_bssid,
+	.config_promisc		= rt2500pci_config_promisc,
+	.config_txpower		= rt2500pci_config_txpower,
+	.config_antenna		= rt2500pci_config_antenna,
+	.config_duration	= rt2500pci_config_duration,
+};
+
 /*
  * Device initialization functions.
  */
@@ -2740,7 +2758,7 @@ static int rt2500pci_init_hw_mac(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Write MAC address to register.
 	 */
-	rt2500pci_config_mac_address(rt2x00dev, addr);
+	rt2500pci_config_mac_addr(rt2x00dev, addr);
 
 	/*
 	 * Copy MAC address to the hw structure.
@@ -3097,6 +3115,8 @@ static int rt2500pci_alloc_dev(struct pci_dev *pci_dev,
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 
 	rt2x00dev->dev = pci_dev;
+	rt2x00dev->lib_ops = &rt2500pci_rt2x00_ops;
+	rt2x00dev->hw_ops = &rt2500pci_mac80211_ops;
 	rt2x00dev->hw = hw;
 
 	/*
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
index 9569875..443cde4 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
@@ -750,8 +750,7 @@ static void rt2500usb_config_phymode(struct rt2x00_dev *rt2x00dev,
 	rt2x00dev->rx_status.phymode = phymode;
 }
 
-static void rt2500usb_config_mac_address(struct rt2x00_dev *rt2x00dev,
-	void *addr)
+static void rt2500usb_config_mac_addr(struct rt2x00_dev *rt2x00dev, u8 *addr)
 {
 	/*
 	 * The MAC address is passed to us as an array of bytes,
@@ -2013,7 +2012,7 @@ static int rt2500usb_add_interface(struct ieee80211_hw *hw,
 		 * Before doing anything else, the MAC address
 		 * of this device should be initialized correctly.
 		 */
-		rt2500usb_config_mac_address(rt2x00dev, conf->mac_addr);
+		rt2500usb_config_mac_addr(rt2x00dev, conf->mac_addr);
 
 		/*
 		 * Initialize the device.
@@ -2481,6 +2480,23 @@ static struct ieee80211_ops rt2500usb_mac80211_ops = {
 	.beacon_update		= rt2500usb_beacon_update,
 };
 
+static const struct rt2x00lib_ops rt2500usb_rt2x00_ops = {
+	.initialize		= rt2500usb_initialize,
+	.uninitialize		= rt2500usb_uninitialize,
+	.enable_radio		= rt2500usb_enable_radio,
+	.disable_radio		= rt2500usb_disable_radio,
+	.toggle_rx		= rt2500usb_toggle_rx,
+	.write_tx_data		= rt2500usb_write_tx_data,
+	.config_type		= rt2500usb_config_type,
+	.config_phymode		= rt2500usb_config_phymode,
+	.config_channel		= rt2500usb_config_channel,
+	.config_mac_addr	= rt2500usb_config_mac_addr,
+	.config_bssid		= rt2500usb_config_bssid,
+	.config_txpower		= rt2500usb_config_txpower,
+	.config_antenna		= rt2500usb_config_antenna,
+	.config_duration	= rt2500usb_config_duration,
+};
+
 /*
  * Device initialization functions.
  */
@@ -2613,7 +2629,7 @@ static int rt2500usb_init_hw_mac(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Write MAC address to register.
 	 */
-	rt2500usb_config_mac_address(rt2x00dev, addr);
+	rt2500usb_config_mac_addr(rt2x00dev, addr);
 
 	/*
 	 * Copy MAC address to the hw structure.
@@ -2961,6 +2977,8 @@ static int rt2500usb_alloc_dev(struct usb_interface *usb_intf,
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 
 	rt2x00dev->dev = usb_intf;
+	rt2x00dev->lib_ops = &rt2500usb_rt2x00_ops;
+	rt2x00dev->hw_ops = &rt2500usb_mac80211_ops;
 	rt2x00dev->hw = hw;
 
 	/*
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
index 1142d5a..674a33b 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
@@ -750,7 +750,7 @@ static void rt61pci_config_txpower(struct rt2x00_dev *rt2x00dev, int txpower)
 }
 
 static void rt61pci_config_antenna(struct rt2x00_dev *rt2x00dev,
-	int antenna_tx, int antenna_rx, int phymode)
+	int antenna_tx, int antenna_rx)
 {
 	u32 reg;
 	u8 reg_r3;
@@ -766,7 +766,7 @@ static void rt61pci_config_antenna(struct rt2x00_dev *rt2x00dev,
 
 	rt2x00_register_read(rt2x00dev, PHY_CSR0, &reg);
 
-	if (phymode == MODE_IEEE80211A) {
+	if (rt2x00dev->curr_hwmode == HWMODE_A) {
 		if (GET_FLAG(rt2x00dev, CONFIG_EXTERNAL_LNA_A)) {
 			rt2x00_bbp_write(rt2x00dev, 17, 0x38);
 			rt2x00_bbp_write(rt2x00dev, 96, 0x78);
@@ -828,18 +828,18 @@ static void rt61pci_config_antenna(struct rt2x00_dev *rt2x00dev,
 	    rt2x00_rf(&rt2x00dev->chip, RF5325)) {
 		if (antenna_rx == 0) {		/* Diversity. */
 			reg_r4 |= 0x02;
-			if (phymode != MODE_IEEE80211A)
+			if (rt2x00dev->curr_hwmode != HWMODE_A)
 				reg_r4 |= 0x20;
 		} else if (antenna_rx == 1) {	/* RX: Antenna A */
 			reg_r4 |= 0x01;
-			if (phymode == MODE_IEEE80211A)
+			if (rt2x00dev->curr_hwmode == HWMODE_A)
 				reg_r77 &= ~0x03;
 			else
 				reg_r77 |= 0x03;
 			rt2x00_bbp_write(rt2x00dev, 77, reg_r77);
 		} else if (antenna_rx == 2) {	/* RX: Antenna B */
 			reg_r4 |= 0x01;
-			if (phymode == MODE_IEEE80211A)
+			if (rt2x00dev->curr_hwmode == HWMODE_A)
 				reg_r77 |= 0x03;
 			else
 				reg_r77 &= ~0x03;
@@ -970,8 +970,7 @@ static void rt61pci_config_phymode(struct rt2x00_dev *rt2x00dev,
 	rt2x00dev->rx_status.phymode = phymode;
 }
 
-static void rt61pci_config_mac_address(struct rt2x00_dev *rt2x00dev,
-	void *addr)
+static void rt61pci_config_mac_addr(struct rt2x00_dev *rt2x00dev, u8 *addr)
 {
 	u32 reg;
 
@@ -2569,7 +2568,7 @@ static int rt61pci_add_interface(struct ieee80211_hw *hw,
 		 * Before doing anything else, the MAC address
 		 * of this device should be initialized correctly.
 		 */
-		rt61pci_config_mac_address(rt2x00dev, conf->mac_addr);
+		rt61pci_config_mac_addr(rt2x00dev, conf->mac_addr);
 
 		/*
 		 * Initialize the device.
@@ -2676,7 +2675,7 @@ static int rt61pci_config(struct ieee80211_hw *hw,
 		conf->power_level);
 	rt61pci_config_txpower(rt2x00dev, conf->power_level);
 	rt61pci_config_antenna(rt2x00dev,
-		conf->antenna_sel_tx, conf->antenna_sel_rx, conf->phymode);
+		conf->antenna_sel_tx, conf->antenna_sel_rx);
 	rt61pci_config_duration(rt2x00dev,
 		(conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME));
 	rt61pci_config_phymode(rt2x00dev, conf->phymode);
@@ -3011,6 +3010,25 @@ static struct ieee80211_ops rt61pci_mac80211_ops = {
 	.beacon_update		= rt61pci_beacon_update,
 };
 
+static const struct rt2x00lib_ops rt61pci_rt2x00_ops = {
+	.initialize		= rt61pci_initialize,
+	.uninitialize		= rt61pci_uninitialize,
+	.enable_radio		= rt61pci_enable_radio,
+	.disable_radio		= rt61pci_disable_radio,
+	.toggle_rx		= rt61pci_toggle_rx,
+	.write_tx_data		= rt61pci_write_tx_data,
+	.kick_tx_queue		= rt61pci_kick_tx_queue,
+	.config_type		= rt61pci_config_type,
+	.config_phymode		= rt61pci_config_phymode,
+	.config_channel		= rt61pci_config_channel,
+	.config_mac_addr	= rt61pci_config_mac_addr,
+	.config_bssid		= rt61pci_config_bssid,
+	.config_promisc		= rt61pci_config_promisc,
+	.config_txpower		= rt61pci_config_txpower,
+	.config_antenna		= rt61pci_config_antenna,
+	.config_duration	= rt61pci_config_duration,
+};
+
 /*
  * Device initialization functions.
  */
@@ -3239,7 +3257,7 @@ static int rt61pci_init_hw_mac(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Write MAC address to register.
 	 */
-	rt61pci_config_mac_address(rt2x00dev, addr);
+	rt61pci_config_mac_addr(rt2x00dev, addr);
 
 	/*
 	 * Copy MAC address to the hw structure.
@@ -3594,6 +3612,8 @@ static int rt61pci_alloc_dev(struct pci_dev *pci_dev,
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 
 	rt2x00dev->dev = pci_dev;
+	rt2x00dev->lib_ops = &rt61pci_rt2x00_ops;
+	rt2x00dev->hw_ops = &rt61pci_mac80211_ops;
 	rt2x00dev->hw = hw;
 
 	/*
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
index fe1aeba..db11d44 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
@@ -644,7 +644,7 @@ static void rt73usb_config_txpower(struct rt2x00_dev *rt2x00dev, int txpower)
 }
 
 static void rt73usb_config_antenna(struct rt2x00_dev *rt2x00dev,
-	int antenna_tx, int antenna_rx, int phymode)
+	int antenna_tx, int antenna_rx)
 {
 	u32 reg;
 	u8 reg_r3;
@@ -660,7 +660,7 @@ static void rt73usb_config_antenna(struct rt2x00_dev *rt2x00dev,
 
 	rt2x00_register_read(rt2x00dev, PHY_CSR0, &reg);
 
-	if (phymode == MODE_IEEE80211A) {
+	if (rt2x00dev->curr_hwmode == HWMODE_A) {
 		if (GET_FLAG(rt2x00dev, CONFIG_EXTERNAL_LNA)) {
 			rt2x00_bbp_write(rt2x00dev, 17, 0x38);
 			rt2x00_bbp_write(rt2x00dev, 96, 0x78);
@@ -720,13 +720,13 @@ static void rt73usb_config_antenna(struct rt2x00_dev *rt2x00dev,
 	    rt2x00_rf(&rt2x00dev->chip, RF5225)) {
 		if (antenna_rx == 0) {		/* Diversity. */
 			reg_r4 |= 0x02;
-			if (phymode != MODE_IEEE80211A)
+			if (rt2x00dev->curr_hwmode != HWMODE_A)
 				reg_r4 |= 0x20;
 			reg_r4 &= frame_type;
 		} else if (antenna_rx == 1) {	/* RX: Antenna A */
 			reg_r4 |= 0x01;
 			reg_r4 &= frame_type;
-			if (phymode == MODE_IEEE80211A)
+			if (rt2x00dev->curr_hwmode == HWMODE_A)
 				reg_r77 &= ~0x03;
 			else
 				reg_r77 |= 0x03;
@@ -734,7 +734,7 @@ static void rt73usb_config_antenna(struct rt2x00_dev *rt2x00dev,
 		} else if (antenna_rx == 2) {	/* RX: Antenna B */
 			reg_r4 |= 0x01;
 			reg_r4 &= frame_type;
-			if (phymode == MODE_IEEE80211A)
+			if (rt2x00dev->curr_hwmode == HWMODE_A)
 				reg_r77 |= 0x03;
 			else
 				reg_r77 &= ~0x03;
@@ -853,8 +853,7 @@ static void rt73usb_config_phymode(struct rt2x00_dev *rt2x00dev,
 	rt2x00dev->rx_status.phymode = phymode;
 }
 
-static void rt73usb_config_mac_address(struct rt2x00_dev *rt2x00dev,
-	void *addr)
+static void rt73usb_config_mac_addr(struct rt2x00_dev *rt2x00dev, u8 *addr)
 {
 	u32 reg;
 
@@ -2284,7 +2283,7 @@ static int rt73usb_add_interface(struct ieee80211_hw *hw,
 		 * Before doing anything else, the MAC address
 		 * of this device should be initialized correctly.
 		 */
-		rt73usb_config_mac_address(rt2x00dev, conf->mac_addr);
+		rt73usb_config_mac_addr(rt2x00dev, conf->mac_addr);
 
 		/*
 		 * Initialize the device.
@@ -2391,7 +2390,7 @@ static int rt73usb_config(struct ieee80211_hw *hw,
 		conf->power_level);
 	rt73usb_config_txpower(rt2x00dev, conf->power_level);
 	rt73usb_config_antenna(rt2x00dev,
-		conf->antenna_sel_tx, conf->antenna_sel_rx, conf->phymode);
+		conf->antenna_sel_tx, conf->antenna_sel_rx);
 	rt73usb_config_duration(rt2x00dev,
 		(conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME));
 	rt73usb_config_phymode(rt2x00dev, conf->phymode);
@@ -2791,6 +2790,23 @@ static struct ieee80211_ops rt73usb_mac80211_ops = {
 	.beacon_update		= rt73usb_beacon_update,
 };
 
+static const struct rt2x00lib_ops rt73usb_rt2x00_ops = {
+	.initialize		= rt73usb_initialize,
+	.uninitialize		= rt73usb_uninitialize,
+	.enable_radio		= rt73usb_enable_radio,
+	.disable_radio		= rt73usb_disable_radio,
+	.toggle_rx		= rt73usb_toggle_rx,
+	.write_tx_data		= rt73usb_write_tx_data,
+	.config_type		= rt73usb_config_type,
+	.config_phymode		= rt73usb_config_phymode,
+	.config_channel		= rt73usb_config_channel,
+	.config_mac_addr	= rt73usb_config_mac_addr,
+	.config_bssid		= rt73usb_config_bssid,
+	.config_txpower		= rt73usb_config_txpower,
+	.config_antenna		= rt73usb_config_antenna,
+	.config_duration	= rt73usb_config_duration,
+};
+
 /*
  * Device initialization functions.
  */
@@ -2953,7 +2969,7 @@ static int rt73usb_init_hw_mac(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Write MAC address to register.
 	 */
-	rt73usb_config_mac_address(rt2x00dev, addr);
+	rt73usb_config_mac_addr(rt2x00dev, addr);
 
 	/*
 	 * Copy MAC address to the hw structure.
@@ -3295,6 +3311,8 @@ static int rt73usb_alloc_dev(struct usb_interface *usb_intf,
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 
 	rt2x00dev->dev = usb_intf;
+	rt2x00dev->lib_ops = &rt73usb_rt2x00_ops;
+	rt2x00dev->hw_ops = &rt73usb_mac80211_ops;
 	rt2x00dev->hw = hw;
 
 	/*
