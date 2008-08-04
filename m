Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:1790 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908AbYHDOSS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 10:18:18 -0400
Received: by nf-out-0910.google.com with SMTP id d3so712212nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 04 Aug 2008 07:18:15 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 4/5] rt2x00: Gather channel information in structure
Date: Mon, 4 Aug 2008 16:38:47 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200808041636.41189.IvDoorn@gmail.com> <200808041638.03164.IvDoorn@gmail.com> <200808041638.24289.IvDoorn@gmail.com>
In-Reply-To: <200808041638.24289.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200808041638.47545.IvDoorn@gmail.com> (sfid-20080804_161821_471084_00A76F50)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Channel information which is read from EEPROM should
be read into an array containing per-channel information.
This removes the requirement of multiple arrays and makes
the channel handling a bit cleaner and easier to expand.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c    |   40 +++++++++++++++----------
 drivers/net/wireless/rt2x00/rt2400pci.h    |   22 +++++---------
 drivers/net/wireless/rt2x00/rt2500pci.c    |   39 +++++++++++++++++--------
 drivers/net/wireless/rt2x00/rt2500pci.h    |   17 +++--------
 drivers/net/wireless/rt2x00/rt2500usb.c    |   39 +++++++++++++++++--------
 drivers/net/wireless/rt2x00/rt2500usb.h    |   17 +++--------
 drivers/net/wireless/rt2x00/rt2x00.h       |   23 ++++++++++-----
 drivers/net/wireless/rt2x00/rt2x00config.c |    4 ++
 drivers/net/wireless/rt2x00/rt2x00dev.c    |   18 ++---------
 drivers/net/wireless/rt2x00/rt61pci.c      |   42 ++++++++++++++++-----------
 drivers/net/wireless/rt2x00/rt61pci.h      |   17 +++--------
 drivers/net/wireless/rt2x00/rt73usb.c      |   43 +++++++++++++++------------
 drivers/net/wireless/rt2x00/rt73usb.h      |   17 +++--------
 13 files changed, 176 insertions(+), 162 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 4c0538d..0107cec 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1404,7 +1404,7 @@ static int rt2400pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
  * RF value list for RF2420 & RF2421
  * Supports: 2.4 GHz
  */
