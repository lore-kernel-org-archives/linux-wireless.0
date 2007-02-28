Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:48611 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932458AbXB1OHW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 09:07:22 -0500
Received: by nf-out-0910.google.com with SMTP id o25so562551nfa
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 06:07:21 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 4/28] rt2x00: Rename rx_params to rx_status
Date: Wed, 28 Feb 2007 15:07:11 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200702281507.11404.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename rx_params to rx_status to reflect the actual purpose
of this field.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
index 14e55b9..4c943ac 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
@@ -454,7 +454,7 @@ static void rt2400pci_config_channel(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Only continue when there is something to be done.
 	 */
-	if (channel == rt2x00dev->rx_params.channel)
+	if (channel == rt2x00dev->rx_status.channel)
 		return;
 
 	INFO("Switching channel. RF1: 0x%08x, RF2: 0x%08x, RF3: 0x%08x.\n",
@@ -499,8 +499,8 @@ static void rt2400pci_config_channel(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Update active info for RX.
 	 */
-	rt2x00dev->rx_params.freq = freq;
-	rt2x00dev->rx_params.channel = channel;
+	rt2x00dev->rx_status.freq = freq;
+	rt2x00dev->rx_status.channel = channel;
 
 	/*
 	 * Update rf fields
@@ -539,7 +539,7 @@ static void rt2400pci_config_antenna(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Only continue when there is something to be done.
 	 */
-	if (rt2x00dev->rx_params.antenna == antenna_rx)
+	if (rt2x00dev->rx_status.antenna == antenna_rx)
 		return;
 
 	rt2x00_bbp_read(rt2x00dev, 4, &reg_rx);
@@ -577,7 +577,7 @@ static void rt2400pci_config_antenna(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Update active info for RX.
 	 */
-	rt2x00dev->rx_params.antenna = antenna_rx;
+	rt2x00dev->rx_status.antenna = antenna_rx;
 }
 
 static void rt2400pci_config_cw(struct rt2x00_dev *rt2x00dev,
@@ -657,7 +657,7 @@ static void rt2400pci_config_phymode(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Only continue when there is something to be done.
 	 */
-	if (rt2x00dev->rx_params.phymode == phymode)
+	if (rt2x00dev->rx_status.phymode == phymode)
 		return;
 
 	rate = &rt2x00dev->hwmodes[0].rates[
@@ -668,7 +668,7 @@ static void rt2400pci_config_phymode(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Update physical mode for rx ring.
 	 */
-	rt2x00dev->rx_params.phymode = phymode;
+	rt2x00dev->rx_status.phymode = phymode;
 }
 
 static void rt2400pci_config_mac_address(struct rt2x00_dev *rt2x00dev,
@@ -1201,10 +1201,10 @@ static int rt2400pci_init_channel_time(struct rt2x00_dev *rt2x00dev)
 		return 0;
 
 	/*
-	 * Invalidate the rx_params.channel value to make sure
+	 * Invalidate the rx_status.channel value to make sure
 	 * the config channel will be correctly executed.
 	 */
-	rt2x00dev->rx_params.channel = 0;
+	rt2x00dev->rx_status.channel = 0;
 
 	/*
 	 * Determine channel_change_time
@@ -1622,16 +1622,16 @@ static void rt2400pci_rxdone(struct work_struct *work)
 			memcpy(skb_put(skb, size), rt2x00_data_addr(entry),
 				size);
 
-			rt2x00dev->rx_params.rate = device_signal_to_rate(
+			rt2x00dev->rx_status.rate = device_signal_to_rate(
 				&rt2x00dev->hwmodes[0],
 				rt2x00_get_field32(word2, RXD_W2_SIGNAL),
 				0);
 
-			rt2x00dev->rx_params.ssi =
+			rt2x00dev->rx_status.ssi =
 				rt2x00_get_field32(word2, RXD_W2_RSSI);
 
 			__ieee80211_rx(rt2x00dev->hw,
-				skb, &rt2x00dev->rx_params);
+				skb, &rt2x00dev->rx_status);
 		}
 
 		rt2x00_set_field32(&word0, RXD_W0_OWNER_NIC, 1);
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
index 6722135..1db9eb2 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
@@ -460,7 +460,7 @@ static void rt2500pci_config_channel(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Only continue when there is something to be done.
 	 */
-	if (channel == rt2x00dev->rx_params.channel)
+	if (channel == rt2x00dev->rx_status.channel)
 		return;
 
 	if (txpower == 0xff)
@@ -544,8 +544,8 @@ static void rt2500pci_config_channel(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Update active info for RX.
 	 */
-	rt2x00dev->rx_params.freq = freq;
-	rt2x00dev->rx_params.channel = channel;
+	rt2x00dev->rx_status.freq = freq;
+	rt2x00dev->rx_status.channel = channel;
 
 	/*
 	 * Update rf fields
@@ -589,7 +589,7 @@ static void rt2500pci_config_antenna(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Only continue when there is something to be done.
 	 */
-	if (rt2x00dev->rx_params.antenna == antenna_rx)
+	if (rt2x00dev->rx_status.antenna == antenna_rx)
 		return;
 
 	rt2x00_register_read(rt2x00dev, BBPCSR1, &reg);
@@ -655,7 +655,7 @@ static void rt2500pci_config_antenna(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Update active info for RX.
 	 */
-	rt2x00dev->rx_params.antenna = antenna_rx;
+	rt2x00dev->rx_status.antenna = antenna_rx;
 }
 
 static void rt2500pci_config_duration(struct rt2x00_dev *rt2x00dev,
@@ -724,7 +724,7 @@ static void rt2500pci_config_phymode(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Only continue when there is something to be done.
 	 */
-	if (rt2x00dev->rx_params.phymode == phymode)
+	if (rt2x00dev->rx_status.phymode == phymode)
 		return;
 
 	if (phymode == MODE_IEEE80211A &&
@@ -743,7 +743,7 @@ static void rt2500pci_config_phymode(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Update physical mode for rx ring.
 	 */
-	rt2x00dev->rx_params.phymode = phymode;
+	rt2x00dev->rx_status.phymode = phymode;
 }
 
 static void rt2500pci_config_mac_address(struct rt2x00_dev *rt2x00dev,
@@ -1327,10 +1327,10 @@ static int rt2500pci_init_channel_time(struct rt2x00_dev *rt2x00dev)
 		return 0;
 
 	/*
-	 * Invalidate the rx_params.channel value to make sure
+	 * Invalidate the rx_status.channel value to make sure
 	 * the config channel will be correctly executed.
 	 */
-	rt2x00dev->rx_params.channel = 0;
+	rt2x00dev->rx_status.channel = 0;
 
 	/*
 	 * Determine channel_change_time
@@ -1781,24 +1781,24 @@ static void rt2500pci_rxdone(struct work_struct *work)
 			memcpy(skb_put(skb, size), rt2x00_data_addr(entry),
 				size);
 
-			rt2x00dev->rx_params.rate = device_signal_to_rate(
+			rt2x00dev->rx_status.rate = device_signal_to_rate(
 				&rt2x00dev->hwmodes[0],
 				rt2x00_get_field32(word2, RXD_W2_SIGNAL),
 				rt2x00_get_field32(word0, RXD_W0_OFDM));
 
-			rt2x00dev->rx_params.ssi =
+			rt2x00dev->rx_status.ssi =
 				rt2x00_get_field32(word2, RXD_W2_RSSI);
-			rt2x00dev->rx_params.noise =
+			rt2x00dev->rx_status.noise =
 				rt2x00_get_link_noise(&rt2x00dev->link);
 
 			__ieee80211_rx(rt2x00dev->hw,
-				skb, &rt2x00dev->rx_params);
+				skb, &rt2x00dev->rx_status);
 
 			/*
 			 * Update link statistics
 			 */
 			rt2x00_update_link_rssi(&rt2x00dev->link,
-				rt2x00dev->rx_params.ssi);
+				rt2x00dev->rx_status.ssi);
 		}
 		rt2x00_set_field32(&word0, RXD_W0_OWNER_NIC, 1);
 		rt2x00_desc_write(rxd, 0, word0);
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
index df155ba..1021663 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
@@ -523,7 +523,7 @@ static void rt2500usb_config_channel(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Only continue when there is something to be done.
 	 */
-	if (channel == rt2x00dev->rx_params.channel)
+	if (channel == rt2x00dev->rx_status.channel)
 		return;
 
 	if (txpower == 0xff)
@@ -597,8 +597,8 @@ static void rt2500usb_config_channel(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Update active info for RX.
 	 */
-	rt2x00dev->rx_params.freq = freq;
-	rt2x00dev->rx_params.channel = channel;
+	rt2x00dev->rx_status.freq = freq;
+	rt2x00dev->rx_status.channel = channel;
 
 	rt2x00dev->tx_power = txpower;
 
@@ -640,7 +640,7 @@ static void rt2500usb_config_antenna(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Only continue when there is something to be done.
 	 */
-	if (rt2x00dev->rx_params.antenna == antenna_rx)
+	if (rt2x00dev->rx_status.antenna == antenna_rx)
 		return;
 
 	rt2x00_bbp_read(rt2x00dev, 2, &reg_tx);
@@ -708,7 +708,7 @@ static void rt2500usb_config_antenna(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Update active info for RX.
 	 */
-	rt2x00dev->rx_params.antenna = antenna_rx;
+	rt2x00dev->rx_status.antenna = antenna_rx;
 }
 
 static void rt2500usb_config_duration(struct rt2x00_dev *rt2x00dev,
@@ -756,7 +756,7 @@ static void rt2500usb_config_phymode(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Only continue when there is something to be done.
 	 */
-	if (rt2x00dev->rx_params.phymode == phymode)
+	if (rt2x00dev->rx_status.phymode == phymode)
 		return;
 
 	if (phymode == MODE_IEEE80211A &&
@@ -775,7 +775,7 @@ static void rt2500usb_config_phymode(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Update physical mode for rx ring.
 	 */
-	rt2x00dev->rx_params.phymode = phymode;
+	rt2x00dev->rx_status.phymode = phymode;
 }
 
 static void rt2500usb_config_mac_address(struct rt2x00_dev *rt2x00dev,
@@ -1299,10 +1299,10 @@ static int rt2500usb_init_channel_time(struct rt2x00_dev *rt2x00dev)
 		return 0;
 
 	/*
-	 * Invalidate the rx_params.channel value to make sure
+	 * Invalidate the rx_status.channel value to make sure
 	 * the config channel will be correctly executed.
 	 */
-	rt2x00dev->rx_params.channel = 0;
+	rt2x00dev->rx_status.channel = 0;
 
 	/*
 	 * Determine channel_change_time
@@ -1762,24 +1762,24 @@ static void rt2500usb_rxdone(struct work_struct *work)
 			memcpy(skb_put(skb, size),
 				rt2x00_rxdata_addr(entry), size);
 
-			rt2x00dev->rx_params.rate = device_signal_to_rate(
+			rt2x00dev->rx_status.rate = device_signal_to_rate(
 				&rt2x00dev->hwmodes[0],
 				rt2x00_get_field32(word1, RXD_W1_SIGNAL),
 				rt2x00_get_field32(word0, RXD_W0_OFDM));
 
-			rt2x00dev->rx_params.ssi =
+			rt2x00dev->rx_status.ssi =
 				rt2x00_get_field32(word1, RXD_W1_RSSI);
-			rt2x00dev->rx_params.noise =
+			rt2x00dev->rx_status.noise =
 				rt2x00_get_link_noise(&rt2x00dev->link);
 
 			__ieee80211_rx(rt2x00dev->hw,
-				skb, &rt2x00dev->rx_params);
+				skb, &rt2x00dev->rx_status);
 
 			/*
 			 * Update link statistics
 			 */
 			rt2x00_update_link_rssi(&rt2x00dev->link,
-				rt2x00dev->rx_params.ssi);
+				rt2x00dev->rx_status.ssi);
 		}
 
 		SET_FLAG(entry, ENTRY_OWNER_NIC);
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00.h b/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
index e505032..fe9ac7d 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
@@ -1033,7 +1033,7 @@ struct rt2x00_dev {
 	/*
 	 * RX configuration information.
 	 */
-	struct ieee80211_rx_status rx_params;
+	struct ieee80211_rx_status rx_status;
 
 	/*
 	 * Scanning structure.
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
index abe458e..8a51a7d 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
@@ -480,7 +480,7 @@ static void rt61pci_config_channel(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Only continue when there is something to be done.
 	 */
-	if (channel == rt2x00dev->rx_params.channel)
+	if (channel == rt2x00dev->rx_status.channel)
 		return;
 
 	if (txpower == 0xff)
@@ -698,8 +698,8 @@ static void rt61pci_config_channel(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Update active info for RX.
 	 */
-	rt2x00dev->rx_params.freq = freq;
-	rt2x00dev->rx_params.channel = channel;
+	rt2x00dev->rx_status.freq = freq;
+	rt2x00dev->rx_status.channel = channel;
 
 	rt2x00dev->tx_power = txpower;
 
@@ -758,7 +758,7 @@ static void rt61pci_config_antenna(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Only continue when there is something to be done.
 	 */
-	if (rt2x00dev->rx_params.antenna == antenna_rx)
+	if (rt2x00dev->rx_status.antenna == antenna_rx)
 		return;
 
 	rt2x00_register_read(rt2x00dev, PHY_CSR0, &reg);
@@ -873,7 +873,7 @@ static void rt61pci_config_antenna(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Update active info for RX.
 	 */
-	rt2x00dev->rx_params.antenna = antenna_rx;
+	rt2x00dev->rx_status.antenna = antenna_rx;
 }
 
 static void rt61pci_config_duration(struct rt2x00_dev *rt2x00dev,
@@ -944,7 +944,7 @@ static void rt61pci_config_phymode(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Only continue when there is something to be done.
 	 */
-	if (rt2x00dev->rx_params.phymode == phymode)
+	if (rt2x00dev->rx_status.phymode == phymode)
 		return;
 
 	if (phymode == MODE_IEEE80211A &&
@@ -964,7 +964,7 @@ static void rt61pci_config_phymode(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Update physical mode for rx ring.
 	 */
-	rt2x00dev->rx_params.phymode = phymode;
+	rt2x00dev->rx_status.phymode = phymode;
 }
 
 static void rt61pci_config_mac_address(struct rt2x00_dev *rt2x00dev,
@@ -1013,7 +1013,7 @@ static void rt61pci_link_tuner(struct work_struct *work)
 	/*
 	 * Determine upper and lower limit for BBP17 register.
 	 */
-	if (rt2x00dev->rx_params.phymode == MODE_IEEE80211A) {
+	if (rt2x00dev->rx_status.phymode == MODE_IEEE80211A) {
 		up_bound = 0x48;
 		low_bound = 0x28;
 	} else {
@@ -1079,7 +1079,7 @@ static void rt61pci_enable_led(struct rt2x00_dev *rt2x00dev)
 
 	led_reg = rt2x00dev->led_reg;
 	rt2x00_set_field16(&led_reg, MCU_LEDCS_RADIO_STATUS, 1);
-	if (rt2x00dev->rx_params.phymode == MODE_IEEE80211A)
+	if (rt2x00dev->rx_status.phymode == MODE_IEEE80211A)
 		rt2x00_set_field16(&led_reg, MCU_LEDCS_LINK_A_STATUS, 1);
 	else
 		rt2x00_set_field16(&led_reg, MCU_LEDCS_LINK_BG_STATUS, 1);
@@ -1752,10 +1752,10 @@ static int rt61pci_init_channel_time(struct rt2x00_dev *rt2x00dev)
 		return 0;
 
 	/*
-	 * Invalidate the rx_params.channel value to make sure
+	 * Invalidate the rx_status.channel value to make sure
 	 * the config channel will be correctly executed.
 	 */
-	rt2x00dev->rx_params.channel = 0;
+	rt2x00dev->rx_status.channel = 0;
 
 	/*
 	 * Determine channel_change_time
@@ -2240,24 +2240,24 @@ static void rt61pci_rxdone(struct work_struct *work)
 			memcpy(skb_put(skb, size), rt2x00_data_addr(entry),
 				size);
 
-			rt2x00dev->rx_params.rate = device_signal_to_rate(
+			rt2x00dev->rx_status.rate = device_signal_to_rate(
 				&rt2x00dev->hwmodes[0],
 				rt2x00_get_field32(word1, RXD_W1_SIGNAL),
 				rt2x00_get_field32(word0, RXD_W0_OFDM));
 
-			rt2x00dev->rx_params.ssi =
+			rt2x00dev->rx_status.ssi =
 				rt2x00_get_field32(word1, RXD_W1_RSSI);
-			rt2x00dev->rx_params.noise =
+			rt2x00dev->rx_status.noise =
 				rt2x00_get_link_noise(&rt2x00dev->link);
 
 			__ieee80211_rx(rt2x00dev->hw,
-				skb, &rt2x00dev->rx_params);
+				skb, &rt2x00dev->rx_status);
 
 			/*
 			 * Update link statistics
 			 */
 			rt2x00_update_link_rssi(&rt2x00dev->link,
-				rt2x00dev->rx_params.ssi);
+				rt2x00dev->rx_status.ssi);
 		}
 		rt2x00_set_field32(&word0, RXD_W0_OWNER_NIC, 1);
 		rt2x00_desc_write(rxd, 0, word0);
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
index 9626cf1..895d68b 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
@@ -488,7 +488,7 @@ static void rt73usb_config_channel(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Only continue when there is something to be done.
 	 */
-	if (channel == rt2x00dev->rx_params.channel)
+	if (channel == rt2x00dev->rx_status.channel)
 		return;
 
 	if (txpower == 0xff)
@@ -609,8 +609,8 @@ static void rt73usb_config_channel(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Update active info for RX.
 	 */
-	rt2x00dev->rx_params.freq = freq;
-	rt2x00dev->rx_params.channel = channel;
+	rt2x00dev->rx_status.freq = freq;
+	rt2x00dev->rx_status.channel = channel;
 
 	rt2x00dev->tx_power = txpower;
 
@@ -667,7 +667,7 @@ static void rt73usb_config_antenna(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Only continue when there is something to be done.
 	 */
-	if (rt2x00dev->rx_params.antenna == antenna_rx)
+	if (rt2x00dev->rx_status.antenna == antenna_rx)
 		return;
 
 	rt2x00_register_read(rt2x00dev, PHY_CSR0, &reg);
@@ -776,7 +776,7 @@ static void rt73usb_config_antenna(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Update active info for RX.
 	 */
-	rt2x00dev->rx_params.antenna = antenna_rx;
+	rt2x00dev->rx_status.antenna = antenna_rx;
 }
 
 static void rt73usb_config_duration(struct rt2x00_dev *rt2x00dev,
@@ -842,7 +842,7 @@ static void rt73usb_config_phymode(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Only continue when there is something to be done.
 	 */
-	if (rt2x00dev->rx_params.phymode == phymode)
+	if (rt2x00dev->rx_status.phymode == phymode)
 		return;
 
 	if (phymode == MODE_IEEE80211A &&
@@ -862,7 +862,7 @@ static void rt73usb_config_phymode(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Update physical mode for rx ring.
 	 */
-	rt2x00dev->rx_params.phymode = phymode;
+	rt2x00dev->rx_status.phymode = phymode;
 }
 
 static void rt73usb_config_mac_address(struct rt2x00_dev *rt2x00dev,
@@ -911,7 +911,7 @@ static void rt73usb_link_tuner(struct work_struct *work)
 	/*
 	 * Determine upper and lower limit for BBP17 register.
 	 */
-	if (rt2x00dev->rx_params.phymode == MODE_IEEE80211A) {
+	if (rt2x00dev->rx_status.phymode == MODE_IEEE80211A) {
 		up_bound = 0x48;
 		low_bound = 0x28;
 	} else {
@@ -992,7 +992,7 @@ static void rt73usb_enable_led(struct rt2x00_dev *rt2x00dev)
 	rt2x00_register_write(rt2x00dev, MAC_CSR14, reg);
 
 	rt2x00_set_field16(&rt2x00dev->led_reg, MCU_LEDCS_RADIO_STATUS, 1);
-	if (rt2x00dev->rx_params.phymode == MODE_IEEE80211A)
+	if (rt2x00dev->rx_status.phymode == MODE_IEEE80211A)
 		rt2x00_set_field16(
 			&rt2x00dev->led_reg, MCU_LEDCS_LINK_A_STATUS, 1);
 	else
@@ -1536,10 +1536,10 @@ static int rt73usb_init_channel_time(struct rt2x00_dev *rt2x00dev)
 		return 0;
 
 	/*
-	 * Invalidate the rx_params.channel value to make sure
+	 * Invalidate the rx_status.channel value to make sure
 	 * the config channel will be correctly executed.
 	 */
-	rt2x00dev->rx_params.channel = 0;
+	rt2x00dev->rx_status.channel = 0;
 
 	/*
 	 * Determine channel_change_time
@@ -2028,24 +2028,24 @@ static void rt73usb_rxdone(struct work_struct *work)
 			memcpy(skb_put(skb, size),
 				rt2x00_data_addr(entry), size);
 
-			rt2x00dev->rx_params.rate = device_signal_to_rate(
+			rt2x00dev->rx_status.rate = device_signal_to_rate(
 				&rt2x00dev->hwmodes[0],
 				rt2x00_get_field32(word1, RXD_W1_SIGNAL),
 				rt2x00_get_field32(word0, RXD_W0_OFDM));
 
-			rt2x00dev->rx_params.ssi =
+			rt2x00dev->rx_status.ssi =
 				rt2x00_get_field32(word1, RXD_W1_RSSI);
-			rt2x00dev->rx_params.noise =
+			rt2x00dev->rx_status.noise =
 				rt2x00_get_link_noise(&rt2x00dev->link);
 
 			__ieee80211_rx(rt2x00dev->hw,
-				skb, &rt2x00dev->rx_params);
+				skb, &rt2x00dev->rx_status);
 
 			/*
 			 * Update link statistics
 			 */
 			rt2x00_update_link_rssi(&rt2x00dev->link,
-				rt2x00dev->rx_params.ssi);
+				rt2x00dev->rx_status.ssi);
 		}
 
 		SET_FLAG(entry, ENTRY_OWNER_NIC);
