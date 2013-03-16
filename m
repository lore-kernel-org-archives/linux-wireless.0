Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:41880 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932506Ab3CPSUF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Mar 2013 14:20:05 -0400
From: stf_xl@wp.pl
To: "John W. Linville\"" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 17/25] rt2800: 5592: add iq calibration
Date: Sat, 16 Mar 2013 19:19:45 +0100
Message-Id: <1363457993-15541-18-git-send-email-stf_xl@wp.pl> (sfid-20130316_192010_978046_538B02ED)
In-Reply-To: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
References: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Based on:
GetIQCalibration()
IQCalibration()

from:
DPO_RT5572_LinuxSTA_2.6.1.3_20121022/chips/rtmp_chip.c

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2800.h    |   55 +++++++++++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2800lib.c |   41 ++++++++++++++++++++++-
 drivers/net/wireless/rt2x00/rt2x00.h    |    9 ++++-
 3 files changed, 101 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 9d18d53..25c94b5 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -2532,6 +2532,61 @@ struct mac_iveiv_entry {
 #define EEPROM_BBP_REG_ID		FIELD16(0xff00)
 
 /*
+ * EEPROM IQ Calibration, unlike other entries those are byte addresses.
+ */
+
+#define EEPROM_IQ_GAIN_CAL_TX0_2G			0x130
+#define EEPROM_IQ_PHASE_CAL_TX0_2G			0x131
+#define EEPROM_IQ_GROUPDELAY_CAL_TX0_2G			0x132
+#define EEPROM_IQ_GAIN_CAL_TX1_2G			0x133
+#define EEPROM_IQ_PHASE_CAL_TX1_2G			0x134
+#define EEPROM_IQ_GROUPDELAY_CAL_TX1_2G			0x135
+#define EEPROM_IQ_GAIN_CAL_RX0_2G			0x136
+#define EEPROM_IQ_PHASE_CAL_RX0_2G			0x137
+#define EEPROM_IQ_GROUPDELAY_CAL_RX0_2G			0x138
+#define EEPROM_IQ_GAIN_CAL_RX1_2G			0x139
+#define EEPROM_IQ_PHASE_CAL_RX1_2G			0x13A
+#define EEPROM_IQ_GROUPDELAY_CAL_RX1_2G			0x13B
+#define EEPROM_RF_IQ_COMPENSATION_CONTROL		0x13C
+#define EEPROM_RF_IQ_IMBALANCE_COMPENSATION_CONTROL	0x13D
+#define EEPROM_IQ_GAIN_CAL_TX0_CH36_TO_CH64_5G		0x144
+#define EEPROM_IQ_PHASE_CAL_TX0_CH36_TO_CH64_5G		0x145
+#define EEPROM_IQ_GAIN_CAL_TX0_CH100_TO_CH138_5G	0X146
+#define EEPROM_IQ_PHASE_CAL_TX0_CH100_TO_CH138_5G	0x147
+#define EEPROM_IQ_GAIN_CAL_TX0_CH140_TO_CH165_5G	0x148
+#define EEPROM_IQ_PHASE_CAL_TX0_CH140_TO_CH165_5G	0x149
+#define EEPROM_IQ_GAIN_CAL_TX1_CH36_TO_CH64_5G		0x14A
+#define EEPROM_IQ_PHASE_CAL_TX1_CH36_TO_CH64_5G		0x14B
+#define EEPROM_IQ_GAIN_CAL_TX1_CH100_TO_CH138_5G	0X14C
+#define EEPROM_IQ_PHASE_CAL_TX1_CH100_TO_CH138_5G	0x14D
+#define EEPROM_IQ_GAIN_CAL_TX1_CH140_TO_CH165_5G	0x14E
+#define EEPROM_IQ_PHASE_CAL_TX1_CH140_TO_CH165_5G	0x14F
+#define EEPROM_IQ_GROUPDELAY_CAL_TX0_CH36_TO_CH64_5G	0x150
+#define EEPROM_IQ_GROUPDELAY_CAL_TX1_CH36_TO_CH64_5G	0x151
+#define EEPROM_IQ_GROUPDELAY_CAL_TX0_CH100_TO_CH138_5G	0x152
+#define EEPROM_IQ_GROUPDELAY_CAL_TX1_CH100_TO_CH138_5G	0x153
+#define EEPROM_IQ_GROUPDELAY_CAL_TX0_CH140_TO_CH165_5G	0x154
+#define EEPROM_IQ_GROUPDELAY_CAL_TX1_CH140_TO_CH165_5G	0x155
+#define EEPROM_IQ_GAIN_CAL_RX0_CH36_TO_CH64_5G		0x156
+#define EEPROM_IQ_PHASE_CAL_RX0_CH36_TO_CH64_5G		0x157
+#define EEPROM_IQ_GAIN_CAL_RX0_CH100_TO_CH138_5G	0X158
+#define EEPROM_IQ_PHASE_CAL_RX0_CH100_TO_CH138_5G	0x159
+#define EEPROM_IQ_GAIN_CAL_RX0_CH140_TO_CH165_5G	0x15A
+#define EEPROM_IQ_PHASE_CAL_RX0_CH140_TO_CH165_5G	0x15B
+#define EEPROM_IQ_GAIN_CAL_RX1_CH36_TO_CH64_5G		0x15C
+#define EEPROM_IQ_PHASE_CAL_RX1_CH36_TO_CH64_5G		0x15D
+#define EEPROM_IQ_GAIN_CAL_RX1_CH100_TO_CH138_5G	0X15E
+#define EEPROM_IQ_PHASE_CAL_RX1_CH100_TO_CH138_5G	0x15F
+#define EEPROM_IQ_GAIN_CAL_RX1_CH140_TO_CH165_5G	0x160
+#define EEPROM_IQ_PHASE_CAL_RX1_CH140_TO_CH165_5G	0x161
+#define EEPROM_IQ_GROUPDELAY_CAL_RX0_CH36_TO_CH64_5G	0x162
+#define EEPROM_IQ_GROUPDELAY_CAL_RX1_CH36_TO_CH64_5G	0x163
+#define EEPROM_IQ_GROUPDELAY_CAL_RX0_CH100_TO_CH138_5G	0x164
+#define EEPROM_IQ_GROUPDELAY_CAL_RX1_CH100_TO_CH138_5G	0x165
+#define EEPROM_IQ_GROUPDELAY_CAL_RX0_CH140_TO_CH165_5G	0x166
+#define EEPROM_IQ_GROUPDELAY_CAL_RX1_CH140_TO_CH165_5G	0x167
+
+/*
  * MCU mailbox commands.
  * MCU_SLEEP - go to power-save mode.
  *             arg1: 1: save as much power as possible, 0: save less power.
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index c990ab8..e96ea32 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -527,8 +527,10 @@ int rt2800_load_firmware(struct rt2x00_dev *rt2x00dev,
 	 */
 	rt2800_register_write(rt2x00dev, H2M_BBP_AGENT, 0);
 	rt2800_register_write(rt2x00dev, H2M_MAILBOX_CSR, 0);
-	if (rt2x00_is_usb(rt2x00dev))
+	if (rt2x00_is_usb(rt2x00dev)) {
 		rt2800_register_write(rt2x00dev, H2M_INT_SRC, 0);
+		rt2800_mcu_request(rt2x00dev, MCU_BOOT_SIGNAL, 0, 0, 0);
+	}
 	msleep(1);
 
 	return 0;
@@ -2456,6 +2458,41 @@ static void rt2800_config_channel_rf55xx(struct rt2x00_dev *rt2x00dev,
 	rt2800_bbp_write(rt2x00dev, 196, (rf->channel <= 14) ? 0x19 : 0x7F);
 }
 
+static void rt2800_iq_calibrate(struct rt2x00_dev *rt2x00dev, int channel)
+{
+	u8 cal;
+
+	/* TODO */
+	if (WARN_ON_ONCE(channel > 14))
+		return;
+
+	rt2800_bbp_write(rt2x00dev, 158, 0x2c);
+	cal = rt2x00_eeprom_byte(rt2x00dev, EEPROM_IQ_GAIN_CAL_TX0_2G);
+	rt2800_bbp_write(rt2x00dev, 159, cal);
+
+	rt2800_bbp_write(rt2x00dev, 158, 0x2d);
+	cal = rt2x00_eeprom_byte(rt2x00dev, EEPROM_IQ_PHASE_CAL_TX0_2G);
+	rt2800_bbp_write(rt2x00dev, 159, cal);
+
+	rt2800_bbp_write(rt2x00dev, 158, 0x4a);
+	cal = rt2x00_eeprom_byte(rt2x00dev, EEPROM_IQ_GAIN_CAL_TX1_2G);
+	rt2800_bbp_write(rt2x00dev, 159, cal);
+
+	rt2800_bbp_write(rt2x00dev, 158, 0x4b);
+	cal = rt2x00_eeprom_byte(rt2x00dev, EEPROM_IQ_PHASE_CAL_TX1_2G);
+	rt2800_bbp_write(rt2x00dev, 159, cal);
+
+	/* RF IQ compensation control */
+	rt2800_bbp_write(rt2x00dev, 158, 0x04);
+	cal = rt2x00_eeprom_byte(rt2x00dev, EEPROM_RF_IQ_COMPENSATION_CONTROL);
+	rt2800_bbp_write(rt2x00dev, 159, cal != 0xff ? cal : 0);
+
+	/* RF IQ imbalance compensation control */
+	rt2800_bbp_write(rt2x00dev, 158, 0x03);
+	cal = rt2x00_eeprom_byte(rt2x00dev, EEPROM_RF_IQ_IMBALANCE_COMPENSATION_CONTROL);
+	rt2800_bbp_write(rt2x00dev, 159, cal != 0xff ? cal : 0);
+}
+
 static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 				  struct ieee80211_conf *conf,
 				  struct rf_channel *rf,
@@ -2606,7 +2643,7 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 		rt2800_bbp_write(rt2x00dev, 196, conf_is_ht40(conf) ? 0x10 : 0x1a);
 
 		/* TODO AGC adjust */
-		/* TODO IQ calibration */
+		rt2800_iq_calibrate(rt2x00dev, rf->channel);
 	}
 
 	rt2800_bbp_read(rt2x00dev, 4, &bbp);
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 4251835..51922cc 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -1065,8 +1065,7 @@ static inline void rt2x00_rf_write(struct rt2x00_dev *rt2x00dev,
 }
 
 /*
- *  Generic EEPROM access.
- * The EEPROM is being accessed by word index.
+ * Generic EEPROM access. The EEPROM is being accessed by word or byte index.
  */
 static inline void *rt2x00_eeprom_addr(struct rt2x00_dev *rt2x00dev,
 				       const unsigned int word)
@@ -1086,6 +1085,12 @@ static inline void rt2x00_eeprom_write(struct rt2x00_dev *rt2x00dev,
 	rt2x00dev->eeprom[word] = cpu_to_le16(data);
 }
 
+static inline u8 rt2x00_eeprom_byte(struct rt2x00_dev *rt2x00dev,
+				    const unsigned int byte)
+{
+	return *(((u8 *)rt2x00dev->eeprom) + byte);
+}
+
 /*
  * Chipset handlers
  */
-- 
1.7.4.4

