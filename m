Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:34447 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751148AbXIXWNS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 18:13:18 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 4/6] adm8211: Use revision from pci_dev
Date: Mon, 24 Sep 2007 18:10:25 -0400
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Message-Id: <20070924221025.6870.61320.stgit@magic.sourmilk.net>
In-Reply-To: <20070924221025.6870.53754.stgit@magic.sourmilk.net>
References: <20070924221025.6870.53754.stgit@magic.sourmilk.net>
Content-Type: text/plain;
  charset=utf-8;
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

No need to load the revision ourselves anymore.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 drivers/net/wireless/adm8211.c |   44 +++++++++++++++++++---------------------
 drivers/net/wireless/adm8211.h |    4 +---
 2 files changed, 22 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index ce1f8e3..e950a7d 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -117,7 +117,7 @@ static int adm8211_read_eeprom(struct ieee80211_hw *dev)
 		break;
 
 	default:
-		if (priv->revid < ADM8211_REV_CA)
+		if (priv->pdev->revision < ADM8211_REV_CA)
 			priv->rf_type = ADM8211_TYPE_RFMD;
 		else
 			priv->rf_type = ADM8211_TYPE_AIROHA;
@@ -135,7 +135,7 @@ static int adm8211_read_eeprom(struct ieee80211_hw *dev)
 	case ADM8211_TYPE_ADMTEK:
 		break;
 	default:
-		if (priv->revid < ADM8211_REV_CA)
+		if (priv->pdev->revision < ADM8211_REV_CA)
 			priv->bbp_type = ADM8211_TYPE_RFMD;
 		else
 			priv->bbp_type = ADM8211_TYPE_ADMTEK;
@@ -175,7 +175,7 @@ static int adm8211_read_eeprom(struct ieee80211_hw *dev)
 		break;
 
 	default:
-		if (priv->revid < ADM8211_REV_CA)
+		if (priv->pdev->revision < ADM8211_REV_CA)
 			priv->specific_bbptype = ADM8211_BBP_RFMD3000;
 		else
 			priv->specific_bbptype = ADM8211_BBP_ADM8011;
@@ -194,11 +194,11 @@ static int adm8211_read_eeprom(struct ieee80211_hw *dev)
 		break;
 
 	default:
-		if (priv->revid == ADM8211_REV_BA)
+		if (priv->pdev->revision == ADM8211_REV_BA)
 			priv->transceiver_type = ADM8211_RFMD2958_RF3000_CONTROL_POWER;
-		else if (priv->revid == ADM8211_REV_CA)
+		else if (priv->pdev->revision == ADM8211_REV_CA)
 			priv->transceiver_type = ADM8211_AL2210L;
