Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:33538 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161631Ab3DEG0o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 02:26:44 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	users@rt2x00.serialmonkey.com, Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 2/6] rt2x00: rt2400pci: use the rt2x00mmio_* routines
Date: Fri,  5 Apr 2013 08:27:01 +0200
Message-Id: <1365143225-24532-3-git-send-email-juhosg@openwrt.org> (sfid-20130405_082653_138556_1064F5E2)
In-Reply-To: <1365143225-24532-1-git-send-email-juhosg@openwrt.org>
References: <1365143225-24532-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the recently introduced rt2x00mmio_* routines
instead of the rt2x00pci_* variants.

The patch contains no functional changes.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |  309 ++++++++++++++++---------------
 1 file changed, 155 insertions(+), 154 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index dcfb54e..d1b10d4 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
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
 
 static void rt2400pci_bbp_write(struct rt2x00_dev *rt2x00dev,
 				const unsigned int word, const u8 value)
@@ -74,7 +74,7 @@ static void rt2400pci_bbp_write(struct rt2x00_dev *rt2x00dev,
 		rt2x00_set_field32(&reg, BBPCSR_BUSY, 1);
 		rt2x00_set_field32(&reg, BBPCSR_WRITE_CONTROL, 1);
 
-		rt2x00pci_register_write(rt2x00dev, BBPCSR, reg);
+		rt2x00mmio_register_write(rt2x00dev, BBPCSR, reg);
 	}
 
 	mutex_unlock(&rt2x00dev->csr_mutex);
@@ -101,7 +101,7 @@ static void rt2400pci_bbp_read(struct rt2x00_dev *rt2x00dev,
 		rt2x00_set_field32(&reg, BBPCSR_BUSY, 1);
 		rt2x00_set_field32(&reg, BBPCSR_WRITE_CONTROL, 0);
 
-		rt2x00pci_register_write(rt2x00dev, BBPCSR, reg);
+		rt2x00mmio_register_write(rt2x00dev, BBPCSR, reg);
 
 		WAIT_FOR_BBP(rt2x00dev, &reg);
 	}
@@ -129,7 +129,7 @@ static void rt2400pci_rf_write(struct rt2x00_dev *rt2x00dev,
 		rt2x00_set_field32(&reg, RFCSR_IF_SELECT, 0);
 		rt2x00_set_field32(&reg, RFCSR_BUSY, 1);
 
-		rt2x00pci_register_write(rt2x00dev, RFCSR, reg);
+		rt2x00mmio_register_write(rt2x00dev, RFCSR, reg);
 		rt2x00_rf_write(rt2x00dev, word, value);
 	}
 
@@ -141,7 +141,7 @@ static void rt2400pci_eepromregister_read(struct eeprom_93cx6 *eeprom)
 	struct rt2x00_dev *rt2x00dev = eeprom->data;
 	u32 reg;
 
-	rt2x00pci_register_read(rt2x00dev, CSR21, &reg);
+	rt2x00mmio_register_read(rt2x00dev, CSR21, &reg);
 
 	eeprom->reg_data_in = !!rt2x00_get_field32(reg, CSR21_EEPROM_DATA_IN);
 	eeprom->reg_data_out = !!rt2x00_get_field32(reg, CSR21_EEPROM_DATA_OUT);
@@ -163,15 +163,15 @@ static void rt2400pci_eepromregister_write(struct eeprom_93cx6 *eeprom)
 	rt2x00_set_field32(&reg, CSR21_EEPROM_CHIP_SELECT,
 			   !!eeprom->reg_chip_select);
 
