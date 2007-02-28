Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:48635 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932453AbXB1OHV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 09:07:21 -0500
Received: by nf-out-0910.google.com with SMTP id o25so562562nfa
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 06:07:20 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 16/28] rt2x00: Fix hwmode selection
Date: Wed, 28 Feb 2007 15:07:10 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200702281507.10734.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Store the current selected mode, and use that whenever for selecting
the modes during later configuration steps.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
index 30f9bf3..18e615c 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
@@ -650,6 +650,7 @@ static void rt2400pci_config_rate(struct rt2x00_dev *rt2x00dev, const int rate)
 static void rt2400pci_config_phymode(struct rt2x00_dev *rt2x00dev,
 	const int phymode)
 {
+	struct ieee80211_hw_mode *mode;
 	struct ieee80211_rate *rate;
 
 	/*
@@ -658,8 +659,10 @@ static void rt2400pci_config_phymode(struct rt2x00_dev *rt2x00dev,
 	if (rt2x00dev->rx_status.phymode == phymode)
 		return;
 
-	rate = &rt2x00dev->hwmodes[0].rates[
-		rt2x00dev->hwmodes[0].num_rates - 1];
+	rt2x00dev->curr_hwmode = HWMODE_B;
+
+	mode = &rt2x00dev->hwmodes[rt2x00dev->curr_hwmode];
+	rate = &mode->rates[mode->num_rates - 1];
 
 	rt2400pci_config_rate(rt2x00dev, rate->val2);
 
@@ -2666,6 +2669,10 @@ static void rt2400pci_init_hw_rates(struct rt2x00_dev *rt2x00dev,
 
 static int rt2400pci_init_hw_modes(struct rt2x00_dev *rt2x00dev)
 {
+	struct ieee80211_channel *channels;
+	struct ieee80211_rate *rates;
+	int status = -ENOMEM;
+
 	/*
 	 * RT2400 only supports 802.11b.
 	 * Allocate memory for 14 OFDM channels and 4 CCK rates.
@@ -2675,43 +2682,59 @@ static int rt2400pci_init_hw_modes(struct rt2x00_dev *rt2x00dev)
 	if (!rt2x00dev->hwmodes)
 		goto exit;
 
-	rt2x00dev->hwmodes[0].num_channels = 14;
-	rt2x00dev->hwmodes[0].channels =
-		kzalloc(sizeof(struct ieee80211_channel) * 14, GFP_KERNEL);
-	if (!rt2x00dev->hwmodes[0].channels)
+	channels = kzalloc(sizeof(struct ieee80211_channel) * 14,
+		GFP_KERNEL);
+	if (!channels)
 		goto exit_free_modes;
 
-	rt2x00dev->hwmodes[0].num_rates = 4;
-	rt2x00dev->hwmodes[0].rates =
-		kzalloc(sizeof(struct ieee80211_rate) * 4, GFP_KERNEL);
-	if (!rt2x00dev->hwmodes[0].rates)
+	rates = kzalloc(sizeof(struct ieee80211_rate) * 4, GFP_KERNEL);
+	if (!rates)
 		goto exit_free_channels;
 
 	/*
-	 * Initialize modes.
+	 * Initialize channels and rate arrays.
+	 */
+	rt2400pci_init_hw_channels(rt2x00dev, channels);
+	rt2400pci_init_hw_rates(rt2x00dev, rates);
+
+	/*
+	 * Intitialize 802.11b
+	 * Rates: CCK.
+	 * Channels: OFDM.
 	 */
-	rt2x00dev->hwmodes[0].mode = MODE_IEEE80211B;
+	rt2x00dev->hwmodes[HWMODE_B].mode = MODE_IEEE80211B;
+	rt2x00dev->hwmodes[HWMODE_B].num_channels = 14;
+	rt2x00dev->hwmodes[HWMODE_B].num_rates = 4;
+	rt2x00dev->hwmodes[HWMODE_B].channels = channels;
+	rt2x00dev->hwmodes[HWMODE_B].rates = rates;
 
-	rt2400pci_init_hw_channels(rt2x00dev, rt2x00dev->hwmodes[0].channels);
-	rt2400pci_init_hw_rates(rt2x00dev, rt2x00dev->hwmodes[0].rates);
+	/*
+	 * Register the working modes.
+	 */
+	status = ieee80211_register_hwmode(rt2x00dev->hw,
+		&rt2x00dev->hwmodes[HWMODE_B]);
+	if (status)
+		goto exit_free_rates;
 
 	return 0;
 
+exit_free_rates:
+	kfree(rates);
+
 exit_free_channels:
-	kfree(rt2x00dev->hwmodes[0].channels);
-	rt2x00dev->hwmodes[0].channels = NULL;
+	kfree(channels);
 
 exit_free_modes:
 	kfree(rt2x00dev->hwmodes);
+	rt2x00dev->hwmodes = NULL;
 
 exit:
 	ERROR("Allocation ieee80211 modes failed.\n");
-	return -ENOMEM;
+	return status;
 }
 
 static int rt2400pci_init_hw(struct rt2x00_dev *rt2x00dev)
 {
-	int err;
 	int status;
 
 	if (GET_FLAG(rt2x00dev, DEVICE_INITIALIZED_HW))
@@ -2737,18 +2760,16 @@ static int rt2400pci_init_hw(struct rt2x00_dev *rt2x00dev)
 		IEEE80211_HW_MONITOR_DURING_OPER;
 	rt2x00dev->hw->extra_tx_headroom = 0;
 	rt2x00dev->hw->max_rssi = MAX_RX_SSI;
+	rt2x00dev->hw->max_noise = MAX_RX_NOISE;
 	rt2x00dev->hw->queues = RING_NUM_TX;
 
-	status = rt2400pci_init_hw_modes(rt2x00dev);
-	if (status)
-		return status;
-
 	if (ieee80211_register_hw(rt2x00dev->hw))
 		return -EIO;
-	err = ieee80211_register_hwmode(rt2x00dev->hw, &rt2x00dev->hwmodes[0]);
-	if (err) {
+
+	status = rt2400pci_init_hw_modes(rt2x00dev);
+	if (status) {
 		ieee80211_unregister_hw(rt2x00dev->hw);
-		return err;
+		return status;
 	}
 
 	SET_FLAG(rt2x00dev, DEVICE_INITIALIZED_HW);
@@ -2794,9 +2815,10 @@ static void rt2400pci_free_dev(struct rt2x00_dev *rt2x00dev)
 	 * Free ieee80211_hw memory.
 	 */
 	if (likely(rt2x00dev->hwmodes)) {
-		kfree(rt2x00dev->hwmodes[0].channels);
-		kfree(rt2x00dev->hwmodes[0].rates);
+		kfree(rt2x00dev->hwmodes->channels);
+		kfree(rt2x00dev->hwmodes->rates);
 		kfree(rt2x00dev->hwmodes);
+		rt2x00dev->hwmodes = NULL;
 	}
 }
 
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.h b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.h
index 6e20d42..489877c 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.h
@@ -37,6 +37,7 @@
  * Max RSSI value, required for RSSI <-> dBm conversion.
  */
 #define MAX_RX_SSI			100
+#define MAX_RX_NOISE			-110
 
 /*
  * Register layout information.
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
index feb2f9c..09b2ff2 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
@@ -717,6 +717,7 @@ static void rt2500pci_config_rate(struct rt2x00_dev *rt2x00dev, const int rate)
 static void rt2500pci_config_phymode(struct rt2x00_dev *rt2x00dev,
 	const int phymode)
 {
+	struct ieee80211_hw_mode *mode;
 	struct ieee80211_rate *rate;
 
 	/*
@@ -725,16 +726,15 @@ static void rt2500pci_config_phymode(struct rt2x00_dev *rt2x00dev,
 	if (rt2x00dev->rx_status.phymode == phymode)
 		return;
 
-	if (phymode == MODE_IEEE80211A &&
-	    rt2x00_rf(&rt2x00dev->chip, RF5222))
-		rate = &rt2x00dev->hwmodes[2].rates[
-			rt2x00dev->hwmodes[2].num_rates - 1];
+	if (phymode == MODE_IEEE80211A)
+		rt2x00dev->curr_hwmode = HWMODE_A;
 	else if (phymode == MODE_IEEE80211B)
-		rate = &rt2x00dev->hwmodes[1].rates[
-			rt2x00dev->hwmodes[1].num_rates - 1];
+		rt2x00dev->curr_hwmode = HWMODE_B;
 	else
-		rate = &rt2x00dev->hwmodes[0].rates[
-			rt2x00dev->hwmodes[0].num_rates - 1];
+		rt2x00dev->curr_hwmode = HWMODE_G;
+
+	mode = &rt2x00dev->hwmodes[rt2x00dev->curr_hwmode];
+	rate = &mode->rates[mode->num_rates - 1];
 
 	rt2500pci_config_rate(rt2x00dev, rate->val2);
 
@@ -2733,7 +2733,6 @@ static int rt2500pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 		rt2x00_get_field16(eeprom, EEPROM_CALIBRATE_OFFSET_RSSI);
 	if (rt2x00dev->hw->max_rssi == 0x00 || rt2x00dev->hw->max_rssi == (s8)0xff)
 		rt2x00dev->hw->max_rssi = MAX_RX_SSI;
-	rt2x00dev->hw->max_noise = MAX_RX_NOISE;
 
 	return 0;
 }
@@ -2929,6 +2928,9 @@ static void rt2500pci_init_hw_rates(struct rt2x00_dev *rt2x00dev,
 
 static int rt2500pci_init_hw_modes(struct rt2x00_dev *rt2x00dev)
 {
+	struct ieee80211_channel *channels;
+	struct ieee80211_rate *rates;
+	int status = -ENOMEM;
 	int num_modes;
 	int num_channels;
 
@@ -2947,64 +2949,88 @@ static int rt2500pci_init_hw_modes(struct rt2x00_dev *rt2x00dev)
 	}
 
 	rt2x00dev->hwmodes =
-		kzalloc((sizeof(struct ieee80211_hw_mode) * num_modes),
-		GFP_KERNEL);
+		kzalloc(sizeof(struct ieee80211_hw_mode) * num_modes,
+			GFP_KERNEL);
 	if (!rt2x00dev->hwmodes)
 		goto exit;
 
-	rt2x00dev->hwmodes[0].channels =
-		kzalloc((sizeof(struct ieee80211_channel) * num_channels),
+	channels = kzalloc(sizeof(struct ieee80211_channel) * num_channels,
 		GFP_KERNEL);
-	if (!rt2x00dev->hwmodes[0].channels)
+	if (!channels)
 		goto exit_free_modes;
 
-	rt2x00dev->hwmodes[0].rates =
-		kzalloc((sizeof(struct ieee80211_rate) * 12),
-		GFP_KERNEL);
-	if (!rt2x00dev->hwmodes[0].rates)
+	rates = kzalloc(sizeof(struct ieee80211_rate) * 12, GFP_KERNEL);
+	if (!rates)
 		goto exit_free_channels;
 
 	/*
-	 * Intitialize 802.11g
-	 * Rates: CCK, OFDM.
-	 * Channels: OFDM.
+	 * Initialize channels and rate arrays.
 	 */
-	rt2x00dev->hwmodes[0].mode = MODE_IEEE80211G;
-	rt2x00dev->hwmodes[0].num_channels = 14;
-	rt2x00dev->hwmodes[0].num_rates = 12;
+	rt2500pci_init_hw_channels(rt2x00dev, channels);
+	rt2500pci_init_hw_rates(rt2x00dev, rates);
 
 	/*
 	 * Intitialize 802.11b
 	 * Rates: CCK.
 	 * Channels: OFDM.
 	 */
-	rt2x00dev->hwmodes[1].mode = MODE_IEEE80211B;
-	rt2x00dev->hwmodes[1].num_channels = 14;
-	rt2x00dev->hwmodes[1].num_rates = 4;
-	rt2x00dev->hwmodes[1].channels = rt2x00dev->hwmodes[0].channels;
-	rt2x00dev->hwmodes[1].rates = rt2x00dev->hwmodes[0].rates;
+	rt2x00dev->hwmodes[HWMODE_B].mode = MODE_IEEE80211B;
+	rt2x00dev->hwmodes[HWMODE_B].num_channels = 14;
+	rt2x00dev->hwmodes[HWMODE_B].num_rates = 4;
+	rt2x00dev->hwmodes[HWMODE_B].channels = channels;
+	rt2x00dev->hwmodes[HWMODE_B].rates = rates;
+
+	/*
+	 * Intitialize 802.11g
+	 * Rates: CCK, OFDM.
+	 * Channels: OFDM.
+	 */
+	rt2x00dev->hwmodes[HWMODE_G].mode = MODE_IEEE80211G;
+	rt2x00dev->hwmodes[HWMODE_G].num_channels = 14;
+	rt2x00dev->hwmodes[HWMODE_G].num_rates = 12;
+	rt2x00dev->hwmodes[HWMODE_G].channels = channels;
+	rt2x00dev->hwmodes[HWMODE_G].rates = rates;
 
 	/*
 	 * Intitialize 802.11a
 	 * Rates: OFDM.
 	 * Channels: OFDM, UNII, HiperLAN2.
 	 */
-	if (rt2x00_rf(&rt2x00dev->chip, RF5222)) {
-		rt2x00dev->hwmodes[2].mode = MODE_IEEE80211A;
-		rt2x00dev->hwmodes[2].num_channels = 37;
-		rt2x00dev->hwmodes[2].num_rates = 8;
-		rt2x00dev->hwmodes[2].channels = &rt2x00dev->hwmodes[0].channels[14];
-		rt2x00dev->hwmodes[2].rates = &rt2x00dev->hwmodes[0].rates[4];
+	if (num_modes == 3) {
+		rt2x00dev->hwmodes[HWMODE_A].mode = MODE_IEEE80211A;
+		rt2x00dev->hwmodes[HWMODE_A].num_channels = 23;
+		rt2x00dev->hwmodes[HWMODE_A].num_rates = 8;
+		rt2x00dev->hwmodes[HWMODE_A].channels = &channels[14];
+		rt2x00dev->hwmodes[HWMODE_A].rates = &rates[4];
+	}
+
+	/*
+	 * Register the working modes.
+	 */
+	status = ieee80211_register_hwmode(rt2x00dev->hw,
+		&rt2x00dev->hwmodes[HWMODE_G]);
+	if (status)
+		goto exit_free_rates;
+
+	status = ieee80211_register_hwmode(rt2x00dev->hw,
+		&rt2x00dev->hwmodes[HWMODE_B]);
+	if (status)
+		goto exit_free_rates;
+
+	if (num_modes == 3) {
+		status = ieee80211_register_hwmode(rt2x00dev->hw,
+			&rt2x00dev->hwmodes[HWMODE_A]);
+		if (status)
+			goto exit_free_rates;
 	}
 
-	rt2500pci_init_hw_channels(rt2x00dev, rt2x00dev->hwmodes[0].channels);
-	rt2500pci_init_hw_rates(rt2x00dev, rt2x00dev->hwmodes[0].rates);
+	return 0;
 
-	return num_modes;
+exit_free_rates:
+	kfree(rates);
 
 exit_free_channels:
-	kfree(rt2x00dev->hwmodes[0].channels);
-	rt2x00dev->hwmodes[0].channels = NULL;
+	kfree(channels);
 
 exit_free_modes:
 	kfree(rt2x00dev->hwmodes);
@@ -3012,13 +3038,12 @@ exit_free_modes:
 
 exit:
 	ERROR("Allocation ieee80211 modes failed.\n");
-	return -ENOMEM;
+	return status;
 }
 
 static int rt2500pci_init_hw(struct rt2x00_dev *rt2x00dev)
 {
 	int status;
-	int i, num_modes;
 
 	if (GET_FLAG(rt2x00dev, DEVICE_INITIALIZED_HW))
 		return 0;
@@ -3042,21 +3067,17 @@ static int rt2500pci_init_hw(struct rt2x00_dev *rt2x00dev)
 		IEEE80211_HW_NO_TKIP_WMM_HWACCEL |
 		IEEE80211_HW_MONITOR_DURING_OPER;
 	rt2x00dev->hw->extra_tx_headroom = 0;
+	rt2x00dev->hw->max_rssi = MAX_RX_SSI;
+	rt2x00dev->hw->max_noise = MAX_RX_NOISE;
 	rt2x00dev->hw->queues = RING_NUM_TX;
 
-	num_modes = rt2500pci_init_hw_modes(rt2x00dev);
-	if (num_modes <= 0)
-		return num_modes;
-
 	if (ieee80211_register_hw(rt2x00dev->hw))
 		return -EIO;
-	for (i = 0; i < num_modes; i++) {
-		status = ieee80211_register_hwmode(rt2x00dev->hw,
-						   &rt2x00dev->hwmodes[i]);
-		if (status) {
-			ieee80211_unregister_hw(rt2x00dev->hw);
-			return status;
-		}
+
+	status = rt2500pci_init_hw_modes(rt2x00dev);
+	if (status) {
+		ieee80211_unregister_hw(rt2x00dev->hw);
+		return status;
 	}
 
 	SET_FLAG(rt2x00dev, DEVICE_INITIALIZED_HW);
@@ -3102,8 +3123,8 @@ static void rt2500pci_free_dev(struct rt2x00_dev *rt2x00dev)
 	 * Free ieee80211_hw memory.
 	 */
 	if (likely(rt2x00dev->hwmodes)) {
-		kfree(rt2x00dev->hwmodes[0].channels);
-		kfree(rt2x00dev->hwmodes[0].rates);
+		kfree(rt2x00dev->hwmodes->channels);
+		kfree(rt2x00dev->hwmodes->rates);
 		kfree(rt2x00dev->hwmodes);
 		rt2x00dev->hwmodes = NULL;
 	}
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
index 443cde4..77c60d0 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
@@ -684,7 +684,7 @@ static void rt2500usb_config_antenna(struct rt2x00_dev *rt2x00dev,
 }
 
 static void rt2500usb_config_duration(struct rt2x00_dev *rt2x00dev,
-	unsigned short short_slot_time)
+	int short_slot_time)
 {
 	short_slot_time = short_slot_time ? SHORT_SLOT_TIME : SLOT_TIME;
 
@@ -723,6 +723,7 @@ static void rt2500usb_config_rate(struct rt2x00_dev *rt2x00dev, const int rate)
 static void rt2500usb_config_phymode(struct rt2x00_dev *rt2x00dev,
 	const int phymode)
 {
+	struct ieee80211_hw_mode *mode;
 	struct ieee80211_rate *rate;
 
 	/*
@@ -731,19 +732,26 @@ static void rt2500usb_config_phymode(struct rt2x00_dev *rt2x00dev,
 	if (rt2x00dev->rx_status.phymode == phymode)
 		return;
 
-	if (phymode == MODE_IEEE80211A &&
-	    rt2x00_rf(&rt2x00dev->chip, RF5222))
-		rate = &rt2x00dev->hwmodes[2].rates[
-			rt2x00dev->hwmodes[2].num_rates - 1];
+	if (phymode == MODE_IEEE80211A)
+		rt2x00dev->curr_hwmode = HWMODE_A;
 	else if (phymode == MODE_IEEE80211B)
-		rate = &rt2x00dev->hwmodes[1].rates[
-			rt2x00dev->hwmodes[1].num_rates - 1];
+		rt2x00dev->curr_hwmode = HWMODE_B;
 	else
-		rate = &rt2x00dev->hwmodes[0].rates[
-			rt2x00dev->hwmodes[0].num_rates - 1];
+		rt2x00dev->curr_hwmode = HWMODE_G;
+
+	mode = &rt2x00dev->hwmodes[rt2x00dev->curr_hwmode];
+	rate = &mode->rates[mode->num_rates - 1];
 
 	rt2500usb_config_rate(rt2x00dev, rate->val2);
 
+	if (phymode == MODE_IEEE80211B) {
+		rt2x00_register_write(rt2x00dev, MAC_CSR11, 0x000b);
+		rt2x00_register_write(rt2x00dev, MAC_CSR12, 0x0040);
+	} else {
+		rt2x00_register_write(rt2x00dev, MAC_CSR11, 0x0005);
+		rt2x00_register_write(rt2x00dev, MAC_CSR12, 0x016c);
+	}
+
 	/*
 	 * Update physical mode for rx ring.
 	 */
@@ -2604,7 +2612,6 @@ static int rt2500usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 		rt2x00_get_field16(eeprom, EEPROM_CALIBRATE_OFFSET_RSSI);
 	if (rt2x00dev->hw->max_rssi == 0x00 || rt2x00dev->hw->max_rssi == (s8)0xff)
 		rt2x00dev->hw->max_rssi = MAX_RX_SSI;
-	rt2x00dev->hw->max_noise = MAX_RX_NOISE;
 
 	return 0;
 }
@@ -2799,6 +2806,9 @@ static void rt2500usb_init_hw_rates(struct rt2x00_dev *rt2x00dev,
 
 static int rt2500usb_init_hw_modes(struct rt2x00_dev *rt2x00dev)
 {
+	struct ieee80211_channel *channels;
+	struct ieee80211_rate *rates;
+	int status = -ENOMEM;
 	int num_modes;
 	int num_channels;
 
@@ -2817,64 +2827,88 @@ static int rt2500usb_init_hw_modes(struct rt2x00_dev *rt2x00dev)
 	}
 
 	rt2x00dev->hwmodes =
-		kzalloc((sizeof(struct ieee80211_hw_mode) * num_modes),
-		GFP_KERNEL);
+		kzalloc(sizeof(struct ieee80211_hw_mode) * num_modes,
+			GFP_KERNEL);
 	if (!rt2x00dev->hwmodes)
 		goto exit;
 
-	rt2x00dev->hwmodes[0].channels =
-		kzalloc((sizeof(struct ieee80211_channel) * num_channels),
+	channels = kzalloc(sizeof(struct ieee80211_channel) * num_channels,
 		GFP_KERNEL);
-	if (!rt2x00dev->hwmodes[0].channels)
+	if (!channels)
 		goto exit_free_modes;
 
-	rt2x00dev->hwmodes[0].rates =
-		kzalloc((sizeof(struct ieee80211_rate) * 12),
-		GFP_KERNEL);
-	if (!rt2x00dev->hwmodes[0].rates)
+	rates = kzalloc(sizeof(struct ieee80211_rate) * 12, GFP_KERNEL);
+	if (!rates)
 		goto exit_free_channels;
 
 	/*
-	 * Intitialize 802.11g
-	 * Rates: CCK, OFDM.
-	 * Channels: OFDM.
+	 * Initialize channels and rate arrays.
 	 */
-	rt2x00dev->hwmodes[0].mode = MODE_IEEE80211G;
-	rt2x00dev->hwmodes[0].num_channels = 14;
-	rt2x00dev->hwmodes[0].num_rates = 12;
+	rt2500usb_init_hw_channels(rt2x00dev, channels);
+	rt2500usb_init_hw_rates(rt2x00dev, rates);
 
 	/*
 	 * Intitialize 802.11b
 	 * Rates: CCK.
 	 * Channels: OFDM.
 	 */
-	rt2x00dev->hwmodes[1].mode = MODE_IEEE80211B;
-	rt2x00dev->hwmodes[1].num_channels = 14;
-	rt2x00dev->hwmodes[1].num_rates = 4;
-	rt2x00dev->hwmodes[1].channels = rt2x00dev->hwmodes[0].channels;
-	rt2x00dev->hwmodes[1].rates = rt2x00dev->hwmodes[0].rates;
+	rt2x00dev->hwmodes[HWMODE_B].mode = MODE_IEEE80211B;
+	rt2x00dev->hwmodes[HWMODE_B].num_channels = 14;
+	rt2x00dev->hwmodes[HWMODE_B].num_rates = 4;
+	rt2x00dev->hwmodes[HWMODE_B].channels = channels;
+	rt2x00dev->hwmodes[HWMODE_B].rates = rates;
+
+	/*
+	 * Intitialize 802.11g
+	 * Rates: CCK, OFDM.
+	 * Channels: OFDM.
+	 */
+	rt2x00dev->hwmodes[HWMODE_G].mode = MODE_IEEE80211G;
+	rt2x00dev->hwmodes[HWMODE_G].num_channels = 14;
+	rt2x00dev->hwmodes[HWMODE_G].num_rates = 12;
+	rt2x00dev->hwmodes[HWMODE_G].channels = channels;
+	rt2x00dev->hwmodes[HWMODE_G].rates = rates;
 
 	/*
 	 * Intitialize 802.11a
 	 * Rates: OFDM.
 	 * Channels: OFDM, UNII, HiperLAN2.
 	 */
-	if (rt2x00_rf(&rt2x00dev->chip, RF5222)) {
-		rt2x00dev->hwmodes[2].mode = MODE_IEEE80211A;
-		rt2x00dev->hwmodes[2].num_channels = 37;
-		rt2x00dev->hwmodes[2].num_rates = 8;
-		rt2x00dev->hwmodes[2].channels = &rt2x00dev->hwmodes[0].channels[14];
-		rt2x00dev->hwmodes[2].rates = &rt2x00dev->hwmodes[0].rates[4];
+	if (num_channels == 3) {
+		rt2x00dev->hwmodes[HWMODE_A].mode = MODE_IEEE80211A;
+		rt2x00dev->hwmodes[HWMODE_A].num_channels = 23;
+		rt2x00dev->hwmodes[HWMODE_A].num_rates = 8;
+		rt2x00dev->hwmodes[HWMODE_A].channels = &channels[14];
+		rt2x00dev->hwmodes[HWMODE_A].rates = &rates[4];
 	}
 
-	rt2500usb_init_hw_channels(rt2x00dev, rt2x00dev->hwmodes[0].channels);
-	rt2500usb_init_hw_rates(rt2x00dev, rt2x00dev->hwmodes[0].rates);
+	/*
+	 * Register the working modes.
+	 */
+	status = ieee80211_register_hwmode(rt2x00dev->hw,
+		&rt2x00dev->hwmodes[HWMODE_G]);
+	if (status)
+		goto exit_free_rates;
+
+	status = ieee80211_register_hwmode(rt2x00dev->hw,
+		&rt2x00dev->hwmodes[HWMODE_B]);
+	if (status)
+		goto exit_free_rates;
+
+	if (num_modes == 3) {
+		status = ieee80211_register_hwmode(rt2x00dev->hw,
+			&rt2x00dev->hwmodes[HWMODE_A]);
+		if (status)
+			goto exit_free_rates;
+	}
+
+	return 0;
 
-	return num_modes;
+exit_free_rates:
+	kfree(rates);
 
 exit_free_channels:
-	kfree(rt2x00dev->hwmodes[0].channels);
-	rt2x00dev->hwmodes[0].channels = NULL;
+	kfree(channels);
 
 exit_free_modes:
 	kfree(rt2x00dev->hwmodes);
@@ -2882,13 +2916,12 @@ exit_free_modes:
 
 exit:
 	ERROR("Allocation ieee80211 modes failed.\n");
-	return -ENOMEM;
+	return status;
 }
 
 static int rt2500usb_init_hw(struct rt2x00_dev *rt2x00dev)
 {
 	int status;
-	int i, num_modes;
 
 	if (GET_FLAG(rt2x00dev, DEVICE_INITIALIZED_HW))
 		return 0;
@@ -2905,28 +2938,24 @@ static int rt2500usb_init_hw(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize all hw fields.
 	 */
-	rt2x00dev->hw->flags = IEEE80211_HW_HOST_GEN_BEACON |
+	rt2x00dev->hw->flags = IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE |
 		IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 		IEEE80211_HW_WEP_INCLUDE_IV |
 		IEEE80211_HW_DATA_NULLFUNC_ACK |
 		IEEE80211_HW_NO_TKIP_WMM_HWACCEL |
 		IEEE80211_HW_MONITOR_DURING_OPER;
-	rt2x00dev->hw->extra_tx_headroom = 0;
+	rt2x00dev->hw->extra_tx_headroom = TXD_DESC_SIZE;
+	rt2x00dev->hw->max_rssi = MAX_RX_SSI;
+	rt2x00dev->hw->max_noise = -110;
 	rt2x00dev->hw->queues = RING_NUM_TX;
 
-	num_modes = rt2500usb_init_hw_modes(rt2x00dev);
-	if (num_modes <= 0)
-		return num_modes;
-
 	if (ieee80211_register_hw(rt2x00dev->hw))
 		return -EIO;
-	for (i = 0; i < num_modes; i++) {
-		status = ieee80211_register_hwmode(rt2x00dev->hw,
-						   &rt2x00dev->hwmodes[i]);
-		if (status) {
-			ieee80211_unregister_hw(rt2x00dev->hw);
-			return status;
-		}
+
+	status = rt2500usb_init_hw_modes(rt2x00dev);
+	if (status) {
+		ieee80211_unregister_hw(rt2x00dev->hw);
+		return status;
 	}
 
 	SET_FLAG(rt2x00dev, DEVICE_INITIALIZED_HW);
@@ -2964,8 +2993,8 @@ static void rt2500usb_free_dev(struct rt2x00_dev *rt2x00dev)
 	 * Free ieee80211_hw memory.
 	 */
 	if (likely(rt2x00dev->hwmodes)) {
-		kfree(rt2x00dev->hwmodes[0].channels);
-		kfree(rt2x00dev->hwmodes[0].rates);
+		kfree(rt2x00dev->hwmodes->channels);
+		kfree(rt2x00dev->hwmodes->rates);
 		kfree(rt2x00dev->hwmodes);
 		rt2x00dev->hwmodes = NULL;
 	}
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
index 674a33b..17f3076 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
@@ -942,6 +942,7 @@ static void rt61pci_config_rate(struct rt2x00_dev *rt2x00dev, const int rate)
 static void rt61pci_config_phymode(struct rt2x00_dev *rt2x00dev,
 	const int phymode)
 {
+	struct ieee80211_hw_mode *mode;
 	struct ieee80211_rate *rate;
 
 	/*
@@ -950,17 +951,15 @@ static void rt61pci_config_phymode(struct rt2x00_dev *rt2x00dev,
 	if (rt2x00dev->rx_status.phymode == phymode)
 		return;
 
-	if (phymode == MODE_IEEE80211A &&
-	    (rt2x00_rf(&rt2x00dev->chip, RF5225) ||
-	    rt2x00_rf(&rt2x00dev->chip, RF5325)))
-		rate = &rt2x00dev->hwmodes[2].rates[
-			rt2x00dev->hwmodes[2].num_rates - 1];
+	if (phymode == MODE_IEEE80211A)
+		rt2x00dev->curr_hwmode = HWMODE_A;
 	else if (phymode == MODE_IEEE80211B)
-		rate = &rt2x00dev->hwmodes[1].rates[
-			rt2x00dev->hwmodes[1].num_rates - 1];
+		rt2x00dev->curr_hwmode = HWMODE_B;
 	else
-		rate = &rt2x00dev->hwmodes[0].rates[
-			rt2x00dev->hwmodes[0].num_rates - 1];
+		rt2x00dev->curr_hwmode = HWMODE_G;
+
+	mode = &rt2x00dev->hwmodes[rt2x00dev->curr_hwmode];
+	rate = &mode->rates[mode->num_rates - 1];
 
 	rt61pci_config_rate(rt2x00dev, rate->val2);
 
@@ -3422,6 +3421,9 @@ static void rt61pci_init_hw_rates(struct rt2x00_dev *rt2x00dev,
 
 static int rt61pci_init_hw_modes(struct rt2x00_dev *rt2x00dev)
 {
+	struct ieee80211_channel *channels;
+	struct ieee80211_rate *rates;
+	int status = -ENOMEM;
 	int num_modes;
 	int num_channels;
 
@@ -3430,7 +3432,7 @@ static int rt61pci_init_hw_modes(struct rt2x00_dev *rt2x00dev)
 	 * so we should allocate 14 OFDM channels, 4 CCK rates
 	 * and 8 OFDM rates.
 	 * RF5225 and RF5325 also supports 802.11a, so allocate an
-	 * additional 23 5.2GHz channels.
+	 * additional 24 5.2GHz channels.
 	 */
 	num_modes = 2;
 	num_channels = 14;
@@ -3441,79 +3443,101 @@ static int rt61pci_init_hw_modes(struct rt2x00_dev *rt2x00dev)
 	}
 
 	rt2x00dev->hwmodes =
-		kzalloc((sizeof(struct ieee80211_hw_mode) * num_modes),
-		GFP_KERNEL);
+		kzalloc(sizeof(struct ieee80211_hw_mode) * num_modes,
+			GFP_KERNEL);
 	if (!rt2x00dev->hwmodes)
 		goto exit;
 
-	rt2x00dev->hwmodes[0].channels =
-		kzalloc((sizeof(struct ieee80211_channel) * num_channels),
+	channels = kzalloc(sizeof(struct ieee80211_channel) * num_channels,
 		GFP_KERNEL);
-	if (!rt2x00dev->hwmodes[0].channels)
+	if (!channels)
 		goto exit_free_modes;
 
-	rt2x00dev->hwmodes[0].rates =
-		kzalloc((sizeof(struct ieee80211_rate) * 12),
-		GFP_KERNEL);
-	if (!rt2x00dev->hwmodes[0].rates)
+	rates = kzalloc(sizeof(struct ieee80211_rate) * 12, GFP_KERNEL);
+	if (!rates)
 		goto exit_free_channels;
 
 	/*
-	 * Intitialize 802.11g
-	 * Rates: CCK, OFDM.
-	 * Channels: OFDM.
+	 * Initialize channels and rate arrays.
 	 */
-	rt2x00dev->hwmodes[0].mode = MODE_IEEE80211G;
-	rt2x00dev->hwmodes[0].num_channels = 14;
-	rt2x00dev->hwmodes[0].num_rates = 12;
+	rt61pci_init_hw_channels(rt2x00dev, channels);
+	rt61pci_init_hw_rates(rt2x00dev, rates);
 
 	/*
-	 * Intitialize 802.11b
+	 * Initialize 802.11b
 	 * Rates: CCK.
 	 * Channels: OFDM.
 	 */
-	rt2x00dev->hwmodes[1].mode = MODE_IEEE80211B;
-	rt2x00dev->hwmodes[1].num_channels = 14;
-	rt2x00dev->hwmodes[1].num_rates = 4;
-	rt2x00dev->hwmodes[1].channels = rt2x00dev->hwmodes[0].channels;
-	rt2x00dev->hwmodes[1].rates = rt2x00dev->hwmodes[0].rates;
+	rt2x00dev->hwmodes[HWMODE_B].mode = MODE_IEEE80211B;
+	rt2x00dev->hwmodes[HWMODE_B].num_channels = 14;
+	rt2x00dev->hwmodes[HWMODE_B].num_rates = 4;
+	rt2x00dev->hwmodes[HWMODE_B].channels = channels;
+	rt2x00dev->hwmodes[HWMODE_B].rates = rates;
+
+	/*
+	 * Initialize 802.11g
+	 * Rates: CCK, OFDM.
+	 * Channels: OFDM.
+	 */
+	rt2x00dev->hwmodes[HWMODE_G].mode = MODE_IEEE80211G;
+	rt2x00dev->hwmodes[HWMODE_G].num_channels = 14;
+	rt2x00dev->hwmodes[HWMODE_G].num_rates = 12;
+	rt2x00dev->hwmodes[HWMODE_G].channels = channels;
+	rt2x00dev->hwmodes[HWMODE_G].rates = rates;
 
 	/*
-	 * Intitialize 802.11a
+	 * Initialize 802.11a
 	 * Rates: OFDM.
 	 * Channels: OFDM, UNII, HiperLAN2.
 	 */
-	if (rt2x00_rf(&rt2x00dev->chip, RF5225) ||
-	    rt2x00_rf(&rt2x00dev->chip, RF5325)) {
-		rt2x00dev->hwmodes[2].mode = MODE_IEEE80211A;
-		rt2x00dev->hwmodes[2].num_channels = 38;
-		rt2x00dev->hwmodes[2].num_rates = 8;
-		rt2x00dev->hwmodes[2].channels = &rt2x00dev->hwmodes[0].channels[14];
-		rt2x00dev->hwmodes[2].rates = &rt2x00dev->hwmodes[0].rates[4];
+	if (num_channels == 3) {
+		rt2x00dev->hwmodes[HWMODE_A].mode = MODE_IEEE80211A;
+		rt2x00dev->hwmodes[HWMODE_A].num_channels = 24;
+		rt2x00dev->hwmodes[HWMODE_A].num_rates = 8;
+		rt2x00dev->hwmodes[HWMODE_A].channels = &channels[14];
+		rt2x00dev->hwmodes[HWMODE_A].rates = &rates[4];
 	}
 
-	rt61pci_init_hw_channels(rt2x00dev, rt2x00dev->hwmodes[0].channels);
-	rt61pci_init_hw_rates(rt2x00dev, rt2x00dev->hwmodes[0].rates);
+	/*
+	 * Register the working modes.
+	 */
+	status = ieee80211_register_hwmode(rt2x00dev->hw,
+		&rt2x00dev->hwmodes[HWMODE_G]);
+	if (status)
+		goto exit_free_rates;
 
-	return num_modes;
+	status = ieee80211_register_hwmode(rt2x00dev->hw,
+		&rt2x00dev->hwmodes[HWMODE_B]);
+	if (status)
+		goto exit_free_rates;
+
+	if (num_modes == 3) {
+		status = ieee80211_register_hwmode(rt2x00dev->hw,
+			&rt2x00dev->hwmodes[HWMODE_A]);
+		if (status)
+			goto exit_free_rates;
+	}
+
+	return 0;
+
+exit_free_rates:
+	kfree(rates);
 
 exit_free_channels:
-	kfree(rt2x00dev->hwmodes[0].channels);
-	rt2x00dev->hwmodes[0].channels = NULL;
+	kfree(channels);
 
 exit_free_modes:
 	kfree(rt2x00dev->hwmodes);
 	rt2x00dev->hwmodes = NULL;
 
 exit:
-	ERROR("Allocation ieee80211 modes failed.\n");
-	return -ENOMEM;
+	ERROR("ieee80211 modes allocation failed.\n");
+	return status;
 }
 
 static int rt61pci_init_hw(struct rt2x00_dev *rt2x00dev)
 {
 	int status;
-	int i, num_modes;
 
 	if (GET_FLAG(rt2x00dev, DEVICE_INITIALIZED_HW))
 		return 0;
@@ -3541,19 +3565,13 @@ static int rt61pci_init_hw(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->hw->max_noise = MAX_RX_NOISE;
 	rt2x00dev->hw->queues = RING_NUM_TX;
 
-	num_modes = rt61pci_init_hw_modes(rt2x00dev);
-	if (num_modes <= 0)
-		return num_modes;
-
 	if (ieee80211_register_hw(rt2x00dev->hw))
 		return -EIO;
-	for (i = 0; i < num_modes; i++) {
-		status = ieee80211_register_hwmode(rt2x00dev->hw,
-						   &rt2x00dev->hwmodes[i]);
-		if (status) {
-			ieee80211_unregister_hw(rt2x00dev->hw);
-			return status;
-		}
+
+	status = rt61pci_init_hw_modes(rt2x00dev);
+	if (status) {
+		ieee80211_unregister_hw(rt2x00dev->hw);
+		return status;
 	}
 
 	SET_FLAG(rt2x00dev, DEVICE_INITIALIZED_HW);
@@ -3599,8 +3617,8 @@ static void rt61pci_free_dev(struct rt2x00_dev *rt2x00dev)
 	 * Free ieee80211_hw memory.
 	 */
 	if (likely(rt2x00dev->hwmodes)) {
-		kfree(rt2x00dev->hwmodes[0].channels);
-		kfree(rt2x00dev->hwmodes[0].rates);
+		kfree(rt2x00dev->hwmodes->channels);
+		kfree(rt2x00dev->hwmodes->rates);
 		kfree(rt2x00dev->hwmodes);
 		rt2x00dev->hwmodes = NULL;
 	}
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
index db11d44..a1f7c91 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
@@ -825,6 +825,7 @@ static void rt73usb_config_rate(struct rt2x00_dev *rt2x00dev, const int rate)
 static void rt73usb_config_phymode(struct rt2x00_dev *rt2x00dev,
 	const int phymode)
 {
+	struct ieee80211_hw_mode *mode;
 	struct ieee80211_rate *rate;
 
 	/*
@@ -833,17 +834,15 @@ static void rt73usb_config_phymode(struct rt2x00_dev *rt2x00dev,
 	if (rt2x00dev->rx_status.phymode == phymode)
 		return;
 
-	if (phymode == MODE_IEEE80211A &&
-	    (rt2x00_rf(&rt2x00dev->chip, RF5225) ||
-	    rt2x00_rf(&rt2x00dev->chip, RF5226)))
-		rate = &rt2x00dev->hwmodes[2].rates[
-			rt2x00dev->hwmodes[2].num_rates - 1];
+	if (phymode == MODE_IEEE80211A)
+		rt2x00dev->curr_hwmode = HWMODE_A;
 	else if (phymode == MODE_IEEE80211B)
-		rate = &rt2x00dev->hwmodes[1].rates[
-			rt2x00dev->hwmodes[1].num_rates - 1];
+		rt2x00dev->curr_hwmode = HWMODE_B;
 	else
-		rate = &rt2x00dev->hwmodes[0].rates[
-			rt2x00dev->hwmodes[0].num_rates - 1];
+		rt2x00dev->curr_hwmode = HWMODE_G;
+
+	mode = &rt2x00dev->hwmodes[rt2x00dev->curr_hwmode];
+	rate = &mode->rates[mode->num_rates - 1];
 
 	rt73usb_config_rate(rt2x00dev, rate->val2);
 
@@ -3129,6 +3128,9 @@ static void rt73usb_init_hw_rates(struct rt2x00_dev *rt2x00dev,
 
 static int rt73usb_init_hw_modes(struct rt2x00_dev *rt2x00dev)
 {
+	struct ieee80211_channel *channels;
+	struct ieee80211_rate *rates;
+	int status = -ENOMEM;
 	int num_modes;
 	int num_channels;
 
@@ -3137,7 +3139,7 @@ static int rt73usb_init_hw_modes(struct rt2x00_dev *rt2x00dev)
 	 * so we should allocate 14 OFDM channels, 4 CCK rates
 	 * and 8 OFDM rates.
 	 * RF5225 and RF5226 also supports 802.11a, so allocate an
-	 * additional 23 5.2GHz channels.
+	 * additional 24 5.2GHz channels.
 	 */
 	num_modes = 2;
 	num_channels = 14;
@@ -3148,65 +3150,88 @@ static int rt73usb_init_hw_modes(struct rt2x00_dev *rt2x00dev)
 	}
 
 	rt2x00dev->hwmodes =
-		kzalloc((sizeof(struct ieee80211_hw_mode) * num_modes),
-		GFP_KERNEL);
+		kzalloc(sizeof(struct ieee80211_hw_mode) * num_modes,
+			GFP_KERNEL);
 	if (!rt2x00dev->hwmodes)
 		goto exit;
 
-	rt2x00dev->hwmodes[0].channels =
-		kzalloc((sizeof(struct ieee80211_channel) * num_channels),
+	channels = kzalloc(sizeof(struct ieee80211_channel) * num_channels,
 		GFP_KERNEL);
-	if (!rt2x00dev->hwmodes[0].channels)
+	if (!channels)
 		goto exit_free_modes;
 
-	rt2x00dev->hwmodes[0].rates =
-		kzalloc((sizeof(struct ieee80211_rate) * 12),
-		GFP_KERNEL);
-	if (!rt2x00dev->hwmodes[0].rates)
+	rates = kzalloc(sizeof(struct ieee80211_rate) * 12, GFP_KERNEL);
+	if (!rates)
 		goto exit_free_channels;
 
 	/*
-	 * Intitialize 802.11g
-	 * Rates: CCK, OFDM.
-	 * Channels: OFDM.
+	 * Initialize channels and rate arrays.
 	 */
-	rt2x00dev->hwmodes[0].mode = MODE_IEEE80211G;
-	rt2x00dev->hwmodes[0].num_channels = 14;
-	rt2x00dev->hwmodes[0].num_rates = 12;
+	rt73usb_init_hw_channels(rt2x00dev, channels);
+	rt73usb_init_hw_rates(rt2x00dev, rates);
 
 	/*
 	 * Intitialize 802.11b
 	 * Rates: CCK.
 	 * Channels: OFDM.
 	 */
-	rt2x00dev->hwmodes[1].mode = MODE_IEEE80211B;
-	rt2x00dev->hwmodes[1].num_channels = 14;
-	rt2x00dev->hwmodes[1].num_rates = 4;
-	rt2x00dev->hwmodes[1].channels = rt2x00dev->hwmodes[0].channels;
-	rt2x00dev->hwmodes[1].rates = rt2x00dev->hwmodes[0].rates;
+	rt2x00dev->hwmodes[HWMODE_B].mode = MODE_IEEE80211B;
+	rt2x00dev->hwmodes[HWMODE_B].num_channels = 14;
+	rt2x00dev->hwmodes[HWMODE_B].num_rates = 4;
+	rt2x00dev->hwmodes[HWMODE_B].channels = channels;
+	rt2x00dev->hwmodes[HWMODE_B].rates = rates;
+
+	/*
+	 * Intitialize 802.11g
+	 * Rates: CCK, OFDM.
+	 * Channels: OFDM.
+	 */
+	rt2x00dev->hwmodes[HWMODE_G].mode = MODE_IEEE80211G;
+	rt2x00dev->hwmodes[HWMODE_G].num_channels = 14;
+	rt2x00dev->hwmodes[HWMODE_G].num_rates = 12;
+	rt2x00dev->hwmodes[HWMODE_G].channels = channels;
+	rt2x00dev->hwmodes[HWMODE_G].rates = rates;
 
 	/*
 	 * Intitialize 802.11a
 	 * Rates: OFDM.
 	 * Channels: OFDM, UNII, HiperLAN2.
 	 */
-	if (rt2x00_rf(&rt2x00dev->chip, RF5225) ||
-	    rt2x00_rf(&rt2x00dev->chip, RF5226)) {
-		rt2x00dev->hwmodes[2].mode = MODE_IEEE80211A;
-		rt2x00dev->hwmodes[2].num_channels = 38;
-		rt2x00dev->hwmodes[2].num_rates = 8;
-		rt2x00dev->hwmodes[2].channels = &rt2x00dev->hwmodes[0].channels[14];
-		rt2x00dev->hwmodes[2].rates = &rt2x00dev->hwmodes[0].rates[4];
+	if (num_channels == 3) {
+		rt2x00dev->hwmodes[HWMODE_A].mode = MODE_IEEE80211A;
+		rt2x00dev->hwmodes[HWMODE_A].num_channels = 24;
+		rt2x00dev->hwmodes[HWMODE_A].num_rates = 8;
+		rt2x00dev->hwmodes[HWMODE_A].channels = &channels[14];
+		rt2x00dev->hwmodes[HWMODE_A].rates = &rates[4];
 	}
 
-	rt73usb_init_hw_channels(rt2x00dev, rt2x00dev->hwmodes[0].channels);
-	rt73usb_init_hw_rates(rt2x00dev, rt2x00dev->hwmodes[0].rates);
+	/*
+	 * Register the working modes.
+	 */
+	status = ieee80211_register_hwmode(rt2x00dev->hw,
+		&rt2x00dev->hwmodes[HWMODE_G]);
+	if (status)
+		goto exit_free_rates;
 
-	return num_modes;
+	status = ieee80211_register_hwmode(rt2x00dev->hw,
+		&rt2x00dev->hwmodes[HWMODE_B]);
+	if (status)
+		goto exit_free_rates;
+
+	if (num_modes == 3) {
+		status = ieee80211_register_hwmode(rt2x00dev->hw,
+			&rt2x00dev->hwmodes[HWMODE_A]);
+		if (status)
+			goto exit_free_rates;
+	}
+
+	return 0;
+
+exit_free_rates:
+	kfree(rates);
 
 exit_free_channels:
-	kfree(rt2x00dev->hwmodes[0].channels);
-	rt2x00dev->hwmodes[0].channels = NULL;
+	kfree(channels);
 
 exit_free_modes:
 	kfree(rt2x00dev->hwmodes);
@@ -3214,13 +3239,12 @@ exit_free_modes:
 
 exit:
 	ERROR("Allocation ieee80211 modes failed.\n");
-	return -ENOMEM;
+	return status;
 }
 
 static int rt73usb_init_hw(struct rt2x00_dev *rt2x00dev)
 {
 	int status;
-	int i, num_modes;
 
 	if (GET_FLAG(rt2x00dev, DEVICE_INITIALIZED_HW))
 		return 0;
@@ -3237,30 +3261,24 @@ static int rt73usb_init_hw(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize all hw fields.
 	 */
-	rt2x00dev->hw->flags = IEEE80211_HW_HOST_GEN_BEACON |
+	rt2x00dev->hw->flags = IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE |
 		IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 		IEEE80211_HW_WEP_INCLUDE_IV |
 		IEEE80211_HW_DATA_NULLFUNC_ACK |
 		IEEE80211_HW_NO_TKIP_WMM_HWACCEL |
 		IEEE80211_HW_MONITOR_DURING_OPER;
-	rt2x00dev->hw->extra_tx_headroom = 0;
+	rt2x00dev->hw->extra_tx_headroom = TXD_DESC_SIZE;
 	rt2x00dev->hw->max_rssi = MAX_RX_SSI;
 	rt2x00dev->hw->max_noise = MAX_RX_NOISE;
 	rt2x00dev->hw->queues = RING_NUM_TX;
 
-	num_modes = rt73usb_init_hw_modes(rt2x00dev);
-	if (num_modes <= 0)
-		return num_modes;
-
 	if (ieee80211_register_hw(rt2x00dev->hw))
 		return -EIO;
-	for (i = 0; i < num_modes; i++) {
-		status = ieee80211_register_hwmode(rt2x00dev->hw,
-						   &rt2x00dev->hwmodes[i]);
-		if (status) {
-			ieee80211_unregister_hw(rt2x00dev->hw);
-			return status;
-		}
+
+	status = rt73usb_init_hw_modes(rt2x00dev);
+	if (status) {
+		ieee80211_unregister_hw(rt2x00dev->hw);
+		return status;
 	}
 
 	SET_FLAG(rt2x00dev, DEVICE_INITIALIZED_HW);
@@ -3298,8 +3316,8 @@ static void rt73usb_free_dev(struct rt2x00_dev *rt2x00dev)
 	 * Free ieee80211_hw memory.
 	 */
 	if (likely(rt2x00dev->hwmodes)) {
-		kfree(rt2x00dev->hwmodes[0].channels);
-		kfree(rt2x00dev->hwmodes[0].rates);
+		kfree(rt2x00dev->hwmodes->channels);
+		kfree(rt2x00dev->hwmodes->rates);
 		kfree(rt2x00dev->hwmodes);
 		rt2x00dev->hwmodes = NULL;
 	}
