Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qe0-f53.google.com ([209.85.128.53]:52748 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734Ab3FESIP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 14:08:15 -0400
Received: by mail-qe0-f53.google.com with SMTP id 1so1280123qee.12
        for <linux-wireless@vger.kernel.org>; Wed, 05 Jun 2013 11:08:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB-Tk73mTDsvf+MCEq5xfUBUtE4c6KfL2nkAcZe2LCY5pF=7RQ@mail.gmail.com>
References: <CAB-Tk70FmmfZOaJnWOubcOrP3MyXebTtrY936_4NROmf_76EZw@mail.gmail.com>
	<201306042143.06998.chunkeey@googlemail.com>
	<CAB-Tk73mTDsvf+MCEq5xfUBUtE4c6KfL2nkAcZe2LCY5pF=7RQ@mail.gmail.com>
Date: Wed, 5 Jun 2013 11:08:14 -0700
Message-ID: <CAJ-Vmok5yLZvstvYHi35ALWG3q8sVYLx_1PuhL31unOjxrg-4g@mail.gmail.com> (sfid-20130605_200820_150137_4BCDA22D)
Subject: Re: carl9170:5/10 MHz Channel Support on carl9170
From: Adrian Chadd <adrian@freebsd.org>
To: "C.B. Wang" <wtwangcb@gmail.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I think that the zydas mac doesn't officially support 5/10mhz operation.

I don't know how it's supposed to.

As for the alternate frequencies - it all depends what it's calibrated
for. The PHY and radio support whatever the AR5416/AR9160 do (as
they're the same PHY/radio), but it does depend if the board design
and calibration has been done with those frequencies in mind.

So by default, please, leave them off. :-)



adrian


On 5 June 2013 05:59, C.B. Wang <wtwangcb@gmail.com> wrote:
> Hi
>
> I've read the "otus" vendor driver and found that in the source file
> /HalPlus/OTUS_FB50/hpreg.h on
> line 1915,the comment says "Temporary discard channel that BW < 20MHz
> (5 or 10MHz)   */
>                             /*   Our architecture does not implemnt it"
> I think either the driver does not implement the 5/10 channels or
> worse,the ar9170 chip does
> not support 5/10 mhz channel at all.
> But 802.11j has 10mhz channel support.To comply with the 802.11j
> standard,the chip should
> support 10mhz channel width.
>
> I know ar9170 support 4.9ghz channels.But does it also support
> non-standard bands like 2.3ghz and 6.0ghz?
>
> Also the ar9170 MAC was indeed designed by ZyDaS berfore the company
> was taken over by
> Atheros.It has some problems with long distance links.
>
> On 6/5/13, Christian Lamparter <chunkeey@googlemail.com> wrote:
>> On Tuesday, June 04, 2013 03:20:26 PM C.B. Wang wrote:
>>> I want to know if the ar9170 chip support 5/10 mhz channels.
>> Maybe. if you care about it, you'll have to look for clues in
>> the original vendor driver (otus - was part of the kernel's staging/
>> directory for < 2.6.39?) and the original vendor firmware
>> (ar9170fw - you can find a git-tree @ git.sipsolutions.com).
>>
>> Anyway, if you need a definitive "yes" or "no", you should
>> ask Qualcomm Atheros directly. As I can only tell something
>> about the MAC [which does have a 802.11j Mode. It can be
>> enabled by setting bit 3 in AR9170_MAC_REG_POWER_STATE_CTRL.]
>> However, I don't have any information about the PHY/FEM/RF
>> and BB.
>>
>>> The datasheet says it supports 802.11j, but the carl9170
>>> driver does not provide support.
>> Again, talk to Qualcomm Atheros to find out what needs to be
>> done in order to support it.
>>
>>> Also the radio chip ar9104 has tuning range from 2.3-2.5ghz and
>>> 4.9-6.1ghz,but the driver does not provide any support for these
>>> super channels.
>> Some AR9170 devices do indeed support the 4.9 GHz channels
>> (out of the box). e.g.:
>>       Frequencies:
>>        * 4920 MHz [-16] (18.0 dBm)
>>        * 4940 MHz [-12] (18.0 dBm)
>>        * 4960 MHz [-8] (18.0 dBm)
>>        * 4980 MHz [-4] (18.0 dBm)
>>        * 5040 MHz [8] (18.0 dBm)
>>        * 5060 MHz [12] (18.0 dBm)
>>        * 5080 MHz [16] (18.0 dBm)
>>
>> However, the device needs to be calibrated for the frequencies
>> to use them legally (the Japanese Market). Look in your kernel
>> logs when the driver is loaded; There should be something like
>> this:
>>
>>> ath: EEPROM regdomain: 0x8xyz
>>> ath: EEPROM indicates we should expect a country code
>>> ath: doing EEPROM country->regdmn map search
>>> ath: Country alpha2 being used: JP <--- JaPan
>>
>> If your country code is not "JP", then you'll have to talk to
>> the manufacturer.
>>
>> Regards,
>>       Chr
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
