Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:45665 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967AbaCZUA4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2014 16:00:56 -0400
Received: by mail-ee0-f47.google.com with SMTP id b15so2076613eek.34
        for <linux-wireless@vger.kernel.org>; Wed, 26 Mar 2014 13:00:55 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: andrea.merello@gmail.com, linux-wireless@vger.kernel.org,
	Larry.Finger@lwfinger.net, bernhard@schiffner-limbach.de,
	dan.carpenter@oracle.com
Subject: [PATCH 12/20] rtl8180: introduce functions for setting ANAPARAM 2 and 3 params
Date: Wed, 26 Mar 2014 21:02:05 +0100
Message-Id: <1395864125-4830-1-git-send-email-andrea.merello@gmail.com> (sfid-20140326_210105_208225_84AD7B6D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rtl8180 has one register for analog converters setting ,rtl8185 has
two and rtl8187se has three.
Setting those registers require more than a simple write, and for
one of them a function is already provided.
This patch introduces functions for the other two.
rtl8187se will use them. rtl8185 doesen't yet, but should

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c     | 40 ++++++++++++++++++++++++++
 drivers/net/wireless/rtl818x/rtl8180/rtl8180.h |  1 +
 drivers/net/wireless/rtl818x/rtl8180/rtl8225.c |  1 +
 3 files changed, 42 insertions(+)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 740a583..a3b67e6 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -523,6 +523,46 @@ static void rtl8180_tx(struct ieee80211_hw *dev,
 	}
 }
 
+static void rtl8180_set_anaparam3(struct rtl8180_priv *priv, u16 anaparam3)
+{
+	u8 reg;
+
+	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
+			 RTL818X_EEPROM_CMD_CONFIG);
+
+	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
+	rtl818x_iowrite8(priv, &priv->map->CONFIG3,
+		 reg | RTL818X_CONFIG3_ANAPARAM_WRITE);
+
+	rtl818x_iowrite16(priv, &priv->map->ANAPARAM3, anaparam3);
+
+	rtl818x_iowrite8(priv, &priv->map->CONFIG3,
+		 reg & ~RTL818X_CONFIG3_ANAPARAM_WRITE);
+
+	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
+			 RTL818X_EEPROM_CMD_NORMAL);
+}
+
+void rtl8180_set_anaparam2(struct rtl8180_priv *priv, u32 anaparam2)
+{
+	u8 reg;
+
+	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
+			 RTL818X_EEPROM_CMD_CONFIG);
+
+	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
+	rtl818x_iowrite8(priv, &priv->map->CONFIG3,
+		 reg | RTL818X_CONFIG3_ANAPARAM_WRITE);
+
+	rtl818x_iowrite32(priv, &priv->map->ANAPARAM2, anaparam2);
+
+	rtl818x_iowrite8(priv, &priv->map->CONFIG3,
+		 reg & ~RTL818X_CONFIG3_ANAPARAM_WRITE);
+
+	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
+			 RTL818X_EEPROM_CMD_NORMAL);
+}
+
 void rtl8180_set_anaparam(struct rtl8180_priv *priv, u32 anaparam)
 {
 	u8 reg;
diff --git a/drivers/net/wireless/rtl818x/rtl8180/rtl8180.h b/drivers/net/wireless/rtl818x/rtl8180/rtl8180.h
index d8f92de..0ef3fc7 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/rtl8180.h
+++ b/drivers/net/wireless/rtl818x/rtl8180/rtl8180.h
@@ -145,6 +145,7 @@ struct rtl8180_priv {
 
 void rtl8180_write_phy(struct ieee80211_hw *dev, u8 addr, u32 data);
 void rtl8180_set_anaparam(struct rtl8180_priv *priv, u32 anaparam);
+void rtl8180_set_anaparam2(struct rtl8180_priv *priv, u32 anaparam2);
 
 static inline u8 rtl818x_ioread8(struct rtl8180_priv *priv, u8 __iomem *addr)
 {
diff --git a/drivers/net/wireless/rtl818x/rtl8180/rtl8225.c b/drivers/net/wireless/rtl818x/rtl8180/rtl8225.c
index 1c0fe23..9bda5bc 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/rtl8225.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/rtl8225.c
@@ -282,6 +282,7 @@ static void rtl8225_rf_set_tx_power(struct ieee80211_hw *dev, int channel)
 
 	msleep(1); /* FIXME: optional? */
 
+	/* TODO: use set_anaparam2 dev.c_func*/
 	/* anaparam2 on */
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
 	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
-- 
1.8.3.2

