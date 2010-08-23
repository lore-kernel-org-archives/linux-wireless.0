Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60044 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab0HWR5c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 13:57:32 -0400
Received: by wwe15 with SMTP id 15so429688wwe.1
        for <linux-wireless@vger.kernel.org>; Mon, 23 Aug 2010 10:57:31 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 8/8] rt2x00: Fix max TX power settings
Date: Mon, 23 Aug 2010 19:56:07 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201008231953.40629.IvDoorn@gmail.com> <201008231955.23348.IvDoorn@gmail.com> <201008231955.44731.IvDoorn@gmail.com>
In-Reply-To: <201008231955.44731.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201008231956.08889.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During initialization each driver reads the default TX power
for each individual channel. However mac80211 only accepts the
maximum value (which is also handled as default value).

As a result, the TX power of the device was being limited to
the default value, which is often quite low compared to the
real maximum acceptable value.

This patch allows each driver to set the maximum value on a
per-channel basis which is forwarded to mac80211. The default
value will be preserved for now, in case we want to update
mac80211 to differentiate between the maximum and default txpower.

This fixes bug complaining about limited TX power values like:
https://bugzilla.kernel.org/show_bug.cgi?id=16358

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |    6 ++-
 drivers/net/wireless/rt2x00/rt2500pci.c |   12 ++++--
 drivers/net/wireless/rt2x00/rt2500usb.c |   12 ++++--
 drivers/net/wireless/rt2x00/rt2800.h    |    7 +++
 drivers/net/wireless/rt2x00/rt2800lib.c |   65 ++++++++++++++++++------------
 drivers/net/wireless/rt2x00/rt2x00.h    |    5 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c |    2 +-
 drivers/net/wireless/rt2x00/rt61pci.c   |   12 ++++--
 drivers/net/wireless/rt2x00/rt73usb.c   |   12 ++++--
 9 files changed, 86 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index a43416d..103c711 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1487,8 +1487,10 @@ static int rt2400pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	spec->channels_info = info;
 
 	tx_power = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_START);
-	for (i = 0; i < 14; i++)
-		info[i].tx_power1 = TXPOWER_FROM_DEV(tx_power[i]);
+	for (i = 0; i < 14; i++) {
+		info[i].max_power = TXPOWER_FROM_DEV(MAX_TXPOWER);
+		info[i].default_power1 = TXPOWER_FROM_DEV(tx_power[i]);
+	}
 
 	return 0;
 }
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 3e3aa5f..ab05071 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1801,12 +1801,16 @@ static int rt2500pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	spec->channels_info = info;
 
 	tx_power = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_START);
-	for (i = 0; i < 14; i++)
-		info[i].tx_power1 = TXPOWER_FROM_DEV(tx_power[i]);
+	for (i = 0; i < 14; i++) {
+		info[i].max_power = MAX_TXPOWER;
+		info[i].default_power1 = TXPOWER_FROM_DEV(tx_power[i]);
+	}
 
 	if (spec->num_channels > 14) {
-		for (i = 14; i < spec->num_channels; i++)
-			info[i].tx_power1 = DEFAULT_TXPOWER;
+		for (i = 14; i < spec->num_channels; i++) {
+			info[i].max_power = MAX_TXPOWER;
+			info[i].default_power1 = DEFAULT_TXPOWER;
+		}
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 7642e71..63b363c 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1706,12 +1706,16 @@ static int rt2500usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	spec->channels_info = info;
 
 	tx_power = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_START);
-	for (i = 0; i < 14; i++)
-		info[i].tx_power1 = TXPOWER_FROM_DEV(tx_power[i]);
+	for (i = 0; i < 14; i++) {
+		info[i].max_power = MAX_TXPOWER;
+		info[i].default_power1 = TXPOWER_FROM_DEV(tx_power[i]);
+	}
 
 	if (spec->num_channels > 14) {
-		for (i = 14; i < spec->num_channels; i++)
-			info[i].tx_power1 = DEFAULT_TXPOWER;
+		for (i = 14; i < spec->num_channels; i++) {
+			info[i].max_power = MAX_TXPOWER;
+			info[i].default_power1 = DEFAULT_TXPOWER;
+		}
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index cf1f16b..5c006a7 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -1859,6 +1859,13 @@ struct mac_iveiv_entry {
 #define EEPROM_RSSI_A2_LNA_A2		FIELD16(0xff00)
 
 /*
+ * EEPROM Maximum TX power values
+ */
+#define EEPROM_MAX_TX_POWER		0x0027
+#define EEPROM_MAX_TX_POWER_24GHZ	FIELD16(0x00ff)
+#define EEPROM_MAX_TX_POWER_5GHZ	FIELD16(0xff00)
+
+/*
  * EEPROM TXpower delta: 20MHZ AND 40 MHZ use different power.
  *	This is delta in 40MHZ.
  * VALUE: Tx Power dalta value (MAX=4)
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 8f11f3e..2fd326c 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1239,23 +1239,23 @@ static void rt2800_config_channel_rf2xxx(struct rt2x00_dev *rt2x00dev,
 		 * double meaning, and we should set a 7DBm boost flag.
 		 */
 		rt2x00_set_field32(&rf->rf3, RF3_TXPOWER_A_7DBM_BOOST,
-				   (info->tx_power1 >= 0));
+				   (info->default_power1 >= 0));
 
-		if (info->tx_power1 < 0)
-			info->tx_power1 += 7;
+		if (info->default_power1 < 0)
+			info->default_power1 += 7;
 
-		rt2x00_set_field32(&rf->rf3, RF3_TXPOWER_A, info->tx_power1);
+		rt2x00_set_field32(&rf->rf3, RF3_TXPOWER_A, info->default_power1);
 
 		rt2x00_set_field32(&rf->rf4, RF4_TXPOWER_A_7DBM_BOOST,
-				   (info->tx_power2 >= 0));
+				   (info->default_power2 >= 0));
 
