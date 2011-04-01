Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:43580 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754231Ab1DAKnE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 06:43:04 -0400
Received: by eye27 with SMTP id 27so1335303eye.34
        for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2011 03:42:54 -0700 (PDT)
Subject: Re: [PATCH 1/5] wl12xx: Clean up and fix the 128x boot sequence
From: Luciano Coelho <coelho@ti.com>
To: Ido Yariv <ido@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1301558821-17787-2-git-send-email-ido@wizery.com>
References: <1301558821-17787-1-git-send-email-ido@wizery.com>
	 <1301558821-17787-2-git-send-email-ido@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Apr 2011 13:43:31 +0300
Message-ID: <1301654611.1988.475.camel@cumari>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-03-31 at 10:06 +0200, Ido Yariv wrote:
> Clean up the boot sequence code & fix the following issues:
> 1. Always read the registers' values and set the relevant bits instead of
>    zeroing all other bits
> 2. Handle cases where wl1271_top_reg_read returns an error
> 3. Verify that the HW can detect the selected clock source
> 4. Remove 128x PG10 initialization code
> 5. Configure the MCS PLL to work in HP mode
> 
> Signed-off-by: Ido Yariv <ido@wizery.com>
> ---

This looks nice! Much easier to read now.  I checked it with the version
of the system initialization procedures that I got and it looks correct.
Except for some extra register reads in the two validation functions.  I
think I don't have the latest version of the initialization document,
since you mentioned to Shahar that in the one you have those registers
are read.

Anyway, this is fine, as you mentioned, reading the registers shouldn't
cause any problems here.

Reviewed-by: Luciano Coelho <coelho@ti.com>

And applied, thanks!

A couple of small comments below...


> +	/* Mask bits [2] & [8:4] in the sys_clk_cfg register */
> +	spare_reg = wl1271_top_reg_read(wl, WL_SPARE_REG);
> +	if (spare_reg == 0xFFFF)
> +		return -EFAULT;
> +	spare_reg |= (BIT(3) | BIT(5) | BIT(6));
> +	wl1271_top_reg_write(wl, WL_SPARE_REG, spare_reg);

The comments of masking bits 2 and 8-4 is quite cryptic here.  You
actually set bits 3, 5 and 6, so from the driver point of view the
comment doesn't make much sense.  Since it's in the initialization
document, I guess it's something the firmware does internally.  This
should be removed, but I'll keep it for now.


> +	/* Mask bits [3:1] in the sys_clk_cfg register */
> +	spare_reg = wl1271_top_reg_read(wl, WL_SPARE_REG);
> +	if (spare_reg == 0xFFFF)
> +		return -EFAULT;
> +	spare_reg |= BIT(2);
> +	wl1271_top_reg_write(wl, WL_SPARE_REG, spare_reg);

Same here, the comment is quite cryptic.  Also, the "sys_clk_cfg
register" is wrong, it should be in the "spare register".  In any case,
let's keep this comment for now, since it's a good way to map what is
going on with the system documentation.  Let's remove them later (maybe
a patch to remove all such information that is still spread around the
driver?).


> +	/* Set the input frequency according to the selected clock source */
> +	input_freq = (clk & 1) + 1;

Nice trick! :) Maybe some comments about what actually happens here
would have been nice, though.


-- 
Cheers,
Luca.

