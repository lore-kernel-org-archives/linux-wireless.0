Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.246]:48575 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761197AbXK2SEE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2007 13:04:04 -0500
Received: by an-out-0708.google.com with SMTP id d31so406078and
        for <linux-wireless@vger.kernel.org>; Thu, 29 Nov 2007 10:04:01 -0800 (PST)
Message-ID: <40f31dec0711291004k6d7f61f5y5487df8540e237c0@mail.gmail.com> (sfid-20071129_180408_421573_3CF8ED08)
Date: Thu, 29 Nov 2007 20:04:00 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Francesco Gringoli" <francesco.gringoli@ing.unibs.it>
Subject: Re: ath5k: filter patch
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <0D869D0B-A5CF-4AE4-B986-DB168917296B@ing.unibs.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <0D869D0B-A5CF-4AE4-B986-DB168917296B@ing.unibs.it>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2007/11/29, Francesco Gringoli <francesco.gringoli@ing.unibs.it>:
> Hello everybody,
>
> I discovered that playing with iface promiscuity to capture traffic
> (including control, promisc and all other stuff) is not working on
> ath5k as rx_filters are never refreshed. To make things going I added
> a single ath5k_hw_set_rx_filters(ah,rfilt) at the end of
> ath5k_configure_filter(). I attach the simple patch. Now tcpdump
> captures everything in monitor mode when iface is set to promisc.
>
> By the way, has someone tried to put ath5k into using RTS/CTS procedure?
>
> Regards,
> FG
>
>
>
> --- wireless-2.6.old/drivers/net/wireless/ath5k/base.c
> 2007-11-29 16:20:27.000000000 +0100
> +++ wireless-2.6/drivers/net/wireless/ath5k/base.c       2007-11-29
> 16:21:24.000000000 +0100
> @@ -2813,6 +2813,9 @@
>                  rfilt |= AR5K_RX_FILTER_BEACON;
>          }
> +        /* Set filters */
> +        ath5k_hw_set_rx_filter(ah,rfilt);
> +
>          /* Set multicast bits */
>          ath5k_hw_set_mcast_filter(ah, mfilt[0], mfilt[1]);
>          /* Set the cached hw filter flags, this will alter actually
>
>

Thanx a lot for your patch !, plz check out
http://www.linuxwireless.org/en/developers/SubmittingPatches
on how to submit your patch on the list and resubmit so it can be included  ;-)

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
