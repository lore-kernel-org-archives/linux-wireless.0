Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:53692 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350AbZICSZc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Sep 2009 14:25:32 -0400
Received: by fxm17 with SMTP id 17so149854fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2009 11:25:33 -0700 (PDT)
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH] ar9170: implement frequency calibration for one-stage/openfw
Cc: John Linville <linville@tuxdriver.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Thu, 3 Sep 2009 20:25:31 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200909032025.31260.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch ports some code from the vendor driver, which is
supposed to upload the right calibration values for the
chosen frequency.

In theory, this should give a better range and throughput
for all users with the open, or one-stage firmware.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/drivers/net/wireless/ath/ar9170/phy.c b/drivers/net/wireless/ath/ar9170/phy.c
index df86f70..be96f50 100644
--- a/drivers/net/wireless/ath/ar9170/phy.c
+++ b/drivers/net/wireless/ath/ar9170/phy.c
@@ -987,6 +987,124 @@ static u8 ar9170_interpolate_u8(u8 x, u8 x1, u8 y1, u8 x2, u8 y2)
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
+static int ar9170_set_freq_cal_data(struct ar9170 *ar,
+				    struct ieee80211_channel *channel)
+{
+	u8 *cal_freq_pier;
+	u8 vpds[2][AR5416_PD_GAIN_ICEPTS];
+	u8 pwrs[2][AR5416_PD_GAIN_ICEPTS];
+	int chain, idx, i;
+	u8 f;
+
+	switch (channel->band) {
+	case IEEE80211_BAND_2GHZ:
+		f = channel->center_freq - 2300;
+		cal_freq_pier = ar->eeprom.cal_freq_pier_2G;
+		i = AR5416_NUM_2G_CAL_PIERS - 1;
+		break;
+
+	case IEEE80211_BAND_5GHZ:
+		f = (channel->center_freq - 4800) / 5;
+		cal_freq_pier = ar->eeprom.cal_freq_pier_5G;
+		i = AR5416_NUM_5G_CAL_PIERS - 1;
+		break;
+
+	default:
+		return -EINVAL;
+		break;
+	}
+
+	for (; i >= 0; i--) {
+		if (cal_freq_pier[i] != 0xff)
+			break;
+	}
+	if (i < 0)
+		return -EINVAL;
+
+	idx = ar9170_find_freq_idx(i, cal_freq_pier, f);
+
+	ar9170_regwrite_begin(ar);
+
+	for (chain = 0; chain < AR5416_MAX_CHAINS; chain++) {
+		for (i = 0; i < AR5416_PD_GAIN_ICEPTS; i++) {
+			struct ar9170_calibration_data_per_freq *cal_pier_data;
+			int j;
+
+			switch (channel->band) {
+			case IEEE80211_BAND_2GHZ:
+				cal_pier_data = &ar->eeprom.
+					cal_pier_data_2G[chain][idx];
+				break;
+
+			case IEEE80211_BAND_5GHZ:
+				cal_pier_data = &ar->eeprom.
+					cal_pier_data_5G[chain][idx];
+				break;
+
+			default:
+				return -EINVAL;
+			}
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
+			u32 phy_data;
+			u8 tmp;
+
+			if (i < 25) {
+				tmp = ar9170_interpolate_val(i, &pwrs[0][0],
+							     &vpds[0][0]);
+			} else {
+				tmp = ar9170_interpolate_val(i - 12,
+							     &pwrs[1][0],
+							     &vpds[1][0]);
+			}
+
+			phy_data |= tmp << ((i & 3) << 3);
+			if ((i & 3) == 3) {
+				ar9170_regwrite(0x1c6280 + chain * 0x1000 +
+						(i & ~3), phy_data);
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
@@ -1207,6 +1325,10 @@ int ar9170_set_channel(struct ar9170 *ar, struct ieee80211_channel *channel,
 	if (err)
 		return err;
 
+	err = ar9170_set_freq_cal_data(ar, channel);
+	if (err)
+		return err;
+
 	err = ar9170_set_power_cal(ar, channel->center_freq, bw);
 	if (err)
 		return err;
