Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59527 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753751Ab2IFWox (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2012 18:44:53 -0400
Date: Thu, 6 Sep 2012 19:44:48 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Vitaly Wool <vitaly.wool@sonymobile.com>
Cc: linux-wireless@vger.kernel.org, vitalywool@gmail.com
Subject: Re: [PATCH/RFC] rfkill: prevent unnecessary event generation
Message-ID: <20120906224448.GA16676@khazad-dum.debian.net> (sfid-20120907_004457_578029_798E6462)
References: <5048ADFC.1010708@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5048ADFC.1010708@sonymobile.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 06 Sep 2012, Vitaly Wool wrote:
> Prevent unnecessary rfkill event generation when the state has
> not actually changed. These events have to be delivered to
> relevant userspace processes, causing these processes to wake
> up and do something while they could as well have slept. This
> obviously results in more CPU usage, longer time-to-sleep-again
> and therefore higher power consumption.

Could this supress the first event when a switch is registered? Would that
be a concern?

> diff --git a/net/rfkill/core.c b/net/rfkill/core.c
> index 752b723..520617c 100644
> --- a/net/rfkill/core.c
> +++ b/net/rfkill/core.c
> @@ -256,6 +256,7 @@ static bool __rfkill_set_hw_state(struct rfkill *rfkill,
>  static void rfkill_set_block(struct rfkill *rfkill, bool blocked)
>  {
>  	unsigned long flags;
> +	bool prev, curr;
>  	int err;
>  	if (unlikely(rfkill->dev.power.power_state.event & PM_EVENT_SLEEP))
> @@ -270,6 +271,8 @@ static void rfkill_set_block(struct rfkill *rfkill, bool blocked)
>  		rfkill->ops->query(rfkill, rfkill->data);
>  	spin_lock_irqsave(&rfkill->lock, flags);
> +	prev = rfkill->state & RFKILL_BLOCK_SW;
> +
>  	if (rfkill->state & RFKILL_BLOCK_SW)
>  		rfkill->state |= RFKILL_BLOCK_SW_PREV;
>  	else
> @@ -299,10 +302,13 @@ static void rfkill_set_block(struct rfkill *rfkill, bool blocked)
>  	}
>  	rfkill->state &= ~RFKILL_BLOCK_SW_SETCALL;
>  	rfkill->state &= ~RFKILL_BLOCK_SW_PREV;
> +	curr = rfkill->state & RFKILL_BLOCK_SW;
>  	spin_unlock_irqrestore(&rfkill->lock, flags);
>  	rfkill_led_trigger_event(rfkill);
> -	rfkill_event(rfkill);
> +
> +	if (prev != curr)
> +		rfkill_event(rfkill);
>  }
>  #ifdef CONFIG_RFKILL_INPUT

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
