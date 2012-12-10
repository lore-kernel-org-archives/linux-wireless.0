Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:44122 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487Ab2LJRH3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 12:07:29 -0500
Message-ID: <1355159205.3738.63.camel@cumari.coelho.fi> (sfid-20121210_180735_323165_68646BA4)
Subject: Re: [PATCH 20/20] wlcore: Always pass DMA-able buffers to mmc
 functions
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
CC: <linux-wireless@vger.kernel.org>, Ido Yariv <ido@wizery.com>
Date: Mon, 10 Dec 2012 19:06:45 +0200
In-Reply-To: <1354095769-8724-21-git-send-email-arik@wizery.com>
References: <1354095769-8724-1-git-send-email-arik@wizery.com>
	 <1354095769-8724-21-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-11-28 at 11:42 +0200, Arik Nemtsov wrote:
> From: Ido Yariv <ido@wizery.com>
> 
> Some of the mmc drivers initiate DMA transfers with buffers passed from
> higher layers. This means that the driver shouldn't ever pass non
> DMA-able buffers, such as ones that are unaligned, allocated on the
> stack or static.
> 
> Fix a couple of calls to the mmc layer in which buffers which weren't
> necessarily DMA-able were passed.
> 
> Signed-off-by: Ido Yariv <ido@wizery.com>
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

[...]

> diff --git a/drivers/net/wireless/ti/wlcore/io.h b/drivers/net/wireless/ti/wlcore/io.h
> index 5897747..70f9bdc 100644
> --- a/drivers/net/wireless/ti/wlcore/io.h
> +++ b/drivers/net/wireless/ti/wlcore/io.h
> @@ -105,13 +105,12 @@ static inline int __must_check wlcore_raw_read32(struct wl1271 *wl, int addr,
>  {
>  	int ret;
>  
> -	ret = wlcore_raw_read(wl, addr, &wl->buffer_32,
> -			      sizeof(wl->buffer_32), false);
> +	ret = wlcore_raw_read(wl, addr, wl->buffer_32, sizeof(u32), false);
>  	if (ret < 0)
>  		return ret;
>  
>  	if (val)
> -		*val = le32_to_cpu(wl->buffer_32);
> +		*val = le32_to_cpu(*wl->buffer_32);
>  
>  	return 0;
>  }
> @@ -119,9 +118,8 @@ static inline int __must_check wlcore_raw_read32(struct wl1271 *wl, int addr,
>  static inline int __must_check wlcore_raw_write32(struct wl1271 *wl, int addr,
>  						  u32 val)
>  {
> -	wl->buffer_32 = cpu_to_le32(val);
> -	return wlcore_raw_write(wl, addr, &wl->buffer_32,
> -				sizeof(wl->buffer_32), false);
> +	*wl->buffer_32 = cpu_to_le32(val);
> +	return wlcore_raw_write(wl, addr, wl->buffer_32, sizeof(u32), false);
>  }
>  
>  static inline int __must_check wlcore_read(struct wl1271 *wl, int addr,
> diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
> index 1793a82..e4ff66a 100644
> --- a/drivers/net/wireless/ti/wlcore/main.c
> +++ b/drivers/net/wireless/ti/wlcore/main.c
> @@ -5890,8 +5890,17 @@ struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size, u32 aggr_buf_size,
>  		goto err_fwlog;
>  	}
>  
> +	wl->buffer_32 = kmalloc(sizeof(u32), GFP_KERNEL);
> +	if (!wl->buffer_32) {
> +		ret = -ENOMEM;
> +		goto err_mbox;
> +	}
> +
>  	return hw;
>  
> +err_mbox:
> +	kfree(wl->mbox);
> +
>  err_fwlog:
>  	free_page((unsigned long)wl->fwlog);


Can't we change sizeof(u32) to sizeof(__le32) or sizeof(*wl->buffer_32)
just for consistency?

I'll change it to the latter if you agree.

--
Luca.

