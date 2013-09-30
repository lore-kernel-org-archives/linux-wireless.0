Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:52465 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755559Ab3I3RDC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Sep 2013 13:03:02 -0400
Message-ID: <1380560235.32539.4.camel@paschendale> (sfid-20130930_190311_167143_25B43DD0)
Subject: Re: [PATCH v2 10/11] wl18xx: print new RDL versions during boot
From: Luca Coelho <luca@coelho.fi>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 30 Sep 2013 19:57:15 +0300
In-Reply-To: <1379432490-22157-10-git-send-email-eliad@wizery.com>
References: <1379432490-22157-1-git-send-email-eliad@wizery.com>
	 <1379432490-22157-10-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-09-17 at 18:41 +0300, Eliad Peller wrote:
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
> v1->v2: split UNTRIMMED/UNKNOWN
> 
>  drivers/net/wireless/ti/wl18xx/main.c | 42 ++++++++++++++++++++++++++++++-----
>  drivers/net/wireless/ti/wl18xx/reg.h  | 20 ++++++++---------
>  2 files changed, 46 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
> index b47eb62..d0daca1 100644
> --- a/drivers/net/wireless/ti/wl18xx/main.c
> +++ b/drivers/net/wireless/ti/wl18xx/main.c
> @@ -1228,16 +1228,48 @@ static u32 wl18xx_ap_get_mimo_wide_rate_mask(struct wl1271 *wl,
>  	}
>  }
>  
> +static const char *wl18xx_rdl_name(enum wl18xx_rdl_num rdl_num)
> +{
> +	switch (rdl_num) {
> +	case RDL_1_HP:
> +		return "183xH";
> +	case RDL_2_SP:
> +		return "183x or 180x";
> +	case RDL_3_HP:
> +		return "187xH";
> +	case RDL_4_SP:
> +		return "187x";
> +	case RDL_5_SP:
> +		return "RDL11 - Not Supported";
> +	case RDL_6_SP:
> +		return "180xD";
> +	case RDL_7_SP:
> +		return "RDL13 - Not Supported (1893Q)";
> +	case RDL_8_SP:
> +		return "18xxQ";
> +	case RDL_NONE:
> +		return "UNTRIMMED";
> +	default:
> +		return "UNKNOWN";
> +	}
> +}

I see you kept the function.  I prefer the array, but I'm not going to
block this patch for such a small thing. ;)

It looks better now, with the untrimmed case separate from unknown.

--
Luca.

