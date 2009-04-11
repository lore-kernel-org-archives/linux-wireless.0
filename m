Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:47111 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbZDKB6G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Apr 2009 21:58:06 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] p54: utilize all available key slots for decryption offload
Date: Sat, 11 Apr 2009 03:58:01 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200904110358.01979.chunkeey@web.de> (sfid-20090411_035813_030554_C36054EC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch takes care of outstanding TODOs:
/* TODO: some devices have 4 more free slots for rx keys */

Now the driver can utilize all available key slots instead of just 4.
Obviously, this helps most in AP/IBSS(/MESH) mode, when
we have to use more different keys.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
Two more patches form an older stash.

I'll wait until wireless-testing is "synced" before
flooding the tubes with the "split p54common" series.
Of course ar9170usb is on hold for the same reason...

Regards,
	Chr
---
diff --git a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
index fe8bca4..fadee60 100644
--- a/drivers/net/wireless/p54/p54.h
+++ b/drivers/net/wireless/p54/p54.h
@@ -187,6 +187,7 @@ struct p54_common {
 	/* cryptographic engine information */
 	u8 privacy_caps;
 	u8 rx_keycache_size;
+	unsigned long *used_rxkeys;
 
 	/* LED management */
 #ifdef CONFIG_P54_LEDS
diff --git a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
index 2f55662..d57e0ca 100644
--- a/drivers/net/wireless/p54/p54common.c
+++ b/drivers/net/wireless/p54/p54common.c
@@ -181,7 +181,7 @@ int p54_parse_firmware(struct ieee80211_hw *dev, const struct firmware *fw)
 		dev->queues = P54_QUEUE_AC_NUM;
 	}
 
-	if (!modparam_nohwcrypt)
+	if (!modparam_nohwcrypt) {
 		printk(KERN_INFO "%s: cryptographic accelerator "
 				 "WEP:%s, TKIP:%s, CCMP:%s\n",
 			wiphy_name(dev->wiphy),
@@ -191,6 +191,26 @@ int p54_parse_firmware(struct ieee80211_hw *dev, const struct firmware *fw)
 			(priv->privacy_caps & BR_DESC_PRIV_CAP_AESCCMP) ?
 			"YES" : "no");
 
+		if (priv->rx_keycache_size) {
+			/*
+			 * NOTE:
+			 *
+			 * The firmware provides at most 255 (0 - 254) slots
+			 * for keys which are then used to offload decryption.
+			 * As a result the 255 entry (aka 0xff) can be used
+			 * safely by the driver to mark keys that didn't fit
+			 * into the full cache. This trick saves us from
+			 * keeping a extra list for uploaded keys.
+			 */
+
+			priv->used_rxkeys = kzalloc(BITS_TO_LONGS(
+				priv->rx_keycache_size), GFP_KERNEL);
+
+			if (!priv->used_rxkeys)
+				return -ENOMEM;
+		}
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(p54_parse_firmware);
@@ -2544,61 +2564,84 @@ static int p54_set_key(struct ieee80211_hw *dev, enum set_key_cmd cmd,
 	struct p54_common *priv = dev->priv;
 	struct sk_buff *skb;
 	struct p54_keycache *rxkey;
+	int slot, ret = 0;
 	u8 algo = 0;
 
 	if (modparam_nohwcrypt)
 		return -EOPNOTSUPP;
 
-	if (cmd == DISABLE_KEY)
-		algo = 0;
-	else {
+	mutex_lock(&priv->conf_mutex);
+	if (cmd == SET_KEY) {
 		switch (key->alg) {
 		case ALG_TKIP:
 			if (!(priv->privacy_caps & (BR_DESC_PRIV_CAP_MICHAEL |
-			      BR_DESC_PRIV_CAP_TKIP)))
-				return -EOPNOTSUPP;
+			      BR_DESC_PRIV_CAP_TKIP))) {
+				ret = -EOPNOTSUPP;
+				goto out_unlock;
+			}
 			key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
 			algo = P54_CRYPTO_TKIPMICHAEL;
 			break;
 		case ALG_WEP:
-			if (!(priv->privacy_caps & BR_DESC_PRIV_CAP_WEP))
-				return -EOPNOTSUPP;
+			if (!(priv->privacy_caps & BR_DESC_PRIV_CAP_WEP)) {
+				ret = -EOPNOTSUPP;
+				goto out_unlock;
+			}
 			key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
 			algo = P54_CRYPTO_WEP;
 			break;
 		case ALG_CCMP:
-			if (!(priv->privacy_caps & BR_DESC_PRIV_CAP_AESCCMP))
-				return -EOPNOTSUPP;
+			if (!(priv->privacy_caps & BR_DESC_PRIV_CAP_AESCCMP)) {
+				ret = -EOPNOTSUPP;
+				goto out_unlock;
+			}
 			key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
 			algo = P54_CRYPTO_AESCCMP;
 			break;
 		default:
-			return -EOPNOTSUPP;
+			ret = -EOPNOTSUPP;
+			goto out_unlock;
 		}
-	}
+		slot = bitmap_find_free_region(priv->used_rxkeys,
+					       priv->rx_keycache_size, 0);
 
-	if (key->keyidx > priv->rx_keycache_size) {
-		/*
-		 * The device supports the choosen algorithm, but the firmware
-		 * does not provide enough key slots to store all of them.
-		 * So, incoming frames have to be decoded by the mac80211 stack,
-		 * but we can still offload encryption for outgoing frames.
-		 */
+		if (slot < 0) {
+			/*
+			 * The device supports the choosen algorithm, but the
+			 * firmware does not provide enough key slots to store
+			 * all of them.
+			 * But encryption offload for outgoing frames is always
+			 * possible, so we just pretend that the upload was
+			 * successful and do the decryption in software.
+			 */
 
-		return 0;
+			/* mark the key as invalid. */
+			key->hw_key_idx = 0xff;
+			goto out_unlock;
+		}
+	} else {
+		slot = key->hw_key_idx;
+
+		if (slot == 0xff) {
+			/* This key was not uploaded into the rx key cache. */
+
+			goto out_unlock;
+		}
+
+		bitmap_release_region(priv->used_rxkeys, slot, 0);
+		algo = 0;
 	}
 
-	mutex_lock(&priv->conf_mutex);
 	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*rxkey),
