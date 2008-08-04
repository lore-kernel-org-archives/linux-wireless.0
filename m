Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.179]:51941 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016AbYHDOSa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 10:18:30 -0400
Received: by ik-out-1112.google.com with SMTP id c28so2603630ika.5
        for <linux-wireless@vger.kernel.org>; Mon, 04 Aug 2008 07:18:06 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3/5] rt2x00: Implement HW encryption (rt73usb)
Date: Mon, 4 Aug 2008 16:38:24 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200808041636.41189.IvDoorn@gmail.com> <200808041637.45042.IvDoorn@gmail.com> <200808041638.03164.IvDoorn@gmail.com>
In-Reply-To: <200808041638.03164.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200808041638.24289.IvDoorn@gmail.com> (sfid-20080804_161836_026137_29F275D9)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt73usb supports hardware encryption.
rt73usb supports up to 4 shared keys and up to 64 pairwise keys.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/Kconfig   |    1 +
 drivers/net/wireless/rt2x00/rt73usb.c |  271 ++++++++++++++++++++++++++++++++-
 drivers/net/wireless/rt2x00/rt73usb.h |   21 +++-
 3 files changed, 285 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index f333f61..11f590d 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -156,6 +156,7 @@ config RT73USB
 	depends on USB
 	select RT2X00_LIB_USB
 	select RT2X00_LIB_FIRMWARE
