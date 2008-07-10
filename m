Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:40927 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181AbYGJVvZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 17:51:25 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: linux-wireless@vger.kernel.org
Subject: [RFC] Try to improve RTL8187B initialization time
Date: Thu, 10 Jul 2008 18:51:31 -0300
Cc: "Hin-Tak Leung" <htl10@users.sourceforge.net>,
	Larry Finger <Larry.Finger@lwfinger.net>, proski@gnu.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200807101851.31985.herton@mandriva.com.br> (sfid-20080710_235209_994396_6A54BAE1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As reported before, we know that the initialization of rtl8187b interfaces is
slow. There were some strange sleeps from vendor driver that were imported too
just to be sure, but they don't seem to be needed. After looking at r8180 code,
I think they really aren't needed, and using it as reference, I did a similar
initialization now for rtl8187b, on quick tests seems to work well.

Another thing I got is a RTL818X_CONFIG3_ANAPARAM_WRITE being enabled without
writing any ANAPARAM value (this came from vendor driver also), I changed it to
write ANAPARAM_ON like on other places and disable config3 write, but in my
tests didn't seem to make any noticeable difference.

diff --git a/drivers/net/wireless/rtl8187_dev.c b/drivers/net/wireless/rtl8187_dev.c
index f981fdb..25d9a0e 100644
--- a/drivers/net/wireless/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl8187_dev.c
@@ -634,8 +634,6 @@ static int rtl8187b_init_hw(struct ieee80211_hw *dev)
 	rtl818x_iowrite32_idx(priv, (__le32 *)0xFFF4, 0, 1);
 	rtl818x_iowrite8_idx(priv, (u8 *)0xFFF8, 0, 1);
 
-	rtl818x_iowrite32(priv, &priv->map->RF_TIMING, 0x00004001);
-
 	rtl818x_iowrite16_idx(priv, (__le16 *)0xFF72, 0x569A, 2);
 
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
@@ -643,14 +641,13 @@ static int rtl8187b_init_hw(struct ieee80211_hw *dev)
 	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
 	reg |= RTL818X_CONFIG3_ANAPARAM_WRITE;
 	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg);
+	rtl818x_iowrite32(priv, &priv->map->ANAPARAM,
+			  RTL8187B_RTL8225_ANAPARAM_ON);
+	reg &= ~RTL818X_CONFIG3_ANAPARAM_WRITE;
+	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg);
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
 			 RTL818X_EEPROM_CMD_NORMAL);
 
-	rtl818x_iowrite16(priv, &priv->map->RFPinsOutput, 0x0480);
-	rtl818x_iowrite16(priv, &priv->map->RFPinsSelect, 0x2488);
-	rtl818x_iowrite16(priv, &priv->map->RFPinsEnable, 0x1FFF);
-	msleep(1100);
-
 	priv->rf->init(dev);
 
 	reg = RTL818X_CMD_TX_ENABLE | RTL818X_CMD_RX_ENABLE;
diff --git a/drivers/net/wireless/rtl8187_rtl8225.c b/drivers/net/wireless/rtl8187_rtl8225.c
index 1bae899..9549e33 100644
--- a/drivers/net/wireless/rtl8187_rtl8225.c
+++ b/drivers/net/wireless/rtl8187_rtl8225.c
@@ -835,6 +835,15 @@ static void rtl8225z2_b_rf_init(struct ieee80211_hw *dev)
 	struct rtl8187_priv *priv = dev->priv;
 	int i;
 
+	rtl818x_iowrite16(priv, &priv->map->RFPinsOutput, 0x0480);
+	rtl818x_iowrite16(priv, &priv->map->RFPinsSelect, 0x2488);
+	rtl818x_iowrite16(priv, &priv->map->RFPinsEnable, 0x1FFF);
+	msleep(200);
+	rtl818x_iowrite32(priv, &priv->map->RF_TIMING, 0x00004001);
+	rtl818x_iowrite32(priv, &priv->map->RF_PARA, 0x00100044);
+
+	rtl818x_iowrite16(priv, &priv->map->RFPinsEnable, 0x1FFF);
+
 	rtl8225_write(dev, 0x0, 0x0B7); msleep(1);
 	rtl8225_write(dev, 0x1, 0xEE0); msleep(1);
 	rtl8225_write(dev, 0x2, 0x44D); msleep(1);
@@ -850,25 +859,36 @@ static void rtl8225z2_b_rf_init(struct ieee80211_hw *dev)
 	rtl8225_write(dev, 0xc, 0x850); msleep(1);
 	rtl8225_write(dev, 0xd, 0xCDF); msleep(1);
 	rtl8225_write(dev, 0xe, 0x02B); msleep(1);
-	rtl8225_write(dev, 0xf, 0x114); msleep(1);
+	rtl8225_write(dev, 0xf, 0x114); msleep(100);
 
-	rtl8225_write(dev, 0x0, 0x1B7); msleep(1);
+	if (!(rtl8225_read(dev, 6) & (1 << 7))) {
+		rtl8225_write(dev, 0x02, 0x0C4D);
+		msleep(200);
+		rtl8225_write(dev, 0x02, 0x044D);
+		msleep(100);
+		/* TODO: detect calibration failure? */
+	}
+
+	rtl8225_write(dev, 0x0, 0x1B7);
+	rtl8225_write(dev, 0x3, 0x002);
+	rtl8225_write(dev, 0x5, 0x004);
 
 	for (i = 0; i < ARRAY_SIZE(rtl8225z2_rxgain); i++) {
-		rtl8225_write(dev, 0x1, i + 1); msleep(1);
-		rtl8225_write(dev, 0x2, rtl8225z2_rxgain[i]); msleep(1);
+		rtl8225_write(dev, 0x1, i + 1);
+		rtl8225_write(dev, 0x2, rtl8225z2_rxgain[i]);
 	}
 
-	rtl8225_write(dev, 0x3, 0x080); msleep(1);
-	rtl8225_write(dev, 0x5, 0x004); msleep(1);
-	rtl8225_write(dev, 0x0, 0x0B7); msleep(1);
-	msleep(3000);
+	rtl8225_write(dev, 0x0, 0x0B7);
+	msleep(100);
+	rtl8225_write(dev, 0x2, 0xC4D);
+	msleep(200);
+	rtl8225_write(dev, 0x2, 0x44D);
+	msleep(100);
 
-	rtl8225_write(dev, 0x2, 0xC4D); msleep(1);
-	msleep(2000);
+	rtl8225_write(dev, 0x00, 0x2BF);
+	rtl8225_write(dev, 0xFF, 0xFFFF);
 
-	rtl8225_write(dev, 0x2, 0x44D); msleep(1);
-	rtl8225_write(dev, 0x0, 0x2BF); msleep(1);
+	rtl818x_iowrite16(priv, &priv->map->RFPinsEnable, 0x1FFF);
 
 	rtl818x_iowrite8(priv, &priv->map->TX_GAIN_CCK, 0x03);
 	rtl818x_iowrite8(priv, &priv->map->TX_GAIN_OFDM, 0x07);


-- 
[]'s
Herton
