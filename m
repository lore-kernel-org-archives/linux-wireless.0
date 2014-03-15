Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:52397 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756278AbaCOR3G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Mar 2014 13:29:06 -0400
Received: by mail-ee0-f48.google.com with SMTP id b57so1861613eek.7
        for <linux-wireless@vger.kernel.org>; Sat, 15 Mar 2014 10:29:05 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	bernhard@schiffner-limbach.de, dan.carpenter@oracle.com,
	andrea.merello@gmail.com
Subject: [PATCH 4/4] rtl8180: move eeprom read stuff in a separate function
Date: Sat, 15 Mar 2014 18:29:38 +0100
Message-Id: <1394904578-5279-5-git-send-email-andrea.merello@gmail.com> (sfid-20140315_182911_347855_3810AC12)
In-Reply-To: <1394904578-5279-1-git-send-email-andrea.merello@gmail.com>
References: <1394904578-5279-1-git-send-email-andrea.merello@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Eeprom read operations are mixed in the probe function.
Make the code more readable and clean by extracting this code and
moving it in a dedicated function.

The variable eeprom_cck_table_adr, now useless, is here because
it will be needed for rtl8187se support, that I hope to add soon.

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c     | 128 ++++++++++++++-----------
 drivers/net/wireless/rtl818x/rtl8180/rtl8180.h |   3 +-
 2 files changed, 73 insertions(+), 58 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 9ee68fd..0b405b8 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -1041,8 +1041,7 @@ static const struct ieee80211_ops rtl8180_ops = {
 
 static void rtl8180_eeprom_register_read(struct eeprom_93cx6 *eeprom)
 {
-	struct ieee80211_hw *dev = eeprom->data;
-	struct rtl8180_priv *priv = dev->priv;
+	struct rtl8180_priv *priv = eeprom->data;
 	u8 reg = rtl818x_ioread8(priv, &priv->map->EEPROM_CMD);
 
 	eeprom->reg_data_in = reg & RTL818X_EEPROM_CMD_WRITE;
@@ -1053,8 +1052,7 @@ static void rtl8180_eeprom_register_read(struct eeprom_93cx6 *eeprom)
 
 static void rtl8180_eeprom_register_write(struct eeprom_93cx6 *eeprom)
 {
-	struct ieee80211_hw *dev = eeprom->data;
-	struct rtl8180_priv *priv = dev->priv;
+	struct rtl8180_priv *priv = eeprom->data;
 	u8 reg = 2 << 6;
 
 	if (eeprom->reg_data_in)
@@ -1071,6 +1069,67 @@ static void rtl8180_eeprom_register_write(struct eeprom_93cx6 *eeprom)
 	udelay(10);
 }
 
+static void rtl8180_eeprom_read(struct rtl8180_priv *priv)
+{
+	struct eeprom_93cx6 eeprom;
+	int eeprom_cck_table_adr;
+	u16 eeprom_val;
+	int i;
+
+	eeprom.data = priv;
+	eeprom.register_read = rtl8180_eeprom_register_read;
+	eeprom.register_write = rtl8180_eeprom_register_write;
+	if (rtl818x_ioread32(priv, &priv->map->RX_CONF) & (1 << 6))
+		eeprom.width = PCI_EEPROM_WIDTH_93C66;
+	else
+		eeprom.width = PCI_EEPROM_WIDTH_93C46;
+
+	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
+			RTL818X_EEPROM_CMD_PROGRAM);
+	rtl818x_ioread8(priv, &priv->map->EEPROM_CMD);
+	udelay(10);
+
+	eeprom_93cx6_read(&eeprom, 0x06, &eeprom_val);
+	eeprom_val &= 0xFF;
+	priv->rf_type = eeprom_val;
+
+	eeprom_93cx6_read(&eeprom, 0x17, &eeprom_val);
+	priv->csthreshold = eeprom_val >> 8;
+
+	eeprom_93cx6_multiread(&eeprom, 0x7, (__le16 *)priv->mac_addr, 3);
+
+	eeprom_cck_table_adr = 0x10;
+
+	/* CCK TX power */
+	for (i = 0; i < 14; i += 2) {
+		u16 txpwr;
+		eeprom_93cx6_read(&eeprom, eeprom_cck_table_adr + (i >> 1),
+				&txpwr);
+		priv->channels[i].hw_value = txpwr & 0xFF;
+		priv->channels[i + 1].hw_value = txpwr >> 8;
+	}
+
+	/* OFDM TX power */
+	if (priv->chip_family != RTL818X_CHIP_FAMILY_RTL8180) {
+		for (i = 0; i < 14; i += 2) {
+			u16 txpwr;
+			eeprom_93cx6_read(&eeprom, 0x20 + (i >> 1), &txpwr);
+			priv->channels[i].hw_value |= (txpwr & 0xFF) << 8;
+			priv->channels[i + 1].hw_value |= txpwr & 0xFF00;
+		}
+	}
+
+	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8180) {
+		__le32 anaparam;
+		eeprom_93cx6_multiread(&eeprom, 0xD, (__le16 *)&anaparam, 2);
+		priv->anaparam = le32_to_cpu(anaparam);
+		eeprom_93cx6_read(&eeprom, 0x19, &priv->rfparam);
+	}
+
+	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
+			RTL818X_EEPROM_CMD_NORMAL);
+}
+
 static int rtl8180_probe(struct pci_dev *pdev,
 				   const struct pci_device_id *id)
 {
@@ -1078,12 +1137,9 @@ static int rtl8180_probe(struct pci_dev *pdev,
 	struct rtl8180_priv *priv;
 	unsigned long mem_addr, mem_len;
 	unsigned int io_addr, io_len;
-	int err, i;
-	struct eeprom_93cx6 eeprom;
+	int err;
 	const char *chip_name, *rf_name = NULL;
 	u32 reg;
-	u16 eeprom_val;
-	u8 mac_addr[ETH_ALEN];
 
 	err = pci_enable_device(pdev);
 	if (err) {
@@ -1201,21 +1257,9 @@ static int rtl8180_probe(struct pci_dev *pdev,
 		pci_try_set_mwi(pdev);
 	}
 
-	eeprom.data = dev;
-	eeprom.register_read = rtl8180_eeprom_register_read;
-	eeprom.register_write = rtl8180_eeprom_register_write;
-	if (rtl818x_ioread32(priv, &priv->map->RX_CONF) & (1 << 6))
-		eeprom.width = PCI_EEPROM_WIDTH_93C66;
-	else
-		eeprom.width = PCI_EEPROM_WIDTH_93C46;
-
-	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_PROGRAM);
-	rtl818x_ioread8(priv, &priv->map->EEPROM_CMD);
-	udelay(10);
+	rtl8180_eeprom_read(priv);
 
-	eeprom_93cx6_read(&eeprom, 0x06, &eeprom_val);
-	eeprom_val &= 0xFF;
-	switch (eeprom_val) {
+	switch (priv->rf_type) {
 	case 1:	rf_name = "Intersil";
 		break;
 	case 2:	rf_name = "RFMD";
@@ -1233,7 +1277,7 @@ static int rtl8180_probe(struct pci_dev *pdev,
 		break;
 	default:
 		printk(KERN_ERR "%s (rtl8180): Unknown RF! (0x%x)\n",
-		       pci_name(pdev), eeprom_val);
+		       pci_name(pdev), priv->rf_type);
 		goto err_iounmap;
 	}
 
@@ -1243,42 +1287,12 @@ static int rtl8180_probe(struct pci_dev *pdev,
 		goto err_iounmap;
 	}
 
-	eeprom_93cx6_read(&eeprom, 0x17, &eeprom_val);
-	priv->csthreshold = eeprom_val >> 8;
-	if (priv->chip_family != RTL818X_CHIP_FAMILY_RTL8185) {
-		__le32 anaparam;
-		eeprom_93cx6_multiread(&eeprom, 0xD, (__le16 *)&anaparam, 2);
-		priv->anaparam = le32_to_cpu(anaparam);
-		eeprom_93cx6_read(&eeprom, 0x19, &priv->rfparam);
-	}
-
-	eeprom_93cx6_multiread(&eeprom, 0x7, (__le16 *)mac_addr, 3);
-	if (!is_valid_ether_addr(mac_addr)) {
+	if (!is_valid_ether_addr(priv->mac_addr)) {
 		printk(KERN_WARNING "%s (rtl8180): Invalid hwaddr! Using"
 		       " randomly generated MAC addr\n", pci_name(pdev));
-		eth_random_addr(mac_addr);
-	}
-	SET_IEEE80211_PERM_ADDR(dev, mac_addr);
-
-	/* CCK TX power */
-	for (i = 0; i < 14; i += 2) {
-		u16 txpwr;
-		eeprom_93cx6_read(&eeprom, 0x10 + (i >> 1), &txpwr);
-		priv->channels[i].hw_value = txpwr & 0xFF;
-		priv->channels[i + 1].hw_value = txpwr >> 8;
-	}
-
-	/* OFDM TX power */
-	if (priv->chip_family != RTL818X_CHIP_FAMILY_RTL8180) {
-		for (i = 0; i < 14; i += 2) {
-			u16 txpwr;
-			eeprom_93cx6_read(&eeprom, 0x20 + (i >> 1), &txpwr);
-			priv->channels[i].hw_value |= (txpwr & 0xFF) << 8;
-			priv->channels[i + 1].hw_value |= txpwr & 0xFF00;
-		}
+		eth_random_addr(priv->mac_addr);
 	}
-
-	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
+	SET_IEEE80211_PERM_ADDR(dev, priv->mac_addr);
 
 	spin_lock_init(&priv->lock);
 
@@ -1290,7 +1304,7 @@ static int rtl8180_probe(struct pci_dev *pdev,
 	}
 
 	wiphy_info(dev->wiphy, "hwaddr %pm, %s + %s\n",
-		   mac_addr, chip_name, priv->rf->name);
+		   priv->mac_addr, chip_name, priv->rf->name);
 
 	return 0;
 
diff --git a/drivers/net/wireless/rtl818x/rtl8180/rtl8180.h b/drivers/net/wireless/rtl818x/rtl8180/rtl8180.h
index 7014bf0..26383d7 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/rtl8180.h
+++ b/drivers/net/wireless/rtl818x/rtl8180/rtl8180.h
@@ -91,7 +91,8 @@ struct rtl8180_priv {
 	u32 anaparam;
 	u16 rfparam;
 	u8 csthreshold;
-
+	u8 mac_addr[ETH_ALEN];
+	u8 rf_type;
 	/* sequence # */
 	u16 seqno;
 };
-- 
1.8.3.2

