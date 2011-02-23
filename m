Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:38423 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751954Ab1BWOdY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Feb 2011 09:33:24 -0500
Received: by mail-ww0-f45.google.com with SMTP id 40so684225wwj.2
        for <linux-wireless@vger.kernel.org>; Wed, 23 Feb 2011 06:33:22 -0800 (PST)
Subject: Re: [PATCH] WLAN: fix the path to the wl12xx firmwares
From: Luciano Coelho <coelho@ti.com>
To: Sebastien Jan <s-jan@ti.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1298467516-9092-1-git-send-email-s-jan@ti.com>
References: <1298467516-9092-1-git-send-email-s-jan@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Feb 2011 16:33:19 +0200
Message-ID: <1298471599.2104.44.camel@pimenta>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sebastien,

On Wed, 2011-02-23 at 14:25 +0100, Sebastien Jan wrote:
> Validated FW loading on a Ubuntu Natty alpha image, on a pandaboard
> (embedding a WL1271).
> 
> Signed-off-by: Sebastien Jan <s-jan@ti.com>
> ---

Thanks for working on getting the wl12xx driver to work on the
pandaboard!

> diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
> index 9050dd9..8ceb6a0 100644
> --- a/drivers/net/wireless/wl12xx/wl12xx.h
> +++ b/drivers/net/wireless/wl12xx/wl12xx.h
> @@ -112,8 +112,8 @@ extern u32 wl12xx_debug_level;
>  				  CFG_RX_CTL_EN | CFG_RX_BCN_EN |     \
>  				  CFG_RX_AUTH_EN | CFG_RX_ASSOC_EN)
>  
> -#define WL1271_FW_NAME "wl1271-fw.bin"
> -#define WL1271_NVS_NAME "wl1271-nvs.bin"
> +#define WL1271_FW_NAME "ti-connectivity/wl1271-fw.bin"
> +#define WL1271_NVS_NAME "ti-connectivity/wl1271-nvs.bin"

You're right.  Our firmware is (unfortunately) inside the
ti-connectivity in linux-firmware.git.  So it would make sense to
include the ti-connectivity/ directory when requesting for the firmware,
but it's just damn ugly. :( The driver should not care at all where the
firmware is to be fetched from, that should be up to the userspace.

Dunno what is the best thing to do about this.  Add the directory to the
driver? Move the wl1271*.bin files to the root of linux-firmware? Does
anybody have opinions about it?

-- 
Cheers,
Luca.

