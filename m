Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout3-sn1.fre.skanova.net ([81.228.11.120]:40781 "EHLO
	pne-smtpout3-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751542AbYBXLEG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Feb 2008 06:04:06 -0500
Subject: Re: [PATCH] rndis_wlan: fix sparse warnings
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1203504466.17534.16.camel@johannes.berg>
References: <1203504466.17534.16.camel@johannes.berg>
Content-Type: text/plain
Date: Sun, 24 Feb 2008 13:02:25 +0200
Message-Id: <1203850945.12137.10.camel@localhost> (sfid-20080224_110411_710295_2C92100C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-02-20 at 11:47 +0100, Johannes Berg wrote:
> It is obviously wrong to use an enum in a little endian struct,
> and those other enums should be declared differently.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Thanks, and also works as nice style cleanup.

Acked-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

> ---
>  drivers/net/wireless/rndis_wlan.c |   14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> --- everything.orig/drivers/net/wireless/rndis_wlan.c	2008-02-20 11:43:22.000000000 +0100
> +++ everything/drivers/net/wireless/rndis_wlan.c	2008-02-20 11:45:35.000000000 +0100
> @@ -228,9 +228,9 @@ struct NDIS_WLAN_BSSID_EX {
>  	struct NDIS_802_11_SSID Ssid;
>  	__le32 Privacy;
>  	__le32 Rssi;
> -	enum NDIS_802_11_NETWORK_TYPE NetworkTypeInUse;
> +	__le32 NetworkTypeInUse;
>  	struct NDIS_802_11_CONFIGURATION Configuration;
> -	enum NDIS_802_11_NETWORK_INFRASTRUCTURE InfrastructureMode;
> +	__le32 InfrastructureMode;
>  	u8 SupportedRates[NDIS_802_11_LENGTH_RATES_EX];
>  	__le32 IELength;
>  	u8 IEs[0];
> @@ -279,11 +279,11 @@ struct RNDIS_CONFIG_PARAMETER_INFOBUFFER
>  } __attribute__((packed));
>  
>  /* these have to match what is in wpa_supplicant */
> -enum { WPA_ALG_NONE, WPA_ALG_WEP, WPA_ALG_TKIP, WPA_ALG_CCMP } wpa_alg;
> -enum { CIPHER_NONE, CIPHER_WEP40, CIPHER_TKIP, CIPHER_CCMP, CIPHER_WEP104 }
> -	wpa_cipher;
> -enum { KEY_MGMT_802_1X, KEY_MGMT_PSK, KEY_MGMT_NONE, KEY_MGMT_802_1X_NO_WPA,
> -	KEY_MGMT_WPA_NONE } wpa_key_mgmt;
> +enum wpa_alg { WPA_ALG_NONE, WPA_ALG_WEP, WPA_ALG_TKIP, WPA_ALG_CCMP };
> +enum wpa_cipher { CIPHER_NONE, CIPHER_WEP40, CIPHER_TKIP, CIPHER_CCMP,
> +		  CIPHER_WEP104 };
> +enum wpa_key_mgmt { KEY_MGMT_802_1X, KEY_MGMT_PSK, KEY_MGMT_NONE,
> +		    KEY_MGMT_802_1X_NO_WPA, KEY_MGMT_WPA_NONE };
>  
>  /*
>   *  private data
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

