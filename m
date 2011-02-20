Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54597 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780Ab1BTM6O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Feb 2011 07:58:14 -0500
Received: by eye27 with SMTP id 27so2477431eye.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Feb 2011 04:58:04 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/8] rt2x00: Fix rt2800 txpower setting to correct value
Date: Sun, 20 Feb 2011 13:55:25 +0100
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
References: <201102201354.53379.IvDoorn@gmail.com>
In-Reply-To: <201102201354.53379.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201102201355.26260.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: RA-Jay Hung <Jay_Hung@ralinktech.com>

TX_PWR_CFG_* setting need to consider below cases
-compesate 20M/40M tx power delta for 2.4/5GHZ band
-limit maximum EIRP tx power to power_level of
 regulatory requirement

Signed-off-by: RA-Jay Hung <jay_hung@ralinktech.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800.h    |   39 ++++--
 drivers/net/wireless/rt2x00/rt2800lib.c |  236 ++++++++++++++++++++++--------
 drivers/net/wireless/rt2x00/rt2x00.h    |    1 +
 3 files changed, 199 insertions(+), 77 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index ef8f605..457887c 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -1703,11 +1703,14 @@ struct mac_iveiv_entry {
  */
 
 /*
- * BBP 1: TX Antenna & Power
- * POWER: 0 - normal, 1 - drop tx power by 6dBm, 2 - drop tx power by 12dBm,
- *	3 - increase tx power by 6dBm
- */
-#define BBP1_TX_POWER			FIELD8(0x07)
+ * BBP 1: TX Antenna & Power Control
+ * POWER_CTRL:
+ * 0 - normal,
+ * 1 - drop tx power by 6dBm,
+ * 2 - drop tx power by 12dBm,
+ * 3 - increase tx power by 6dBm
+ */
+#define BBP1_TX_POWER_CTRL		FIELD8(0x07)
 #define BBP1_TX_ANTENNA			FIELD8(0x18)
 
 /*
@@ -2001,23 +2004,26 @@ struct mac_iveiv_entry {
 #define EEPROM_RSSI_A2_LNA_A2		FIELD16(0xff00)
 
 /*
- * EEPROM Maximum TX power values
+ * EEPROM EIRP Maximum TX power values(unit: dbm)
  */
-#define EEPROM_MAX_TX_POWER		0x0027
-#define EEPROM_MAX_TX_POWER_24GHZ	FIELD16(0x00ff)
-#define EEPROM_MAX_TX_POWER_5GHZ	FIELD16(0xff00)
+#define EEPROM_EIRP_MAX_TX_POWER	0x0027
+#define EEPROM_EIRP_MAX_TX_POWER_2GHZ	FIELD16(0x00ff)
+#define EEPROM_EIRP_MAX_TX_POWER_5GHZ	FIELD16(0xff00)
 
 /*
  * EEPROM TXpower delta: 20MHZ AND 40 MHZ use different power.
  * This is delta in 40MHZ.
- * VALUE: Tx Power dalta value (MAX=4)
+ * VALUE: Tx Power dalta value, MAX=4(unit: dbm)
  * TYPE: 1: Plus the delta value, 0: minus the delta value
- * TXPOWER: Enable:
+ * ENABLE: enable tx power compensation for 40BW
  */
 #define EEPROM_TXPOWER_DELTA		0x0028
-#define EEPROM_TXPOWER_DELTA_VALUE	FIELD16(0x003f)
-#define EEPROM_TXPOWER_DELTA_TYPE	FIELD16(0x0040)
-#define EEPROM_TXPOWER_DELTA_TXPOWER	FIELD16(0x0080)
+#define EEPROM_TXPOWER_DELTA_VALUE_2G	FIELD16(0x003f)
+#define EEPROM_TXPOWER_DELTA_TYPE_2G	FIELD16(0x0040)
+#define EEPROM_TXPOWER_DELTA_ENABLE_2G	FIELD16(0x0080)
+#define EEPROM_TXPOWER_DELTA_VALUE_5G	FIELD16(0x3f00)
+#define EEPROM_TXPOWER_DELTA_TYPE_5G	FIELD16(0x4000)
+#define EEPROM_TXPOWER_DELTA_ENABLE_5G	FIELD16(0x8000)
 
 /*
  * EEPROM TXPOWER 802.11BG
@@ -2215,4 +2221,9 @@ struct mac_iveiv_entry {
 #define TXPOWER_A_TO_DEV(__txpower) \
 	clamp_t(char, __txpower, MIN_A_TXPOWER, MAX_A_TXPOWER)
 
+/*
+ *  Board's maximun TX power limitation
+ */
+#define EIRP_MAX_TX_POWER_LIMIT	0x50
+
 #endif /* RT2800_H */
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 7f44b97..d23a5d8 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1676,30 +1676,116 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 	rt2800_register_read(rt2x00dev, CH_BUSY_STA_SEC, &reg);
 }
 
