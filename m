Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:58101 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbYGIQQO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 12:16:14 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] rtl8187: use different ANAPARAM*_OFF values for 8187B
Date: Wed, 9 Jul 2008 13:16:19 -0300
Cc: "Hin-Tak Leung" <htl10@users.sourceforge.net>, proski@gnu.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200807091316.20334.herton@mandriva.com.br> (sfid-20080709_181618_168790_4466B68D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For RTL8187B it seems we need special values too for ANAPARAM*_OFF
values (and not use RTL8187L ones). The ANAPARAM*_OFF values used are
the stock ones read from the hardware after a cold boot.

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Signed-off-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

diff --git a/drivers/net/wireless/rtl8187_dev.c 
b/drivers/net/wireless/rtl8187_dev.c
index 33527e5..f981fdb 100644
--- a/drivers/net/wireless/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl8187_dev.c
@@ -430,8 +430,10 @@ static int rtl8187_init_hw(struct ieee80211_hw *dev)
 	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
 	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg |
 			 RTL818X_CONFIG3_ANAPARAM_WRITE);
-	rtl818x_iowrite32(priv, &priv->map->ANAPARAM, RTL8225_ANAPARAM_ON);
-	rtl818x_iowrite32(priv, &priv->map->ANAPARAM2, RTL8225_ANAPARAM2_ON);
+	rtl818x_iowrite32(priv, &priv->map->ANAPARAM,
+			  RTL8187_RTL8225_ANAPARAM_ON);
+	rtl818x_iowrite32(priv, &priv->map->ANAPARAM2,
+			  RTL8187_RTL8225_ANAPARAM2_ON);
 	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg &
 			 ~RTL818X_CONFIG3_ANAPARAM_WRITE);
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
@@ -453,8 +455,10 @@ static int rtl8187_init_hw(struct ieee80211_hw *dev)
 	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
 	rtl818x_iowrite8(priv, &priv->map->CONFIG3,
 			reg | RTL818X_CONFIG3_ANAPARAM_WRITE);
-	rtl818x_iowrite32(priv, &priv->map->ANAPARAM, RTL8225_ANAPARAM_ON);
-	rtl818x_iowrite32(priv, &priv->map->ANAPARAM2, RTL8225_ANAPARAM2_ON);
+	rtl818x_iowrite32(priv, &priv->map->ANAPARAM,
+			  RTL8187_RTL8225_ANAPARAM_ON);
+	rtl818x_iowrite32(priv, &priv->map->ANAPARAM2,
+			  RTL8187_RTL8225_ANAPARAM2_ON);
 	rtl818x_iowrite8(priv, &priv->map->CONFIG3,
 			reg & ~RTL818X_CONFIG3_ANAPARAM_WRITE);
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
@@ -566,9 +570,12 @@ static int rtl8187b_init_hw(struct ieee80211_hw *dev)
 	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
 	reg |= RTL818X_CONFIG3_ANAPARAM_WRITE | RTL818X_CONFIG3_GNT_SELECT;
 	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg);
-	rtl818x_iowrite32(priv, &priv->map->ANAPARAM2, 0x727f3f52);
-	rtl818x_iowrite32(priv, &priv->map->ANAPARAM, 0x45090658);
-	rtl818x_iowrite8(priv, &priv->map->ANAPARAM3, 0);
+	rtl818x_iowrite32(priv, &priv->map->ANAPARAM2,
+			  RTL8187B_RTL8225_ANAPARAM2_ON);
+	rtl818x_iowrite32(priv, &priv->map->ANAPARAM,
+			  RTL8187B_RTL8225_ANAPARAM_ON);
+	rtl818x_iowrite8(priv, &priv->map->ANAPARAM3,
+			 RTL8187B_RTL8225_ANAPARAM3_ON);
 
 	rtl818x_iowrite8(priv, (u8 *)0xFF61, 0x10);
 	reg = rtl818x_ioread8(priv, (u8 *)0xFF62);
diff --git a/drivers/net/wireless/rtl8187_rtl8225.c 
b/drivers/net/wireless/rtl8187_rtl8225.c
index 1e059de..1bae899 100644
--- a/drivers/net/wireless/rtl8187_rtl8225.c
+++ b/drivers/net/wireless/rtl8187_rtl8225.c
@@ -307,7 +307,8 @@ static void rtl8225_rf_set_tx_power(struct ieee80211_hw 
*dev, int channel)
 	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
 	rtl818x_iowrite8(priv, &priv->map->CONFIG3,
 			reg | RTL818X_CONFIG3_ANAPARAM_WRITE);
