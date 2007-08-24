Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45009 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758237AbXHXMby (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2007 08:31:54 -0400
Message-Id: <20070824122903.038886000@sipsolutions.net>
References: <20070824122705.549190000@sipsolutions.net>
Date: Fri, 24 Aug 2007 14:27:07 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 02/15] mac80211: rework hardware crypto flags
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch reworks the various hardware crypto related
flags to make them more local, i.e. put them with each
key or each packet instead of into the hw struct.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 drivers/net/wireless/adm8211.c                  |    2 
 drivers/net/wireless/b43/main.c                 |    4 -
 drivers/net/wireless/b43/xmit.c                 |   28 -------------
 drivers/net/wireless/iwl-base.c                 |    5 +-
 drivers/net/wireless/p54common.c                |    3 -
 drivers/net/wireless/rtl8187_dev.c              |    3 -
 drivers/net/wireless/zd1211rw-mac80211/zd_mac.c |    1 
 include/net/mac80211.h                          |   49 +++++++-----------------
 net/mac80211/rx.c                               |   24 ++++-------
 net/mac80211/tx.c                               |    5 --
 net/mac80211/wpa.c                              |   43 ++++++---------------
 11 files changed, 49 insertions(+), 118 deletions(-)

--- wireless-dev.orig/include/net/mac80211.h	2007-08-24 14:05:53.549417211 +0200
+++ wireless-dev/include/net/mac80211.h	2007-08-24 14:06:08.249417211 +0200
@@ -243,6 +243,8 @@ struct ieee80211_rx_status {
 #define RX_FLAG_MMIC_ERROR	(1<<0)
 #define RX_FLAG_DECRYPTED	(1<<1)
 #define RX_FLAG_RADIOTAP	(1<<2)
+#define RX_FLAG_MMIC_STRIPPED	(1<<3)
+#define RX_FLAG_IV_STRIPPED	(1<<4)
 	int flag;
 };
 
