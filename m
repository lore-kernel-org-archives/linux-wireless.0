Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:37107 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080Ab3CPSUR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Mar 2013 14:20:17 -0400
From: stf_xl@wp.pl
To: "John W. Linville\"" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 24/25] rt2800: 5592: iq calibration for 5GHz
Date: Sat, 16 Mar 2013 19:19:52 +0100
Message-Id: <1363457993-15541-25-git-send-email-stf_xl@wp.pl> (sfid-20130316_192031_484313_46F4F019)
In-Reply-To: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
References: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Based on:
RT5592_IQCalibration()

DPO_RT5572_LinuxSTA_2.6.1.3_20121022/cips/rt5592.c

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   70 ++++++++++++++++++++++++++----
 1 files changed, 60 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 9b1f293..f08a042 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2468,31 +2468,80 @@ static void rt2800_bbp_write_with_rx_chain(struct rt2x00_dev *rt2x00dev,
 	}
 }
 
-
 static void rt2800_iq_calibrate(struct rt2x00_dev *rt2x00dev, int channel)
 {
 	u8 cal;
 
-	/* TODO */
-	if (WARN_ON_ONCE(channel > 14))
-		return;
-
+	/* TX0 IQ Gain */
 	rt2800_bbp_write(rt2x00dev, 158, 0x2c);
-	cal = rt2x00_eeprom_byte(rt2x00dev, EEPROM_IQ_GAIN_CAL_TX0_2G);
+	if (channel <= 14)
+		cal = rt2x00_eeprom_byte(rt2x00dev, EEPROM_IQ_GAIN_CAL_TX0_2G);
+	else if (channel >= 36 && channel <= 64)
+		cal = rt2x00_eeprom_byte(rt2x00dev,
+					 EEPROM_IQ_GAIN_CAL_TX0_CH36_TO_CH64_5G);
+	else if (channel >= 100 && channel <= 138)
+		cal = rt2x00_eeprom_byte(rt2x00dev,
+					 EEPROM_IQ_GAIN_CAL_TX0_CH100_TO_CH138_5G);
+	else if (channel >= 140 && channel <= 165)
+		cal = rt2x00_eeprom_byte(rt2x00dev,
+					 EEPROM_IQ_GAIN_CAL_TX0_CH140_TO_CH165_5G);
+	else
+		cal = 0;
 	rt2800_bbp_write(rt2x00dev, 159, cal);
 
+	/* TX0 IQ Phase */
 	rt2800_bbp_write(rt2x00dev, 158, 0x2d);
-	cal = rt2x00_eeprom_byte(rt2x00dev, EEPROM_IQ_PHASE_CAL_TX0_2G);
+	if (channel <= 14)
+		cal = rt2x00_eeprom_byte(rt2x00dev, EEPROM_IQ_PHASE_CAL_TX0_2G);
+	else if (channel >= 36 && channel <= 64)
+		cal = rt2x00_eeprom_byte(rt2x00dev,
+					 EEPROM_IQ_PHASE_CAL_TX0_CH36_TO_CH64_5G);
+	else if (channel >= 100 && channel <= 138)
+		cal = rt2x00_eeprom_byte(rt2x00dev,
+					 EEPROM_IQ_PHASE_CAL_TX0_CH100_TO_CH138_5G);
+	else if (channel >= 140 && channel <= 165)
+		cal = rt2x00_eeprom_byte(rt2x00dev,
+					 EEPROM_IQ_PHASE_CAL_TX0_CH140_TO_CH165_5G);
+	else
+		cal = 0;
 	rt2800_bbp_write(rt2x00dev, 159, cal);
 
+	/* TX1 IQ Gain */
 	rt2800_bbp_write(rt2x00dev, 158, 0x4a);
-	cal = rt2x00_eeprom_byte(rt2x00dev, EEPROM_IQ_GAIN_CAL_TX1_2G);
+	if (channel <= 14)
+		cal = rt2x00_eeprom_byte(rt2x00dev, EEPROM_IQ_GAIN_CAL_TX1_2G);
+	else if (channel >= 36 && channel <= 64)
+		cal = rt2x00_eeprom_byte(rt2x00dev,
+					 EEPROM_IQ_GAIN_CAL_TX1_CH36_TO_CH64_5G);
+	else if (channel >= 100 && channel <= 138)
+		cal = rt2x00_eeprom_byte(rt2x00dev,
+					 EEPROM_IQ_GAIN_CAL_TX1_CH100_TO_CH138_5G);
+	else if (channel >= 140 && channel <= 165)
+		cal = rt2x00_eeprom_byte(rt2x00dev,
+					 EEPROM_IQ_GAIN_CAL_TX1_CH140_TO_CH165_5G);
+	else
+		cal = 0;
 	rt2800_bbp_write(rt2x00dev, 159, cal);
 
+	/* TX1 IQ Phase */
 	rt2800_bbp_write(rt2x00dev, 158, 0x4b);
-	cal = rt2x00_eeprom_byte(rt2x00dev, EEPROM_IQ_PHASE_CAL_TX1_2G);
+	if (channel <= 14)
+		cal = rt2x00_eeprom_byte(rt2x00dev, EEPROM_IQ_PHASE_CAL_TX1_2G);
+	else if (channel >= 36 && channel <= 64)
+		cal = rt2x00_eeprom_byte(rt2x00dev,
+					 EEPROM_IQ_PHASE_CAL_TX1_CH36_TO_CH64_5G);
+	else if (channel >= 100 && channel <= 138)
+		cal = rt2x00_eeprom_byte(rt2x00dev,
+					 EEPROM_IQ_PHASE_CAL_TX1_CH100_TO_CH138_5G);
+	else if (channel >= 140 && channel <= 165)
+		cal = rt2x00_eeprom_byte(rt2x00dev,
+					 EEPROM_IQ_PHASE_CAL_TX1_CH140_TO_CH165_5G);
+	else
+		cal = 0;
 	rt2800_bbp_write(rt2x00dev, 159, cal);
 
+	/* FIXME: possible RX0, RX1 callibration ? */
+
 	/* RF IQ compensation control */
 	rt2800_bbp_write(rt2x00dev, 158, 0x04);
 	cal = rt2x00_eeprom_byte(rt2x00dev, EEPROM_RF_IQ_COMPENSATION_CONTROL);
@@ -2500,7 +2549,8 @@ static void rt2800_iq_calibrate(struct rt2x00_dev *rt2x00dev, int channel)
 
 	/* RF IQ imbalance compensation control */
 	rt2800_bbp_write(rt2x00dev, 158, 0x03);
-	cal = rt2x00_eeprom_byte(rt2x00dev, EEPROM_RF_IQ_IMBALANCE_COMPENSATION_CONTROL);
+	cal = rt2x00_eeprom_byte(rt2x00dev,
+				 EEPROM_RF_IQ_IMBALANCE_COMPENSATION_CONTROL);
 	rt2800_bbp_write(rt2x00dev, 159, cal != 0xff ? cal : 0);
 }
 
-- 
1.7.4.4

