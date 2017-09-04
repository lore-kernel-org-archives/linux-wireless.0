Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f182.google.com ([209.85.216.182]:35150 "EHLO
        mail-qt0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753946AbdIDRhU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Sep 2017 13:37:20 -0400
Received: by mail-qt0-f182.google.com with SMTP id k2so4290117qte.2
        for <linux-wireless@vger.kernel.org>; Mon, 04 Sep 2017 10:37:20 -0700 (PDT)
Subject: Re: [PATCH] Documentation: dt-binding: net: wireless: add
 bcm43430-fmac
To: Antony Antony <antony@phenome.org>
Cc: Rob Herring <robh@kernel.org>, Chen-Yu Tsai <wens@csie.org>,
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
 <20170901204030.2zpsoa4i53tdegs3@AntonyAntony.local>
 <8af0e096-f4b1-213f-d543-fa711e1961ad@broadcom.com>
 <20170904144230.yuadvqiruj73q5t3@AntonyAntony.local>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <7f07455d-88b6-3ab5-4cdd-dc38e019ac2a@broadcom.com> (sfid-20170904_193724_398918_E5006EFD)
Date: Mon, 4 Sep 2017 19:37:15 +0200
MIME-Version: 1.0
In-Reply-To: <20170904144230.yuadvqiruj73q5t3@AntonyAntony.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04-09-17 16:42, Antony Antony wrote:
> Hi Arend,
> 
> On Fri, Sep 01, 2017 at 11:30:59PM +0200, Arend van Spriel wrote:
>>>> Hi Rob,
>>>>
>>>> Actually the Broadcom wifi chips themselves are discoverable. So once the
>>>> driver has access to the register space of the device it can determine the
>>>> actual chip, its revision, and exactly what cores (and their revision) are
>>>> present in the chip. Hence there is a single compatible string as there is
>>>> no need to convey the same information through device tree data.
>>>
>>> In my expereince this how it seems to work.
>>>
>>> I jsut discovered s/brcm,bcm4329-fmac/brcm/ can load the broadcom driver.
>>>
>>> brcmf: wifi@1 {
>>> 	reg = <1>;
>>> 	compatible = "brcm";
>>> };
>>>
>>> This looks better to me. Maxime, Would this work?
>>
>> I have no idea what you are saying here. To what exactly do you apply that
>> substitute. In brcmfmac I have:
> 
> Thanks for pointing me to the relevent code. I was asking about DT support I
> submitted.
> 
>>
>>          if (!np || bus_type != BRCMF_BUSTYPE_SDIO ||
>>              !of_device_is_compatible(np, "brcm,bcm4329-fmac"))
>>                  return;
>>
>> In my perception using "brcm" goes against DT compatible naming convention.
> 
> It seems the driver has a special place holder, bcm4329-fmac.
> I am still wondering what is acceptable in the DT.
> 
> compatible = ""brcm,bcm4329-fmac";
> or
> compatible = "brcm";
> 
> The last one does not generate any warnings.

Ok. So what warning do you get when using "brcm,bcm4329-fmac"? Or did 
you really try ""brcm,bcm4329-fmac" as mentioned above?

Regards,
Arend
