Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:37298 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757687AbcK3Ojr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Nov 2016 09:39:47 -0500
Received: by mail-wm0-f41.google.com with SMTP id t79so220996538wmt.0
        for <linux-wireless@vger.kernel.org>; Wed, 30 Nov 2016 06:39:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABxcv=nc1qjtSjzfcuGTo-zUpuWdRT6OR7MZCCWaoeq4Co3Uew@mail.gmail.com>
References: <1479434109-8745-1-git-send-email-matt@ranostay.consulting>
 <CABxcv=nEih8xX4fM0eqjkqprdt1uGTEyx5tzK04GuSgsHc=Haw@mail.gmail.com>
 <CAJ_EiST_bpBm+spPuWH-a+47t4qVsDVFjUm=a+TtL-BWN3DHdw@mail.gmail.com> <CABxcv=nc1qjtSjzfcuGTo-zUpuWdRT6OR7MZCCWaoeq4Co3Uew@mail.gmail.com>
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Wed, 30 Nov 2016 15:39:43 +0100
Message-ID: <CAPDyKFpVNeSrsAjabSOgr6p0dWPiQr4C=jUhO26dcyYOXdXFyw@mail.gmail.com> (sfid-20161130_154027_233106_6CD7C568)
Subject: Re: [PATCH] mmc: pwrseq: add support for Marvell SD8787 chip
To: Javier Martinez Canillas <javier@dowhile0.org>,
        Matt Ranostay <matt@ranostay.consulting>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30 November 2016 at 14:11, Javier Martinez Canillas
<javier@dowhile0.org> wrote:
> Hello Matt,
>
> On Tue, Nov 29, 2016 at 10:20 PM, Matt Ranostay
> <matt@ranostay.consulting> wrote:
>> On Tue, Nov 29, 2016 at 9:13 AM, Javier Martinez Canillas
>
> [snip]
>
>>
>>
>>>> +- pwndn-gpio: contains a power down GPIO specifier.
>>>> +- reset-gpio: contains a reset GPIO specifier.
>>>> +
>>>
>>> I wonder if we really need a custom power sequence provider for just
>>> this SDIO WiFI chip though. AFAICT the only missing piece in
>>> mmc-pwrseq-simple is the power down GPIO property, so maybe
>>> mmc-pwrseq-simple could be extended instead to have an optional
>>> powerdown-gpios property and instead in the Marvell SD8787 DT binding
>>> can be mentioned which mmc-pwrseq-simple properties are required for
>>> the device.
>>>
>>
>> The reason we didn't do that is we need delay between the two
>> assertions/desertions of GPIOs. It wouldn't seems good practice to
>> hack the pwrseq-simple for this...
>>
>
> Yes, I noticed that. I wouldn't say that it would be a hack for the
> pwrseq-simple since it already has a "post-power-on-delay-ms" DT
> property, so AFAICT it would just be adding a "pre-power-on-delay-ms"
> property for your use case.
>
> It would also be more consistent since it would support a delay for
> pre and post power callbacks. It would also make you avoid hardcoding
> the 300 msec wait, in case other device has a similar need but with a
> different wait time.
>
> In summary, I think that devices having a power (or power down) and
> enable GPIO, and needing to wait between the GPIO toggling are common.
> So I would prefer to make pwrseq-simple usable for these instead of
> adding device specific power sequence providers. But it's just my
> opinion and not my call :-)

This is a good idea. Please try out this approach.

[...]

Kind regards
Uffe
