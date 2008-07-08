Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from n21.bullet.mail.ukl.yahoo.com ([87.248.110.138]:44321 "HELO
	n21.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751324AbYGHGoY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 02:44:24 -0400
Message-ID: <48730E9E.4010802@yahoo.co.uk> (sfid-20080708_084440_433450_2225CD82)
Date: Tue, 08 Jul 2008 07:52:14 +0100
From: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@redhat.com>, flamingice@sourmilk.net,
	Andrea Merello <andreamrl@tiscali.it>
CC: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>
Subject: [PATCH 4/6] rtl8187: change part 1 of rtl8187_dev.c to support RTL8187B
References: <4873088C.2090603@yahoo.co.uk>
In-Reply-To: <4873088C.2090603@yahoo.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rtl8187: change part 1 of rtl8187_dev.c to support RTL8187B

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Signed-off-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Signed-off-by: Pavel Roskin <proski@gnu.org>
---
diff --git a/drivers/net/wireless/rtl8187_dev.c b/drivers/net/wireless/rtl8187_dev.c
index bec96d7..b17f237 100644
--- a/drivers/net/wireless/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl8187_dev.c
@@ -27,19 +27,21 @@

  MODULE_AUTHOR("Michael Wu <flamingice@sourmilk.net>");
  MODULE_AUTHOR("Andrea Merello <andreamrl@tiscali.it>");
-MODULE_DESCRIPTION("RTL8187 USB wireless driver");
+MODULE_DESCRIPTION("RTL8187/RTL8187B USB wireless driver");
  MODULE_LICENSE("GPL");

  static struct usb_device_id rtl8187_table[] __devinitdata = {
  	/* Realtek */
-	{USB_DEVICE(0x0bda, 0x8187)},
+	{USB_DEVICE(0x0bda, 0x8187), .driver_info = DEVICE_RTL8187},
+	{USB_DEVICE(0x0bda, 0x8189), .driver_info = DEVICE_RTL8187B},
+	{USB_DEVICE(0x0bda, 0x8197), .driver_info = DEVICE_RTL8187B},
  	/* Netgear */
-	{USB_DEVICE(0x0846, 0x6100)},
-	{USB_DEVICE(0x0846, 0x6a00)},
+	{USB_DEVICE(0x0846, 0x6100), .driver_info = DEVICE_RTL8187},
+	{USB_DEVICE(0x0846, 0x6a00), .driver_info = DEVICE_RTL8187},
  	/* HP */
-	{USB_DEVICE(0x03f0, 0xca02)},
+	{USB_DEVICE(0x03f0, 0xca02), .driver_info = DEVICE_RTL8187},
  	/* Sitecom */
-	{USB_DEVICE(0x0df6, 0x000d)},
+	{USB_DEVICE(0x0df6, 0x000d), .driver_info = DEVICE_RTL8187},
  	{}
  };

@@ -318,29 +320,12 @@ static int rtl8187_init_urbs(struct ieee80211_hw *dev)
  	return 0;
  }

-static int rtl8187_init_hw(struct ieee80211_hw *dev)
+static int rtl8187_cmd_reset(struct ieee80211_hw *dev)
  {
  	struct rtl8187_priv *priv = dev->priv;
  	u8 reg;
  	int i;

-	/* reset */
-	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
-	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
-	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg | RTL818X_CONFIG3_ANAPARAM_WRITE);
-	rtl818x_iowrite32(priv, &priv->map->ANAPARAM, RTL8225_ANAPARAM_ON);
-	rtl818x_iowrite32(priv, &priv->map->ANAPARAM2, RTL8225_ANAPARAM2_ON);
-	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg & 
~RTL818X_CONFIG3_ANAPARAM_WRITE);
-	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
-
-	rtl818x_iowrite16(priv, &priv->map->INT_MASK, 0);
-
-	msleep(200);
-	rtl818x_iowrite8(priv, (u8 *)0xFE18, 0x10);
-	rtl818x_iowrite8(priv, (u8 *)0xFE18, 0x11);
-	rtl818x_iowrite8(priv, (u8 *)0xFE18, 0x00);
-	msleep(200);
-
  	reg = rtl818x_ioread8(priv, &priv->map->CMD);
  	reg &= (1 << 1);
  	reg |= RTL818X_CMD_RESET;
