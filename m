Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:41708 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753207AbZEVPGC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2009 11:06:02 -0400
Subject: Re: [PATCH 2/4] rndis_wlan: explain bits used in key setup code.
From: Dan Williams <dcbw@redhat.com>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <20090522144020.8134.76073.stgit@fate.lan>
References: <20090522144012.8134.27669.stgit@fate.lan>
	 <20090522144020.8134.76073.stgit@fate.lan>
Content-Type: text/plain
Date: Fri, 22 May 2009 11:05:55 -0400
Message-Id: <1243004755.2461.10.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-05-22 at 17:40 +0300, Jussi Kivilinna wrote:
> Driver uses some unnamed bits to control encryption setup. Move these to
> enumerations with proper names explaining their meaning.
> 
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
> ---
> 
>  drivers/net/wireless/rndis_wlan.c |   23 ++++++++++++++++++-----
>  1 files changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
> index f9b0a35..8609d28 100644
> --- a/drivers/net/wireless/rndis_wlan.c
> +++ b/drivers/net/wireless/rndis_wlan.c
> @@ -196,6 +196,18 @@ enum ndis_80211_priv_filter {
>  	ndis_80211_priv_8021x_wep
>  };
>  
> +enum ndis_80211_addkey_bits {
> +	ndis_80211_addkey_8021x_auth = cpu_to_le32(1 << 28),
> +	ndis_80211_addkey_set_init_recv_seq = cpu_to_le32(1 << 29),
> +	ndis_80211_addkey_pairwise_key = cpu_to_le32(1 << 30),
> +	ndis_80211_addkey_transmit_key = cpu_to_le32(1 << 31),
> +};

Enums and defines are usually capitalized in Linux, ie
NDIS_80211_ADDKEY_8021X_AUTH, so that they can be separated from
non-constant stuff and from function names.  Makes the code more
readable.  Any chance you'd mind doing that in this patch since you're
touching these bits?

Dan

> +enum ndis_80211_addwep_bits {
> +	ndis_80211_addwep_perclient_key = cpu_to_le32(1 << 30),
> +	ndis_80211_addwep_transmit_key = cpu_to_le32(1 << 31),
> +};
> +
>  struct ndis_80211_ssid {
>  	__le32 length;
>  	u8 essid[NDIS_802_11_LENGTH_SSID];
> @@ -998,7 +1010,7 @@ static int add_wep_key(struct usbnet *usbdev, char *key, int key_len, int index)
>  	memcpy(&ndis_key.material, key, key_len);
>  
>  	if (index == priv->encr_tx_key_index) {
> -		ndis_key.index |= cpu_to_le32(1 << 31);
> +		ndis_key.index |= ndis_80211_addwep_transmit_key;
>  		ret = set_encr_mode(usbdev, IW_AUTH_CIPHER_WEP104,
>  						IW_AUTH_CIPHER_NONE);
>  		if (ret)
> @@ -1044,7 +1056,8 @@ static int remove_key(struct usbnet *usbdev, int index, u8 bssid[ETH_ALEN])
>  		if (bssid) {
>  			/* pairwise key */
>  			if (memcmp(bssid, ffff_bssid, ETH_ALEN) != 0)
> -				remove_key.index |= cpu_to_le32(1 << 30);
> +				remove_key.index |=
> +					ndis_80211_addkey_pairwise_key;
>  			memcpy(remove_key.bssid, bssid,
>  					sizeof(remove_key.bssid));
>  		} else
> @@ -1626,7 +1639,7 @@ static int rndis_iw_set_encode_ext(struct net_device *dev,
>  
>  	if (ext->ext_flags & IW_ENCODE_EXT_RX_SEQ_VALID) {
>  		memcpy(ndis_key.rsc, ext->rx_seq, 6);
> -		ndis_key.index |= cpu_to_le32(1 << 29);
> +		ndis_key.index |= ndis_80211_addkey_set_init_recv_seq;
>  	}
>  
>  	addr = ext->addr.sa_data;
> @@ -1638,12 +1651,12 @@ static int rndis_iw_set_encode_ext(struct net_device *dev,
>  			get_bssid(usbdev, ndis_key.bssid);
>  	} else {
>  		/* pairwise key */
> -		ndis_key.index |= cpu_to_le32(1 << 30);
> +		ndis_key.index |= ndis_80211_addkey_pairwise_key;
>  		memcpy(ndis_key.bssid, addr, ETH_ALEN);
>  	}
>  
>  	if (ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY)
> -		ndis_key.index |= cpu_to_le32(1 << 31);
> +		ndis_key.index |= ndis_80211_addkey_transmit_key;
>  
>  	if (ext->alg == IW_ENCODE_ALG_TKIP && ext->key_len == 32) {
>  		/* wpa_supplicant gives us the Michael MIC RX/TX keys in
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

