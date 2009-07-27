Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:34768 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbZG0RLs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 13:11:48 -0400
Subject: Re: [PATCH] airo: Buffer overflow
From: Dan Williams <dcbw@redhat.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4A6B72E8.3060500@gmail.com>
References: <4A6B72E8.3060500@gmail.com>
Content-Type: text/plain
Date: Mon, 27 Jul 2009 13:12:26 -0400
Message-Id: <1248714746.17189.17.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2009-07-25 at 23:02 +0200, Roel Kluin wrote:
> SSID_rid has space for only 3 ssids. 
> txPowerLevels[i] is read before the bounds check for i
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
> diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
> index c70604f..8ce5e4c 100644
> --- a/drivers/net/wireless/airo.c
> +++ b/drivers/net/wireless/airo.c
> @@ -5918,20 +5918,19 @@ static int airo_set_essid(struct net_device *dev,
>  	readSsidRid(local, &SSID_rid);
>  
>  	/* Check if we asked for `any' */
> -	if(dwrq->flags == 0) {
> +	if (dwrq->flags == 0) {
>  		/* Just send an empty SSID list */
>  		memset(&SSID_rid, 0, sizeof(SSID_rid));
>  	} else {
> -		int	index = (dwrq->flags & IW_ENCODE_INDEX) - 1;
> +		unsigned index = (dwrq->flags & IW_ENCODE_INDEX) - 1;
>  
>  		/* Check the size of the string */
> -		if(dwrq->length > IW_ESSID_MAX_SIZE) {
> +		if (dwrq->length > IW_ESSID_MAX_SIZE)
>  			return -E2BIG ;
> -		}
> +
>  		/* Check if index is valid */
> -		if((index < 0) || (index >= 4)) {
> +		if (index >= ARRAY_SIZE(SSID_rid.ssids))
>  			return -EINVAL;
> -		}
>  
>  		/* Set the SSID */
>  		memset(SSID_rid.ssids[index].ssid, 0,
> @@ -6819,7 +6818,7 @@ static int airo_set_txpow(struct net_device *dev,
>  		return -EINVAL;
>  	}
>  	clear_bit (FLAG_RADIO_OFF, &local->flags);
> -	for (i = 0; cap_rid.txPowerLevels[i] && (i < 8); i++)
> +	for (i = 0; i < 8 && cap_rid.txPowerLevels[i]; i++)
>  		if (v == cap_rid.txPowerLevels[i]) {
>  			readConfigRid(local, 1);
>  			local->config.txPower = v;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

