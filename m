Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:16751 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149AbZKBIED (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 03:04:03 -0500
Message-ID: <4AEE9269.40006@nokia.com>
Date: Mon, 02 Nov 2009 10:03:53 +0200
From: Luciano Coelho <luciano.coelho@nokia.com>
MIME-Version: 1.0
To: "ext Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] wl1271: use __dev_alloc_skb() on RX
References: <1256927746-19352-1-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1256927746-19352-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luiz,

ext Luis R. Rodriguez wrote:
> RX is handled in a workqueue therefore allocating for GFP_ATOMIC
> is overkill and not required.


Yes, this looks like the correct thing to do.  Thank you for pointing out! Can 
you send the patch again to Linville for integration?


> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> 
> --- 
> 
> This goes untested and not even compile tested but just thought this was odd.
> 
> diff --git a/drivers/net/wireless/wl12xx/wl1271_rx.c b/drivers/net/wireless/wl12xx/wl1271_rx.c
> index 37d81ab..ca645f3 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_rx.c
> +++ b/drivers/net/wireless/wl12xx/wl1271_rx.c
> @@ -159,7 +159,7 @@ static void wl1271_rx_handle_data(struct wl1271 *wl, u32 length)
>  	u8 *buf;
>  	u8 beacon = 0;
>  
> -	skb = dev_alloc_skb(length);
> +	skb = __dev_alloc_skb(length, GFP_KERNEL);
>  	if (!skb) {
>  		wl1271_error("Couldn't allocate RX frame");
>  		return;

Acked-by: Luciano Coelho <luciano.coelho@nokia.com>

-- 
Cheers,
Luca.
