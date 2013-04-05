Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:33546 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161659Ab3DEG0o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 02:26:44 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	users@rt2x00.serialmonkey.com, Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 4/6] rt2x00: rt61pci: use the rt2x00mmio_* routines
Date: Fri,  5 Apr 2013 08:27:03 +0200
Message-Id: <1365143225-24532-5-git-send-email-juhosg@openwrt.org> (sfid-20130405_082656_933641_5F4AE24C)
In-Reply-To: <1365143225-24532-1-git-send-email-juhosg@openwrt.org>
References: <1365143225-24532-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the recently introduced rt2x00mmio_* routines
instead of the rt2x00pci_* variants.

The patch contains no functional changes.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt61pci.c |  515 +++++++++++++++++----------------
 1 file changed, 259 insertions(+), 256 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 9e3c8ff..232d1f7 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -58,12 +58,12 @@ MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
  * and we will print an error.
  */
 #define WAIT_FOR_BBP(__dev, __reg) \
-	rt2x00pci_regbusy_read((__dev), PHY_CSR3, PHY_CSR3_BUSY, (__reg))
+	rt2x00mmio_regbusy_read((__dev), PHY_CSR3, PHY_CSR3_BUSY, (__reg))
 #define WAIT_FOR_RF(__dev, __reg) \
-	rt2x00pci_regbusy_read((__dev), PHY_CSR4, PHY_CSR4_BUSY, (__reg))
+	rt2x00mmio_regbusy_read((__dev), PHY_CSR4, PHY_CSR4_BUSY, (__reg))
 #define WAIT_FOR_MCU(__dev, __reg) \
-	rt2x00pci_regbusy_read((__dev), H2M_MAILBOX_CSR, \
-			       H2M_MAILBOX_CSR_OWNER, (__reg))
+	rt2x00mmio_regbusy_read((__dev), H2M_MAILBOX_CSR, \
+				H2M_MAILBOX_CSR_OWNER, (__reg))
 
 static void rt61pci_bbp_write(struct rt2x00_dev *rt2x00dev,
 			      const unsigned int word, const u8 value)
@@ -83,7 +83,7 @@ static void rt61pci_bbp_write(struct rt2x00_dev *rt2x00dev,
 		rt2x00_set_field32(&reg, PHY_CSR3_BUSY, 1);
 		rt2x00_set_field32(&reg, PHY_CSR3_READ_CONTROL, 0);
 
-		rt2x00pci_register_write(rt2x00dev, PHY_CSR3, reg);
+		rt2x00mmio_register_write(rt2x00dev, PHY_CSR3, reg);
 	}
 
 	mutex_unlock(&rt2x00dev->csr_mutex);
@@ -110,7 +110,7 @@ static void rt61pci_bbp_read(struct rt2x00_dev *rt2x00dev,
 		rt2x00_set_field32(&reg, PHY_CSR3_BUSY, 1);
 		rt2x00_set_field32(&reg, PHY_CSR3_READ_CONTROL, 1);
 
-		rt2x00pci_register_write(rt2x00dev, PHY_CSR3, reg);
+		rt2x00mmio_register_write(rt2x00dev, PHY_CSR3, reg);
 
 		WAIT_FOR_BBP(rt2x00dev, &reg);
 	}
@@ -138,7 +138,7 @@ static void rt61pci_rf_write(struct rt2x00_dev *rt2x00dev,
 		rt2x00_set_field32(&reg, PHY_CSR4_IF_SELECT, 0);
 		rt2x00_set_field32(&reg, PHY_CSR4_BUSY, 1);
 
-		rt2x00pci_register_write(rt2x00dev, PHY_CSR4, reg);
+		rt2x00mmio_register_write(rt2x00dev, PHY_CSR4, reg);
 		rt2x00_rf_write(rt2x00dev, word, value);
 	}
 
@@ -162,12 +162,12 @@ static void rt61pci_mcu_request(struct rt2x00_dev *rt2x00dev,
 		rt2x00_set_field32(&reg, H2M_MAILBOX_CSR_CMD_TOKEN, token);
 		rt2x00_set_field32(&reg, H2M_MAILBOX_CSR_ARG0, arg0);
 		rt2x00_set_field32(&reg, H2M_MAILBOX_CSR_ARG1, arg1);
-		rt2x00pci_register_write(rt2x00dev, H2M_MAILBOX_CSR, reg);
+		rt2x00mmio_register_write(rt2x00dev, H2M_MAILBOX_CSR, reg);
 
-		rt2x00pci_register_read(rt2x00dev, HOST_CMD_CSR, &reg);
+		rt2x00mmio_register_read(rt2x00dev, HOST_CMD_CSR, &reg);
 		rt2x00_set_field32(&reg, HOST_CMD_CSR_HOST_COMMAND, command);
 		rt2x00_set_field32(&reg, HOST_CMD_CSR_INTERRUPT_MCU, 1);
-		rt2x00pci_register_write(rt2x00dev, HOST_CMD_CSR, reg);
+		rt2x00mmio_register_write(rt2x00dev, HOST_CMD_CSR, reg);
 	}
 
 	mutex_unlock(&rt2x00dev->csr_mutex);
@@ -179,7 +179,7 @@ static void rt61pci_eepromregister_read(struct eeprom_93cx6 *eeprom)
 	struct rt2x00_dev *rt2x00dev = eeprom->data;
 	u32 reg;
 
-	rt2x00pci_register_read(rt2x00dev, E2PROM_CSR, &reg);
+	rt2x00mmio_register_read(rt2x00dev, E2PROM_CSR, &reg);
 
 	eeprom->reg_data_in = !!rt2x00_get_field32(reg, E2PROM_CSR_DATA_IN);
 	eeprom->reg_data_out = !!rt2x00_get_field32(reg, E2PROM_CSR_DATA_OUT);
@@ -201,15 +201,15 @@ static void rt61pci_eepromregister_write(struct eeprom_93cx6 *eeprom)
 	rt2x00_set_field32(&reg, E2PROM_CSR_CHIP_SELECT,
 			   !!eeprom->reg_chip_select);
 
