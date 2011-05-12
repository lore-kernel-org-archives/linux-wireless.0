Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:47873 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754971Ab1ELTtH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 15:49:07 -0400
Received: by mail-ew0-f43.google.com with SMTP id 20so742916ewy.2
        for <linux-wireless@vger.kernel.org>; Thu, 12 May 2011 12:49:01 -0700 (PDT)
Subject: Re: [PATCH 4/7] wl12xx: prevent scheduling while suspending (WoW
 enabled)
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1305104068-32240-5-git-send-email-eliad@wizery.com>
References: <1305104068-32240-1-git-send-email-eliad@wizery.com>
	 <1305104068-32240-5-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 22:48:57 +0300
Message-ID: <1305229737.12586.1027.camel@cumari> (sfid-20110512_214911_703763_A3F7A170)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-05-11 at 11:54 +0300, Eliad Peller wrote:
> When WoW is enabled, the interface will stay up and the chip will
> be powered on, so we have to flush/cancel any remaining work, and
> prevent the irq handler from scheduling a new work until the system
> is resumed.
> 
> Add 2 new flags:
> * WL1271_FLAG_SUSPENDED - the system is (about to be) suspended.
> * WL1271_FLAG_PENDING_WORK - there is a pending irq work which
>    should be scheduled when the system is being resumed.
> 
> In order to wake-up the system while getting an irq, we initialize
> the device as wakeup device, and calling pm_wakeup_event() upon
> getting the interrupt (while the system is about to be suspended)
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

[...]

> diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
> index 9ca71ce..308855a 100644
> --- a/drivers/net/wireless/wl12xx/main.c
> +++ b/drivers/net/wireless/wl12xx/main.c
> @@ -1338,6 +1338,28 @@ static int wl1271_op_suspend(struct ieee80211_hw *hw,
>  	struct wl1271 *wl = hw->priv;
>  	wl1271_debug(DEBUG_MAC80211, "mac80211 suspend wow=%d", !!wow);
>  	wl->wow_enabled = !!wow;
> +	if (wl->wow_enabled) {
> +		/* flush any remaining work */
> +		wl1271_debug(DEBUG_MAC80211, "flushing remaining works");
> +		flush_delayed_work(&wl->scan_complete_work);
> +
> +		/*
> +		 * disable and re-enable interrupts in order to flush
> +		 * the threaded_irq
> +		 */
> +		wl1271_disable_interrupts(wl);
> +
> +		/*
> +		 * set suspended flag to avoid triggering a new threaded_irq
> +		 * work. no need for spinlock as interrupts are disabled.
> +		 */
> +		set_bit(WL1271_FLAG_SUSPENDED, &wl->flags);

The set_bit() function is atomic, so you wouldn't need the spinlock here
anyway.  Couldn't you use __set_bit() instead, to avoid the expense of
using an atomic function when it's not necessary?


> +
> +		wl1271_enable_interrupts(wl);
> +		flush_work(&wl->tx_work);
> +		flush_delayed_work(&wl->pspoll_work);
> +		flush_delayed_work(&wl->elp_work);
> +	}
>  	return 0;
>  }
>  
> @@ -1346,6 +1368,30 @@ static int wl1271_op_resume(struct ieee80211_hw *hw)
>  	struct wl1271 *wl = hw->priv;
>  	wl1271_debug(DEBUG_MAC80211, "mac80211 resume wow=%d",
>  		     wl->wow_enabled);
> +
> +	/*
> +	 * re-enable irq_work enqueuing, and call irq_work directly if
> +	 * there is a pending work.
> +	 */
> +	if (wl->wow_enabled) {
> +		struct wl1271 *wl = hw->priv;
> +		unsigned long flags;
> +		bool run_irq_work = false;
> +
> +		spin_lock_irqsave(&wl->wl_lock, flags);
> +		clear_bit(WL1271_FLAG_SUSPENDED, &wl->flags);
> +		if (test_and_clear_bit(WL1271_FLAG_PENDING_WORK, &wl->flags))
> +			run_irq_work = true;
> +		spin_unlock_irqrestore(&wl->wl_lock, flags);

You could use __clear_bit() and __test_and_clear_bit() here too, since
you're spinning.


> +		if (run_irq_work) {
> +			wl1271_debug(DEBUG_MAC80211,
> +				     "run postponed irq_work directly");
> +			wl1271_irq(0, wl);
> +			wl1271_enable_interrupts(wl);

Shouldn't this wl1271_enable_interrupts() be outside the if? Don't you
want to enable interrupts again when there was no pending work?


> diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
> index 5b03fd5..bf2a6ad 100644
> --- a/drivers/net/wireless/wl12xx/sdio.c
> +++ b/drivers/net/wireless/wl12xx/sdio.c
> @@ -72,6 +72,7 @@ static irqreturn_t wl1271_hardirq(int irq, void *cookie)
>  {
>  	struct wl1271 *wl = cookie;
>  	unsigned long flags;
> +	bool skip = false;
>  
>  	wl1271_debug(DEBUG_IRQ, "IRQ");
>  
> @@ -82,8 +83,20 @@ static irqreturn_t wl1271_hardirq(int irq, void *cookie)
>  		complete(wl->elp_compl);
>  		wl->elp_compl = NULL;
>  	}
> +
> +	if (test_bit(WL1271_FLAG_SUSPENDED, &wl->flags)) {
> +		/* don't enqueue a work right now. mark it as pending */
> +		set_bit(WL1271_FLAG_PENDING_WORK, &wl->flags);
> +		wl1271_debug(DEBUG_IRQ, "should not enqueue work");
> +		disable_irq_nosync(wl->irq);
> +		pm_wakeup_event(wl1271_sdio_wl_to_dev(wl), 0);
> +		skip = true;
> +	}
>  	spin_unlock_irqrestore(&wl->wl_lock, flags);
>  
> +	if (skip)
> +		return IRQ_HANDLED;
> +
>  	return IRQ_WAKE_THREAD;
>  }

Could be nicer to just skip the skip variable (unintended pun
intended ;).  You can do it like this:

if (test_bit...) {
	...
	spin_unlock_irqrestore();
	return IRQ_HANDLED;
}
spin_unlock_irqrestore();
return IRQ_WAKE_THREAD;

Looks a bit nicer to me, but I don't mind if you prefer not skipping the
skip. :)


-- 
Cheers,
Luca.

