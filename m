Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:53568 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075AbaCZUBh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2014 16:01:37 -0400
Received: by mail-ee0-f49.google.com with SMTP id c41so2075798eek.36
        for <linux-wireless@vger.kernel.org>; Wed, 26 Mar 2014 13:01:36 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: andrea.merello@gmail.com, linux-wireless@vger.kernel.org,
	Larry.Finger@lwfinger.net, bernhard@schiffner-limbach.de,
	dan.carpenter@oracle.com
Subject: [PATCH 14/20] rtl8180: add rtl8187se HW initialization
Date: Wed, 26 Mar 2014 21:02:46 +0100
Message-Id: <1395864166-4943-1-git-send-email-andrea.merello@gmail.com> (sfid-20140326_210149_472356_4A9A1EF6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds few functions that initializes extra stuff that
is present only in rtl8187se HW, and it modify the existing
HW initialization function where necessary

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c | 168 +++++++++++++++++++++++++++--
 1 file changed, 159 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 1c4a148..8061852 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -578,6 +578,75 @@ void rtl8180_set_anaparam(struct rtl8180_priv *priv, u32 anaparam)
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
 }
 
+static void rtl8187se_mac_config(struct ieee80211_hw *dev)
+{
+	struct rtl8180_priv *priv = dev->priv;
+	u8 reg;
+
+	rtl818x_iowrite32(priv, REG_ADDR4(0x1F0), 0);
+	rtl818x_ioread32(priv, REG_ADDR4(0x1F0));
+	rtl818x_iowrite32(priv, REG_ADDR4(0x1F4), 0);
+	rtl818x_ioread32(priv, REG_ADDR4(0x1F4));
+	rtl818x_iowrite8(priv, REG_ADDR1(0x1F8), 0);
+	rtl818x_ioread8(priv, REG_ADDR1(0x1F8));
+	/* Enable DA10 TX power saving */
+	reg = rtl818x_ioread8(priv, &priv->map->PHY_PR);
+	rtl818x_iowrite8(priv, &priv->map->PHY_PR, reg | 0x04);
+	/* Power */
+	rtl818x_iowrite16(priv, PI_DATA_REG, 0x1000);
+	rtl818x_iowrite16(priv, SI_DATA_REG, 0x1000);
+	/* AFE - default to power ON */
+	rtl818x_iowrite16(priv, REG_ADDR2(0x370), 0x0560);
+	rtl818x_iowrite16(priv, REG_ADDR2(0x372), 0x0560);
+	rtl818x_iowrite16(priv, REG_ADDR2(0x374), 0x0DA4);
+	rtl818x_iowrite16(priv, REG_ADDR2(0x376), 0x0DA4);
+	rtl818x_iowrite16(priv, REG_ADDR2(0x378), 0x0560);
+	rtl818x_iowrite16(priv, REG_ADDR2(0x37A), 0x0560);
+	rtl818x_iowrite16(priv, REG_ADDR2(0x37C), 0x00EC);
+	rtl818x_iowrite16(priv, REG_ADDR2(0x37E), 0x00EC);
+	rtl818x_iowrite8(priv, REG_ADDR1(0x24E), 0x01);
+	/* unknown, needed for suspend to RAM resume */
+	rtl818x_iowrite8(priv, REG_ADDR1(0x0A), 0x72);
+}
+
+static void rtl8187se_set_antenna_config(struct ieee80211_hw *dev, u8 def_ant,
+					 bool diversity)
+{
+	struct rtl8180_priv *priv = dev->priv;
+
+	rtl8225_write_phy_cck(dev, 0x0C, 0x09);
+	if (diversity) {
+		if (def_ant == 1) {
+			rtl818x_iowrite8(priv, &priv->map->TX_ANTENNA, 0x00);
+			rtl8225_write_phy_cck(dev, 0x11, 0xBB);
+			rtl8225_write_phy_cck(dev, 0x01, 0xC7);
+			rtl8225_write_phy_ofdm(dev, 0x0D, 0x54);
+			rtl8225_write_phy_ofdm(dev, 0x18, 0xB2);
+		} else { /* main antenna */
+			rtl818x_iowrite8(priv, &priv->map->TX_ANTENNA, 0x03);
+			rtl8225_write_phy_cck(dev, 0x11, 0x9B);
+			rtl8225_write_phy_cck(dev, 0x01, 0xC7);
+			rtl8225_write_phy_ofdm(dev, 0x0D, 0x5C);
+			rtl8225_write_phy_ofdm(dev, 0x18, 0xB2);
+		}
+	} else { /* disable antenna diversity */
+		if (def_ant == 1) {
+			rtl818x_iowrite8(priv, &priv->map->TX_ANTENNA, 0x00);
+			rtl8225_write_phy_cck(dev, 0x11, 0xBB);
+			rtl8225_write_phy_cck(dev, 0x01, 0x47);
+			rtl8225_write_phy_ofdm(dev, 0x0D, 0x54);
+			rtl8225_write_phy_ofdm(dev, 0x18, 0x32);
+		} else { /* main antenna */
+			rtl818x_iowrite8(priv, &priv->map->TX_ANTENNA, 0x03);
+			rtl8225_write_phy_cck(dev, 0x11, 0x9B);
+			rtl8225_write_phy_cck(dev, 0x01, 0x47);
+			rtl8225_write_phy_ofdm(dev, 0x0D, 0x5C);
+			rtl8225_write_phy_ofdm(dev, 0x18, 0x32);
+		}
+	}
+	/* priv->curr_ant = def_ant; */
+}
+
 static void rtl8180_int_enable(struct ieee80211_hw *dev)
 {
 	struct rtl8180_priv *priv = dev->priv;
@@ -666,6 +735,7 @@ static int rtl8180_init_hw(struct ieee80211_hw *dev)
 {
 	struct rtl8180_priv *priv = dev->priv;
 	u16 reg;
+	u32 reg32;
 
 	rtl818x_iowrite8(priv, &priv->map->CMD, 0);
 	rtl818x_ioread8(priv, &priv->map->CMD);
@@ -696,14 +766,36 @@ static int rtl8180_init_hw(struct ieee80211_hw *dev)
 		rtl8180_config_cardbus(dev);
 	}
 
-	rtl818x_iowrite8(priv, &priv->map->MSR, 0);
+	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8187SE)
+		rtl818x_iowrite8(priv, &priv->map->MSR, RTL818X_MSR_ENEDCA);
+	else
+		rtl818x_iowrite8(priv, &priv->map->MSR, 0);
 
 	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8180)
 		rtl8180_set_anaparam(priv, priv->anaparam);
 
 	rtl818x_iowrite32(priv, &priv->map->RDSAR, priv->rx_ring_dma);
