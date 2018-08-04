Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ed1-f65.google.com ([209.85.208.65]:45325 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729035AbeHEAWI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 4 Aug 2018 20:22:08 -0400
Received: by mail-ed1-f65.google.com with SMTP id s16-v6so3390301edq.12
        for <linux-wireless@vger.kernel.org>; Sat, 04 Aug 2018 15:19:57 -0700 (PDT)
Subject: Re: [PATCH 5/6] qtnfmac: add support for PTA configuration
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>
References: <20180531091102.28666-1-sergey.matyukevich.os@quantenna.com>
 <20180531091102.28666-6-sergey.matyukevich.os@quantenna.com>
 <87d0v4stqm.fsf@codeaurora.org> <5B604B14.8080607@broadcom.com>
 <20180801082300.sev7ag5wh4wj7fbb@bars>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B66268B.3010205@broadcom.com> (sfid-20180805_002001_069427_BB88D848)
Date: Sun, 5 Aug 2018 00:19:55 +0200
MIME-Version: 1.0
In-Reply-To: <20180801082300.sev7ag5wh4wj7fbb@bars>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/1/2018 10:23 AM, Sergey Matyukevich wrote:
>>>> Implement support for PTA (Packet Traffic Arbitration) configuration.
>>>> The PTA mechanism is used to coordinate sharing of the medium between
>>>> WiFi and other 2.4 wireless networks, e.g. Bluetooth or ZigBee.
>>>>
>>>> This patch implements core infrastructure and vendor specific commands
>>>> to control PTA functionality in firmware.
>>>
>>> And no description of the actual interface which would have helped with
>>> the review.
>>>
>>> Anyway, the vendor commands are pain and they just make me grumpy. The
>>> original idea was that upstream drivers should not support them at all,
>>> later we flexed the rules so that low level hardware specific interfaces
>>> might be ok, for example we added one in wil6210.
>>>
>>> If I would even consider applying a patch which adds a vendor command it
>>> needs a really good commit log with a proper description of the actual
>>> interface and good justifications why a generic nl80211 command won't
>>> work. I don't see anything even remotely close here.
>>>
>>> Sorry for being grumpy, I just hate these vendor commands. Especially
>>> when I see that a generic nl80211 command has not even be consired at
>>> all.
>>
>> For what it is worth, looking at part of the patch:
>>
>> +/**
>> + * enum qlink_pta_mode - Packet Traffic Arbiter operating modes
>> + *
>> + * @QLINK_PTA_MODE_DISABLED: PTA is disabled
>> + * @QLINK_PTA_MODE_2_WIRE: enable PTA 2-wire mode
>> + */
>> +enum qlink_pta_mode {
>> +       QLINK_PTA_MODE_DISABLED = 0,
>> +       QLINK_PTA_MODE_2_WIRE = 2
>> +};
>> +
>>
>> it smells very much like low-level btcoex. The question is whether this
>> needs to be conveyed from user-space or should these be device
>> configuration, eg. like DT properties.
>
> Hello Arend,
>
> Yes, this is some kind of low-level BT coexistence mechanism, when WiFi and
> BT cards coordinate access to wireless media in 2.4G using gpio lines.
> Those lines connect WiFi and BT cards directly w/o host mediation.

Right.

> As for DT properties, the qustion still remains the same: how to propagate
> those settings to WiFi card. AFAIK there is no 'standard' interface for
> this kind of things. So using vendor commands looked like the only option.

So DT properties are available to the kernel so it is just between 
device driver and wifi card. There is no involvement with user-space needed.

Regards,
Arend
