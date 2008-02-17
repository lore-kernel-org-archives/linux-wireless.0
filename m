Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.187]:30440 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbYBQQgE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Feb 2008 11:36:04 -0500
Received: by fk-out-0910.google.com with SMTP id z23so1391418fkz.5
        for <linux-wireless@vger.kernel.org>; Sun, 17 Feb 2008 08:36:03 -0800 (PST)
To: linville@tuxdriver.com
Subject: [PATCH 07/11] rt2x00: Cleanup mode registration
Date: Sun, 17 Feb 2008 17:35:05 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802171730.44353.IvDoorn@gmail.com>
In-Reply-To: <200802171730.44353.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802171735.06138.IvDoorn@gmail.com> (sfid-20080217_163619_653817_C35F9E08)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't wildly pass any number for num_rates to rt2x00lib,
instead pass which type of rates are supported (CCK, OFDM).
Same for num_modes but then for the 2GHZ and 5GHZ band.

This makes the interface look much nicer and makes
extending it later easier.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |    4 +-
 drivers/net/wireless/rt2x00/rt2500pci.c |    6 +-
 drivers/net/wireless/rt2x00/rt2500usb.c |    6 +-
 drivers/net/wireless/rt2x00/rt2x00.h    |   38 +++++++++------
 drivers/net/wireless/rt2x00/rt2x00dev.c |   80 +++++++++++++++---------------
 drivers/net/wireless/rt2x00/rt2x00lib.h |    5 +-
 drivers/net/wireless/rt2x00/rt61pci.c   |    6 +-
 drivers/net/wireless/rt2x00/rt73usb.c   |    8 ++--
 8 files changed, 81 insertions(+), 72 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 23b14b0..b63bc66 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1348,8 +1348,8 @@ static void rt2400pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize hw_mode information.
 	 */
-	spec->num_modes = 1;
-	spec->num_rates = 4;
+	spec->supported_bands = SUPPORT_BAND_2GHZ;
+	spec->supported_rates = SUPPORT_RATE_CCK;
 	spec->tx_power_a = NULL;
 	spec->tx_power_bg = txpower;
 	spec->tx_power_default = DEFAULT_TXPOWER;
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 26e1fcc..add8aff 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1662,8 +1662,8 @@ static void rt2500pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize hw_mode information.
 	 */
-	spec->num_modes = 2;
-	spec->num_rates = 12;
+	spec->supported_bands = SUPPORT_BAND_2GHZ;
+	spec->supported_rates = SUPPORT_RATE_CCK | SUPPORT_RATE_OFDM;
 	spec->tx_power_a = NULL;
 	spec->tx_power_bg = txpower;
 	spec->tx_power_default = DEFAULT_TXPOWER;
@@ -1684,9 +1684,9 @@ static void rt2500pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 		spec->num_channels = ARRAY_SIZE(rf_vals_bg_2525e);
 		spec->channels = rf_vals_bg_2525e;
 	} else if (rt2x00_rf(&rt2x00dev->chip, RF5222)) {
+		spec->supported_bands |= SUPPORT_BAND_5GHZ;
 		spec->num_channels = ARRAY_SIZE(rf_vals_5222);
 		spec->channels = rf_vals_5222;
-		spec->num_modes = 3;
 	}
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 27681fc..0a5900b 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1582,8 +1582,8 @@ static void rt2500usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize hw_mode information.
 	 */
-	spec->num_modes = 2;
-	spec->num_rates = 12;
+	spec->supported_bands = SUPPORT_BAND_2GHZ;
+	spec->supported_rates = SUPPORT_RATE_CCK | SUPPORT_RATE_OFDM;
 	spec->tx_power_a = NULL;
 	spec->tx_power_bg = txpower;
 	spec->tx_power_default = DEFAULT_TXPOWER;
@@ -1604,9 +1604,9 @@ static void rt2500usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 		spec->num_channels = ARRAY_SIZE(rf_vals_bg_2525e);
 		spec->channels = rf_vals_bg_2525e;
 	} else if (rt2x00_rf(&rt2x00dev->chip, RF5222)) {
+		spec->supported_bands |= SUPPORT_BAND_5GHZ;
 		spec->num_channels = ARRAY_SIZE(rf_vals_5222);
 		spec->channels = rf_vals_5222;
-		spec->num_modes = 3;
 	}
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 7a83e0a..e315d79 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -392,30 +392,38 @@ static inline struct rt2x00_intf* vif_to_intf(struct ieee80211_vif *vif)
 	return (struct rt2x00_intf *)vif->drv_priv;
 }
 
