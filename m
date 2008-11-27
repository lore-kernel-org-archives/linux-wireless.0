Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:34991 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755004AbYK0AP6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 19:15:58 -0500
Message-ID: <492DE6BD.5060206@lwfinger.net> (sfid-20081127_011614_008617_07EA0111)
Date: Wed, 26 Nov 2008 18:15:57 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFT][RFC][PATCH] p54: utilize cryptographic accelerator
References: <200811242215.00475.chunkeey@web.de>
In-Reply-To: <200811242215.00475.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> This patch allows p54 to utilize its WEP, TKIP and CCMP accelerator.
> 
> Signed-off-by: Christian Lamparter <chunkeey@web.de>
> ---
> diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
> --- a/drivers/net/wireless/p54/p54common.c	2008-11-24 21:05:42.590287518 +0100
> +++ b/drivers/net/wireless/p54/p54common.c	2008-11-24 22:06:13.951266225 +0100
> @@ -25,6 +25,9 @@
>  #include "p54.h"
>  #include "p54common.h"
>  
> +static int modparam_nohwcrypt;
> +module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
> +MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
>  MODULE_AUTHOR("Michael Wu <flamingice@sourmilk.net>");
--snip--
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(p54_parse_firmware);
> @@ -527,6 +542,11 @@ static int p54_rx_data(struct ieee80211_
>  			return 0;
>  	}
>  
> +	if (hdr->decrypt_status == P54_DECRYPT_OK)
> +		rx_status.flag |= RX_FLAG_DECRYPTED;
> +	if (hdr->decrypt_status == P54_DECRYPT_FAIL_MICHAEL)
> +		rx_status.flag |= RX_FLAG_MMIC_ERROR;
> +
>  	rx_status.signal = p54_rssi_to_dbm(dev, hdr->rssi);
>  	rx_status.noise = priv->noise;
>  	/* XX correct? */
> @@ -843,6 +863,8 @@ static int p54_assign_address(struct iee
>  
>  	spin_lock_irqsave(&priv->tx_queue.lock, flags);
>  	left = skb_queue_len(&priv->tx_queue);
> +	if (left > 30)
> +		return -ENOMEM;

The above returns with tx_queue.lock still set.

>  	while (left--) {
>  		u32 hole_size;
>  		info = IEEE80211_SKB_CB(entry);
> @@ -1082,6 +1104,20 @@ static int p54_tx_fill(struct ieee80211_
>  	return ret;
>  }
>  
--snip--
> +		}
> +	}
> +
> +	mutex_lock(&priv->conf_mutex);
> +	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*rxkey) +
> +			sizeof(struct p54_hdr),	P54_CONTROL_TYPE_RX_KEYCACHE,
> +			GFP_ATOMIC);
> +	if (!skb) {
> +		mutex_unlock(&priv->conf_mutex);
> +		return -ENOMEM;
> +	}
> +
> +	rxkey = (struct p54_keycache *)skb_put(skb, sizeof(*rxkey));
> +	rxkey->entry = cpu_to_le16(key->keyidx);
> +	rxkey->key_id = cpu_to_le16(key->keyidx);

Sparse objects to the above two statments because key->keyidx is of type s8, and
both rxkey->entry and rxkey->key_id are of type u8. A conversion to le16 is not
needed.

A patch for both problems is below:

Larry

=========

Index: wireless-testing/drivers/net/wireless/p54/p54common.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/p54/p54common.c
+++ wireless-testing/drivers/net/wireless/p54/p54common.c
@@ -862,8 +862,10 @@ static int p54_assign_address(struct iee

 	spin_lock_irqsave(&priv->tx_queue.lock, flags);
 	left = skb_queue_len(&priv->tx_queue);
-	if (left > 30)
+	if (left > 30) {
+		spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
 		return -ENOMEM;
+	}
 	while (left--) {
 		u32 hole_size;
 		info = IEEE80211_SKB_CB(entry);
@@ -1944,8 +1946,8 @@ static int p54_set_key(struct ieee80211_
 	}

 	rxkey = (struct p54_keycache *)skb_put(skb, sizeof(*rxkey));
-	rxkey->entry = cpu_to_le16(key->keyidx);
-	rxkey->key_id = cpu_to_le16(key->keyidx);
+	rxkey->entry = key->keyidx;
+	rxkey->key_id = key->keyidx;
 	rxkey->key_len = min((u8)24, key->keylen);
 	rxkey->key_type = algo;
 	if (address)
