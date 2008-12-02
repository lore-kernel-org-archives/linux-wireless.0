Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:61376 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160AbYLBRXR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 12:23:17 -0500
Received: by nf-out-0910.google.com with SMTP id d3so1637200nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2008 09:23:16 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 4/5] rt2x00: Implement HW encryption (rt2500usb)
Date: Tue, 2 Dec 2008 18:20:42 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200812021819.23756.IvDoorn@gmail.com> <200812021820.05124.IvDoorn@gmail.com> <200812021820.22750.IvDoorn@gmail.com>
In-Reply-To: <200812021820.22750.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200812021820.42808.IvDoorn@gmail.com> (sfid-20081202_182324_911065_A69BD34E)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2500usb supports hardware encryption.
rt2500usb supports up to 4 shared and pairwise keys.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/Kconfig        |    1 +
 drivers/net/wireless/rt2x00/rt2500usb.c    |  132 ++++++++++++++++++++++++++-
 drivers/net/wireless/rt2x00/rt2500usb.h    |    3 +
 drivers/net/wireless/rt2x00/rt2x00.h       |    1 +
 drivers/net/wireless/rt2x00/rt2x00crypto.c |   12 +++
 drivers/net/wireless/rt2x00/rt2x00lib.h    |    6 ++
 drivers/net/wireless/rt2x00/rt2x00mac.c    |    2 -
 drivers/net/wireless/rt2x00/rt2x00queue.c  |    8 ++-
 8 files changed, 156 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index 95511ac..178b313 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -57,6 +57,7 @@ config RT2500USB
 	tristate "Ralink rt2500 (USB) support"
 	depends on USB
 	select RT2X00_LIB_USB
+	select RT2X00_LIB_CRYPTO
 	---help---
 	  This adds support for rt2500 wireless chipset family.
 	  Supported chips: RT2571 & RT2572.
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 10cb46a..5f65b7e 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -36,6 +36,13 @@
 #include "rt2500usb.h"
 
 /*
+ * Allow hardware encryption to be disabled.
+ */
+static int modparam_nohwcrypt = 1;
+module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
+MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
+
+/*
  * Register access.
  * All access to the CSR registers will go through the methods
  * rt2500usb_register_read and rt2500usb_register_write.
@@ -323,6 +330,82 @@ static void rt2500usb_init_led(struct rt2x00_dev *rt2x00dev,
 /*
  * Configuration handlers.
  */
