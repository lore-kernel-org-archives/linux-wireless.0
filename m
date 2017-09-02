Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35884 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751855AbdIBHPc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Sep 2017 03:15:32 -0400
Received: by mail-pg0-f65.google.com with SMTP id 83so1384397pgb.3
        for <linux-wireless@vger.kernel.org>; Sat, 02 Sep 2017 00:15:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7481b892-511f-4696-bf3f-82b1bec50abf@broadcom.com>
References: <3cfcb175-8031-f5a8-da51-d81fa2d331c8@gmail.com> <7481b892-511f-4696-bf3f-82b1bec50abf@broadcom.com>
From: Ian W MORRISON <ianwmorrison@gmail.com>
Date: Sat, 2 Sep 2017 17:15:31 +1000
Message-ID: <CAFXWsS_c6kr8LyZi0x8j5d4gU0AU9JzhSrYxit10G2B7OC9F+A@mail.gmail.com> (sfid-20170902_091557_786152_46A2EC5B)
Subject: Re: [PATCH v2] brcmfmac: feature check for multi-scheduled scan fails
 on bcm4345 devices
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: kvalo@codeaurora.org, Ian Molton <ian@mnementh.co.uk>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 September 2017 at 06:04, Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 31-08-17 00:51, Ian W MORRISON wrote:
>>
>> The firmware feature check introduced for multi-scheduled scan is also
>> failing for bcm4345 devices resulting in a firmware crash.
>> The reason for this crash has not yet been root cause so this patch avoids
>> the feature check for those device as a short-term fix.
>
>
> Thanks. This is one of the few devices that I actually do not have on my
> desk.
>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>>
>> Fixes: 9fe929aaace6 ("brcmfmac: add firmware feature detection for gscan
>> feature")
>> Signed-off-by: Ian W MORRISON <ianwmorrison@gmail.com>
>> ---
>> v2: Fixed tabs being replaced by spaces in patch submission
>> Tested on MINIX NEO Z83-4 and MINIX NEO Z83-4 Pro devices.
>> ---
>>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)

Thanks. This patch of course is required to fix the '4.13 REGRESSION'
for brcm4345 sdio wifi with 4.13-rc1 through 4.13-rc7 as v4.12.10 is
the last working release. If you want me to test anything specific on
this device let me know.