-	rt2x00pci_register_write(rt2x00dev, E2PROM_CSR, reg);
+	rt2x00mmio_register_write(rt2x00dev, E2PROM_CSR, reg);
 }
 
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
 static const struct rt2x00debug rt61pci_rt2x00debug = {
 	.owner	= THIS_MODULE,
 	.csr	= {
-		.read		= rt2x00pci_register_read,
-		.write		= rt2x00pci_register_write,
+		.read		= rt2x00mmio_register_read,
+		.write		= rt2x00mmio_register_write,
 		.flags		= RT2X00DEBUGFS_OFFSET,
 		.word_base	= CSR_REG_BASE,
 		.word_size	= sizeof(u32),
@@ -243,7 +243,7 @@ static int rt61pci_rfkill_poll(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
 
-	rt2x00pci_register_read(rt2x00dev, MAC_CSR13, &reg);
+	rt2x00mmio_register_read(rt2x00dev, MAC_CSR13, &reg);
 	return rt2x00_get_field32(reg, MAC_CSR13_VAL5);
 }
 
@@ -294,10 +294,10 @@ static int rt61pci_blink_set(struct led_classdev *led_cdev,
 	    container_of(led_cdev, struct rt2x00_led, led_dev);
 	u32 reg;
 
-	rt2x00pci_register_read(led->rt2x00dev, MAC_CSR14, &reg);
+	rt2x00mmio_register_read(led->rt2x00dev, MAC_CSR14, &reg);
 	rt2x00_set_field32(&reg, MAC_CSR14_ON_PERIOD, *delay_on);
 	rt2x00_set_field32(&reg, MAC_CSR14_OFF_PERIOD, *delay_off);
-	rt2x00pci_register_write(led->rt2x00dev, MAC_CSR14, reg);
+	rt2x00mmio_register_write(led->rt2x00dev, MAC_CSR14, reg);
 
 	return 0;
 }
@@ -339,7 +339,7 @@ static int rt61pci_config_shared_key(struct rt2x00_dev *rt2x00dev,
 		 */
 		mask = (0xf << crypto->bssidx);
 
-		rt2x00pci_register_read(rt2x00dev, SEC_CSR0, &reg);
+		rt2x00mmio_register_read(rt2x00dev, SEC_CSR0, &reg);
 		reg &= mask;
 
 		if (reg && reg == mask)
@@ -358,8 +358,8 @@ static int rt61pci_config_shared_key(struct rt2x00_dev *rt2x00dev,
 		       sizeof(key_entry.rx_mic));
 
 		reg = SHARED_KEY_ENTRY(key->hw_key_idx);
-		rt2x00pci_register_multiwrite(rt2x00dev, reg,
-					      &key_entry, sizeof(key_entry));
+		rt2x00mmio_register_multiwrite(rt2x00dev, reg,
+					       &key_entry, sizeof(key_entry));
 
 		/*
 		 * The cipher types are stored over 2 registers.
@@ -372,16 +372,16 @@ static int rt61pci_config_shared_key(struct rt2x00_dev *rt2x00dev,
 			field.bit_offset = (3 * key->hw_key_idx);
 			field.bit_mask = 0x7 << field.bit_offset;
 
-			rt2x00pci_register_read(rt2x00dev, SEC_CSR1, &reg);
+			rt2x00mmio_register_read(rt2x00dev, SEC_CSR1, &reg);
 			rt2x00_set_field32(&reg, field, crypto->cipher);
-			rt2x00pci_register_write(rt2x00dev, SEC_CSR1, reg);
+			rt2x00mmio_register_write(rt2x00dev, SEC_CSR1, reg);
 		} else {
 			field.bit_offset = (3 * (key->hw_key_idx - 8));
 			field.bit_mask = 0x7 << field.bit_offset;
 
-			rt2x00pci_register_read(rt2x00dev, SEC_CSR5, &reg);
+			rt2x00mmio_register_read(rt2x00dev, SEC_CSR5, &reg);
 			rt2x00_set_field32(&reg, field, crypto->cipher);
-			rt2x00pci_register_write(rt2x00dev, SEC_CSR5, reg);
+			rt2x00mmio_register_write(rt2x00dev, SEC_CSR5, reg);
 		}
 
 		/*
@@ -404,12 +404,12 @@ static int rt61pci_config_shared_key(struct rt2x00_dev *rt2x00dev,
 	 */
 	mask = 1 << key->hw_key_idx;
 
-	rt2x00pci_register_read(rt2x00dev, SEC_CSR0, &reg);
+	rt2x00mmio_register_read(rt2x00dev, SEC_CSR0, &reg);
 	if (crypto->cmd == SET_KEY)
 		reg |= mask;
 	else if (crypto->cmd == DISABLE_KEY)
 		reg &= ~mask;
-	rt2x00pci_register_write(rt2x00dev, SEC_CSR0, reg);
+	rt2x00mmio_register_write(rt2x00dev, SEC_CSR0, reg);
 
 	return 0;
 }
@@ -433,10 +433,10 @@ static int rt61pci_config_pairwise_key(struct rt2x00_dev *rt2x00dev,
 		 * When both registers are full, we drop the key.
 		 * Otherwise, we use the first invalid entry.
 		 */
-		rt2x00pci_register_read(rt2x00dev, SEC_CSR2, &reg);
+		rt2x00mmio_register_read(rt2x00dev, SEC_CSR2, &reg);
 		if (reg && reg == ~0) {
 			key->hw_key_idx = 32;
-			rt2x00pci_register_read(rt2x00dev, SEC_CSR3, &reg);
+			rt2x00mmio_register_read(rt2x00dev, SEC_CSR3, &reg);
 			if (reg && reg == ~0)
 				return -ENOSPC;
 		}
@@ -458,21 +458,21 @@ static int rt61pci_config_pairwise_key(struct rt2x00_dev *rt2x00dev,
 		addr_entry.cipher = crypto->cipher;
 
 		reg = PAIRWISE_KEY_ENTRY(key->hw_key_idx);
-		rt2x00pci_register_multiwrite(rt2x00dev, reg,
-					      &key_entry, sizeof(key_entry));
+		rt2x00mmio_register_multiwrite(rt2x00dev, reg,
+					       &key_entry, sizeof(key_entry));
 
 		reg = PAIRWISE_TA_ENTRY(key->hw_key_idx);
-		rt2x00pci_register_multiwrite(rt2x00dev, reg,
-					      &addr_entry, sizeof(addr_entry));
+		rt2x00mmio_register_multiwrite(rt2x00dev, reg,
+					       &addr_entry, sizeof(addr_entry));
 
 		/*
 		 * Enable pairwise lookup table for given BSS idx.
 		 * Without this, received frames will not be decrypted
 		 * by the hardware.
 		 */
-		rt2x00pci_register_read(rt2x00dev, SEC_CSR4, &reg);
+		rt2x00mmio_register_read(rt2x00dev, SEC_CSR4, &reg);
 		reg |= (1 << crypto->bssidx);
-		rt2x00pci_register_write(rt2x00dev, SEC_CSR4, reg);
+		rt2x00mmio_register_write(rt2x00dev, SEC_CSR4, reg);
 
 		/*
 		 * The driver does not support the IV/EIV generation
@@ -495,21 +495,21 @@ static int rt61pci_config_pairwise_key(struct rt2x00_dev *rt2x00dev,
 	if (key->hw_key_idx < 32) {
 		mask = 1 << key->hw_key_idx;
 
-		rt2x00pci_register_read(rt2x00dev, SEC_CSR2, &reg);
+		rt2x00mmio_register_read(rt2x00dev, SEC_CSR2, &reg);
 		if (crypto->cmd == SET_KEY)
 			reg |= mask;
 		else if (crypto->cmd == DISABLE_KEY)
 			reg &= ~mask;
-		rt2x00pci_register_write(rt2x00dev, SEC_CSR2, reg);
+		rt2x00mmio_register_write(rt2x00dev, SEC_CSR2, reg);
 	} else {
 		mask = 1 << (key->hw_key_idx - 32);
 
-		rt2x00pci_register_read(rt2x00dev, SEC_CSR3, &reg);
+		rt2x00mmio_register_read(rt2x00dev, SEC_CSR3, &reg);
 		if (crypto->cmd == SET_KEY)
 			reg |= mask;
 		else if (crypto->cmd == DISABLE_KEY)
 			reg &= ~mask;
-		rt2x00pci_register_write(rt2x00dev, SEC_CSR3, reg);
+		rt2x00mmio_register_write(rt2x00dev, SEC_CSR3, reg);
 	}
 
 	return 0;
@@ -526,7 +526,7 @@ static void rt61pci_config_filter(struct rt2x00_dev *rt2x00dev,
 	 * and broadcast frames will always be accepted since
 	 * there is no filter for it at this time.
 	 */
-	rt2x00pci_register_read(rt2x00dev, TXRX_CSR0, &reg);
+	rt2x00mmio_register_read(rt2x00dev, TXRX_CSR0, &reg);
 	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_CRC,
 			   !(filter_flags & FIF_FCSFAIL));
 	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_PHYSICAL,
@@ -544,7 +544,7 @@ static void rt61pci_config_filter(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_BROADCAST, 0);
 	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_ACK_CTS,
 			   !(filter_flags & FIF_CONTROL));
-	rt2x00pci_register_write(rt2x00dev, TXRX_CSR0, reg);
+	rt2x00mmio_register_write(rt2x00dev, TXRX_CSR0, reg);
 }
 
 static void rt61pci_config_intf(struct rt2x00_dev *rt2x00dev,
@@ -558,9 +558,9 @@ static void rt61pci_config_intf(struct rt2x00_dev *rt2x00dev,
 		/*
 		 * Enable synchronisation.
 		 */
-		rt2x00pci_register_read(rt2x00dev, TXRX_CSR9, &reg);
+		rt2x00mmio_register_read(rt2x00dev, TXRX_CSR9, &reg);
 		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_SYNC, conf->sync);
-		rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, reg);
+		rt2x00mmio_register_write(rt2x00dev, TXRX_CSR9, reg);
 	}
 
 	if (flags & CONFIG_UPDATE_MAC) {
@@ -568,8 +568,8 @@ static void rt61pci_config_intf(struct rt2x00_dev *rt2x00dev,
 		rt2x00_set_field32(&reg, MAC_CSR3_UNICAST_TO_ME_MASK, 0xff);
 		conf->mac[1] = cpu_to_le32(reg);
 
-		rt2x00pci_register_multiwrite(rt2x00dev, MAC_CSR2,
-					      conf->mac, sizeof(conf->mac));
+		rt2x00mmio_register_multiwrite(rt2x00dev, MAC_CSR2,
+					       conf->mac, sizeof(conf->mac));
 	}
 
 	if (flags & CONFIG_UPDATE_BSSID) {
@@ -577,8 +577,9 @@ static void rt61pci_config_intf(struct rt2x00_dev *rt2x00dev,
 		rt2x00_set_field32(&reg, MAC_CSR5_BSS_ID_MASK, 3);
 		conf->bssid[1] = cpu_to_le32(reg);
 
-		rt2x00pci_register_multiwrite(rt2x00dev, MAC_CSR4,
-					      conf->bssid, sizeof(conf->bssid));
+		rt2x00mmio_register_multiwrite(rt2x00dev, MAC_CSR4,
+					       conf->bssid,
+					       sizeof(conf->bssid));
 	}
 }
 
@@ -588,40 +589,40 @@ static void rt61pci_config_erp(struct rt2x00_dev *rt2x00dev,
 {
 	u32 reg;
 
-	rt2x00pci_register_read(rt2x00dev, TXRX_CSR0, &reg);
+	rt2x00mmio_register_read(rt2x00dev, TXRX_CSR0, &reg);
 	rt2x00_set_field32(&reg, TXRX_CSR0_RX_ACK_TIMEOUT, 0x32);
 	rt2x00_set_field32(&reg, TXRX_CSR0_TSF_OFFSET, IEEE80211_HEADER);
-	rt2x00pci_register_write(rt2x00dev, TXRX_CSR0, reg);
+	rt2x00mmio_register_write(rt2x00dev, TXRX_CSR0, reg);
 
 	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
-		rt2x00pci_register_read(rt2x00dev, TXRX_CSR4, &reg);
+		rt2x00mmio_register_read(rt2x00dev, TXRX_CSR4, &reg);
 		rt2x00_set_field32(&reg, TXRX_CSR4_AUTORESPOND_ENABLE, 1);
 		rt2x00_set_field32(&reg, TXRX_CSR4_AUTORESPOND_PREAMBLE,
 				   !!erp->short_preamble);
-		rt2x00pci_register_write(rt2x00dev, TXRX_CSR4, reg);
+		rt2x00mmio_register_write(rt2x00dev, TXRX_CSR4, reg);
 	}
 
 	if (changed & BSS_CHANGED_BASIC_RATES)
-		rt2x00pci_register_write(rt2x00dev, TXRX_CSR5,
-					 erp->basic_rates);
+		rt2x00mmio_register_write(rt2x00dev, TXRX_CSR5,
+					  erp->basic_rates);
 
 	if (changed & BSS_CHANGED_BEACON_INT) {
-		rt2x00pci_register_read(rt2x00dev, TXRX_CSR9, &reg);
+		rt2x00mmio_register_read(rt2x00dev, TXRX_CSR9, &reg);
 		rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_INTERVAL,
 				   erp->beacon_int * 16);
-		rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, reg);
+		rt2x00mmio_register_write(rt2x00dev, TXRX_CSR9, reg);
 	}
 
 	if (changed & BSS_CHANGED_ERP_SLOT) {
-		rt2x00pci_register_read(rt2x00dev, MAC_CSR9, &reg);
+		rt2x00mmio_register_read(rt2x00dev, MAC_CSR9, &reg);
 		rt2x00_set_field32(&reg, MAC_CSR9_SLOT_TIME, erp->slot_time);
-		rt2x00pci_register_write(rt2x00dev, MAC_CSR9, reg);
+		rt2x00mmio_register_write(rt2x00dev, MAC_CSR9, reg);
 
-		rt2x00pci_register_read(rt2x00dev, MAC_CSR8, &reg);
+		rt2x00mmio_register_read(rt2x00dev, MAC_CSR8, &reg);
 		rt2x00_set_field32(&reg, MAC_CSR8_SIFS, erp->sifs);
 		rt2x00_set_field32(&reg, MAC_CSR8_SIFS_AFTER_RX_OFDM, 3);
 		rt2x00_set_field32(&reg, MAC_CSR8_EIFS, erp->eifs);
-		rt2x00pci_register_write(rt2x00dev, MAC_CSR8, reg);
+		rt2x00mmio_register_write(rt2x00dev, MAC_CSR8, reg);
 	}
 }
 