-		if (info->tx_power2 < 0)
-			info->tx_power2 += 7;
+		if (info->default_power2 < 0)
+			info->default_power2 += 7;
 
-		rt2x00_set_field32(&rf->rf4, RF4_TXPOWER_A, info->tx_power2);
+		rt2x00_set_field32(&rf->rf4, RF4_TXPOWER_A, info->default_power2);
 	} else {
-		rt2x00_set_field32(&rf->rf3, RF3_TXPOWER_G, info->tx_power1);
-		rt2x00_set_field32(&rf->rf4, RF4_TXPOWER_G, info->tx_power2);
+		rt2x00_set_field32(&rf->rf3, RF3_TXPOWER_G, info->default_power1);
+		rt2x00_set_field32(&rf->rf4, RF4_TXPOWER_G, info->default_power2);
 	}
 
 	rt2x00_set_field32(&rf->rf4, RF4_HT40, conf_is_ht40(conf));
@@ -1295,11 +1295,11 @@ static void rt2800_config_channel_rf3xxx(struct rt2x00_dev *rt2x00dev,
 	rt2800_rfcsr_write(rt2x00dev, 6, rfcsr);
 
 	rt2800_rfcsr_read(rt2x00dev, 12, &rfcsr);
-	rt2x00_set_field8(&rfcsr, RFCSR12_TX_POWER, info->tx_power1);
+	rt2x00_set_field8(&rfcsr, RFCSR12_TX_POWER, info->default_power1);
 	rt2800_rfcsr_write(rt2x00dev, 12, rfcsr);
 
 	rt2800_rfcsr_read(rt2x00dev, 13, &rfcsr);
-	rt2x00_set_field8(&rfcsr, RFCSR13_TX_POWER, info->tx_power2);
+	rt2x00_set_field8(&rfcsr, RFCSR13_TX_POWER, info->default_power2);
 	rt2800_rfcsr_write(rt2x00dev, 13, rfcsr);
 
 	rt2800_rfcsr_read(rt2x00dev, 23, &rfcsr);
@@ -1324,11 +1324,11 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 	u8 bbp;
 
 	if (rf->channel <= 14) {
-		info->tx_power1 = TXPOWER_G_TO_DEV(info->tx_power1);
-		info->tx_power2 = TXPOWER_G_TO_DEV(info->tx_power2);
+		info->default_power1 = TXPOWER_G_TO_DEV(info->default_power1);
+		info->default_power2 = TXPOWER_G_TO_DEV(info->default_power2);
 	} else {
-		info->tx_power1 = TXPOWER_A_TO_DEV(info->tx_power1);
-		info->tx_power2 = TXPOWER_A_TO_DEV(info->tx_power2);
+		info->default_power1 = TXPOWER_A_TO_DEV(info->default_power1);
+		info->default_power2 = TXPOWER_A_TO_DEV(info->default_power2);
 	}
 
 	if (rt2x00_rf(rt2x00dev, RF2020) ||
@@ -2729,6 +2729,13 @@ int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 				   default_lna_gain);
 	rt2x00_eeprom_write(rt2x00dev, EEPROM_RSSI_A2, word);
 
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_MAX_TX_POWER, &word);
+	if (rt2x00_get_field16(word, EEPROM_MAX_TX_POWER_24GHZ) == 0xff)
+		rt2x00_set_field16(&word, EEPROM_MAX_TX_POWER_24GHZ, MAX_G_TXPOWER);
+	if (rt2x00_get_field16(word, EEPROM_MAX_TX_POWER_5GHZ) == 0xff)
+		rt2x00_set_field16(&word, EEPROM_MAX_TX_POWER_5GHZ, MAX_A_TXPOWER);
+	rt2x00_eeprom_write(rt2x00dev, EEPROM_MAX_TX_POWER, word);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(rt2800_validate_eeprom);
@@ -2968,9 +2975,10 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 {
 	struct hw_mode_spec *spec = &rt2x00dev->spec;
 	struct channel_info *info;
-	char *tx_power1;
-	char *tx_power2;
+	char *default_power1;
+	char *default_power2;
 	unsigned int i;
+	unsigned short max_power;
 	u16 eeprom;
 
 	/*
@@ -3084,21 +3092,26 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 
 	spec->channels_info = info;
 
-	tx_power1 = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_BG1);
-	tx_power2 = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_BG2);
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_MAX_TX_POWER, &eeprom);
+	max_power = rt2x00_get_field16(eeprom, EEPROM_MAX_TX_POWER_24GHZ);
+	default_power1 = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_BG1);
+	default_power2 = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_BG2);
 
 	for (i = 0; i < 14; i++) {
-		info[i].tx_power1 = TXPOWER_G_FROM_DEV(tx_power1[i]);
-		info[i].tx_power2 = TXPOWER_G_FROM_DEV(tx_power2[i]);
+		info[i].max_power = max_power;
+		info[i].default_power1 = TXPOWER_G_FROM_DEV(default_power1[i]);
+		info[i].default_power2 = TXPOWER_G_FROM_DEV(default_power2[i]);
 	}
 
 	if (spec->num_channels > 14) {
-		tx_power1 = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A1);
-		tx_power2 = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A2);
+		max_power = rt2x00_get_field16(eeprom, EEPROM_MAX_TX_POWER_5GHZ);
+		default_power1 = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A1);
+		default_power2 = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A2);
 
 		for (i = 14; i < spec->num_channels; i++) {
-			info[i].tx_power1 = TXPOWER_A_FROM_DEV(tx_power1[i]);
-			info[i].tx_power2 = TXPOWER_A_FROM_DEV(tx_power2[i]);
+			info[i].max_power = max_power;
+			info[i].default_power1 = TXPOWER_A_FROM_DEV(default_power1[i]);
+			info[i].default_power2 = TXPOWER_A_FROM_DEV(default_power2[i]);
 		}
 	}
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 69308a0..762f6b4 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -213,8 +213,9 @@ struct channel_info {
 	unsigned int flags;
 #define GEOGRAPHY_ALLOWED	0x00000001
 
-	short tx_power1;
-	short tx_power2;
+	short max_power;
+	short default_power1;
+	short default_power2;
 };
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index e692608..580595b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -711,7 +711,7 @@ static int rt2x00lib_probe_hw_modes(struct rt2x00_dev *rt2x00dev,
 	for (i = 0; i < spec->num_channels; i++) {
 		rt2x00lib_channel(&channels[i],
 				  spec->channels[i].channel,
-				  spec->channels_info[i].tx_power1, i);
+				  spec->channels_info[i].max_power, i);
 	}
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index a756d5b..8b67cfd 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2656,13 +2656,17 @@ static int rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	spec->channels_info = info;
 
 	tx_power = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_G_START);
-	for (i = 0; i < 14; i++)
-		info[i].tx_power1 = TXPOWER_FROM_DEV(tx_power[i]);
+	for (i = 0; i < 14; i++) {
+		info[i].max_power = MAX_TXPOWER;
+		info[i].default_power1 = TXPOWER_FROM_DEV(tx_power[i]);
+	}
 
 	if (spec->num_channels > 14) {
 		tx_power = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A_START);
-		for (i = 14; i < spec->num_channels; i++)
-			info[i].tx_power1 = TXPOWER_FROM_DEV(tx_power[i]);
+		for (i = 14; i < spec->num_channels; i++) {
+			info[i].max_power = MAX_TXPOWER;
+			info[i].default_power1 = TXPOWER_FROM_DEV(tx_power[i]);
+		}
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index d46bfd4..b04e618 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2090,13 +2090,17 @@ static int rt73usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	spec->channels_info = info;
 
 	tx_power = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_G_START);
-	for (i = 0; i < 14; i++)
-		info[i].tx_power1 = TXPOWER_FROM_DEV(tx_power[i]);
+	for (i = 0; i < 14; i++) {
+		info[i].max_power = MAX_TXPOWER;
+		info[i].default_power1 = TXPOWER_FROM_DEV(tx_power[i]);
+	}
 
 	if (spec->num_channels > 14) {
 		tx_power = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A_START);
-		for (i = 14; i < spec->num_channels; i++)
-			info[i].tx_power1 = TXPOWER_FROM_DEV(tx_power[i]);
+		for (i = 14; i < spec->num_channels; i++) {
+			info[i].max_power = MAX_TXPOWER;
+			info[i].default_power1 = TXPOWER_FROM_DEV(tx_power[i]);
+		}
 	}
 
 	return 0;
-- 
1.7.2.1