+
+/*
+ * rt2500usb does not differentiate between shared and pairwise
+ * keys, so we should use the same function for both key types.
+ */
+static int rt2500usb_config_key(struct rt2x00_dev *rt2x00dev,
+				struct rt2x00lib_crypto *crypto,
+				struct ieee80211_key_conf *key)
+{
+	int timeout;
+	u32 mask;
+	u16 reg;
+
+	if (crypto->cmd == SET_KEY) {
+		/*
+		 * Pairwise key will always be entry 0, but this
+		 * could collide with a shared key on the same
+		 * position...
+		 */
+		mask = TXRX_CSR0_KEY_ID.bit_mask;
+
+		rt2500usb_register_read(rt2x00dev, TXRX_CSR0, &reg);
+		reg &= mask;
+
+		if (reg && reg == mask)
+			return -ENOSPC;
+
+		reg = rt2x00_get_field16(reg, TXRX_CSR0_KEY_ID);
+
+		key->hw_key_idx += reg ? ffz(reg) : 0;
+
+		/*
+		 * The encryption key doesn't fit within the CSR cache,
+		 * this means we should allocate it seperately and use
+		 * rt2x00usb_vendor_request() to send the key to the hardware.
+		 */
+		reg = KEY_ENTRY(key->hw_key_idx);
+		timeout = REGISTER_TIMEOUT32(sizeof(crypto->key));
+		rt2x00usb_vendor_request_large_buff(rt2x00dev, USB_MULTI_WRITE,
+						    USB_VENDOR_REQUEST_OUT, reg,
+						    crypto->key,
+						    sizeof(crypto->key),
+						    timeout);
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
+		key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
+	}
+
+	/*
+	 * TXRX_CSR0_KEY_ID contains only single-bit fields to indicate
+	 * a particular key is valid.
+	 */
+	rt2500usb_register_read(rt2x00dev, TXRX_CSR0, &reg);
+	rt2x00_set_field16(&reg, TXRX_CSR0_ALGORITHM, crypto->cipher);
+	rt2x00_set_field16(&reg, TXRX_CSR0_IV_OFFSET, IEEE80211_HEADER);
+
+	mask = rt2x00_get_field16(reg, TXRX_CSR0_KEY_ID);
+	if (crypto->cmd == SET_KEY)
+		mask |= 1 << key->hw_key_idx;
+	else if (crypto->cmd == DISABLE_KEY)
+		mask &= ~(1 << key->hw_key_idx);
+	rt2x00_set_field16(&reg, TXRX_CSR0_KEY_ID, mask);
+	rt2500usb_register_write(rt2x00dev, TXRX_CSR0, reg);
+
+	return 0;
+}
+
 static void rt2500usb_config_filter(struct rt2x00_dev *rt2x00dev,
 				    const unsigned int filter_flags)
 {
@@ -844,7 +927,7 @@ static int rt2500usb_init_registers(struct rt2x00_dev *rt2x00dev)
 
 	rt2500usb_register_read(rt2x00dev, TXRX_CSR0, &reg);
 	rt2x00_set_field16(&reg, TXRX_CSR0_IV_OFFSET, IEEE80211_HEADER);
-	rt2x00_set_field16(&reg, TXRX_CSR0_KEY_ID, 0xff);
+	rt2x00_set_field16(&reg, TXRX_CSR0_KEY_ID, 0);
 	rt2500usb_register_write(rt2x00dev, TXRX_CSR0, reg);
 
 	rt2500usb_register_read(rt2x00dev, MAC_CSR18, &reg);
@@ -1066,7 +1149,7 @@ static void rt2500usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	 * Start writing the descriptor words.
 	 */
 	rt2x00_desc_read(txd, 1, &word);
-	rt2x00_set_field32(&word, TXD_W1_IV_OFFSET, IEEE80211_HEADER);
+	rt2x00_set_field32(&word, TXD_W1_IV_OFFSET, txdesc->iv_offset);
 	rt2x00_set_field32(&word, TXD_W1_AIFS, txdesc->aifs);
 	rt2x00_set_field32(&word, TXD_W1_CWMIN, txdesc->cw_min);
 	rt2x00_set_field32(&word, TXD_W1_CWMAX, txdesc->cw_max);
@@ -1079,6 +1162,11 @@ static void rt2500usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W2_PLCP_LENGTH_HIGH, txdesc->length_high);
 	rt2x00_desc_write(txd, 2, word);
 
+	if (test_bit(ENTRY_TXD_ENCRYPT, &txdesc->flags)) {
+		_rt2x00_desc_write(txd, 3, skbdesc->iv[0]);
+		_rt2x00_desc_write(txd, 4, skbdesc->iv[1]);
+	}
+
 	rt2x00_desc_read(txd, 0, &word);
 	rt2x00_set_field32(&word, TXD_W0_RETRY_LIMIT, txdesc->retry_limit);
 	rt2x00_set_field32(&word, TXD_W0_MORE_FRAG,
@@ -1093,7 +1181,8 @@ static void rt2500usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 			   test_bit(ENTRY_TXD_FIRST_FRAGMENT, &txdesc->flags));
 	rt2x00_set_field32(&word, TXD_W0_IFS, txdesc->ifs);
 	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, skb->len);
-	rt2x00_set_field32(&word, TXD_W0_CIPHER, CIPHER_NONE);
+	rt2x00_set_field32(&word, TXD_W0_CIPHER, txdesc->cipher);
+	rt2x00_set_field32(&word, TXD_W0_KEY_ID, txdesc->key_idx);
 	rt2x00_desc_write(txd, 0, word);
 }
 
