Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:54729 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753099Ab1CHNLR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2011 08:11:17 -0500
Received: by mail-ww0-f51.google.com with SMTP id 40so871110wwj.8
        for <linux-wireless@vger.kernel.org>; Tue, 08 Mar 2011 05:11:16 -0800 (PST)
Subject: Re: [PATCH 06/15] wl12xx: 1281/1283 support - New boot sequence
From: Luciano Coelho <coelho@ti.com>
To: Shahar Levi <shahar_levi@ti.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1299421940-26292-7-git-send-email-shahar_levi@ti.com>
References: <1299421940-26292-1-git-send-email-shahar_levi@ti.com>
	 <1299421940-26292-7-git-send-email-shahar_levi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Mar 2011 15:11:16 +0200
Message-ID: <1299589876.1816.67.camel@cumari>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-03-06 at 16:32 +0200, Shahar Levi wrote:
> -       clk |= (wl->ref_clock << 1) << 4;
> +       if (wl->chip.id == CHIP_ID_1283_PG20) {
> +               if (is_ref_clk == false)
> +                       clk |= ((wl->tcxo_clock & 0x3) << 1) << 4;
> +               else
> +                       clk |= ((wl->ref_clock & 0x3) << 1) << 4;
> +       } else
> +               clk |= ((wl->ref_clock & 0x3) << 1) << 4;
> +
>         wl1271_write32(wl, DRPW_SCRATCH_START, clk); 

Can you explain why you changed the wl127x part as well? For wl127x
you're essentially changing:

clk |= (wl->ref_clock << 1) << 4;

to:

clk |= ((wl->ref_clock & 0x3) << 1) << 4;

This means that CONF_REF_CLK_38_4_M_XTAL will be treated in the same way
as CONF_REF_CLK_19_2_E.  Is that right? If it is, it must be addressed
in a separate patch and not as part of the Quattro series.


-- 
Cheers,
Luca.

