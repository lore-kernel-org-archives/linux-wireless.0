Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:40495 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757730AbZE3T7P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 May 2009 15:59:15 -0400
Subject: Re: [RFC v2 04/23] cfg80211: set WE encoding size based on
 available ciphers
From: Marcel Holtmann <marcel@holtmann.org>
To: David Kilroy <kilroyd@googlemail.com>
Cc: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
In-Reply-To: <1243705017-8784-5-git-send-email-kilroyd@googlemail.com>
References: <1243705017-8784-1-git-send-email-kilroyd@googlemail.com>
	 <1243705017-8784-5-git-send-email-kilroyd@googlemail.com>
Content-Type: text/plain
Date: Sat, 30 May 2009 21:57:48 +0200
Message-Id: <1243713468.3523.32.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi David,

> Only set the sizes for WEP40 and WEP104.
> 
> Signed-off-by: David Kilroy <kilroyd@googlemail.com>
> ---
> I'm not sure of the intent of the encoding_size field, and whether it
> should contain entries for TKIP and CCMP ciphers. However since these
> aren't currently advertised, I've left this alone.
> ---
>  net/wireless/wext-compat.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
> index 9ec9fc5..e5385f0 100644
> --- a/net/wireless/wext-compat.c
> +++ b/net/wireless/wext-compat.c
> @@ -173,9 +173,6 @@ int cfg80211_wext_giwrange(struct net_device *dev,
>  	range->min_frag = 256;
>  	range->max_frag = 2346;
>  
> -	range->encoding_size[0] = 5;
> -	range->encoding_size[1] = 13;
> -	range->num_encoding_sizes = 2;
>  	range->max_encoding_tokens = 4;
>  
>  	range->max_qual.updated = IW_QUAL_NOISE_INVALID;
> @@ -213,6 +210,12 @@ int cfg80211_wext_giwrange(struct net_device *dev,
>  			range->enc_capa |= IW_ENC_CAPA_CIPHER_TKIP;
>  		else if (suite == WLAN_CIPHER_SUITE_CCMP)
>  			range->enc_capa |= IW_ENC_CAPA_CIPHER_CCMP;
> +		else if (suite == WLAN_CIPHER_SUITE_WEP40)
> +			range->encoding_size[range->num_encoding_sizes++] =
> +				WLAN_KEY_LEN_WEP40;
> +		else if (suite == WLAN_CIPHER_SUITE_WEP104)
> +			range->encoding_size[range->num_encoding_sizes++] =
> +				WLAN_KEY_LEN_WEP104;

especially since you are now extending this list, please use a switch
statement. The code becomes hard to read.

Regards

Marcel


