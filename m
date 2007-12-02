Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:32739 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750774AbXLBWLO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Dec 2007 17:11:14 -0500
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 4/8] rtl8180: Add rtl8180_set_anaparam
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Andrea Merello <andreamrl@tiscali.it>
Date: Sun, 02 Dec 2007 17:17:51 -0500
Message-ID: <20071202221751.7347.75840.stgit@tetra.sourmilk.net> (sfid-20071202_221125_988675_13043851)
In-Reply-To: <20071202221751.7347.54891.stgit@tetra.sourmilk.net>
References: <20071202221751.7347.54891.stgit@tetra.sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrea Merello <andreamrl@tiscali.it>

This piece of code is used everywhere, so pull it into a function.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
Signed-off-by: Andrea Merello <andreamrl@tiscali.it>
---

 drivers/net/wireless/rtl8180.h         |    1 +
 drivers/net/wireless/rtl8180_dev.c     |   26 ++++++++++++++++----------
 drivers/net/wireless/rtl8180_rtl8225.c |   16 ++--------------
 3 files changed, 19 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/rtl8180.h b/drivers/net/wireless/rtl8180.h
index 4a5b44b..28431ac 100644
--- a/drivers/net/wireless/rtl8180.h
+++ b/drivers/net/wireless/rtl8180.h
@@ -101,6 +101,7 @@ struct rtl8180_priv {
 };
 
 void rtl8180_write_phy(struct ieee80211_hw *dev, u8 addr, u32 data);
+void rtl8180_set_anaparam(struct rtl8180_priv *priv, u32 anaparam);
 
 static inline u8 rtl818x_ioread8(struct rtl8180_priv *priv, u8 __iomem *addr)
 {
diff --git a/drivers/net/wireless/rtl8180_dev.c b/drivers/net/wireless/rtl8180_dev.c
index a2a6791..54f9c31 100644
--- a/drivers/net/wireless/rtl8180_dev.c
+++ b/drivers/net/wireless/rtl8180_dev.c
@@ -243,6 +243,20 @@ static int rtl8180_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
 	return 0;
 }
 
+void rtl8180_set_anaparam(struct rtl8180_priv *priv, u32 anaparam)
+{
+	u8 reg;
+
+	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
+	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
+	rtl818x_iowrite8(priv, &priv->map->CONFIG3,
+		 reg | RTL818X_CONFIG3_ANAPARAM_WRITE);
+	rtl818x_iowrite32(priv, &priv->map->ANAPARAM, anaparam);
+	rtl818x_iowrite8(priv, &priv->map->CONFIG3,
+		 reg & ~RTL818X_CONFIG3_ANAPARAM_WRITE);
+	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
+}
+
 static int rtl8180_init_hw(struct ieee80211_hw *dev)
 {
 	struct rtl8180_priv *priv = dev->priv;
@@ -285,16 +299,8 @@ static int rtl8180_init_hw(struct ieee80211_hw *dev)
 
 	rtl818x_iowrite8(priv, &priv->map->MSR, 0);
 
-	if (!priv->r8185) {
-		rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
-		reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
-		rtl818x_iowrite8(priv, &priv->map->CONFIG3,
-				 reg | RTL818X_CONFIG3_ANAPARAM_WRITE);
-		rtl818x_iowrite32(priv, &priv->map->ANAPARAM, priv->anaparam);
-		rtl818x_iowrite8(priv, &priv->map->CONFIG3,
-				 reg & ~RTL818X_CONFIG3_ANAPARAM_WRITE);
-		rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
-	}
+	if (!priv->r8185)
+		rtl8180_set_anaparam(priv, priv->anaparam);
 
 	rtl818x_iowrite32(priv, &priv->map->RDSAR, priv->rx_ring_dma);
 	rtl818x_iowrite32(priv, &priv->map->TBDA, priv->tx_ring[3].dma);
diff --git a/drivers/net/wireless/rtl8180_rtl8225.c b/drivers/net/wireless/rtl8180_rtl8225.c
index 6fb0659..3bcdb9e 100644
--- a/drivers/net/wireless/rtl8180_rtl8225.c
+++ b/drivers/net/wireless/rtl8180_rtl8225.c
@@ -322,14 +322,8 @@ void rtl8225_rf_init(struct ieee80211_hw *dev)
 {
 	struct rtl8180_priv *priv = dev->priv;
 	int i;
-	u8 reg;
 
-	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
-	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
-	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg | RTL818X_CONFIG3_ANAPARAM_WRITE);
-	rtl818x_iowrite32(priv, &priv->map->ANAPARAM, RTL8225_ANAPARAM_ON);
-	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg & ~RTL818X_CONFIG3_ANAPARAM_WRITE);
-	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
+	rtl8180_set_anaparam(priv, RTL8225_ANAPARAM_ON);
 
 	/* host_pci_init */
 	rtl818x_iowrite16(priv, &priv->map->RFPinsOutput, 0x0480);
@@ -561,14 +555,8 @@ void rtl8225z2_rf_init(struct ieee80211_hw *dev)
 {
 	struct rtl8180_priv *priv = dev->priv;
 	int i;
-	u8 reg;
 
-	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
-	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
-	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg | RTL818X_CONFIG3_ANAPARAM_WRITE);
-	rtl818x_iowrite32(priv, &priv->map->ANAPARAM, RTL8225_ANAPARAM_ON);
-	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg & ~RTL818X_CONFIG3_ANAPARAM_WRITE);
-	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
+	rtl8180_set_anaparam(priv, RTL8225_ANAPARAM_ON);
 
 	/* host_pci_init */
 	rtl818x_iowrite16(priv, &priv->map->RFPinsOutput, 0x0480);