@@ -376,12 +361,48 @@ static int rtl8187_init_hw(struct ieee80211_hw *dev)
  		return -ETIMEDOUT;
  	}

+	return 0;
+}
+
+static int rtl8187_init_hw(struct ieee80211_hw *dev)
+{
+	struct rtl8187_priv *priv = dev->priv;
+	u8 reg;
+	int res;
+
+	/* reset */
+	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
+			 RTL818X_EEPROM_CMD_CONFIG);
+	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
+	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg |
+			 RTL818X_CONFIG3_ANAPARAM_WRITE);
+	rtl818x_iowrite32(priv, &priv->map->ANAPARAM, RTL8225_ANAPARAM_ON);
+	rtl818x_iowrite32(priv, &priv->map->ANAPARAM2, RTL8225_ANAPARAM2_ON);
+	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg &
+			 ~RTL818X_CONFIG3_ANAPARAM_WRITE);
+	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
+			 RTL818X_EEPROM_CMD_NORMAL);
+
+	rtl818x_iowrite16(priv, &priv->map->INT_MASK, 0);
+
+	msleep(200);
+	rtl818x_iowrite8(priv, (u8 *)0xFE18, 0x10);
+	rtl818x_iowrite8(priv, (u8 *)0xFE18, 0x11);
+	rtl818x_iowrite8(priv, (u8 *)0xFE18, 0x00);
+	msleep(200);
+
+	res = rtl8187_cmd_reset(dev);
+	if (res)
+		return res;
+
  	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
  	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
-	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg | RTL818X_CONFIG3_ANAPARAM_WRITE);
+	rtl818x_iowrite8(priv, &priv->map->CONFIG3,
+			reg | RTL818X_CONFIG3_ANAPARAM_WRITE);
  	rtl818x_iowrite32(priv, &priv->map->ANAPARAM, RTL8225_ANAPARAM_ON);
  	rtl818x_iowrite32(priv, &priv->map->ANAPARAM2, RTL8225_ANAPARAM2_ON);
-	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg & 
~RTL818X_CONFIG3_ANAPARAM_WRITE);
+	rtl818x_iowrite8(priv, &priv->map->CONFIG3,
+			reg & ~RTL818X_CONFIG3_ANAPARAM_WRITE);
  	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);

  	/* setup card */
@@ -426,9 +447,11 @@ static int rtl8187_init_hw(struct ieee80211_hw *dev)
  	rtl818x_iowrite32(priv, &priv->map->RF_TIMING, 0x000a8008);
  	rtl818x_iowrite16(priv, &priv->map->BRSR, 0xFFFF);
  	rtl818x_iowrite32(priv, &priv->map->RF_PARA, 0x00100044);
-	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
+	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
+			 RTL818X_EEPROM_CMD_CONFIG);
  	rtl818x_iowrite8(priv, &priv->map->CONFIG3, 0x44);
-	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
+	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
+			 RTL818X_EEPROM_CMD_NORMAL);
  	rtl818x_iowrite16(priv, &priv->map->RFPinsEnable, 0x1FF7);
  	msleep(100);

@@ -445,16 +468,198 @@ static int rtl8187_init_hw(struct ieee80211_hw *dev)
  	return 0;
  }

