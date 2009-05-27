Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:45852 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932990AbZE0SPQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2009 14:15:16 -0400
Subject: Re: [PATCH] wireless: libertas: fix unaligned accesses
From: Dan Williams <dcbw@redhat.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-wireless@vger.kernel.org, Cliff Cai <cliff.cai@analog.com>,
	Bryan Wu <cooloney@kernel.org>
In-Reply-To: <1243447389-6715-1-git-send-email-vapier@gentoo.org>
References: <1243447389-6715-1-git-send-email-vapier@gentoo.org>
Content-Type: text/plain
Date: Wed, 27 May 2009 14:06:43 -0400
Message-Id: <1243447603.17301.24.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-05-27 at 14:03 -0400, Mike Frysinger wrote:
> From: Cliff Cai <cliff.cai@analog.com>
> 
> Signed-off-by: Cliff Cai <cliff.cai@analog.com>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/cmdresp.c |   10 +++++-----
>  drivers/net/wireless/libertas/scan.c    |    2 +-
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
> index bcf2a97..c3e947c 100644
> --- a/drivers/net/wireless/libertas/cmdresp.c
> +++ b/drivers/net/wireless/libertas/cmdresp.c
> @@ -5,7 +5,7 @@
>  #include <linux/delay.h>
>  #include <linux/if_arp.h>
>  #include <linux/netdevice.h>
> -
> +#include <asm/unaligned.h>
>  #include <net/iw_handler.h>
>  
>  #include "host.h"
> @@ -154,11 +154,11 @@ static int lbs_ret_802_11_rssi(struct lbs_private *priv,
>  	lbs_deb_enter(LBS_DEB_CMD);
>  
>  	/* store the non average value */
> -	priv->SNR[TYPE_BEACON][TYPE_NOAVG] = le16_to_cpu(rssirsp->SNR);
> -	priv->NF[TYPE_BEACON][TYPE_NOAVG] = le16_to_cpu(rssirsp->noisefloor);
> +	priv->SNR[TYPE_BEACON][TYPE_NOAVG] = get_unaligned_le16(&rssirsp->SNR);
> +	priv->NF[TYPE_BEACON][TYPE_NOAVG] = get_unaligned_le16(&rssirsp->noisefloor);
>  
> -	priv->SNR[TYPE_BEACON][TYPE_AVG] = le16_to_cpu(rssirsp->avgSNR);
> -	priv->NF[TYPE_BEACON][TYPE_AVG] = le16_to_cpu(rssirsp->avgnoisefloor);
> +	priv->SNR[TYPE_BEACON][TYPE_AVG] = get_unaligned_le16(&rssirsp->avgSNR);
> +	priv->NF[TYPE_BEACON][TYPE_AVG] = get_unaligned_le16(&rssirsp->avgnoisefloor);
>  
>  	priv->RSSI[TYPE_BEACON][TYPE_NOAVG] =
>  	    CAL_RSSI(priv->SNR[TYPE_BEACON][TYPE_NOAVG],
> diff --git a/drivers/net/wireless/libertas/scan.c b/drivers/net/wireless/libertas/scan.c
> index 8124db3..68bf6b7 100644
> --- a/drivers/net/wireless/libertas/scan.c
> +++ b/drivers/net/wireless/libertas/scan.c
> @@ -1130,7 +1130,7 @@ static int lbs_ret_80211_scan(struct lbs_private *priv, unsigned long dummy,
>  		goto done;
>  	}
>  
> -	bytesleft = le16_to_cpu(scanresp->bssdescriptsize);
> +	bytesleft = get_unaligned_le16(&scanresp->bssdescriptsize);
>  	lbs_deb_scan("SCAN_RESP: bssdescriptsize %d\n", bytesleft);
>  
>  	scanrespsize = le16_to_cpu(resp->size);

