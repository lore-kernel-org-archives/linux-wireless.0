Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:41960 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388021AbeGWJ5X (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jul 2018 05:57:23 -0400
Received: by mail-io0-f196.google.com with SMTP id q9-v6so14900374ioj.8
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jul 2018 01:57:13 -0700 (PDT)
MIME-Version: 1.0
References: <1530771142-4118-1-git-send-email-sgruszka@redhat.com>
 <1530771142-4118-5-git-send-email-sgruszka@redhat.com> <20180705150519.GB17524@localhost.localdomain>
 <87va96tq1g.fsf@purkki.adurom.net>
In-Reply-To: <87va96tq1g.fsf@purkki.adurom.net>
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date: Mon, 23 Jul 2018 10:57:02 +0200
Message-ID: <CAJ0CqmV_pPrKnRvcCrn-pUNGgJ9bDoFY+H2u0eokOayX7N08oA@mail.gmail.com> (sfid-20180723_105715_613287_2414BE6D)
Subject: Re: [PATCH 04/11] mt76x0: usb files
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        Michal Schmidt <mschmidt@redhat.com>,
        linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
>
> > On Jul 05, Stanislaw Gruszka wrote:
> >> Add usb files of mt76x0 driver.
> >>
> >> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
>
> [...]
>
> >> +static int mt76x0_suspend(struct usb_interface *usb_intf, pm_message_t state)
> >> +{
> >> +    struct mt76x0_dev *dev = usb_get_intfdata(usb_intf);
> >> +
> >> +    mt76x0_cleanup(dev);
> >
> > Is it necessary to deallocate rx queue here in case of a system suspend?
>
> BTW it would really helpful to others if you could edit your quotes. It
> takes some time to find your oneliner from a 450 line message.

Ack sorry, I will be more verbose next time :).
I mean that AFAIU it is not necessary to deallocate all buffers in the rx queue
during suspend/resume (using mt76x0_cleanup routine) but we can just mark them
as 'free' and reuse them as soon as the hw is resumed. I guess the same approach
can be used for mcu rx buffer.

Regards,
Lorenzo
>
> --
> Kalle Valo
