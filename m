Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:33540 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161658Ab3DEG0o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 02:26:44 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	users@rt2x00.serialmonkey.com, Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 3/6] rt2x00: rt2500pci: use the rt2x00mmio_* routines
Date: Fri,  5 Apr 2013 08:27:02 +0200
Message-Id: <1365143225-24532-4-git-send-email-juhosg@openwrt.org> (sfid-20130405_082700_029137_C3EDEBAB)
In-Reply-To: <1365143225-24532-1-git-send-email-juhosg@openwrt.org>
References: <1365143225-24532-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the recently introduced rt2x00mmio_* routines
instead of the rt2x00pci_* variants.

The patch contains no functional changes.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2500pci.c |  334 +++++++++++++++----------------
 1 file changed, 167 insertions(+), 167 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index e1d2dc9..9ba1457 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -41,7 +41,7 @@
 /*
  * Register access.
  * All access to the CSR registers will go through the methods
- * rt2x00pci_register_read and rt2x00pci_register_write.
+ * rt2x00mmio_register_read and rt2x00mmio_register_write.
  * BBP and RF register require indirect register access,
  * and use the CSR registers BBPCSR and RFCSR to achieve this.
  * These indirect registers work with busy bits,
@@ -52,9 +52,9 @@
  * and we will print an error.
  */
 #define WAIT_FOR_BBP(__dev, __reg) \
-	rt2x00pci_regbusy_read((__dev), BBPCSR, BBPCSR_BUSY, (__reg))
+	rt2x00mmio_regbusy_read((__dev), BBPCSR, BBPCSR_BUSY, (__reg))
 #define WAIT_FOR_RF(__dev, __reg) \
-	rt2x00pci_regbusy_read((__dev), RFCSR, RFCSR_BUSY, (__reg))
+	rt2x00mmio_regbusy_read((__dev), RFCSR, RFCSR_BUSY, (__reg))
 
 static void rt2500pci_bbp_write(struct rt2x00_dev *rt2x00dev,
 				const unsigned int word, const u8 value)
@@ -74,7 +74,7 @@ static void rt2500pci_bbp_write(struct rt2x00_dev *rt2x00dev,
 		rt2x00_set_field32(&reg, BBPCSR_BUSY, 1);
 		rt2x00_set_field32(&reg, BBPCSR_WRITE_CONTROL, 1);
 
-		rt2x00pci_register_write(rt2x00dev, BBPCSR, reg);
+		rt2x00mmio_register_write(rt2x00dev, BBPCSR, reg);
 	}
 
 	mutex_unlock(&rt2x00dev->csr_mutex);
@@ -101,7 +101,7 @@ static void rt2500pci_bbp_read(struct rt2x00_dev *rt2x00dev,
 		rt2x00_set_field32(&reg, BBPCSR_BUSY, 1);
 		rt2x00_set_field32(&reg, BBPCSR_WRITE_CONTROL, 0);
 
-		rt2x00pci_register_write(rt2x00dev, BBPCSR, reg);
+		rt2x00mmio_register_write(rt2x00dev, BBPCSR, reg);
 
 		WAIT_FOR_BBP(rt2x00dev, &reg);
 	}
@@ -129,7 +129,7 @@ static void rt2500pci_rf_write(struct rt2x00_dev *rt2x00dev,
 		rt2x00_set_field32(&reg, RFCSR_IF_SELECT, 0);
 		rt2x00_set_field32(&reg, RFCSR_BUSY, 1);
 
-		rt2x00pci_register_write(rt2x00dev, RFCSR, reg);
+		rt2x00mmio_register_write(rt2x00dev, RFCSR, reg);
 		rt2x00_rf_write(rt2x00dev, word, value);
 	}
 
@@ -141,7 +141,7 @@ static void rt2500pci_eepromregister_read(struct eeprom_93cx6 *eeprom)
 	struct rt2x00_dev *rt2x00dev = eeprom->data;
 	u32 reg;
 
-	rt2x00pci_register_read(rt2x00dev, CSR21, &reg);
+	rt2x00mmio_register_read(rt2x00dev, CSR21, &reg);
 
 	eeprom->reg_data_in = !!rt2x00_get_field32(reg, CSR21_EEPROM_DATA_IN);
 	eeprom->reg_data_out = !!rt2x00_get_field32(reg, CSR21_EEPROM_DATA_OUT);
@@ -163,15 +163,15 @@ static void rt2500pci_eepromregister_write(struct eeprom_93cx6 *eeprom)
 	rt2x00_set_field32(&reg, CSR21_EEPROM_CHIP_SELECT,
 			   !!eeprom->reg_chip_select);
 
