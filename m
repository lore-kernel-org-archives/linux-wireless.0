Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:37181 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903Ab3IJHrH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 03:47:07 -0400
Message-ID: <1378799252.4799.61.camel@porter.coelho.fi> (sfid-20130910_094710_861273_5E326AD2)
Subject: Re: [PATCH 11/12] wl18xx: print new RDL versions during boot
From: Luca Coelho <luca@coelho.fi>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 10 Sep 2013 10:47:32 +0300
In-Reply-To: <1378218848-7853-11-git-send-email-eliad@wizery.com>
References: <1378218848-7853-1-git-send-email-eliad@wizery.com>
	 <1378218848-7853-11-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-09-03 at 17:34 +0300, Eliad Peller wrote:
> From: Victor Goldenshtein <victorg@ti.com>
> 
> Extract and print info for the new RDL 5, 6, 7 and 8.
> Replace const struct with function which translates
> the RDL number to string.
> 
> Signed-off-by: Victor Goldenshtein <victorg@ti.com>
> Signed-off-by: Barak Bercovitz <barak@wizery.com>
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Why convert the array with a function? The array looks much cleaner to
me.

[...[
> diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
> index b47eb62..aef0c91 100644
> --- a/drivers/net/wireless/ti/wl18xx/main.c
> +++ b/drivers/net/wireless/ti/wl18xx/main.c
> @@ -1228,16 +1228,46 @@ static u32 wl18xx_ap_get_mimo_wide_rate_mask(struct wl1271 *wl,
>  	}
>  }
>  
> +static const char *wl18xx_rdl_name(enum wl18xx_rdl_num rdl_num)
> +{
> +	switch (rdl_num) {
> +	case RDL_1_HP:
> +	    return "183xH";
> +	case RDL_2_SP:
> +	    return "183x or 180x";
> +	case RDL_3_HP:
> +	    return "187xH";
> +	case RDL_4_SP:
> +	    return "187x";
> +	case RDL_5_SP:
> +	    return "RDL11 - Not Supported";
> +	case RDL_6_SP:
> +	    return "180xD";
> +	case RDL_7_SP:
> +	    return "RDL13 - Not Supported (1893Q)";
> +	case RDL_8_SP:
> +	    return "18xxQ";
> +	default:
> +	    return "UNTRIMMED";

This may become misleading if we get more RDLs versions in the future.
And the untrimmed case is probably reporting 0? Or something predefined,
hopefully, otherwise how can we know that we wouldn't randomly get a
valid value?

Also, in the unsupported cases, it would probably be better to bail out?

--
Luca.

