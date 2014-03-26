Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:41518 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756281AbaCZUAK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2014 16:00:10 -0400
Received: by mail-ee0-f45.google.com with SMTP id d17so2059855eek.18
        for <linux-wireless@vger.kernel.org>; Wed, 26 Mar 2014 13:00:09 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: andrea.merello@gmail.com, linux-wireless@vger.kernel.org,
	Larry.Finger@lwfinger.net, bernhard@schiffner-limbach.de,
	dan.carpenter@oracle.com
Subject: [PATCH 10/20] rtl8180: config carbus register for rtl8187se
Date: Wed, 26 Mar 2014 21:01:19 +0100
Message-Id: <1395864079-4742-1-git-send-email-andrea.merello@gmail.com> (sfid-20140326_210028_204697_78039086)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

configuration of carbus-related registers is different for
rtl8187se.
Introduce a dedicated function that does it for all cards in the
proper way

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index eb86ede..06d3c30 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -601,6 +601,26 @@ static void rtl8180_conf_basic_rates(struct ieee80211_hw *dev,
 	}
 }
 
+static void rtl8180_config_cardbus(struct ieee80211_hw *dev)
+{
+	struct rtl8180_priv *priv = dev->priv;
+	u16 reg16;
+	u8 reg8;
+
+	reg8 = rtl818x_ioread8(priv, &priv->map->CONFIG3);
+	reg8 |= 1 << 1;
+	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg8);
+
+	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8187SE) {
+		rtl818x_iowrite16(priv, FEMR_SE, 0xffff);
+	} else {
+		reg16 = rtl818x_ioread16(priv, &priv->map->FEMR);
+			reg16 |= (1 << 15) | (1 << 14) | (1 << 4);
+		rtl818x_iowrite16(priv, &priv->map->FEMR, reg16);
+	}
+
+}
+
 static int rtl8180_init_hw(struct ieee80211_hw *dev)
 {
 	struct rtl8180_priv *priv = dev->priv;
@@ -632,13 +652,7 @@ static int rtl8180_init_hw(struct ieee80211_hw *dev)
 	msleep(200);
 
 	if (rtl818x_ioread8(priv, &priv->map->CONFIG3) & (1 << 3)) {
-		/* For cardbus */
-		reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
-		reg |= 1 << 1;
-		rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg);
-		reg = rtl818x_ioread16(priv, &priv->map->FEMR);
-		reg |= (1 << 15) | (1 << 14) | (1 << 4);
-		rtl818x_iowrite16(priv, &priv->map->FEMR, reg);
+		rtl8180_config_cardbus(dev);
 	}
 
 	rtl818x_iowrite8(priv, &priv->map->MSR, 0);
-- 
1.8.3.2