-	rt2x00pci_register_write(rt2x00dev, CSR21, reg);
+	rt2x00mmio_register_write(rt2x00dev, CSR21, reg);
 }
 
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
 static const struct rt2x00debug rt2500pci_rt2x00debug = {
 	.owner	= THIS_MODULE,
 	.csr	= {
-		.read		= rt2x00pci_register_read,
-		.write		= rt2x00pci_register_write,
+		.read		= rt2x00mmio_register_read,
+		.write		= rt2x00mmio_register_write,
 		.flags		= RT2X00DEBUGFS_OFFSET,
 		.word_base	= CSR_REG_BASE,
 		.word_size	= sizeof(u32),
@@ -205,7 +205,7 @@ static int rt2500pci_rfkill_poll(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
 
-	rt2x00pci_register_read(rt2x00dev, GPIOCSR, &reg);
+	rt2x00mmio_register_read(rt2x00dev, GPIOCSR, &reg);
 	return rt2x00_get_field32(reg, GPIOCSR_VAL0);
 }
 
@@ -218,14 +218,14 @@ static void rt2500pci_brightness_set(struct led_classdev *led_cdev,
 	unsigned int enabled = brightness != LED_OFF;
 	u32 reg;
 
-	rt2x00pci_register_read(led->rt2x00dev, LEDCSR, &reg);
+	rt2x00mmio_register_read(led->rt2x00dev, LEDCSR, &reg);
 
 	if (led->type == LED_TYPE_RADIO || led->type == LED_TYPE_ASSOC)
 		rt2x00_set_field32(&reg, LEDCSR_LINK, enabled);
 	else if (led->type == LED_TYPE_ACTIVITY)
 		rt2x00_set_field32(&reg, LEDCSR_ACTIVITY, enabled);
 
-	rt2x00pci_register_write(led->rt2x00dev, LEDCSR, reg);
+	rt2x00mmio_register_write(led->rt2x00dev, LEDCSR, reg);
 }
 
 static int rt2500pci_blink_set(struct led_classdev *led_cdev,
@@ -236,10 +236,10 @@ static int rt2500pci_blink_set(struct led_classdev *led_cdev,
 	    container_of(led_cdev, struct rt2x00_led, led_dev);
 	u32 reg;
 
-	rt2x00pci_register_read(led->rt2x00dev, LEDCSR, &reg);
+	rt2x00mmio_register_read(led->rt2x00dev, LEDCSR, &reg);
 	rt2x00_set_field32(&reg, LEDCSR_ON_PERIOD, *delay_on);
 	rt2x00_set_field32(&reg, LEDCSR_OFF_PERIOD, *delay_off);
-	rt2x00pci_register_write(led->rt2x00dev, LEDCSR, reg);
+	rt2x00mmio_register_write(led->rt2x00dev, LEDCSR, reg);
 
 	return 0;
 }
@@ -270,7 +270,7 @@ static void rt2500pci_config_filter(struct rt2x00_dev *rt2x00dev,
 	 * and broadcast frames will always be accepted since
 	 * there is no filter for it at this time.
 	 */
-	rt2x00pci_register_read(rt2x00dev, RXCSR0, &reg);
+	rt2x00mmio_register_read(rt2x00dev, RXCSR0, &reg);
 	rt2x00_set_field32(&reg, RXCSR0_DROP_CRC,
 			   !(filter_flags & FIF_FCSFAIL));
 	rt2x00_set_field32(&reg, RXCSR0_DROP_PHYSICAL,
@@ -286,7 +286,7 @@ static void rt2500pci_config_filter(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&reg, RXCSR0_DROP_MCAST,
 			   !(filter_flags & FIF_ALLMULTI));
 	rt2x00_set_field32(&reg, RXCSR0_DROP_BCAST, 0);
-	rt2x00pci_register_write(rt2x00dev, RXCSR0, reg);
+	rt2x00mmio_register_write(rt2x00dev, RXCSR0, reg);
 }
 
 static void rt2500pci_config_intf(struct rt2x00_dev *rt2x00dev,
@@ -303,25 +303,25 @@ static void rt2500pci_config_intf(struct rt2x00_dev *rt2x00dev,
 		 * Enable beacon config
 		 */
 		bcn_preload = PREAMBLE + GET_DURATION(IEEE80211_HEADER, 20);
-		rt2x00pci_register_read(rt2x00dev, BCNCSR1, &reg);
+		rt2x00mmio_register_read(rt2x00dev, BCNCSR1, &reg);
 		rt2x00_set_field32(&reg, BCNCSR1_PRELOAD, bcn_preload);
 		rt2x00_set_field32(&reg, BCNCSR1_BEACON_CWMIN, queue->cw_min);
-		rt2x00pci_register_write(rt2x00dev, BCNCSR1, reg);
+		rt2x00mmio_register_write(rt2x00dev, BCNCSR1, reg);
 
 		/*
 		 * Enable synchronisation.
 		 */
-		rt2x00pci_register_read(rt2x00dev, CSR14, &reg);
+		rt2x00mmio_register_read(rt2x00dev, CSR14, &reg);
 		rt2x00_set_field32(&reg, CSR14_TSF_SYNC, conf->sync);
-		rt2x00pci_register_write(rt2x00dev, CSR14, reg);
+		rt2x00mmio_register_write(rt2x00dev, CSR14, reg);
 	}
 
 	if (flags & CONFIG_UPDATE_MAC)
-		rt2x00pci_register_multiwrite(rt2x00dev, CSR3,
+		rt2x00mmio_register_multiwrite(rt2x00dev, CSR3,
 					      conf->mac, sizeof(conf->mac));
 
 	if (flags & CONFIG_UPDATE_BSSID)
-		rt2x00pci_register_multiwrite(rt2x00dev, CSR5,
+		rt2x00mmio_register_multiwrite(rt2x00dev, CSR5,
 					      conf->bssid, sizeof(conf->bssid));
 }
 
@@ -338,68 +338,68 @@ static void rt2500pci_config_erp(struct rt2x00_dev *rt2x00dev,
 	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
 		preamble_mask = erp->short_preamble << 3;
 
-		rt2x00pci_register_read(rt2x00dev, TXCSR1, &reg);
+		rt2x00mmio_register_read(rt2x00dev, TXCSR1, &reg);
 		rt2x00_set_field32(&reg, TXCSR1_ACK_TIMEOUT, 0x162);
 		rt2x00_set_field32(&reg, TXCSR1_ACK_CONSUME_TIME, 0xa2);
 		rt2x00_set_field32(&reg, TXCSR1_TSF_OFFSET, IEEE80211_HEADER);
 		rt2x00_set_field32(&reg, TXCSR1_AUTORESPONDER, 1);
-		rt2x00pci_register_write(rt2x00dev, TXCSR1, reg);
+		rt2x00mmio_register_write(rt2x00dev, TXCSR1, reg);
 
-		rt2x00pci_register_read(rt2x00dev, ARCSR2, &reg);
+		rt2x00mmio_register_read(rt2x00dev, ARCSR2, &reg);
 		rt2x00_set_field32(&reg, ARCSR2_SIGNAL, 0x00);
 		rt2x00_set_field32(&reg, ARCSR2_SERVICE, 0x04);
 		rt2x00_set_field32(&reg, ARCSR2_LENGTH,
 				   GET_DURATION(ACK_SIZE, 10));
-		rt2x00pci_register_write(rt2x00dev, ARCSR2, reg);
+		rt2x00mmio_register_write(rt2x00dev, ARCSR2, reg);
 
-		rt2x00pci_register_read(rt2x00dev, ARCSR3, &reg);
+		rt2x00mmio_register_read(rt2x00dev, ARCSR3, &reg);
 		rt2x00_set_field32(&reg, ARCSR3_SIGNAL, 0x01 | preamble_mask);
 		rt2x00_set_field32(&reg, ARCSR3_SERVICE, 0x04);
 		rt2x00_set_field32(&reg, ARCSR2_LENGTH,
 				   GET_DURATION(ACK_SIZE, 20));
-		rt2x00pci_register_write(rt2x00dev, ARCSR3, reg);
+		rt2x00mmio_register_write(rt2x00dev, ARCSR3, reg);
 
-		rt2x00pci_register_read(rt2x00dev, ARCSR4, &reg);
+		rt2x00mmio_register_read(rt2x00dev, ARCSR4, &reg);
 		rt2x00_set_field32(&reg, ARCSR4_SIGNAL, 0x02 | preamble_mask);
 		rt2x00_set_field32(&reg, ARCSR4_SERVICE, 0x04);
 		rt2x00_set_field32(&reg, ARCSR2_LENGTH,
 				   GET_DURATION(ACK_SIZE, 55));
-		rt2x00pci_register_write(rt2x00dev, ARCSR4, reg);
+		rt2x00mmio_register_write(rt2x00dev, ARCSR4, reg);
 
-		rt2x00pci_register_read(rt2x00dev, ARCSR5, &reg);
+		rt2x00mmio_register_read(rt2x00dev, ARCSR5, &reg);
 		rt2x00_set_field32(&reg, ARCSR5_SIGNAL, 0x03 | preamble_mask);
 		rt2x00_set_field32(&reg, ARCSR5_SERVICE, 0x84);
 		rt2x00_set_field32(&reg, ARCSR2_LENGTH,
 				   GET_DURATION(ACK_SIZE, 110));
-		rt2x00pci_register_write(rt2x00dev, ARCSR5, reg);
+		rt2x00mmio_register_write(rt2x00dev, ARCSR5, reg);
 	}
 
 	if (changed & BSS_CHANGED_BASIC_RATES)
-		rt2x00pci_register_write(rt2x00dev, ARCSR1, erp->basic_rates);
+		rt2x00mmio_register_write(rt2x00dev, ARCSR1, erp->basic_rates);
 
 	if (changed & BSS_CHANGED_ERP_SLOT) {
-		rt2x00pci_register_read(rt2x00dev, CSR11, &reg);
+		rt2x00mmio_register_read(rt2x00dev, CSR11, &reg);
 		rt2x00_set_field32(&reg, CSR11_SLOT_TIME, erp->slot_time);
-		rt2x00pci_register_write(rt2x00dev, CSR11, reg);
+		rt2x00mmio_register_write(rt2x00dev, CSR11, reg);
 
-		rt2x00pci_register_read(rt2x00dev, CSR18, &reg);
+		rt2x00mmio_register_read(rt2x00dev, CSR18, &reg);
 		rt2x00_set_field32(&reg, CSR18_SIFS, erp->sifs);
 		rt2x00_set_field32(&reg, CSR18_PIFS, erp->pifs);
-		rt2x00pci_register_write(rt2x00dev, CSR18, reg);
+		rt2x00mmio_register_write(rt2x00dev, CSR18, reg);
 
-		rt2x00pci_register_read(rt2x00dev, CSR19, &reg);
+		rt2x00mmio_register_read(rt2x00dev, CSR19, &reg);
 		rt2x00_set_field32(&reg, CSR19_DIFS, erp->difs);
 		rt2x00_set_field32(&reg, CSR19_EIFS, erp->eifs);
-		rt2x00pci_register_write(rt2x00dev, CSR19, reg);
+		rt2x00mmio_register_write(rt2x00dev, CSR19, reg);
 	}
 
 	if (changed & BSS_CHANGED_BEACON_INT) {
-		rt2x00pci_register_read(rt2x00dev, CSR12, &reg);
+		rt2x00mmio_register_read(rt2x00dev, CSR12, &reg);
 		rt2x00_set_field32(&reg, CSR12_BEACON_INTERVAL,
 				   erp->beacon_int * 16);
 		rt2x00_set_field32(&reg, CSR12_CFP_MAX_DURATION,
 				   erp->beacon_int * 16);
-		rt2x00pci_register_write(rt2x00dev, CSR12, reg);
+		rt2x00mmio_register_write(rt2x00dev, CSR12, reg);
 	}
 
 }
@@ -418,7 +418,7 @@ static void rt2500pci_config_ant(struct rt2x00_dev *rt2x00dev,
 	BUG_ON(ant->rx == ANTENNA_SW_DIVERSITY ||
 	       ant->tx == ANTENNA_SW_DIVERSITY);
 
-	rt2x00pci_register_read(rt2x00dev, BBPCSR1, &reg);
+	rt2x00mmio_register_read(rt2x00dev, BBPCSR1, &reg);
 	rt2500pci_bbp_read(rt2x00dev, 14, &r14);
 	rt2500pci_bbp_read(rt2x00dev, 2, &r2);
 
@@ -470,7 +470,7 @@ static void rt2500pci_config_ant(struct rt2x00_dev *rt2x00dev,
 		rt2x00_set_field32(&reg, BBPCSR1_OFDM_FLIP, 0);
 	}
 
-	rt2x00pci_register_write(rt2x00dev, BBPCSR1, reg);
+	rt2x00mmio_register_write(rt2x00dev, BBPCSR1, reg);
 	rt2500pci_bbp_write(rt2x00dev, 14, r14);
 	rt2500pci_bbp_write(rt2x00dev, 2, r2);
 }
@@ -541,7 +541,7 @@ static void rt2500pci_config_channel(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Clear false CRC during channel switch.
 	 */
-	rt2x00pci_register_read(rt2x00dev, CNT0, &rf->rf1);
+	rt2x00mmio_register_read(rt2x00dev, CNT0, &rf->rf1);
 }
 
 static void rt2500pci_config_txpower(struct rt2x00_dev *rt2x00dev,
@@ -559,12 +559,12 @@ static void rt2500pci_config_retry_limit(struct rt2x00_dev *rt2x00dev,
 {
 	u32 reg;
 
-	rt2x00pci_register_read(rt2x00dev, CSR11, &reg);
+	rt2x00mmio_register_read(rt2x00dev, CSR11, &reg);
 	rt2x00_set_field32(&reg, CSR11_LONG_RETRY,
 			   libconf->conf->long_frame_max_tx_count);
 	rt2x00_set_field32(&reg, CSR11_SHORT_RETRY,
 			   libconf->conf->short_frame_max_tx_count);
-	rt2x00pci_register_write(rt2x00dev, CSR11, reg);
+	rt2x00mmio_register_write(rt2x00dev, CSR11, reg);
 }
 
 static void rt2500pci_config_ps(struct rt2x00_dev *rt2x00dev,
@@ -576,7 +576,7 @@ static void rt2500pci_config_ps(struct rt2x00_dev *rt2x00dev,
 	u32 reg;
 
 	if (state == STATE_SLEEP) {
-		rt2x00pci_register_read(rt2x00dev, CSR20, &reg);
+		rt2x00mmio_register_read(rt2x00dev, CSR20, &reg);
 		rt2x00_set_field32(&reg, CSR20_DELAY_AFTER_TBCN,
 				   (rt2x00dev->beacon_int - 20) * 16);
 		rt2x00_set_field32(&reg, CSR20_TBCN_BEFORE_WAKEUP,
@@ -584,14 +584,14 @@ static void rt2500pci_config_ps(struct rt2x00_dev *rt2x00dev,
 
 		/* We must first disable autowake before it can be enabled */
 		rt2x00_set_field32(&reg, CSR20_AUTOWAKE, 0);
-		rt2x00pci_register_write(rt2x00dev, CSR20, reg);
+		rt2x00mmio_register_write(rt2x00dev, CSR20, reg);
 
 		rt2x00_set_field32(&reg, CSR20_AUTOWAKE, 1);
-		rt2x00pci_register_write(rt2x00dev, CSR20, reg);
+		rt2x00mmio_register_write(rt2x00dev, CSR20, reg);
 	} else {
-		rt2x00pci_register_read(rt2x00dev, CSR20, &reg);
+		rt2x00mmio_register_read(rt2x00dev, CSR20, &reg);
 		rt2x00_set_field32(&reg, CSR20_AUTOWAKE, 0);
-		rt2x00pci_register_write(rt2x00dev, CSR20, reg);
+		rt2x00mmio_register_write(rt2x00dev, CSR20, reg);
 	}
 
 	rt2x00dev->ops->lib->set_device_state(rt2x00dev, state);
@@ -625,13 +625,13 @@ static void rt2500pci_link_stats(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Update FCS error count from register.
 	 */
-	rt2x00pci_register_read(rt2x00dev, CNT0, &reg);
+	rt2x00mmio_register_read(rt2x00dev, CNT0, &reg);
 	qual->rx_failed = rt2x00_get_field32(reg, CNT0_FCS_ERROR);
 
 	/*
 	 * Update False CCA count from register.
 	 */
-	rt2x00pci_register_read(rt2x00dev, CNT3, &reg);
+	rt2x00mmio_register_read(rt2x00dev, CNT3, &reg);
 	qual->false_cca = rt2x00_get_field32(reg, CNT3_FALSE_CCA);
 }
 
@@ -731,16 +731,16 @@ static void rt2500pci_start_queue(struct data_queue *queue)
 
 	switch (queue->qid) {
 	case QID_RX:
-		rt2x00pci_register_read(rt2x00dev, RXCSR0, &reg);
+		rt2x00mmio_register_read(rt2x00dev, RXCSR0, &reg);
 		rt2x00_set_field32(&reg, RXCSR0_DISABLE_RX, 0);
-		rt2x00pci_register_write(rt2x00dev, RXCSR0, reg);
+		rt2x00mmio_register_write(rt2x00dev, RXCSR0, reg);
 		break;
 	case QID_BEACON:
-		rt2x00pci_register_read(rt2x00dev, CSR14, &reg);
+		rt2x00mmio_register_read(rt2x00dev, CSR14, &reg);
 		rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 1);
 		rt2x00_set_field32(&reg, CSR14_TBCN, 1);
 		rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 1);
-		rt2x00pci_register_write(rt2x00dev, CSR14, reg);
+		rt2x00mmio_register_write(rt2x00dev, CSR14, reg);
 		break;
 	default:
 		break;
@@ -754,19 +754,19 @@ static void rt2500pci_kick_queue(struct data_queue *queue)
 
 	switch (queue->qid) {
 	case QID_AC_VO:
-		rt2x00pci_register_read(rt2x00dev, TXCSR0, &reg);
+		rt2x00mmio_register_read(rt2x00dev, TXCSR0, &reg);
 		rt2x00_set_field32(&reg, TXCSR0_KICK_PRIO, 1);
-		rt2x00pci_register_write(rt2x00dev, TXCSR0, reg);
+		rt2x00mmio_register_write(rt2x00dev, TXCSR0, reg);
 		break;
 	case QID_AC_VI:
-		rt2x00pci_register_read(rt2x00dev, TXCSR0, &reg);
+		rt2x00mmio_register_read(rt2x00dev, TXCSR0, &reg);
 		rt2x00_set_field32(&reg, TXCSR0_KICK_TX, 1);
-		rt2x00pci_register_write(rt2x00dev, TXCSR0, reg);
+		rt2x00mmio_register_write(rt2x00dev, TXCSR0, reg);
 		break;
 	case QID_ATIM:
-		rt2x00pci_register_read(rt2x00dev, TXCSR0, &reg);
+		rt2x00mmio_register_read(rt2x00dev, TXCSR0, &reg);
 		rt2x00_set_field32(&reg, TXCSR0_KICK_ATIM, 1);
-		rt2x00pci_register_write(rt2x00dev, TXCSR0, reg);
+		rt2x00mmio_register_write(rt2x00dev, TXCSR0, reg);
 		break;
 	default:
 		break;
@@ -782,21 +782,21 @@ static void rt2500pci_stop_queue(struct data_queue *queue)
 	case QID_AC_VO:
 	case QID_AC_VI:
 	case QID_ATIM:
-		rt2x00pci_register_read(rt2x00dev, TXCSR0, &reg);
+		rt2x00mmio_register_read(rt2x00dev, TXCSR0, &reg);
 		rt2x00_set_field32(&reg, TXCSR0_ABORT, 1);
-		rt2x00pci_register_write(rt2x00dev, TXCSR0, reg);
+		rt2x00mmio_register_write(rt2x00dev, TXCSR0, reg);
 		break;
 	case QID_RX:
-		rt2x00pci_register_read(rt2x00dev, RXCSR0, &reg);
+		rt2x00mmio_register_read(rt2x00dev, RXCSR0, &reg);
 		rt2x00_set_field32(&reg, RXCSR0_DISABLE_RX, 1);
-		rt2x00pci_register_write(rt2x00dev, RXCSR0, reg);
+		rt2x00mmio_register_write(rt2x00dev, RXCSR0, reg);
 		break;
 	case QID_BEACON:
-		rt2x00pci_register_read(rt2x00dev, CSR14, &reg);
+		rt2x00mmio_register_read(rt2x00dev, CSR14, &reg);
 		rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 0);
 		rt2x00_set_field32(&reg, CSR14_TBCN, 0);
 		rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 0);
-		rt2x00pci_register_write(rt2x00dev, CSR14, reg);
+		rt2x00mmio_register_write(rt2x00dev, CSR14, reg);
 
 		/*
 		 * Wait for possibly running tbtt tasklets.
@@ -813,7 +813,7 @@ static void rt2500pci_stop_queue(struct data_queue *queue)
  */
 static bool rt2500pci_get_entry_state(struct queue_entry *entry)
 {
-	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
+	struct queue_entry_priv_mmio *entry_priv = entry->priv_data;
 	u32 word;
 
 	if (entry->queue->qid == QID_RX) {
@@ -830,7 +830,7 @@ static bool rt2500pci_get_entry_state(struct queue_entry *entry)
 
 static void rt2500pci_clear_entry(struct queue_entry *entry)
 {
-	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
+	struct queue_entry_priv_mmio *entry_priv = entry->priv_data;
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
 	u32 word;
 
@@ -852,53 +852,53 @@ static void rt2500pci_clear_entry(struct queue_entry *entry)
 
 static int rt2500pci_init_queues(struct rt2x00_dev *rt2x00dev)
 {
-	struct queue_entry_priv_pci *entry_priv;
+	struct queue_entry_priv_mmio *entry_priv;
 	u32 reg;
 
 	/*
 	 * Initialize registers.
 	 */
-	rt2x00pci_register_read(rt2x00dev, TXCSR2, &reg);
+	rt2x00mmio_register_read(rt2x00dev, TXCSR2, &reg);
 	rt2x00_set_field32(&reg, TXCSR2_TXD_SIZE, rt2x00dev->tx[0].desc_size);
 	rt2x00_set_field32(&reg, TXCSR2_NUM_TXD, rt2x00dev->tx[1].limit);
 	rt2x00_set_field32(&reg, TXCSR2_NUM_ATIM, rt2x00dev->atim->limit);
 	rt2x00_set_field32(&reg, TXCSR2_NUM_PRIO, rt2x00dev->tx[0].limit);
-	rt2x00pci_register_write(rt2x00dev, TXCSR2, reg);
+	rt2x00mmio_register_write(rt2x00dev, TXCSR2, reg);
 
 	entry_priv = rt2x00dev->tx[1].entries[0].priv_data;
-	rt2x00pci_register_read(rt2x00dev, TXCSR3, &reg);
+	rt2x00mmio_register_read(rt2x00dev, TXCSR3, &reg);
 	rt2x00_set_field32(&reg, TXCSR3_TX_RING_REGISTER,
 			   entry_priv->desc_dma);
-	rt2x00pci_register_write(rt2x00dev, TXCSR3, reg);
+	rt2x00mmio_register_write(rt2x00dev, TXCSR3, reg);
 
 	entry_priv = rt2x00dev->tx[0].entries[0].priv_data;
-	rt2x00pci_register_read(rt2x00dev, TXCSR5, &reg);
+	rt2x00mmio_register_read(rt2x00dev, TXCSR5, &reg);
 	rt2x00_set_field32(&reg, TXCSR5_PRIO_RING_REGISTER,
 			   entry_priv->desc_dma);
-	rt2x00pci_register_write(rt2x00dev, TXCSR5, reg);
+	rt2x00mmio_register_write(rt2x00dev, TXCSR5, reg);
 
 	entry_priv = rt2x00dev->atim->entries[0].priv_data;
-	rt2x00pci_register_read(rt2x00dev, TXCSR4, &reg);
+	rt2x00mmio_register_read(rt2x00dev, TXCSR4, &reg);
 	rt2x00_set_field32(&reg, TXCSR4_ATIM_RING_REGISTER,
 			   entry_priv->desc_dma);
-	rt2x00pci_register_write(rt2x00dev, TXCSR4, reg);
+	rt2x00mmio_register_write(rt2x00dev, TXCSR4, reg);
 
 	entry_priv = rt2x00dev->bcn->entries[0].priv_data;
-	rt2x00pci_register_read(rt2x00dev, TXCSR6, &reg);
+	rt2x00mmio_register_read(rt2x00dev, TXCSR6, &reg);
 	rt2x00_set_field32(&reg, TXCSR6_BEACON_RING_REGISTER,
 			   entry_priv->desc_dma);
-	rt2x00pci_register_write(rt2x00dev, TXCSR6, reg);
+	rt2x00mmio_register_write(rt2x00dev, TXCSR6, reg);
 
-	rt2x00pci_register_read(rt2x00dev, RXCSR1, &reg);
+	rt2x00mmio_register_read(rt2x00dev, RXCSR1, &reg);
 	rt2x00_set_field32(&reg, RXCSR1_RXD_SIZE, rt2x00dev->rx->desc_size);
 	rt2x00_set_field32(&reg, RXCSR1_NUM_RXD, rt2x00dev->rx->limit);
-	rt2x00pci_register_write(rt2x00dev, RXCSR1, reg);
+	rt2x00mmio_register_write(rt2x00dev, RXCSR1, reg);
 
 	entry_priv = rt2x00dev->rx->entries[0].priv_data;
-	rt2x00pci_register_read(rt2x00dev, RXCSR2, &reg);
+	rt2x00mmio_register_read(rt2x00dev, RXCSR2, &reg);
 	rt2x00_set_field32(&reg, RXCSR2_RX_RING_REGISTER,
 			   entry_priv->desc_dma);
-	rt2x00pci_register_write(rt2x00dev, RXCSR2, reg);
+	rt2x00mmio_register_write(rt2x00dev, RXCSR2, reg);
 
 	return 0;
 }
@@ -907,30 +907,30 @@ static int rt2500pci_init_registers(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
 
-	rt2x00pci_register_write(rt2x00dev, PSCSR0, 0x00020002);
-	rt2x00pci_register_write(rt2x00dev, PSCSR1, 0x00000002);
-	rt2x00pci_register_write(rt2x00dev, PSCSR2, 0x00020002);
-	rt2x00pci_register_write(rt2x00dev, PSCSR3, 0x00000002);
+	rt2x00mmio_register_write(rt2x00dev, PSCSR0, 0x00020002);
+	rt2x00mmio_register_write(rt2x00dev, PSCSR1, 0x00000002);
+	rt2x00mmio_register_write(rt2x00dev, PSCSR2, 0x00020002);
+	rt2x00mmio_register_write(rt2x00dev, PSCSR3, 0x00000002);
 
-	rt2x00pci_register_read(rt2x00dev, TIMECSR, &reg);
+	rt2x00mmio_register_read(rt2x00dev, TIMECSR, &reg);
 	rt2x00_set_field32(&reg, TIMECSR_US_COUNT, 33);
 	rt2x00_set_field32(&reg, TIMECSR_US_64_COUNT, 63);
 	rt2x00_set_field32(&reg, TIMECSR_BEACON_EXPECT, 0);
-	rt2x00pci_register_write(rt2x00dev, TIMECSR, reg);
+	rt2x00mmio_register_write(rt2x00dev, TIMECSR, reg);
 
-	rt2x00pci_register_read(rt2x00dev, CSR9, &reg);
+	rt2x00mmio_register_read(rt2x00dev, CSR9, &reg);
 	rt2x00_set_field32(&reg, CSR9_MAX_FRAME_UNIT,
 			   rt2x00dev->rx->data_size / 128);
-	rt2x00pci_register_write(rt2x00dev, CSR9, reg);
+	rt2x00mmio_register_write(rt2x00dev, CSR9, reg);
 
 	/*
 	 * Always use CWmin and CWmax set in descriptor.
 	 */
-	rt2x00pci_register_read(rt2x00dev, CSR11, &reg);
+	rt2x00mmio_register_read(rt2x00dev, CSR11, &reg);
 	rt2x00_set_field32(&reg, CSR11_CW_SELECT, 0);
-	rt2x00pci_register_write(rt2x00dev, CSR11, reg);
+	rt2x00mmio_register_write(rt2x00dev, CSR11, reg);
 
-	rt2x00pci_register_read(rt2x00dev, CSR14, &reg);
+	rt2x00mmio_register_read(rt2x00dev, CSR14, &reg);
 	rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 0);
 	rt2x00_set_field32(&reg, CSR14_TSF_SYNC, 0);
 	rt2x00_set_field32(&reg, CSR14_TBCN, 0);
@@ -939,11 +939,11 @@ static int rt2500pci_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 0);
 	rt2x00_set_field32(&reg, CSR14_CFP_COUNT_PRELOAD, 0);
 	rt2x00_set_field32(&reg, CSR14_TBCM_PRELOAD, 0);
-	rt2x00pci_register_write(rt2x00dev, CSR14, reg);
+	rt2x00mmio_register_write(rt2x00dev, CSR14, reg);
 
-	rt2x00pci_register_write(rt2x00dev, CNT3, 0);
+	rt2x00mmio_register_write(rt2x00dev, CNT3, 0);
 
-	rt2x00pci_register_read(rt2x00dev, TXCSR8, &reg);
+	rt2x00mmio_register_read(rt2x00dev, TXCSR8, &reg);
 	rt2x00_set_field32(&reg, TXCSR8_BBP_ID0, 10);
 	rt2x00_set_field32(&reg, TXCSR8_BBP_ID0_VALID, 1);
 	rt2x00_set_field32(&reg, TXCSR8_BBP_ID1, 11);
@@ -952,30 +952,30 @@ static int rt2500pci_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, TXCSR8_BBP_ID2_VALID, 1);
 	rt2x00_set_field32(&reg, TXCSR8_BBP_ID3, 12);
 	rt2x00_set_field32(&reg, TXCSR8_BBP_ID3_VALID, 1);
-	rt2x00pci_register_write(rt2x00dev, TXCSR8, reg);
+	rt2x00mmio_register_write(rt2x00dev, TXCSR8, reg);
 
-	rt2x00pci_register_read(rt2x00dev, ARTCSR0, &reg);
+	rt2x00mmio_register_read(rt2x00dev, ARTCSR0, &reg);
 	rt2x00_set_field32(&reg, ARTCSR0_ACK_CTS_1MBS, 112);
 	rt2x00_set_field32(&reg, ARTCSR0_ACK_CTS_2MBS, 56);
 	rt2x00_set_field32(&reg, ARTCSR0_ACK_CTS_5_5MBS, 20);
 	rt2x00_set_field32(&reg, ARTCSR0_ACK_CTS_11MBS, 10);
-	rt2x00pci_register_write(rt2x00dev, ARTCSR0, reg);
+	rt2x00mmio_register_write(rt2x00dev, ARTCSR0, reg);
 
-	rt2x00pci_register_read(rt2x00dev, ARTCSR1, &reg);
+	rt2x00mmio_register_read(rt2x00dev, ARTCSR1, &reg);
 	rt2x00_set_field32(&reg, ARTCSR1_ACK_CTS_6MBS, 45);
 	rt2x00_set_field32(&reg, ARTCSR1_ACK_CTS_9MBS, 37);
 	rt2x00_set_field32(&reg, ARTCSR1_ACK_CTS_12MBS, 33);
 	rt2x00_set_field32(&reg, ARTCSR1_ACK_CTS_18MBS, 29);
-	rt2x00pci_register_write(rt2x00dev, ARTCSR1, reg);
+	rt2x00mmio_register_write(rt2x00dev, ARTCSR1, reg);
 
-	rt2x00pci_register_read(rt2x00dev, ARTCSR2, &reg);
+	rt2x00mmio_register_read(rt2x00dev, ARTCSR2, &reg);
 	rt2x00_set_field32(&reg, ARTCSR2_ACK_CTS_24MBS, 29);
 	rt2x00_set_field32(&reg, ARTCSR2_ACK_CTS_36MBS, 25);
 	rt2x00_set_field32(&reg, ARTCSR2_ACK_CTS_48MBS, 25);
 	rt2x00_set_field32(&reg, ARTCSR2_ACK_CTS_54MBS, 25);
-	rt2x00pci_register_write(rt2x00dev, ARTCSR2, reg);
+	rt2x00mmio_register_write(rt2x00dev, ARTCSR2, reg);
 
-	rt2x00pci_register_read(rt2x00dev, RXCSR3, &reg);
+	rt2x00mmio_register_read(rt2x00dev, RXCSR3, &reg);
 	rt2x00_set_field32(&reg, RXCSR3_BBP_ID0, 47); /* CCK Signal */
 	rt2x00_set_field32(&reg, RXCSR3_BBP_ID0_VALID, 1);
 	rt2x00_set_field32(&reg, RXCSR3_BBP_ID1, 51); /* Rssi */
@@ -984,9 +984,9 @@ static int rt2500pci_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, RXCSR3_BBP_ID2_VALID, 1);
 	rt2x00_set_field32(&reg, RXCSR3_BBP_ID3, 51); /* RSSI */
 	rt2x00_set_field32(&reg, RXCSR3_BBP_ID3_VALID, 1);
-	rt2x00pci_register_write(rt2x00dev, RXCSR3, reg);
+	rt2x00mmio_register_write(rt2x00dev, RXCSR3, reg);
 
-	rt2x00pci_register_read(rt2x00dev, PCICSR, &reg);
+	rt2x00mmio_register_read(rt2x00dev, PCICSR, &reg);
 	rt2x00_set_field32(&reg, PCICSR_BIG_ENDIAN, 0);
 	rt2x00_set_field32(&reg, PCICSR_RX_TRESHOLD, 0);
 	rt2x00_set_field32(&reg, PCICSR_TX_TRESHOLD, 3);
@@ -994,54 +994,54 @@ static int rt2500pci_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, PCICSR_ENABLE_CLK, 1);
 	rt2x00_set_field32(&reg, PCICSR_READ_MULTIPLE, 1);
 	rt2x00_set_field32(&reg, PCICSR_WRITE_INVALID, 1);
-	rt2x00pci_register_write(rt2x00dev, PCICSR, reg);
+	rt2x00mmio_register_write(rt2x00dev, PCICSR, reg);
 
-	rt2x00pci_register_write(rt2x00dev, PWRCSR0, 0x3f3b3100);
+	rt2x00mmio_register_write(rt2x00dev, PWRCSR0, 0x3f3b3100);
 
-	rt2x00pci_register_write(rt2x00dev, GPIOCSR, 0x0000ff00);
-	rt2x00pci_register_write(rt2x00dev, TESTCSR, 0x000000f0);
+	rt2x00mmio_register_write(rt2x00dev, GPIOCSR, 0x0000ff00);
+	rt2x00mmio_register_write(rt2x00dev, TESTCSR, 0x000000f0);
 
 	if (rt2x00dev->ops->lib->set_device_state(rt2x00dev, STATE_AWAKE))
 		return -EBUSY;
 
-	rt2x00pci_register_write(rt2x00dev, MACCSR0, 0x00213223);
-	rt2x00pci_register_write(rt2x00dev, MACCSR1, 0x00235518);
+	rt2x00mmio_register_write(rt2x00dev, MACCSR0, 0x00213223);
+	rt2x00mmio_register_write(rt2x00dev, MACCSR1, 0x00235518);
 
-	rt2x00pci_register_read(rt2x00dev, MACCSR2, &reg);
+	rt2x00mmio_register_read(rt2x00dev, MACCSR2, &reg);
 	rt2x00_set_field32(&reg, MACCSR2_DELAY, 64);
-	rt2x00pci_register_write(rt2x00dev, MACCSR2, reg);
+	rt2x00mmio_register_write(rt2x00dev, MACCSR2, reg);
 
-	rt2x00pci_register_read(rt2x00dev, RALINKCSR, &reg);
+	rt2x00mmio_register_read(rt2x00dev, RALINKCSR, &reg);
 	rt2x00_set_field32(&reg, RALINKCSR_AR_BBP_DATA0, 17);
 	rt2x00_set_field32(&reg, RALINKCSR_AR_BBP_ID0, 26);
 	rt2x00_set_field32(&reg, RALINKCSR_AR_BBP_VALID0, 1);
 	rt2x00_set_field32(&reg, RALINKCSR_AR_BBP_DATA1, 0);
 	rt2x00_set_field32(&reg, RALINKCSR_AR_BBP_ID1, 26);
 	rt2x00_set_field32(&reg, RALINKCSR_AR_BBP_VALID1, 1);
-	rt2x00pci_register_write(rt2x00dev, RALINKCSR, reg);
+	rt2x00mmio_register_write(rt2x00dev, RALINKCSR, reg);
 
-	rt2x00pci_register_write(rt2x00dev, BBPCSR1, 0x82188200);
+	rt2x00mmio_register_write(rt2x00dev, BBPCSR1, 0x82188200);
 
-	rt2x00pci_register_write(rt2x00dev, TXACKCSR0, 0x00000020);
+	rt2x00mmio_register_write(rt2x00dev, TXACKCSR0, 0x00000020);
 
-	rt2x00pci_register_read(rt2x00dev, CSR1, &reg);
+	rt2x00mmio_register_read(rt2x00dev, CSR1, &reg);
 	rt2x00_set_field32(&reg, CSR1_SOFT_RESET, 1);
 	rt2x00_set_field32(&reg, CSR1_BBP_RESET, 0);
 	rt2x00_set_field32(&reg, CSR1_HOST_READY, 0);
-	rt2x00pci_register_write(rt2x00dev, CSR1, reg);
+	rt2x00mmio_register_write(rt2x00dev, CSR1, reg);
 
-	rt2x00pci_register_read(rt2x00dev, CSR1, &reg);
+	rt2x00mmio_register_read(rt2x00dev, CSR1, &reg);
 	rt2x00_set_field32(&reg, CSR1_SOFT_RESET, 0);
 	rt2x00_set_field32(&reg, CSR1_HOST_READY, 1);
-	rt2x00pci_register_write(rt2x00dev, CSR1, reg);
+	rt2x00mmio_register_write(rt2x00dev, CSR1, reg);
 
 	/*
 	 * We must clear the FCS and FIFO error count.
 	 * These registers are cleared on read,
 	 * so we may pass a useless variable to store the value.
 	 */
-	rt2x00pci_register_read(rt2x00dev, CNT0, &reg);
-	rt2x00pci_register_read(rt2x00dev, CNT4, &reg);
+	rt2x00mmio_register_read(rt2x00dev, CNT0, &reg);
+	rt2x00mmio_register_read(rt2x00dev, CNT4, &reg);
 
 	return 0;
 }
@@ -1131,8 +1131,8 @@ static void rt2500pci_toggle_irq(struct rt2x00_dev *rt2x00dev,
 	 * should clear the register to assure a clean state.
 	 */
 	if (state == STATE_RADIO_IRQ_ON) {
-		rt2x00pci_register_read(rt2x00dev, CSR7, &reg);
-		rt2x00pci_register_write(rt2x00dev, CSR7, reg);
+		rt2x00mmio_register_read(rt2x00dev, CSR7, &reg);
+		rt2x00mmio_register_write(rt2x00dev, CSR7, reg);
 	}
 
 	/*
@@ -1141,13 +1141,13 @@ static void rt2500pci_toggle_irq(struct rt2x00_dev *rt2x00dev,
 	 */
 	spin_lock_irqsave(&rt2x00dev->irqmask_lock, flags);
 
-	rt2x00pci_register_read(rt2x00dev, CSR8, &reg);
+	rt2x00mmio_register_read(rt2x00dev, CSR8, &reg);
 	rt2x00_set_field32(&reg, CSR8_TBCN_EXPIRE, mask);
 	rt2x00_set_field32(&reg, CSR8_TXDONE_TXRING, mask);
 	rt2x00_set_field32(&reg, CSR8_TXDONE_ATIMRING, mask);
 	rt2x00_set_field32(&reg, CSR8_TXDONE_PRIORING, mask);
 	rt2x00_set_field32(&reg, CSR8_RXDONE, mask);
-	rt2x00pci_register_write(rt2x00dev, CSR8, reg);
+	rt2x00mmio_register_write(rt2x00dev, CSR8, reg);
 
 	spin_unlock_irqrestore(&rt2x00dev->irqmask_lock, flags);
 
@@ -1179,7 +1179,7 @@ static void rt2500pci_disable_radio(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Disable power
 	 */
-	rt2x00pci_register_write(rt2x00dev, PWRCSR0, 0);
+	rt2x00mmio_register_write(rt2x00dev, PWRCSR0, 0);
 }
 
 static int rt2500pci_set_state(struct rt2x00_dev *rt2x00dev,
@@ -1193,12 +1193,12 @@ static int rt2500pci_set_state(struct rt2x00_dev *rt2x00dev,
 
 	put_to_sleep = (state != STATE_AWAKE);
 
-	rt2x00pci_register_read(rt2x00dev, PWRCSR1, &reg);
+	rt2x00mmio_register_read(rt2x00dev, PWRCSR1, &reg);
 	rt2x00_set_field32(&reg, PWRCSR1_SET_STATE, 1);
 	rt2x00_set_field32(&reg, PWRCSR1_BBP_DESIRE_STATE, state);
 	rt2x00_set_field32(&reg, PWRCSR1_RF_DESIRE_STATE, state);
 	rt2x00_set_field32(&reg, PWRCSR1_PUT_TO_SLEEP, put_to_sleep);
-	rt2x00pci_register_write(rt2x00dev, PWRCSR1, reg);
+	rt2x00mmio_register_write(rt2x00dev, PWRCSR1, reg);
 
 	/*
 	 * Device is not guaranteed to be in the requested state yet.
@@ -1206,12 +1206,12 @@ static int rt2500pci_set_state(struct rt2x00_dev *rt2x00dev,
 	 * device has entered the correct state.
 	 */
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
-		rt2x00pci_register_read(rt2x00dev, PWRCSR1, &reg2);
+		rt2x00mmio_register_read(rt2x00dev, PWRCSR1, &reg2);
 		bbp_state = rt2x00_get_field32(reg2, PWRCSR1_BBP_CURR_STATE);
 		rf_state = rt2x00_get_field32(reg2, PWRCSR1_RF_CURR_STATE);
 		if (bbp_state == state && rf_state == state)
 			return 0;
-		rt2x00pci_register_write(rt2x00dev, PWRCSR1, reg);
+		rt2x00mmio_register_write(rt2x00dev, PWRCSR1, reg);
 		msleep(10);
 	}
 
@@ -1259,7 +1259,7 @@ static void rt2500pci_write_tx_desc(struct queue_entry *entry,
 				    struct txentry_desc *txdesc)
 {
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
-	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
+	struct queue_entry_priv_mmio *entry_priv = entry->priv_data;
 	__le32 *txd = entry_priv->desc;
 	u32 word;
 
@@ -1335,9 +1335,9 @@ static void rt2500pci_write_beacon(struct queue_entry *entry,
 	 * Disable beaconing while we are reloading the beacon data,
 	 * otherwise we might be sending out invalid data.
 	 */
-	rt2x00pci_register_read(rt2x00dev, CSR14, &reg);
+	rt2x00mmio_register_read(rt2x00dev, CSR14, &reg);
 	rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 0);
-	rt2x00pci_register_write(rt2x00dev, CSR14, reg);
+	rt2x00mmio_register_write(rt2x00dev, CSR14, reg);
 
 	if (rt2x00queue_map_txskb(entry)) {
 		ERROR(rt2x00dev, "Fail to map beacon, aborting\n");
@@ -1358,7 +1358,7 @@ out:
 	 * Enable beaconing again.
 	 */
 	rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 1);
-	rt2x00pci_register_write(rt2x00dev, CSR14, reg);
+	rt2x00mmio_register_write(rt2x00dev, CSR14, reg);
 }
 
 /*
@@ -1367,7 +1367,7 @@ out:
 static void rt2500pci_fill_rxdone(struct queue_entry *entry,
 				  struct rxdone_entry_desc *rxdesc)
 {
-	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
+	struct queue_entry_priv_mmio *entry_priv = entry->priv_data;
 	u32 word0;
 	u32 word2;
 
@@ -1405,7 +1405,7 @@ static void rt2500pci_txdone(struct rt2x00_dev *rt2x00dev,
 			     const enum data_queue_qid queue_idx)
 {
 	struct data_queue *queue = rt2x00queue_get_tx_queue(rt2x00dev, queue_idx);
-	struct queue_entry_priv_pci *entry_priv;
+	struct queue_entry_priv_mmio *entry_priv;
 	struct queue_entry *entry;
 	struct txdone_entry_desc txdesc;
 	u32 word;
@@ -1451,9 +1451,9 @@ static inline void rt2500pci_enable_interrupt(struct rt2x00_dev *rt2x00dev,
 	 */
 	spin_lock_irq(&rt2x00dev->irqmask_lock);
 
-	rt2x00pci_register_read(rt2x00dev, CSR8, &reg);
+	rt2x00mmio_register_read(rt2x00dev, CSR8, &reg);
 	rt2x00_set_field32(&reg, irq_field, 0);
-	rt2x00pci_register_write(rt2x00dev, CSR8, reg);
+	rt2x00mmio_register_write(rt2x00dev, CSR8, reg);
 
 	spin_unlock_irq(&rt2x00dev->irqmask_lock);
 }
@@ -1476,11 +1476,11 @@ static void rt2500pci_txstatus_tasklet(unsigned long data)
 	if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags)) {
 		spin_lock_irq(&rt2x00dev->irqmask_lock);
 
-		rt2x00pci_register_read(rt2x00dev, CSR8, &reg);
+		rt2x00mmio_register_read(rt2x00dev, CSR8, &reg);
 		rt2x00_set_field32(&reg, CSR8_TXDONE_TXRING, 0);
 		rt2x00_set_field32(&reg, CSR8_TXDONE_ATIMRING, 0);
 		rt2x00_set_field32(&reg, CSR8_TXDONE_PRIORING, 0);
-		rt2x00pci_register_write(rt2x00dev, CSR8, reg);
+		rt2x00mmio_register_write(rt2x00dev, CSR8, reg);
 
 		spin_unlock_irq(&rt2x00dev->irqmask_lock);
 	}
@@ -1497,7 +1497,7 @@ static void rt2500pci_tbtt_tasklet(unsigned long data)
 static void rt2500pci_rxdone_tasklet(unsigned long data)
 {
 	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
-	if (rt2x00pci_rxdone(rt2x00dev))
+	if (rt2x00mmio_rxdone(rt2x00dev))
 		tasklet_schedule(&rt2x00dev->rxdone_tasklet);
 	else if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
 		rt2500pci_enable_interrupt(rt2x00dev, CSR8_RXDONE);
@@ -1512,8 +1512,8 @@ static irqreturn_t rt2500pci_interrupt(int irq, void *dev_instance)
 	 * Get the interrupt sources & saved to local variable.
 	 * Write register value back to clear pending interrupts.
 	 */
-	rt2x00pci_register_read(rt2x00dev, CSR7, &reg);
-	rt2x00pci_register_write(rt2x00dev, CSR7, reg);
+	rt2x00mmio_register_read(rt2x00dev, CSR7, &reg);
+	rt2x00mmio_register_write(rt2x00dev, CSR7, reg);
 
 	if (!reg)
 		return IRQ_NONE;
@@ -1550,9 +1550,9 @@ static irqreturn_t rt2500pci_interrupt(int irq, void *dev_instance)
 	 */
 	spin_lock(&rt2x00dev->irqmask_lock);
 
-	rt2x00pci_register_read(rt2x00dev, CSR8, &reg);
+	rt2x00mmio_register_read(rt2x00dev, CSR8, &reg);
 	reg |= mask;
-	rt2x00pci_register_write(rt2x00dev, CSR8, reg);
+	rt2x00mmio_register_write(rt2x00dev, CSR8, reg);
 
 	spin_unlock(&rt2x00dev->irqmask_lock);
 
@@ -1569,7 +1569,7 @@ static int rt2500pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 	u16 word;
 	u8 *mac;
 
-	rt2x00pci_register_read(rt2x00dev, CSR21, &reg);
+	rt2x00mmio_register_read(rt2x00dev, CSR21, &reg);
 
 	eeprom.data = rt2x00dev;
 	eeprom.register_read = rt2500pci_eepromregister_read;
@@ -1644,7 +1644,7 @@ static int rt2500pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	 * Identify RF chipset.
 	 */
 	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RF_TYPE);
-	rt2x00pci_register_read(rt2x00dev, CSR0, &reg);
+	rt2x00mmio_register_read(rt2x00dev, CSR0, &reg);
 	rt2x00_set_chip(rt2x00dev, RT2560, value,
 			rt2x00_get_field32(reg, CSR0_REVISION));
 
@@ -1950,9 +1950,9 @@ static int rt2500pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 	 * Enable rfkill polling by setting GPIO direction of the
 	 * rfkill switch GPIO pin correctly.
 	 */
-	rt2x00pci_register_read(rt2x00dev, GPIOCSR, &reg);
+	rt2x00mmio_register_read(rt2x00dev, GPIOCSR, &reg);
 	rt2x00_set_field32(&reg, GPIOCSR_DIR0, 1);
-	rt2x00pci_register_write(rt2x00dev, GPIOCSR, reg);
+	rt2x00mmio_register_write(rt2x00dev, GPIOCSR, reg);
 
 	/*
 	 * Initialize hw specifications.
@@ -1986,9 +1986,9 @@ static u64 rt2500pci_get_tsf(struct ieee80211_hw *hw,
 	u64 tsf;
 	u32 reg;
 
-	rt2x00pci_register_read(rt2x00dev, CSR17, &reg);
+	rt2x00mmio_register_read(rt2x00dev, CSR17, &reg);
 	tsf = (u64) rt2x00_get_field32(reg, CSR17_HIGH_TSFTIMER) << 32;
-	rt2x00pci_register_read(rt2x00dev, CSR16, &reg);
+	rt2x00mmio_register_read(rt2x00dev, CSR16, &reg);
 	tsf |= rt2x00_get_field32(reg, CSR16_LOW_TSFTIMER);
 
 	return tsf;
@@ -1999,7 +1999,7 @@ static int rt2500pci_tx_last_beacon(struct ieee80211_hw *hw)
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	u32 reg;
 
-	rt2x00pci_register_read(rt2x00dev, CSR15, &reg);
+	rt2x00mmio_register_read(rt2x00dev, CSR15, &reg);
 	return rt2x00_get_field32(reg, CSR15_BEACON_SENT);
 }
 
@@ -2032,8 +2032,8 @@ static const struct rt2x00lib_ops rt2500pci_rt2x00_ops = {
 	.tbtt_tasklet		= rt2500pci_tbtt_tasklet,
 	.rxdone_tasklet		= rt2500pci_rxdone_tasklet,
 	.probe_hw		= rt2500pci_probe_hw,
-	.initialize		= rt2x00pci_initialize,
-	.uninitialize		= rt2x00pci_uninitialize,
+	.initialize		= rt2x00mmio_initialize,
+	.uninitialize		= rt2x00mmio_uninitialize,
 	.get_entry_state	= rt2500pci_get_entry_state,
 	.clear_entry		= rt2500pci_clear_entry,
 	.set_device_state	= rt2500pci_set_device_state,
@@ -2044,7 +2044,7 @@ static const struct rt2x00lib_ops rt2500pci_rt2x00_ops = {
 	.start_queue		= rt2500pci_start_queue,
 	.kick_queue		= rt2500pci_kick_queue,
 	.stop_queue		= rt2500pci_stop_queue,
-	.flush_queue		= rt2x00pci_flush_queue,
+	.flush_queue		= rt2x00mmio_flush_queue,
 	.write_tx_desc		= rt2500pci_write_tx_desc,
 	.write_beacon		= rt2500pci_write_beacon,
 	.fill_rxdone		= rt2500pci_fill_rxdone,
@@ -2059,28 +2059,28 @@ static const struct data_queue_desc rt2500pci_queue_rx = {
 	.entry_num		= 32,
 	.data_size		= DATA_FRAME_SIZE,
 	.desc_size		= RXD_DESC_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_pci),
+	.priv_size		= sizeof(struct queue_entry_priv_mmio),
 };
 
 static const struct data_queue_desc rt2500pci_queue_tx = {
 	.entry_num		= 32,
 	.data_size		= DATA_FRAME_SIZE,
 	.desc_size		= TXD_DESC_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_pci),
+	.priv_size		= sizeof(struct queue_entry_priv_mmio),
 };
 
 static const struct data_queue_desc rt2500pci_queue_bcn = {
 	.entry_num		= 1,
 	.data_size		= MGMT_FRAME_SIZE,
 	.desc_size		= TXD_DESC_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_pci),
+	.priv_size		= sizeof(struct queue_entry_priv_mmio),
 };
 
 static const struct data_queue_desc rt2500pci_queue_atim = {
 	.entry_num		= 8,
 	.data_size		= DATA_FRAME_SIZE,
 	.desc_size		= TXD_DESC_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_pci),
+	.priv_size		= sizeof(struct queue_entry_priv_mmio),
 };
 
 static const struct rt2x00_ops rt2500pci_ops = {
-- 
1.7.10