+static int rt2800_get_txpower_bw_comp(struct rt2x00_dev *rt2x00dev,
+				      enum ieee80211_band band)
+{
+	u16 eeprom;
+	u8 comp_en;
+	u8 comp_type;
+	int comp_value;
+
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_TXPOWER_DELTA, &eeprom);
+
+	if (eeprom == 0xffff)
+		return 0;
+
+	if (band == IEEE80211_BAND_2GHZ) {
+		comp_en = rt2x00_get_field16(eeprom,
+				 EEPROM_TXPOWER_DELTA_ENABLE_2G);
+		if (comp_en) {
+			comp_type = rt2x00_get_field16(eeprom,
+					   EEPROM_TXPOWER_DELTA_TYPE_2G);
+			comp_value = rt2x00_get_field16(eeprom,
+					    EEPROM_TXPOWER_DELTA_VALUE_2G);
+			if (!comp_type)
+				comp_value = -comp_value;
+		}
+	} else {
+		comp_en = rt2x00_get_field16(eeprom,
+				 EEPROM_TXPOWER_DELTA_ENABLE_5G);
+		if (comp_en) {
+			comp_type = rt2x00_get_field16(eeprom,
+					   EEPROM_TXPOWER_DELTA_TYPE_5G);
+			comp_value = rt2x00_get_field16(eeprom,
+					    EEPROM_TXPOWER_DELTA_VALUE_5G);
+			if (!comp_type)
+				comp_value = -comp_value;
+		}
+	}
+
+	return comp_value;
+}
+
+static u8 rt2800_compesate_txpower(struct rt2x00_dev *rt2x00dev,
+				     int is_rate_b,
+				     enum ieee80211_band band,
+				     int power_level,
+				     u8 txpower)
+{
+	u32 reg;
+	u16 eeprom;
+	u8 criterion;
+	u8 eirp_txpower;
+	u8 eirp_txpower_criterion;
+	u8 reg_limit;
+	int bw_comp = 0;
+
+	if (!((band == IEEE80211_BAND_5GHZ) && is_rate_b))
+		return txpower;
+
+	if (test_bit(CONFIG_CHANNEL_HT40, &rt2x00dev->flags))
+		bw_comp = rt2800_get_txpower_bw_comp(rt2x00dev, band);
+
+	if (test_bit(CONFIG_SUPPORT_POWER_LIMIT, &rt2x00dev->flags)) {
+		/*
+		 * Check if eirp txpower exceed txpower_limit.
+		 * We use OFDM 6M as criterion and its eirp txpower
+		 * is stored at EEPROM_EIRP_MAX_TX_POWER.
+		 * .11b data rate need add additional 4dbm
+		 * when calculating eirp txpower.
+		 */
+		rt2800_register_read(rt2x00dev, TX_PWR_CFG_0, &reg);
+		criterion = rt2x00_get_field32(reg, TX_PWR_CFG_0_6MBS);
+
+		rt2x00_eeprom_read(rt2x00dev,
+				   EEPROM_EIRP_MAX_TX_POWER, &eeprom);
+
+		if (band == IEEE80211_BAND_2GHZ)
+			eirp_txpower_criterion = rt2x00_get_field16(eeprom,
+						 EEPROM_EIRP_MAX_TX_POWER_2GHZ);
+		else
+			eirp_txpower_criterion = rt2x00_get_field16(eeprom,
+						 EEPROM_EIRP_MAX_TX_POWER_5GHZ);
+
+		eirp_txpower = eirp_txpower_criterion + (txpower - criterion) +
+				       (is_rate_b ? 4 : 0) + bw_comp;
+
+		reg_limit = (eirp_txpower > power_level) ?
+					(eirp_txpower - power_level) : 0;
+	} else
+		reg_limit = 0;
+
+	return txpower + bw_comp - reg_limit;
+}
+
 static void rt2800_config_txpower(struct rt2x00_dev *rt2x00dev,
-				  const int max_txpower)
+				  struct ieee80211_conf *conf)
 {
 	u8 txpower;
-	u8 max_value = (u8)max_txpower;
 	u16 eeprom;
-	int i;
+	int i, is_rate_b;
 	u32 reg;
 	u8 r1;
 	u32 offset;
+	enum ieee80211_band band = conf->channel->band;
+	int power_level = conf->power_level;
 
 	/*
-	 * set to normal tx power mode: +/- 0dBm
+	 * set to normal bbp tx power control mode: +/- 0dBm
 	 */
 	rt2800_bbp_read(rt2x00dev, 1, &r1);
-	rt2x00_set_field8(&r1, BBP1_TX_POWER, 0);
+	rt2x00_set_field8(&r1, BBP1_TX_POWER_CTRL, 0);
 	rt2800_bbp_write(rt2x00dev, 1, r1);
-
-	/*
-	 * The eeprom contains the tx power values for each rate. These
-	 * values map to 100% tx power. Each 16bit word contains four tx
-	 * power values and the order is the same as used in the TX_PWR_CFG
-	 * registers.
-	 */
 	offset = TX_PWR_CFG_0;
 
 	for (i = 0; i < EEPROM_TXPOWER_BYRATE_SIZE; i += 2) {
@@ -1713,73 +1799,99 @@ static void rt2800_config_txpower(struct rt2x00_dev *rt2x00dev,
 		rt2x00_eeprom_read(rt2x00dev, EEPROM_TXPOWER_BYRATE + i,
 				   &eeprom);
 
-		/* TX_PWR_CFG_0: 1MBS, TX_PWR_CFG_1: 24MBS,
+		is_rate_b = i ? 0 : 1;
+		/*
+		 * TX_PWR_CFG_0: 1MBS, TX_PWR_CFG_1: 24MBS,
 		 * TX_PWR_CFG_2: MCS4, TX_PWR_CFG_3: MCS12,
-		 * TX_PWR_CFG_4: unknown */
+		 * TX_PWR_CFG_4: unknown
+		 */
 		txpower = rt2x00_get_field16(eeprom,
 					     EEPROM_TXPOWER_BYRATE_RATE0);
-		rt2x00_set_field32(&reg, TX_PWR_CFG_RATE0,
-				   min(txpower, max_value));
+		txpower = rt2800_compesate_txpower(rt2x00dev, is_rate_b, band,
+					     power_level, txpower);
+		rt2x00_set_field32(&reg, TX_PWR_CFG_RATE0, txpower);
 
-		/* TX_PWR_CFG_0: 2MBS, TX_PWR_CFG_1: 36MBS,
+		/*
+		 * TX_PWR_CFG_0: 2MBS, TX_PWR_CFG_1: 36MBS,
 		 * TX_PWR_CFG_2: MCS5, TX_PWR_CFG_3: MCS13,
-		 * TX_PWR_CFG_4: unknown */
+		 * TX_PWR_CFG_4: unknown
+		 */
 		txpower = rt2x00_get_field16(eeprom,
 					     EEPROM_TXPOWER_BYRATE_RATE1);
-		rt2x00_set_field32(&reg, TX_PWR_CFG_RATE1,
-				   min(txpower, max_value));
+		txpower = rt2800_compesate_txpower(rt2x00dev, is_rate_b, band,
+					     power_level, txpower);
+		rt2x00_set_field32(&reg, TX_PWR_CFG_RATE1, txpower);
 
-		/* TX_PWR_CFG_0: 55MBS, TX_PWR_CFG_1: 48MBS,
+		/*
+		 * TX_PWR_CFG_0: 5.5MBS, TX_PWR_CFG_1: 48MBS,
 		 * TX_PWR_CFG_2: MCS6,  TX_PWR_CFG_3: MCS14,
-		 * TX_PWR_CFG_4: unknown */
+		 * TX_PWR_CFG_4: unknown
+		 */
 		txpower = rt2x00_get_field16(eeprom,
 					     EEPROM_TXPOWER_BYRATE_RATE2);
-		rt2x00_set_field32(&reg, TX_PWR_CFG_RATE2,
-				   min(txpower, max_value));
+		txpower = rt2800_compesate_txpower(rt2x00dev, is_rate_b, band,
+					     power_level, txpower);
+		rt2x00_set_field32(&reg, TX_PWR_CFG_RATE2, txpower);
 
-		/* TX_PWR_CFG_0: 11MBS, TX_PWR_CFG_1: 54MBS,
+		/*
+		 * TX_PWR_CFG_0: 11MBS, TX_PWR_CFG_1: 54MBS,
 		 * TX_PWR_CFG_2: MCS7,  TX_PWR_CFG_3: MCS15,
-		 * TX_PWR_CFG_4: unknown */
+		 * TX_PWR_CFG_4: unknown
+		 */
 		txpower = rt2x00_get_field16(eeprom,
 					     EEPROM_TXPOWER_BYRATE_RATE3);
-		rt2x00_set_field32(&reg, TX_PWR_CFG_RATE3,
-				   min(txpower, max_value));
+		txpower = rt2800_compesate_txpower(rt2x00dev, is_rate_b, band,
+					     power_level, txpower);
+		rt2x00_set_field32(&reg, TX_PWR_CFG_RATE3, txpower);
 
 		/* read the next four txpower values */
 		rt2x00_eeprom_read(rt2x00dev, EEPROM_TXPOWER_BYRATE + i + 1,
 				   &eeprom);
 
-		/* TX_PWR_CFG_0: 6MBS, TX_PWR_CFG_1: MCS0,
+		is_rate_b = 0;
+		/*
+		 * TX_PWR_CFG_0: 6MBS, TX_PWR_CFG_1: MCS0,
 		 * TX_PWR_CFG_2: MCS8, TX_PWR_CFG_3: unknown,
-		 * TX_PWR_CFG_4: unknown */
+		 * TX_PWR_CFG_4: unknown
+		 */
 		txpower = rt2x00_get_field16(eeprom,
 					     EEPROM_TXPOWER_BYRATE_RATE0);
-		rt2x00_set_field32(&reg, TX_PWR_CFG_RATE4,
-				   min(txpower, max_value));
+		txpower = rt2800_compesate_txpower(rt2x00dev, is_rate_b, band,
+					     power_level, txpower);
+		rt2x00_set_field32(&reg, TX_PWR_CFG_RATE4, txpower);
 
-		/* TX_PWR_CFG_0: 9MBS, TX_PWR_CFG_1: MCS1,
+		/*
+		 * TX_PWR_CFG_0: 9MBS, TX_PWR_CFG_1: MCS1,
 		 * TX_PWR_CFG_2: MCS9, TX_PWR_CFG_3: unknown,
-		 * TX_PWR_CFG_4: unknown */
+		 * TX_PWR_CFG_4: unknown
+		 */
 		txpower = rt2x00_get_field16(eeprom,
 					     EEPROM_TXPOWER_BYRATE_RATE1);
-		rt2x00_set_field32(&reg, TX_PWR_CFG_RATE5,
-				   min(txpower, max_value));
+		txpower = rt2800_compesate_txpower(rt2x00dev, is_rate_b, band,
+					     power_level, txpower);
+		rt2x00_set_field32(&reg, TX_PWR_CFG_RATE5, txpower);
 
-		/* TX_PWR_CFG_0: 12MBS, TX_PWR_CFG_1: MCS2,
+		/*
+		 * TX_PWR_CFG_0: 12MBS, TX_PWR_CFG_1: MCS2,
 		 * TX_PWR_CFG_2: MCS10, TX_PWR_CFG_3: unknown,
-		 * TX_PWR_CFG_4: unknown */
+		 * TX_PWR_CFG_4: unknown
+		 */
 		txpower = rt2x00_get_field16(eeprom,
 					     EEPROM_TXPOWER_BYRATE_RATE2);
-		rt2x00_set_field32(&reg, TX_PWR_CFG_RATE6,
-				   min(txpower, max_value));
+		txpower = rt2800_compesate_txpower(rt2x00dev, is_rate_b, band,
+					     power_level, txpower);
+		rt2x00_set_field32(&reg, TX_PWR_CFG_RATE6, txpower);
 
-		/* TX_PWR_CFG_0: 18MBS, TX_PWR_CFG_1: MCS3,
+		/*
+		 * TX_PWR_CFG_0: 18MBS, TX_PWR_CFG_1: MCS3,
 		 * TX_PWR_CFG_2: MCS11, TX_PWR_CFG_3: unknown,
-		 * TX_PWR_CFG_4: unknown */
+		 * TX_PWR_CFG_4: unknown
+		 */
 		txpower = rt2x00_get_field16(eeprom,
 					     EEPROM_TXPOWER_BYRATE_RATE3);
-		rt2x00_set_field32(&reg, TX_PWR_CFG_RATE7,
-				   min(txpower, max_value));
+		txpower = rt2800_compesate_txpower(rt2x00dev, is_rate_b, band,
+					     power_level, txpower);
+		rt2x00_set_field32(&reg, TX_PWR_CFG_RATE7, txpower);
 
 		rt2800_register_write(rt2x00dev, offset, reg);
 
@@ -1838,11 +1950,13 @@ void rt2800_config(struct rt2x00_dev *rt2x00dev,
 	/* Always recalculate LNA gain before changing configuration */
 	rt2800_config_lna_gain(rt2x00dev, libconf);
 
-	if (flags & IEEE80211_CONF_CHANGE_CHANNEL)
+	if (flags & IEEE80211_CONF_CHANGE_CHANNEL) {
 		rt2800_config_channel(rt2x00dev, libconf->conf,
 				      &libconf->rf, &libconf->channel);
+		rt2800_config_txpower(rt2x00dev, libconf->conf);
+	}
 	if (flags & IEEE80211_CONF_CHANGE_POWER)
-		rt2800_config_txpower(rt2x00dev, libconf->conf->power_level);
+		rt2800_config_txpower(rt2x00dev, libconf->conf);
 	if (flags & IEEE80211_CONF_CHANGE_RETRY_LIMITS)
 		rt2800_config_retry_limit(rt2x00dev, libconf);
 	if (flags & IEEE80211_CONF_CHANGE_PS)
@@ -3032,13 +3146,6 @@ int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 				   default_lna_gain);
 	rt2x00_eeprom_write(rt2x00dev, EEPROM_RSSI_A2, word);
 
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_MAX_TX_POWER, &word);
-	if (rt2x00_get_field16(word, EEPROM_MAX_TX_POWER_24GHZ) == 0xff)
-		rt2x00_set_field16(&word, EEPROM_MAX_TX_POWER_24GHZ, MAX_G_TXPOWER);
-	if (rt2x00_get_field16(word, EEPROM_MAX_TX_POWER_5GHZ) == 0xff)
-		rt2x00_set_field16(&word, EEPROM_MAX_TX_POWER_5GHZ, MAX_A_TXPOWER);
-	rt2x00_eeprom_write(rt2x00dev, EEPROM_MAX_TX_POWER, word);
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(rt2800_validate_eeprom);
@@ -3154,6 +3261,15 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_FREQ, &rt2x00dev->led_mcu_reg);
 #endif /* CONFIG_RT2X00_LIB_LEDS */
 
+	/*
+	 * Check if support EIRP tx power limit feature.
+	 */
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_EIRP_MAX_TX_POWER, &eeprom);
+
+	if (rt2x00_get_field16(eeprom, EEPROM_EIRP_MAX_TX_POWER_2GHZ) <
+					EIRP_MAX_TX_POWER_LIMIT)
+		__set_bit(CONFIG_SUPPORT_POWER_LIMIT, &rt2x00dev->flags);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(rt2800_init_eeprom);
@@ -3306,7 +3422,6 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	char *default_power1;
 	char *default_power2;
 	unsigned int i;