-static const struct rf_channel rf_vals_bg[] = {
+static const struct rf_channel rf_vals_b[] = {
 	{ 1,  0x00022058, 0x000c1fda, 0x00000101, 0 },
 	{ 2,  0x00022058, 0x000c1fee, 0x00000101, 0 },
 	{ 3,  0x00022058, 0x000c2002, 0x00000101, 0 },
@@ -1421,10 +1421,11 @@ static const struct rf_channel rf_vals_bg[] = {
 	{ 14, 0x00022058, 0x000c20fa, 0x00000101, 0 },
 };
 
-static void rt2400pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
+static int rt2400pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 {
 	struct hw_mode_spec *spec = &rt2x00dev->spec;
-	u8 *txpower;
+	struct channel_info *info;
+	char *tx_power;
 	unsigned int i;
 
 	/*
@@ -1440,23 +1441,28 @@ static void rt2400pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 						   EEPROM_MAC_ADDR_0));
 
 	/*
-	 * Convert tx_power array in eeprom.
-	 */
-	txpower = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_START);
-	for (i = 0; i < 14; i++)
-		txpower[i] = TXPOWER_FROM_DEV(txpower[i]);
-
-	/*
 	 * Initialize hw_mode information.
 	 */
 	spec->supported_bands = SUPPORT_BAND_2GHZ;
 	spec->supported_rates = SUPPORT_RATE_CCK;
-	spec->tx_power_a = NULL;
-	spec->tx_power_bg = txpower;
-	spec->tx_power_default = DEFAULT_TXPOWER;
 
-	spec->num_channels = ARRAY_SIZE(rf_vals_bg);
-	spec->channels = rf_vals_bg;
+	spec->num_channels = ARRAY_SIZE(rf_vals_b);
+	spec->channels = rf_vals_b;
+
+	/*
+	 * Create channel information array
+	 */
+	info = kzalloc(spec->num_channels * sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	spec->channels_info = info;
+
+	tx_power = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_START);
+	for (i = 0; i < 14; i++)
+		info[i].tx_power1 = TXPOWER_FROM_DEV(tx_power[i]);
+
+	return 0;
 }
 
 static int rt2400pci_probe_hw(struct rt2x00_dev *rt2x00dev)
@@ -1477,7 +1483,9 @@ static int rt2400pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize hw specifications.
 	 */
-	rt2400pci_probe_hw_mode(rt2x00dev);
+	retval = rt2400pci_probe_hw_mode(rt2x00dev);
+	if (retval)
+		return retval;
 
 	/*
 	 * This device requires the atim queue and DMA-mapped skbs.
diff --git a/drivers/net/wireless/rt2x00/rt2400pci.h b/drivers/net/wireless/rt2x00/rt2400pci.h
index bc55642..bbff381 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.h
+++ b/drivers/net/wireless/rt2x00/rt2400pci.h
@@ -938,19 +938,13 @@
 #define MAX_TXPOWER	62
 #define DEFAULT_TXPOWER	39
 
-#define TXPOWER_FROM_DEV(__txpower)					\
-({									\
-	((__txpower) > MAX_TXPOWER) ? DEFAULT_TXPOWER - MIN_TXPOWER :	\
-	((__txpower) < MIN_TXPOWER) ? DEFAULT_TXPOWER - MIN_TXPOWER :	\
-	(((__txpower) - MAX_TXPOWER) + MIN_TXPOWER);			\
-})
-
-#define TXPOWER_TO_DEV(__txpower)			\
-({							\
-	(__txpower) += MIN_TXPOWER;			\
-	((__txpower) <= MIN_TXPOWER) ? MAX_TXPOWER :	\
-	(((__txpower) >= MAX_TXPOWER) ? MIN_TXPOWER :	\
-	(MAX_TXPOWER - ((__txpower) - MIN_TXPOWER)));	\
-})
+#define __CLAMP_TX(__txpower) \
+	clamp_t(char, (__txpower), MIN_TXPOWER, MAX_TXPOWER)
+
+#define TXPOWER_FROM_DEV(__txpower) \
+	((__CLAMP_TX(__txpower) - MAX_TXPOWER) + MIN_TXPOWER)
+
+#define TXPOWER_TO_DEV(__txpower) \
+	MAX_TXPOWER - (__CLAMP_TX(__txpower) - MIN_TXPOWER)
 
 #endif /* RT2400PCI_H */
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 181a146..e0ff76f 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1721,10 +1721,11 @@ static const struct rf_channel rf_vals_5222[] = {
 	{ 161, 0x00022020, 0x000090be, 0x00000101, 0x00000a07 },
 };
 
-static void rt2500pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
+static int rt2500pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 {
 	struct hw_mode_spec *spec = &rt2x00dev->spec;
-	u8 *txpower;
+	struct channel_info *info;
+	char *tx_power;
 	unsigned int i;
 
 	/*
@@ -1741,20 +1742,10 @@ static void rt2500pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 						   EEPROM_MAC_ADDR_0));
 
 	/*
-	 * Convert tx_power array in eeprom.
-	 */
-	txpower = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_START);
-	for (i = 0; i < 14; i++)
-		txpower[i] = TXPOWER_FROM_DEV(txpower[i]);
-
-	/*
 	 * Initialize hw_mode information.
 	 */
 	spec->supported_bands = SUPPORT_BAND_2GHZ;
 	spec->supported_rates = SUPPORT_RATE_CCK | SUPPORT_RATE_OFDM;
-	spec->tx_power_a = NULL;
-	spec->tx_power_bg = txpower;
-	spec->tx_power_default = DEFAULT_TXPOWER;
 
 	if (rt2x00_rf(&rt2x00dev->chip, RF2522)) {
 		spec->num_channels = ARRAY_SIZE(rf_vals_bg_2522);
@@ -1776,6 +1767,26 @@ static void rt2500pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 		spec->num_channels = ARRAY_SIZE(rf_vals_5222);
 		spec->channels = rf_vals_5222;
 	}
+
+	/*
+	 * Create channel information array
+	 */
+	info = kzalloc(spec->num_channels * sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	spec->channels_info = info;
+
+	tx_power = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_START);
+	for (i = 0; i < 14; i++)
+		info[i].tx_power1 = TXPOWER_FROM_DEV(tx_power[i]);
+
+	if (spec->num_channels > 14) {
+		for (i = 14; i < spec->num_channels; i++)
+			info[i].tx_power1 = DEFAULT_TXPOWER;
+	}
+
+	return 0;
 }
 
 static int rt2500pci_probe_hw(struct rt2x00_dev *rt2x00dev)
@@ -1796,7 +1807,9 @@ static int rt2500pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize hw specifications.
 	 */
