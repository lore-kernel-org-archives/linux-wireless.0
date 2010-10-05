Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-sa02.nokia.com ([147.243.1.48]:22049 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822Ab0JELsV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 07:48:21 -0400
Received: from nokia.com (localhost [127.0.0.1])
	by mgw-sa02.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id o95BmIo5003490
	for <linux-wireless@vger.kernel.org>; Tue, 5 Oct 2010 14:48:18 +0300
Subject: Re: [PATCHv2] wl1271: Add extended radio parameter initialization
From: Luciano Coelho <luciano.coelho@nokia.com>
To: "juuso.oikarinen@nokia.com" <juuso.oikarinen@nokia.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1286277116-22486-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1286277116-22486-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Oct 2010 14:47:54 +0300
Message-ID: <1286279274.15401.21.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-10-05 at 13:11 +0200, juuso.oikarinen@nokia.com wrote:
> From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> 
> Currently a command to initialize extended radio parameter tables in the
> hardware is missing.
> 
> Add the initialization
> 
> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> ---
> v2: change the name of the length macro for the TX power compensation table

Thanks for fixing it, it looks clearer now.

Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>

A couple of comments below.

[...]

> diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.h b/drivers/net/wireless/wl12xx/wl1271_cmd.h
> index 33b946b..4e8b464 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_cmd.h
> +++ b/drivers/net/wireless/wl12xx/wl1271_cmd.h

[...]

> @@ -363,6 +365,16 @@ struct wl1271_radio_parms_cmd {
>  	u8 padding3[2];
>  } __packed;
>  
> +struct wl1271_ext_radio_parms_cmd {
> +	struct wl1271_cmd_header header;
> +
> +	struct wl1271_cmd_test_header test;
> +
> +	u8 tx_per_channel_power_compensation_2[CONF_TX_PWR_COMPENSATION_LEN_2];
> +	u8 tx_per_channel_power_compensation_5[CONF_TX_PWR_COMPENSATION_LEN_5];
> +	u8 padding[3];
> +} __attribute__ ((packed));
> +

This should be __packed nowadays.  But I'll change that before applying
the patch, so no need to resend.

[...]

> diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
> index cb18f22..8d33a2b 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_main.c
> +++ b/drivers/net/wireless/wl12xx/wl1271_main.c
> @@ -242,6 +242,16 @@ static struct conf_drv_settings default_conf = {
>  		.max_dwell_time_passive       = 60000,
>  		.num_probe_reqs               = 2,
>  	},
> +	.rf = {
> +		.tx_per_channel_power_compensation_2 = {
> +			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +		},
> +		.tx_per_channel_power_compensation_5 = {
> +			0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +			0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +			0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +		},
> +	},
>  };

I guess we should not hardcode this in the driver, but add it to the NVS
file.  But let's think about that later, because we need to agree on
changing the NVS structure first.


-- 
Cheers,
Luca.

