Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.237]:3924 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949AbYGHQUP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 12:20:15 -0400
Received: by qb-out-0506.google.com with SMTP id d8so5878690qbc.37
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jul 2008 09:20:15 -0700 (PDT)
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: Hin-Tak Leung <HinTak.Leung@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Pavel Roskin <proski@gnu.org>
Subject: [PATCH 3/6] rtl8187: updating rtl8187_rtl8225.c to support RTL8187B
Date: Tue,  8 Jul 2008 17:18:10 +0100
Message-Id: <1215533893-8598-3-git-send-email-HinTak.Leung@gmail.com> (sfid-20080708_182019_386739_A408645A)
In-Reply-To: <1215533893-8598-2-git-send-email-HinTak.Leung@gmail.com>
References: <1215533893-8598-1-git-send-email-HinTak.Leung@gmail.com>
 <1215533893-8598-2-git-send-email-HinTak.Leung@gmail.com>
From: Hin-Tak Leung <hintak.leung@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Signed-off-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/rtl8187_rtl8225.c |  229 ++++++++++++++++++++++++++++++--
 1 files changed, 215 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/rtl8187_rtl8225.c b/drivers/net/wireless/rtl8187_rtl8225.c
index 9146387..1e059de 100644
--- a/drivers/net/wireless/rtl8187_rtl8225.c
+++ b/drivers/net/wireless/rtl8187_rtl8225.c
@@ -305,9 +305,11 @@ static void rtl8225_rf_set_tx_power(struct ieee80211_hw *dev, int channel)
 	/* anaparam2 on */
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
 	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
-	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg | RTL818X_CONFIG3_ANAPARAM_WRITE);
+	rtl818x_iowrite8(priv, &priv->map->CONFIG3,
+			reg | RTL818X_CONFIG3_ANAPARAM_WRITE);
 	rtl818x_iowrite32(priv, &priv->map->ANAPARAM2, RTL8225_ANAPARAM2_ON);
-	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg & ~RTL818X_CONFIG3_ANAPARAM_WRITE);
+	rtl818x_iowrite8(priv, &priv->map->CONFIG3,
+			reg & ~RTL818X_CONFIG3_ANAPARAM_WRITE);
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
 
 	rtl8225_write_phy_ofdm(dev, 2, 0x42);
@@ -471,12 +473,42 @@ static void rtl8225_rf_init(struct ieee80211_hw *dev)
 	rtl8225_write_phy_cck(dev, 0x41, rtl8225_threshold[2]);
 }
 
