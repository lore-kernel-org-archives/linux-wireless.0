Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:42951 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309Ab3BYKCI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2013 05:02:08 -0500
Message-ID: <20130225120204.31157lefw4sex57k@www.dalek.fi> (sfid-20130225_110218_767224_C6FA01DB)
Date: Mon, 25 Feb 2013 12:02:04 +0200
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Syam Sidhardhan <syamsidhardh@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH] rndis_wlan: Remove redundant NULL check before kfree
References: <1361743543-27912-1-git-send-email-s.syam@samsung.com>
In-Reply-To: <1361743543-27912-1-git-send-email-s.syam@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Acked-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

Quoting Syam Sidhardhan <syamsidhardh@gmail.com>:

> kfree on a NULL pointer is a no-op.
>
> Signed-off-by: Syam Sidhardhan <s.syam@samsung.com>
> ---
>  drivers/net/wireless/rndis_wlan.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/rndis_wlan.c  
> b/drivers/net/wireless/rndis_wlan.c
> index 525fd75..5f66b4e 100644
> --- a/drivers/net/wireless/rndis_wlan.c
> +++ b/drivers/net/wireless/rndis_wlan.c
> @@ -2839,8 +2839,7 @@ static void rndis_wlan_do_link_up_work(struct  
> usbnet *usbdev)
>  	} else if (priv->infra_mode == NDIS_80211_INFRA_ADHOC)
>  		cfg80211_ibss_joined(usbdev->net, bssid, GFP_KERNEL);
>
> -	if (info != NULL)
> -		kfree(info);
> +	kfree(info);
>
>  	priv->connected = true;
>  	memcpy(priv->bssid, bssid, ETH_ALEN);
> --
> 1.7.9.5
>
>
>