-		else if (priv->revid == ADM8211_REV_AB)
+		else if (priv->pdev->revision == ADM8211_REV_AB)
 			priv->transceiver_type = ADM8211_RFMD2948;
 
 		printk(KERN_WARNING "%s (adm8211): Unknown transceiver: %d\n",
@@ -220,7 +220,7 @@ static inline void adm8211_write_sram(struct ieee80211_hw *dev,
 	struct adm8211_priv *priv = dev->priv;
 
 	ADM8211_CSR_WRITE(WEPCTL, addr | ADM8211_WEPCTL_TABLE_WR |
-			  (priv->revid < ADM8211_REV_BA ?
+			  (priv->pdev->revision < ADM8211_REV_BA ?
 			   0 : ADM8211_WEPCTL_SEL_WEPTABLE ));
 	ADM8211_CSR_READ(WEPCTL);
 	msleep(1);
@@ -238,7 +238,7 @@ static void adm8211_write_sram_bytes(struct ieee80211_hw *dev,
 	u32 reg = ADM8211_CSR_READ(WEPCTL);
 	unsigned int i;
 
-	if (priv->revid < ADM8211_REV_BA) {
+	if (priv->pdev->revision < ADM8211_REV_BA) {
 		for (i = 0; i < len; i += 2) {
 			u16 val = buf[i] | (buf[i + 1] << 8);
 			adm8211_write_sram(dev, addr + i / 2, val);
@@ -421,7 +421,7 @@ static void adm8211_interrupt_rci(struct ieee80211_hw *dev)
 		if (skb) {
 			struct ieee80211_rx_status rx_status = {0};
 
-			if (priv->revid < ADM8211_REV_CA)
+			if (priv->pdev->revision < ADM8211_REV_CA)
 				rx_status.ssi = rssi;
 			else
 				rx_status.ssi = 100 - rssi;
@@ -703,7 +703,7 @@ static int adm8211_rf_set_channel(struct ieee80211_hw *dev, unsigned int chan)
 		adm8211_rf_write_syn_rfmd2958(dev, 0x0A, reg);
 		/* set TXRX TX_GAIN */
 		adm8211_rf_write_syn_rfmd2958(dev, 0x09, 0x00050 |
-			(priv->revid < ADM8211_REV_CA ? tx_power : 0));
+			(priv->pdev->revision < ADM8211_REV_CA ? tx_power : 0));
 	} else {
 		reg = ADM8211_CSR_READ(PLCPHD);
 		reg &= 0xff00ffff;
@@ -722,7 +722,7 @@ static int adm8211_rf_set_channel(struct ieee80211_hw *dev, unsigned int chan)
 				  tx_power<<2);
 	adm8211_write_bbp(dev, RF3000_LOW_GAIN_CALIB, lpf_cutoff);
 	adm8211_write_bbp(dev, RF3000_HIGH_GAIN_CALIB, lnags_thresh);
-	adm8211_write_bbp(dev, 0x1c, priv->revid == ADM8211_REV_BA ?
+	adm8211_write_bbp(dev, 0x1c, priv->pdev->revision == ADM8211_REV_BA ?
 				     priv->eeprom->cr28 : 0);
 	adm8211_write_bbp(dev, 0x1d, priv->eeprom->cr29);
 
@@ -761,7 +761,7 @@ static void adm8211_update_mode(struct ieee80211_hw *dev)
 		priv->nar |= ADM8211_NAR_EA | ADM8211_NAR_ST | ADM8211_NAR_SR;
 
 		/* don't trust the error bits on rev 0x20 and up in adhoc */
-		if (priv->revid >= ADM8211_REV_BA)
+		if (priv->pdev->revision >= ADM8211_REV_BA)
 			priv->soft_rx_crc = 1;
 		break;
 	case IEEE80211_IF_TYPE_MNTR:
@@ -862,7 +862,7 @@ static int adm8211_hw_init_bbp(struct ieee80211_hw *dev)
 			break;
 		}
 
-		switch (priv->revid) {
+		switch (priv->pdev->revision) {
 		case ADM8211_REV_CA:
 			if (priv->transceiver_type == ADM8211_RFMD2958 ||
 			    priv->transceiver_type == ADM8211_RFMD2958_RF3000_CONTROL_POWER ||
@@ -920,7 +920,7 @@ static int adm8211_hw_init_bbp(struct ieee80211_hw *dev)
 			adm8211_write_bbp(dev, 0x1c, 0x00);
 			adm8211_write_bbp(dev, 0x1d, 0x80);
 		} else {
-			if (priv->revid == ADM8211_REV_BA)
+			if (priv->pdev->revision == ADM8211_REV_BA)
 				adm8211_write_bbp(dev, 0x1c, priv->eeprom->cr28);
 			else
 				adm8211_write_bbp(dev, 0x1c, 0x00);
@@ -1052,7 +1052,7 @@ static int adm8211_set_rate(struct ieee80211_hw *dev)
 	u8 rate_buf[12] = {0};
 
 	/* write supported rates */
-	if (priv->revid != ADM8211_REV_BA) {
+	if (priv->pdev->revision != ADM8211_REV_BA) {
 		rate_buf[0] = ARRAY_SIZE(adm8211_rates);
 		for (i = 0; i < ARRAY_SIZE(adm8211_rates); i++)
 			rate_buf[i + 1] = (adm8211_rates[i].rate / 5) | 0x80;
@@ -1136,7 +1136,7 @@ static void adm8211_hw_init(struct ieee80211_hw *dev)
 	 * PWR0PE2  = 13 us
 	 * PWR1PE2  = 1 us
 	 * PWR0TXPE = 8 or 6 */
-	if (priv->revid < ADM8211_REV_CA)
+	if (priv->pdev->revision < ADM8211_REV_CA)
 		ADM8211_CSR_WRITE(TOFS2, 0x8815cd18);
 	else
 		ADM8211_CSR_WRITE(TOFS2, 0x8535cd16);
@@ -1165,7 +1165,7 @@ static void adm8211_hw_init(struct ieee80211_hw *dev)
 
 	/* SLOT=20 us, SIFS=110 cycles of 22 MHz (5 us),
 	 * DIFS=50 us, EIFS=100 us */
-	if (priv->revid < ADM8211_REV_CA)
+	if (priv->pdev->revision < ADM8211_REV_CA)
 		ADM8211_CSR_WRITE(IFST, (20 << 23) | (110 << 15) |
 					(50 << 9)  | 100);
 	else
@@ -1224,13 +1224,13 @@ static int adm8211_hw_reset(struct ieee80211_hw *dev)
 
 	ADM8211_CSR_WRITE(PAR, tmp);
 
-	if (priv->revid == ADM8211_REV_BA &&
+	if (priv->pdev->revision == ADM8211_REV_BA &&
 	    (priv->transceiver_type == ADM8211_RFMD2958_RF3000_CONTROL_POWER ||
 	     priv->transceiver_type == ADM8211_RFMD2958)) {
 		reg = ADM8211_CSR_READ(CSR_TEST1);
 		reg |= (1 << 4) | (1 << 5);
 		ADM8211_CSR_WRITE(CSR_TEST1, reg);
-	} else if (priv->revid == ADM8211_REV_CA) {
+	} else if (priv->pdev->revision == ADM8211_REV_CA) {
 		reg = ADM8211_CSR_READ(CSR_TEST1);
 		reg &= ~((1 << 4) | (1 << 5));
 		ADM8211_CSR_WRITE(CSR_TEST1, reg);
@@ -1866,8 +1866,6 @@ static int __devinit adm8211_probe(struct pci_dev *pdev,
 		goto err_iounmap;
 	}
 
-	pci_read_config_byte(pdev, PCI_CLASS_REVISION, &priv->revid);
-
 	*(u32 *)perm_addr = le32_to_cpu((__force __le32)ADM8211_CSR_READ(PAR0));
 	*(u16 *)&perm_addr[4] =
 		le16_to_cpu((__force __le16)ADM8211_CSR_READ(PAR1) & 0xFFFF);
@@ -1902,7 +1900,7 @@ static int __devinit adm8211_probe(struct pci_dev *pdev,
 	priv->mode = IEEE80211_IF_TYPE_MNTR;
 
 	/* Power-on issue. EEPROM won't read correctly without */
-	if (priv->revid >= ADM8211_REV_BA) {
+	if (pdev->revision >= ADM8211_REV_BA) {
 		ADM8211_CSR_WRITE(FRCTL, 0);
 		ADM8211_CSR_READ(FRCTL);
 		ADM8211_CSR_WRITE(FRCTL, 1);
@@ -1935,7 +1933,7 @@ static int __devinit adm8211_probe(struct pci_dev *pdev,
 
 	printk(KERN_INFO "%s: hwaddr %s, Rev 0x%02x\n",
 	       wiphy_name(dev->wiphy), print_mac(mac, dev->wiphy->perm_addr),
-	       priv->revid);
+	       pdev->revision);
 
 	return 0;
 
diff --git a/drivers/net/wireless/adm8211.h b/drivers/net/wireless/adm8211.h
index 5991b17..ef326fe 100644
--- a/drivers/net/wireless/adm8211.h
+++ b/drivers/net/wireless/adm8211.h
@@ -416,7 +416,7 @@ struct adm8211_desc {
 #define TDES1_CONTROL_RBS1	(0x00000fff)
 
 /* SRAM offsets */
-#define ADM8211_SRAM(x) (priv->revid < ADM8211_REV_BA ? \
+#define ADM8211_SRAM(x) (priv->pdev->revision < ADM8211_REV_BA ? \
         ADM8211_SRAM_A_ ## x : ADM8211_SRAM_B_ ## x)
 
 #define ADM8211_SRAM_INDIV_KEY   0x0000
@@ -623,8 +623,6 @@ struct adm8211_priv {
 	struct adm8211_eeprom *eeprom;
 	size_t eeprom_len;
 
-	u8 revid;
-
 	u32 nar;
 
 #define ADM8211_TYPE_INTERSIL	0x00