@@ -1204,6 +1293,7 @@ static void rt2500usb_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 static void rt2500usb_fill_rxdone(struct queue_entry *entry,
 				  struct rxdone_entry_desc *rxdesc)
 {
+	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct queue_entry_priv_usb *entry_priv = entry->priv_data;
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
 	__le32 *rxd =
@@ -1231,6 +1321,31 @@ static void rt2500usb_fill_rxdone(struct queue_entry *entry,
 	if (rt2x00_get_field32(word0, RXD_W0_PHYSICAL_ERROR))
 		rxdesc->flags |= RX_FLAG_FAILED_PLCP_CRC;
 
+	if (test_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags)) {
+		rxdesc->cipher = rt2x00_get_field32(word0, RXD_W0_CIPHER);
+		if (rt2x00_get_field32(word0, RXD_W0_CIPHER_ERROR))
+			rxdesc->cipher_status = RX_CRYPTO_FAIL_KEY;
+	}
+
+	if (rxdesc->cipher != CIPHER_NONE) {
+		_rt2x00_desc_read(rxd, 2, &rxdesc->iv[0]);
+		_rt2x00_desc_read(rxd, 3, &rxdesc->iv[1]);
+		/* ICV is located at the end of frame */
+
+		/*
+		 * Hardware has stripped IV/EIV data from 802.11 frame during
+		 * decryption. It has provided the data seperately but rt2x00lib
+		 * should decide if it should be reinserted.
+		 */
+		rxdesc->flags |= RX_FLAG_IV_STRIPPED;
+		if (rxdesc->cipher != CIPHER_TKIP)
+			rxdesc->flags |= RX_FLAG_MMIC_STRIPPED;
+		if (rxdesc->cipher_status == RX_CRYPTO_SUCCESS)
+			rxdesc->flags |= RX_FLAG_DECRYPTED;
+		else if (rxdesc->cipher_status == RX_CRYPTO_FAIL_MIC)
+			rxdesc->flags |= RX_FLAG_MMIC_ERROR;
+	}
+
 	/*
 	 * Obtain the status about this packet.
 	 * When frame was received with an OFDM bitrate,
@@ -1238,8 +1353,8 @@ static void rt2500usb_fill_rxdone(struct queue_entry *entry,
 	 * a CCK bitrate the signal is the rate in 100kbit/s.
 	 */
 	rxdesc->signal = rt2x00_get_field32(word1, RXD_W1_SIGNAL);
-	rxdesc->rssi = rt2x00_get_field32(word1, RXD_W1_RSSI) -
-	    entry->queue->rt2x00dev->rssi_offset;
+	rxdesc->rssi =
+	    rt2x00_get_field32(word1, RXD_W1_RSSI) - rt2x00dev->rssi_offset;
 	rxdesc->size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
 
 	if (rt2x00_get_field32(word0, RXD_W0_OFDM))
@@ -1729,6 +1844,10 @@ static int rt2500usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 	__set_bit(DRIVER_REQUIRE_ATIM_QUEUE, &rt2x00dev->flags);
 	__set_bit(DRIVER_REQUIRE_BEACON_GUARD, &rt2x00dev->flags);
 	__set_bit(DRIVER_REQUIRE_SCHEDULED, &rt2x00dev->flags);
+	if (!modparam_nohwcrypt) {
+		__set_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags);
+		__set_bit(CONFIG_CRYPTO_COPY_IV, &rt2x00dev->flags);
+	}
 	__set_bit(CONFIG_DISABLE_LINK_TUNING, &rt2x00dev->flags);
 
 	/*
@@ -1748,6 +1867,7 @@ static const struct ieee80211_ops rt2500usb_mac80211_ops = {
 	.config			= rt2x00mac_config,
 	.config_interface	= rt2x00mac_config_interface,
 	.configure_filter	= rt2x00mac_configure_filter,
+	.set_key		= rt2x00mac_set_key,
 	.get_stats		= rt2x00mac_get_stats,
 	.bss_info_changed	= rt2x00mac_bss_info_changed,
 	.conf_tx		= rt2x00mac_conf_tx,
@@ -1769,6 +1889,8 @@ static const struct rt2x00lib_ops rt2500usb_rt2x00_ops = {
 	.get_tx_data_len	= rt2500usb_get_tx_data_len,
 	.kick_tx_queue		= rt2500usb_kick_tx_queue,
 	.fill_rxdone		= rt2500usb_fill_rxdone,
+	.config_shared_key	= rt2500usb_config_key,
+	.config_pairwise_key	= rt2500usb_config_key,
 	.config_filter		= rt2500usb_config_filter,
 	.config_intf		= rt2500usb_config_intf,
 	.config_erp		= rt2500usb_config_erp,
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.h b/drivers/net/wireless/rt2x00/rt2500usb.h
index dbb5d68..4347dfd 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.h
+++ b/drivers/net/wireless/rt2x00/rt2500usb.h
@@ -447,6 +447,9 @@
 #define SEC_CSR30			0x04bc
 #define SEC_CSR31			0x04be
 
+#define KEY_ENTRY(__idx) \
+	( SEC_CSR0 + ((__idx) * 16) )
+
 /*
  * PHY control registers.
  */
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index e7ed56d..03d34bb 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -653,6 +653,7 @@ enum rt2x00_flags {
 	CONFIG_EXTERNAL_LNA_BG,
 	CONFIG_DOUBLE_ANTENNA,
 	CONFIG_DISABLE_LINK_TUNING,
+	CONFIG_CRYPTO_COPY_IV,
 };
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00crypto.c b/drivers/net/wireless/rt2x00/rt2x00crypto.c
index e0fc7c1..c6709b3 100644
--- a/drivers/net/wireless/rt2x00/rt2x00crypto.c
+++ b/drivers/net/wireless/rt2x00/rt2x00crypto.c
@@ -69,6 +69,18 @@ unsigned int rt2x00crypto_tx_overhead(struct ieee80211_tx_info *tx_info)
 	return overhead;
 }
 
