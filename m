Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:47225 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752709Ab1DAIwu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 04:52:50 -0400
Received: by mail-wy0-f173.google.com with SMTP id 42so3210709wyb.32
        for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2011 01:52:49 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: Set correct REF CLK and TCXO CLK values to the
 FW
From: Luciano Coelho <coelho@ti.com>
To: Shahar Levi <shahar_levi@ti.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1301297691-27665-1-git-send-email-shahar_levi@ti.com>
References: <1301297691-27665-1-git-send-email-shahar_levi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Apr 2011 11:48:54 +0300
Message-ID: <1301647734.1988.441.camel@cumari>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-03-28 at 09:34 +0200, Shahar Levi wrote:
> Set the correct values to the FW of REF CLK and TCXO CLK from
> wl12xx_platform_data to ini_general_params.
> 
> Signed-off-by: Shahar Levi <shahar_levi@ti.com>
> ---

Please rephrase the commit message.  Say why we need to do this.  The
reason is that we don't want to have a mismatch between the information
that is set in the platform data and the NVS, so we override what comes
from the NVS and replace it with what comes from the platform data.


> diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
> index 2468044..beb9f88 100644
> --- a/drivers/net/wireless/wl12xx/cmd.c
> +++ b/drivers/net/wireless/wl12xx/cmd.c
> @@ -129,6 +129,9 @@ int wl1271_cmd_general_parms(struct wl1271 *wl)
>  	if (gp->tx_bip_fem_auto_detect)
>  		answer = true;
>  
> +	/* Set the ref CLK value */
> +	gen_parms->general_params.ref_clock = wl->ref_clock;
> +

The comment is too obvious.  I think it's better if you say "Override
the REF CLK from the NVS with the one from platform data".


> @@ -168,6 +171,13 @@ int wl128x_cmd_general_parms(struct wl1271 *wl)
>  	if (gp->tx_bip_fem_auto_detect)
>  		answer = true;
>  
> +	/*
> +	 * Set the ref CLK & TCXO values.
> +	 * The HW will know which of them is the valid one due to boot setting.
> +	 */
> +	gen_parms->general_params.ref_clock = wl->ref_clock;
> +	gen_parms->general_params.tcxo_ref_clock = wl->tcxo_clock;
> +

Same here.  Please rewrite the comment.  And "The HW will know which
one..." is irrelevant here, please remove.

-- 
Cheers,
Luca.