-	rt2x00pci_register_write(rt2x00dev, CSR21, reg);
+	rt2x00mmio_register_write(rt2x00dev, CSR21, reg);
 }
 
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
 static const struct rt2x00debug rt2400pci_rt2x00debug = {
 	.owner	= THIS_MODULE,
 	.csr	= {
-		.read		= rt2x00pci_register_read,
-		.write		= rt2x00pci_register_write,
+		.read		= rt2x00mmio_register_read,
+		.write		= rt2x00mmio_register_write,
 		.flags		= RT2X00DEBUGFS_OFFSET,
 		.word_base	= CSR_REG_BASE,
 		.word_size	= sizeof(u32),
@@ -205,7 +205,7 @@ static int rt2400pci_rfkill_poll(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
 
-	rt2x00pci_register_read(rt2x00dev, GPIOCSR, &reg);
+	rt2x00mmio_register_read(rt2x00dev, GPIOCSR, &reg);
 	return rt2x00_get_field32(reg, GPIOCSR_VAL0);
 }
 
@@ -218,14 +218,14 @@ static void rt2400pci_brightness_set(struct led_classdev *led_cdev,
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
 
 static int rt2400pci_blink_set(struct led_classdev *led_cdev,
@@ -236,10 +236,10 @@ static int rt2400pci_blink_set(struct led_classdev *led_cdev,
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
@@ -269,7 +269,7 @@ static void rt2400pci_config_filter(struct rt2x00_dev *rt2x00dev,
 	 * Note that the version error will always be dropped
 	 * since there is no filter for it at this time.
 	 */
-	rt2x00pci_register_read(rt2x00dev, RXCSR0, &reg);
+	rt2x00mmio_register_read(rt2x00dev, RXCSR0, &reg);
 	rt2x00_set_field32(&reg, RXCSR0_DROP_CRC,
 			   !(filter_flags & FIF_FCSFAIL));
 	rt2x00_set_field32(&reg, RXCSR0_DROP_PHYSICAL,
@@ -282,7 +282,7 @@ static void rt2400pci_config_filter(struct rt2x00_dev *rt2x00dev,
 			   !(filter_flags & FIF_PROMISC_IN_BSS) &&
 			   !rt2x00dev->intf_ap_count);
 	rt2x00_set_field32(&reg, RXCSR0_DROP_VERSION_ERROR, 1);
-	rt2x00pci_register_write(rt2x00dev, RXCSR0, reg);
+	rt2x00mmio_register_write(rt2x00dev, RXCSR0, reg);
 }
 
 static void rt2400pci_config_intf(struct rt2x00_dev *rt2x00dev,
@@ -298,25 +298,26 @@ static void rt2400pci_config_intf(struct rt2x00_dev *rt2x00dev,
 		 * Enable beacon config
 		 */
 		bcn_preload = PREAMBLE + GET_DURATION(IEEE80211_HEADER, 20);
-		rt2x00pci_register_read(rt2x00dev, BCNCSR1, &reg);
+		rt2x00mmio_register_read(rt2x00dev, BCNCSR1, &reg);
 		rt2x00_set_field32(&reg, BCNCSR1_PRELOAD, bcn_preload);
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
-					      conf->mac, sizeof(conf->mac));
+		rt2x00mmio_register_multiwrite(rt2x00dev, CSR3,
+					       conf->mac, sizeof(conf->mac));
 
 	if (flags & CONFIG_UPDATE_BSSID)
-		rt2x00pci_register_multiwrite(rt2x00dev, CSR5,
-					      conf->bssid, sizeof(conf->bssid));
+		rt2x00mmio_register_multiwrite(rt2x00dev, CSR5,
+					       conf->bssid,
+					       sizeof(conf->bssid));
 }
 
 static void rt2400pci_config_erp(struct rt2x00_dev *rt2x00dev,
@@ -332,68 +333,68 @@ static void rt2400pci_config_erp(struct rt2x00_dev *rt2x00dev,
 	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
 		preamble_mask = erp->short_preamble << 3;
 
-		rt2x00pci_register_read(rt2x00dev, TXCSR1, &reg);
+		rt2x00mmio_register_read(rt2x00dev, TXCSR1, &reg);
 		rt2x00_set_field32(&reg, TXCSR1_ACK_TIMEOUT, 0x1ff);
 		rt2x00_set_field32(&reg, TXCSR1_ACK_CONSUME_TIME, 0x13a);
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
 
@@ -497,7 +498,7 @@ static void rt2400pci_config_channel(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Clear false CRC during channel switch.
 	 */
-	rt2x00pci_register_read(rt2x00dev, CNT0, &rf->rf1);
+	rt2x00mmio_register_read(rt2x00dev, CNT0, &rf->rf1);
 }
 
 static void rt2400pci_config_txpower(struct rt2x00_dev *rt2x00dev, int txpower)
@@ -510,12 +511,12 @@ static void rt2400pci_config_retry_limit(struct rt2x00_dev *rt2x00dev,
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
 
 static void rt2400pci_config_ps(struct rt2x00_dev *rt2x00dev,
@@ -527,7 +528,7 @@ static void rt2400pci_config_ps(struct rt2x00_dev *rt2x00dev,
 	u32 reg;
 
 	if (state == STATE_SLEEP) {
-		rt2x00pci_register_read(rt2x00dev, CSR20, &reg);
+		rt2x00mmio_register_read(rt2x00dev, CSR20, &reg);
 		rt2x00_set_field32(&reg, CSR20_DELAY_AFTER_TBCN,
 				   (rt2x00dev->beacon_int - 20) * 16);
 		rt2x00_set_field32(&reg, CSR20_TBCN_BEFORE_WAKEUP,
@@ -535,14 +536,14 @@ static void rt2400pci_config_ps(struct rt2x00_dev *rt2x00dev,
 
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
@@ -568,10 +569,10 @@ static void rt2400pci_config_cw(struct rt2x00_dev *rt2x00dev,
 {
 	u32 reg;
 
-	rt2x00pci_register_read(rt2x00dev, CSR11, &reg);
+	rt2x00mmio_register_read(rt2x00dev, CSR11, &reg);
 	rt2x00_set_field32(&reg, CSR11_CWMIN, cw_min);
 	rt2x00_set_field32(&reg, CSR11_CWMAX, cw_max);
-	rt2x00pci_register_write(rt2x00dev, CSR11, reg);
+	rt2x00mmio_register_write(rt2x00dev, CSR11, reg);
 }
 
 /*
@@ -586,7 +587,7 @@ static void rt2400pci_link_stats(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Update FCS error count from register.
 	 */
-	rt2x00pci_register_read(rt2x00dev, CNT0, &reg);
+	rt2x00mmio_register_read(rt2x00dev, CNT0, &reg);
 	qual->rx_failed = rt2x00_get_field32(reg, CNT0_FCS_ERROR);
 
 	/*
@@ -641,16 +642,16 @@ static void rt2400pci_start_queue(struct data_queue *queue)
 
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
@@ -664,19 +665,19 @@ static void rt2400pci_kick_queue(struct data_queue *queue)
 
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
@@ -692,21 +693,21 @@ static void rt2400pci_stop_queue(struct data_queue *queue)
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
@@ -723,7 +724,7 @@ static void rt2400pci_stop_queue(struct data_queue *queue)
  */
 static bool rt2400pci_get_entry_state(struct queue_entry *entry)
 {
-	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
+	struct queue_entry_priv_mmio *entry_priv = entry->priv_data;
 	u32 word;
 
 	if (entry->queue->qid == QID_RX) {
@@ -740,7 +741,7 @@ static bool rt2400pci_get_entry_state(struct queue_entry *entry)
 
 static void rt2400pci_clear_entry(struct queue_entry *entry)
 {
-	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
+	struct queue_entry_priv_mmio *entry_priv = entry->priv_data;
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
 	u32 word;
 
@@ -766,53 +767,53 @@ static void rt2400pci_clear_entry(struct queue_entry *entry)
 
 static int rt2400pci_init_queues(struct rt2x00_dev *rt2x00dev)
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
@@ -821,23 +822,23 @@ static int rt2400pci_init_registers(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
 
-	rt2x00pci_register_write(rt2x00dev, PSCSR0, 0x00020002);
-	rt2x00pci_register_write(rt2x00dev, PSCSR1, 0x00000002);
-	rt2x00pci_register_write(rt2x00dev, PSCSR2, 0x00023f20);
-	rt2x00pci_register_write(rt2x00dev, PSCSR3, 0x00000002);
+	rt2x00mmio_register_write(rt2x00dev, PSCSR0, 0x00020002);
+	rt2x00mmio_register_write(rt2x00dev, PSCSR1, 0x00000002);
+	rt2x00mmio_register_write(rt2x00dev, PSCSR2, 0x00023f20);
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
 			   (rt2x00dev->rx->data_size / 128));
-	rt2x00pci_register_write(rt2x00dev, CSR9, reg);
+	rt2x00mmio_register_write(rt2x00dev, CSR9, reg);
 
-	rt2x00pci_register_read(rt2x00dev, CSR14, &reg);
+	rt2x00mmio_register_read(rt2x00dev, CSR14, &reg);
 	rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 0);
 	rt2x00_set_field32(&reg, CSR14_TSF_SYNC, 0);
 	rt2x00_set_field32(&reg, CSR14_TBCN, 0);
@@ -846,63 +847,63 @@ static int rt2400pci_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 0);
 	rt2x00_set_field32(&reg, CSR14_CFP_COUNT_PRELOAD, 0);
 	rt2x00_set_field32(&reg, CSR14_TBCM_PRELOAD, 0);
-	rt2x00pci_register_write(rt2x00dev, CSR14, reg);
+	rt2x00mmio_register_write(rt2x00dev, CSR14, reg);
 
-	rt2x00pci_register_write(rt2x00dev, CNT3, 0x3f080000);
+	rt2x00mmio_register_write(rt2x00dev, CNT3, 0x3f080000);
 
-	rt2x00pci_register_read(rt2x00dev, ARCSR0, &reg);
+	rt2x00mmio_register_read(rt2x00dev, ARCSR0, &reg);
 	rt2x00_set_field32(&reg, ARCSR0_AR_BBP_DATA0, 133);
 	rt2x00_set_field32(&reg, ARCSR0_AR_BBP_ID0, 134);
 	rt2x00_set_field32(&reg, ARCSR0_AR_BBP_DATA1, 136);
 	rt2x00_set_field32(&reg, ARCSR0_AR_BBP_ID1, 135);
-	rt2x00pci_register_write(rt2x00dev, ARCSR0, reg);
+	rt2x00mmio_register_write(rt2x00dev, ARCSR0, reg);
 
-	rt2x00pci_register_read(rt2x00dev, RXCSR3, &reg);
+	rt2x00mmio_register_read(rt2x00dev, RXCSR3, &reg);
 	rt2x00_set_field32(&reg, RXCSR3_BBP_ID0, 3); /* Tx power.*/
 	rt2x00_set_field32(&reg, RXCSR3_BBP_ID0_VALID, 1);
 	rt2x00_set_field32(&reg, RXCSR3_BBP_ID1, 32); /* Signal */
 	rt2x00_set_field32(&reg, RXCSR3_BBP_ID1_VALID, 1);
 	rt2x00_set_field32(&reg, RXCSR3_BBP_ID2, 36); /* Rssi */
 	rt2x00_set_field32(&reg, RXCSR3_BBP_ID2_VALID, 1);
-	rt2x00pci_register_write(rt2x00dev, RXCSR3, reg);
+	rt2x00mmio_register_write(rt2x00dev, RXCSR3, reg);
 
-	rt2x00pci_register_write(rt2x00dev, PWRCSR0, 0x3f3b3100);
+	rt2x00mmio_register_write(rt2x00dev, PWRCSR0, 0x3f3b3100);
 
 	if (rt2x00dev->ops->lib->set_device_state(rt2x00dev, STATE_AWAKE))
 		return -EBUSY;
 
-	rt2x00pci_register_write(rt2x00dev, MACCSR0, 0x00217223);
-	rt2x00pci_register_write(rt2x00dev, MACCSR1, 0x00235518);
+	rt2x00mmio_register_write(rt2x00dev, MACCSR0, 0x00217223);
+	rt2x00mmio_register_write(rt2x00dev, MACCSR1, 0x00235518);
 
-	rt2x00pci_register_read(rt2x00dev, MACCSR2, &reg);
+	rt2x00mmio_register_read(rt2x00dev, MACCSR2, &reg);
 	rt2x00_set_field32(&reg, MACCSR2_DELAY, 64);
-	rt2x00pci_register_write(rt2x00dev, MACCSR2, reg);
+	rt2x00mmio_register_write(rt2x00dev, MACCSR2, reg);
 
-	rt2x00pci_register_read(rt2x00dev, RALINKCSR, &reg);
+	rt2x00mmio_register_read(rt2x00dev, RALINKCSR, &reg);
 	rt2x00_set_field32(&reg, RALINKCSR_AR_BBP_DATA0, 17);
 	rt2x00_set_field32(&reg, RALINKCSR_AR_BBP_ID0, 154);
 	rt2x00_set_field32(&reg, RALINKCSR_AR_BBP_DATA1, 0);
 	rt2x00_set_field32(&reg, RALINKCSR_AR_BBP_ID1, 154);
-	rt2x00pci_register_write(rt2x00dev, RALINKCSR, reg);
+	rt2x00mmio_register_write(rt2x00dev, RALINKCSR, reg);
 
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
@@ -976,8 +977,8 @@ static void rt2400pci_toggle_irq(struct rt2x00_dev *rt2x00dev,
 	 * should clear the register to assure a clean state.
 	 */
 	if (state == STATE_RADIO_IRQ_ON) {
-		rt2x00pci_register_read(rt2x00dev, CSR7, &reg);
-		rt2x00pci_register_write(rt2x00dev, CSR7, reg);
+		rt2x00mmio_register_read(rt2x00dev, CSR7, &reg);
+		rt2x00mmio_register_write(rt2x00dev, CSR7, reg);
 	}
 
 	/*
@@ -986,13 +987,13 @@ static void rt2400pci_toggle_irq(struct rt2x00_dev *rt2x00dev,
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
 
@@ -1025,7 +1026,7 @@ static void rt2400pci_disable_radio(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Disable power
 	 */
-	rt2x00pci_register_write(rt2x00dev, PWRCSR0, 0);
+	rt2x00mmio_register_write(rt2x00dev, PWRCSR0, 0);
 }
 
 static int rt2400pci_set_state(struct rt2x00_dev *rt2x00dev,
@@ -1039,12 +1040,12 @@ static int rt2400pci_set_state(struct rt2x00_dev *rt2x00dev,
 
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
@@ -1052,12 +1053,12 @@ static int rt2400pci_set_state(struct rt2x00_dev *rt2x00dev,
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
 
@@ -1105,7 +1106,7 @@ static void rt2400pci_write_tx_desc(struct queue_entry *entry,
 				    struct txentry_desc *txdesc)
 {
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
-	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
+	struct queue_entry_priv_mmio *entry_priv = entry->priv_data;
 	__le32 *txd = entry_priv->desc;
 	u32 word;
 
@@ -1182,9 +1183,9 @@ static void rt2400pci_write_beacon(struct queue_entry *entry,
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
@@ -1208,7 +1209,7 @@ out:
 	 * Enable beaconing again.
 	 */
 	rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 1);
-	rt2x00pci_register_write(rt2x00dev, CSR14, reg);
+	rt2x00mmio_register_write(rt2x00dev, CSR14, reg);
 }
 
 /*
@@ -1218,7 +1219,7 @@ static void rt2400pci_fill_rxdone(struct queue_entry *entry,
 				  struct rxdone_entry_desc *rxdesc)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
-	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
+	struct queue_entry_priv_mmio *entry_priv = entry->priv_data;
 	u32 word0;
 	u32 word2;
 	u32 word3;
@@ -1276,7 +1277,7 @@ static void rt2400pci_txdone(struct rt2x00_dev *rt2x00dev,
 			     const enum data_queue_qid queue_idx)
 {
 	struct data_queue *queue = rt2x00queue_get_tx_queue(rt2x00dev, queue_idx);
-	struct queue_entry_priv_pci *entry_priv;
+	struct queue_entry_priv_mmio *entry_priv;
 	struct queue_entry *entry;
 	struct txdone_entry_desc txdesc;
 	u32 word;
@@ -1322,9 +1323,9 @@ static inline void rt2400pci_enable_interrupt(struct rt2x00_dev *rt2x00dev,
 	 */
 	spin_lock_irq(&rt2x00dev->irqmask_lock);
 
-	rt2x00pci_register_read(rt2x00dev, CSR8, &reg);
+	rt2x00mmio_register_read(rt2x00dev, CSR8, &reg);
 	rt2x00_set_field32(&reg, irq_field, 0);
-	rt2x00pci_register_write(rt2x00dev, CSR8, reg);
+	rt2x00mmio_register_write(rt2x00dev, CSR8, reg);
 
 	spin_unlock_irq(&rt2x00dev->irqmask_lock);
 }
@@ -1347,11 +1348,11 @@ static void rt2400pci_txstatus_tasklet(unsigned long data)
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
@@ -1368,7 +1369,7 @@ static void rt2400pci_tbtt_tasklet(unsigned long data)
 static void rt2400pci_rxdone_tasklet(unsigned long data)
 {
 	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
-	if (rt2x00pci_rxdone(rt2x00dev))
+	if (rt2x00mmio_rxdone(rt2x00dev))
 		tasklet_schedule(&rt2x00dev->rxdone_tasklet);
 	else if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
 		rt2400pci_enable_interrupt(rt2x00dev, CSR8_RXDONE);
@@ -1383,8 +1384,8 @@ static irqreturn_t rt2400pci_interrupt(int irq, void *dev_instance)
 	 * Get the interrupt sources & saved to local variable.
 	 * Write register value back to clear pending interrupts.
 	 */
-	rt2x00pci_register_read(rt2x00dev, CSR7, &reg);
-	rt2x00pci_register_write(rt2x00dev, CSR7, reg);
+	rt2x00mmio_register_read(rt2x00dev, CSR7, &reg);
+	rt2x00mmio_register_write(rt2x00dev, CSR7, reg);
 
 	if (!reg)
 		return IRQ_NONE;
@@ -1421,9 +1422,9 @@ static irqreturn_t rt2400pci_interrupt(int irq, void *dev_instance)
 	 */
 	spin_lock(&rt2x00dev->irqmask_lock);
 
-	rt2x00pci_register_read(rt2x00dev, CSR8, &reg);
+	rt2x00mmio_register_read(rt2x00dev, CSR8, &reg);
 	reg |= mask;
-	rt2x00pci_register_write(rt2x00dev, CSR8, reg);
+	rt2x00mmio_register_write(rt2x00dev, CSR8, reg);
 
 	spin_unlock(&rt2x00dev->irqmask_lock);
 
@@ -1442,7 +1443,7 @@ static int rt2400pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 	u16 word;
 	u8 *mac;
 
-	rt2x00pci_register_read(rt2x00dev, CSR21, &reg);
+	rt2x00mmio_register_read(rt2x00dev, CSR21, &reg);
 
 	eeprom.data = rt2x00dev;
 	eeprom.register_read = rt2400pci_eepromregister_read;
@@ -1490,7 +1491,7 @@ static int rt2400pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	 * Identify RF chipset.
 	 */
 	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RF_TYPE);
-	rt2x00pci_register_read(rt2x00dev, CSR0, &reg);
+	rt2x00mmio_register_read(rt2x00dev, CSR0, &reg);
 	rt2x00_set_chip(rt2x00dev, RT2460, value,
 			rt2x00_get_field32(reg, CSR0_REVISION));
 
@@ -1635,9 +1636,9 @@ static int rt2400pci_probe_hw(struct rt2x00_dev *rt2x00dev)
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
@@ -1697,9 +1698,9 @@ static u64 rt2400pci_get_tsf(struct ieee80211_hw *hw,
 	u64 tsf;
 	u32 reg;
 
-	rt2x00pci_register_read(rt2x00dev, CSR17, &reg);
+	rt2x00mmio_register_read(rt2x00dev, CSR17, &reg);
 	tsf = (u64) rt2x00_get_field32(reg, CSR17_HIGH_TSFTIMER) << 32;
-	rt2x00pci_register_read(rt2x00dev, CSR16, &reg);
+	rt2x00mmio_register_read(rt2x00dev, CSR16, &reg);
 	tsf |= rt2x00_get_field32(reg, CSR16_LOW_TSFTIMER);
 
 	return tsf;
@@ -1710,7 +1711,7 @@ static int rt2400pci_tx_last_beacon(struct ieee80211_hw *hw)
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	u32 reg;
 
-	rt2x00pci_register_read(rt2x00dev, CSR15, &reg);
+	rt2x00mmio_register_read(rt2x00dev, CSR15, &reg);
 	return rt2x00_get_field32(reg, CSR15_BEACON_SENT);
 }
 
@@ -1743,8 +1744,8 @@ static const struct rt2x00lib_ops rt2400pci_rt2x00_ops = {
 	.tbtt_tasklet		= rt2400pci_tbtt_tasklet,
 	.rxdone_tasklet		= rt2400pci_rxdone_tasklet,
 	.probe_hw		= rt2400pci_probe_hw,
-	.initialize		= rt2x00pci_initialize,
-	.uninitialize		= rt2x00pci_uninitialize,
+	.initialize		= rt2x00mmio_initialize,
+	.uninitialize		= rt2x00mmio_uninitialize,
 	.get_entry_state	= rt2400pci_get_entry_state,
 	.clear_entry		= rt2400pci_clear_entry,
 	.set_device_state	= rt2400pci_set_device_state,
@@ -1755,7 +1756,7 @@ static const struct rt2x00lib_ops rt2400pci_rt2x00_ops = {
 	.start_queue		= rt2400pci_start_queue,
 	.kick_queue		= rt2400pci_kick_queue,
 	.stop_queue		= rt2400pci_stop_queue,
-	.flush_queue		= rt2x00pci_flush_queue,
+	.flush_queue		= rt2x00mmio_flush_queue,
 	.write_tx_desc		= rt2400pci_write_tx_desc,
 	.write_beacon		= rt2400pci_write_beacon,
 	.fill_rxdone		= rt2400pci_fill_rxdone,
@@ -1770,28 +1771,28 @@ static const struct data_queue_desc rt2400pci_queue_rx = {
 	.entry_num		= 24,
 	.data_size		= DATA_FRAME_SIZE,
 	.desc_size		= RXD_DESC_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_pci),
+	.priv_size		= sizeof(struct queue_entry_priv_mmio),
 };
 
 static const struct data_queue_desc rt2400pci_queue_tx = {
 	.entry_num		= 24,
 	.data_size		= DATA_FRAME_SIZE,
 	.desc_size		= TXD_DESC_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_pci),
+	.priv_size		= sizeof(struct queue_entry_priv_mmio),
 };
 
 static const struct data_queue_desc rt2400pci_queue_bcn = {
 	.entry_num		= 1,
 	.data_size		= MGMT_FRAME_SIZE,
 	.desc_size		= TXD_DESC_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_pci),
+	.priv_size		= sizeof(struct queue_entry_priv_mmio),
 };
 
 static const struct data_queue_desc rt2400pci_queue_atim = {
 	.entry_num		= 8,
 	.data_size		= DATA_FRAME_SIZE,
 	.desc_size		= TXD_DESC_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_pci),
+	.priv_size		= sizeof(struct queue_entry_priv_mmio),
 };
 
 static const struct rt2x00_ops rt2400pci_ops = {
-- 
1.7.10

