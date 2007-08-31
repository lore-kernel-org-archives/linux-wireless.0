Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:19285 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752532AbXHaE65 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Aug 2007 00:58:57 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 3/6] adm8211: cleanups
Date: Fri, 31 Aug 2007 00:56:05 -0400
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Message-Id: <200708310056.05237.flamingice@sourmilk.net>
In-Reply-To: <20070831045328.3700.81232.stgit@magic.sourmilk.net>
References: <20070831045328.3700.81232.stgit@magic.sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8";
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

A bunch of code cleanups and various small changes like
copyright year and email changes.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 drivers/net/wireless/adm8211.c |  717 ++++++++++++++++++++--------------------
 drivers/net/wireless/adm8211.h |   46 +--
 2 files changed, 373 insertions(+), 390 deletions(-)

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index 76b1a48..575182e 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -2,7 +2,7 @@
 /*
  * Linux device driver for ADMtek ADM8211 (IEEE 802.11b MAC/BBP)
  *
- * Copyright (c) 2003, Jouni Malinen <jkmaline@cc.hut.fi>
+ * Copyright (c) 2003, Jouni Malinen <j@w1.fi>
  * Copyright (c) 2004-2007, Michael Wu <flamingice@sourmilk.net>
  * Some parts copyright (c) 2003 by David Young <dyoung@pobox.com>
  * and used with permission.
@@ -18,34 +18,30 @@
 #include <linux/init.h>
 #include <linux/if.h>
 #include <linux/skbuff.h>
-#include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/crc32.h>
 #include <linux/eeprom_93cx6.h>
 #include <net/mac80211.h>
-#include <asm/unaligned.h>
-#include <asm/div64.h>
 
 #include "adm8211.h"
 
-MODULE_AUTHOR("Michael Wu <flamingice@sourmilk.net>, Jouni Malinen <jkmaline@cc.hut.fi>");
-MODULE_DESCRIPTION("Driver for IEEE 802.11b wireless LAN cards based on ADMtek ADM8211");
+MODULE_AUTHOR("Michael Wu <flamingice@sourmilk.net>");
+MODULE_AUTHOR("Jouni Malinen <j@w1.fi>");
+MODULE_DESCRIPTION("Driver for IEEE 802.11b wireless cards based on ADMtek ADM8211");
 MODULE_SUPPORTED_DEVICE("ADM8211");
 MODULE_LICENSE("GPL");
 
 static unsigned int tx_ring_size __read_mostly = 16;
 static unsigned int rx_ring_size __read_mostly = 16;
-static int debug __read_mostly = 1;
 
 module_param(tx_ring_size, uint, 0);
 module_param(rx_ring_size, uint, 0);
-module_param(debug, int, 0);
 
 static const char version[] = KERN_INFO "adm8211: "
-"Copyright 2003, Jouni Malinen <jkmaline@cc.hut.fi>; "
-"Copyright 2004-2006, Michael Wu <flamingice@sourmilk.net>\n";
+"Copyright 2003, Jouni Malinen <j@w1.fi>; "
+"Copyright 2004-2007, Michael Wu <flamingice@sourmilk.net>\n";
 
 
 static struct pci_device_id adm8211_pci_id_table[] __devinitdata = {
@@ -83,13 +79,13 @@ static void adm8211_eeprom_register_write(struct eeprom_93cx6 *eeprom)
 		reg |= ADM8211_SPR_SCS;
 
 	ADM8211_CSR_WRITE(SPR, reg);
-	ADM8211_CSR_READ(SPR);		// eeprom_delay
+	ADM8211_CSR_READ(SPR);		/* eeprom_delay */
 }
 
 static int adm8211_read_eeprom(struct ieee80211_hw *dev)
 {
 	struct adm8211_priv *priv = dev->priv;
-	unsigned int words;
+	unsigned int words, channels;
 	struct ieee80211_chan_range chan_range;
 	u16 cr49;
 	struct eeprom_93cx6 eeprom = {
@@ -99,12 +95,10 @@ static int adm8211_read_eeprom(struct ieee80211_hw *dev)
 	};
 
 	if (ADM8211_CSR_READ(CSR_TEST0) & ADM8211_CSR_TEST0_EPTYP) {
-		printk(KERN_DEBUG "%s (adm8211): EEPROM type: 93C66\n", pci_name(priv->pdev));
 		/* 256 * 16-bit = 512 bytes */
 		eeprom.width = PCI_EEPROM_WIDTH_93C66;
 		words = 256;
 	} else {
-		printk(KERN_DEBUG "%s (adm8211): EEPROM type 93C46\n", pci_name(priv->pdev));
 		/* 64 * 16-bit = 128 bytes */
 		eeprom.width = PCI_EEPROM_WIDTH_93C46;
 		words = 64;
@@ -112,7 +106,7 @@ static int adm8211_read_eeprom(struct ieee80211_hw *dev)
 
 	priv->eeprom_len = words * 2;
 	priv->eeprom = kmalloc(priv->eeprom_len, GFP_KERNEL);
-	if (priv->eeprom == NULL)
+	if (!priv->eeprom)
 		return -ENOMEM;
 
 	eeprom_93cx6_multiread(&eeprom, 0, (__le16 __force *)priv->eeprom, words);
@@ -133,8 +127,8 @@ static int adm8211_read_eeprom(struct ieee80211_hw *dev)
 		else
 			priv->rf_type = ADM8211_TYPE_AIROHA;
 
-		printk(KERN_WARNING "%s (adm8211): Invalid or unsupported RFtype: %d, assuming %d\n",
-		       pci_name(priv->pdev), (cr49 >> 3) & 0x7, priv->rf_type);
+		printk(KERN_WARNING "%s (adm8211): Unknown RFtype %d\n",
+		       pci_name(priv->pdev), (cr49 >> 3) & 0x7);
 	}
 
 	priv->bbp_type = cr49 & 0x7;
@@ -145,19 +139,18 @@ static int adm8211_read_eeprom(struct ieee80211_hw *dev)
 	case ADM8211_TYPE_AIROHA:
 	case ADM8211_TYPE_ADMTEK:
 		break;
-
 	default:
 		if (priv->revid < ADM8211_REV_CA)
 			priv->bbp_type = ADM8211_TYPE_RFMD;
 		else
 			priv->bbp_type = ADM8211_TYPE_ADMTEK;
 
-		printk(KERN_WARNING "%s (adm8211): Invalid or unsupported BBPtype: %d, assuming %d\n",
-		       pci_name(priv->pdev), cr49 >> 3, priv->bbp_type);
+		printk(KERN_WARNING "%s (adm8211): Unknown BBPtype: %d\n",
+		       pci_name(priv->pdev), cr49 >> 3);
 	}
 
 	if (priv->eeprom->country_code >= ARRAY_SIZE(cranges)) {
-		printk(KERN_WARNING "%s (adm8211): Invalid country code (%d) in EEPROM, assuming ETSI\n",
+		printk(KERN_WARNING "%s (adm8211): Invalid country code (%d)\n",
 		       pci_name(priv->pdev), priv->eeprom->country_code);
 
 		chan_range = cranges[2];
@@ -167,15 +160,17 @@ static int adm8211_read_eeprom(struct ieee80211_hw *dev)
 	printk(KERN_DEBUG "%s (adm8211): Channel range: %d - %d\n",
 	       pci_name(priv->pdev), (int)chan_range.min, (int)chan_range.max);
 
-	priv->modes[0].num_channels = chan_range.max - chan_range.min + 1;
-	priv->modes[0].channels = kmalloc(priv->modes[0].num_channels * sizeof(struct ieee80211_channel), GFP_KERNEL);
-	if (priv->modes[0].channels == NULL) {
+	channels = chan_range.max - chan_range.min + 1;
+	priv->modes[0].num_channels = channels;
+	priv->modes[0].channels = kmalloc(sizeof(struct ieee80211_channel) *
+					  channels, GFP_KERNEL);
+	if (!priv->modes[0].channels) {
 		kfree(priv->eeprom);
 		return -ENOMEM;
 	}
 
-	memcpy(priv->modes[0].channels, &adm8211_channels[chan_range.min-1],
-		priv->modes[0].num_channels * sizeof(struct ieee80211_channel));
+	memcpy(priv->modes[0].channels, &adm8211_channels[chan_range.min - 1],
+	       sizeof(struct ieee80211_channel) * channels);
 
 	switch (priv->eeprom->specific_bbptype) {
 	case ADM8211_BBP_RFMD3000:
@@ -190,8 +185,8 @@ static int adm8211_read_eeprom(struct ieee80211_hw *dev)
 		else
 			priv->specific_bbptype = ADM8211_BBP_ADM8011;
 
-		printk(KERN_WARNING "%s (adm8211): Invalid or unsupported specific BBP: %d, assuming %d\n",
-		       pci_name(priv->pdev), priv->eeprom->specific_bbptype, priv->specific_bbptype);
+		printk(KERN_WARNING "%s (adm8211): Unknown specific BBP: %d\n",
+		       pci_name(priv->pdev), priv->eeprom->specific_bbptype);
 	}
 
 	switch (priv->eeprom->specific_rftype) {
@@ -211,20 +206,21 @@ static int adm8211_read_eeprom(struct ieee80211_hw *dev)
 		else if (priv->revid == ADM8211_REV_AB)
 			priv->transceiver_type = ADM8211_RFMD2948;
 
-		printk(KERN_WARNING "%s (adm8211): Invalid or unsupported transceiver: %d, assuming %d\n",
-		       pci_name(priv->pdev), priv->eeprom->specific_rftype, priv->transceiver_type);
+		printk(KERN_WARNING "%s (adm8211): Unknown transceiver: %d\n",
+		       pci_name(priv->pdev), priv->eeprom->specific_rftype);
 
 		break;
 	}
 
-	printk(KERN_DEBUG "%s (adm8211): RFtype=%d BBPtype=%d Specific BBP=%d Transceiver=%d\n",
-	       pci_name(priv->pdev), priv->rf_type, priv->bbp_type,
-	       priv->specific_bbptype, priv->transceiver_type);
+	printk(KERN_DEBUG "%s (adm8211): RFtype=%d BBPtype=%d Specific BBP=%d "
+               "Transceiver=%d\n", pci_name(priv->pdev), priv->rf_type,
+	       priv->bbp_type, priv->specific_bbptype, priv->transceiver_type);
 
 	return 0;
 }
 
-static inline void adm8211_write_sram(struct ieee80211_hw *dev, u32 addr, u32 data)
+static inline void adm8211_write_sram(struct ieee80211_hw *dev,
+				      u32 addr, u32 data)
 {
 	struct adm8211_priv *priv = dev->priv;
 
@@ -240,15 +236,16 @@ static inline void adm8211_write_sram(struct ieee80211_hw *dev, u32 addr, u32 da
 }
 
 static void adm8211_write_sram_bytes(struct ieee80211_hw *dev,
-				     unsigned int addr, u8 *buf, unsigned int len)
+				     unsigned int addr, u8 *buf,
+				     unsigned int len)
 {
 	struct adm8211_priv *priv = dev->priv;
-	__le32 reg = ADM8211_CSR_READ(WEPCTL);
+	u32 reg = ADM8211_CSR_READ(WEPCTL);
 	unsigned int i;
 
 	if (priv->revid < ADM8211_REV_BA) {
 		for (i = 0; i < len; i += 2) {
-			u16 val = buf[i] | buf[i + 1] << 8;
+			u16 val = buf[i] | (buf[i + 1] << 8);
 			adm8211_write_sram(dev, addr + i / 2, val);
 		}
 	} else {
@@ -269,7 +266,7 @@ static void adm8211_clear_sram(struct ieee80211_hw *dev)
 	unsigned int addr;
 
 	for (addr = 0; addr < ADM8211_SRAM_SIZE; addr++)
-			adm8211_write_sram(dev, addr, 0);
+		adm8211_write_sram(dev, addr, 0);
 
 	ADM8211_CSR_WRITE(WEPCTL, reg);
 }
@@ -289,19 +286,18 @@ static void adm8211_set_rx_mode(struct ieee80211_hw *dev,
 {
 	struct adm8211_priv *priv = dev->priv;
 	unsigned int bit_nr;
-	__le32 mc_filter[2];
+	u32 mc_filter[2];
 	struct dev_mc_list *mclist;
 	void *tmp;
 
-		mc_filter[1] = mc_filter[0] = 0;
 	if (flags & IFF_PROMISC) {
 		priv->nar |= ADM8211_NAR_PR;
 		priv->nar &= ~ADM8211_NAR_MM;
-		mc_filter[1] = mc_filter[0] = cpu_to_le32(~0);
+		mc_filter[1] = mc_filter[0] = ~0;
 	} else if ((flags & IFF_ALLMULTI) || (mc_count > -1)) {
 		priv->nar &= ~ADM8211_NAR_PR;
 		priv->nar |= ADM8211_NAR_MM;
-		mc_filter[1] = mc_filter[0] = cpu_to_le32(~0);
+		mc_filter[1] = mc_filter[0] = ~0;
 	} else {
 		priv->nar &= ~(ADM8211_NAR_MM | ADM8211_NAR_PR);
 		mc_filter[1] = mc_filter[0] = 0;
@@ -310,7 +306,7 @@ static void adm8211_set_rx_mode(struct ieee80211_hw *dev,
 			bit_nr = ether_crc(ETH_ALEN, mclist->dmi_addr) >> 26;
 
 			bit_nr &= 0x3F;
-			mc_filter[bit_nr >> 5] |= cpu_to_le32(1 << (bit_nr & 31));
+			mc_filter[bit_nr >> 5] |= 1 << (bit_nr & 31);
 		}
 	}
 
@@ -339,13 +335,11 @@ static int adm8211_get_tx_stats(struct ieee80211_hw *dev,
 static void adm8211_interrupt_tci(struct ieee80211_hw *dev)
 {
 	struct adm8211_priv *priv = dev->priv;
-	//struct net_device_stats *stats = ieee80211_dev_stats(dev);
 	unsigned dirty_tx;
 
 	spin_lock(&priv->lock);
 
-	for (dirty_tx = priv->dirty_tx;
-	     priv->cur_tx - dirty_tx > 0; dirty_tx++) {
+	for (dirty_tx = priv->dirty_tx; priv->cur_tx - dirty_tx; dirty_tx++) {
 		unsigned entry = dirty_tx % priv->tx_ring_size;
 		u32 status = le32_to_cpu(priv->tx_ring[entry].status);
 
@@ -353,11 +347,11 @@ static void adm8211_interrupt_tci(struct ieee80211_hw *dev)
 		    !(status & TDES0_CONTROL_DONE))
 			break;
 
-		/*	if (status & (TDES0_STATUS_TUF | TDES0_STATUS_TRO))
-				stats->tx_fifo_errors++;*/
+		/* TODO: check TDES0_STATUS_TUF and TDES0_STATUS_TRO */
 
 		pci_unmap_single(priv->pdev, priv->tx_buffers[entry].mapping,
-				 priv->tx_buffers[entry].skb->len, PCI_DMA_TODEVICE);
+				 priv->tx_buffers[entry].skb->len,
+				 PCI_DMA_TODEVICE);
 
 		if (priv->tx_buffers[entry].tx_control.flags &
 		    IEEE80211_TXCTL_REQ_TX_STATUS) {
@@ -388,7 +382,6 @@ static void adm8211_interrupt_tci(struct ieee80211_hw *dev)
 static void adm8211_interrupt_rci(struct ieee80211_hw *dev)
 {
 	struct adm8211_priv *priv = dev->priv;
-	//struct net_device_stats *stats = ieee80211_dev_stats(dev);
 	unsigned int entry = priv->cur_rx % priv->rx_ring_size;
 	u32 status;
 	unsigned pktlen;
@@ -397,9 +390,8 @@ static void adm8211_interrupt_rci(struct ieee80211_hw *dev)
 	static const u8 rate_tbl[] = {10, 20, 55, 110, 220};
 	u8 rssi, rate;
 
-	while (!(priv->rx_ring[entry].status &
-		 cpu_to_le32(RDES0_STATUS_OWN))) {
-		if (limit-- == 0)
+	while (!(priv->rx_ring[entry].status & cpu_to_le32(RDES0_STATUS_OWN))) {
+		if (!limit--)
 			break;
 
 		status = le32_to_cpu(priv->rx_ring[entry].status);
@@ -410,17 +402,15 @@ static void adm8211_interrupt_rci(struct ieee80211_hw *dev)
 		pktlen = status & RDES0_STATUS_FL;
 		if (pktlen > RX_PKT_SIZE) {
 			if (net_ratelimit())
-				printk(KERN_DEBUG "%s: too long frame (pktlen=%d)\n",
+				printk(KERN_DEBUG "%s: frame too long (%d)\n",
 				       wiphy_name(dev->wiphy), pktlen);
 			pktlen = RX_PKT_SIZE;
 		}
 
 		if (!priv->soft_rx_crc && status & RDES0_STATUS_ES) {
 			skb = NULL; /* old buffer will be reused */
-			/*stats->rx_errors++;
-			if (status & (RDES0_STATUS_CRC16E | RDES0_STATUS_CRC32E))
-				stats->rx_crc_errors++;*/
-
+			/* TODO: update RX error stats */
+			/* TODO: check RDES0_STATUS_CRC*E */
 		} else if (pktlen < RX_COPY_BREAK) {
 			skb = dev_alloc_skb(pktlen);
 			if (skb) {
@@ -453,14 +443,15 @@ static void adm8211_interrupt_rci(struct ieee80211_hw *dev)
 						       PCI_DMA_FROMDEVICE);
 			} else {
 				skb = NULL;
-				//stats->rx_dropped++;
+				/* TODO: update rx dropped stats */
 			}
 
 			priv->rx_ring[entry].buffer1 =
 				cpu_to_le32(priv->rx_buffers[entry].mapping);
 		}
 
-		priv->rx_ring[entry].status = cpu_to_le32( RDES0_STATUS_OWN | RDES0_STATUS_SQL );
+		priv->rx_ring[entry].status = cpu_to_le32(RDES0_STATUS_OWN |
+							  RDES0_STATUS_SQL);
 		priv->rx_ring[entry].length =
 			cpu_to_le32(RX_PKT_SIZE |
 				    (entry == priv->rx_ring_size - 1 ?
@@ -492,13 +483,17 @@ static void adm8211_interrupt_rci(struct ieee80211_hw *dev)
 		entry = (++priv->cur_rx) % priv->rx_ring_size;
 	}
 
-	//stats->rx_missed_errors += le32_to_cpu(ADM8211_CSR_READ(LPC)) & 0xFFFF;
+	/* TODO: check LPC and update stats? */
 }
 
 
 static irqreturn_t adm8211_interrupt(int irq, void *dev_id)
 {
-#define ADM8211_INT(x) if (unlikely(stsr & ADM8211_STSR_ ## x)) printk(KERN_DEBUG "%s: " #x "\n", wiphy_name(dev->wiphy))
+#define ADM8211_INT(x)							   \
+do {									   \
+	if (unlikely(stsr & ADM8211_STSR_ ## x))			   \
+		printk(KERN_DEBUG "%s: " #x "\n", wiphy_name(dev->wiphy)); \
+} while (0)
 
 	struct ieee80211_hw *dev = dev_id;
 	struct adm8211_priv *priv = dev->priv;
@@ -519,16 +514,8 @@ static irqreturn_t adm8211_interrupt(int irq, void *dev_id)
 		if (stsr & ADM8211_STSR_TCI)
 			adm8211_interrupt_tci(dev);
 
-		if ((stsr & (ADM8211_STSR_LinkOn | ADM8211_STSR_LinkOff))
-			 != (ADM8211_STSR_LinkOn | ADM8211_STSR_LinkOff)) {
-			if (stsr & ADM8211_STSR_LinkOn)
-				printk(KERN_DEBUG "%s: LinkOn\n",
-				       wiphy_name(dev->wiphy));
-
-			if (stsr & ADM8211_STSR_LinkOff)
-				printk(KERN_DEBUG "%s: LinkOff\n",
-				       wiphy_name(dev->wiphy));
-		}
+		/*ADM8211_INT(LinkOn);*/
+		/*ADM8211_INT(LinkOff);*/
 
 		ADM8211_INT(PCF);
 		ADM8211_INT(BCNTC);
@@ -559,72 +546,61 @@ static irqreturn_t adm8211_interrupt(int irq, void *dev_id)
 #undef ADM8211_INT
 }
 
-#define WRITE_SYN(valmask,valshift,addrmask,addrshift,bits,prewrite,postwrite) do {\
-	struct adm8211_priv *priv = dev->priv;\
-	unsigned int i;\
-	u32 reg, bitbuf;\
-	\
-	value &= valmask;\
-	addr &= addrmask;\
-	bitbuf = (value << valshift) | (addr << addrshift);\
-	\
-	ADM8211_CSR_WRITE(SYNRF, ADM8211_SYNRF_IF_SELECT_1); \
-	ADM8211_CSR_READ(SYNRF);\
-	ADM8211_CSR_WRITE(SYNRF, ADM8211_SYNRF_IF_SELECT_0); \
-	ADM8211_CSR_READ(SYNRF);\
-	\
-	if (prewrite) {\
-		ADM8211_CSR_WRITE(SYNRF, ADM8211_SYNRF_WRITE_SYNDATA_0);\
-		ADM8211_CSR_READ(SYNRF);\
-	}\
-	\
-	for (i = 0; i <= bits; i++) {\
-		if ( bitbuf & (1 << (bits - i)) )\
-			reg = ADM8211_SYNRF_WRITE_SYNDATA_1;\
-		else\
-			reg = ADM8211_SYNRF_WRITE_SYNDATA_0;\
-		\
-		ADM8211_CSR_WRITE(SYNRF, reg);\
-		ADM8211_CSR_READ(SYNRF);\
-		\
-		ADM8211_CSR_WRITE(SYNRF, reg | ADM8211_SYNRF_WRITE_CLOCK_1);\
-		ADM8211_CSR_READ(SYNRF);\
-		ADM8211_CSR_WRITE(SYNRF, reg | ADM8211_SYNRF_WRITE_CLOCK_0);\
-		ADM8211_CSR_READ(SYNRF);\
-	}\
-	\
-	if (postwrite == 1) {\
-		ADM8211_CSR_WRITE(SYNRF, reg | ADM8211_SYNRF_IF_SELECT_0);\
-		ADM8211_CSR_READ(SYNRF);\
-	}\
-	if (postwrite == 2) {\
-		ADM8211_CSR_WRITE(SYNRF, reg | ADM8211_SYNRF_IF_SELECT_1);\
-		ADM8211_CSR_READ(SYNRF);\
-	}\
-	\
-	ADM8211_CSR_WRITE(SYNRF, 0);\
-	ADM8211_CSR_READ(SYNRF);\
-} while (0)
-
-static void adm8211_rf_write_syn_max2820 (struct ieee80211_hw *dev, u16 addr, u32 value)
-{
-	WRITE_SYN(0x00FFF, 0, 0x0F, 12, 15, 1, 1);
-}
-
-static void adm8211_rf_write_syn_al2210l (struct ieee80211_hw *dev, u16 addr, u32 value)
-{
-	WRITE_SYN(0xFFFFF, 4, 0x0F,  0, 23, 1, 1);
+#define WRITE_SYN(name,v_mask,v_shift,a_mask,a_shift,bits,prewrite,postwrite)\
+static void adm8211_rf_write_syn_ ## name (struct ieee80211_hw *dev,	     \
+					   u16 addr, u32 value) {	     \
+	struct adm8211_priv *priv = dev->priv;				     \
+	unsigned int i;							     \
+	u32 reg, bitbuf;						     \
+									     \
+	value &= v_mask;						     \
+	addr &= a_mask;							     \
+	bitbuf = (value << v_shift) | (addr << a_shift);		     \
+									     \
+	ADM8211_CSR_WRITE(SYNRF, ADM8211_SYNRF_IF_SELECT_1);		     \
+	ADM8211_CSR_READ(SYNRF);					     \
+	ADM8211_CSR_WRITE(SYNRF, ADM8211_SYNRF_IF_SELECT_0);		     \
+	ADM8211_CSR_READ(SYNRF);					     \
+									     \
+	if (prewrite) {							     \
+		ADM8211_CSR_WRITE(SYNRF, ADM8211_SYNRF_WRITE_SYNDATA_0);     \
+		ADM8211_CSR_READ(SYNRF);				     \
+	}								     \
+									     \
+	for (i = 0; i <= bits; i++) {					     \
+		if (bitbuf & (1 << (bits - i)))				     \
+			reg = ADM8211_SYNRF_WRITE_SYNDATA_1;		     \
+		else							     \
+			reg = ADM8211_SYNRF_WRITE_SYNDATA_0;		     \
+									     \
+		ADM8211_CSR_WRITE(SYNRF, reg);				     \
+		ADM8211_CSR_READ(SYNRF);				     \
+									     \
+		ADM8211_CSR_WRITE(SYNRF, reg | ADM8211_SYNRF_WRITE_CLOCK_1); \
+		ADM8211_CSR_READ(SYNRF);				     \
+		ADM8211_CSR_WRITE(SYNRF, reg | ADM8211_SYNRF_WRITE_CLOCK_0); \
+		ADM8211_CSR_READ(SYNRF);				     \
+	}								     \
+									     \
+	if (postwrite == 1) {						     \
+		ADM8211_CSR_WRITE(SYNRF, reg | ADM8211_SYNRF_IF_SELECT_0);   \
+		ADM8211_CSR_READ(SYNRF);				     \
+	}								     \
+	if (postwrite == 2) {						     \
+		ADM8211_CSR_WRITE(SYNRF, reg | ADM8211_SYNRF_IF_SELECT_1);   \
+		ADM8211_CSR_READ(SYNRF);				     \
+	}								     \
+									     \
+	ADM8211_CSR_WRITE(SYNRF, 0);					     \
+	ADM8211_CSR_READ(SYNRF);					     \
 }
 
-static void adm8211_rf_write_syn_rfmd2958 (struct ieee80211_hw *dev, u16 addr, u32 value)
-{
-	WRITE_SYN(0x3FFFF, 0, 0x1F, 18, 23, 0, 1);
-}
+WRITE_SYN(max2820,  0x00FFF, 0, 0x0F, 12, 15, 1, 1)
+WRITE_SYN(al2210l,  0xFFFFF, 4, 0x0F,  0, 23, 1, 1)
+WRITE_SYN(rfmd2958, 0x3FFFF, 0, 0x1F, 18, 23, 0, 1)
+WRITE_SYN(rfmd2948, 0x0FFFF, 4, 0x0F,  0, 21, 0, 2)
 
-static void adm8211_rf_write_syn_rfmd2948 (struct ieee80211_hw *dev, u16 addr, u32 value)
-{
-	WRITE_SYN(0x0FFFF, 4, 0x0F,  0, 21, 0, 2);
-}
+#undef WRITE_SYN
 
 static int adm8211_write_bbp(struct ieee80211_hw *dev, u8 addr, u8 data)
 {
@@ -653,12 +629,12 @@ static int adm8211_write_bbp(struct ieee80211_hw *dev, u8 addr, u8 data)
 		reg = ADM8211_BBPCTL_MMISEL;	/* three wire interface */
 		break;
 	case ADM8211_TYPE_RFMD:
-		reg = (0x20<<24) | ADM8211_BBPCTL_TXCE | ADM8211_BBPCTL_CCAP |
-		      (0x01<<18);
+		reg = (0x20 << 24) | ADM8211_BBPCTL_TXCE | ADM8211_BBPCTL_CCAP |
+		      (0x01 << 18);
 		break;
 	case ADM8211_TYPE_ADMTEK:
-		reg = (0x20<<24) | ADM8211_BBPCTL_TXCE | ADM8211_BBPCTL_CCAP |
-		      (0x05<<18);
+		reg = (0x20 << 24) | ADM8211_BBPCTL_TXCE | ADM8211_BBPCTL_CCAP |
+		      (0x05 << 18);
 		break;
 	}
 	reg |= ADM8211_BBPCTL_WR | (addr << 8) | data;
@@ -686,7 +662,7 @@ static int adm8211_write_bbp(struct ieee80211_hw *dev, u8 addr, u8 data)
 	return 0;
 }
 
-static int adm8211_rf_set_channel(struct ieee80211_hw *dev, unsigned int channel)
+static int adm8211_rf_set_channel(struct ieee80211_hw *dev, unsigned int chan)
 {
 	static const u32 adm8211_rfmd2958_reg5[] =
 		{0x22BD, 0x22D2, 0x22E8, 0x22FE, 0x2314, 0x232A, 0x2340,
@@ -697,18 +673,15 @@ static int adm8211_rf_set_channel(struct ieee80211_hw *dev, unsigned int channel
 
 	struct adm8211_priv *priv = dev->priv;
 	u8 ant_power = priv->ant_power > 0x3F ?
-		priv->eeprom->antenna_power[channel-1] : priv->ant_power;
+		priv->eeprom->antenna_power[chan - 1] : priv->ant_power;
 	u8 tx_power = priv->tx_power > 0x3F ?
-		priv->eeprom->tx_power[channel-1] : priv->tx_power;
+		priv->eeprom->tx_power[chan - 1] : priv->tx_power;
 	u8 lpf_cutoff = priv->lpf_cutoff == 0xFF ?
-		priv->eeprom->lpf_cutoff[channel-1] : priv->lpf_cutoff;
+		priv->eeprom->lpf_cutoff[chan - 1] : priv->lpf_cutoff;
 	u8 lnags_thresh = priv->lnags_threshold == 0xFF ?
-		priv->eeprom->lnags_threshold[channel-1] : priv->lnags_threshold;
+		priv->eeprom->lnags_threshold[chan - 1] : priv->lnags_threshold;
 	u32 reg;
 
-	if (channel < 1 || channel > 14)
-		return -EINVAL;
-
 	ADM8211_IDLE();
 
 	/* Program synthesizer to new channel */
@@ -719,18 +692,21 @@ static int adm8211_rf_set_channel(struct ieee80211_hw *dev, unsigned int channel
 		adm8211_rf_write_syn_rfmd2958(dev, 0x02, 0x00033);
 
 		adm8211_rf_write_syn_rfmd2958(dev, 0x05,
-					adm8211_rfmd2958_reg5[channel-1]);
+			adm8211_rfmd2958_reg5[chan - 1]);
 		adm8211_rf_write_syn_rfmd2958(dev, 0x06,
-					adm8211_rfmd2958_reg6[channel-1]);
+			adm8211_rfmd2958_reg6[chan - 1]);
 		break;
 
 	case ADM8211_RFMD2948:
-		adm8211_rf_write_syn_rfmd2948(dev, SI4126_MAIN_CONF, SI4126_MAIN_XINDIV2);
+		adm8211_rf_write_syn_rfmd2948(dev, SI4126_MAIN_CONF,
+					      SI4126_MAIN_XINDIV2);
 		adm8211_rf_write_syn_rfmd2948(dev, SI4126_POWERDOWN,
-				     SI4126_POWERDOWN_PDIB | SI4126_POWERDOWN_PDRB);
+					      SI4126_POWERDOWN_PDIB |
+					      SI4126_POWERDOWN_PDRB);
 		adm8211_rf_write_syn_rfmd2948(dev, SI4126_PHASE_DET_GAIN, 0);
 		adm8211_rf_write_syn_rfmd2948(dev, SI4126_RF2_N_DIV,
-				     (channel == 14 ? 2110 : (2033 + (channel * 5))));
+					      (chan == 14 ?
+					       2110 : (2033 + (chan * 5))));
 		adm8211_rf_write_syn_rfmd2948(dev, SI4126_IF_N_DIV, 1496);
 		adm8211_rf_write_syn_rfmd2948(dev, SI4126_RF2_R_DIV, 44);
 		adm8211_rf_write_syn_rfmd2948(dev, SI4126_IF_R_DIV, 44);
@@ -738,12 +714,12 @@ static int adm8211_rf_set_channel(struct ieee80211_hw *dev, unsigned int channel
 
 	case ADM8211_MAX2820:
 		adm8211_rf_write_syn_max2820(dev, 0x3,
-			(channel == 14 ? 0x054 : (0x7 + (channel * 5))));
+			(chan == 14 ? 0x054 : (0x7 + (chan * 5))));
 		break;
 
 	case ADM8211_AL2210L:
 		adm8211_rf_write_syn_al2210l(dev, 0x0,
-			(channel == 14 ? 0x229B4 : (0x22967 + (channel * 5))));
+			(chan == 14 ? 0x229B4 : (0x22967 + (chan * 5))));
 		break;
 
 	default:
@@ -761,7 +737,7 @@ static int adm8211_rf_set_channel(struct ieee80211_hw *dev, unsigned int channel
 		reg = ADM8211_CSR_READ(GPIO);
 		reg &= 0xfffc0000;
 		reg |= ADM8211_CSR_GPIO_EN0;
-		if (channel != 14)
+		if (chan != 14)
 			reg |= ADM8211_CSR_GPIO_O0;
 		ADM8211_CSR_WRITE(GPIO, reg);
 	}
@@ -773,7 +749,7 @@ static int adm8211_rf_set_channel(struct ieee80211_hw *dev, unsigned int channel
 		reg = le16_to_cpu(priv->eeprom->cr49);
 		reg >>= 13;
 		reg <<= 15;
-		reg |= ant_power<<9;
+		reg |= ant_power << 9;
 		adm8211_rf_write_syn_rfmd2958(dev, 0x0A, reg);
 		/* set TXRX TX_GAIN */
 		adm8211_rf_write_syn_rfmd2958(dev, 0x09, 0x00050 |
@@ -781,7 +757,7 @@ static int adm8211_rf_set_channel(struct ieee80211_hw *dev, unsigned int channel
 	} else {
 		reg = ADM8211_CSR_READ(PLCPHD);
 		reg &= 0xff00ffff;
-		reg |= tx_power<<18;
+		reg |= tx_power << 18;
 		ADM8211_CSR_WRITE(PLCPHD, reg);
 	}
 
@@ -796,23 +772,23 @@ static int adm8211_rf_set_channel(struct ieee80211_hw *dev, unsigned int channel
 				  tx_power<<2);
 	adm8211_write_bbp(dev, RF3000_LOW_GAIN_CALIB, lpf_cutoff);
 	adm8211_write_bbp(dev, RF3000_HIGH_GAIN_CALIB, lnags_thresh);
-	adm8211_write_bbp(dev, 0x1c, priv->revid == ADM8211_REV_BA
-			  ? priv->eeprom->cr28 : 0);
+	adm8211_write_bbp(dev, 0x1c, priv->revid == ADM8211_REV_BA ?
+				     priv->eeprom->cr28 : 0);
 	adm8211_write_bbp(dev, 0x1d, priv->eeprom->cr29);
 
 	ADM8211_CSR_WRITE(SYNRF, 0);
 
-	} else if (priv->bbp_type != ADM8211_TYPE_ADMTEK) {	/* Nothing to do for ADMtek BBP */
+	/* Nothing to do for ADMtek BBP */
+	} else if (priv->bbp_type != ADM8211_TYPE_ADMTEK)
 		printk(KERN_DEBUG "%s: unsupported BBP type %d\n",
 		       wiphy_name(dev->wiphy), priv->bbp_type);
-	}
 
 	ADM8211_RESTORE();
 
 	/* update current channel for adhoc (and maybe AP mode) */
 	reg = ADM8211_CSR_READ(CAP0);
 	reg &= ~0xF;
-	reg |= channel;
+	reg |= chan;
 	ADM8211_CSR_WRITE(CAP0, reg);
 
 	return 0;
@@ -854,7 +830,7 @@ static void adm8211_hw_init_syn(struct ieee80211_hw *dev)
 	switch (priv->transceiver_type) {
 	case ADM8211_RFMD2958:
 	case ADM8211_RFMD2958_RF3000_CONTROL_POWER:
-		/* comments taken from ADMtek driver */
+		/* comments taken from ADMtek vendor driver */
 
 		/* Reset RF2958 after power on */
 		adm8211_rf_write_syn_rfmd2958(dev, 0x1F, 0x00000);
@@ -870,8 +846,8 @@ static void adm8211_hw_init_syn(struct ieee80211_hw *dev)
 		adm8211_rf_write_syn_rfmd2958(dev, 0x07, 0x1456F);
 		/* Initialize TX gain and filter BW (R9) */
 		adm8211_rf_write_syn_rfmd2958(dev, 0x09,
-			(priv->transceiver_type == ADM8211_RFMD2958
-			? 0x10050 : 0x00050) );
+			(priv->transceiver_type == ADM8211_RFMD2958 ?
+			 0x10050 : 0x00050));
 		/* Initialize CAL register */
 		adm8211_rf_write_syn_rfmd2958(dev, 0x08, 0x3FFF8);
 		break;
@@ -917,53 +893,52 @@ static int adm8211_hw_init_bbp(struct ieee80211_hw *dev)
 		ADM8211_CSR_WRITE(MMIRD1, 0x00100000);
 	} else if (priv->bbp_type == ADM8211_TYPE_RFMD ||
 		   priv->bbp_type == ADM8211_TYPE_ADMTEK) {
+		/* check specific BBP type */
+		switch (priv->specific_bbptype) {
+		case ADM8211_BBP_RFMD3000:
+		case ADM8211_BBP_RFMD3002:
+			ADM8211_CSR_WRITE(MMIWA,  0x00009101);
+			ADM8211_CSR_WRITE(MMIRD0, 0x00000301);
+			break;
 
-	/* check specific BBP type */
-	switch (priv->specific_bbptype) {
-	case ADM8211_BBP_RFMD3000:
-	case ADM8211_BBP_RFMD3002:
-		ADM8211_CSR_WRITE(MMIWA,  0x00009101);
-		ADM8211_CSR_WRITE(MMIRD0, 0x00000301);
-		break;
-
-	case ADM8211_BBP_ADM8011:
-		ADM8211_CSR_WRITE(MMIWA,  0x00008903);
-		ADM8211_CSR_WRITE(MMIRD0, 0x00001716);
+		case ADM8211_BBP_ADM8011:
+			ADM8211_CSR_WRITE(MMIWA,  0x00008903);
+			ADM8211_CSR_WRITE(MMIRD0, 0x00001716);
 
-		reg = ADM8211_CSR_READ(BBPCTL);
-		reg &= ~ADM8211_BBPCTL_TYPE;
-		reg |= 0x5 << 18;
-		ADM8211_CSR_WRITE(BBPCTL, reg);
-		break;
-	}
+			reg = ADM8211_CSR_READ(BBPCTL);
+			reg &= ~ADM8211_BBPCTL_TYPE;
+			reg |= 0x5 << 18;
+			ADM8211_CSR_WRITE(BBPCTL, reg);
+			break;
+		}
 
-	switch (priv->revid) {
-	case ADM8211_REV_CA:
-		if (priv->transceiver_type == ADM8211_RFMD2958 ||
-		    priv->transceiver_type == ADM8211_RFMD2958_RF3000_CONTROL_POWER ||
-		    priv->transceiver_type == ADM8211_RFMD2948)
-			ADM8211_CSR_WRITE(SYNCTL, 0x1 << 22);
-		else if (priv->transceiver_type == ADM8211_MAX2820 ||
-			 priv->transceiver_type == ADM8211_AL2210L)
-			ADM8211_CSR_WRITE(SYNCTL, 0x3 << 22);
-		break;
+		switch (priv->revid) {
+		case ADM8211_REV_CA:
+			if (priv->transceiver_type == ADM8211_RFMD2958 ||
+			    priv->transceiver_type == ADM8211_RFMD2958_RF3000_CONTROL_POWER ||
+			    priv->transceiver_type == ADM8211_RFMD2948)
+				ADM8211_CSR_WRITE(SYNCTL, 0x1 << 22);
+			else if (priv->transceiver_type == ADM8211_MAX2820 ||
+				 priv->transceiver_type == ADM8211_AL2210L)
+				ADM8211_CSR_WRITE(SYNCTL, 0x3 << 22);
+			break;
 
-	case ADM8211_REV_BA:
-		reg  = ADM8211_CSR_READ(MMIRD1);
-		reg &= 0x0000FFFF;
-		reg |= 0x7e100000;
-		ADM8211_CSR_WRITE(MMIRD1, reg);
-		break;
+		case ADM8211_REV_BA:
+			reg  = ADM8211_CSR_READ(MMIRD1);
+			reg &= 0x0000FFFF;
+			reg |= 0x7e100000;
+			ADM8211_CSR_WRITE(MMIRD1, reg);
+			break;
 
-	case ADM8211_REV_AB:
-	case ADM8211_REV_AF:
-	default:
-		ADM8211_CSR_WRITE(MMIRD1, 0x7E100000);
-		break;
-	}
+		case ADM8211_REV_AB:
+		case ADM8211_REV_AF:
+		default:
+			ADM8211_CSR_WRITE(MMIRD1, 0x7e100000);
+			break;
+		}
 
-	/* For RFMD */
-	ADM8211_CSR_WRITE(MACTEST, 0x800);
+		/* For RFMD */
+		ADM8211_CSR_WRITE(MACTEST, 0x800);
 	}
 
 	adm8211_hw_init_syn(dev);
@@ -985,7 +960,8 @@ static int adm8211_hw_init_bbp(struct ieee80211_hw *dev)
 		 * 1d: 84
 		 */
 		adm8211_write_bbp(dev, RF3000_CCA_CTRL, 0x80);
-		adm8211_write_bbp(dev, RF3000_DIVERSITY__RSSI, 0x80); /* antenna selection: diversity */
+		/* antenna selection: diversity */
+		adm8211_write_bbp(dev, RF3000_DIVERSITY__RSSI, 0x80);
 		adm8211_write_bbp(dev, RF3000_TX_VAR_GAIN__TX_LEN_EXT, 0x74);
 		adm8211_write_bbp(dev, RF3000_LOW_GAIN_CALIB, 0x38);
 		adm8211_write_bbp(dev, RF3000_HIGH_GAIN_CALIB, 0x40);
@@ -1002,109 +978,110 @@ static int adm8211_hw_init_bbp(struct ieee80211_hw *dev)
 			adm8211_write_bbp(dev, 0x1d, priv->eeprom->cr29);
 		}
 	} else if (priv->bbp_type == ADM8211_TYPE_ADMTEK) {
-	adm8211_write_bbp(dev, 0x00, 0xFF);	/* reset baseband */
-	adm8211_write_bbp(dev, 0x07, 0x0A);	/* antenna selection: diversity */
-
-	/* TODO: find documentation for this */
-	switch (priv->transceiver_type) {
-	case ADM8211_RFMD2958:
-	case ADM8211_RFMD2958_RF3000_CONTROL_POWER:
-		adm8211_write_bbp(dev, 0x00, 0x00);
-		adm8211_write_bbp(dev, 0x01, 0x00);
-		adm8211_write_bbp(dev, 0x02, 0x00);
-		adm8211_write_bbp(dev, 0x03, 0x00);
-		adm8211_write_bbp(dev, 0x06, 0x0f);
-		adm8211_write_bbp(dev, 0x09, 0x00);
-		adm8211_write_bbp(dev, 0x0a, 0x00);
-		adm8211_write_bbp(dev, 0x0b, 0x00);
-		adm8211_write_bbp(dev, 0x0c, 0x00);
-		adm8211_write_bbp(dev, 0x0f, 0xAA);
-		adm8211_write_bbp(dev, 0x10, 0x8c);
-		adm8211_write_bbp(dev, 0x11, 0x43);
-		adm8211_write_bbp(dev, 0x18, 0x40);
-		adm8211_write_bbp(dev, 0x20, 0x23);
-		adm8211_write_bbp(dev, 0x21, 0x02);
-		adm8211_write_bbp(dev, 0x22, 0x28);
-		adm8211_write_bbp(dev, 0x23, 0x30);
-		adm8211_write_bbp(dev, 0x24, 0x2d);
-		adm8211_write_bbp(dev, 0x28, 0x35);
-		adm8211_write_bbp(dev, 0x2a, 0x8c);
-		adm8211_write_bbp(dev, 0x2b, 0x81);
-		adm8211_write_bbp(dev, 0x2c, 0x44);
-		adm8211_write_bbp(dev, 0x2d, 0x0A);
-		adm8211_write_bbp(dev, 0x29, 0x40);
-		adm8211_write_bbp(dev, 0x60, 0x08);
-		adm8211_write_bbp(dev, 0x64, 0x01);
-		break;
+		/* reset baseband */
+		adm8211_write_bbp(dev, 0x00, 0xFF);
+		/* antenna selection: diversity */
+		adm8211_write_bbp(dev, 0x07, 0x0A);
+
+		/* TODO: find documentation for this */
+		switch (priv->transceiver_type) {
+		case ADM8211_RFMD2958:
+		case ADM8211_RFMD2958_RF3000_CONTROL_POWER:
+			adm8211_write_bbp(dev, 0x00, 0x00);
+			adm8211_write_bbp(dev, 0x01, 0x00);
+			adm8211_write_bbp(dev, 0x02, 0x00);
+			adm8211_write_bbp(dev, 0x03, 0x00);
+			adm8211_write_bbp(dev, 0x06, 0x0f);
+			adm8211_write_bbp(dev, 0x09, 0x00);
+			adm8211_write_bbp(dev, 0x0a, 0x00);
+			adm8211_write_bbp(dev, 0x0b, 0x00);
+			adm8211_write_bbp(dev, 0x0c, 0x00);
+			adm8211_write_bbp(dev, 0x0f, 0xAA);
+			adm8211_write_bbp(dev, 0x10, 0x8c);
+			adm8211_write_bbp(dev, 0x11, 0x43);
+			adm8211_write_bbp(dev, 0x18, 0x40);
+			adm8211_write_bbp(dev, 0x20, 0x23);
+			adm8211_write_bbp(dev, 0x21, 0x02);
+			adm8211_write_bbp(dev, 0x22, 0x28);
+			adm8211_write_bbp(dev, 0x23, 0x30);
+			adm8211_write_bbp(dev, 0x24, 0x2d);
+			adm8211_write_bbp(dev, 0x28, 0x35);
+			adm8211_write_bbp(dev, 0x2a, 0x8c);
+			adm8211_write_bbp(dev, 0x2b, 0x81);
+			adm8211_write_bbp(dev, 0x2c, 0x44);
+			adm8211_write_bbp(dev, 0x2d, 0x0A);
+			adm8211_write_bbp(dev, 0x29, 0x40);
+			adm8211_write_bbp(dev, 0x60, 0x08);
+			adm8211_write_bbp(dev, 0x64, 0x01);
+			break;
 
-	case ADM8211_MAX2820:
-		adm8211_write_bbp(dev, 0x00, 0x00);
-		adm8211_write_bbp(dev, 0x01, 0x00);
-		adm8211_write_bbp(dev, 0x02, 0x00);
-		adm8211_write_bbp(dev, 0x03, 0x00);
-		adm8211_write_bbp(dev, 0x06, 0x0f);
-		adm8211_write_bbp(dev, 0x09, 0x05);
-		adm8211_write_bbp(dev, 0x0a, 0x02);
-		adm8211_write_bbp(dev, 0x0b, 0x00);
-		adm8211_write_bbp(dev, 0x0c, 0x0f);
-		adm8211_write_bbp(dev, 0x0f, 0x55);
-		adm8211_write_bbp(dev, 0x10, 0x8d);
-		adm8211_write_bbp(dev, 0x11, 0x43);
-		adm8211_write_bbp(dev, 0x18, 0x4a);
-		adm8211_write_bbp(dev, 0x20, 0x20);
-		adm8211_write_bbp(dev, 0x21, 0x02);
-		adm8211_write_bbp(dev, 0x22, 0x23);
-		adm8211_write_bbp(dev, 0x23, 0x30);
-		adm8211_write_bbp(dev, 0x24, 0x2d);
-		adm8211_write_bbp(dev, 0x2a, 0x8c);
-		adm8211_write_bbp(dev, 0x2b, 0x81);
-		adm8211_write_bbp(dev, 0x2c, 0x44);
-		adm8211_write_bbp(dev, 0x29, 0x4a);
-		adm8211_write_bbp(dev, 0x60, 0x2b);
-		adm8211_write_bbp(dev, 0x64, 0x01);
-		break;
+		case ADM8211_MAX2820:
+			adm8211_write_bbp(dev, 0x00, 0x00);
+			adm8211_write_bbp(dev, 0x01, 0x00);
+			adm8211_write_bbp(dev, 0x02, 0x00);
+			adm8211_write_bbp(dev, 0x03, 0x00);
+			adm8211_write_bbp(dev, 0x06, 0x0f);
+			adm8211_write_bbp(dev, 0x09, 0x05);
+			adm8211_write_bbp(dev, 0x0a, 0x02);
+			adm8211_write_bbp(dev, 0x0b, 0x00);
+			adm8211_write_bbp(dev, 0x0c, 0x0f);
+			adm8211_write_bbp(dev, 0x0f, 0x55);
+			adm8211_write_bbp(dev, 0x10, 0x8d);
+			adm8211_write_bbp(dev, 0x11, 0x43);
+			adm8211_write_bbp(dev, 0x18, 0x4a);
+			adm8211_write_bbp(dev, 0x20, 0x20);
+			adm8211_write_bbp(dev, 0x21, 0x02);
+			adm8211_write_bbp(dev, 0x22, 0x23);
+			adm8211_write_bbp(dev, 0x23, 0x30);
+			adm8211_write_bbp(dev, 0x24, 0x2d);
+			adm8211_write_bbp(dev, 0x2a, 0x8c);
+			adm8211_write_bbp(dev, 0x2b, 0x81);
+			adm8211_write_bbp(dev, 0x2c, 0x44);
+			adm8211_write_bbp(dev, 0x29, 0x4a);
+			adm8211_write_bbp(dev, 0x60, 0x2b);
+			adm8211_write_bbp(dev, 0x64, 0x01);
+			break;
 
-	case ADM8211_AL2210L:
-		adm8211_write_bbp(dev, 0x00, 0x00);
-		adm8211_write_bbp(dev, 0x01, 0x00);
-		adm8211_write_bbp(dev, 0x02, 0x00);
-		adm8211_write_bbp(dev, 0x03, 0x00);
-		adm8211_write_bbp(dev, 0x06, 0x0f);
-		adm8211_write_bbp(dev, 0x07, 0x05);
-		adm8211_write_bbp(dev, 0x08, 0x03);
-		adm8211_write_bbp(dev, 0x09, 0x00);
-		adm8211_write_bbp(dev, 0x0a, 0x00);
-		adm8211_write_bbp(dev, 0x0b, 0x00);
-		adm8211_write_bbp(dev, 0x0c, 0x10);
-		adm8211_write_bbp(dev, 0x0f, 0x55);
-		adm8211_write_bbp(dev, 0x10, 0x8d);
-		adm8211_write_bbp(dev, 0x11, 0x43);
-		adm8211_write_bbp(dev, 0x18, 0x4a);
-		adm8211_write_bbp(dev, 0x20, 0x20);
-		adm8211_write_bbp(dev, 0x21, 0x02);
-		adm8211_write_bbp(dev, 0x22, 0x23);
-		adm8211_write_bbp(dev, 0x23, 0x30);
-		adm8211_write_bbp(dev, 0x24, 0x2d);
-		adm8211_write_bbp(dev, 0x2a, 0xaa);
-		adm8211_write_bbp(dev, 0x2b, 0x81);
-		adm8211_write_bbp(dev, 0x2c, 0x44);
-		adm8211_write_bbp(dev, 0x29, 0xfa);
-		adm8211_write_bbp(dev, 0x60, 0x2d);
-		adm8211_write_bbp(dev, 0x64, 0x01);
-		break;
+		case ADM8211_AL2210L:
+			adm8211_write_bbp(dev, 0x00, 0x00);
+			adm8211_write_bbp(dev, 0x01, 0x00);
+			adm8211_write_bbp(dev, 0x02, 0x00);
+			adm8211_write_bbp(dev, 0x03, 0x00);
+			adm8211_write_bbp(dev, 0x06, 0x0f);
+			adm8211_write_bbp(dev, 0x07, 0x05);
+			adm8211_write_bbp(dev, 0x08, 0x03);
+			adm8211_write_bbp(dev, 0x09, 0x00);
+			adm8211_write_bbp(dev, 0x0a, 0x00);
+			adm8211_write_bbp(dev, 0x0b, 0x00);
+			adm8211_write_bbp(dev, 0x0c, 0x10);
+			adm8211_write_bbp(dev, 0x0f, 0x55);
+			adm8211_write_bbp(dev, 0x10, 0x8d);
+			adm8211_write_bbp(dev, 0x11, 0x43);
+			adm8211_write_bbp(dev, 0x18, 0x4a);
+			adm8211_write_bbp(dev, 0x20, 0x20);
+			adm8211_write_bbp(dev, 0x21, 0x02);
+			adm8211_write_bbp(dev, 0x22, 0x23);
+			adm8211_write_bbp(dev, 0x23, 0x30);
+			adm8211_write_bbp(dev, 0x24, 0x2d);
+			adm8211_write_bbp(dev, 0x2a, 0xaa);
+			adm8211_write_bbp(dev, 0x2b, 0x81);
+			adm8211_write_bbp(dev, 0x2c, 0x44);
+			adm8211_write_bbp(dev, 0x29, 0xfa);
+			adm8211_write_bbp(dev, 0x60, 0x2d);
+			adm8211_write_bbp(dev, 0x64, 0x01);
+			break;
 
-	case ADM8211_RFMD2948:
-		break;
+		case ADM8211_RFMD2948:
+			break;
 
-	default:
-		printk(KERN_DEBUG "%s: unsupported transceiver type %d\n",
-		       wiphy_name(dev->wiphy), priv->transceiver_type);
-		break;
-	}
-	} else {
-		printk(KERN_DEBUG "%s: unsupported BBP type %d\n",
+		default:
+			printk(KERN_DEBUG "%s: unsupported transceiver %d\n",
+			       wiphy_name(dev->wiphy), priv->transceiver_type);
+			break;
+		}
+	} else
+		printk(KERN_DEBUG "%s: unsupported BBP %d\n",
 		       wiphy_name(dev->wiphy), priv->bbp_type);
-	}
 
 	ADM8211_CSR_WRITE(SYNRF, 0);
 
@@ -1116,7 +1093,7 @@ static int adm8211_hw_init_bbp(struct ieee80211_hw *dev)
 	return 0;
 }
 
-// configures hw beacons/probe responses
+/* configures hw beacons/probe responses */
 static int adm8211_set_rate(struct ieee80211_hw *dev)
 {
 	struct adm8211_priv *priv = dev->priv;
@@ -1128,27 +1105,28 @@ static int adm8211_set_rate(struct ieee80211_hw *dev)
 	if (priv->revid != ADM8211_REV_BA) {
 		rate_buf[0] = ARRAY_SIZE(adm8211_rates);
 		for (i = 0; i < ARRAY_SIZE(adm8211_rates); i++)
-			rate_buf[i+1] = (adm8211_rates[i].rate/5) | 0x80;
+			rate_buf[i + 1] = (adm8211_rates[i].rate / 5) | 0x80;
 	} else {
 		/* workaround for rev BA specific bug */
-		rate_buf[0]=4;
-		rate_buf[1]=0x82;
-		rate_buf[2]=0x04;
-		rate_buf[3]=0x0b;
-		rate_buf[4]=0x16;
+		rate_buf[0] = 0x04;
+		rate_buf[1] = 0x82;
+		rate_buf[2] = 0x04;
+		rate_buf[3] = 0x0b;
+		rate_buf[4] = 0x16;
 	}
 
-	adm8211_write_sram_bytes(dev, ADM8211_SRAM_SUPP_RATE, rate_buf, ARRAY_SIZE(adm8211_rates)+1);
+	adm8211_write_sram_bytes(dev, ADM8211_SRAM_SUPP_RATE, rate_buf,
+				 ARRAY_SIZE(adm8211_rates) + 1);
 
 	reg = ADM8211_CSR_READ(PLCPHD) & 0x00FFFFFF; /* keep bits 0-23 */
-	reg |= (1 << 15);	/* short preamble */
+	reg |= 1 << 15;	/* short preamble */
 	reg |= 110 << 24;
 	ADM8211_CSR_WRITE(PLCPHD, reg);
 
 	/* MTMLT   = 512 TU (max TX MSDU lifetime)
 	 * BCNTSIG = plcp_signal (beacon, probe resp, and atim TX rate)
-	 * SRTYLIM = 224 (short retry limit, value in TX header used by default) */
-	ADM8211_CSR_WRITE(TXLMT, (512<<16) | (110<<8) | (224<<0));
+	 * SRTYLIM = 224 (short retry limit, TX header value is default) */
+	ADM8211_CSR_WRITE(TXLMT, (512 << 16) | (110 << 8) | (224 << 0));
 
 	return 0;
 }
@@ -1157,24 +1135,24 @@ static void adm8211_hw_init(struct ieee80211_hw *dev)
 {
 	struct adm8211_priv *priv = dev->priv;
 	u32 reg;
-	u8 cacheline;
+	u8 cline;
 
 	reg = le32_to_cpu(ADM8211_CSR_READ(PAR));
 	reg |= ADM8211_PAR_MRLE | ADM8211_PAR_MRME;
 	reg &= ~(ADM8211_PAR_BAR | ADM8211_PAR_CAL);
 
 	if (!pci_set_mwi(priv->pdev)) {
-		reg |= (0x1<<24);
-		pci_read_config_byte(priv->pdev, PCI_CACHE_LINE_SIZE, &cacheline);
+		reg |= 0x1 << 24;
+		pci_read_config_byte(priv->pdev, PCI_CACHE_LINE_SIZE, &cline);
 
-		switch (cacheline) {
-		case  0x8: reg |= (0x1<<14);
+		switch (cline) {
+		case  0x8: reg |= (0x1 << 14);
 			   break;
-		case 0x16: reg |= (0x2<<14);
+		case 0x16: reg |= (0x2 << 14);
 			   break;
-		case 0x32: reg |= (0x3<<14);
+		case 0x32: reg |= (0x3 << 14);
 			   break;
-		  default: reg |= (0x0<<14);
+		  default: reg |= (0x0 << 14);
 			   break;
 		}
 	}
@@ -1182,8 +1160,8 @@ static void adm8211_hw_init(struct ieee80211_hw *dev)
 	ADM8211_CSR_WRITE(PAR, reg);
 
 	reg = ADM8211_CSR_READ(CSR_TEST1);
-	reg &= ~(0xF<<28);
-	reg |= ((1 << 28) | (1 << 31));
+	reg &= ~(0xF << 28);
+	reg |= (1 << 28) | (1 << 31);
 	ADM8211_CSR_WRITE(CSR_TEST1, reg);
 
 	/* lose link after 4 lost beacons */
@@ -1227,8 +1205,8 @@ static void adm8211_hw_init(struct ieee80211_hw *dev)
 
 	/* Set CFP Max Duration to 0x10 TU */
 	reg = ADM8211_CSR_READ(CFPP);
-	reg &= ~(0xffff<<8);
-	reg |= 0x0010<<8;
+	reg &= ~(0xffff << 8);
+	reg |= 0x0010 << 8;
 	ADM8211_CSR_WRITE(CFPP, reg);
 
 	/* USCNT = 0x16 (number of system clocks, 22 MHz, in 1us
@@ -1262,7 +1240,7 @@ static void adm8211_hw_init(struct ieee80211_hw *dev)
 
 	/* Setup WEP (turns it off for now) */
 	reg = ADM8211_CSR_READ(MACTEST);
-	reg &= ~(7<<20);
+	reg &= ~(7 << 20);
 	ADM8211_CSR_WRITE(MACTEST, reg);
 
 	reg = ADM8211_CSR_READ(WEPCTL);
@@ -1301,8 +1279,8 @@ static int adm8211_hw_reset(struct ieee80211_hw *dev)
 	ADM8211_CSR_WRITE(PAR, tmp);
 
 	if (priv->revid == ADM8211_REV_BA &&
-	    ( priv->transceiver_type == ADM8211_RFMD2958_RF3000_CONTROL_POWER
-	   || priv->transceiver_type == ADM8211_RFMD2958)) {
+	    (priv->transceiver_type == ADM8211_RFMD2958_RF3000_CONTROL_POWER ||
+	     priv->transceiver_type == ADM8211_RFMD2958)) {
 		reg = ADM8211_CSR_READ(CSR_TEST1);
 		reg |= (1 << 4) | (1 << 5);
 		ADM8211_CSR_WRITE(CSR_TEST1, reg);
@@ -1374,7 +1352,7 @@ static int adm8211_set_ssid(struct ieee80211_hw *dev, u8 *ssid, size_t ssid_len)
 	buf[0] = ssid_len;
 	memcpy(buf + 1, ssid, ssid_len);
 	adm8211_write_sram_bytes(dev, ADM8211_SRAM_SSID, buf, 33);
-	//adm8211_set_beacon(dev);
+	/* TODO: configure beacon for adhoc? */
 	return 0;
 }
 
@@ -1511,10 +1489,10 @@ static void adm8211_free_rings(struct ieee80211_hw *dev)
 		if (!priv->tx_buffers[i].skb)
 			continue;
 
-		pci_unmap_single(
-			priv->pdev,
-			priv->tx_buffers[i].mapping,
-			priv->tx_buffers[i].skb->len, PCI_DMA_TODEVICE);
+		pci_unmap_single(priv->pdev,
+				 priv->tx_buffers[i].mapping,
+				 priv->tx_buffers[i].skb->len,
+				 PCI_DMA_TODEVICE);
 
 		dev_kfree_skb(priv->tx_buffers[i].skb);
 	}
@@ -1634,7 +1612,8 @@ static void adm8211_calc_durations(int *dur, int *plcp, size_t payload_len, int
 
 /* Transmit skb w/adm8211_tx_hdr (802.11 header created by hardware) */
 static void adm8211_tx_raw(struct ieee80211_hw *dev, struct sk_buff *skb,
-			   u16 plcp_signal, struct ieee80211_tx_control *control,
+			   u16 plcp_signal,
+			   struct ieee80211_tx_control *control,
 			   struct ieee80211_hdr *hdr)
 {
 	struct adm8211_priv *priv = dev->priv;
@@ -1687,9 +1666,7 @@ static int adm8211_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
 	struct adm8211_tx_hdr *txhdr;
 	u16 fc;
 	size_t payload_len, hdrlen;
-	int plcp, dur, len;
-	int plcp_signal;
-	int short_preamble;
+	int plcp, dur, len, plcp_signal, short_preamble;
 	struct ieee80211_hdr hdr;
 
 	if (control->tx_rate < 0) {
@@ -1749,12 +1726,13 @@ static int adm8211_alloc_rings(struct ieee80211_hw *dev)
 	struct adm8211_priv *priv = dev->priv;
 	unsigned int ring_size;
 
-	priv->rx_buffers = kmalloc(sizeof(struct adm8211_rx_ring_info) * priv->rx_ring_size +
-				   sizeof(struct adm8211_tx_ring_info) * priv->tx_ring_size, GFP_KERNEL);
+	priv->rx_buffers = kmalloc(sizeof(*priv->rx_buffers) * priv->rx_ring_size +
+				   sizeof(*priv->tx_buffers) * priv->tx_ring_size, GFP_KERNEL);
 	if (!priv->rx_buffers)
 		return -ENOMEM;
 
-	priv->tx_buffers = ((void *)priv->rx_buffers) + sizeof(struct adm8211_rx_ring_info) * priv->rx_ring_size;
+	priv->tx_buffers = (void *)priv->rx_buffers +
+			   sizeof(*priv->rx_buffers) * priv->rx_ring_size;
 
 	/* Allocate TX/RX descriptors */
 	ring_size = sizeof(struct adm8211_desc) * priv->rx_ring_size +
@@ -1769,9 +1747,10 @@ static int adm8211_alloc_rings(struct ieee80211_hw *dev)
 		return -ENOMEM;
 	}
 
-	priv->tx_ring = (struct adm8211_desc *) (priv->rx_ring + priv->rx_ring_size);
+	priv->tx_ring = (struct adm8211_desc *)(priv->rx_ring +
+						priv->rx_ring_size);
 	priv->tx_ring_dma = priv->rx_ring_dma +
-		sizeof(struct adm8211_desc) * priv->rx_ring_size;
+			    sizeof(struct adm8211_desc) * priv->rx_ring_size;
 
 	return 0;
 }
@@ -1809,7 +1788,8 @@ static int __devinit adm8211_probe(struct pci_dev *pdev,
 
 	err = pci_enable_device(pdev);
 	if (err) {
-		printk(KERN_ERR "%s (adm8211): Cannot enable new PCI device\n", pci_name(pdev));
+		printk(KERN_ERR "%s (adm8211): Cannot enable new PCI device\n",
+		       pci_name(pdev));
 		return err;
 	}
 
@@ -1818,7 +1798,8 @@ static int __devinit adm8211_probe(struct pci_dev *pdev,
 	mem_addr = pci_resource_start(pdev, 1);
 	mem_len = pci_resource_len(pdev, 1);
 	if (io_len < 256 || mem_len < 1024) {
-		printk(KERN_ERR "%s (adm8211): Too short PCI resources\n", pci_name(pdev));
+		printk(KERN_ERR "%s (adm8211): Too short PCI resources\n",
+		       pci_name(pdev));
 		goto err_disable_pdev;
 	}
 
@@ -1826,19 +1807,22 @@ static int __devinit adm8211_probe(struct pci_dev *pdev,
 	/* check signature */
 	pci_read_config_dword(pdev, 0x80 /* CR32 */, &reg);
 	if (reg != ADM8211_SIG1 && reg != ADM8211_SIG2) {
-		printk(KERN_ERR "%s (adm8211): Invalid signature (0x%x)\n", pci_name(pdev), reg);
+		printk(KERN_ERR "%s (adm8211): Invalid signature (0x%x)\n",
+		       pci_name(pdev), reg);
 		goto err_disable_pdev;
 	}
 
 	err = pci_request_regions(pdev, "adm8211");
 	if (err) {
-		printk(KERN_ERR "%s (adm8211): Cannot obtain PCI resources\n", pci_name(pdev));
+		printk(KERN_ERR "%s (adm8211): Cannot obtain PCI resources\n",
+		       pci_name(pdev));
 		return err; /* someone else grabbed it? don't disable it */
 	}
 
 	if (pci_set_dma_mask(pdev, DMA_32BIT_MASK) ||
 	    pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK)) {
-		printk(KERN_ERR "%s (adm8211): No suitable DMA available\n", pci_name(pdev));
+		printk(KERN_ERR "%s (adm8211): No suitable DMA available\n",
+		       pci_name(pdev));
 		goto err_free_reg;
 	}
 
@@ -1846,7 +1830,8 @@ static int __devinit adm8211_probe(struct pci_dev *pdev,
 
 	dev = ieee80211_alloc_hw(sizeof(*priv), &adm8211_ops);
 	if (!dev) {
-		printk(KERN_ERR "%s (adm8211): ieee80211 alloc failed\n", pci_name(pdev));
+		printk(KERN_ERR "%s (adm8211): ieee80211 alloc failed\n",
+		       pci_name(pdev));
 		err = -ENOMEM;
 		goto err_free_reg;
 	}
@@ -1858,14 +1843,14 @@ static int __devinit adm8211_probe(struct pci_dev *pdev,
 	SET_IEEE80211_DEV(dev, &pdev->dev);
 
 	pci_set_drvdata(pdev, dev);
-	priv->msg_enable = netif_msg_init(debug, NETIF_MSG_DRV | NETIF_MSG_PROBE);
 
 	priv->map = pci_iomap(pdev, 1, mem_len);
 	if (!priv->map)
 		priv->map = pci_iomap(pdev, 0, io_len);
 
 	if (!priv->map) {
-		printk(KERN_ERR "%s (adm8211): Cannot map device memory\n", pci_name(pdev));
+		printk(KERN_ERR "%s (adm8211): Cannot map device memory\n",
+		       pci_name(pdev));
 		goto err_free_dev;
 	}
 
@@ -1873,7 +1858,8 @@ static int __devinit adm8211_probe(struct pci_dev *pdev,
 	priv->tx_ring_size = tx_ring_size;
 
 	if (adm8211_alloc_rings(dev)) {
-		printk(KERN_ERR "%s (adm8211): Cannot allocate TX/RX ring\n", pci_name(pdev));
+		printk(KERN_ERR "%s (adm8211): Cannot allocate TX/RX ring\n",
+		       pci_name(pdev));
 		goto err_iounmap;
 	}
 
@@ -1884,17 +1870,18 @@ static int __devinit adm8211_probe(struct pci_dev *pdev,
 		le16_to_cpu((__force __le16)ADM8211_CSR_READ(PAR1) & 0xFFFF);
 
 	if (!is_valid_ether_addr(perm_addr)) {
-		printk(KERN_WARNING "%s (adm8211): Invalid hwaddr! Using randomly generated hwaddr\n", pci_name(pdev));
+		printk(KERN_WARNING "%s (adm8211): Invalid hwaddr in EEPROM!\n",
+		       pci_name(pdev));
 		random_ether_addr(perm_addr);
 	}
 	SET_IEEE80211_PERM_ADDR(dev, perm_addr);
 
 	dev->extra_tx_headroom = sizeof(struct adm8211_tx_hdr);
 	dev->flags = IEEE80211_HW_WEP_INCLUDE_IV;
-	// however, IEEE80211_HW_RX_INCLUDES_FCS in promisc mode
+	/* IEEE80211_HW_RX_INCLUDES_FCS in promisc mode */
 
 	dev->channel_change_time = 1000;
-	dev->max_rssi = ADM8211_RX_MAX_SSI;// FIXME - This is an approximation
+	dev->max_rssi = 100;	/* FIXME: find better value */
 
 	priv->modes[0].mode = MODE_IEEE80211B;
 	/* channel info filled in by adm8211_read_eeprom */
@@ -1902,7 +1889,7 @@ static int __devinit adm8211_probe(struct pci_dev *pdev,
 	priv->modes[0].num_rates = ARRAY_SIZE(adm8211_rates);
 	priv->modes[0].rates = priv->rates;
 
-	dev->queues = 1;		// ADM8211C supports more, maybe ADM8211B
+	dev->queues = 1; /* ADM8211C supports more, maybe ADM8211B too */
 
 	priv->retry_limit = 3;
 	priv->ant_power = 0x40;
@@ -1922,7 +1909,8 @@ static int __devinit adm8211_probe(struct pci_dev *pdev,
 
 	err = adm8211_read_eeprom(dev);
 	if (err) {
-		printk(KERN_ERR "%s (adm8211): Cannot allocate eeprom buffer\n", pci_name(pdev));
+		printk(KERN_ERR "%s (adm8211): Can't alloc eeprom buffer\n",
+		       pci_name(pdev));
 		goto err_free_desc;
 	}
 
@@ -1930,18 +1918,21 @@ static int __devinit adm8211_probe(struct pci_dev *pdev,
 
 	err = ieee80211_register_hwmode(dev, &priv->modes[0]);
 	if (err) {
-		printk(KERN_ERR "%s (adm8211): Cannot register hwmode\n", pci_name(pdev));
+		printk(KERN_ERR "%s (adm8211): Can't register hwmode\n",
+		       pci_name(pdev));
 		goto err_free_desc;
 	}
 
 	err = ieee80211_register_hw(dev);
 	if (err) {
-		printk(KERN_ERR "%s (adm8211): Cannot register hardware\n", pci_name(pdev));
+		printk(KERN_ERR "%s (adm8211): Cannot register device\n",
+		       pci_name(pdev));
 		goto err_free_desc;
 	}
 
 	printk(KERN_INFO "%s: hwaddr " MAC_FMT ", Rev 0x%02x\n",
-	       wiphy_name(dev->wiphy), MAC_ARG(dev->wiphy->perm_addr), priv->revid);
+	       wiphy_name(dev->wiphy), MAC_ARG(dev->wiphy->perm_addr),
+	       priv->revid);
 
 	return 0;
 
@@ -2030,7 +2021,7 @@ static int adm8211_resume(struct pci_dev *pdev)
 
 MODULE_DEVICE_TABLE(pci, adm8211_pci_id_table);
 
-/* TODO: enable_wake */
+/* TODO: implement enable_wake */
 static struct pci_driver adm8211_driver = {
 	.name		= "adm8211",
 	.id_table	= adm8211_pci_id_table,
diff --git a/drivers/net/wireless/adm8211.h b/drivers/net/wireless/adm8211.h
index 6bf6eac..35f4658 100644
--- a/drivers/net/wireless/adm8211.h
+++ b/drivers/net/wireless/adm8211.h
@@ -149,33 +149,29 @@ struct adm8211_csr {
 #define ADM8211_NAR_SR		(1 << 1)
 #define ADM8211_NAR_CTX		(1 << 0)
 
-#define ADM8211_IDLE()		do { \
-	if (priv->nar & (ADM8211_NAR_SR | ADM8211_NAR_ST)) {\
-		ADM8211_CSR_WRITE(NAR, cpu_to_le32(priv->nar & ~(ADM8211_NAR_SR | ADM8211_NAR_ST)));\
-		ADM8211_CSR_READ(NAR);\
-		mdelay(20);\
-	}\
+#define ADM8211_IDLE() 							   \
+do { 									   \
+	if (priv->nar & (ADM8211_NAR_SR | ADM8211_NAR_ST)) {		   \
+		ADM8211_CSR_WRITE(NAR, priv->nar &			   \
+				       ~(ADM8211_NAR_SR | ADM8211_NAR_ST));\
+		ADM8211_CSR_READ(NAR);					   \
+		msleep(20);						   \
+	}								   \
 } while (0)
 
-#define ADM8211_IDLE_RX()	do { \
-	if (priv->nar & ADM8211_NAR_SR) {\
-		ADM8211_CSR_WRITE(NAR, cpu_to_le32(priv->nar & ~ADM8211_NAR_SR));\
-		ADM8211_CSR_READ(NAR);\
-		mdelay(20);\
-	}\
+#define ADM8211_IDLE_RX() 						\
+do {									\
+	if (priv->nar & ADM8211_NAR_SR) {				\
+		ADM8211_CSR_WRITE(NAR, priv->nar & ~ADM8211_NAR_SR);	\
+		ADM8211_CSR_READ(NAR);					\
+		mdelay(20);						\
+	}								\
 } while (0)
 
-#define ADM8211_IDLE_TX()	do { \
-	if (priv->nar & ADM8211_NAR_ST) {\
-		ADM8211_CSR_WRITE(NAR, cpu_to_le32(priv->nar & ~ADM8211_NAR_ST));\
-		ADM8211_CSR_READ(NAR);\
-		mdelay(20);\
-	}\
-} while (0)
-
-#define ADM8211_RESTORE()	do { \
-	if (priv->nar & (ADM8211_NAR_SR | ADM8211_NAR_ST)) \
-		ADM8211_CSR_WRITE(NAR, cpu_to_le32(priv->nar));\
+#define ADM8211_RESTORE()					\
+do {								\
+	if (priv->nar & (ADM8211_NAR_SR | ADM8211_NAR_ST))	\
+		ADM8211_CSR_WRITE(NAR, priv->nar);		\
 } while (0)
 
 /* CSR7 - IER (Interrupt Enable Register) */
@@ -456,8 +452,6 @@ struct adm8211_tx_ring_info {
 #define PLCP_SIGNAL_5M5		0x37
 #define PLCP_SIGNAL_11M		0x6e
 
-#define ADM8211_RX_MAX_SSI	100
-
 struct adm8211_tx_hdr {
 	u8 da[6];
 	u8 signal; /* PLCP signal / TX rate in 100 Kbps */
@@ -588,8 +582,6 @@ struct adm8211_priv {
 	size_t ssid_len;
 	u8 *mac_addr;
 
-	u32 msg_enable;
-
 	u8 soft_rx_crc;
 	u8 retry_limit;
 