-	rtl818x_iowrite32(priv, &priv->map->TBDA, priv->tx_ring[1].dma);
-	rtl818x_iowrite32(priv, &priv->map->TLPDA, priv->tx_ring[0].dma);
+	/* mac80211 queue have higher prio for lower index. The last queue
+	 * (that mac80211 is not aware of) is reserved for beacons (and have
+	 * the highest priority on the NIC)
+	 */
+	if (priv->chip_family != RTL818X_CHIP_FAMILY_RTL8187SE) {
+		rtl818x_iowrite32(priv, &priv->map->TBDA,
+				  priv->tx_ring[1].dma);
+		rtl818x_iowrite32(priv, &priv->map->TLPDA,
+				  priv->tx_ring[0].dma);
+	} else {
+		rtl818x_iowrite32(priv, &priv->map->TBDA,
+				  priv->tx_ring[4].dma);
+		rtl818x_iowrite32(priv, &priv->map->TVODA,
+				  priv->tx_ring[0].dma);
+		rtl818x_iowrite32(priv, &priv->map->TVIDA,
+				  priv->tx_ring[1].dma);
+		rtl818x_iowrite32(priv, &priv->map->TBEDA,
+				  priv->tx_ring[2].dma);
+		rtl818x_iowrite32(priv, &priv->map->TBKDA,
+				  priv->tx_ring[3].dma);
+	}
 
 	/* TODO: necessary? specs indicate not */
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
@@ -724,7 +816,14 @@ static int rtl8180_init_hw(struct ieee80211_hw *dev)
 	if (priv->chip_family != RTL818X_CHIP_FAMILY_RTL8180) {
 		rtl818x_iowrite8(priv, &priv->map->WPA_CONF, 0);
 		rtl818x_iowrite8(priv, &priv->map->RATE_FALLBACK, 0x81);
+	} else {
+		rtl818x_iowrite8(priv, &priv->map->SECURITY, 0);
+
+		rtl818x_iowrite8(priv, &priv->map->PHY_DELAY, 0x6);
+		rtl818x_iowrite8(priv, &priv->map->CARRIER_SENSE_COUNTER, 0x4C);
+	}
 
+	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8185) {
 		/* TODO: set ClkRun enable? necessary? */
 		reg = rtl818x_ioread8(priv, &priv->map->GP_ENABLE);
 		rtl818x_iowrite8(priv, &priv->map->GP_ENABLE, reg & ~(1 << 6));
@@ -732,11 +831,55 @@ static int rtl8180_init_hw(struct ieee80211_hw *dev)
 		reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
 		rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg | (1 << 2));
 		rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
