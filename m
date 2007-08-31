Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:47832 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751025AbXHaE64 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Aug 2007 00:58:56 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 1/6] adm8211: Switch to eeprom_93cx6
Date: Fri, 31 Aug 2007 00:55:37 -0400
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Message-Id: <200708310055.37580.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8";
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

This makes adm8211 use the eeprom_93cx6 library.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 drivers/net/wireless/Kconfig   |    3 +
 drivers/net/wireless/adm8211.c |   85 ++++++++++++++++------------------------
 2 files changed, 37 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index f14f04c..b73a751 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -560,8 +560,9 @@ config RTL8187
 
 config ADM8211
 	tristate "ADMtek ADM8211 support"
-	depends on PCI && WLAN_80211 && MAC80211 && EXPERIMENTAL
+	depends on MAC80211 && PCI && WLAN_80211 && EXPERIMENTAL
 	select CRC32
+	select EEPROM_93CX6
 	---help---
 	  This driver is for ADM8211A, ADM8211B, and ADM8211C based cards.
 	  These are PCI/mini-PCI/Cardbus 802.11b chips found in cards such as:
diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index 5ab798c..e307412 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -3,7 +3,7 @@
  * Linux device driver for ADMtek ADM8211 (IEEE 802.11b MAC/BBP)
  *
  * Copyright (c) 2003, Jouni Malinen <jkmaline@cc.hut.fi>
- * Copyright (c) 2004-2006, Michael Wu <flamingice@sourmilk.net>
+ * Copyright (c) 2004-2007, Michael Wu <flamingice@sourmilk.net>
  * Some parts copyright (c) 2003 by David Young <dyoung@pobox.com>
  * and used with permission.
  *
@@ -23,6 +23,7 @@
 #include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/crc32.h>
+#include <linux/eeprom_93cx6.h>
 #include <net/mac80211.h>
 #include <asm/unaligned.h>
 #include <asm/div64.h>
@@ -106,70 +107,56 @@ struct adm8211_tx_hdr {
 #define RX_COPY_BREAK 128
 #define RX_PKT_SIZE 2500
 
-/* Serial EEPROM reading for 93C66/93C46 */
-#define EE_ENB		(0x4000 | ADM8211_SPR_SRS | ADM8211_SPR_SCS)
-#define EE_READ_CMD	(6)
-#define eeprom_delay()	ADM8211_CSR_READ(SPR);
-
-
-static u16 adm8211_eeprom_read_word(struct ieee80211_hw *dev, unsigned int addr,
-				    unsigned int addr_len)
+static void adm8211_eeprom_register_read(struct eeprom_93cx6 *eeprom)
 {
-	struct adm8211_priv *priv = dev->priv;
-	unsigned int read_cmd = addr | (EE_READ_CMD << addr_len);
-	int i;
-	u16 retval = 0;
-
-	ADM8211_CSR_WRITE(SPR, EE_ENB & ~ADM8211_SPR_SCS);
-	eeprom_delay();
-	ADM8211_CSR_WRITE(SPR, EE_ENB);
-	eeprom_delay();
-
-	/* Shift the read command bits out. */
-	for (i = 4 + addr_len; i >= 0; i--) {
-		u32 dataval = EE_ENB | ((read_cmd & (1 << i)) ? ADM8211_SPR_SDI : 0);
-		ADM8211_CSR_WRITE(SPR, dataval);
-		eeprom_delay();
-		ADM8211_CSR_WRITE(SPR, dataval | ADM8211_SPR_SCLK);
-		eeprom_delay();
-	}
-
-	ADM8211_CSR_WRITE(SPR, EE_ENB);
-	eeprom_delay();
-
-	for (i = 16; i > 0; i--) {
-		ADM8211_CSR_WRITE(SPR, EE_ENB | ADM8211_SPR_SCLK);
-		eeprom_delay();
-		retval <<= 1;
-		if (ADM8211_CSR_READ(SPR) & ADM8211_SPR_SDO)
-			retval |= 1;
-		ADM8211_CSR_WRITE(SPR, EE_ENB);
-		eeprom_delay();
-	}
-
-	/* Terminate the EEPROM access. */
-	ADM8211_CSR_WRITE(SPR, EE_ENB & ~ADM8211_SPR_SCS);
+	struct adm8211_priv *priv = eeprom->data;
+	u32 reg = ADM8211_CSR_READ(SPR);
 
-	return retval;
+	eeprom->reg_data_in = reg & ADM8211_SPR_SDI;
+	eeprom->reg_data_out = reg & ADM8211_SPR_SDO;
+	eeprom->reg_data_clock = reg & ADM8211_SPR_SCLK;
+	eeprom->reg_chip_select = reg & ADM8211_SPR_SCS;
 }
 
+static void adm8211_eeprom_register_write(struct eeprom_93cx6 *eeprom)
+{
+	struct adm8211_priv *priv = eeprom->data;
+	u32 reg = 0x4000 | ADM8211_SPR_SRS;
+
+	if (eeprom->reg_data_in)
+		reg |= ADM8211_SPR_SDI;
+	if (eeprom->reg_data_out)
+		reg |= ADM8211_SPR_SDO;
+	if (eeprom->reg_data_clock)
+		reg |= ADM8211_SPR_SCLK;
+	if (eeprom->reg_chip_select)
+		reg |= ADM8211_SPR_SCS;
+
+	ADM8211_CSR_WRITE(SPR, reg);
+	ADM8211_CSR_READ(SPR);		// eeprom_delay
+}
 
 static int adm8211_read_eeprom(struct ieee80211_hw *dev)
 {
 	struct adm8211_priv *priv = dev->priv;
-	unsigned int addr_len, words, i;
+	unsigned int words;
 	struct ieee80211_chan_range chan_range;
 	u16 cr49;
+	struct eeprom_93cx6 eeprom = {
+		.data		= priv,
+		.register_read	= adm8211_eeprom_register_read,
+		.register_write	= adm8211_eeprom_register_write
+	};
 
 	if (ADM8211_CSR_READ(CSR_TEST0) & ADM8211_CSR_TEST0_EPTYP) {
 		printk(KERN_DEBUG "%s (adm8211): EEPROM type: 93C66\n", pci_name(priv->pdev));
 		/* 256 * 16-bit = 512 bytes */
-		addr_len = 8;
+		eeprom.width = PCI_EEPROM_WIDTH_93C66;
 		words = 256;
 	} else {
 		printk(KERN_DEBUG "%s (adm8211): EEPROM type 93C46\n", pci_name(priv->pdev));
 		/* 64 * 16-bit = 128 bytes */
-		addr_len = 6;
+		eeprom.width = PCI_EEPROM_WIDTH_93C46;
 		words = 64;
 	}
 
@@ -178,9 +165,7 @@ static int adm8211_read_eeprom(struct ieee80211_hw *dev)
 	if (priv->eeprom == NULL)
 		return -ENOMEM;
 
-	for (i = 0; i < words; i++)
-		*((u16 *) &((u8 *)priv->eeprom)[i * 2]) =
-			adm8211_eeprom_read_word(dev, i, addr_len);
+	eeprom_93cx6_multiread(&eeprom, 0, (__le16 __force *)priv->eeprom, words);
 
 	cr49 = le16_to_cpu(priv->eeprom->cr49);
 	priv->rf_type = (cr49 >> 3) & 0x7;

