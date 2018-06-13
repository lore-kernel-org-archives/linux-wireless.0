Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:44678 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934563AbeFMQIg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Jun 2018 12:08:36 -0400
Date: Wed, 13 Jun 2018 18:08:34 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Christian Lamparter <chunkeey@gmail.com>
Cc: linux-wireless@vger.kernel.org, tglx@linutronix.de
Subject: Re: Locking in carl9170
Message-ID: <20180613160834.e7rnjyesi4sqaofo@linutronix.de> (sfid-20180613_180842_946926_930F0A93)
References: <20180611202156.ts3ldjvmjqpsi56o@linutronix.de>
 <6375081.rDYi7Ll9gj@debian64>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <6375081.rDYi7Ll9gj@debian64>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-06-12 18:56:28 [+0200], Christian Lamparter wrote:
> Hello,
Hi,

> On Monday, June 11, 2018 10:21:56 PM CEST Sebastian Andrzej Siewior wrote:
> > I've been locking at the USB completion handler and stumbled upon this
> > driver. The code path:
> >  carl9170_usb_rx_irq_complete()
> >  -> carl9170_handle_command_response()
> >   -> carl9170_cmd_callback()
> >      spin_lock(&ar->cmd_lock);
> > 
> >   -> carl9170_update_beacon()
> >       spin_lock_bh(&ar->beacon_lock);
> > 
> >   -> carl9170_tx_process_status()
> >    -> __carl9170_tx_process_status()
> >     -> carl9170_get_queued_skb()
> >        spin_lock_bh(&queue->lock);
> > 
> >       -> carl9170_release_dev_space()
> >          spin_lock_bh(&ar->mem_lock);
> > …
> > 
> > I planned to make all locks use spin_lock_irqsave().
> > carl9170_usb_rx_irq_complete() is called by HCD's completion handler
> > which is invoked mostly in IRQ context except for EHCI/DWC2 which invoke
> > the completion callback in tasklet/BH context. Currently there is a
> > local_irq_save() before invoking the ->complete callback which I plan to
> > remove, therefore the push-down. The _irqsave() would reflect the
> > current status. 
> > The locks I mentioned use only the _bh() suffix in other places. I
> > *think* lockdep is not complaining about this on EHCI but should
> > complain on other controllers which really complete in IRQ-context.
> > Could you please check if this is the case?
> 
> Oh, something else is going on here. First, please take a closer
> look at the comment in carl9170_usb_rx_irq_complete(), just right
> before the carl9170_handle_command_response() call [0].
> 
> |	/*
> |	 * While the carl9170 firmware does not use this EP, the
> |	 * firmware loader in the EEPROM unfortunately does.
> |	 * Therefore we need to be ready to handle out-of-band
> |	 * responses and traps in case the firmware crashed and
> |	 * the loader took over again.
> |	 */
> |	carl9170_handle_command_response(ar, urb->transfer_buffer,
> |					 urb->actual_length);
> | ...
> 
> Incoming urbs/data/... on this EP are all out-of-band and will
> cause the driver to issue a usb reset and this causes the driver
> to unbind from the unresponsive/crashed/dead device.

Are you saing that carl9170_handle_command_response() is invoked but
does not do much and a call chain such as:
 carl9170_usb_rx_irq_complete()
  -> carl9170_handle_command_response()
    -> carl9170_cmd_callback()
      -> spin_lock(&ar->cmd_lock);

is not likely?

> as for the locking in carl9170:
> carl9170_handle_command_response() main callee is the 
> carl9170_rx_untie_cmds() function, which gets called from the 
> carl9170_usb_rx_work() tasklet context. Hence the locking in
> carl9170's rx path and its related functions is mostly done by
> spin_lock[_bh]. (So, it should be fine in this context).

Okay. If this called from tasklet then _bh() is fine. But as I pointed
out above, we have a IRQ-context caller of cmd_lock. And the other
locks.

> Now, the driver could be vulnerable to a malicious device
> - after all, Apple only recently tried to fix the iPhone
> USB holes (GrayKey) with iOS 12 and from what I know Sony's
> PS4 have been pwned through usb as well -. So what could help
> would be to replace the carl9170_handle_command_response() in
> carl9170_usb_rx_irq_complete() with
> 
>      carl9170_restart(ar, CARL9170_RR_INVALID_RSP);
> 
> This will cut out the middle man and be much safer against 
> such attacks. So, what do you think?

I don't get this part. If you are saying you can get rid of
carl9170_handle_command_response() in carl9170_usb_rx_irq_complete()
without breaking the driver, then yes, go for it please. Because as by
the call chains I pointed you could acquire the locks in a wrong way.

> Regards,
> Christian

Sebastian
