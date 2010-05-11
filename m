Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:20227 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab0EKE1T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 00:27:19 -0400
Subject: Re: [patch 7/9] wl1271: add missing spin_lock()
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Dan Carpenter <error27@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Oikarinen Juuso (Nokia-D/Tampere)" <juuso.oikarinen@nokia.com>,
	"Paasikivi Teemu.3 (EXT-Ixonos/Tampere)"
	<ext-teemu.3.paasikivi@nokia.com>, Kalle Valo <kalle.valo@iki.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20100508162517.GS27064@bicker>
References: <20100508162517.GS27064@bicker>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 May 2010 07:27:17 +0300
Message-ID: <1273552037.2021.25.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-05-08 at 18:25 +0200, ext Dan Carpenter wrote:
> We should start the loop consistently with the "wl_lock" lock held.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
> index 3e4b9fb..b61cd10 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_main.c
> +++ b/drivers/net/wireless/wl12xx/wl1271_main.c
> @@ -466,6 +466,7 @@ static void wl1271_irq_work(struct work_struct *work)
>  		intr = le32_to_cpu(wl->fw_status->intr);
>  		if (!intr) {
>  			wl1271_debug(DEBUG_IRQ, "Zero interrupt received.");
> +			spin_lock_irqsave(&wl->wl_lock, flags);
>  			continue;
>  		}
>  

Good catch.  Thank you.

Acked-by: Luciano Coelho <luciano.coelho@nokia.com>


-- 
Cheers,
Luca.