-	rt2500pci_probe_hw_mode(rt2x00dev);
+	retval = rt2500pci_probe_hw_mode(rt2x00dev);
+	if (retval)
+		return retval;
 
 	/*
 	 * This device requires the atim queue and DMA-mapped skbs.
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.h b/drivers/net/wireless/rt2x00/rt2500pci.h
index 42f3769..8c26bef 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.h
+++ b/drivers/net/wireless/rt2x00/rt2500pci.h
@@ -1223,17 +1223,10 @@
 #define MAX_TXPOWER	31
 #define DEFAULT_TXPOWER	24
 
-#define TXPOWER_FROM_DEV(__txpower)		\
-({						\
-	((__txpower) > MAX_TXPOWER) ?		\
-		DEFAULT_TXPOWER : (__txpower);	\
-})
-
-#define TXPOWER_TO_DEV(__txpower)			\
-({							\
-	((__txpower) <= MIN_TXPOWER) ? MIN_TXPOWER :	\
-	(((__txpower) >= MAX_TXPOWER) ? MAX_TXPOWER :	\
-	(__txpower));					\
-})
+#define TXPOWER_FROM_DEV(__txpower) \
+	(((u8)(__txpower)) > MAX_TXPOWER) ? DEFAULT_TXPOWER : (__txpower)
+
+#define TXPOWER_TO_DEV(__txpower) \
+	clamp_t(char, __txpower, MIN_TXPOWER, MAX_TXPOWER)
 
 #endif /* RT2500PCI_H */
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index c6f6eb6..df78bd3 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1652,10 +1652,11 @@ static const struct rf_channel rf_vals_5222[] = {
 	{ 161, 0x00022020, 0x000090be, 0x00000101, 0x00000a07 },
 };
 
-static void rt2500usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
+static int rt2500usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 {
 	struct hw_mode_spec *spec = &rt2x00dev->spec;
-	u8 *txpower;
+	struct channel_info *info;
+	char *tx_power;
 	unsigned int i;
 
 	/*
@@ -1674,20 +1675,10 @@ static void rt2500usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 						   EEPROM_MAC_ADDR_0));
 
 	/*
-	 * Convert tx_power array in eeprom.
-	 */
-	txpower = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_START);
-	for (i = 0; i < 14; i++)
-		txpower[i] = TXPOWER_FROM_DEV(txpower[i]);
-
-	/*
 	 * Initialize hw_mode information.
 	 */
 	spec->supported_bands = SUPPORT_BAND_2GHZ;
 	spec->supported_rates = SUPPORT_RATE_CCK | SUPPORT_RATE_OFDM;
-	spec->tx_power_a = NULL;
-	spec->tx_power_bg = txpower;
-	spec->tx_power_default = DEFAULT_TXPOWER;
 
 	if (rt2x00_rf(&rt2x00dev->chip, RF2522)) {
 		spec->num_channels = ARRAY_SIZE(rf_vals_bg_2522);
@@ -1709,6 +1700,26 @@ static void rt2500usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 		spec->num_channels = ARRAY_SIZE(rf_vals_5222);
 		spec->channels = rf_vals_5222;
 	}
+
+	/*
+	 * Create channel information array
+	 */
+	info = kzalloc(spec->num_channels * sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	spec->channels_info = info;
+
+	tx_power = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_START);
+	for (i = 0; i < 14; i++)
+		info[i].tx_power1 = TXPOWER_FROM_DEV(tx_power[i]);
+
+	if (spec->num_channels > 14) {
+		for (i = 14; i < spec->num_channels; i++)
+			info[i].tx_power1 = DEFAULT_TXPOWER;
+	}
+
+	return 0;
 }
 
 static int rt2500usb_probe_hw(struct rt2x00_dev *rt2x00dev)
@@ -1729,7 +1740,9 @@ static int rt2500usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize hw specifications.
 	 */