+static const u8 rtl8225z2_agc[] = {
+	0x5e, 0x5e, 0x5e, 0x5e, 0x5d, 0x5b, 0x59, 0x57, 0x55, 0x53, 0x51, 0x4f,
+	0x4d, 0x4b, 0x49, 0x47, 0x45, 0x43, 0x41, 0x3f, 0x3d, 0x3b, 0x39, 0x37,
+	0x35, 0x33, 0x31, 0x2f, 0x2d, 0x2b, 0x29, 0x27, 0x25, 0x23, 0x21, 0x1f,
+	0x1d, 0x1b, 0x19, 0x17, 0x15, 0x13, 0x11, 0x0f, 0x0d, 0x0b, 0x09, 0x07,
+	0x05, 0x03, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
+	0x01, 0x01, 0x01, 0x01, 0x19, 0x19, 0x19, 0x19, 0x19, 0x19, 0x19, 0x19,
+	0x19, 0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x26, 0x27, 0x27, 0x28,
+	0x28, 0x29, 0x2a, 0x2a, 0x2a, 0x2b, 0x2b, 0x2b, 0x2c, 0x2c, 0x2c, 0x2d,
+	0x2d, 0x2d, 0x2d, 0x2e, 0x2e, 0x2e, 0x2e, 0x2f, 0x2f, 0x2f, 0x30, 0x30,
+	0x31, 0x31, 0x31, 0x31, 0x31, 0x31, 0x31, 0x31, 0x31, 0x31, 0x31, 0x31,
+	0x31, 0x31, 0x31, 0x31, 0x31, 0x31, 0x31, 0x31
+};
+static const u8 rtl8225z2_ofdm[] = {
+	0x10, 0x0d, 0x01, 0x00, 0x14, 0xfb, 0xfb, 0x60,
+	0x00, 0x60, 0x00, 0x00, 0x00, 0x5c, 0x00, 0x00,
+	0x40, 0x00, 0x40, 0x00, 0x00, 0x00, 0xa8, 0x26,
+	0x32, 0x33, 0x07, 0xa5, 0x6f, 0x55, 0xc8, 0xb3,
+	0x0a, 0xe1, 0x2C, 0x8a, 0x86, 0x83, 0x34, 0x0f,
+	0x4f, 0x24, 0x6f, 0xc2, 0x6b, 0x40, 0x80, 0x00,
+	0xc0, 0xc1, 0x58, 0xf1, 0x00, 0xe4, 0x90, 0x3e,
+	0x6d, 0x3c, 0xfb, 0x07
+};
+
 static const u8 rtl8225z2_tx_power_cck_ch14[] = {
-	0x36, 0x35, 0x2e, 0x1b, 0x00, 0x00, 0x00, 0x00
+	0x36, 0x35, 0x2e, 0x1b, 0x00, 0x00, 0x00, 0x00,
+	0x30, 0x2f, 0x29, 0x15, 0x00, 0x00, 0x00, 0x00,
+	0x30, 0x2f, 0x29, 0x15, 0x00, 0x00, 0x00, 0x00,
+	0x30, 0x2f, 0x29, 0x15, 0x00, 0x00, 0x00, 0x00
 };
 
 static const u8 rtl8225z2_tx_power_cck[] = {
-	0x36, 0x35, 0x2e, 0x25, 0x1c, 0x12, 0x09, 0x04
+	0x36, 0x35, 0x2e, 0x25, 0x1c, 0x12, 0x09, 0x04,
+	0x30, 0x2f, 0x29, 0x21, 0x19, 0x10, 0x08, 0x03,
+	0x2b, 0x2a, 0x25, 0x1e, 0x16, 0x0e, 0x07, 0x03,
+	0x26, 0x25, 0x21, 0x1b, 0x14, 0x0d, 0x06, 0x03
 };
 
 static const u8 rtl8225z2_tx_power_ofdm[] = {
@@ -526,9 +558,11 @@ static void rtl8225z2_rf_set_tx_power(struct ieee80211_hw *dev, int channel)
 	/* anaparam2 on */
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
 	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
-	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg | RTL818X_CONFIG3_ANAPARAM_WRITE);
+	rtl818x_iowrite8(priv, &priv->map->CONFIG3,
+			reg | RTL818X_CONFIG3_ANAPARAM_WRITE);
 	rtl818x_iowrite32(priv, &priv->map->ANAPARAM2, RTL8225_ANAPARAM2_ON);
-	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg & ~RTL818X_CONFIG3_ANAPARAM_WRITE);
+	rtl818x_iowrite8(priv, &priv->map->CONFIG3,
+			reg & ~RTL818X_CONFIG3_ANAPARAM_WRITE);
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
 
 	rtl8225_write_phy_ofdm(dev, 2, 0x42);
@@ -542,6 +576,85 @@ static void rtl8225z2_rf_set_tx_power(struct ieee80211_hw *dev, int channel)
 	msleep(1);
 }
 
