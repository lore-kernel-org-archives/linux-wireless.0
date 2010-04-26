Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:2174 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755383Ab0DZVqv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 17:46:51 -0400
Message-ID: <4BD609C9.1080005@gmail.com>
Date: Mon, 26 Apr 2010 23:46:49 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: John Linville <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rt2x00: rt2800lib: Fix rx path on SoC devices
References: <201004261348.45044.helmut.schaa@googlemail.com>
In-Reply-To: <201004261348.45044.helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/26/10 13:48, Helmut Schaa wrote:
> Restore the rfcsr initialization for RT305x SoC devices which was removed
> by "rt2x00: Finish rt3070 support in rt2800 register initialization.".
> 
> This fixes the rx path on SoC devices.
> 
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |   34 ++++++++++++++++++++++++++++++-
>  1 files changed, 33 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 2648f31..1358d9a 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -1703,7 +1703,8 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>  	if (!rt2x00_rt(rt2x00dev, RT3070) &&
>  	    !rt2x00_rt(rt2x00dev, RT3071) &&
>  	    !rt2x00_rt(rt2x00dev, RT3090) &&
> -	    !rt2x00_rt(rt2x00dev, RT3390))
> +	    !rt2x00_rt(rt2x00dev, RT3390) &&
> +	    !(rt2x00_is_soc(rt2x00dev) && rt2x00_rt(rt2x00dev, RT2872)))
>  		return 0;

As indicated in the separate email, we should also check for the presence of an RF3020, RF3021
or RF3022 RF chipset for the RT2872 case (maybe this should be more generic, because I'm sure
this will also hold for the other RT chipsets).

>  
>  	/*
> @@ -1771,6 +1772,37 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>  		rt2800_rfcsr_write(rt2x00dev, 29, 0x8f);
>  		rt2800_rfcsr_write(rt2x00dev, 30, 0x20);
>  		rt2800_rfcsr_write(rt2x00dev, 31, 0x0f);
> +	} else if (rt2x00_rt(rt2x00dev, RT2872)) {
> +		rt2800_rfcsr_write(rt2x00dev, 0, 0x50);
> +		rt2800_rfcsr_write(rt2x00dev, 1, 0x01);
> +		rt2800_rfcsr_write(rt2x00dev, 2, 0xf7);
> +		rt2800_rfcsr_write(rt2x00dev, 3, 0x75);
> +		rt2800_rfcsr_write(rt2x00dev, 4, 0x40);
> +		rt2800_rfcsr_write(rt2x00dev, 5, 0x03);
> +		rt2800_rfcsr_write(rt2x00dev, 6, 0x02);
> +		rt2800_rfcsr_write(rt2x00dev, 7, 0x50);
> +		rt2800_rfcsr_write(rt2x00dev, 8, 0x39);
> +		rt2800_rfcsr_write(rt2x00dev, 9, 0x0f);
> +		rt2800_rfcsr_write(rt2x00dev, 10, 0x60);
> +		rt2800_rfcsr_write(rt2x00dev, 11, 0x21);
> +		rt2800_rfcsr_write(rt2x00dev, 12, 0x75);
> +		rt2800_rfcsr_write(rt2x00dev, 13, 0x75);
> +		rt2800_rfcsr_write(rt2x00dev, 14, 0x90);
> +		rt2800_rfcsr_write(rt2x00dev, 15, 0x58);
> +		rt2800_rfcsr_write(rt2x00dev, 16, 0xb3);
> +		rt2800_rfcsr_write(rt2x00dev, 17, 0x92);
> +		rt2800_rfcsr_write(rt2x00dev, 18, 0x2c);
> +		rt2800_rfcsr_write(rt2x00dev, 19, 0x02);
> +		rt2800_rfcsr_write(rt2x00dev, 20, 0xba);
> +		rt2800_rfcsr_write(rt2x00dev, 21, 0xdb);
> +		rt2800_rfcsr_write(rt2x00dev, 22, 0x00);
> +		rt2800_rfcsr_write(rt2x00dev, 23, 0x31);
> +		rt2800_rfcsr_write(rt2x00dev, 24, 0x08);
> +		rt2800_rfcsr_write(rt2x00dev, 25, 0x01);
> +		rt2800_rfcsr_write(rt2x00dev, 26, 0x25);
> +		rt2800_rfcsr_write(rt2x00dev, 27, 0x23);
> +		rt2800_rfcsr_write(rt2x00dev, 28, 0x13);
> +		rt2800_rfcsr_write(rt2x00dev, 29, 0x83);
>  	}
>  
>  	if (rt2x00_rt_rev_lt(rt2x00dev, RT3070, REV_RT3070F)) {

Here we need 2 additional rfcsr_writes, for RF CSR 30 and RF CSR 31, both set to value 0x00.
Also, we can add an "return 0" at the end of the sequence, as nothing more needs to be done for RT2872.

---
Gertjan.