-	rt2500usb_probe_hw_mode(rt2x00dev);
+	retval = rt2500usb_probe_hw_mode(rt2x00dev);
+	if (retval)
+		return retval;
 
 	/*
 	 * This device requires the atim queue
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.h b/drivers/net/wireless/rt2x00/rt2500usb.h
index 4769ffe..89e5ed2 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.h
+++ b/drivers/net/wireless/rt2x00/rt2500usb.h
@@ -825,17 +825,10 @@
 #define MAX_TXPOWER	31
 #define DEFAULT_TXPOWER	24
 
-#define TXPOWER_FROM_DEV(__txpower)		\
-({						\
-	((__txpower) > MAX_TXPOWER) ?		\
-		DEFAULT_TXPOWER : (__txpower);	\
-})
-
-#define TXPOWER_TO_DEV(__txpower)			\
-({							\
-	((__txpower) <= MIN_TXPOWER) ? MIN_TXPOWER :	\
-	(((__txpower) >= MAX_TXPOWER) ? MAX_TXPOWER :	\
-	(__txpower));					\
-})
+#define TXPOWER_FROM_DEV(__txpower) \
+	(((u8)(__txpower)) > MAX_TXPOWER) ? DEFAULT_TXPOWER : (__txpower)
+
+#define TXPOWER_TO_DEV(__txpower) \
+	clamp_t(char, __txpower, MIN_TXPOWER, MAX_TXPOWER)
 
 #endif /* RT2500USB_H */
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index ae5c090..61f853f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -144,6 +144,17 @@ struct rf_channel {
 };
 
 /*
+ * Channel information structure
+ */
+struct channel_info {
+	unsigned int flags;
+#define GEOGRAPHY_ALLOWED	0x00000001
+
+	short tx_power1;
+	short tx_power2;
+};
+
+/*
  * Antenna setup values.
  */
 struct antenna_setup {
@@ -394,10 +405,7 @@ static inline struct rt2x00_intf* vif_to_intf(struct ieee80211_vif *vif)
  * @num_channels: Number of supported channels. This is used as array size
  *	for @tx_power_a, @tx_power_bg and @channels.
  * @channels: Device/chipset specific channel values (See &struct rf_channel).
- * @tx_power_a: TX power values for all 5.2GHz channels (may be NULL).
- * @tx_power_bg: TX power values for all 2.4GHz channels (may be NULL).
- * @tx_power_default: Default TX power value to use when either
- *	@tx_power_a or @tx_power_bg is missing.
+ * @channels_info: Additional information for channels (See &struct channel_info).
  */
 struct hw_mode_spec {
 	unsigned int supported_bands;
@@ -410,10 +418,7 @@ struct hw_mode_spec {
 
 	unsigned int num_channels;
 	const struct rf_channel *channels;
-
-	const u8 *tx_power_a;
-	const u8 *tx_power_bg;
-	u8 tx_power_default;
+	const struct channel_info *channels_info;
 };
 
 /*
@@ -425,7 +430,9 @@ struct hw_mode_spec {
  */
 struct rt2x00lib_conf {
 	struct ieee80211_conf *conf;
+
 	struct rf_channel rf;
+	struct channel_info channel;
 
 	struct antenna_setup ant;
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index d134c3b..ea37c79 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -245,6 +245,10 @@ config:
 		memcpy(&libconf.rf,
 		       &rt2x00dev->spec.channels[conf->channel->hw_value],
 		       sizeof(libconf.rf));
+
+		memcpy(&libconf.channel,
+		       &rt2x00dev->spec.channels_info[conf->channel->hw_value],
+		       sizeof(libconf.channel));
 	}
 
 	if (flags & CONFIG_UPDATE_ANTENNA) {
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 1829522..328ff8b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -818,7 +818,6 @@ static int rt2x00lib_probe_hw_modes(struct rt2x00_dev *rt2x00dev,
 	struct ieee80211_rate *rates;
 	unsigned int num_rates;
 	unsigned int i;
-	unsigned char tx_power;
 
 	num_rates = 0;
 	if (spec->supported_rates & SUPPORT_RATE_CCK)
@@ -844,20 +843,9 @@ static int rt2x00lib_probe_hw_modes(struct rt2x00_dev *rt2x00dev,
 	 * Initialize Channel list.
 	 */
 	for (i = 0; i < spec->num_channels; i++) {
-		if (spec->channels[i].channel <= 14) {
-			if (spec->tx_power_bg)
-				tx_power = spec->tx_power_bg[i];
-			else
-				tx_power = spec->tx_power_default;
-		} else {
-			if (spec->tx_power_a)
-				tx_power = spec->tx_power_a[i];
-			else
-				tx_power = spec->tx_power_default;
-		}
-
 		rt2x00lib_channel(&channels[i],
-				  spec->channels[i].channel, tx_power, i);
+				  spec->channels[i].channel,
+				  spec->channels_info[i].tx_power1, i);
 	}
 
 	/*
@@ -909,6 +897,8 @@ static void rt2x00lib_remove_hw(struct rt2x00_dev *rt2x00dev)
 		rt2x00dev->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = NULL;
 		rt2x00dev->hw->wiphy->bands[IEEE80211_BAND_5GHZ] = NULL;
 	}
+
+	kfree(rt2x00dev->spec.channels_info);
 }
 
 static int rt2x00lib_probe_hw(struct rt2x00_dev *rt2x00dev)
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 86e7a50..87012f8 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2514,10 +2514,11 @@ static const struct rf_channel rf_vals_seq[] = {
 	{ 46, 0x00002ccc, 0x000049a6, 0x0009be55, 0x000c0a23 },
 };
 
-static void rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
+static int rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 {
 	struct hw_mode_spec *spec = &rt2x00dev->spec;
-	u8 *txpower;
+	struct channel_info *info;
+	char *tx_power;
 	unsigned int i;
 
 	/*
@@ -2534,20 +2535,10 @@ static void rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 						   EEPROM_MAC_ADDR_0));
 
 	/*
-	 * Convert tx_power array in eeprom.
-	 */
-	txpower = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_G_START);
-	for (i = 0; i < 14; i++)
-		txpower[i] = TXPOWER_FROM_DEV(txpower[i]);
-
-	/*
 	 * Initialize hw_mode information.
 	 */
 	spec->supported_bands = SUPPORT_BAND_2GHZ;
 	spec->supported_rates = SUPPORT_RATE_CCK | SUPPORT_RATE_OFDM;
-	spec->tx_power_a = NULL;
-	spec->tx_power_bg = txpower;
-	spec->tx_power_default = DEFAULT_TXPOWER;
 
 	if (!test_bit(CONFIG_RF_SEQUENCE, &rt2x00dev->flags)) {
 		spec->num_channels = 14;
@@ -2561,13 +2552,28 @@ static void rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	    rt2x00_rf(&rt2x00dev->chip, RF5325)) {
 		spec->supported_bands |= SUPPORT_BAND_5GHZ;
 		spec->num_channels = ARRAY_SIZE(rf_vals_seq);
+	}
+
+	/*
+	 * Create channel information array
+	 */
+	info = kzalloc(spec->num_channels * sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	spec->channels_info = info;
 
-		txpower = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A_START);
-		for (i = 0; i < 14; i++)
-			txpower[i] = TXPOWER_FROM_DEV(txpower[i]);
+	tx_power = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_G_START);
+	for (i = 0; i < 14; i++)
+		info[i].tx_power1 = TXPOWER_FROM_DEV(tx_power[i]);
 
-		spec->tx_power_a = txpower;
+	if (spec->num_channels > 14) {
+		tx_power = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A_START);
+		for (i = 14; i < spec->num_channels; i++)
+			info[i].tx_power1 = TXPOWER_FROM_DEV(tx_power[i]);
 	}
+
+	return 0;
 }
 
 static int rt61pci_probe_hw(struct rt2x00_dev *rt2x00dev)
