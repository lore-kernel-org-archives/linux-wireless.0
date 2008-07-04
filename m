Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.184]:38918 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbYGDRov (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jul 2008 13:44:51 -0400
Received: by mu-out-0910.google.com with SMTP id w8so379639mue.1
        for <linux-wireless@vger.kernel.org>; Fri, 04 Jul 2008 10:44:50 -0700 (PDT)
From: Milan Plzik <milan.plzik@gmail.com>
Subject: [PATCH 7/7] Add WPA support for 1.103 firmware
To: linux-wireless@vger.kernel.org
Date: Fri, 04 Jul 2008 19:44:46 +0200
Message-ID: <20080704174445.4996.3885.stgit@localhost> (sfid-20080704_194453_221511_EAE46B50)
In-Reply-To: <20080704174350.4996.72931.stgit@localhost>
References: <20080704174350.4996.72931.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Based on atmelwlandriver analysis, this patch implements support for WPA.
TKIP was tested and working, AES/CCMP needs testing on 505A or 505AMX
device.

Signed-off-by: Milan Plzik <milan.plzik@gmail.com>
---

 drivers/net/wireless/at76_usb.c |   74 ++++++++++++++++++++++++++++++++++-----
 1 files changed, 64 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 5b6fa5c..a0513d7 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -1002,6 +1002,40 @@ static int at76_add_mac_address(struct at76_priv *priv, void *addr)
 	return ret;
 }
 
+static int at76_set_tkip_bssid(struct at76_priv *priv, const void *addr)
+{
+	int ret = 0;
+
+	priv->mib_buf.type = MIB_MAC_ENCRYPTION;
+	priv->mib_buf.size = ETH_ALEN;
+	priv->mib_buf.index = offsetof(struct mib_mac_encryption, tkip_bssid);
+	memcpy(priv->mib_buf.data.addr, addr, ETH_ALEN);
+
+	ret = at76_set_mib(priv, &priv->mib_buf);
+	if (ret < 0)
+		printk(KERN_ERR "%s: set_mib (MAC_ENCRYPTION, tkip_bssid) failed: %d\n",
+		       wiphy_name(priv->hw->wiphy), ret);
+
+	return ret;
+}
+
+static int at76_reset_rsc(struct at76_priv *priv)
+{
+	int ret = 0;
+
+	priv->mib_buf.type = MIB_MAC_ENCRYPTION;
+	priv->mib_buf.size = 4 * 8;
+	priv->mib_buf.index = offsetof(struct mib_mac_encryption, key_rsc);
+	memset(priv->mib_buf.data.data, 0 , priv->mib_buf.size);
+
+	ret = at76_set_mib(priv, &priv->mib_buf);
+	if (ret < 0)
+		printk(KERN_ERR "%s: set_mib (MAC_ENCRYPTION, key_rsc) failed: %d\n",
+		       wiphy_name(priv->hw->wiphy), ret);
+
+	return ret;
+}
+
 static void at76_dump_mib_mac_addr(struct at76_priv *priv)
 {
 	int i;
@@ -1798,10 +1832,10 @@ static int at76_mac80211_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	tx_buffer->padding = padding;
 	tx_buffer->wlength = cpu_to_le16(skb->len);
 	tx_buffer->tx_rate = ieee80211_get_tx_rate(hw, info)->hw_value;
-	if (FIRMWARE_IS_WPA(priv->fw_version) && !(control->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT)) {
-		tx_buffer->key_id = (control->key_idx);
-		tx_buffer->cipher_type = priv->keys[control->key_idx].cipher;
-		tx_buffer->cipher_length = priv->keys[control->key_idx].keylen;
+	if (FIRMWARE_IS_WPA(priv->fw_version) && !(info->flags & IEEE80211_TX_CTL_DO_NOT_ENCRYPT)) {
+		tx_buffer->key_id = (info->control.hw_key->keyidx);
+		tx_buffer->cipher_type = priv->keys[info->control.hw_key->keyidx].cipher;
+		tx_buffer->cipher_length = priv->keys[info->control.hw_key->keyidx].keylen;
 		tx_buffer->reserved = 0;
 	} else {
 		tx_buffer->key_id = 0;
@@ -1944,7 +1978,8 @@ static int at76_join(struct at76_priv *priv)
 		       wiphy_name(priv->hw->wiphy), ret);
 		return 0;
 	}
-
+	
+	at76_set_tkip_bssid(priv, priv->bssid);
 	at76_set_pm_mode(priv);
 
 	return 0;
@@ -1972,13 +2007,10 @@ static void at76_dwork_hw_scan(struct work_struct *work)
 	if (is_valid_ether_addr(priv->bssid)) {
 		ieee80211_wake_queues(priv->hw);
 		at76_join(priv);
-	} else
-		ieee80211_stop_queues(priv->hw);
+	}
 
 	ieee80211_wake_queues(priv->hw);
 
-// CHECKME:	ieee80211_wake_queues(priv->hw);
-
 exit:
 	return;
 }
@@ -2182,7 +2214,7 @@ static int at76_set_key_newfw(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		if (at76_set_mib(priv, &priv->mib_buf) != CMD_STATUS_COMPLETE)
 			ret = -EOPNOTSUPP; /* -EIO would be probably better */
 		else {
-			ret = 0;
+
 			priv->keys[key->keyidx].cipher = CIPHER_NONE;
 			priv->keys[key->keyidx].keylen = 0;
 		};
@@ -2193,6 +2225,7 @@ static int at76_set_key_newfw(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			priv->default_pairwise_key = 0xff;
 		/* If default pairwise key is removed, fall back to 
 		 * group key? */
+		ret = 0;
 		goto exit;
 	};
 	
@@ -2220,6 +2253,22 @@ static int at76_set_key_newfw(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 					goto exit;
 				};
 				break;
+			case ALG_TKIP:
+				key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
+				priv->keys[key->keyidx].cipher = CIPHER_TKIP;
+				priv->keys[key->keyidx].keylen = 12;
+				break;
+
+			case ALG_CCMP:
+				if (!at76_is_505a(priv->board_type)) {
+					ret = -EOPNOTSUPP;
+					goto exit;
+				};
+				key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
+				priv->keys[key->keyidx].cipher = CIPHER_CCMP;
+				priv->keys[key->keyidx].keylen = 16;
+				break;
+				
 			default:
 				ret = -EOPNOTSUPP;
 				goto exit;
@@ -2244,6 +2293,10 @@ static int at76_set_key_newfw(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			ret = -EOPNOTSUPP; /* -EIO would be probably better */
 			goto exit;
 		};
+
+		if ((key->alg == ALG_TKIP) || (key->alg == ALG_CCMP))
+			at76_reset_rsc(priv);
+
 		key->hw_key_idx = key->keyidx;
 
 		/* Set up default keys */
@@ -2742,5 +2795,6 @@ MODULE_AUTHOR("Balint Seeber <n0_5p4m_p13453@hotmail.com>");
 MODULE_AUTHOR("Pavel Roskin <proski@gnu.org>");
 MODULE_AUTHOR("Guido Guenther <agx@sigxcpu.org>");
 MODULE_AUTHOR("Kalle Valo <kalle.valo@iki.fi>");
+MODULE_AUTHOR("Milan Plzik <milan.plzik@gmail.com>");
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");