+static const u8 rtl8187b_reg_table[][3] = {
+	{0xF0, 0x32, 0}, {0xF1, 0x32, 0}, {0xF2, 0x00, 0}, {0xF3, 0x00, 0},
+	{0xF4, 0x32, 0}, {0xF5, 0x43, 0}, {0xF6, 0x00, 0}, {0xF7, 0x00, 0},
+	{0xF8, 0x46, 0}, {0xF9, 0xA4, 0}, {0xFA, 0x00, 0}, {0xFB, 0x00, 0},
+	{0xFC, 0x96, 0}, {0xFD, 0xA4, 0}, {0xFE, 0x00, 0}, {0xFF, 0x00, 0},
+
+	{0x58, 0x4B, 1}, {0x59, 0x00, 1}, {0x5A, 0x4B, 1}, {0x5B, 0x00, 1},
+	{0x60, 0x4B, 1}, {0x61, 0x09, 1}, {0x62, 0x4B, 1}, {0x63, 0x09, 1},
+	{0xCE, 0x0F, 1}, {0xCF, 0x00, 1}, {0xE0, 0xFF, 1}, {0xE1, 0x0F, 1},
+	{0xE2, 0x00, 1}, {0xF0, 0x4E, 1}, {0xF1, 0x01, 1}, {0xF2, 0x02, 1},
+	{0xF3, 0x03, 1}, {0xF4, 0x04, 1}, {0xF5, 0x05, 1}, {0xF6, 0x06, 1},
+	{0xF7, 0x07, 1}, {0xF8, 0x08, 1},
+
+	{0x4E, 0x00, 2}, {0x0C, 0x04, 2}, {0x21, 0x61, 2}, {0x22, 0x68, 2},
+	{0x23, 0x6F, 2}, {0x24, 0x76, 2}, {0x25, 0x7D, 2}, {0x26, 0x84, 2},
+	{0x27, 0x8D, 2}, {0x4D, 0x08, 2}, {0x50, 0x05, 2}, {0x51, 0xF5, 2},
+	{0x52, 0x04, 2}, {0x53, 0xA0, 2}, {0x54, 0x1F, 2}, {0x55, 0x23, 2},
+	{0x56, 0x45, 2}, {0x57, 0x67, 2}, {0x58, 0x08, 2}, {0x59, 0x08, 2},
+	{0x5A, 0x08, 2}, {0x5B, 0x08, 2}, {0x60, 0x08, 2}, {0x61, 0x08, 2},
+	{0x62, 0x08, 2}, {0x63, 0x08, 2}, {0x64, 0xCF, 2}, {0x72, 0x56, 2},
+	{0x73, 0x9A, 2},
+
+	{0x34, 0xF0, 0}, {0x35, 0x0F, 0}, {0x5B, 0x40, 0}, {0x84, 0x88, 0},
+	{0x85, 0x24, 0}, {0x88, 0x54, 0}, {0x8B, 0xB8, 0}, {0x8C, 0x07, 0},
+	{0x8D, 0x00, 0}, {0x94, 0x1B, 0}, {0x95, 0x12, 0}, {0x96, 0x00, 0},
+	{0x97, 0x06, 0}, {0x9D, 0x1A, 0}, {0x9F, 0x10, 0}, {0xB4, 0x22, 0},
+	{0xBE, 0x80, 0}, {0xDB, 0x00, 0}, {0xEE, 0x00, 0}, {0x91, 0x03, 0},
+
+	{0x4C, 0x00, 2}, {0x9F, 0x00, 3}, {0x8C, 0x01, 0}, {0x8D, 0x10, 0},
+	{0x8E, 0x08, 0}, {0x8F, 0x00, 0}
+};
+
+static int rtl8187b_init_hw(struct ieee80211_hw *dev)
+{
+	struct rtl8187_priv *priv = dev->priv;
+	int res, i;
+	u8 reg;
+
+	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
+			 RTL818X_EEPROM_CMD_CONFIG);
+
+	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
+	reg |= RTL818X_CONFIG3_ANAPARAM_WRITE | RTL818X_CONFIG3_GNT_SELECT;
+	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg);
+	rtl818x_iowrite32(priv, &priv->map->ANAPARAM2, 0x727f3f52);
+	rtl818x_iowrite32(priv, &priv->map->ANAPARAM, 0x45090658);
+	rtl818x_iowrite8(priv, &priv->map->ANAPARAM3, 0);
+
+	rtl818x_iowrite8(priv, (u8 *)0xFF61, 0x10);
+	reg = rtl818x_ioread8(priv, (u8 *)0xFF62);
+	rtl818x_iowrite8(priv, (u8 *)0xFF62, reg & ~(1 << 5));
+	rtl818x_iowrite8(priv, (u8 *)0xFF62, reg | (1 << 5));
+
+	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
+	reg &= ~RTL818X_CONFIG3_ANAPARAM_WRITE;
+	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg);
+
+	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
+			 RTL818X_EEPROM_CMD_NORMAL);
+
+	res = rtl8187_cmd_reset(dev);
+	if (res)
+		return res;
+
+	rtl818x_iowrite16(priv, (__le16 *)0xFF2D, 0x0FFF);
+	reg = rtl818x_ioread8(priv, &priv->map->CW_CONF);
+	reg |= RTL818X_CW_CONF_PERPACKET_RETRY_SHIFT;
+	rtl818x_iowrite8(priv, &priv->map->CW_CONF, reg);
+	reg = rtl818x_ioread8(priv, &priv->map->TX_AGC_CTL);
+	reg |= RTL818X_TX_AGC_CTL_PERPACKET_GAIN_SHIFT |
+	       RTL818X_TX_AGC_CTL_PERPACKET_ANTSEL_SHIFT;
+	rtl818x_iowrite8(priv, &priv->map->TX_AGC_CTL, reg);
+
+	rtl818x_iowrite16_idx(priv, (__le16 *)0xFFE0, 0x0FFF, 1);
+	reg = rtl818x_ioread8(priv, &priv->map->RATE_FALLBACK);
+	reg |= RTL818X_RATE_FALLBACK_ENABLE;
+	rtl818x_iowrite8(priv, &priv->map->RATE_FALLBACK, reg);
+
+	rtl818x_iowrite16(priv, &priv->map->BEACON_INTERVAL, 100);
+	rtl818x_iowrite16(priv, &priv->map->ATIM_WND, 2);
+	rtl818x_iowrite16_idx(priv, (__le16 *)0xFFD4, 0xFFFF, 1);
+
+	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
+			 RTL818X_EEPROM_CMD_CONFIG);
+	reg = rtl818x_ioread8(priv, &priv->map->CONFIG1);
+	rtl818x_iowrite8(priv, &priv->map->CONFIG1, (reg & 0x3F) | 0x80);
+	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
+			 RTL818X_EEPROM_CMD_NORMAL);
+
+	rtl818x_iowrite8(priv, &priv->map->WPA_CONF, 0);
+	for (i = 0; i < ARRAY_SIZE(rtl8187b_reg_table); i++) {
+		rtl818x_iowrite8_idx(priv,
+				     (u8 *)(uintptr_t)
+				     (rtl8187b_reg_table[i][0] | 0xFF00),
+				     rtl8187b_reg_table[i][1],
+				     rtl8187b_reg_table[i][2]);
+	}
+
+	rtl818x_iowrite16(priv, &priv->map->TID_AC_MAP, 0xFA50);
+	rtl818x_iowrite16(priv, &priv->map->INT_MIG, 0);
+
+	rtl818x_iowrite32_idx(priv, (__le32 *)0xFFF0, 0, 1);
+	rtl818x_iowrite32_idx(priv, (__le32 *)0xFFF4, 0, 1);
+	rtl818x_iowrite8_idx(priv, (u8 *)0xFFF8, 0, 1);
+
+	rtl818x_iowrite32(priv, &priv->map->RF_TIMING, 0x00004001);
+
+	rtl818x_iowrite16_idx(priv, (__le16 *)0xFF72, 0x569A, 2);
+
+	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
+			 RTL818X_EEPROM_CMD_CONFIG);
+	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
+	reg |= RTL818X_CONFIG3_ANAPARAM_WRITE;
+	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg);
+	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
+			 RTL818X_EEPROM_CMD_NORMAL);
+
+	rtl818x_iowrite16(priv, &priv->map->RFPinsOutput, 0x0480);
+	rtl818x_iowrite16(priv, &priv->map->RFPinsSelect, 0x2488);
+	rtl818x_iowrite16(priv, &priv->map->RFPinsEnable, 0x1FFF);
+	msleep(1100);
+
+	priv->rf->init(dev);
+
+	reg = RTL818X_CMD_TX_ENABLE | RTL818X_CMD_RX_ENABLE;
+	rtl818x_iowrite8(priv, &priv->map->CMD, reg);
+	rtl818x_iowrite16(priv, &priv->map->INT_MASK, 0xFFFF);
+
+	rtl818x_iowrite8(priv, (u8 *)0xFE41, 0xF4);
+	rtl818x_iowrite8(priv, (u8 *)0xFE40, 0x00);
+	rtl818x_iowrite8(priv, (u8 *)0xFE42, 0x00);
+	rtl818x_iowrite8(priv, (u8 *)0xFE42, 0x01);
+	rtl818x_iowrite8(priv, (u8 *)0xFE40, 0x0F);
+	rtl818x_iowrite8(priv, (u8 *)0xFE42, 0x00);
+	rtl818x_iowrite8(priv, (u8 *)0xFE42, 0x01);
+
+	reg = rtl818x_ioread8(priv, (u8 *)0xFFDB);
+	rtl818x_iowrite8(priv, (u8 *)0xFFDB, reg | (1 << 2));
+	rtl818x_iowrite16_idx(priv, (__le16 *)0xFF72, 0x59FA, 3);
+	rtl818x_iowrite16_idx(priv, (__le16 *)0xFF74, 0x59D2, 3);
+	rtl818x_iowrite16_idx(priv, (__le16 *)0xFF76, 0x59D2, 3);
+	rtl818x_iowrite16_idx(priv, (__le16 *)0xFF78, 0x19FA, 3);
+	rtl818x_iowrite16_idx(priv, (__le16 *)0xFF7A, 0x19FA, 3);
+	rtl818x_iowrite16_idx(priv, (__le16 *)0xFF7C, 0x00D0, 3);
+	rtl818x_iowrite8(priv, (u8 *)0xFF61, 0);
+	rtl818x_iowrite8_idx(priv, (u8 *)0xFF80, 0x0F, 1);
+	rtl818x_iowrite8_idx(priv, (u8 *)0xFF83, 0x03, 1);
+	rtl818x_iowrite8(priv, (u8 *)0xFFDA, 0x10);
+	rtl818x_iowrite8_idx(priv, (u8 *)0xFF4D, 0x08, 2);
+
+	rtl818x_iowrite32(priv, &priv->map->HSSI_PARA, 0x0600321B);
+
+	rtl818x_iowrite16_idx(priv, (__le16 *)0xFFEC, 0x0800, 1);
+
+	return 0;
+}
+
  static int rtl8187_start(struct ieee80211_hw *dev)
  {
  	struct rtl8187_priv *priv = dev->priv;
  	u32 reg;
  	int ret;

-	ret = rtl8187_init_hw(dev);
+	ret = (!priv->is_rtl8187b) ? rtl8187_init_hw(dev) :
+				     rtl8187b_init_hw(dev);
  	if (ret)
  		return ret;

+	if (priv->is_rtl8187b) {
+		reg = RTL818X_RX_CONF_MGMT |
+		      RTL818X_RX_CONF_DATA |
+		      RTL818X_RX_CONF_BROADCAST |
+		      RTL818X_RX_CONF_NICMAC |
+		      RTL818X_RX_CONF_BSSID |
+		      (7 << 13 /* RX FIFO threshold NONE */) |
+		      (7 << 10 /* MAX RX DMA */) |
+		      RTL818X_RX_CONF_RX_AUTORESETPHY |
+		      RTL818X_RX_CONF_ONLYERLPKT |
+		      RTL818X_RX_CONF_MULTICAST;
+		priv->rx_conf = reg;
+		rtl818x_iowrite32(priv, &priv->map->RX_CONF, reg);
+
+		rtl818x_iowrite32(priv, &priv->map->TX_CONF,
+				  RTL818X_TX_CONF_HW_SEQNUM |
+				  RTL818X_TX_CONF_DISREQQSIZE |
+				  (7 << 8  /* short retry limit */) |
+				  (7 << 0  /* long retry limit */) |
+				  (7 << 21 /* MAX TX DMA */));
+		rtl8187_init_urbs(dev);
+		return 0;
+	}
+
  	rtl818x_iowrite16(priv, &priv->map->INT_MASK, 0xFFFF);

  	rtl818x_iowrite32(priv, &priv->map->MAR[0], ~0);

