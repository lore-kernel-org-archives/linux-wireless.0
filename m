Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:41744 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756026Ab3CPSTi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Mar 2013 14:19:38 -0400
From: stf_xl@wp.pl
To: "John W. Linville\"" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 04/25] rt2800: 5592: channel config stub
Date: Sat, 16 Mar 2013 19:19:32 +0100
Message-Id: <1363457993-15541-5-git-send-email-stf_xl@wp.pl> (sfid-20130316_191941_428329_E502E198)
In-Reply-To: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
References: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Based on:
RT5592_ChipSwitchChannel()

from:
DPO_RT5572_LinuxSTA_2.6.1.3_20121022/chips/rt5592.c

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2800.h    |   11 ++
 drivers/net/wireless/rt2x00/rt2800lib.c |  255 +++++++++++++++++++++++++++++++
 2 files changed, 266 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index b72f71d..acb5e62 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -2030,9 +2030,18 @@ struct mac_iveiv_entry {
 #define RFCSR7_BITS67			FIELD8(0xc0)
 
 /*
+ * RFCSR 9:
+ */
+#define RFCSR9_K			FIELD8(0x0f)
+#define RFCSR9_N			FIELD8(0x10)
+#define RFCSR9_UNKNOWN			FIELD8(0x60)
+#define RFCSR9_MOD			FIELD8(0x80)
+
+/*
  * RFCSR 11:
  */
 #define RFCSR11_R			FIELD8(0x03)
+#define RFCSR11_MOD			FIELD8(0xc0)
 
 /*
  * RFCSR 12:
@@ -2138,11 +2147,13 @@ struct mac_iveiv_entry {
  * RFCSR 49:
  */
 #define RFCSR49_TX			FIELD8(0x3f)
+#define RFCSR49_EP			FIELD8(0xc0)
 
 /*
  * RFCSR 50:
  */
 #define RFCSR50_TX			FIELD8(0x3f)
+#define RFCSR50_EP			FIELD8(0xc0)
 
 /*
  * RF registers
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 45f0338..079086b 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1988,6 +1988,7 @@ static void rt2800_config_channel_rf3052(struct rt2x00_dev *rt2x00dev,
 }
 
 #define POWER_BOUND		0x27
+#define POWER_BOUND_5G		0x2b
 #define FREQ_OFFSET_BOUND	0x5f
 
 static void rt2800_config_channel_rf3290(struct rt2x00_dev *rt2x00dev,
@@ -2184,6 +2185,257 @@ static void rt2800_config_channel_rf53xx(struct rt2x00_dev *rt2x00dev,
 	}
 }
 
+static void rt2800_config_channel_rf55xx(struct rt2x00_dev *rt2x00dev,
+					 struct ieee80211_conf *conf,
+					 struct rf_channel *rf,
+					 struct channel_info *info)
+{
+	u8 rfcsr, ep_reg;
+	int power_bound;
+
+	/* TODO */
+	const bool is_11b = false;
+	const bool is_type_ep = false;
+
+
+	/* Order of values on rf_channel entry: N, K, mod, R */
+	rt2800_rfcsr_write(rt2x00dev, 8, rf->rf1 & 0xff);
+
+	rt2800_rfcsr_read(rt2x00dev,  9, &rfcsr);
+	rt2x00_set_field8(&rfcsr, RFCSR9_K, rf->rf2 & 0xf);
+	rt2x00_set_field8(&rfcsr, RFCSR9_N, (rf->rf1 & 0x100) >> 8);
+	rt2x00_set_field8(&rfcsr, RFCSR9_MOD, ((rf->rf3 - 8) & 0x4) >> 2);
+	rt2800_rfcsr_write(rt2x00dev, 9, rfcsr);
+
+	rt2800_rfcsr_read(rt2x00dev, 11, &rfcsr);
+	rt2x00_set_field8(&rfcsr, RFCSR11_R, rf->rf4 - 1);
+	rt2x00_set_field8(&rfcsr, RFCSR11_MOD, (rf->rf3 - 8) & 0x3);
+	rt2800_rfcsr_write(rt2x00dev, 11, rfcsr);
+
+	if (rf->channel <= 14) {
+		rt2800_rfcsr_write(rt2x00dev, 10, 0x90);
+		/* FIXME: RF11 owerwrite ? */
+		rt2800_rfcsr_write(rt2x00dev, 11, 0x4A);
+		rt2800_rfcsr_write(rt2x00dev, 12, 0x52);
+		rt2800_rfcsr_write(rt2x00dev, 13, 0x42);
+		rt2800_rfcsr_write(rt2x00dev, 22, 0x40);
+		rt2800_rfcsr_write(rt2x00dev, 24, 0x4A);
+		rt2800_rfcsr_write(rt2x00dev, 25, 0x80);
+		rt2800_rfcsr_write(rt2x00dev, 27, 0x42);
+		rt2800_rfcsr_write(rt2x00dev, 36, 0x80);
+		rt2800_rfcsr_write(rt2x00dev, 37, 0x08);
+		rt2800_rfcsr_write(rt2x00dev, 38, 0x89);
+		rt2800_rfcsr_write(rt2x00dev, 39, 0x1B);
+		rt2800_rfcsr_write(rt2x00dev, 40, 0x0D);
+		rt2800_rfcsr_write(rt2x00dev, 41, 0x9B);
+		rt2800_rfcsr_write(rt2x00dev, 42, 0xD5);
+		rt2800_rfcsr_write(rt2x00dev, 43, 0x72);
+		rt2800_rfcsr_write(rt2x00dev, 44, 0x0E);
+		rt2800_rfcsr_write(rt2x00dev, 45, 0xA2);
+		rt2800_rfcsr_write(rt2x00dev, 46, 0x6B);
+		rt2800_rfcsr_write(rt2x00dev, 48, 0x10);
+		rt2800_rfcsr_write(rt2x00dev, 51, 0x3E);
+		rt2800_rfcsr_write(rt2x00dev, 52, 0x48);
+		rt2800_rfcsr_write(rt2x00dev, 54, 0x38);
+		rt2800_rfcsr_write(rt2x00dev, 56, 0xA1);
+		rt2800_rfcsr_write(rt2x00dev, 57, 0x00);
+		rt2800_rfcsr_write(rt2x00dev, 58, 0x39);
+		rt2800_rfcsr_write(rt2x00dev, 60, 0x45);
+		rt2800_rfcsr_write(rt2x00dev, 61, 0x91);
+		rt2800_rfcsr_write(rt2x00dev, 62, 0x39);
+
+		/* TODO RF27 <- tssi */
+
+		rfcsr = rf->channel <= 10 ? 0x07 : 0x06;
+		rt2800_rfcsr_write(rt2x00dev, 23, rfcsr);
+		rt2800_rfcsr_write(rt2x00dev, 59, rfcsr);
+
+		if (is_11b) {
+			/* CCK */
+			rt2800_rfcsr_write(rt2x00dev, 31, 0xF8);
+			rt2800_rfcsr_write(rt2x00dev, 32, 0xC0);
+			if (is_type_ep)
+				rt2800_rfcsr_write(rt2x00dev, 55, 0x06);
+			else
+				rt2800_rfcsr_write(rt2x00dev, 55, 0x47);
+		} else {
+			/* OFDM */
+			if (is_type_ep)
+				rt2800_rfcsr_write(rt2x00dev, 55, 0x03);
+			else
+				rt2800_rfcsr_write(rt2x00dev, 55, 0x43);
+		}
+
+		power_bound = POWER_BOUND;
+		ep_reg = 0x2;
+	} else {
+		rt2800_rfcsr_write(rt2x00dev, 10, 0x97);
+		/* FIMXE: RF11 overwrite */
+		rt2800_rfcsr_write(rt2x00dev, 11, 0x40);
+		rt2800_rfcsr_write(rt2x00dev, 25, 0xBF);
+		rt2800_rfcsr_write(rt2x00dev, 27, 0x42);
+		rt2800_rfcsr_write(rt2x00dev, 36, 0x00);
+		rt2800_rfcsr_write(rt2x00dev, 37, 0x04);
+		rt2800_rfcsr_write(rt2x00dev, 38, 0x85);
+		rt2800_rfcsr_write(rt2x00dev, 40, 0x42);
+		rt2800_rfcsr_write(rt2x00dev, 41, 0xBB);
+		rt2800_rfcsr_write(rt2x00dev, 42, 0xD7);
+		rt2800_rfcsr_write(rt2x00dev, 45, 0x41);
+		rt2800_rfcsr_write(rt2x00dev, 48, 0x00);
+		rt2800_rfcsr_write(rt2x00dev, 57, 0x77);
+		rt2800_rfcsr_write(rt2x00dev, 60, 0x05);
+		rt2800_rfcsr_write(rt2x00dev, 61, 0x01);
+
+		/* TODO RF27 <- tssi */
+
+		if (rf->channel >= 36 && rf->channel <= 64) {
+
+			rt2800_rfcsr_write(rt2x00dev, 12, 0x2E);
+			rt2800_rfcsr_write(rt2x00dev, 13, 0x22);
+			rt2800_rfcsr_write(rt2x00dev, 22, 0x60);
+			rt2800_rfcsr_write(rt2x00dev, 23, 0x7F);
+			if (rf->channel <= 50)
+				rt2800_rfcsr_write(rt2x00dev, 24, 0x09);
+			else if (rf->channel >= 52)
+				rt2800_rfcsr_write(rt2x00dev, 24, 0x07);
+			rt2800_rfcsr_write(rt2x00dev, 39, 0x1C);
+			rt2800_rfcsr_write(rt2x00dev, 43, 0x5B);
+			rt2800_rfcsr_write(rt2x00dev, 44, 0X40);
+			rt2800_rfcsr_write(rt2x00dev, 46, 0X00);
+			rt2800_rfcsr_write(rt2x00dev, 51, 0xFE);
+			rt2800_rfcsr_write(rt2x00dev, 52, 0x0C);
+			rt2800_rfcsr_write(rt2x00dev, 54, 0xF8);
+			if (rf->channel <= 50) {
+				rt2800_rfcsr_write(rt2x00dev, 55, 0x06),
+				rt2800_rfcsr_write(rt2x00dev, 56, 0xD3);
+			} else if (rf->channel >= 52) {
+				rt2800_rfcsr_write(rt2x00dev, 55, 0x04);
+				rt2800_rfcsr_write(rt2x00dev, 56, 0xBB);
+			}
+
+			rt2800_rfcsr_write(rt2x00dev, 58, 0x15);
+			rt2800_rfcsr_write(rt2x00dev, 59, 0x7F);
+			rt2800_rfcsr_write(rt2x00dev, 62, 0x15);
+
+		} else if (rf->channel >= 100 && rf->channel <= 165) {
+
+			rt2800_rfcsr_write(rt2x00dev, 12, 0x0E);
+			rt2800_rfcsr_write(rt2x00dev, 13, 0x42);
+			rt2800_rfcsr_write(rt2x00dev, 22, 0x40);
+			if (rf->channel <= 153) {
+				rt2800_rfcsr_write(rt2x00dev, 23, 0x3C);
+				rt2800_rfcsr_write(rt2x00dev, 24, 0x06);
+			} else if (rf->channel >= 155) {
+				rt2800_rfcsr_write(rt2x00dev, 23, 0x38);
+				rt2800_rfcsr_write(rt2x00dev, 24, 0x05);
+			}
+			if (rf->channel <= 138) {
+				rt2800_rfcsr_write(rt2x00dev, 39, 0x1A);
+				rt2800_rfcsr_write(rt2x00dev, 43, 0x3B);
+				rt2800_rfcsr_write(rt2x00dev, 44, 0x20);
+				rt2800_rfcsr_write(rt2x00dev, 46, 0x18);
+			} else if (rf->channel >= 140) {
+				rt2800_rfcsr_write(rt2x00dev, 39, 0x18);
+				rt2800_rfcsr_write(rt2x00dev, 43, 0x1B);
+				rt2800_rfcsr_write(rt2x00dev, 44, 0x10);
+				rt2800_rfcsr_write(rt2x00dev, 46, 0X08);
+			}
+			if (rf->channel <= 124)
+				rt2800_rfcsr_write(rt2x00dev, 51, 0xFC);
+			else if (rf->channel >= 126)
+				rt2800_rfcsr_write(rt2x00dev, 51, 0xEC);
+			if (rf->channel <= 138)
+				rt2800_rfcsr_write(rt2x00dev, 52, 0x06);
+			else if (rf->channel >= 140)
+				rt2800_rfcsr_write(rt2x00dev, 52, 0x06);
+			rt2800_rfcsr_write(rt2x00dev, 54, 0xEB);
+			if (rf->channel <= 138)
+				rt2800_rfcsr_write(rt2x00dev, 55, 0x01);
+			else if (rf->channel >= 140)
+				rt2800_rfcsr_write(rt2x00dev, 55, 0x00);
+			if (rf->channel <= 128)
+				rt2800_rfcsr_write(rt2x00dev, 56, 0xBB);
+			else if (rf->channel >= 130)
+				rt2800_rfcsr_write(rt2x00dev, 56, 0xAB);
+			if (rf->channel <= 116)
+				rt2800_rfcsr_write(rt2x00dev, 58, 0x1D);
+			else if (rf->channel >= 118)
+				rt2800_rfcsr_write(rt2x00dev, 58, 0x15);
+			if (rf->channel <= 138)
+				rt2800_rfcsr_write(rt2x00dev, 59, 0x3F);
+			else if (rf->channel >= 140)
+				rt2800_rfcsr_write(rt2x00dev, 59, 0x7C);
+			if (rf->channel <= 116)
+				rt2800_rfcsr_write(rt2x00dev, 62, 0x1D);
+			else if (rf->channel >= 118)
+				rt2800_rfcsr_write(rt2x00dev, 62, 0x15);
+		}
+
+		power_bound = POWER_BOUND_5G;
+		ep_reg = 0x3;
+	}
+
+	rt2800_rfcsr_read(rt2x00dev, 49, &rfcsr);
+	if (info->default_power1 > power_bound)
+		rt2x00_set_field8(&rfcsr, RFCSR49_TX, power_bound);
+	else
+		rt2x00_set_field8(&rfcsr, RFCSR49_TX, info->default_power1);
+	if (is_type_ep)
+		rt2x00_set_field8(&rfcsr, RFCSR49_EP, ep_reg);
+	rt2800_rfcsr_write(rt2x00dev, 49, rfcsr);
+
+	rt2800_rfcsr_read(rt2x00dev, 50, &rfcsr);
+	if (info->default_power1 > power_bound)
+		rt2x00_set_field8(&rfcsr, RFCSR50_TX, power_bound);
+	else
+		rt2x00_set_field8(&rfcsr, RFCSR50_TX, info->default_power2);
+	if (is_type_ep)
+		rt2x00_set_field8(&rfcsr, RFCSR50_EP, ep_reg);
+	rt2800_rfcsr_write(rt2x00dev, 50, rfcsr);
+
+	rt2800_rfcsr_read(rt2x00dev, 1, &rfcsr);
+	rt2x00_set_field8(&rfcsr, RFCSR1_RF_BLOCK_EN, 1);
+	rt2x00_set_field8(&rfcsr, RFCSR1_PLL_PD, 1);
+
+	rt2x00_set_field8(&rfcsr, RFCSR1_TX0_PD,
+			  rt2x00dev->default_ant.tx_chain_num >= 1);
+	rt2x00_set_field8(&rfcsr, RFCSR1_TX1_PD,
+			  rt2x00dev->default_ant.tx_chain_num == 2);
+	rt2x00_set_field8(&rfcsr, RFCSR1_TX2_PD, 0);
+
+	rt2x00_set_field8(&rfcsr, RFCSR1_RX0_PD,
+			  rt2x00dev->default_ant.rx_chain_num >= 1);
+	rt2x00_set_field8(&rfcsr, RFCSR1_RX1_PD,
+			  rt2x00dev->default_ant.rx_chain_num == 2);
+	rt2x00_set_field8(&rfcsr, RFCSR1_RX2_PD, 0);
+
+	rt2800_rfcsr_write(rt2x00dev, 1, rfcsr);
+	rt2800_rfcsr_write(rt2x00dev, 6, 0xe4);
+
+	if (conf_is_ht40(conf))
+		rt2800_rfcsr_write(rt2x00dev, 30, 0x16);
+	else
+		rt2800_rfcsr_write(rt2x00dev, 30, 0x10);
+
+	if (!is_11b) {
+		rt2800_rfcsr_write(rt2x00dev, 31, 0x80);
+		rt2800_rfcsr_write(rt2x00dev, 32, 0x80);
+	}
+
+	/* TODO proper frequency adjustment */
+	rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
+	if (rt2x00dev->freq_offset > FREQ_OFFSET_BOUND)
+		rt2x00_set_field8(&rfcsr, RFCSR17_CODE, FREQ_OFFSET_BOUND);
+	else
+		rt2x00_set_field8(&rfcsr, RFCSR17_CODE, rt2x00dev->freq_offset);
+	rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
+
+	/* TODO merge with others */
+	rt2800_rfcsr_read(rt2x00dev, 3, &rfcsr);
+	rt2x00_set_field8(&rfcsr, RFCSR3_VCOCAL_EN, 1);
+	rt2800_rfcsr_write(rt2x00dev, 3, rfcsr);
+}
+
 static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 				  struct ieee80211_conf *conf,
 				  struct rf_channel *rf,
@@ -2225,6 +2477,9 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 	case RF5392:
 		rt2800_config_channel_rf53xx(rt2x00dev, conf, rf, info);
 		break;
+	case RF5592:
+		rt2800_config_channel_rf55xx(rt2x00dev, conf, rf, info);
+		break;
 	default:
 		rt2800_config_channel_rf2xxx(rt2x00dev, conf, rf, info);
 	}
-- 
1.7.4.4

