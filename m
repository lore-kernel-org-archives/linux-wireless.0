Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:36682 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbYKOA5r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 19:57:47 -0500
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [RFC][RFT][PATCH] p54: WEP & CCMP accelerator v2
Date: Sat, 15 Nov 2008 01:57:45 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>,
	Kalle Valo <kalle.valo@nokia.com>
References: <200811141942.50398.chunkeey@web.de>
In-Reply-To: <200811141942.50398.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200811150157.45433.chunkeey@web.de> (sfid-20081115_015751_707171_3F764573)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch allows p54 to utilize its WEP and CCMP accelerator.

However, I'm not sure how TKIP is supposed to work... Kalle?

changes:
- fix reject if "[PATCH 3/4] p54pci: cache firmware for suspend/resume" is applied
  instead of the original "[PATCH 3/4] p54: protect against sudden firmware file changes".

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
Oops, this is the right one... ignore the other v2
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-11-15 01:29:46.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2008-11-15 01:29:54.000000000 +0100
@@ -25,6 +25,9 @@
 #include "p54.h"
 #include "p54common.h"
 
+static int modparam_nohwcrypt;
+module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
+MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
 MODULE_AUTHOR("Michael Wu <flamingice@sourmilk.net>");
 MODULE_DESCRIPTION("Softmac Prism54 common code");
 MODULE_LICENSE("GPL");
