Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:46290 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752143AbXJOPNI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 11:13:08 -0400
Message-ID: <47138373.3010703@lwfinger.net> (sfid-20071015_161311_456854_9A6996D8)
Date: Mon, 15 Oct 2007 10:12:51 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH] b43: jiffies_round -> jiffies_round_relative conversion
 - b43/b43legacy
References: <200710151452.58150.mb@bu3sch.de>
In-Reply-To: <200710151452.58150.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> When rounding a relative timeout we need to use round_jiffies_relative(). 
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>
> Signed-off-by: Michael Buesch <mb@bu3sch.de>

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

> ---
> 
> diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
> index c141a26..41049a4 100644
> --- a/drivers/net/wireless/b43/main.c
> +++ b/drivers/net/wireless/b43/main.c
> @@ -2392,7 +2392,7 @@ out_requeue:
>  	if (b43_debug(dev, B43_DBG_PWORK_FAST))
>  		delay = msecs_to_jiffies(50);
>  	else
> -		delay = round_jiffies(HZ * 15);
> +		delay = round_jiffies_relative(HZ * 15);
>  	queue_delayed_work(wl->hw->workqueue, &dev->periodic_work, delay);
>  out:
>  	mutex_unlock(&wl->mutex);
> diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
> index f074951..bd0bd9b 100644
> --- a/drivers/net/wireless/b43legacy/main.c
> +++ b/drivers/net/wireless/b43legacy/main.c
> @@ -2260,7 +2260,7 @@ out_requeue:
>  	if (b43legacy_debug(dev, B43legacy_DBG_PWORK_FAST))
>  		delay = msecs_to_jiffies(50);
>  	else
> -		delay = round_jiffies(HZ);
> +		delay = round_jiffies_relative(HZ);
>  	queue_delayed_work(dev->wl->hw->workqueue,
>  			   &dev->periodic_work, delay);
>  out:
> 
> 
> -------------------------------------------------------
> 

