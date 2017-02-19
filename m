Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:36623 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751501AbdBSMgh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 19 Feb 2017 07:36:37 -0500
Received: by mail-qk0-f195.google.com with SMTP id p22so12211626qka.3
        for <linux-wireless@vger.kernel.org>; Sun, 19 Feb 2017 04:36:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <b21a95a8-2a84-7bba-24b2-6d2ab3d255c1@dd-wrt.com>
References: <20170218063515.16071-1-ryan@mounce.com.au> <9d768854-e41d-fdb1-967d-7fdd7d692226@dd-wrt.com>
 <CAN+fvRYkbeV8yXuA+J1HVtZemB+j-07wvHkbouEpgzL-7SE6-Q@mail.gmail.com> <b21a95a8-2a84-7bba-24b2-6d2ab3d255c1@dd-wrt.com>
From: Ryan Mounce <ryan@mounce.com.au>
Date: Sun, 19 Feb 2017 23:06:21 +1030
Message-ID: <CAN+fvRbXvLcU57aTRNxeBhWP0QQmbodiUbSjarPGf1HKTisJbA@mail.gmail.com> (sfid-20170219_133715_923695_BD6D4E80)
Subject: Re: [PATCH] wireless-regdb: Update rules for Australia (AU) and add
 60GHz rules
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Cc: Seth Forshee <seth.forshee@canonical.com>,
        wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Australian regulations differ from most of Europe, the USA and even
New Zealand (which shares AS/NZS 4268) in that any unlicensed
operation between 5600-5650MHz is prohibited outright, rather than
being allowed after an extended DFS channel availability check.

The situation appears to be similar in Canada, the regdb has
previously been amended to reflect this.

https://git.kernel.org/cgit/linux/kernel/git/sforshee/wireless-regdb.git/co=
mmit/db.txt?id=3Dce7697d3def48f87427b3a3c285b46241af3b79d

On 19 February 2017 at 22:46, Sebastian Gottschall
<s.gottschall@dd-wrt.com> wrote:
> Am 19.02.2017 um 01:01 schrieb Ryan Mounce:
>>
>> Hi Sebastian,
>>
>> There is no explicit channel width restriction in the document,
>> however the only band in which the current regdb rules permit 160MHz
>> operation (5490-5710MHz) would result in an overlap with the
>> restricted weather radar band 5600-5650MHz.
>
> thats the case for all countries, so this couldnt be a argument. dfs shou=
ld
> handle this
>
>>
>> While remaining in compliance with both 802.11 and Australian law,
>> contiguous 160MHz operation in 5GHz is only permitted between
>> 5170-5330MHz which spans two bands with slightly different
>> requirements, hence AUTO-BW.
>>
>> Regards,
>> Ryan Mounce
>>
>> ryan@mounce.com.au
>>
>> On 19 February 2017 at 07:15, Sebastian Gottschall
>> <s.gottschall@dd-wrt.com> wrote:
>>>
>>> maybe i'm blind. but you reduced the channel width from 160 to 80 mhz.
>>> but i
>>> can't find any restriction in the document in a quick review
>>>
>>> Sebastian
>>>
>>>
>>> Am 18.02.2017 um 07:35 schrieb Ryan Mounce:
>>>>
>>>> Sourced from the latest legislation at
>>>> https://www.legislation.gov.au/Details/F2016C0043
>>>>
>>>> The current rules exceed legal limits between 5250-5330MHz, and permit
>>>> illegal operation in 5600-5650MHz (reserved for weather radar).
>>>>
>>>> Signed-off-by: Ryan Mounce <ryan@mounce.com.au>
>>>> ---
>>>>    db.txt | 15 ++++++++++-----
>>>>    1 file changed, 10 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/db.txt b/db.txt
>>>> index 05108e0..b951e0c 100644
>>>> --- a/db.txt
>>>> +++ b/db.txt
>>>> @@ -85,12 +85,17 @@ country AT: DFS-ETSI
>>>>          # 60 GHz band channels 1-4, ref: Etsi En 302 567
>>>>          (57000 - 66000 @ 2160), (40)
>>>>    +# Source:
>>>> +# https://www.legislation.gov.au/Details/F2016C00432
>>>> +# Both DFS-ETSI and DFS-FCC are acceptable per AS/NZS 4268 Appendix B
>>>>    country AU: DFS-ETSI
>>>> -       (2402 - 2482 @ 40), (20)
>>>> -       (5170 - 5250 @ 80), (17), AUTO-BW
>>>> -       (5250 - 5330 @ 80), (24), DFS, AUTO-BW
>>>> -       (5490 - 5710 @ 160), (24), DFS
>>>> -       (5735 - 5835 @ 80), (30)
>>>> +       (2402 - 2482 @ 40), (36)
>>>> +       (5170 - 5250 @ 80), (23), NO-OUTDOOR, AUTO-BW
>>>> +       (5250 - 5330 @ 80), (23), NO-OUTDOOR, AUTO-BW, DFS
>>>> +       (5490 - 5590 @ 80), (30), DFS
>>>> +       (5650 - 5730 @ 80), (30), DFS
>>>> +       (5735 - 5835 @ 80), (36)
>>>> +       (57000 - 66000 @ 2160), (43), NO-OUTDOOR
>>>>      country AW: DFS-ETSI
>>>>          (2402 - 2482 @ 40), (20)
>>>
>>>
>>>
>>> --
>>> Mit freundlichen Gr=C3=BCssen / Regards
>>>
>>> Sebastian Gottschall / CTO
>>>
>>> NewMedia-NET GmbH - DD-WRT
>>> Firmensitz:  Berliner Ring 101, 64625 Bensheim
>>> Registergericht: Amtsgericht Darmstadt, HRB 25473
>>> Gesch=C3=A4ftsf=C3=BChrer: Peter Steinh=C3=A4user, Christian Scheele
>>> http://www.dd-wrt.com
>>> email: s.gottschall@dd-wrt.com
>>> Tel.: +496251-582650 / Fax: +496251-5826565
>>>
>
>
> --
> Mit freundlichen Gr=C3=BCssen / Regards
>
> Sebastian Gottschall / CTO
>
> NewMedia-NET GmbH - DD-WRT
> Firmensitz:  Berliner Ring 101, 64625 Bensheim
> Registergericht: Amtsgericht Darmstadt, HRB 25473
> Gesch=C3=A4ftsf=C3=BChrer: Peter Steinh=C3=A4user, Christian Scheele
> http://www.dd-wrt.com
> email: s.gottschall@dd-wrt.com
> Tel.: +496251-582650 / Fax: +496251-5826565
>
