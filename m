Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:40012 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752918Ab1DFSNx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2011 14:13:53 -0400
Received: by mail-vw0-f50.google.com with SMTP id 14so1843530vws.23
        for <linux-wireless@vger.kernel.org>; Wed, 06 Apr 2011 11:13:50 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: FM WLAN coexistence
From: Luciano Coelho <coelho@ti.com>
To: Shahar Levi <shahar_levi@ti.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1301900860-19337-1-git-send-email-shahar_levi@ti.com>
References: <1301900860-19337-1-git-send-email-shahar_levi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Apr 2011 11:13:32 -0700
Message-ID: <1302113612.2366.34.camel@pimenta>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-04-04 at 10:07 +0300, Shahar Levi wrote:
> Add support to FM WLAN coexistence (STA only).
> Few WiFi harmonics may interfere FM operation, to
> avoid this problem special coexistence techniques are
> activated around some FM frequencies.
> 
> Signed-off-by: Shahar Levi <shahar_levi@ti.com>
> ---

Some comments.


> diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
> index e005aa4..5f5afbe 100644
> --- a/drivers/net/wireless/wl12xx/acx.c
> +++ b/drivers/net/wireless/wl12xx/acx.c
> @@ -1604,3 +1604,45 @@ out:
>  	kfree(acx);
>  	return ret;
>  }
> +
> +int wl1271_acx_fm_coex(struct wl1271 *wl)
> +{
> +	struct wl1271_acx_fm_coex *acx;
> +	int ret;
> +
> +	wl1271_debug(DEBUG_ACX, "acx fm coex setting");
> +
> +	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
> +	if (!acx) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	acx->enable = wl->conf.fm_coex.enable;
> +	acx->swallow_period = wl->conf.fm_coex.swallow_period;
> +	acx->n_divider_fref_set_1 = wl->conf.fm_coex.n_divider_fref_set_1;
> +	acx->n_divider_fref_set_2 = wl->conf.fm_coex.n_divider_fref_set_2;
> +	acx->m_divider_fref_set_1 =
> +		cpu_to_le16(wl->conf.fm_coex.m_divider_fref_set_1);
> +	acx->m_divider_fref_set_2 =
> +		cpu_to_le16(wl->conf.fm_coex.m_divider_fref_set_2);
> +	acx->coex_pll_stabilization_time =
> +		cpu_to_le32(wl->conf.fm_coex.coex_pll_stabilization_time);

> +	acx->ldo_stabilization_timwl12xx-fm-coex-v2/e =
> +		cpu_to_le16(wl->conf.fm_coex.ldo_stabilization_time);

What's this? There is some garbage pasted into this statement here!


> diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
> index 0a40cae..45242db 100644
> --- a/drivers/net/wireless/wl12xx/acx.h
> +++ b/drivers/net/wireless/wl12xx/acx.h
> @@ -1172,6 +1172,65 @@ struct wl1271_acx_inconnection_sta {
>  	u8 padding1[2];
>  } __packed;
>  
> +/*
> + * ACX_FM_COEX_CFG
> + * set the FM co-existence parameters.
> + */
> +struct wl1271_acx_fm_coex {
> +	struct acx_header header;
> +	/* enable(1) / disable(0) the FM Coex feature */
> +	u8 enable;
> +	/*
> +	 * Swallow period used in COEX PLL swallowing mechanism.
> +	 * 0xFF = use FW default
> +	 */
> +	u8 swallow_period;
> +	/*
> +	 * The N divider used in COEX PLL swallowing mechanism for Fref of
> +	 * 38.4/19.2 Mhz. 0xFF = use FW default
> +	 */
> +	u8 n_divider_fref_set_1;
> +	/*
> +	 * The N divider used in COEX PLL swallowing mechanism for Fref of
> +	 * 26/52 Mhz. 0xFF = use FW default
> +	 */
> +	u8 n_divider_fref_set_2;
> +	/*
> +	 * The M divider used in COEX PLL swallowing mechanism for Fref of
> +	 * 38.4/19.2 Mhz. 0xFFFF = use FW default
> +	 */
> +	u16 m_divider_fref_set_1;

This must be __le16.


> +	/*
> +	 * The M divider used in COEX PLL swallowing mechanism for Fref of
> +	 * 26/52 Mhz. 0xFFFF = use FW default
> +	 */
> +	u16 m_divider_fref_set_2;

Same here.


> +	/*
> +	 * The time duration in uSec required for COEX PLL to stabilize.
> +	 * 0xFFFFFFFF = use FW default
> +	 */
> +	u32 coex_pll_stabilization_time;

__le32


> +	/*
> +	 * The time duration in uSec required for LDO to stabilize.
> +	 * 0xFFFFFFFF = use FW default
> +	 */
> +	u16 ldo_stabilization_time;

__le16


-- 
Cheers,
Luca.