@@ -2588,7 +2594,9 @@ static int rt61pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize hw specifications.
 	 */
-	rt61pci_probe_hw_mode(rt2x00dev);
+	retval = rt61pci_probe_hw_mode(rt2x00dev);
+	if (retval)
+		return retval;
 
 	/*
 	 * This device requires firmware and DMA mapped skbs.
diff --git a/drivers/net/wireless/rt2x00/rt61pci.h b/drivers/net/wireless/rt2x00/rt61pci.h
index 6d591ce..8ec1451 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.h
+++ b/drivers/net/wireless/rt2x00/rt61pci.h
@@ -1482,17 +1482,10 @@ struct hw_pairwise_ta_entry {
 #define MAX_TXPOWER	31
 #define DEFAULT_TXPOWER	24
 
-#define TXPOWER_FROM_DEV(__txpower)		\
-({						\
-	((__txpower) > MAX_TXPOWER) ?		\
-		DEFAULT_TXPOWER : (__txpower);	\
-})
-
-#define TXPOWER_TO_DEV(__txpower)			\
-({							\
-	((__txpower) <= MIN_TXPOWER) ? MIN_TXPOWER :	\
-	(((__txpower) >= MAX_TXPOWER) ? MAX_TXPOWER :	\
-	(__txpower));					\
-})
+#define TXPOWER_FROM_DEV(__txpower) \
+	(((u8)(__txpower)) > MAX_TXPOWER) ? DEFAULT_TXPOWER : (__txpower)
+
+#define TXPOWER_TO_DEV(__txpower) \
+	clamp_t(char, __txpower, MIN_TXPOWER, MAX_TXPOWER)
 
 #endif /* RT61PCI_H */
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index ddba747..1bd6b3f 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2107,10 +2107,11 @@ static const struct rf_channel rf_vals_5225_2527[] = {
 };
 
 