-	rtl818x_iowrite32(priv, &priv->map->ANAPARAM2, RTL8225_ANAPARAM2_ON);
+	rtl818x_iowrite32(priv, &priv->map->ANAPARAM2,
+			  RTL8187_RTL8225_ANAPARAM2_ON);
 	rtl818x_iowrite8(priv, &priv->map->CONFIG3,
 			reg & ~RTL818X_CONFIG3_ANAPARAM_WRITE);
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
@@ -560,7 +561,8 @@ static void rtl8225z2_rf_set_tx_power(struct ieee80211_hw 
*dev, int channel)
 	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
 	rtl818x_iowrite8(priv, &priv->map->CONFIG3,
 			reg | RTL818X_CONFIG3_ANAPARAM_WRITE);
-	rtl818x_iowrite32(priv, &priv->map->ANAPARAM2, RTL8225_ANAPARAM2_ON);
+	rtl818x_iowrite32(priv, &priv->map->ANAPARAM2,
+			  RTL8187_RTL8225_ANAPARAM2_ON);
 	rtl818x_iowrite8(priv, &priv->map->CONFIG3,
 			reg & ~RTL818X_CONFIG3_ANAPARAM_WRITE);
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
@@ -913,8 +915,19 @@ static void rtl8225_rf_stop(struct ieee80211_hw *dev)
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
 	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
 	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg | 
RTL818X_CONFIG3_ANAPARAM_WRITE);
-	rtl818x_iowrite32(priv, &priv->map->ANAPARAM2, RTL8225_ANAPARAM2_OFF);
-	rtl818x_iowrite32(priv, &priv->map->ANAPARAM, RTL8225_ANAPARAM_OFF);
+	if (!priv->is_rtl8187b) {
+		rtl818x_iowrite32(priv, &priv->map->ANAPARAM2,
+				  RTL8187_RTL8225_ANAPARAM2_OFF);
+		rtl818x_iowrite32(priv, &priv->map->ANAPARAM,
+				  RTL8187_RTL8225_ANAPARAM_OFF);
+	} else {
+		rtl818x_iowrite32(priv, &priv->map->ANAPARAM2,
+				  RTL8187B_RTL8225_ANAPARAM2_OFF);
+		rtl818x_iowrite32(priv, &priv->map->ANAPARAM,
+				  RTL8187B_RTL8225_ANAPARAM_OFF);
+		rtl818x_iowrite8(priv, &priv->map->ANAPARAM3,
+				  RTL8187B_RTL8225_ANAPARAM3_OFF);
+	}
 	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg & 
~RTL818X_CONFIG3_ANAPARAM_WRITE);
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
 }
diff --git a/drivers/net/wireless/rtl8187_rtl8225.h 
b/drivers/net/wireless/rtl8187_rtl8225.h
index d39ed02..20c5b6e 100644
--- a/drivers/net/wireless/rtl8187_rtl8225.h
+++ b/drivers/net/wireless/rtl8187_rtl8225.h
@@ -15,10 +15,17 @@
 #ifndef RTL8187_RTL8225_H
 #define RTL8187_RTL8225_H
 
-#define RTL8225_ANAPARAM_ON	0xa0000a59
-#define RTL8225_ANAPARAM2_ON	0x860c7312
-#define RTL8225_ANAPARAM_OFF	0xa00beb59
-#define RTL8225_ANAPARAM2_OFF	0x840dec11
+#define RTL8187_RTL8225_ANAPARAM_ON	0xa0000a59
+#define RTL8187_RTL8225_ANAPARAM2_ON	0x860c7312
+#define RTL8187_RTL8225_ANAPARAM_OFF	0xa00beb59
+#define RTL8187_RTL8225_ANAPARAM2_OFF	0x840dec11
+
+#define RTL8187B_RTL8225_ANAPARAM_ON	0x45090658
+#define RTL8187B_RTL8225_ANAPARAM2_ON	0x727f3f52
+#define RTL8187B_RTL8225_ANAPARAM3_ON	0x00
+#define RTL8187B_RTL8225_ANAPARAM_OFF	0x55480658
+#define RTL8187B_RTL8225_ANAPARAM2_OFF	0x72003f50
+#define RTL8187B_RTL8225_ANAPARAM3_OFF	0x00
 
 const struct rtl818x_rf_ops * rtl8187_detect_rf(struct ieee80211_hw *);
 
-- 
1.5.6