+	select RT2X00_LIB_CRYPTO
 	select CRC_ITU_T
 	---help---
 	  This adds support for rt2501 wireless chipset family.
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 9761eaa..ddba747 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -357,6 +357,219 @@ static void rt73usb_init_led(struct rt2x00_dev *rt2x00dev,
 /*
  * Configuration handlers.
  */
+static int rt73usb_config_shared_key(struct rt2x00_dev *rt2x00dev,
+				     struct rt2x00lib_crypto *crypto,
+				     struct ieee80211_key_conf *key)
+{
+	struct hw_key_entry key_entry;
+	struct rt2x00_field32 field;
+	int timeout;
+	u32 mask;
+	u32 reg;
+
+	if (crypto->cmd == SET_KEY) {
+		/*
+		 * rt2x00lib can't determine the correct free
+		 * key_idx for shared keys. We have 1 register
+		 * with key valid bits. The goal is simple, read
+		 * the register, if that is full we have no slots
+		 * left.
+		 * Note that each BSS is allowed to have up to 4
+		 * shared keys, so put a mask over the allowed
+		 * entries.
+		 */
+		mask = (0xf << crypto->bssidx);
+
+		rt73usb_register_read(rt2x00dev, SEC_CSR0, &reg);
+		reg &= mask;
+
+		if (reg && reg == mask)
+			return -ENOSPC;
+
+		key->hw_key_idx += reg ? (ffz(reg) - 1) : 0;
+
+		/*
+		 * Upload key to hardware
+		 */
+		memcpy(key_entry.key, crypto->key,
+		       sizeof(key_entry.key));
+		memcpy(key_entry.tx_mic, crypto->tx_mic,
+		       sizeof(key_entry.tx_mic));
+		memcpy(key_entry.rx_mic, crypto->rx_mic,
+		       sizeof(key_entry.rx_mic));
+
+		reg = SHARED_KEY_ENTRY(key->hw_key_idx);
+		timeout = REGISTER_TIMEOUT32(sizeof(key_entry));
+		rt2x00usb_vendor_request_large_buff(rt2x00dev, USB_MULTI_WRITE,
+						    USB_VENDOR_REQUEST_OUT, reg,
+						    &key_entry,
+						    sizeof(key_entry),
+						    timeout);
+
+		/*
+		 * The cipher types are stored over 2 registers.
+		 * bssidx 0 and 1 keys are stored in SEC_CSR1 and
+		 * bssidx 1 and 2 keys are stored in SEC_CSR5.
+		 * Using the correct defines correctly will cause overhead,
+		 * so just calculate the correct offset.
+		 */
+		if (key->hw_key_idx < 8) {
+			field.bit_offset = (3 * key->hw_key_idx);
+			field.bit_mask = 0x7 << field.bit_offset;
+
+			rt73usb_register_read(rt2x00dev, SEC_CSR1, &reg);
+			rt2x00_set_field32(&reg, field, crypto->cipher);
+			rt73usb_register_write(rt2x00dev, SEC_CSR1, reg);
+		} else {
+			field.bit_offset = (3 * (key->hw_key_idx - 8));
+			field.bit_mask = 0x7 << field.bit_offset;
+
+			rt73usb_register_read(rt2x00dev, SEC_CSR5, &reg);
+			rt2x00_set_field32(&reg, field, crypto->cipher);
+			rt73usb_register_write(rt2x00dev, SEC_CSR5, reg);
+		}
+
+		/*
+		 * The driver does not support the IV/EIV generation
+		 * in hardware. However it doesn't support the IV/EIV
+		 * inside the ieee80211 frame either, but requires it
+		 * to be provided seperately for the descriptor.
+		 * rt2x00lib will cut the IV/EIV data out of all frames
+		 * given to us by mac80211, but we must tell mac80211
+		 * to generate the IV/EIV data.
+		 */
+		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
+	}
+
+	/*
+	 * SEC_CSR0 contains only single-bit fields to indicate
+	 * a particular key is valid. Because using the FIELD32()
+	 * defines directly will cause a lot of overhead we use
+	 * a calculation to determine the correct bit directly.
+	 */
+	mask = 1 << key->hw_key_idx;
+
+	rt73usb_register_read(rt2x00dev, SEC_CSR0, &reg);
+	if (crypto->cmd == SET_KEY)
+		reg |= mask;
+	else if (crypto->cmd == DISABLE_KEY)
+		reg &= ~mask;
+	rt73usb_register_write(rt2x00dev, SEC_CSR0, reg);
+
+	return 0;
+}
+
+static int rt73usb_config_pairwise_key(struct rt2x00_dev *rt2x00dev,
+				       struct rt2x00lib_crypto *crypto,
+				       struct ieee80211_key_conf *key)
+{
+	struct hw_pairwise_ta_entry addr_entry;
+	struct hw_key_entry key_entry;
+	int timeout;
+	u32 mask;
+	u32 reg;
+
+	if (crypto->cmd == SET_KEY) {
+		/*
+		 * rt2x00lib can't determine the correct free
+		 * key_idx for pairwise keys. We have 2 registers
+		 * with key valid bits. The goal is simple, read
+		 * the first register, if that is full move to
+		 * the next register.
+		 * When both registers are full, we drop the key,
+		 * otherwise we use the first invalid entry.
+		 */
+		rt73usb_register_read(rt2x00dev, SEC_CSR2, &reg);
+		if (reg && reg == ~0) {
+			key->hw_key_idx = 32;
+			rt73usb_register_read(rt2x00dev, SEC_CSR3, &reg);
+			if (reg && reg == ~0)
+				return -ENOSPC;
+		}
+
+		key->hw_key_idx += reg ? (ffz(reg) - 1) : 0;
+
+		/*
+		 * Upload key to hardware
+		 */
+		memcpy(key_entry.key, crypto->key,
+		       sizeof(key_entry.key));
+		memcpy(key_entry.tx_mic, crypto->tx_mic,
+		       sizeof(key_entry.tx_mic));
+		memcpy(key_entry.rx_mic, crypto->rx_mic,
+		       sizeof(key_entry.rx_mic));
+
+		reg = PAIRWISE_KEY_ENTRY(key->hw_key_idx);
+		timeout = REGISTER_TIMEOUT32(sizeof(key_entry));
+		rt2x00usb_vendor_request_large_buff(rt2x00dev, USB_MULTI_WRITE,
+						    USB_VENDOR_REQUEST_OUT, reg,
+						    &key_entry,
+						    sizeof(key_entry),
+						    timeout);
+
+		/*
+		 * Send the address and cipher type to the hardware register.
+		 * This data fits within the CSR cache size, so we can use
+		 * rt73usb_register_multiwrite() directly.
+		 */
+		memset(&addr_entry, 0, sizeof(addr_entry));
+		memcpy(&addr_entry, crypto->address, ETH_ALEN);
+		addr_entry.cipher = crypto->cipher;
+
+		reg = PAIRWISE_TA_ENTRY(key->hw_key_idx);
+		rt73usb_register_multiwrite(rt2x00dev, reg,
+					    &addr_entry, sizeof(addr_entry));
+
+		/*
+		 * Enable pairwise lookup table for given BSS idx,
+		 * without this received frames will not be decrypted
+		 * by the hardware.
+		 */
+		rt73usb_register_read(rt2x00dev, SEC_CSR4, &reg);
+		reg |= (1 << crypto->bssidx);
+		rt73usb_register_write(rt2x00dev, SEC_CSR4, reg);
+
+		/*
+		 * The driver does not support the IV/EIV generation
+		 * in hardware. However it doesn't support the IV/EIV
+		 * inside the ieee80211 frame either, but requires it
+		 * to be provided seperately for the descriptor.
+		 * rt2x00lib will cut the IV/EIV data out of all frames
+		 * given to us by mac80211, but we must tell mac80211
+		 * to generate the IV/EIV data.
+		 */
+		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
+	}
+
+	/*
+	 * SEC_CSR2 and SEC_CSR3 contain only single-bit fields to indicate
+	 * a particular key is valid. Because using the FIELD32()
+	 * defines directly will cause a lot of overhead we use
+	 * a calculation to determine the correct bit directly.
+	 */
+	if (key->hw_key_idx < 32) {
+		mask = 1 << key->hw_key_idx;
+
+		rt73usb_register_read(rt2x00dev, SEC_CSR2, &reg);
+		if (crypto->cmd == SET_KEY)
+			reg |= mask;
+		else if (crypto->cmd == DISABLE_KEY)
+			reg &= ~mask;
+		rt73usb_register_write(rt2x00dev, SEC_CSR2, reg);
+	} else {
+		mask = 1 << (key->hw_key_idx - 32);
+
+		rt73usb_register_read(rt2x00dev, SEC_CSR3, &reg);
+		if (crypto->cmd == SET_KEY)
+			reg |= mask;
+		else if (crypto->cmd == DISABLE_KEY)
+			reg &= ~mask;
+		rt73usb_register_write(rt2x00dev, SEC_CSR3, reg);
+	}
+
+	return 0;
+}
+
 static void rt73usb_config_filter(struct rt2x00_dev *rt2x00dev,
 				  const unsigned int filter_flags)
 {
@@ -1265,8 +1478,8 @@ static int rt73usb_set_device_state(struct rt2x00_dev *rt2x00dev,
  * TX descriptor initialization
  */
 static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
-				    struct sk_buff *skb,
-				    struct txentry_desc *txdesc)
+				  struct sk_buff *skb,
+				  struct txentry_desc *txdesc)
 {
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
 	__le32 *txd = skbdesc->desc;
@@ -1280,7 +1493,7 @@ static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W1_AIFSN, txdesc->aifs);
 	rt2x00_set_field32(&word, TXD_W1_CWMIN, txdesc->cw_min);
 	rt2x00_set_field32(&word, TXD_W1_CWMAX, txdesc->cw_max);
-	rt2x00_set_field32(&word, TXD_W1_IV_OFFSET, IEEE80211_HEADER);
+	rt2x00_set_field32(&word, TXD_W1_IV_OFFSET, txdesc->iv_offset);
 	rt2x00_set_field32(&word, TXD_W1_HW_SEQUENCE,
 			   test_bit(ENTRY_TXD_GENERATE_SEQ, &txdesc->flags));
 	rt2x00_desc_write(txd, 1, word);
@@ -1292,6 +1505,11 @@ static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W2_PLCP_LENGTH_HIGH, txdesc->length_high);
 	rt2x00_desc_write(txd, 2, word);
 