-	} else {
-		rtl818x_iowrite8(priv, &priv->map->SECURITY, 0);
+	}
 
-		rtl818x_iowrite8(priv, &priv->map->PHY_DELAY, 0x6);
-		rtl818x_iowrite8(priv, &priv->map->CARRIER_SENSE_COUNTER, 0x4C);
+	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8187SE) {
+
+		/* the set auto rate fallback bitmask from 1M to 54 Mb/s */
+		rtl818x_iowrite16(priv, ARFR, 0xFFF);
+		rtl818x_ioread16(priv, ARFR);
+
+		/* stop unused queus (no dma alloc) */
+		rtl818x_iowrite8(priv, &priv->map->TPPOLL_STOP,
+			       RTL818x_TPPOLL_STOP_MG | RTL818x_TPPOLL_STOP_HI);
+
+		rtl818x_iowrite8(priv, &priv->map->ACM_CONTROL, 0x00);
+		rtl818x_iowrite16(priv, &priv->map->TID_AC_MAP, 0xFA50);
+
+		rtl818x_iowrite16(priv, &priv->map->INT_MIG, 0);
+
+		/* some black magic here.. */
+		rtl8187se_mac_config(dev);
+
+		rtl818x_iowrite16(priv, RFSW_CTRL, 0x569A);
+		rtl818x_ioread16(priv, RFSW_CTRL);
+
+		rtl8180_set_anaparam(priv, RTL8225SE_ANAPARAM_ON);
+		rtl8180_set_anaparam2(priv, RTL8225SE_ANAPARAM2_ON);
+		rtl8180_set_anaparam3(priv, RTL8225SE_ANAPARAM3);
+
+
+		rtl818x_iowrite8(priv, &priv->map->CONFIG5,
+			    rtl818x_ioread8(priv, &priv->map->CONFIG5) & 0x7F);
+
+		/*probably this switch led on */
+		rtl818x_iowrite8(priv, &priv->map->PGSELECT,
+			    rtl818x_ioread8(priv, &priv->map->PGSELECT) | 0x08);
+
+		rtl818x_iowrite16(priv, &priv->map->RFPinsOutput, 0x0480);
+		rtl818x_iowrite16(priv, &priv->map->RFPinsEnable, 0x1BFF);
+		rtl818x_iowrite16(priv, &priv->map->RFPinsSelect, 0x2488);
+
+		rtl818x_iowrite32(priv, &priv->map->RF_TIMING, 0x4003);
+
+		/* the reference code mac hardcode table write
+		 * this reg by doing byte-wide accesses.
+		 * It does it just for lowest and highest byte..
+		 */
+		reg32 = rtl818x_ioread32(priv, &priv->map->RF_PARA);
+		reg32 &= 0x00ffff00;
+		reg32 |= 0xb8000054;
+		rtl818x_iowrite32(priv, &priv->map->RF_PARA, reg32);
 	}
 
 	priv->rf->init(dev);
@@ -752,6 +895,10 @@ static int rtl8180_init_hw(struct ieee80211_hw *dev)
 	else
 		rtl8180_conf_basic_rates(dev, 0x1f3);
 
+	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8187SE)
+		rtl8187se_set_antenna_config(dev,
+					     priv->antenna_diversity_default,
+					     priv->antenna_diversity_en);
 	return 0;
 }
 
@@ -926,11 +1073,13 @@ static int rtl8180_start(struct ieee80211_hw *dev)
 
 	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8185)
 		reg |= RTL818X_RX_CONF_CSDM1 | RTL818X_RX_CONF_CSDM2;
-	else {
+	else if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8180) {
 		reg |= (priv->rfparam & RF_PARAM_CARRIERSENSE1)
 			? RTL818X_RX_CONF_CSDM1 : 0;
 		reg |= (priv->rfparam & RF_PARAM_CARRIERSENSE2)
 			? RTL818X_RX_CONF_CSDM2 : 0;
+	} else {
+		reg &= ~(RTL818X_RX_CONF_CSDM1 | RTL818X_RX_CONF_CSDM2);
 	}
 
 	priv->rx_conf = reg;
@@ -968,7 +1117,8 @@ static int rtl8180_start(struct ieee80211_hw *dev)
 	reg |= (6 << 21 /* MAX TX DMA */) |
 	       RTL818X_TX_CONF_NO_ICV;
 
-
+	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8187SE)
+		reg |= 1<<30;  /*  "duration procedure mode" */
 
 	if (priv->chip_family != RTL818X_CHIP_FAMILY_RTL8180)
 		reg &= ~RTL818X_TX_CONF_PROBE_DTS;
-- 
1.8.3.2

