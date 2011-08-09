Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:40317 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab1HICFJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 22:05:09 -0400
Message-ID: <4E4095C2.3010607@openwrt.org> (sfid-20110809_040513_622582_FD99F76B)
Date: Mon, 08 Aug 2011 20:04:50 -0600
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Bill Jordan <bjordan@rajant.com>
CC: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Subject: Re: [PATCH] ath: Fix hardware decryption of WEP
References: <1312831193-8691-1-git-send-email-bjordan@rajant.com>
In-Reply-To: <1312831193-8691-1-git-send-email-bjordan@rajant.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-08-08 1:19 PM, Bill Jordan wrote:
> The first 4 hardware key indexes are reserved for WEP, but
> never programmed. The result was that WEP always used
> software decryption.
>
> Signed-off-by: Bill Jordan<bjordan@rajant.com>
> ---
>   drivers/net/wireless/ath/key.c |    8 +++++---
>   1 files changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/key.c b/drivers/net/wireless/ath/key.c
> index 17b0efd..73177f1 100644
> --- a/drivers/net/wireless/ath/key.c
> +++ b/drivers/net/wireless/ath/key.c
> @@ -501,7 +501,11 @@ int ath_key_config(struct ath_common *common,
>   	if (key->keylen)
>   		memcpy(hk.kv_val, key->key, key->keylen);
>
> -	if (!(key->flags&  IEEE80211_KEY_FLAG_PAIRWISE)) {
> +	if (hk.kv_type == ATH_CIPHER_WEP) {
> +		if (key->keyidx>= IEEE80211_WEP_NKID)
> +			return -EOPNOTSUPP;
> +		idx = key->keyidx;
> +	} else if (!(key->flags&  IEEE80211_KEY_FLAG_PAIRWISE)) {
I'm not sure this is a good idea, this would break adding pairwise WEP 
keys. Also, maybe WEP keys could use the BSSID in the lookup to avoid 
the first 4 keycache slots, that way it'd work properly in multi-BSSID 
AP setups.

- Felix
