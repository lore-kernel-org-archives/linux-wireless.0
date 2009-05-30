Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:54108 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210AbZE3Tyl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 May 2009 15:54:41 -0400
Subject: Re: [RFC v2 02/23] cfg80211: Advertise ciphers via WE according to
 driver capability
From: Marcel Holtmann <marcel@holtmann.org>
To: David Kilroy <kilroyd@googlemail.com>
Cc: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
In-Reply-To: <1243705017-8784-3-git-send-email-kilroyd@googlemail.com>
References: <1243705017-8784-1-git-send-email-kilroyd@googlemail.com>
	 <1243705017-8784-3-git-send-email-kilroyd@googlemail.com>
Content-Type: text/plain
Date: Sat, 30 May 2009 21:54:22 +0200
Message-Id: <1243713262.3523.29.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi David,

> Signed-off-by: David Kilroy <kilroyd@googlemail.com>
> ---
>  net/wireless/wext-compat.c |   12 ++++++++++--
>  1 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
> index 711e00a..b132f85 100644
> --- a/net/wireless/wext-compat.c
> +++ b/net/wireless/wext-compat.c
> @@ -204,8 +204,16 @@ int cfg80211_wext_giwrange(struct net_device *dev,
>  	range->avg_qual.noise = range->max_qual.noise / 2;
>  	range->avg_qual.updated = range->max_qual.updated;
>  
> -	range->enc_capa = IW_ENC_CAPA_WPA | IW_ENC_CAPA_WPA2 |
> -			  IW_ENC_CAPA_CIPHER_TKIP | IW_ENC_CAPA_CIPHER_CCMP;
> +	range->enc_capa = IW_ENC_CAPA_WPA | IW_ENC_CAPA_WPA2;
> +
> +	for (c = 0; c < wdev->wiphy->n_cipher_suites; c++) {
> +		u32 suite = wdev->wiphy->cipher_suites[c];
> +
> +		if (suite == WLAN_CIPHER_SUITE_TKIP)
> +			range->enc_capa |= IW_ENC_CAPA_CIPHER_TKIP;
> +		else if (suite == WLAN_CIPHER_SUITE_CCMP)
> +			range->enc_capa |= IW_ENC_CAPA_CIPHER_CCMP;

this is a personal preference, but a switch statement make the code way
easier to read here.

Regards

Marcel