+	if (test_bit(ENTRY_TXD_ENCRYPT, &txdesc->flags)) {
+		_rt2x00_desc_write(txd, 3, skbdesc->iv);
+		_rt2x00_desc_write(txd, 4, skbdesc->eiv);
+	}
+
 	rt2x00_desc_read(txd, 5, &word);
 	rt2x00_set_field32(&word, TXD_W5_TX_POWER,
 			   TXPOWER_TO_DEV(rt2x00dev->tx_power));
@@ -1313,12 +1531,16 @@ static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W0_IFS, txdesc->ifs);
 	rt2x00_set_field32(&word, TXD_W0_RETRY_MODE,
 			   test_bit(ENTRY_TXD_RETRY_MODE, &txdesc->flags));
-	rt2x00_set_field32(&word, TXD_W0_TKIP_MIC, 0);
+	rt2x00_set_field32(&word, TXD_W0_TKIP_MIC,
+			   test_bit(ENTRY_TXD_ENCRYPT_MMIC, &txdesc->flags));
+	rt2x00_set_field32(&word, TXD_W0_KEY_TABLE,
+			   test_bit(ENTRY_TXD_ENCRYPT_PAIRWISE, &txdesc->flags));
+	rt2x00_set_field32(&word, TXD_W0_KEY_INDEX, txdesc->key_idx);
 	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT,
 			   skb->len - skbdesc->desc_len);
 	rt2x00_set_field32(&word, TXD_W0_BURST2,
 			   test_bit(ENTRY_TXD_BURST, &txdesc->flags));