@@ -182,6 +185,8 @@ int p54_parse_firmware(struct ieee80211_
 			priv->rx_end = le32_to_cpu(desc->rx_end) - 0x3500;
 			priv->headroom = desc->headroom;
 			priv->tailroom = desc->tailroom;
+			priv->privacy_caps = desc->privacy_caps;
+			priv->rx_keycache_size = desc->rx_keycache_size;
 			if (le32_to_cpu(bootrec->len) == 11)
 				priv->rx_mtu = le16_to_cpu(desc->rx_mtu);
 			else
@@ -225,6 +230,14 @@ int p54_parse_firmware(struct ieee80211_
 		dev->queues = 4;
 	}
 
+	if (!modparam_nohwcrypt)
+		printk(KERN_INFO "%s: Available cryptographic accelerator for"
+				 " WEP:%s, TKIP:no, CCMP:%s\n",
+			wiphy_name(dev->wiphy),
+			(priv->privacy_caps & BR_DESC_PRIV_CAP_WEP) ? "YES" :
+			"no", (priv->privacy_caps & BR_DESC_PRIV_CAP_AESCCMP) ?
+			"YES" : "no");
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(p54_parse_firmware);
@@ -524,6 +537,11 @@ static int p54_rx_data(struct ieee80211_
 			return 0;
 	}
 
+	if (hdr->decrypt_status == P54_DECRYPT_OK)
+		rx_status.flag |= RX_FLAG_DECRYPTED;
+	if (hdr->decrypt_status == P54_DECRYPT_FAIL_MICHAEL)
+		rx_status.flag |= RX_FLAG_MMIC_ERROR;
+
 	rx_status.signal = p54_rssi_to_dbm(dev, hdr->rssi);
 	rx_status.noise = priv->noise;
 	/* XX correct? */
@@ -1072,6 +1090,20 @@ static int p54_tx_fill(struct ieee80211_
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
@@ -1082,13 +1114,14 @@ static int p54_tx(struct ieee80211_hw *d
 	size_t padding, len, tim_len = 0;
 	int i, j, ridx;
 	u16 hdr_flags = 0, aid = 0;
-	u8 rate, queue;
+	u8 rate, queue, crypt_offset;
 	u8 cts_rate = 0x20;
 	u8 rc_flags;
 	u8 calculated_tries[4];
 	u8 nrates = 0, nremaining = 8;
 
 	queue = skb_get_queue_mapping(skb);
+	crypt_offset = ieee80211_get_hdrlen_from_skb(skb);
 
 	if (p54_tx_fill(dev, skb, info, &queue, &tim_len, &hdr_flags, &aid)) {
 		current_queue = &priv->tx_stats[queue];
@@ -1194,10 +1227,23 @@ static int p54_tx(struct ieee80211_hw *d
 	/* TODO: enable bursting */
 	hdr->flags = cpu_to_le16(hdr_flags);
 	hdr->tries = ridx;
-	txhdr->crypt_offset = 0;
 	txhdr->rts_rate_idx = 0;
-	txhdr->key_type = 0;
-	txhdr->key_len = 0;
+	if (info->control.hw_key) {
+		crypt_offset += info->control.hw_key->iv_len;
+		if (info->control.hw_key->flags & IEEE80211_KEY_FLAG_WMM_STA)
+			crypt_offset += IEEE80211_QOS_CTL_LEN;
+		txhdr->crypt_offset = crypt_offset;
+		txhdr->key_type = p54_convert_algo(info->control.hw_key->alg);
+		txhdr->key_len = min((u8)16, info->control.hw_key->keylen);
+		memcpy(txhdr->key, info->control.hw_key->key, txhdr->key_len);
+
+		/* reserve some space for ICV */
+		hdr->len += info->control.hw_key->icv_len;
+	} else {
+		txhdr->crypt_offset = 0;
+		txhdr->key_type = 0;
+		txhdr->key_len = 0;
+	}
 	txhdr->hw_queue = queue;
 	if (current_queue)
 		txhdr->backlog = current_queue->len;
@@ -1826,6 +1872,66 @@ static void p54_bss_info_changed(struct 
 
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
+		return -ENOSPC;
+
+	if (cmd == DISABLE_KEY)
+		algo = 0;
+	else {
+		switch (key->alg) {
+		case ALG_TKIP:
+			return -EOPNOTSUPP;
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
+	mutex_lock(&priv->conf_mutex);
+	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*rxkey) +
+			sizeof(struct p54_hdr),	P54_CONTROL_TYPE_RX_KEYCACHE,
+			GFP_ATOMIC);
+	if (!skb) {
+		mutex_unlock(&priv->conf_mutex);
+		return -ENOMEM;
+	}
+
+	rxkey = (struct p54_keycache *)skb_put(skb, sizeof(*rxkey));
+	rxkey->entry = cpu_to_le16(key->keyidx);
+	rxkey->key_id = cpu_to_le16(key->keyidx);
+	rxkey->key_len = min((u8)16, key->keylen);
+	rxkey->key_type = algo;
+	if (address)
+		memcpy(rxkey->mac, address, ETH_ALEN);
+	else
+		memset(rxkey->mac, ~0, ETH_ALEN);
+	memcpy(rxkey->key, key->key, rxkey->key_len);
+	priv->tx(dev, skb, 1);
+	mutex_unlock(&priv->conf_mutex);
+	return 0;
+}
+
 static const struct ieee80211_ops p54_ops = {
 	.tx			= p54_tx,
 	.start			= p54_start,
@@ -1833,6 +1939,7 @@ static const struct ieee80211_ops p54_op
 	.add_interface		= p54_add_interface,
 	.remove_interface	= p54_remove_interface,
 	.set_tim		= p54_set_tim,
+	.set_key		= p54_set_key,
 	.config			= p54_config,
 	.config_interface	= p54_config_interface,
 	.bss_info_changed	= p54_bss_info_changed,
diff -Nurp a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
--- a/drivers/net/wireless/p54/p54.h	2008-11-15 01:26:51.000000000 +0100
+++ b/drivers/net/wireless/p54/p54.h	2008-11-15 01:26:56.000000000 +0100
@@ -115,6 +115,8 @@ struct p54_common {
 	int noise;
 	void *eeprom;
 	struct completion eeprom_comp;
+	u8 privacy_caps;
+	u8 rx_keycache_size;
 };
 
 int p54_rx(struct ieee80211_hw *dev, struct sk_buff *skb);