+static void rtl8225z2_b_rf_set_tx_power(struct ieee80211_hw *dev, int channel)
+{
+	struct rtl8187_priv *priv = dev->priv;
+	u8 cck_power, ofdm_power;
+	const u8 *tmp;
+	int i;
+
+	cck_power = priv->channels[channel - 1].hw_value & 0xF;
+	ofdm_power = priv->channels[channel - 1].hw_value >> 4;
+
+	if (cck_power > 15)
+		cck_power = (priv->hw_rev == RTL8187BvB) ? 15 : 22;
+	else
+		cck_power += (priv->hw_rev == RTL8187BvB) ? 0 : 7;
+	cck_power += priv->txpwr_base & 0xF;
+	cck_power = min(cck_power, (u8)35);
+
+	if (ofdm_power > 15)
+		ofdm_power = (priv->hw_rev == RTL8187BvB) ? 17 : 25;
+	else
+		ofdm_power += (priv->hw_rev == RTL8187BvB) ? 2 : 10;
+	ofdm_power += (priv->txpwr_base >> 4) & 0xF;
+	ofdm_power = min(ofdm_power, (u8)35);
+
+	if (channel == 14)
+		tmp = rtl8225z2_tx_power_cck_ch14;
+	else
+		tmp = rtl8225z2_tx_power_cck;
+
+	if (priv->hw_rev == RTL8187BvB) {
+		if (cck_power <= 6)
+			; /* do nothing */
+		else if (cck_power <= 11)
+			tmp += 8;
+		else
+			tmp += 16;
+	} else {
+		if (cck_power <= 5)
+			; /* do nothing */
+		else if (cck_power <= 11)
+			tmp += 8;
+		else if (cck_power <= 17)
+			tmp += 16;
+		else
+			tmp += 24;
+	}
+
+	for (i = 0; i < 8; i++)
+		rtl8225_write_phy_cck(dev, 0x44 + i, *tmp++);
+
+	rtl818x_iowrite8(priv, &priv->map->TX_GAIN_CCK,
+			 rtl8225z2_tx_gain_cck_ofdm[cck_power]);
+	msleep(1);
+
+	rtl818x_iowrite8(priv, &priv->map->TX_GAIN_OFDM,
+			 rtl8225z2_tx_gain_cck_ofdm[ofdm_power] << 1);
+	if (priv->hw_rev == RTL8187BvB) {
+		if (ofdm_power <= 11) {
+			rtl8225_write_phy_ofdm(dev, 0x87, 0x60);
+			rtl8225_write_phy_ofdm(dev, 0x89, 0x60);
+		} else {
+			rtl8225_write_phy_ofdm(dev, 0x87, 0x5c);
+			rtl8225_write_phy_ofdm(dev, 0x89, 0x5c);
+		}
+	} else {
+		if (ofdm_power <= 11) {
+			rtl8225_write_phy_ofdm(dev, 0x87, 0x5c);
+			rtl8225_write_phy_ofdm(dev, 0x89, 0x5c);
+		} else if (ofdm_power <= 17) {
+			rtl8225_write_phy_ofdm(dev, 0x87, 0x54);
+			rtl8225_write_phy_ofdm(dev, 0x89, 0x54);
+		} else {
+			rtl8225_write_phy_ofdm(dev, 0x87, 0x50);
+			rtl8225_write_phy_ofdm(dev, 0x89, 0x50);
+		}
+	}
+	msleep(1);
+}
+
 static const u16 rtl8225z2_rxgain[] = {
 	0x0400, 0x0401, 0x0402, 0x0403, 0x0404, 0x0405, 0x0408, 0x0409,
 	0x040a, 0x040b, 0x0502, 0x0503, 0x0504, 0x0505, 0x0540, 0x0541,
@@ -715,6 +828,81 @@ static void rtl8225z2_rf_init(struct ieee80211_hw *dev)
 	rtl818x_iowrite32(priv, (__le32 *)0xFF94, 0x3dc00002);
 }
 
