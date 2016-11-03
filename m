Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f196.google.com ([209.85.217.196]:34316 "EHLO
        mail-ua0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757991AbcKCSsf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Nov 2016 14:48:35 -0400
Received: by mail-ua0-f196.google.com with SMTP id b35so2256142uaa.1
        for <linux-wireless@vger.kernel.org>; Thu, 03 Nov 2016 11:48:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20161103182705.GA1153@google.com>
References: <1477559563-18328-1-git-send-email-akarwar@marvell.com>
 <1477559563-18328-2-git-send-email-akarwar@marvell.com> <20161027174422.GA509@dtor-ws>
 <b9fed0716cfb46818b0a93a925e5d37a@SC-EXCH02.marvell.com> <20161103161504.GA15366@dtor-ws>
 <20161103182705.GA1153@google.com>
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Thu, 3 Nov 2016 12:48:33 -0600
Message-ID: <CAKdAkRQb-rnEqOxG6MLkvM068Up-+jvYqxKCNXM+OvPgn3kdwA@mail.gmail.com> (sfid-20161103_194839_170411_260BB87F)
Subject: Re: [PATCH v2 2/5] mwifiex: use spinlock for 'mwifiex_processing' in shutdown_drv
To: Brian Norris <briannorris@chromium.org>
Cc: Xinming Hu <huxm@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        "rajatja@google.com" <rajatja@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 3, 2016 at 12:27 PM, Brian Norris <briannorris@chromium.org> wrote:
> On Thu, Nov 03, 2016 at 09:15:04AM -0700, Dmitry Torokhov wrote:
>> On Thu, Nov 03, 2016 at 08:34:06AM +0000, Xinming Hu wrote:
>> > > -----Original Message-----
>> > > From: linux-wireless-owner@vger.kernel.org
>> > > [mailto:linux-wireless-owner@vger.kernel.org] On Behalf Of Dmitry Torokhov
>> > >
>> > > Instead please remove call to mwifiex_shutdown_drv() in the main routine
>> > > and "if (adapter->mwifiex_processing)" check here.
>> > >
>> >
>> > mwifiex_main_process will be used from interrupt or workqueue.
>> > Now we have disabled interrupt and flush workqueue, so
>> > mwifiex_main_process won't be scheduled in the future.
>> > But mwifiex_main_process might just running in context of last
>> > interrupt, so we need wait current main_process complete in
>> > mwifiex_shutdown_drv.
>>
>> synchronize_irq() is your friend then.
>
> Hmm, that sounds right, but IIUC, the "interrupt context" is actually
> only used for SDIO, and for SDIO, the driver doesn't actually have
> access to the IRQ number. The MMC/SDIO layer has some extra abstraction
> around the IRQ. So this may be more difficult than it appears.
>
> Do we need a sdio_synchronize_irq() API?

Actually the ->disable_irq() method should be responsible for making
sure it does not complete while interrupt handler is running. As far
as I can see, for SDIO case, we end up calling sdio_card_irq_put()
which stops kernel thread and won't return while the thread is
running. For other interfaces we need to check. IIRC USB lacks
->disable_irq() altogether and this is something that shoudl be fixed
(by doing usb_kill_urb() at the minimum).

Thanks.

-- 
Dmitry
