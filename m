Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39086 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705Ab1CUWkm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 18:40:42 -0400
Received: by wwa36 with SMTP id 36so8051158wwa.1
        for <linux-wireless@vger.kernel.org>; Mon, 21 Mar 2011 15:40:41 -0700 (PDT)
Message-ID: <4D87D3E0.4080408@gmail.com>
Date: Mon, 21 Mar 2011 22:40:32 +0000
From: Dave Kilroy <kilroyd@googlemail.com>
MIME-Version: 1.0
To: armadefuego@gmail.com
CC: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2.6.38-rc8-wl RESEND] orinoco: Clear dangling pointer
 on hardware busy
References: <4d870a8a.8735e50a.41c9.134e@mx.google.com>
In-Reply-To: <4d870a8a.8735e50a.41c9.134e@mx.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21/03/2011 08:21, armadefuego@gmail.com wrote:
> On hardware busy the scan request pointer should be cleared, as higher levels will release. This avoids a crash when that pointer is erroneously used later.

I think you need to add line breaks for the git log

> Signed-off-by: Joseph J. Gunn<armadefuego@yahoo.com>
> ---
> When the hardware is busy the error is propagated to higher levels on the stack. Those layers release the buffer. Therefore the copy of the pointer must be erased. Otherwise subsequent events checking this pointer ma crash.
> ---
> diff --git a/drivers/net/wireless/orinoco/cfg.c b/drivers/net/wireless/orinoco/cfg.c
> index 09fae2f..2022815 100644
> --- a/drivers/net/wireless/orinoco/cfg.c
> +++ b/drivers/net/wireless/orinoco/cfg.c
> @@ -151,8 +151,17 @@ static int orinoco_scan(struct wiphy *wiphy, struct net_device *dev,
>   		return -EBUSY;
>
>   	priv->scan_request = request;
> +	DEBUG(3, "orinoco_scan():"
> +		" scan_request %p wiphy %p, dev %p\n",
> +		priv->scan_request,
> +		priv->scan_request->wiphy,
> +		priv->scan_request->dev
> +		);
>
>   	err = orinoco_hw_trigger_scan(priv, request->ssids);
> +	/* On EBUSY the hardware is busy. We aren't processing the request */
> +	if (err == -EBUSY)

We should reset priv->scan_request on all errors, not just -EBUSY. Were 
you getting this in a particular situation? If so, highlighting it in 
the commit log is useful.

I notice -EBUSY is returned when we can't get the orinoco_lock - are you 
having an issue with lock cotention on a particular device?

> +		priv->scan_request = NULL;
>
>   	return err;
>   }
> diff --git a/drivers/net/wireless/orinoco/scan.c b/drivers/net/wireless/orinoco/scan.c
> index e99ca1c..698e9ff 100644
> --- a/drivers/net/wireless/orinoco/scan.c
> +++ b/drivers/net/wireless/orinoco/scan.c
> @@ -230,6 +230,12 @@ void orinoco_add_hostscan_results(struct orinoco_private *priv,
>
>    scan_abort:
>   	if (priv->scan_request) {
> +		DEBUG(3, "orinoco_add_hostscan_results():"
> +			" scan_request %p wiphy %p, dev %p\n",
> +			priv->scan_request,
> +			priv->scan_request->wiphy,
> +			priv->scan_request->dev
> +			);

I'm not a big fan of scattering DEBUG statements about, but if we're 
going to, use __FUNCTION__ (or whatever the C99 incarnation is) rather 
than explicitly naming the functions.


Dave.
