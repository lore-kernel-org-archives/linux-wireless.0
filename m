Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51982 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387699AbeHAKKT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Aug 2018 06:10:19 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>
Subject: Re: [PATCH 5/6] qtnfmac: add support for PTA configuration
References: <20180531091102.28666-1-sergey.matyukevich.os@quantenna.com>
        <20180531091102.28666-6-sergey.matyukevich.os@quantenna.com>
        <87d0v4stqm.fsf@codeaurora.org> <5B604B14.8080607@broadcom.com>
Date: Wed, 01 Aug 2018 11:25:42 +0300
In-Reply-To: <5B604B14.8080607@broadcom.com> (Arend van Spriel's message of
        "Tue, 31 Jul 2018 13:42:12 +0200")
Message-ID: <87effi8pdl.fsf@kamboji.qca.qualcomm.com> (sfid-20180801_103306_257052_4B7EA8B2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> On 7/30/2018 4:06 PM, Kalle Valo wrote:
>> Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:
>>
>>> From: Andrey Shevchenko <ashevchenko@quantenna.com>
>>>
>>> Implement support for PTA (Packet Traffic Arbitration) configuration.
>>> The PTA mechanism is used to coordinate sharing of the medium between
>>> WiFi and other 2.4 wireless networks, e.g. Bluetooth or ZigBee.
>>>
>>> This patch implements core infrastructure and vendor specific commands
>>> to control PTA functionality in firmware.
>>
>> And no description of the actual interface which would have helped with
>> the review.
>>
>> Anyway, the vendor commands are pain and they just make me grumpy. The
>> original idea was that upstream drivers should not support them at all,
>> later we flexed the rules so that low level hardware specific interfaces
>> might be ok, for example we added one in wil6210.
>>
>> If I would even consider applying a patch which adds a vendor command it
>> needs a really good commit log with a proper description of the actual
>> interface and good justifications why a generic nl80211 command won't
>> work. I don't see anything even remotely close here.
>>
>> Sorry for being grumpy, I just hate these vendor commands. Especially
>> when I see that a generic nl80211 command has not even be consired at
>> all.
>
> For what it is worth, looking at part of the patch:
>
> +/**
> + * enum qlink_pta_mode - Packet Traffic Arbiter operating modes
> + *
> + * @QLINK_PTA_MODE_DISABLED: PTA is disabled
> + * @QLINK_PTA_MODE_2_WIRE: enable PTA 2-wire mode
> + */
> +enum qlink_pta_mode {
> +	QLINK_PTA_MODE_DISABLED = 0,
> +	QLINK_PTA_MODE_2_WIRE = 2
> +};
> +
>
> it smells very much like low-level btcoex. The question is whether
> this needs to be conveyed from user-space or should these be device
> configuration, eg. like DT properties.

That's a very good point.

-- 
Kalle Valo
