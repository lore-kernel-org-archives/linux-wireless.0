Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49175 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756550Ab2IFPCd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2012 11:02:33 -0400
Message-ID: <1346943788.5469.12.camel@jlt4.sipsolutions.net> (sfid-20120906_170237_197472_7971BC8C)
Subject: Re: [PATCH/RFC] rfkill: prevent unnecessary event generation
From: Johannes Berg <johannes@sipsolutions.net>
To: Vitaly Wool <vitaly.wool@sonymobile.com>
Cc: linux-wireless@vger.kernel.org, vitalywool@gmail.com
Date: Thu, 06 Sep 2012 17:03:08 +0200
In-Reply-To: <5048ADFC.1010708@sonymobile.com> (sfid-20120906_161659_043721_12893A62)
References: <5048ADFC.1010708@sonymobile.com>
	 (sfid-20120906_161659_043721_12893A62)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-09-06 at 16:06 +0200, Vitaly Wool wrote:
> Prevent unnecessary rfkill event generation when the state has
> not actually changed. These events have to be delivered to
> relevant userspace processes, causing these processes to wake
> up and do something while they could as well have slept. This
> obviously results in more CPU usage, longer time-to-sleep-again
> and therefore higher power consumption.
> 
> Signed-off-by: Vitaly Wool <vitalywool@gmail.com>
> Signed-off-by: Mykyta Iziumtsev <nikita.izyumtsev@gmail.com>

Looks fine to me, should I just pick it up?

johannes


> ---
>   net/rfkill/core.c |    8 +++++++-
>   1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/net/rfkill/core.c b/net/rfkill/core.c
> index 752b723..520617c 100644
> --- a/net/rfkill/core.c
> +++ b/net/rfkill/core.c
> @@ -256,6 +256,7 @@ static bool __rfkill_set_hw_state(struct rfkill *rfkill,
>   static void rfkill_set_block(struct rfkill *rfkill, bool blocked)
>   {
>   	unsigned long flags;
> +	bool prev, curr;
>   	int err;
>   
>   	if (unlikely(rfkill->dev.power.power_state.event & PM_EVENT_SLEEP))
> @@ -270,6 +271,8 @@ static void rfkill_set_block(struct rfkill *rfkill, bool blocked)
>   		rfkill->ops->query(rfkill, rfkill->data);
>   
>   	spin_lock_irqsave(&rfkill->lock, flags);
> +	prev = rfkill->state & RFKILL_BLOCK_SW;
> +
>   	if (rfkill->state & RFKILL_BLOCK_SW)
>   		rfkill->state |= RFKILL_BLOCK_SW_PREV;
>   	else
> @@ -299,10 +302,13 @@ static void rfkill_set_block(struct rfkill *rfkill, bool blocked)
>   	}
>   	rfkill->state &= ~RFKILL_BLOCK_SW_SETCALL;
>   	rfkill->state &= ~RFKILL_BLOCK_SW_PREV;
> +	curr = rfkill->state & RFKILL_BLOCK_SW;
>   	spin_unlock_irqrestore(&rfkill->lock, flags);
>   
>   	rfkill_led_trigger_event(rfkill);
> -	rfkill_event(rfkill);
> +
> +	if (prev != curr)
> +		rfkill_event(rfkill);
>   }
>   
>   #ifdef CONFIG_RFKILL_INPUT


