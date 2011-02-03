Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60898 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134Ab1BCQgI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Feb 2011 11:36:08 -0500
Subject: Re: [PATCH] mac80211: Remove obsolete TKIP flexibility
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20110203163428.GA17227@jm.kir.nu>
References: <20110203163428.GA17227@jm.kir.nu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Feb 2011 17:36:04 +0100
Message-ID: <1296750964.3854.17.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-02-03 at 18:34 +0200, Jouni Malinen wrote:
> The TKIP implementation was originally prepared to be a bit more
> flexible in the way Michael MIC TX/RX keys are configured. However, we
> are now taking care of the TX/RX MIC key swapping in user space, so
> this code will not be needed. Similarly, there were some remaining WPA
> testing code that won't be used in their current form. Remove the
> unneeded extra complexity.
> 
> Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

Thanks.

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/wpa.c |   32 +++++++-------------------------
>  1 file changed, 7 insertions(+), 25 deletions(-)
> 
> --- wireless-testing.orig/net/mac80211/wpa.c	2011-02-03 13:54:05.000000000 +0200
> +++ wireless-testing/net/mac80211/wpa.c	2011-02-03 17:55:31.000000000 +0200
> @@ -26,13 +26,12 @@
>  ieee80211_tx_result
>  ieee80211_tx_h_michael_mic_add(struct ieee80211_tx_data *tx)
>  {
> -	u8 *data, *key, *mic, key_offset;
> +	u8 *data, *key, *mic;
>  	size_t data_len;
>  	unsigned int hdrlen;
>  	struct ieee80211_hdr *hdr;
>  	struct sk_buff *skb = tx->skb;
>  	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> -	int authenticator;
>  	int tail;
>  
>  	hdr = (struct ieee80211_hdr *)skb->data;
> @@ -62,15 +61,7 @@ ieee80211_tx_h_michael_mic_add(struct ie
>  		    skb_headroom(skb) < TKIP_IV_LEN))
>  		return TX_DROP;
>  
> -#if 0
> -	authenticator = fc & IEEE80211_FCTL_FROMDS; /* FIX */
> -#else
> -	authenticator = 1;
> -#endif
> -	key_offset = authenticator ?
> -		NL80211_TKIP_DATA_OFFSET_TX_MIC_KEY :
> -		NL80211_TKIP_DATA_OFFSET_RX_MIC_KEY;
> -	key = &tx->key->conf.key[key_offset];
> +	key = &tx->key->conf.key[NL80211_TKIP_DATA_OFFSET_TX_MIC_KEY];
>  	mic = skb_put(skb, MICHAEL_MIC_LEN);
>  	michael_mic(key, hdr, data, data_len, mic);
>  
> @@ -81,14 +72,13 @@ ieee80211_tx_h_michael_mic_add(struct ie
>  ieee80211_rx_result
>  ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx)
>  {
> -	u8 *data, *key = NULL, key_offset;
> +	u8 *data, *key = NULL;
>  	size_t data_len;
>  	unsigned int hdrlen;
>  	u8 mic[MICHAEL_MIC_LEN];
>  	struct sk_buff *skb = rx->skb;
>  	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
>  	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
> -	int authenticator = 1, wpa_test = 0;
>  
>  	/* No way to verify the MIC if the hardware stripped it */
>  	if (status->flag & RX_FLAG_MMIC_STRIPPED)
> @@ -106,17 +96,9 @@ ieee80211_rx_h_michael_mic_verify(struct
>  	data = skb->data + hdrlen;
>  	data_len = skb->len - hdrlen - MICHAEL_MIC_LEN;
>  
> -#if 0
> -	authenticator = fc & IEEE80211_FCTL_TODS; /* FIX */
> -#else
> -	authenticator = 1;
> -#endif
> -	key_offset = authenticator ?
> -		NL80211_TKIP_DATA_OFFSET_RX_MIC_KEY :
> -		NL80211_TKIP_DATA_OFFSET_TX_MIC_KEY;
> -	key = &rx->key->conf.key[key_offset];
> +	key = &rx->key->conf.key[NL80211_TKIP_DATA_OFFSET_RX_MIC_KEY];
>  	michael_mic(key, hdr, data, data_len, mic);
> -	if (memcmp(mic, data + data_len, MICHAEL_MIC_LEN) != 0 || wpa_test) {
> +	if (memcmp(mic, data + data_len, MICHAEL_MIC_LEN) != 0) {
>  		if (!(status->rx_flags & IEEE80211_RX_RA_MATCH))
>  			return RX_DROP_UNUSABLE;
>  
> @@ -208,7 +190,7 @@ ieee80211_rx_result
>  ieee80211_crypto_tkip_decrypt(struct ieee80211_rx_data *rx)
>  {
>  	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) rx->skb->data;
> -	int hdrlen, res, hwaccel = 0, wpa_test = 0;
> +	int hdrlen, res, hwaccel = 0;
>  	struct ieee80211_key *key = rx->key;
>  	struct sk_buff *skb = rx->skb;
>  	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
> @@ -235,7 +217,7 @@ ieee80211_crypto_tkip_decrypt(struct iee
>  					  hdr->addr1, hwaccel, rx->queue,
>  					  &rx->tkip_iv32,
>  					  &rx->tkip_iv16);
> -	if (res != TKIP_DECRYPT_OK || wpa_test)
> +	if (res != TKIP_DECRYPT_OK)
>  		return RX_DROP_UNUSABLE;
>  
>  	/* Trim ICV */
> 