+void rt2x00crypto_tx_copy_iv(struct sk_buff *skb, unsigned int iv_len)
+{
+	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
+	unsigned int header_length = ieee80211_get_hdrlen_from_skb(skb);
+
+	if (unlikely(!iv_len))
+		return;
+
+	/* Copy IV/EIV data */
+	memcpy(skbdesc->iv, skb->data + header_length, iv_len);
+}
+
 void rt2x00crypto_tx_remove_iv(struct sk_buff *skb, unsigned int iv_len)
 {
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index 9399733..1e18937 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -219,6 +219,7 @@ static inline void rt2x00debug_update_crypto(struct rt2x00_dev *rt2x00dev,
 #ifdef CONFIG_RT2X00_LIB_CRYPTO
 enum cipher rt2x00crypto_key_to_cipher(struct ieee80211_key_conf *key);
 unsigned int rt2x00crypto_tx_overhead(struct ieee80211_tx_info *tx_info);
+void rt2x00crypto_tx_copy_iv(struct sk_buff *skb, unsigned int iv_len);
 void rt2x00crypto_tx_remove_iv(struct sk_buff *skb, unsigned int iv_len);
 void rt2x00crypto_tx_insert_iv(struct sk_buff *skb);
 void rt2x00crypto_rx_insert_iv(struct sk_buff *skb, unsigned int align,
@@ -235,6 +236,11 @@ static inline unsigned int rt2x00crypto_tx_overhead(struct ieee80211_tx_info *tx
 	return 0;
 }
 
+static inline void rt2x00crypto_tx_copy_iv(struct sk_buff *skb,
+					   unsigned int iv_len)
+{
+}
+
 static inline void rt2x00crypto_tx_remove_iv(struct sk_buff *skb,
 					     unsigned int iv_len)
 {
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 4c03957..fa91ca5 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -79,10 +79,8 @@ static int rt2x00mac_tx_rts_cts(struct rt2x00_dev *rt2x00dev,
 	 * RTS/CTS frame should use the length of the frame plus any
 	 * encryption overhead that will be added by the hardware.
 	 */
-#ifdef CONFIG_RT2X00_LIB_CRYPTO
 	if (!frag_skb->do_not_encrypt)
 		data_length += rt2x00crypto_tx_overhead(tx_info);
-#endif /* CONFIG_RT2X00_LIB_CRYPTO */
 
 	if (tx_info->control.rates[0].flags & IEEE80211_TX_RC_USE_CTS_PROTECT)
 		ieee80211_ctstoself_get(rt2x00dev->hw, tx_info->control.vif,
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 7f908a1..e4a1dbe 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -420,8 +420,12 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb)
 	 * the frame so we can provide it to the driver seperately.
 	 */
 	if (test_bit(ENTRY_TXD_ENCRYPT, &txdesc.flags) &&
-	    !test_bit(ENTRY_TXD_ENCRYPT_IV, &txdesc.flags))
-		rt2x00crypto_tx_remove_iv(skb, iv_len);
+	    !test_bit(ENTRY_TXD_ENCRYPT_IV, &txdesc.flags)) {
+		if (test_bit(CONFIG_CRYPTO_COPY_IV, &queue->rt2x00dev->flags))
+			rt2x00crypto_tx_copy_iv(skb, iv_len);
+		else
+			rt2x00crypto_tx_remove_iv(skb, iv_len);
+	}
 
 	/*
 	 * It could be possible that the queue was corrupted and this
-- 
1.5.6.1

