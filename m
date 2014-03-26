Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48315 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369AbaCZT7P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2014 15:59:15 -0400
Received: by mail-ee0-f46.google.com with SMTP id t10so2036851eei.5
        for <linux-wireless@vger.kernel.org>; Wed, 26 Mar 2014 12:59:14 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: andrea.merello@gmail.com, linux-wireless@vger.kernel.org,
	Larry.Finger@lwfinger.net, bernhard@schiffner-limbach.de,
	dan.carpenter@oracle.com
Subject: [PATCH 07/20] rtl8180: introduce functions to enable/disable ints and add support for rtl8187se
Date: Wed, 26 Mar 2014 21:00:24 +0100
Message-Id: <1395864024-4619-1-git-send-email-andrea.merello@gmail.com> (sfid-20140326_205922_178221_9029584B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch introduces two dedicated functions for enabling and
disabling ints.
Support for rtl8187se is also added to them

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c | 36 +++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 242a4bc..92b6d53 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -463,6 +463,36 @@ void rtl8180_set_anaparam(struct rtl8180_priv *priv, u32 anaparam)
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
 }
 
+static void rtl8180_int_enable(struct ieee80211_hw *dev)
+{
+	struct rtl8180_priv *priv = dev->priv;
+
+	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8187SE) {
+		rtl818x_iowrite32(priv, &priv->map->IMR, IMR_TMGDOK |
+			  IMR_TBDER | IMR_THPDER |
+			  IMR_THPDER | IMR_THPDOK |
+			  IMR_TVODER | IMR_TVODOK |
+			  IMR_TVIDER | IMR_TVIDOK |
+			  IMR_TBEDER | IMR_TBEDOK |
+			  IMR_TBKDER | IMR_TBKDOK |
+			  IMR_RDU | IMR_RER |
+			  IMR_ROK | IMR_RQOSOK);
+	} else {
+		rtl818x_iowrite16(priv, &priv->map->INT_MASK, 0xFFFF);
+	}
+}
+
+static void rtl8180_int_disable(struct ieee80211_hw *dev)
+{
+	struct rtl8180_priv *priv = dev->priv;
+
+	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8187SE) {
+		rtl818x_iowrite32(priv, &priv->map->IMR, 0);
+	} else {
+		rtl818x_iowrite16(priv, &priv->map->INT_MASK, 0);
+	}
+}
+
 static void rtl8180_conf_basic_rates(struct ieee80211_hw *dev,
 			    u32 rates_mask)
 {
@@ -507,7 +537,7 @@ static int rtl8180_init_hw(struct ieee80211_hw *dev)
 	msleep(10);
 
 	/* reset */
-	rtl818x_iowrite16(priv, &priv->map->INT_MASK, 0);
+	rtl8180_int_disable(dev);
 	rtl818x_ioread8(priv, &priv->map->CMD);
 
 	reg = rtl818x_ioread8(priv, &priv->map->CMD);
@@ -747,7 +777,7 @@ static int rtl8180_start(struct ieee80211_hw *dev)
 		goto err_free_rings;
 	}
 
-	rtl818x_iowrite16(priv, &priv->map->INT_MASK, 0xFFFF);
+	rtl8180_int_enable(dev);
 
 	rtl818x_iowrite32(priv, &priv->map->MAR[0], ~0);
 	rtl818x_iowrite32(priv, &priv->map->MAR[1], ~0);
@@ -840,7 +870,7 @@ static void rtl8180_stop(struct ieee80211_hw *dev)
 	u8 reg;
 	int i;
 
-	rtl818x_iowrite16(priv, &priv->map->INT_MASK, 0);
+	rtl8180_int_disable(dev);
 
 	reg = rtl818x_ioread8(priv, &priv->map->CMD);
 	reg &= ~RTL818X_CMD_TX_ENABLE;
-- 
1.8.3.2