@@ -714,7 +715,7 @@ static void rt61pci_config_antenna_2529_rx(struct rt2x00_dev *rt2x00dev,
 {
 	u32 reg;
 
-	rt2x00pci_register_read(rt2x00dev, MAC_CSR13, &reg);
+	rt2x00mmio_register_read(rt2x00dev, MAC_CSR13, &reg);
 
 	rt2x00_set_field32(&reg, MAC_CSR13_DIR4, 0);
 	rt2x00_set_field32(&reg, MAC_CSR13_VAL4, p1);
@@ -722,7 +723,7 @@ static void rt61pci_config_antenna_2529_rx(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&reg, MAC_CSR13_DIR3, 0);
 	rt2x00_set_field32(&reg, MAC_CSR13_VAL3, !p2);
 
-	rt2x00pci_register_write(rt2x00dev, MAC_CSR13, reg);
+	rt2x00mmio_register_write(rt2x00dev, MAC_CSR13, reg);
 }
 
 static void rt61pci_config_antenna_2529(struct rt2x00_dev *rt2x00dev,
@@ -821,14 +822,14 @@ static void rt61pci_config_ant(struct rt2x00_dev *rt2x00dev,
 	for (i = 0; i < ARRAY_SIZE(antenna_sel_a); i++)
 		rt61pci_bbp_write(rt2x00dev, sel[i].word, sel[i].value[lna]);
 
-	rt2x00pci_register_read(rt2x00dev, PHY_CSR0, &reg);
+	rt2x00mmio_register_read(rt2x00dev, PHY_CSR0, &reg);
 
 	rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_BG,
 			   rt2x00dev->curr_band == IEEE80211_BAND_2GHZ);
 	rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_A,
 			   rt2x00dev->curr_band == IEEE80211_BAND_5GHZ);
 
-	rt2x00pci_register_write(rt2x00dev, PHY_CSR0, reg);
+	rt2x00mmio_register_write(rt2x00dev, PHY_CSR0, reg);
 
 	if (rt2x00_rf(rt2x00dev, RF5225) || rt2x00_rf(rt2x00dev, RF5325))
 		rt61pci_config_antenna_5x(rt2x00dev, ant);
@@ -928,7 +929,7 @@ static void rt61pci_config_retry_limit(struct rt2x00_dev *rt2x00dev,
 {
 	u32 reg;
 
-	rt2x00pci_register_read(rt2x00dev, TXRX_CSR4, &reg);
+	rt2x00mmio_register_read(rt2x00dev, TXRX_CSR4, &reg);
 	rt2x00_set_field32(&reg, TXRX_CSR4_OFDM_TX_RATE_DOWN, 1);
 	rt2x00_set_field32(&reg, TXRX_CSR4_OFDM_TX_RATE_STEP, 0);
 	rt2x00_set_field32(&reg, TXRX_CSR4_OFDM_TX_FALLBACK_CCK, 0);
@@ -936,7 +937,7 @@ static void rt61pci_config_retry_limit(struct rt2x00_dev *rt2x00dev,
 			   libconf->conf->long_frame_max_tx_count);
 	rt2x00_set_field32(&reg, TXRX_CSR4_SHORT_RETRY_LIMIT,
 			   libconf->conf->short_frame_max_tx_count);
-	rt2x00pci_register_write(rt2x00dev, TXRX_CSR4, reg);
+	rt2x00mmio_register_write(rt2x00dev, TXRX_CSR4, reg);
 }
 
 static void rt61pci_config_ps(struct rt2x00_dev *rt2x00dev,
@@ -948,7 +949,7 @@ static void rt61pci_config_ps(struct rt2x00_dev *rt2x00dev,
 	u32 reg;
 
 	if (state == STATE_SLEEP) {
-		rt2x00pci_register_read(rt2x00dev, MAC_CSR11, &reg);
+		rt2x00mmio_register_read(rt2x00dev, MAC_CSR11, &reg);
 		rt2x00_set_field32(&reg, MAC_CSR11_DELAY_AFTER_TBCN,
 				   rt2x00dev->beacon_int - 10);
 		rt2x00_set_field32(&reg, MAC_CSR11_TBCN_BEFORE_WAKEUP,
@@ -957,27 +958,29 @@ static void rt61pci_config_ps(struct rt2x00_dev *rt2x00dev,
 
 		/* We must first disable autowake before it can be enabled */
 		rt2x00_set_field32(&reg, MAC_CSR11_AUTOWAKE, 0);
-		rt2x00pci_register_write(rt2x00dev, MAC_CSR11, reg);
+		rt2x00mmio_register_write(rt2x00dev, MAC_CSR11, reg);
 
 		rt2x00_set_field32(&reg, MAC_CSR11_AUTOWAKE, 1);
-		rt2x00pci_register_write(rt2x00dev, MAC_CSR11, reg);
+		rt2x00mmio_register_write(rt2x00dev, MAC_CSR11, reg);
 
-		rt2x00pci_register_write(rt2x00dev, SOFT_RESET_CSR, 0x00000005);
-		rt2x00pci_register_write(rt2x00dev, IO_CNTL_CSR, 0x0000001c);
-		rt2x00pci_register_write(rt2x00dev, PCI_USEC_CSR, 0x00000060);
+		rt2x00mmio_register_write(rt2x00dev, SOFT_RESET_CSR,
+					  0x00000005);
+		rt2x00mmio_register_write(rt2x00dev, IO_CNTL_CSR, 0x0000001c);
+		rt2x00mmio_register_write(rt2x00dev, PCI_USEC_CSR, 0x00000060);
 
 		rt61pci_mcu_request(rt2x00dev, MCU_SLEEP, 0xff, 0, 0);
 	} else {
-		rt2x00pci_register_read(rt2x00dev, MAC_CSR11, &reg);
+		rt2x00mmio_register_read(rt2x00dev, MAC_CSR11, &reg);
 		rt2x00_set_field32(&reg, MAC_CSR11_DELAY_AFTER_TBCN, 0);
 		rt2x00_set_field32(&reg, MAC_CSR11_TBCN_BEFORE_WAKEUP, 0);
 		rt2x00_set_field32(&reg, MAC_CSR11_AUTOWAKE, 0);
 		rt2x00_set_field32(&reg, MAC_CSR11_WAKEUP_LATENCY, 0);
-		rt2x00pci_register_write(rt2x00dev, MAC_CSR11, reg);
+		rt2x00mmio_register_write(rt2x00dev, MAC_CSR11, reg);
 
-		rt2x00pci_register_write(rt2x00dev, SOFT_RESET_CSR, 0x00000007);
-		rt2x00pci_register_write(rt2x00dev, IO_CNTL_CSR, 0x00000018);
-		rt2x00pci_register_write(rt2x00dev, PCI_USEC_CSR, 0x00000020);
+		rt2x00mmio_register_write(rt2x00dev, SOFT_RESET_CSR,
+					  0x00000007);
+		rt2x00mmio_register_write(rt2x00dev, IO_CNTL_CSR, 0x00000018);
+		rt2x00mmio_register_write(rt2x00dev, PCI_USEC_CSR, 0x00000020);
 
 		rt61pci_mcu_request(rt2x00dev, MCU_WAKEUP, 0xff, 0, 0);
 	}
@@ -1013,13 +1016,13 @@ static void rt61pci_link_stats(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Update FCS error count from register.
 	 */
-	rt2x00pci_register_read(rt2x00dev, STA_CSR0, &reg);
+	rt2x00mmio_register_read(rt2x00dev, STA_CSR0, &reg);
 	qual->rx_failed = rt2x00_get_field32(reg, STA_CSR0_FCS_ERROR);
 
 	/*
 	 * Update False CCA count from register.
 	 */
-	rt2x00pci_register_read(rt2x00dev, STA_CSR1, &reg);
+	rt2x00mmio_register_read(rt2x00dev, STA_CSR1, &reg);
 	qual->false_cca = rt2x00_get_field32(reg, STA_CSR1_FALSE_CCA_ERROR);
 }
 
@@ -1138,16 +1141,16 @@ static void rt61pci_start_queue(struct data_queue *queue)
 
 	switch (queue->qid) {
 	case QID_RX:
-		rt2x00pci_register_read(rt2x00dev, TXRX_CSR0, &reg);
+		rt2x00mmio_register_read(rt2x00dev, TXRX_CSR0, &reg);
 		rt2x00_set_field32(&reg, TXRX_CSR0_DISABLE_RX, 0);
-		rt2x00pci_register_write(rt2x00dev, TXRX_CSR0, reg);
+		rt2x00mmio_register_write(rt2x00dev, TXRX_CSR0, reg);
 		break;
 	case QID_BEACON:
-		rt2x00pci_register_read(rt2x00dev, TXRX_CSR9, &reg);
+		rt2x00mmio_register_read(rt2x00dev, TXRX_CSR9, &reg);
 		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_TICKING, 1);
 		rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 1);
 		rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 1);
-		rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, reg);
+		rt2x00mmio_register_write(rt2x00dev, TXRX_CSR9, reg);
 		break;
 	default:
 		break;
@@ -1161,24 +1164,24 @@ static void rt61pci_kick_queue(struct data_queue *queue)
 
 	switch (queue->qid) {
 	case QID_AC_VO:
-		rt2x00pci_register_read(rt2x00dev, TX_CNTL_CSR, &reg);
+		rt2x00mmio_register_read(rt2x00dev, TX_CNTL_CSR, &reg);
 		rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC0, 1);
-		rt2x00pci_register_write(rt2x00dev, TX_CNTL_CSR, reg);
+		rt2x00mmio_register_write(rt2x00dev, TX_CNTL_CSR, reg);
 		break;
 	case QID_AC_VI:
-		rt2x00pci_register_read(rt2x00dev, TX_CNTL_CSR, &reg);
+		rt2x00mmio_register_read(rt2x00dev, TX_CNTL_CSR, &reg);
 		rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC1, 1);
-		rt2x00pci_register_write(rt2x00dev, TX_CNTL_CSR, reg);
+		rt2x00mmio_register_write(rt2x00dev, TX_CNTL_CSR, reg);
 		break;
 	case QID_AC_BE:
-		rt2x00pci_register_read(rt2x00dev, TX_CNTL_CSR, &reg);
+		rt2x00mmio_register_read(rt2x00dev, TX_CNTL_CSR, &reg);
 		rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC2, 1);
-		rt2x00pci_register_write(rt2x00dev, TX_CNTL_CSR, reg);
+		rt2x00mmio_register_write(rt2x00dev, TX_CNTL_CSR, reg);
 		break;
 	case QID_AC_BK:
-		rt2x00pci_register_read(rt2x00dev, TX_CNTL_CSR, &reg);
+		rt2x00mmio_register_read(rt2x00dev, TX_CNTL_CSR, &reg);
 		rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC3, 1);
-		rt2x00pci_register_write(rt2x00dev, TX_CNTL_CSR, reg);
+		rt2x00mmio_register_write(rt2x00dev, TX_CNTL_CSR, reg);
 		break;
 	default:
 		break;