-	rt2x00_set_field32(&word, TXD_W0_CIPHER_ALG, CIPHER_NONE);
+	rt2x00_set_field32(&word, TXD_W0_CIPHER_ALG, txdesc->cipher);
 	rt2x00_desc_write(txd, 0, word);
 }
 
@@ -1468,6 +1690,7 @@ static int rt73usb_agc_to_rssi(struct rt2x00_dev *rt2x00dev, int rxd_w1)
 static void rt73usb_fill_rxdone(struct queue_entry *entry,
 			        struct rxdone_entry_desc *rxdesc)
 {
+	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
 	__le32 *rxd = (__le32 *)entry->skb->data;
 	u32 word0;
@@ -1489,6 +1712,38 @@ static void rt73usb_fill_rxdone(struct queue_entry *entry,
 	if (rt2x00_get_field32(word0, RXD_W0_CRC_ERROR))
 		rxdesc->flags |= RX_FLAG_FAILED_FCS_CRC;
 
+	if (test_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags)) {
+		rxdesc->cipher =
+		    rt2x00_get_field32(word0, RXD_W0_CIPHER_ALG);
+		rxdesc->cipher_status =
+		    rt2x00_get_field32(word0, RXD_W0_CIPHER_ERROR);
+	}
+
+	if (rxdesc->cipher != CIPHER_NONE) {
+		_rt2x00_desc_read(rxd, 2, &rxdesc->iv);
+		_rt2x00_desc_read(rxd, 3, &rxdesc->eiv);
+		_rt2x00_desc_read(rxd, 4, &rxdesc->icv);
+
+		/*
+		 * Hardware has stripped IV/EIV data from 802.11 frame during
+		 * decryption. It has provided the data seperately but rt2x00lib
+		 * should decide if it should be reinserted.
+		 */
+		rxdesc->flags |= RX_FLAG_IV_STRIPPED;
+
+		/*
+		 * FIXME: Legacy driver indicates that the frame does
+		 * contain the Michael Mic. Unfortunately, in rt2x00
+		 * the MIC seems to be missing completely...
+		 */
+		rxdesc->flags |= RX_FLAG_MMIC_STRIPPED;
+
+		if (rxdesc->cipher_status == RX_CRYPTO_SUCCESS)
+			rxdesc->flags |= RX_FLAG_DECRYPTED;
+		else if (rxdesc->cipher_status == RX_CRYPTO_FAIL_MIC)
+			rxdesc->flags |= RX_FLAG_MMIC_ERROR;
+	}
+
 	/*
 	 * Obtain the status about this packet.
 	 * When frame was received with an OFDM bitrate,
@@ -1496,7 +1751,7 @@ static void rt73usb_fill_rxdone(struct queue_entry *entry,
 	 * a CCK bitrate the signal is the rate in 100kbit/s.
 	 */
 	rxdesc->signal = rt2x00_get_field32(word1, RXD_W1_SIGNAL);
-	rxdesc->rssi = rt73usb_agc_to_rssi(entry->queue->rt2x00dev, word1);
+	rxdesc->rssi = rt73usb_agc_to_rssi(rt2x00dev, word1);
 	rxdesc->size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
 
 	if (rt2x00_get_field32(word0, RXD_W0_OFDM))
@@ -1938,6 +2193,7 @@ static int rt73usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 	 */
 	__set_bit(DRIVER_REQUIRE_FIRMWARE, &rt2x00dev->flags);
 	__set_bit(DRIVER_REQUIRE_SCHEDULED, &rt2x00dev->flags);
+	__set_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags);
 
 	/*
 	 * Set the rssi offset.
@@ -1997,6 +2253,7 @@ static const struct ieee80211_ops rt73usb_mac80211_ops = {
 	.config			= rt2x00mac_config,
 	.config_interface	= rt2x00mac_config_interface,
 	.configure_filter	= rt2x00mac_configure_filter,
+	.set_key		= rt2x00mac_set_key,
 	.get_stats		= rt2x00mac_get_stats,
 	.set_retry_limit	= rt73usb_set_retry_limit,
 	.bss_info_changed	= rt2x00mac_bss_info_changed,
@@ -2024,6 +2281,8 @@ static const struct rt2x00lib_ops rt73usb_rt2x00_ops = {
 	.get_tx_data_len	= rt73usb_get_tx_data_len,
 	.kick_tx_queue		= rt73usb_kick_tx_queue,
 	.fill_rxdone		= rt73usb_fill_rxdone,
+	.config_shared_key	= rt73usb_config_shared_key,
+	.config_pairwise_key	= rt73usb_config_pairwise_key,
 	.config_filter		= rt73usb_config_filter,
 	.config_intf		= rt73usb_config_intf,
 	.config_erp		= rt73usb_config_erp,
diff --git a/drivers/net/wireless/rt2x00/rt73usb.h b/drivers/net/wireless/rt2x00/rt73usb.h
index 1484935..91e04d3 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.h
+++ b/drivers/net/wireless/rt2x00/rt73usb.h
@@ -92,6 +92,16 @@
 #define PAIRWISE_KEY_TABLE_BASE		0x1200
 #define PAIRWISE_TA_TABLE_BASE		0x1a00
 
+#define SHARED_KEY_ENTRY(__idx) \
+	( SHARED_KEY_TABLE_BASE + \
+		((__idx) * sizeof(struct hw_key_entry)) )
+#define PAIRWISE_KEY_ENTRY(__idx) \
+	( PAIRWISE_KEY_TABLE_BASE + \
+		((__idx) * sizeof(struct hw_key_entry)) )
+#define PAIRWISE_TA_ENTRY(__idx) \
+	( PAIRWISE_TA_TABLE_BASE + \
+		((__idx) * sizeof(struct hw_pairwise_ta_entry)) )
+
 struct hw_key_entry {
 	u8 key[16];
 	u8 tx_mic[8];
@@ -100,7 +110,8 @@ struct hw_key_entry {
 
 struct hw_pairwise_ta_entry {
 	u8 address[6];
-	u8 reserved[2];
+	u8 cipher;
+	u8 reserved;
 } __attribute__ ((packed));
 
 /*
@@ -563,6 +574,10 @@ struct hw_pairwise_ta_entry {
  * SEC_CSR4: Pairwise key table lookup control.
  */
 #define SEC_CSR4			0x30b0
+#define SEC_CSR4_ENABLE_BSS0		FIELD32(0x00000001)
+#define SEC_CSR4_ENABLE_BSS1		FIELD32(0x00000002)
+#define SEC_CSR4_ENABLE_BSS2		FIELD32(0x00000004)
+#define SEC_CSR4_ENABLE_BSS3		FIELD32(0x00000008)
 
 /*
  * SEC_CSR5: shared key table security mode register.
@@ -1010,8 +1025,10 @@ struct hw_pairwise_ta_entry {
 
 /*
  * Word4
+ * ICV: Received ICV of originally encrypted.
+ * NOTE: This is a guess, the official definition is "reserved"
  */
-#define RXD_W4_RESERVED			FIELD32(0xffffffff)
+#define RXD_W4_ICV			FIELD32(0xffffffff)
 
 /*
  * the above 20-byte is called RXINFO and will be DMAed to MAC RX block
-- 
1.5.6.1

