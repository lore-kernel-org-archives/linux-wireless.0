Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56141 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab2APMVe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jan 2012 07:21:34 -0500
Subject: Re: [PATCH] mac80211: fix tx->skb NULL pointer dereference
From: Johannes Berg <johannes@sipsolutions.net>
To: Yoni Divinsky <yoni.divinsky@ti.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1326707004-3352-1-git-send-email-yoni.divinsky@ti.com> (sfid-20120116_104144_714044_0D0D9702)
References: <1326707004-3352-1-git-send-email-yoni.divinsky@ti.com>
	 (sfid-20120116_104144_714044_0D0D9702)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Jan 2012 13:21:32 +0100
Message-ID: <1326716492.3510.10.camel@jlt3.sipsolutions.net> (sfid-20120116_132137_430770_1A95420B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-01-16 at 11:43 +0200, Yoni Divinsky wrote:
> In function ieee80211_tx_h_encrypt the var info was
> initialized from tx->skb, since the fucntion
> is called after the function ieee80211_tx_h_fragment
> tx->skb is not valid anymore.

Wow, that's quite a while ago, I guess nobody tests WAPI often? :-)

> @@ -1001,8 +1001,6 @@ ieee80211_tx_h_stats(struct ieee80211_tx_data *tx)
>  static ieee80211_tx_result debug_noinline
>  ieee80211_tx_h_encrypt(struct ieee80211_tx_data *tx)
>  {
> -	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
> -
>  	if (!tx->key)
>  		return TX_CONTINUE;
>  
> @@ -1017,13 +1015,7 @@ ieee80211_tx_h_encrypt(struct ieee80211_tx_data *tx)
>  	case WLAN_CIPHER_SUITE_AES_CMAC:
>  		return ieee80211_crypto_aes_cmac_encrypt(tx);
>  	default:
> -		/* handle hw-only algorithm */
> -		if (info->control.hw_key) {
> -			ieee80211_tx_set_protected(tx);
> -			return TX_CONTINUE;
> -		}
> -		break;
> -
> +		return ieee80211_crypto_default_encrypt(tx);

How about
ieee80211_require_hw_crypto() or something like that?

> +ieee80211_tx_result
> +ieee80211_crypto_default_encrypt(struct ieee80211_tx_data *tx)
> +{
> +	struct sk_buff *skb;
> +	struct ieee80211_tx_info *info = NULL;
> +
> +	skb_queue_walk(&tx->skbs, skb) {
> +		info  = IEEE80211_SKB_CB(skb);
> +
> +		/* handle hw-only algorithm */
> +		if (info == NULL || !info->control.hw_key)
> +			return TX_DROP;

info == NULL can't happen

johannes

