Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:45576 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932596AbZHUUwm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 16:52:42 -0400
From: Christian Lamparter <chunkeey@web.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [RFT] ar9170: use eeprom's frequency calibration values
Date: Fri, 21 Aug 2009 22:52:40 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200908212252.41053.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds some more bits from the vendor driver, which
are supposed to help users with the one-stage/openfw firmwares.

Unfortunately, my device (WNDA3100) still doesn't work properly
with either version at phy-rates beyond the magic 18MBit barrier.
---
Johannes, in phy.c (now at line) line 429

int ar9170_init_phy(struct ar9170 *ar, enum ieee80211_band band)
{
[...]
        /* XXX: use EEPROM data here! */

        err = ar9170_init_power_cal(ar);
        if (err)
[...]
}

do you still know what EEPROM data is missing here? 
---
diff --git a/drivers/net/wireless/ath/ar9170/eeprom.h b/drivers/net/wireless/ath/ar9170/eeprom.h
index d2c8cc8..b6af8b4 100644
--- a/drivers/net/wireless/ath/ar9170/eeprom.h
+++ b/drivers/net/wireless/ath/ar9170/eeprom.h
@@ -150,7 +150,8 @@ struct ar9170_eeprom {
 	u8	cal_freq_pier_2G[AR5416_NUM_2G_CAL_PIERS];
 
 	struct ar9170_calibration_data_per_freq
-		cal_pier_data_5G[AR5416_MAX_CHAINS][AR5416_NUM_5G_CAL_PIERS],
+		cal_pier_data_5G[AR5416_MAX_CHAINS][AR5416_NUM_5G_CAL_PIERS];
+	struct ar9170_calibration_data_per_freq
 		cal_pier_data_2G[AR5416_MAX_CHAINS][AR5416_NUM_2G_CAL_PIERS];
 
 	/* power calibration data */
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index 658b323..ecdf1b9 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -1387,6 +1387,7 @@ static int ar9170_tx_prepare(struct ar9170 *ar, struct sk_buff *skb)
 
 	txc->mac_control = cpu_to_le16(AR9170_TX_MAC_HW_DURATION |
 				       AR9170_TX_MAC_BACKOFF);
+
 	txc->mac_control |= cpu_to_le16(ar9170_qos_hwmap[queue] <<
 					AR9170_TX_MAC_QOS_SHIFT);
 	txc->mac_control |= cpu_to_le16(keytype);
diff --git a/drivers/net/wireless/ath/ar9170/phy.c b/drivers/net/wireless/ath/ar9170/phy.c
index df86f70..cb8b5cd 100644
--- a/drivers/net/wireless/ath/ar9170/phy.c
+++ b/drivers/net/wireless/ath/ar9170/phy.c
@@ -987,6 +987,107 @@ static u8 ar9170_interpolate_u8(u8 x, u8 x1, u8 y1, u8 x2, u8 y2)
 #undef SHIFT
 }
 
