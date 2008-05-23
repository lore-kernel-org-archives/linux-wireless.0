Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:52626 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944AbYEWPXa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2008 11:23:30 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1JzZ76-00078J-Ij
	for linux-wireless@vger.kernel.org; Fri, 23 May 2008 15:23:24 +0000
Received: from cpc3-cwma2-0-0-cust15.swan.cable.ntl.com ([81.96.204.16])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2008 15:23:24 +0000
Received: from andy by cpc3-cwma2-0-0-cust15.swan.cable.ntl.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2008 15:23:24 +0000
To: linux-wireless@vger.kernel.org
From: Andrew Price <andy@andrewprice.me.uk>
Subject: Re: BUG: scheduling while atomic (2.6.26-rc3...)
Date: Fri, 23 May 2008 16:23:12 +0100
Message-ID: <g16nh3$iqd$1@ger.gmane.org> (sfid-20080523_172334_394953_9CFACF81)
References: <g158ou$ts7$1@ger.gmane.org> <1211533873.18247.0.camel@johannes.berg> <200805231628.39152.IvDoorn@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
In-Reply-To: <200805231628.39152.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ivo,

On 23/05/08 15:28, Ivo van Doorn wrote:
> Andew: Could you try below patch to see if that works?

It looks good. wlan0 came up fine and dmesg looks clean, I can ping and
read email...

Seems that some traffic (ssh, http, ...) is having problems though so
I'm back on -rc1 to email you but I expect that's a different problem
altogether and I'll see if I can track it down.

> ---
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index 5645140..669d942 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -481,9 +481,9 @@ void rt2x00lib_beacondone(struct rt2x00_dev *rt2x00dev)
>  	if (!test_bit(DEVICE_ENABLED_RADIO, &rt2x00dev->flags))
>  		return;
>  
> -	ieee80211_iterate_active_interfaces(rt2x00dev->hw,
> -					    rt2x00lib_beacondone_iter,
> -					    rt2x00dev);
> +	ieee80211_iterate_active_interfaces_atomic(rt2x00dev->hw,
> +						   rt2x00lib_beacondone_iter,
> +						   rt2x00dev);
>  
>  	queue_work(rt2x00dev->hw->workqueue, &rt2x00dev->intf_work);
>  }
> 

Thanks,

--
Andy Price