+static void rtl8225z2_b_rf_init(struct ieee80211_hw *dev)
+{
+	struct rtl8187_priv *priv = dev->priv;
+	int i;
+
+	rtl8225_write(dev, 0x0, 0x0B7); msleep(1);
+	rtl8225_write(dev, 0x1, 0xEE0); msleep(1);
+	rtl8225_write(dev, 0x2, 0x44D); msleep(1);
+	rtl8225_write(dev, 0x3, 0x441); msleep(1);
+	rtl8225_write(dev, 0x4, 0x8C3); msleep(1);
+	rtl8225_write(dev, 0x5, 0xC72); msleep(1);
+	rtl8225_write(dev, 0x6, 0x0E6); msleep(1);
+	rtl8225_write(dev, 0x7, 0x82A); msleep(1);
+	rtl8225_write(dev, 0x8, 0x03F); msleep(1);
+	rtl8225_write(dev, 0x9, 0x335); msleep(1);
+	rtl8225_write(dev, 0xa, 0x9D4); msleep(1);
+	rtl8225_write(dev, 0xb, 0x7BB); msleep(1);
+	rtl8225_write(dev, 0xc, 0x850); msleep(1);
+	rtl8225_write(dev, 0xd, 0xCDF); msleep(1);
+	rtl8225_write(dev, 0xe, 0x02B); msleep(1);
+	rtl8225_write(dev, 0xf, 0x114); msleep(1);
+
+	rtl8225_write(dev, 0x0, 0x1B7); msleep(1);
+
+	for (i = 0; i < ARRAY_SIZE(rtl8225z2_rxgain); i++) {
+		rtl8225_write(dev, 0x1, i + 1); msleep(1);
+		rtl8225_write(dev, 0x2, rtl8225z2_rxgain[i]); msleep(1);
+	}
+
+	rtl8225_write(dev, 0x3, 0x080); msleep(1);
+	rtl8225_write(dev, 0x5, 0x004); msleep(1);
+	rtl8225_write(dev, 0x0, 0x0B7); msleep(1);
+	msleep(3000);
+
+	rtl8225_write(dev, 0x2, 0xC4D); msleep(1);
+	msleep(2000);
+
+	rtl8225_write(dev, 0x2, 0x44D); msleep(1);
+	rtl8225_write(dev, 0x0, 0x2BF); msleep(1);
+
+	rtl818x_iowrite8(priv, &priv->map->TX_GAIN_CCK, 0x03);
+	rtl818x_iowrite8(priv, &priv->map->TX_GAIN_OFDM, 0x07);
+	rtl818x_iowrite8(priv, &priv->map->TX_ANTENNA, 0x03);
+
+	rtl8225_write_phy_ofdm(dev, 0x80, 0x12);
+	for (i = 0; i < ARRAY_SIZE(rtl8225z2_agc); i++) {
+		rtl8225_write_phy_ofdm(dev, 0xF, rtl8225z2_agc[i]);
+		rtl8225_write_phy_ofdm(dev, 0xE, 0x80 + i);
+		rtl8225_write_phy_ofdm(dev, 0xE, 0);
+	}
+	rtl8225_write_phy_ofdm(dev, 0x80, 0x10);
+
+	for (i = 0; i < ARRAY_SIZE(rtl8225z2_ofdm); i++)
+		rtl8225_write_phy_ofdm(dev, i, rtl8225z2_ofdm[i]);
+
+	rtl818x_iowrite8(priv, &priv->map->SIFS, 0x22);
+	rtl818x_iowrite8(priv, &priv->map->SLOT, 9);
+	rtl818x_iowrite8(priv, (u8 *)0xFFF0, 28);
+	rtl818x_iowrite8(priv, (u8 *)0xFFF4, 28);
+	rtl818x_iowrite8(priv, (u8 *)0xFFF8, 28);
+	rtl818x_iowrite8(priv, (u8 *)0xFFFC, 28);
+	rtl818x_iowrite8(priv, (u8 *)0xFF2D, 0x5B);
+	rtl818x_iowrite8(priv, (u8 *)0xFF79, 0x5B);
+	rtl818x_iowrite32(priv, (__le32 *)0xFFF0, (7 << 12) | (3 << 8) | 28);
+	rtl818x_iowrite32(priv, (__le32 *)0xFFF4, (7 << 12) | (3 << 8) | 28);
+	rtl818x_iowrite32(priv, (__le32 *)0xFFF8, (7 << 12) | (3 << 8) | 28);
+	rtl818x_iowrite32(priv, (__le32 *)0xFFFC, (7 << 12) | (3 << 8) | 28);
+	rtl818x_iowrite8(priv, &priv->map->ACM_CONTROL, 0);
+
+	rtl8225_write_phy_ofdm(dev, 0x97, 0x46); msleep(1);
+	rtl8225_write_phy_ofdm(dev, 0xa4, 0xb6); msleep(1);
+	rtl8225_write_phy_ofdm(dev, 0x85, 0xfc); msleep(1);
+	rtl8225_write_phy_cck(dev, 0xc1, 0x88); msleep(1);
+}
+
 static void rtl8225_rf_stop(struct ieee80211_hw *dev)
 {
 	u8 reg;
@@ -739,8 +927,10 @@ static void rtl8225_rf_set_channel(struct ieee80211_hw *dev,
 
 	if (priv->rf->init == rtl8225_rf_init)
 		rtl8225_rf_set_tx_power(dev, chan);
-	else
+	else if (priv->rf->init == rtl8225z2_rf_init)
 		rtl8225z2_rf_set_tx_power(dev, chan);
+	else
+		rtl8225z2_b_rf_set_tx_power(dev, chan);
 
 	rtl8225_write(dev, 0x7, rtl8225_chan[chan - 1]);
 	msleep(10);
@@ -760,19 +950,30 @@ static const struct rtl818x_rf_ops rtl8225z2_ops = {
 	.set_chan	= rtl8225_rf_set_channel
 };
 
+static const struct rtl818x_rf_ops rtl8225z2_b_ops = {
+	.name		= "rtl8225z2",
+	.init		= rtl8225z2_b_rf_init,
+	.stop		= rtl8225_rf_stop,
+	.set_chan	= rtl8225_rf_set_channel
+};
+
 const struct rtl818x_rf_ops * rtl8187_detect_rf(struct ieee80211_hw *dev)
 {
 	u16 reg8, reg9;
+	struct rtl8187_priv *priv = dev->priv;
 
-	rtl8225_write(dev, 0, 0x1B7);
+	if (!priv->is_rtl8187b) {
+		rtl8225_write(dev, 0, 0x1B7);
 
-	reg8 = rtl8225_read(dev, 8);
-	reg9 = rtl8225_read(dev, 9);
+		reg8 = rtl8225_read(dev, 8);
+		reg9 = rtl8225_read(dev, 9);
 
-	rtl8225_write(dev, 0, 0x0B7);
+		rtl8225_write(dev, 0, 0x0B7);
 
-	if (reg8 != 0x588 || reg9 != 0x700)
-		return &rtl8225_ops;
+		if (reg8 != 0x588 || reg9 != 0x700)
+			return &rtl8225_ops;
 
-	return &rtl8225z2_ops;
+		return &rtl8225z2_ops;
+	} else
+		return &rtl8225z2_b_ops;
 }
-- 
1.5.5.1

