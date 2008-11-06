Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:39029 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbYKFRGP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2008 12:06:15 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] b43: remove rate index warning
Date: Thu, 6 Nov 2008 18:05:50 +0100
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1225988424.3619.249.camel@johannes.berg>
In-Reply-To: <1225988424.3619.249.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200811061805.50781.mb@bu3sch.de> (sfid-20081106_180620_357348_F62CCC18)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 06 November 2008 17:20:24 Johannes Berg wrote:
> I frequently run into this warning, and added some
> debugging to see why, and got this:
> 
> b43 bad rx: 00000000: 2f d2 e2 63 cf a7 14 04 28 18 c8 5f 88 4a a2 00
>                       bogus junk       | plcp            | fctl| dur
> 
> b43 bad rx: 00000010: 00 11 24 91 07 4d 00 06 25 ff 8f 78 00 06 25 ff
>                       my MAC address   | BSSID           | AP MAC
> b43 bad rx: 00000020: 8f 76 20 74 00 00 42 07 00 20 00 00 00 00 aa aa
>                            | seq | QoS | CCMP IV               | data
>                       ...
> 
> As you can see, there are 6 bogus bytes (sometimes only five) and then
> the frame. I don't know why, and I don't see how to recover, so let's
> just drop these frames.
> 

I don't know why this happens, but I also see it on the opensource firmware.
It might probably be a DMA programming error of some kind. (or just a silicon bug).
But yeah, let's just drop them for now.

> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Signed-off-by: Michael Buesch <mb@bu3sch.de>

> ---
>  drivers/net/wireless/b43/xmit.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- everything.orig/drivers/net/wireless/b43/xmit.c	2008-11-06 16:52:53.000000000 +0100
> +++ everything/drivers/net/wireless/b43/xmit.c	2008-11-06 17:10:06.000000000 +0100
> @@ -46,7 +46,6 @@ static int b43_plcp_get_bitrate_idx_cck(
>  	case 0x6E:
>  		return 3;
>  	}
> -	B43_WARN_ON(1);
>  	return -1;
>  }
>  
> @@ -73,7 +72,6 @@ static u8 b43_plcp_get_bitrate_idx_ofdm(
>  	case 0xC:
>  		return base + 7;
>  	}
> -	B43_WARN_ON(1);
>  	return -1;
>  }
>  
> @@ -608,6 +606,8 @@ void b43_rx(struct b43_wldev *dev, struc
>  						phytype == B43_PHYTYPE_A);
>  	else
>  		status.rate_idx = b43_plcp_get_bitrate_idx_cck(plcp);
> +	if (unlikely(status.rate_idx == -1))
> +		goto drop;
>  	status.antenna = !!(phystat0 & B43_RX_PHYST0_ANT);
>  
>  	/*
> 
> 
> 
> 



-- 
Greetings Michael.
