Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:36401 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752566AbdIAWBq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Sep 2017 18:01:46 -0400
Received: by mail-wm0-f50.google.com with SMTP id f127so8502275wmf.1
        for <linux-wireless@vger.kernel.org>; Fri, 01 Sep 2017 15:01:45 -0700 (PDT)
Subject: Re: [PATCH] Documentation: dt-binding: net: wireless: add
 bcm43430-fmac
To: Rob Herring <robh@kernel.org>
Cc: Antony Antony <antony@phenome.org>, Chen-Yu Tsai <wens@csie.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Icenowy Zheng <icenowy@aosc.io>,
        devicetree <devicetree@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
References: <20170829214309.34466-1-antony@phenome.org>
 <CAGb2v66=JvS9wHkUNBwd+vHwx4NAQsaWyhx1OyEokSZizo+7-g@mail.gmail.com>
 <20170830120218.ms3xuhp4qsibistv@AntonyAntony.local>
 <20170901164911.aiu5ej5u546z5kow@rob-hp-laptop>
 <bb53a79e-8045-3c9b-8c98-8d4815c3b57a@broadcom.com>
 <CAL_JsqLsnXYfyix3KLkEYguWAe-Wqcb9Nd22jM8HM2dnw4Frog@mail.gmail.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <73188868-3809-b94e-d08b-56b83b981558@broadcom.com> (sfid-20170902_000148_846098_578769A9)
Date: Sat, 2 Sep 2017 00:01:43 +0200
MIME-Version: 1.0
In-Reply-To: <CAL_JsqLsnXYfyix3KLkEYguWAe-Wqcb9Nd22jM8HM2dnw4Frog@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 01-09-17 23:38, Rob Herring wrote:
> On Fri, Sep 1, 2017 at 2:10 PM, Arend van Spriel
> <arend.vanspriel@broadcom.com> wrote:
>> On 01-09-17 18:49, Rob Herring wrote:
>>>
>>> On Wed, Aug 30, 2017 at 02:02:18PM +0200, Antony Antony wrote:
>>>>
>>>> hi,
>>>>
>>>> On Wed, Aug 30, 2017 at 10:28:20AM +0800, Chen-Yu Tsai wrote:
>>>>>
>>>>> On Wed, Aug 30, 2017 at 5:43 AM, Antony Antony <antony@phenome.org>
>>>>> wrote:
>>>>
>>>>
>>>>>> a/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
>>>>>> +++
>>>>>> b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
>>>>>> @@ -6,7 +6,9 @@ connects the device to the system.
>>>>>>
>>>>>>    Required properties:
>>>>>>
>>>>>> - - compatible : Should be "brcm,bcm4329-fmac".
>>>>>> + - compatible : should be one of the following:
>>>>>> +       * "brcm,bcm4329-fmac"
>>>>>> +       * "brcm,bcm43430-fmac"
>>>>>
>>>>>
>>>>> You updated the bindings, but not the driver. So it's not actually
>>>>> going to work. More specifically, OOB interrupts won't work.
>>>>>
>>>>
>>>> understood, ignore this patch for now. Thanks Chen-Yu.
>>>>
>>>>> IIRC, The compatible string for this particular case, as it was
>>>>> originally proposed, only serves as a placeholder for the driver
>>>>> to check against. None of the instances in sunxi device trees
>>>>> match the actual chip model. Actual model matching is done
>>>>> through SDIO, as you've already seen.
>>>>
>>>>
>>>> yes it seems SDIO driveer code is smarter, once it initialize
>>>> brcm,bcm4329-fmac it ignore the DT info and read the chip details to
>>>> locate
>>>> firmware file.
>>>>
>>>> I also noticed other boards using bcm4329-fmac in similar situations.
>>>> https://patchwork.kernel.org/patch/9739181/
>>>>
>>>>
>>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/arm64/boot/dts/amlogic/meson-gxbb-nanopi-k2.dts?h=v4.13-rc7
>>>>
>>>> I will resend "NanoPi NEO Plus2" dts with "brcm,bcm4329-fmac" and see
>>>> where
>>>> it goes.
>>>
>>>
>>> Adding the compatible or instead of? The former would be better. You
>>> should still have the actual chip in case you do have some difference to
>>> handle.
>>
>>
>> Hi Rob,
>>
>> Actually the Broadcom wifi chips themselves are discoverable. So once the
>> driver has access to the register space of the device it can determine the
>> actual chip, its revision, and exactly what cores (and their revision) are
>> present in the chip. Hence there is a single compatible string as there is
>> no need to convey the same information through device tree data.
> 
> So if a chip has different power on/off sequencing you can discover that?
> 
> I realize that most often you don't need it, but a more specific
> compatible is there in case you do and so it doesn't require a DTB
> update to handle some difference. But you can keep using one
> compatible because I can't really enforce any of that.

For SDIO chips the power sequencing is defined by power-seq-* in 
bindings/mmc and handled by the MMC stack itself. So the wifi driver is 
not dealing with that.

Regards,
Arend