@@ -1192,36 +1195,36 @@ static void rt61pci_stop_queue(struct data_queue *queue)
 
 	switch (queue->qid) {
 	case QID_AC_VO:
-		rt2x00pci_register_read(rt2x00dev, TX_CNTL_CSR, &reg);
+		rt2x00mmio_register_read(rt2x00dev, TX_CNTL_CSR, &reg);
 		rt2x00_set_field32(&reg, TX_CNTL_CSR_ABORT_TX_AC0, 1);
-		rt2x00pci_register_write(rt2x00dev, TX_CNTL_CSR, reg);
+		rt2x00mmio_register_write(rt2x00dev, TX_CNTL_CSR, reg);
 		break;
 	case QID_AC_VI:
-		rt2x00pci_register_read(rt2x00dev, TX_CNTL_CSR, &reg);
+		rt2x00mmio_register_read(rt2x00dev, TX_CNTL_CSR, &reg);
 		rt2x00_set_field32(&reg, TX_CNTL_CSR_ABORT_TX_AC1, 1);
-		rt2x00pci_register_write(rt2x00dev, TX_CNTL_CSR, reg);
+		rt2x00mmio_register_write(rt2x00dev, TX_CNTL_CSR, reg);
 		break;
 	case QID_AC_BE:
-		rt2x00pci_register_read(rt2x00dev, TX_CNTL_CSR, &reg);
+		rt2x00mmio_register_read(rt2x00dev, TX_CNTL_CSR, &reg);
 		rt2x00_set_field32(&reg, TX_CNTL_CSR_ABORT_TX_AC2, 1);
-		rt2x00pci_register_write(rt2x00dev, TX_CNTL_CSR, reg);
+		rt2x00mmio_register_write(rt2x00dev, TX_CNTL_CSR, reg);
 		break;
 	case QID_AC_BK:
-		rt2x00pci_register_read(rt2x00dev, TX_CNTL_CSR, &reg);
+		rt2x00mmio_register_read(rt2x00dev, TX_CNTL_CSR, &reg);
 		rt2x00_set_field32(&reg, TX_CNTL_CSR_ABORT_TX_AC3, 1);
-		rt2x00pci_register_write(rt2x00dev, TX_CNTL_CSR, reg);
+		rt2x00mmio_register_write(rt2x00dev, TX_CNTL_CSR, reg);
 		break;
 	case QID_RX:
-		rt2x00pci_register_read(rt2x00dev, TXRX_CSR0, &reg);
+		rt2x00mmio_register_read(rt2x00dev, TXRX_CSR0, &reg);
 		rt2x00_set_field32(&reg, TXRX_CSR0_DISABLE_RX, 1);
-		rt2x00pci_register_write(rt2x00dev, TXRX_CSR0, reg);
+		rt2x00mmio_register_write(rt2x00dev, TXRX_CSR0, reg);
 		break;
 	case QID_BEACON:
-		rt2x00pci_register_read(rt2x00dev, TXRX_CSR9, &reg);
+		rt2x00mmio_register_read(rt2x00dev, TXRX_CSR9, &reg);
 		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_TICKING, 0);
 		rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 0);
 		rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 0);