-/*
+/**
+ * struct hw_mode_spec: Hardware specifications structure
+ *
  * Details about the supported modes, rates and channels
  * of a particular chipset. This is used by rt2x00lib
  * to build the ieee80211_hw_mode array for mac80211.
+ *
+ * @supported_bands: Bitmask contained the supported bands (2.4GHz, 5.2GHz).
+ * @supported_rates: Rate types which are supported (CCK, OFDM).
+ * @num_channels: Number of supported channels. This is used as array size
+ *	for @tx_power_a, @tx_power_bg and @channels.
+ * channels: Device/chipset specific channel values (See &struct rf_channel).
+ * @tx_power_a: TX power values for all 5.2GHz channels (may be NULL).
+ * @tx_power_bg: TX power values for all 2.4GHz channels (may be NULL).
+ * @tx_power_default: Default TX power value to use when either
+ *	@tx_power_a or @tx_power_bg is missing.
  */
 struct hw_mode_spec {
-	/*
-	 * Number of modes, rates and channels.
-	 */
-	int num_modes;
-	int num_rates;
-	int num_channels;
+	unsigned int supported_bands;
+#define SUPPORT_BAND_2GHZ	0x00000001
+#define SUPPORT_BAND_5GHZ	0x00000002
+
+	unsigned int supported_rates;
+#define SUPPORT_RATE_CCK	0x00000001
+#define SUPPORT_RATE_OFDM	0x00000002
+
+	unsigned int num_channels;
+	const struct rf_channel *channels;
 
-	/*
-	 * txpower values.
-	 */
 	const u8 *tx_power_a;
 	const u8 *tx_power_bg;
 	u8 tx_power_default;
-
-	/*
-	 * Device/chipset specific value.
-	 */
-	const struct rf_channel *channels;
 };
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 3e9e61d..6103175 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -764,25 +764,25 @@ EXPORT_SYMBOL_GPL(rt2x00lib_write_tx_desc);
  */
 const struct rt2x00_rate rt2x00_supported_rates[12] = {
 	{
-		.flags = 0,
+		.flags = DEV_RATE_CCK,
 		.bitrate = 10,
 		.ratemask = DEV_RATEMASK_1MB,
 		.plcp = 0x00,
 	},
 	{
-		.flags = DEV_RATE_SHORT_PREAMBLE,
+		.flags = DEV_RATE_CCK | DEV_RATE_SHORT_PREAMBLE,
 		.bitrate = 20,
 		.ratemask = DEV_RATEMASK_2MB,
 		.plcp = 0x01,
 	},
 	{
-		.flags = DEV_RATE_SHORT_PREAMBLE,
+		.flags = DEV_RATE_CCK | DEV_RATE_SHORT_PREAMBLE,
 		.bitrate = 55,
 		.ratemask = DEV_RATEMASK_5_5MB,
 		.plcp = 0x02,
 	},
 	{
-		.flags = DEV_RATE_SHORT_PREAMBLE,
+		.flags = DEV_RATE_CCK | DEV_RATE_SHORT_PREAMBLE,
 		.bitrate = 110,
 		.ratemask = DEV_RATEMASK_11MB,
 		.plcp = 0x03,
@@ -865,67 +865,64 @@ static int rt2x00lib_probe_hw_modes(struct rt2x00_dev *rt2x00dev,
 				    struct hw_mode_spec *spec)
 {
 	struct ieee80211_hw *hw = rt2x00dev->hw;
-	struct ieee80211_supported_band *sbands;
 	struct ieee80211_channel *channels;
 	struct ieee80211_rate *rates;
+	unsigned int num_rates;
 	unsigned int i;
 	unsigned char tx_power;
 
-	sbands = &rt2x00dev->bands[0];
+	num_rates = 0;
+	if (spec->supported_rates & SUPPORT_RATE_CCK)
+		num_rates += 4;
+	if (spec->supported_rates & SUPPORT_RATE_OFDM)
+		num_rates += 8;
 
 	channels = kzalloc(sizeof(*channels) * spec->num_channels, GFP_KERNEL);
 	if (!channels)
 		return -ENOMEM;
 
-	rates = kzalloc(sizeof(*rates) * spec->num_rates, GFP_KERNEL);
+	rates = kzalloc(sizeof(*rates) * num_rates, GFP_KERNEL);
 	if (!rates)
 		goto exit_free_channels;
 
 	/*
 	 * Initialize Rate list.
 	 */
-	for (i = 0; i < spec->num_rates; i++)
+	for (i = 0; i < num_rates; i++)
 		rt2x00lib_rate(&rates[i], i, rt2x00_get_rate(i));
 
 	/*
 	 * Initialize Channel list.
 	 */
 	for (i = 0; i < spec->num_channels; i++) {
-		if (spec->channels[i].channel <= 14)
-			tx_power = spec->tx_power_bg[i];
-		else if (spec->tx_power_a)
-			tx_power = spec->tx_power_a[i];
-		else
-			tx_power = spec->tx_power_default;
+		if (spec->channels[i].channel <= 14) {
+			if (spec->tx_power_bg)
+				tx_power = spec->tx_power_bg[i];
+			else
+				tx_power = spec->tx_power_default;
+		} else {
+			if (spec->tx_power_a)
+				tx_power = spec->tx_power_a[i];
+			else
+				tx_power = spec->tx_power_default;
+		}
 
 		rt2x00lib_channel(&channels[i],
 				  spec->channels[i].channel, tx_power, i);
 	}
 
 	/*
-	 * Intitialize 802.11b
-	 * Rates: CCK.
-	 * Channels: 2.4 GHz
-	 */
-	if (spec->num_modes > 0) {
-		sbands[IEEE80211_BAND_2GHZ].n_channels = 14;
-		sbands[IEEE80211_BAND_2GHZ].n_bitrates = 4;
-		sbands[IEEE80211_BAND_2GHZ].channels = channels;
-		sbands[IEEE80211_BAND_2GHZ].bitrates = rates;
-		hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &rt2x00dev->bands[IEEE80211_BAND_2GHZ];
-	}
-
-	/*
-	 * Intitialize 802.11g
+	 * Intitialize 802.11b, 802.11g
 	 * Rates: CCK, OFDM.
 	 * Channels: 2.4 GHz
 	 */
-	if (spec->num_modes > 1) {
-		sbands[IEEE80211_BAND_2GHZ].n_channels = 14;
-		sbands[IEEE80211_BAND_2GHZ].n_bitrates = spec->num_rates;
-		sbands[IEEE80211_BAND_2GHZ].channels = channels;
-		sbands[IEEE80211_BAND_2GHZ].bitrates = rates;
-		hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &rt2x00dev->bands[IEEE80211_BAND_2GHZ];
+	if (spec->supported_bands > SUPPORT_BAND_2GHZ) {
+		rt2x00dev->bands[IEEE80211_BAND_2GHZ].n_channels = 14;
+		rt2x00dev->bands[IEEE80211_BAND_2GHZ].n_bitrates = num_rates;
+		rt2x00dev->bands[IEEE80211_BAND_2GHZ].channels = channels;
+		rt2x00dev->bands[IEEE80211_BAND_2GHZ].bitrates = rates;
+		hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
+		    &rt2x00dev->bands[IEEE80211_BAND_2GHZ];
 	}
 
 	/*
@@ -933,12 +930,15 @@ static int rt2x00lib_probe_hw_modes(struct rt2x00_dev *rt2x00dev,
 	 * Rates: OFDM.
 	 * Channels: OFDM, UNII, HiperLAN2.
 	 */
-	if (spec->num_modes > 2) {
-		sbands[IEEE80211_BAND_5GHZ].n_channels = spec->num_channels - 14;
-		sbands[IEEE80211_BAND_5GHZ].n_bitrates = spec->num_rates - 4;
-		sbands[IEEE80211_BAND_5GHZ].channels = &channels[14];
-		sbands[IEEE80211_BAND_5GHZ].bitrates = &rates[4];
-		hw->wiphy->bands[IEEE80211_BAND_5GHZ] = &rt2x00dev->bands[IEEE80211_BAND_5GHZ];
+	if (spec->supported_bands > SUPPORT_BAND_5GHZ) {
+		rt2x00dev->bands[IEEE80211_BAND_5GHZ].n_channels =
+		    spec->num_channels - 14;
+		rt2x00dev->bands[IEEE80211_BAND_5GHZ].n_bitrates =
+		    num_rates - 4;
+		rt2x00dev->bands[IEEE80211_BAND_5GHZ].channels = &channels[14];
+		rt2x00dev->bands[IEEE80211_BAND_5GHZ].bitrates = &rates[4];
+		hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
+		    &rt2x00dev->bands[IEEE80211_BAND_5GHZ];
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index 2a611e4..34ccb3d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -38,8 +38,9 @@
  */
 struct rt2x00_rate {
 	unsigned short flags;
-#define DEV_RATE_OFDM			0x0001
-#define DEV_RATE_SHORT_PREAMBLE		0x0002
+#define DEV_RATE_CCK			0x0001
+#define DEV_RATE_OFDM			0x0002
+#define DEV_RATE_SHORT_PREAMBLE		0x0004
 
 	unsigned short bitrate; /* In 100kbit/s */
 
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 3b10452..70cfdad 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2205,8 +2205,8 @@ static void rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize hw_mode information.
 	 */
-	spec->num_modes = 2;
-	spec->num_rates = 12;
+	spec->supported_bands = SUPPORT_BAND_2GHZ;
+	spec->supported_rates = SUPPORT_RATE_CCK | SUPPORT_RATE_OFDM;
 	spec->tx_power_a = NULL;
 	spec->tx_power_bg = txpower;
 	spec->tx_power_default = DEFAULT_TXPOWER;
@@ -2221,7 +2221,7 @@ static void rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 
 	if (rt2x00_rf(&rt2x00dev->chip, RF5225) ||
 	    rt2x00_rf(&rt2x00dev->chip, RF5325)) {
-		spec->num_modes = 3;
+		spec->supported_bands |= SUPPORT_BAND_5GHZ;
 		spec->num_channels = ARRAY_SIZE(rf_vals_seq);
 
 		txpower = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A_START);
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 43f5676..cae4b02 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1787,8 +1787,8 @@ static void rt73usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize hw_mode information.
 	 */
-	spec->num_modes = 2;
-	spec->num_rates = 12;
+	spec->supported_bands = SUPPORT_BAND_2GHZ;
+	spec->supported_rates = SUPPORT_RATE_CCK | SUPPORT_RATE_OFDM;
 	spec->tx_power_a = NULL;
 	spec->tx_power_bg = txpower;
 	spec->tx_power_default = DEFAULT_TXPOWER;
@@ -1797,20 +1797,20 @@ static void rt73usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 		spec->num_channels = ARRAY_SIZE(rf_vals_bg_2528);
 		spec->channels = rf_vals_bg_2528;
 	} else if (rt2x00_rf(&rt2x00dev->chip, RF5226)) {
+		spec->supported_bands |= SUPPORT_BAND_5GHZ;
 		spec->num_channels = ARRAY_SIZE(rf_vals_5226);
 		spec->channels = rf_vals_5226;
 	} else if (rt2x00_rf(&rt2x00dev->chip, RF2527)) {
 		spec->num_channels = 14;
 		spec->channels = rf_vals_5225_2527;
 	} else if (rt2x00_rf(&rt2x00dev->chip, RF5225)) {
+		spec->supported_bands |= SUPPORT_BAND_5GHZ;
 		spec->num_channels = ARRAY_SIZE(rf_vals_5225_2527);
 		spec->channels = rf_vals_5225_2527;
 	}
 
 	if (rt2x00_rf(&rt2x00dev->chip, RF5225) ||
 	    rt2x00_rf(&rt2x00dev->chip, RF5226)) {
-		spec->num_modes = 3;
-
 		txpower = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A_START);
 		for (i = 0; i < 14; i++)
 			txpower[i] = TXPOWER_FROM_DEV(txpower[i]);
-- 
1.5.4

