Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:39152 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750784AbXLYGYK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Dec 2007 01:24:10 -0500
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH] rtl818x: Use RF ops tables
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Andrea Merello <andreamrl@tiscali.it>
Date: Tue, 25 Dec 2007 01:23:59 -0500
Message-ID: <20071225062359.22859.72603.stgit@tetra.sourmilk.net> (sfid-20071225_062419_472009_DF275B29)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Unfortunately, merging the usb and pci rtl8225 rf code is currently
more pain than gain. Switch to RF ops tables to avoid symbol conflicts
when building in the rtl818x drivers.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 drivers/net/wireless/rtl8180.h         |    4 --
 drivers/net/wireless/rtl8180_dev.c     |   47 +++++----------------
 drivers/net/wireless/rtl8180_grf5101.c |   15 +++++--
 drivers/net/wireless/rtl8180_grf5101.h |    4 --
 drivers/net/wireless/rtl8180_max2820.c |   16 +++++--
 drivers/net/wireless/rtl8180_max2820.h |    4 --
 drivers/net/wireless/rtl8180_rtl8225.c |   71 ++++++++++++++++++++------------
 drivers/net/wireless/rtl8180_rtl8225.h |    7 ---
 drivers/net/wireless/rtl8180_sa2400.c  |   14 +++++-
 drivers/net/wireless/rtl8180_sa2400.h  |    4 --
 drivers/net/wireless/rtl8187.h         |    2 -
 drivers/net/wireless/rtl8187_dev.c     |   48 ++++++++--------------
 drivers/net/wireless/rtl8187_rtl8225.c |   52 +++++++++++++++++++----
 drivers/net/wireless/rtl8187_rtl8225.h |    9 ----
 drivers/net/wireless/rtl818x.h         |    7 +++
 15 files changed, 163 insertions(+), 141 deletions(-)

