Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38046 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388269AbeHPNvj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Aug 2018 09:51:39 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Ajay Singh <ajay.kathat@microchip.com>
Cc: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <linux-wireless@vger.kernel.org>, <ganesh.krishna@microchip.com>,
        <aditya.shankar@microchip.com>, <nicolas.ferre@microchip.com>,
        <claudiu.beznea@microchip.com>, <adham.abozaeid@microchip.com>
Subject: Re: feedback on mainlining wilc1000 staging driver
References: <20180816015243.545cd009@ajaysk-VirtualBox>
        <87sh3etwoj.fsf@purkki.adurom.net>
Date: Thu, 16 Aug 2018 13:53:50 +0300
In-Reply-To: <87sh3etwoj.fsf@purkki.adurom.net> (Kalle Valo's message of "Thu,
        16 Aug 2018 13:47:40 +0300")
Message-ID: <87o9e2twe9.fsf@purkki.adurom.net> (sfid-20180816_125358_086678_724466CC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

> Ajay Singh <ajay.kathat@microchip.com> writes:
>
>> Hi Greg,
>>
>> We all are working on submitting and reviewing patches for wilc1000 in
>> staging driver for quite some time. 
>>
>> We would like to have feedback on the next steps to bring wilc1000
>> driver closer to move into the wireless subsystem tree. 
>>
>> In summary, the following major things from TODO have been addressed in
>> staging:
>> -remove the defined feature as kernel versions
>> -remove OS wrapper functions
>> -remove custom debug and tracing functions
>> -rework comments and function headers(also coding style)
>> -remove build warnings
>> -replace all semaphores with mutexes or completions
>> -make spi and sdio components coexist in one build
>> -turn compile-time platform configuration (BEAGLE_BOARD, PANDA_BOARD,
>> PLAT_WMS8304, PLAT_RKXXXX, CUSTOMER_PLATFORM, ...) into run-time
>> options that are read from DT
>> -replace SIOCDEVPRIVATE commands with generic API functions
>> -use wext-core handling instead of private SIOCSIWPRIV implementation
>
> From wireless point of view: if I see wext mentioned anywhere in the
> driver I stop right there. cfg80211 is a hard requirement for us
> nowadays.

Clarification: Depending on the hardware design either cfg80211 or
mac80211 is a hard requirement. I haven't checked wilc1000 at all so I
don't know what design it has but if it's a "softmac" design then it has
to use mac80211, we do not want to support multiple 802.11 UMAC stacks.

-- 
Kalle Valo