-			    P54_CONTROL_TYPE_RX_KEYCACHE, GFP_ATOMIC);
+			    P54_CONTROL_TYPE_RX_KEYCACHE, GFP_KERNEL);
 	if (!skb) {
-		mutex_unlock(&priv->conf_mutex);
-		return -ENOMEM;
+		bitmap_release_region(priv->used_rxkeys, slot, 0);
+		ret = -ENOSPC;
+		goto out_unlock;
 	}
 
-	/* TODO: some devices have 4 more free slots for rx keys */
 	rxkey = (struct p54_keycache *)skb_put(skb, sizeof(*rxkey));
-	rxkey->entry = key->keyidx;
+	rxkey->entry = slot;
 	rxkey->key_id = key->keyidx;
 	rxkey->key_type = algo;
 	if (sta)
@@ -2616,8 +2659,11 @@ static int p54_set_key(struct ieee80211_hw *dev, enum set_key_cmd cmd,
 	}
 
 	priv->tx(dev, skb);
+	key->hw_key_idx = slot;
+
+out_unlock:
 	mutex_unlock(&priv->conf_mutex);
-	return 0;
+	return ret;
 }
 
 #ifdef CONFIG_P54_LEDS
@@ -2858,6 +2904,7 @@ void p54_free_common(struct ieee80211_hw *dev)
 	kfree(priv->iq_autocal);
 	kfree(priv->output_limit);
 	kfree(priv->curve_data);
+	kfree(priv->used_rxkeys);
 
 #ifdef CONFIG_P54_LEDS
 	p54_unregister_leds(dev);
