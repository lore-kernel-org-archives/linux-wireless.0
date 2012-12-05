Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:48222 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912Ab2LEK4S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 05:56:18 -0500
Message-ID: <1354704935.6234.44.camel@cumari.coelho.fi> (sfid-20121205_115622_823732_7EF2694F)
Subject: Re: [PATCH 03/20] wlcore/wl18xx/wl12xx: FW log params per chip arch
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
CC: <linux-wireless@vger.kernel.org>, Igal Chernobelsky <igalc@ti.com>
Date: Wed, 5 Dec 2012 12:55:35 +0200
In-Reply-To: <1354095769-8724-4-git-send-email-arik@wizery.com>
References: <1354095769-8724-1-git-send-email-arik@wizery.com>
	 <1354095769-8724-4-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-11-28 at 11:42 +0200, Arik Nemtsov wrote:
> From: Igal Chernobelsky <igalc@ti.com>
> 
> FW memory block size and FW log end marker parameters
> are added to wl structure and are initialized per
> chip architecture. convert_hwaddr hw operation is added
> to convert chip dependent FW internal address.
> Copy from FW log is also simplified to copy the entire
> memory block as FW logger utility is repsponsible
> for parsing of FW log content.
> 
> Signed-off-by: Igal Chernobelsky <igalc@ti.com>
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

This commit log explains what has been done, which can quite easily be
see in the patch itself.  That's okay, but what I'm missing here is the
explanation *why* this needs to be done.


> diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
> index 951b88c..5e3c808 100644
> --- a/drivers/net/wireless/ti/wl12xx/main.c
> +++ b/drivers/net/wireless/ti/wl12xx/main.c
> @@ -706,6 +706,9 @@ static int wl12xx_identify_chip(struct wl1271 *wl)
>  		goto out;
>  	}
>  
> +	wl->fw_mem_block_size = 256;
> +	wl->fwlog_end = 0x2000000;

This value used to be in a macro before (WLCORE_FW_LOG_END), why kill
it? It should just be renamed to WL12XX_FW_LOG_END and a new one be
created for WL18XX.


> @@ -1632,6 +1635,11 @@ static int wl12xx_set_peer_cap(struct wl1271 *wl,
>  					      hlid);
>  }
>  
> +static u32 wl12xx_convert_hwaddr(struct wl1271 *wl, u32 hwaddr)
> +{
> +	return hwaddr << 5;
> +}

There was a good comment about this calculation before, it should be
moved here instead of deleted.


> @@ -1669,6 +1677,7 @@ static struct wlcore_ops wl12xx_ops = {
>  	.channel_switch		= wl12xx_cmd_channel_switch,
>  	.pre_pkt_send		= NULL,
>  	.set_peer_cap		= wl12xx_set_peer_cap,
> +	.convert_hwaddr = wl12xx_convert_hwaddr,

No need to break the alignment here.


>  static struct ieee80211_sta_ht_cap wl12xx_ht_cap = {
> diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
> index df8de71..d806241 100644
> --- a/drivers/net/wireless/ti/wl18xx/main.c
> +++ b/drivers/net/wireless/ti/wl18xx/main.c
> @@ -667,6 +667,9 @@ static int wl18xx_identify_chip(struct wl1271 *wl)
>  		goto out;
>  	}
>  
> +	wl->fw_mem_block_size = 272;
> +	wl->fwlog_end = 0x40000000;

Again, the magic number here can be avoided.

> @@ -1423,6 +1426,11 @@ static int wl18xx_set_peer_cap(struct wl1271 *wl,
>  				       rate_set, hlid);
>  }
>  
> +static u32 wl18xx_convert_hwaddr(struct wl1271 *wl, u32 hwaddr)
> +{
> +	return hwaddr & ~0x80000000;
> +}

A small explanation here would be nice.

[...]



>  	/* Traverse the memory blocks linked list */
>  	do {
> -		memset(block, 0, WL12XX_HW_BLOCK_SIZE);
> -		ret = wlcore_read_hwaddr(wl, addr, block, WL12XX_HW_BLOCK_SIZE,
> -					 false);
> +		part.mem.start = wlcore_hw_convert_hwaddr(wl, addr);
> +		part.mem.size  = PAGE_SIZE;
> +
> +		ret = wlcore_set_partition(wl, &part);
> +		if (ret < 0) {
> +			wl1271_error("%s: set_partition start=0x%X size=%d",
> +				__func__, part.mem.start, part.mem.size);

This could probably be a bit more descriptive, like saying that the
fwlog seems to be corrupt because the address in the linked list can't
be used for setting the partition.


> diff --git a/drivers/net/wireless/ti/wlcore/io.h b/drivers/net/wireless/ti/wlcore/io.h
> index f48530f..5897747 100644
> --- a/drivers/net/wireless/ti/wlcore/io.h
> +++ b/drivers/net/wireless/ti/wlcore/io.h
> @@ -165,8 +165,8 @@ static inline int __must_check wlcore_read_hwaddr(struct wl1271 *wl, int hwaddr,
>         int physical;
>         int addr;
>  
> -       /* Addresses are stored internally as addresses to 32 bytes blocks */
> -       addr = hwaddr << 5;
> +       /* Convert from FW internal address which is chip arch dependent */
> +       addr = wl->ops->convert_hwaddr(wl, hwaddr);

This could be more descriptive.  As I understand, this is converting an
internal representation of pointers in the hardware to an address that
can be used to set the partitions.



> diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
> index a664662..a8647bd 100644
> --- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
> +++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
> @@ -523,6 +523,4 @@ void wl1271_rx_filter_flatten_fields(struct wl12xx_rx_filter *filter,
>  #define HW_HT_RATES_OFFSET	16
>  #define HW_MIMO_RATES_OFFSET	24
>  
> -#define WL12XX_HW_BLOCK_SIZE	256

I think this should also be created separately for wl12xx and wl18xx
instead of deleting the macro and hardcoding the values.

--
Luca.

