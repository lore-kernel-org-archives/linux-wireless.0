Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:59682 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705Ab0EKE2D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 00:28:03 -0400
Subject: Re: [patch 8/9] wl1271: fix notifier interface supported test
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Dan Carpenter <error27@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Oikarinen Juuso (Nokia-D/Tampere)" <juuso.oikarinen@nokia.com>,
	"Paasikivi Teemu.3 (EXT-Ixonos/Tampere)"
	<ext-teemu.3.paasikivi@nokia.com>, Kalle Valo <kalle.valo@iki.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20100508162551.GT27064@bicker>
References: <20100508162551.GT27064@bicker>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 May 2010 07:27:42 +0300
Message-ID: <1273552062.2021.26.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-05-08 at 18:25 +0200, ext Dan Carpenter wrote:
> The "(wl == NULL)" test doesn't work here because "wl" is always
> non-null.  The intent of the code is to return if the interface
> was not supported by the driver.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
> index b61cd10..55aa813 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_main.c
> +++ b/drivers/net/wireless/wl12xx/wl1271_main.c
> @@ -852,7 +852,7 @@ static int wl1271_dev_notify(struct notifier_block *me, unsigned long what,
>  		if (wl == wl_temp)
>  			break;
>  	}
> -	if (wl == NULL)
> +	if (wl != wl_temp)
>  		return NOTIFY_DONE;
>  
>  	/* Get the interface IP address for the device. "ifa" will become

Thanks for the fix.

Acked-by: Luciano Coelho <luciano.coelho@nokia.com>


-- 
Cheers,
Luca.


