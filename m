Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:41390 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535Ab2K0N0F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 08:26:05 -0500
Message-ID: <1354022725.950.103.camel@cumari.coelho.fi> (sfid-20121127_142611_209340_B42702DD)
Subject: Re: [PATCH 10/20] wl18xx: FDSP Code RAM Corruption fix
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
CC: <linux-wireless@vger.kernel.org>, Ido Reis <idor@ti.com>
Date: Tue, 27 Nov 2012 15:25:25 +0200
In-Reply-To: <1353998701-18171-11-git-send-email-arik@wizery.com>
References: <1353998701-18171-1-git-send-email-arik@wizery.com>
	 <1353998701-18171-11-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-27 at 08:44 +0200, Arik Nemtsov wrote:
> From: Ido Reis <idor@ti.com>
> 
> In PG2.0 there is an issue where PHY's FDSP Code RAM sometimes gets
> corrupted when exiting from ELP mode. This issue is related to FDSP
> Code RAM clock implementation.
> 
> PG2.1 introduces a HW fix for this issue that requires the driver to
> change the FDSP Code Ram clock settings (mux it to ATGP clock instead
> of its own clock).
> 
> This workaround uses PHY_FPGA_SPARE_1 register and is relevant to WL8
> PG2.1 devices.
> 
> The fix is also backward compatible with older PG2.0 devices where the
> register PHY_FPGA_SPARE_1 is not used and not connected.
> 
> The fix is done in the wl18xx_pre_upload function (must be performed
> before uploading the FW code) and includes the following steps:
> 
> 1. Disable FDSP clock
> 2. Set ATPG clock toward FDSP Code RAM rather than its own clock.
> 3. Re-enable FDSP clock
> 
> Signed-off-by: Yair Shapira <yair.shapira@ti.com>
> Signed-off-by: Ido Reis <idor@ti.com>
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

Same question as before... Who's the actual author?
 

> diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
> index 4f3c142..8fd13f3 100644
> --- a/drivers/net/wireless/ti/wl18xx/main.c
> +++ b/drivers/net/wireless/ti/wl18xx/main.c
> @@ -559,6 +559,9 @@ static struct wl18xx_priv_conf wl18xx_default_priv_conf = {
>  	},
>  };
>  
> +#define WL18XX_PHY_INIT_MEM_SIZE \
> +	(WL18XX_PHY_END_MEM_ADDR - WL18XX_PHY_INIT_MEM_ADDR + 4)
> +

This is ugly.  Where does the 4 come from?


> @@ -585,8 +588,8 @@ static const struct wlcore_partition_set wl18xx_ptable[PART_TABLE_LEN] = {
>  		.mem3 = { .start = 0x00000000, .size  = 0x00000000 },
>  	},
>  	[PART_PHY_INIT] = {
> -		.mem  = { .start = 0x80926000,
> -			  .size = sizeof(struct wl18xx_mac_and_phy_params) },
> +		.mem  = { .start = WL18XX_PHY_INIT_MEM_ADDR,
> +			  .size = WL18XX_PHY_INIT_MEM_SIZE },
>  		.reg  = { .start = 0x00000000, .size = 0x00000000 },
>  		.mem2 = { .start = 0x00000000, .size = 0x00000000 },
>  		.mem3 = { .start = 0x00000000, .size = 0x00000000 },
> @@ -787,6 +790,9 @@ static int wl18xx_pre_upload(struct wl1271 *wl)
>  	u32 tmp;
>  	int ret;
>  
> +	BUILD_BUG_ON(sizeof(struct wl18xx_mac_and_phy_params) >
> +		WL18XX_PHY_INIT_MEM_SIZE);

Why can't we just add the spare to the end of the mac_and_phy structure
and avoid all this hassle?

Is it because something will break if we write the same register again
with the mac_and_phy block during the wl18xx_set_mac_and_phy() call?


> @@ -803,6 +809,30 @@ static int wl18xx_pre_upload(struct wl1271 *wl)
>  	wl1271_debug(DEBUG_BOOT, "chip id 0x%x", tmp);
>  
>  	ret = wlcore_read32(wl, WL18XX_SCR_PAD2, &tmp);
> +	if (ret < 0)
> +		goto out;
> +
> +	/* Set ATPG clock toward FDSP Code RAM rather than its own clock */

This seems to be out of place.


> +	/* Disable FDSP clock */
> +
> +	ret = wlcore_set_partition(wl, &wl->ptable[PART_PHY_INIT]);
> +	if (ret < 0)
> +		goto out;
> +
> +	ret = wlcore_write32(wl, WL18XX_PHY_FPGA_SPARE_1,
> +			     MEM_FDSP_CLK_120_DISABLE);
> +	if (ret < 0)
> +		goto out;
> +
> +	/* Set ATPG clock toward FDSP Code RAM rather than its own clock */
> +	ret = wlcore_write32(wl, WL18XX_PHY_FPGA_SPARE_1,
> +			     MEM_FDSP_CODERAM_FUNC_CLK_SEL);

This looks strange.  We're writing this value to the same register where
we disable and enable the clock.  Is this really how it's supposed to
be?



> +	if (ret < 0)
> +		goto out;
> +
> +	/* Re-enable FDSP clock */
> +	ret = wlcore_write32(wl, WL18XX_PHY_FPGA_SPARE_1,
> +			     MEM_FDSP_CLK_120_ENABLE);
>  
>  out:
>  	return ret;
> diff --git a/drivers/net/wireless/ti/wl18xx/reg.h b/drivers/net/wireless/ti/wl18xx/reg.h
> index 937b71d..ed35519 100644
> --- a/drivers/net/wireless/ti/wl18xx/reg.h
> +++ b/drivers/net/wireless/ti/wl18xx/reg.h
> @@ -188,4 +188,24 @@ enum {
>  	NUM_BOARD_TYPES,
>  };
>  
> +/*
> + * The following definitions are used to change the PHY ATPG clock towards
> + * FDSP code RAM. This is done during FW boot before we download the FW.
> + *
> + * This change is required by PG2.1 and has not impact on previous PGs.
> + */

This explanation is about the action not about the definitions here.  It
would be better to have it in the pre_upload() function instead.

--
Luca.