-		rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, reg);
+		rt2x00mmio_register_write(rt2x00dev, TXRX_CSR9, reg);
 
 		/*
 		 * Wait for possibly running tbtt tasklets.
@@ -1299,7 +1302,7 @@ static int rt61pci_load_firmware(struct rt2x00_dev *rt2x00dev,
 	 * Wait for stable hardware.
 	 */
 	for (i = 0; i < 100; i++) {
-		rt2x00pci_register_read(rt2x00dev, MAC_CSR0, &reg);
+		rt2x00mmio_register_read(rt2x00dev, MAC_CSR0, &reg);
 		if (reg)
 			break;
 		msleep(1);
@@ -1315,10 +1318,10 @@ static int rt61pci_load_firmware(struct rt2x00_dev *rt2x00dev,
 	 */
 	reg = 0;
 	rt2x00_set_field32(&reg, MCU_CNTL_CSR_RESET, 1);
-	rt2x00pci_register_write(rt2x00dev, MCU_CNTL_CSR, reg);
-	rt2x00pci_register_write(rt2x00dev, M2H_CMD_DONE_CSR, 0xffffffff);
-	rt2x00pci_register_write(rt2x00dev, H2M_MAILBOX_CSR, 0);
-	rt2x00pci_register_write(rt2x00dev, HOST_CMD_CSR, 0);
+	rt2x00mmio_register_write(rt2x00dev, MCU_CNTL_CSR, reg);
+	rt2x00mmio_register_write(rt2x00dev, M2H_CMD_DONE_CSR, 0xffffffff);
+	rt2x00mmio_register_write(rt2x00dev, H2M_MAILBOX_CSR, 0);
+	rt2x00mmio_register_write(rt2x00dev, HOST_CMD_CSR, 0);
 
 	/*
 	 * Write firmware to device.
@@ -1326,19 +1329,19 @@ static int rt61pci_load_firmware(struct rt2x00_dev *rt2x00dev,
 	reg = 0;
 	rt2x00_set_field32(&reg, MCU_CNTL_CSR_RESET, 1);
 	rt2x00_set_field32(&reg, MCU_CNTL_CSR_SELECT_BANK, 1);
-	rt2x00pci_register_write(rt2x00dev, MCU_CNTL_CSR, reg);
+	rt2x00mmio_register_write(rt2x00dev, MCU_CNTL_CSR, reg);
 
-	rt2x00pci_register_multiwrite(rt2x00dev, FIRMWARE_IMAGE_BASE,
-				      data, len);
+	rt2x00mmio_register_multiwrite(rt2x00dev, FIRMWARE_IMAGE_BASE,
+				       data, len);
 
 	rt2x00_set_field32(&reg, MCU_CNTL_CSR_SELECT_BANK, 0);
-	rt2x00pci_register_write(rt2x00dev, MCU_CNTL_CSR, reg);
+	rt2x00mmio_register_write(rt2x00dev, MCU_CNTL_CSR, reg);
 
 	rt2x00_set_field32(&reg, MCU_CNTL_CSR_RESET, 0);
-	rt2x00pci_register_write(rt2x00dev, MCU_CNTL_CSR, reg);
+	rt2x00mmio_register_write(rt2x00dev, MCU_CNTL_CSR, reg);
 
 	for (i = 0; i < 100; i++) {
-		rt2x00pci_register_read(rt2x00dev, MCU_CNTL_CSR, &reg);
+		rt2x00mmio_register_read(rt2x00dev, MCU_CNTL_CSR, &reg);
 		if (rt2x00_get_field32(reg, MCU_CNTL_CSR_READY))
 			break;
 		msleep(1);
@@ -1360,16 +1363,16 @@ static int rt61pci_load_firmware(struct rt2x00_dev *rt2x00dev,
 	reg = 0;
 	rt2x00_set_field32(&reg, MAC_CSR1_SOFT_RESET, 1);
 	rt2x00_set_field32(&reg, MAC_CSR1_BBP_RESET, 1);
-	rt2x00pci_register_write(rt2x00dev, MAC_CSR1, reg);
+	rt2x00mmio_register_write(rt2x00dev, MAC_CSR1, reg);
 
-	rt2x00pci_register_read(rt2x00dev, MAC_CSR1, &reg);
+	rt2x00mmio_register_read(rt2x00dev, MAC_CSR1, &reg);
 	rt2x00_set_field32(&reg, MAC_CSR1_SOFT_RESET, 0);
 	rt2x00_set_field32(&reg, MAC_CSR1_BBP_RESET, 0);
-	rt2x00pci_register_write(rt2x00dev, MAC_CSR1, reg);
+	rt2x00mmio_register_write(rt2x00dev, MAC_CSR1, reg);
 
-	rt2x00pci_register_read(rt2x00dev, MAC_CSR1, &reg);
+	rt2x00mmio_register_read(rt2x00dev, MAC_CSR1, &reg);
 	rt2x00_set_field32(&reg, MAC_CSR1_HOST_READY, 1);
-	rt2x00pci_register_write(rt2x00dev, MAC_CSR1, reg);
+	rt2x00mmio_register_write(rt2x00dev, MAC_CSR1, reg);
 
 	return 0;
 }
@@ -1379,7 +1382,7 @@ static int rt61pci_load_firmware(struct rt2x00_dev *rt2x00dev,
  */
 static bool rt61pci_get_entry_state(struct queue_entry *entry)
 {
-	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
+	struct queue_entry_priv_mmio *entry_priv = entry->priv_data;
 	u32 word;
 
 	if (entry->queue->qid == QID_RX) {
@@ -1396,7 +1399,7 @@ static bool rt61pci_get_entry_state(struct queue_entry *entry)
 
 static void rt61pci_clear_entry(struct queue_entry *entry)
 {
-	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
+	struct queue_entry_priv_mmio *entry_priv = entry->priv_data;
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
 	u32 word;
 
@@ -1419,13 +1422,13 @@ static void rt61pci_clear_entry(struct queue_entry *entry)
 
 static int rt61pci_init_queues(struct rt2x00_dev *rt2x00dev)
 {
-	struct queue_entry_priv_pci *entry_priv;
+	struct queue_entry_priv_mmio *entry_priv;
 	u32 reg;
 
 	/*
 	 * Initialize registers.
 	 */
-	rt2x00pci_register_read(rt2x00dev, TX_RING_CSR0, &reg);
+	rt2x00mmio_register_read(rt2x00dev, TX_RING_CSR0, &reg);
 	rt2x00_set_field32(&reg, TX_RING_CSR0_AC0_RING_SIZE,
 			   rt2x00dev->tx[0].limit);
 	rt2x00_set_field32(&reg, TX_RING_CSR0_AC1_RING_SIZE,
@@ -1434,67 +1437,67 @@ static int rt61pci_init_queues(struct rt2x00_dev *rt2x00dev)
 			   rt2x00dev->tx[2].limit);
 	rt2x00_set_field32(&reg, TX_RING_CSR0_AC3_RING_SIZE,
 			   rt2x00dev->tx[3].limit);
-	rt2x00pci_register_write(rt2x00dev, TX_RING_CSR0, reg);
+	rt2x00mmio_register_write(rt2x00dev, TX_RING_CSR0, reg);
 
-	rt2x00pci_register_read(rt2x00dev, TX_RING_CSR1, &reg);
+	rt2x00mmio_register_read(rt2x00dev, TX_RING_CSR1, &reg);
 	rt2x00_set_field32(&reg, TX_RING_CSR1_TXD_SIZE,
 			   rt2x00dev->tx[0].desc_size / 4);
-	rt2x00pci_register_write(rt2x00dev, TX_RING_CSR1, reg);
+	rt2x00mmio_register_write(rt2x00dev, TX_RING_CSR1, reg);
 
 	entry_priv = rt2x00dev->tx[0].entries[0].priv_data;
-	rt2x00pci_register_read(rt2x00dev, AC0_BASE_CSR, &reg);
+	rt2x00mmio_register_read(rt2x00dev, AC0_BASE_CSR, &reg);
 	rt2x00_set_field32(&reg, AC0_BASE_CSR_RING_REGISTER,
 			   entry_priv->desc_dma);
-	rt2x00pci_register_write(rt2x00dev, AC0_BASE_CSR, reg);
+	rt2x00mmio_register_write(rt2x00dev, AC0_BASE_CSR, reg);
 
 	entry_priv = rt2x00dev->tx[1].entries[0].priv_data;
-	rt2x00pci_register_read(rt2x00dev, AC1_BASE_CSR, &reg);
+	rt2x00mmio_register_read(rt2x00dev, AC1_BASE_CSR, &reg);
 	rt2x00_set_field32(&reg, AC1_BASE_CSR_RING_REGISTER,
 			   entry_priv->desc_dma);
-	rt2x00pci_register_write(rt2x00dev, AC1_BASE_CSR, reg);
+	rt2x00mmio_register_write(rt2x00dev, AC1_BASE_CSR, reg);
 
 	entry_priv = rt2x00dev->tx[2].entries[0].priv_data;
-	rt2x00pci_register_read(rt2x00dev, AC2_BASE_CSR, &reg);
+	rt2x00mmio_register_read(rt2x00dev, AC2_BASE_CSR, &reg);
 	rt2x00_set_field32(&reg, AC2_BASE_CSR_RING_REGISTER,
 			   entry_priv->desc_dma);
-	rt2x00pci_register_write(rt2x00dev, AC2_BASE_CSR, reg);
+	rt2x00mmio_register_write(rt2x00dev, AC2_BASE_CSR, reg);
 
 	entry_priv = rt2x00dev->tx[3].entries[0].priv_data;
-	rt2x00pci_register_read(rt2x00dev, AC3_BASE_CSR, &reg);
+	rt2x00mmio_register_read(rt2x00dev, AC3_BASE_CSR, &reg);
 	rt2x00_set_field32(&reg, AC3_BASE_CSR_RING_REGISTER,
 			   entry_priv->desc_dma);
-	rt2x00pci_register_write(rt2x00dev, AC3_BASE_CSR, reg);
+	rt2x00mmio_register_write(rt2x00dev, AC3_BASE_CSR, reg);
 
-	rt2x00pci_register_read(rt2x00dev, RX_RING_CSR, &reg);
+	rt2x00mmio_register_read(rt2x00dev, RX_RING_CSR, &reg);
 	rt2x00_set_field32(&reg, RX_RING_CSR_RING_SIZE, rt2x00dev->rx->limit);
 	rt2x00_set_field32(&reg, RX_RING_CSR_RXD_SIZE,
 			   rt2x00dev->rx->desc_size / 4);
 	rt2x00_set_field32(&reg, RX_RING_CSR_RXD_WRITEBACK_SIZE, 4);
-	rt2x00pci_register_write(rt2x00dev, RX_RING_CSR, reg);
+	rt2x00mmio_register_write(rt2x00dev, RX_RING_CSR, reg);
 
 	entry_priv = rt2x00dev->rx->entries[0].priv_data;
-	rt2x00pci_register_read(rt2x00dev, RX_BASE_CSR, &reg);
+	rt2x00mmio_register_read(rt2x00dev, RX_BASE_CSR, &reg);
 	rt2x00_set_field32(&reg, RX_BASE_CSR_RING_REGISTER,
 			   entry_priv->desc_dma);
-	rt2x00pci_register_write(rt2x00dev, RX_BASE_CSR, reg);
+	rt2x00mmio_register_write(rt2x00dev, RX_BASE_CSR, reg);
 
-	rt2x00pci_register_read(rt2x00dev, TX_DMA_DST_CSR, &reg);
+	rt2x00mmio_register_read(rt2x00dev, TX_DMA_DST_CSR, &reg);
 	rt2x00_set_field32(&reg, TX_DMA_DST_CSR_DEST_AC0, 2);
 	rt2x00_set_field32(&reg, TX_DMA_DST_CSR_DEST_AC1, 2);
 	rt2x00_set_field32(&reg, TX_DMA_DST_CSR_DEST_AC2, 2);
 	rt2x00_set_field32(&reg, TX_DMA_DST_CSR_DEST_AC3, 2);
-	rt2x00pci_register_write(rt2x00dev, TX_DMA_DST_CSR, reg);
+	rt2x00mmio_register_write(rt2x00dev, TX_DMA_DST_CSR, reg);
 
-	rt2x00pci_register_read(rt2x00dev, LOAD_TX_RING_CSR, &reg);
+	rt2x00mmio_register_read(rt2x00dev, LOAD_TX_RING_CSR, &reg);
 	rt2x00_set_field32(&reg, LOAD_TX_RING_CSR_LOAD_TXD_AC0, 1);
 	rt2x00_set_field32(&reg, LOAD_TX_RING_CSR_LOAD_TXD_AC1, 1);
 	rt2x00_set_field32(&reg, LOAD_TX_RING_CSR_LOAD_TXD_AC2, 1);
 	rt2x00_set_field32(&reg, LOAD_TX_RING_CSR_LOAD_TXD_AC3, 1);
-	rt2x00pci_register_write(rt2x00dev, LOAD_TX_RING_CSR, reg);
+	rt2x00mmio_register_write(rt2x00dev, LOAD_TX_RING_CSR, reg);
 
-	rt2x00pci_register_read(rt2x00dev, RX_CNTL_CSR, &reg);
+	rt2x00mmio_register_read(rt2x00dev, RX_CNTL_CSR, &reg);
 	rt2x00_set_field32(&reg, RX_CNTL_CSR_LOAD_RXD, 1);
-	rt2x00pci_register_write(rt2x00dev, RX_CNTL_CSR, reg);
+	rt2x00mmio_register_write(rt2x00dev, RX_CNTL_CSR, reg);
 
 	return 0;
 }
@@ -1503,13 +1506,13 @@ static int rt61pci_init_registers(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
 
-	rt2x00pci_register_read(rt2x00dev, TXRX_CSR0, &reg);
+	rt2x00mmio_register_read(rt2x00dev, TXRX_CSR0, &reg);
 	rt2x00_set_field32(&reg, TXRX_CSR0_AUTO_TX_SEQ, 1);
 	rt2x00_set_field32(&reg, TXRX_CSR0_DISABLE_RX, 0);
 	rt2x00_set_field32(&reg, TXRX_CSR0_TX_WITHOUT_WAITING, 0);
-	rt2x00pci_register_write(rt2x00dev, TXRX_CSR0, reg);
+	rt2x00mmio_register_write(rt2x00dev, TXRX_CSR0, reg);
 
-	rt2x00pci_register_read(rt2x00dev, TXRX_CSR1, &reg);
+	rt2x00mmio_register_read(rt2x00dev, TXRX_CSR1, &reg);
 	rt2x00_set_field32(&reg, TXRX_CSR1_BBP_ID0, 47); /* CCK Signal */
 	rt2x00_set_field32(&reg, TXRX_CSR1_BBP_ID0_VALID, 1);
 	rt2x00_set_field32(&reg, TXRX_CSR1_BBP_ID1, 30); /* Rssi */
@@ -1518,12 +1521,12 @@ static int rt61pci_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, TXRX_CSR1_BBP_ID2_VALID, 1);
 	rt2x00_set_field32(&reg, TXRX_CSR1_BBP_ID3, 30); /* Rssi */
 	rt2x00_set_field32(&reg, TXRX_CSR1_BBP_ID3_VALID, 1);
-	rt2x00pci_register_write(rt2x00dev, TXRX_CSR1, reg);
+	rt2x00mmio_register_write(rt2x00dev, TXRX_CSR1, reg);
 
 	/*
 	 * CCK TXD BBP registers
 	 */
-	rt2x00pci_register_read(rt2x00dev, TXRX_CSR2, &reg);
+	rt2x00mmio_register_read(rt2x00dev, TXRX_CSR2, &reg);
 	rt2x00_set_field32(&reg, TXRX_CSR2_BBP_ID0, 13);
 	rt2x00_set_field32(&reg, TXRX_CSR2_BBP_ID0_VALID, 1);
 	rt2x00_set_field32(&reg, TXRX_CSR2_BBP_ID1, 12);
@@ -1532,76 +1535,76 @@ static int rt61pci_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, TXRX_CSR2_BBP_ID2_VALID, 1);
 	rt2x00_set_field32(&reg, TXRX_CSR2_BBP_ID3, 10);
 	rt2x00_set_field32(&reg, TXRX_CSR2_BBP_ID3_VALID, 1);
-	rt2x00pci_register_write(rt2x00dev, TXRX_CSR2, reg);
+	rt2x00mmio_register_write(rt2x00dev, TXRX_CSR2, reg);
 
 	/*
 	 * OFDM TXD BBP registers
 	 */
-	rt2x00pci_register_read(rt2x00dev, TXRX_CSR3, &reg);
+	rt2x00mmio_register_read(rt2x00dev, TXRX_CSR3, &reg);
 	rt2x00_set_field32(&reg, TXRX_CSR3_BBP_ID0, 7);
 	rt2x00_set_field32(&reg, TXRX_CSR3_BBP_ID0_VALID, 1);
 	rt2x00_set_field32(&reg, TXRX_CSR3_BBP_ID1, 6);
 	rt2x00_set_field32(&reg, TXRX_CSR3_BBP_ID1_VALID, 1);
 	rt2x00_set_field32(&reg, TXRX_CSR3_BBP_ID2, 5);
 	rt2x00_set_field32(&reg, TXRX_CSR3_BBP_ID2_VALID, 1);
-	rt2x00pci_register_write(rt2x00dev, TXRX_CSR3, reg);
+	rt2x00mmio_register_write(rt2x00dev, TXRX_CSR3, reg);
 
-	rt2x00pci_register_read(rt2x00dev, TXRX_CSR7, &reg);
+	rt2x00mmio_register_read(rt2x00dev, TXRX_CSR7, &reg);
 	rt2x00_set_field32(&reg, TXRX_CSR7_ACK_CTS_6MBS, 59);
 	rt2x00_set_field32(&reg, TXRX_CSR7_ACK_CTS_9MBS, 53);
 	rt2x00_set_field32(&reg, TXRX_CSR7_ACK_CTS_12MBS, 49);
 	rt2x00_set_field32(&reg, TXRX_CSR7_ACK_CTS_18MBS, 46);
-	rt2x00pci_register_write(rt2x00dev, TXRX_CSR7, reg);
+	rt2x00mmio_register_write(rt2x00dev, TXRX_CSR7, reg);
 
-	rt2x00pci_register_read(rt2x00dev, TXRX_CSR8, &reg);
+	rt2x00mmio_register_read(rt2x00dev, TXRX_CSR8, &reg);
 	rt2x00_set_field32(&reg, TXRX_CSR8_ACK_CTS_24MBS, 44);
 	rt2x00_set_field32(&reg, TXRX_CSR8_ACK_CTS_36MBS, 42);
 	rt2x00_set_field32(&reg, TXRX_CSR8_ACK_CTS_48MBS, 42);
 	rt2x00_set_field32(&reg, TXRX_CSR8_ACK_CTS_54MBS, 42);
-	rt2x00pci_register_write(rt2x00dev, TXRX_CSR8, reg);
+	rt2x00mmio_register_write(rt2x00dev, TXRX_CSR8, reg);
 
-	rt2x00pci_register_read(rt2x00dev, TXRX_CSR9, &reg);
+	rt2x00mmio_register_read(rt2x00dev, TXRX_CSR9, &reg);
 	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_INTERVAL, 0);
 	rt2x00_set_field32(&reg, TXRX_CSR9_TSF_TICKING, 0);
 	rt2x00_set_field32(&reg, TXRX_CSR9_TSF_SYNC, 0);
 	rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 0);
 	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 0);
 	rt2x00_set_field32(&reg, TXRX_CSR9_TIMESTAMP_COMPENSATE, 0);
-	rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, reg);
+	rt2x00mmio_register_write(rt2x00dev, TXRX_CSR9, reg);
 
