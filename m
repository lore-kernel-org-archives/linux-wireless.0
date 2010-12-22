Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:65249 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828Ab0LVUWR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 15:22:17 -0500
Subject: Re: [PATCH v2 01/18] wl1271: Add AP related configuration to
 conf_drv_settings
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1293028057-6212-2-git-send-email-arik@wizery.com>
References: <1293028057-6212-1-git-send-email-arik@wizery.com>
	 <1293028057-6212-2-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Dec 2010 22:22:14 +0200
Message-ID: <1293049334.14423.1.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-12-22 at 16:27 +0200, ext Arik Nemtsov wrote:
> Rate class configuration has been split up for AP and STA modes.
> Template related configuration likewise separated.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

[...]

> @@ -153,6 +153,45 @@ static struct conf_drv_settings default_conf = {
>  				.tx_op_limit = 1504,
>  			},
>  		},
> +		.ap_rc_conf                  = {
> +			[0] = {
> +				.enabled_rates = 0x1EFF,
> +				.short_retry_limit = 10,
> +				.long_retry_limit = 10,
> +				.aflags      = 0,
> +			},
> +			[1] = {
> +				.enabled_rates = 0x1EFF,
> +				.short_retry_limit = 10,
> +				.long_retry_limit = 10,
> +				.aflags      = 0,
> +			},
> +			[2] = {
> +				.enabled_rates = 0x1EFF,
> +				.short_retry_limit = 10,
> +				.long_retry_limit = 10,
> +				.aflags      = 0,
> +			},
> +			[3] = {
> +				.enabled_rates = 0x1EFF,
> +				.short_retry_limit = 10,
> +				.long_retry_limit = 10,
> +				.aflags      = 0,
> +			},
> +		},
> +		.ap_mgmt_conf = {
> +			.enabled_rates       = 0x7,
> +			.short_retry_limit   = 10,
> +			.long_retry_limit    = 10,
> +			.aflags              = 0,
> +		},
> +		.ap_bcst_conf = {
> +			.enabled_rates       = 0x1,
> +			.short_retry_limit   = 10,
> +			.long_retry_limit    = 10,
> +			.aflags              = 0,
> +		},
> +

All the enabled_rates values here look quite magic.  Is there any way
these could be changed to macros or something more descriptive?

Also, how do you deal with the different basic rates used by 11bg and
11a?

-- 
Cheers,
Luca.

