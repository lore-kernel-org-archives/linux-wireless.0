Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:32802 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934544AbeFLQ4b (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Jun 2018 12:56:31 -0400
Received: by mail-wm0-f68.google.com with SMTP id z6-v6so20392428wma.0
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jun 2018 09:56:31 -0700 (PDT)
From: Christian Lamparter <chunkeey@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-wireless@vger.kernel.org, tglx@linutronix.de
Subject: Re: Locking in carl9170
Date: Tue, 12 Jun 2018 18:56:28 +0200
Message-ID: <6375081.rDYi7Ll9gj@debian64> (sfid-20180612_185947_504831_85D6C380)
In-Reply-To: <20180611202156.ts3ldjvmjqpsi56o@linutronix.de>
References: <20180611202156.ts3ldjvmjqpsi56o@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On Monday, June 11, 2018 10:21:56 PM CEST Sebastian Andrzej Siewior wrote:
> I've been locking at the USB completion handler and stumbled upon this
> driver. The code path:
>  carl9170_usb_rx_irq_complete()
>  -> carl9170_handle_command_response()
>   -> carl9170_cmd_callback()
>      spin_lock(&ar->cmd_lock);
>=20
>   -> carl9170_update_beacon()
>       spin_lock_bh(&ar->beacon_lock);
>=20
>   -> carl9170_tx_process_status()
>    -> __carl9170_tx_process_status()
>     -> carl9170_get_queued_skb()
>        spin_lock_bh(&queue->lock);
>=20
>       -> carl9170_release_dev_space()
>          spin_lock_bh(&ar->mem_lock);
> =E2=80=A6
>=20
> I planned to make all locks use spin_lock_irqsave().
> carl9170_usb_rx_irq_complete() is called by HCD's completion handler
> which is invoked mostly in IRQ context except for EHCI/DWC2 which invoke
> the completion callback in tasklet/BH context. Currently there is a
> local_irq_save() before invoking the ->complete callback which I plan to
> remove, therefore the push-down. The _irqsave() would reflect the
> current status.=20
> The locks I mentioned use only the _bh() suffix in other places. I
> *think* lockdep is not complaining about this on EHCI but should
> complain on other controllers which really complete in IRQ-context.
> Could you please check if this is the case?

Oh, something else is going on here. First, please take a closer
look at the comment in carl9170_usb_rx_irq_complete(), just right
before the carl9170_handle_command_response() call [0].

|	/*
|	 * While the carl9170 firmware does not use this EP, the
|	 * firmware loader in the EEPROM unfortunately does.
|	 * Therefore we need to be ready to handle out-of-band
|	 * responses and traps in case the firmware crashed and
|	 * the loader took over again.
|	 */
|	carl9170_handle_command_response(ar, urb->transfer_buffer,
|					 urb->actual_length);
| ...

Incoming urbs/data/... on this EP are all out-of-band and will
cause the driver to issue a usb reset and this causes the driver
to unbind from the unresponsive/crashed/dead device.

as for the locking in carl9170:
carl9170_handle_command_response() main callee is the=20
carl9170_rx_untie_cmds() function, which gets called from the=20
carl9170_usb_rx_work() tasklet context. Hence the locking in
carl9170's rx path and its related functions is mostly done by
spin_lock[_bh]. (So, it should be fine in this context).

Now, the driver could be vulnerable to a malicious device
=2D after all, Apple only recently tried to fix the iPhone
USB holes (GrayKey) with iOS 12 and from what I know Sony's
PS4 have been pwned through usb as well -. So what could help
would be to replace the carl9170_handle_command_response() in
carl9170_usb_rx_irq_complete() with

     carl9170_restart(ar, CARL9170_RR_INVALID_RSP);

This will cut out the middle man and be much safer against=20
such attacks. So, what do you think?
=20
Regards,
Christian

[0] <https://elixir.bootlin.com/linux/v4.14/source/drivers/net/wireless/ath=
/carl9170/usb.c#L299>