-	rt2x00pci_register_write(rt2x00dev, TXRX_CSR15, 0x0000000f);
+	rt2x00mmio_register_write(rt2x00dev, TXRX_CSR15, 0x0000000f);
 
-	rt2x00pci_register_write(rt2x00dev, MAC_CSR6, 0x00000fff);
+	rt2x00mmio_register_write(rt2x00dev, MAC_CSR6, 0x00000fff);
 
-	rt2x00pci_register_read(rt2x00dev, MAC_CSR9, &reg);
+	rt2x00mmio_register_read(rt2x00dev, MAC_CSR9, &reg);
 	rt2x00_set_field32(&reg, MAC_CSR9_CW_SELECT, 0);
-	rt2x00pci_register_write(rt2x00dev, MAC_CSR9, reg);
+	rt2x00mmio_register_write(rt2x00dev, MAC_CSR9, reg);
 
-	rt2x00pci_register_write(rt2x00dev, MAC_CSR10, 0x0000071c);
+	rt2x00mmio_register_write(rt2x00dev, MAC_CSR10, 0x0000071c);
 
 	if (rt2x00dev->ops->lib->set_device_state(rt2x00dev, STATE_AWAKE))
 		return -EBUSY;
 
-	rt2x00pci_register_write(rt2x00dev, MAC_CSR13, 0x0000e000);
+	rt2x00mmio_register_write(rt2x00dev, MAC_CSR13, 0x0000e000);
 
 	/*
 	 * Invalidate all Shared Keys (SEC_CSR0),
 	 * and clear the Shared key Cipher algorithms (SEC_CSR1 & SEC_CSR5)
 	 */
-	rt2x00pci_register_write(rt2x00dev, SEC_CSR0, 0x00000000);
-	rt2x00pci_register_write(rt2x00dev, SEC_CSR1, 0x00000000);
-	rt2x00pci_register_write(rt2x00dev, SEC_CSR5, 0x00000000);
+	rt2x00mmio_register_write(rt2x00dev, SEC_CSR0, 0x00000000);
+	rt2x00mmio_register_write(rt2x00dev, SEC_CSR1, 0x00000000);
+	rt2x00mmio_register_write(rt2x00dev, SEC_CSR5, 0x00000000);
 
-	rt2x00pci_register_write(rt2x00dev, PHY_CSR1, 0x000023b0);
-	rt2x00pci_register_write(rt2x00dev, PHY_CSR5, 0x060a100c);
-	rt2x00pci_register_write(rt2x00dev, PHY_CSR6, 0x00080606);
-	rt2x00pci_register_write(rt2x00dev, PHY_CSR7, 0x00000a08);
+	rt2x00mmio_register_write(rt2x00dev, PHY_CSR1, 0x000023b0);
+	rt2x00mmio_register_write(rt2x00dev, PHY_CSR5, 0x060a100c);
+	rt2x00mmio_register_write(rt2x00dev, PHY_CSR6, 0x00080606);
+	rt2x00mmio_register_write(rt2x00dev, PHY_CSR7, 0x00000a08);
 
-	rt2x00pci_register_write(rt2x00dev, PCI_CFG_CSR, 0x28ca4404);
+	rt2x00mmio_register_write(rt2x00dev, PCI_CFG_CSR, 0x28ca4404);
 
-	rt2x00pci_register_write(rt2x00dev, TEST_MODE_CSR, 0x00000200);
+	rt2x00mmio_register_write(rt2x00dev, TEST_MODE_CSR, 0x00000200);
 
-	rt2x00pci_register_write(rt2x00dev, M2H_CMD_DONE_CSR, 0xffffffff);
+	rt2x00mmio_register_write(rt2x00dev, M2H_CMD_DONE_CSR, 0xffffffff);
 
 	/*
 	 * Clear all beacons
@@ -1609,36 +1612,36 @@ static int rt61pci_init_registers(struct rt2x00_dev *rt2x00dev)
 	 * the first byte since that byte contains the VALID and OWNER
 	 * bits which (when set to 0) will invalidate the entire beacon.
 	 */
-	rt2x00pci_register_write(rt2x00dev, HW_BEACON_BASE0, 0);
-	rt2x00pci_register_write(rt2x00dev, HW_BEACON_BASE1, 0);
-	rt2x00pci_register_write(rt2x00dev, HW_BEACON_BASE2, 0);
-	rt2x00pci_register_write(rt2x00dev, HW_BEACON_BASE3, 0);
+	rt2x00mmio_register_write(rt2x00dev, HW_BEACON_BASE0, 0);
+	rt2x00mmio_register_write(rt2x00dev, HW_BEACON_BASE1, 0);
+	rt2x00mmio_register_write(rt2x00dev, HW_BEACON_BASE2, 0);
+	rt2x00mmio_register_write(rt2x00dev, HW_BEACON_BASE3, 0);
 
 	/*
 	 * We must clear the error counters.
 	 * These registers are cleared on read,
 	 * so we may pass a useless variable to store the value.
 	 */
-	rt2x00pci_register_read(rt2x00dev, STA_CSR0, &reg);
-	rt2x00pci_register_read(rt2x00dev, STA_CSR1, &reg);
-	rt2x00pci_register_read(rt2x00dev, STA_CSR2, &reg);
+	rt2x00mmio_register_read(rt2x00dev, STA_CSR0, &reg);
+	rt2x00mmio_register_read(rt2x00dev, STA_CSR1, &reg);
+	rt2x00mmio_register_read(rt2x00dev, STA_CSR2, &reg);
 
 	/*
 	 * Reset MAC and BBP registers.
 	 */
-	rt2x00pci_register_read(rt2x00dev, MAC_CSR1, &reg);
+	rt2x00mmio_register_read(rt2x00dev, MAC_CSR1, &reg);
 	rt2x00_set_field32(&reg, MAC_CSR1_SOFT_RESET, 1);
 	rt2x00_set_field32(&reg, MAC_CSR1_BBP_RESET, 1);
-	rt2x00pci_register_write(rt2x00dev, MAC_CSR1, reg);
+	rt2x00mmio_register_write(rt2x00dev, MAC_CSR1, reg);
 
-	rt2x00pci_register_read(rt2x00dev, MAC_CSR1, &reg);
+	rt2x00mmio_register_read(rt2x00dev, MAC_CSR1, &reg);
 	rt2x00_set_field32(&reg, MAC_CSR1_SOFT_RESET, 0);
 	rt2x00_set_field32(&reg, MAC_CSR1_BBP_RESET, 0);
-	rt2x00pci_register_write(rt2x00dev, MAC_CSR1, reg);
+	rt2x00mmio_register_write(rt2x00dev, MAC_CSR1, reg);
 
-	rt2x00pci_register_read(rt2x00dev, MAC_CSR1, &reg);
+	rt2x00mmio_register_read(rt2x00dev, MAC_CSR1, &reg);
 	rt2x00_set_field32(&reg, MAC_CSR1_HOST_READY, 1);
-	rt2x00pci_register_write(rt2x00dev, MAC_CSR1, reg);
+	rt2x00mmio_register_write(rt2x00dev, MAC_CSR1, reg);
 
 	return 0;
 }
@@ -1722,11 +1725,11 @@ static void rt61pci_toggle_irq(struct rt2x00_dev *rt2x00dev,
 	 * should clear the register to assure a clean state.
 	 */
 	if (state == STATE_RADIO_IRQ_ON) {
-		rt2x00pci_register_read(rt2x00dev, INT_SOURCE_CSR, &reg);
-		rt2x00pci_register_write(rt2x00dev, INT_SOURCE_CSR, reg);
+		rt2x00mmio_register_read(rt2x00dev, INT_SOURCE_CSR, &reg);
+		rt2x00mmio_register_write(rt2x00dev, INT_SOURCE_CSR, reg);
 
-		rt2x00pci_register_read(rt2x00dev, MCU_INT_SOURCE_CSR, &reg);
-		rt2x00pci_register_write(rt2x00dev, MCU_INT_SOURCE_CSR, reg);
+		rt2x00mmio_register_read(rt2x00dev, MCU_INT_SOURCE_CSR, &reg);
+		rt2x00mmio_register_write(rt2x00dev, MCU_INT_SOURCE_CSR, reg);
 	}
 
 	/*
@@ -1735,15 +1738,15 @@ static void rt61pci_toggle_irq(struct rt2x00_dev *rt2x00dev,
 	 */
 	spin_lock_irqsave(&rt2x00dev->irqmask_lock, flags);
 
-	rt2x00pci_register_read(rt2x00dev, INT_MASK_CSR, &reg);
+	rt2x00mmio_register_read(rt2x00dev, INT_MASK_CSR, &reg);
 	rt2x00_set_field32(&reg, INT_MASK_CSR_TXDONE, mask);
 	rt2x00_set_field32(&reg, INT_MASK_CSR_RXDONE, mask);
 	rt2x00_set_field32(&reg, INT_MASK_CSR_BEACON_DONE, mask);
 	rt2x00_set_field32(&reg, INT_MASK_CSR_ENABLE_MITIGATION, mask);
 	rt2x00_set_field32(&reg, INT_MASK_CSR_MITIGATION_PERIOD, 0xff);
-	rt2x00pci_register_write(rt2x00dev, INT_MASK_CSR, reg);
+	rt2x00mmio_register_write(rt2x00dev, INT_MASK_CSR, reg);
 
-	rt2x00pci_register_read(rt2x00dev, MCU_INT_MASK_CSR, &reg);
+	rt2x00mmio_register_read(rt2x00dev, MCU_INT_MASK_CSR, &reg);
 	rt2x00_set_field32(&reg, MCU_INT_MASK_CSR_0, mask);
 	rt2x00_set_field32(&reg, MCU_INT_MASK_CSR_1, mask);
 	rt2x00_set_field32(&reg, MCU_INT_MASK_CSR_2, mask);
@@ -1753,7 +1756,7 @@ static void rt61pci_toggle_irq(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&reg, MCU_INT_MASK_CSR_6, mask);
 	rt2x00_set_field32(&reg, MCU_INT_MASK_CSR_7, mask);
 	rt2x00_set_field32(&reg, MCU_INT_MASK_CSR_TWAKEUP, mask);
-	rt2x00pci_register_write(rt2x00dev, MCU_INT_MASK_CSR, reg);
+	rt2x00mmio_register_write(rt2x00dev, MCU_INT_MASK_CSR, reg);
 
 	spin_unlock_irqrestore(&rt2x00dev->irqmask_lock, flags);
 
@@ -1783,9 +1786,9 @@ static int rt61pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Enable RX.
 	 */
-	rt2x00pci_register_read(rt2x00dev, RX_CNTL_CSR, &reg);
+	rt2x00mmio_register_read(rt2x00dev, RX_CNTL_CSR, &reg);
 	rt2x00_set_field32(&reg, RX_CNTL_CSR_ENABLE_RX_DMA, 1);
-	rt2x00pci_register_write(rt2x00dev, RX_CNTL_CSR, reg);
+	rt2x00mmio_register_write(rt2x00dev, RX_CNTL_CSR, reg);
 
 	return 0;
 }
