Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:34185 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752529AbdASMuF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jan 2017 07:50:05 -0500
Received: by mail-wm0-f45.google.com with SMTP id f73so5575875wmf.1
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jan 2017 04:50:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJ_EiSSQF_2pRaYdUBbKzbHt=1pn3NBrz8C5B7Dta9x7xqZ8oA@mail.gmail.com>
References: <20170113052937.12538-1-matt@ranostay.consulting>
 <20170113052937.12538-3-matt@ranostay.consulting> <cd669d08-0db4-57e4-478b-2b200ccef6f1@rock-chips.com>
 <CAJ_EiSQtPUwv9K7CbM5e_wnre6=qR=+hgtq-oVFub2phijvXgA@mail.gmail.com>
 <0a49ba8d-e749-8462-fa48-7d8a17cecc75@rock-chips.com> <CAJ_EiSSQF_2pRaYdUBbKzbHt=1pn3NBrz8C5B7Dta9x7xqZ8oA@mail.gmail.com>
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Thu, 19 Jan 2017 13:50:02 +0100
Message-ID: <CAPDyKFqWrzh7pr+TLwjoCWxu8g9ANrNnETeVoE0MCqo-q7YsSA@mail.gmail.com> (sfid-20170119_135020_788993_CFCEE597)
Subject: Re: [PATCH v3 2/2] mmc: pwrseq: add support for Marvell SD8787 chip
To: Matt Ranostay <matt@ranostay.consulting>
Cc: Shawn Lin <shawn.lin@rock-chips.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18 January 2017 at 08:50, Matt Ranostay <matt@ranostay.consulting> wrote:
> On Sun, Jan 15, 2017 at 6:35 PM, Shawn Lin <shawn.lin@rock-chips.com> wrote:
>> On 2017/1/16 5:41, Matt Ranostay wrote:
>>>
>>> On Thu, Jan 12, 2017 at 11:16 PM, Shawn Lin <shawn.lin@rock-chips.com>
>>> wrote:
>>>>
>>>> On 2017/1/13 13:29, Matt Ranostay wrote:
>>>>>
>>>>>
>>>>> Allow power sequencing for the Marvell SD8787 Wifi/BT chip.
>>>>> This can be abstracted to other chipsets if needed in the future.
>>>>>
>>>>> Cc: Tony Lindgren <tony@atomide.com>
>>>>> Cc: Ulf Hansson <ulf.hansson@linaro.org>
>>>>> Signed-off-by: Matt Ranostay <matt@ranostay.consulting>
>>>>> ---
>>>>>  drivers/mmc/core/Kconfig         |  10 ++++
>>>>>  drivers/mmc/core/Makefile        |   1 +
>>>>>  drivers/mmc/core/pwrseq_sd8787.c | 117
>>>>> +++++++++++++++++++++++++++++++++++++++
>>>>>  3 files changed, 128 insertions(+)
>>>>>  create mode 100644 drivers/mmc/core/pwrseq_sd8787.c
>>>>>
>>>>> diff --git a/drivers/mmc/core/Kconfig b/drivers/mmc/core/Kconfig
>>>>> index cdfa8520a4b1..fc1ecdaaa9ca 100644
>>>>> --- a/drivers/mmc/core/Kconfig
>>>>> +++ b/drivers/mmc/core/Kconfig
>>>>> @@ -12,6 +12,16 @@ config PWRSEQ_EMMC
>>>>>           This driver can also be built as a module. If so, the module
>>>>>           will be called pwrseq_emmc.
>>>>>
>>>>> +config PWRSEQ_SD8787
>>>>> +       tristate "HW reset support for SD8787 BT + Wifi module"
>>>>> +       depends on OF && (MWIFIEX || BT_MRVL_SDIO)
>>>>> +       help
>>>>> +         This selects hardware reset support for the SD8787 BT + Wifi
>>>>> +         module. By default this option is set to n.
>>>>> +
>>>>> +         This driver can also be built as a module. If so, the module
>>>>> +         will be called pwrseq_sd8787.
>>>>> +
>>>>
>>>>
>>>>
>>>> I don't like this way, as we have a chance to list lots
>>>> configure options here. wifi A,B,C,D...Z, all of them need a
>>>> new section here if needed?
>>>>
>>>> Instead, could you just extent pwrseq_simple.c and add you
>>>> .compatible = "mmc-pwrseq-sd8787", "mmc-pwrseq-simple"?
>>>
>>>
>>> You mean all the chipset pwrseqs linked into the pwrseq-simple module?
>>
>>
>> What I mean was if you just extent the pwrseq-simple a bit, you could
>> just add your chipset pwrseqs linked into the pwrseq-simple. But if you
>> need a different *pattern* of pwrseqs, you should need a new name, for
>> instance, pwrseq-sdio.c etc... But please don't use the name of
>> sd8787? So if I use a wifi named ABC but using the same pwrseq pattenr,
>> should I include your "mmc-pwrseq- sd8787" for that or I need a new
>> mmc-pwrseq-ABC.c?
>
> Ah so pwrseq-sdio.c seems reasonable and having chipsets functions
> defined in a structure. That could be abstracted out for other
> chipsets that could needed in the future.

I think get the idea and it seems reasonable. With that in mind, I
have looked at the code once more and I got some new ideas on how to
adopt pwrseq-simple for your case.

I post the comments separately.

Kind regards
Uffe
