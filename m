Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:54112 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752773Ab1JJRwV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 13:52:21 -0400
Received: by mail-ey0-f174.google.com with SMTP id 27so1828326eye.5
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 10:52:19 -0700 (PDT)
Subject: Re: [PATCH 02/29] wl12xx: move last_tx_hlid into wlvif
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1318234397-21081-3-git-send-email-eliad@wizery.com>
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
	 <1318234397-21081-3-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Oct 2011 20:52:15 +0300
Message-ID: <1318269135.9690.369.camel@cumari> (sfid-20111010_195224_340049_9B38C38A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-10-10 at 10:12 +0200, Eliad Peller wrote: 
> move last_tx_hlid into the per-interface data, rather than
> being global.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---
>  drivers/net/wireless/wl12xx/debugfs.c |    1 -
>  drivers/net/wireless/wl12xx/main.c    |    1 -
>  drivers/net/wireless/wl12xx/tx.c      |   10 +++++-----
>  drivers/net/wireless/wl12xx/wl12xx.h  |    6 +++---
>  4 files changed, 8 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
> index f0398d0..bbc8004 100644
> --- a/drivers/net/wireless/wl12xx/debugfs.c
> +++ b/drivers/net/wireless/wl12xx/debugfs.c
> @@ -355,7 +355,6 @@ static ssize_t driver_state_read(struct file *file, char __user *user_buf,
>  	DRIVER_STATE_PRINT_INT(sg_enabled);
>  	DRIVER_STATE_PRINT_INT(enable_11a);
>  	DRIVER_STATE_PRINT_INT(noise);
> -	DRIVER_STATE_PRINT_INT(last_tx_hlid);
>  	DRIVER_STATE_PRINT_HEX(ap_fw_ps_map);
>  	DRIVER_STATE_PRINT_LHEX(ap_ps_map);
>  	DRIVER_STATE_PRINT_HEX(quirks);

No big deal at this point, so I'll apply this, but maybe we should print
the last_tx_hlid from inside all the vifs as well?

-- 
Cheers,
Luca.

