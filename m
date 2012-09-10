Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:37139 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176Ab2IJPdn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 11:33:43 -0400
Message-ID: <20120910183339.19525dpw8ii5bk9c@www.81.fi> (sfid-20120910_173354_468580_0A1773EB)
Date: Mon, 10 Sep 2012 18:33:39 +0300
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: linville@tuxdriver.com, yongjun_wei@trendmicro.com.cn,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] rndis_wlan: remove pointless check from
 rndis_scan()
References: <CAPgLHd8FG3pEz3FZ=1ux=h5sKGXwykXc=qafb=OzEQKXWU9uuw@mail.gmail.com>
In-Reply-To: <CAPgLHd8FG3pEz3FZ=1ux=h5sKGXwykXc=qafb=OzEQKXWU9uuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Wei Yongjun <weiyj.lk@gmail.com>:

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> In rndis_scan(), 'request' is actually always valid pointer and
> the !request check is unneeded, so remove it.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

> ---
>  drivers/net/wireless/rndis_wlan.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/drivers/net/wireless/rndis_wlan.c  
> b/drivers/net/wireless/rndis_wlan.c
> index 7a4ae9e..bd1f0cb 100644
> --- a/drivers/net/wireless/rndis_wlan.c
> +++ b/drivers/net/wireless/rndis_wlan.c
> @@ -1959,9 +1959,6 @@ static int rndis_scan(struct wiphy *wiphy,
>  	 */
>  	rndis_check_bssid_list(usbdev, NULL, NULL);
>
> -	if (!request)
> -		return -EINVAL;
> -
>  	if (priv->scan_request && priv->scan_request != request)
>  		return -EBUSY;
>
>
>
>
>