-static void rt73usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
+static int rt73usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 {
 	struct hw_mode_spec *spec = &rt2x00dev->spec;
-	u8 *txpower;
+	struct channel_info *info;
+	char *tx_power;
 	unsigned int i;
 
 	/*
@@ -2127,20 +2128,10 @@ static void rt73usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 						   EEPROM_MAC_ADDR_0));
 
 	/*
-	 * Convert tx_power array in eeprom.
-	 */
-	txpower = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_G_START);
-	for (i = 0; i < 14; i++)
-		txpower[i] = TXPOWER_FROM_DEV(txpower[i]);
-
-	/*
 	 * Initialize hw_mode information.
 	 */
 	spec->supported_bands = SUPPORT_BAND_2GHZ;
 	spec->supported_rates = SUPPORT_RATE_CCK | SUPPORT_RATE_OFDM;
-	spec->tx_power_a = NULL;
-	spec->tx_power_bg = txpower;
-	spec->tx_power_default = DEFAULT_TXPOWER;
 
 	if (rt2x00_rf(&rt2x00dev->chip, RF2528)) {
 		spec->num_channels = ARRAY_SIZE(rf_vals_bg_2528);
@@ -2158,14 +2149,26 @@ static void rt73usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 		spec->channels = rf_vals_5225_2527;
 	}
 
-	if (rt2x00_rf(&rt2x00dev->chip, RF5225) ||
-	    rt2x00_rf(&rt2x00dev->chip, RF5226)) {
-		txpower = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A_START);
-		for (i = 0; i < 14; i++)
-			txpower[i] = TXPOWER_FROM_DEV(txpower[i]);
+	/*
+	 * Create channel information array
+	 */
+	info = kzalloc(spec->num_channels * sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
 
-		spec->tx_power_a = txpower;
+	spec->channels_info = info;
+
+	tx_power = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_G_START);
+	for (i = 0; i < 14; i++)
+		info[i].tx_power1 = TXPOWER_FROM_DEV(tx_power[i]);
+
+	if (spec->num_channels > 14) {
+		tx_power = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A_START);
+		for (i = 14; i < spec->num_channels; i++)
+			info[i].tx_power1 = TXPOWER_FROM_DEV(tx_power[i]);
 	}
+
+	return 0;
 }
 
 static int rt73usb_probe_hw(struct rt2x00_dev *rt2x00dev)
@@ -2186,7 +2189,9 @@ static int rt73usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize hw specifications.
 	 */
-	rt73usb_probe_hw_mode(rt2x00dev);
+	retval = rt73usb_probe_hw_mode(rt2x00dev);
+	if (retval)
+		return retval;
 
 	/*
 	 * This device requires firmware.
diff --git a/drivers/net/wireless/rt2x00/rt73usb.h b/drivers/net/wireless/rt2x00/rt73usb.h
index 91e04d3..868386c 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.h
+++ b/drivers/net/wireless/rt2x00/rt73usb.h
@@ -1050,17 +1050,10 @@ struct hw_pairwise_ta_entry {
 #define MAX_TXPOWER	31
 #define DEFAULT_TXPOWER	24
 
-#define TXPOWER_FROM_DEV(__txpower)		\
-({						\
-	((__txpower) > MAX_TXPOWER) ?		\
-		DEFAULT_TXPOWER : (__txpower);	\
-})
-
-#define TXPOWER_TO_DEV(__txpower)			\
-({							\
-	((__txpower) <= MIN_TXPOWER) ? MIN_TXPOWER :	\
-	(((__txpower) >= MAX_TXPOWER) ? MAX_TXPOWER :	\
-	(__txpower));					\
-})
+#define TXPOWER_FROM_DEV(__txpower) \
+	(((u8)(__txpower)) > MAX_TXPOWER) ? DEFAULT_TXPOWER : (__txpower)
+
+#define TXPOWER_TO_DEV(__txpower) \
+	clamp_t(char, __txpower, MIN_TXPOWER, MAX_TXPOWER)
 
 #endif /* RT73USB_H */
-- 
1.5.6.1