@@ -405,6 +407,16 @@ typedef enum {
  * that situation it should reject that key.
  */
 #define IEEE80211_KEY_FLAG_WMM_STA	(1<<0)
+/*
+ * This flag should be set by the driver if it requires
+ * IV generation in software for this key.
+ */
+#define IEEE80211_KEY_FLAG_GENERATE_IV	(1<<1)
+/*
+ * This flag should be set by the driver if it requires
+ * MMIC generation in software for this key.
+ */
+#define IEEE80211_KEY_FLAG_GENERATE_MMIC (1<<2)
 
 struct ieee80211_key_conf {
 	/*
@@ -474,17 +486,7 @@ struct ieee80211_hw {
 	 */
 #define IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE (1<<1)
 
-	/*
-	 * Some devices handle decryption internally and do not
-	 * indicate whether the frame was encrypted (unencrypted frames
-	 * will be dropped by the hardware, unless specifically allowed
-	 * through.)
-	 * It is permissible to not handle all encrypted frames and fall
-	 * back to software encryption; however, if this flag is set
-	 * unencrypted frames must be dropped unless the driver is told
-	 * otherwise via the set_ieee8021x() callback.
-	 */
-#define IEEE80211_HW_DEVICE_HIDES_WEP (1<<2)
+/* hole at 2 */
 
 	/* Whether RX frames passed to ieee80211_rx() include FCS in the end */
 #define IEEE80211_HW_RX_INCLUDES_FCS (1<<3)
@@ -497,32 +499,13 @@ struct ieee80211_hw {
 	 * can fetch them with ieee80211_get_buffered_bc(). */
 #define IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING (1<<4)
 
-	/*
-	 * This flag is only relevant if hardware encryption is used.
-	 * If set, it has two meanings:
-	 *  1) the IV and ICV are present in received frames that have
-	 *     been decrypted (unless IEEE80211_HW_DEVICE_HIDES_WEP is
-	 *     also set)
-	 *  2) on transmission, the IV should be generated in software.
-	 *
-	 * Please let us know if you *don't* use this flag, the stack would
-	 * really like to be able to get the IV to keep key statistics
-	 * accurate.
-	 */
-#define IEEE80211_HW_WEP_INCLUDE_IV (1<<5)
+/* hole at 5 */
 
 /* hole at 6 */
 
 /* hole at 7 */
 
-	/*
-	 * Some devices handle Michael MIC internally and do not include MIC in
-	 * the received packets passed up. This flag must be set for such
-	 * devices. The 'encryption' frame control bit is expected to be still
-	 * set in the IEEE 802.11 header with this option unlike with the
-	 * IEEE80211_HW_DEVICE_HIDES_WEP flag.
-	 */
-#define IEEE80211_HW_DEVICE_STRIPS_MIC (1<<8)
+/* hole at 8 */
 
 	/* Device is capable of performing full monitor mode even during
 	 * normal operation. */
@@ -536,8 +519,6 @@ struct ieee80211_hw {
 	 * specified in the device's EEPROM */
 #define IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED (1<<11)
 
-	/* calculate Michael MIC for an MSDU when doing hwcrypto */
-#define IEEE80211_HW_TKIP_INCLUDE_MMIC (1<<12)
 	/* Do TKIP phase1 key mixing in stack to support cards only do
 	 * phase2 key mixing when doing hwcrypto */
 #define IEEE80211_HW_TKIP_REQ_PHASE1_KEY (1<<13)
--- wireless-dev.orig/net/mac80211/wpa.c	2007-08-24 14:05:53.569417211 +0200
+++ wireless-dev/net/mac80211/wpa.c	2007-08-24 14:06:08.259417211 +0200
@@ -103,7 +103,7 @@ ieee80211_tx_h_michael_mic_add(struct ie
 
 	if ((tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) &&
 	    !(tx->flags & IEEE80211_TXRXD_FRAGMENTED) &&
-	    !(tx->local->hw.flags & IEEE80211_HW_TKIP_INCLUDE_MMIC) &&
+	    !(tx->key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC) &&
 	    !wpa_test) {
 		/* hwaccel - with no need for preallocated room for Michael MIC
 		 */
@@ -170,7 +170,7 @@ ieee80211_rx_h_michael_mic_verify(struct
 	/*
 	 * No way to verify the MIC if the hardware stripped it
 	 */
-	if (rx->local->hw.flags & IEEE80211_HW_DEVICE_STRIPS_MIC)
+	if (rx->u.rx.status->flag & RX_FLAG_MMIC_STRIPPED)
 		return TXRX_CONTINUE;
 
 	if (!rx->key || rx->key->conf.alg != ALG_TKIP ||
@@ -183,19 +183,6 @@ ieee80211_rx_h_michael_mic_verify(struct
 	}
 #endif /* CONFIG_HOSTAPD_WPA_TESTING */
 
-	if ((rx->u.rx.status->flag & RX_FLAG_DECRYPTED) &&
-	    (rx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)) {
-		if (rx->local->hw.flags & IEEE80211_HW_WEP_INCLUDE_IV) {
-			if (skb->len < MICHAEL_MIC_LEN)
-				return TXRX_DROP;
-		}
-		/* Need to verify Michael MIC sometimes in software even when
-		 * hwaccel is used. Atheros ar5212: fragmented frames and QoS
-		 * frames. */
-		if (!(rx->flags & IEEE80211_TXRXD_FRAGMENTED) && !wpa_test)
-			goto remove_mic;
-	}
-
 	if (ieee80211_get_hdr_info(skb, &sa, &da, &qos_tid, &data, &data_len)
 	    || data_len < MICHAEL_MIC_LEN)
 		return TXRX_DROP;
@@ -249,7 +236,6 @@ ieee80211_rx_h_michael_mic_verify(struct
 		return TXRX_DROP;
 	}
 
- remove_mic:
 	/* remove Michael MIC from payload */
 	skb_trim(skb, skb->len - MICHAEL_MIC_LEN);
 
@@ -401,7 +387,7 @@ ieee80211_tx_h_tkip_encrypt(struct ieee8
 #endif /* CONFIG_HOSTAPD_WPA_TESTING */
 
 	if ((tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) &&
-	    !(tx->local->hw.flags & IEEE80211_HW_WEP_INCLUDE_IV) &&
+	    !(tx->key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV) &&
 	    !wpa_test) {
 		/* hwaccel - with no need for preallocated room for IV/ICV */
 		tx->u.tx.control->key_idx = tx->key->conf.hw_key_idx;
@@ -478,11 +464,13 @@ ieee80211_rx_h_tkip_decrypt(struct ieee8
 	}
 #endif /* CONFIG_HOSTAPD_WPA_TESTING */
 
-	if ((rx->u.rx.status->flag & RX_FLAG_DECRYPTED) &&
-	    (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)) {
-		if (!(rx->local->hw.flags & IEEE80211_HW_WEP_INCLUDE_IV)) {
-			/* Hardware takes care of all processing, including
-			 * replay protection, so no need to continue here. */
+	if (rx->u.rx.status->flag & RX_FLAG_DECRYPTED) {
+		if (rx->u.rx.status->flag & RX_FLAG_IV_STRIPPED) {
+			/*
+			 * Hardware took care of all processing, including
+			 * replay protection, and stripped the ICV/IV so
+			 * we cannot do any checks here.
+			 */
 			return TXRX_CONTINUE;
 		}
 
@@ -721,7 +709,7 @@ ieee80211_tx_h_ccmp_encrypt(struct ieee8
 	ieee80211_tx_set_iswep(tx);
 
 	if ((tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) &&
-	    !(tx->local->hw.flags & IEEE80211_HW_WEP_INCLUDE_IV)) {
+	    !(tx->key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV)) {
 		/* hwaccel - with no need for preallocated room for CCMP "
 		 * header or MIC fields */
 		tx->u.tx.control->key_idx = tx->key->conf.hw_key_idx;
@@ -772,8 +760,7 @@ ieee80211_rx_h_ccmp_decrypt(struct ieee8
 		return TXRX_DROP;
 
 	if ((rx->u.rx.status->flag & RX_FLAG_DECRYPTED) &&
-	    (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) &&
-	    !(rx->local->hw.flags & IEEE80211_HW_WEP_INCLUDE_IV))
+	    (rx->u.rx.status->flag & RX_FLAG_IV_STRIPPED))
 		return TXRX_CONTINUE;
 
 	(void) ccmp_hdr2pn(pn, skb->data + hdrlen);
@@ -792,10 +779,8 @@ ieee80211_rx_h_ccmp_decrypt(struct ieee8
 		return TXRX_DROP;
 	}
 
-	if ((rx->u.rx.status->flag & RX_FLAG_DECRYPTED) &&
-	    (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)) {
-		/* hwaccel has already decrypted frame and verified MIC */
-	} else {
+	if (!(rx->u.rx.status->flag & RX_FLAG_DECRYPTED)) {
+		/* hardware didn't decrypt/verify MIC */
 		u8 *scratch, *b_0, *aad;
 
 		scratch = key->u.ccmp.rx_crypto_buf;
--- wireless-dev.orig/net/mac80211/rx.c	2007-08-24 14:06:02.669417211 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-08-24 14:06:08.259417211 +0200
@@ -370,7 +370,8 @@ ieee80211_rx_h_load_key(struct ieee80211
 		 * we somehow allow the driver to tell us which key
 		 * the hardware used if this flag is set?
 		 */
-		if (!(rx->local->hw.flags & IEEE80211_HW_WEP_INCLUDE_IV))
+		if ((rx->u.rx.status->flag & RX_FLAG_DECRYPTED) &&
+		    (rx->u.rx.status->flag & RX_FLAG_IV_STRIPPED))
 			return TXRX_CONTINUE;
 
 		hdrlen = ieee80211_get_hdrlen(rx->fc);
@@ -547,8 +548,8 @@ ieee80211_rx_h_wep_weak_iv_detection(str
 		return TXRX_CONTINUE;
 
 	/* Check for weak IVs, if hwaccel did not remove IV from the frame */
-	if ((rx->local->hw.flags & IEEE80211_HW_WEP_INCLUDE_IV) ||
-	    !(rx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE))
+	if (!(rx->u.rx.status->flag & RX_FLAG_IV_STRIPPED) ||
+	    !(rx->u.rx.status->flag & RX_FLAG_DECRYPTED))
 		if (ieee80211_wep_is_weak_iv(rx->skb, rx->key))
 			rx->sta->wep_weak_iv_count++;
 
@@ -572,15 +573,14 @@ ieee80211_rx_h_wep_decrypt(struct ieee80
 		return TXRX_DROP;
 	}
 
-	if (!(rx->u.rx.status->flag & RX_FLAG_DECRYPTED) ||
-	    !(rx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)) {
+	if (!(rx->u.rx.status->flag & RX_FLAG_DECRYPTED)) {
 		if (ieee80211_wep_decrypt(rx->local, rx->skb, rx->key)) {
 			if (net_ratelimit())
 				printk(KERN_DEBUG "%s: RX WEP frame, decrypt "
 				       "failed\n", rx->dev->name);
 			return TXRX_DROP;
 		}
-	} else if (rx->local->hw.flags & IEEE80211_HW_WEP_INCLUDE_IV) {
+	} else if (!(rx->u.rx.status->flag & RX_FLAG_IV_STRIPPED)) {
 		ieee80211_wep_remove_iv(rx->local, rx->skb, rx->key);
 		/* remove ICV */
 		skb_trim(rx->skb, rx->skb->len - 4);
@@ -911,13 +911,10 @@ static ieee80211_txrx_result
 ieee80211_rx_h_drop_unencrypted(struct ieee80211_txrx_data *rx)
 {
 	/*
-	 * Pass through unencrypted frames if the hardware might have
-	 * decrypted them already without telling us, but that can only
-	 * be true if we either didn't find a key or the found key is
-	 * uploaded to the hardware.
+	 * Pass through unencrypted frames if the hardware has
+	 * decrypted them already.
 	 */
-	if ((rx->local->hw.flags & IEEE80211_HW_DEVICE_HIDES_WEP) &&
-	    (!rx->key || (rx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)))
+	if (rx->u.rx.status->flag & RX_FLAG_DECRYPTED)
 		return TXRX_CONTINUE;
 
 	/* Drop unencrypted frames if key is set. */
@@ -1362,8 +1359,7 @@ static void ieee80211_rx_michael_mic_rep
 		goto ignore;
 	}
 
-	if ((rx->local->hw.flags & IEEE80211_HW_WEP_INCLUDE_IV) &&
-	    rx->sdata->type == IEEE80211_IF_TYPE_AP && keyidx) {
+	if (rx->sdata->type == IEEE80211_IF_TYPE_AP && keyidx) {
 		/* AP with Pairwise keys support should never receive Michael
 		 * MIC errors for non-zero keyidx because these are reserved
 		 * for group keys and only the AP is sending real multicast
--- wireless-dev.orig/net/mac80211/tx.c	2007-08-24 14:05:53.669417211 +0200
+++ wireless-dev/net/mac80211/tx.c	2007-08-24 14:06:08.269417211 +0200
@@ -541,9 +541,8 @@ static int wep_encrypt_skb(struct ieee80
 			return -1;
 	} else {
 		tx->u.tx.control->key_idx = tx->key->conf.hw_key_idx;
-		if (tx->local->hw.flags & IEEE80211_HW_WEP_INCLUDE_IV) {
-			if (ieee80211_wep_add_iv(tx->local, skb, tx->key) ==
-			    NULL)
+		if (tx->key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV) {
+			if (!ieee80211_wep_add_iv(tx->local, skb, tx->key))
 				return -1;
 		}
 	}
--- wireless-dev.orig/drivers/net/wireless/iwl-base.c	2007-08-24 14:05:53.689417211 +0200
+++ wireless-dev/drivers/net/wireless/iwl-base.c	2007-08-24 14:06:08.279417211 +0200
@@ -7906,6 +7906,8 @@ static int iwl_mac_set_key(struct ieee80
 		 * conf->sw_decrypt = 0;
 		 */
 		IWL_DEBUG_MAC80211("set_key success, using hwcrypto\n");
+
+		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
 	}
 
 	IWL_DEBUG_MAC80211("leave\n");
@@ -9134,8 +9136,7 @@ static int iwl_pci_probe(struct pci_dev 
 	hw->max_signal = 100;	/* link quality indication (%) */
 
 	/* Tell mac80211 our Tx characteristics */
-	hw->flags = IEEE80211_HW_WEP_INCLUDE_IV |
-	    IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE;
+	hw->flags = IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE;
 
 	hw->queues = 4;
 #if IWL == 4965
--- wireless-dev.orig/drivers/net/wireless/rtl8187_dev.c	2007-08-24 14:05:53.729417211 +0200
+++ wireless-dev/drivers/net/wireless/rtl8187_dev.c	2007-08-24 14:06:08.289417211 +0200
@@ -605,8 +605,7 @@ static int __devinit rtl8187_probe(struc
 	priv->modes[1].channels = priv->channels;
 	priv->mode = IEEE80211_IF_TYPE_MGMT;
 	dev->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
-		     IEEE80211_HW_RX_INCLUDES_FCS |
-		     IEEE80211_HW_WEP_INCLUDE_IV;
+		     IEEE80211_HW_RX_INCLUDES_FCS;
 	dev->extra_tx_headroom = sizeof(struct rtl8187_tx_hdr);
 	dev->queues = 1;
 	dev->max_rssi = 65;
--- wireless-dev.orig/drivers/net/wireless/adm8211.c	2007-08-24 14:05:53.749417211 +0200
+++ wireless-dev/drivers/net/wireless/adm8211.c	2007-08-24 14:06:08.289417211 +0200
@@ -1953,7 +1953,7 @@ static int __devinit adm8211_probe(struc
 	SET_IEEE80211_PERM_ADDR(dev, perm_addr);
 
 	dev->extra_tx_headroom = sizeof(struct adm8211_tx_hdr);
-	dev->flags = IEEE80211_HW_WEP_INCLUDE_IV;
+	dev->flags = 0;
 	// however, IEEE80211_HW_RX_INCLUDES_FCS in promisc mode
 
 	dev->channel_change_time = 1000;
--- wireless-dev.orig/drivers/net/wireless/b43/main.c	2007-08-24 14:05:53.799417211 +0200
+++ wireless-dev/drivers/net/wireless/b43/main.c	2007-08-24 14:06:08.299417211 +0200
@@ -2967,6 +2967,7 @@ static int b43_dev_set_key(struct ieee80
 			b43_hf_write(dev,
 				     b43_hf_read(dev) & ~B43_HF_USEDEFKEYS);
 		}
+		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
 		break;
 	case DISABLE_KEY: {
 		static const u8 zero[B43_SEC_KEYSIZE] = { 0 };
@@ -3913,8 +3914,7 @@ static int b43_wireless_init(struct ssb_
 
 	/* fill hw info */
 	hw->flags = IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE |
-	    IEEE80211_HW_MONITOR_DURING_OPER |
-	    IEEE80211_HW_DEVICE_HIDES_WEP | IEEE80211_HW_WEP_INCLUDE_IV;
+		    IEEE80211_HW_MONITOR_DURING_OPER;
 	hw->max_signal = 100;
 	hw->max_rssi = -110;
 	hw->max_noise = -110;
--- wireless-dev.orig/drivers/net/wireless/b43/xmit.c	2007-08-24 14:05:53.839417211 +0200
+++ wireless-dev/drivers/net/wireless/b43/xmit.c	2007-08-24 14:06:08.299417211 +0200
@@ -486,8 +486,6 @@ void b43_rx(struct b43_wldev *dev, struc
 	if ((macstat & B43_RX_MAC_DEC) && !(macstat & B43_RX_MAC_DECERR)) {
 		unsigned int keyidx;
 		int wlhdr_len;
-		int iv_len;
-		int icv_len;
 
 		keyidx = ((macstat & B43_RX_MAC_KEYIDX)
 			  >> B43_RX_MAC_KEYIDX_SHIFT);
@@ -498,38 +496,12 @@ void b43_rx(struct b43_wldev *dev, struc
 		B43_WARN_ON(keyidx >= dev->max_nr_keys);
 
 		if (dev->key[keyidx].algorithm != B43_SEC_ALGO_NONE) {
-			/* Remove PROTECTED flag to mark it as decrypted. */
-			B43_WARN_ON(!(fctl & IEEE80211_FCTL_PROTECTED));
-			fctl &= ~IEEE80211_FCTL_PROTECTED;
-			wlhdr->frame_control = cpu_to_le16(fctl);
-
 			wlhdr_len = ieee80211_get_hdrlen(fctl);
 			if (unlikely(skb->len < (wlhdr_len + 3))) {
 				b43dbg(dev->wl,
 				       "RX: Packet size underrun (3)\n");
 				goto drop;
 			}
-			if (skb->data[wlhdr_len + 3] & (1 << 5)) {
-				/* The Ext-IV Bit is set in the "KeyID"
-				 * octet of the IV.
-				 */
-				iv_len = 8;
-				icv_len = 8;
-			} else {
-				iv_len = 4;
-				icv_len = 4;
-			}
-			if (unlikely(skb->len < (wlhdr_len + iv_len + icv_len))) {
-				b43dbg(dev->wl,
-				       "RX: Packet size underrun (4)\n");
-				goto drop;
-			}
-			/* Remove the IV */
-			memmove(skb->data + iv_len, skb->data, wlhdr_len);
-			skb_pull(skb, iv_len);
-			/* Remove the ICV */
-			skb_trim(skb, skb->len - icv_len);
-
 			status.flag |= RX_FLAG_DECRYPTED;
 		}
 	}
--- wireless-dev.orig/drivers/net/wireless/p54common.c	2007-08-24 14:05:53.859417211 +0200
+++ wireless-dev/drivers/net/wireless/p54common.c	2007-08-24 14:06:08.309417211 +0200
@@ -892,8 +892,7 @@ struct ieee80211_hw *p54_init_common(siz
 	priv->modes[0].num_channels = ARRAY_SIZE(p54_channels);
 	priv->modes[0].channels = priv->channels;
 	dev->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING | /* not sure */
-		    IEEE80211_HW_RX_INCLUDES_FCS |
-		    IEEE80211_HW_WEP_INCLUDE_IV;
+		    IEEE80211_HW_RX_INCLUDES_FCS;
 	dev->channel_change_time = 1000;	/* TODO: find actual value */
 	dev->max_rssi = 100;
 
--- wireless-dev.orig/drivers/net/wireless/zd1211rw-mac80211/zd_mac.c	2007-08-24 14:05:53.919417211 +0200
+++ wireless-dev/drivers/net/wireless/zd1211rw-mac80211/zd_mac.c	2007-08-24 14:06:08.309417211 +0200
@@ -879,7 +879,6 @@ struct ieee80211_hw *zd_mac_alloc_hw(str
 	mac->modes[1].channels = mac->channels;
 
 	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
-		     IEEE80211_HW_WEP_INCLUDE_IV |
 		     IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED;
 	hw->max_rssi = 100;
 	hw->max_signal = 100;

-- 

