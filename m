Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:33854 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932526AbbKQWeR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2015 17:34:17 -0500
Received: by ioir85 with SMTP id r85so34841122ioi.1
        for <linux-wireless@vger.kernel.org>; Tue, 17 Nov 2015 14:34:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALupW3C9GrvB24TZ9LVA46TH1oADtV5jgWXPjJDaHu_mp4iR4w@mail.gmail.com>
References: <1447738373-15804-1-git-send-email-steve.derosier@lairdtech.com>
 <1447738373-15804-2-git-send-email-steve.derosier@lairdtech.com>
 <CAGRGNgUdSrwxw7j885ghFu5ivHfWgDCUC7RODbV8iW_AcmfE5Q@mail.gmail.com> <CALupW3C9GrvB24TZ9LVA46TH1oADtV5jgWXPjJDaHu_mp4iR4w@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 18 Nov 2015 09:33:57 +1100
Message-ID: <CAGRGNgXHkLiSPeh9QjRuptmjnB=Qvz4fmaucZGUyGubXzZVCCg@mail.gmail.com> (sfid-20151117_233421_371761_CF758E5F)
Subject: Re: [PATCH 1/2] ath6kl_sdio: Add reset gpio module parameter for
 CHIP_PWD_L pin
To: Steve deRosier <derosier@gmail.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, ath6kl@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Steve deRosier <steve.derosier@lairdtech.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Steve,

On Wed, Nov 18, 2015 at 4:42 AM, Steve deRosier <derosier@gmail.com> wrote:
> Hi Julian,
>
> Thanks for looking at this.
>
> In short - I agree with your review and will do most of them. As a
> well as a few minor changes suggested by the kbuild test robot. Expect
> a new version shortly.

I'm only really reviewing for style, you might want to wait for Kalle
or someone else to do a technical review.

> On Mon, Nov 16, 2015 at 10:25 PM, Julian Calaby <julian.calaby@gmail.com> wrote:
>>>
>>>  static void __exit ath6kl_sdio_exit(void)
>>>  {
>>>         sdio_unregister_driver(&ath6kl_sdio_driver);
>>> +
>>> +#ifdef CONFIG_GPIOLIB
>>> +       /* Delay to avoid pulling the plug on the chip when an irq is pending
>>> +        * and then getting a spurious message:
>>> +        * "ath6kl: failed to get pending recv messages: -125"
>>> +        */
>>> +       msleep(300);
>>
>> Is there some actual synchronisation you can do here against the IRQ?
>> 300msec isn't a long time to wait, but it seems wrong here.
>>
>
> Considering this is only called on exit, I wasn't too worried about
> this, but then again, on reboot as well as a few types of
> reconfiguring the interface speed is an important consideration for
> our system.
>
> I'm open to suggestions.  I had looked at this and didn't see an
> obvious way to try to sync with the IRQ as it goes through several
> subsystems.

Maybe having this in ath6kl is having it in the wrong layer?

I'm guessing this is on some board that already has a DTS. Do the mmc
pwrseq drivers do what you're after?
https://www.kernel.org/doc/Documentation/devicetree/bindings/mmc/mmc-pwrseq-emmc.txt
or https://www.kernel.org/doc/Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.txt

> But looking at it again in a different light...
>
> 125 is ECANCELED.  Which is exactly right and appropriate, and
> ath6kl_htc_rxmsg_pending_handler() where the message comes from does a
> proper cleanup, or so it looks like. I wonder if maybe we can consider
> ECANCELED not an error that needs an error message as it might be a
> reasonable case?
>
> So instead of synchronization, just consider that particular status an
> expected and properly handled exception condition and not print an
> error?

Printing it as a debug instead of an error is probably a better option
here if you want to "silence" that error.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
