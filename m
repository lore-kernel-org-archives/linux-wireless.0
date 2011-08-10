Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:60603 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751343Ab1HJMbZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 08:31:25 -0400
Received: by mail-bw0-f50.google.com with SMTP id zu5so405384bkb.23
        for <linux-wireless@vger.kernel.org>; Wed, 10 Aug 2011 05:31:23 -0700 (PDT)
Subject: Re: [PATCH 15/40] wl12xx: add set_rate_mgmt_params acx
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1312881233-9366-16-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
	 <1312881233-9366-16-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Aug 2011 15:31:19 +0300
Message-ID: <1312979479.2407.578.camel@cumari> (sfid-20110810_143128_239228_61F0BC1F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-09 at 12:13 +0300, Eliad Peller wrote: 
> +int wl1271_acx_set_rate_mgmt_params(struct wl1271 *wl)
> +{
> +	struct wl1271_acx_set_rate_mgmt_params *acx = NULL;
> +	struct conf_rate_policy_settings *conf = &wl->conf.rate;
> +	int ret;
> +
> +	wl1271_debug(DEBUG_ACX, "acx set rate mgmt params");
> +	BUILD_BUG_ON(sizeof(conf->rate_retry_policy) !=
> +		     sizeof(acx->rate_retry_policy));
> +	BUILD_BUG_ON(sizeof(*acx) % 4);

I guess you shouldn't need these anymore?


> +	ret = wl1271_cmd_configure(wl, ACX_SET_RATE_MAMAGEMENT_PARAMS,

Typo, should be MANAGEMENT.  This should be fixed already where
declared, in patch 07.


> +#define ACX_RATE_MGMT_ALL_PARAMS 0xff
> +#define ACX_RATE_MGMT_NUM_OF_RATES 13
> +struct wl1271_acx_set_rate_mgmt_params {
> +	struct acx_header header;
> +
> +	/* the param we configure */

This comment doesn't seem very meaningful.


> +	u8 index;
> +	u8 padding1; /* MISSING */
> +	__le16 rate_retry_score;
> +	__le16 per_add;
> +	__le16 per_th1;
> +	__le16 per_th2;
> +	__le16 max_per;
> +	u8 inverse_curiosity_factor;
> +	u8 tx_fail_low_th;
> +	u8 tx_fail_high_th;
> +	u8 per_alpha_shift;
> +	u8 per_add_shift;
> +	u8 per_beta1_shift;
> +	u8 per_beta2_shift;
> +	u8 rate_check_up;
> +	u8 rate_check_down;
> +	u8 rate_retry_policy[ACX_RATE_MGMT_NUM_OF_RATES];
> +	u8 padding2[2]; /* MISSING */
> +} __packed;

Now that you found what was MISSING, please remove from here and inform
the firmware people so they can fix it on their side.


> @@ -1324,9 +1343,10 @@ struct conf_drv_settings {
>  	struct conf_memory_settings mem_wl127x;
>  	struct conf_memory_settings mem_wl128x;
>  	struct conf_fm_coex fm_coex;
>  	struct conf_rx_streaming_settings rx_streaming;
>  	struct conf_fwlog fwlog;
>  	u8 hci_io_ds;
> +	struct conf_rate_policy_settings rate;
>  };

The new struct could come before hci_io_ds, since there's no need to
keep backwards compatibility here yet.


-- 
Cheers,
Luca.