diff --git a/drivers/net/wireless/rtl8180.h b/drivers/net/wireless/rtl8180.h
index 41b64cb..2cbfe3c 100644
--- a/drivers/net/wireless/rtl8180.h
+++ b/drivers/net/wireless/rtl8180.h
@@ -89,9 +89,7 @@ struct rtl8180_tx_ring {
 struct rtl8180_priv {
 	/* common between rtl818x drivers */
 	struct rtl818x_csr __iomem *map;
-	void (*rf_init)(struct ieee80211_hw *);
-	void (*rf_stop)(struct ieee80211_hw *);
-	void (*rf_set_chan)(struct ieee80211_hw *, struct ieee80211_conf *);
+	const struct rtl818x_rf_ops *rf;
 	struct ieee80211_vif *vif;
 	int mode;
 
diff --git a/drivers/net/wireless/rtl8180_dev.c b/drivers/net/wireless/rtl8180_dev.c
index c8e24a1..07f37b0 100644
--- a/drivers/net/wireless/rtl8180_dev.c
+++ b/drivers/net/wireless/rtl8180_dev.c
@@ -375,7 +375,7 @@ static int rtl8180_init_hw(struct ieee80211_hw *dev)
 		rtl818x_iowrite8(priv, &priv->map->CARRIER_SENSE_COUNTER, 0x4C);
 	}
 
-	priv->rf_init(dev);
+	priv->rf->init(dev);
 	if (priv->r8185)
 		rtl818x_iowrite16(priv, &priv->map->BRSR, 0x01F3);
 	return 0;
@@ -609,7 +609,7 @@ static void rtl8180_stop(struct ieee80211_hw *dev)
 	reg &= ~RTL818X_CMD_RX_ENABLE;
 	rtl818x_iowrite8(priv, &priv->map->CMD, reg);
 
-	priv->rf_stop(dev);
+	priv->rf->stop(dev);
 
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
 	reg = rtl818x_ioread8(priv, &priv->map->CONFIG4);
@@ -663,7 +663,7 @@ static int rtl8180_config(struct ieee80211_hw *dev, struct ieee80211_conf *conf)
 {
 	struct rtl8180_priv *priv = dev->priv;
 
-	priv->rf_set_chan(dev, conf);
+	priv->rf->set_chan(dev, conf);
 
 	return 0;
 }
@@ -770,7 +770,7 @@ static int __devinit rtl8180_probe(struct pci_dev *pdev,
 	unsigned int io_addr, io_len;
 	int err, i;
 	struct eeprom_93cx6 eeprom;
-	const char *chip_name, *rf_name;
+	const char *chip_name, *rf_name = NULL;
 	u32 reg;
 	u16 eeprom_val;
 	DECLARE_MAC_BUF(mac);
@@ -900,40 +900,17 @@ static int __devinit rtl8180_probe(struct pci_dev *pdev,
 	eeprom_93cx6_read(&eeprom, 0x06, &eeprom_val);
 	eeprom_val &= 0xFF;
 	switch (eeprom_val) {
-	case 1:
-		rf_name = "Intersil";
+	case 1:	rf_name = "Intersil";
 		break;
-	case 2:
-		rf_name = "RFMD";
+	case 2:	rf_name = "RFMD";
 		break;
-	case 3:
-		rf_name = "Philips";
-		priv->rf_init = sa2400_rf_init;
-		priv->rf_stop = sa2400_rf_stop;
-		priv->rf_set_chan = sa2400_rf_set_channel;
+	case 3:	priv->rf = &sa2400_rf_ops;
 		break;
-	case 4:
-		rf_name = "Maxim";
-		priv->rf_init = max2820_rf_init;
-		priv->rf_stop = max2820_rf_stop;
-		priv->rf_set_chan = max2820_rf_set_channel;
+	case 4:	priv->rf = &max2820_rf_ops;
 		break;
-	case 5:
-		rf_name = "GCT";
-		priv->rf_init = grf5101_rf_init;
-		priv->rf_stop = grf5101_rf_stop;
-		priv->rf_set_chan = grf5101_rf_set_channel;
+	case 5:	priv->rf = &grf5101_rf_ops;
 		break;
-	case 9:
-		if (rtl8225_is_z2(dev)) {
-			rf_name = "RTL8225z2";
-			priv->rf_init = rtl8225z2_rf_init;
-		} else {
-			rf_name = "RTL8225";
-			priv->rf_init = rtl8225_rf_init;
-		}
-		priv->rf_stop = rtl8225_rf_stop;
-		priv->rf_set_chan = rtl8225_rf_set_channel;
+	case 9:	priv->rf = rtl8180_detect_rf(dev);
 		break;
 	case 10:
 		rf_name = "RTL8255";
@@ -944,7 +921,7 @@ static int __devinit rtl8180_probe(struct pci_dev *pdev,
 		goto err_iounmap;
 	}
 
-	if (eeprom_val < 3) {
+	if (!priv->rf) {
 		printk(KERN_ERR "%s (rtl8180): %s RF frontend not supported!\n",
 		       pci_name(pdev), rf_name);
 		goto err_iounmap;
@@ -997,7 +974,7 @@ static int __devinit rtl8180_probe(struct pci_dev *pdev,
 
 	printk(KERN_INFO "%s: hwaddr %s, %s + %s\n",
 	       wiphy_name(dev->wiphy), print_mac(mac, dev->wiphy->perm_addr),
-	       chip_name, rf_name);
+	       chip_name, priv->rf->name);
 
 	return 0;
 
diff --git a/drivers/net/wireless/rtl8180_grf5101.c b/drivers/net/wireless/rtl8180_grf5101.c
index 11e80ab..8293e19 100644
--- a/drivers/net/wireless/rtl8180_grf5101.c
+++ b/drivers/net/wireless/rtl8180_grf5101.c
@@ -69,8 +69,8 @@ static void grf5101_write_phy_antenna(struct ieee80211_hw *dev, short chan)
 	rtl8180_write_phy(dev, 0x10, ant);
 }
 
-void grf5101_rf_set_channel(struct ieee80211_hw *dev,
-			    struct ieee80211_conf *conf)
+static void grf5101_rf_set_channel(struct ieee80211_hw *dev,
+				   struct ieee80211_conf *conf)
 {
 	struct rtl8180_priv *priv = dev->priv;
 	u32 txpw = priv->channels[conf->channel - 1].val & 0xFF;
@@ -90,7 +90,7 @@ void grf5101_rf_set_channel(struct ieee80211_hw *dev,
 	grf5101_write_phy_antenna(dev, chan);
 }
 
-void grf5101_rf_stop(struct ieee80211_hw *dev)
+static void grf5101_rf_stop(struct ieee80211_hw *dev)
 {
 	struct rtl8180_priv *priv = dev->priv;
 	u32 anaparam;
@@ -106,7 +106,7 @@ void grf5101_rf_stop(struct ieee80211_hw *dev)
 	write_grf5101(dev, 0x00, 0x8e4);
 }
 
-void grf5101_rf_init(struct ieee80211_hw *dev)
+static void grf5101_rf_init(struct ieee80211_hw *dev)
 {
 	struct rtl8180_priv *priv = dev->priv;
 
@@ -170,3 +170,10 @@ void grf5101_rf_init(struct ieee80211_hw *dev)
 	rtl8180_write_phy(dev, 0x1a, 0xa0);
 	rtl8180_write_phy(dev, 0x1b, 0x44);
 }
+
+const struct rtl818x_rf_ops grf5101_rf_ops = {
+	.name		= "GCT",
+	.init		= grf5101_rf_init,
+	.stop		= grf5101_rf_stop,
+	.set_chan	= grf5101_rf_set_channel
+};
diff --git a/drivers/net/wireless/rtl8180_grf5101.h b/drivers/net/wireless/rtl8180_grf5101.h
index 5b4a171..7664711 100644
--- a/drivers/net/wireless/rtl8180_grf5101.h
+++ b/drivers/net/wireless/rtl8180_grf5101.h
@@ -23,8 +23,6 @@
 
 #define GRF5101_ANTENNA 0xA3
 
-void grf5101_rf_init(struct ieee80211_hw *);
-void grf5101_rf_stop(struct ieee80211_hw *);
-void grf5101_rf_set_channel(struct ieee80211_hw *, struct ieee80211_conf *);
+extern const struct rtl818x_rf_ops grf5101_rf_ops;
 
 #endif /* RTL8180_GRF5101_H */
diff --git a/drivers/net/wireless/rtl8180_max2820.c b/drivers/net/wireless/rtl8180_max2820.c
index c3e125f..98fe9fd 100644
--- a/drivers/net/wireless/rtl8180_max2820.c
+++ b/drivers/net/wireless/rtl8180_max2820.c
@@ -26,7 +26,7 @@
 #include "rtl8180.h"
 #include "rtl8180_max2820.h"
 
-u32 max2820_chan[] = {
+static const u32 max2820_chan[] = {
 	12, /* CH 1 */
 	17,
 	22,
@@ -74,7 +74,8 @@ static void max2820_write_phy_antenna(struct ieee80211_hw *dev, short chan)
 	rtl8180_write_phy(dev, 0x10, ant);
 }
 
-void max2820_rf_set_channel(struct ieee80211_hw *dev, struct ieee80211_conf *conf)
+static void max2820_rf_set_channel(struct ieee80211_hw *dev,
+				   struct ieee80211_conf *conf)
 {
 	struct rtl8180_priv *priv = dev->priv;
 	unsigned int chan_idx = conf ? conf->channel - 1 : 0;
@@ -89,14 +90,14 @@ void max2820_rf_set_channel(struct ieee80211_hw *dev, struct ieee80211_conf *con
 	write_max2820(dev, 3, chan);
 }
 
-void max2820_rf_stop(struct ieee80211_hw *dev)
+static void max2820_rf_stop(struct ieee80211_hw *dev)
 {
 	rtl8180_write_phy(dev, 3, 0x8);
 	write_max2820(dev, 1, 0);
 }
 
 
-void max2820_rf_init(struct ieee80211_hw *dev)
+static void max2820_rf_init(struct ieee80211_hw *dev)
 {
 	struct rtl8180_priv *priv = dev->priv;
 
@@ -140,3 +141,10 @@ void max2820_rf_init(struct ieee80211_hw *dev)
 
 	max2820_rf_set_channel(dev, NULL);
 }
+
+const struct rtl818x_rf_ops max2820_rf_ops = {
+	.name		= "Maxim",
+	.init		= max2820_rf_init,
+	.stop		= max2820_rf_stop,
+	.set_chan	= max2820_rf_set_channel
+};
diff --git a/drivers/net/wireless/rtl8180_max2820.h b/drivers/net/wireless/rtl8180_max2820.h
index 8e27292..61cf6d1 100644
--- a/drivers/net/wireless/rtl8180_max2820.h
+++ b/drivers/net/wireless/rtl8180_max2820.h
@@ -23,8 +23,6 @@
 
 #define MAXIM_ANTENNA 0xb3
 
-void max2820_rf_init(struct ieee80211_hw *);
-void max2820_rf_stop(struct ieee80211_hw *);
-void max2820_rf_set_channel(struct ieee80211_hw *, struct ieee80211_conf *);
+extern const struct rtl818x_rf_ops max2820_rf_ops;
 
 #endif /* RTL8180_MAX2820_H */
diff --git a/drivers/net/wireless/rtl8180_rtl8225.c b/drivers/net/wireless/rtl8180_rtl8225.c
index 09a54fd..37ac402 100644
--- a/drivers/net/wireless/rtl8180_rtl8225.c
+++ b/drivers/net/wireless/rtl8180_rtl8225.c
@@ -299,28 +299,7 @@ static void rtl8225_rf_set_tx_power(struct ieee80211_hw *dev, int channel)
 	msleep(1);
 }
 
-int rtl8225_is_z2(struct ieee80211_hw *dev)
-{
-	struct rtl8180_priv *priv = dev->priv;
-	int z2 = 0;
-
-	rtl818x_iowrite16(priv, &priv->map->RFPinsOutput, 0x0480);
-	rtl818x_iowrite16(priv, &priv->map->RFPinsSelect, 0x0488);
-	rtl818x_iowrite16(priv, &priv->map->RFPinsEnable, 0x1FFF);
-	rtl818x_ioread8(priv, &priv->map->EEPROM_CMD);
-	msleep(100);
-
-	rtl8225_write(dev, 0, 0x1B7);
-
-	if (rtl8225_read(dev, 8) == 0x588 && rtl8225_read(dev, 9) == 0x700)
-		z2 = 1;
-
-	rtl8225_write(dev, 0, 0x0B7);
-
-	return z2;
-}
-
-void rtl8225_rf_init(struct ieee80211_hw *dev)
+static void rtl8225_rf_init(struct ieee80211_hw *dev)
 {
 	struct rtl8180_priv *priv = dev->priv;
 	int i;
@@ -549,7 +528,7 @@ static const u16 rtl8225z2_rxgain[] = {
 	0x03b4, 0x03b5, 0x03b8, 0x03b9, 0x03ba, 0x03bb, 0x03bb
 };
 
-void rtl8225z2_rf_init(struct ieee80211_hw *dev)
+static void rtl8225z2_rf_init(struct ieee80211_hw *dev)
 {
 	struct rtl8180_priv *priv = dev->priv;
 	int i;
@@ -718,7 +697,7 @@ void rtl8225z2_rf_init(struct ieee80211_hw *dev)
 	rtl818x_iowrite16(priv, &priv->map->RFPinsEnable, 0x1FFF);
 }
 
-void rtl8225_rf_stop(struct ieee80211_hw *dev)
+static void rtl8225_rf_stop(struct ieee80211_hw *dev)
 {
 	struct rtl8180_priv *priv = dev->priv;
 	u8 reg;
@@ -734,12 +713,12 @@ void rtl8225_rf_stop(struct ieee80211_hw *dev)
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
 }
 
-void rtl8225_rf_set_channel(struct ieee80211_hw *dev,
-			    struct ieee80211_conf *conf)
+static void rtl8225_rf_set_channel(struct ieee80211_hw *dev,
+				   struct ieee80211_conf *conf)
 {
 	struct rtl8180_priv *priv = dev->priv;
 
-	if (priv->rf_init == rtl8225_rf_init)
+	if (priv->rf->init == rtl8225_rf_init)
 		rtl8225_rf_set_tx_power(dev, conf->channel);
 	else
 		rtl8225z2_rf_set_tx_power(dev, conf->channel);
@@ -761,3 +740,41 @@ void rtl8225_rf_set_channel(struct ieee80211_hw *dev,
 		rtl818x_iowrite8(priv, &priv->map->CW_VAL, 0xa5);
 	}
 }
+
+static const struct rtl818x_rf_ops rtl8225_ops = {
+	.name		= "rtl8225",
+	.init		= rtl8225_rf_init,
+	.stop		= rtl8225_rf_stop,
+	.set_chan	= rtl8225_rf_set_channel
+};
+
+static const struct rtl818x_rf_ops rtl8225z2_ops = {
+	.name		= "rtl8225z2",
+	.init		= rtl8225z2_rf_init,
+	.stop		= rtl8225_rf_stop,
+	.set_chan	= rtl8225_rf_set_channel
+};
+
+const struct rtl818x_rf_ops * rtl8180_detect_rf(struct ieee80211_hw *dev)
+{
+	struct rtl8180_priv *priv = dev->priv;
+	u16 reg8, reg9;
+
+	rtl818x_iowrite16(priv, &priv->map->RFPinsOutput, 0x0480);
+	rtl818x_iowrite16(priv, &priv->map->RFPinsSelect, 0x0488);
+	rtl818x_iowrite16(priv, &priv->map->RFPinsEnable, 0x1FFF);
+	rtl818x_ioread8(priv, &priv->map->EEPROM_CMD);
+	msleep(100);
+
+	rtl8225_write(dev, 0, 0x1B7);
+
+	reg8 = rtl8225_read(dev, 8);
+	reg9 = rtl8225_read(dev, 9);
+
+	rtl8225_write(dev, 0, 0x0B7);
+
+	if (reg8 != 0x588 || reg9 != 0x700)
+		return &rtl8225_ops;
+
+	return &rtl8225z2_ops;
+}
diff --git a/drivers/net/wireless/rtl8180_rtl8225.h b/drivers/net/wireless/rtl8180_rtl8225.h
index e142795..92d2b17 100644
--- a/drivers/net/wireless/rtl8180_rtl8225.h
+++ b/drivers/net/wireless/rtl8180_rtl8225.h
@@ -6,12 +6,7 @@
 #define RTL8225_ANAPARAM_OFF	0xa00beb59
 #define RTL8225_ANAPARAM2_OFF	0x840dec11
 
-int rtl8225_is_z2(struct ieee80211_hw *dev);
-
-void rtl8225_rf_init(struct ieee80211_hw *);
-void rtl8225z2_rf_init(struct ieee80211_hw *);
-void rtl8225_rf_stop(struct ieee80211_hw *);
-void rtl8225_rf_set_channel(struct ieee80211_hw *, struct ieee80211_conf *);
+const struct rtl818x_rf_ops * rtl8180_detect_rf(struct ieee80211_hw *);
 
 static inline void rtl8225_write_phy_ofdm(struct ieee80211_hw *dev,
 					  u8 addr, u8 data)
diff --git a/drivers/net/wireless/rtl8180_sa2400.c b/drivers/net/wireless/rtl8180_sa2400.c
index dea7e5a..e08ace7 100644
--- a/drivers/net/wireless/rtl8180_sa2400.c
+++ b/drivers/net/wireless/rtl8180_sa2400.c
@@ -76,7 +76,8 @@ static void sa2400_write_phy_antenna(struct ieee80211_hw *dev, short chan)
 
 }
 
-void sa2400_rf_set_channel(struct ieee80211_hw *dev, struct ieee80211_conf *conf)
+static void sa2400_rf_set_channel(struct ieee80211_hw *dev,
+				  struct ieee80211_conf *conf)
 {
 	struct rtl8180_priv *priv = dev->priv;
 	u32 txpw = priv->channels[conf->channel - 1].val & 0xFF;
@@ -92,12 +93,12 @@ void sa2400_rf_set_channel(struct ieee80211_hw *dev, struct ieee80211_conf *conf
 	write_sa2400(dev, 3, 0);
 }
 
-void sa2400_rf_stop(struct ieee80211_hw *dev)
+static void sa2400_rf_stop(struct ieee80211_hw *dev)
 {
 	write_sa2400(dev, 4, 0);
 }
 
-void sa2400_rf_init(struct ieee80211_hw *dev)
+static void sa2400_rf_init(struct ieee80211_hw *dev)
 {
 	struct rtl8180_priv *priv = dev->priv;
 	u32 anaparam, txconf;
@@ -191,3 +192,10 @@ void sa2400_rf_init(struct ieee80211_hw *dev)
 	rtl8180_write_phy(dev, 0x19, 0x0);
 	rtl8180_write_phy(dev, 0x1a, 0xa0);
 }
+
+const struct rtl818x_rf_ops sa2400_rf_ops = {
+	.name		= "Philips",
+	.init		= sa2400_rf_init,
+	.stop		= sa2400_rf_stop,
+	.set_chan	= sa2400_rf_set_channel
+};
diff --git a/drivers/net/wireless/rtl8180_sa2400.h b/drivers/net/wireless/rtl8180_sa2400.h
index 018bb92..a4aaa0d 100644
--- a/drivers/net/wireless/rtl8180_sa2400.h
+++ b/drivers/net/wireless/rtl8180_sa2400.h
@@ -31,8 +31,6 @@
 
 #define SA2400_REG4_FIRDAC_SHIFT 7
 
-void sa2400_rf_init(struct ieee80211_hw *);
-void sa2400_rf_stop(struct ieee80211_hw *);
-void sa2400_rf_set_channel(struct ieee80211_hw *, struct ieee80211_conf *);
+extern const struct rtl818x_rf_ops sa2400_rf_ops;
 
 #endif /* RTL8180_SA2400_H */
diff --git a/drivers/net/wireless/rtl8187.h b/drivers/net/wireless/rtl8187.h
index a934a46..8680a0b 100644
--- a/drivers/net/wireless/rtl8187.h
+++ b/drivers/net/wireless/rtl8187.h
@@ -64,7 +64,7 @@ struct rtl8187_tx_hdr {
 struct rtl8187_priv {
 	/* common between rtl818x drivers */
 	struct rtl818x_csr *map;
-	void (*rf_init)(struct ieee80211_hw *);
+	const struct rtl818x_rf_ops *rf;
 	struct ieee80211_vif *vif;
 	int mode;
 
diff --git a/drivers/net/wireless/rtl8187_dev.c b/drivers/net/wireless/rtl8187_dev.c
index 13399de..0d71716 100644
--- a/drivers/net/wireless/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl8187_dev.c
@@ -394,7 +394,7 @@ static int rtl8187_init_hw(struct ieee80211_hw *dev)
 	rtl818x_iowrite16(priv, &priv->map->RFPinsEnable, 0x1FF7);
 	msleep(100);
 
-	priv->rf_init(dev);
+	priv->rf->init(dev);
 
 	rtl818x_iowrite16(priv, &priv->map->BRSR, 0x01F3);
 	reg = rtl818x_ioread8(priv, &priv->map->PGSELECT) & ~1;
@@ -407,24 +407,6 @@ static int rtl8187_init_hw(struct ieee80211_hw *dev)
 	return 0;
 }
 
-static void rtl8187_set_channel(struct ieee80211_hw *dev, int channel)
-{
-	u32 reg;
-	struct rtl8187_priv *priv = dev->priv;
-
-	reg = rtl818x_ioread32(priv, &priv->map->TX_CONF);
-	/* Enable TX loopback on MAC level to avoid TX during channel
-	 * changes, as this has be seen to causes problems and the
-	 * card will stop work until next reset
-	 */
-	rtl818x_iowrite32(priv, &priv->map->TX_CONF,
-			  reg | RTL818X_TX_CONF_LOOPBACK_MAC);
-	msleep(10);
-	rtl8225_rf_set_channel(dev, channel);
-	msleep(10);
-	rtl818x_iowrite32(priv, &priv->map->TX_CONF, reg);
-}
-
 static int rtl8187_start(struct ieee80211_hw *dev)
 {
 	struct rtl8187_priv *priv = dev->priv;
@@ -493,7 +475,7 @@ static void rtl8187_stop(struct ieee80211_hw *dev)
 	reg &= ~RTL818X_CMD_RX_ENABLE;
 	rtl818x_iowrite8(priv, &priv->map->CMD, reg);
 
-	rtl8225_rf_stop(dev);
+	priv->rf->stop(dev);
 
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
 	reg = rtl818x_ioread8(priv, &priv->map->CONFIG4);
@@ -544,7 +526,19 @@ static void rtl8187_remove_interface(struct ieee80211_hw *dev,
 static int rtl8187_config(struct ieee80211_hw *dev, struct ieee80211_conf *conf)
 {
 	struct rtl8187_priv *priv = dev->priv;
-	rtl8187_set_channel(dev, conf->channel);
+	u32 reg;
+
+	reg = rtl818x_ioread32(priv, &priv->map->TX_CONF);
+	/* Enable TX loopback on MAC level to avoid TX during channel
+	 * changes, as this has be seen to causes problems and the
+	 * card will stop work until next reset
+	 */
+	rtl818x_iowrite32(priv, &priv->map->TX_CONF,
+			  reg | RTL818X_TX_CONF_LOOPBACK_MAC);
+	msleep(10);
+	priv->rf->set_chan(dev, conf);
+	msleep(10);
+	rtl818x_iowrite32(priv, &priv->map->TX_CONF, reg);
 
 	rtl818x_iowrite8(priv, &priv->map->SIFS, 0x22);
 
@@ -762,14 +756,7 @@ static int __devinit rtl8187_probe(struct usb_interface *intf,
 	rtl818x_iowrite8(priv, &priv->map->PGSELECT, reg);
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
 
-	rtl8225_write(dev, 0, 0x1B7);
-
-	if (rtl8225_read(dev, 8) != 0x588 || rtl8225_read(dev, 9) != 0x700)
-		priv->rf_init = rtl8225_rf_init;
-	else
-		priv->rf_init = rtl8225z2_rf_init;
-
-	rtl8225_write(dev, 0, 0x0B7);
+	priv->rf = rtl8187_detect_rf(dev);
 
 	err = ieee80211_register_hw(dev);
 	if (err) {
@@ -779,8 +766,7 @@ static int __devinit rtl8187_probe(struct usb_interface *intf,
 
 	printk(KERN_INFO "%s: hwaddr %s, rtl8187 V%d + %s\n",
 	       wiphy_name(dev->wiphy), print_mac(mac, dev->wiphy->perm_addr),
-	       priv->asic_rev, priv->rf_init == rtl8225_rf_init ?
-	       "rtl8225" : "rtl8225z2");
+	       priv->asic_rev, priv->rf->name);
 
 	return 0;
 
diff --git a/drivers/net/wireless/rtl8187_rtl8225.c b/drivers/net/wireless/rtl8187_rtl8225.c
index eade81f..c04ad34 100644
--- a/drivers/net/wireless/rtl8187_rtl8225.c
+++ b/drivers/net/wireless/rtl8187_rtl8225.c
@@ -101,7 +101,7 @@ static void rtl8225_write_8051(struct ieee80211_hw *dev, u8 addr, __le16 data)
 	msleep(2);
 }
 
-void rtl8225_write(struct ieee80211_hw *dev, u8 addr, u16 data)
+static void rtl8225_write(struct ieee80211_hw *dev, u8 addr, u16 data)
 {
 	struct rtl8187_priv *priv = dev->priv;
 
@@ -111,7 +111,7 @@ void rtl8225_write(struct ieee80211_hw *dev, u8 addr, u16 data)
 		rtl8225_write_bitbang(dev, addr, data);
 }
 
-u16 rtl8225_read(struct ieee80211_hw *dev, u8 addr)
+static u16 rtl8225_read(struct ieee80211_hw *dev, u8 addr)
 {
 	struct rtl8187_priv *priv = dev->priv;
 	u16 reg80, reg82, reg84, out;
@@ -325,7 +325,7 @@ static void rtl8225_rf_set_tx_power(struct ieee80211_hw *dev, int channel)
 	msleep(1);
 }
 
-void rtl8225_rf_init(struct ieee80211_hw *dev)
+static void rtl8225_rf_init(struct ieee80211_hw *dev)
 {
 	struct rtl8187_priv *priv = dev->priv;
 	int i;
@@ -567,7 +567,7 @@ static const u8 rtl8225z2_gain_bg[] = {
 	0x63, 0x15, 0xc5  /* -66dBm */
 };
 
-void rtl8225z2_rf_init(struct ieee80211_hw *dev)
+static void rtl8225z2_rf_init(struct ieee80211_hw *dev)
 {
 	struct rtl8187_priv *priv = dev->priv;
 	int i;
@@ -715,7 +715,7 @@ void rtl8225z2_rf_init(struct ieee80211_hw *dev)
 	rtl818x_iowrite32(priv, (__le32 *)0xFF94, 0x3dc00002);
 }
 
-void rtl8225_rf_stop(struct ieee80211_hw *dev)
+static void rtl8225_rf_stop(struct ieee80211_hw *dev)
 {
 	u8 reg;
 	struct rtl8187_priv *priv = dev->priv;
@@ -731,15 +731,47 @@ void rtl8225_rf_stop(struct ieee80211_hw *dev)
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
 }
 
-void rtl8225_rf_set_channel(struct ieee80211_hw *dev, int channel)
+static void rtl8225_rf_set_channel(struct ieee80211_hw *dev,
+				   struct ieee80211_conf *conf)
 {
 	struct rtl8187_priv *priv = dev->priv;
 
-	if (priv->rf_init == rtl8225_rf_init)
-		rtl8225_rf_set_tx_power(dev, channel);
+	if (priv->rf->init == rtl8225_rf_init)
+		rtl8225_rf_set_tx_power(dev, conf->channel);
 	else
-		rtl8225z2_rf_set_tx_power(dev, channel);
+		rtl8225z2_rf_set_tx_power(dev, conf->channel);
 
-	rtl8225_write(dev, 0x7, rtl8225_chan[channel - 1]);
+	rtl8225_write(dev, 0x7, rtl8225_chan[conf->channel - 1]);
 	msleep(10);
 }
+
+static const struct rtl818x_rf_ops rtl8225_ops = {
+	.name		= "rtl8225",
+	.init		= rtl8225_rf_init,
+	.stop		= rtl8225_rf_stop,
+	.set_chan	= rtl8225_rf_set_channel
+};
+
+static const struct rtl818x_rf_ops rtl8225z2_ops = {
+	.name		= "rtl8225z2",
+	.init		= rtl8225z2_rf_init,
+	.stop		= rtl8225_rf_stop,
+	.set_chan	= rtl8225_rf_set_channel
+};
+
+const struct rtl818x_rf_ops * rtl8187_detect_rf(struct ieee80211_hw *dev)
+{
+	u16 reg8, reg9;
+
+	rtl8225_write(dev, 0, 0x1B7);
+
+	reg8 = rtl8225_read(dev, 8);
+	reg9 = rtl8225_read(dev, 9);
+
+	rtl8225_write(dev, 0, 0x0B7);
+
+	if (reg8 != 0x588 || reg9 != 0x700)
+		return &rtl8225_ops;
+
+	return &rtl8225z2_ops;
+}
diff --git a/drivers/net/wireless/rtl8187_rtl8225.h b/drivers/net/wireless/rtl8187_rtl8225.h
index 798ba4a..d39ed02 100644
--- a/drivers/net/wireless/rtl8187_rtl8225.h
+++ b/drivers/net/wireless/rtl8187_rtl8225.h
@@ -20,14 +20,7 @@
 #define RTL8225_ANAPARAM_OFF	0xa00beb59
 #define RTL8225_ANAPARAM2_OFF	0x840dec11
 
-void rtl8225_write(struct ieee80211_hw *, u8 addr, u16 data);
-u16  rtl8225_read(struct ieee80211_hw *, u8 addr);
-
-void rtl8225_rf_init(struct ieee80211_hw *);
-void rtl8225z2_rf_init(struct ieee80211_hw *);
-void rtl8225_rf_stop(struct ieee80211_hw *);
-void rtl8225_rf_set_channel(struct ieee80211_hw *, int);
-
+const struct rtl818x_rf_ops * rtl8187_detect_rf(struct ieee80211_hw *);
 
 static inline void rtl8225_write_phy_ofdm(struct ieee80211_hw *dev,
 					  u8 addr, u32 data)
diff --git a/drivers/net/wireless/rtl818x.h b/drivers/net/wireless/rtl818x.h
index 1322f6a..1e7d6f8 100644
--- a/drivers/net/wireless/rtl818x.h
+++ b/drivers/net/wireless/rtl818x.h
@@ -168,6 +168,13 @@ struct rtl818x_csr {
 	u8	TALLY_SEL;
 } __attribute__((packed));
 
+struct rtl818x_rf_ops {
+	char *name;
+	void (*init)(struct ieee80211_hw *);
+	void (*stop)(struct ieee80211_hw *);
+	void (*set_chan)(struct ieee80211_hw *, struct ieee80211_conf *);
+};
+
 static const struct ieee80211_rate rtl818x_rates[] = {
 	{ .rate = 10,
 	  .val = 0,