@@ -1795,7 +1798,7 @@ static void rt61pci_disable_radio(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Disable power
 	 */
-	rt2x00pci_register_write(rt2x00dev, MAC_CSR10, 0x00001818);
+	rt2x00mmio_register_write(rt2x00dev, MAC_CSR10, 0x00001818);
 }
 
 static int rt61pci_set_state(struct rt2x00_dev *rt2x00dev, enum dev_state state)
@@ -1806,10 +1809,10 @@ static int rt61pci_set_state(struct rt2x00_dev *rt2x00dev, enum dev_state state)
 
 	put_to_sleep = (state != STATE_AWAKE);
 
-	rt2x00pci_register_read(rt2x00dev, MAC_CSR12, &reg);
+	rt2x00mmio_register_read(rt2x00dev, MAC_CSR12, &reg);
 	rt2x00_set_field32(&reg, MAC_CSR12_FORCE_WAKEUP, !put_to_sleep);
 	rt2x00_set_field32(&reg, MAC_CSR12_PUT_TO_SLEEP, put_to_sleep);
-	rt2x00pci_register_write(rt2x00dev, MAC_CSR12, reg);
+	rt2x00mmio_register_write(rt2x00dev, MAC_CSR12, reg);
 
 	/*
 	 * Device is not guaranteed to be in the requested state yet.
@@ -1817,11 +1820,11 @@ static int rt61pci_set_state(struct rt2x00_dev *rt2x00dev, enum dev_state state)
 	 * device has entered the correct state.
 	 */
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
-		rt2x00pci_register_read(rt2x00dev, MAC_CSR12, &reg2);
+		rt2x00mmio_register_read(rt2x00dev, MAC_CSR12, &reg2);
 		state = rt2x00_get_field32(reg2, MAC_CSR12_BBP_CURRENT_STATE);
 		if (state == !put_to_sleep)
 			return 0;
-		rt2x00pci_register_write(rt2x00dev, MAC_CSR12, reg);
+		rt2x00mmio_register_write(rt2x00dev, MAC_CSR12, reg);
 		msleep(10);
 	}
 
@@ -1869,7 +1872,7 @@ static void rt61pci_write_tx_desc(struct queue_entry *entry,
 				  struct txentry_desc *txdesc)
 {
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
-	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
+	struct queue_entry_priv_mmio *entry_priv = entry->priv_data;
 	__le32 *txd = entry_priv->desc;
 	u32 word;
 
@@ -1967,7 +1970,7 @@ static void rt61pci_write_beacon(struct queue_entry *entry,
 				 struct txentry_desc *txdesc)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
-	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
+	struct queue_entry_priv_mmio *entry_priv = entry->priv_data;
 	unsigned int beacon_base;
 	unsigned int padding_len;
 	u32 orig_reg, reg;
@@ -1976,10 +1979,10 @@ static void rt61pci_write_beacon(struct queue_entry *entry,
 	 * Disable beaconing while we are reloading the beacon data,
 	 * otherwise we might be sending out invalid data.
 	 */
-	rt2x00pci_register_read(rt2x00dev, TXRX_CSR9, &reg);
+	rt2x00mmio_register_read(rt2x00dev, TXRX_CSR9, &reg);
 	orig_reg = reg;
 	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 0);
-	rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, reg);
+	rt2x00mmio_register_write(rt2x00dev, TXRX_CSR9, reg);
 
 	/*
 	 * Write the TX descriptor for the beacon.
@@ -1999,16 +2002,16 @@ static void rt61pci_write_beacon(struct queue_entry *entry,
 		ERROR(rt2x00dev, "Failure padding beacon, aborting\n");
 		/* skb freed by skb_pad() on failure */
 		entry->skb = NULL;
-		rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, orig_reg);
+		rt2x00mmio_register_write(rt2x00dev, TXRX_CSR9, orig_reg);
 		return;
 	}
 
 	beacon_base = HW_BEACON_OFFSET(entry->entry_idx);
-	rt2x00pci_register_multiwrite(rt2x00dev, beacon_base,
-				      entry_priv->desc, TXINFO_SIZE);
-	rt2x00pci_register_multiwrite(rt2x00dev, beacon_base + TXINFO_SIZE,
-				      entry->skb->data,
-				      entry->skb->len + padding_len);
+	rt2x00mmio_register_multiwrite(rt2x00dev, beacon_base,
+				       entry_priv->desc, TXINFO_SIZE);
+	rt2x00mmio_register_multiwrite(rt2x00dev, beacon_base + TXINFO_SIZE,
+				       entry->skb->data,
+				       entry->skb->len + padding_len);
 
 	/*
 	 * Enable beaconing again.
@@ -2016,10 +2019,10 @@ static void rt61pci_write_beacon(struct queue_entry *entry,
 	 * For Wi-Fi faily generated beacons between participating
 	 * stations. Set TBTT phase adaptive adjustment step to 8us.
 	 */
-	rt2x00pci_register_write(rt2x00dev, TXRX_CSR10, 0x00001008);
+	rt2x00mmio_register_write(rt2x00dev, TXRX_CSR10, 0x00001008);
 
 	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 1);
-	rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, reg);
+	rt2x00mmio_register_write(rt2x00dev, TXRX_CSR9, reg);
 
 	/*
 	 * Clean up beacon skb.
@@ -2037,21 +2040,21 @@ static void rt61pci_clear_beacon(struct queue_entry *entry)
 	 * Disable beaconing while we are reloading the beacon data,
 	 * otherwise we might be sending out invalid data.
 	 */
-	rt2x00pci_register_read(rt2x00dev, TXRX_CSR9, &reg);
+	rt2x00mmio_register_read(rt2x00dev, TXRX_CSR9, &reg);
 	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 0);
-	rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, reg);
+	rt2x00mmio_register_write(rt2x00dev, TXRX_CSR9, reg);
 
 	/*
 	 * Clear beacon.
 	 */
-	rt2x00pci_register_write(rt2x00dev,
-				 HW_BEACON_OFFSET(entry->entry_idx), 0);
+	rt2x00mmio_register_write(rt2x00dev,
+				  HW_BEACON_OFFSET(entry->entry_idx), 0);
 
 	/*
 	 * Enable beaconing again.
 	 */
 	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 1);