-	unsigned short max_power;
 	u16 eeprom;
 
 	/*
@@ -3431,26 +3546,21 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 
 	spec->channels_info = info;
 
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_MAX_TX_POWER, &eeprom);
-	max_power = rt2x00_get_field16(eeprom, EEPROM_MAX_TX_POWER_24GHZ);
 	default_power1 = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_BG1);
 	default_power2 = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_BG2);
 
 	for (i = 0; i < 14; i++) {
-		info[i].max_power = max_power;
-		info[i].default_power1 = TXPOWER_G_FROM_DEV(default_power1[i]);
-		info[i].default_power2 = TXPOWER_G_FROM_DEV(default_power2[i]);
+		info[i].default_power1 = default_power1[i];
+		info[i].default_power2 = default_power2[i];
 	}
 
 	if (spec->num_channels > 14) {
-		max_power = rt2x00_get_field16(eeprom, EEPROM_MAX_TX_POWER_5GHZ);
 		default_power1 = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A1);
 		default_power2 = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A2);
 
 		for (i = 14; i < spec->num_channels; i++) {
-			info[i].max_power = max_power;
-			info[i].default_power1 = TXPOWER_A_FROM_DEV(default_power1[i]);
-			info[i].default_power2 = TXPOWER_A_FROM_DEV(default_power2[i]);
+			info[i].default_power1 = default_power1[i];
+			info[i].default_power2 = default_power2[i];
 		}
 	}
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index fd28836..64c6ef5 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -667,6 +667,7 @@ enum rt2x00_flags {
 	 */
 	CONFIG_SUPPORT_HW_BUTTON,
 	CONFIG_SUPPORT_HW_CRYPTO,
+	CONFIG_SUPPORT_POWER_LIMIT,
 	DRIVER_SUPPORT_CONTROL_FILTERS,
 	DRIVER_SUPPORT_CONTROL_FILTER_PSPOLL,
 	DRIVER_SUPPORT_PRE_TBTT_INTERRUPT,
-- 
1.7.2.3

