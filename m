Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:37944 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750701AbdAMVos (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 16:44:48 -0500
Date: Fri, 13 Jan 2017 22:24:26 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 12/40] rt2x00: rt2800lib: add channel configuration function
 for RF3853
Message-ID: <20170113212421.GA3433@makrotopia.org> (sfid-20170113_224451_024054_2A27E1A0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gabor Juhos <juhosg@openwrt.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
[daniel@makrotopia.org: replaced udelay with usleep_range]
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 208 +++++++++++++++++++++++++
 1 file changed, 208 insertions(+)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 15bcad1156d9..eda886648daf 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -2661,6 +2661,211 @@ static void rt2800_config_channel_rf3053(struct rt2x00_dev *rt2x00dev,
 	}
 }
 
+static void rt2800_config_channel_rf3853(struct rt2x00_dev *rt2x00dev,
+					 struct ieee80211_conf *conf,
+					 struct rf_channel *rf,
+					 struct channel_info *info)
+{
+	u8 rfcsr;
+	u8 bbp;
+	u8 pwr1, pwr2, pwr3;
+
+	const bool txbf_enabled = false; /* TODO */
+
+	/* TODO: add band selection */
+
+	if (rf->channel <= 14)
+		rt2800_rfcsr_write(rt2x00dev, 6, 0x40);
+	else if (rf->channel < 132)
+		rt2800_rfcsr_write(rt2x00dev, 6, 0x80);
+	else
+		rt2800_rfcsr_write(rt2x00dev, 6, 0x40);
+
+	rt2800_rfcsr_write(rt2x00dev, 8, rf->rf1);
+	rt2800_rfcsr_write(rt2x00dev, 9, rf->rf3);
+
+	if (rf->channel <= 14)
+		rt2800_rfcsr_write(rt2x00dev, 11, 0x46);
+	else
+		rt2800_rfcsr_write(rt2x00dev, 11, 0x48);
+
+	if (rf->channel <= 14)
+		rt2800_rfcsr_write(rt2x00dev, 12, 0x1a);
+	else
+		rt2800_rfcsr_write(rt2x00dev, 12, 0x52);
+
+	rt2800_rfcsr_write(rt2x00dev, 13, 0x12);
+
+	rt2800_rfcsr_read(rt2x00dev, 1, &rfcsr);
+	rt2x00_set_field8(&rfcsr, RFCSR1_RX0_PD, 0);
+	rt2x00_set_field8(&rfcsr, RFCSR1_TX0_PD, 0);
+	rt2x00_set_field8(&rfcsr, RFCSR1_RX1_PD, 0);
+	rt2x00_set_field8(&rfcsr, RFCSR1_TX1_PD, 0);
+	rt2x00_set_field8(&rfcsr, RFCSR1_RX2_PD, 0);
+	rt2x00_set_field8(&rfcsr, RFCSR1_TX2_PD, 0);
+	rt2x00_set_field8(&rfcsr, RFCSR1_RF_BLOCK_EN, 1);
+	rt2x00_set_field8(&rfcsr, RFCSR1_PLL_PD, 1);
+
+	switch (rt2x00dev->default_ant.tx_chain_num) {
+	case 3:
+		rt2x00_set_field8(&rfcsr, RFCSR1_TX2_PD, 1);
+		/* fallthrough */
+	case 2:
+		rt2x00_set_field8(&rfcsr, RFCSR1_TX1_PD, 1);
+		/* fallthrough */
+	case 1:
+		rt2x00_set_field8(&rfcsr, RFCSR1_TX0_PD, 1);
+		break;
+	}
+
+	switch (rt2x00dev->default_ant.rx_chain_num) {
+	case 3:
+		rt2x00_set_field8(&rfcsr, RFCSR1_RX2_PD, 1);
+		/* fallthrough */
+	case 2:
+		rt2x00_set_field8(&rfcsr, RFCSR1_RX1_PD, 1);
+		/* fallthrough */
+	case 1:
+		rt2x00_set_field8(&rfcsr, RFCSR1_RX0_PD, 1);
+		break;
+	}
+	rt2800_rfcsr_write(rt2x00dev, 1, rfcsr);
+
+	rt2800_adjust_freq_offset(rt2x00dev);
+
+	rt2800_rfcsr_read(rt2x00dev, 30, &rfcsr);
+	if (!conf_is_ht40(conf))
+		rfcsr &= ~(0x06);
+	else
+		rfcsr |= 0x06;
+	rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
+
+	if (rf->channel <= 14)
+		rt2800_rfcsr_write(rt2x00dev, 31, 0xa0);
+	else
+		rt2800_rfcsr_write(rt2x00dev, 31, 0x80);
+
+	if (conf_is_ht40(conf))
+		rt2800_rfcsr_write(rt2x00dev, 32, 0x80);
+	else
+		rt2800_rfcsr_write(rt2x00dev, 32, 0xd8);
+
+	if (rf->channel <= 14)
+		rt2800_rfcsr_write(rt2x00dev, 34, 0x3c);
+	else
+		rt2800_rfcsr_write(rt2x00dev, 34, 0x20);
+
+	/* loopback RF_BS */
+	rt2800_rfcsr_read(rt2x00dev, 36, &rfcsr);
+	if (rf->channel <= 14)
+		rt2x00_set_field8(&rfcsr, RFCSR36_RF_BS, 1);
+	else
+		rt2x00_set_field8(&rfcsr, RFCSR36_RF_BS, 0);
+	rt2800_rfcsr_write(rt2x00dev, 36, rfcsr);
+
+	if (rf->channel <= 14)
+		rfcsr = 0x23;
+	else if (rf->channel < 100)
+		rfcsr = 0x36;
+	else if (rf->channel < 132)
+		rfcsr = 0x32;
+	else
+		rfcsr = 0x30;
+
+	if (txbf_enabled)
+		rfcsr |= 0x40;
+
+	rt2800_rfcsr_write(rt2x00dev, 39, rfcsr);
+
+	if (rf->channel <= 14)
+		rt2800_rfcsr_write(rt2x00dev, 44, 0x93);
+	else
+		rt2800_rfcsr_write(rt2x00dev, 44, 0x9b);
+
+	if (rf->channel <= 14)
+		rfcsr = 0xbb;
+	else if (rf->channel < 100)
+		rfcsr = 0xeb;
+	else if (rf->channel < 132)
+		rfcsr = 0xb3;
+	else
+		rfcsr = 0x9b;
+	rt2800_rfcsr_write(rt2x00dev, 45, rfcsr);
+
+	if (rf->channel <= 14)
+		rfcsr = 0x8e;
+	else
+		rfcsr = 0x8a;
+
+	if (txbf_enabled)
+		rfcsr |= 0x20;
+
+	rt2800_rfcsr_write(rt2x00dev, 49, rfcsr);
+
+	rt2800_rfcsr_write(rt2x00dev, 50, 0x86);
+
+	rt2800_rfcsr_read(rt2x00dev, 51, &rfcsr);
+	if (rf->channel <= 14)
+		rt2800_rfcsr_write(rt2x00dev, 51, 0x75);
+	else
+		rt2800_rfcsr_write(rt2x00dev, 51, 0x51);
+
+	rt2800_rfcsr_read(rt2x00dev, 52, &rfcsr);
+	if (rf->channel <= 14)
+		rt2800_rfcsr_write(rt2x00dev, 52, 0x45);
+	else
+		rt2800_rfcsr_write(rt2x00dev, 52, 0x05);
+
+	if (rf->channel <= 14) {
+		pwr1 = info->default_power1 & 0x1f;
+		pwr2 = info->default_power2 & 0x1f;
+		pwr3 = info->default_power3 & 0x1f;
+	} else {
+		pwr1 = 0x48 | ((info->default_power1 & 0x18) << 1) |
+			(info->default_power1 & 0x7);
+		pwr2 = 0x48 | ((info->default_power2 & 0x18) << 1) |
+			(info->default_power2 & 0x7);
+		pwr3 = 0x48 | ((info->default_power3 & 0x18) << 1) |
+			(info->default_power3 & 0x7);
+	}
+
+	rt2800_rfcsr_write(rt2x00dev, 53, pwr1);
+	rt2800_rfcsr_write(rt2x00dev, 54, pwr2);
+	rt2800_rfcsr_write(rt2x00dev, 55, pwr3);
+
+	rt2x00_dbg(rt2x00dev, "Channel:%d, pwr1:%02x, pwr2:%02x, pwr3:%02x\n",
+		   rf->channel, pwr1, pwr2, pwr3);
+
+	bbp = (info->default_power1 >> 5) |
+	      ((info->default_power2 & 0xe0) >> 1);
+	rt2800_bbp_write(rt2x00dev, 109, bbp);
+
+	rt2800_bbp_read(rt2x00dev, 110, &bbp);
+	bbp &= 0x0f;
+	bbp |= (info->default_power3 & 0xe0) >> 1;
+	rt2800_bbp_write(rt2x00dev, 110, bbp);
+
+	rt2800_rfcsr_read(rt2x00dev, 57, &rfcsr);
+	if (rf->channel <= 14)
+		rt2800_rfcsr_write(rt2x00dev, 57, 0x6e);
+	else
+		rt2800_rfcsr_write(rt2x00dev, 57, 0x3e);
+
+	/* Enable RF tuning */
+	rt2800_rfcsr_read(rt2x00dev, 3, &rfcsr);
+	rt2x00_set_field8(&rfcsr, RFCSR3_VCOCAL_EN, 1);
+	rt2800_rfcsr_write(rt2x00dev, 3, rfcsr);
+
+	usleep_range(2000, 2500);
+
+	rt2800_bbp_read(rt2x00dev, 49, &bbp);
+	/* clear update flag */
+	rt2800_bbp_write(rt2x00dev, 49, bbp & 0xfe);
+	rt2800_bbp_write(rt2x00dev, 49, bbp);
+
+	/* TODO: add calibration for TxBF */
+}
+
 #define POWER_BOUND		0x27
 #define POWER_BOUND_5G		0x2b
 
@@ -3273,6 +3478,9 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 	case RF3322:
 		rt2800_config_channel_rf3322(rt2x00dev, conf, rf, info);
 		break;
+	case RF3853:
+		rt2800_config_channel_rf3853(rt2x00dev, conf, rf, info);
+		break;
 	case RF3070:
 	case RF5360:
 	case RF5362:
-- 
2.11.0