+static u8 ar9170_interpolate_val(u8 x, u8 *x_array, u8 *y_array)
+{
+	int i;
+
+	for (i = 0; i < 3; i++)
+		if (x <= x_array[i + 1])
+			break;
+
+	return ar9170_interpolate_u8(x,
+				     x_array[i],
+				     y_array[i],
+				     x_array[i + 1],
+				     y_array[i + 1]);
+}
+
+static int ar9170_set_freq_cal_data(struct ar9170 *ar, u32 freq)
+{
+	u8 *cal_freq_pier;
+	u8 vpds[2][AR5416_PD_GAIN_ICEPTS];
+	u8 pwrs[2][AR5416_PD_GAIN_ICEPTS];
+	int chain, idx, i, j, n;
+	u32 phy_data;
+	u8 f;
+
+	if (freq < 3000) {
+		f = freq - 2300;
+		cal_freq_pier = ar->eeprom.cal_freq_pier_2G;
+		n = AR5416_NUM_2G_CAL_PIERS;
+	} else {
+		f = (freq - 4800) / 5;
+		cal_freq_pier = ar->eeprom.cal_freq_pier_5G;
+		n = AR5416_NUM_5G_CAL_PIERS;
+	}
+
+
+	for (i = 0; i < n; i++) {
+		if (cal_freq_pier[i] == 0xff)
+			break;
+	}
+
+	idx = ar9170_find_freq_idx(i, cal_freq_pier, f);
+
+	ar9170_regwrite_begin(ar);
+
+	for (chain = 0; chain < AR5416_MAX_CHAINS; chain++) {
+		for (i = 0; i < AR5416_PD_GAIN_ICEPTS; i++) {
+			struct ar9170_calibration_data_per_freq *cal_pier_data;
+
+			if (freq < 3000)
+				cal_pier_data = &ar->eeprom.
+					cal_pier_data_2G[chain][idx];
+			else
+				cal_pier_data = &ar->eeprom.
+					cal_pier_data_5G[chain][idx];
+
+			for (j = 0; j < 2; j++) {
+				vpds[j][i] = ar9170_interpolate_u8(f,
+					cal_freq_pier[idx],
+					cal_pier_data->vpd_pdg[j][i],
+					cal_freq_pier[idx + 1],
+					cal_pier_data[1].vpd_pdg[j][i]);
+
+				pwrs[j][i] = ar9170_interpolate_u8(f,
+					cal_freq_pier[idx],
+					cal_pier_data->pwr_pdg[j][i],
+					cal_freq_pier[idx + 1],
+					cal_pier_data[1].pwr_pdg[j][i]) / 2;
+			}
+		}
+
+		for (i = 0; i < 76; i++) {
+			u8 tmp;
+
+			if (i < 25) {
+				tmp = ar9170_interpolate_val(i,
+							     &pwrs[0][0],
+							     &vpds[0][0]);
+			} else {
+				tmp = ar9170_interpolate_val(i - 12,
+							     &pwrs[1][0],
+							     &vpds[1][0]);
+			}
+
+			phy_data |= tmp << (8 * (i & 3));
+			if ((i & 3) == 3) {
+				ar9170_regwrite(0x1c6280 + chain * 0x1000 +
+						(i & ~3), phy_data);
+
+				phy_data = 0;
+			}
+		}
+
+		for (i = 19; i < 32; i++)
+			ar9170_regwrite(0x1c6280 + chain * 0x1000 + (i << 2),
+					0x0);
+	}
+
+	ar9170_regwrite_finish();
+	return ar9170_regwrite_result();
+}
+
 static int ar9170_set_power_cal(struct ar9170 *ar, u32 freq, enum ar9170_bw bw)
 {
 	struct ar9170_calibration_target_power_legacy *ctpl;
@@ -1000,7 +1101,7 @@ static int ar9170_set_power_cal(struct ar9170 *ar, u32 freq, enum ar9170_bw bw)
 	if (freq < 3000)
 		f = freq - 2300;
 	else
-		f = (freq - 4800)/5;
+		f = (freq - 4800) / 5;
 
 	/*
 	 * cycle through the various modes
@@ -1045,7 +1146,7 @@ static int ar9170_set_power_cal(struct ar9170 *ar, u32 freq, enum ar9170_bw bw)
 	}
 
 	/*
-	 * HT modes now: 5G HT20, 5G HT40, 2G CCK, 2G OFDM, 2G HT20, 2G HT40
+	 * HT modes now: 5G HT20, 5G HT40, 2G HT20, 2G HT40
 	 */
 	for (i = 0; i < 4; i++) {
 		switch (i) {
@@ -1207,6 +1308,10 @@ int ar9170_set_channel(struct ar9170 *ar, struct ieee80211_channel *channel,
 	if (err)
 		return err;
 
+	err = ar9170_set_freq_cal_data(ar, channel->center_freq);
+	if (err)
+		return err;
+
 	err = ar9170_set_power_cal(ar, channel->center_freq, bw);
 	if (err)
 		return err;
