Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:49927 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932955Ab0DHW2Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 18:28:16 -0400
Message-ID: <4BBE5879.8000304@openwrt.org>
Date: Fri, 09 Apr 2010 00:28:09 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Gertjan van Wingerde <gwingerde@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 3/9] rt2x00: Align RT chipset definitions with vendor
 driver.
References: <1270763437-29526-1-git-send-email-gwingerde@gmail.com> <1270763437-29526-4-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1270763437-29526-4-git-send-email-gwingerde@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-04-08 11:50 PM, Gertjan van Wingerde wrote:
> Only include definitions for RT chipsets that are also used inside the
> Ralink vendor drivers.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |   13 -------------
>  drivers/net/wireless/rt2x00/rt2x00.h    |    7 +++----
>  2 files changed, 3 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 394c8e4..4bc7e09 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -1209,10 +1209,7 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
>  	rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_MPDU, AGGREGATION_SIZE);
>  	if ((rt2x00_rt(rt2x00dev, RT2872) &&
>  	     (rt2x00_rev(rt2x00dev) >= RT2880E_VERSION)) ||
> -	    rt2x00_rt(rt2x00dev, RT2880) ||
>  	    rt2x00_rt(rt2x00dev, RT2883) ||
> -	    rt2x00_rt(rt2x00dev, RT2890) ||
> -	    rt2x00_rt(rt2x00dev, RT3052) ||
>  	    (rt2x00_rt(rt2x00dev, RT3070) &&
>  	     (rt2x00_rev(rt2x00dev) < RT3070_VERSION)))
>  		rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_PSDU, 2);
> @@ -1511,12 +1508,6 @@ int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
>  		rt2800_bbp_write(rt2x00dev, 105, 0x05);
>  	}
>  
> -	if (rt2x00_rt(rt2x00dev, RT3052)) {
> -		rt2800_bbp_write(rt2x00dev, 31, 0x08);
> -		rt2800_bbp_write(rt2x00dev, 78, 0x0e);
> -		rt2800_bbp_write(rt2x00dev, 80, 0x08);
> -	}
> -
Why are you removing support for RT3052? IMHO those writes were
necessary, last time I tested the rt2800pci code on the RT3052 WiSoC.

- Felix
