Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:48783 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbYK2Vej (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Nov 2008 16:34:39 -0500
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 3/6 v6] p54: utilize cryptographic accelerator
Date: Sat, 29 Nov 2008 22:34:37 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Stefan Steuerwald <salsasepp@googlemail.com>,
	John W Linville <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200811292234.37794.chunkeey@web.de> (sfid-20081129_223442_873173_E04D7349)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch allows p54 to utilize its WEP, TKIP and CCMP accelerator.

Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
incorporates Larry's Fix... So I don't know if you want to add a signed-off as well?!
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-11-29 21:32:59.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2008-11-29 21:34:07.000000000 +0100
@@ -25,6 +25,9 @@
 #include "p54.h"
 #include "p54common.h"
 
+static int modparam_nohwcrypt;
+module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
+MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
 MODULE_AUTHOR("Michael Wu <flamingice@sourmilk.net>");
 MODULE_DESCRIPTION("Softmac Prism54 common code");
 MODULE_LICENSE("GPL");
@@ -185,6 +188,8 @@ int p54_parse_firmware(struct ieee80211_
 			priv->rx_end = le32_to_cpu(desc->rx_end) - 0x3500;
 			priv->headroom = desc->headroom;
 			priv->tailroom = desc->tailroom;
+			priv->privacy_caps = desc->privacy_caps;
+			priv->rx_keycache_size = desc->rx_keycache_size;
 			if (le32_to_cpu(bootrec->len) == 11)
 				priv->rx_mtu = le16_to_cpu(desc->rx_mtu);
 			else
@@ -228,6 +233,16 @@ int p54_parse_firmware(struct ieee80211_
 		dev->queues = 4;
 	}
 
+	if (!modparam_nohwcrypt)
+		printk(KERN_INFO "%s: cryptographic accelerator "
+				 "WEP:%s, TKIP:%s, CCMP:%s\n",
+			wiphy_name(dev->wiphy),
+			(priv->privacy_caps & BR_DESC_PRIV_CAP_WEP) ? "YES" :
+			"no", (priv->privacy_caps & (BR_DESC_PRIV_CAP_TKIP |
+			 BR_DESC_PRIV_CAP_MICHAEL)) ? "YES" : "no",
+			(priv->privacy_caps & BR_DESC_PRIV_CAP_AESCCMP) ?
+			"YES" : "no");
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(p54_parse_firmware);
@@ -527,6 +542,12 @@ static int p54_rx_data(struct ieee80211_
 			return 0;
 	}
 
+	if (hdr->decrypt_status == P54_DECRYPT_OK)
+		rx_status.flag |= RX_FLAG_DECRYPTED;
+	if ((hdr->decrypt_status == P54_DECRYPT_FAIL_MICHAEL) ||
+	    (hdr->decrypt_status == P54_DECRYPT_FAIL_TKIP))
+		rx_status.flag |= RX_FLAG_MMIC_ERROR;
+
 	rx_status.signal = p54_rssi_to_dbm(dev, hdr->rssi);
 	rx_status.noise = priv->noise;
 	/* XX correct? */
@@ -1108,6 +1129,20 @@ static int p54_tx_fill(struct ieee80211_
 	return ret;
 }
 
+static u8 p54_convert_algo(enum ieee80211_key_alg alg)
+{
+	switch (alg) {
+	case ALG_WEP:
+		return P54_CRYPTO_WEP;
+	case ALG_TKIP:
+		return P54_CRYPTO_TKIPMICHAEL;
+	case ALG_CCMP:
+		return P54_CRYPTO_AESCCMP;
+	default:
+		return 0;
+	}
+}
+
 static int p54_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -1118,7 +1153,7 @@ static int p54_tx(struct ieee80211_hw *d
 	size_t padding, len, tim_len = 0;
 	int i, j, ridx, ret;
 	u16 hdr_flags = 0, aid = 0;
-	u8 rate, queue;
+	u8 rate, queue, crypt_offset = 0;
 	u8 cts_rate = 0x20;
 	u8 rc_flags;
 	u8 calculated_tries[4];
@@ -1138,12 +1173,25 @@ static int p54_tx(struct ieee80211_hw *d
 	padding = (unsigned long)(skb->data - (sizeof(*hdr) + sizeof(*txhdr))) & 3;
 	len = skb->len;
 
+	if (info->control.hw_key) {
+		crypt_offset = ieee80211_get_hdrlen_from_skb(skb);
+		if (info->control.hw_key->alg == ALG_TKIP) {
+			u8 *iv = (u8 *)(skb->data + crypt_offset);
+			/*
+			 * The firmware excepts that the IV has to have
+			 * this special format
+			 */
+			iv[1] = iv[0];
+			iv[0] = iv[2];
+			iv[2] = 0;
+		}
+	}
+
 	txhdr = (struct p54_tx_data *) skb_push(skb, sizeof(*txhdr) + padding);
 	hdr = (struct p54_hdr *) skb_push(skb, sizeof(*hdr));
 
 	if (padding)
 		hdr_flags |= P54_HDR_FLAG_DATA_ALIGN;
-	hdr->len = cpu_to_le16(len);
 	hdr->type = cpu_to_le16(aid);
 	hdr->rts_tries = info->control.rates[0].count;
 
@@ -1218,10 +1266,27 @@ static int p54_tx(struct ieee80211_hw *d
 	/* TODO: enable bursting */
 	hdr->flags = cpu_to_le16(hdr_flags);
 	hdr->tries = ridx;
-	txhdr->crypt_offset = 0;
 	txhdr->rts_rate_idx = 0;
-	txhdr->key_type = 0;
-	txhdr->key_len = 0;
+	if (info->control.hw_key) {
+		crypt_offset += info->control.hw_key->iv_len;
+		txhdr->key_type = p54_convert_algo(info->control.hw_key->alg);
+		txhdr->key_len = min((u8)16, info->control.hw_key->keylen);
+		memcpy(txhdr->key, info->control.hw_key->key, txhdr->key_len);
+		if (info->control.hw_key->alg == ALG_TKIP) {
+			if (unlikely(skb_tailroom(skb) < 12))
+				goto err;
+			/* reserve space for the MIC key */
+			len += 8;
+			memcpy(skb_put(skb, 8), &(info->control.hw_key->key
+				[NL80211_TKIP_DATA_OFFSET_TX_MIC_KEY]), 8);
+		}
+		/* reserve some space for ICV */
+		len += info->control.hw_key->icv_len;
+	} else {
+		txhdr->key_type = 0;
+		txhdr->key_len = 0;
+	}
+	txhdr->crypt_offset = crypt_offset;
 	txhdr->hw_queue = queue;
 	if (current_queue)
 		txhdr->backlog = current_queue->len;
@@ -1235,17 +1300,20 @@ static int p54_tx(struct ieee80211_hw *d
 	if (padding)
 		txhdr->align[0] = padding;
 
+	hdr->len = cpu_to_le16(len);
 	/* modifies skb->cb and with it info, so must be last! */
-	if (unlikely(p54_assign_address(dev, skb, hdr, skb->len + tim_len))) {
-		skb_pull(skb, sizeof(*hdr) + sizeof(*txhdr) + padding);
-		if (current_queue) {
-			current_queue->len--;
-			current_queue->count--;
-		}
-		return NETDEV_TX_BUSY;
-	}
+	if (unlikely(p54_assign_address(dev, skb, hdr, skb->len + tim_len)))
+		goto err;
 	priv->tx(dev, skb, 0);
 	return 0;
+
+ err:
+	skb_pull(skb, sizeof(*hdr) + sizeof(*txhdr) + padding);
+	if (current_queue) {
+		current_queue->len--;
+		current_queue->count--;
+	}
+	return NETDEV_TX_BUSY;
 }
 
 static int p54_setup_mac(struct ieee80211_hw *dev, u16 mode, const u8 *bssid)
@@ -1849,6 +1917,90 @@ static void p54_bss_info_changed(struct 
 
 }
 
+static int p54_set_key(struct ieee80211_hw *dev, enum set_key_cmd cmd,
+		       const u8 *local_address, const u8 *address,
+		       struct ieee80211_key_conf *key)
+{
+	struct p54_common *priv = dev->priv;
+	struct sk_buff *skb;
+	struct p54_keycache *rxkey;
+	u8 algo = 0;
+
+	if (modparam_nohwcrypt)
+		return -EOPNOTSUPP;
+
+	if (cmd == DISABLE_KEY)
+		algo = 0;
+	else {
+		switch (key->alg) {
+		case ALG_TKIP:
+			if (!(priv->privacy_caps & (BR_DESC_PRIV_CAP_MICHAEL |
+			      BR_DESC_PRIV_CAP_TKIP)))
+				return -EOPNOTSUPP;
+			key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
+			algo = P54_CRYPTO_TKIPMICHAEL;
+			break;
+		case ALG_WEP:
+			if (!(priv->privacy_caps & BR_DESC_PRIV_CAP_WEP))
+				return -EOPNOTSUPP;
+			key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
+			algo = P54_CRYPTO_WEP;
+			break;
+		case ALG_CCMP:
+			if (!(priv->privacy_caps & BR_DESC_PRIV_CAP_AESCCMP))
+				return -EOPNOTSUPP;
+			key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
+			algo = P54_CRYPTO_AESCCMP;
+			break;
+		default:
+			return -EINVAL;
+		}
+	}
+
+	if (key->keyidx > priv->rx_keycache_size) {
+		/*
+		 * The device supports the choosen algorithm, but the firmware
+		 * does not provide enough key slots to store all of them.
+		 * So, incoming frames have to be decoded by the mac80211 stack,
+		 * but we can still offload encryption for outgoing frames.
+		 */
+
+		return 0;
+	}
+
+	mutex_lock(&priv->conf_mutex);
+	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*rxkey) +
+			sizeof(struct p54_hdr),	P54_CONTROL_TYPE_RX_KEYCACHE,
+			GFP_ATOMIC);
+	if (!skb) {
+		mutex_unlock(&priv->conf_mutex);
+		return -ENOMEM;
+	}
+
+	/* TODO: some devices have 4 more free slots for rx keys */
+	rxkey = (struct p54_keycache *)skb_put(skb, sizeof(*rxkey));
+	rxkey->entry = key->keyidx;
+	rxkey->key_id = key->keyidx;
+	rxkey->key_type = algo;
+	if (address)
+		memcpy(rxkey->mac, address, ETH_ALEN);
+	else
+		memset(rxkey->mac, ~0, ETH_ALEN);
+	if (key->alg != ALG_TKIP) {
+		rxkey->key_len = min((u8)16, key->keylen);
+		memcpy(rxkey->key, key->key, rxkey->key_len);
+	} else {
+		rxkey->key_len = 24;
+		memcpy(rxkey->key, key->key, 16);
+		memcpy(&(rxkey->key[16]), &(key->key
+			[NL80211_TKIP_DATA_OFFSET_RX_MIC_KEY]), 8);
+	}
+
+	priv->tx(dev, skb, 1);
+	mutex_unlock(&priv->conf_mutex);
+	return 0;
+}
+
 static const struct ieee80211_ops p54_ops = {
 	.tx			= p54_tx,
 	.start			= p54_start,
@@ -1858,6 +2010,7 @@ static const struct ieee80211_ops p54_op
 	.set_tim		= p54_set_tim,
 	.sta_notify_ps		= p54_sta_notify_ps,
 	.sta_notify		= p54_sta_notify,
+	.set_key		= p54_set_key,
 	.config			= p54_config,
 	.config_interface	= p54_config_interface,
 	.bss_info_changed	= p54_bss_info_changed,
diff -Nurp a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
--- a/drivers/net/wireless/p54/p54.h	2008-11-29 18:19:18.000000000 +0100
+++ b/drivers/net/wireless/p54/p54.h	2008-11-24 21:39:22.000000000 +0100
@@ -115,6 +115,8 @@ struct p54_common {
 	int noise;
 	void *eeprom;
 	struct completion eeprom_comp;
+	u8 privacy_caps;
+	u8 rx_keycache_size;
 };
 
 int p54_rx(struct ieee80211_hw *dev, struct sk_buff *skb);
