Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:33072 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751574AbdDAQUM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 1 Apr 2017 12:20:12 -0400
Date: Sat, 1 Apr 2017 09:20:08 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Brian Norris <briannorris@chromium.org>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeffy Chen <jeffy.chen@rock-chips.com>
Subject: Re: [RFC PATCH] Revert "mwifiex: fix system hang problem after
 resume"
Message-ID: <20170401162008.GA17130@dtor-ws> (sfid-20170401_182035_505634_00662228)
References: <20170331202136.100342-1-briannorris@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170331202136.100342-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 31, 2017 at 01:21:36PM -0700, Brian Norris wrote:
> This reverts commit 437322ea2a36d112e20aa7282c869bf924b3a836.
> 
> This above-mentioned "fix" does not actually do anything to prevent a
> race condition. It simply papers over it so that the issue doesn't
> appear.
> 
> If this is a real problem, it should be explained better than the above
> commit does, and an alternative, non-racy solution should be found.
> 
> For further reason to revert this: there's ot reason we can't try
> resetting the card when it's *actually* stuck in host-sleep mode. So
> instead, this is unnecessarily creating scenarios where we can't recover
> Wifi.
> 
> Cc: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Brian Norris <briannorris@chromium.org>

FWIW:

Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

> ---
> Amit, please take a look. AIUI, your "fix" is wrong, and quite racy. If you
> still think it's needed, can you please propose an alternative? Or at least
> explain more why this is needed? Thanks.
> 
>  drivers/net/wireless/marvell/mwifiex/init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/init.c b/drivers/net/wireless/marvell/mwifiex/init.c
> index 756948385b60..0dab77b526de 100644
> --- a/drivers/net/wireless/marvell/mwifiex/init.c
> +++ b/drivers/net/wireless/marvell/mwifiex/init.c
> @@ -60,7 +60,7 @@ static void wakeup_timer_fn(unsigned long data)
>  	adapter->hw_status = MWIFIEX_HW_STATUS_RESET;
>  	mwifiex_cancel_all_pending_cmd(adapter);
>  
> -	if (adapter->if_ops.card_reset && !adapter->hs_activated)
> +	if (adapter->if_ops.card_reset)
>  		adapter->if_ops.card_reset(adapter);
>  }
>  
> -- 
> 2.12.2.564.g063fe858b8-goog
> 

-- 
Dmitry
