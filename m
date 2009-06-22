Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:49910 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183AbZFVO27 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2009 10:28:59 -0400
Subject: Re: [PATCH V2] libertas: copy WPA keys to priv when associating
From: Dan Williams <dcbw@redhat.com>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
In-Reply-To: <1245289534-21888-1-git-send-email-andrey@cozybit.com>
References: <1245186407.28992.59.camel@130.81.190.10.in-addr.arpa>
	 <1245289534-21888-1-git-send-email-andrey@cozybit.com>
Content-Type: text/plain
Date: Mon, 22 Jun 2009 10:29:00 -0400
Message-Id: <1245680940.4338.20.camel@dhcp-100-3-98.bos.redhat.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-06-17 at 18:45 -0700, Andrey Yurovsky wrote:
> Libertas currently maintains a copy of the WPA unicast and group keys
> when using WPA or WPA2.  This copy is checked when deciding whether or
> not to return to sleep in IEEE PS mode but the actual copying back to
> priv was omitted, which breaks IEEE PS mode with WPA/WPA2 when one
> issues commands that require temporarily keeping the device awake.
> 
> This patch introduces the omitted copy-back of the keys so that IEEE PS
> functions correctly in WPA/WPA2 mode.  Thanks to Dan Williams for
> clearing up the issue.
> 
> V2: fix typo.  Also, this has been tested on GSPI and SDIO with V9 firmware.
> 
> Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>

Acked-by: Dan Williams <dcbw@redhat.com>

Thanks!

> ---
>  drivers/net/wireless/libertas/assoc.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
> index b9b3741..b7c7cb0 100644
> --- a/drivers/net/wireless/libertas/assoc.c
> +++ b/drivers/net/wireless/libertas/assoc.c
> @@ -1368,11 +1368,17 @@ static int assoc_helper_wpa_keys(struct lbs_private *priv,
>  	if (ret)
>  		goto out;
>  
> +	memcpy(&priv->wpa_unicast_key, &assoc_req->wpa_unicast_key,
> +			sizeof(struct enc_key));
> +
>  	if (test_bit(ASSOC_FLAG_WPA_MCAST_KEY, &assoc_req->flags)) {
>  		clear_bit(ASSOC_FLAG_WPA_UCAST_KEY, &assoc_req->flags);
>  
>  		ret = lbs_cmd_802_11_key_material(priv, CMD_ACT_SET, assoc_req);
>  		assoc_req->flags = flags;
> +
> +		memcpy(&priv->wpa_mcast_key, &assoc_req->wpa_mcast_key,
> +				sizeof(struct enc_key));
>  	}
>  
>  out:

