Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45644 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753680AbdIDNCC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Sep 2017 09:02:02 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Ian W MORRISON <ianwmorrison@gmail.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Ian Molton <ian@mnementh.co.uk>,
        <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] brcmfmac: feature check for multi-scheduled scan fails on bcm4345 devices
References: <3cfcb175-8031-f5a8-da51-d81fa2d331c8@gmail.com>
        <7481b892-511f-4696-bf3f-82b1bec50abf@broadcom.com>
        <CAFXWsS_c6kr8LyZi0x8j5d4gU0AU9JzhSrYxit10G2B7OC9F+A@mail.gmail.com>
Date: Mon, 04 Sep 2017 16:01:58 +0300
In-Reply-To: <CAFXWsS_c6kr8LyZi0x8j5d4gU0AU9JzhSrYxit10G2B7OC9F+A@mail.gmail.com>
        (Ian W. MORRISON's message of "Sat, 2 Sep 2017 17:15:31 +1000")
Message-ID: <87vakyobw9.fsf@kamboji.qca.qualcomm.com> (sfid-20170904_150206_415609_C3AA2355)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ian W MORRISON <ianwmorrison@gmail.com> writes:

> On 2 September 2017 at 06:04, Arend van Spriel
> <arend.vanspriel@broadcom.com> wrote:
>> On 31-08-17 00:51, Ian W MORRISON wrote:
>>>
>>> The firmware feature check introduced for multi-scheduled scan is also
>>> failing for bcm4345 devices resulting in a firmware crash.
>>> The reason for this crash has not yet been root cause so this patch avoids
>>> the feature check for those device as a short-term fix.
>>
>>
>> Thanks. This is one of the few devices that I actually do not have on my
>> desk.
>>
>> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>>>
>>> Fixes: 9fe929aaace6 ("brcmfmac: add firmware feature detection for gscan
>>> feature")
>>> Signed-off-by: Ian W MORRISON <ianwmorrison@gmail.com>
>>> ---
>>> v2: Fixed tabs being replaced by spaces in patch submission
>>> Tested on MINIX NEO Z83-4 and MINIX NEO Z83-4 Pro devices.
>>> ---
>>>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c | 3 ++-
>>>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> Thanks. This patch of course is required to fix the '4.13 REGRESSION'
> for brcm4345 sdio wifi with 4.13-rc1 through 4.13-rc7 as v4.12.10 is
> the last working release. If you want me to test anything specific on
> this device let me know.

I'll queue this for 4.14. And add a stable tag so that I goes to 4.13
stable releases:

Cc: <stable@vger.kernel.org> # v4.13

-- 
Kalle Valo