-	rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, reg);
+	rt2x00mmio_register_write(rt2x00dev, TXRX_CSR9, reg);
 }
 
 /*
@@ -2089,7 +2092,7 @@ static void rt61pci_fill_rxdone(struct queue_entry *entry,
 				struct rxdone_entry_desc *rxdesc)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
-	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
+	struct queue_entry_priv_mmio *entry_priv = entry->priv_data;
 	u32 word0;
 	u32 word1;
 
@@ -2155,7 +2158,7 @@ static void rt61pci_txdone(struct rt2x00_dev *rt2x00dev)
 	struct data_queue *queue;
 	struct queue_entry *entry;
 	struct queue_entry *entry_done;
-	struct queue_entry_priv_pci *entry_priv;
+	struct queue_entry_priv_mmio *entry_priv;
 	struct txdone_entry_desc txdesc;
 	u32 word;
 	u32 reg;
@@ -2173,7 +2176,7 @@ static void rt61pci_txdone(struct rt2x00_dev *rt2x00dev)
 	 * tx ring size for now.
 	 */
 	for (i = 0; i < rt2x00dev->ops->tx->entry_num; i++) {
-		rt2x00pci_register_read(rt2x00dev, STA_CSR4, &reg);
+		rt2x00mmio_register_read(rt2x00dev, STA_CSR4, &reg);
 		if (!rt2x00_get_field32(reg, STA_CSR4_VALID))
 			break;
 
@@ -2260,9 +2263,9 @@ static inline void rt61pci_enable_interrupt(struct rt2x00_dev *rt2x00dev,
 	 */
 	spin_lock_irq(&rt2x00dev->irqmask_lock);
 
-	rt2x00pci_register_read(rt2x00dev, INT_MASK_CSR, &reg);
+	rt2x00mmio_register_read(rt2x00dev, INT_MASK_CSR, &reg);
 	rt2x00_set_field32(&reg, irq_field, 0);
-	rt2x00pci_register_write(rt2x00dev, INT_MASK_CSR, reg);
+	rt2x00mmio_register_write(rt2x00dev, INT_MASK_CSR, reg);
 
 	spin_unlock_irq(&rt2x00dev->irqmask_lock);
 }
@@ -2278,9 +2281,9 @@ static void rt61pci_enable_mcu_interrupt(struct rt2x00_dev *rt2x00dev,
 	 */
 	spin_lock_irq(&rt2x00dev->irqmask_lock);
 
-	rt2x00pci_register_read(rt2x00dev, MCU_INT_MASK_CSR, &reg);
+	rt2x00mmio_register_read(rt2x00dev, MCU_INT_MASK_CSR, &reg);
 	rt2x00_set_field32(&reg, irq_field, 0);
-	rt2x00pci_register_write(rt2x00dev, MCU_INT_MASK_CSR, reg);
+	rt2x00mmio_register_write(rt2x00dev, MCU_INT_MASK_CSR, reg);
 
 	spin_unlock_irq(&rt2x00dev->irqmask_lock);
 }
@@ -2304,7 +2307,7 @@ static void rt61pci_tbtt_tasklet(unsigned long data)
 static void rt61pci_rxdone_tasklet(unsigned long data)
 {
 	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
-	if (rt2x00pci_rxdone(rt2x00dev))
+	if (rt2x00mmio_rxdone(rt2x00dev))
 		tasklet_schedule(&rt2x00dev->rxdone_tasklet);
 	else if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
 		rt61pci_enable_interrupt(rt2x00dev, INT_MASK_CSR_RXDONE);
@@ -2314,8 +2317,8 @@ static void rt61pci_autowake_tasklet(unsigned long data)
 {
 	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
 	rt61pci_wakeup(rt2x00dev);
-	rt2x00pci_register_write(rt2x00dev,
-				 M2H_CMD_DONE_CSR, 0xffffffff);
+	rt2x00mmio_register_write(rt2x00dev,
+				  M2H_CMD_DONE_CSR, 0xffffffff);
 	if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
 		rt61pci_enable_mcu_interrupt(rt2x00dev, MCU_INT_MASK_CSR_TWAKEUP);
 }
@@ -2330,11 +2333,11 @@ static irqreturn_t rt61pci_interrupt(int irq, void *dev_instance)
 	 * Get the interrupt sources & saved to local variable.
 	 * Write register value back to clear pending interrupts.
 	 */
-	rt2x00pci_register_read(rt2x00dev, MCU_INT_SOURCE_CSR, &reg_mcu);
-	rt2x00pci_register_write(rt2x00dev, MCU_INT_SOURCE_CSR, reg_mcu);
+	rt2x00mmio_register_read(rt2x00dev, MCU_INT_SOURCE_CSR, &reg_mcu);
+	rt2x00mmio_register_write(rt2x00dev, MCU_INT_SOURCE_CSR, reg_mcu);
 
-	rt2x00pci_register_read(rt2x00dev, INT_SOURCE_CSR, &reg);
-	rt2x00pci_register_write(rt2x00dev, INT_SOURCE_CSR, reg);
+	rt2x00mmio_register_read(rt2x00dev, INT_SOURCE_CSR, &reg);
+	rt2x00mmio_register_write(rt2x00dev, INT_SOURCE_CSR, reg);
 
 	if (!reg && !reg_mcu)
 		return IRQ_NONE;
@@ -2371,13 +2374,13 @@ static irqreturn_t rt61pci_interrupt(int irq, void *dev_instance)
 	 */
 	spin_lock(&rt2x00dev->irqmask_lock);
 
-	rt2x00pci_register_read(rt2x00dev, INT_MASK_CSR, &reg);
+	rt2x00mmio_register_read(rt2x00dev, INT_MASK_CSR, &reg);
 	reg |= mask;
-	rt2x00pci_register_write(rt2x00dev, INT_MASK_CSR, reg);
+	rt2x00mmio_register_write(rt2x00dev, INT_MASK_CSR, reg);
 
-	rt2x00pci_register_read(rt2x00dev, MCU_INT_MASK_CSR, &reg);
+	rt2x00mmio_register_read(rt2x00dev, MCU_INT_MASK_CSR, &reg);
 	reg |= mask_mcu;
-	rt2x00pci_register_write(rt2x00dev, MCU_INT_MASK_CSR, reg);
+	rt2x00mmio_register_write(rt2x00dev, MCU_INT_MASK_CSR, reg);
 
 	spin_unlock(&rt2x00dev->irqmask_lock);
 
@@ -2395,7 +2398,7 @@ static int rt61pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 	u8 *mac;
 	s8 value;
 
-	rt2x00pci_register_read(rt2x00dev, E2PROM_CSR, &reg);
+	rt2x00mmio_register_read(rt2x00dev, E2PROM_CSR, &reg);
 
 	eeprom.data = rt2x00dev;
 	eeprom.register_read = rt61pci_eepromregister_read;
@@ -2513,7 +2516,7 @@ static int rt61pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	 * Identify RF chipset.
 	 */
 	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RF_TYPE);
-	rt2x00pci_register_read(rt2x00dev, MAC_CSR0, &reg);
+	rt2x00mmio_register_read(rt2x00dev, MAC_CSR0, &reg);
 	rt2x00_set_chip(rt2x00dev, rt2x00_get_field32(reg, MAC_CSR0_CHIPSET),
 			value, rt2x00_get_field32(reg, MAC_CSR0_REVISION));
 
@@ -2838,7 +2841,7 @@ static int rt61pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Disable power saving.
 	 */
-	rt2x00pci_register_write(rt2x00dev, SOFT_RESET_CSR, 0x00000007);
+	rt2x00mmio_register_write(rt2x00dev, SOFT_RESET_CSR, 0x00000007);
 
 	/*
 	 * Allocate eeprom data.
@@ -2855,9 +2858,9 @@ static int rt61pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 	 * Enable rfkill polling by setting GPIO direction of the
 	 * rfkill switch GPIO pin correctly.
 	 */
-	rt2x00pci_register_read(rt2x00dev, MAC_CSR13, &reg);
+	rt2x00mmio_register_read(rt2x00dev, MAC_CSR13, &reg);
 	rt2x00_set_field32(&reg, MAC_CSR13_DIR5, 1);
-	rt2x00pci_register_write(rt2x00dev, MAC_CSR13, reg);
+	rt2x00mmio_register_write(rt2x00dev, MAC_CSR13, reg);
 
 	/*
 	 * Initialize hw specifications.
@@ -2927,25 +2930,25 @@ static int rt61pci_conf_tx(struct ieee80211_hw *hw,
 	field.bit_offset = (queue_idx & 1) * 16;
 	field.bit_mask = 0xffff << field.bit_offset;
 
-	rt2x00pci_register_read(rt2x00dev, offset, &reg);
+	rt2x00mmio_register_read(rt2x00dev, offset, &reg);
 	rt2x00_set_field32(&reg, field, queue->txop);
-	rt2x00pci_register_write(rt2x00dev, offset, reg);
+	rt2x00mmio_register_write(rt2x00dev, offset, reg);
 
 	/* Update WMM registers */
 	field.bit_offset = queue_idx * 4;
 	field.bit_mask = 0xf << field.bit_offset;
 
-	rt2x00pci_register_read(rt2x00dev, AIFSN_CSR, &reg);
+	rt2x00mmio_register_read(rt2x00dev, AIFSN_CSR, &reg);
 	rt2x00_set_field32(&reg, field, queue->aifs);
-	rt2x00pci_register_write(rt2x00dev, AIFSN_CSR, reg);
+	rt2x00mmio_register_write(rt2x00dev, AIFSN_CSR, reg);
 
-	rt2x00pci_register_read(rt2x00dev, CWMIN_CSR, &reg);
+	rt2x00mmio_register_read(rt2x00dev, CWMIN_CSR, &reg);
 	rt2x00_set_field32(&reg, field, queue->cw_min);
-	rt2x00pci_register_write(rt2x00dev, CWMIN_CSR, reg);
+	rt2x00mmio_register_write(rt2x00dev, CWMIN_CSR, reg);
 
-	rt2x00pci_register_read(rt2x00dev, CWMAX_CSR, &reg);
+	rt2x00mmio_register_read(rt2x00dev, CWMAX_CSR, &reg);
 	rt2x00_set_field32(&reg, field, queue->cw_max);
-	rt2x00pci_register_write(rt2x00dev, CWMAX_CSR, reg);
+	rt2x00mmio_register_write(rt2x00dev, CWMAX_CSR, reg);
 
 	return 0;
 }
@@ -2956,9 +2959,9 @@ static u64 rt61pci_get_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	u64 tsf;
 	u32 reg;
 
-	rt2x00pci_register_read(rt2x00dev, TXRX_CSR13, &reg);
+	rt2x00mmio_register_read(rt2x00dev, TXRX_CSR13, &reg);
 	tsf = (u64) rt2x00_get_field32(reg, TXRX_CSR13_HIGH_TSFTIMER) << 32;
-	rt2x00pci_register_read(rt2x00dev, TXRX_CSR12, &reg);
+	rt2x00mmio_register_read(rt2x00dev, TXRX_CSR12, &reg);
 	tsf |= rt2x00_get_field32(reg, TXRX_CSR12_LOW_TSFTIMER);
 
 	return tsf;
@@ -2997,8 +3000,8 @@ static const struct rt2x00lib_ops rt61pci_rt2x00_ops = {
 	.get_firmware_name	= rt61pci_get_firmware_name,
 	.check_firmware		= rt61pci_check_firmware,
 	.load_firmware		= rt61pci_load_firmware,
-	.initialize		= rt2x00pci_initialize,
-	.uninitialize		= rt2x00pci_uninitialize,
+	.initialize		= rt2x00mmio_initialize,
+	.uninitialize		= rt2x00mmio_uninitialize,
 	.get_entry_state	= rt61pci_get_entry_state,
 	.clear_entry		= rt61pci_clear_entry,
 	.set_device_state	= rt61pci_set_device_state,
@@ -3009,7 +3012,7 @@ static const struct rt2x00lib_ops rt61pci_rt2x00_ops = {
 	.start_queue		= rt61pci_start_queue,
 	.kick_queue		= rt61pci_kick_queue,
 	.stop_queue		= rt61pci_stop_queue,
-	.flush_queue		= rt2x00pci_flush_queue,
+	.flush_queue		= rt2x00mmio_flush_queue,
 	.write_tx_desc		= rt61pci_write_tx_desc,
 	.write_beacon		= rt61pci_write_beacon,
 	.clear_beacon		= rt61pci_clear_beacon,
@@ -3027,21 +3030,21 @@ static const struct data_queue_desc rt61pci_queue_rx = {
 	.entry_num		= 32,
 	.data_size		= DATA_FRAME_SIZE,
 	.desc_size		= RXD_DESC_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_pci),
+	.priv_size		= sizeof(struct queue_entry_priv_mmio),
 };
 
 static const struct data_queue_desc rt61pci_queue_tx = {
 	.entry_num		= 32,
 	.data_size		= DATA_FRAME_SIZE,
 	.desc_size		= TXD_DESC_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_pci),
+	.priv_size		= sizeof(struct queue_entry_priv_mmio),
 };
 
 static const struct data_queue_desc rt61pci_queue_bcn = {
 	.entry_num		= 4,
 	.data_size		= 0, /* No DMA required for beacons */
 	.desc_size		= TXINFO_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_pci),
+	.priv_size		= sizeof(struct queue_entry_priv_mmio),
 };
 
 static const struct rt2x00_ops rt61pci_ops = {
-- 
1.7.10

