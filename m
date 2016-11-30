Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:35974 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754863AbcK3NLW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Nov 2016 08:11:22 -0500
Received: by mail-io0-f196.google.com with SMTP id k19so2266975iod.3
        for <linux-wireless@vger.kernel.org>; Wed, 30 Nov 2016 05:11:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJ_EiST_bpBm+spPuWH-a+47t4qVsDVFjUm=a+TtL-BWN3DHdw@mail.gmail.com>
References: <1479434109-8745-1-git-send-email-matt@ranostay.consulting>
 <CABxcv=nEih8xX4fM0eqjkqprdt1uGTEyx5tzK04GuSgsHc=Haw@mail.gmail.com> <CAJ_EiST_bpBm+spPuWH-a+47t4qVsDVFjUm=a+TtL-BWN3DHdw@mail.gmail.com>
From: Javier Martinez Canillas <javier@dowhile0.org>
Date: Wed, 30 Nov 2016 10:11:20 -0300
Message-ID: <CABxcv=nc1qjtSjzfcuGTo-zUpuWdRT6OR7MZCCWaoeq4Co3Uew@mail.gmail.com> (sfid-20161130_141152_708159_33BAEB33)
Subject: Re: [PATCH] mmc: pwrseq: add support for Marvell SD8787 chip
To: Matt Ranostay <matt@ranostay.consulting>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Matt,

On Tue, Nov 29, 2016 at 10:20 PM, Matt Ranostay
<matt@ranostay.consulting> wrote:
> On Tue, Nov 29, 2016 at 9:13 AM, Javier Martinez Canillas

[snip]

>
>
>>> +- pwndn-gpio: contains a power down GPIO specifier.
>>> +- reset-gpio: contains a reset GPIO specifier.
>>> +
>>
>> I wonder if we really need a custom power sequence provider for just
>> this SDIO WiFI chip though. AFAICT the only missing piece in
>> mmc-pwrseq-simple is the power down GPIO property, so maybe
>> mmc-pwrseq-simple could be extended instead to have an optional
>> powerdown-gpios property and instead in the Marvell SD8787 DT binding
>> can be mentioned which mmc-pwrseq-simple properties are required for
>> the device.
>>
>
> The reason we didn't do that is we need delay between the two
> assertions/desertions of GPIOs. It wouldn't seems good practice to
> hack the pwrseq-simple for this...
>

Yes, I noticed that. I wouldn't say that it would be a hack for the
pwrseq-simple since it already has a "post-power-on-delay-ms" DT
property, so AFAICT it would just be adding a "pre-power-on-delay-ms"
property for your use case.

It would also be more consistent since it would support a delay for
pre and post power callbacks. It would also make you avoid hardcoding
the 300 msec wait, in case other device has a similar need but with a
different wait time.

In summary, I think that devices having a power (or power down) and
enable GPIO, and needing to wait between the GPIO toggling are common.
So I would prefer to make pwrseq-simple usable for these instead of
adding device specific power sequence providers. But it's just my
opinion and not my call :-)

>>> +Example:
>>> +
>>> +       wifi_pwrseq: wifi_pwrseq {
>>> +               compatible = "mmc-pwrseq-sd8787";
>>> +               pwrdn-gpio = <&twl_gpio 0 GPIO_ACTIVE_LOW>;
>>> +               reset-gpio = <&twl_gpio 1 GPIO_ACTIVE_LOW>;
>>> +       }
>>> diff --git a/Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt b/Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt
>>
>> Does this patch depend on a previous posted series? I don't see this
>> file in today's linux-next...
>
> Got renamed to ->
> Documentation/devicetree/bindings/net/wireless/marvell-8xxx.txt it
> seems very recently.
>

I see, that's what I thought but I wasn't able to find the commit /
patch that did it.

>>
>>> index c421aba0a5bc..08fd65d35725 100644
>>> --- a/Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt
>>> +++ b/Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt
>>> @@ -32,6 +32,9 @@ Optional properties:
>>>                  so that the wifi chip can wakeup host platform under certain condition.
>>>                  during system resume, the irq will be disabled to make sure
>>>                  unnecessary interrupt is not received.
>>> +  - vmmc-supply: a phandle of a regulator, supplying VCC to the card
>>> +  - mmc-pwrseq:  phandle to the MMC power sequence node. See "mmc-pwrseq-*"
>>> +                for documentation of MMC power sequence bindings.
>>>
>>>  Example:
>>>
>>> @@ -44,6 +47,7 @@ so that firmware can wakeup host using this device side pin.
>>>  &mmc3 {
>>>         status = "okay";
>>>         vmmc-supply = <&wlan_en_reg>;
>>> +       mmc-pwrseq = <&wifi_pwrseq>;
>>>         bus-width = <4>;
>>>         cap-power-off-card;
>>>         keep-power-in-suspend;
>>
>> I think this change should be split in a separate patch as well.
>>

You didn't answer about this, but I guess you agree it should be in a
separate patch.

Best regards,
Javier
